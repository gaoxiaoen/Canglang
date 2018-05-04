%%----------------------------------------------------
%% 成就数据版本控制
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(achievement_parse).
-export([do/1]).

-include("common.hrl").
-include("achievement.hrl").

%% 成就称号转换
do({role_achievement, Ver = 0, Val, UseHonorL, AllHonorL, DList}) ->
    NewAllHonorL = [{Honor, 0} || Honor <- AllHonorL],
    do({role_achievement, Ver + 1, Val, UseHonorL, NewAllHonorL, DList});
do({role_achievement, Ver = 1, Val, UseHonorL, AllHonorL, DList}) ->
    NewAllHonorL = [{HonorId, <<>>, Time} || {HonorId, Time} <- AllHonorL],
    do({role_achievement, Ver + 1, Val, UseHonorL, NewAllHonorL, DList});
do({role_achievement, Ver = 2, Val, UseHonorL, AllHonorL, DList}) ->
    do({role_achievement, Ver + 1, Val, UseHonorL, AllHonorL, DList, []});
do({role_achievement, Ver = 3, Val, UseHonorL, AllHonorL, DList, FinishList}) ->
    do({role_achievement, Ver + 1, Val, UseHonorL, AllHonorL, DList, FinishList, 0, []});
do({role_achievement, Ver = 4, Val, UseHonorL, AllHonorL, DList, FinishList, DayReward, DayList}) ->
    do({role_achievement, Ver + 1, Val, UseHonorL, AllHonorL, DList, FinishList, DayReward, DayList, []});
do(Ach = #role_achievement{ver = ?ACHIEVEMENT_VER, d_list = DList, finish_list = FList}) ->
    NewDList = [A || A <- DList, A#achievement.status =/= ?achievement_status_rewarded],
    NewFinish = [A#achievement.id || A <- DList, A#achievement.status =:= ?achievement_status_rewarded],
    {ok, Ach#role_achievement{d_list = NewDList, finish_list = FList ++ NewFinish}};
do(_Ach) ->
    ?ERR("成就称号数据版本转换失败"),
    {false, ?L(<<"成就称号数据版本转换失败">>)}.
