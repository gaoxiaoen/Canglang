%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     %%玩家头部
%%% @end
%%% Created : 17. 一月 2017 10:53
%%%-------------------------------------------------------------------
-module(head).
-author("hxming").


-include("common.hrl").
-include("server.hrl").
-include("head.hrl").

%% API
-export([
    head_list/1
    , use_head/2
    , put_off_head/2
    , activate_head/2
    , upgrade_head/2
    , check_activate_by_goods/2
    , activate_by_goods/2
    , is_activate/1
    , is_activate2/1
    , get_notice_player/1
    , activation_stage_lv/2
]).
-export([
    use_head_sys/2,
    put_off_head_sys/2
]).

%% 头饰列表
head_list(_Player) ->
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    Now = util:unixtime(),
    F = fun(Head) ->
        if Head#head.time == 0 ->
            AttrList = attribute_util:pack_attr(Head#head.attribute),
            ActivationListInfo0 = get_activation_list_info(Head#head.activation_list, Head#head.head_id, 1, Head#head.stage, []),
            ActivationListInfo = [tuple_to_list(X) || X <- ActivationListInfo0],
            [[Head#head.head_id, 0, Head#head.stage, Head#head.is_use, Head#head.cbp, AttrList, ActivationListInfo]];
            Head#head.time < Now -> [];
            true ->
                AttrList = attribute_util:pack_attr(Head#head.attribute),
                [[Head#head.head_id, Head#head.time - Now, Head#head.stage, Head#head.is_use, Head#head.cbp, AttrList, []]]
        end
    end,
    HeadList = lists:flatmap(F, StHead#st_head.head_list),
    AllAttrList = attribute_util:pack_attr(StHead#st_head.attribute),
    {StHead#st_head.cbp, AllAttrList, HeadList}.

get_activation_list_info(ActivationList, HeadId, Stage, NowStage, List) ->
    case data_head_upgrade:get(HeadId, Stage) of
        [] -> List;
        #base_head_upgrade{lv_attr = LvAttr} ->
            if
                LvAttr == [] ->
                    get_activation_list_info(ActivationList, HeadId, Stage + 1, NowStage, List);
                true ->
                    case lists:member(Stage, ActivationList) of
                        false ->
                            ActState = ?IF_ELSE(NowStage >= Stage, 2, 0),
                            get_activation_list_info(ActivationList, HeadId, Stage + 1, NowStage, [{Stage, ActState, attribute_util:pack_attr(LvAttr)} | List]);
                        _ ->
                            get_activation_list_info(ActivationList, HeadId, Stage + 1, NowStage, [{Stage, 1, attribute_util:pack_attr(LvAttr)} | List])
                    end
            end
    end.

%%使用 头饰
use_head(Player, HeadId) ->
    if Player#player.fashion#fashion_figure.fashion_head_id == HeadId -> {2, Player};
        true ->
            StHead = lib_dict:get(?PROC_STATUS_HEAD),
            case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
                false -> {3, Player};
                {value, Head, T} ->
                    Now = util:unixtime(),
                    if Head#head.time > 0 andalso Head#head.time < Now -> {4, Player};
                        true ->
                            HeadList = [Head#head{is_use = 1}] ++ [F#head{is_use = 0} || F <- T],
                            NewStHead = StHead#st_head{head_list = HeadList, head_id = HeadId, is_change = 1},
                            lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
                            NewPlayer = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_head_id = HeadId}},
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer}
                    end
            end
    end.

use_head_sys(Player, HeadId) ->
    if Player#player.fashion#fashion_figure.fashion_head_id == HeadId -> Player;
        true ->
            StHead = lib_dict:get(?PROC_STATUS_HEAD),
            case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
                false -> Player;
                {value, Head, T} ->
                    Now = util:unixtime(),
                    if Head#head.time > 0 andalso Head#head.time < Now -> Player;
                        true ->
                            HeadList = [Head#head{is_use = 1}] ++ [F#head{is_use = 0} || F <- T],
                            NewStHead = StHead#st_head{head_list = HeadList, head_id = HeadId, is_change = 1},
                            lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
                            NewPlayer = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_head_id = HeadId}},
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            NewPlayer
                    end
            end
    end.

put_off_head(Player, HeadId) ->
    if Player#player.fashion#fashion_figure.fashion_head_id =/= HeadId -> {11, Player};
        true ->
            StHead = lib_dict:get(?PROC_STATUS_HEAD),
            case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
                false -> {3, Player};
                {value, Head, T} ->
                    HeadList = [Head#head{is_use = 0} | T],
                    NewStHead = StHead#st_head{head_list = HeadList, head_id = 0, is_change = 1},
                    lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
                    NewPlayer = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_head_id = 0}},
                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                    {1, NewPlayer}
            end
    end.


put_off_head_sys(Player, HeadId) ->
    if Player#player.fashion#fashion_figure.fashion_head_id =/= HeadId -> Player;
        true ->
            StHead = lib_dict:get(?PROC_STATUS_HEAD),
            case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
                false -> Player;
                {value, Head, T} ->
                    HeadList = [Head#head{is_use = 0} | T],
                    NewStHead = StHead#st_head{head_list = HeadList, head_id = 0, is_change = 1},
                    lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
                    NewPlayer = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_head_id = 0}},
                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                    NewPlayer
            end
    end.

%%激活 头饰
activate_head(Player, HeadId) ->
    case data_head:get(HeadId) of
        [] -> {5, Player};
        Base ->
            StHead = lib_dict:get(?PROC_STATUS_HEAD),
            Now = util:unixtime(),
            GoodsCount = goods_util:get_goods_count(Base#base_head.goods_id),
            if
                Base#base_head.goods_id == 0 -> {12, Player};
                Base#base_head.goods_num > GoodsCount -> {7, Player};
                true ->
                    case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
                        false ->
                            NewPlayer = activate(HeadId, Base, Now, Player, StHead),
                            goods:subtract_good(Player, [{Base#base_head.goods_id, Base#base_head.goods_num}], 233),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer};
                        {value, HeadOld, T} ->
                            if HeadOld#head.time == 0 orelse HeadOld#head.time > Now -> {6, Player};
                                true ->
                                    NewPlayer = activate(HeadId, Base, Now, Player, StHead#st_head{head_list = T}),
                                    goods:subtract_good(Player, [{Base#base_head.goods_id, Base#base_head.goods_num}], 233),
                                    player:apply_state(async, self(), {activity, sys_notice, [94]}),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

activate(HeadId, Base, Now, Player, StHead) ->
    Time = ?IF_ELSE(Base#base_head.time_bar == 0, 0, Base#base_head.time_bar + Now),
    Head = #head{head_id = HeadId, time = Time, stage = 1, is_use = 1, is_enable = true},
    NewHead = head_init:calc_single_attribute(Head),
    HeadList = [NewHead] ++ [Fa#head{is_use = 0} || Fa <- StHead#st_head.head_list],
    StHead1 = StHead#st_head{head_list = HeadList, head_id = HeadId},
    head_load:replace_head(StHead1),
    NewStHead = head_init:calc_attribute(StHead1),
    lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
    msg_activate(Player, HeadId),
    Player1 = Player#player{fashion = Player#player.fashion#fashion_figure{fashion_head_id = HeadId}},
    NewPlayer = player_util:count_player_attribute(Player1, true),
    head_load:log_head(Player#player.key, Player#player.nickname, 1, HeadId, 1),
    fashion_suit:active_icon_push(NewPlayer),
    NewPlayer.


%%检查成品激活
check_activate_by_goods(_Player, Args) ->
    HeadId = ?IF_ELSE(is_list(Args), hd(Args), Args),
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    case data_head:get(HeadId) of
        [] -> {false, 6};
        _ ->
            case lists:keyfind(HeadId, #head.head_id, StHead#st_head.head_list) of
                false -> true;
                Head ->
                    Now = util:unixtime(),
                    if Head#head.time == 0 -> {false, 32};
                        Head#head.time > Now -> {false, 32};
                        true ->
                            true
                    end
            end
    end.

%%成品激活
activate_by_goods(Player, Args) ->
    [HeadId, TimeBar] =
        case is_list(Args) of
            true -> Args;
            false ->
                [Args, 0]
        end,
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    Now = util:unixtime(),
    case data_head:get(HeadId) of
        [] -> Player;
        Base ->
            NewTimeBar = ?IF_ELSE(TimeBar > 0, TimeBar, Base#base_head.time_bar),
            case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
                false ->
                    NewPlayer = activate(HeadId, Base#base_head{time_bar = NewTimeBar}, Now, Player, StHead),
                    scene_agent_dispatch:fashion_update(NewPlayer),
                    NewPlayer;
                {value, Head, T} ->
                    if Head#head.time == 0 -> Player;
                        true ->
                            NewPlayer = activate(HeadId, Base#base_head{time_bar = NewTimeBar}, Now, Player, StHead#st_head{head_list = T}),
                            scene_agent_dispatch:fashion_update(NewPlayer),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            NewPlayer
                    end
            end
    end.

%%是否激活
is_activate(HeadId) ->
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    case lists:keyfind(HeadId, #head.head_id, StHead#st_head.head_list) of
        false -> false;
        Head ->
            if Head#head.time == 0 -> true;
                true ->
                    false
            end
    end.


%%是否激活
is_activate2(HeadId) ->
    NowTime = util:unixtime(),
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    case lists:keyfind(HeadId, #head.head_id, StHead#st_head.head_list) of
        false -> {false, 0};
        Head ->
            if Head#head.time == 0 -> {true, Head#head.stage};
                Head#head.time > NowTime -> {true, Head#head.stage};
                true ->
                    {false, 0}
            end
    end.

%%升级
upgrade_head(Player, HeadId) ->
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
        false -> {3, Player};
        {value, Head, T} ->
            case data_head_upgrade:get(HeadId, Head#head.stage + 1) of
                [] -> {8, Player};
                _ ->
                    Base = data_head_upgrade:get(HeadId, Head#head.stage),
                    GoodsCount = goods_util:get_goods_count(Base#base_head_upgrade.goods_id),
                    if GoodsCount < Base#base_head_upgrade.goods_num -> {9, Player};
                        Head#head.is_enable == false -> {2, Player};
                        Head#head.time > 0 -> {10, Player};
                        true ->
                            Head1 = Head#head{stage = Head#head.stage + 1},
                            NewHead = head_init:calc_single_attribute(Head1),
                            StHead1 = StHead#st_head{head_list = [NewHead | T], is_change = 1},
                            NewStHead = head_init:calc_attribute(StHead1),
                            lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            goods:subtract_good(Player, [{Base#base_head_upgrade.goods_id, Base#base_head_upgrade.goods_num}], 234),
                            head_load:log_head(Player#player.key, Player#player.nickname, 2, HeadId, Head1#head.stage),
                            player:apply_state(async, self(), {activity, sys_notice, [94]}),
                            {1, NewPlayer}
                    end
            end
    end.

get_notice_player(_Player) ->
    Ids = data_head:id_list(),
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    Now = util:unixtime(),
    F = fun(HeadId) ->
        Base = data_head:get(HeadId),
        GoodsCount = goods_util:get_goods_count(Base#base_head.goods_id),
        if
            Base#base_head.goods_num == 0 -> [];
            Base#base_head.goods_num > GoodsCount -> [];
            true ->
                case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
                    false -> [];
                    {value, HeadOld, _T} ->
                        if
                            HeadOld#head.time == 0 orelse HeadOld#head.time > Now -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List = lists:flatmap(F, Ids),
    F2 = fun(HeadId) ->
        case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
            false -> [];
            {value, Head, _T} ->
                case data_head_upgrade:get(HeadId, Head#head.stage + 1) of
                    [] -> [];
                    _ ->
                        Base = data_head_upgrade:get(HeadId, Head#head.stage),
                        GoodsCount = goods_util:get_goods_count(Base#base_head_upgrade.goods_id),
                        if GoodsCount < Base#base_head_upgrade.goods_num -> [];
                            Head#head.is_enable == false -> [];
                            Head#head.time > 0 -> [];
                            true -> [1]
                        end
                end
        end
    end,
    List2 = lists:flatmap(F2, Ids),
    ?IF_ELSE(List ++ List2 == [], 0, 1).

%%激活通知
msg_activate(Player, HeadId) ->
    {ok, Bin} = pt_333:write(33305, {HeadId}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


activation_stage_lv(Player, HeadId) ->
    StHead = lib_dict:get(?PROC_STATUS_HEAD),
    case lists:keytake(HeadId, #head.head_id, StHead#st_head.head_list) of
        false -> {3, Player};
        {value, Head, T} ->
            StageList = get_stage_list(HeadId, Head#head.stage),
            NewActivationList = StageList -- Head#head.activation_list,
            if
                NewActivationList == [] -> {13, Player};
                true ->
                    Head1 = Head#head{activation_list = NewActivationList ++ Head#head.activation_list},
                    NewHead = head_init:calc_single_attribute(Head1),
                    StHead1 = StHead#st_head{head_list = [NewHead | T], is_change = 1},
                    NewStHead = head_init:calc_attribute(StHead1),
                    lib_dict:put(?PROC_STATUS_HEAD, NewStHead),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {1, NewPlayer}
            end
    end.


get_stage_list(Id, Stage) ->
    F = fun(Stage0, List) ->
        case data_head_upgrade:get(Id, Stage0) of
            [] -> List;
            #base_head_upgrade{lv_attr = LvAttr} ->
                if
                    LvAttr == [] -> List;
                    true -> [Stage0 | List]
                end
        end
    end,
    lists:foldl(F, [], lists:seq(1, Stage)).
