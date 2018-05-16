%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2015 下午7:26
%%%-------------------------------------------------------------------
-module(protomap).
-author("fancy").

%% API
-export([map/1]).

map(Cmd) -> pt(Cmd div (100)).

pt(100) -> {ok, false, pt_100, player_login};
pt(101) -> {ok, false, pt_101, player_login};
pt(110) -> {ok, true, pt_110, chat_rpc};
pt(120) -> {ok, true, pt_120, scene_rpc};
pt(121) -> {ok, true, pt_121, dungeon_rpc};
pt(122) -> {ok, true, pt_122, dungeon_rpc};
pt(123) -> {ok, true, pt_123, cross_dungeon_rpc};
pt(124) -> {ok, true, pt_124, prison_rpc};
pt(125) -> {ok, true, pt_125, dungeon_rpc};
pt(126) -> {ok, true, pt_126, dungeon_rpc};
pt(127) -> {ok, true, pt_127, dungeon_rpc};
pt(128) -> {ok, true, pt_128, dungeon_rpc};
pt(129) -> {ok, true, pt_129, dungeon_rpc};
pt(130) -> {ok, true, pt_130, player_rpc};
pt(131) -> {ok, true, pt_131, achieve_rpc};
pt(132) -> {ok, true, pt_132, hp_pool_rpc};
pt(133) -> {ok, true, pt_133, dungeon_rpc};
pt(140) -> {ok, true, pt_140, pray_rpc};
pt(150) -> {ok, true, pt_150, goods_rpc};
pt(151) -> {ok, true, pt_151, treasure_rpc};
pt(153) -> {ok, true, pt_153, panic_buying_rpc};
pt(154) -> {ok, true, pt_154, sword_pool_rpc};
pt(155) -> {ok, true, pt_155, magic_weapon_rpc};
pt(156) -> {ok, true, pt_156, god_weapon_rpc};
pt(157) -> {ok, true, pt_157, smelt_rpc};
pt(158) -> {ok, true, pt_158, pet_weapon_rpc};
pt(159) -> {ok, true, pt_159, plant_rpc};
pt(160) -> {ok, true, pt_160, equip_rpc};
pt(161) -> {ok, true, pt_161, cat_rpc};
pt(162) -> {ok, true, pt_162, golden_body_rpc};
pt(163) -> {ok, true, pt_163, baby_rpc};
pt(170) -> {ok, true, pt_170, mount_rpc};
pt(171) -> {ok, true, pt_171, baby_mount_rpc};
pt(180) -> {ok, true, pt_180, random_shop_rpc};
pt(190) -> {ok, true, pt_190, mail_rpc};
pt(200) -> {ok, true, pt_200, battle_rpc};
pt(201) -> {ok, true, pt_201, mon_photo_rpc};
pt(210) -> {ok, true, pt_210, skill_rpc};
pt(220) -> {ok, true, pt_220, team_rpc};
pt(230) -> {ok, true, pt_230, arena_rpc};
pt(231) -> {ok, true, pt_231, cross_arena_rpc};
pt(240) -> {ok, true, pt_240, relation_rpc};
pt(250) -> {ok, true, pt_250, taobao_rpc};
pt(260) -> {ok, true, pt_260, answer_rpc};
pt(270) -> {ok, true, pt_270, invest_rpc};
pt(280) -> {ok, true, pt_280, xiulian_rpc};
pt(287) -> {ok, true, pt_287, party_rpc};
pt(288) -> {ok, true, pt_288, marry_rpc};
pt(289) -> {ok, true, pt_289, marry_rpc};
pt(290) -> {ok, true, pt_290, yuanli_rpc};
pt(291) -> {ok, true, pt_291, marry_rpc};
pt(300) -> {ok, true, pt_300, task_rpc};
pt(310) -> {ok, true, pt_310, market_rpc};
pt(320) -> {ok, true, pt_320, npc_rpc};
pt(330) -> {ok, true, pt_330, fashion_rpc};
pt(331) -> {ok, true, pt_331, footprint_rpc};
pt(332) -> {ok, true, pt_332, bubble_rpc};
pt(333) -> {ok, true, pt_333, head_rpc};
pt(334) -> {ok, true, pt_334, decoration_rpc};
pt(350) -> {ok, true, pt_350, light_weapon_rpc};
pt(351) -> {ok, true, pt_351, baby_weapon_rpc};
pt(360) -> {ok, true, pt_360, wing_rpc};
pt(362) -> {ok, true, pt_362, baby_wing_rpc};
pt(370) -> {ok, true, pt_370, wish_tree_rpc};
pt(380) -> {ok, true, pt_380, new_shop_rpc};
pt(381) -> {ok, true, pt_381, findback_rpc};
pt(382) -> {ok, true, pt_382, red_bag_rpc};
pt(384) -> {ok, true, pt_384, star_luck_rpc};
pt(390) -> {ok, true, pt_390, crazy_click_rpc};
pt(400) -> {ok, true, pt_400, guild_rpc};
pt(401) -> {ok, true, pt_401, guild_manor_rpc};
pt(402) -> {ok, true, pt_402, manor_war_rpc};
pt(403) -> {ok, true, pt_403, cross_dark_bribe_rpc};
pt(404) -> {ok, true, pt_404, dvip_rpc};
pt(405) -> {ok, true, pt_405, guild_answer_rpc};
pt(410) -> {ok, true, pt_410, guild_war_rpc};
pt(420) -> {ok, true, pt_420, meridian_rpc};
pt(430) -> {ok, true, pt_430, activity_rpc};
pt(431) -> {ok, true, pt_431, activity_rpc};
pt(432) -> {ok, true, pt_432, activity_rpc};
pt(433) -> {ok, true, pt_433, activity_rpc};
pt(434) -> {ok, true, pt_434, wybq_rpc};
pt(435) -> {ok, true, pt_435, fuwen_rpc};
pt(436) -> {ok, true, pt_436, marry_room_rpc};
pt(437) -> {ok, true, pt_437, activity_rpc};
pt(438) -> {ok, true, pt_438, activity_rpc};
pt(439) -> {ok, true, pt_439, activity_rpc};
pt(440) -> {ok, true, pt_440, designation_rpc};
pt(441) -> {ok, true, pt_441, fashion_suit_rpc};
pt(442) -> {ok, true, pt_442, xian_rpc};
pt(443) -> {ok, true, pt_443, pet_war_rpc};
pt(444) -> {ok, true, pt_444, godness_rpc};
pt(445) -> {ok, true, pt_445, elite_boss_rpc};
pt(446) -> {ok, true, pt_446, face_card_rpc};
pt(447) -> {ok, true, pt_447, guild_fight_rpc};
pt(448) -> {ok, true, pt_448, element_rpc};
pt(460) -> {ok, true, pt_460, charge_rpc};
pt(470) -> {ok, true, pt_470, vip_rpc};
pt(480) -> {ok, true, pt_480, rank_rpc};
pt(490) -> {ok, true, pt_490, notice_rpc};
pt(501) -> {ok, true, pt_501, pet_rpc};
pt(510) -> {ok, true, pt_510, sign_in_rpc};
pt(520) -> {ok, true, pt_520, day7login_rpc};
pt(530) -> {ok, true, pt_530, gift_rpc};
pt(540) -> {ok, true, pt_540, worship_rpc};
pt(550) -> {ok, true, pt_550, cross_battlefield_rpc};
pt(560) -> {ok, true, pt_560, field_boss_rpc};
pt(570) -> {ok, true, pt_570, cross_boss_rpc};
pt(580) -> {ok, true, pt_580, cross_elite_rpc};
pt(581) -> {ok, true, pt_581, cross_six_dragon_rpc};
pt(582) -> {ok, true, pt_582, cross_fruit_rpc};
pt(583) -> {ok, true, pt_583, hot_well_rpc};
pt(584) -> {ok, true, pt_584, cross_scuffle_rpc};
pt(585) -> {ok, true, pt_585, cross_scuffle_elite_rpc};
pt(590) -> {ok, true, pt_590, cross_eliminate_rpc};
pt(601) -> {ok, true, pt_601, cross_war_rpc};
pt(602) -> {ok, true, pt_602, cross_flower_rpc};
pt(603) -> {ok, true, pt_603, flower_rank_rpc};
pt(604) -> {ok, true, pt_604, cross_mining_rpc};
pt(610) -> {ok, true, pt_610, invade_rpc};
pt(620) -> {ok, true, pt_620, cross_hunt_rpc};
pt(630) -> {ok, true, pt_630, grace_rpc};
pt(640) -> {ok, true, pt_640, battlefield_rpc};
pt(641) -> {ok, true, pt_641, fairy_soul_rpc};
pt(642) -> {ok, true, pt_642, cross_1vn_rpc};
pt(650) -> {ok, true, pt_650, lucky_pool_rpc};
pt(651) -> {ok, true, pt_651, cross_dungeon_guard_rpc};
pt(652) -> {ok, true, pt_652, jade_rpc};
pt(653) -> {ok, true, pt_653, god_treasure_rpc};


pt(_) -> false.
