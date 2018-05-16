%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 一月 2015 下午5:43
%%%-------------------------------------------------------------------
-module(player_rpc).
-author("fancy").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("team.hrl").
-include("relation.hrl").
-include("mount.hrl").
-include("light_weapon.hrl").
-include("wing.hrl").
%% API
-export([handle/3]).

handle(13001, Player, _) ->
    {ok, Bin} = pt_130:write(13001, player_pack:trans13001(Player)),
    server_send:send_priority_to_sid(Player#player.sid, Bin),
%%    server_send:send_to_sid(Player#player.sid, Bin),
    player_guide:get_guide_list(Player), %%玩家登陆，获取用户新手引导进度
    goods_attr_dan:get_goods_num_info(Player),
%%    ?DEBUG("data ~p/~p/~p~n",[Player#player.scene,Player#player.x,Player#player.y]),
    ok;

%%推送玩家数据
handle(13002, Player, _) ->
    NewPlayer1 = player_util:count_player_attribute(Player, true),
    {ok, NewPlayer1};

%%玩法数据
handle(13005, Player, _) ->
    List = lib_dict:get(?PROC_STATUS_PLAY_POINT),
    player_play_point:pack_play_point_list(List, Player#player.sid),
    ok;

%%战力评分
%%handle(13006, Player, _) ->
%%    Data = player_cbp_evaluated:cbp_evaluated(Player),
%%    {ok, Bin} = pt_130:write(13006, Data),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ok;
%%
%%%%分享跑分
%%handle(13007, Player, _) ->
%%    Ret = player_cbp_evaluated:share_evaluated(Player),
%%    {ok, Bin} = pt_130:write(13007, {Ret}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ok;

handle(13008, Player, _) ->
    player_guide:get_guide_list(Player),
    ok;

handle(13009, Player, {Key, Value}) ->
    player_guide:guide_updata(Player, Key, Value),
    {ok, Bin} = pt_130:write(13009, {1, Key}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取提示大厅信息
handle(13010, Player, _) ->
    tips:get_tips(Player, data_tips:login_tips()),
    ok;

%%查询某个玩家是否是自己的好友或者队友
handle(13011, Player, {Pkey}) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Mbs = team_util:get_team_mbs(Player#player.team_key),
    IsFriend = ?IF_ELSE(lists:keyfind(Pkey, #relation.pkey, RelationsSt#st_relation.friends) =/= false, 1, 0),
    case lists:keyfind(Pkey, #t_mb.pkey, Mbs) of
        false -> %%不是普通是队友，看看是否是副本队友
            ok;
        _ ->
            FPlayer = shadow_proc:get_shadow(Pkey),
            {ok, Bin} = pt_130:write(13011, {Pkey, IsFriend, 1, FPlayer#player.nickname, FPlayer#player.career, FPlayer#player.lv, FPlayer#player.cbp, FPlayer#player.sn, FPlayer#player.guild#st_guild.guild_name, FPlayer#player.sex, FPlayer#player.avatar}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%套装属性查询
%%handle(13012, Player, _) ->
%%    {StrengthLv, StoneLv, AllStar, PetClientStarList} = equip_util:get_suit_cliet_list(Player),
%%    {ok, Bin} = pt_130:write(13012, {StrengthLv, StoneLv, AllStar, PetClientStarList}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ok;

%%查看其他玩家属性
handle(13013, Player, {Sn, Pkey}) ->
    case player_util:is_cur_sn_player(Sn) of
        true ->
            player_view:view_attribute(Player, Sn, Pkey);
        false ->
            cross_all:apply(player_view, cross_view_attribute, [node(), Player#player.sid, Sn, Pkey]),
            ok
    end;

%%查看其它玩家形象
handle(13014, Player, {Sn, Pkey}) ->
    case player_util:is_cur_sn_player(Sn) of
        true ->
            player_view:view_model(Player, Sn, Pkey);
        false ->
            cross_all:apply(player_view, cross_view_model, [node(), Player#player.sid, Sn, Pkey])
    end,
    ok;

%%查看其它玩家的外观信息1坐骑,2仙羽3法宝,4神兵,5妖灵,6足迹
handle(13015, Player, {Pkey, Type}) ->
    Data =
        case Type of
            1 ->
                mount_pack:view_other(Pkey);
            2 ->
                wing_pack:view_other(Pkey);
            3 ->
                magic_weapon:view_other(Pkey);
            4 ->
                light_weapon:view_other(Pkey);
            5 ->
                pet_weapon:view_other(Pkey);
            6 ->
                footprint:view_other(Pkey);
            7 ->
                cat:view_other(Pkey);
            8 ->
                golden_body:view_other(Pkey);
            9 ->  %% 仙宝
                god_treasure:view_other(Pkey);
            10 -> %% 灵佩
                jade:view_other(Pkey);
            11 -> %% 灵羽
                baby_wing:view_other(Pkey);
            12 -> %% 灵骑
                baby_mount:view_other(Pkey);
            13 -> %% 灵弓
                baby_weapon:view_other(Pkey);
            _ ->
                {0, 0, [], [], [], 0, []}
        end,
    {ok, Bin} = pt_130:write(13015, list_to_tuple([Type | tuple_to_list(Data)])),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%查看属性丹使用数量
handle(13016, Player, _) ->
    goods_attr_dan:get_goods_num_info(Player),
    ok;

%%handle(13017, Player, _) ->
%%    StrenLv = equip_util:get_all_equip_stren_lv(),
%%    case data_suit_strengthen:get(StrenLv) of
%%        {first, QSAttr, MinStrLv} ->
%%            NStrLv = MinStrLv,
%%            CStrAttr = [],
%%            NStrAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- QSAttr];
%%        {QSAttr, 0} ->
%%            NStrLv = 0,
%%            CStrAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- QSAttr],
%%            NStrAttr = [];
%%        {QSAttr, NStrLv} ->
%%            {NsttrAttr, _} = data_suit_strengthen:get(NStrLv),
%%            CStrAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- QSAttr],
%%            NStrAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- NsttrAttr]
%%    end,
%%    {ok, Bin} = pt_130:write(13017, {StrenLv, NStrLv, CStrAttr, NStrAttr}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ok;

%%
handle(13018, _Player, {_Pkey, _Type}) ->
%%    {SelfCbp, SelfList} = player_attr_compare:self_attr(Type, Player),
%%    {OtherCbp, OtherList} = player_attr_compare:other_attr(Player, Type, Pkey),
%%    ?PRINT("SelfCbp ~p SelfList ~p ~n ~n OtherCbp ~p OtherList ~p ~n", [SelfCbp, SelfList, OtherCbp, OtherList]),
%%    {ok, Bin} = pt_130:write(13018, {SelfCbp, SelfList, OtherCbp, OtherList}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%设置头像
handle(13019, Player, {Url}) ->
    Player2 = Player#player{avatar = Url},
    player_load:dbup_player_avatar(Player#player.key, Url),
    {ok, Bin} = pt_130:write(13019, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    relation:up_friends_avatar(Player, Url),
    guild_util:update_avatar(Player#player.key, Url),
    marry_room:update_photo(Player),
    {ok, Player2};

%%改名
handle(13020, Player, {NewName, Type}) ->
    case player_util:change_name(Player, NewName, Type) of
        {false, Res} ->
            {ok, Bin} = pt_130:write(13020, {Res, Type}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_130:write(13020, {1, Type}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_130:write(13020, {1, Type}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, change_name, NewPlayer}
    end;

%%获取其他玩家的宠物信息
%%handle(13021, Player, {_Sn, Pkey, PetKey}) ->
%%    pet:get_other_player_pet_info(Player, Pkey, PetKey),
%%    ok;

%%%%查询强化套装属性
%%handle(13022, Player, {StrenLv}) ->
%%    case data_suit_strengthen:get(StrenLv) of
%%        {first, QSAttr, MinStrLv} ->
%%            NStrLv = MinStrLv,
%%            CStrAttr = [],
%%            NStrAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- QSAttr];
%%        {QSAttr, 0} ->
%%            NStrLv = 0,
%%            CStrAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- QSAttr],
%%            NStrAttr = [];
%%        {QSAttr, NStrLv} ->
%%            {NsttrAttr, _} = data_suit_strengthen:get(NStrLv),
%%            CStrAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- QSAttr],
%%            NStrAttr = [[attribute_util:attr_tans_client(K), V] || {K, V} <- NsttrAttr]
%%    end,
%%    {ok, Bin} = pt_130:write(13022, {StrenLv, NStrLv, CStrAttr, NStrAttr}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    ok;

%%转职
handle(13023, Player, {Career}) ->
    case catch player_util:transforme_carrer(Player, Career) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_130:write(13023, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            scene_agent_dispatch:equip_update(NewPlayer),
            scene_agent_dispatch:fashion_update(NewPlayer),
            scene_agent_dispatch:light_weapon_update(NewPlayer),
            {ok, NewPlayer};
        {false, Errorcode} ->
            {ok, Bin} = pt_130:write(13023, {Errorcode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _Other ->
            ?ERR("transforme_carrer error ~p ~n", [_Other]),
            {ok, Bin} = pt_130:write(13023, {0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%查询祝福CD列表
handle(13024, Player, {}) ->
    Data = player_bless:check_bless_list(Player, util:unixtime()),
    {ok, Bin} = pt_130:write(13024, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%变性
handle(13028, Player, {}) ->
    case player_util:change_sex(Player) of
        {false, Res} ->
            {ok, Bin} = pt_130:write(13028, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin);
        {ok, sex_update, NewPlayer} ->
            {ok, Bin} = pt_130:write(13028, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, sex_update, NewPlayer}
    end;

%%进入打坐
handle(13030, Player, {}) ->
    case scene:is_normal_scene(Player#player.scene) of
        false ->
            {ok, Bin} = pt_130:write(13030, {13}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            if Player#player.lv < 60 ->
                {ok, Bin} = pt_130:write(13030, {13}),
                server_send:send_to_sid(Player#player.sid, Bin),
                ok;
                true ->
                    {ok, Bin} = pt_130:write(13030, {1}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    NewPlayer = Player#player{sit_state = 1},
                    {ok, sit, NewPlayer}
            end
    end;

handle(13032, Player, {Id}) ->
    SnList = data_menu_open:get_lim_sn_list(Id),
    Sn = config:get_server_num(),
    Ret =
        case [true || {Min, Max} <- SnList, Min =< Sn, Sn =< Max] of
            [] -> 0;
            _ -> 1
        end,
    {ok, Bin} = pt_130:write(13032, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


handle(13033, Player, {}) ->
    F = fun({Id, Star}, {List, ActivationList}) ->
        case lists:keyfind(Id, 1, ActivationList) of
            false -> {[[Id, Star, []] | List], ActivationList};
            {Id, ActList} ->
                {[[Id, Star, ActList] | List], ActivationList}
        end
        end,

    Mount = mount_util:get_mount(),
    {StarList1, _} = lists:foldl(F, {[], Mount#st_mount.activation_list}, Mount#st_mount.star_list),

    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    {StarList2, _} = lists:foldl(F, {[], LightWeapon#st_light_weapon.activation_list}, LightWeapon#st_light_weapon.star_list),

    WingSt = lib_dict:get(?PROC_STATUS_WING),
    {StarList3, _} = lists:foldl(F, {[], WingSt#st_wing.activation_list}, WingSt#st_wing.star_list),
    ?DEBUG("StarList1 ~p~n", [StarList1]),
    ?DEBUG("StarList2 ~p~n", [StarList2]),
    ?DEBUG("StarList3 ~p~n", [StarList3]),
    Data = [[1, Mount#st_mount.current_image_id, StarList1], [2, LightWeapon#st_light_weapon.weapon_id, StarList2], [3, WingSt#st_wing.current_image_id, StarList3]],
    {ok, Bin} = pt_130:write(13033, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%查询付费礼包列表
handle(13035, Player, {}) ->
    Data = goods_util:check_gift(Player),
    {ok, Bin} = pt_130:write(13035, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(13036, Player, {Type}) ->
    case Player#player.sit_state of
        0 ->
            {ok, Bin} = pt_130:write(13036, {0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        1 ->
            Show = ?IF_ELSE(Type == 0, 0, 1),
            NewPlayer = Player#player{show_golden_body = Show},
            {ok, Bin} = pt_130:write(13036, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, sit, NewPlayer}
    end;

%%获取人物属性丹信息
handle(13037, Player, {}) ->
    Data = role_attr_dan:get_type_info(Player),
    {ok, Bin} = pt_130:write(13037, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取人物属性丹信息
handle(13038, Player, {GoodsId}) ->
    Data = role_attr_dan:get_goods_info(Player, GoodsId),
    {ok, Bin} = pt_130:write(13038, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%一键使用属性丹
handle(13039, Player, {Type}) ->
    {ok, NewPlayer} = role_attr_dan:use_attr_dan(Player, Type),
    {ok, Bin} = pt_130:write(13039, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%查看其它玩家子女信息
handle(13041, Player, {Sn, Pkey}) ->
    case player_util:is_cur_sn_player(Sn) of
        true ->
            player_view:view_baby_attribute(Player, Sn, Pkey);
        false ->
            cross_all:apply(player_view, cross_view_baby_attribute, [node(), Player#player.sid, Sn, Pkey]),
            ok
    end;


%% 获取玩家天命觉醒信息
handle(13042, Player, {}) ->
    Data = player_awake:get_info(Player),
%%     ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_130:write(13042, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 天命觉醒升级
handle(13043, Player, {}) ->
    {Res, NewPlayer} = player_awake:up_awake(Player),
    {ok, Bin} = pt_130:write(13043, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 天命觉醒升级
handle(13044, Player, {}) ->
    {Res, NewPlayer} = player_awake:up_type_awake(Player),
    {ok, Bin} = pt_130:write(13044, {Res, NewPlayer#player.new_career}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


handle(13046, Player, {_Name,CardId}) ->
    Ret = player_fcm:auth_identity(Player,CardId),
    {ok, Bin} = pt_130:write(13046, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%robot 通信
handle(13099, Player, {Type, Value}) ->
    Player2 =
        case config:is_debug() of
            true ->
                robot_act:act(Player, Type, Value);
            false ->
                Player
        end,
    {ok, Player2};

handle(_cmd, _Player, _Data) ->
    ok.
