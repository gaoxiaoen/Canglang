%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 二月 2016 下午7:39
%%%-------------------------------------------------------------------
-module(act_rank_goal).
-author("fengzhenlin").
-include("common.hrl").
-include("activity.hrl").
-include("server.hrl").

%%协议接口
-export([
    get_act_rank_goal_info/1,
    get_gift/2
]).

%% API
-export([
    init/1,
    get_state/1
]).

init(Player) ->
    ActRankGoalSt = activity_load:dbget_player_act_rank_goal(Player),
    lib_dict:put(?PROC_STATUS_ACT_RANK_GOAL, ActRankGoalSt),
    update(),
    Player.

update() ->
    ActRankGoalSt = lib_dict:get(?PROC_STATUS_ACT_RANK_GOAL),
    NewActRankGoalSt =
        case activity:get_work_list(data_act_rank_goal) of
            [] -> ActRankGoalSt;
            [Base|_] ->
                case ActRankGoalSt#st_act_rank_goal.act_id == Base#base_act_rank_goal.act_id of
                    true ->
                        ActRankGoalSt;
                    false ->
                        ActRankGoalSt#st_act_rank_goal{
                            act_id = Base#base_act_rank_goal.act_id,
                            get_list = []
                        }
                end
        end,
    lib_dict:put(?PROC_STATUS_ACT_RANK_GOAL, NewActRankGoalSt),
    NewActRankGoalSt.


get_act_rank_goal_info(Player) ->
    InfoList = get_act_rank_list(Player),
    {ok, Bin} = pt_430:write(43071, {InfoList}),
    server_send:send_to_sid(Player#player.sid,Bin),
    ok.

get_act_rank_list(Player) ->
    ActRankGoalSt = lib_dict:get(?PROC_STATUS_ACT_RANK_GOAL),
    #st_act_rank_goal{
        get_list = GetList
    } = ActRankGoalSt,
    Openday = config:get_open_days(),
    GetDay = max(1,Openday),
    SubL =
        case Openday > 6 of
            true -> [];
            false ->
                TypeList = act_rank:get_type_list(),
                [lists:nth(GetDay,TypeList)]
        end,
    case activity:get_work_list(data_act_rank_goal) of
        [] -> [];
        [Base|_] ->
            get_act_rank_goal_info_helper(Player,SubL,GetList,Base#base_act_rank_goal.goal_list,[])
    end.

get_act_rank_goal_info_helper(_Player,[],_GetList,_GoalList,AccList) ->
    AccList;
get_act_rank_goal_info_helper(Player,[Type|Tail],GetList,GoalList,AccList) ->
    MyGoal = get_my_goal(Player,Type),
    TypeList = get_goal_list_by_type(Type,GoalList),
    F = fun(BaseAr) ->
            #base_ar_goal{
                id = Id,
                goal = Goal,
                gift_id = GiftId
            } = BaseAr,
            GetState =
                case lists:keyfind(Id,1,GetList) of
                    false ->
                        case MyGoal >= Goal of
                            true -> 1;
                            false -> 0
                        end;
                    _Val -> 2
                end,
            [Id,Goal,GiftId,GetState]
        end,
    GiftList = lists:map(F,TypeList),
    LeaveTime = act_rank:get_leave_time(Type),
    TypeInfo = [Type,LeaveTime,MyGoal,GiftList],
    get_act_rank_goal_info_helper(Player,Tail,GetList,GoalList,[TypeInfo|AccList]).


get_goal_list_by_type(Type,GoalList) ->
    F = fun(BaseAr) ->
            case BaseAr#base_ar_goal.type == Type of
                true -> [BaseAr];
                false -> []
            end
        end,
    lists:flatmap(F,GoalList).


get_gift(Player,SubActId) ->
    case check_get_gift(Player,SubActId) of
        {false, Res} ->
            {false, Res};
        {ok, BaseAr} ->
            #base_ar_goal{
                gift_id = GiftId
            } = BaseAr,
            ActRankGoalSt = lib_dict:get(?PROC_STATUS_ACT_RANK_GOAL),
            #st_act_rank_goal{
                get_list = GetList
            } = ActRankGoalSt,
            Now = util:unixtime(),
            NewGetList = [{SubActId,Now}|GetList],
            NewActRankGoalSt = ActRankGoalSt#st_act_rank_goal{
                get_list = NewGetList
            },
            lib_dict:put(?PROC_STATUS_ACT_RANK_GOAL,NewActRankGoalSt),
            activity_load:dbup_player_act_rank_goal(NewActRankGoalSt),
            %%给物品
            GiveGoodsList = goods:make_give_goods_list(129,[{GiftId,1}]),
            {ok, NewPlayer} = goods:give_goods(Player,GiveGoodsList),
            activity_log:log_get_gift(Player#player.key,Player#player.nickname,GiftId,1,129),
            activity:get_notice(Player,[9],true),
            {ok, NewPlayer}
    end.

check_get_gift(Player,SubActId) ->
    ActList = activity:get_work_list(data_act_rank_goal),
    if
        ActList == [] -> {false, 0};
        true ->
            ActRankGoalSt = lib_dict:get(?PROC_STATUS_ACT_RANK_GOAL),
            #st_act_rank_goal{
                act_id = NowActId,
                get_list = GetList
            } = ActRankGoalSt,
            Base = hd(ActList),
            #base_act_rank_goal{
                act_id = ActId,
                goal_list = GoalList
            } = Base,
            IsGet = lists:keyfind(SubActId,1,GetList),
            if
                NowActId =/= ActId ->
                    update(),
                    {false, 0};
                IsGet =/= false ->
                    {false, 3};
                true ->
                    case lists:keyfind(SubActId,#base_ar_goal.id,GoalList) of
                        false -> {false, 0};
                        BaseAr ->
                            #base_ar_goal{
                                type = Type,
                                goal = Goal
                            } = BaseAr,
                            MyGoal = get_my_goal(Player,Type),
                            if
                                MyGoal < Goal -> {false, 2};
                                true ->
                                    {ok, BaseAr}
                            end
                    end
            end
    end.

get_my_goal(Player,Type) ->
    case Type of
        ?ACT_RANK_EQUIP_STREN -> equip_stren:get_equip_stren_sum_lv();
%%        ?ACT_RANK_PET -> pet:get_fight_pet_combatpower();
        ?ACT_RANK_BAOSHI -> equip_inlay:get_equip_inlay_stone_lv_total();
        ?ACT_RANK_MOUNT -> mount_util:get_mount_level();
        ?ACT_RANK_WING -> wing:get_wing_power();
        ?ACT_RANK_COMBATPOWER -> Player#player.cbp
    end.

get_state(Player) ->
    EffectActList = activity:get_work_list(data_act_rank_goal),
    if
        EffectActList == [] -> -1;
        true ->
            ActList = get_act_rank_list(Player),
            if
                ActList == [] -> -1;
                true ->
                    Act = lists:last(ActList),
                    StateList = lists:last(Act),
                    F = fun(L) ->
                        case lists:last(L) == 1 of
                            true -> 1;
                            false -> 0
                        end
                    end,
                    case lists:sum(lists:map(F, StateList)) > 0 of
                        true -> 1;
                        false -> 0
                    end
            end
    end.
%%  -1.

