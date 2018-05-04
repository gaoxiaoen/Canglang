%%----------------------------------------------------
%% 仙境寻宝--开宝箱（开封印）数据库操作
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(casino_dao).
-export([
        add_log_open/4
        ,add_log/2
        ,select_logs/0
        ,del_log/0
        ,update/3
        ,select/2
        ,get_super_boss_casino/1
        ,save_super_boss_casino/2
        ,get_super_boss_casino_logs/0
        ,add_super_boss_casino_log/2
        ,del_super_boss_casino_log/1
    ]
).

-include("casino.hrl").
-include("common.hrl").
-include("role.hrl").
-include("item.hrl").

-define(log_out_time, 86400 * 30). %% 日志超时时间
-define(casino_global_info, {0, <<"global">>}). %% 全服数据信息

%% 插入揭开日志
add_log_open(#role{id = {Rid, SrvId}, name = Name}, {Type, N, Price}, Logs, NewRoleL) ->
    spawn( 
        fun() -> 
                update({Rid, SrvId}, Type, NewRoleL),
                Sql = "insert into log_casino_open (rid, srv_id, name, type, open_times, price, ct) values (~s,~s,~s,~s,~s,~s,~s)",
                db:execute(Sql, [Rid, SrvId, Name, Type, N, Price, util:unixtime()]),
                add_log(N, Logs)
        end
    ).

%% 插入物品揭开日志信息
add_log(_N, []) -> ok;
add_log(N, [H | T]) ->
    VStr1 = to_log_sql(N, H),
    OtherValStr = to_log_sql(N, T, <<>>),
    Sql = util:fbin("insert into log_casino(rid,srv_id,name,type,open_times,item_name,base_id,num,get_time,is_notice,bind) values ~s ~s", [VStr1, OtherValStr]),
    db:execute(Sql).
to_log_sql(_N, [], VStr) -> VStr;
to_log_sql(N, [I | T], VStr) ->
    NewVStr = util:fbin(",~s", [to_log_sql(N, I)]),
    to_log_sql(N, T, <<VStr/binary, NewVStr/binary>>).
to_log_sql(N, #casino_log{rid = Rid, srv_id = SrvId, name = Name, type = Type, base_id = BaseId, num = Num, get_time = GT, is_notice = IsNotice, bind = Bind}) ->
    ItemName = case item_data:get(BaseId) of
        {ok, #item_base{name = IName}} -> IName;
        _ -> "未知物品"
    end,
    Fields = [Rid, SrvId, Name, Type, N, ItemName, BaseId, Num, GT, IsNotice, Bind],
    db:format_sql("(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)", Fields).

%% 读取日志信息
select_logs() ->
    [{Type, select_logs(Type)} || Type <- ?casino_type_list].
select_logs(Type) ->
    Sql = "select rid,srv_id,name,type,base_id,num,get_time,bind from log_casino where type=~s and is_notice = 1 order by get_time desc limit 1, ~s",
    case db:get_all(Sql, [Type, ?casino_max_log_num]) of 
        {ok, Data} ->
            Logs = format(log, Data, []),
            lists:reverse(Logs);
        _ ->
            []
    end.

%% 删除过时日志信息
del_log() ->
    spawn(
        fun() ->
                Sql = "delete from log_casino where get_time < ~s",
                db:execute(Sql, [?log_out_time])
        end
    ).

%% 更新揭开信息表
update(global, all, List) ->
    [update(?casino_global_info, Type, L) || {Type, L} <- List];
update({Rid, SrvId}, Type, L) -> 
    Sql = "replace into sys_casino(rid, srv_id, type, info) values(~s,~s,~s,~s)",
    db:execute(Sql, [Rid, SrvId, Type, util:term_to_string(L)]).

%% 读取揭开信息表
select(global, all) ->
    [{Type, select(?casino_global_info, Type)} || Type <- ?casino_type_list];
select({Rid, SrvId}, Type) ->
    Sql = "select info from sys_casino where rid=~s and srv_id=~s and type = ~s",
    case db:get_one(Sql, [Rid, SrvId, Type]) of
        {ok, Info} ->
            case util:bitstring_to_term(Info) of
                {ok, L} -> [Open || Open <- L, is_record(Open, casino_open)];
                _ ->
                    ?ERR("[~w:~s]揭开信息数据转换失败", [Rid, SrvId]),
                    []
            end;
        _ -> []
    end.

%%--------------------------------
%% 盘龙探宝
%%--------------------------------

%% 获取寻宝日志
get_super_boss_casino(global) ->
    get_super_boss_casino(?casino_global_info);
get_super_boss_casino({Rid, SrvId}) ->
    Sql = "select info from sys_super_boss_casino where rid=~s and srv_id=~s",
    case db:get_one(Sql, [Rid, SrvId]) of
        {ok, Info} ->
            case util:bitstring_to_term(Info) of
                {ok, L} when is_list(L) -> L;
                _ ->
                    ?ERR("[~w:~s]揭开信息数据转换失败", [Rid, SrvId]),
                    []
            end;
        _ -> []
    end.

%% 保存
save_super_boss_casino(global, Info) ->
    do_save_super_boss_casino(?casino_global_info, Info);
save_super_boss_casino({Rid, SrvId}, Info) ->
    spawn(
        fun() ->
                do_save_super_boss_casino({Rid, SrvId}, Info) 
        end
    ).
do_save_super_boss_casino({Rid, SrvId}, Info) ->
    Sql = "replace into sys_super_boss_casino(rid, srv_id, info) values(~s,~s,~s)",
    db:execute(Sql, [Rid, SrvId, util:term_to_string(Info)]).

%% 读取日志信息
get_super_boss_casino_logs() ->
    Sql = "select rid,srv_id,name,base_id,num,get_time,bind from log_super_boss_casino where is_notice = 1 order by get_time desc limit 20",
    case db:get_all(Sql, []) of 
        {ok, Data} ->
            Logs = format(super_boss_log, Data, []),
            lists:reverse(Logs);
        _ ->
            []
    end.

%% 插入物品揭开日志信息
add_super_boss_casino_log(_N, []) -> ok;
add_super_boss_casino_log(N, [H | T]) ->
    spawn(
        fun() ->
                VStr1 = to_super_boss_casino_log_sql(N, H),
                OtherValStr = to_super_boss_casino_log_sql(N, T, <<>>),
                Sql = util:fbin("insert into log_super_boss_casino(rid,srv_id,name,open_times,item_name,base_id,num,get_time,is_notice,bind) values ~s ~s", [VStr1, OtherValStr]),
                db:execute(Sql)
        end
    ).
to_super_boss_casino_log_sql(_N, [], VStr) -> VStr;
to_super_boss_casino_log_sql(N, [I | T], VStr) ->
    NewVStr = util:fbin(",~s", [to_super_boss_casino_log_sql(N, I)]),
    to_super_boss_casino_log_sql(N, T, <<VStr/binary, NewVStr/binary>>).
to_super_boss_casino_log_sql(N, #super_boss_casino_log{rid = Rid, srv_id = SrvId, name = Name, base_id = BaseId, num = Num, get_time = GT, is_notice = IsNotice, bind = Bind}) ->
    ItemName = case item_data:get(BaseId) of
        {ok, #item_base{name = IName}} -> IName;
        _ -> "未知物品"
    end,
    Fields = [Rid, SrvId, Name, N, ItemName, BaseId, Num, GT, IsNotice, Bind],
    db:format_sql("(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)", Fields).

%% 删除过时日志信息
del_super_boss_casino_log(Logs) when length(Logs) < 20 -> ok;
del_super_boss_casino_log([#super_boss_casino_log{get_time = GT} | _]) ->
    OT = util:unixtime() - 86400 * 30,
    case OT < GT of
        false -> ok;
        true ->
            spawn(
                fun() ->
                        Sql = "delete from log_super_boss_casino where get_time < ~s",
                        db:execute(Sql, [OT])
                end
            )
    end;
del_super_boss_casino_log(_) -> ok. %% 容错


%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------

%% 格式化处理
format(_Mod, [], L) -> L;
format(Mod, [I | T], L) ->
    case do_format(Mod, I) of
        false ->
            format(Mod, T, L);
        R ->
            format(Mod, T, [R | L])
    end.
do_format(log, [Rid, SrvId, Name, Type, BaseId, Num, GT, Bind]) ->
    #casino_log{rid = Rid, srv_id = SrvId, name = Name, type = Type, base_id = BaseId, num = Num, get_time = GT, bind = Bind};
do_format(super_boss_log, [Rid, SrvId, Name, BaseId, Num, GT, Bind]) ->
    #super_boss_casino_log{rid = Rid, srv_id = SrvId, name = Name, base_id = BaseId, num = Num, get_time = GT, bind = Bind};
do_format(_, _) -> false.

