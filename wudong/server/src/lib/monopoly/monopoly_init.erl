%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 七月 2016 上午11:48
%%%-------------------------------------------------------------------
-module(monopoly_init).
-author("fengzhenlin").
-include("activity.hrl").
-include("monopoly.hrl").
-include("server.hrl").

%% API
-export([
    init/1,
    refresh_cell_list/1,
    update/1
]).

init(Player) ->
    St = monopoly_load:dbget_monopoly(Player),
    monopoly:put_dict(St),
    NewPlayer = update(Player),
    NewPlayer.

update(Player) ->
    St = monopoly:get_dict(),
    case monopoly:get_act() of
        [] -> Player;
        Base ->
            #st_monopoly{
                act_id = ActId
            } = St,
            #base_act_monopoly{
                act_id = BaseActId
            } = Base,
            Now = util:unixtime(),
            {NewPlayer, NewSt} =
                case ActId =/= BaseActId orelse (not util:is_same_date(Now, St#st_monopoly.update_time)) of
                    true ->
                        Player1 = auto_get_gift(Player, St#st_monopoly.finish_times, St#st_monopoly.gift_get_list, ActId),
                        St1 = St#st_monopoly{
                            act_id = BaseActId,
                            finish_times = 0,
                            cell_list = [],
                            cur_step = 1,
                            cur_step_state = 2,
                            step_history = [1],
                            dice_num = ?DEFAULT_DICE_NUM,
                            use_dice_num = 0,
                            buy_dice_times = 0,  %%购买骰子次数
                            update_time = Now,  %%更新时间
                            gift_get_list = [],  %%礼包领取列表
                            task_list = []
                        },
                        {Player1, St1};
                    false ->
                        {Player, St}
                end,
            monopoly:put_dict(NewSt),
            case NewSt =/= St of
                true -> monopoly_load:dbup_monopoly(NewSt);
                false -> skip
            end,
            case NewSt#st_monopoly.cell_list == [] of
                true -> %%更新事件
                    refresh_cell_list(Player);
                false ->
                    ok
            end,
            NewPlayer
    end.

refresh_cell_list(Player) ->
    St = monopoly:get_dict(),
    All = data_monopoly:get_all(),
    F = fun(Id) ->
            Base = data_monopoly:get(Id),
            lists:duplicate(Base#base_monopoly.times, Id)
        end,
    TypeList0 = lists:flatmap(F, All),

    case refresh_cell_list(TypeList0, 0) of
        [] -> skip;
        TypeList ->
            NewSt = St#st_monopoly{
                update_time = util:unixtime(),
                cell_list = TypeList,
                step_history = []
            },
            monopoly:put_dict(NewSt)
    end,
    Now = util:unixtime(),
    IsMidnight =
        case Now - util:unixdate() < 10 orelse get(gm_monopoly_momid) == true of
            true -> 1;
            false -> 0
        end,
    {ok, Bin} = pt_432:write(43257, {IsMidnight}),
    server_send:send_to_sid(Player#player.sid, Bin).

refresh_cell_list(_TypeList0, 25) ->
    [8,1,3,2,4,6,1,3,5,4,7,2,2,5,4,3,1,6,3,2,4,1]; %%随机不成功，使用默认
refresh_cell_list(TypeList0, Times) ->
    case refresh_cell_list_1(lists:seq(1, ?CELL_NUM), [], TypeList0, 0) of
        [] -> refresh_cell_list(TypeList0, Times+1);
        L -> lists:reverse(L)
    end.

refresh_cell_list_1([1|Tail], _AccCellList, TypeList0, Times) ->
    TypeList = lists:delete(8, TypeList0),
    refresh_cell_list_1(Tail, [8], TypeList, Times);
refresh_cell_list_1([], AccCellList, _TypeList0, _Times) -> AccCellList;
refresh_cell_list_1([Id|Tail], AccCellList, TypeList0, Times) ->
    case Times > 100 of
        true -> [];
        false ->
            HDType = 5,  %%黑洞类型
            HDList = [T || T<-AccCellList, T == 5],
            Type =
                case length(HDList) of
                    0 ->
                        case length(AccCellList) > 13 of
                            true -> HDType;
                            false -> util:list_rand(TypeList0)
                        end;
                    1 ->
                        HDIndex = util:get_list_elem_index(HDType, lists:reverse(AccCellList)),
                        Diff = length(AccCellList) - HDIndex,
                        case Diff >= 5 of
                            true -> HDType;
                            false ->
                                case length(TypeList0) == 1 of
                                    true -> util:list_rand(TypeList0);
                                    false ->
                                        util:list_rand(lists:delete(HDType,TypeList0))
                                end
                        end;
                    _ ->
                        util:list_rand(TypeList0)
                end,
            Res =
            case AccCellList of
                [Type,Type|_] -> false;
                _ ->
                    case TypeList0 == [6] of
                        true -> false;
                        false -> true
                    end
            end,
            case Res of
                false ->
                    refresh_cell_list_1([Id|Tail], AccCellList, TypeList0, Times+1);
                true ->
                    refresh_cell_list_1(Tail, [Type|AccCellList], lists:delete(Type,TypeList0), Times+1)
            end
    end.

auto_get_gift(Player, PassRound, GetList, ActId) ->
    case data_act_monopoly:get(ActId) of
        [] -> Player;
        Base ->
            #base_act_monopoly{
                gift_list = BaseGiftList
            } = Base,
            F = fun({Round, GiftId}) ->
                    case Round > PassRound of
                        true -> [];
                        false ->
                            case lists:member(Round, GetList) of
                                true -> [];
                                false ->
                                    [{GiftId, 1}]
                            end
                    end
                end,
            GetList1 = lists:flatmap(F, BaseGiftList),
            case GetList1 of
                [] -> skip;
                _ ->
                    Title = ?T("大富翁圈数奖励"),
                    Content = ?T("勇者，你昨天漏领的大富翁圈数奖励，奴家给你送过来啦！"),
                    mail:sys_send_mail([Player#player.key], Title, Content, GetList1)
            end
    end,
    Player.

