%%----------------------------------------------------
%% 排行榜 数据库查询
%% @author liuweihua(yjbgwxf@gmail.com)
%%
%%----------------------------------------------------
-module(rank_dao).
-export([
        save/0
        ,save/1
        ,load/0
        ,load_celebrity/0
        ,delete_celebrity/3
        ,delete_celebrity/1
        ,save_role_info/1
        ,load_role_info/1
    ]).

-include("common.hrl").
-include("rank.hrl").
-include("vip.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("role_ext.hrl").

%% 排行榜角色信息保存
save_role_info(#rank_role{id = {Rid, SrvId}, info = Info}) ->
    spawn(
        fun() ->
                Sql = "replace into sys_rank_ext(rid, srv_id, info) values(~s,~s,~s)",
                db:execute(Sql, [Rid, SrvId, util:term_to_string(Info)])
        end
    ).

%% 加载角色排行榜信息
load_role_info({Rid, SrvId}) ->
    Sql = "select info from sys_rank_ext where rid=~s and srv_id=~s",
    case db:get_row(Sql, [Rid, SrvId]) of
        {ok, [[Info]]} ->
            NewInfo =case util:bitstring_to_term(Info) of
                {ok, D1} when is_list(D1) -> D1;
                _ -> []
            end,
            #rank_role{id = {Rid, SrvId}, info = NewInfo};
        _ -> 
            #rank_role{id = {Rid, SrvId}}
    end.

%% 保存排行榜数据
save() -> 
    do_save(?rank_need_save).

%% 保存指定榜数据
save(#rank{type = Type, honor_roles = HonorL, roles = L, last_val = Val}) -> 
    Sql = "replace into sys_rank (rtype, val, honor_list, rank_list) values(~s, ~s, ~s, ~s)",
    db:execute(Sql, [Type, Val, util:term_to_string(HonorL), util:term_to_string(L)]);
save(Type) when is_integer(Type) ->
    Rank = rank_mgr:lookup(Type),
    save(Rank);
save(_) -> ok.

do_save([]) -> ok;
do_save([Type | T]) ->
    save(Type),
    do_save(T).

%% 读取排行榜数据
load() ->
    Sql = "select rtype, val, honor_list, rank_list from sys_rank",
    case db:get_all(Sql, []) of
        {ok, Data} ->
            case do_format(to_rank, Data) of
                ok -> 
                    load_celebrity(),
                    ok;
                _ -> 
                    false
            end;
        {error, undefined} -> 
                load_celebrity(),
                ok;
        _ ->
            false
    end.

%% 删除角色名人榜数据
delete_celebrity(Rid, SrvId, CType) ->
    spawn(
        fun() ->
                Sql = "delete from sys_rank_celebrity where rid = ~s and srv_id = ~s and ctype = ~s",
                db:execute(Sql, [Rid, SrvId, CType])
        end
    ).
delete_celebrity(CType) ->
    spawn(
        fun() ->
                Sql = "delete from sys_rank_celebrity where ctype = ~s",
                db:execute(Sql, [CType])
        end
    ).


%% 加载名人榜数据
load_celebrity() ->
    Sql = "select `ctype`,`rid`,`srv_id`,`name`,`sex`,`career`,`in_time` from sys_rank_celebrity",
    case db:get_all(Sql, []) of
        {ok, Data} when is_list(Data) andalso length(Data) > 0 ->
            case celebrity_format(Data, []) of
                List when length(List) > 0 ->
                    Rank = #rank{type = ?rank_celebrity, roles = List},
                    rank_mgr:update_ets(Rank),
                    ok;
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

%%------------------------------------------------------------------
%% 内部方法
%%------------------------------------------------------------------

%% 执行数据转换
do_format(to_rank, []) -> ok;
do_format(to_rank, [[Type, Val, D1, D2] | T]) ->
    case util:bitstring_to_term(D2) of
        {ok, List} ->
            % List1 = check_exist(List, Type, []),
            {ok, HonorL} = util:bitstring_to_term(D1),
            Rank = #rank{type = Type, honor_roles = HonorL, roles = List, last_val = Val},
            rank_mgr:update_ets(Rank),
            do_format(to_rank, T);
        _Why -> 
            ?ERR("排行榜数据转换失败:[Type:~p]", [Type]),
            case lists:member(Type, ?rank_allow_load_fail) of
                true ->
                    do_format(to_rank, T);
                false ->
                    false
            end
    end.

% check_exist([], _Type, Return) ->Return;
% check_exist([Rank_Role|T], Type, Return) ->
%     {IdKey, _SortKeys} = rank_mgr:keys(Type),
%     Id = erlang:element(IdKey, Rank_Role),
%     Res = 
%         case  Id of
%             {Rid, SrvId} ->
%                 {Rid, SrvId};
%             {Rid, SrvId, _} ->
%                 {Rid, SrvId};
%             _ -> true
%         end,
%     case Res of 
%         {Rid1, SrvId1} ->
%             case check_role_exist(Rid1, SrvId1) of 
%                 true ->
%                     check_exist(T, Type, [Rank_Role|Return]);
%                 false ->
%                     check_exist(T, Type, Return)
%             end;
%         true ->
%             check_exist(T, Type, [Rank_Role|Return])
%     end.

% check_role_exist(RoleId, SrvId) ->
%     Sql = <<"select is_delete from role where id = ~s and srv_id = ~s">>,
%     case db:get_row(Sql, [RoleId, SrvId]) of
%         {ok, [Is_delete]} ->
%             case Is_delete of 
%                 1 -> false;
%                 0 -> true
%             end;
%         {error, _Msg} ->
%            false
%     end.

%% 名人榜数据转换分组
celebrity_format([], List) -> List;
celebrity_format([[Id, Rid, SrvId, Name, Sex, Career, Date] | T], List) -> 
    Role = #rank_celebrity_role{id = {Rid, SrvId}, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex},
    case lists:keyfind(Id, #rank_global_celebrity.id, List) of
        Cel = #rank_global_celebrity{r_list = RList} ->
            NewCel = Cel#rank_global_celebrity{r_list = [Role | RList]},
            NewList = lists:keyreplace(Id, #rank_global_celebrity.id, List, NewCel),
            celebrity_format(T, NewList);
        _ ->
            NewCel = #rank_global_celebrity{id = Id, date = Date, r_list = [Role]},
            celebrity_format(T, [NewCel | List])
    end;
celebrity_format(_Info, List) ->
    ?ERR("名人榜数据有误:~w", [_Info]),
    List.

