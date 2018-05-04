%%----------------------------------------------------
%% 控制台发开服活动奖励
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_gm_reward).
-export([do_all/1, do/3, do/4]).
-include("common.hrl").
-include("rank.hrl").

%% 中央服执行 更新所有服
do_all(Args) ->
    c_mirror_group:cast(all, rank_gm_reward, do, Args).

do(Label, Type, {Year, Month, Day}) ->
    StartT = util:datetime_to_seconds({{Year, Month, Day}, {0, 0, 1}}),
    do(Label, Type, StartT);
do(Label, Type, {Year, Month, Day, Hour}) ->
    StartT = util:datetime_to_seconds({{Year, Month, Day}, {Hour, 0, 1}}),
    do(Label, Type, StartT);
do(Label, Type, StartT) when is_integer(StartT) andalso StartT > 0 -> 
    do(Label, Type, StartT, StartT + 43200).

do(Label, [Type | T], StartT, EndT) ->
    reward(Label, Type, StartT, EndT),
    do(Label, T, StartT, EndT);
do(Label, {rank, Type}, StartT, EndT) ->
    reward(Label, Type, StartT, EndT);
do(Label, ?rank_reward_open_srv_3, StartT, EndT) ->
    reward(Label, ?rank_vie_kill, StartT, EndT);
do(Label, ?rank_reward_open_srv_5, StartT, EndT) ->
    reward(Label, ?rank_role_lev, StartT, EndT),
    reward(Label, ?rank_role_pet_power, StartT, EndT),
    reward(Label, ?rank_total_power, StartT, EndT),
    reward(Label, ?rank_role_achieve, StartT, EndT),
    reward(Label, ?rank_guild_lev, StartT, EndT);
do(_Label, _, _StartT, _EndT) -> ok.

reward(Label, Type, StartT, EndT) ->
    Sql = "select sort_val, rid, srv_id, r_name from log_rank where r_type = ~s and ct >= ~s and ct < ~s and sort_val < 11",
    case db:get_all(Sql, [Type, StartT, EndT]) of
        {ok, Data} ->
            do_reward(Label, Type, Data, 0);
        _ -> 
            ?INFO("此榜没有相关时间段快照数据[~p]", [Type]),
            ok
    end.

do_reward(Label, Type, [], N) -> 
    ?INFO("类型[~s ~p]排行榜开服奖励已发放:~p", [Label, Type, N]),
    ok;
do_reward(Label, Type, [[Sort, Rid, SrvId, Name] | T], N) ->
    case rank_reward:get_reward_base(Label, Type, Sort) of
        {ok, #rank_reward_base{items = Items, assets = Assets, subject = Subject, content = Content}} ->
            mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, Assets, Items}),
            do_reward(Label, Type, T, N + 1);
        _ ->
            do_reward(Label, Type, T, N)
    end.
