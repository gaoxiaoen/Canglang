%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2016 10:02
%%%-------------------------------------------------------------------
-module(achieve_init).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("achieve.hrl").

%% API
-export([
    init/1
    , record2list/1
    , timer_update/0
    , logout/0
    , calc_achieve_attribute/1
    , get_achieve_attribute/0
    , load/1
    , calc_achieve_score/1
]).

init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            ScoreList = calc_achieve_score([]),
            lib_dict:put(?PROC_STATUS_ACHIEVE, #st_achieve{pkey = Player#player.key, score_list = ScoreList});
        false ->
            StAchieve = load(Player#player.key),
            ScoreList = calc_achieve_score(StAchieve#st_achieve.achieve_list),
            lib_dict:put(?PROC_STATUS_ACHIEVE, StAchieve#st_achieve{score_list = ScoreList})
    end,
    Player#player{achieve_view = achieve:achieve_view_other()}.


load(Pkey) ->
    case achieve_load:select_achieve(Pkey) of
        [] ->
            #st_achieve{pkey = Pkey};
        [Lv, Score, AchieveList, Log, RecLog] ->
            NewAchieveList = list2record(util:bitstring_to_term(AchieveList)),
            #st_achieve{
                pkey = Pkey,
                lv = Lv,
                score = Score,
                achieve_list = NewAchieveList,
                log = util:bitstring_to_term(Log),
                rec_log = util:bitstring_to_term(RecLog)
            }
    end.

record2list(AchieveList) ->
    F = fun(Achieve) ->
        {Achieve#achieve.ach_id, Achieve#achieve.value, Achieve#achieve.state}
        end,
    lists:map(F, AchieveList).

list2record(AchieveList) ->
    F = fun({AchId, Value, State}) ->
        #achieve{ach_id = AchId, value = Value, state = State}
        end,
    lists:map(F, AchieveList).

%%定时更新
timer_update() ->
    StAchieve = lib_dict:get(?PROC_STATUS_ACHIEVE),
    if StAchieve#st_achieve.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_ACHIEVE, StAchieve#st_achieve{is_change = 0}),
        achieve_load:replace_achieve(StAchieve);
        true -> ok
    end.

%%离线
logout() ->
    StAchieve = lib_dict:get(?PROC_STATUS_ACHIEVE),
    if StAchieve#st_achieve.is_change == 1 ->
        achieve_load:replace_achieve(StAchieve);
        true -> ok
    end.

%%计算成就属性
calc_achieve_attribute(_AchieveList) ->
    #attribute{}.

%%获取成就属性
get_achieve_attribute() ->
    St = lib_dict:get(?PROC_STATUS_ACHIEVE),
    St#st_achieve.attribute.


calc_achieve_score(AchieveList) ->
    F = fun(Type) ->
        [Type | achieve_score(Type, AchieveList)]
        end,
    lists:map(F, data_achieve:type_list()).
achieve_score(Type, AchieveList) ->
    F = fun(AchId, [Cur, Total]) ->
        Base = data_achieve:get(AchId),
        case lists:keyfind(AchId, #achieve.ach_id, AchieveList) of
            false ->
                [Cur, Total + Base#base_achieve.score];
            Achieve ->
                if Achieve#achieve.state == ?ACH_STATE_FINISH ->
                    [Cur + Base#base_achieve.score, Total + Base#base_achieve.score];
                    true ->
                        [Cur, Total + Base#base_achieve.score]
                end
        end
        end,
    lists:foldl(F, [0, 0], data_achieve:get_type(Type)).