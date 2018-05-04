%%----------------------------------------------------
%% NPC商店数据处理 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(npc_store_dao).
-export([
        add_log_sm/3
        ,select_logs_sm/0
        ,del_logs_sm/1
        ,select_refresh_sm/0
        ,save_refresh_sm/1
        ,save_role_items_sm/1
        ,select_role_items_sm/0
        ,del_role_items_sm/0
        ,get_activity/0
        ,reset_activity/0
    ]
).

-define(log_out_time, 15724800). %% 日志超时时间 半年

-include("common.hrl").
-include("role.hrl").
-include("npc_store.hrl").
-include("item.hrl").

%%插入购买日志
add_log_sm(ReType, IsNotice, #npc_store_sm_log{rid = Rid, srv_id = SrvId, name = Name, base_id = BaseId, num = Num, price = Price, price_type = PriceType, buy_time = BuyTime}) ->
    spawn(
        fun() ->
                Sql = "insert into log_npc_store_sm(rid, srv_id, name, item_name, base_id, num, price, price_type, buy_time, is_notice, refresh_type) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)",
                ItemName = case item_data:get(BaseId) of
                    {ok, #item_base{name = IName}} -> IName;
                    _ -> "未知物品"
                end,
                db:execute(Sql, [Rid, SrvId, Name, ItemName, BaseId, Num, Price, PriceType, BuyTime, IsNotice, ReType])
        end
    ).

%% 读取最新N条记录
select_logs_sm() ->
    Sql = "select rid, srv_id, name, base_id, num, price, price_type, buy_time from log_npc_store_sm where is_notice = 1 order by buy_time desc limit 0, ~s",
    case db:get_all(Sql, [?npc_store_sm_log_num]) of
        {ok, Data} when is_list(Data) -> 
            {ok, format(log, Data, [])};
        {error, undefined} -> {ok, []};
        _Else -> 
            ?DEBUG("获取神秘商店购买日志失败"),
            {ok, []}
    end.

%% 清除日志
del_logs_sm(Logs) when length(Logs) < ?npc_store_sm_log_num -> ok;
del_logs_sm(Logs) ->
    OT = util:unixtime() - ?log_out_time,
    Ts = [T || #npc_store_sm_log{buy_time = T} <- Logs],
    MinT = lists:min(Ts), %% 确保不能删除到需显示的日志记录
    case OT < MinT of
        false -> ok;
        true ->
            spawn(
                fun() ->
                        Sql = "delete from log_npc_store_sm where buy_time < ~s",
                        db:execute(Sql, [OT]),
                        del_role_items_sm()
                end
            )
    end.

%% 读取刷新操作数据
select_refresh_sm() ->
    Sql = "select base_id, limit_time, time_num, num, refresh_num from sys_npc_store_sm_refresh",
    case db:get_all(Sql, []) of
        {ok, Data} when is_list(Data) -> {ok, format(refresh, Data, [])};
        {error, undefined} -> {ok, []};
        _Else -> {false, ?L(<<"获取神秘商店刷新数据失败">>)}
    end.

%% 保存刷新操作数据
save_refresh_sm([]) -> ok;
save_refresh_sm([#npc_store_sm_refresh{base_id = BaseId, limit_time = LimitTime, time_num = TimeNum, limit_num = LimitNum, refresh_num = RefreshNum} | T]) ->
    Sql = "replace into sys_npc_store_sm_refresh(base_id, limit_time, time_num, num, refresh_num) values(~s, ~s, ~s, ~s, ~s)",
    db:execute(Sql, [BaseId, LimitTime, TimeNum, LimitNum, RefreshNum]),
    save_refresh_sm(T).

%% 保存个人物品数据
save_role_items_sm(#npc_store_sm_role{id = {Rid, SrvId}, refresh_time = RefreshTime, refresh_type = ReType, items = Items}) ->
    spawn(
        fun() ->
                Sql = "replace into sys_npc_store_sm_role(rid, srv_id, refresh_time, refresh_type, items) values(~s,~s,~s,~s,~s)",
                db:execute(Sql, [Rid, SrvId, RefreshTime, ReType, util:term_to_string(Items)])
        end
    ).

%% 读取个人物品数据
select_role_items_sm() ->
    Sql = "select rid, srv_id, refresh_time, refresh_type, items from sys_npc_store_sm_role where refresh_time > ~s",
    case db:get_all(Sql, [util:unixtime()]) of
        {ok, Data} when is_list(Data) -> {ok, format(role_items, Data, [])};
        {error, undefined} -> {ok, []};
        _Else -> {false, ?L(<<"获取神秘商店个人刷新数据失败">>)}
    end.

%% 删除过时个人物品数据
del_role_items_sm() ->
    Sql = "delete from sys_npc_store_sm_role when refresh_time < ~s",
    db:execute(Sql, [util:unixtime()]).

%% 统计当前全服金币总数
get_activity() ->
    Sql = "select count(*), avg(lev) from role where day_activity >= ~s",
    case db:get_row(Sql, [?npc_store_live_min_activity]) of
        {ok, [Num, AvgLev]} when is_integer(AvgLev) -> 
            {Num, AvgLev};
        {ok, [Num, _]} ->
            {Num, 0};
        _ -> {0, 0}
    end.

%% 每天12点清0活跃值
reset_activity() -> 
    spawn( 
        fun() -> 
                Sql = "update role set day_activity = 0",
                db:execute(Sql, [])
        end
    ).

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------

%% 格式化处理
format(_Mod, [], L) -> L;
format(Mod, [I | T], L) ->
    case do_format(Mod, I) of
        {false, _} ->
            format(Mod, T, L);
        Sm ->
            format(Mod, T, [Sm | L])
    end.
do_format(log, [Rid, SrvId, Name, BaseId, Num, Price, PriceType, BuyTime]) ->
    #npc_store_sm_log{rid = Rid, srv_id = SrvId, name = Name, base_id = BaseId, num = Num, price = Price, price_type = PriceType, buy_time = BuyTime};
do_format(refresh, [BaseId, LimitTime, TimeNum, LimitNum, RefreshNum]) ->
    #npc_store_sm_refresh{base_id = BaseId, limit_time = LimitTime, time_num = TimeNum, limit_num = LimitNum, refresh_num = RefreshNum};
do_format(role_items, [Rid, SrvId, RefreshTime, ReType, Data]) ->
    case util:bitstring_to_term(Data) of
        {error, Why}  ->
            ?ERR("[~w:~s]个人神秘商店数据无法正确转换成term(): ~p", [Rid, SrvId, Why]),
            {false, ?L(<<"个人神秘商店数据已损坏">>)};
        {ok, Items} ->
            #npc_store_sm_role{id = {Rid, SrvId}, refresh_time = RefreshTime, refresh_type = ReType, items = Items}
    end.

