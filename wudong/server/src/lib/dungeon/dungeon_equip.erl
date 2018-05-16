%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         神装副本
%%% @end
%%% Created : 11. 十月 2017 9:59
%%%-------------------------------------------------------------------
-module(dungeon_equip).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("dungeon.hrl").
-include("scene.hrl").

%% API
-export([
    init/1,
    logout/0,
    midnight_refresh/1,
    timer_update/0,
    get_st/0,
    is_pass/1,
    is_all_pass/0,
    get_task_id/1,
    get_state/1
]).
-export([
    dungeon_info/1,
    check_enter/2,
    dun_equip_ret/3
]).

-define(STATE_LOCK, 0).
-define(STATE_UNLOCK, 1).
-define(STATE_TOMORROW, 2).
-define(STATE_PASS, 3).

-define(MAX_TIMES, 1).

%%初始化
init(Player) ->
    Now = util:unixtime(),
    St =
        case player_util:is_new_role(Player) of
            true ->
                #st_dun_equip{pkey = Player#player.key, time = Now};
            false ->
                case dungeon_load:load_dun_equip(Player#player.key) of
                    [] ->
                        #st_dun_equip{pkey = Player#player.key, time = Now};
                    [Times, DunList, Time] ->
                        case util:is_same_date(Now, Time) of
                            true ->
                                #st_dun_equip{pkey = Player#player.key, dun_list = util:bitstring_to_term(DunList), times = Times, time = Time};
                            false ->
                                #st_dun_equip{pkey = Player#player.key, dun_list = util:bitstring_to_term(DunList), time = Now, is_change = 1}
                        end
                end
        end,
    set_st(St),
    Player.

%%离线
logout() ->
    St = get_st(),
    if St#st_dun_equip.is_change == 1 ->
        dungeon_load:replace_dun_equip(St);
        true ->
            ok
    end.
%%零点刷新
midnight_refresh(Now) ->
    St = get_st(),
    NewSt = St#st_dun_equip{times = 0, time = Now, is_change = 1},
    set_st(NewSt).

%%定时更新
timer_update() ->
    St = get_st(),
    if St#st_dun_equip.is_change == 1 ->
        NewSt = St#st_dun_equip{is_change = 0},
        set_st(NewSt),
        dungeon_load:replace_dun_equip(St);
        true ->
            ok
    end.

set_st(St) ->
    lib_dict:put(?PROC_STATUS_DUN_EQUIP, St),
    ok.

get_st() ->
    lib_dict:get(?PROC_STATUS_DUN_EQUIP).

%%查询单个副本是否已通关
is_pass(DunId) ->
    St = get_st(),
    lists:member(DunId, St#st_dun_equip.dun_list).

%%查询是否全部通过
is_all_pass() ->
    St = get_st(),
    F = fun(DunId) ->
        lists:member(DunId, St#st_dun_equip.dun_list)
        end,
    lists:all(F, data_dungeon_equip:dun_list()).

%%副本信息
dungeon_info(Plv) ->
    OpenDay = config:get_open_days(),
    St = get_st(),
    F = fun(DunId) ->
        DunState = check_state(DunId, St#st_dun_equip.dun_list, OpenDay, St#st_dun_equip.times, Plv),
        [DunId, DunState]
        end,
    L = lists:map(F, data_dungeon_equip:dun_list()),
    ?DEBUG("info ~p~n", [L]),
    L.

%%挑战状态 0未解锁,1可挑战 2明日挑战,3已挑战
check_state(DunId, DunList, OpenDay, Times, Plv) ->
    Base = data_dungeon_equip:get(DunId),
    case lists:member(DunId, DunList) of
        true -> ?STATE_PASS;
        false ->
            Dungeon = data_dungeon:get(DunId),
            if Dungeon#dungeon.lv > Plv -> ?STATE_LOCK;
                Base#base_dun_equip.open_day > OpenDay -> ?STATE_LOCK;
                Base#base_dun_equip.pre_id == 0 ->
                    ?IF_ELSE(Times >= ?MAX_TIMES, ?STATE_TOMORROW, ?STATE_UNLOCK);
                true ->
                    case lists:member(Base#base_dun_equip.pre_id, DunList) of
                        true ->
                            ?IF_ELSE(Times >= ?MAX_TIMES, ?STATE_TOMORROW, ?STATE_UNLOCK);
                        false -> ?STATE_LOCK
                    end
            end
    end.

%%进入检查
check_enter(_Player, DunId) ->
    case dungeon_util:is_dungeon_equip(DunId) of
        false -> true;
        true ->
            OpenDay = config:get_open_days(),
            St = get_st(),
            case check_state(DunId, St#st_dun_equip.dun_list, OpenDay, St#st_dun_equip.times, _Player#player.lv) of
                ?STATE_LOCK ->
                    {false, ?T("副本未解锁,不能挑战")};
                ?STATE_UNLOCK -> true;
                ?STATE_TOMORROW ->
                    {false, ?T("明天才能继续挑战神装副本，上仙请明天再来吧")};
                ?STATE_PASS ->
                    {false, ?T("副本已通关")}
            end
    end.

%%副本通关结算
dun_equip_ret(1, Player, DunId) ->
    dungeon_util:add_dungeon_times(DunId),
    Base = data_dungeon_equip:get(DunId),
    St = get_st(),
    DunList = [DunId | lists:delete(DunId, St#st_dun_equip.dun_list)],
    NewSt = St#st_dun_equip{times = St#st_dun_equip.times + 1, dun_list = DunList, is_change = 1},
    set_st(NewSt),
    GoodsList = tuple_to_list(Base#base_dun_equip.pass_reward),
    GiveGoodsList = goods:make_give_goods_list(565, GoodsList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, Bin} = pt_127:write(12703, {1, DunId, goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [163], true),
    NewPlayer1 = skill:active_skill_effect(NewPlayer),
    NewPlayer1;
dun_equip_ret(_, Player, DunId) ->
    {ok, Bin} = pt_127:write(12703, {0, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player.

%%获取副本任务id
get_task_id(Plv) ->
    OpenDay = config:get_open_days(),
    St = get_st(),
    F = fun(DunId) ->
        case check_state(DunId, St#st_dun_equip.dun_list, OpenDay, St#st_dun_equip.times, Plv) of
            ?STATE_UNLOCK ->
                Base = data_dungeon_equip:get(DunId),
                [Base#base_dun_equip.task_id];
            _ -> []
        end
        end,
    case lists:flatmap(F, data_dungeon_equip:dun_list()) of
        [] -> [];
        Ids ->
            hd(Ids)
    end.


%%状态
get_state(Plv) ->
    OpenDay = config:get_open_days(),
    St = get_st(),
    F = fun(DunId) ->
        check_state(DunId, St#st_dun_equip.dun_list, OpenDay, St#st_dun_equip.times, Plv)
        end,
    StateList = lists:map(F, data_dungeon_equip:dun_list()),
    OpenState =
        case lists:any(fun(Val) -> Val /= ?STATE_LOCK end, StateList) of
            false -> -1;
            true ->
                case lists:any(fun(Val) -> Val /= ?STATE_PASS end, StateList) of
                    false -> -1;
                    true ->
                        case lists:any(fun(Val) -> Val == ?STATE_UNLOCK end, StateList) of
                            true -> 1;
                            false -> 0
                        end
                end
        end,
    OpenState.
