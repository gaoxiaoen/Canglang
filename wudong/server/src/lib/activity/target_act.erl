%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 七月 2016 下午1:50
%%%-------------------------------------------------------------------
-module(target_act).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

-export([
    get_info/1,
    get_gift/2
]).

%% API
-export([
    init/1,
    update/1,
    logout/1,
    trigger_tar_act/3,
    get_state/1
]).

%% 1	等级
%% 2	消耗强化石
%% 3	元宝淘宝次数
%% 4	宠物光环进阶消耗
%% 5	光翼进阶消耗
%% 6	坐骑进阶消耗
%% 7	精灵进阶消耗
%% 8	升星消耗星魂
%% 9	消耗银币
%% 10	占星消耗元宝数
%% 11	史诗占星次数

init(Player) ->
    St = activity_load:dbget_target_act(Player),
    put_dict(St),
    update(Player),
    Player.

update(_Player) ->
    St = get_dict(),
    case get_act() of
        [] -> St;
        Base ->
            #st_target_act{
                act_id = ActId
            } = St,
            #base_target_act{
                act_id = BaseActId
            } = Base,
            case ActId =/= BaseActId of
                true ->
                    St#st_target_act{
                        act_id = BaseActId,
                        target_list = []
                    };
                false ->
                    St
            end
    end.

logout(_Player) ->
    St = get_dict(),
    activity_load:dbup_target_act(St),
    ok.

get_info(Player) ->
    case get_act() of
        [] -> skip;
        Base ->
            #base_target_act{
                open_info = OpenInfo
            } = Base,
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            List = get_state_list(),
            {ok, Bin} = pt_432:write(43231, {LeaveTime, List}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end.

get_state_list() ->
    Base = get_act(),
    St = get_dict(),
    #st_target_act{
        target_list = TargetList
    } = St,
    #base_target_act{
        target_list = BaseTargetList
    } = Base,
    F = fun(BaseTarAct) ->
        #base_tar_act{
            type = Type,
            list = List
        } = BaseTarAct,
        {CurVal, NextVal, GiftId, State} = get_tar_state(Type, TargetList, List),
        [Type, GiftId, NextVal, CurVal, State]
        end,
    lists:map(F, BaseTargetList).

get_tar_state(Type, TargetList, List) ->
    get_tar_state_helper(Type, TargetList, List, {0, 0, 0, 0}).
get_tar_state_helper(_Type, _TargetList, [], {CurVal, NextVal, GiftId, State}) ->
    {CurVal, NextVal, GiftId, State};
get_tar_state_helper(Type, TargetList, [{Val, GiftId} | Tail], {_CurVal, _NextVal, _GetGiftId, _State}) ->
    case lists:keyfind(Type, #tar_act.type, TargetList) of
        false -> {0, Val, GiftId, 0};
        TarAct ->
            #tar_act{
                cur_val = TarCurVal,
                get_list = GetList
            } = TarAct,
            case lists:member(Val, GetList) of
                true -> get_tar_state_helper(Type, TargetList, Tail, {TarCurVal, Val, GiftId, 2});
                false ->
                    case Val > TarCurVal of
                        true -> {TarCurVal, Val, GiftId, 0};
                        false -> {TarCurVal, Val, GiftId, 1}
                    end
            end
    end.


get_gift(Player, Type) ->
    case check_get_gift(Player, Type) of
        {false, Res} -> {false, Res};
        {ok, GiftId, Val, TarAct} ->
            St = get_dict(),
            NewTarAct = TarAct#tar_act{
                get_list = TarAct#tar_act.get_list ++ [Val]
            },
            NewSt = St#st_target_act{
                target_list = lists:keydelete(Type, #tar_act.type, St#st_target_act.target_list) ++ [NewTarAct]
            },
            put_dict(NewSt),
            activity_load:dbup_target_act(NewSt),
            GiveGoodsList = goods:make_give_goods_list(175, [{GiftId, 1}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 175),
            activity:get_notice(Player, [26], true),
            {ok, NewPlayer}
    end.
check_get_gift(_Player, Type) ->
    St = get_dict(),
    case get_act() of
        [] -> {false, 0};
        Base ->
            #base_target_act{
                target_list = BaseTargetList
            } = Base,
            #st_target_act{
                target_list = TargetList
            } = St,
            case lists:keyfind(Type, #tar_act.type, TargetList) of
                false -> {false, 2};
                TarAct ->
                    case lists:keyfind(Type, #base_tar_act.type, BaseTargetList) of
                        false -> {false, 2};
                        BaseTarAct ->
                            {_CurVal, NextVal, GiftId, State} = get_tar_state(Type, TargetList, BaseTarAct#base_tar_act.list),
                            case State == 1 of
                                true -> {ok, GiftId, NextVal, TarAct};
                                false -> {false, 2}
                            end
                    end
            end
    end.

get_act() ->
    case activity:get_work_list(data_target_act) of
        [] -> [];
        [Base | _] -> Base
    end.

get_dict() ->
    lib_dict:get(?PROC_STATUS_TARGET_ACT).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_TARGET_ACT, St).

trigger_tar_act(_Player, Type, Times) ->
    St = get_dict(),
    Base = get_act(),
    case Base == [] orelse St == [] of
        true -> skip;
        false ->
            #base_target_act{
                target_list = BaseTargetList
            } = Base,
            #st_target_act{
                target_list = TargetList
            } = St,
            case lists:keyfind(Type, #base_tar_act.type, BaseTargetList) of
                false -> skip;
                _ ->
                    NewTarAct =
                        case lists:keyfind(Type, #tar_act.type, TargetList) of
                            false ->
                                #tar_act{
                                    type = Type,
                                    cur_val = Times
                                };
                            TarAct ->
                                NewTimes =
                                    case lists:member(Type, [1]) of
                                        true -> Times;
                                        false -> TarAct#tar_act.cur_val + Times
                                    end,
                                TarAct#tar_act{
                                    cur_val = NewTimes
                                }
                        end,
                    NewTargetList = lists:keydelete(Type, #tar_act.type, TargetList) ++ [NewTarAct],
                    NewSt = St#st_target_act{
                        target_list = NewTargetList
                    },
                    put_dict(NewSt),
                    activity_load:dbup_target_act(NewSt)
            end
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            StateList = get_state_list(),
            F = fun(L) ->
                case lists:last(L) == 1 of
                    true -> 1;
                    false -> 0
                end
                end,
            Args = activity:get_base_state(Base#base_target_act.act_info),
            case lists:sum(lists:map(F, StateList)) > 0 of
                true -> {1, Args};
                false -> {0, Args}
            end
    end.