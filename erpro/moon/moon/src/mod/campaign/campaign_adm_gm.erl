%%----------------------------------------------------
%% 后台活动 GM控制台奖励 补后
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(campaign_adm_gm).
-export([do_all/1, do/2, do/3]).
-include("common.hrl").
-include("campaign.hrl").

%% 中央服执行 更新所有服
do_all(Args) ->
    c_mirror_group:cast(all, campaign_adm_gm, do, Args).

%% 执行相应服
do(TypeList, {Year, Month, Day}) ->
    StartT = util:datetime_to_seconds({{Year, Month, Day}, {0, 0, 1}}),
    do(TypeList, StartT);
do(TypeList, {Year, Month, Day, Hour}) ->
    StartT = util:datetime_to_seconds({{Year, Month, Day}, {Hour, 0, 1}}),
    do(TypeList, StartT);
do(TypeList, StartT) when is_integer(StartT) andalso StartT > 0 -> 
    do(TypeList, StartT, StartT + 43200).

do([Type | T], StartT, EndT) ->
    reward(Type, StartT, EndT),
    do(T, StartT, EndT);
do(Type, StartT, EndT) when is_integer(Type) ->
    reward(Type, StartT, EndT);
do(_Type, _StartT, _EndT) ->
    ok.

%% 奖励发放
reward(Type, StartT, EndT) ->
    L = campaign_adm:list_type(now, Type),
    reward(Type, L, StartT, EndT).

reward(Type, {TotalCamp, Camp, Cond = #campaign_cond{button = ?camp_button_type_mail, sec_type = Type, conds = [{rank, _Time, StartIndex, EndIndex}]}}, StartT, EndT) ->
   Sql = "select sort_val, rid, srv_id, r_name from log_rank where r_type = ~s and ct >= ~s and ct < ~s and sort_val >=~s and sort_val <= ~s",
    case db:get_all(Sql, [Type, StartT, EndT, StartIndex, EndIndex]) of
        {ok, Data} ->
            do_reward(Type, Data, TotalCamp, Camp, Cond);
        _ -> 
            ?INFO("此榜没有相关时间段快照数据[~p]", [Type]),
            ok
    end;
reward(Type, [I | T], StartT, EndT) ->
    reward(Type, I, StartT, EndT),
    reward(Type, T, StartT, EndT);
reward(_Type, _, _StartT, _EndT) ->
    ok.

do_reward(Type, [[Sort, Rid, SrvId, Name] | T], TotalCamp, Camp, Cond) ->
    campaign_adm_reward:do_send_mail(Cond, Camp, TotalCamp, {Rid, SrvId, Name}, Sort),
    ?INFO("GM发放排行榜[~p]后台活动奖励[~p, ~s, ~s, ~p]", [Type, Rid, SrvId, Name, Sort]),
    do_reward(Type, T, TotalCamp, Camp, Cond);
do_reward(_Type, _Data, _TotalCamp, _Camp, _Cond) ->
    ok.

