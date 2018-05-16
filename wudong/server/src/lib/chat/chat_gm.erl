%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%% 秘籍
%%% @end
%%% Created : 20. 一月 2015 11:08
%%%-------------------------------------------------------------------
-module(chat_gm).
-author("fzl").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("charge.hrl").
-include("scene.hrl").
-include("pet.hrl").
-include("guild.hrl").
-include("dungeon.hrl").
-include("wing.hrl").
-include("g_daily.hrl").
-include("relation.hrl").
-include("marry.hrl").
-include("team.hrl").
-include("rank.hrl").
-include("task.hrl").
-include("player_mask.hrl").
-include("daily.hrl").
-include("awake.hrl").
%% API

-compile(export_all).

%%GM 说明，需要大家用到的gm，都麻烦在这里添加下，方面查询
-define(GM_COMMOND, ?T(
    "
    lv_N        加等级
    money_N     加钱
    plv_N       所有宠物加等级
    ot_N        设置到开服第N天
    at_N        设置时间到第N天 1代表设置到明天
    goods_Id_Num  加物品
    att_N       增加攻击 加其他属性 属性名_数值
    charge_N    充值N元 N=1时，代表充值月卡
    vip_N       加VIP等级
    ar          刷冲榜活动--清除所有领奖信息
    arf         冲榜活动结算
    gpet_Petid  获取指定宠物
    sfz_N       神罚值
    xh_N        星魂值
    ")
).

%%-------------------------基础gm-------------------
test() ->
    Q = goods_attr_dan:calc_dan_attr_by_type(12),
    ?DEBUG("~p~n"),
    ?DEBUG("Test  ~n").

gm(Player, ["ttss"]) ->
    player_rpc:handle(13041, Player, {Player#player.sn, Player#player.key}),
    ok;

gm(Player, ["177177"]) ->
    activity:get_notice(Player, [147], true),
    ok;

gm(Player, ["16039"]) ->
    equip_rpc:handle(16039, Player, {5101453, 0}),
    ok;

gm(Player, ["176176"]) ->
    activity:get_notice(Player, [176], true),
    ok;


gm(Player, ["40090"]) ->
    ?DEBUG("40090 ~n"),
    guild_rpc:handle(40090, Player, 1),
    ok;
gm(Player, ["40091"]) ->
    ?DEBUG("40091 ~n"),
    guild_rpc:handle(40091, Player, 1),
    ok;
gm(Player, ["40092"]) ->
    ?DEBUG("40092 ~n"),
    guild_rpc:handle(40092, Player, 1),
    ok;
gm(Player, ["40093"]) ->
    ?DEBUG("40093 ~n"),
    guild_rpc:handle(40093, Player, 1),
    ok;
gm(Player, ["40094"]) ->
    ?DEBUG("40094 ~n"),
    guild_rpc:handle(40094, Player, 1),
    ok;

gm(Player, ["58535", AddNumStr]) ->
    cross_scuffle_elite_rpc:handle(58535, Player, {list_to_integer(AddNumStr)});

%%
%% gm(Player, ["58535"]) ->
%%     Q = cross_scuffle_elite_rpc:handle(58535, Player, {}),
%%     ?DEBUG("Q ~p~n", [Q]), Q;

gm(Player, ["pethp", Str]) ->
    Hp = util:to_integer(Str),
    pet_war_dun:add_hp(Player, Hp),
    ok;

gm(Player, ["60401"]) ->
    cross_mining_rpc:handle(60401, Player, {1, 1}),
    ok;
gm(Player, ["60402"]) ->
    cross_mining_rpc:handle(60402, Player, {}),
    ok;
gm(Player, ["60403"]) ->
    cross_mining_rpc:handle(60403, Player, {1, 1, 3}),
    ok;
gm(Player, ["60404"]) ->
    cross_mining_rpc:handle(60404, Player, {1, 1, 3}),
    ok;
gm(Player, ["60405"]) ->
    cross_mining_rpc:handle(60405, Player, {1, 1, 3}),
    ok;
gm(Player, ["60406"]) ->
    cross_mining_rpc:handle(60406, Player, {1, 1, 3}),
    ok;
gm(Player, ["60408"]) ->
    cross_mining_rpc:handle(60408, Player, {1, 1, 3}),
    ok;
gm(Player, ["60410"]) ->
    cross_mining_rpc:handle(60410, Player, {}),
    ok;
gm(Player, ["60413"]) ->
    cross_mining_rpc:handle(60413, Player, {Player#player.key}),
    ok;

gm(Player, ["43960", Str]) ->
    Hp = util:to_integer(Str),
    activity_rpc:handle(43960, Player, {Hp});

gm(Player, ["43959"]) ->
    activity_rpc:handle(43959, Player, {});

gm(Player, ["sbsb"]) ->
    ?DEBUG("Player#player.show_golden_body ~p~n", [Player#player.show_golden_body]),
    ok;
gm(Player, ["12165"]) ->
    dungeon_rpc:handle(12165, Player, 56001),
    ok;


gm(Player, ["12165"]) ->
    Nodes = ets:tab2list(?ETS_KF_NODES),
    Q =

        ok;


gm(Player, ["actsn"]) ->
    ok;
gm(Player, ["gguild"]) ->

    ?DEBUG("Player#player.guild#guild.gkey, ~p~n", [Player#player.guild#st_guild.guild_key]),

    ok;
gm(Player, ["actsn11"]) ->
    ?DEBUG("OtherPlayer#player.scene ~p~n", [Player#player.scene]),
    ok;
gm(Player, ["58528"]) ->
    cross_scuffle_elite_rpc:handle(58528, Player, {}),
    ok;
gm(Player, ["act", Sn]) ->
    activity_rpc:handle(list_to_integer(Sn), Player, {}),
    ok;
%% gm(Player, ["name"]) ->
%% %%     Q1 = is_atom(Player#player.nickname),
%% %%     Q2 = is_binary(Player#player.nickname),
%% %%     Q3 = is_integer(Player#player.nickname),
%% %%     Q4 = is_tuple(Player#player.nickname),
%% %%     Q5 = is_float(Player#player.nickname),
%% %%     Q6 = is_list(Player#player.nickname),
%%     ?DEBUG("Player ~p~n",[Player#player.war_team#st_war_team.war_team_key]),
%%
%%     Q1 = is_atom(" "),
%%     Q2 = is_binary(" "),
%%     Q3 = is_integer(" "),
%%     Q4 = is_tuple(" "),
%%     Q5 = is_float(" "),
%%     Q6 = is_list(util:make_sure_list(Player#player.nickname) ++ " " ),
%%
%%
%%     ?DEBUG(" ~p ", [{Q1, Q2, Q3, Q4, Q5,Q6}]),
%%
%%     ok;
gm(Player, ["st"]) ->
    St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
    ?DEBUG("St ~p~n", [St]),
    ok;

gm(Player, ["gmsm"]) ->
    act_cbp_rank:gm_send_mail(),
    ok;

gm(Player, ["gglv"]) ->
    player_awake:get_equip_strength_lv(),
    ok;

gm(Player, ["snewcaree"]) ->
    St = lib_dict:get(?PROC_STATUS_AWAKE),
    NewSt = St#st_awake{type = 3},
    lib_dict:put(?PROC_STATUS_AWAKE, NewSt),
    player_awake:dbup_player_awake(NewSt),
    StCareer = lib_dict:get(?PROC_STATUS_TASK_CHANGE_CAREER),
    NewSt = StCareer#st_change_career{new_career = 3},
    lib_dict:put(?PROC_STATUS_TASK_CHANGE_CAREER, NewSt),
    task_change_career:dbup_change_career(NewSt),
    NewPlayer1 = Player#player{new_career = StCareer#st_change_career.new_career + NewSt#st_awake.type},
    player_load:dbup_player_new_career(NewPlayer1),
    ok;

gm(Player, ["snewcaree3"]) ->
    StCareer = lib_dict:get(?PROC_STATUS_TASK_CHANGE_CAREER),
    NewSt = StCareer#st_change_career{new_career = 3},
    lib_dict:put(?PROC_STATUS_TASK_CHANGE_CAREER, NewSt),
    task_change_career:dbup_change_career(NewSt),
    NewPlayer1 = Player#player{new_career = NewSt#st_change_career.new_career},
    player_load:dbup_player_new_career(NewPlayer1),
    ok;

gm(Player, ["gnewcaree"]) ->
    StCareer = lib_dict:get(?PROC_STATUS_TASK_CHANGE_CAREER),
    ?DEBUG("StCareer ~p~n", [StCareer#st_change_career.new_career]),

    ok;

gm(Player, ["43860"]) ->
    activity_rpc:handle(43860, Player, {}),
    ok;
gm(Player, ["43855"]) ->
    activity_rpc:handle(43855, Player, {});

gm(Player, ["43856"]) ->
    activity_rpc:handle(43856, Player, {});

gm(Player, ["stst"]) ->
    St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
    ?DEBUG("St ~p~n", [St]),
    ok;

gm(Player, ["g00"]) ->
    ?DEBUG("~p~n", [daily:get_count(?DAILY_ACT_CBP_UP)]),
    ok;
gm(Player, ["s00"]) ->
    daily:set_count(?DAILY_ACT_CBP_UP, 0),
    ok;

gm(Player, ["13042"]) ->
    player_rpc:handle(13042, Player, {}),
    ok;
gm(Player, ["upl"]) ->
    act_meet_limit:update_online_time(Player),
    ok;
gm(Player, ["43863"]) ->
    activity_rpc:handle(43863, Player, {1}),
    ok;

gm(Player, ["43864", Type]) ->
    {ok, Bin} = pt_438:write(43864, {list_to_integer(Type)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

gm(Player, ["43839", Sn]) ->
    activity_rpc:handle(43839, Player, {list_to_integer(Sn)}),
    ok;
gm(Player, ["13002"]) ->
    player_util:count_player_attribute(Player, true);


gm(_Player, ["cregift"]) ->
    player_mask:set(15, 0),
    ok;

gm(Player, ["mail0"]) ->
    player_handle:gm(Player#player.key),
    ok;
gm(Player, ["13037"]) ->
    player_rpc:handle(13037, Player, {});

gm(Player, ["13038"]) ->
    player_rpc:handle(13038, Player, {3105000});

gm(Player, ["test1"]) ->
    ?DEBUG("scene ~p~n ", [Player#player.scene]),
    ?DEBUG("copy ~p~n ", [Player#player.copy]),

    ok;

gm(Player, ["13039"]) ->
    player_rpc:handle(13039, Player, {1});


gm(Player, ["mail11"]) ->
    {Title, Content} = t_mail:mail_content(143),
    mail:sys_send_mail([Player#player.key], Title, Content, []),
    ok;


%%gm说明
gm(Player, ["login", LoginFlag]) ->
    {ok, Player#player{login_flag = util:to_atom(LoginFlag)}};

gm(Player, ["gm"]) ->
    Data = chat:pack_chat_data(Player, 1, ?GM_COMMOND, "", 0),
    {ok, Bin} = pt_110:write(11000, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

gm(_Player, ["stop"]) ->
    ?CAST(self(), stop),
    ok;

gm(_Player, ["clean"]) ->
    goods_util:cmd_clean(_Player);

gm(_Player, ["clearup"]) ->
    goods_clear_up:clear_up_bag(_Player, 2);


%%加亲密度
gm(Player, ["qinmidu", AddNumStr]) ->
    AddNum = list_to_integer(AddNumStr),
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Fun = fun(Relation) ->
        relation:add_qinmidu({Relation#relation.pkey, AddNum}, Player),
        case ets:lookup(?ETS_ONLINE, Relation#relation.pkey) of
            [] -> ok;
            Online -> Online#ets_online.pid ! {add_qinmidu, Player#player.key, {no_db, AddNum}}
        end
          end,
    lists:foreach(Fun, RelationsSt#st_relation.friends),
    ok;


%%设置回归身份
gm(Player, ["setre"]) ->
    {ok, Player#player{continue_end_time = util:unixtime() + 20 * ?ONE_DAY_SECONDS}};


%%取消回归身份
gm(Player, ["clre"]) ->
    {ok, Player#player{return_time = 0, continue_end_time = 0}};

%%设置回归身份
gm(Player, ["177177"]) ->
    return_act:get_notice_state(Player),
    {ok, Player#player{continue_end_time = util:unixtime() + 20 * ?ONE_DAY_SECONDS}};

%%加经验
gm(Player, ["exp", AddExpStr]) ->
    AddExp = list_to_integer(AddExpStr),
    NewPlayer = player_util:add_exp(Player, AddExp, 4),
    {ok, NewPlayer};
%%加等级
gm(Player, ["lv", LvStr]) ->
    Lv = min(300, list_to_integer(LvStr)),
    NowLv = Player#player.lv,
    case Lv > NowLv of
        true ->
            F = fun(_N, AccPlayer) ->
                NewLv = AccPlayer#player.lv + 1,
                NeedExp = data_exp:get(NewLv),
                player_util:add_exp(AccPlayer, NeedExp, 4)
                end,
            NewPlayer = lists:foldl(F, Player, lists:seq(NowLv, Lv)),
%%            task:cmd_finish_lv_task(NewPlayer),
%%             NewPlayer1 = pet:pet_lv_up(NewPlayer),
            {ok, NewPlayer};
        false ->
            NewPlayer = Player#player{lv = Lv, exp = 0},
            player_util:count_player_attribute(NewPlayer, true),
            player_load:dbup_player_state(NewPlayer),
%%            task:cmd_finish_lv_task(NewPlayer),
            {ok, NewPlayer}
    end;
%%加钱
gm(Player, ["money", NumStr]) ->
    Num = min(1000000000, list_to_integer(NumStr)),
    NewPlayer = Player#player{
        coin = Num,
        gold = Num,
        bcoin = Num,
        bgold = Num,
        arena_pt = Num,
        xingyun_pt = Num
    },
    SQL = io_lib:format("update player_state set gold = ~p ,bgold = ~p ,coin = ~p ,bcoin = ~p,xingyun_pt = ~p where pkey = ~p", [Num, Num, Num, Num, Num, Player#player.key]),
    db:execute(SQL),
    player_util:update_notice(NewPlayer),
    {ok, NewPlayer};
%%加物品
gm(Player, ["goods", GoodsIdStr, NumStr]) ->
    GoodsId = list_to_integer(GoodsIdStr),
    Num = list_to_integer(NumStr),
    #goods_type{type = Type} = data_goods:get(GoodsId),
    if
        Type == ?GOODS_TYPE_FUWEN ->
            GiveGoodsList = goods:make_give_goods_list(0, [{GoodsId, Num, ?GOODS_LOCATION_FUWEN, ?BIND, []}]);
        true ->
            GiveGoodsList = goods:make_give_goods_list(0, [{GoodsId, Num, 0}])
    end,
    ?DEBUG("GiveGoodsList:~p~n", [GiveGoodsList]),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, NewPlayer};

%% 清除背包所有物品
gm(_Player, ["cbag"]) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    FilterDict = dict:filter(fun(_, [Goods]) ->
        Goods#goods.location == ?GOODS_LOCATION_BAG end, GoodsSt#st_goods.dict),
    KeyList = [{Goods#goods.key, Goods#goods.num} || {_, [Goods]} <- dict:to_list(FilterDict)],
    goods:subtract_good_by_keys(KeyList),
    ok;

gm(_Player, ["ltcmsg"]) ->
    act_lucky_turn:gm_clear_msg(),
    ok;

gm(_Player, ["ltcmsg2"]) ->
    act_local_lucky_turn:gm_clear_msg2(),
    ok;

gm(Player, ["goodsb", GoodsIdStr, NumStr]) ->
    GoodsId = list_to_integer(GoodsIdStr),
    Num = list_to_integer(NumStr),
    #goods_type{type = Type} = data_goods:get(GoodsId),
    if
        Type == ?GOODS_TYPE_FUWEN ->
            GiveGoodsList = goods:make_give_goods_list(0, [{GoodsId, Num, ?GOODS_LOCATION_FUWEN, ?BIND, []}]);
        true ->
            GiveGoodsList = goods:make_give_goods_list(0, [{GoodsId, Num, ?BIND}])
    end,
    ?DEBUG("GiveGoodsList:~p~n", [GiveGoodsList]),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, NewPlayer};

gm(Player, ["goodst", GoodsIdStr, Time]) ->
    GoodsId = list_to_integer(GoodsIdStr),
    GiveGoodsList = goods:make_give_goods_list(0, [{GoodsId, 1, 0, util:unixtime() + list_to_integer(Time)}]),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, NewPlayer};

gm(_Player, ["ginfo", Id]) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsDict = GoodsStatus#st_goods.dict,
    {_SumNum, GoodsList} = goods_util:get_goods_list_by_goods_id(list_to_integer(Id), GoodsDict),
    L = [{Goods#goods.key, Goods#goods.num, Goods#goods.bind, Goods#goods.expire_time} || Goods <- GoodsList],
    ?DEBUG("L ~p~n", [L]),
    ok;
%%加物品
gm(Player, ["fbgoods", GoodsIdStr, NumStr]) ->
    GoodsId = list_to_integer(GoodsIdStr),
    Num = list_to_integer(NumStr),
    {ok, NewPlayer} = goods:give_goods(Player, [#give_goods{goods_id = GoodsId, num = Num, from = 0, bind = ?NO_BIND}]),
    {ok, NewPlayer};

%%加物品
gm(Player, ["wing", StagerStr]) ->
    Stager = list_to_integer(StagerStr),
    case catch data_wing_stage:get(Stager) of
        {false, _} ->
            ok;
        NewWingStage ->
            WingSt = lib_dict:get(?PROC_STATUS_WING),
            OwnSpecialImage = [begin WingStage = data_wing_stage:get(InStager), {WingStage#base_wing_stage.image, -1} end || InStager <- lists:seq(1, Stager)],
            NewWingSt = WingSt#st_wing{own_special_image = OwnSpecialImage, stage = Stager, current_image_id = 1001},
            NewWingSt1 = wing_attr:calc_wing_attr(NewWingSt),
            lib_dict:put(?PROC_STATUS_WING, NewWingSt1),
            wing_load:replace_wing(NewWingSt1),
            wing_pack:send_wing_info(NewWingSt1, Player),
            NewPlayer = player_util:count_player_attribute(Player, true),
            {ok, NewPlayer}
    end;
gm(Player, ["tlv", LvStr]) ->
    task:cmd_tlv(Player, list_to_integer(LvStr));
gm(Player, ["des", N]) ->
    DesId = list_to_integer(N),
    case data_designation:get(DesId) of
        [] -> ok;
        _ ->
            designation_proc:add_des(DesId, [Player#player.key]),
            ok
    end;
%% %%渠道号
%% gm(Player,["qdplayer"]) ->
%%     %%等级
%%     {ok, NewPlayer} = gm(Player,["lv","50"]),
%%     %%金钱
%%     NewPlayer1 = NewPlayer#player{
%%         coin = 1000000,
%%         gold = 50000,
%%         repute = 30000
%%     },
%%     player_load:dbup_player_money(NewPlayer1),
%%     player_util:update_notice(NewPlayer1),
%%     %%装备
%%     EquipList =
%%         case NewPlayer1#player.career of
%%             ?CAREER1 ->
%%                 [130104,130204,130704,130804,130904,131004,131104,131204,131304,131404,130104,130204,130704,130804];
%%             ?CAREER2 ->
%%                 [130504,130604,130704,130804,130904,131004,131104,131204,131304,131404,130104,130204,130704,130804];
%%             ?CAREER3 ->
%%                 [130304,130404,130704,130804,130904,131004,131104,131204,131304,131404,130104,130204,130704,130804]
%%         end,
%%     EquipList1 = [{GTId,1}||GTId<-EquipList],
%%     goods:give_goods(Player#player.key,EquipList1),
%%     goods_util:send_goods_info(?GOODS_LOCATION_BAG),
%%     {ok,NewPlayer1};
%%属性修改
gm(Player, ["att", NumStr]) ->
    Num = list_to_integer(NumStr),
    Attribute = Player#player.attribute,
    Player2 = Player#player{attribute = Attribute#attribute{att = Num}},
    player_util:update_notice(Player2),
    {ok, attr, Player2};
gm(Player, ["def", NumStr]) ->
    Num = list_to_integer(NumStr),
    Attribute = Player#player.attribute,
    Player2 = Player#player{attribute = Attribute#attribute{def = Num}},
    player_util:update_notice(Player2),
    {ok, attr, Player2};
gm(Player, ["hp", NumStr]) ->
    Num = list_to_integer(NumStr),
    Attribute = Player#player.attribute,
    Player2 = Player#player{hp = Num, attribute = Attribute#attribute{hp_lim = Num}},
    player_util:update_notice(Player2),
    scene_agent_dispatch:hpmp_update(Player2),
    {ok, attr, Player2};
gm(Player, ["pvpinc", NumStr]) ->
    Num = list_to_integer(NumStr),
    Attribute = Player#player.attribute,
    Player2 = Player#player{attribute = Attribute#attribute{pvp_inc = Num}},
    player_util:update_notice(Player2),
    {ok, attr, Player2};
gm(Player, ["pvpdec", NumStr]) ->
    Num = list_to_integer(NumStr),
    Attribute = Player#player.attribute,
    Player2 = Player#player{attribute = Attribute#attribute{pvp_dec = Num}},
    player_util:update_notice(Player2),
    {ok, attr, Player2};
gm(Player, ["myhp"]) ->
    ?DEBUG("hpinfo ~p/~p~n", [Player#player.hp, Player#player.attribute#attribute.hp_lim]),
    ok;
gm(Player, ["sethp", NumStr]) ->
    Num = list_to_integer(NumStr),
    Hp = min(Num, Player#player.attribute#attribute.hp_lim),
    Player2 = Player#player{hp = Hp},
    player_util:update_notice(Player2),
    {ok, attr, Player2};
gm(Player, ["br"]) ->
    Str = io_lib:format("~s", [t_tv:pn(Player)]),
%%     io:format("系统广播测试 ~s",[t_tv:pn(Player)]),
%%     Str = "sdfasfdsdf",
    notice:add_sys_notice(Str, [1, 2, 3, 4]),
    ok;

gm(Player, ["manorpt", Val]) ->
    NewPlayer = money:add_manor_pt(Player, list_to_integer(Val)),
    {ok, NewPlayer};

gm(Player, ["jyjy", Exp]) ->
    guild_manor:cmd_manor_exp(Player, list_to_integer(Exp));

gm(Player, ["jyjzjy", Exp]) ->
    guild_manor:cmd_build_exp(Player, list_to_integer(Exp));
gm(_Player, ["mwtask"]) ->
    manor_war_task:midnight_refresh(),
    ok;
%%换场景
gm(Player, ["goto", Sid]) ->
    Id = list_to_integer(Sid),
    case data_scene:get(Id) of
        [] -> ok;
        Scene ->
            Copy = scene_copy_proc:get_scene_copy(Id, Player#player.copy),
            {ok, scene_change:change_scene(Player, Id, Copy, Scene#scene.x, Scene#scene.y, false)}
    end;
gm(Player, ["gtc", Sid, Copy1]) ->
    Id = list_to_integer(Sid),
    Copy = list_to_integer(Copy1),
    case data_scene:get(Id) of
        [] -> ok;
        Scene ->
            Copy = scene_copy_proc:get_scene_copy(Id, Copy),
            {ok, scene_change:change_scene(Player, Id, Copy, Scene#scene.x, Scene#scene.y, false)}
    end;


%%召唤怪物
gm(Player, ["mon", Mid, Group]) ->
    Group2 = ?IF_ELSE(Group == "1", Player#player.key, list_to_integer(Group)),
%%mon_agent:create_mon_cast([util:to_integer(Mid), Player#player.scene, Player#player.x+1, Player#player.y+1, Player#player.copy, 1, [{group, Group2}]]),
    mon_agent:create_mon_cast([util:to_integer(Mid), Player#player.scene, Player#player.x, Player#player.y, Player#player.copy, 1, [{group, Group2}]]);

gm(Player, ["drop", Id]) ->
    NewPlayer = drop:drop(Player, list_to_integer(Id), 0),
    {ok, NewPlayer};

gm(Player, ["dun", Id]) ->
    DunId = list_to_integer(Id),
    case data_dungeon:get(DunId) of
        [] -> ok;
        Dun ->
%%玩家创建副本进程
            Now = util:unixtime(),
            DunPlayer = dungeon_util:make_dungeon_mb(Player, Now),
            Extra = [],
            DunPid = dungeon:start([DunPlayer], Dun#dungeon.id, Now, Extra),
            Scene = data_scene:get(DunId),
            [X, Y] = [Scene#scene.x, Scene#scene.y],
            NewPlayer = scene_change:change_scene(Player, DunId, DunPid, X, Y, false),
            {ok, NewPlayer}
    end;

gm(Player, ["kfdun", Id]) ->
    ?DEBUG("kfdun ~p~n", [Id]),
    Mb = dungeon_util:make_dungeon_mb(Player, util:unixtime()),
    cross_all:apply(cross_dungeon_util, cmd_enter, [Mb, list_to_integer(Id)]),
    ok;

gm(Player, ["kfgdun", Id]) ->
    ?DEBUG("kfdun ~p~n", [Id]),
    Mb = dungeon_util:make_dungeon_mb(Player, util:unixtime()),
    cross_all:apply(cross_dungeon_guard_util, cmd_enter, [Mb, list_to_integer(Id)]),
    ok;

gm(Player, ["stimes", Id]) ->
    cross_dungeon_util:set_times(list_to_integer(Id)),
    ok;

gm(Player, ["ckfg"]) ->
    cross_dungeon_guard_rpc:handle(65102, Player, {12015, [], 1});

gm(Player, ["12300"]) ->
    cross_dungeon_rpc:handle(12300, Player, {});

gm(Player, ["65100"]) ->
    cross_dungeon_guard_rpc:handle(65100, Player, {});

gm(Player, ["qkfg"]) ->
    cross_dungeon_guard_rpc:handle(65120, Player, {});

gm(Player, ["65126"]) ->
    cross_dungeon_guard_rpc:handle(65126, Player, {});

gm(Player, ["convoyreset"]) ->
    NewPlayer = task_convoy:cmd_reset(Player),
    {ok, NewPlayer};

gm(Player, ["sfz", N]) ->
    Num = list_to_integer(N),
    Player2 = Player#player{sin = Num},
    scene_agent_dispatch:request_scene_data(Player2),
    {ok, Player2};

gm(_Player, ["ksmwrq"]) ->
    invade_proc:cmd_start(),
    ok;

gm(_Player, ["gbmwrq"]) ->
    invade_proc:cmd_close(),
    ok;

gm(_Player, ["tcycle", N]) ->
    task_cycle:cmd_cycle(list_to_integer(N)),
    ok;
gm(_Player, ["rcycle"]) ->
    task_cycle:cmd_reset(_Player),
    ok;

gm(_Player, ["kssyez"]) ->
    grace_proc:cmd_start(),
    ok;

gm(_Player, ["gbsyez"]) ->
    grace_proc:cmd_close(),
    ok;


gm(_Player, ["kslc"]) ->
    cross_area:apply(cross_hunt_proc, cmd_start, []),
    ok;

gm(_Player, ["gblc"]) ->
    cross_area:apply(cross_hunt_proc, cmd_close, []),
    ok;

gm(_Player, ["rhunt"]) ->
    cross_hunt_target:cmd_reset(_Player),
    ok;


gm(_Player, ["wlv", Lv]) ->
    cache:set(world_lv, list_to_integer(Lv)),
    ok;

gm(_Player, ["blzc"]) ->
    cross_area:apply(battlefield_proc, cmd_ready, []),
    ok;
gm(_Player, ["kszc"]) ->
    cross_area:apply(battlefield_proc, cmd_start, []),
    ok;
gm(_Player, ["gbzc"]) ->
    cross_area:apply(battlefield_proc, cmd_close, []),
    ok;

gm(_Player, ["kskfzc"]) ->
    cross_area:apply(cross_battlefield_proc, cmd_start, []),
    ok;

gm(_Player, ["gbkfzc"]) ->
    cross_area:apply(cross_battlefield_proc, cmd_close, []),
    ok;

gm(_Player, ["kfzctc", Layer]) ->
    cross_area:apply(cross_battlefield_proc, cmd_jump, [_Player#player.key, list_to_integer(Layer)]),
    ok;


gm(_Player, ["kskfboss"]) ->
    cross_area:apply(cross_boss_proc, cmd_start, []),
    ok;
gm(_Player, ["gbkfboss"]) ->
    cross_area:apply(cross_boss_proc, cmd_close, []),
    ok;
gm(_Player, ["dfkfboss"]) ->
    cross_area:apply(cross_boss_proc, cmd_default, []),
    ok;

gm(_Player, ["kskf1v1"]) ->
    cross_area:apply(cross_elite_proc, cmd_start, []),
    ok;
gm(_Player, ["gbkf1v1"]) ->
    cross_area:apply(cross_elite_proc, cmd_close, []),
    ok;

gm(_Player, ["1v1"]) ->
    cross_elite:cmd_test(),
    ok;


gm(Player, ["58504"]) ->
    ?DEBUG("Player ~p~n", [Player#player.cross_scuffle_elite]),
    ?DEBUG("war_team ~p~n", [Player#player.war_team]),
    ok;
gm(Player, ["gmtest"]) ->
    task:gm_test(),
    PackTask = task:get_task_list(Player),
    ?ERR("PackTask PackTask ~p~n", [PackTask]),
    ok;

gm(Player, ["999"]) ->
    ?DEBUG("key ~p~n", [Player#player.key]),
    ok;

gm(_Player, ["58504", CmdStr]) ->
    Cmd = util:term_to_string(CmdStr),
    cross_scuffle_elite_rpc:handle(58504, _Player, {Cmd});

gm(_Player, ["58512"]) ->
    cross_scuffle_elite_rpc:handle(58512, _Player, {});

gm(_Player, ["58518"]) ->
    cross_scuffle_elite_rpc:handle(58518, _Player, {1, 1});

gm(_Player, ["58505", Type0]) ->
    Type = util:to_integer(Type0),
    cross_scuffle_elite_rpc:handle(58505, _Player, {Type});

gm(_Player, ["58502"]) ->
    cross_scuffle_elite_rpc:handle(58502, _Player, {});


gm(_Player, ["58506", Type0]) ->
    Type = util:to_integer(Type0),
    cross_scuffle_elite_rpc:handle(58506, _Player, {Type});


gm(_Player, ["1v1s", Val]) ->
    cross_elite:cmd_score(list_to_integer(Val));


gm(_Player, ["jjcjl"]) ->
    arena_proc:reward(),
    cross_area:apply(cross_arena_proc, reward, []),
    ok;

gm(_Player, ["rxxl"]) ->
    cross_eliminate:set_eliminate_times(),
    ok;

gm(_Player, ["xxlf"]) ->
    cross_area:apply(cross_eliminate_proc, cmd_refresh, []),
    ok;


gm(_Player, ["xxljl"]) ->
    cross_area:apply(cross_eliminate_proc, week_reward, []),
    ok;

gm(Player, ["achieve", N]) ->
    achieve:cmd_achieve(Player, list_to_integer(N)),
    ok;
gm(_Player, ["achscore", N]) ->
    achieve:cmd_score(list_to_integer(N)),
    ok;

gm(_Player, ["mphoto", Mid, N]) ->
    mon_photo:cmd_kill(_Player, list_to_integer(Mid), list_to_integer(N)),
    ok;

gm(Player, ["signin", Day]) ->
    sign_in:cmd_sign_in(Player, list_to_integer(Day));

gm(_Player, ["rdunt"]) ->
    dungeon_tower:cmd_sweep_reset();

gm(_player, ["skillexp"]) ->
    skill:cmd_exp();

gm(Player, ["smelt", Exp]) ->
    smelt:cmd_smelt(Player, list_to_integer(Exp));

%%gm(_Player, ["ldzbm"]) ->
%%    manor_war_proc:cmd_apply(),
%%    ok;

gm(_Player, ["ldzks"]) ->
    manor_war_proc:cmd_start(),
    ok;

gm(_Player, ["ldzgb"]) ->
    manor_war_proc:cmd_close(),
    ok;

gm(Player, ["petall"]) ->
    pet_util:cmd_pet(Player);

gm(Player, ["pet", N]) ->
    PetId = list_to_integer(N),
    NewPlayer = pet_util:create_pet(Player, PetId, 0),
    {ok, NewPlayer};

gm(_Player, ["ksld"]) ->
    cross_all:apply(cross_scuffle_proc, cmd_start, []),
    ok;
gm(_Player, ["gbld"]) ->
    cross_all:apply(cross_scuffle_proc, cmd_close, []),
    ok;
gm(_Player, ["fdhy", Sec, Last]) ->
    active_proc:cmd_set(list_to_integer(Sec), list_to_integer(Last)),
    ok;

gm(_Player, ["ksldjy"]) ->
    cross_all:apply(cross_scuffle_elite_proc, cmd_start, []),
    ok;
gm(_Player, ["gbldjy"]) ->
    cross_all:apply(cross_scuffle_elite_proc, cmd_close, []),
    ok;

gm(_Player, ["ksjs"]) ->
    cross_all:apply(cross_scuffle_elite_proc, cmd_final_start, []),
    ok;
gm(_Player, ["csres"]) ->
    cross_all:apply(cross_scuffle_elite_war_team_ets, re_set, []),
    ok;
gm(_Player, ["gbjs"]) ->
    cross_all:apply(cross_scuffle_elite_proc, cmd_final_close, []),
    ok;
gm(_Player, ["jsnx"]) ->
    cross_all:apply(cross_scuffle_elite_proc, cmd_next_final_start, []),
    ok;
gm(_Player, ["cmdre"]) ->
    cross_all:apply(cross_scuffle_elite_proc, cmd_refresh, []),
    ok;
gm(_Player, ["sxsx"]) ->
    cross_all:apply(cross_scuffle_elite_proc, cmd_update_fight_record, []),
    ok;


%% cross_1vn
gm(_Player, ["ks1vn"]) ->
    cross_area:apply(cross_1vn_proc, cmd_start, []),
    ok;

%%------------------功能测试gm 可删除------------------

gm(Player, ["charge", NumStr]) ->
    Num = list_to_integer(NumStr),
    ?DEBUG("Num ~p~n", [Num]),

    TotalFee =
        case version:get_lan_config() of
            fanti -> Num;
            _ ->
                Num * 100
        end,
%%    Base1 = data_charge:get(90, Player#player.pf),
%%    Base2 = data_charge:get(91, Player#player.pf),
%%    Base3 = data_charge:get(100, Player#player.pf),
    IsMonthCard0 = 0,
%%    ?IF_ELSE(Num == Base1#base_charge.price, 1, 0),
    IsMonthCard = 0,
%%    ?IF_ELSE(Num == Base2#base_charge.price, 2, IsMonthCard0),
    IsBgift = 0,
%%    ?IF_ELSE(Num == Base3#base_charge.price, 100, IsMonthCard),
    Sql = io_lib:format("insert into recharge set user_id='~s',jh_order_id='2015031910588233785',app_order_id='b7b3111d-a69e-4b73-bb64-a435511b4a05',total_fee=~p,app_role_id = ~p, server_id = ~p, channel_id = ~p, state = 1, pay_result = 1,
        lv=~p,career=~p,nickname='~s',time=~p,goods_type=~p,total_gold=0,product_id=~p",
        [Player#player.accname, TotalFee, Player#player.key, Player#player.sn, Player#player.pf,
            Player#player.lv, Player#player.career, Player#player.nickname, util:unixtime(), IsBgift, IsBgift]),
    db:execute(Sql),
    self() ! 'recharge_notice',
    {ok, Player};

gm(Player, ["cg100"]) ->
    Base1 = data_charge:get(100, Player#player.pf),
    TotalFee = Base1#base_charge.price * 100,
    Sql = io_lib:format("insert into recharge set user_id='~s',jh_order_id='2015031910588233785',app_order_id='b7b3111d-a69e-4b73-bb64-a435511b4a05',total_fee=~p,app_role_id = ~p, server_id = ~p, channel_id = ~p, state = 1, pay_result = 1,
        lv=~p,career=~p,nickname='~s',time=~p,goods_type=~p,total_gold=0,product_id=~p",
        [Player#player.accname, TotalFee, Player#player.key, Player#player.sn, Player#player.pf,
            Player#player.lv, Player#player.career, Player#player.nickname, util:unixtime(), Base1#base_charge.price, 100]),
    db:execute(Sql),
    self() ! 'recharge_notice',
    {ok, Player};

gm(Player, ["cg101"]) ->
    Base1 = data_charge:get(101, Player#player.pf),
    TotalFee = Base1#base_charge.price * 100,
    Sql = io_lib:format("insert into recharge set user_id='~s',jh_order_id='2015031910588233785',app_order_id='b7b3111d-a69e-4b73-bb64-a435511b4a05',total_fee=~p,app_role_id = ~p, server_id = ~p, channel_id = ~p, state = 1, pay_result = 1,
        lv=~p,career=~p,nickname='~s',time=~p,goods_type=~p,total_gold=0,product_id=~p",
        [Player#player.accname, TotalFee, Player#player.key, Player#player.sn, Player#player.pf,
            Player#player.lv, Player#player.career, Player#player.nickname, util:unixtime(), Base1#base_charge.price, 101]),
    db:execute(Sql),
    self() ! 'recharge_notice',
    {ok, Player};
gm(Player, ["cg102"]) ->
    Base1 = data_charge:get(102, Player#player.pf),
    TotalFee = Base1#base_charge.price * 100,
    Sql = io_lib:format("insert into recharge set user_id='~s',jh_order_id='2015031910588233785',app_order_id='b7b3111d-a69e-4b73-bb64-a435511b4a05',total_fee=~p,app_role_id = ~p, server_id = ~p, channel_id = ~p, state = 1, pay_result = 1,
        lv=~p,career=~p,nickname='~s',time=~p,goods_type=~p,total_gold=0,product_id=~p",
        [Player#player.accname, TotalFee, Player#player.key, Player#player.sn, Player#player.pf,
            Player#player.lv, Player#player.career, Player#player.nickname, util:unixtime(), Base1#base_charge.price, 102]),
    db:execute(Sql),
    self() ! 'recharge_notice',
    {ok, Player};
gm(_Player, "chargereturn") ->
    charge:cmd_charge_return(),
    ok;

gm(_Player, ["fixhft"]) ->
    hotfix1:fix_hi_fan_tian(),
    ok;

gm(_Player, ["dvipt"]) ->
    dvip_rpc:handle(40409, _Player, {}),
    ok;

gm(_Player, ["dvto"]) ->
    NewPlayer = dvip:dvip_time_out(_Player),
    {ok, NewPlayer};

gm(Player, ["tz", NumStr]) ->
    Num = list_to_integer(NumStr),
    TotalFee = Num * 100,
    Base1 = data_charge:get(92, Player#player.pf),
    Base2 = data_charge:get(93, Player#player.pf),
    IsMonthCard0 = ?IF_ELSE(Num == Base1#base_charge.price, 3, 0),
    IsMonthCard = ?IF_ELSE(Num == Base2#base_charge.price, 4, IsMonthCard0),
    Sql = io_lib:format("insert into recharge set user_id='~s',jh_order_id='2015031910588233785',app_order_id='b7b3111d-a69e-4b73-bb64-a435511b4a05',total_fee=~p,app_role_id = ~p, server_id = ~p, channel_id = ~p, state = 1, pay_result = 1,
        lv=~p,career=~p,nickname='~s',time=~p,goods_type=~p,total_gold=0,product_id=~p",
        [Player#player.accname, TotalFee, Player#player.key, Player#player.sn, Player#player.pf,
            Player#player.lv, Player#player.career, Player#player.nickname, util:unixtime(), IsMonthCard, IsMonthCard]),
    db:execute(Sql),
    self() ! 'recharge_notice',
    {ok, Player};

gm(_Player, ["tznum", NumStr]) ->
    Num = list_to_integer(NumStr),
    g_forever:set_count(?G_FOREVER_TYPE_INVEST, Num),
    {ok, Bin} = pt_270:write(27003, {Num}),
    server_send:send_to_all(Bin),
    ok;

gm(_Player, ["ot", DayStr]) ->
    Day = list_to_integer(DayStr),
    {M, S, _} = erlang:timestamp(),
    Now = M * 1000000 + S,
    OpenTime = Now - max(0, (Day - 1)) * ?ONE_DAY_SECONDS,
    config:set_dyc_config_time(OpenTime),
    cross_all:apply(config, set_dyc_config_time, [OpenTime]),
    cross_area:apply(config, set_dyc_config_time, [OpenTime]),
    util:sleep(100),
    util:unixtime(),
    open_act_all_target:sys_midnight_refresh(),
    open_act_group_charge:sys_midnight_refresh(),
    open_act_back_buy:sys_midnight_refresh(),
    act_open_info:sys_midnight_refresh(),
    act_one_gold_buy:gm_sys_midnight_refresh(),
    activity:get_all_act_state(_Player),
    gm(_Player, ["ar"]),
    ok;

gm(Player, ["at", DayStr]) ->
    Day = list_to_integer(DayStr),
    timer:sleep(100),
    put(at_time, Day),
    util:sync_at_time(Day),
    cross_all:apply(util, sync_at_time, [Day]),
    cross_area:apply(util, sync_at_time, [Day]),
    util:sleep(100),
    put(tt_time, 0),
    util:unixtime(),
    spawn(fun() -> act_map:sys_midnight_refresh(1) end),
    spawn(fun() -> act_one_gold_buy:gm_sys_midnight_refresh() end),
    spawn(fun() -> festival_red_gift:gm_sys_midnight_refresh() end),
    gm(Player, ["midn"]),
    act_open_info:sys_midnight_refresh(),
    Time = util:unixtime(),
    {Date, _} = util:seconds_to_localtime(Time),
    Content = util:term_to_string(Date),
    Data = chat:pack_chat_data(Player, 1, Content, ""),
    {ok, Bin} = pt_110:write(11000, {Data}),
    server_send:send_to_all(Bin),
    Content1 = util:term_to_string(config:get_open_days()),
    Data1 = chat:pack_chat_data(Player, 1, Content1, ""),
    act_festive_boss:campaign_start(),
    {ok, Bin1} = pt_110:write(11000, {Data1}),
    server_send:send_to_all(Bin1),
    ok;


gm(Player, ["aat", DayStr]) ->
    Day = list_to_integer(DayStr),
    timer:sleep(100),
    put(aat_time, Day),
    put(tt_time, 0),
    util:unixtime(),
    spawn(fun() -> act_map:sys_midnight_refresh(1) end),
    gm(Player, ["midn"]),
    act_open_info:sys_midnight_refresh(),
    Time = util:unixtime(),
    {Date, _} = util:seconds_to_localtime(Time),
    Content = util:term_to_string(Date),
    Data = chat:pack_chat_data(Player, 1, Content, ""),
    {ok, Bin} = pt_110:write(11000, {Data}),
    server_send:send_to_all(Bin),
    Content1 = util:term_to_string(config:get_open_days()),
    Data1 = chat:pack_chat_data(Player, 1, Content1, ""),
    act_festive_boss:campaign_start(),
    {ok, Bin1} = pt_110:write(11000, {Data1}),
    server_send:send_to_all(Bin1),
    ok;

gm(Player, ["tt", DayStr]) ->
    Day = list_to_integer(DayStr),
    timer:sleep(100),
    put(tt_time, Day),
    Time = util:unixtime(),
    {Date, _} = util:seconds_to_localtime(Time),
    Content = util:term_to_string(Date),
    Data = chat:pack_chat_data(Player, 1, Content, ""),
    {ok, Bin} = pt_110:write(11000, {Data}),
    server_send:send_to_all(Bin),
    Content1 = util:term_to_string(config:get_open_days()),
    Data1 = chat:pack_chat_data(Player, 1, Content1, ""),
    act_festive_boss:campaign_start(),
    {ok, Bin1} = pt_110:write(11000, {Data1}),
    server_send:send_to_all(Bin1),
    ok;

gm(_Player, ["mergetimes", V]) ->
    cache:set(get_merge_times, list_to_integer(V)),
    gm(_Player, ["midn"]);

gm(_Player, ["mt", DayStr]) ->
    Day = list_to_integer(DayStr),
    g_forever:set_count(9999999, Day),
    gm(_Player, ["midn"]);

gm(Player, ["CsMid"]) ->
    cs_charge_d:sys_cacl(),
    {ok, Player};

gm(Player, ["JbpMid"]) ->
    act_jbp:gm_sys_back(),
    {ok, Player};

gm(Player, ["vip", N]) ->
    Exp = data_vip_args:get(0, list_to_integer(N)),
    NewPlayer = vip:add_vip_exp(Player, Exp),
    {ok, NewPlayer};

gm(Player, ["xh", N]) ->
    NewPlayer = money:add_xinghun(Player, list_to_integer(N)),
    {ok, NewPlayer};

gm(_Player, ["ar"]) ->
    P = activity_proc:get_act_pid(),
    P ! gm_act_rank_refresh,
    ok;
gm(_Player, ["arf"]) ->
    spawn(fun() ->
        P = activity_proc:get_act_pid(),
        P ! act_rank_refresh,
        timer:sleep(18000),
        P ! mignight_rank_handle
          end),
    ok;

gm(Player, ["cs"]) ->
    ?CAST(wish_tree:get_server_pid(), {cs_gm, Player}),
    ok;



gm(Player, ["allg"]) ->
    F = fun(GoodsId) ->
        case data_gift_bag:get(GoodsId) of
            [] -> skip;
            _ ->
                case catch goods:give_goods(Player, [#give_goods{goods_id = GoodsId, num = 1, bind = 0}]) of
                    {false, Res} -> io:format("#####give goods ~p~n", [{GoodsId, Res}]);
                    _ -> skip
                end
        end
        end,
    L = lists:seq(24001, 28000),
    lists:foreach(F, L),
    ok;

gm(_Player, ["rdune"]) ->
    dungeon_exp:midnight_refresh(util:unixtime()),
    ok;

gm(Player, ["gl"]) ->
    guild_util:cmd_set_login(Player),
    ok;

gm(_Player, ["dtstart"]) ->
    cross_area:apply(in_answer_proc, cmd_start, []),
    ok;

gm(_Player, ["dtclose"]) ->
    cross_area:apply(in_answer_proc, cmd_close, []),
    ok;

gm(_Player, ["sexp", N]) ->
    St = lib_dict:get(?PROC_STATUS_SWORD_POOL),
    sword_pool:add_exp(St, list_to_integer(N)),
    ok;


gm(Player, ["ttask", _Taskid]) ->
    task:cmd_trigger_task(Player, list_to_integer(_Taskid)),
    ok;
gm(Player, ["dtask", _Taskid]) ->
    task:cmd_del_task(Player#player.sid, list_to_integer(_Taskid)),
    ok;
gm(Player, ["ftask"]) ->
    task:cmd_finish_task(Player),
    ok;

%%gm(Player, ["2020"]) ->
%%    shadow:cmd_shadow(Player, Player#player.scene, Player#player.x, Player#player.y),
%%    ok;
gm(Player, ["shadow", Num, Type]) ->
    shadow:cmd_shadow(Player, list_to_integer(Num), list_to_integer(Type)),
    ok;
gm(Player, ["kshadow"]) ->
    Pids = mon_agent:get_scene_shadow_pids(Player#player.scene, Player#player.copy),
    [monster:stop_broadcast(Pid) || Pid <- Pids],
    ok;
gm(Player, ["arena"]) ->
    arena:cmd_arena(Player);
gm(_Player, ["jjcjl"]) ->
    arena_proc:get_server_pid() ! {arena_daily_reward, util:unixtime()},
    ok;
gm(_Player, ["kfjjcjl"]) ->
    cross_arena_proc:get_server_pid() ! {arena_daily_reward, util:unixtime()},
    ok;

gm(Player, ["arank", Rank]) ->
    arena_proc:cmd_rank(Player#player.key, list_to_integer(Rank)),
    ok;

gm(Player, ["jsxj"]) ->
    market_proc:cmd_sold_out(),
    ok;


gm(_player, ["rfboss"]) ->
    field_boss_proc:cmd_refresh(),
    ok;
gm(_player, ["wkboss"]) ->
    field_boss:week_rank_reward(),
    cross_area:apply(field_boss, week_rank_reward, []),
    ok;
gm(Player, ["flrpc", _Cmd]) ->
    Cmd = list_to_integer(_Cmd),
    field_boss_rpc:handle(Cmd, Player, {});
gm(_player, ["ryboss"]) ->
    field_boss_proc:get_server_pid() ! {ready_refresh, 20},
    ok;

gm(Player, ["scbp", _Cbp]) ->
    Cbp = list_to_integer(_Cbp),
    NewPlayer = Player#player{cbp = Cbp},
    player_load:dbup_player_state(NewPlayer),
    {ok, NewPlayer};

gm(_Player, ["kshs"]) ->
    convoy_proc:cmd_start(),
    ok;

gm(_Player, ["gbhs"]) ->
    convoy_proc:cmd_close(),
    ok;

gm(_Player, ["ksghz"]) ->
    guild_war_proc:cmd_start(),
    ok;
gm(_Player, ["gbghz"]) ->
    guild_war_proc:cmd_close(),
    ok;
gm(Player, ["tno"]) ->
    notice_sys:add_notice(convoy_rob, [Player, Player]),
    ok;

gm(_Player, ["midn"]) ->
    handle_midnight:handle(0, util:get_today_midnight()),
    cross_all:apply(handle_midnight, handle, [0, util:get_today_midnight()]),
    cross_area:apply(handle_midnight, handle, [0, util:get_today_midnight()]),
    ok;
gm(Player, ["cgt"]) ->
    chat:set_lim(Player#player.key, 60),
    ok;
gm(Player, ["alt"]) ->
    activity:get_all_act_state(Player),
    ok;
gm(Player, ["sid"]) ->
    io:format("~p~n~p~n", [hd(tuple_to_list(Player#player.sid)), erlang:process_info(hd(tuple_to_list(Player#player.sid)))]),
    ok;

gm(Player, ["xmsc"]) ->
    guild_manor:cmd_activate_retinue(Player);
%%--------luo----------------
gm(_Player, ["sxxh"]) ->
    cross_all:apply(cross_flower_proc, cmd_refresh, []),
    ok;
gm(_Player, ["lwing"]) ->
    Data = time_limit_wing:get_state(_Player),
    ok;
gm(Player, ["aabb"]) ->
%%     act_new_wealth_cat:get_info(Player),
%%     ?DEBUG("Player ~p~n", [Player#player.career]),
%%     ?DEBUG("Player ~p~n", [Player#player.new_career]),
%%     Q = baby:check_equip_state(Player),
%%     ?DEBUG("QQQQQ ~p~n", [Player#player.sex]),
%%     rank_rpc:handle(48001,Player,{10,1}),
    activity_rpc:handle(43194, Player, {}),
    ok;

gm(Player, ["sets", AA]) ->
    Day = list_to_integer(AA),
    put(test_state, Day),
    ok;

gm(Player, ["ac", AA]) ->
    Day = list_to_integer(AA),
    activity_rpc:handle(Day, Player, {}), ok;


gm(Player, ["43832", Id0]) ->
    Id = list_to_integer(Id0),
    activity_rpc:handle(43832, Player, {Id}), ok;

gm(Player, ["191"]) ->
    activity:get_notice(Player, [191], true)
    , ok;

gm(Player, ["196"]) ->
    activity:get_notice(Player, [196], true)
    , ok;



gm(Player, ["43195"]) ->
    activity_rpc:handle(43195, Player, {});
gm(Player, ["43943"]) ->
    activity_rpc:handle(43943, Player, {});
gm(Player, ["43196", Id]) ->
    Day = list_to_integer(Id),
    activity_rpc:handle(43196, Player, {Day});
gm(Player, ["16055", Id]) ->
    Day = list_to_integer(Id),
    activity_rpc:handle(43197, Player, {Day});


gm(_Player, ["crer"]) ->
    cross_all:apply(cross_flower_proc, end_reward, []),
    ok;
gm(_Player, ["sxjz"]) ->
    daily:set_count(812, 0),
    ok;
gm(Player, ["gf"]) ->
    equip_god_forging:equip_god_forging(Player, 300010000000118016),
    ok;
gm(Player, ["viptest"]) ->
    vip:vip_send_mail(),
    ok;
gm(Player, ["gmm"]) ->
    equip_rpc:handle(16029, Player, {300010000000123415}),
    ok;
gm(Player, ["16039"]) ->
    equip_rpc:handle(16039, Player, {3201000});

gm(Player, ["30044"]) ->
    ?DEBUG("Player ~p~n", [Player#player.new_career]),
    task_rpc:handle(30044, Player, {110001});

gm(Player, ["30043"]) ->
    ?DEBUG("Player ~p~n", [Player#player.new_career]),
    task_rpc:handle(30043, Player, {});

gm(Player, ["retask"]) ->
    lib_dict:put(?PROC_STATUS_TASK, #st_task{}),
    task_init:update_to_db(#st_task{}),
    task_init:init(Player),
    ?DEBUG("retask ok ~n"),
    ok;

gm(Player, ["53002"]) ->
    gift_rpc:handle(53002, Player, {1});
gm(Player, ["53003"]) ->
    gift_rpc:handle(53003, Player, {1});

gm(Player, ["16037"]) ->
    ?DEBUG("hhaa ~n"),
    Q = equip_rpc:handle(16037, Player, {300010000000123481, 1, 5101402}),
    ok;
gm(Player, ["1111"]) ->
    ?DEBUG("hhaa ~n"),
    Data = activity_rpc:handle(43190, Player, {}),
    ?DEBUG("data ~p~n", [Data]),
    ok;

gm(Player, ["2222", Rpc0]) ->
    Rpc = list_to_integer(Rpc0),
    ?DEBUG("Rpc ~p~n", [Rpc]),
    activity_rpc:handle(43191, Player, {Rpc});

gm(Player, ["gmr"]) ->
    equip_magic:gm_reset(),
    ok;
gm(Player, ["ggg"]) ->
    equip_soul:gm_get(),
    ok;
gm(Player, ["gmg"]) ->
    equip_magic:gm_get(),
    ok;

gm(Player, ["gsid"]) ->
    ?DEBUG("SID SID ~p~n", [Player#player.sid]),
    ok;
gm(Player, ["gcopy"]) ->
    ?DEBUG("Player ~p~n", [Player#player.copy]),
    ok;
gm(_Player, ["qcwc"]) ->
    act_wealth_cat:reset(),
    ok;

gm(Player, ["te", Rpc0, Type]) ->
    Rpc = list_to_integer(Rpc0),
    Id = list_to_integer(Type),
    activity_rpc:handle(Rpc, Player, {Id});

gm(Player, ["43288"]) ->
    activity_rpc:handle(43288, Player, {}),
    ok;
gm(Player, ["43939"]) ->
    activity_rpc:handle(43939, Player, {}),
    ok;
gm(Player, ["43940"]) ->
    activity_rpc:handle(43940, Player, {1}),
    ok;
gm(Player, ["28860"]) ->
    marry_rpc:handle(28860, Player, {}),
    ok;
gm(Player, ["43397"]) ->
    ?DEBUG("43397 ~n"),
    activity_rpc:handle(43397, Player, {}),
    ok;

gm(Player, ["43396"]) ->
    ?DEBUG("43396 ~n"),
    activity_rpc:handle(43396, Player, {2, 2});

gm(Player, ["43398"]) ->
    activity_rpc:handle(43398, Player, {68}),
    ok;
gm(Player, ["43282"]) ->
    activity:get_notice(Player, [113], true),
    {ok, Bin} = pt_432:write(43282, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

gm(Player, ["16050"]) ->
    equip_rpc:handle(16050, Player, {2601003, [[2602003, 3]]}),
    ok;

gm(Player, ["43505"]) ->
    activity_rpc:handle(43505, Player, {}),
    ok;

gm(Player, ["43507"]) ->
    fuwen_rpc:handle(43507, Player, {0, []}),
    ok;

gm(_Player, ["dgto"]) ->
    NowTime = util:unixtime(),
    dungeon_guard:midnight_refresh(NowTime + ?ONE_DAY_SECONDS),
    ok;

gm(Player, ["asas"]) ->
    {ok, money:add_sweet(Player, 10000)};

gm(Player, ["43275", Id0]) ->
    Id = list_to_integer(Id0),
    activity_rpc:handle(43275, Player, {Id}),
    ok;

gm(Player, ["42", Vip]) ->
    Id = list_to_integer(Vip),
    vip_rpc:handle(47002, Player, {Id}),
    ok;
gm(Player, ["44"]) ->
    ?DEBUG("snsns ~p~n", [Player#player.sn_cur]),
    ok;
gm(Player, ["45"]) ->
    vip_rpc:handle(47005, Player, {}),
    ok;

gm(Player, ["snsn"]) ->
    QQ = config:get_server_num(),
    ?DEBUG("QQQQQ ~p~n", [QQ]),
    ok;

gm(Player, ["gek"]) ->
    ?DEBUG("key  ~p~n", [Player#player.key]),
    ?DEBUG("key  ~p~n", [Player#player.key]),
    ?DEBUG("team_key  ~p~n", [Player#player.team_key]),
    ?DEBUG("copy   ~p~n", [Player#player.copy]),
    Mbs = team_util:get_team_mbs(Player#player.team_key),
    ?DEBUG("Mbs ~p~n", [Mbs]),
    ok;

gm(Player, ["gs"]) ->
    ?DEBUG("key  ~p~n", [Player#player.key]),
    ?DEBUG("team_key  ~p~n", [Player#player.team_key]),
    ?DEBUG("scene  ~p~n", [Player#player.scene]),
    ?DEBUG("copy   ~p~n", [Player#player.copy]),
    ok;



gm(Player, ["ksxy"]) ->
    marry_proc:cmd_start(),
    ok;

gm(Player, ["jsxy"]) ->
    marry_proc:cmd_end(),
    ok;

gm(Player, ["ksyx"]) ->
    party_proc:cmd_start(),
    ok;

gm(Player, ["jsyx"]) ->
    party_proc:cmd_close(),
    ok;




gm(Player, ["gsgs"]) ->
    ?DEBUG("scene ~p~n", [Player#player.scene]),
    ?DEBUG("copy ~p~n", [Player#player.copy]),
    ok;

gm(Player, ["24022"]) ->
    relation_rpc:handle(24022, Player, {10001, 1}),
    ok;
gm(Player, ["43268"]) ->
    activity_rpc:handle(43268, Player, {}),
    ok;

gm(Player, ["17006"]) ->

    ext = [{10101, 11}, {10101, 11}],

    mount_rpc:handle(17006, Player, {1, 1});


gm(Player, ["t", Key0]) ->
    Key = list_to_integer(Key0),
    team_rpc:handle(Key, Player, {});

gm(Player, ["24021"]) ->
    relation_rpc:handle(24021, Player, {300011085});

gm(Player, ["22006"]) ->
    team_rpc:handle(22006, Player, {1, 100000000223, 10015});

gm(Player, ["22012"]) ->
    team_rpc:handle(22012, Player, {0});

gm(Player, ["22002"]) ->
    team_rpc:handle(22002, Player, {});

gm(Player, ["22019"]) ->
    team_rpc:handle(22019, Player, {});

gm(Player, ["ggg"]) ->
    ?DEBUG("sd_pt ~p~n", [Player#player.sd_pt]),
    ?DEBUG("exploit_pri ~p~n", [Player#player.exploit_pri]),
    ?DEBUG("repute ~p~n", [Player#player.repute]),
    ?DEBUG("honor ~p~n", [Player#player.honor]),
    ok;

gm(Player, ["63001"]) ->
    grace_rpc:handle(63001, Player, {}),
    ok;

gm(Player, ["22003"]) ->
    team_rpc:handle(22003, Player, {}),
    ok;
gm(Player, ["22001"]) ->
    team_rpc:handle(22001, Player, {}),
    ok;

gm(Player, ["12005", SceneId]) ->
    SceneId0 = list_to_integer(SceneId),
    scene_rpc:handle(12005, Player, {SceneId0, 0});

gm(_Player, ["gexp"]) ->
    ?DEBUG(" get reward ~n"),
    Reward = exp_activity_proc:more_exp_reward(1, 50),
    ?DEBUG("Reward ~p~n", [Reward]),
    ok;

gm(Player, ["gs"]) ->
    ?DEBUG(" scene ~p~n", [Player#player.scene]),
    ok;

gm(_Player, ["rmexp"]) ->
    ?DEBUG(" reset exp ~n"),
    daily:set_count(805, 0),
    exp_activity_proc:cmd_reset(),
    ok;

gm(_Player, ["smexp"]) ->
    ?DEBUG(" start exp ~n"),

    exp_activity_proc:cmd_start(),
    ok;

gm(_Player, ["cmexp"]) ->
    ?DEBUG(" start exp ~n"),
    exp_activity_proc:cmd_close(),
    ok;

gm(Player, ["43267", Type, Time]) ->
    Type0 = list_to_integer(Type),
    Time0 = list_to_integer(Time),
    {ok, Bin} = pt_432:write(43267, {Type0, Time0}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

gm(Player, ["43268", Type, Time]) ->
    Type0 = list_to_integer(Type),
    Time0 = list_to_integer(Time),
    {ok, Bin} = pt_432:write(43268, {Type0, Time0, 10000, 2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

gm(Player, ["gcoin"]) ->
    HaveNum = goods_util:get_goods_count(10400),
    ?DEBUG("HaveNum ~p~n", [HaveNum]),
    ok;

gm(Player, ["show"]) ->
    ?DEBUG("~p~n", [Player#player.honor]),
    ?DEBUG("~p~n", [Player#player.repute]),
    vip_rpc:handle(47005, Player, {}),
    ok;

gm(Player, ["52000"]) ->
    day7login_rpc:handle(52000, Player, {}),
    ok;
gm(Player, ["52001", Day]) ->
    Id = list_to_integer(Day),
    day7login_rpc:handle(52001, Player, {Id}),
    ok;

gm(Player, ["38000", ShopType0]) ->
    ShopType = list_to_integer(ShopType0),
    new_shop_rpc:handle(38000, Player, {ShopType}),
    ok;

gm(Player, ["38001", ShopType0, Id0, BuyNum0]) ->
    ?DEBUG("38001GM~n"),
    ShopType = list_to_integer(ShopType0),
    Id = list_to_integer(Id0),
    BuyNum = list_to_integer(BuyNum0),
    new_shop_rpc:handle(38001, Player, {ShopType, Id, BuyNum}),
    ok;

%%--------luo----------------

gm(_Player, ["gmcr"]) ->
    consume_rank:gm_reward(),
    ok;
gm(_Player, ["gmgm11"]) ->
    ?DEBUG("gmgm ~n"),
    act_daily_task:gm(),
    ok;
gm(_Player, ["gmgm1"]) ->
    act_daily_task:gm1(),
    ok;
gm(Player, ["mmm"]) ->
    ?DEBUG("key ~p~n", [Player#player.key]),
    ?DEBUG("MID ~p~n", [Player#player.mount_id]),
    ok;
gm(Player, ["17038"]) ->
    mount_rpc:handle(17038, Player, {}),
    ok;
gm(_Player, ["gmrrr"]) ->
    recharge_rank:gm_reward(),
    ok;
gm(Player, ["43192"]) ->
    activity_rpc:handle(43192, Player, {});

gm(Player, ["43193"]) ->
    activity_rpc:handle(43193, Player, {});


gm(Player, ["43293"]) ->
    activity_rpc:handle(43293, Player, {});
gm(Player, ["43296"]) ->
    activity_rpc:handle(43296, Player, {});

gm(Player, ["43294", Sid]) ->
    Id = list_to_integer(Sid),
    activity_rpc:handle(43294, Player, {Id});

gm(Player, ["43295", Sid]) ->
    Id = list_to_integer(Sid),
    activity_rpc:handle(43295, Player, {Id});

gm(_Player, ["gmcrc"]) ->
    cross_all:apply(cross_consume_rank_proc, end_reward, []),
    ok;
gm(_Player, ["gmrrc"]) ->
    cross_all:apply(cross_recharge_rank_proc, end_reward, []),
    ok;
gm(_Player, ["gmacc"]) ->
    Base = area_consume_rank:get_act(),
    cross_all:apply(area_consume_rank_proc, end_reward, [Base]),
    ok;
gm(_Player, ["gmarc"]) ->
    Base = area_recharge_rank:get_act(),
    cross_all:apply(area_recharge_rank_proc, end_reward, [Base]),
    ok;

gm(_Player, ["rshop"]) ->
    handle_midnight:handle(0, 0),
    ok;
gm(_Player, ["sd1"]) ->
    activity_proc:get_act_pid() ! global_auto_del_buy_num,
    ok;
gm(_Player, ["olg"]) ->
    online_gift:get_gift(),
    ok;
gm(Player, ["vipout"]) ->
    NewPlayer = vip_init:update(Player),
    {ok, NewPlayer};
gm(_Player, ["wor"]) ->
    worship_proc:get_worship_pid() ! gm_refresh,
    ok;
gm(Player, ["svp"]) ->
    io:format("###svip ~p~n", [Player#player.vip_lv]),
    {ok, Player};
gm(Player, ["oexp"]) ->
    findback_exp:get_findback_exp_info(Player),
    ok;



gm(_Player, ["remine"]) ->
    cross_all:apply(cross_mining_util, gm_reset, []),
    ok;
gm(_Player, ["remeet"]) ->
    cross_all:apply(cross_mining_util, gm_reset1, []),
    ok;
gm(_Player, ["rethief"]) ->
    cross_all:apply(cross_mining_util, gm_reset2, []),
    ok;

gm(Player, ["actc"]) ->
    [act_content:get_act_content(Player, Id) || Id <- lists:seq(1, 13)],
    ok;
gm(Player, ["timer"]) ->
    NewPlayer = player_util:timer(Player, 300),
    {ok, NewPlayer};
gm(Player, ["gtt"]) ->
    [gm(Player, ["gift5"]) || _N <- lists:seq(1, 100)],
    ok;

gm(Player, ["fcmzx", N]) ->
    player_fcm:gm_set_online(Player, list_to_integer(N)),
    ok;
gm(Player, ["fcmzx", N]) ->
    player_fcm:gm_set_logout(Player, list_to_integer(N)),
    ok;
gm(_Player, ["mo", _Point]) ->
    put(gm_monopoly_point, util:to_integer(_Point)),
    ok;
gm(_Player, ["momid"]) ->
    put(gm_monopoly_momid, true),
    ok;
gm(_Player, ["grank"]) ->
    guild_rank:gm_reward(),
    ok;
gm(Player, ["40000"]) ->
    guild_rpc:handle(40000, Player, {"kkkk", 2}),
    ok;
gm(Player, ["40001"]) ->
    guild_rpc:handle(40001, Player, {"kkkk", 2}),
    ok;
gm(Player, ["40002"]) ->
    guild_rpc:handle(40002, Player, {}),
    ok;
gm(Player, ["40030"]) ->
    guild_rpc:handle(40030, Player, {}),
    ok;
gm(Player, ["40031"]) ->
    guild_rpc:handle(40031, Player, {0, 100}),
    ok;
gm(Player, ["cg", _Pro]) ->
    guild_rpc:handle(list_to_integer(_Pro), Player, {}),
    ok;

gm(Player, ["ap", _Pro]) ->
    activity_rpc:handle(list_to_integer(_Pro), Player, {}),
    ok;
gm(Player, ["fd1"]) ->
%%     findback_rpc:handle(38100, Player, []),
%%     findback_rpc:handle(38100, Player, {1}),
%%     findback_rpc:handle(38110, Player, []),
    Player#player.copy ! {time_to_next_round},
    ok;

%% cross_1vn
gm(_Player, ["ks1vn"]) -> %% 开始初赛
    cross_area:apply(cross_1vn_proc, cmd_start, []),
    ok;
gm(_Player, ["re1vn"]) -> %% 清空数据
    cross_area:apply(cross_1vn_proc, cmd_reset, []),
    ok;
gm(_Player, ["fs1vn"]) -> %% 开始决赛
    cross_area:apply(cross_1vn_proc, cmd_fstart, []),
    ok;
gm(_Player, ["mc1vn"]) -> %% 初赛下一轮
    cross_area:apply(cross_1vn_proc, cmd_match, []),
    ok;
gm(_Player, ["fm1vn"]) -> %% 决赛下一轮
    cross_area:apply(cross_1vn_proc, cmd_fmatch, []),
    ok;

gm(_Player, ["setfloor"]) -> %% 决赛下一轮
    cross_area:apply(cross_1vn_proc, cmd_setfloor, []),
    ok;


%%换场景
gm(Player, ["vn", Sid]) ->
    cross_1vn_rpc:handle(list_to_integer(Sid), Player, {});

%% cross_1vn
gm(Player, ["64200"]) ->
    cross_1vn_rpc:handle(64200, Player, {});
%% cross_1vn
gm(Player, ["64201"]) ->
    cross_1vn_rpc:handle(64201, Player, {});

%% cross_1vn
gm(Player, ["64202"]) ->
    cross_1vn_rpc:handle(64202, Player, {});

%% cross_1vn
gm(Player, ["64209"]) ->
    cross_1vn_rpc:handle(64209, Player, {1});

gm(Player, ["act515"]) ->
    activity:get_notice(Player, [51], true);

gm(_Player, ["mmon"]) ->
    mon_agent:create_mon([64400, 10003, 65, 24, 0, 1, [{return_pid, true}]]),
    ok;
%%换场景
gm(Player, ["gotom", Sid]) ->
    Id = list_to_integer(Sid),
    case data_scene:get(Id) of
        [] -> ok;
        Scene ->
            scene_rpc:handle(12005, Player, {Id, 0})
    end;

gm(Player, ["goto", Sid, X, Y]) ->
    Id = list_to_integer(Sid),
    X2 = list_to_integer(X),
    Y2 = list_to_integer(Y),
    case data_scene:get(Id) of
        [] -> ok;
        _Scene ->
            NewPlayer = scene_change:change_scene(Player, Id, 0, X2, Y2, false),
            {ok, NewPlayer}
    end;


gm(_Player, ["slopen"]) ->
    act_festive_boss:gm_open();

gm(_Player, ["RedOpen"]) ->
    festival_red_gift:gm_open();

%%召唤怪物
gm(Player, ["monm", Mid, Group]) ->
    Group2 = ?IF_ELSE(Group == "1", Player#player.key, list_to_integer(Group)),
    Mon = data_mon:get(util:to_integer(Mid)),
    %%mon_agent:create_mon_cast([util:to_integer(Mid), Player#player.scene, Player#player.x+1, Player#player.y+1, Player#player.copy, 1, [{group, Group2}]]),
    %mon_agent:create_mon_cast([util:to_integer(Mid), Player#player.scene, Mon#mon.x, Mon#mon.y, Player#player.copy, 1, [{group, Group2}]]);
    mon_agent:create_mon_cast([util:to_integer(Mid), Player#player.scene, Player#player.x, Player#player.y, Player#player.copy, 1, [{group, Group2}]]);


gm(Player, ["buff", Id]) ->
    NewPlayer = buff:add_buff_to_player(Player, list_to_integer(Id)),
    io:format("#####buff ~p~n", [Player#player.buff_list]),
    {ok, NewPlayer};
gm(Player, ["mail"]) ->
    mail:sys_send_mail([Player#player.key], "test", "test", [{11701, 10}]),
    ok;
gm(Player, ["mail", GoodsIdStr, NumStr]) ->
    GoodsId = list_to_integer(GoodsIdStr),
    case data_goods:get(GoodsId) of
        [] -> ok;
        _ ->
            mail:sys_send_mail([Player#player.key], "test", "test", [{GoodsId, list_to_integer(NumStr)}])
    end,
    ok;

%%藏宝阁
gm(_Player, ["TreasureHourseReset"]) ->
    treasure_hourse:gm(),
    ok;

gm(Player, ["ResetActMap"]) ->
    act_map:gm_reset(Player),
    ok;
gm(_Player, ["Map49"]) ->
    act_map:gm49(),
    ok;

%% 手动加剑池经验
gm(_Player, ["swordExp", ExpStr]) ->
    Exp = list_to_integer(ExpStr),
    sword_pool:gm_add_exp(Exp),
    ok;

%% 手动打印红点状态
gm(_Player, ["actStatus", IdStr]) ->
    Id = list_to_integer(IdStr),
    activity:gm_print(_Player, Id),
    ok;

%% 功能推送
gm(Player, ["tips", TipsId]) ->
    Id = list_to_integer(TipsId),
    tips:gm_tips(Player, Id),
    ok;

gm(_Player, ["tipsTimer"]) ->
    put(gm_tips_timer, 1),
    ok;

gm(_Player, ["openwh"]) ->
    kindom_guard_proc:rpc_open_kindom_guard(),
    ok;

gm(_Player, ["endwh"]) ->
    kindom_guard_proc:rpc_end_kindom_guard(),
    ok;

gm(Player, ["whmon"]) ->
    Res = mon_agent:get_scene_mon(Player#player.scene, Player#player.copy),
    io:format("###Res ~p~n", [Res]),
    ok;

gm(Player, ["ontime", NumStr]) ->
    online_time_gift:gm(list_to_integer(NumStr)),
    ok;

gm(Player, ["startsd"]) ->
    case config:is_center_node() of
        false ->
            cross_area:apply(chat_gm, gm, [Player, ["startsd"]]);
        true ->
            cross_six_dragon_proc:get_server_pid() ! {start, 1800}
    end,
    ok;

gm(Player, ["endsd"]) ->
    case config:is_center_node() of
        false ->
            cross_area:apply(chat_gm, gm, [Player, ["endsd"]]);
        true ->
            cross_six_dragon_proc:get_server_pid() ! time_to_end
    end,
    ok;

gm(Player, ["sdrpc", _NumStr]) ->
    Num = list_to_integer(_NumStr),
    cross_six_dragon_rpc:handle(Num, Player, []);
gm(_Player, ["allsd"]) ->
    handle_online:online_apply_state(cross_six_dragon, gm_all_match, []),
    ok;

gm(Player, ["startan"]) ->
    case config:is_center_node() of
        false ->
            cross_area:apply(chat_gm, gm, [Player, ["startan"]]);
        true ->
            answer_proc:get_server_pid() ! {open_answer, 900}
    end,
    ok;
gm(Player, ["endan"]) ->
    case config:is_center_node() of
        false ->
            cross_area:apply(chat_gm, gm, [Player, ["endan"]]);
        true ->
            answer_proc:get_server_pid() ! end_answer
    end,
    ok;
gm(Player, ["anrpc", _NumStr]) ->
    io:format("####answer ~p~n", [Player#player.scene]),
    Num = list_to_integer(_NumStr),
    case Num == 26005 of
        true -> answer_rpc:handle(Num, Player, {1});
        false -> answer_rpc:handle(Num, Player, [])
    end;

gm(_Player, ["starthw"]) ->
    cross_area:apply(hot_well_proc, cmd_start, []),
    ok;
gm(_Player, ["endhw"]) ->
    cross_area:apply(hot_well_proc, cmd_close, []),
    ok;
gm(Player, ["hwrpc", _Cmd]) ->
    hot_well_rpc:handle(list_to_integer(_Cmd), Player, []);

gm(Player, ["fly"]) ->
    Scene = data_scene:get(?SCENE_ID_MAIN),
    scene_rpc:handle(12047, Player, {Scene#scene.id, Scene#scene.x, Scene#scene.y});

gm(Player, ["rb"]) ->
    St = lib_dict:get(?PROC_STATUS_GOODS),
    {_, GoodsList} = goods_util:get_goods_list_by_goods_id(1011000, St#st_goods.dict),
    case GoodsList of
        [] -> ?ERR("have not red bag~n"), ok;
        [Goods | _] ->
            red_bag:use_red_bag_guild(Player, Goods#goods.goods_id),
            ok
    end,
    ok;

gm(Player, ["evil", Value]) ->
    NewPlayer = prison:gm_set_evil(Player, list_to_integer(Value)),
    {ok, NewPlayer};
gm(Player, ["kill", Value]) ->
    NewPlayer = prison:set_kill_count(Player, list_to_integer(Value)),
    {ok, NewPlayer};
gm(Player, ["chival", Value]) ->
    NewPlayer = prison:set_chivalry(Player, list_to_integer(Value)),
    {ok, NewPlayer};
gm(Player, ["pri", Value]) ->
    prison_rpc:handle(list_to_integer(Value), Player, {}),
    ok;

gm(Player, ["cgift"]) ->
    activity_rpc:handle(43060, Player, {"AAABBAAAABAB"}),
    ok;

gm(Player, ["rank1"]) ->
    [rank_rpc:handle(48001, Player, {Type, 1}) || Type <- lists:seq(1, 10)],
    ok;

gm(Player, ["rank2"]) ->
    L = rank:get_rank_top_N(1, 10),
    [rank_rpc:handle(48002, Player, {1, R#a_rank.pkey}) || R <- L],
    ok;
gm(Player, ["grng"]) ->
    task_guild:refresh_no_guild(Player),
    ok;

gm(_Player, ["mtask"]) ->
    manor_war_task:midnight_refresh(),
    ok;

gm(Player, ["fru", Cmd]) ->
    cross_fruit_rpc:handle(list_to_integer(Cmd), Player, []),
    ok;
gm(Player, ["fru1", _Type, _Pos]) ->
    cross_fruit_rpc:handle(58205, Player, {list_to_integer(_Type), list_to_integer(_Pos)}),
    ok;

gm(_Player, ["fuwenpos"]) ->
    fuwen:gm_pos(),
    ok;

gm(_Player, ["fuwenall"]) ->
    dungeon_fuwen_tower:gm_unlock(),
    ok;

gm(_Player, ["fuwentower", LayerStr, SubLayerStr]) ->
    Layer = list_to_integer(LayerStr),
    SubLayer = list_to_integer(SubLayerStr),
    dungeon_fuwen_tower:gm(Layer, SubLayer),
    ok;

gm(Player, ["12608" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["12609" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["12610" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["43383" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["43365" | _] = List) ->
    gm_cmd(Player, List);
gm(Player, ["43366" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["11013" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["43384" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["12611" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["44314" | _] = List) ->
    gm_cmd(Player, List);

gm(Player, ["MarryAnswer"] = List) ->
    dungeon_marry:gm(Player),
    ok;

gm(_Player, ["ActXian"]) ->
    cross_area:apply(act_limit_xian, gm_timer, []),
    ok;

gm(_Player, ["Shop", TimeStr]) ->
    Time = util:to_integer(TimeStr),
    mystery_shop:gm(Time),
    ok;

gm(_Player, ["GmOneCacl"]) ->
    act_one_gold_buy:gm_cacl(),
    ok;

gm(_Player, ["crossBossStart"]) ->
    cross_boss:gm_start(),
    ok;
gm(_Player, ["crossBossStop"]) ->
    cross_boss:gm_stop(),
    ok;
gm(_Player, ["crossBossBox"]) ->
    cross_boss:gm_box_mon(),
    ok;

gm(Player, ["43606" | _] = _List) ->
    marry_room_rpc:handle(43606, Player, {1, ?T("从今以后，我若眼中有你，我便弄瞎双眼！我若心中有你，我便毁掉自己！")}),
    ok;

gm(Player, ["43608" | _] = _List) ->
%%     marry_room_rpc:handle(43608, Player, {1, ?T("从今以后，我若眼中有你，我便弄瞎双眼！我若心中有你，我便毁掉自己！")}),
    marry_room_rpc:handle(43608, Player, {0, ?T("我在桃花树下等你！")}),
    ok;

gm(Player, ["GmDisplay"]) ->
    act_display:gm(Player),
    ok;

gm(_Player, ["GmKing"]) ->
    cross_war_gm:gm_king(_Player),
    ok;

gm(_Player, ["CrossWarMateris"]) ->
    cross_war_gm:gm_add_materis(_Player),
    ok;

gm(_Player, ["CrossWarScore", N]) ->
    cross_war_gm:gm_add_score(_Player, util:to_integer(N)),
    ok;

gm(_Player, ["CrossWarStart"]) ->
    cross_area:war_apply(cross_war_proc, gm_start, []),
    activity:get_notice(_Player, [143], true),
    ok;

gm(_Player, ["CrossWarStop"]) ->
    cross_area:war_apply(cross_war_proc, gm_stop, []),
    activity:get_notice(_Player, [143], true),
    ok;

gm(_Player, ["CrossReady"]) ->
    cross_war_gm:gm_ready(),
    activity:get_notice(_Player, [143], true),
    ok;

gm(_Player, ["CrossWarCar"]) ->
    cross_war_rpc:handle(60123, _Player, {2}),
    ok;

gm(_Player, ["CrossDay1"]) ->
    cross_war_gm:gm_day_1(),
    ok;


gm(_Player, ["convoy", NumStr]) ->
    Num = list_to_integer(NumStr),
    act_convoy:gm(Num),
    ok;

gm(Player, ["marry", PkeyStr]) ->
    Pkey = list_to_integer(PkeyStr),
    marry:gm_marry_answer(Player, 1, Pkey),
    ok;

gm(Player, ["divorce"]) ->
    marry:gm_divorce(Player),
    ok;

gm(_Player, ["cmdtest", _Cmd]) ->
    Cmd = list_to_integer(_Cmd),
    activity_rpc:handle(Cmd, _Player, {});
%%    fashion_suit_rpc:handle(Cmd, _Player, {1001});
%%    baby_rpc:handle(Cmd, _Player, {});

gm(_Player, ["cbaby"]) ->
    baby_util:gm_create();

gm(_Player, ["createbaby"]) ->
    baby_util:gm_create_baby(_Player),
    ok;

gm(_Player, ["babykill", _Inter]) ->
    KillNum = list_to_integer(_Inter),
    daily:set_count(?DAILY_BABY_KILL_TIMES, KillNum),
    ok;

gm(_Player, ["babylv", _Inter]) ->
    KillNum = list_to_integer(_Inter),
    baby_util:gm_set_baby_lv(KillNum),
    ok;

gm(_Player, ["fffff", _Inter]) ->
    KillNum = list_to_integer(_Inter),
    ?DEBUG("ffffff ~n"),
    mount_rpc:handle(17040, _Player, {1, KillNum});


gm(_Player, ["babyspeed"]) ->
    baby_rpc:handle(16319, _Player, {7305001});

gm(Player, ["pf", Pf]) ->
    {ok, Player#player{pf = util:to_integer(Pf)}};

gm(Player, ["getsc"]) ->
    ?DEBUG("Player ~p~n", [Player#player.scene]),
    ok;

gm(_Player, ["sync"]) ->
    chat:refresh_res(),
    ok;

gm(Player, ["godness"]) ->
    godness:add_godness(Player#player.key, 5002),
    ok;

gm(Player, ["addhi", HiNum]) ->
    HiNum2 = list_to_integer(HiNum),
    daily:set_count(?DAILY_HI_FAN_TIAN_POINT, HiNum2),
    ok;

gm(_Player, ["bossplz", V]) ->
    daily:set_count(?DAILY_FIELD_BOSS, list_to_integer(V)),
    ok;

gm(Player, ["13307" | _] = List) ->
    gm_cmd(Player, List);


gm(_Player, ["Gmedal", IdStr] = _List) ->
    guild_fight:gm_add_guild_medal(_Player#player.guild#st_guild.guild_key, list_to_integer(IdStr)),
    ok;



gm(_Player, ["petwar", IdStr] = _List) ->
    pet_war_dun:gm(list_to_integer(IdStr)),
    ok;

gm(_Player, ["ps", SkillIdStr] = _List) ->
    SkillId = list_to_integer(SkillIdStr),
    put(pet_battle_skill_id, SkillId),
    ok;

gm(Player, _Content) ->
    online_time_gift:get_state(Player),
    ?PRINT("bad gm cmd ~p~n", [_Content]),
    {ok, Player}.



gm_cmd(_Player, [CmdStr | List]) ->
    Cmd = util:string_to_term(CmdStr),
    {ok, true, _, RPC_module} = protomap:map(Cmd),
    F = fun(Msg) ->
        util:string_to_term(Msg)
        end,
    Data = lists:map(F, List),
    gen_server:cast(self(), {'SOCKET_EVENT', Cmd, RPC_module, list_to_tuple(Data)}),
    ok.



tttt(Fun, [_] = L) when is_function(Fun, 2) ->
    ?DEBUG("when ~n");
tttt(Fun, _) ->
    ?DEBUG("other ~n").


cmd_pos(SceneId) ->
    PlayerList = scene_agent:get_scene_player(SceneId),
    [P#scene_player.pid ! {cmd_position, P#scene_player.x, P#scene_player.y} || P <- PlayerList].

cmd_scene(Sid) ->
    case data_scene:get(Sid) of
        [] -> 0;
        Scene -> length(Scene#scene.mon)
    end.

clean_mail() ->
    db:execute("truncate mail"),

    F = fun(Online) ->
        Online#ets_online.pid ! reload_mail
        end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)),
    ok.


fix_login_days() ->
    Sql = io_lib:format("update player_login set login_days = ~p where logout_time > ~p ", [config:get_open_days(), util:unixdate() - ?ONE_DAY_SECONDS]),
    db:execute(Sql),
    F = fun(Online) ->
        Online#ets_online.pid ! login_days
        end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)),
    ok.


fix_task() ->
    F = fun(Online) ->
        Online#ets_online.pid ! fix_task
        end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)),
    ok.


do_fix_task(Player) ->
    ok.


task_ids() ->
    [200402, 200403, 200504, 200505, 200506, 200507, 200508].

cmd_cross_dun() ->
    F2 = fun({Mid, _, _}) ->
        Mon = data_mon:get(Mid),
        if Mon#mon.is_att_by_mon == 1 -> [];
            true -> [Mid]
        end
         end,
    F1 = fun({_, MonList}) ->
        lists:flatmap(F2, MonList)
         end,
    F = fun(DunId) ->
        Dungeon = data_dungeon:get(DunId),
        case lists:flatmap(F1, Dungeon#dungeon.mon) of
            [] -> ok;
            Ids ->
                ?ERR("dun ~p ids ~p~n", [DunId, util:list_filter_repeat(Ids)])
        end
        end,
    lists:foreach(F, data_dungeon_cross:dun_list()).

fix_midnight() ->
    F = fun(Online) ->
        Online#ets_online.pid ! fix_midnight
        end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)).

cmd_pet_pkey() ->
    SkillList = [4610301, 4620301, 4630301, 4610302, 4620302, 4630302, 4610303, 4620303, 4630303, 4610304, 4620304, 4630304, 4610305, 4620305, 4630305,
        4610306, 4620306, 4630306, 4610307, 4620307, 4630307, 4610308, 4620308, 4630308, 4610309, 4620309, 4630309, 4610310, 4620310, 4630310],
    Data = db:get_all("select pkey,skill from pet"),
    F = fun(Sid) ->
        F1 = fun([Pkey, Skill]) ->
            case lists:keymember(Sid, 2, util:bitstring_to_term(Skill)) of
                false -> [];
                true -> [Pkey]
            end
             end,
        case lists:flatmap(F1, Data) of
            [] -> [];
            L -> [{Sid, L}]
        end
        end,
    Ids = lists:flatmap(F, SkillList),
    ?ERR("Ids ~p~n", [Ids]),
    Ids.

cmd_out(Sid) ->
    F = fun(Online) ->
        Online#ets_online.pid ! {cmd_change_scene, Sid}
        end,
    lists:foreach(F, ets:tab2list(?ETS_ONLINE)),
    ok.


cmd_time() ->
    %% speed 30
    [{X, Y, _} | T] = marry_cruise:get_cruise_line(),
    F = fun({X1, Y1, _}, {TarX, TarY, Time}) ->
        Dis = abs(TarX - X1) * 60 + abs(TarY - Y1) * 30,
        Time1 = case Dis == 0 of
                    true -> 600;
                    false ->
                        round(Dis * 900 / 60)
                end,
        {X1, Y1, Time + Time1}
        end,
    lists:foldl(F, {X, Y, 0}, T).


cmd_reset_mon() ->
    F =
        fun(SceneId) ->
            MonList = mon_agent:get_scene_mon(SceneId, 0),
            ?DEBUG("scene ~p len ~p~n", [SceneId, length(MonList)]),
            [Mon#mon.pid ! {change_attr, [{type, 0}]} || Mon <- MonList]
        end,
    lists:foreach(F, data_cross_dark_scene_lv:ids()).


cmd_fix_lucky_turn() ->
    Sql0 = "select pkey,gkey,num from goods where origin = 536",
    Data = db:get_all(Sql0),


    F = fun([Pkey, Gkey, Num], L) ->
        case lists:keytake(Pkey, 1, L) of
            false -> [{Pkey, [{Gkey, Num}]} | L];
            {value, {_, KeyList}, T} ->
                [{Pkey, [{Gkey, Num} | KeyList]} | T]
        end
        end,

    F1 = fun({Pkey, GkeyList}) ->
        case player_util:get_player_pid(Pkey) of
            false -> skip;
            Pid ->
                Pid ! {fix_lucky_turn, GkeyList}
        end
         end,
    lists:foreach(F1, lists:foldl(F, [], Data)),
    Sql = " delete from goods where origin = 536 ",
    db:execute(Sql),

    ok.


log_lucky_turn() ->
    Sql = "SELECT pkey,goods,score  FROM `log_act_lucky_turn` WHERE `opera` = 3 and time > 1505404800",
    Data = db:execute(Sql),
    F = fun([Pkey, Goods, Score], L) ->
        case lists:keytake(Pkey, 1, L) of
            false ->
                [{Pkey, [{Score, util:bitstring_to_term(Goods)}]} | L];
            {value, {_, AccList}, L1} ->
                NewAccList = {Pkey, [{Score, util:bitstring_to_term(Goods)} | AccList]},
                [NewAccList | L1]
        end
        end,
    List = lists:foldl(F, [], Data),
    F1 = fun({Pkey, AccList}) ->
        fix_lucky_turn(Pkey, AccList)
         end,
    lists:foreach(F1, List),
    ok.


fix_lucky_turn(Pkey, List) ->
    F = fun({Score, GoodsList}, L) ->
        case lists:keytake(Score, 1, L) of
            false -> [{Score, GoodsList} | L];
            {value, {_, L1}, T} ->
                [{Pkey, L1}]
        end
        end,
    lists:foreach(F, [], List),
    ok.


check_gift() ->
    FileName = io_lib:format("../gift_check.txt", []),
    {ok, S} = file:open(FileName, write),

    F = fun(GiftId) ->
        Gift = data_gift_bag:get(GiftId),
        case check_must_get(Gift#base_gift.must_get, []) ++ check_rand_get(Gift#base_gift.career0 ++ Gift#base_gift.career1 ++ Gift#base_gift.career2, []) of
            [] -> ok;
            L ->
                io:format(S, "~w       ~w ~n", [GiftId, L])
        end
        end,
    lists:foreach(F, data_gift_bag:get_all()),
    file:close(S).

check_must_get([], UndefList) -> UndefList;
%%{0,10108,10000000,0}

check_must_get([{Career, GoodsId, InNum, Bind, ExpireTime} | T], UndefList) ->
    case data_goods:get(GoodsId) of
        [] ->
            check_must_get(T, [GoodsId | UndefList]);
        _ ->
            check_must_get(T, UndefList)
    end;
check_must_get([{_, GoodsId, _, _} | T], UndefList) ->
    case data_goods:get(GoodsId) of
        [] ->
            check_must_get(T, [GoodsId | UndefList]);
        _ ->
            check_must_get(T, UndefList)
    end.

check_rand_get([], UndefList) -> UndefList;
%%{2003000,10,1,10}
check_rand_get([{GoodsId, _, _, _} | T], UndefList) ->
    case data_goods:get(GoodsId) of
        [] ->
            check_rand_get(T, [GoodsId | UndefList]);
        _ ->
            check_rand_get(T, UndefList)
    end;
check_rand_get([{GoodsId, _, _, _, _} | T], UndefList) ->
    case data_goods:get(GoodsId) of
        [] ->
            check_rand_get(T, [GoodsId | UndefList]);
        _ ->
            check_rand_get(T, UndefList)
    end;
check_rand_get([Item | T], UndefList) ->
    check_rand_get(T, [Item | UndefList]).


hotfix_view() ->
    db:execute("delete from mount where stage = 0"),
    db:execute("delete from wing where stage = 0"),
    db:execute("delete from magic_weapon where stage = 0"),
    db:execute("delete from light_weapon where stage = 0"),
    db:execute("delete from pet_weapon where stage = 0"),
    db:execute("delete from footprint where stage = 0"),
    db:execute("delete from cat where stage = 0"),
    db:execute("delete from golden_body where stage = 0"),
    db:execute("delete from baby_mount where stage = 0"),
    db:execute("delete from baby_wing where stage = 0"),
    db:execute("delete from baby_weapon where stage = 0"),
    ok.


