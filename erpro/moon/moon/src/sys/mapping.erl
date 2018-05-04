%%----------------------------------------------------
%% 协议处理映射表
%% (当服务端成功解包消息时，将解包后的数据交由此表中对应的模块处理)
%% @author yeahoo2000@gmail.com
%% @end
%----------------------------------------------------
-module(mapping).
-export([module/2]).

%% @spec module(Type, Cmd) -> {ok, NeedAuth, Caller, Proto, ModName} | {ok, Proto, ModName} | {error, Reason}
%% Tyep = atom()
%% Cmd = int()
%% NeedAuth = bool()
%% Caller = connector | object
%% Proto = atom()
%% ModName = atom()
%% Reason = int()
%% @doc 模块映射信息
%% <ul>
%% <li>Tyep: 模块类型game_server | monitor | tester</li>
%% <li>Cmd: 命令号，约定有效范围:100~65500，模块号有效范围:1~655</li>
%% <li>NeedAuth: 调用时是否需要先通过验证</li>
%% <li>Caller: 指定调用发起者</li>
%% <li>Proto: 协议解析模块</li>
%% <li>ModName: 模块名</li>
%% <li>Reason: 返回出错的模块编号</li>
%% </ul>
module(Type, Cmd)       -> code(Type, trunc(Cmd / 100)).

%% 游戏服务器协议映射
code(game_server, 10)   -> {ok, false,  connector,  proto_10,   client_rpc_open};
code(game_server, 11)   -> {ok, true,   connector,  proto_11,   client_rpc_game};
code(game_server, 80)   -> {ok, false,  connector,  proto_80,   monitor_rpc};
code(game_server, 99)   -> {ok, true,   object,     proto_99,   role_adm_rpc};
code(game_server, 100)  -> {ok, true,   object,     proto_100,  role_rpc};
code(game_server, 101)  -> {ok, true,   object,     proto_101,  map_rpc};
code(game_server, 102)  -> {ok, true,   object,     proto_102,  task_rpc};
code(game_server, 103)  -> {ok, true,   object,     proto_103,  item_rpc};
code(game_server, 104)  -> {ok, true,   object,     proto_104,  buff_rpc};
code(game_server, 105)  -> {ok, true,   object,     proto_105,  blacksmith_rpc};
code(game_server, 106)  -> {ok, true,   object,     proto_106,  story_rpc};
code(game_server, 107)  -> {ok, true,   object,     proto_107,  combat_rpc};
code(game_server, 108)  -> {ok, true,   object,     proto_108,  team_rpc};
code(game_server, 109)  -> {ok, true,   object,     proto_109,  chat_rpc};
code(game_server, 110)  -> {ok, true,   object,     proto_110,  rank_rpc};
code(game_server, 111)  -> {ok, true,   object,     proto_111,  notice_rpc};
code(game_server, 112)  -> {ok, true,   object,     proto_112,  exchange_rpc};
code(game_server, 113)  -> {ok, true,   object,     proto_113,  market_rpc};
code(game_server, 115)  -> {ok, true,   object,     proto_115,  skill_rpc};
code(game_server, 116)  -> {ok, true,   object,     proto_116,  sit_rpc};
code(game_server, 117)  -> {ok, true,   object,     proto_117,  mail_rpc};
code(game_server, 118)  -> {ok, true,   object,     proto_118,  npc_rpc};
code(game_server, 119)  -> {ok, true,   object,     proto_119,  npc_store_rpc};
code(game_server, 120)  -> {ok, true,   object,     proto_120,  shop_rpc};
code(game_server, 121)  -> {ok, true,   object,     proto_121,  sns_rpc};
code(game_server, 123)  -> {ok, true,   object,     proto_123,  collect_rpc};
code(game_server, 124)  -> {ok, true,   object,     proto_124,  vip_rpc};
code(game_server, 125)  -> {ok, true,   object,     proto_125,  mount_rpc};
code(game_server, 126)  -> {ok, true,   object,     proto_126,  pet_rpc};
code(game_server, 127)  -> {ok, true,   object,     proto_127,  guild_rpc};
code(game_server, 128)  -> {ok, true,   object,     proto_128,  boss_rpc};
code(game_server, 129)  -> {ok, true,   object,     proto_129,  channel_rpc};
code(game_server, 130)  -> {ok, true,   object,     proto_130,  achievement_rpc};
code(game_server, 131)  -> {ok, true,   object,     proto_131,  escort_rpc};
code(game_server, 132)  -> {ok, true,   object,     proto_132,  hook_rpc};
code(game_server, 133)  -> {ok, true,   object,     proto_133,  arena_rpc};
code(game_server, 134)  -> {ok, true,   object,     proto_134,  fcm_rpc};
code(game_server, 135)  -> {ok, true,   object,     proto_135,  dungeon_rpc};
code(game_server, 136)  -> {ok, true,   object,     proto_136,  tree_rpc};
code(game_server, 137)  -> {ok, true,   object,     proto_137,  guild_refresh_rpc};
code(game_server, 138)  -> {ok, true,   object,     proto_138,  activity_rpc};
code(game_server, 139)  -> {ok, true,   object,     proto_139,  offline_exp_rpc};
code(game_server, 140)  -> {ok, true,   object,     proto_140,  award_rpc};
code(game_server, 141)  -> {ok, true,   object,     proto_141,  setting_rpc};
code(game_server, 142)  -> {ok, true,   object,     proto_142,  casino_rpc};
code(game_server, 144)  -> {ok, true,   object,     proto_144,  wish_rpc};
code(game_server, 145)  -> {ok, true,   object,     proto_145,  gm_rpc};
code(game_server, 146)  -> {ok, true,   object,     proto_146,  guild_war_rpc};
code(game_server, 147)  -> {ok, true,   object,     proto_147,  lottery_rpc};
code(game_server, 148)  -> {ok, true,   object,     proto_148,  jail_rpc};
code(game_server, 149)  -> {ok, true,   object,     proto_149,  guild_td_rpc};
code(game_server, 150)  -> {ok, true,   object,     proto_150,  wanted_rpc};
code(game_server, 151)  -> {ok, true,   object,     proto_151,  guild_practise_rpc};
code(game_server, 154)  -> {ok, true,   object,     proto_154,  guard_rpc};
code(game_server, 155)  -> {ok, true,   object,     proto_155,  wedding_rpc};
code(game_server, 156)  -> {ok, true,   object,     proto_156,  npc_employ_rpc};
code(game_server, 158)  -> {ok, true,   object,     proto_158,  campaign_rpc};
code(game_server, 159)  -> {ok, true,   object,     proto_159,  guild_arena_rpc};
code(game_server, 160)  -> {ok, true,   object,     proto_160,  world_compete_rpc};
code(game_server, 161)  -> {ok, true,   object,     proto_161,  arena_career_rpc};
code(game_server, 162)  -> {ok, true,   object,     proto_162,  compete_rpc};
code(game_server, 163)  -> {ok, true,   object,     proto_163,  sworn_rpc};
code(game_server, 165)  -> {ok, true,   object,     proto_165,  hall_rpc};
code(game_server, 166)  -> {ok, true,   object,     proto_166,  practice_rpc};
code(game_server, 167)  -> {ok, true,   object,     proto_167,  wing_rpc};
code(game_server, 168)  -> {ok, true,   object,     proto_168,  cross_boss_rpc};
code(game_server, 169)  -> {ok, true,   object,     proto_169,  cross_pk_rpc};
code(game_server, 170)  -> {ok, true,   object,     proto_170,  cross_king_rpc};
code(game_server, 172)  -> {ok, true,   object,     proto_172,  demon_rpc};
code(game_server, 173)  -> {ok, true,   object,     proto_173,  top_fight_rpc};
code(game_server, 174)  -> {ok, true,   object,     proto_174,  rank_cross_rpc};
code(game_server, 175)  -> {ok, true,   object,     proto_175,  guild_boss_rpc};
code(game_server, 177)  -> {ok, true,   object,     proto_177,  fate_rpc};
code(game_server, 178)  -> {ok, true,   object,     proto_178,  cross_ore_rpc};
code(game_server, 179)  -> {ok, true,   object,     proto_179,  soul_world_rpc};
code(game_server, 181)  -> {ok, true,   object,     proto_181,  cross_warlord_rpc};
code(game_server, 183)  -> {ok, true,   object,     proto_183,  trip_rpc};
code(game_server, 184)  -> {ok, true,   object,     proto_184,  wine_rpc};
code(game_server, 188)  -> {ok, true,   object,     proto_188,  talisman_rpc};
code(game_server, 189)  -> {ok, true,   object,     proto_189,  train_rpc};
code(game_server, 194)  -> {ok, true,   object,     proto_194,  looks_rpc};
code(game_server, 195)  -> {ok, true,   object,     proto_195,  manor_rpc};
code(game_server, 196)  -> {ok, true,   object,     proto_196,  energy_rpc};
code(game_server, 197)  -> {ok, true,   object,     proto_197,  seven_day_award_rpc};
code(game_server, 198)  -> {ok, true,   object,     proto_198,  combat2_rpc};
code(game_server, 199)  -> {ok, true,   object,     proto_199,  charge};

%% 监控服务器协议映射
code(monitor, 10)       -> {ok, proto_10, mon_rpc};
code(monitor, 80)       -> {ok, proto_80, mon_rpc};

%% 测试器协议映射
code(tester, 10)        -> {ok, proto_10, test_client_rpc_open};
code(tester, 11)        -> {ok, proto_11, test_client_rpc_game};
code(tester, 99)        -> {ok, proto_99, test_role_adm_rpc};
code(tester, 100)       -> {ok, proto_100, test_role_rpc};
code(tester, 101)       -> {ok, proto_101, test_map_rpc};
code(tester, 102)       -> {ok, proto_102, test_task_rpc};
code(tester, 103)       -> {ok, proto_103, test_item_rpc};
code(tester, 104)       -> {ok, proto_104, test_buff_rpc};
code(tester, 105)       -> {ok, proto_105, test_blacksmith_rpc};
code(tester, 107)       -> {ok, proto_107, test_combat_rpc};
code(tester, 108)       -> {ok, proto_108, test_team_rpc};
code(tester, 109)       -> {ok, proto_109, test_chat_rpc};
code(tester, 110)       -> {ok, proto_110, test_rank_rpc};
code(tester, 111)       -> {ok, proto_111, test_notice_rpc};
code(tester, 112)       -> {ok, proto_112, test_exchange_rpc};
code(tester, 113)       -> {ok, proto_113, test_market_rpc};
code(tester, 115)       -> {ok, proto_115, test_skill_rpc};
code(tester, 116)       -> {ok, proto_116, test_sit_rpc};
code(tester, 117)       -> {ok, proto_117, test_mail_rpc};
code(tester, 118)       -> {ok, proto_118, test_npc_rpc};
code(tester, 119)       -> {ok, proto_119, test_npc_store_rpc};
code(tester, 120)       -> {ok, proto_120, test_shop_rpc};
code(tester, 121)       -> {ok, proto_121, test_sns_rpc};
code(tester, 122)       -> {ok, proto_122, test_drop_rpc};
code(tester, 123)       -> {ok, proto_123, test_collect_rpc};
code(tester, 124)       -> {ok, proto_124, test_vip_rpc};
code(tester, 125)       -> {ok, proto_125, test_mount_rpc};
code(tester, 126)       -> {ok, proto_126, test_pet_rpc};
code(tester, 127)       -> {ok, proto_127, test_guild_rpc};
code(tester, 128)       -> {ok, proto_128, test_boss_rpc};
code(tester, 129)       -> {ok, proto_129, test_channel_rpc};
code(tester, 130)       -> {ok, proto_130, test_achievement_rpc};
code(tester, 131)       -> {ok, proto_131, test_escort_rpc};
code(tester, 132)       -> {ok, proto_132, test_hook_rpc};
code(tester, 133)       -> {ok, proto_133, test_arena_rpc};
code(tester, 134)       -> {ok, proto_134, test_fcm_rpc};
code(tester, 135)       -> {ok, proto_135, test_dungeon_rpc};
code(tester, 136)       -> {ok, proto_136, test_disciple_rpc};
code(tester, 137)       -> {ok, proto_137, test_guild_refresh_rpc};
code(tester, 138)       -> {ok, proto_138, test_activity_rpc};
code(tester, 139)       -> {ok, proto_139, test_offline_exp_rpc};
code(tester, 140)       -> {ok, proto_140, test_award_rpc};
code(tester, 141)       -> {ok, proto_141, test_setting_rpc};
code(tester, 142)       -> {ok, proto_142, test_casino_rpc};
code(tester, 144)       -> {ok, proto_144, test_wish_rpc};
code(tester, 145)       -> {ok, proto_145, test_gm_rpc};
code(tester, 146)       -> {ok, proto_146, test_guild_war_rpc};
code(tester, 147)       -> {ok, proto_147, test_lottery_rpc};
code(tester, 149)       -> {ok, proto_149, test_guild_td_rpc};
code(tester, 150)       -> {ok, proto_150, test_wanted_rpc};
code(tester, 151)       -> {ok, proto_151, test_guild_practise_rpc};
code(tester, 154)       -> {ok, proto_154, test_guard_rpc};
code(tester, 155)       -> {ok, proto_155, test_wedding_rpc};
code(tester, 156)       -> {ok, proto_156, test_npc_employ_rpc};
code(tester, 158)       -> {ok, proto_158, test_campaign_rpc};
code(tester, 159)       -> {ok, proto_159, test_guild_arena_rpc};
code(tester, 160)       -> {ok, proto_160, test_world_compete_rpc};
code(tester, 161)       -> {ok, proto_161, test_arena_career_rpc};
code(tester, 163)       -> {ok, proto_163, test_sworn_rpc};
code(tester, 165)       -> {ok, proto_165, test_hall_rpc};
code(tester, 166)       -> {ok, proto_166, test_practice_rpc};
code(tester, 167)       -> {ok, proto_167, test_wing_rpc};
code(tester, 168)       -> {ok, proto_168, test_cross_boss_rpc};
code(tester, 169)       -> {ok, proto_169, test_cross_pk_rpc};
code(tester, 170)       -> {ok, proto_170, test_cross_king_rpc};
code(tester, 172)       -> {ok, proto_172, test_demon_rpc};
code(tester, 173)       -> {ok, proto_173, test_top_fight_rpc};
code(tester, 174)       -> {ok, proto_174, test_rank_cross_rpc};
code(tester, 175)       -> {ok, proto_175, test_guild_boss_rpc};
code(tester, 177)       -> {ok, proto_177, test_fate_rpc};
code(tester, 178)       -> {ok, proto_178, test_cross_ore_rpc};
code(tester, 179)       -> {ok, proto_179, test_soul_world_rpc};
code(tester, 181)       -> {ok, proto_181, test_cross_warlord_rpc};
code(tester, 183)       -> {ok, proto_183, test_trip_rpc};
code(tester, 184)       -> {ok, proto_184, test_wine_rpc};
code(tester, 189)       -> {ok, proto_189, test_train_rpc};
code(tester, 194)       -> {ok, proto_194, test_looks_rpc};
code(tester, 195)       -> {ok, proto_195, test_seeking_rpc};

%% 未知编号
code(Type, Code)        -> {error, {Type, Code}}.
