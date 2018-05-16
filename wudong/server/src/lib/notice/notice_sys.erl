%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 处理所有的系统公告
%%% @end
%%% Created : 17. 十二月 2015 下午2:02
%%%-------------------------------------------------------------------
-module(notice_sys).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("pet.hrl").
-include("arena.hrl").
-include("mount.hrl").
-include("scene.hrl").
-include("cross_arena.hrl").

%% API
-export([
    add_notice/2
]).

add_notice(eq_stren, Args) -> %%装备强化
    [Player, NewGoods] = Args,
    case NewGoods#goods.stren >= 6 of
        true ->
            Content = io_lib:format(t_tv:get(219), [t_tv:pn(Player), t_tv:eq(NewGoods), NewGoods#goods.stren]),
            notice:add_sys_notice(Content, 219);
        false ->
            skip
    end;
add_notice(player_lv, Args) -> %%玩家升级
    [Player] = Args,
    case lists:member(Player#player.lv, [60, 68, 76, 84, 92, 100]) of
        true ->
            Content = io_lib:format(t_tv:get(2), [t_tv:pn(Player), Player#player.lv]),
            notice:add_sys_notice(Content, 2);
        false ->
            skip
    end;
add_notice(arena_challenge, Args) -> %%竞技场挑战
    [ArenaA, ArenaB] = Args,
    Shadow1 = shadow_proc:get_shadow(ArenaA#arena.pkey),
    Player1 = #player{
        key = ArenaA#arena.pkey,
        nickname = Shadow1#player.nickname,
        vip_lv = Shadow1#player.vip_lv
    },
    Player2 =
        if ArenaB#arena.type == ?ARENA_TYPE_ROBOT ->
            #player{
                key = ArenaB#arena.pkey,
                nickname = ArenaB#arena.nickname,
                vip_lv = ArenaB#arena.vip
            };
            true ->
                Shadow2 = shadow_proc:get_shadow(ArenaB#arena.pkey),
                #player{
                    key = ArenaB#arena.pkey,
                    nickname = Shadow2#player.nickname,
                    vip_lv = Shadow2#player.vip_lv
                }
        end,
    Content = io_lib:format(t_tv:get(3), [t_tv:pn(Player1), t_tv:pn(Player2)]),
    notice:add_sys_notice(Content, 3);
add_notice(cross_arena_challenge, Args) -> %%竞技场挑战
    [ArenaA, ArenaB] = Args,
    Player1 = #player{
        key = ArenaB#cross_arena.pkey,
        nickname = ArenaB#cross_arena.nickname
    },
    Player2 = #player{
        key = ArenaA#cross_arena.pkey,
        nickname = ArenaA#cross_arena.nickname
    },
    Content = io_lib:format(t_tv:get(189), [t_tv:pn(Player1), t_tv:pn(Player2)]),
    notice:add_sys_notice(Content, 189);
add_notice(wing, Args) -> %%翅膀
    [Player, FashionId] = Args,
    case lists:member(FashionId, data_notice:get(2)) of
        true ->
            Content = io_lib:format(t_tv:get(5), [t_tv:pn(Player), t_tv:wg(FashionId)]),
            notice:add_sys_notice(Content, 5);
        false ->
            skip
    end;
add_notice(market, Args) -> %%交易所
    [_Player, Goods] = Args,
    BaseGoods = data_goods:get(Goods#goods.goods_id),
    case BaseGoods#goods_type.color >= 3 of
        true ->
            Content = io_lib:format(t_tv:get(6), [t_tv:eq(Goods)]),
            notice:add_sys_notice(Content, 6);
        false ->
            skip
    end;
add_notice(dungeon_pass, Args) ->
    [Player, DunName, DunId] = Args,
    DunIdList = data_notice:get(3),
    case lists:member(DunId, DunIdList) of
        false -> skip;
        true ->
            Content = io_lib:format(t_tv:get(7), [t_tv:pn(Player), t_tv:cl(DunName, 4)]),
            notice:add_sys_notice(Content, 7)
    end;
add_notice(share_evaluated, Args) ->
    [Player, Point] = Args,
    Content = io_lib:format(t_tv:get(8), [t_tv:pn(Player), Point]),
    notice:add_sys_notice(Content, 8);

add_notice(convoy_start, _Args) ->
    notice:add_sys_notice(t_tv:get(9), 9);

add_notice(convoy_close, _Args) ->
    notice:add_sys_notice(t_tv:get(10), 10);

add_notice(drop, Args) ->
    [Player, MonName, SceneName, Goodstype] = Args,
    case lists:member(Goodstype#goods_type.goods_id, data_notice:get(1)) of
        true ->
            Content = io_lib:format(t_tv:get(11), [t_tv:pn(Player), t_tv:cl(SceneName, 4), t_tv:cl(MonName, 4), t_tv:cl(Goodstype#goods_type.goods_name, 4)]),
            notice:add_sys_notice(Content, 11);
        false ->
            skip
    end;

add_notice(vip_login, Args) ->
    case version:get_lan_config() of
        fanti -> skip;
        _ ->
            Player = Args,
            Content = io_lib:format(t_tv:get(12), [Player#player.vip_lv, t_tv:pn(Player)]),
            notice:add_sys_notice(Content, 12)
    end;

add_notice(first_charge, Args) ->
    Player = Args,
    Content = io_lib:format(t_tv:get(196), [t_tv:pn(Player)]),
    notice:add_sys_notice(Content, 196),
    ok;

add_notice(worship, Pkey) ->
    Sql1 = io_lib:format("select nickname,vip_lv from player_state where pkey=~s", [Pkey]),
    [Name1, VipLv1] = db:get_row(Sql1),
    Player = #player{
        key = Pkey,
        nickname = Name1,
        vip_lv = VipLv1
    },
    Msg = io_lib:format(t_tv:get(14), [t_tv:pn(Player)]),
    notice:add_sys_notice(Msg, 14),
    ok;


add_notice(fir_charge_return, _Player) ->
    %% 暂时屏蔽首充
    %% Content = io_lib:format(t_tv:get(15), [t_tv:pn(Player)]),
    %% notice:add_sys_notice(Content, 15),
    ok;

add_notice(vip_gift, Player) ->
    Content = io_lib:format(t_tv:get(16), [t_tv:pn(Player), Player#player.vip_lv]),
    notice:add_sys_notice(Content, 16);

add_notice(cross_dun_invite_notice, [Nickname, Key, DunId, Password, Type]) ->
    Msg = io_lib:format(t_tv:get(155), [Nickname, dungeon_util:get_dungeon_name(DunId), dungeon_util:get_dungeon_lv(DunId)]),
    Content = io_lib:format(<<"~s~s">>, [Msg, t_tv:dun_cross(?T("我要加入房间"), DunId, Key, Password, Type)]),
    notice:add_sys_notice(Content, 155);

add_notice(manor_war_ready, _Args) ->
    notice:add_sys_notice(t_tv:get(156), 156);
add_notice(manor_war_start, _Args) ->
    notice:add_sys_notice(t_tv:get(157), 157);

add_notice(manor_war_flag, [_Gkey, GuildName, Pkey, Nickname, Vip, Sid]) ->
    SceneName = scene:get_scene_name(Sid),
    Player = #player{
        key = Pkey,
        nickname = Nickname,
        vip_lv = Vip
    },
    Msg = io_lib:format(t_tv:get(158), [GuildName, t_tv:pn(Player), t_tv:cl(SceneName, 1), t_tv:cl(SceneName, 1)]),
    notice:add_sys_notice(Msg, 158);

add_notice(manor_war_finish, [_Gkey, GuildName, Sid]) ->
    SceneName = scene:get_scene_name(Sid),
    Msg = io_lib:format(t_tv:get(159), [GuildName, t_tv:cl(SceneName, 1)]),
    notice:add_sys_notice(Msg, 159);

add_notice(manor_war_boss_ready, [BossId, Sid, Time]) ->
    Msg = io_lib:format(t_tv:get(160), [t_tv:cl(mon_util:get_mon_name(BossId), 1), Time, t_tv:cl(scene:get_scene_name(Sid), 1)]),
    notice:add_sys_notice(Msg, 160);

add_notice(manor_war_boss, [BossId, Sid, X, Y]) ->
    Msg = io_lib:format(t_tv:get(161), [t_tv:cl(mon_util:get_mon_name(BossId), 1), t_tv:cl(scene:get_scene_name(Sid), 1), X, Y]),
    Content = io_lib:format(<<"~s~s">>, [Msg, t_tv:xy(Sid, X, Y, ?T("立即前往"))]),
    notice:add_sys_notice(Content, 161);

add_notice(manor_war_boss_kill, [BossId, Gkey, GuildName, Pkey, Nickname, Vip, Sid]) ->
    Player = #player{
        key = Pkey,
        nickname = Nickname,
        vip_lv = Vip
    },
    Msg = io_lib:format(t_tv:get(162), [t_tv:cl(mon_util:get_mon_name(BossId), 1), t_tv:guild(Gkey, GuildName), t_tv:pn(Player), t_tv:cl(scene:get_scene_name(Sid), 1), t_tv:guild(Gkey, GuildName)]),
    notice:add_sys_notice(Msg, 162);


add_notice(kindom_guard_open, _Args) ->
    Msg = io_lib:format(t_tv:get(163), []),
    notice:add_sys_notice(Msg, 163);
add_notice(kindom_guard_ready, _Args) ->
    Msg = io_lib:format(t_tv:get(164), []),
    notice:add_sys_notice(Msg, 164);

add_notice(kindom_kill_boss, [Pname, Mname, Sid, Copy]) ->
    Msg = io_lib:format(t_tv:get(165), [Pname, Mname]),
    notice:add_sys_notice_scene_copy(Msg, 165, Sid, Copy);

add_notice(cross_guard_kill_boss, [Pname, Mname, Sid, Copy]) ->
    Msg = io_lib:format(t_tv:get(286), [Pname, Mname]),
    notice:add_sys_notice_scene_copy(Msg, 286, Sid, Copy);

add_notice(redbag_guild, [Player, Key]) ->
    Msg = io_lib:format(t_tv:get(166), [t_tv:pn(Player), Key]),
    notice:add_sys_notice(Msg, 166);

add_notice(prison, [Player]) ->
    Msg = io_lib:format(t_tv:get(167), [Player#player.nickname]),
    SCENE = data_scene:get(?SCENE_ID_PRISON),
    Msg1 = io_lib:format(<<"~s~s">>, [Msg, t_tv:xy(?SCENE_ID_PRISON, SCENE#scene.x, SCENE#scene.y, ?T("【前往围观行刑官鞭打他】"))]),
    notice:add_sys_notice(Msg1, 167);

add_notice(prision_mon_kill, [Player, Name]) ->
    Msg = io_lib:format(t_tv:get(168), [t_tv:pn(Player), Name]),
    SCENE = data_scene:get(?SCENE_ID_PRISON),
    Msg1 = io_lib:format(<<"~s~s">>, [Msg, t_tv:xy(?SCENE_ID_PRISON, SCENE#scene.x, SCENE#scene.y, ?T("【前往围观TA】"))]),
    notice:add_sys_notice(Msg1, 168);


add_notice(cross_battlefield_ready, []) ->
    Msg = io_lib:format(t_tv:get(190), []),
    notice:add_sys_notice(Msg, 190);

add_notice(cross_battlefield_start, []) ->
    Msg = io_lib:format(t_tv:get(191), []),
    notice:add_sys_notice(Msg, 191);

add_notice(cross_bf_combo1, [Nickname, Combo]) ->
    Msg = io_lib:format(t_tv:get(169), [Nickname, Combo]),
    notice:add_sys_notice(Msg, 169);

add_notice(cross_bf_combo2, [Nickname, Combo]) ->
    Msg = io_lib:format(t_tv:get(170), [Nickname, Combo]),
    notice:add_sys_notice(Msg, 170);

add_notice(cross_bf_box_ready, _Args) ->
    notice:add_sys_notice(t_tv:get(171), 171);

add_notice(cross_bf_box, _Args) ->
    notice:add_sys_notice(t_tv:get(172), 172);
add_notice(cross_bf_box_collect, _Args) ->
    notice:add_sys_notice(t_tv:get(173), 173);

add_notice(cross_bf_box_ready1, [Min]) ->
    Msg = io_lib:format(t_tv:get(174), [Min]),
    notice:add_sys_notice(Msg, 174);

add_notice(cross_bf_box1, _Args) ->
    notice:add_sys_notice(t_tv:get(175), 175);

add_notice(manor_war_party, [Pkey, Nickname, Vip, SceneId, X, Y]) ->
    Player = #player{
        key = Pkey,
        nickname = Nickname,
        vip_lv = Vip
    },
    Msg = io_lib:format(t_tv:get(177), [t_tv:pn(Player), t_tv:cl(scene:get_scene_name(SceneId), 1)]),
    Content = io_lib:format(<<"~s~s">>, [Msg, t_tv:xy(SceneId, X, Y, ?T("立即前往"))]),
    notice:add_sys_notice(Content, 177);

add_notice(answer, [Name]) ->
    Msg = io_lib:format(t_tv:get(178), [t_tv:cl(Name, 4)]),
    notice:add_sys_notice(Msg, 178);

add_notice(six_dragon_ready, []) ->
    Msg = io_lib:format(t_tv:get(179), []),
    notice:add_sys_notice(Msg, 179);

add_notice(six_dragon_open, []) ->
    Msg = io_lib:format(t_tv:get(180), []),
    notice:add_sys_notice(Msg, 180);

add_notice(answer_ready, []) ->
    Msg = io_lib:format(t_tv:get(181), []),
    notice:add_sys_notice(Msg, 181);

add_notice(answer_open, []) ->
    Msg = io_lib:format(t_tv:get(182), []),
    notice:add_sys_notice(Msg, 182);

add_notice(more_exp_activity_open_before, _Args) ->
    Msg = io_lib:format(t_tv:get(185), []),
    notice:add_sys_notice(Msg, 185);
add_notice(more_exp_activity_open, _Args) ->
    Msg = io_lib:format(t_tv:get(186), []),
    notice:add_sys_notice(Msg, 186);

add_notice(red_bag, [Player, RedBagkey]) ->
    Msg = io_lib:format(t_tv:get(188), [t_tv:pn(Player), RedBagkey]),
    notice:add_sys_notice(Msg, 188);

add_notice(red_bag_marry, [Player, Couple, RedBagKey]) ->
    Msg = io_lib:format(t_tv:get(226), [t_tv:pn(Player), t_tv:pn(Couple), RedBagKey]),
    notice:add_sys_notice(Msg, 226);

add_notice(marry_roll, [Type, Key, Name, Pkey, Nickname]) ->
    P1 = #player{key = Key, nickname = Name},
    P2 = #player{key = Pkey, nickname = Nickname},
    case Type of
        3 ->
            Msg = io_lib:format(t_tv:get(231), [t_tv:pn(P2), t_tv:pn(P1)]),
            notice:add_sys_notice(Msg, 231);
        _ ->
            Msg = io_lib:format(t_tv:get(232), [t_tv:pn(P2), t_tv:pn(P1)]),
            notice:add_sys_notice(Msg, 232)
    end,
    ok;

add_notice(convoy_help, [Player]) ->
    Name = case Player#player.convoy_state of
               1 -> ?T("沉鱼");
               2 -> ?T("落雁");
               3 -> ?T("闭月");
               _4 -> ?T("羞花")
           end,

    Content = io_lib:format(t_tv:get(176), [t_tv:pn(Player), Name, Player#player.key]),
    notice:add_sys_notice_guild(Content, 176, Player#player.guild#st_guild.guild_key);

add_notice(convoy_rob, [P1, P2]) ->
    Msg = io_lib:format(t_tv:get(195), [t_tv:pn(P1), t_tv:pn(P2)]),
    notice:add_sys_notice(Msg, 195);

add_notice(guild_manor_task, [Gkey, Name]) ->
    Msg = io_lib:format(t_tv:get(192), [t_tv:cl(Name, 1)]),
    notice:add_sys_notice_guild(Msg, 192, Gkey);


add_notice(cross_elite_ready, []) ->
    notice:add_sys_notice(t_tv:get(193), 193);

add_notice(cross_elite_start, []) ->
    notice:add_sys_notice(t_tv:get(194), 194);

add_notice(player_view, [Player, Type, Stage]) ->
    if Stage < 3 -> ok;
        true ->
            case Type of
                1 ->%%坐骑
                    Content = io_lib:format(t_tv:get(197), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 197);
                2 ->%%仙羽
                    Content = io_lib:format(t_tv:get(198), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 198);
                3 ->%%法宝
                    Content = io_lib:format(t_tv:get(200), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 200);
                4 ->%%神兵
                    Content = io_lib:format(t_tv:get(199), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 199);
                5 ->%%妖灵
                    Content = io_lib:format(t_tv:get(201), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 201);
                6 ->%%足迹
                    Content = io_lib:format(t_tv:get(202), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 202);
                7 ->%%灵猫
                    Content = io_lib:format(t_tv:get(222), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 222);
                8 ->
                    Content = io_lib:format(t_tv:get(225), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 225);
                9 ->
                    Content = io_lib:format(t_tv:get(251), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 251);
                12 ->
                    Content = io_lib:format(t_tv:get(287), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 287);
                13 ->
                    Content = io_lib:format(t_tv:get(288), [t_tv:pn(Player), Stage]),
                    notice:add_sys_notice(Content, 288);
                _ -> ok
            end
    end;
%%乱斗
add_notice(cross_scuffle_ready, []) ->
    notice:add_sys_notice(t_tv:get(203), 203);

add_notice(cross_scuffle_start, []) ->
    notice:add_sys_notice(t_tv:get(204), 204);


%%乱斗精英
add_notice(cross_scuffle_elite_ready, []) ->
    notice:add_sys_notice(t_tv:get(275), 275);

add_notice(cross_scuffle_elite_start, []) ->
    notice:add_sys_notice(t_tv:get(276), 276);

%%乱斗精英
add_notice(cross_scuffle_elite_final_ready, []) ->
    notice:add_sys_notice(t_tv:get(277), 277);

add_notice(cross_scuffle_elite_final_start, []) ->
    notice:add_sys_notice(t_tv:get(278), 278);

add_notice(cross_scuffle_elite_final_first, [Sn, WarTeamName, MeName]) ->
    Content = io_lib:format(t_tv:get(279), [Sn, WarTeamName, MeName]),
    notice:add_sys_notice(Content, 279);

add_notice(cross_scuffle_elite_stage_notice, [Sn, NameStr, Circle]) ->
    Content = io_lib:format(t_tv:get(280), [Sn, NameStr, Circle]),
    notice:add_sys_notice(Content, 280);

add_notice(cross_scuffle_elite_party, [Str, StrNext]) ->
    Content = io_lib:format(t_tv:get(283), [Str, StrNext, Str]),
    notice:add_sys_notice(Content, 283);

add_notice(cross_scuffle_elite_party_final, [Str]) ->
    Content = io_lib:format(t_tv:get(285), [Str, Str]),
    notice:add_sys_notice(Content, 285);

add_notice(cross_1vn_ratio_change, [Sn, NameStr, Rtio, Id]) ->
    Content = io_lib:format(t_tv:get(Id), [Sn, NameStr, util:to_list(Rtio)]),
    notice:add_sys_notice(Content, Id);


add_notice(notice_meet_start,[]) ->
    notice:add_sys_notice(t_tv:get(309), 309);

add_notice(notice_meet_end, [PName, Type, Page, Id, GoodsList]) ->
    {GoodsId, _GoodsNum} = hd(GoodsList),
    Content = io_lib:format(t_tv:get(310), [?IF_ELSE(PName == [], ?T("无人"), PName), t_tv:gn(GoodsId), Type, Page, Id]),
    notice:add_sys_notice(Content, 310);

add_notice(notice_thief_start, []) ->
    notice:add_sys_notice(t_tv:get(311), 311);


add_notice(notice_thief_end, [PName, Type, Page, Id]) ->
    Content = io_lib:format(t_tv:get(312), [?IF_ELSE(PName == [], ?T("无人"), PName), Type, Page, Id]),
    notice:add_sys_notice(Content, 312);

%% 投资计划
add_notice(act_invest, Player) ->
    Msg = io_lib:format(t_tv:get(207), [t_tv:pn(Player)]),
    notice:add_sys_notice(Msg, 207);
add_notice(field_boss_roll, [Pname]) ->
    Content = io_lib:format(t_tv:get(205), [t_tv:cl(Pname, 1)]),
    notice:add_sys_notice(Content, 205),
    ok;

add_notice(join_guild, [PlayerName, GuildName]) ->
    Content = io_lib:format(t_tv:get(208), [t_tv:cl(PlayerName, 1), t_tv:cl(GuildName, 1)]),
    notice:add_sys_notice(Content, 208),
    ok;

add_notice(exit_guild, [PlayerName, GuildName, Gkey]) ->
    Content = io_lib:format(t_tv:get(209), [t_tv:cl(PlayerName, 1), t_tv:cl(GuildName, 1)]),
    notice:add_sys_notice_guild(Content, 209, Gkey),
    ok;

%% 跨服boss
add_notice(cross_player_kill, [AttKey, AttSn, AttSnName, AttGName, AttPos, AttName, DefKey, DefSn, DefSnName, DefGuildName, DefPos, DefName, Layer]) ->
    Msg = io_lib:format(t_tv:get(220), [t_tv:cl(AttSn, 11), t_tv:cl(AttSnName, 11), t_tv:cl(AttGName, 1), AttPos, t_tv:pn(#player{key = AttKey, nickname = AttName}), t_tv:cl(DefSn, 11), t_tv:cl(DefSnName, 11), t_tv:cl(DefGuildName, 1), DefPos, t_tv:pn(#player{nickname = DefName, key = DefKey})]),
    notice:add_sys_notice_scene(Msg, 220, cross_boss:get_scene_id_by_layer(Layer));

%% 跨服boss
add_notice(cross_boss_kill, [Sn, SnName, MonName, GName, Layer]) ->
    Msg = io_lib:format(t_tv:get(221), [t_tv:cl(Sn, 11), t_tv:cl(SnName, 11), t_tv:cl(GName, 1), t_tv:cl(MonName, 11)]),
    notice:add_sys_notice_scene(Msg, 221, cross_boss:get_scene_id_by_layer(Layer));

add_notice(marry_room, [NickName, Desc, Args]) ->
    Msg = io_lib:format(t_tv:get(229), [NickName, Desc, Args]),
    notice:add_sys_notice(Msg, 229);

add_notice(marry, [Boy, Girl, Count]) ->
    Msg = io_lib:format(t_tv:get(228), [t_tv:pn(Boy), t_tv:pn(Girl), Count]),
    notice:add_sys_notice(Msg, 228),
    ok;

add_notice(divorce, [P1, P2]) ->
    Msg = io_lib:format(t_tv:get(233), [t_tv:pn(P1), t_tv:pn(P2)]),
    notice:add_sys_notice(Msg, 233),
    ok;

add_notice(weeding_cruise, [Boy, Girl]) ->
    Msg = io_lib:format(t_tv:get(227), [t_tv:pn(Boy), t_tv:pn(Girl)]),
    notice:add_sys_notice(Msg, 227),
    ok;

add_notice(party, [Player, Desc]) ->
    Msg = io_lib:format(t_tv:get(234), [t_tv:pn(Player), Desc]),
    notice:add_sys_notice(Msg, 234),
    ok;

%% buff 值
add_notice(cross_dark_bribe_buff, [SName, BuffVal, _Sid]) ->
    Msg = io_lib:format(t_tv:get(235), [t_tv:cl(SName, 11), BuffVal]),
    notice:add_sys_notice(Msg, 235);

%% 击杀数量
add_notice(cross_dark_bribe_kill_num, [SName, PName, KillNum]) ->
    Msg = io_lib:format(t_tv:get(236), [t_tv:cl(SName, 11), t_tv:cl(PName, 1), KillNum]),
    notice:add_sys_notice(Msg, 236);

%% 占领值
add_notice(cross_dark_bribe_t_val, [SName, PName, KillNum]) ->
    Msg = io_lib:format(t_tv:get(237), [t_tv:cl(SName, 11), t_tv:cl(PName, 1), KillNum]),
    notice:add_sys_notice(Msg, 237);

%% 攻城战准备
add_notice(cross_war_ready, _) ->
    Msg = io_lib:format(t_tv:get(238), []),
    notice:add_sys_notice(Msg, 238);

%% 攻城战开始
add_notice(cross_war_start, _) ->
    Msg = io_lib:format(t_tv:get(239), []),
    notice:add_sys_notice(Msg, 239);

add_notice(cross_war_new_king, [SnName, GuildName]) ->
    Msg = io_lib:format(t_tv:get(240), [SnName, GuildName]),
    notice:add_sys_notice_scene(Msg, 240, ?SCENE_ID_CROSS_WAR);

add_notice(cross_war_guard_success, [SnName, GuildName]) ->
    Msg = io_lib:format(t_tv:get(241), [SnName, GuildName]),
    notice:add_sys_notice_scene(Msg, 241, ?SCENE_ID_CROSS_WAR);

add_notice(cross_war_new_king_2, [SnName, GuildName]) ->
    Msg = io_lib:format(t_tv:get(242), [SnName, GuildName]),
    notice:add_sys_notice(Msg, 242);

add_notice(end_kill_acc_win, [AttSignName, AttNickName, DefSignName, DefNickName, AccKillNum]) ->
    Msg = io_lib:format(t_tv:get(243), [AttSignName, AttNickName, DefSignName, DefNickName, AccKillNum]),
    notice:add_sys_notice_scene(Msg, 243, ?SCENE_ID_CROSS_WAR);

add_notice(kill_acc_win, [AttSignName, AttNickName, AccKillNum]) ->
    Msg = io_lib:format(t_tv:get(244), [AttSignName, AttNickName, AccKillNum]),
    notice:add_sys_notice_scene(Msg, 244, ?SCENE_ID_CROSS_WAR);

add_notice(cross_war_kill_banner, _) ->
    Msg = io_lib:format(t_tv:get(245), []),
    notice:add_sys_notice_scene(Msg, 245, ?SCENE_ID_CROSS_WAR);

add_notice(kill_acc_win_2, [AttSignName, AttNickName, AccKillNum]) ->
    Msg = io_lib:format(t_tv:get(246), [AttSignName, AttNickName, AccKillNum]),
    notice:add_sys_notice_scene(Msg, 246, ?SCENE_ID_CROSS_WAR);

add_notice(cross_war_kill_king_door, _) ->
    Msg = io_lib:format(t_tv:get(247), []),
    notice:add_sys_notice_scene(Msg, 247, ?SCENE_ID_CROSS_WAR);

add_notice(cross_war_kill_door_1, _) ->
    Msg = io_lib:format(t_tv:get(248), []),
    notice:add_sys_notice_scene(Msg, 248, ?SCENE_ID_CROSS_WAR);

add_notice(cross_war_kill_door_2, _) ->
    Msg = io_lib:format(t_tv:get(249), []),
    notice:add_sys_notice_scene(Msg, 249, ?SCENE_ID_CROSS_WAR);

add_notice(act_lucky_turn, [SN, NickNiame, GoodsNum, AddMoney, LeftGold]) ->
    Msg = io_lib:format(t_tv:get(258), [SN, NickNiame, GoodsNum, AddMoney, LeftGold]),
    notice:add_sys_notice(Msg, 258);

add_notice(marry_room_love_desc, [Player, LoveDesc, Args]) ->
    Msg = io_lib:format(t_tv:get(264), [t_tv:pn(Player), LoveDesc, Args]),
    notice:add_sys_notice(Msg, 264);

add_notice(act_local_lucky_turn, [_SN, NickNiame, GoodsNum, AddMoney, LeftGold]) ->
    Msg = io_lib:format(t_tv:get(265), [NickNiame, GoodsNum, AddMoney, LeftGold]),
    notice:add_sys_notice(Msg, 265);

add_notice(open_gift_bag, [Player, GiftId, GoodsId, Num]) ->
    Msg = io_lib:format(t_tv:get(266), [t_tv:pn(Player), t_tv:gn(GiftId), t_tv:gn(GoodsId), Num]),
    notice:add_sys_notice(Msg, 266);

add_notice(limit_time_buy, [Player, CostGold, Desc]) ->
    Msg = io_lib:format(t_tv:get(267), [t_tv:pn(Player), CostGold, ?T(Desc)]),
    notice:add_sys_notice(Msg, 267);

add_notice(buy_d_vip, [Player]) ->
    Msg = io_lib:format(t_tv:get(268), [t_tv:pn(Player)]),
    notice:add_sys_notice(Msg, 268);

add_notice(festival_red_gift, [Score, RedBagkey]) ->
    Msg = io_lib:format(t_tv:get(270), [Score, RedBagkey, RedBagkey]),
    notice:add_sys_notice(Msg, 270);

add_notice(act_festive_boss, [_Msg]) ->
    Msg2 = io_lib:format(t_tv:get(272), [_Msg]),
    notice:add_sys_notice(Msg2, 272);

add_notice(act_festive_boss_last_kill, [AttName, SceneName, MonName, GoodsId]) ->
    Msg2 = io_lib:format(t_tv:get(273), [AttName, SceneName, MonName, t_tv:gn(GoodsId)]),
    notice:add_sys_notice(Msg2, 273);

add_notice(act_cs_charge_d, [NickName, GoodsName]) ->
    Msg2 = io_lib:format(t_tv:get(281), [NickName, GoodsName]),
    notice:add_sys_notice(Msg2, 281);

add_notice(act_jbp, [NickName, GoodsNum, GoodsName]) ->
    Msg2 = io_lib:format(t_tv:get(282), [NickName, GoodsNum, GoodsName]),
    notice:add_sys_notice(Msg2, 282);

add_notice(act_limit_xian, [NickName, GoodsId]) ->
    #goods_type{goods_name = GoodsName} = data_goods:get(GoodsId),
    Msg2 = io_lib:format(t_tv:get(284), [NickName, GoodsName]),
    notice:add_sys_notice(Msg2, 284);

add_notice(act_limit_pet, [NickName, GoodsId]) ->
    #goods_type{goods_name = GoodsName} = data_goods:get(GoodsId),
    Msg2 = io_lib:format(t_tv:get(290), [NickName, GoodsName]),
    notice:add_sys_notice(Msg2, 290);

add_notice(act_small_charge_d, [NickName, GoodsName]) ->
    Msg2 = io_lib:format(t_tv:get(289), [NickName, GoodsName]),
    notice:add_sys_notice(Msg2, 289);

add_notice(magic_face, [PName1, PName2, GoodsName]) ->
    Msg2 = io_lib:format(t_tv:get(297), [PName1, PName2, GoodsName]),
    notice:add_sys_notice(Msg2, 297);

add_notice(guild_answer_start, _Args) ->
    notice:add_sys_notice(t_tv:get(303), 303);

add_notice(guild_answer_close, _Args) ->
    notice:add_sys_notice(t_tv:get(304), 304);

add_notice(att_guild_fight, [Name, Gkey]) ->
    Msg2 = io_lib:format(t_tv:get(305), [Name]),
    notice:add_sys_notice_guild(Msg2, 305, Gkey);

add_notice(def_guild_fight, [Name, Gkey]) ->
    Msg2 = io_lib:format(t_tv:get(306), [Name]),
    notice:add_sys_notice_guild(Msg2, 306, Gkey);

add_notice(Type, Args) ->
    ?ERR("bad add_notice handle ~p~n", [{Type, Args}]),
    ok.