%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%     翅膀升阶
%%% @end
%%% Created : 03. 十一月 2016 15:43
%%%-------------------------------------------------------------------
-module(wing_stage).
-author("hxming").

-include("wing.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").

%% API
-export([
    upgrade_stage/2,
    bless_cd_reset/2,
    check_bless_state/1,
    mail_bless_reset/2,
    goods_add_stage/3,
    goods_add_stage_limit/3,
    goods_add_to_stage/3,
    log_wing_stage/7
]).

%%物品增加1阶
goods_add_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    Wing = lib_dict:get(?PROC_STATUS_WING),
    MaxStage = data_wing_stage:max_stage(),
    if Wing#st_wing.stage >= MaxStage -> {Player, GoodsList};
        Wing#st_wing.stage >= Stage ->
            BaseData = data_wing_stage:get(Wing#st_wing.stage),
            NewExp = Wing#st_wing.exp + Exp,
            if NewExp >= BaseData#base_wing_stage.exp ->
                NewWing = upgrade_stage(Wing),
                NewWing1 = wing_attr:calc_wing_attr(NewWing),
                lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
                log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
                NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewWing#st_wing.current_image_id}, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(223, tuple_to_list(BaseData#base_wing_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1013, 0, NewWing#st_wing.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_wing_stage.award));
                true ->
                    Wing1 = set_bless_cd(Wing, BaseData#base_wing_stage.cd),
                    NewWing = Wing1#st_wing{exp = Wing1#st_wing.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_WING, NewWing),
                    log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NewWing = upgrade_stage(Wing),
            NewWing1 = wing_attr:calc_wing_attr(NewWing),
            notice_sys:add_notice(player_view, [Player, 2, NewWing1#st_wing.stage]),
            lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
            log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
            NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewWing#st_wing.current_image_id}, true),
            scene_agent_dispatch:attribute_update(NewPlayer),
            BaseData = data_wing_stage:get(Wing#st_wing.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(222, tuple_to_list(BaseData#base_wing_stage.award))),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1013, 0, NewWing#st_wing.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_wing_stage.award))
    end.

%%使用物品增加到指定阶数 1 3
goods_add_to_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_to_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    Wing = lib_dict:get(?PROC_STATUS_WING),
    MaxStage = data_wing_stage:max_stage(),
    if Wing#st_wing.stage >= MaxStage -> {Player, GoodsList};
        Wing#st_wing.stage >= Stage ->
            BaseData = data_wing_stage:get(Wing#st_wing.stage),
            NewExp = Wing#st_wing.exp + Exp,
            if NewExp >= BaseData#base_wing_stage.exp ->
                NewWing = upgrade_stage(Wing),
                NewWing1 = wing_attr:calc_wing_attr(NewWing),
                lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
                log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
                NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewWing#st_wing.current_image_id}, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(223, tuple_to_list(BaseData#base_wing_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1013, 0, NewWing#st_wing.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_wing_stage.award));
                true ->
                    Wing1 = set_bless_cd(Wing, BaseData#base_wing_stage.cd),
                    NewWing = Wing1#st_wing{exp = Wing1#st_wing.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_WING, NewWing),
                    log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            F = fun(_, {W, GList}) ->
                NewW = upgrade_stage(W),
                BaseData = data_wing_stage:get(W#st_wing.stage),
                {NewW, GList ++ tuple_to_list(BaseData#base_wing_stage.award)}
                end,
            {NewWing, GoodsList1} = lists:foldl(F, {Wing, []}, lists:seq(Wing#st_wing.stage, Stage - 1)),
            NewWing1 = wing_attr:calc_wing_attr(NewWing),
            notice_sys:add_notice(player_view, [Player, 2, NewWing1#st_wing.stage]),
            lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
            NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewWing#st_wing.current_image_id}, true),
            scene_agent_dispatch:attribute_update(NewPlayer),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(223, goods:merge_goods(GoodsList))),
            log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1013, 0, NewWing#st_wing.stage),
            goods_add_to_stage(NewPlayer1, T, GoodsList ++ GoodsList1)
    end.

%%物品增加1阶 特定等级使用
goods_add_stage_limit(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage_limit(Player, [{Stage, Exp} | T], GoodsList) ->
    Wing = lib_dict:get(?PROC_STATUS_WING),
    MaxStage = data_wing_stage:max_stage(),
    if Wing#st_wing.stage >= MaxStage -> {Player, GoodsList};
        Wing#st_wing.stage > Stage ->
            BaseData = data_wing_stage:get(Wing#st_wing.stage),
            NewExp = Wing#st_wing.exp + Exp,
            if NewExp >= BaseData#base_wing_stage.exp ->
                NewWing = upgrade_stage(Wing),
                NewWing1 = wing_attr:calc_wing_attr(NewWing),
                lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
                log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
                NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewWing#st_wing.current_image_id}, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(223, tuple_to_list(BaseData#base_wing_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1013, 0, NewWing#st_wing.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_wing_stage.award));
                true ->
                    Wing1 = set_bless_cd(Wing, BaseData#base_wing_stage.cd),
                    NewWing = Wing1#st_wing{exp = Wing1#st_wing.exp + Exp, is_change = 1},
                    lib_dict:put(?PROC_STATUS_WING, NewWing),
                    log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            NewWing = upgrade_stage(Wing),
            NewWing1 = wing_attr:calc_wing_attr(NewWing),
            notice_sys:add_notice(player_view, [Player, 2, NewWing1#st_wing.stage]),
            lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
            log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
            NewPlayer = player_util:count_player_attribute(Player#player{wing_id = NewWing#st_wing.current_image_id}, true),
            scene_agent_dispatch:attribute_update(NewPlayer),
            BaseData = data_wing_stage:get(Wing#st_wing.stage),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(222, tuple_to_list(BaseData#base_wing_stage.award))),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1013, 0, NewWing#st_wing.stage),
            goods_add_stage_limit(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_wing_stage.award))
    end.

%%升阶
upgrade_stage(Player, IsAuto) ->
    Wing = lib_dict:get(?PROC_STATUS_WING),
    MaxStage = data_wing_stage:max_stage(),
    BaseData = data_wing_stage:get(Wing#st_wing.stage),
    if Wing#st_wing.stage >= MaxStage -> {false, 2};
        Wing#st_wing.stage == 0 -> {false, 0};
        BaseData == [] -> {false, 0};
        true ->
            case check_goods(Player, BaseData, IsAuto) of
                {false, Err} -> {false, Err};
                {true, Player1} ->
                    NewWing = add_exp(Wing, BaseData, Player#player.vip_lv),
                    daily:increment(?DAILY_WING_STAGE, 1),
                    wing_pack:send_wing_info(NewWing, Player),
                    log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 0),
                    OldExpPercent = util:floor(Wing#st_wing.exp / BaseData#base_wing_stage.exp * 100),
                    NewExpPercent = util:floor(NewWing#st_wing.exp / BaseData#base_wing_stage.exp * 100),
                    if
                        NewWing#st_wing.stage /= Wing#st_wing.stage ->
                            NewWing1 = wing_attr:calc_wing_attr(NewWing),
                            lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
                            NewPlayer = player_util:count_player_attribute(Player1#player{wing_id = NewWing#st_wing.current_image_id}, true),
                            scene_agent_dispatch:wing_update(NewPlayer),

                            {ok, NewPlayer2} = goods:give_goods(NewPlayer, goods:make_give_goods_list(223, tuple_to_list(BaseData#base_wing_stage.award))),
                            open_act_all_target:act_target(Player#player.key, ?OPEN_ALL_TARGET_WING, NewWing#st_wing.stage),
                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1013, 0, NewWing#st_wing.stage),
                            notice_sys:add_notice(player_view, [Player, 2, NewWing#st_wing.stage]),
                            activity:get_notice(Player, [33, 46, 127], true),
                            {ok, 7, NewPlayer2};
                        OldExpPercent /= NewExpPercent ->
                            NewWing1 = wing_attr:calc_wing_attr(NewWing),
                            lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
                            NewPlayer = player_util:count_player_attribute(Player1#player{wing_id = NewWing#st_wing.current_image_id}, true),
                            scene_agent_dispatch:attribute_update(NewPlayer),
                            {ok, 1, NewPlayer};
                        true ->
                            lib_dict:put(?PROC_STATUS_WING, NewWing#st_wing{is_change = 1}),
                            {ok, 1, Player1}
                    end
            end
    end.

%%场景今日是否有双倍
check_double(_Vip) -> false.
%%    case data_vip_args:get(47, Vip) of
%%        [] -> false;
%%        Times ->
%%            Times > daily:get_count(?DAILY_WING_STAGE)
%%    end.

%%增加经验
add_exp(Wing, BaseData, Vip) ->
    IsDouble = check_double(Vip),
    Mult = ?IF_ELSE(IsDouble, 2, 1),
    Exp = util:rand(BaseData#base_wing_stage.exp_min, BaseData#base_wing_stage.exp_max) * Mult,
    %%经验满了,升阶
    if Wing#st_wing.exp + Exp >= BaseData#base_wing_stage.exp ->
        upgrade_stage(Wing);
        true ->
            Wing1 = set_bless_cd(Wing, BaseData#base_wing_stage.cd),
            Wing1#st_wing{exp = Wing#st_wing.exp + Exp}
    end.

upgrade_stage(Wing) ->
    NextBaseData = data_wing_stage:get(Wing#st_wing.stage + 1),
    %%激活图鉴
    ImageList =
        case lists:keytake(NextBaseData#base_wing_stage.image, 1, Wing#st_wing.own_special_image) of
            false ->
                [{NextBaseData#base_wing_stage.image, 0} | Wing#st_wing.own_special_image];
            {value, _, OL} ->
                [{NextBaseData#base_wing_stage.image, 0} | OL]
        end,
%%    StarList =
%%        case lists:keytake(NextBaseData#base_wing_stage.image, 1, Wing#st_wing.star_list) of
%%            false ->
%%                [{NextBaseData#base_wing_stage.image, 1} | Wing#st_wing.star_list];
%%            {value, _, SOL} ->
%%                [{NextBaseData#base_wing_stage.image, 1} | SOL]
%%        end,
    NewWing = Wing#st_wing{exp = 0, stage = Wing#st_wing.stage + 1, bless_cd = 0, own_special_image = ImageList, current_image_id = NextBaseData#base_wing_stage.image},
    wing_load:replace_wing(NewWing),
    NewWing.

%%检查物品是否足够
check_goods(Player, BaseData, IsAuto) ->
    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_wing_stage.goods_ids)],
    Num = BaseData#base_wing_stage.num,
    Awing = lists:sum([Val || {_, Val} <- CountList]),
    if Awing >= Num ->
        DelGoodsList = goods_num(CountList, Num, []),
        goods:subtract_good(Player, DelGoodsList, 37),
        {true, Player};
        Awing < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(BaseData#base_wing_stage.gid_auto) of
                false -> {false, 6};
                {ok, Type, Price} ->
                    Money = Price * (Num - Awing),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 5};
                        true ->
                            DelGoodsList = goods_num(CountList, Num, []),
                            goods:subtract_good(Player, DelGoodsList, 37),
                            NewPlayer = money:cost_money(Player, Type, -Money, 37, BaseData#base_wing_stage.gid_auto, Num - Awing),
                            {true, NewPlayer}
                    end
            end;
        true ->
            goods_util:client_popup_goods_not_enough(Player, BaseData#base_wing_stage.gid_auto, Num, 37),
            {false, 3}
    end.

%%检查物品是否足够
%%check_goods2(Player, BaseData, IsAuto) ->
%%    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_wing_stage.goods_ids)],
%%    Num = BaseData#base_wing_stage.num,
%%    Awing = lists:sum([Val || {_, Val} <- CountList]),
%%    if Awing >= Num ->
%%        DelGoodsList = goods_num(CountList, Num, []),
%%        goods:subtract_good(Player, DelGoodsList, 60),
%%        {true, Player};
%%        Awing < Num andalso IsAuto == 1 ->
%%            case new_shop:get_goods_price(BaseData#base_wing_stage.gid_auto) of
%%                false -> {false, 6};
%%                {ok, Type, Price} ->
%%                    Money = Price * (Num - Awing),
%%                    case money:is_enough(Player, Money, Type) of
%%                        false -> {false, 5};
%%                        true ->
%%                            DelGoodsList = goods_num(CountList, Num, []),
%%                            goods:subtract_good(Player, DelGoodsList, 60),
%%                            {true, Player}
%%                    end
%%            end;
%%        true ->
%%            {false, 3}
%%    end.

goods_num([], _, GoodsList) -> GoodsList;
goods_num(_, 0, GoodsList) -> GoodsList;
goods_num([{Gid, Num} | T], NeedNum, GoodsList) ->
    if Num =< 0 -> goods_num(T, NeedNum, GoodsList);
        Num < NeedNum ->
            goods_num(T, NeedNum - Num, [{Gid, Num} | GoodsList]);
        true ->
            [{Gid, NeedNum} | GoodsList]
    end.


%%设置超时CD
set_bless_cd(Wing, Cd) ->
    if Wing#st_wing.bless_cd > 0 -> Wing;
        Wing#st_wing.exp > 0 -> Wing;
        Cd > 0 ->
            Wing#st_wing{bless_cd = Cd + util:unixtime()};
        true ->
            Wing
    end.


%%祝福重置
bless_cd_reset(Player, Now) ->
    Wing = lib_dict:get(?PROC_STATUS_WING),
    if Wing#st_wing.bless_cd > 0 ->
        if Wing#st_wing.bless_cd > Now ->
            Player;
            true ->
                mail_bless_reset(Player#player.key, Wing#st_wing.stage),
                NewWing = Wing#st_wing{bless_cd = 0, exp = 0},
                NewWing1 = wing_attr:calc_wing_attr(NewWing),
%%                wing_load:replace_wing(NewWing1),
                lib_dict:put(?PROC_STATUS_WING, NewWing1#st_wing{is_change = 1}),
                NewPlayer = player_util:count_player_attribute(Player, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
                log_wing_stage(Player#player.key, Player#player.nickname, NewWing#st_wing.stage, Wing#st_wing.stage, NewWing#st_wing.exp, Wing#st_wing.exp, 1),
                player_bless:refresh_bless(Player#player.sid, 2, 0),
                NewPlayer
        end;
        true -> Player
    end.

%%祝福经验清0通知
mail_bless_reset(Key, Lv) ->
    Content = io_lib:format(?T("您的~p阶翅膀祝福时间到期,祝福值清零"), [Lv]),
    mail:sys_send_mail([Key], ?T("祝福清零"), Content),
    ok.

log_wing_stage(Pkey, NickName, NewStage, Stage, NewExp, Exp, Type) ->
    Sql = io_lib:format("insert into log_wing_stage set pkey=~p,nickname='~s',stage=~p,old_stage=~p,exp=~p,old_exp=~p,time=~p,`type`=~p",
        [Pkey, NickName, NewStage, Stage, NewExp, Exp, util:unixtime(), Type]),
    log_proc:log(Sql),
    ok.

check_bless_state(Now) ->
    Wing = lib_dict:get(?PROC_STATUS_WING),
    if Wing#st_wing.bless_cd > Now -> [[2, Wing#st_wing.bless_cd - Now]];
        true -> []
    end.