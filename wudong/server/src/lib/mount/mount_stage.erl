%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%坐骑升阶
%%% @end
%%% Created : 03. 十一月 2016 10:16
%%%-------------------------------------------------------------------
-module(mount_stage).
-author("hxming").

-include("mount.hrl").
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
-include("activity.hrl").
-include("achieve.hrl").
%% API
-export([
    upgrade_stage/2,
    bless_cd_reset/2,
    check_bless_state/1,
    mail_bless_reset/2,
    goods_add_stage/3,
    goods_add_to_stage/3,
    goods_add_stage_limit/3,
    log_mount_stage/7
]).


%%物品增加1阶
goods_add_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    Mount = mount_util:get_mount(),
    MaxStage = data_mount_stage:max_stage(),
    if Mount#st_mount.stage >= MaxStage -> {Player, GoodsList};
        Mount#st_mount.stage >= Stage ->
            BaseData = data_mount_stage:get(Mount#st_mount.stage),
            NewExp = Mount#st_mount.exp + Exp,
            if NewExp >= BaseData#base_mount_stage.exp ->
                NewMount = upgrade_stage(Mount),
                NewMount1 = mount_attr:calc_mount_attr(NewMount),
                mount_util:put_mount(NewMount1),
                log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
                NewPlayer = player_util:count_player_attribute(Player#player{mount_id = NewMount#st_mount.current_sword_id}, true),
                scene_agent_dispatch:mount_id_update(NewPlayer),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1019, 0, NewMount#st_mount.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_mount_stage.award));
                true ->
                    Mount1 = set_bless_cd(Mount, BaseData#base_mount_stage.cd),
                    NewMount = Mount1#st_mount{exp = Mount#st_mount.exp + Exp, is_change = 1},
                    log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
                    mount_util:put_mount(NewMount),
                    {Player, GoodsList}
            end;
        true ->
            NewMount = upgrade_stage(Mount),
            NewMount1 = mount_attr:calc_mount_attr(NewMount),
            notice_sys:add_notice(player_view, [Player, 1, NewMount1#st_mount.stage]),
            mount_util:put_mount(NewMount1),
            log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
            NewPlayer = player_util:count_player_attribute(Player#player{mount_id = NewMount#st_mount.current_sword_id}, true),
            scene_agent_dispatch:mount_id_update(NewPlayer),
            BaseData = data_mount_stage:get(Mount#st_mount.stage),
            achieve:trigger_achieve(NewPlayer, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1019, 0, NewMount#st_mount.stage),
            goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_mount_stage.award))
    end.

%%使用物品增加到指定阶数 1 3
goods_add_to_stage(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_to_stage(Player, [{Stage, Exp} | T], GoodsList) ->
    Mount = mount_util:get_mount(),
    MaxStage = data_mount_stage:max_stage(),
    if Mount#st_mount.stage >= MaxStage -> {Player, GoodsList};
        Mount#st_mount.stage >= Stage ->
            BaseData = data_mount_stage:get(Mount#st_mount.stage),
            NewExp = Mount#st_mount.exp + Exp,
            if NewExp >= BaseData#base_mount_stage.exp ->
                NewMount = upgrade_stage(Mount),
                NewMount1 = mount_attr:calc_mount_attr(NewMount),
                mount_util:put_mount(NewMount1),
                log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
                NewPlayer = player_util:count_player_attribute(Player#player{mount_id = NewMount#st_mount.current_sword_id}, true),
                scene_agent_dispatch:mount_id_update(NewPlayer),
%%                {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(222, tuple_to_list(BaseData#base_mount_stage.award))),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1019, 0, NewMount#st_mount.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_mount_stage.award));
                true ->
                    Mount1 = set_bless_cd(Mount, BaseData#base_mount_stage.cd),
                    NewMount = Mount1#st_mount{exp = Mount#st_mount.exp + Exp, is_change = 1},
                    mount_util:put_mount(NewMount),
                    log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
                    {Player, GoodsList}
            end;
        true ->
            F = fun(_, {M, GList}) ->
                NewM = upgrade_stage(M),
                BaseData = data_mount_stage:get(M#st_mount.stage),
                {NewM, GList ++ tuple_to_list(BaseData#base_mount_stage.award)}
                end,
            {NewMount, GoodsList1} = lists:foldl(F, {Mount, []}, lists:seq(Mount#st_mount.stage, Stage - 1)),
            NewMount1 = mount_attr:calc_mount_attr(NewMount),
            mount_util:put_mount(NewMount1),
            notice_sys:add_notice(player_view, [Player, 1, NewMount1#st_mount.stage]),
            NewPlayer = player_util:count_player_attribute(Player#player{mount_id = NewMount#st_mount.current_sword_id}, true),
            scene_agent_dispatch:mount_id_update(NewPlayer),
%%            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(222, goods:merge_goods(GoodsList))),
            log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1019, 0, NewMount#st_mount.stage),
            goods_add_to_stage(NewPlayer, T, GoodsList ++ GoodsList1)
    end.

%%物品增加1阶 特定等级
goods_add_stage_limit(Player, [], GoodsList) -> {Player, GoodsList};
goods_add_stage_limit(Player, [{Stage, Exp} | T], GoodsList) ->
    Mount = mount_util:get_mount(),
    MaxStage = data_mount_stage:max_stage(),
    if Mount#st_mount.stage >= MaxStage -> {Player, GoodsList};
        Mount#st_mount.stage > Stage ->
            BaseData = data_mount_stage:get(Mount#st_mount.stage),
            NewExp = Mount#st_mount.exp + Exp,
            if NewExp >= BaseData#base_mount_stage.exp ->
                NewMount = upgrade_stage(Mount),
                NewMount1 = mount_attr:calc_mount_attr(NewMount),
                mount_util:put_mount(NewMount1),
                log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
                NewPlayer = player_util:count_player_attribute(Player#player{mount_id = NewMount#st_mount.current_sword_id}, true),
                scene_agent_dispatch:mount_id_update(NewPlayer),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1019, 0, NewMount#st_mount.stage),
                goods_add_stage(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_mount_stage.award));
                true ->
                    Mount1 = set_bless_cd(Mount, BaseData#base_mount_stage.cd),
                    NewMount = Mount1#st_mount{exp = Mount#st_mount.exp + Exp, is_change = 1},
                    log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
                    mount_util:put_mount(NewMount),
                    {Player, GoodsList}
            end;
        true ->
            NewMount = upgrade_stage(Mount),
            NewMount1 = mount_attr:calc_mount_attr(NewMount),
            mount_util:put_mount(NewMount1),
            notice_sys:add_notice(player_view, [Player, 1, NewMount1#st_mount.stage]),
            log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
            NewPlayer = player_util:count_player_attribute(Player#player{mount_id = NewMount#st_mount.current_sword_id}, true),
            scene_agent_dispatch:mount_id_update(NewPlayer),
            BaseData = data_mount_stage:get(Mount#st_mount.stage),
            achieve:trigger_achieve(NewPlayer, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1019, 0, NewMount#st_mount.stage),
            goods_add_stage_limit(NewPlayer, T, GoodsList ++ tuple_to_list(BaseData#base_mount_stage.award))
    end.

%%坐骑升阶
upgrade_stage(Player, IsAuto) ->
    OpenLv = ?MOUNT_OPEN_LV,
    if Player#player.lv < OpenLv -> {false, 4};
        true ->
            MaxStage = data_mount_stage:max_stage(),
            Mount = mount_util:get_mount(),
            if Mount#st_mount.stage >= MaxStage -> {false, 6};
                Mount#st_mount.stage == 0 -> {false, 0};
                true ->
                    BaseData = data_mount_stage:get(Mount#st_mount.stage),
                    case check_goods(Player, BaseData, IsAuto) of
                        {false, Err} -> {false, Err};
                        {true, Player1} ->
                            NewMount = add_exp(Mount, BaseData, Player#player.vip_lv),
                            daily:increment(?DAILY_MOUNT_STAGE, 1),
                            NewMount1 = mount_attr:calc_mount_attr(NewMount),
                            mount_util:put_mount(NewMount1),
                            mount_pack:send_mount_info(NewMount1, Player),
                            log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 0),
                            OldExpPercent = util:floor(Mount#st_mount.exp / BaseData#base_mount_stage.exp * 100),
                            NewExpPercent = util:floor(NewMount#st_mount.exp / BaseData#base_mount_stage.exp * 100),
                            if
                                NewMount#st_mount.stage /= Mount#st_mount.stage ->
                                    NewPlayer = player_util:count_player_attribute(Player1#player{mount_id = NewMount#st_mount.current_sword_id}, true),
                                    %% 添加进阶奖励
                                    {ok, NewPlayer2} = goods:give_goods(NewPlayer, goods:make_give_goods_list(222, tuple_to_list(BaseData#base_mount_stage.award))),
                                    open_act_all_target:act_target(Player#player.key, ?OPEN_ALL_TARGET_MOUNT, NewMount#st_mount.stage),
                                    scene_agent_dispatch:mount_id_update(NewPlayer),
                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1019, 0, NewMount#st_mount.stage),
                                    notice_sys:add_notice(player_view, [Player, 1, NewMount#st_mount.stage]),
                                    activity:get_notice(Player, [33, 46, 128], true),
                                    {ok, 8, NewPlayer2};
                                OldExpPercent /= NewExpPercent ->
                                    NewPlayer = player_util:count_player_attribute(Player1, true),
                                    scene_agent_dispatch:attribute_update(NewPlayer),
                                    {ok, 1, NewPlayer};
                                true ->
                                    {ok, 1, Player1}
                            end
                    end
            end
    end.

%%场景今日是否有双倍
check_double(_Vip) -> false.
%%    SumTimes = data_vip_args:get(42, Vip),
%%    DoubleNum = daily:get_count(?DAILY_MOUNT_STAGE),
%%    SumTimes > DoubleNum.

%%增加经验
add_exp(Mount, BaseData, Vip) ->
    IsDouble = check_double(Vip),
    Mult = ?IF_ELSE(IsDouble, 2, 1),
    Exp = util:rand(BaseData#base_mount_stage.exp_min, BaseData#base_mount_stage.exp_max) * Mult,
    %%经验满了,升阶
    if Mount#st_mount.exp + Exp >= BaseData#base_mount_stage.exp ->
        upgrade_stage(Mount);
        true ->
            Mount1 = set_bless_cd(Mount, BaseData#base_mount_stage.cd),
            Mount1#st_mount{exp = Mount#st_mount.exp + Exp, is_change = 1}
    end.

upgrade_stage(Mount) ->
    NextBaseData = data_mount_stage:get(Mount#st_mount.stage + 1),
    %%激活形象
    ImageList =
        case lists:keytake(NextBaseData#base_mount_stage.image, 1, Mount#st_mount.own_special_image) of
            false ->
                [{NextBaseData#base_mount_stage.image, 0} | Mount#st_mount.own_special_image];
            {value, _, OL} ->
                [{NextBaseData#base_mount_stage.image, 0} | OL]
        end,
%%    StarList =
%%        case lists:keytake(NextBaseData#base_mount_stage.image, 1, Mount#st_mount.star_list) of
%%            false ->
%%                [{NextBaseData#base_mount_stage.image, 1} | Mount#st_mount.star_list];
%%            {value, _, SOL} ->
%%                [{NextBaseData#base_mount_stage.image, 1} | SOL]
%%        end,
    NewMount = Mount#st_mount{exp = 0, stage = Mount#st_mount.stage + 1, bless_cd = 0, own_special_image = ImageList, current_image_id = NextBaseData#base_mount_stage.image, current_sword_id = NextBaseData#base_mount_stage.sword_image,is_change = 1},
    mount_load:replace_mount(NewMount),
    NewMount.


%%检查物品是否足够
check_goods(_Player, [], _IsAuto) ->
    {false, 0};

check_goods(Player, BaseData, IsAuto) ->
    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_mount_stage.goods_ids)],
    Num = BaseData#base_mount_stage.num,
    Amount = lists:sum([Val || {_, Val} <- CountList]),
    if Amount >= Num ->
        DelGoodsList = goods_num(CountList, Num, []),
        goods:subtract_good(Player, DelGoodsList, 60),
        {true, Player};
        Amount < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(BaseData#base_mount_stage.gid_auto) of
                false -> {false, 7};
                {ok, Type, Price} ->
                    Money = Price * (Num - Amount),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 5};
                        true ->
                            DelGoodsList = goods_num(CountList, Num, []),
                            goods:subtract_good(Player, DelGoodsList, 60),
                            NewPlayer = money:cost_money(Player, Type, -Money, 60, BaseData#base_mount_stage.gid_auto, Num - Amount),
                            {true, NewPlayer}
                    end
            end;
        true ->
            goods_util:client_popup_goods_not_enough(Player, BaseData#base_mount_stage.gid_auto, Num, 60),
            {false, 3}
    end.

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
set_bless_cd(Mount, Cd) ->
    if Mount#st_mount.bless_cd > 0 -> Mount;
        Mount#st_mount.exp > 0 -> Mount;
        Cd > 0 ->
            Mount#st_mount{bless_cd = Cd + util:unixtime()};
        true ->
            Mount
    end.


%%祝福重置
bless_cd_reset(Player, Now) ->
    Mount = mount_util:get_mount(),
    if Mount#st_mount.bless_cd > 0 ->
        if Mount#st_mount.bless_cd > Now ->
            Player;
            true ->
                mail_bless_reset(Player#player.key, Mount#st_mount.stage),
                NewMount = Mount#st_mount{bless_cd = 0, exp = 0, is_change = 1},
                log_mount_stage(Player#player.key, Player#player.nickname, NewMount#st_mount.stage, Mount#st_mount.stage, NewMount#st_mount.exp, Mount#st_mount.exp, 1),
                NewMount1 = mount_attr:calc_mount_attr(NewMount),
                mount_util:put_mount(NewMount1),
                player_bless:refresh_bless(Player#player.sid, 1, 0),
                NewPlayer = player_util:count_player_attribute(Player, true),
                scene_agent_dispatch:attribute_update(NewPlayer),
                NewPlayer
        end;
        true -> Player
    end.

%%祝福经验清0通知
mail_bless_reset(Key, Lv) ->
    Content = io_lib:format(?T("您的~p级坐骑祝福时间到期,祝福值清零"), [Lv]),
    mail:sys_send_mail([Key], ?T("祝福清零"), Content),
    ok.

log_mount_stage(Pkey, NickName, NewStage, Stage, NewExp, Exp, Type) ->
    Sql = io_lib:format("insert into log_mount_stage set pkey=~p,nickname='~s',stage=~p,old_stage=~p,exp=~p,old_exp=~p,time=~p,`type`=~p",
        [Pkey, NickName, NewStage, Stage, NewExp, Exp, util:unixtime(), Type]),
    log_proc:log(Sql),
    ok.

%%获取祝福状态
check_bless_state(Now) ->
    Mount = mount_util:get_mount(),
    if Mount#st_mount.bless_cd > Now -> [[1, Mount#st_mount.bless_cd - Now]];
        true -> []
    end.