%% --------------------------------------------------------------------
%% npc后台管理方法
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------
-module(npc_adm).

-export([
        stat/0
        ,lookup/2
        ,clear/0
        ,remove/1
    ]).

-include("common.hrl").
-include("npc.hrl").
-include("pos.hrl").

%% --------------------------------------------------------------------
%% api function
%% --------------------------------------------------------------------

%% @spec stat_npc() -> [{BaseId, Count}, ...]
%% BaseId = integer()
%% Count = integer()
%% 统计在线npc的情况
stat() ->
    R = lists:sort(fun({_, C1}, {_, C2})-> C1 > C2 end, ets:foldl(fun foldl_count/2, [], npc_online)),
    ?DEBUG("online npc: ~w", [R]),
    R.

%% @spec lookup(T, Id) -> false | #npc{} | [#npc{}]
%% T = by_id | by_base_id
%% Id = integer()
%% @doc 查询某个或某些Npc的在线信息，返回完整的NPC属性
lookup(Type, Id) ->
    npc_mgr:lookup(Type, Id).

%% @spec clear() ->
%% 清理所在地图已关闭的npc
clear() ->
    C = do_clear(ets:tab2list(npc_online), 0),
    ?INFO("共清理 ~w 个npc", [C]).

%% @spec remove(BaseId) -> ok
%% 移除某类npc
remove(BaseId) ->
    case npc_mgr:lookup(by_base_id, BaseId) of
        false ->
            ?INFO("没有找到 base_id = ~w 的npc", [BaseId]),
            ok;
        L ->
            [npc_mgr:remove(Id) || #npc{id = Id} <- L],
            case npc_data:get(BaseId) of 
                false ->
                    ?INFO("共移除 ~w 个", [length(L)]);
                {ok, #npc_base{name = Name}} ->
                    ?INFO("共移除 ~w 个 ~s", [length(L), Name])
            end,
            ok
    end.

%% --------------------------------------------------------------------
%% 内部方法
%% --------------------------------------------------------------------

%% 用于统计npc
foldl_count(#npc{base_id = BaseId}, Stat) ->
    case lists:keyfind(BaseId, 1, Stat) of
        false ->
            [{BaseId, 1} | Stat];
        {_, Count} ->
            lists:keyreplace(BaseId, 1, Stat, {BaseId, Count + 1})
    end.

%% 清除npc 
do_clear([], Count) ->
    Count;
do_clear(_Npcs = [H | T], Count) ->
    case do_clear(H) of
        true ->
            do_clear(T, Count + 1);
        false ->
            do_clear(T, Count)
    end.

do_clear(#npc{id = Id, type = Type, pid = Pid, name = _Name, pos = #pos{map_pid = Mpid}}) ->
    case is_pid(Mpid) andalso is_process_alive(Mpid) of
        false ->
            if Type =:= 1 ->
                    npc:stop(Pid);
                true ->
                    ok
            end,
            ?DEBUG("清理 ~s", [_Name]),
            ets:delete(npc_online, Id),
            true;
        true ->
            false
    end.



