%%----------------------------------------------------
%% 宠物猎魔数据
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(pet_magic_data).
-export([
        get_npc/1
        ,list_npc_item/1
        ,get_npc_item/2
        ,get_item_attr/2
        ,exchange_list/0
        ,get_exchange/1
        ,get_polish_star/2
    ]
).

-include("pet.hrl").


%% 获取猎魔NPC信息数据
get_npc(1) ->
    #pet_npc{
        id = 1
        ,npc_name = <<"少陵野老">>
        ,coin = 20000
        ,gold = 0
        ,rand = {0, 0, 0}
    };
get_npc(2) ->
    #pet_npc{
        id = 2
        ,npc_name = <<"周一仙">>
        ,coin = 0
        ,gold = 50
        ,rand = {0, 0, 0}
    };
get_npc(_) -> false.

%% 获取猎魔NPC产出物品列表信息
list_npc_item(1) -> [50000,50001,50002,50003,50004,50012,50201,50202,50203,50204
   ,50205,50206,50151,50152,50153,50154,50155,50156,50101,50102
   ,50103,50104,50105,50106,50107];
list_npc_item(2) -> [50013,50151,50152,50153,50154,50155,50156,50101,50102,50103
   ,50104,50105,50106,50107,50051,50052,50053,50054,50055,50056
   ,50057,50058];
list_npc_item(_NpcId) -> [].

%% 获取猎魔NPC物品产出信息数据
get_npc_item(1, 50000) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50000
        ,item_name = <<"鬼·绝体绝命">>
        ,is_notice = 0
        ,rand = 600
    };
get_npc_item(1, 50001) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50001
        ,item_name = <<"鬼·孤星">>
        ,is_notice = 0
        ,rand = 600
    };
get_npc_item(1, 50002) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50002
        ,item_name = <<"鬼·血光">>
        ,is_notice = 0
        ,rand = 600
    };
get_npc_item(1, 50003) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50003
        ,item_name = <<"鬼·邪恶低语">>
        ,is_notice = 0
        ,rand = 600
    };
get_npc_item(1, 50004) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50004
        ,item_name = <<"鬼·死亡连锁">>
        ,is_notice = 0
        ,rand = 600
    };
get_npc_item(1, 50012) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50012
        ,item_name = <<"晶核">>
        ,is_notice = 0
        ,rand = 3500
    };
get_npc_item(1, 50201) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50201
        ,item_name = <<"血法之灵">>
        ,is_notice = 0
        ,rand = 416
    };
get_npc_item(1, 50202) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50202
        ,item_name = <<"御金之灵">>
        ,is_notice = 0
        ,rand = 416
    };
get_npc_item(1, 50203) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50203
        ,item_name = <<"御木之灵">>
        ,is_notice = 0
        ,rand = 416
    };
get_npc_item(1, 50204) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50204
        ,item_name = <<"御水之灵">>
        ,is_notice = 0
        ,rand = 416
    };
get_npc_item(1, 50205) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50205
        ,item_name = <<"御火之灵">>
        ,is_notice = 0
        ,rand = 416
    };
get_npc_item(1, 50206) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50206
        ,item_name = <<"御土之灵">>
        ,is_notice = 0
        ,rand = 416
    };
get_npc_item(1, 50151) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50151
        ,item_name = <<"血法之灵">>
        ,is_notice = 0
        ,rand = 150
    };
get_npc_item(1, 50152) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50152
        ,item_name = <<"御金之灵">>
        ,is_notice = 0
        ,rand = 150
    };
get_npc_item(1, 50153) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50153
        ,item_name = <<"御木之灵">>
        ,is_notice = 0
        ,rand = 150
    };
get_npc_item(1, 50154) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50154
        ,item_name = <<"御水之灵">>
        ,is_notice = 0
        ,rand = 150
    };
get_npc_item(1, 50155) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50155
        ,item_name = <<"御火之灵">>
        ,is_notice = 0
        ,rand = 150
    };
get_npc_item(1, 50156) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50156
        ,item_name = <<"御土之灵">>
        ,is_notice = 0
        ,rand = 150
    };
get_npc_item(1, 50101) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50101
        ,item_name = <<"血法之灵">>
        ,is_notice = 0
        ,rand = 14
    };
get_npc_item(1, 50102) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50102
        ,item_name = <<"御金之灵">>
        ,is_notice = 0
        ,rand = 14
    };
get_npc_item(1, 50103) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50103
        ,item_name = <<"御木之灵">>
        ,is_notice = 0
        ,rand = 14
    };
get_npc_item(1, 50104) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50104
        ,item_name = <<"御水之灵">>
        ,is_notice = 0
        ,rand = 14
    };
get_npc_item(1, 50105) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50105
        ,item_name = <<"御火之灵">>
        ,is_notice = 0
        ,rand = 14
    };
get_npc_item(1, 50106) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50106
        ,item_name = <<"御土之灵">>
        ,is_notice = 0
        ,rand = 14
    };
get_npc_item(1, 50107) ->
    #pet_npc_item{
        id = 1
        ,base_id = 50107
        ,item_name = <<"攻击之灵">>
        ,is_notice = 0
        ,rand = 20
    };
get_npc_item(2, 50013) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50013
        ,item_name = <<"远古晶核">>
        ,is_notice = 0
        ,rand = 6000
    };
get_npc_item(2, 50151) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50151
        ,item_name = <<"血法之灵">>
        ,is_notice = 0
        ,rand = 166
    };
get_npc_item(2, 50152) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50152
        ,item_name = <<"御金之灵">>
        ,is_notice = 0
        ,rand = 166
    };
get_npc_item(2, 50153) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50153
        ,item_name = <<"御木之灵">>
        ,is_notice = 0
        ,rand = 166
    };
get_npc_item(2, 50154) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50154
        ,item_name = <<"御水之灵">>
        ,is_notice = 0
        ,rand = 166
    };
get_npc_item(2, 50155) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50155
        ,item_name = <<"御火之灵">>
        ,is_notice = 0
        ,rand = 166
    };
get_npc_item(2, 50156) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50156
        ,item_name = <<"御土之灵">>
        ,is_notice = 0
        ,rand = 166
    };
get_npc_item(2, 50101) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50101
        ,item_name = <<"血法之灵">>
        ,is_notice = 0
        ,rand = 400
    };
get_npc_item(2, 50102) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50102
        ,item_name = <<"御金之灵">>
        ,is_notice = 0
        ,rand = 400
    };
get_npc_item(2, 50103) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50103
        ,item_name = <<"御木之灵">>
        ,is_notice = 0
        ,rand = 400
    };
get_npc_item(2, 50104) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50104
        ,item_name = <<"御水之灵">>
        ,is_notice = 0
        ,rand = 400
    };
get_npc_item(2, 50105) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50105
        ,item_name = <<"御火之灵">>
        ,is_notice = 0
        ,rand = 400
    };
get_npc_item(2, 50106) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50106
        ,item_name = <<"御土之灵">>
        ,is_notice = 0
        ,rand = 400
    };
get_npc_item(2, 50107) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50107
        ,item_name = <<"攻击之灵">>
        ,is_notice = 0
        ,rand = 400
    };
get_npc_item(2, 50051) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50051
        ,item_name = <<"真·血法之灵">>
        ,is_notice = 1
        ,rand = 25
    };
get_npc_item(2, 50052) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50052
        ,item_name = <<"真·御金之灵">>
        ,is_notice = 1
        ,rand = 25
    };
get_npc_item(2, 50053) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50053
        ,item_name = <<"真·御木之灵">>
        ,is_notice = 1
        ,rand = 25
    };
get_npc_item(2, 50054) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50054
        ,item_name = <<"真·御水之灵">>
        ,is_notice = 1
        ,rand = 25
    };
get_npc_item(2, 50055) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50055
        ,item_name = <<"真·御火之灵">>
        ,is_notice = 1
        ,rand = 25
    };
get_npc_item(2, 50056) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50056
        ,item_name = <<"真·御土之灵">>
        ,is_notice = 1
        ,rand = 25
    };
get_npc_item(2, 50057) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50057
        ,item_name = <<"真·攻击之灵">>
        ,is_notice = 1
        ,rand = 25
    };
get_npc_item(2, 50058) ->
    #pet_npc_item{
        id = 2
        ,base_id = 50058
        ,item_name = <<"真·法伤之灵">>
        ,is_notice = 1
        ,rand = 29
    };
get_npc_item(_NpcId, _BaseId) -> false.

%% 获取物品属性数据
get_item_attr(50011, 1) ->
    #pet_item_attr{
        base_id = 50011
        ,name = <<"上古晶核">>
        ,lev = 1
        ,exp = 0
        ,attr = []
        ,polish = {0, 0}
        ,polish_list = []
    };
get_item_attr(50012, 1) ->
    #pet_item_attr{
        base_id = 50012
        ,name = <<"晶核">>
        ,lev = 1
        ,exp = 0
        ,attr = []
        ,polish = {0, 0}
        ,polish_list = []
    };
get_item_attr(50013, 1) ->
    #pet_item_attr{
        base_id = 50013
        ,name = <<"远古晶核">>
        ,lev = 1
        ,exp = 0
        ,attr = []
        ,polish = {0, 0}
        ,polish_list = []
    };
get_item_attr(50051, 1) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 1
        ,exp = 128
        ,attr = []
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 480], 312},{attr_pet_mp, 3, [1, 55], 312},{attr_pet_defence, 3, [1, 135], 312},{attr_pet_resist_metal, 3, [1, 110], 312},{attr_pet_resist_wood, 3, [1, 110], 312},{attr_pet_resist_water, 3, [1, 110], 312},{attr_pet_resist_fire, 3, [1, 110], 312},{attr_pet_resist_earth, 3, [1, 110], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 35], 1250},{attr_pet_dmg_magic, 1, [1, 22], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 2) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 2
        ,exp = 256
        ,attr = [{attr_pet_hp, 491},{attr_pet_mp, 49}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 717], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 205], 312},{attr_pet_resist_metal, 3, [1, 164], 312},{attr_pet_resist_wood, 3, [1, 164], 312},{attr_pet_resist_water, 3, [1, 164], 312},{attr_pet_resist_fire, 3, [1, 164], 312},{attr_pet_resist_earth, 3, [1, 164], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 52], 1250},{attr_pet_dmg_magic, 1, [1, 31], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 3) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 3
        ,exp = 512
        ,attr = [{attr_pet_hp, 1292},{attr_pet_mp, 141}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1130], 312},{attr_pet_mp, 3, [1, 130], 312},{attr_pet_defence, 3, [1, 323], 312},{attr_pet_resist_metal, 3, [1, 258], 312},{attr_pet_resist_wood, 3, [1, 258], 312},{attr_pet_resist_water, 3, [1, 258], 312},{attr_pet_resist_fire, 3, [1, 258], 312},{attr_pet_resist_earth, 3, [1, 258], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 81], 1250},{attr_pet_dmg_magic, 1, [1, 48], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 4) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 4
        ,exp = 1024
        ,attr = [{attr_pet_hp, 2276},{attr_pet_mp, 253}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1637], 312},{attr_pet_mp, 3, [1, 187], 312},{attr_pet_defence, 3, [1, 468], 312},{attr_pet_resist_metal, 3, [1, 374], 312},{attr_pet_resist_wood, 3, [1, 374], 312},{attr_pet_resist_water, 3, [1, 374], 312},{attr_pet_resist_fire, 3, [1, 374], 312},{attr_pet_resist_earth, 3, [1, 374], 312},{attr_pet_anti_stone, 1, [1, 40], 416},{attr_pet_anti_stun, 1, [1, 40], 416},{attr_pet_anti_sleep, 1, [1, 40], 416},{attr_pet_anti_taunt, 1, [1, 40], 416},{attr_pet_anti_silent, 1, [1, 40], 416},{attr_pet_anti_poison, 1, [1, 40], 416},{attr_pet_dmg, 1, [1, 117], 1250},{attr_pet_dmg_magic, 1, [1, 70], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 5) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 5
        ,exp = 2048
        ,attr = [{attr_pet_hp, 3444},{attr_pet_mp, 387}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2238], 312},{attr_pet_mp, 3, [1, 256], 312},{attr_pet_defence, 3, [1, 640], 312},{attr_pet_resist_metal, 3, [1, 512], 312},{attr_pet_resist_wood, 3, [1, 512], 312},{attr_pet_resist_water, 3, [1, 512], 312},{attr_pet_resist_fire, 3, [1, 512], 312},{attr_pet_resist_earth, 3, [1, 512], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 160], 1250},{attr_pet_dmg_magic, 1, [1, 96], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 6) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 6
        ,exp = 4096
        ,attr = [{attr_pet_hp, 4797},{attr_pet_mp, 542}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2935], 312},{attr_pet_mp, 3, [1, 336], 312},{attr_pet_defence, 3, [1, 839], 312},{attr_pet_resist_metal, 3, [1, 671], 312},{attr_pet_resist_wood, 3, [1, 671], 312},{attr_pet_resist_water, 3, [1, 671], 312},{attr_pet_resist_fire, 3, [1, 671], 312},{attr_pet_resist_earth, 3, [1, 671], 312},{attr_pet_anti_stone, 1, [1, 60], 416},{attr_pet_anti_stun, 1, [1, 60], 416},{attr_pet_anti_sleep, 1, [1, 60], 416},{attr_pet_anti_taunt, 1, [1, 60], 416},{attr_pet_anti_silent, 1, [1, 60], 416},{attr_pet_anti_poison, 1, [1, 60], 416},{attr_pet_dmg, 1, [1, 210], 1250},{attr_pet_dmg_magic, 1, [1, 126], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 7) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 7
        ,exp = 8192
        ,attr = [{attr_pet_hp, 6335},{attr_pet_mp, 717}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 3727], 312},{attr_pet_mp, 3, [1, 426], 312},{attr_pet_defence, 3, [1, 1065], 312},{attr_pet_resist_metal, 3, [1, 852], 312},{attr_pet_resist_wood, 3, [1, 852], 312},{attr_pet_resist_water, 3, [1, 852], 312},{attr_pet_resist_fire, 3, [1, 852], 312},{attr_pet_resist_earth, 3, [1, 852], 312},{attr_pet_anti_stone, 1, [1, 70], 416},{attr_pet_anti_stun, 1, [1, 70], 416},{attr_pet_anti_sleep, 1, [1, 70], 416},{attr_pet_anti_taunt, 1, [1, 70], 416},{attr_pet_anti_silent, 1, [1, 70], 416},{attr_pet_anti_poison, 1, [1, 70], 416},{attr_pet_dmg, 1, [1, 267], 1250},{attr_pet_dmg_magic, 1, [1, 160], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 8) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 8
        ,exp = 16384
        ,attr = [{attr_pet_hp, 8059},{attr_pet_mp, 914}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 4615], 312},{attr_pet_mp, 3, [1, 528], 312},{attr_pet_defence, 3, [1, 1319], 312},{attr_pet_resist_metal, 3, [1, 1055], 312},{attr_pet_resist_wood, 3, [1, 1055], 312},{attr_pet_resist_water, 3, [1, 1055], 312},{attr_pet_resist_fire, 3, [1, 1055], 312},{attr_pet_resist_earth, 3, [1, 1055], 312},{attr_pet_anti_stone, 1, [1, 80], 416},{attr_pet_anti_stun, 1, [1, 80], 416},{attr_pet_anti_sleep, 1, [1, 80], 416},{attr_pet_anti_taunt, 1, [1, 80], 416},{attr_pet_anti_silent, 1, [1, 80], 416},{attr_pet_anti_poison, 1, [1, 80], 416},{attr_pet_dmg, 1, [1, 330], 1250},{attr_pet_dmg_magic, 1, [1, 198], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 9) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 9
        ,exp = 32768
        ,attr = [{attr_pet_hp, 9969},{attr_pet_mp, 1133}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 5599], 312},{attr_pet_mp, 3, [1, 640], 312},{attr_pet_defence, 3, [1, 1600], 312},{attr_pet_resist_metal, 3, [1, 1280], 312},{attr_pet_resist_wood, 3, [1, 1280], 312},{attr_pet_resist_water, 3, [1, 1280], 312},{attr_pet_resist_fire, 3, [1, 1280], 312},{attr_pet_resist_earth, 3, [1, 1280], 312},{attr_pet_anti_stone, 1, [1, 90], 416},{attr_pet_anti_stun, 1, [1, 90], 416},{attr_pet_anti_sleep, 1, [1, 90], 416},{attr_pet_anti_taunt, 1, [1, 90], 416},{attr_pet_anti_silent, 1, [1, 90], 416},{attr_pet_anti_poison, 1, [1, 90], 416},{attr_pet_dmg, 1, [1, 400], 1250},{attr_pet_dmg_magic, 1, [1, 240], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 10) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 10
        ,exp = 65536
        ,attr = [{attr_pet_hp, 12066},{attr_pet_mp, 1372}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 6680], 312},{attr_pet_mp, 3, [1, 764], 312},{attr_pet_defence, 3, [1, 1909], 312},{attr_pet_resist_metal, 3, [1, 1527], 312},{attr_pet_resist_wood, 3, [1, 1527], 312},{attr_pet_resist_water, 3, [1, 1527], 312},{attr_pet_resist_fire, 3, [1, 1527], 312},{attr_pet_resist_earth, 3, [1, 1527], 312},{attr_pet_anti_stone, 1, [1, 100], 416},{attr_pet_anti_stun, 1, [1, 100], 416},{attr_pet_anti_sleep, 1, [1, 100], 416},{attr_pet_anti_taunt, 1, [1, 100], 416},{attr_pet_anti_silent, 1, [1, 100], 416},{attr_pet_anti_poison, 1, [1, 100], 416},{attr_pet_dmg, 1, [1, 478], 1250},{attr_pet_dmg_magic, 1, [1, 286], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 11) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 11
        ,exp = 131072
        ,attr = [{attr_pet_hp, 14350},{attr_pet_mp, 1633}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 7856], 312},{attr_pet_mp, 3, [1, 898], 312},{attr_pet_defence, 3, [1, 2245], 312},{attr_pet_resist_metal, 3, [1, 1796], 312},{attr_pet_resist_wood, 3, [1, 1796], 312},{attr_pet_resist_water, 3, [1, 1796], 312},{attr_pet_resist_fire, 3, [1, 1796], 312},{attr_pet_resist_earth, 3, [1, 1796], 312},{attr_pet_anti_stone, 1, [1, 110], 416},{attr_pet_anti_stun, 1, [1, 110], 416},{attr_pet_anti_sleep, 1, [1, 110], 416},{attr_pet_anti_taunt, 1, [1, 110], 416},{attr_pet_anti_silent, 1, [1, 110], 416},{attr_pet_anti_poison, 1, [1, 110], 416},{attr_pet_dmg, 1, [1, 562], 1250},{attr_pet_dmg_magic, 1, [1, 337], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50051, 12) ->
    #pet_item_attr{
        base_id = 50051
        ,name = <<"真·血法之灵">>
        ,lev = 12
        ,exp = 131072
        ,attr = [{attr_pet_hp, 16822},{attr_pet_mp, 1916}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 9130], 312},{attr_pet_mp, 3, [1, 1044], 312},{attr_pet_defence, 3, [1, 2609], 312},{attr_pet_resist_metal, 3, [1, 2087], 312},{attr_pet_resist_wood, 3, [1, 2087], 312},{attr_pet_resist_water, 3, [1, 2087], 312},{attr_pet_resist_fire, 3, [1, 2087], 312},{attr_pet_resist_earth, 3, [1, 2087], 312},{attr_pet_anti_stone, 1, [1, 120], 416},{attr_pet_anti_stun, 1, [1, 120], 416},{attr_pet_anti_sleep, 1, [1, 120], 416},{attr_pet_anti_taunt, 1, [1, 120], 416},{attr_pet_anti_silent, 1, [1, 120], 416},{attr_pet_anti_poison, 1, [1, 120], 416},{attr_pet_dmg, 1, [1, 653], 1250},{attr_pet_dmg_magic, 1, [1, 391], 1250},{attr_pet_anti_attack, 1, [1, 15], 1000},{attr_pet_skill_protect, 1, [1, 2], 100},{attr_pet_skill_id, 1, [180000, 190000], 200}]
    };
get_item_attr(50052, 1) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 1
        ,exp = 128
        ,attr = []
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 480], 312},{attr_pet_mp, 3, [1, 55], 312},{attr_pet_defence, 3, [1, 135], 312},{attr_pet_resist_metal, 3, [1, 110], 312},{attr_pet_resist_wood, 3, [1, 110], 312},{attr_pet_resist_water, 3, [1, 110], 312},{attr_pet_resist_fire, 3, [1, 110], 312},{attr_pet_resist_earth, 3, [1, 110], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 35], 1250},{attr_pet_dmg_magic, 1, [1, 22], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 2) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 2
        ,exp = 256
        ,attr = [{attr_pet_defence, 138},{attr_pet_resist_metal, 108}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 717], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 205], 312},{attr_pet_resist_metal, 3, [1, 164], 312},{attr_pet_resist_wood, 3, [1, 164], 312},{attr_pet_resist_water, 3, [1, 164], 312},{attr_pet_resist_fire, 3, [1, 164], 312},{attr_pet_resist_earth, 3, [1, 164], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 52], 1250},{attr_pet_dmg_magic, 1, [1, 31], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 3) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 3
        ,exp = 512
        ,attr = [{attr_pet_defence, 367},{attr_pet_resist_metal, 291}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1130], 312},{attr_pet_mp, 3, [1, 130], 312},{attr_pet_defence, 3, [1, 323], 312},{attr_pet_resist_metal, 3, [1, 258], 312},{attr_pet_resist_wood, 3, [1, 258], 312},{attr_pet_resist_water, 3, [1, 258], 312},{attr_pet_resist_fire, 3, [1, 258], 312},{attr_pet_resist_earth, 3, [1, 258], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 81], 1250},{attr_pet_dmg_magic, 1, [1, 48], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 4) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 4
        ,exp = 1024
        ,attr = [{attr_pet_defence, 648},{attr_pet_resist_metal, 516}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1637], 312},{attr_pet_mp, 3, [1, 187], 312},{attr_pet_defence, 3, [1, 468], 312},{attr_pet_resist_metal, 3, [1, 374], 312},{attr_pet_resist_wood, 3, [1, 374], 312},{attr_pet_resist_water, 3, [1, 374], 312},{attr_pet_resist_fire, 3, [1, 374], 312},{attr_pet_resist_earth, 3, [1, 374], 312},{attr_pet_anti_stone, 1, [1, 40], 416},{attr_pet_anti_stun, 1, [1, 40], 416},{attr_pet_anti_sleep, 1, [1, 40], 416},{attr_pet_anti_taunt, 1, [1, 40], 416},{attr_pet_anti_silent, 1, [1, 40], 416},{attr_pet_anti_poison, 1, [1, 40], 416},{attr_pet_dmg, 1, [1, 117], 1250},{attr_pet_dmg_magic, 1, [1, 70], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 5) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 5
        ,exp = 2048
        ,attr = [{attr_pet_defence, 982},{attr_pet_resist_metal, 783}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2238], 312},{attr_pet_mp, 3, [1, 256], 312},{attr_pet_defence, 3, [1, 640], 312},{attr_pet_resist_metal, 3, [1, 512], 312},{attr_pet_resist_wood, 3, [1, 512], 312},{attr_pet_resist_water, 3, [1, 512], 312},{attr_pet_resist_fire, 3, [1, 512], 312},{attr_pet_resist_earth, 3, [1, 512], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 160], 1250},{attr_pet_dmg_magic, 1, [1, 96], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 6) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 6
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1368},{attr_pet_resist_metal, 1092}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2935], 312},{attr_pet_mp, 3, [1, 336], 312},{attr_pet_defence, 3, [1, 839], 312},{attr_pet_resist_metal, 3, [1, 671], 312},{attr_pet_resist_wood, 3, [1, 671], 312},{attr_pet_resist_water, 3, [1, 671], 312},{attr_pet_resist_fire, 3, [1, 671], 312},{attr_pet_resist_earth, 3, [1, 671], 312},{attr_pet_anti_stone, 1, [1, 60], 416},{attr_pet_anti_stun, 1, [1, 60], 416},{attr_pet_anti_sleep, 1, [1, 60], 416},{attr_pet_anti_taunt, 1, [1, 60], 416},{attr_pet_anti_silent, 1, [1, 60], 416},{attr_pet_anti_poison, 1, [1, 60], 416},{attr_pet_dmg, 1, [1, 210], 1250},{attr_pet_dmg_magic, 1, [1, 126], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 7) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 7
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1807},{attr_pet_resist_metal, 1443}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 3727], 312},{attr_pet_mp, 3, [1, 426], 312},{attr_pet_defence, 3, [1, 1065], 312},{attr_pet_resist_metal, 3, [1, 852], 312},{attr_pet_resist_wood, 3, [1, 852], 312},{attr_pet_resist_water, 3, [1, 852], 312},{attr_pet_resist_fire, 3, [1, 852], 312},{attr_pet_resist_earth, 3, [1, 852], 312},{attr_pet_anti_stone, 1, [1, 70], 416},{attr_pet_anti_stun, 1, [1, 70], 416},{attr_pet_anti_sleep, 1, [1, 70], 416},{attr_pet_anti_taunt, 1, [1, 70], 416},{attr_pet_anti_silent, 1, [1, 70], 416},{attr_pet_anti_poison, 1, [1, 70], 416},{attr_pet_dmg, 1, [1, 267], 1250},{attr_pet_dmg_magic, 1, [1, 160], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 8) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 8
        ,exp = 16384
        ,attr = [{attr_pet_defence, 2300},{attr_pet_resist_metal, 1838}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 4615], 312},{attr_pet_mp, 3, [1, 528], 312},{attr_pet_defence, 3, [1, 1319], 312},{attr_pet_resist_metal, 3, [1, 1055], 312},{attr_pet_resist_wood, 3, [1, 1055], 312},{attr_pet_resist_water, 3, [1, 1055], 312},{attr_pet_resist_fire, 3, [1, 1055], 312},{attr_pet_resist_earth, 3, [1, 1055], 312},{attr_pet_anti_stone, 1, [1, 80], 416},{attr_pet_anti_stun, 1, [1, 80], 416},{attr_pet_anti_sleep, 1, [1, 80], 416},{attr_pet_anti_taunt, 1, [1, 80], 416},{attr_pet_anti_silent, 1, [1, 80], 416},{attr_pet_anti_poison, 1, [1, 80], 416},{attr_pet_dmg, 1, [1, 330], 1250},{attr_pet_dmg_magic, 1, [1, 198], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 9) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 9
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2846},{attr_pet_resist_metal, 2274}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 5599], 312},{attr_pet_mp, 3, [1, 640], 312},{attr_pet_defence, 3, [1, 1600], 312},{attr_pet_resist_metal, 3, [1, 1280], 312},{attr_pet_resist_wood, 3, [1, 1280], 312},{attr_pet_resist_water, 3, [1, 1280], 312},{attr_pet_resist_fire, 3, [1, 1280], 312},{attr_pet_resist_earth, 3, [1, 1280], 312},{attr_pet_anti_stone, 1, [1, 90], 416},{attr_pet_anti_stun, 1, [1, 90], 416},{attr_pet_anti_sleep, 1, [1, 90], 416},{attr_pet_anti_taunt, 1, [1, 90], 416},{attr_pet_anti_silent, 1, [1, 90], 416},{attr_pet_anti_poison, 1, [1, 90], 416},{attr_pet_dmg, 1, [1, 400], 1250},{attr_pet_dmg_magic, 1, [1, 240], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 10) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 10
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3445},{attr_pet_resist_metal, 2754}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 6680], 312},{attr_pet_mp, 3, [1, 764], 312},{attr_pet_defence, 3, [1, 1909], 312},{attr_pet_resist_metal, 3, [1, 1527], 312},{attr_pet_resist_wood, 3, [1, 1527], 312},{attr_pet_resist_water, 3, [1, 1527], 312},{attr_pet_resist_fire, 3, [1, 1527], 312},{attr_pet_resist_earth, 3, [1, 1527], 312},{attr_pet_anti_stone, 1, [1, 100], 416},{attr_pet_anti_stun, 1, [1, 100], 416},{attr_pet_anti_sleep, 1, [1, 100], 416},{attr_pet_anti_taunt, 1, [1, 100], 416},{attr_pet_anti_silent, 1, [1, 100], 416},{attr_pet_anti_poison, 1, [1, 100], 416},{attr_pet_dmg, 1, [1, 478], 1250},{attr_pet_dmg_magic, 1, [1, 286], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 11) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 11
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4098},{attr_pet_resist_metal, 3276}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 7856], 312},{attr_pet_mp, 3, [1, 898], 312},{attr_pet_defence, 3, [1, 2245], 312},{attr_pet_resist_metal, 3, [1, 1796], 312},{attr_pet_resist_wood, 3, [1, 1796], 312},{attr_pet_resist_water, 3, [1, 1796], 312},{attr_pet_resist_fire, 3, [1, 1796], 312},{attr_pet_resist_earth, 3, [1, 1796], 312},{attr_pet_anti_stone, 1, [1, 110], 416},{attr_pet_anti_stun, 1, [1, 110], 416},{attr_pet_anti_sleep, 1, [1, 110], 416},{attr_pet_anti_taunt, 1, [1, 110], 416},{attr_pet_anti_silent, 1, [1, 110], 416},{attr_pet_anti_poison, 1, [1, 110], 416},{attr_pet_dmg, 1, [1, 562], 1250},{attr_pet_dmg_magic, 1, [1, 337], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50052, 12) ->
    #pet_item_attr{
        base_id = 50052
        ,name = <<"真·御金之灵">>
        ,lev = 12
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4804},{attr_pet_resist_metal, 3841}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 9130], 312},{attr_pet_mp, 3, [1, 1044], 312},{attr_pet_defence, 3, [1, 2609], 312},{attr_pet_resist_metal, 3, [1, 2087], 312},{attr_pet_resist_wood, 3, [1, 2087], 312},{attr_pet_resist_water, 3, [1, 2087], 312},{attr_pet_resist_fire, 3, [1, 2087], 312},{attr_pet_resist_earth, 3, [1, 2087], 312},{attr_pet_anti_stone, 1, [1, 120], 416},{attr_pet_anti_stun, 1, [1, 120], 416},{attr_pet_anti_sleep, 1, [1, 120], 416},{attr_pet_anti_taunt, 1, [1, 120], 416},{attr_pet_anti_silent, 1, [1, 120], 416},{attr_pet_anti_poison, 1, [1, 120], 416},{attr_pet_dmg, 1, [1, 653], 1250},{attr_pet_dmg_magic, 1, [1, 391], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [150000], 200}]
    };
get_item_attr(50053, 1) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 1
        ,exp = 128
        ,attr = []
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 480], 312},{attr_pet_mp, 3, [1, 55], 312},{attr_pet_defence, 3, [1, 135], 312},{attr_pet_resist_metal, 3, [1, 110], 312},{attr_pet_resist_wood, 3, [1, 110], 312},{attr_pet_resist_water, 3, [1, 110], 312},{attr_pet_resist_fire, 3, [1, 110], 312},{attr_pet_resist_earth, 3, [1, 110], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 35], 1250},{attr_pet_dmg_magic, 1, [1, 22], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 2) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 2
        ,exp = 256
        ,attr = [{attr_pet_defence, 138},{attr_pet_resist_wood, 108}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 717], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 205], 312},{attr_pet_resist_metal, 3, [1, 164], 312},{attr_pet_resist_wood, 3, [1, 164], 312},{attr_pet_resist_water, 3, [1, 164], 312},{attr_pet_resist_fire, 3, [1, 164], 312},{attr_pet_resist_earth, 3, [1, 164], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 52], 1250},{attr_pet_dmg_magic, 1, [1, 31], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 3) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 3
        ,exp = 512
        ,attr = [{attr_pet_defence, 367},{attr_pet_resist_wood, 291}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1130], 312},{attr_pet_mp, 3, [1, 130], 312},{attr_pet_defence, 3, [1, 323], 312},{attr_pet_resist_metal, 3, [1, 258], 312},{attr_pet_resist_wood, 3, [1, 258], 312},{attr_pet_resist_water, 3, [1, 258], 312},{attr_pet_resist_fire, 3, [1, 258], 312},{attr_pet_resist_earth, 3, [1, 258], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 81], 1250},{attr_pet_dmg_magic, 1, [1, 48], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 4) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 4
        ,exp = 1024
        ,attr = [{attr_pet_defence, 648},{attr_pet_resist_wood, 516}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1637], 312},{attr_pet_mp, 3, [1, 187], 312},{attr_pet_defence, 3, [1, 468], 312},{attr_pet_resist_metal, 3, [1, 374], 312},{attr_pet_resist_wood, 3, [1, 374], 312},{attr_pet_resist_water, 3, [1, 374], 312},{attr_pet_resist_fire, 3, [1, 374], 312},{attr_pet_resist_earth, 3, [1, 374], 312},{attr_pet_anti_stone, 1, [1, 40], 416},{attr_pet_anti_stun, 1, [1, 40], 416},{attr_pet_anti_sleep, 1, [1, 40], 416},{attr_pet_anti_taunt, 1, [1, 40], 416},{attr_pet_anti_silent, 1, [1, 40], 416},{attr_pet_anti_poison, 1, [1, 40], 416},{attr_pet_dmg, 1, [1, 117], 1250},{attr_pet_dmg_magic, 1, [1, 70], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 5) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 5
        ,exp = 2048
        ,attr = [{attr_pet_defence, 982},{attr_pet_resist_wood, 783}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2238], 312},{attr_pet_mp, 3, [1, 256], 312},{attr_pet_defence, 3, [1, 640], 312},{attr_pet_resist_metal, 3, [1, 512], 312},{attr_pet_resist_wood, 3, [1, 512], 312},{attr_pet_resist_water, 3, [1, 512], 312},{attr_pet_resist_fire, 3, [1, 512], 312},{attr_pet_resist_earth, 3, [1, 512], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 160], 1250},{attr_pet_dmg_magic, 1, [1, 96], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 6) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 6
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1368},{attr_pet_resist_wood, 1092}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2935], 312},{attr_pet_mp, 3, [1, 336], 312},{attr_pet_defence, 3, [1, 839], 312},{attr_pet_resist_metal, 3, [1, 671], 312},{attr_pet_resist_wood, 3, [1, 671], 312},{attr_pet_resist_water, 3, [1, 671], 312},{attr_pet_resist_fire, 3, [1, 671], 312},{attr_pet_resist_earth, 3, [1, 671], 312},{attr_pet_anti_stone, 1, [1, 60], 416},{attr_pet_anti_stun, 1, [1, 60], 416},{attr_pet_anti_sleep, 1, [1, 60], 416},{attr_pet_anti_taunt, 1, [1, 60], 416},{attr_pet_anti_silent, 1, [1, 60], 416},{attr_pet_anti_poison, 1, [1, 60], 416},{attr_pet_dmg, 1, [1, 210], 1250},{attr_pet_dmg_magic, 1, [1, 126], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 7) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 7
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1807},{attr_pet_resist_wood, 1443}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 3727], 312},{attr_pet_mp, 3, [1, 426], 312},{attr_pet_defence, 3, [1, 1065], 312},{attr_pet_resist_metal, 3, [1, 852], 312},{attr_pet_resist_wood, 3, [1, 852], 312},{attr_pet_resist_water, 3, [1, 852], 312},{attr_pet_resist_fire, 3, [1, 852], 312},{attr_pet_resist_earth, 3, [1, 852], 312},{attr_pet_anti_stone, 1, [1, 70], 416},{attr_pet_anti_stun, 1, [1, 70], 416},{attr_pet_anti_sleep, 1, [1, 70], 416},{attr_pet_anti_taunt, 1, [1, 70], 416},{attr_pet_anti_silent, 1, [1, 70], 416},{attr_pet_anti_poison, 1, [1, 70], 416},{attr_pet_dmg, 1, [1, 267], 1250},{attr_pet_dmg_magic, 1, [1, 160], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 8) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 8
        ,exp = 16384
        ,attr = [{attr_pet_defence, 2300},{attr_pet_resist_wood, 1838}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 4615], 312},{attr_pet_mp, 3, [1, 528], 312},{attr_pet_defence, 3, [1, 1319], 312},{attr_pet_resist_metal, 3, [1, 1055], 312},{attr_pet_resist_wood, 3, [1, 1055], 312},{attr_pet_resist_water, 3, [1, 1055], 312},{attr_pet_resist_fire, 3, [1, 1055], 312},{attr_pet_resist_earth, 3, [1, 1055], 312},{attr_pet_anti_stone, 1, [1, 80], 416},{attr_pet_anti_stun, 1, [1, 80], 416},{attr_pet_anti_sleep, 1, [1, 80], 416},{attr_pet_anti_taunt, 1, [1, 80], 416},{attr_pet_anti_silent, 1, [1, 80], 416},{attr_pet_anti_poison, 1, [1, 80], 416},{attr_pet_dmg, 1, [1, 330], 1250},{attr_pet_dmg_magic, 1, [1, 198], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 9) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 9
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2846},{attr_pet_resist_wood, 2274}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 5599], 312},{attr_pet_mp, 3, [1, 640], 312},{attr_pet_defence, 3, [1, 1600], 312},{attr_pet_resist_metal, 3, [1, 1280], 312},{attr_pet_resist_wood, 3, [1, 1280], 312},{attr_pet_resist_water, 3, [1, 1280], 312},{attr_pet_resist_fire, 3, [1, 1280], 312},{attr_pet_resist_earth, 3, [1, 1280], 312},{attr_pet_anti_stone, 1, [1, 90], 416},{attr_pet_anti_stun, 1, [1, 90], 416},{attr_pet_anti_sleep, 1, [1, 90], 416},{attr_pet_anti_taunt, 1, [1, 90], 416},{attr_pet_anti_silent, 1, [1, 90], 416},{attr_pet_anti_poison, 1, [1, 90], 416},{attr_pet_dmg, 1, [1, 400], 1250},{attr_pet_dmg_magic, 1, [1, 240], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 10) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 10
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3445},{attr_pet_resist_wood, 2754}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 6680], 312},{attr_pet_mp, 3, [1, 764], 312},{attr_pet_defence, 3, [1, 1909], 312},{attr_pet_resist_metal, 3, [1, 1527], 312},{attr_pet_resist_wood, 3, [1, 1527], 312},{attr_pet_resist_water, 3, [1, 1527], 312},{attr_pet_resist_fire, 3, [1, 1527], 312},{attr_pet_resist_earth, 3, [1, 1527], 312},{attr_pet_anti_stone, 1, [1, 100], 416},{attr_pet_anti_stun, 1, [1, 100], 416},{attr_pet_anti_sleep, 1, [1, 100], 416},{attr_pet_anti_taunt, 1, [1, 100], 416},{attr_pet_anti_silent, 1, [1, 100], 416},{attr_pet_anti_poison, 1, [1, 100], 416},{attr_pet_dmg, 1, [1, 478], 1250},{attr_pet_dmg_magic, 1, [1, 286], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 11) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 11
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4098},{attr_pet_resist_wood, 3276}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 7856], 312},{attr_pet_mp, 3, [1, 898], 312},{attr_pet_defence, 3, [1, 2245], 312},{attr_pet_resist_metal, 3, [1, 1796], 312},{attr_pet_resist_wood, 3, [1, 1796], 312},{attr_pet_resist_water, 3, [1, 1796], 312},{attr_pet_resist_fire, 3, [1, 1796], 312},{attr_pet_resist_earth, 3, [1, 1796], 312},{attr_pet_anti_stone, 1, [1, 110], 416},{attr_pet_anti_stun, 1, [1, 110], 416},{attr_pet_anti_sleep, 1, [1, 110], 416},{attr_pet_anti_taunt, 1, [1, 110], 416},{attr_pet_anti_silent, 1, [1, 110], 416},{attr_pet_anti_poison, 1, [1, 110], 416},{attr_pet_dmg, 1, [1, 562], 1250},{attr_pet_dmg_magic, 1, [1, 337], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50053, 12) ->
    #pet_item_attr{
        base_id = 50053
        ,name = <<"真·御木之灵">>
        ,lev = 12
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4804},{attr_pet_resist_wood, 3841}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 9130], 312},{attr_pet_mp, 3, [1, 1044], 312},{attr_pet_defence, 3, [1, 2609], 312},{attr_pet_resist_metal, 3, [1, 2087], 312},{attr_pet_resist_wood, 3, [1, 2087], 312},{attr_pet_resist_water, 3, [1, 2087], 312},{attr_pet_resist_fire, 3, [1, 2087], 312},{attr_pet_resist_earth, 3, [1, 2087], 312},{attr_pet_anti_stone, 1, [1, 120], 416},{attr_pet_anti_stun, 1, [1, 120], 416},{attr_pet_anti_sleep, 1, [1, 120], 416},{attr_pet_anti_taunt, 1, [1, 120], 416},{attr_pet_anti_silent, 1, [1, 120], 416},{attr_pet_anti_poison, 1, [1, 120], 416},{attr_pet_dmg, 1, [1, 653], 1250},{attr_pet_dmg_magic, 1, [1, 391], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [121000, 118000, 119000], 200}]
    };
get_item_attr(50054, 1) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 1
        ,exp = 128
        ,attr = []
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 480], 312},{attr_pet_mp, 3, [1, 55], 312},{attr_pet_defence, 3, [1, 135], 312},{attr_pet_resist_metal, 3, [1, 110], 312},{attr_pet_resist_wood, 3, [1, 110], 312},{attr_pet_resist_water, 3, [1, 110], 312},{attr_pet_resist_fire, 3, [1, 110], 312},{attr_pet_resist_earth, 3, [1, 110], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 35], 1250},{attr_pet_dmg_magic, 1, [1, 22], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 2) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 2
        ,exp = 256
        ,attr = [{attr_pet_defence, 138},{attr_pet_resist_water, 108}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 717], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 205], 312},{attr_pet_resist_metal, 3, [1, 164], 312},{attr_pet_resist_wood, 3, [1, 164], 312},{attr_pet_resist_water, 3, [1, 164], 312},{attr_pet_resist_fire, 3, [1, 164], 312},{attr_pet_resist_earth, 3, [1, 164], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 52], 1250},{attr_pet_dmg_magic, 1, [1, 31], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 3) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 3
        ,exp = 512
        ,attr = [{attr_pet_defence, 367},{attr_pet_resist_water, 291}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1130], 312},{attr_pet_mp, 3, [1, 130], 312},{attr_pet_defence, 3, [1, 323], 312},{attr_pet_resist_metal, 3, [1, 258], 312},{attr_pet_resist_wood, 3, [1, 258], 312},{attr_pet_resist_water, 3, [1, 258], 312},{attr_pet_resist_fire, 3, [1, 258], 312},{attr_pet_resist_earth, 3, [1, 258], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 81], 1250},{attr_pet_dmg_magic, 1, [1, 48], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 4) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 4
        ,exp = 1024
        ,attr = [{attr_pet_defence, 648},{attr_pet_resist_water, 516}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1637], 312},{attr_pet_mp, 3, [1, 187], 312},{attr_pet_defence, 3, [1, 468], 312},{attr_pet_resist_metal, 3, [1, 374], 312},{attr_pet_resist_wood, 3, [1, 374], 312},{attr_pet_resist_water, 3, [1, 374], 312},{attr_pet_resist_fire, 3, [1, 374], 312},{attr_pet_resist_earth, 3, [1, 374], 312},{attr_pet_anti_stone, 1, [1, 40], 416},{attr_pet_anti_stun, 1, [1, 40], 416},{attr_pet_anti_sleep, 1, [1, 40], 416},{attr_pet_anti_taunt, 1, [1, 40], 416},{attr_pet_anti_silent, 1, [1, 40], 416},{attr_pet_anti_poison, 1, [1, 40], 416},{attr_pet_dmg, 1, [1, 117], 1250},{attr_pet_dmg_magic, 1, [1, 70], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 5) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 5
        ,exp = 2048
        ,attr = [{attr_pet_defence, 982},{attr_pet_resist_water, 783}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2238], 312},{attr_pet_mp, 3, [1, 256], 312},{attr_pet_defence, 3, [1, 640], 312},{attr_pet_resist_metal, 3, [1, 512], 312},{attr_pet_resist_wood, 3, [1, 512], 312},{attr_pet_resist_water, 3, [1, 512], 312},{attr_pet_resist_fire, 3, [1, 512], 312},{attr_pet_resist_earth, 3, [1, 512], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 160], 1250},{attr_pet_dmg_magic, 1, [1, 96], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 6) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 6
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1368},{attr_pet_resist_water, 1092}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2935], 312},{attr_pet_mp, 3, [1, 336], 312},{attr_pet_defence, 3, [1, 839], 312},{attr_pet_resist_metal, 3, [1, 671], 312},{attr_pet_resist_wood, 3, [1, 671], 312},{attr_pet_resist_water, 3, [1, 671], 312},{attr_pet_resist_fire, 3, [1, 671], 312},{attr_pet_resist_earth, 3, [1, 671], 312},{attr_pet_anti_stone, 1, [1, 60], 416},{attr_pet_anti_stun, 1, [1, 60], 416},{attr_pet_anti_sleep, 1, [1, 60], 416},{attr_pet_anti_taunt, 1, [1, 60], 416},{attr_pet_anti_silent, 1, [1, 60], 416},{attr_pet_anti_poison, 1, [1, 60], 416},{attr_pet_dmg, 1, [1, 210], 1250},{attr_pet_dmg_magic, 1, [1, 126], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 7) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 7
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1807},{attr_pet_resist_water, 1443}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 3727], 312},{attr_pet_mp, 3, [1, 426], 312},{attr_pet_defence, 3, [1, 1065], 312},{attr_pet_resist_metal, 3, [1, 852], 312},{attr_pet_resist_wood, 3, [1, 852], 312},{attr_pet_resist_water, 3, [1, 852], 312},{attr_pet_resist_fire, 3, [1, 852], 312},{attr_pet_resist_earth, 3, [1, 852], 312},{attr_pet_anti_stone, 1, [1, 70], 416},{attr_pet_anti_stun, 1, [1, 70], 416},{attr_pet_anti_sleep, 1, [1, 70], 416},{attr_pet_anti_taunt, 1, [1, 70], 416},{attr_pet_anti_silent, 1, [1, 70], 416},{attr_pet_anti_poison, 1, [1, 70], 416},{attr_pet_dmg, 1, [1, 267], 1250},{attr_pet_dmg_magic, 1, [1, 160], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 8) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 8
        ,exp = 16384
        ,attr = [{attr_pet_defence, 2300},{attr_pet_resist_water, 1838}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 4615], 312},{attr_pet_mp, 3, [1, 528], 312},{attr_pet_defence, 3, [1, 1319], 312},{attr_pet_resist_metal, 3, [1, 1055], 312},{attr_pet_resist_wood, 3, [1, 1055], 312},{attr_pet_resist_water, 3, [1, 1055], 312},{attr_pet_resist_fire, 3, [1, 1055], 312},{attr_pet_resist_earth, 3, [1, 1055], 312},{attr_pet_anti_stone, 1, [1, 80], 416},{attr_pet_anti_stun, 1, [1, 80], 416},{attr_pet_anti_sleep, 1, [1, 80], 416},{attr_pet_anti_taunt, 1, [1, 80], 416},{attr_pet_anti_silent, 1, [1, 80], 416},{attr_pet_anti_poison, 1, [1, 80], 416},{attr_pet_dmg, 1, [1, 330], 1250},{attr_pet_dmg_magic, 1, [1, 198], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 9) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 9
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2846},{attr_pet_resist_water, 2274}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 5599], 312},{attr_pet_mp, 3, [1, 640], 312},{attr_pet_defence, 3, [1, 1600], 312},{attr_pet_resist_metal, 3, [1, 1280], 312},{attr_pet_resist_wood, 3, [1, 1280], 312},{attr_pet_resist_water, 3, [1, 1280], 312},{attr_pet_resist_fire, 3, [1, 1280], 312},{attr_pet_resist_earth, 3, [1, 1280], 312},{attr_pet_anti_stone, 1, [1, 90], 416},{attr_pet_anti_stun, 1, [1, 90], 416},{attr_pet_anti_sleep, 1, [1, 90], 416},{attr_pet_anti_taunt, 1, [1, 90], 416},{attr_pet_anti_silent, 1, [1, 90], 416},{attr_pet_anti_poison, 1, [1, 90], 416},{attr_pet_dmg, 1, [1, 400], 1250},{attr_pet_dmg_magic, 1, [1, 240], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 10) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 10
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3445},{attr_pet_resist_water, 2754}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 6680], 312},{attr_pet_mp, 3, [1, 764], 312},{attr_pet_defence, 3, [1, 1909], 312},{attr_pet_resist_metal, 3, [1, 1527], 312},{attr_pet_resist_wood, 3, [1, 1527], 312},{attr_pet_resist_water, 3, [1, 1527], 312},{attr_pet_resist_fire, 3, [1, 1527], 312},{attr_pet_resist_earth, 3, [1, 1527], 312},{attr_pet_anti_stone, 1, [1, 100], 416},{attr_pet_anti_stun, 1, [1, 100], 416},{attr_pet_anti_sleep, 1, [1, 100], 416},{attr_pet_anti_taunt, 1, [1, 100], 416},{attr_pet_anti_silent, 1, [1, 100], 416},{attr_pet_anti_poison, 1, [1, 100], 416},{attr_pet_dmg, 1, [1, 478], 1250},{attr_pet_dmg_magic, 1, [1, 286], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 11) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 11
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4098},{attr_pet_resist_water, 3276}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 7856], 312},{attr_pet_mp, 3, [1, 898], 312},{attr_pet_defence, 3, [1, 2245], 312},{attr_pet_resist_metal, 3, [1, 1796], 312},{attr_pet_resist_wood, 3, [1, 1796], 312},{attr_pet_resist_water, 3, [1, 1796], 312},{attr_pet_resist_fire, 3, [1, 1796], 312},{attr_pet_resist_earth, 3, [1, 1796], 312},{attr_pet_anti_stone, 1, [1, 110], 416},{attr_pet_anti_stun, 1, [1, 110], 416},{attr_pet_anti_sleep, 1, [1, 110], 416},{attr_pet_anti_taunt, 1, [1, 110], 416},{attr_pet_anti_silent, 1, [1, 110], 416},{attr_pet_anti_poison, 1, [1, 110], 416},{attr_pet_dmg, 1, [1, 562], 1250},{attr_pet_dmg_magic, 1, [1, 337], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50054, 12) ->
    #pet_item_attr{
        base_id = 50054
        ,name = <<"真·御水之灵">>
        ,lev = 12
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4804},{attr_pet_resist_water, 3841}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 9130], 312},{attr_pet_mp, 3, [1, 1044], 312},{attr_pet_defence, 3, [1, 2609], 312},{attr_pet_resist_metal, 3, [1, 2087], 312},{attr_pet_resist_wood, 3, [1, 2087], 312},{attr_pet_resist_water, 3, [1, 2087], 312},{attr_pet_resist_fire, 3, [1, 2087], 312},{attr_pet_resist_earth, 3, [1, 2087], 312},{attr_pet_anti_stone, 1, [1, 120], 416},{attr_pet_anti_stun, 1, [1, 120], 416},{attr_pet_anti_sleep, 1, [1, 120], 416},{attr_pet_anti_taunt, 1, [1, 120], 416},{attr_pet_anti_silent, 1, [1, 120], 416},{attr_pet_anti_poison, 1, [1, 120], 416},{attr_pet_dmg, 1, [1, 653], 1250},{attr_pet_dmg_magic, 1, [1, 391], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [112000, 113000], 200}]
    };
get_item_attr(50055, 1) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 1
        ,exp = 128
        ,attr = []
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 480], 312},{attr_pet_mp, 3, [1, 55], 312},{attr_pet_defence, 3, [1, 135], 312},{attr_pet_resist_metal, 3, [1, 110], 312},{attr_pet_resist_wood, 3, [1, 110], 312},{attr_pet_resist_water, 3, [1, 110], 312},{attr_pet_resist_fire, 3, [1, 110], 312},{attr_pet_resist_earth, 3, [1, 110], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 35], 1250},{attr_pet_dmg_magic, 1, [1, 22], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 2) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 2
        ,exp = 256
        ,attr = [{attr_pet_defence, 138},{attr_pet_resist_fire, 108}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 717], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 205], 312},{attr_pet_resist_metal, 3, [1, 164], 312},{attr_pet_resist_wood, 3, [1, 164], 312},{attr_pet_resist_water, 3, [1, 164], 312},{attr_pet_resist_fire, 3, [1, 164], 312},{attr_pet_resist_earth, 3, [1, 164], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 52], 1250},{attr_pet_dmg_magic, 1, [1, 31], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 3) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 3
        ,exp = 512
        ,attr = [{attr_pet_defence, 367},{attr_pet_resist_fire, 291}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1130], 312},{attr_pet_mp, 3, [1, 130], 312},{attr_pet_defence, 3, [1, 323], 312},{attr_pet_resist_metal, 3, [1, 258], 312},{attr_pet_resist_wood, 3, [1, 258], 312},{attr_pet_resist_water, 3, [1, 258], 312},{attr_pet_resist_fire, 3, [1, 258], 312},{attr_pet_resist_earth, 3, [1, 258], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 81], 1250},{attr_pet_dmg_magic, 1, [1, 48], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 4) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 4
        ,exp = 1024
        ,attr = [{attr_pet_defence, 648},{attr_pet_resist_fire, 516}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1637], 312},{attr_pet_mp, 3, [1, 187], 312},{attr_pet_defence, 3, [1, 468], 312},{attr_pet_resist_metal, 3, [1, 374], 312},{attr_pet_resist_wood, 3, [1, 374], 312},{attr_pet_resist_water, 3, [1, 374], 312},{attr_pet_resist_fire, 3, [1, 374], 312},{attr_pet_resist_earth, 3, [1, 374], 312},{attr_pet_anti_stone, 1, [1, 40], 416},{attr_pet_anti_stun, 1, [1, 40], 416},{attr_pet_anti_sleep, 1, [1, 40], 416},{attr_pet_anti_taunt, 1, [1, 40], 416},{attr_pet_anti_silent, 1, [1, 40], 416},{attr_pet_anti_poison, 1, [1, 40], 416},{attr_pet_dmg, 1, [1, 117], 1250},{attr_pet_dmg_magic, 1, [1, 70], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 5) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 5
        ,exp = 2048
        ,attr = [{attr_pet_defence, 982},{attr_pet_resist_fire, 783}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2238], 312},{attr_pet_mp, 3, [1, 256], 312},{attr_pet_defence, 3, [1, 640], 312},{attr_pet_resist_metal, 3, [1, 512], 312},{attr_pet_resist_wood, 3, [1, 512], 312},{attr_pet_resist_water, 3, [1, 512], 312},{attr_pet_resist_fire, 3, [1, 512], 312},{attr_pet_resist_earth, 3, [1, 512], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 160], 1250},{attr_pet_dmg_magic, 1, [1, 96], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 6) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 6
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1368},{attr_pet_resist_fire, 1092}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2935], 312},{attr_pet_mp, 3, [1, 336], 312},{attr_pet_defence, 3, [1, 839], 312},{attr_pet_resist_metal, 3, [1, 671], 312},{attr_pet_resist_wood, 3, [1, 671], 312},{attr_pet_resist_water, 3, [1, 671], 312},{attr_pet_resist_fire, 3, [1, 671], 312},{attr_pet_resist_earth, 3, [1, 671], 312},{attr_pet_anti_stone, 1, [1, 60], 416},{attr_pet_anti_stun, 1, [1, 60], 416},{attr_pet_anti_sleep, 1, [1, 60], 416},{attr_pet_anti_taunt, 1, [1, 60], 416},{attr_pet_anti_silent, 1, [1, 60], 416},{attr_pet_anti_poison, 1, [1, 60], 416},{attr_pet_dmg, 1, [1, 210], 1250},{attr_pet_dmg_magic, 1, [1, 126], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 7) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 7
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1807},{attr_pet_resist_fire, 1443}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 3727], 312},{attr_pet_mp, 3, [1, 426], 312},{attr_pet_defence, 3, [1, 1065], 312},{attr_pet_resist_metal, 3, [1, 852], 312},{attr_pet_resist_wood, 3, [1, 852], 312},{attr_pet_resist_water, 3, [1, 852], 312},{attr_pet_resist_fire, 3, [1, 852], 312},{attr_pet_resist_earth, 3, [1, 852], 312},{attr_pet_anti_stone, 1, [1, 70], 416},{attr_pet_anti_stun, 1, [1, 70], 416},{attr_pet_anti_sleep, 1, [1, 70], 416},{attr_pet_anti_taunt, 1, [1, 70], 416},{attr_pet_anti_silent, 1, [1, 70], 416},{attr_pet_anti_poison, 1, [1, 70], 416},{attr_pet_dmg, 1, [1, 267], 1250},{attr_pet_dmg_magic, 1, [1, 160], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 8) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 8
        ,exp = 16384
        ,attr = [{attr_pet_defence, 2300},{attr_pet_resist_fire, 1838}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 4615], 312},{attr_pet_mp, 3, [1, 528], 312},{attr_pet_defence, 3, [1, 1319], 312},{attr_pet_resist_metal, 3, [1, 1055], 312},{attr_pet_resist_wood, 3, [1, 1055], 312},{attr_pet_resist_water, 3, [1, 1055], 312},{attr_pet_resist_fire, 3, [1, 1055], 312},{attr_pet_resist_earth, 3, [1, 1055], 312},{attr_pet_anti_stone, 1, [1, 80], 416},{attr_pet_anti_stun, 1, [1, 80], 416},{attr_pet_anti_sleep, 1, [1, 80], 416},{attr_pet_anti_taunt, 1, [1, 80], 416},{attr_pet_anti_silent, 1, [1, 80], 416},{attr_pet_anti_poison, 1, [1, 80], 416},{attr_pet_dmg, 1, [1, 330], 1250},{attr_pet_dmg_magic, 1, [1, 198], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 9) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 9
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2846},{attr_pet_resist_fire, 2274}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 5599], 312},{attr_pet_mp, 3, [1, 640], 312},{attr_pet_defence, 3, [1, 1600], 312},{attr_pet_resist_metal, 3, [1, 1280], 312},{attr_pet_resist_wood, 3, [1, 1280], 312},{attr_pet_resist_water, 3, [1, 1280], 312},{attr_pet_resist_fire, 3, [1, 1280], 312},{attr_pet_resist_earth, 3, [1, 1280], 312},{attr_pet_anti_stone, 1, [1, 90], 416},{attr_pet_anti_stun, 1, [1, 90], 416},{attr_pet_anti_sleep, 1, [1, 90], 416},{attr_pet_anti_taunt, 1, [1, 90], 416},{attr_pet_anti_silent, 1, [1, 90], 416},{attr_pet_anti_poison, 1, [1, 90], 416},{attr_pet_dmg, 1, [1, 400], 1250},{attr_pet_dmg_magic, 1, [1, 240], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 10) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 10
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3445},{attr_pet_resist_fire, 2754}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 6680], 312},{attr_pet_mp, 3, [1, 764], 312},{attr_pet_defence, 3, [1, 1909], 312},{attr_pet_resist_metal, 3, [1, 1527], 312},{attr_pet_resist_wood, 3, [1, 1527], 312},{attr_pet_resist_water, 3, [1, 1527], 312},{attr_pet_resist_fire, 3, [1, 1527], 312},{attr_pet_resist_earth, 3, [1, 1527], 312},{attr_pet_anti_stone, 1, [1, 100], 416},{attr_pet_anti_stun, 1, [1, 100], 416},{attr_pet_anti_sleep, 1, [1, 100], 416},{attr_pet_anti_taunt, 1, [1, 100], 416},{attr_pet_anti_silent, 1, [1, 100], 416},{attr_pet_anti_poison, 1, [1, 100], 416},{attr_pet_dmg, 1, [1, 478], 1250},{attr_pet_dmg_magic, 1, [1, 286], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 11) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 11
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4098},{attr_pet_resist_fire, 3276}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 7856], 312},{attr_pet_mp, 3, [1, 898], 312},{attr_pet_defence, 3, [1, 2245], 312},{attr_pet_resist_metal, 3, [1, 1796], 312},{attr_pet_resist_wood, 3, [1, 1796], 312},{attr_pet_resist_water, 3, [1, 1796], 312},{attr_pet_resist_fire, 3, [1, 1796], 312},{attr_pet_resist_earth, 3, [1, 1796], 312},{attr_pet_anti_stone, 1, [1, 110], 416},{attr_pet_anti_stun, 1, [1, 110], 416},{attr_pet_anti_sleep, 1, [1, 110], 416},{attr_pet_anti_taunt, 1, [1, 110], 416},{attr_pet_anti_silent, 1, [1, 110], 416},{attr_pet_anti_poison, 1, [1, 110], 416},{attr_pet_dmg, 1, [1, 562], 1250},{attr_pet_dmg_magic, 1, [1, 337], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50055, 12) ->
    #pet_item_attr{
        base_id = 50055
        ,name = <<"真·御火之灵">>
        ,lev = 12
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4804},{attr_pet_resist_fire, 3841}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 9130], 312},{attr_pet_mp, 3, [1, 1044], 312},{attr_pet_defence, 3, [1, 2609], 312},{attr_pet_resist_metal, 3, [1, 2087], 312},{attr_pet_resist_wood, 3, [1, 2087], 312},{attr_pet_resist_water, 3, [1, 2087], 312},{attr_pet_resist_fire, 3, [1, 2087], 312},{attr_pet_resist_earth, 3, [1, 2087], 312},{attr_pet_anti_stone, 1, [1, 120], 416},{attr_pet_anti_stun, 1, [1, 120], 416},{attr_pet_anti_sleep, 1, [1, 120], 416},{attr_pet_anti_taunt, 1, [1, 120], 416},{attr_pet_anti_silent, 1, [1, 120], 416},{attr_pet_anti_poison, 1, [1, 120], 416},{attr_pet_dmg, 1, [1, 653], 1250},{attr_pet_dmg_magic, 1, [1, 391], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [117000], 200}]
    };
get_item_attr(50056, 1) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 1
        ,exp = 128
        ,attr = []
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 480], 312},{attr_pet_mp, 3, [1, 55], 312},{attr_pet_defence, 3, [1, 135], 312},{attr_pet_resist_metal, 3, [1, 110], 312},{attr_pet_resist_wood, 3, [1, 110], 312},{attr_pet_resist_water, 3, [1, 110], 312},{attr_pet_resist_fire, 3, [1, 110], 312},{attr_pet_resist_earth, 3, [1, 110], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 35], 1250},{attr_pet_dmg_magic, 1, [1, 22], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 2) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 2
        ,exp = 256
        ,attr = [{attr_pet_defence, 138},{attr_pet_resist_earth, 108}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 717], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 205], 312},{attr_pet_resist_metal, 3, [1, 164], 312},{attr_pet_resist_wood, 3, [1, 164], 312},{attr_pet_resist_water, 3, [1, 164], 312},{attr_pet_resist_fire, 3, [1, 164], 312},{attr_pet_resist_earth, 3, [1, 164], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 52], 1250},{attr_pet_dmg_magic, 1, [1, 31], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 3) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 3
        ,exp = 512
        ,attr = [{attr_pet_defence, 367},{attr_pet_resist_earth, 291}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1130], 312},{attr_pet_mp, 3, [1, 130], 312},{attr_pet_defence, 3, [1, 323], 312},{attr_pet_resist_metal, 3, [1, 258], 312},{attr_pet_resist_wood, 3, [1, 258], 312},{attr_pet_resist_water, 3, [1, 258], 312},{attr_pet_resist_fire, 3, [1, 258], 312},{attr_pet_resist_earth, 3, [1, 258], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 81], 1250},{attr_pet_dmg_magic, 1, [1, 48], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 4) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 4
        ,exp = 1024
        ,attr = [{attr_pet_defence, 648},{attr_pet_resist_earth, 516}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1637], 312},{attr_pet_mp, 3, [1, 187], 312},{attr_pet_defence, 3, [1, 468], 312},{attr_pet_resist_metal, 3, [1, 374], 312},{attr_pet_resist_wood, 3, [1, 374], 312},{attr_pet_resist_water, 3, [1, 374], 312},{attr_pet_resist_fire, 3, [1, 374], 312},{attr_pet_resist_earth, 3, [1, 374], 312},{attr_pet_anti_stone, 1, [1, 40], 416},{attr_pet_anti_stun, 1, [1, 40], 416},{attr_pet_anti_sleep, 1, [1, 40], 416},{attr_pet_anti_taunt, 1, [1, 40], 416},{attr_pet_anti_silent, 1, [1, 40], 416},{attr_pet_anti_poison, 1, [1, 40], 416},{attr_pet_dmg, 1, [1, 117], 1250},{attr_pet_dmg_magic, 1, [1, 70], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 5) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 5
        ,exp = 2048
        ,attr = [{attr_pet_defence, 982},{attr_pet_resist_earth, 783}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2238], 312},{attr_pet_mp, 3, [1, 256], 312},{attr_pet_defence, 3, [1, 640], 312},{attr_pet_resist_metal, 3, [1, 512], 312},{attr_pet_resist_wood, 3, [1, 512], 312},{attr_pet_resist_water, 3, [1, 512], 312},{attr_pet_resist_fire, 3, [1, 512], 312},{attr_pet_resist_earth, 3, [1, 512], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 160], 1250},{attr_pet_dmg_magic, 1, [1, 96], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 6) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 6
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1368},{attr_pet_resist_earth, 1092}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2935], 312},{attr_pet_mp, 3, [1, 336], 312},{attr_pet_defence, 3, [1, 839], 312},{attr_pet_resist_metal, 3, [1, 671], 312},{attr_pet_resist_wood, 3, [1, 671], 312},{attr_pet_resist_water, 3, [1, 671], 312},{attr_pet_resist_fire, 3, [1, 671], 312},{attr_pet_resist_earth, 3, [1, 671], 312},{attr_pet_anti_stone, 1, [1, 60], 416},{attr_pet_anti_stun, 1, [1, 60], 416},{attr_pet_anti_sleep, 1, [1, 60], 416},{attr_pet_anti_taunt, 1, [1, 60], 416},{attr_pet_anti_silent, 1, [1, 60], 416},{attr_pet_anti_poison, 1, [1, 60], 416},{attr_pet_dmg, 1, [1, 210], 1250},{attr_pet_dmg_magic, 1, [1, 126], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 7) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 7
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1807},{attr_pet_resist_earth, 1443}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 3727], 312},{attr_pet_mp, 3, [1, 426], 312},{attr_pet_defence, 3, [1, 1065], 312},{attr_pet_resist_metal, 3, [1, 852], 312},{attr_pet_resist_wood, 3, [1, 852], 312},{attr_pet_resist_water, 3, [1, 852], 312},{attr_pet_resist_fire, 3, [1, 852], 312},{attr_pet_resist_earth, 3, [1, 852], 312},{attr_pet_anti_stone, 1, [1, 70], 416},{attr_pet_anti_stun, 1, [1, 70], 416},{attr_pet_anti_sleep, 1, [1, 70], 416},{attr_pet_anti_taunt, 1, [1, 70], 416},{attr_pet_anti_silent, 1, [1, 70], 416},{attr_pet_anti_poison, 1, [1, 70], 416},{attr_pet_dmg, 1, [1, 267], 1250},{attr_pet_dmg_magic, 1, [1, 160], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 8) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 8
        ,exp = 16384
        ,attr = [{attr_pet_defence, 2300},{attr_pet_resist_earth, 1838}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 4615], 312},{attr_pet_mp, 3, [1, 528], 312},{attr_pet_defence, 3, [1, 1319], 312},{attr_pet_resist_metal, 3, [1, 1055], 312},{attr_pet_resist_wood, 3, [1, 1055], 312},{attr_pet_resist_water, 3, [1, 1055], 312},{attr_pet_resist_fire, 3, [1, 1055], 312},{attr_pet_resist_earth, 3, [1, 1055], 312},{attr_pet_anti_stone, 1, [1, 80], 416},{attr_pet_anti_stun, 1, [1, 80], 416},{attr_pet_anti_sleep, 1, [1, 80], 416},{attr_pet_anti_taunt, 1, [1, 80], 416},{attr_pet_anti_silent, 1, [1, 80], 416},{attr_pet_anti_poison, 1, [1, 80], 416},{attr_pet_dmg, 1, [1, 330], 1250},{attr_pet_dmg_magic, 1, [1, 198], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 9) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 9
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2846},{attr_pet_resist_earth, 2274}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 5599], 312},{attr_pet_mp, 3, [1, 640], 312},{attr_pet_defence, 3, [1, 1600], 312},{attr_pet_resist_metal, 3, [1, 1280], 312},{attr_pet_resist_wood, 3, [1, 1280], 312},{attr_pet_resist_water, 3, [1, 1280], 312},{attr_pet_resist_fire, 3, [1, 1280], 312},{attr_pet_resist_earth, 3, [1, 1280], 312},{attr_pet_anti_stone, 1, [1, 90], 416},{attr_pet_anti_stun, 1, [1, 90], 416},{attr_pet_anti_sleep, 1, [1, 90], 416},{attr_pet_anti_taunt, 1, [1, 90], 416},{attr_pet_anti_silent, 1, [1, 90], 416},{attr_pet_anti_poison, 1, [1, 90], 416},{attr_pet_dmg, 1, [1, 400], 1250},{attr_pet_dmg_magic, 1, [1, 240], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 10) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 10
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3445},{attr_pet_resist_earth, 2754}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 6680], 312},{attr_pet_mp, 3, [1, 764], 312},{attr_pet_defence, 3, [1, 1909], 312},{attr_pet_resist_metal, 3, [1, 1527], 312},{attr_pet_resist_wood, 3, [1, 1527], 312},{attr_pet_resist_water, 3, [1, 1527], 312},{attr_pet_resist_fire, 3, [1, 1527], 312},{attr_pet_resist_earth, 3, [1, 1527], 312},{attr_pet_anti_stone, 1, [1, 100], 416},{attr_pet_anti_stun, 1, [1, 100], 416},{attr_pet_anti_sleep, 1, [1, 100], 416},{attr_pet_anti_taunt, 1, [1, 100], 416},{attr_pet_anti_silent, 1, [1, 100], 416},{attr_pet_anti_poison, 1, [1, 100], 416},{attr_pet_dmg, 1, [1, 478], 1250},{attr_pet_dmg_magic, 1, [1, 286], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 11) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 11
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4098},{attr_pet_resist_earth, 3276}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 7856], 312},{attr_pet_mp, 3, [1, 898], 312},{attr_pet_defence, 3, [1, 2245], 312},{attr_pet_resist_metal, 3, [1, 1796], 312},{attr_pet_resist_wood, 3, [1, 1796], 312},{attr_pet_resist_water, 3, [1, 1796], 312},{attr_pet_resist_fire, 3, [1, 1796], 312},{attr_pet_resist_earth, 3, [1, 1796], 312},{attr_pet_anti_stone, 1, [1, 110], 416},{attr_pet_anti_stun, 1, [1, 110], 416},{attr_pet_anti_sleep, 1, [1, 110], 416},{attr_pet_anti_taunt, 1, [1, 110], 416},{attr_pet_anti_silent, 1, [1, 110], 416},{attr_pet_anti_poison, 1, [1, 110], 416},{attr_pet_dmg, 1, [1, 562], 1250},{attr_pet_dmg_magic, 1, [1, 337], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50056, 12) ->
    #pet_item_attr{
        base_id = 50056
        ,name = <<"真·御土之灵">>
        ,lev = 12
        ,exp = 131072
        ,attr = [{attr_pet_defence, 4804},{attr_pet_resist_earth, 3841}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 9130], 312},{attr_pet_mp, 3, [1, 1044], 312},{attr_pet_defence, 3, [1, 2609], 312},{attr_pet_resist_metal, 3, [1, 2087], 312},{attr_pet_resist_wood, 3, [1, 2087], 312},{attr_pet_resist_water, 3, [1, 2087], 312},{attr_pet_resist_fire, 3, [1, 2087], 312},{attr_pet_resist_earth, 3, [1, 2087], 312},{attr_pet_anti_stone, 1, [1, 120], 416},{attr_pet_anti_stun, 1, [1, 120], 416},{attr_pet_anti_sleep, 1, [1, 120], 416},{attr_pet_anti_taunt, 1, [1, 120], 416},{attr_pet_anti_silent, 1, [1, 120], 416},{attr_pet_anti_poison, 1, [1, 120], 416},{attr_pet_dmg, 1, [1, 653], 1250},{attr_pet_dmg_magic, 1, [1, 391], 1250},{attr_pet_skill_anima, 1, [1, 1], 100},{attr_pet_skill_id, 1, [111000, 114000], 200}]
    };
get_item_attr(50057, 1) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 1
        ,exp = 128
        ,attr = []
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 480], 312},{attr_pet_mp, 3, [1, 55], 312},{attr_pet_defence, 3, [1, 135], 312},{attr_pet_resist_metal, 3, [1, 110], 312},{attr_pet_resist_wood, 3, [1, 110], 312},{attr_pet_resist_water, 3, [1, 110], 312},{attr_pet_resist_fire, 3, [1, 110], 312},{attr_pet_resist_earth, 3, [1, 110], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 35], 1250},{attr_pet_dmg_magic, 1, [1, 22], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 2) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 2
        ,exp = 256
        ,attr = [{attr_pet_dmg, 32}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 717], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 205], 312},{attr_pet_resist_metal, 3, [1, 164], 312},{attr_pet_resist_wood, 3, [1, 164], 312},{attr_pet_resist_water, 3, [1, 164], 312},{attr_pet_resist_fire, 3, [1, 164], 312},{attr_pet_resist_earth, 3, [1, 164], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 52], 1250},{attr_pet_dmg_magic, 1, [1, 31], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 3) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 3
        ,exp = 512
        ,attr = [{attr_pet_dmg, 89}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1130], 312},{attr_pet_mp, 3, [1, 130], 312},{attr_pet_defence, 3, [1, 323], 312},{attr_pet_resist_metal, 3, [1, 258], 312},{attr_pet_resist_wood, 3, [1, 258], 312},{attr_pet_resist_water, 3, [1, 258], 312},{attr_pet_resist_fire, 3, [1, 258], 312},{attr_pet_resist_earth, 3, [1, 258], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 81], 1250},{attr_pet_dmg_magic, 1, [1, 48], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 4) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 4
        ,exp = 1024
        ,attr = [{attr_pet_dmg, 159}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1637], 312},{attr_pet_mp, 3, [1, 187], 312},{attr_pet_defence, 3, [1, 468], 312},{attr_pet_resist_metal, 3, [1, 374], 312},{attr_pet_resist_wood, 3, [1, 374], 312},{attr_pet_resist_water, 3, [1, 374], 312},{attr_pet_resist_fire, 3, [1, 374], 312},{attr_pet_resist_earth, 3, [1, 374], 312},{attr_pet_anti_stone, 1, [1, 40], 416},{attr_pet_anti_stun, 1, [1, 40], 416},{attr_pet_anti_sleep, 1, [1, 40], 416},{attr_pet_anti_taunt, 1, [1, 40], 416},{attr_pet_anti_silent, 1, [1, 40], 416},{attr_pet_anti_poison, 1, [1, 40], 416},{attr_pet_dmg, 1, [1, 117], 1250},{attr_pet_dmg_magic, 1, [1, 70], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 5) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 5
        ,exp = 2048
        ,attr = [{attr_pet_dmg, 243}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2238], 312},{attr_pet_mp, 3, [1, 256], 312},{attr_pet_defence, 3, [1, 640], 312},{attr_pet_resist_metal, 3, [1, 512], 312},{attr_pet_resist_wood, 3, [1, 512], 312},{attr_pet_resist_water, 3, [1, 512], 312},{attr_pet_resist_fire, 3, [1, 512], 312},{attr_pet_resist_earth, 3, [1, 512], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 160], 1250},{attr_pet_dmg_magic, 1, [1, 96], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 6) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 6
        ,exp = 4096
        ,attr = [{attr_pet_dmg, 339}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2935], 312},{attr_pet_mp, 3, [1, 336], 312},{attr_pet_defence, 3, [1, 839], 312},{attr_pet_resist_metal, 3, [1, 671], 312},{attr_pet_resist_wood, 3, [1, 671], 312},{attr_pet_resist_water, 3, [1, 671], 312},{attr_pet_resist_fire, 3, [1, 671], 312},{attr_pet_resist_earth, 3, [1, 671], 312},{attr_pet_anti_stone, 1, [1, 60], 416},{attr_pet_anti_stun, 1, [1, 60], 416},{attr_pet_anti_sleep, 1, [1, 60], 416},{attr_pet_anti_taunt, 1, [1, 60], 416},{attr_pet_anti_silent, 1, [1, 60], 416},{attr_pet_anti_poison, 1, [1, 60], 416},{attr_pet_dmg, 1, [1, 210], 1250},{attr_pet_dmg_magic, 1, [1, 126], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 7) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 7
        ,exp = 8192
        ,attr = [{attr_pet_dmg, 449}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 3727], 312},{attr_pet_mp, 3, [1, 426], 312},{attr_pet_defence, 3, [1, 1065], 312},{attr_pet_resist_metal, 3, [1, 852], 312},{attr_pet_resist_wood, 3, [1, 852], 312},{attr_pet_resist_water, 3, [1, 852], 312},{attr_pet_resist_fire, 3, [1, 852], 312},{attr_pet_resist_earth, 3, [1, 852], 312},{attr_pet_anti_stone, 1, [1, 70], 416},{attr_pet_anti_stun, 1, [1, 70], 416},{attr_pet_anti_sleep, 1, [1, 70], 416},{attr_pet_anti_taunt, 1, [1, 70], 416},{attr_pet_anti_silent, 1, [1, 70], 416},{attr_pet_anti_poison, 1, [1, 70], 416},{attr_pet_dmg, 1, [1, 267], 1250},{attr_pet_dmg_magic, 1, [1, 160], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 8) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 8
        ,exp = 16384
        ,attr = [{attr_pet_dmg, 572}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 4615], 312},{attr_pet_mp, 3, [1, 528], 312},{attr_pet_defence, 3, [1, 1319], 312},{attr_pet_resist_metal, 3, [1, 1055], 312},{attr_pet_resist_wood, 3, [1, 1055], 312},{attr_pet_resist_water, 3, [1, 1055], 312},{attr_pet_resist_fire, 3, [1, 1055], 312},{attr_pet_resist_earth, 3, [1, 1055], 312},{attr_pet_anti_stone, 1, [1, 80], 416},{attr_pet_anti_stun, 1, [1, 80], 416},{attr_pet_anti_sleep, 1, [1, 80], 416},{attr_pet_anti_taunt, 1, [1, 80], 416},{attr_pet_anti_silent, 1, [1, 80], 416},{attr_pet_anti_poison, 1, [1, 80], 416},{attr_pet_dmg, 1, [1, 330], 1250},{attr_pet_dmg_magic, 1, [1, 198], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 9) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 9
        ,exp = 32768
        ,attr = [{attr_pet_dmg, 709}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 5599], 312},{attr_pet_mp, 3, [1, 640], 312},{attr_pet_defence, 3, [1, 1600], 312},{attr_pet_resist_metal, 3, [1, 1280], 312},{attr_pet_resist_wood, 3, [1, 1280], 312},{attr_pet_resist_water, 3, [1, 1280], 312},{attr_pet_resist_fire, 3, [1, 1280], 312},{attr_pet_resist_earth, 3, [1, 1280], 312},{attr_pet_anti_stone, 1, [1, 90], 416},{attr_pet_anti_stun, 1, [1, 90], 416},{attr_pet_anti_sleep, 1, [1, 90], 416},{attr_pet_anti_taunt, 1, [1, 90], 416},{attr_pet_anti_silent, 1, [1, 90], 416},{attr_pet_anti_poison, 1, [1, 90], 416},{attr_pet_dmg, 1, [1, 400], 1250},{attr_pet_dmg_magic, 1, [1, 240], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 10) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 10
        ,exp = 65536
        ,attr = [{attr_pet_dmg, 859}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 6680], 312},{attr_pet_mp, 3, [1, 764], 312},{attr_pet_defence, 3, [1, 1909], 312},{attr_pet_resist_metal, 3, [1, 1527], 312},{attr_pet_resist_wood, 3, [1, 1527], 312},{attr_pet_resist_water, 3, [1, 1527], 312},{attr_pet_resist_fire, 3, [1, 1527], 312},{attr_pet_resist_earth, 3, [1, 1527], 312},{attr_pet_anti_stone, 1, [1, 100], 416},{attr_pet_anti_stun, 1, [1, 100], 416},{attr_pet_anti_sleep, 1, [1, 100], 416},{attr_pet_anti_taunt, 1, [1, 100], 416},{attr_pet_anti_silent, 1, [1, 100], 416},{attr_pet_anti_poison, 1, [1, 100], 416},{attr_pet_dmg, 1, [1, 478], 1250},{attr_pet_dmg_magic, 1, [1, 286], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 11) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 11
        ,exp = 131072
        ,attr = [{attr_pet_dmg, 1022}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 7856], 312},{attr_pet_mp, 3, [1, 898], 312},{attr_pet_defence, 3, [1, 2245], 312},{attr_pet_resist_metal, 3, [1, 1796], 312},{attr_pet_resist_wood, 3, [1, 1796], 312},{attr_pet_resist_water, 3, [1, 1796], 312},{attr_pet_resist_fire, 3, [1, 1796], 312},{attr_pet_resist_earth, 3, [1, 1796], 312},{attr_pet_anti_stone, 1, [1, 110], 416},{attr_pet_anti_stun, 1, [1, 110], 416},{attr_pet_anti_sleep, 1, [1, 110], 416},{attr_pet_anti_taunt, 1, [1, 110], 416},{attr_pet_anti_silent, 1, [1, 110], 416},{attr_pet_anti_poison, 1, [1, 110], 416},{attr_pet_dmg, 1, [1, 562], 1250},{attr_pet_dmg_magic, 1, [1, 337], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50057, 12) ->
    #pet_item_attr{
        base_id = 50057
        ,name = <<"真·攻击之灵">>
        ,lev = 12
        ,exp = 131072
        ,attr = [{attr_pet_dmg, 1198}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 9130], 312},{attr_pet_mp, 3, [1, 1044], 312},{attr_pet_defence, 3, [1, 2609], 312},{attr_pet_resist_metal, 3, [1, 2087], 312},{attr_pet_resist_wood, 3, [1, 2087], 312},{attr_pet_resist_water, 3, [1, 2087], 312},{attr_pet_resist_fire, 3, [1, 2087], 312},{attr_pet_resist_earth, 3, [1, 2087], 312},{attr_pet_anti_stone, 1, [1, 120], 416},{attr_pet_anti_stun, 1, [1, 120], 416},{attr_pet_anti_sleep, 1, [1, 120], 416},{attr_pet_anti_taunt, 1, [1, 120], 416},{attr_pet_anti_silent, 1, [1, 120], 416},{attr_pet_anti_poison, 1, [1, 120], 416},{attr_pet_dmg, 1, [1, 653], 1250},{attr_pet_dmg_magic, 1, [1, 391], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [110000], 200}]
    };
get_item_attr(50058, 1) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 1
        ,exp = 128
        ,attr = []
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 480], 312},{attr_pet_mp, 3, [1, 55], 312},{attr_pet_defence, 3, [1, 135], 312},{attr_pet_resist_metal, 3, [1, 110], 312},{attr_pet_resist_wood, 3, [1, 110], 312},{attr_pet_resist_water, 3, [1, 110], 312},{attr_pet_resist_fire, 3, [1, 110], 312},{attr_pet_resist_earth, 3, [1, 110], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 35], 1250},{attr_pet_dmg_magic, 1, [1, 22], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 2) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 2
        ,exp = 256
        ,attr = [{attr_pet_dmg_magic, 20}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 717], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 205], 312},{attr_pet_resist_metal, 3, [1, 164], 312},{attr_pet_resist_wood, 3, [1, 164], 312},{attr_pet_resist_water, 3, [1, 164], 312},{attr_pet_resist_fire, 3, [1, 164], 312},{attr_pet_resist_earth, 3, [1, 164], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 52], 1250},{attr_pet_dmg_magic, 1, [1, 31], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 3) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 3
        ,exp = 512
        ,attr = [{attr_pet_dmg_magic, 54}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1130], 312},{attr_pet_mp, 3, [1, 130], 312},{attr_pet_defence, 3, [1, 323], 312},{attr_pet_resist_metal, 3, [1, 258], 312},{attr_pet_resist_wood, 3, [1, 258], 312},{attr_pet_resist_water, 3, [1, 258], 312},{attr_pet_resist_fire, 3, [1, 258], 312},{attr_pet_resist_earth, 3, [1, 258], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 81], 1250},{attr_pet_dmg_magic, 1, [1, 48], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 4) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 4
        ,exp = 1024
        ,attr = [{attr_pet_dmg_magic, 96}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 1637], 312},{attr_pet_mp, 3, [1, 187], 312},{attr_pet_defence, 3, [1, 468], 312},{attr_pet_resist_metal, 3, [1, 374], 312},{attr_pet_resist_wood, 3, [1, 374], 312},{attr_pet_resist_water, 3, [1, 374], 312},{attr_pet_resist_fire, 3, [1, 374], 312},{attr_pet_resist_earth, 3, [1, 374], 312},{attr_pet_anti_stone, 1, [1, 40], 416},{attr_pet_anti_stun, 1, [1, 40], 416},{attr_pet_anti_sleep, 1, [1, 40], 416},{attr_pet_anti_taunt, 1, [1, 40], 416},{attr_pet_anti_silent, 1, [1, 40], 416},{attr_pet_anti_poison, 1, [1, 40], 416},{attr_pet_dmg, 1, [1, 117], 1250},{attr_pet_dmg_magic, 1, [1, 70], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 5) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 5
        ,exp = 2048
        ,attr = [{attr_pet_dmg_magic, 146}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2238], 312},{attr_pet_mp, 3, [1, 256], 312},{attr_pet_defence, 3, [1, 640], 312},{attr_pet_resist_metal, 3, [1, 512], 312},{attr_pet_resist_wood, 3, [1, 512], 312},{attr_pet_resist_water, 3, [1, 512], 312},{attr_pet_resist_fire, 3, [1, 512], 312},{attr_pet_resist_earth, 3, [1, 512], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 160], 1250},{attr_pet_dmg_magic, 1, [1, 96], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 6) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 6
        ,exp = 4096
        ,attr = [{attr_pet_dmg_magic, 204}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 2935], 312},{attr_pet_mp, 3, [1, 336], 312},{attr_pet_defence, 3, [1, 839], 312},{attr_pet_resist_metal, 3, [1, 671], 312},{attr_pet_resist_wood, 3, [1, 671], 312},{attr_pet_resist_water, 3, [1, 671], 312},{attr_pet_resist_fire, 3, [1, 671], 312},{attr_pet_resist_earth, 3, [1, 671], 312},{attr_pet_anti_stone, 1, [1, 60], 416},{attr_pet_anti_stun, 1, [1, 60], 416},{attr_pet_anti_sleep, 1, [1, 60], 416},{attr_pet_anti_taunt, 1, [1, 60], 416},{attr_pet_anti_silent, 1, [1, 60], 416},{attr_pet_anti_poison, 1, [1, 60], 416},{attr_pet_dmg, 1, [1, 210], 1250},{attr_pet_dmg_magic, 1, [1, 126], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 7) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 7
        ,exp = 8192
        ,attr = [{attr_pet_dmg_magic, 270}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 3727], 312},{attr_pet_mp, 3, [1, 426], 312},{attr_pet_defence, 3, [1, 1065], 312},{attr_pet_resist_metal, 3, [1, 852], 312},{attr_pet_resist_wood, 3, [1, 852], 312},{attr_pet_resist_water, 3, [1, 852], 312},{attr_pet_resist_fire, 3, [1, 852], 312},{attr_pet_resist_earth, 3, [1, 852], 312},{attr_pet_anti_stone, 1, [1, 70], 416},{attr_pet_anti_stun, 1, [1, 70], 416},{attr_pet_anti_sleep, 1, [1, 70], 416},{attr_pet_anti_taunt, 1, [1, 70], 416},{attr_pet_anti_silent, 1, [1, 70], 416},{attr_pet_anti_poison, 1, [1, 70], 416},{attr_pet_dmg, 1, [1, 267], 1250},{attr_pet_dmg_magic, 1, [1, 160], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 8) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 8
        ,exp = 16384
        ,attr = [{attr_pet_dmg_magic, 344}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 4615], 312},{attr_pet_mp, 3, [1, 528], 312},{attr_pet_defence, 3, [1, 1319], 312},{attr_pet_resist_metal, 3, [1, 1055], 312},{attr_pet_resist_wood, 3, [1, 1055], 312},{attr_pet_resist_water, 3, [1, 1055], 312},{attr_pet_resist_fire, 3, [1, 1055], 312},{attr_pet_resist_earth, 3, [1, 1055], 312},{attr_pet_anti_stone, 1, [1, 80], 416},{attr_pet_anti_stun, 1, [1, 80], 416},{attr_pet_anti_sleep, 1, [1, 80], 416},{attr_pet_anti_taunt, 1, [1, 80], 416},{attr_pet_anti_silent, 1, [1, 80], 416},{attr_pet_anti_poison, 1, [1, 80], 416},{attr_pet_dmg, 1, [1, 330], 1250},{attr_pet_dmg_magic, 1, [1, 198], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 9) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 9
        ,exp = 32768
        ,attr = [{attr_pet_dmg_magic, 426}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 5599], 312},{attr_pet_mp, 3, [1, 640], 312},{attr_pet_defence, 3, [1, 1600], 312},{attr_pet_resist_metal, 3, [1, 1280], 312},{attr_pet_resist_wood, 3, [1, 1280], 312},{attr_pet_resist_water, 3, [1, 1280], 312},{attr_pet_resist_fire, 3, [1, 1280], 312},{attr_pet_resist_earth, 3, [1, 1280], 312},{attr_pet_anti_stone, 1, [1, 90], 416},{attr_pet_anti_stun, 1, [1, 90], 416},{attr_pet_anti_sleep, 1, [1, 90], 416},{attr_pet_anti_taunt, 1, [1, 90], 416},{attr_pet_anti_silent, 1, [1, 90], 416},{attr_pet_anti_poison, 1, [1, 90], 416},{attr_pet_dmg, 1, [1, 400], 1250},{attr_pet_dmg_magic, 1, [1, 240], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 10) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 10
        ,exp = 65536
        ,attr = [{attr_pet_dmg_magic, 516}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 6680], 312},{attr_pet_mp, 3, [1, 764], 312},{attr_pet_defence, 3, [1, 1909], 312},{attr_pet_resist_metal, 3, [1, 1527], 312},{attr_pet_resist_wood, 3, [1, 1527], 312},{attr_pet_resist_water, 3, [1, 1527], 312},{attr_pet_resist_fire, 3, [1, 1527], 312},{attr_pet_resist_earth, 3, [1, 1527], 312},{attr_pet_anti_stone, 1, [1, 100], 416},{attr_pet_anti_stun, 1, [1, 100], 416},{attr_pet_anti_sleep, 1, [1, 100], 416},{attr_pet_anti_taunt, 1, [1, 100], 416},{attr_pet_anti_silent, 1, [1, 100], 416},{attr_pet_anti_poison, 1, [1, 100], 416},{attr_pet_dmg, 1, [1, 478], 1250},{attr_pet_dmg_magic, 1, [1, 286], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 11) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 11
        ,exp = 131072
        ,attr = [{attr_pet_dmg_magic, 614}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 7856], 312},{attr_pet_mp, 3, [1, 898], 312},{attr_pet_defence, 3, [1, 2245], 312},{attr_pet_resist_metal, 3, [1, 1796], 312},{attr_pet_resist_wood, 3, [1, 1796], 312},{attr_pet_resist_water, 3, [1, 1796], 312},{attr_pet_resist_fire, 3, [1, 1796], 312},{attr_pet_resist_earth, 3, [1, 1796], 312},{attr_pet_anti_stone, 1, [1, 110], 416},{attr_pet_anti_stun, 1, [1, 110], 416},{attr_pet_anti_sleep, 1, [1, 110], 416},{attr_pet_anti_taunt, 1, [1, 110], 416},{attr_pet_anti_silent, 1, [1, 110], 416},{attr_pet_anti_poison, 1, [1, 110], 416},{attr_pet_dmg, 1, [1, 562], 1250},{attr_pet_dmg_magic, 1, [1, 337], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50058, 12) ->
    #pet_item_attr{
        base_id = 50058
        ,name = <<"真·法伤之灵">>
        ,lev = 12
        ,exp = 131072
        ,attr = [{attr_pet_dmg_magic, 719}]
        ,polish = {3, 5}
        ,polish_list = [{attr_pet_hp, 3, [1, 9130], 312},{attr_pet_mp, 3, [1, 1044], 312},{attr_pet_defence, 3, [1, 2609], 312},{attr_pet_resist_metal, 3, [1, 2087], 312},{attr_pet_resist_wood, 3, [1, 2087], 312},{attr_pet_resist_water, 3, [1, 2087], 312},{attr_pet_resist_fire, 3, [1, 2087], 312},{attr_pet_resist_earth, 3, [1, 2087], 312},{attr_pet_anti_stone, 1, [1, 120], 416},{attr_pet_anti_stun, 1, [1, 120], 416},{attr_pet_anti_sleep, 1, [1, 120], 416},{attr_pet_anti_taunt, 1, [1, 120], 416},{attr_pet_anti_silent, 1, [1, 120], 416},{attr_pet_anti_poison, 1, [1, 120], 416},{attr_pet_dmg, 1, [1, 653], 1250},{attr_pet_dmg_magic, 1, [1, 391], 1250},{attr_pet_skill_kill, 1, [1, 2], 100},{attr_pet_skill_id, 1, [130000], 200}]
    };
get_item_attr(50101, 1) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 1
        ,exp = 64
        ,attr = []
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 300], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 69], 312},{attr_pet_resist_wood, 3, [1, 69], 312},{attr_pet_resist_water, 3, [1, 69], 312},{attr_pet_resist_fire, 3, [1, 69], 312},{attr_pet_resist_earth, 3, [1, 69], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 14], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 2) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 2
        ,exp = 128
        ,attr = [{attr_pet_hp, 307},{attr_pet_mp, 31}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 449], 312},{attr_pet_mp, 3, [1, 52], 312},{attr_pet_defence, 3, [1, 129], 312},{attr_pet_resist_metal, 3, [1, 103], 312},{attr_pet_resist_wood, 3, [1, 103], 312},{attr_pet_resist_water, 3, [1, 103], 312},{attr_pet_resist_fire, 3, [1, 103], 312},{attr_pet_resist_earth, 3, [1, 103], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 3) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 3
        ,exp = 256
        ,attr = [{attr_pet_hp, 807},{attr_pet_mp, 88}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 707], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 202], 312},{attr_pet_resist_metal, 3, [1, 162], 312},{attr_pet_resist_wood, 3, [1, 162], 312},{attr_pet_resist_water, 3, [1, 162], 312},{attr_pet_resist_fire, 3, [1, 162], 312},{attr_pet_resist_earth, 3, [1, 162], 312},{attr_pet_anti_stone, 1, [1, 19], 416},{attr_pet_anti_stun, 1, [1, 19], 416},{attr_pet_anti_sleep, 1, [1, 19], 416},{attr_pet_anti_taunt, 1, [1, 19], 416},{attr_pet_anti_silent, 1, [1, 19], 416},{attr_pet_anti_poison, 1, [1, 19], 416},{attr_pet_dmg, 1, [1, 51], 1250},{attr_pet_dmg_magic, 1, [1, 30], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 4) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 4
        ,exp = 512
        ,attr = [{attr_pet_hp, 1422},{attr_pet_mp, 158}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1024], 312},{attr_pet_mp, 3, [1, 117], 312},{attr_pet_defence, 3, [1, 293], 312},{attr_pet_resist_metal, 3, [1, 234], 312},{attr_pet_resist_wood, 3, [1, 234], 312},{attr_pet_resist_water, 3, [1, 234], 312},{attr_pet_resist_fire, 3, [1, 234], 312},{attr_pet_resist_earth, 3, [1, 234], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 74], 1250},{attr_pet_dmg_magic, 1, [1, 44], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 5) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 5
        ,exp = 1024
        ,attr = [{attr_pet_hp, 2152},{attr_pet_mp, 242}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1399], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 32], 416},{attr_pet_anti_stun, 1, [1, 32], 416},{attr_pet_anti_sleep, 1, [1, 32], 416},{attr_pet_anti_taunt, 1, [1, 32], 416},{attr_pet_anti_silent, 1, [1, 32], 416},{attr_pet_anti_poison, 1, [1, 32], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 6) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 6
        ,exp = 2048
        ,attr = [{attr_pet_hp, 2998},{attr_pet_mp, 339}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1835], 312},{attr_pet_mp, 3, [1, 210], 312},{attr_pet_defence, 3, [1, 525], 312},{attr_pet_resist_metal, 3, [1, 420], 312},{attr_pet_resist_wood, 3, [1, 420], 312},{attr_pet_resist_water, 3, [1, 420], 312},{attr_pet_resist_fire, 3, [1, 420], 312},{attr_pet_resist_earth, 3, [1, 420], 312},{attr_pet_anti_stone, 1, [1, 38], 416},{attr_pet_anti_stun, 1, [1, 38], 416},{attr_pet_anti_sleep, 1, [1, 38], 416},{attr_pet_anti_taunt, 1, [1, 38], 416},{attr_pet_anti_silent, 1, [1, 38], 416},{attr_pet_anti_poison, 1, [1, 38], 416},{attr_pet_dmg, 1, [1, 132], 1250},{attr_pet_dmg_magic, 1, [1, 79], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 7) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 7
        ,exp = 4096
        ,attr = [{attr_pet_hp, 3959},{attr_pet_mp, 448}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2330], 312},{attr_pet_mp, 3, [1, 267], 312},{attr_pet_defence, 3, [1, 666], 312},{attr_pet_resist_metal, 3, [1, 533], 312},{attr_pet_resist_wood, 3, [1, 533], 312},{attr_pet_resist_water, 3, [1, 533], 312},{attr_pet_resist_fire, 3, [1, 533], 312},{attr_pet_resist_earth, 3, [1, 533], 312},{attr_pet_anti_stone, 1, [1, 44], 416},{attr_pet_anti_stun, 1, [1, 44], 416},{attr_pet_anti_sleep, 1, [1, 44], 416},{attr_pet_anti_taunt, 1, [1, 44], 416},{attr_pet_anti_silent, 1, [1, 44], 416},{attr_pet_anti_poison, 1, [1, 44], 416},{attr_pet_dmg, 1, [1, 167], 1250},{attr_pet_dmg_magic, 1, [1, 100], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 8) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 8
        ,exp = 8192
        ,attr = [{attr_pet_hp, 5037},{attr_pet_mp, 571}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2885], 312},{attr_pet_mp, 3, [1, 330], 312},{attr_pet_defence, 3, [1, 825], 312},{attr_pet_resist_metal, 3, [1, 660], 312},{attr_pet_resist_wood, 3, [1, 660], 312},{attr_pet_resist_water, 3, [1, 660], 312},{attr_pet_resist_fire, 3, [1, 660], 312},{attr_pet_resist_earth, 3, [1, 660], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 207], 1250},{attr_pet_dmg_magic, 1, [1, 124], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 9) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 9
        ,exp = 16384
        ,attr = [{attr_pet_hp, 6231},{attr_pet_mp, 708}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 3500], 312},{attr_pet_mp, 3, [1, 400], 312},{attr_pet_defence, 3, [1, 1000], 312},{attr_pet_resist_metal, 3, [1, 800], 312},{attr_pet_resist_wood, 3, [1, 800], 312},{attr_pet_resist_water, 3, [1, 800], 312},{attr_pet_resist_fire, 3, [1, 800], 312},{attr_pet_resist_earth, 3, [1, 800], 312},{attr_pet_anti_stone, 1, [1, 57], 416},{attr_pet_anti_stun, 1, [1, 57], 416},{attr_pet_anti_sleep, 1, [1, 57], 416},{attr_pet_anti_taunt, 1, [1, 57], 416},{attr_pet_anti_silent, 1, [1, 57], 416},{attr_pet_anti_poison, 1, [1, 57], 416},{attr_pet_dmg, 1, [1, 250], 1250},{attr_pet_dmg_magic, 1, [1, 150], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 10) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 10
        ,exp = 32768
        ,attr = [{attr_pet_hp, 7541},{attr_pet_mp, 858}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4175], 312},{attr_pet_mp, 3, [1, 478], 312},{attr_pet_defence, 3, [1, 1194], 312},{attr_pet_resist_metal, 3, [1, 955], 312},{attr_pet_resist_wood, 3, [1, 955], 312},{attr_pet_resist_water, 3, [1, 955], 312},{attr_pet_resist_fire, 3, [1, 955], 312},{attr_pet_resist_earth, 3, [1, 955], 312},{attr_pet_anti_stone, 1, [1, 63], 416},{attr_pet_anti_stun, 1, [1, 63], 416},{attr_pet_anti_sleep, 1, [1, 63], 416},{attr_pet_anti_taunt, 1, [1, 63], 416},{attr_pet_anti_silent, 1, [1, 63], 416},{attr_pet_anti_poison, 1, [1, 63], 416},{attr_pet_dmg, 1, [1, 299], 1250},{attr_pet_dmg_magic, 1, [1, 179], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 11) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 11
        ,exp = 65536
        ,attr = [{attr_pet_hp, 8969},{attr_pet_mp, 1021}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4910], 312},{attr_pet_mp, 3, [1, 562], 312},{attr_pet_defence, 3, [1, 1404], 312},{attr_pet_resist_metal, 3, [1, 1123], 312},{attr_pet_resist_wood, 3, [1, 1123], 312},{attr_pet_resist_water, 3, [1, 1123], 312},{attr_pet_resist_fire, 3, [1, 1123], 312},{attr_pet_resist_earth, 3, [1, 1123], 312},{attr_pet_anti_stone, 1, [1, 69], 416},{attr_pet_anti_stun, 1, [1, 69], 416},{attr_pet_anti_sleep, 1, [1, 69], 416},{attr_pet_anti_taunt, 1, [1, 69], 416},{attr_pet_anti_silent, 1, [1, 69], 416},{attr_pet_anti_poison, 1, [1, 69], 416},{attr_pet_dmg, 1, [1, 352], 1250},{attr_pet_dmg_magic, 1, [1, 211], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50101, 12) ->
    #pet_item_attr{
        base_id = 50101
        ,name = <<"血法之灵">>
        ,lev = 12
        ,exp = 65536
        ,attr = [{attr_pet_hp, 10514},{attr_pet_mp, 1198}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 5707], 312},{attr_pet_mp, 3, [1, 653], 312},{attr_pet_defence, 3, [1, 1631], 312},{attr_pet_resist_metal, 3, [1, 1305], 312},{attr_pet_resist_wood, 3, [1, 1305], 312},{attr_pet_resist_water, 3, [1, 1305], 312},{attr_pet_resist_fire, 3, [1, 1305], 312},{attr_pet_resist_earth, 3, [1, 1305], 312},{attr_pet_anti_stone, 1, [1, 75], 416},{attr_pet_anti_stun, 1, [1, 75], 416},{attr_pet_anti_sleep, 1, [1, 75], 416},{attr_pet_anti_taunt, 1, [1, 75], 416},{attr_pet_anti_silent, 1, [1, 75], 416},{attr_pet_anti_poison, 1, [1, 75], 416},{attr_pet_dmg, 1, [1, 409], 1250},{attr_pet_dmg_magic, 1, [1, 245], 1250},{attr_pet_anti_attack, 1, [1, 9], 1000},{attr_pet_skill_protect, 1, [1, 2], 100}]
    };
get_item_attr(50102, 1) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 1
        ,exp = 64
        ,attr = []
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 300], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 69], 312},{attr_pet_resist_wood, 3, [1, 69], 312},{attr_pet_resist_water, 3, [1, 69], 312},{attr_pet_resist_fire, 3, [1, 69], 312},{attr_pet_resist_earth, 3, [1, 69], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 14], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 2) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 2
        ,exp = 128
        ,attr = [{attr_pet_defence, 86},{attr_pet_resist_metal, 68}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 449], 312},{attr_pet_mp, 3, [1, 52], 312},{attr_pet_defence, 3, [1, 129], 312},{attr_pet_resist_metal, 3, [1, 103], 312},{attr_pet_resist_wood, 3, [1, 103], 312},{attr_pet_resist_water, 3, [1, 103], 312},{attr_pet_resist_fire, 3, [1, 103], 312},{attr_pet_resist_earth, 3, [1, 103], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 3) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 3
        ,exp = 256
        ,attr = [{attr_pet_defence, 229},{attr_pet_resist_metal, 183}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 707], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 202], 312},{attr_pet_resist_metal, 3, [1, 162], 312},{attr_pet_resist_wood, 3, [1, 162], 312},{attr_pet_resist_water, 3, [1, 162], 312},{attr_pet_resist_fire, 3, [1, 162], 312},{attr_pet_resist_earth, 3, [1, 162], 312},{attr_pet_anti_stone, 1, [1, 19], 416},{attr_pet_anti_stun, 1, [1, 19], 416},{attr_pet_anti_sleep, 1, [1, 19], 416},{attr_pet_anti_taunt, 1, [1, 19], 416},{attr_pet_anti_silent, 1, [1, 19], 416},{attr_pet_anti_poison, 1, [1, 19], 416},{attr_pet_dmg, 1, [1, 51], 1250},{attr_pet_dmg_magic, 1, [1, 30], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 4) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 4
        ,exp = 512
        ,attr = [{attr_pet_defence, 405},{attr_pet_resist_metal, 323}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1024], 312},{attr_pet_mp, 3, [1, 117], 312},{attr_pet_defence, 3, [1, 293], 312},{attr_pet_resist_metal, 3, [1, 234], 312},{attr_pet_resist_wood, 3, [1, 234], 312},{attr_pet_resist_water, 3, [1, 234], 312},{attr_pet_resist_fire, 3, [1, 234], 312},{attr_pet_resist_earth, 3, [1, 234], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 74], 1250},{attr_pet_dmg_magic, 1, [1, 44], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 5) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 5
        ,exp = 1024
        ,attr = [{attr_pet_defence, 614},{attr_pet_resist_metal, 490}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1399], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 32], 416},{attr_pet_anti_stun, 1, [1, 32], 416},{attr_pet_anti_sleep, 1, [1, 32], 416},{attr_pet_anti_taunt, 1, [1, 32], 416},{attr_pet_anti_silent, 1, [1, 32], 416},{attr_pet_anti_poison, 1, [1, 32], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 6) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 6
        ,exp = 2048
        ,attr = [{attr_pet_defence, 855},{attr_pet_resist_metal, 683}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1835], 312},{attr_pet_mp, 3, [1, 210], 312},{attr_pet_defence, 3, [1, 525], 312},{attr_pet_resist_metal, 3, [1, 420], 312},{attr_pet_resist_wood, 3, [1, 420], 312},{attr_pet_resist_water, 3, [1, 420], 312},{attr_pet_resist_fire, 3, [1, 420], 312},{attr_pet_resist_earth, 3, [1, 420], 312},{attr_pet_anti_stone, 1, [1, 38], 416},{attr_pet_anti_stun, 1, [1, 38], 416},{attr_pet_anti_sleep, 1, [1, 38], 416},{attr_pet_anti_taunt, 1, [1, 38], 416},{attr_pet_anti_silent, 1, [1, 38], 416},{attr_pet_anti_poison, 1, [1, 38], 416},{attr_pet_dmg, 1, [1, 132], 1250},{attr_pet_dmg_magic, 1, [1, 79], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 7) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 7
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1129},{attr_pet_resist_metal, 903}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2330], 312},{attr_pet_mp, 3, [1, 267], 312},{attr_pet_defence, 3, [1, 666], 312},{attr_pet_resist_metal, 3, [1, 533], 312},{attr_pet_resist_wood, 3, [1, 533], 312},{attr_pet_resist_water, 3, [1, 533], 312},{attr_pet_resist_fire, 3, [1, 533], 312},{attr_pet_resist_earth, 3, [1, 533], 312},{attr_pet_anti_stone, 1, [1, 44], 416},{attr_pet_anti_stun, 1, [1, 44], 416},{attr_pet_anti_sleep, 1, [1, 44], 416},{attr_pet_anti_taunt, 1, [1, 44], 416},{attr_pet_anti_silent, 1, [1, 44], 416},{attr_pet_anti_poison, 1, [1, 44], 416},{attr_pet_dmg, 1, [1, 167], 1250},{attr_pet_dmg_magic, 1, [1, 100], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 8) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 8
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1437},{attr_pet_resist_metal, 1149}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2885], 312},{attr_pet_mp, 3, [1, 330], 312},{attr_pet_defence, 3, [1, 825], 312},{attr_pet_resist_metal, 3, [1, 660], 312},{attr_pet_resist_wood, 3, [1, 660], 312},{attr_pet_resist_water, 3, [1, 660], 312},{attr_pet_resist_fire, 3, [1, 660], 312},{attr_pet_resist_earth, 3, [1, 660], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 207], 1250},{attr_pet_dmg_magic, 1, [1, 124], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 9) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 9
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1779},{attr_pet_resist_metal, 1422}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 3500], 312},{attr_pet_mp, 3, [1, 400], 312},{attr_pet_defence, 3, [1, 1000], 312},{attr_pet_resist_metal, 3, [1, 800], 312},{attr_pet_resist_wood, 3, [1, 800], 312},{attr_pet_resist_water, 3, [1, 800], 312},{attr_pet_resist_fire, 3, [1, 800], 312},{attr_pet_resist_earth, 3, [1, 800], 312},{attr_pet_anti_stone, 1, [1, 57], 416},{attr_pet_anti_stun, 1, [1, 57], 416},{attr_pet_anti_sleep, 1, [1, 57], 416},{attr_pet_anti_taunt, 1, [1, 57], 416},{attr_pet_anti_silent, 1, [1, 57], 416},{attr_pet_anti_poison, 1, [1, 57], 416},{attr_pet_dmg, 1, [1, 250], 1250},{attr_pet_dmg_magic, 1, [1, 150], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 10) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 10
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2153},{attr_pet_resist_metal, 1722}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4175], 312},{attr_pet_mp, 3, [1, 478], 312},{attr_pet_defence, 3, [1, 1194], 312},{attr_pet_resist_metal, 3, [1, 955], 312},{attr_pet_resist_wood, 3, [1, 955], 312},{attr_pet_resist_water, 3, [1, 955], 312},{attr_pet_resist_fire, 3, [1, 955], 312},{attr_pet_resist_earth, 3, [1, 955], 312},{attr_pet_anti_stone, 1, [1, 63], 416},{attr_pet_anti_stun, 1, [1, 63], 416},{attr_pet_anti_sleep, 1, [1, 63], 416},{attr_pet_anti_taunt, 1, [1, 63], 416},{attr_pet_anti_silent, 1, [1, 63], 416},{attr_pet_anti_poison, 1, [1, 63], 416},{attr_pet_dmg, 1, [1, 299], 1250},{attr_pet_dmg_magic, 1, [1, 179], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 11) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 11
        ,exp = 65536
        ,attr = [{attr_pet_defence, 2561},{attr_pet_resist_metal, 2048}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4910], 312},{attr_pet_mp, 3, [1, 562], 312},{attr_pet_defence, 3, [1, 1404], 312},{attr_pet_resist_metal, 3, [1, 1123], 312},{attr_pet_resist_wood, 3, [1, 1123], 312},{attr_pet_resist_water, 3, [1, 1123], 312},{attr_pet_resist_fire, 3, [1, 1123], 312},{attr_pet_resist_earth, 3, [1, 1123], 312},{attr_pet_anti_stone, 1, [1, 69], 416},{attr_pet_anti_stun, 1, [1, 69], 416},{attr_pet_anti_sleep, 1, [1, 69], 416},{attr_pet_anti_taunt, 1, [1, 69], 416},{attr_pet_anti_silent, 1, [1, 69], 416},{attr_pet_anti_poison, 1, [1, 69], 416},{attr_pet_dmg, 1, [1, 352], 1250},{attr_pet_dmg_magic, 1, [1, 211], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50102, 12) ->
    #pet_item_attr{
        base_id = 50102
        ,name = <<"御金之灵">>
        ,lev = 12
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3002},{attr_pet_resist_metal, 2401}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 5707], 312},{attr_pet_mp, 3, [1, 653], 312},{attr_pet_defence, 3, [1, 1631], 312},{attr_pet_resist_metal, 3, [1, 1305], 312},{attr_pet_resist_wood, 3, [1, 1305], 312},{attr_pet_resist_water, 3, [1, 1305], 312},{attr_pet_resist_fire, 3, [1, 1305], 312},{attr_pet_resist_earth, 3, [1, 1305], 312},{attr_pet_anti_stone, 1, [1, 75], 416},{attr_pet_anti_stun, 1, [1, 75], 416},{attr_pet_anti_sleep, 1, [1, 75], 416},{attr_pet_anti_taunt, 1, [1, 75], 416},{attr_pet_anti_silent, 1, [1, 75], 416},{attr_pet_anti_poison, 1, [1, 75], 416},{attr_pet_dmg, 1, [1, 409], 1250},{attr_pet_dmg_magic, 1, [1, 245], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 1) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 1
        ,exp = 64
        ,attr = []
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 300], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 69], 312},{attr_pet_resist_wood, 3, [1, 69], 312},{attr_pet_resist_water, 3, [1, 69], 312},{attr_pet_resist_fire, 3, [1, 69], 312},{attr_pet_resist_earth, 3, [1, 69], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 14], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 2) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 2
        ,exp = 128
        ,attr = [{attr_pet_defence, 86},{attr_pet_resist_wood, 68}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 449], 312},{attr_pet_mp, 3, [1, 52], 312},{attr_pet_defence, 3, [1, 129], 312},{attr_pet_resist_metal, 3, [1, 103], 312},{attr_pet_resist_wood, 3, [1, 103], 312},{attr_pet_resist_water, 3, [1, 103], 312},{attr_pet_resist_fire, 3, [1, 103], 312},{attr_pet_resist_earth, 3, [1, 103], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 3) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 3
        ,exp = 256
        ,attr = [{attr_pet_defence, 229},{attr_pet_resist_wood, 183}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 707], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 202], 312},{attr_pet_resist_metal, 3, [1, 162], 312},{attr_pet_resist_wood, 3, [1, 162], 312},{attr_pet_resist_water, 3, [1, 162], 312},{attr_pet_resist_fire, 3, [1, 162], 312},{attr_pet_resist_earth, 3, [1, 162], 312},{attr_pet_anti_stone, 1, [1, 19], 416},{attr_pet_anti_stun, 1, [1, 19], 416},{attr_pet_anti_sleep, 1, [1, 19], 416},{attr_pet_anti_taunt, 1, [1, 19], 416},{attr_pet_anti_silent, 1, [1, 19], 416},{attr_pet_anti_poison, 1, [1, 19], 416},{attr_pet_dmg, 1, [1, 51], 1250},{attr_pet_dmg_magic, 1, [1, 30], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 4) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 4
        ,exp = 512
        ,attr = [{attr_pet_defence, 405},{attr_pet_resist_wood, 323}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1024], 312},{attr_pet_mp, 3, [1, 117], 312},{attr_pet_defence, 3, [1, 293], 312},{attr_pet_resist_metal, 3, [1, 234], 312},{attr_pet_resist_wood, 3, [1, 234], 312},{attr_pet_resist_water, 3, [1, 234], 312},{attr_pet_resist_fire, 3, [1, 234], 312},{attr_pet_resist_earth, 3, [1, 234], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 74], 1250},{attr_pet_dmg_magic, 1, [1, 44], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 5) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 5
        ,exp = 1024
        ,attr = [{attr_pet_defence, 614},{attr_pet_resist_wood, 490}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1399], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 32], 416},{attr_pet_anti_stun, 1, [1, 32], 416},{attr_pet_anti_sleep, 1, [1, 32], 416},{attr_pet_anti_taunt, 1, [1, 32], 416},{attr_pet_anti_silent, 1, [1, 32], 416},{attr_pet_anti_poison, 1, [1, 32], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 6) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 6
        ,exp = 2048
        ,attr = [{attr_pet_defence, 855},{attr_pet_resist_wood, 683}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1835], 312},{attr_pet_mp, 3, [1, 210], 312},{attr_pet_defence, 3, [1, 525], 312},{attr_pet_resist_metal, 3, [1, 420], 312},{attr_pet_resist_wood, 3, [1, 420], 312},{attr_pet_resist_water, 3, [1, 420], 312},{attr_pet_resist_fire, 3, [1, 420], 312},{attr_pet_resist_earth, 3, [1, 420], 312},{attr_pet_anti_stone, 1, [1, 38], 416},{attr_pet_anti_stun, 1, [1, 38], 416},{attr_pet_anti_sleep, 1, [1, 38], 416},{attr_pet_anti_taunt, 1, [1, 38], 416},{attr_pet_anti_silent, 1, [1, 38], 416},{attr_pet_anti_poison, 1, [1, 38], 416},{attr_pet_dmg, 1, [1, 132], 1250},{attr_pet_dmg_magic, 1, [1, 79], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 7) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 7
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1129},{attr_pet_resist_wood, 903}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2330], 312},{attr_pet_mp, 3, [1, 267], 312},{attr_pet_defence, 3, [1, 666], 312},{attr_pet_resist_metal, 3, [1, 533], 312},{attr_pet_resist_wood, 3, [1, 533], 312},{attr_pet_resist_water, 3, [1, 533], 312},{attr_pet_resist_fire, 3, [1, 533], 312},{attr_pet_resist_earth, 3, [1, 533], 312},{attr_pet_anti_stone, 1, [1, 44], 416},{attr_pet_anti_stun, 1, [1, 44], 416},{attr_pet_anti_sleep, 1, [1, 44], 416},{attr_pet_anti_taunt, 1, [1, 44], 416},{attr_pet_anti_silent, 1, [1, 44], 416},{attr_pet_anti_poison, 1, [1, 44], 416},{attr_pet_dmg, 1, [1, 167], 1250},{attr_pet_dmg_magic, 1, [1, 100], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 8) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 8
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1437},{attr_pet_resist_wood, 1149}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2885], 312},{attr_pet_mp, 3, [1, 330], 312},{attr_pet_defence, 3, [1, 825], 312},{attr_pet_resist_metal, 3, [1, 660], 312},{attr_pet_resist_wood, 3, [1, 660], 312},{attr_pet_resist_water, 3, [1, 660], 312},{attr_pet_resist_fire, 3, [1, 660], 312},{attr_pet_resist_earth, 3, [1, 660], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 207], 1250},{attr_pet_dmg_magic, 1, [1, 124], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 9) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 9
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1779},{attr_pet_resist_wood, 1422}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 3500], 312},{attr_pet_mp, 3, [1, 400], 312},{attr_pet_defence, 3, [1, 1000], 312},{attr_pet_resist_metal, 3, [1, 800], 312},{attr_pet_resist_wood, 3, [1, 800], 312},{attr_pet_resist_water, 3, [1, 800], 312},{attr_pet_resist_fire, 3, [1, 800], 312},{attr_pet_resist_earth, 3, [1, 800], 312},{attr_pet_anti_stone, 1, [1, 57], 416},{attr_pet_anti_stun, 1, [1, 57], 416},{attr_pet_anti_sleep, 1, [1, 57], 416},{attr_pet_anti_taunt, 1, [1, 57], 416},{attr_pet_anti_silent, 1, [1, 57], 416},{attr_pet_anti_poison, 1, [1, 57], 416},{attr_pet_dmg, 1, [1, 250], 1250},{attr_pet_dmg_magic, 1, [1, 150], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 10) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 10
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2153},{attr_pet_resist_wood, 1722}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4175], 312},{attr_pet_mp, 3, [1, 478], 312},{attr_pet_defence, 3, [1, 1194], 312},{attr_pet_resist_metal, 3, [1, 955], 312},{attr_pet_resist_wood, 3, [1, 955], 312},{attr_pet_resist_water, 3, [1, 955], 312},{attr_pet_resist_fire, 3, [1, 955], 312},{attr_pet_resist_earth, 3, [1, 955], 312},{attr_pet_anti_stone, 1, [1, 63], 416},{attr_pet_anti_stun, 1, [1, 63], 416},{attr_pet_anti_sleep, 1, [1, 63], 416},{attr_pet_anti_taunt, 1, [1, 63], 416},{attr_pet_anti_silent, 1, [1, 63], 416},{attr_pet_anti_poison, 1, [1, 63], 416},{attr_pet_dmg, 1, [1, 299], 1250},{attr_pet_dmg_magic, 1, [1, 179], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 11) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 11
        ,exp = 65536
        ,attr = [{attr_pet_defence, 2561},{attr_pet_resist_wood, 2048}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4910], 312},{attr_pet_mp, 3, [1, 562], 312},{attr_pet_defence, 3, [1, 1404], 312},{attr_pet_resist_metal, 3, [1, 1123], 312},{attr_pet_resist_wood, 3, [1, 1123], 312},{attr_pet_resist_water, 3, [1, 1123], 312},{attr_pet_resist_fire, 3, [1, 1123], 312},{attr_pet_resist_earth, 3, [1, 1123], 312},{attr_pet_anti_stone, 1, [1, 69], 416},{attr_pet_anti_stun, 1, [1, 69], 416},{attr_pet_anti_sleep, 1, [1, 69], 416},{attr_pet_anti_taunt, 1, [1, 69], 416},{attr_pet_anti_silent, 1, [1, 69], 416},{attr_pet_anti_poison, 1, [1, 69], 416},{attr_pet_dmg, 1, [1, 352], 1250},{attr_pet_dmg_magic, 1, [1, 211], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50103, 12) ->
    #pet_item_attr{
        base_id = 50103
        ,name = <<"御木之灵">>
        ,lev = 12
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3002},{attr_pet_resist_wood, 2401}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 5707], 312},{attr_pet_mp, 3, [1, 653], 312},{attr_pet_defence, 3, [1, 1631], 312},{attr_pet_resist_metal, 3, [1, 1305], 312},{attr_pet_resist_wood, 3, [1, 1305], 312},{attr_pet_resist_water, 3, [1, 1305], 312},{attr_pet_resist_fire, 3, [1, 1305], 312},{attr_pet_resist_earth, 3, [1, 1305], 312},{attr_pet_anti_stone, 1, [1, 75], 416},{attr_pet_anti_stun, 1, [1, 75], 416},{attr_pet_anti_sleep, 1, [1, 75], 416},{attr_pet_anti_taunt, 1, [1, 75], 416},{attr_pet_anti_silent, 1, [1, 75], 416},{attr_pet_anti_poison, 1, [1, 75], 416},{attr_pet_dmg, 1, [1, 409], 1250},{attr_pet_dmg_magic, 1, [1, 245], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 1) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 1
        ,exp = 64
        ,attr = []
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 300], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 69], 312},{attr_pet_resist_wood, 3, [1, 69], 312},{attr_pet_resist_water, 3, [1, 69], 312},{attr_pet_resist_fire, 3, [1, 69], 312},{attr_pet_resist_earth, 3, [1, 69], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 14], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 2) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 2
        ,exp = 128
        ,attr = [{attr_pet_defence, 86},{attr_pet_resist_water, 68}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 449], 312},{attr_pet_mp, 3, [1, 52], 312},{attr_pet_defence, 3, [1, 129], 312},{attr_pet_resist_metal, 3, [1, 103], 312},{attr_pet_resist_wood, 3, [1, 103], 312},{attr_pet_resist_water, 3, [1, 103], 312},{attr_pet_resist_fire, 3, [1, 103], 312},{attr_pet_resist_earth, 3, [1, 103], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 3) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 3
        ,exp = 256
        ,attr = [{attr_pet_defence, 229},{attr_pet_resist_water, 183}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 707], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 202], 312},{attr_pet_resist_metal, 3, [1, 162], 312},{attr_pet_resist_wood, 3, [1, 162], 312},{attr_pet_resist_water, 3, [1, 162], 312},{attr_pet_resist_fire, 3, [1, 162], 312},{attr_pet_resist_earth, 3, [1, 162], 312},{attr_pet_anti_stone, 1, [1, 19], 416},{attr_pet_anti_stun, 1, [1, 19], 416},{attr_pet_anti_sleep, 1, [1, 19], 416},{attr_pet_anti_taunt, 1, [1, 19], 416},{attr_pet_anti_silent, 1, [1, 19], 416},{attr_pet_anti_poison, 1, [1, 19], 416},{attr_pet_dmg, 1, [1, 51], 1250},{attr_pet_dmg_magic, 1, [1, 30], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 4) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 4
        ,exp = 512
        ,attr = [{attr_pet_defence, 405},{attr_pet_resist_water, 323}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1024], 312},{attr_pet_mp, 3, [1, 117], 312},{attr_pet_defence, 3, [1, 293], 312},{attr_pet_resist_metal, 3, [1, 234], 312},{attr_pet_resist_wood, 3, [1, 234], 312},{attr_pet_resist_water, 3, [1, 234], 312},{attr_pet_resist_fire, 3, [1, 234], 312},{attr_pet_resist_earth, 3, [1, 234], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 74], 1250},{attr_pet_dmg_magic, 1, [1, 44], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 5) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 5
        ,exp = 1024
        ,attr = [{attr_pet_defence, 614},{attr_pet_resist_water, 490}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1399], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 32], 416},{attr_pet_anti_stun, 1, [1, 32], 416},{attr_pet_anti_sleep, 1, [1, 32], 416},{attr_pet_anti_taunt, 1, [1, 32], 416},{attr_pet_anti_silent, 1, [1, 32], 416},{attr_pet_anti_poison, 1, [1, 32], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 6) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 6
        ,exp = 2048
        ,attr = [{attr_pet_defence, 855},{attr_pet_resist_water, 683}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1835], 312},{attr_pet_mp, 3, [1, 210], 312},{attr_pet_defence, 3, [1, 525], 312},{attr_pet_resist_metal, 3, [1, 420], 312},{attr_pet_resist_wood, 3, [1, 420], 312},{attr_pet_resist_water, 3, [1, 420], 312},{attr_pet_resist_fire, 3, [1, 420], 312},{attr_pet_resist_earth, 3, [1, 420], 312},{attr_pet_anti_stone, 1, [1, 38], 416},{attr_pet_anti_stun, 1, [1, 38], 416},{attr_pet_anti_sleep, 1, [1, 38], 416},{attr_pet_anti_taunt, 1, [1, 38], 416},{attr_pet_anti_silent, 1, [1, 38], 416},{attr_pet_anti_poison, 1, [1, 38], 416},{attr_pet_dmg, 1, [1, 132], 1250},{attr_pet_dmg_magic, 1, [1, 79], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 7) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 7
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1129},{attr_pet_resist_water, 903}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2330], 312},{attr_pet_mp, 3, [1, 267], 312},{attr_pet_defence, 3, [1, 666], 312},{attr_pet_resist_metal, 3, [1, 533], 312},{attr_pet_resist_wood, 3, [1, 533], 312},{attr_pet_resist_water, 3, [1, 533], 312},{attr_pet_resist_fire, 3, [1, 533], 312},{attr_pet_resist_earth, 3, [1, 533], 312},{attr_pet_anti_stone, 1, [1, 44], 416},{attr_pet_anti_stun, 1, [1, 44], 416},{attr_pet_anti_sleep, 1, [1, 44], 416},{attr_pet_anti_taunt, 1, [1, 44], 416},{attr_pet_anti_silent, 1, [1, 44], 416},{attr_pet_anti_poison, 1, [1, 44], 416},{attr_pet_dmg, 1, [1, 167], 1250},{attr_pet_dmg_magic, 1, [1, 100], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 8) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 8
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1437},{attr_pet_resist_water, 1149}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2885], 312},{attr_pet_mp, 3, [1, 330], 312},{attr_pet_defence, 3, [1, 825], 312},{attr_pet_resist_metal, 3, [1, 660], 312},{attr_pet_resist_wood, 3, [1, 660], 312},{attr_pet_resist_water, 3, [1, 660], 312},{attr_pet_resist_fire, 3, [1, 660], 312},{attr_pet_resist_earth, 3, [1, 660], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 207], 1250},{attr_pet_dmg_magic, 1, [1, 124], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 9) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 9
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1779},{attr_pet_resist_water, 1422}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 3500], 312},{attr_pet_mp, 3, [1, 400], 312},{attr_pet_defence, 3, [1, 1000], 312},{attr_pet_resist_metal, 3, [1, 800], 312},{attr_pet_resist_wood, 3, [1, 800], 312},{attr_pet_resist_water, 3, [1, 800], 312},{attr_pet_resist_fire, 3, [1, 800], 312},{attr_pet_resist_earth, 3, [1, 800], 312},{attr_pet_anti_stone, 1, [1, 57], 416},{attr_pet_anti_stun, 1, [1, 57], 416},{attr_pet_anti_sleep, 1, [1, 57], 416},{attr_pet_anti_taunt, 1, [1, 57], 416},{attr_pet_anti_silent, 1, [1, 57], 416},{attr_pet_anti_poison, 1, [1, 57], 416},{attr_pet_dmg, 1, [1, 250], 1250},{attr_pet_dmg_magic, 1, [1, 150], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 10) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 10
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2153},{attr_pet_resist_water, 1722}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4175], 312},{attr_pet_mp, 3, [1, 478], 312},{attr_pet_defence, 3, [1, 1194], 312},{attr_pet_resist_metal, 3, [1, 955], 312},{attr_pet_resist_wood, 3, [1, 955], 312},{attr_pet_resist_water, 3, [1, 955], 312},{attr_pet_resist_fire, 3, [1, 955], 312},{attr_pet_resist_earth, 3, [1, 955], 312},{attr_pet_anti_stone, 1, [1, 63], 416},{attr_pet_anti_stun, 1, [1, 63], 416},{attr_pet_anti_sleep, 1, [1, 63], 416},{attr_pet_anti_taunt, 1, [1, 63], 416},{attr_pet_anti_silent, 1, [1, 63], 416},{attr_pet_anti_poison, 1, [1, 63], 416},{attr_pet_dmg, 1, [1, 299], 1250},{attr_pet_dmg_magic, 1, [1, 179], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 11) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 11
        ,exp = 65536
        ,attr = [{attr_pet_defence, 2561},{attr_pet_resist_water, 2048}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4910], 312},{attr_pet_mp, 3, [1, 562], 312},{attr_pet_defence, 3, [1, 1404], 312},{attr_pet_resist_metal, 3, [1, 1123], 312},{attr_pet_resist_wood, 3, [1, 1123], 312},{attr_pet_resist_water, 3, [1, 1123], 312},{attr_pet_resist_fire, 3, [1, 1123], 312},{attr_pet_resist_earth, 3, [1, 1123], 312},{attr_pet_anti_stone, 1, [1, 69], 416},{attr_pet_anti_stun, 1, [1, 69], 416},{attr_pet_anti_sleep, 1, [1, 69], 416},{attr_pet_anti_taunt, 1, [1, 69], 416},{attr_pet_anti_silent, 1, [1, 69], 416},{attr_pet_anti_poison, 1, [1, 69], 416},{attr_pet_dmg, 1, [1, 352], 1250},{attr_pet_dmg_magic, 1, [1, 211], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50104, 12) ->
    #pet_item_attr{
        base_id = 50104
        ,name = <<"御水之灵">>
        ,lev = 12
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3002},{attr_pet_resist_water, 2401}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 5707], 312},{attr_pet_mp, 3, [1, 653], 312},{attr_pet_defence, 3, [1, 1631], 312},{attr_pet_resist_metal, 3, [1, 1305], 312},{attr_pet_resist_wood, 3, [1, 1305], 312},{attr_pet_resist_water, 3, [1, 1305], 312},{attr_pet_resist_fire, 3, [1, 1305], 312},{attr_pet_resist_earth, 3, [1, 1305], 312},{attr_pet_anti_stone, 1, [1, 75], 416},{attr_pet_anti_stun, 1, [1, 75], 416},{attr_pet_anti_sleep, 1, [1, 75], 416},{attr_pet_anti_taunt, 1, [1, 75], 416},{attr_pet_anti_silent, 1, [1, 75], 416},{attr_pet_anti_poison, 1, [1, 75], 416},{attr_pet_dmg, 1, [1, 409], 1250},{attr_pet_dmg_magic, 1, [1, 245], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 1) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 1
        ,exp = 64
        ,attr = []
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 300], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 69], 312},{attr_pet_resist_wood, 3, [1, 69], 312},{attr_pet_resist_water, 3, [1, 69], 312},{attr_pet_resist_fire, 3, [1, 69], 312},{attr_pet_resist_earth, 3, [1, 69], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 14], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 2) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 2
        ,exp = 128
        ,attr = [{attr_pet_defence, 86},{attr_pet_resist_fire, 68}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 449], 312},{attr_pet_mp, 3, [1, 52], 312},{attr_pet_defence, 3, [1, 129], 312},{attr_pet_resist_metal, 3, [1, 103], 312},{attr_pet_resist_wood, 3, [1, 103], 312},{attr_pet_resist_water, 3, [1, 103], 312},{attr_pet_resist_fire, 3, [1, 103], 312},{attr_pet_resist_earth, 3, [1, 103], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 3) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 3
        ,exp = 256
        ,attr = [{attr_pet_defence, 229},{attr_pet_resist_fire, 183}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 707], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 202], 312},{attr_pet_resist_metal, 3, [1, 162], 312},{attr_pet_resist_wood, 3, [1, 162], 312},{attr_pet_resist_water, 3, [1, 162], 312},{attr_pet_resist_fire, 3, [1, 162], 312},{attr_pet_resist_earth, 3, [1, 162], 312},{attr_pet_anti_stone, 1, [1, 19], 416},{attr_pet_anti_stun, 1, [1, 19], 416},{attr_pet_anti_sleep, 1, [1, 19], 416},{attr_pet_anti_taunt, 1, [1, 19], 416},{attr_pet_anti_silent, 1, [1, 19], 416},{attr_pet_anti_poison, 1, [1, 19], 416},{attr_pet_dmg, 1, [1, 51], 1250},{attr_pet_dmg_magic, 1, [1, 30], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 4) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 4
        ,exp = 512
        ,attr = [{attr_pet_defence, 405},{attr_pet_resist_fire, 323}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1024], 312},{attr_pet_mp, 3, [1, 117], 312},{attr_pet_defence, 3, [1, 293], 312},{attr_pet_resist_metal, 3, [1, 234], 312},{attr_pet_resist_wood, 3, [1, 234], 312},{attr_pet_resist_water, 3, [1, 234], 312},{attr_pet_resist_fire, 3, [1, 234], 312},{attr_pet_resist_earth, 3, [1, 234], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 74], 1250},{attr_pet_dmg_magic, 1, [1, 44], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 5) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 5
        ,exp = 1024
        ,attr = [{attr_pet_defence, 614},{attr_pet_resist_fire, 490}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1399], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 32], 416},{attr_pet_anti_stun, 1, [1, 32], 416},{attr_pet_anti_sleep, 1, [1, 32], 416},{attr_pet_anti_taunt, 1, [1, 32], 416},{attr_pet_anti_silent, 1, [1, 32], 416},{attr_pet_anti_poison, 1, [1, 32], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 6) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 6
        ,exp = 2048
        ,attr = [{attr_pet_defence, 855},{attr_pet_resist_fire, 683}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1835], 312},{attr_pet_mp, 3, [1, 210], 312},{attr_pet_defence, 3, [1, 525], 312},{attr_pet_resist_metal, 3, [1, 420], 312},{attr_pet_resist_wood, 3, [1, 420], 312},{attr_pet_resist_water, 3, [1, 420], 312},{attr_pet_resist_fire, 3, [1, 420], 312},{attr_pet_resist_earth, 3, [1, 420], 312},{attr_pet_anti_stone, 1, [1, 38], 416},{attr_pet_anti_stun, 1, [1, 38], 416},{attr_pet_anti_sleep, 1, [1, 38], 416},{attr_pet_anti_taunt, 1, [1, 38], 416},{attr_pet_anti_silent, 1, [1, 38], 416},{attr_pet_anti_poison, 1, [1, 38], 416},{attr_pet_dmg, 1, [1, 132], 1250},{attr_pet_dmg_magic, 1, [1, 79], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 7) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 7
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1129},{attr_pet_resist_fire, 903}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2330], 312},{attr_pet_mp, 3, [1, 267], 312},{attr_pet_defence, 3, [1, 666], 312},{attr_pet_resist_metal, 3, [1, 533], 312},{attr_pet_resist_wood, 3, [1, 533], 312},{attr_pet_resist_water, 3, [1, 533], 312},{attr_pet_resist_fire, 3, [1, 533], 312},{attr_pet_resist_earth, 3, [1, 533], 312},{attr_pet_anti_stone, 1, [1, 44], 416},{attr_pet_anti_stun, 1, [1, 44], 416},{attr_pet_anti_sleep, 1, [1, 44], 416},{attr_pet_anti_taunt, 1, [1, 44], 416},{attr_pet_anti_silent, 1, [1, 44], 416},{attr_pet_anti_poison, 1, [1, 44], 416},{attr_pet_dmg, 1, [1, 167], 1250},{attr_pet_dmg_magic, 1, [1, 100], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 8) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 8
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1437},{attr_pet_resist_fire, 1149}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2885], 312},{attr_pet_mp, 3, [1, 330], 312},{attr_pet_defence, 3, [1, 825], 312},{attr_pet_resist_metal, 3, [1, 660], 312},{attr_pet_resist_wood, 3, [1, 660], 312},{attr_pet_resist_water, 3, [1, 660], 312},{attr_pet_resist_fire, 3, [1, 660], 312},{attr_pet_resist_earth, 3, [1, 660], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 207], 1250},{attr_pet_dmg_magic, 1, [1, 124], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 9) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 9
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1779},{attr_pet_resist_fire, 1422}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 3500], 312},{attr_pet_mp, 3, [1, 400], 312},{attr_pet_defence, 3, [1, 1000], 312},{attr_pet_resist_metal, 3, [1, 800], 312},{attr_pet_resist_wood, 3, [1, 800], 312},{attr_pet_resist_water, 3, [1, 800], 312},{attr_pet_resist_fire, 3, [1, 800], 312},{attr_pet_resist_earth, 3, [1, 800], 312},{attr_pet_anti_stone, 1, [1, 57], 416},{attr_pet_anti_stun, 1, [1, 57], 416},{attr_pet_anti_sleep, 1, [1, 57], 416},{attr_pet_anti_taunt, 1, [1, 57], 416},{attr_pet_anti_silent, 1, [1, 57], 416},{attr_pet_anti_poison, 1, [1, 57], 416},{attr_pet_dmg, 1, [1, 250], 1250},{attr_pet_dmg_magic, 1, [1, 150], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 10) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 10
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2153},{attr_pet_resist_fire, 1722}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4175], 312},{attr_pet_mp, 3, [1, 478], 312},{attr_pet_defence, 3, [1, 1194], 312},{attr_pet_resist_metal, 3, [1, 955], 312},{attr_pet_resist_wood, 3, [1, 955], 312},{attr_pet_resist_water, 3, [1, 955], 312},{attr_pet_resist_fire, 3, [1, 955], 312},{attr_pet_resist_earth, 3, [1, 955], 312},{attr_pet_anti_stone, 1, [1, 63], 416},{attr_pet_anti_stun, 1, [1, 63], 416},{attr_pet_anti_sleep, 1, [1, 63], 416},{attr_pet_anti_taunt, 1, [1, 63], 416},{attr_pet_anti_silent, 1, [1, 63], 416},{attr_pet_anti_poison, 1, [1, 63], 416},{attr_pet_dmg, 1, [1, 299], 1250},{attr_pet_dmg_magic, 1, [1, 179], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 11) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 11
        ,exp = 65536
        ,attr = [{attr_pet_defence, 2561},{attr_pet_resist_fire, 2048}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4910], 312},{attr_pet_mp, 3, [1, 562], 312},{attr_pet_defence, 3, [1, 1404], 312},{attr_pet_resist_metal, 3, [1, 1123], 312},{attr_pet_resist_wood, 3, [1, 1123], 312},{attr_pet_resist_water, 3, [1, 1123], 312},{attr_pet_resist_fire, 3, [1, 1123], 312},{attr_pet_resist_earth, 3, [1, 1123], 312},{attr_pet_anti_stone, 1, [1, 69], 416},{attr_pet_anti_stun, 1, [1, 69], 416},{attr_pet_anti_sleep, 1, [1, 69], 416},{attr_pet_anti_taunt, 1, [1, 69], 416},{attr_pet_anti_silent, 1, [1, 69], 416},{attr_pet_anti_poison, 1, [1, 69], 416},{attr_pet_dmg, 1, [1, 352], 1250},{attr_pet_dmg_magic, 1, [1, 211], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50105, 12) ->
    #pet_item_attr{
        base_id = 50105
        ,name = <<"御火之灵">>
        ,lev = 12
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3002},{attr_pet_resist_fire, 2401}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 5707], 312},{attr_pet_mp, 3, [1, 653], 312},{attr_pet_defence, 3, [1, 1631], 312},{attr_pet_resist_metal, 3, [1, 1305], 312},{attr_pet_resist_wood, 3, [1, 1305], 312},{attr_pet_resist_water, 3, [1, 1305], 312},{attr_pet_resist_fire, 3, [1, 1305], 312},{attr_pet_resist_earth, 3, [1, 1305], 312},{attr_pet_anti_stone, 1, [1, 75], 416},{attr_pet_anti_stun, 1, [1, 75], 416},{attr_pet_anti_sleep, 1, [1, 75], 416},{attr_pet_anti_taunt, 1, [1, 75], 416},{attr_pet_anti_silent, 1, [1, 75], 416},{attr_pet_anti_poison, 1, [1, 75], 416},{attr_pet_dmg, 1, [1, 409], 1250},{attr_pet_dmg_magic, 1, [1, 245], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 1) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 1
        ,exp = 64
        ,attr = []
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 300], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 69], 312},{attr_pet_resist_wood, 3, [1, 69], 312},{attr_pet_resist_water, 3, [1, 69], 312},{attr_pet_resist_fire, 3, [1, 69], 312},{attr_pet_resist_earth, 3, [1, 69], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 14], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 2) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 2
        ,exp = 128
        ,attr = [{attr_pet_defence, 86},{attr_pet_resist_earth, 68}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 449], 312},{attr_pet_mp, 3, [1, 52], 312},{attr_pet_defence, 3, [1, 129], 312},{attr_pet_resist_metal, 3, [1, 103], 312},{attr_pet_resist_wood, 3, [1, 103], 312},{attr_pet_resist_water, 3, [1, 103], 312},{attr_pet_resist_fire, 3, [1, 103], 312},{attr_pet_resist_earth, 3, [1, 103], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 3) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 3
        ,exp = 256
        ,attr = [{attr_pet_defence, 229},{attr_pet_resist_earth, 183}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 707], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 202], 312},{attr_pet_resist_metal, 3, [1, 162], 312},{attr_pet_resist_wood, 3, [1, 162], 312},{attr_pet_resist_water, 3, [1, 162], 312},{attr_pet_resist_fire, 3, [1, 162], 312},{attr_pet_resist_earth, 3, [1, 162], 312},{attr_pet_anti_stone, 1, [1, 19], 416},{attr_pet_anti_stun, 1, [1, 19], 416},{attr_pet_anti_sleep, 1, [1, 19], 416},{attr_pet_anti_taunt, 1, [1, 19], 416},{attr_pet_anti_silent, 1, [1, 19], 416},{attr_pet_anti_poison, 1, [1, 19], 416},{attr_pet_dmg, 1, [1, 51], 1250},{attr_pet_dmg_magic, 1, [1, 30], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 4) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 4
        ,exp = 512
        ,attr = [{attr_pet_defence, 405},{attr_pet_resist_earth, 323}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1024], 312},{attr_pet_mp, 3, [1, 117], 312},{attr_pet_defence, 3, [1, 293], 312},{attr_pet_resist_metal, 3, [1, 234], 312},{attr_pet_resist_wood, 3, [1, 234], 312},{attr_pet_resist_water, 3, [1, 234], 312},{attr_pet_resist_fire, 3, [1, 234], 312},{attr_pet_resist_earth, 3, [1, 234], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 74], 1250},{attr_pet_dmg_magic, 1, [1, 44], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 5) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 5
        ,exp = 1024
        ,attr = [{attr_pet_defence, 614},{attr_pet_resist_earth, 490}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1399], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 32], 416},{attr_pet_anti_stun, 1, [1, 32], 416},{attr_pet_anti_sleep, 1, [1, 32], 416},{attr_pet_anti_taunt, 1, [1, 32], 416},{attr_pet_anti_silent, 1, [1, 32], 416},{attr_pet_anti_poison, 1, [1, 32], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 6) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 6
        ,exp = 2048
        ,attr = [{attr_pet_defence, 855},{attr_pet_resist_earth, 683}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1835], 312},{attr_pet_mp, 3, [1, 210], 312},{attr_pet_defence, 3, [1, 525], 312},{attr_pet_resist_metal, 3, [1, 420], 312},{attr_pet_resist_wood, 3, [1, 420], 312},{attr_pet_resist_water, 3, [1, 420], 312},{attr_pet_resist_fire, 3, [1, 420], 312},{attr_pet_resist_earth, 3, [1, 420], 312},{attr_pet_anti_stone, 1, [1, 38], 416},{attr_pet_anti_stun, 1, [1, 38], 416},{attr_pet_anti_sleep, 1, [1, 38], 416},{attr_pet_anti_taunt, 1, [1, 38], 416},{attr_pet_anti_silent, 1, [1, 38], 416},{attr_pet_anti_poison, 1, [1, 38], 416},{attr_pet_dmg, 1, [1, 132], 1250},{attr_pet_dmg_magic, 1, [1, 79], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 7) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 7
        ,exp = 4096
        ,attr = [{attr_pet_defence, 1129},{attr_pet_resist_earth, 903}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2330], 312},{attr_pet_mp, 3, [1, 267], 312},{attr_pet_defence, 3, [1, 666], 312},{attr_pet_resist_metal, 3, [1, 533], 312},{attr_pet_resist_wood, 3, [1, 533], 312},{attr_pet_resist_water, 3, [1, 533], 312},{attr_pet_resist_fire, 3, [1, 533], 312},{attr_pet_resist_earth, 3, [1, 533], 312},{attr_pet_anti_stone, 1, [1, 44], 416},{attr_pet_anti_stun, 1, [1, 44], 416},{attr_pet_anti_sleep, 1, [1, 44], 416},{attr_pet_anti_taunt, 1, [1, 44], 416},{attr_pet_anti_silent, 1, [1, 44], 416},{attr_pet_anti_poison, 1, [1, 44], 416},{attr_pet_dmg, 1, [1, 167], 1250},{attr_pet_dmg_magic, 1, [1, 100], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 8) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 8
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1437},{attr_pet_resist_earth, 1149}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2885], 312},{attr_pet_mp, 3, [1, 330], 312},{attr_pet_defence, 3, [1, 825], 312},{attr_pet_resist_metal, 3, [1, 660], 312},{attr_pet_resist_wood, 3, [1, 660], 312},{attr_pet_resist_water, 3, [1, 660], 312},{attr_pet_resist_fire, 3, [1, 660], 312},{attr_pet_resist_earth, 3, [1, 660], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 207], 1250},{attr_pet_dmg_magic, 1, [1, 124], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 9) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 9
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1779},{attr_pet_resist_earth, 1422}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 3500], 312},{attr_pet_mp, 3, [1, 400], 312},{attr_pet_defence, 3, [1, 1000], 312},{attr_pet_resist_metal, 3, [1, 800], 312},{attr_pet_resist_wood, 3, [1, 800], 312},{attr_pet_resist_water, 3, [1, 800], 312},{attr_pet_resist_fire, 3, [1, 800], 312},{attr_pet_resist_earth, 3, [1, 800], 312},{attr_pet_anti_stone, 1, [1, 57], 416},{attr_pet_anti_stun, 1, [1, 57], 416},{attr_pet_anti_sleep, 1, [1, 57], 416},{attr_pet_anti_taunt, 1, [1, 57], 416},{attr_pet_anti_silent, 1, [1, 57], 416},{attr_pet_anti_poison, 1, [1, 57], 416},{attr_pet_dmg, 1, [1, 250], 1250},{attr_pet_dmg_magic, 1, [1, 150], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 10) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 10
        ,exp = 32768
        ,attr = [{attr_pet_defence, 2153},{attr_pet_resist_earth, 1722}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4175], 312},{attr_pet_mp, 3, [1, 478], 312},{attr_pet_defence, 3, [1, 1194], 312},{attr_pet_resist_metal, 3, [1, 955], 312},{attr_pet_resist_wood, 3, [1, 955], 312},{attr_pet_resist_water, 3, [1, 955], 312},{attr_pet_resist_fire, 3, [1, 955], 312},{attr_pet_resist_earth, 3, [1, 955], 312},{attr_pet_anti_stone, 1, [1, 63], 416},{attr_pet_anti_stun, 1, [1, 63], 416},{attr_pet_anti_sleep, 1, [1, 63], 416},{attr_pet_anti_taunt, 1, [1, 63], 416},{attr_pet_anti_silent, 1, [1, 63], 416},{attr_pet_anti_poison, 1, [1, 63], 416},{attr_pet_dmg, 1, [1, 299], 1250},{attr_pet_dmg_magic, 1, [1, 179], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 11) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 11
        ,exp = 65536
        ,attr = [{attr_pet_defence, 2561},{attr_pet_resist_earth, 2048}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4910], 312},{attr_pet_mp, 3, [1, 562], 312},{attr_pet_defence, 3, [1, 1404], 312},{attr_pet_resist_metal, 3, [1, 1123], 312},{attr_pet_resist_wood, 3, [1, 1123], 312},{attr_pet_resist_water, 3, [1, 1123], 312},{attr_pet_resist_fire, 3, [1, 1123], 312},{attr_pet_resist_earth, 3, [1, 1123], 312},{attr_pet_anti_stone, 1, [1, 69], 416},{attr_pet_anti_stun, 1, [1, 69], 416},{attr_pet_anti_sleep, 1, [1, 69], 416},{attr_pet_anti_taunt, 1, [1, 69], 416},{attr_pet_anti_silent, 1, [1, 69], 416},{attr_pet_anti_poison, 1, [1, 69], 416},{attr_pet_dmg, 1, [1, 352], 1250},{attr_pet_dmg_magic, 1, [1, 211], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50106, 12) ->
    #pet_item_attr{
        base_id = 50106
        ,name = <<"御土之灵">>
        ,lev = 12
        ,exp = 65536
        ,attr = [{attr_pet_defence, 3002},{attr_pet_resist_earth, 2401}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 5707], 312},{attr_pet_mp, 3, [1, 653], 312},{attr_pet_defence, 3, [1, 1631], 312},{attr_pet_resist_metal, 3, [1, 1305], 312},{attr_pet_resist_wood, 3, [1, 1305], 312},{attr_pet_resist_water, 3, [1, 1305], 312},{attr_pet_resist_fire, 3, [1, 1305], 312},{attr_pet_resist_earth, 3, [1, 1305], 312},{attr_pet_anti_stone, 1, [1, 75], 416},{attr_pet_anti_stun, 1, [1, 75], 416},{attr_pet_anti_sleep, 1, [1, 75], 416},{attr_pet_anti_taunt, 1, [1, 75], 416},{attr_pet_anti_silent, 1, [1, 75], 416},{attr_pet_anti_poison, 1, [1, 75], 416},{attr_pet_dmg, 1, [1, 409], 1250},{attr_pet_dmg_magic, 1, [1, 245], 1250},{attr_pet_skill_anima, 1, [1, 1], 100}]
    };
get_item_attr(50107, 1) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 1
        ,exp = 64
        ,attr = []
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 300], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 69], 312},{attr_pet_resist_wood, 3, [1, 69], 312},{attr_pet_resist_water, 3, [1, 69], 312},{attr_pet_resist_fire, 3, [1, 69], 312},{attr_pet_resist_earth, 3, [1, 69], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 14], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 2) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 2
        ,exp = 128
        ,attr = [{attr_pet_dmg, 20}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 449], 312},{attr_pet_mp, 3, [1, 52], 312},{attr_pet_defence, 3, [1, 129], 312},{attr_pet_resist_metal, 3, [1, 103], 312},{attr_pet_resist_wood, 3, [1, 103], 312},{attr_pet_resist_water, 3, [1, 103], 312},{attr_pet_resist_fire, 3, [1, 103], 312},{attr_pet_resist_earth, 3, [1, 103], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 3) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 3
        ,exp = 256
        ,attr = [{attr_pet_dmg, 56}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 707], 312},{attr_pet_mp, 3, [1, 82], 312},{attr_pet_defence, 3, [1, 202], 312},{attr_pet_resist_metal, 3, [1, 162], 312},{attr_pet_resist_wood, 3, [1, 162], 312},{attr_pet_resist_water, 3, [1, 162], 312},{attr_pet_resist_fire, 3, [1, 162], 312},{attr_pet_resist_earth, 3, [1, 162], 312},{attr_pet_anti_stone, 1, [1, 19], 416},{attr_pet_anti_stun, 1, [1, 19], 416},{attr_pet_anti_sleep, 1, [1, 19], 416},{attr_pet_anti_taunt, 1, [1, 19], 416},{attr_pet_anti_silent, 1, [1, 19], 416},{attr_pet_anti_poison, 1, [1, 19], 416},{attr_pet_dmg, 1, [1, 51], 1250},{attr_pet_dmg_magic, 1, [1, 30], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 4) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 4
        ,exp = 512
        ,attr = [{attr_pet_dmg, 99}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1024], 312},{attr_pet_mp, 3, [1, 117], 312},{attr_pet_defence, 3, [1, 293], 312},{attr_pet_resist_metal, 3, [1, 234], 312},{attr_pet_resist_wood, 3, [1, 234], 312},{attr_pet_resist_water, 3, [1, 234], 312},{attr_pet_resist_fire, 3, [1, 234], 312},{attr_pet_resist_earth, 3, [1, 234], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 74], 1250},{attr_pet_dmg_magic, 1, [1, 44], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 5) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 5
        ,exp = 1024
        ,attr = [{attr_pet_dmg, 152}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1399], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 32], 416},{attr_pet_anti_stun, 1, [1, 32], 416},{attr_pet_anti_sleep, 1, [1, 32], 416},{attr_pet_anti_taunt, 1, [1, 32], 416},{attr_pet_anti_silent, 1, [1, 32], 416},{attr_pet_anti_poison, 1, [1, 32], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 6) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 6
        ,exp = 2048
        ,attr = [{attr_pet_dmg, 212}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 1835], 312},{attr_pet_mp, 3, [1, 210], 312},{attr_pet_defence, 3, [1, 525], 312},{attr_pet_resist_metal, 3, [1, 420], 312},{attr_pet_resist_wood, 3, [1, 420], 312},{attr_pet_resist_water, 3, [1, 420], 312},{attr_pet_resist_fire, 3, [1, 420], 312},{attr_pet_resist_earth, 3, [1, 420], 312},{attr_pet_anti_stone, 1, [1, 38], 416},{attr_pet_anti_stun, 1, [1, 38], 416},{attr_pet_anti_sleep, 1, [1, 38], 416},{attr_pet_anti_taunt, 1, [1, 38], 416},{attr_pet_anti_silent, 1, [1, 38], 416},{attr_pet_anti_poison, 1, [1, 38], 416},{attr_pet_dmg, 1, [1, 132], 1250},{attr_pet_dmg_magic, 1, [1, 79], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 7) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 7
        ,exp = 4096
        ,attr = [{attr_pet_dmg, 281}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2330], 312},{attr_pet_mp, 3, [1, 267], 312},{attr_pet_defence, 3, [1, 666], 312},{attr_pet_resist_metal, 3, [1, 533], 312},{attr_pet_resist_wood, 3, [1, 533], 312},{attr_pet_resist_water, 3, [1, 533], 312},{attr_pet_resist_fire, 3, [1, 533], 312},{attr_pet_resist_earth, 3, [1, 533], 312},{attr_pet_anti_stone, 1, [1, 44], 416},{attr_pet_anti_stun, 1, [1, 44], 416},{attr_pet_anti_sleep, 1, [1, 44], 416},{attr_pet_anti_taunt, 1, [1, 44], 416},{attr_pet_anti_silent, 1, [1, 44], 416},{attr_pet_anti_poison, 1, [1, 44], 416},{attr_pet_dmg, 1, [1, 167], 1250},{attr_pet_dmg_magic, 1, [1, 100], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 8) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 8
        ,exp = 8192
        ,attr = [{attr_pet_dmg, 357}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 2885], 312},{attr_pet_mp, 3, [1, 330], 312},{attr_pet_defence, 3, [1, 825], 312},{attr_pet_resist_metal, 3, [1, 660], 312},{attr_pet_resist_wood, 3, [1, 660], 312},{attr_pet_resist_water, 3, [1, 660], 312},{attr_pet_resist_fire, 3, [1, 660], 312},{attr_pet_resist_earth, 3, [1, 660], 312},{attr_pet_anti_stone, 1, [1, 50], 416},{attr_pet_anti_stun, 1, [1, 50], 416},{attr_pet_anti_sleep, 1, [1, 50], 416},{attr_pet_anti_taunt, 1, [1, 50], 416},{attr_pet_anti_silent, 1, [1, 50], 416},{attr_pet_anti_poison, 1, [1, 50], 416},{attr_pet_dmg, 1, [1, 207], 1250},{attr_pet_dmg_magic, 1, [1, 124], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 9) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 9
        ,exp = 16384
        ,attr = [{attr_pet_dmg, 443}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 3500], 312},{attr_pet_mp, 3, [1, 400], 312},{attr_pet_defence, 3, [1, 1000], 312},{attr_pet_resist_metal, 3, [1, 800], 312},{attr_pet_resist_wood, 3, [1, 800], 312},{attr_pet_resist_water, 3, [1, 800], 312},{attr_pet_resist_fire, 3, [1, 800], 312},{attr_pet_resist_earth, 3, [1, 800], 312},{attr_pet_anti_stone, 1, [1, 57], 416},{attr_pet_anti_stun, 1, [1, 57], 416},{attr_pet_anti_sleep, 1, [1, 57], 416},{attr_pet_anti_taunt, 1, [1, 57], 416},{attr_pet_anti_silent, 1, [1, 57], 416},{attr_pet_anti_poison, 1, [1, 57], 416},{attr_pet_dmg, 1, [1, 250], 1250},{attr_pet_dmg_magic, 1, [1, 150], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 10) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 10
        ,exp = 32768
        ,attr = [{attr_pet_dmg, 537}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4175], 312},{attr_pet_mp, 3, [1, 478], 312},{attr_pet_defence, 3, [1, 1194], 312},{attr_pet_resist_metal, 3, [1, 955], 312},{attr_pet_resist_wood, 3, [1, 955], 312},{attr_pet_resist_water, 3, [1, 955], 312},{attr_pet_resist_fire, 3, [1, 955], 312},{attr_pet_resist_earth, 3, [1, 955], 312},{attr_pet_anti_stone, 1, [1, 63], 416},{attr_pet_anti_stun, 1, [1, 63], 416},{attr_pet_anti_sleep, 1, [1, 63], 416},{attr_pet_anti_taunt, 1, [1, 63], 416},{attr_pet_anti_silent, 1, [1, 63], 416},{attr_pet_anti_poison, 1, [1, 63], 416},{attr_pet_dmg, 1, [1, 299], 1250},{attr_pet_dmg_magic, 1, [1, 179], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 11) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 11
        ,exp = 65536
        ,attr = [{attr_pet_dmg, 639}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 4910], 312},{attr_pet_mp, 3, [1, 562], 312},{attr_pet_defence, 3, [1, 1404], 312},{attr_pet_resist_metal, 3, [1, 1123], 312},{attr_pet_resist_wood, 3, [1, 1123], 312},{attr_pet_resist_water, 3, [1, 1123], 312},{attr_pet_resist_fire, 3, [1, 1123], 312},{attr_pet_resist_earth, 3, [1, 1123], 312},{attr_pet_anti_stone, 1, [1, 69], 416},{attr_pet_anti_stun, 1, [1, 69], 416},{attr_pet_anti_sleep, 1, [1, 69], 416},{attr_pet_anti_taunt, 1, [1, 69], 416},{attr_pet_anti_silent, 1, [1, 69], 416},{attr_pet_anti_poison, 1, [1, 69], 416},{attr_pet_dmg, 1, [1, 352], 1250},{attr_pet_dmg_magic, 1, [1, 211], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50107, 12) ->
    #pet_item_attr{
        base_id = 50107
        ,name = <<"攻击之灵">>
        ,lev = 12
        ,exp = 65536
        ,attr = [{attr_pet_dmg, 749}]
        ,polish = {3, 4}
        ,polish_list = [{attr_pet_hp, 3, [1, 5707], 312},{attr_pet_mp, 3, [1, 653], 312},{attr_pet_defence, 3, [1, 1631], 312},{attr_pet_resist_metal, 3, [1, 1305], 312},{attr_pet_resist_wood, 3, [1, 1305], 312},{attr_pet_resist_water, 3, [1, 1305], 312},{attr_pet_resist_fire, 3, [1, 1305], 312},{attr_pet_resist_earth, 3, [1, 1305], 312},{attr_pet_anti_stone, 1, [1, 75], 416},{attr_pet_anti_stun, 1, [1, 75], 416},{attr_pet_anti_sleep, 1, [1, 75], 416},{attr_pet_anti_taunt, 1, [1, 75], 416},{attr_pet_anti_silent, 1, [1, 75], 416},{attr_pet_anti_poison, 1, [1, 75], 416},{attr_pet_dmg, 1, [1, 409], 1250},{attr_pet_dmg_magic, 1, [1, 245], 1250},{attr_pet_skill_kill, 1, [1, 2], 100}]
    };
get_item_attr(50151, 1) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 1
        ,exp = 32
        ,attr = []
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 195], 312},{attr_pet_mp, 3, [1, 22], 312},{attr_pet_defence, 3, [1, 55], 312},{attr_pet_resist_metal, 3, [1, 45], 312},{attr_pet_resist_wood, 3, [1, 45], 312},{attr_pet_resist_water, 3, [1, 45], 312},{attr_pet_resist_fire, 3, [1, 45], 312},{attr_pet_resist_earth, 3, [1, 45], 312},{attr_pet_anti_stone, 1, [1, 6], 416},{attr_pet_anti_stun, 1, [1, 6], 416},{attr_pet_anti_sleep, 1, [1, 6], 416},{attr_pet_anti_taunt, 1, [1, 6], 416},{attr_pet_anti_silent, 1, [1, 6], 416},{attr_pet_anti_poison, 1, [1, 6], 416},{attr_pet_dmg, 1, [1, 14], 1250},{attr_pet_dmg_magic, 1, [1, 9], 1250}]
    };
get_item_attr(50151, 2) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 2
        ,exp = 64
        ,attr = [{attr_pet_hp, 200},{attr_pet_mp, 20}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 292], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 67], 312},{attr_pet_resist_wood, 3, [1, 67], 312},{attr_pet_resist_water, 3, [1, 67], 312},{attr_pet_resist_fire, 3, [1, 67], 312},{attr_pet_resist_earth, 3, [1, 67], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 13], 1250}]
    };
get_item_attr(50151, 3) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 3
        ,exp = 128
        ,attr = [{attr_pet_hp, 525},{attr_pet_mp, 57}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 460], 312},{attr_pet_mp, 3, [1, 53], 312},{attr_pet_defence, 3, [1, 132], 312},{attr_pet_resist_metal, 3, [1, 105], 312},{attr_pet_resist_wood, 3, [1, 105], 312},{attr_pet_resist_water, 3, [1, 105], 312},{attr_pet_resist_fire, 3, [1, 105], 312},{attr_pet_resist_earth, 3, [1, 105], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250}]
    };
get_item_attr(50151, 4) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 4
        ,exp = 256
        ,attr = [{attr_pet_hp, 925},{attr_pet_mp, 103}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 666], 312},{attr_pet_mp, 3, [1, 76], 312},{attr_pet_defence, 3, [1, 191], 312},{attr_pet_resist_metal, 3, [1, 152], 312},{attr_pet_resist_wood, 3, [1, 152], 312},{attr_pet_resist_water, 3, [1, 152], 312},{attr_pet_resist_fire, 3, [1, 152], 312},{attr_pet_resist_earth, 3, [1, 152], 312},{attr_pet_anti_stone, 1, [1, 17], 416},{attr_pet_anti_stun, 1, [1, 17], 416},{attr_pet_anti_sleep, 1, [1, 17], 416},{attr_pet_anti_taunt, 1, [1, 17], 416},{attr_pet_anti_silent, 1, [1, 17], 416},{attr_pet_anti_poison, 1, [1, 17], 416},{attr_pet_dmg, 1, [1, 48], 1250},{attr_pet_dmg_magic, 1, [1, 29], 1250}]
    };
get_item_attr(50151, 5) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 5
        ,exp = 512
        ,attr = [{attr_pet_hp, 1399},{attr_pet_mp, 157}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 910], 312},{attr_pet_mp, 3, [1, 104], 312},{attr_pet_defence, 3, [1, 260], 312},{attr_pet_resist_metal, 3, [1, 208], 312},{attr_pet_resist_wood, 3, [1, 208], 312},{attr_pet_resist_water, 3, [1, 208], 312},{attr_pet_resist_fire, 3, [1, 208], 312},{attr_pet_resist_earth, 3, [1, 208], 312},{attr_pet_anti_stone, 1, [1, 21], 416},{attr_pet_anti_stun, 1, [1, 21], 416},{attr_pet_anti_sleep, 1, [1, 21], 416},{attr_pet_anti_taunt, 1, [1, 21], 416},{attr_pet_anti_silent, 1, [1, 21], 416},{attr_pet_anti_poison, 1, [1, 21], 416},{attr_pet_dmg, 1, [1, 65], 1250},{attr_pet_dmg_magic, 1, [1, 39], 1250}]
    };
get_item_attr(50151, 6) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 6
        ,exp = 1024
        ,attr = [{attr_pet_hp, 1949},{attr_pet_mp, 220}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1193], 312},{attr_pet_mp, 3, [1, 137], 312},{attr_pet_defence, 3, [1, 341], 312},{attr_pet_resist_metal, 3, [1, 273], 312},{attr_pet_resist_wood, 3, [1, 273], 312},{attr_pet_resist_water, 3, [1, 273], 312},{attr_pet_resist_fire, 3, [1, 273], 312},{attr_pet_resist_earth, 3, [1, 273], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 86], 1250},{attr_pet_dmg_magic, 1, [1, 52], 1250}]
    };
get_item_attr(50151, 7) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 7
        ,exp = 2048
        ,attr = [{attr_pet_hp, 2574},{attr_pet_mp, 291}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1515], 312},{attr_pet_mp, 3, [1, 174], 312},{attr_pet_defence, 3, [1, 433], 312},{attr_pet_resist_metal, 3, [1, 347], 312},{attr_pet_resist_wood, 3, [1, 347], 312},{attr_pet_resist_water, 3, [1, 347], 312},{attr_pet_resist_fire, 3, [1, 347], 312},{attr_pet_resist_earth, 3, [1, 347], 312},{attr_pet_anti_stone, 1, [1, 29], 416},{attr_pet_anti_stun, 1, [1, 29], 416},{attr_pet_anti_sleep, 1, [1, 29], 416},{attr_pet_anti_taunt, 1, [1, 29], 416},{attr_pet_anti_silent, 1, [1, 29], 416},{attr_pet_anti_poison, 1, [1, 29], 416},{attr_pet_dmg, 1, [1, 109], 1250},{attr_pet_dmg_magic, 1, [1, 65], 1250}]
    };
get_item_attr(50151, 8) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 8
        ,exp = 4096
        ,attr = [{attr_pet_hp, 3274},{attr_pet_mp, 371}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1875], 312},{attr_pet_mp, 3, [1, 215], 312},{attr_pet_defence, 3, [1, 536], 312},{attr_pet_resist_metal, 3, [1, 429], 312},{attr_pet_resist_wood, 3, [1, 429], 312},{attr_pet_resist_water, 3, [1, 429], 312},{attr_pet_resist_fire, 3, [1, 429], 312},{attr_pet_resist_earth, 3, [1, 429], 312},{attr_pet_anti_stone, 1, [1, 33], 416},{attr_pet_anti_stun, 1, [1, 33], 416},{attr_pet_anti_sleep, 1, [1, 33], 416},{attr_pet_anti_taunt, 1, [1, 33], 416},{attr_pet_anti_silent, 1, [1, 33], 416},{attr_pet_anti_poison, 1, [1, 33], 416},{attr_pet_dmg, 1, [1, 135], 1250},{attr_pet_dmg_magic, 1, [1, 81], 1250}]
    };
get_item_attr(50151, 9) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 9
        ,exp = 8192
        ,attr = [{attr_pet_hp, 4050},{attr_pet_mp, 460}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2275], 312},{attr_pet_mp, 3, [1, 260], 312},{attr_pet_defence, 3, [1, 650], 312},{attr_pet_resist_metal, 3, [1, 520], 312},{attr_pet_resist_wood, 3, [1, 520], 312},{attr_pet_resist_water, 3, [1, 520], 312},{attr_pet_resist_fire, 3, [1, 520], 312},{attr_pet_resist_earth, 3, [1, 520], 312},{attr_pet_anti_stone, 1, [1, 37], 416},{attr_pet_anti_stun, 1, [1, 37], 416},{attr_pet_anti_sleep, 1, [1, 37], 416},{attr_pet_anti_taunt, 1, [1, 37], 416},{attr_pet_anti_silent, 1, [1, 37], 416},{attr_pet_anti_poison, 1, [1, 37], 416},{attr_pet_dmg, 1, [1, 163], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50151, 10) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 10
        ,exp = 16384
        ,attr = [{attr_pet_hp, 4902},{attr_pet_mp, 558}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2714], 312},{attr_pet_mp, 3, [1, 311], 312},{attr_pet_defence, 3, [1, 776], 312},{attr_pet_resist_metal, 3, [1, 621], 312},{attr_pet_resist_wood, 3, [1, 621], 312},{attr_pet_resist_water, 3, [1, 621], 312},{attr_pet_resist_fire, 3, [1, 621], 312},{attr_pet_resist_earth, 3, [1, 621], 312},{attr_pet_anti_stone, 1, [1, 41], 416},{attr_pet_anti_stun, 1, [1, 41], 416},{attr_pet_anti_sleep, 1, [1, 41], 416},{attr_pet_anti_taunt, 1, [1, 41], 416},{attr_pet_anti_silent, 1, [1, 41], 416},{attr_pet_anti_poison, 1, [1, 41], 416},{attr_pet_dmg, 1, [1, 195], 1250},{attr_pet_dmg_magic, 1, [1, 117], 1250}]
    };
get_item_attr(50151, 11) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 11
        ,exp = 32768
        ,attr = [{attr_pet_hp, 5830},{attr_pet_mp, 664}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3192], 312},{attr_pet_mp, 3, [1, 365], 312},{attr_pet_defence, 3, [1, 913], 312},{attr_pet_resist_metal, 3, [1, 730], 312},{attr_pet_resist_wood, 3, [1, 730], 312},{attr_pet_resist_water, 3, [1, 730], 312},{attr_pet_resist_fire, 3, [1, 730], 312},{attr_pet_resist_earth, 3, [1, 730], 312},{attr_pet_anti_stone, 1, [1, 45], 416},{attr_pet_anti_stun, 1, [1, 45], 416},{attr_pet_anti_sleep, 1, [1, 45], 416},{attr_pet_anti_taunt, 1, [1, 45], 416},{attr_pet_anti_silent, 1, [1, 45], 416},{attr_pet_anti_poison, 1, [1, 45], 416},{attr_pet_dmg, 1, [1, 229], 1250},{attr_pet_dmg_magic, 1, [1, 137], 1250}]
    };
get_item_attr(50151, 12) ->
    #pet_item_attr{
        base_id = 50151
        ,name = <<"血法之灵">>
        ,lev = 12
        ,exp = 32768
        ,attr = [{attr_pet_hp, 6834},{attr_pet_mp, 779}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3710], 312},{attr_pet_mp, 3, [1, 425], 312},{attr_pet_defence, 3, [1, 1060], 312},{attr_pet_resist_metal, 3, [1, 848], 312},{attr_pet_resist_wood, 3, [1, 848], 312},{attr_pet_resist_water, 3, [1, 848], 312},{attr_pet_resist_fire, 3, [1, 848], 312},{attr_pet_resist_earth, 3, [1, 848], 312},{attr_pet_anti_stone, 1, [1, 49], 416},{attr_pet_anti_stun, 1, [1, 49], 416},{attr_pet_anti_sleep, 1, [1, 49], 416},{attr_pet_anti_taunt, 1, [1, 49], 416},{attr_pet_anti_silent, 1, [1, 49], 416},{attr_pet_anti_poison, 1, [1, 49], 416},{attr_pet_dmg, 1, [1, 266], 1250},{attr_pet_dmg_magic, 1, [1, 159], 1250}]
    };
get_item_attr(50152, 1) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 1
        ,exp = 32
        ,attr = []
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 195], 312},{attr_pet_mp, 3, [1, 22], 312},{attr_pet_defence, 3, [1, 55], 312},{attr_pet_resist_metal, 3, [1, 45], 312},{attr_pet_resist_wood, 3, [1, 45], 312},{attr_pet_resist_water, 3, [1, 45], 312},{attr_pet_resist_fire, 3, [1, 45], 312},{attr_pet_resist_earth, 3, [1, 45], 312},{attr_pet_anti_stone, 1, [1, 6], 416},{attr_pet_anti_stun, 1, [1, 6], 416},{attr_pet_anti_sleep, 1, [1, 6], 416},{attr_pet_anti_taunt, 1, [1, 6], 416},{attr_pet_anti_silent, 1, [1, 6], 416},{attr_pet_anti_poison, 1, [1, 6], 416},{attr_pet_dmg, 1, [1, 14], 1250},{attr_pet_dmg_magic, 1, [1, 9], 1250}]
    };
get_item_attr(50152, 2) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 2
        ,exp = 64
        ,attr = [{attr_pet_defence, 56},{attr_pet_resist_metal, 45}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 292], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 67], 312},{attr_pet_resist_wood, 3, [1, 67], 312},{attr_pet_resist_water, 3, [1, 67], 312},{attr_pet_resist_fire, 3, [1, 67], 312},{attr_pet_resist_earth, 3, [1, 67], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 13], 1250}]
    };
get_item_attr(50152, 3) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 3
        ,exp = 128
        ,attr = [{attr_pet_defence, 149},{attr_pet_resist_metal, 119}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 460], 312},{attr_pet_mp, 3, [1, 53], 312},{attr_pet_defence, 3, [1, 132], 312},{attr_pet_resist_metal, 3, [1, 105], 312},{attr_pet_resist_wood, 3, [1, 105], 312},{attr_pet_resist_water, 3, [1, 105], 312},{attr_pet_resist_fire, 3, [1, 105], 312},{attr_pet_resist_earth, 3, [1, 105], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250}]
    };
get_item_attr(50152, 4) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 4
        ,exp = 256
        ,attr = [{attr_pet_defence, 263},{attr_pet_resist_metal, 210}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 666], 312},{attr_pet_mp, 3, [1, 76], 312},{attr_pet_defence, 3, [1, 191], 312},{attr_pet_resist_metal, 3, [1, 152], 312},{attr_pet_resist_wood, 3, [1, 152], 312},{attr_pet_resist_water, 3, [1, 152], 312},{attr_pet_resist_fire, 3, [1, 152], 312},{attr_pet_resist_earth, 3, [1, 152], 312},{attr_pet_anti_stone, 1, [1, 17], 416},{attr_pet_anti_stun, 1, [1, 17], 416},{attr_pet_anti_sleep, 1, [1, 17], 416},{attr_pet_anti_taunt, 1, [1, 17], 416},{attr_pet_anti_silent, 1, [1, 17], 416},{attr_pet_anti_poison, 1, [1, 17], 416},{attr_pet_dmg, 1, [1, 48], 1250},{attr_pet_dmg_magic, 1, [1, 29], 1250}]
    };
get_item_attr(50152, 5) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 5
        ,exp = 512
        ,attr = [{attr_pet_defence, 399},{attr_pet_resist_metal, 319}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 910], 312},{attr_pet_mp, 3, [1, 104], 312},{attr_pet_defence, 3, [1, 260], 312},{attr_pet_resist_metal, 3, [1, 208], 312},{attr_pet_resist_wood, 3, [1, 208], 312},{attr_pet_resist_water, 3, [1, 208], 312},{attr_pet_resist_fire, 3, [1, 208], 312},{attr_pet_resist_earth, 3, [1, 208], 312},{attr_pet_anti_stone, 1, [1, 21], 416},{attr_pet_anti_stun, 1, [1, 21], 416},{attr_pet_anti_sleep, 1, [1, 21], 416},{attr_pet_anti_taunt, 1, [1, 21], 416},{attr_pet_anti_silent, 1, [1, 21], 416},{attr_pet_anti_poison, 1, [1, 21], 416},{attr_pet_dmg, 1, [1, 65], 1250},{attr_pet_dmg_magic, 1, [1, 39], 1250}]
    };
get_item_attr(50152, 6) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 6
        ,exp = 1024
        ,attr = [{attr_pet_defence, 556},{attr_pet_resist_metal, 444}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1193], 312},{attr_pet_mp, 3, [1, 137], 312},{attr_pet_defence, 3, [1, 341], 312},{attr_pet_resist_metal, 3, [1, 273], 312},{attr_pet_resist_wood, 3, [1, 273], 312},{attr_pet_resist_water, 3, [1, 273], 312},{attr_pet_resist_fire, 3, [1, 273], 312},{attr_pet_resist_earth, 3, [1, 273], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 86], 1250},{attr_pet_dmg_magic, 1, [1, 52], 1250}]
    };
get_item_attr(50152, 7) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 7
        ,exp = 2048
        ,attr = [{attr_pet_defence, 734},{attr_pet_resist_metal, 587}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1515], 312},{attr_pet_mp, 3, [1, 174], 312},{attr_pet_defence, 3, [1, 433], 312},{attr_pet_resist_metal, 3, [1, 347], 312},{attr_pet_resist_wood, 3, [1, 347], 312},{attr_pet_resist_water, 3, [1, 347], 312},{attr_pet_resist_fire, 3, [1, 347], 312},{attr_pet_resist_earth, 3, [1, 347], 312},{attr_pet_anti_stone, 1, [1, 29], 416},{attr_pet_anti_stun, 1, [1, 29], 416},{attr_pet_anti_sleep, 1, [1, 29], 416},{attr_pet_anti_taunt, 1, [1, 29], 416},{attr_pet_anti_silent, 1, [1, 29], 416},{attr_pet_anti_poison, 1, [1, 29], 416},{attr_pet_dmg, 1, [1, 109], 1250},{attr_pet_dmg_magic, 1, [1, 65], 1250}]
    };
get_item_attr(50152, 8) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 8
        ,exp = 4096
        ,attr = [{attr_pet_defence, 934},{attr_pet_resist_metal, 747}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1875], 312},{attr_pet_mp, 3, [1, 215], 312},{attr_pet_defence, 3, [1, 536], 312},{attr_pet_resist_metal, 3, [1, 429], 312},{attr_pet_resist_wood, 3, [1, 429], 312},{attr_pet_resist_water, 3, [1, 429], 312},{attr_pet_resist_fire, 3, [1, 429], 312},{attr_pet_resist_earth, 3, [1, 429], 312},{attr_pet_anti_stone, 1, [1, 33], 416},{attr_pet_anti_stun, 1, [1, 33], 416},{attr_pet_anti_sleep, 1, [1, 33], 416},{attr_pet_anti_taunt, 1, [1, 33], 416},{attr_pet_anti_silent, 1, [1, 33], 416},{attr_pet_anti_poison, 1, [1, 33], 416},{attr_pet_dmg, 1, [1, 135], 1250},{attr_pet_dmg_magic, 1, [1, 81], 1250}]
    };
get_item_attr(50152, 9) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 9
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1156},{attr_pet_resist_metal, 925}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2275], 312},{attr_pet_mp, 3, [1, 260], 312},{attr_pet_defence, 3, [1, 650], 312},{attr_pet_resist_metal, 3, [1, 520], 312},{attr_pet_resist_wood, 3, [1, 520], 312},{attr_pet_resist_water, 3, [1, 520], 312},{attr_pet_resist_fire, 3, [1, 520], 312},{attr_pet_resist_earth, 3, [1, 520], 312},{attr_pet_anti_stone, 1, [1, 37], 416},{attr_pet_anti_stun, 1, [1, 37], 416},{attr_pet_anti_sleep, 1, [1, 37], 416},{attr_pet_anti_taunt, 1, [1, 37], 416},{attr_pet_anti_silent, 1, [1, 37], 416},{attr_pet_anti_poison, 1, [1, 37], 416},{attr_pet_dmg, 1, [1, 163], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50152, 10) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 10
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1400},{attr_pet_resist_metal, 1120}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2714], 312},{attr_pet_mp, 3, [1, 311], 312},{attr_pet_defence, 3, [1, 776], 312},{attr_pet_resist_metal, 3, [1, 621], 312},{attr_pet_resist_wood, 3, [1, 621], 312},{attr_pet_resist_water, 3, [1, 621], 312},{attr_pet_resist_fire, 3, [1, 621], 312},{attr_pet_resist_earth, 3, [1, 621], 312},{attr_pet_anti_stone, 1, [1, 41], 416},{attr_pet_anti_stun, 1, [1, 41], 416},{attr_pet_anti_sleep, 1, [1, 41], 416},{attr_pet_anti_taunt, 1, [1, 41], 416},{attr_pet_anti_silent, 1, [1, 41], 416},{attr_pet_anti_poison, 1, [1, 41], 416},{attr_pet_dmg, 1, [1, 195], 1250},{attr_pet_dmg_magic, 1, [1, 117], 1250}]
    };
get_item_attr(50152, 11) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 11
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1665},{attr_pet_resist_metal, 1332}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3192], 312},{attr_pet_mp, 3, [1, 365], 312},{attr_pet_defence, 3, [1, 913], 312},{attr_pet_resist_metal, 3, [1, 730], 312},{attr_pet_resist_wood, 3, [1, 730], 312},{attr_pet_resist_water, 3, [1, 730], 312},{attr_pet_resist_fire, 3, [1, 730], 312},{attr_pet_resist_earth, 3, [1, 730], 312},{attr_pet_anti_stone, 1, [1, 45], 416},{attr_pet_anti_stun, 1, [1, 45], 416},{attr_pet_anti_sleep, 1, [1, 45], 416},{attr_pet_anti_taunt, 1, [1, 45], 416},{attr_pet_anti_silent, 1, [1, 45], 416},{attr_pet_anti_poison, 1, [1, 45], 416},{attr_pet_dmg, 1, [1, 229], 1250},{attr_pet_dmg_magic, 1, [1, 137], 1250}]
    };
get_item_attr(50152, 12) ->
    #pet_item_attr{
        base_id = 50152
        ,name = <<"御金之灵">>
        ,lev = 12
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1952},{attr_pet_resist_metal, 1561}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3710], 312},{attr_pet_mp, 3, [1, 425], 312},{attr_pet_defence, 3, [1, 1060], 312},{attr_pet_resist_metal, 3, [1, 848], 312},{attr_pet_resist_wood, 3, [1, 848], 312},{attr_pet_resist_water, 3, [1, 848], 312},{attr_pet_resist_fire, 3, [1, 848], 312},{attr_pet_resist_earth, 3, [1, 848], 312},{attr_pet_anti_stone, 1, [1, 49], 416},{attr_pet_anti_stun, 1, [1, 49], 416},{attr_pet_anti_sleep, 1, [1, 49], 416},{attr_pet_anti_taunt, 1, [1, 49], 416},{attr_pet_anti_silent, 1, [1, 49], 416},{attr_pet_anti_poison, 1, [1, 49], 416},{attr_pet_dmg, 1, [1, 266], 1250},{attr_pet_dmg_magic, 1, [1, 159], 1250}]
    };
get_item_attr(50153, 1) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 1
        ,exp = 32
        ,attr = []
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 195], 312},{attr_pet_mp, 3, [1, 22], 312},{attr_pet_defence, 3, [1, 55], 312},{attr_pet_resist_metal, 3, [1, 45], 312},{attr_pet_resist_wood, 3, [1, 45], 312},{attr_pet_resist_water, 3, [1, 45], 312},{attr_pet_resist_fire, 3, [1, 45], 312},{attr_pet_resist_earth, 3, [1, 45], 312},{attr_pet_anti_stone, 1, [1, 6], 416},{attr_pet_anti_stun, 1, [1, 6], 416},{attr_pet_anti_sleep, 1, [1, 6], 416},{attr_pet_anti_taunt, 1, [1, 6], 416},{attr_pet_anti_silent, 1, [1, 6], 416},{attr_pet_anti_poison, 1, [1, 6], 416},{attr_pet_dmg, 1, [1, 14], 1250},{attr_pet_dmg_magic, 1, [1, 9], 1250}]
    };
get_item_attr(50153, 2) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 2
        ,exp = 64
        ,attr = [{attr_pet_defence, 56},{attr_pet_resist_wood, 45}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 292], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 67], 312},{attr_pet_resist_wood, 3, [1, 67], 312},{attr_pet_resist_water, 3, [1, 67], 312},{attr_pet_resist_fire, 3, [1, 67], 312},{attr_pet_resist_earth, 3, [1, 67], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 13], 1250}]
    };
get_item_attr(50153, 3) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 3
        ,exp = 128
        ,attr = [{attr_pet_defence, 149},{attr_pet_resist_wood, 119}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 460], 312},{attr_pet_mp, 3, [1, 53], 312},{attr_pet_defence, 3, [1, 132], 312},{attr_pet_resist_metal, 3, [1, 105], 312},{attr_pet_resist_wood, 3, [1, 105], 312},{attr_pet_resist_water, 3, [1, 105], 312},{attr_pet_resist_fire, 3, [1, 105], 312},{attr_pet_resist_earth, 3, [1, 105], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250}]
    };
get_item_attr(50153, 4) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 4
        ,exp = 256
        ,attr = [{attr_pet_defence, 263},{attr_pet_resist_wood, 210}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 666], 312},{attr_pet_mp, 3, [1, 76], 312},{attr_pet_defence, 3, [1, 191], 312},{attr_pet_resist_metal, 3, [1, 152], 312},{attr_pet_resist_wood, 3, [1, 152], 312},{attr_pet_resist_water, 3, [1, 152], 312},{attr_pet_resist_fire, 3, [1, 152], 312},{attr_pet_resist_earth, 3, [1, 152], 312},{attr_pet_anti_stone, 1, [1, 17], 416},{attr_pet_anti_stun, 1, [1, 17], 416},{attr_pet_anti_sleep, 1, [1, 17], 416},{attr_pet_anti_taunt, 1, [1, 17], 416},{attr_pet_anti_silent, 1, [1, 17], 416},{attr_pet_anti_poison, 1, [1, 17], 416},{attr_pet_dmg, 1, [1, 48], 1250},{attr_pet_dmg_magic, 1, [1, 29], 1250}]
    };
get_item_attr(50153, 5) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 5
        ,exp = 512
        ,attr = [{attr_pet_defence, 399},{attr_pet_resist_wood, 319}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 910], 312},{attr_pet_mp, 3, [1, 104], 312},{attr_pet_defence, 3, [1, 260], 312},{attr_pet_resist_metal, 3, [1, 208], 312},{attr_pet_resist_wood, 3, [1, 208], 312},{attr_pet_resist_water, 3, [1, 208], 312},{attr_pet_resist_fire, 3, [1, 208], 312},{attr_pet_resist_earth, 3, [1, 208], 312},{attr_pet_anti_stone, 1, [1, 21], 416},{attr_pet_anti_stun, 1, [1, 21], 416},{attr_pet_anti_sleep, 1, [1, 21], 416},{attr_pet_anti_taunt, 1, [1, 21], 416},{attr_pet_anti_silent, 1, [1, 21], 416},{attr_pet_anti_poison, 1, [1, 21], 416},{attr_pet_dmg, 1, [1, 65], 1250},{attr_pet_dmg_magic, 1, [1, 39], 1250}]
    };
get_item_attr(50153, 6) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 6
        ,exp = 1024
        ,attr = [{attr_pet_defence, 556},{attr_pet_resist_wood, 444}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1193], 312},{attr_pet_mp, 3, [1, 137], 312},{attr_pet_defence, 3, [1, 341], 312},{attr_pet_resist_metal, 3, [1, 273], 312},{attr_pet_resist_wood, 3, [1, 273], 312},{attr_pet_resist_water, 3, [1, 273], 312},{attr_pet_resist_fire, 3, [1, 273], 312},{attr_pet_resist_earth, 3, [1, 273], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 86], 1250},{attr_pet_dmg_magic, 1, [1, 52], 1250}]
    };
get_item_attr(50153, 7) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 7
        ,exp = 2048
        ,attr = [{attr_pet_defence, 734},{attr_pet_resist_wood, 587}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1515], 312},{attr_pet_mp, 3, [1, 174], 312},{attr_pet_defence, 3, [1, 433], 312},{attr_pet_resist_metal, 3, [1, 347], 312},{attr_pet_resist_wood, 3, [1, 347], 312},{attr_pet_resist_water, 3, [1, 347], 312},{attr_pet_resist_fire, 3, [1, 347], 312},{attr_pet_resist_earth, 3, [1, 347], 312},{attr_pet_anti_stone, 1, [1, 29], 416},{attr_pet_anti_stun, 1, [1, 29], 416},{attr_pet_anti_sleep, 1, [1, 29], 416},{attr_pet_anti_taunt, 1, [1, 29], 416},{attr_pet_anti_silent, 1, [1, 29], 416},{attr_pet_anti_poison, 1, [1, 29], 416},{attr_pet_dmg, 1, [1, 109], 1250},{attr_pet_dmg_magic, 1, [1, 65], 1250}]
    };
get_item_attr(50153, 8) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 8
        ,exp = 4096
        ,attr = [{attr_pet_defence, 934},{attr_pet_resist_wood, 747}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1875], 312},{attr_pet_mp, 3, [1, 215], 312},{attr_pet_defence, 3, [1, 536], 312},{attr_pet_resist_metal, 3, [1, 429], 312},{attr_pet_resist_wood, 3, [1, 429], 312},{attr_pet_resist_water, 3, [1, 429], 312},{attr_pet_resist_fire, 3, [1, 429], 312},{attr_pet_resist_earth, 3, [1, 429], 312},{attr_pet_anti_stone, 1, [1, 33], 416},{attr_pet_anti_stun, 1, [1, 33], 416},{attr_pet_anti_sleep, 1, [1, 33], 416},{attr_pet_anti_taunt, 1, [1, 33], 416},{attr_pet_anti_silent, 1, [1, 33], 416},{attr_pet_anti_poison, 1, [1, 33], 416},{attr_pet_dmg, 1, [1, 135], 1250},{attr_pet_dmg_magic, 1, [1, 81], 1250}]
    };
get_item_attr(50153, 9) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 9
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1156},{attr_pet_resist_wood, 925}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2275], 312},{attr_pet_mp, 3, [1, 260], 312},{attr_pet_defence, 3, [1, 650], 312},{attr_pet_resist_metal, 3, [1, 520], 312},{attr_pet_resist_wood, 3, [1, 520], 312},{attr_pet_resist_water, 3, [1, 520], 312},{attr_pet_resist_fire, 3, [1, 520], 312},{attr_pet_resist_earth, 3, [1, 520], 312},{attr_pet_anti_stone, 1, [1, 37], 416},{attr_pet_anti_stun, 1, [1, 37], 416},{attr_pet_anti_sleep, 1, [1, 37], 416},{attr_pet_anti_taunt, 1, [1, 37], 416},{attr_pet_anti_silent, 1, [1, 37], 416},{attr_pet_anti_poison, 1, [1, 37], 416},{attr_pet_dmg, 1, [1, 163], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50153, 10) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 10
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1400},{attr_pet_resist_wood, 1120}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2714], 312},{attr_pet_mp, 3, [1, 311], 312},{attr_pet_defence, 3, [1, 776], 312},{attr_pet_resist_metal, 3, [1, 621], 312},{attr_pet_resist_wood, 3, [1, 621], 312},{attr_pet_resist_water, 3, [1, 621], 312},{attr_pet_resist_fire, 3, [1, 621], 312},{attr_pet_resist_earth, 3, [1, 621], 312},{attr_pet_anti_stone, 1, [1, 41], 416},{attr_pet_anti_stun, 1, [1, 41], 416},{attr_pet_anti_sleep, 1, [1, 41], 416},{attr_pet_anti_taunt, 1, [1, 41], 416},{attr_pet_anti_silent, 1, [1, 41], 416},{attr_pet_anti_poison, 1, [1, 41], 416},{attr_pet_dmg, 1, [1, 195], 1250},{attr_pet_dmg_magic, 1, [1, 117], 1250}]
    };
get_item_attr(50153, 11) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 11
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1665},{attr_pet_resist_wood, 1332}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3192], 312},{attr_pet_mp, 3, [1, 365], 312},{attr_pet_defence, 3, [1, 913], 312},{attr_pet_resist_metal, 3, [1, 730], 312},{attr_pet_resist_wood, 3, [1, 730], 312},{attr_pet_resist_water, 3, [1, 730], 312},{attr_pet_resist_fire, 3, [1, 730], 312},{attr_pet_resist_earth, 3, [1, 730], 312},{attr_pet_anti_stone, 1, [1, 45], 416},{attr_pet_anti_stun, 1, [1, 45], 416},{attr_pet_anti_sleep, 1, [1, 45], 416},{attr_pet_anti_taunt, 1, [1, 45], 416},{attr_pet_anti_silent, 1, [1, 45], 416},{attr_pet_anti_poison, 1, [1, 45], 416},{attr_pet_dmg, 1, [1, 229], 1250},{attr_pet_dmg_magic, 1, [1, 137], 1250}]
    };
get_item_attr(50153, 12) ->
    #pet_item_attr{
        base_id = 50153
        ,name = <<"御木之灵">>
        ,lev = 12
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1952},{attr_pet_resist_wood, 1561}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3710], 312},{attr_pet_mp, 3, [1, 425], 312},{attr_pet_defence, 3, [1, 1060], 312},{attr_pet_resist_metal, 3, [1, 848], 312},{attr_pet_resist_wood, 3, [1, 848], 312},{attr_pet_resist_water, 3, [1, 848], 312},{attr_pet_resist_fire, 3, [1, 848], 312},{attr_pet_resist_earth, 3, [1, 848], 312},{attr_pet_anti_stone, 1, [1, 49], 416},{attr_pet_anti_stun, 1, [1, 49], 416},{attr_pet_anti_sleep, 1, [1, 49], 416},{attr_pet_anti_taunt, 1, [1, 49], 416},{attr_pet_anti_silent, 1, [1, 49], 416},{attr_pet_anti_poison, 1, [1, 49], 416},{attr_pet_dmg, 1, [1, 266], 1250},{attr_pet_dmg_magic, 1, [1, 159], 1250}]
    };
get_item_attr(50154, 1) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 1
        ,exp = 32
        ,attr = []
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 195], 312},{attr_pet_mp, 3, [1, 22], 312},{attr_pet_defence, 3, [1, 55], 312},{attr_pet_resist_metal, 3, [1, 45], 312},{attr_pet_resist_wood, 3, [1, 45], 312},{attr_pet_resist_water, 3, [1, 45], 312},{attr_pet_resist_fire, 3, [1, 45], 312},{attr_pet_resist_earth, 3, [1, 45], 312},{attr_pet_anti_stone, 1, [1, 6], 416},{attr_pet_anti_stun, 1, [1, 6], 416},{attr_pet_anti_sleep, 1, [1, 6], 416},{attr_pet_anti_taunt, 1, [1, 6], 416},{attr_pet_anti_silent, 1, [1, 6], 416},{attr_pet_anti_poison, 1, [1, 6], 416},{attr_pet_dmg, 1, [1, 14], 1250},{attr_pet_dmg_magic, 1, [1, 9], 1250}]
    };
get_item_attr(50154, 2) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 2
        ,exp = 64
        ,attr = [{attr_pet_defence, 56},{attr_pet_resist_water, 45}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 292], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 67], 312},{attr_pet_resist_wood, 3, [1, 67], 312},{attr_pet_resist_water, 3, [1, 67], 312},{attr_pet_resist_fire, 3, [1, 67], 312},{attr_pet_resist_earth, 3, [1, 67], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 13], 1250}]
    };
get_item_attr(50154, 3) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 3
        ,exp = 128
        ,attr = [{attr_pet_defence, 149},{attr_pet_resist_water, 119}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 460], 312},{attr_pet_mp, 3, [1, 53], 312},{attr_pet_defence, 3, [1, 132], 312},{attr_pet_resist_metal, 3, [1, 105], 312},{attr_pet_resist_wood, 3, [1, 105], 312},{attr_pet_resist_water, 3, [1, 105], 312},{attr_pet_resist_fire, 3, [1, 105], 312},{attr_pet_resist_earth, 3, [1, 105], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250}]
    };
get_item_attr(50154, 4) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 4
        ,exp = 256
        ,attr = [{attr_pet_defence, 263},{attr_pet_resist_water, 210}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 666], 312},{attr_pet_mp, 3, [1, 76], 312},{attr_pet_defence, 3, [1, 191], 312},{attr_pet_resist_metal, 3, [1, 152], 312},{attr_pet_resist_wood, 3, [1, 152], 312},{attr_pet_resist_water, 3, [1, 152], 312},{attr_pet_resist_fire, 3, [1, 152], 312},{attr_pet_resist_earth, 3, [1, 152], 312},{attr_pet_anti_stone, 1, [1, 17], 416},{attr_pet_anti_stun, 1, [1, 17], 416},{attr_pet_anti_sleep, 1, [1, 17], 416},{attr_pet_anti_taunt, 1, [1, 17], 416},{attr_pet_anti_silent, 1, [1, 17], 416},{attr_pet_anti_poison, 1, [1, 17], 416},{attr_pet_dmg, 1, [1, 48], 1250},{attr_pet_dmg_magic, 1, [1, 29], 1250}]
    };
get_item_attr(50154, 5) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 5
        ,exp = 512
        ,attr = [{attr_pet_defence, 399},{attr_pet_resist_water, 319}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 910], 312},{attr_pet_mp, 3, [1, 104], 312},{attr_pet_defence, 3, [1, 260], 312},{attr_pet_resist_metal, 3, [1, 208], 312},{attr_pet_resist_wood, 3, [1, 208], 312},{attr_pet_resist_water, 3, [1, 208], 312},{attr_pet_resist_fire, 3, [1, 208], 312},{attr_pet_resist_earth, 3, [1, 208], 312},{attr_pet_anti_stone, 1, [1, 21], 416},{attr_pet_anti_stun, 1, [1, 21], 416},{attr_pet_anti_sleep, 1, [1, 21], 416},{attr_pet_anti_taunt, 1, [1, 21], 416},{attr_pet_anti_silent, 1, [1, 21], 416},{attr_pet_anti_poison, 1, [1, 21], 416},{attr_pet_dmg, 1, [1, 65], 1250},{attr_pet_dmg_magic, 1, [1, 39], 1250}]
    };
get_item_attr(50154, 6) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 6
        ,exp = 1024
        ,attr = [{attr_pet_defence, 556},{attr_pet_resist_water, 444}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1193], 312},{attr_pet_mp, 3, [1, 137], 312},{attr_pet_defence, 3, [1, 341], 312},{attr_pet_resist_metal, 3, [1, 273], 312},{attr_pet_resist_wood, 3, [1, 273], 312},{attr_pet_resist_water, 3, [1, 273], 312},{attr_pet_resist_fire, 3, [1, 273], 312},{attr_pet_resist_earth, 3, [1, 273], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 86], 1250},{attr_pet_dmg_magic, 1, [1, 52], 1250}]
    };
get_item_attr(50154, 7) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 7
        ,exp = 2048
        ,attr = [{attr_pet_defence, 734},{attr_pet_resist_water, 587}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1515], 312},{attr_pet_mp, 3, [1, 174], 312},{attr_pet_defence, 3, [1, 433], 312},{attr_pet_resist_metal, 3, [1, 347], 312},{attr_pet_resist_wood, 3, [1, 347], 312},{attr_pet_resist_water, 3, [1, 347], 312},{attr_pet_resist_fire, 3, [1, 347], 312},{attr_pet_resist_earth, 3, [1, 347], 312},{attr_pet_anti_stone, 1, [1, 29], 416},{attr_pet_anti_stun, 1, [1, 29], 416},{attr_pet_anti_sleep, 1, [1, 29], 416},{attr_pet_anti_taunt, 1, [1, 29], 416},{attr_pet_anti_silent, 1, [1, 29], 416},{attr_pet_anti_poison, 1, [1, 29], 416},{attr_pet_dmg, 1, [1, 109], 1250},{attr_pet_dmg_magic, 1, [1, 65], 1250}]
    };
get_item_attr(50154, 8) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 8
        ,exp = 4096
        ,attr = [{attr_pet_defence, 934},{attr_pet_resist_water, 747}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1875], 312},{attr_pet_mp, 3, [1, 215], 312},{attr_pet_defence, 3, [1, 536], 312},{attr_pet_resist_metal, 3, [1, 429], 312},{attr_pet_resist_wood, 3, [1, 429], 312},{attr_pet_resist_water, 3, [1, 429], 312},{attr_pet_resist_fire, 3, [1, 429], 312},{attr_pet_resist_earth, 3, [1, 429], 312},{attr_pet_anti_stone, 1, [1, 33], 416},{attr_pet_anti_stun, 1, [1, 33], 416},{attr_pet_anti_sleep, 1, [1, 33], 416},{attr_pet_anti_taunt, 1, [1, 33], 416},{attr_pet_anti_silent, 1, [1, 33], 416},{attr_pet_anti_poison, 1, [1, 33], 416},{attr_pet_dmg, 1, [1, 135], 1250},{attr_pet_dmg_magic, 1, [1, 81], 1250}]
    };
get_item_attr(50154, 9) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 9
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1156},{attr_pet_resist_water, 925}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2275], 312},{attr_pet_mp, 3, [1, 260], 312},{attr_pet_defence, 3, [1, 650], 312},{attr_pet_resist_metal, 3, [1, 520], 312},{attr_pet_resist_wood, 3, [1, 520], 312},{attr_pet_resist_water, 3, [1, 520], 312},{attr_pet_resist_fire, 3, [1, 520], 312},{attr_pet_resist_earth, 3, [1, 520], 312},{attr_pet_anti_stone, 1, [1, 37], 416},{attr_pet_anti_stun, 1, [1, 37], 416},{attr_pet_anti_sleep, 1, [1, 37], 416},{attr_pet_anti_taunt, 1, [1, 37], 416},{attr_pet_anti_silent, 1, [1, 37], 416},{attr_pet_anti_poison, 1, [1, 37], 416},{attr_pet_dmg, 1, [1, 163], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50154, 10) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 10
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1400},{attr_pet_resist_water, 1120}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2714], 312},{attr_pet_mp, 3, [1, 311], 312},{attr_pet_defence, 3, [1, 776], 312},{attr_pet_resist_metal, 3, [1, 621], 312},{attr_pet_resist_wood, 3, [1, 621], 312},{attr_pet_resist_water, 3, [1, 621], 312},{attr_pet_resist_fire, 3, [1, 621], 312},{attr_pet_resist_earth, 3, [1, 621], 312},{attr_pet_anti_stone, 1, [1, 41], 416},{attr_pet_anti_stun, 1, [1, 41], 416},{attr_pet_anti_sleep, 1, [1, 41], 416},{attr_pet_anti_taunt, 1, [1, 41], 416},{attr_pet_anti_silent, 1, [1, 41], 416},{attr_pet_anti_poison, 1, [1, 41], 416},{attr_pet_dmg, 1, [1, 195], 1250},{attr_pet_dmg_magic, 1, [1, 117], 1250}]
    };
get_item_attr(50154, 11) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 11
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1665},{attr_pet_resist_water, 1332}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3192], 312},{attr_pet_mp, 3, [1, 365], 312},{attr_pet_defence, 3, [1, 913], 312},{attr_pet_resist_metal, 3, [1, 730], 312},{attr_pet_resist_wood, 3, [1, 730], 312},{attr_pet_resist_water, 3, [1, 730], 312},{attr_pet_resist_fire, 3, [1, 730], 312},{attr_pet_resist_earth, 3, [1, 730], 312},{attr_pet_anti_stone, 1, [1, 45], 416},{attr_pet_anti_stun, 1, [1, 45], 416},{attr_pet_anti_sleep, 1, [1, 45], 416},{attr_pet_anti_taunt, 1, [1, 45], 416},{attr_pet_anti_silent, 1, [1, 45], 416},{attr_pet_anti_poison, 1, [1, 45], 416},{attr_pet_dmg, 1, [1, 229], 1250},{attr_pet_dmg_magic, 1, [1, 137], 1250}]
    };
get_item_attr(50154, 12) ->
    #pet_item_attr{
        base_id = 50154
        ,name = <<"御水之灵">>
        ,lev = 12
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1952},{attr_pet_resist_water, 1561}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3710], 312},{attr_pet_mp, 3, [1, 425], 312},{attr_pet_defence, 3, [1, 1060], 312},{attr_pet_resist_metal, 3, [1, 848], 312},{attr_pet_resist_wood, 3, [1, 848], 312},{attr_pet_resist_water, 3, [1, 848], 312},{attr_pet_resist_fire, 3, [1, 848], 312},{attr_pet_resist_earth, 3, [1, 848], 312},{attr_pet_anti_stone, 1, [1, 49], 416},{attr_pet_anti_stun, 1, [1, 49], 416},{attr_pet_anti_sleep, 1, [1, 49], 416},{attr_pet_anti_taunt, 1, [1, 49], 416},{attr_pet_anti_silent, 1, [1, 49], 416},{attr_pet_anti_poison, 1, [1, 49], 416},{attr_pet_dmg, 1, [1, 266], 1250},{attr_pet_dmg_magic, 1, [1, 159], 1250}]
    };
get_item_attr(50155, 1) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 1
        ,exp = 32
        ,attr = []
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 195], 312},{attr_pet_mp, 3, [1, 22], 312},{attr_pet_defence, 3, [1, 55], 312},{attr_pet_resist_metal, 3, [1, 45], 312},{attr_pet_resist_wood, 3, [1, 45], 312},{attr_pet_resist_water, 3, [1, 45], 312},{attr_pet_resist_fire, 3, [1, 45], 312},{attr_pet_resist_earth, 3, [1, 45], 312},{attr_pet_anti_stone, 1, [1, 6], 416},{attr_pet_anti_stun, 1, [1, 6], 416},{attr_pet_anti_sleep, 1, [1, 6], 416},{attr_pet_anti_taunt, 1, [1, 6], 416},{attr_pet_anti_silent, 1, [1, 6], 416},{attr_pet_anti_poison, 1, [1, 6], 416},{attr_pet_dmg, 1, [1, 14], 1250},{attr_pet_dmg_magic, 1, [1, 9], 1250}]
    };
get_item_attr(50155, 2) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 2
        ,exp = 64
        ,attr = [{attr_pet_defence, 56},{attr_pet_resist_fire, 45}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 292], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 67], 312},{attr_pet_resist_wood, 3, [1, 67], 312},{attr_pet_resist_water, 3, [1, 67], 312},{attr_pet_resist_fire, 3, [1, 67], 312},{attr_pet_resist_earth, 3, [1, 67], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 13], 1250}]
    };
get_item_attr(50155, 3) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 3
        ,exp = 128
        ,attr = [{attr_pet_defence, 149},{attr_pet_resist_fire, 119}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 460], 312},{attr_pet_mp, 3, [1, 53], 312},{attr_pet_defence, 3, [1, 132], 312},{attr_pet_resist_metal, 3, [1, 105], 312},{attr_pet_resist_wood, 3, [1, 105], 312},{attr_pet_resist_water, 3, [1, 105], 312},{attr_pet_resist_fire, 3, [1, 105], 312},{attr_pet_resist_earth, 3, [1, 105], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250}]
    };
get_item_attr(50155, 4) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 4
        ,exp = 256
        ,attr = [{attr_pet_defence, 263},{attr_pet_resist_fire, 210}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 666], 312},{attr_pet_mp, 3, [1, 76], 312},{attr_pet_defence, 3, [1, 191], 312},{attr_pet_resist_metal, 3, [1, 152], 312},{attr_pet_resist_wood, 3, [1, 152], 312},{attr_pet_resist_water, 3, [1, 152], 312},{attr_pet_resist_fire, 3, [1, 152], 312},{attr_pet_resist_earth, 3, [1, 152], 312},{attr_pet_anti_stone, 1, [1, 17], 416},{attr_pet_anti_stun, 1, [1, 17], 416},{attr_pet_anti_sleep, 1, [1, 17], 416},{attr_pet_anti_taunt, 1, [1, 17], 416},{attr_pet_anti_silent, 1, [1, 17], 416},{attr_pet_anti_poison, 1, [1, 17], 416},{attr_pet_dmg, 1, [1, 48], 1250},{attr_pet_dmg_magic, 1, [1, 29], 1250}]
    };
get_item_attr(50155, 5) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 5
        ,exp = 512
        ,attr = [{attr_pet_defence, 399},{attr_pet_resist_fire, 319}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 910], 312},{attr_pet_mp, 3, [1, 104], 312},{attr_pet_defence, 3, [1, 260], 312},{attr_pet_resist_metal, 3, [1, 208], 312},{attr_pet_resist_wood, 3, [1, 208], 312},{attr_pet_resist_water, 3, [1, 208], 312},{attr_pet_resist_fire, 3, [1, 208], 312},{attr_pet_resist_earth, 3, [1, 208], 312},{attr_pet_anti_stone, 1, [1, 21], 416},{attr_pet_anti_stun, 1, [1, 21], 416},{attr_pet_anti_sleep, 1, [1, 21], 416},{attr_pet_anti_taunt, 1, [1, 21], 416},{attr_pet_anti_silent, 1, [1, 21], 416},{attr_pet_anti_poison, 1, [1, 21], 416},{attr_pet_dmg, 1, [1, 65], 1250},{attr_pet_dmg_magic, 1, [1, 39], 1250}]
    };
get_item_attr(50155, 6) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 6
        ,exp = 1024
        ,attr = [{attr_pet_defence, 556},{attr_pet_resist_fire, 444}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1193], 312},{attr_pet_mp, 3, [1, 137], 312},{attr_pet_defence, 3, [1, 341], 312},{attr_pet_resist_metal, 3, [1, 273], 312},{attr_pet_resist_wood, 3, [1, 273], 312},{attr_pet_resist_water, 3, [1, 273], 312},{attr_pet_resist_fire, 3, [1, 273], 312},{attr_pet_resist_earth, 3, [1, 273], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 86], 1250},{attr_pet_dmg_magic, 1, [1, 52], 1250}]
    };
get_item_attr(50155, 7) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 7
        ,exp = 2048
        ,attr = [{attr_pet_defence, 734},{attr_pet_resist_fire, 587}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1515], 312},{attr_pet_mp, 3, [1, 174], 312},{attr_pet_defence, 3, [1, 433], 312},{attr_pet_resist_metal, 3, [1, 347], 312},{attr_pet_resist_wood, 3, [1, 347], 312},{attr_pet_resist_water, 3, [1, 347], 312},{attr_pet_resist_fire, 3, [1, 347], 312},{attr_pet_resist_earth, 3, [1, 347], 312},{attr_pet_anti_stone, 1, [1, 29], 416},{attr_pet_anti_stun, 1, [1, 29], 416},{attr_pet_anti_sleep, 1, [1, 29], 416},{attr_pet_anti_taunt, 1, [1, 29], 416},{attr_pet_anti_silent, 1, [1, 29], 416},{attr_pet_anti_poison, 1, [1, 29], 416},{attr_pet_dmg, 1, [1, 109], 1250},{attr_pet_dmg_magic, 1, [1, 65], 1250}]
    };
get_item_attr(50155, 8) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 8
        ,exp = 4096
        ,attr = [{attr_pet_defence, 934},{attr_pet_resist_fire, 747}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1875], 312},{attr_pet_mp, 3, [1, 215], 312},{attr_pet_defence, 3, [1, 536], 312},{attr_pet_resist_metal, 3, [1, 429], 312},{attr_pet_resist_wood, 3, [1, 429], 312},{attr_pet_resist_water, 3, [1, 429], 312},{attr_pet_resist_fire, 3, [1, 429], 312},{attr_pet_resist_earth, 3, [1, 429], 312},{attr_pet_anti_stone, 1, [1, 33], 416},{attr_pet_anti_stun, 1, [1, 33], 416},{attr_pet_anti_sleep, 1, [1, 33], 416},{attr_pet_anti_taunt, 1, [1, 33], 416},{attr_pet_anti_silent, 1, [1, 33], 416},{attr_pet_anti_poison, 1, [1, 33], 416},{attr_pet_dmg, 1, [1, 135], 1250},{attr_pet_dmg_magic, 1, [1, 81], 1250}]
    };
get_item_attr(50155, 9) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 9
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1156},{attr_pet_resist_fire, 925}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2275], 312},{attr_pet_mp, 3, [1, 260], 312},{attr_pet_defence, 3, [1, 650], 312},{attr_pet_resist_metal, 3, [1, 520], 312},{attr_pet_resist_wood, 3, [1, 520], 312},{attr_pet_resist_water, 3, [1, 520], 312},{attr_pet_resist_fire, 3, [1, 520], 312},{attr_pet_resist_earth, 3, [1, 520], 312},{attr_pet_anti_stone, 1, [1, 37], 416},{attr_pet_anti_stun, 1, [1, 37], 416},{attr_pet_anti_sleep, 1, [1, 37], 416},{attr_pet_anti_taunt, 1, [1, 37], 416},{attr_pet_anti_silent, 1, [1, 37], 416},{attr_pet_anti_poison, 1, [1, 37], 416},{attr_pet_dmg, 1, [1, 163], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50155, 10) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 10
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1400},{attr_pet_resist_fire, 1120}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2714], 312},{attr_pet_mp, 3, [1, 311], 312},{attr_pet_defence, 3, [1, 776], 312},{attr_pet_resist_metal, 3, [1, 621], 312},{attr_pet_resist_wood, 3, [1, 621], 312},{attr_pet_resist_water, 3, [1, 621], 312},{attr_pet_resist_fire, 3, [1, 621], 312},{attr_pet_resist_earth, 3, [1, 621], 312},{attr_pet_anti_stone, 1, [1, 41], 416},{attr_pet_anti_stun, 1, [1, 41], 416},{attr_pet_anti_sleep, 1, [1, 41], 416},{attr_pet_anti_taunt, 1, [1, 41], 416},{attr_pet_anti_silent, 1, [1, 41], 416},{attr_pet_anti_poison, 1, [1, 41], 416},{attr_pet_dmg, 1, [1, 195], 1250},{attr_pet_dmg_magic, 1, [1, 117], 1250}]
    };
get_item_attr(50155, 11) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 11
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1665},{attr_pet_resist_fire, 1332}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3192], 312},{attr_pet_mp, 3, [1, 365], 312},{attr_pet_defence, 3, [1, 913], 312},{attr_pet_resist_metal, 3, [1, 730], 312},{attr_pet_resist_wood, 3, [1, 730], 312},{attr_pet_resist_water, 3, [1, 730], 312},{attr_pet_resist_fire, 3, [1, 730], 312},{attr_pet_resist_earth, 3, [1, 730], 312},{attr_pet_anti_stone, 1, [1, 45], 416},{attr_pet_anti_stun, 1, [1, 45], 416},{attr_pet_anti_sleep, 1, [1, 45], 416},{attr_pet_anti_taunt, 1, [1, 45], 416},{attr_pet_anti_silent, 1, [1, 45], 416},{attr_pet_anti_poison, 1, [1, 45], 416},{attr_pet_dmg, 1, [1, 229], 1250},{attr_pet_dmg_magic, 1, [1, 137], 1250}]
    };
get_item_attr(50155, 12) ->
    #pet_item_attr{
        base_id = 50155
        ,name = <<"御火之灵">>
        ,lev = 12
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1952},{attr_pet_resist_fire, 1561}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3710], 312},{attr_pet_mp, 3, [1, 425], 312},{attr_pet_defence, 3, [1, 1060], 312},{attr_pet_resist_metal, 3, [1, 848], 312},{attr_pet_resist_wood, 3, [1, 848], 312},{attr_pet_resist_water, 3, [1, 848], 312},{attr_pet_resist_fire, 3, [1, 848], 312},{attr_pet_resist_earth, 3, [1, 848], 312},{attr_pet_anti_stone, 1, [1, 49], 416},{attr_pet_anti_stun, 1, [1, 49], 416},{attr_pet_anti_sleep, 1, [1, 49], 416},{attr_pet_anti_taunt, 1, [1, 49], 416},{attr_pet_anti_silent, 1, [1, 49], 416},{attr_pet_anti_poison, 1, [1, 49], 416},{attr_pet_dmg, 1, [1, 266], 1250},{attr_pet_dmg_magic, 1, [1, 159], 1250}]
    };
get_item_attr(50156, 1) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 1
        ,exp = 32
        ,attr = []
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 195], 312},{attr_pet_mp, 3, [1, 22], 312},{attr_pet_defence, 3, [1, 55], 312},{attr_pet_resist_metal, 3, [1, 45], 312},{attr_pet_resist_wood, 3, [1, 45], 312},{attr_pet_resist_water, 3, [1, 45], 312},{attr_pet_resist_fire, 3, [1, 45], 312},{attr_pet_resist_earth, 3, [1, 45], 312},{attr_pet_anti_stone, 1, [1, 6], 416},{attr_pet_anti_stun, 1, [1, 6], 416},{attr_pet_anti_sleep, 1, [1, 6], 416},{attr_pet_anti_taunt, 1, [1, 6], 416},{attr_pet_anti_silent, 1, [1, 6], 416},{attr_pet_anti_poison, 1, [1, 6], 416},{attr_pet_dmg, 1, [1, 14], 1250},{attr_pet_dmg_magic, 1, [1, 9], 1250}]
    };
get_item_attr(50156, 2) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 2
        ,exp = 64
        ,attr = [{attr_pet_defence, 56},{attr_pet_resist_earth, 45}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 292], 312},{attr_pet_mp, 3, [1, 34], 312},{attr_pet_defence, 3, [1, 84], 312},{attr_pet_resist_metal, 3, [1, 67], 312},{attr_pet_resist_wood, 3, [1, 67], 312},{attr_pet_resist_water, 3, [1, 67], 312},{attr_pet_resist_fire, 3, [1, 67], 312},{attr_pet_resist_earth, 3, [1, 67], 312},{attr_pet_anti_stone, 1, [1, 9], 416},{attr_pet_anti_stun, 1, [1, 9], 416},{attr_pet_anti_sleep, 1, [1, 9], 416},{attr_pet_anti_taunt, 1, [1, 9], 416},{attr_pet_anti_silent, 1, [1, 9], 416},{attr_pet_anti_poison, 1, [1, 9], 416},{attr_pet_dmg, 1, [1, 22], 1250},{attr_pet_dmg_magic, 1, [1, 13], 1250}]
    };
get_item_attr(50156, 3) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 3
        ,exp = 128
        ,attr = [{attr_pet_defence, 149},{attr_pet_resist_earth, 119}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 460], 312},{attr_pet_mp, 3, [1, 53], 312},{attr_pet_defence, 3, [1, 132], 312},{attr_pet_resist_metal, 3, [1, 105], 312},{attr_pet_resist_wood, 3, [1, 105], 312},{attr_pet_resist_water, 3, [1, 105], 312},{attr_pet_resist_fire, 3, [1, 105], 312},{attr_pet_resist_earth, 3, [1, 105], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 33], 1250},{attr_pet_dmg_magic, 1, [1, 20], 1250}]
    };
get_item_attr(50156, 4) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 4
        ,exp = 256
        ,attr = [{attr_pet_defence, 263},{attr_pet_resist_earth, 210}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 666], 312},{attr_pet_mp, 3, [1, 76], 312},{attr_pet_defence, 3, [1, 191], 312},{attr_pet_resist_metal, 3, [1, 152], 312},{attr_pet_resist_wood, 3, [1, 152], 312},{attr_pet_resist_water, 3, [1, 152], 312},{attr_pet_resist_fire, 3, [1, 152], 312},{attr_pet_resist_earth, 3, [1, 152], 312},{attr_pet_anti_stone, 1, [1, 17], 416},{attr_pet_anti_stun, 1, [1, 17], 416},{attr_pet_anti_sleep, 1, [1, 17], 416},{attr_pet_anti_taunt, 1, [1, 17], 416},{attr_pet_anti_silent, 1, [1, 17], 416},{attr_pet_anti_poison, 1, [1, 17], 416},{attr_pet_dmg, 1, [1, 48], 1250},{attr_pet_dmg_magic, 1, [1, 29], 1250}]
    };
get_item_attr(50156, 5) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 5
        ,exp = 512
        ,attr = [{attr_pet_defence, 399},{attr_pet_resist_earth, 319}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 910], 312},{attr_pet_mp, 3, [1, 104], 312},{attr_pet_defence, 3, [1, 260], 312},{attr_pet_resist_metal, 3, [1, 208], 312},{attr_pet_resist_wood, 3, [1, 208], 312},{attr_pet_resist_water, 3, [1, 208], 312},{attr_pet_resist_fire, 3, [1, 208], 312},{attr_pet_resist_earth, 3, [1, 208], 312},{attr_pet_anti_stone, 1, [1, 21], 416},{attr_pet_anti_stun, 1, [1, 21], 416},{attr_pet_anti_sleep, 1, [1, 21], 416},{attr_pet_anti_taunt, 1, [1, 21], 416},{attr_pet_anti_silent, 1, [1, 21], 416},{attr_pet_anti_poison, 1, [1, 21], 416},{attr_pet_dmg, 1, [1, 65], 1250},{attr_pet_dmg_magic, 1, [1, 39], 1250}]
    };
get_item_attr(50156, 6) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 6
        ,exp = 1024
        ,attr = [{attr_pet_defence, 556},{attr_pet_resist_earth, 444}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1193], 312},{attr_pet_mp, 3, [1, 137], 312},{attr_pet_defence, 3, [1, 341], 312},{attr_pet_resist_metal, 3, [1, 273], 312},{attr_pet_resist_wood, 3, [1, 273], 312},{attr_pet_resist_water, 3, [1, 273], 312},{attr_pet_resist_fire, 3, [1, 273], 312},{attr_pet_resist_earth, 3, [1, 273], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 86], 1250},{attr_pet_dmg_magic, 1, [1, 52], 1250}]
    };
get_item_attr(50156, 7) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 7
        ,exp = 2048
        ,attr = [{attr_pet_defence, 734},{attr_pet_resist_earth, 587}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1515], 312},{attr_pet_mp, 3, [1, 174], 312},{attr_pet_defence, 3, [1, 433], 312},{attr_pet_resist_metal, 3, [1, 347], 312},{attr_pet_resist_wood, 3, [1, 347], 312},{attr_pet_resist_water, 3, [1, 347], 312},{attr_pet_resist_fire, 3, [1, 347], 312},{attr_pet_resist_earth, 3, [1, 347], 312},{attr_pet_anti_stone, 1, [1, 29], 416},{attr_pet_anti_stun, 1, [1, 29], 416},{attr_pet_anti_sleep, 1, [1, 29], 416},{attr_pet_anti_taunt, 1, [1, 29], 416},{attr_pet_anti_silent, 1, [1, 29], 416},{attr_pet_anti_poison, 1, [1, 29], 416},{attr_pet_dmg, 1, [1, 109], 1250},{attr_pet_dmg_magic, 1, [1, 65], 1250}]
    };
get_item_attr(50156, 8) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 8
        ,exp = 4096
        ,attr = [{attr_pet_defence, 934},{attr_pet_resist_earth, 747}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 1875], 312},{attr_pet_mp, 3, [1, 215], 312},{attr_pet_defence, 3, [1, 536], 312},{attr_pet_resist_metal, 3, [1, 429], 312},{attr_pet_resist_wood, 3, [1, 429], 312},{attr_pet_resist_water, 3, [1, 429], 312},{attr_pet_resist_fire, 3, [1, 429], 312},{attr_pet_resist_earth, 3, [1, 429], 312},{attr_pet_anti_stone, 1, [1, 33], 416},{attr_pet_anti_stun, 1, [1, 33], 416},{attr_pet_anti_sleep, 1, [1, 33], 416},{attr_pet_anti_taunt, 1, [1, 33], 416},{attr_pet_anti_silent, 1, [1, 33], 416},{attr_pet_anti_poison, 1, [1, 33], 416},{attr_pet_dmg, 1, [1, 135], 1250},{attr_pet_dmg_magic, 1, [1, 81], 1250}]
    };
get_item_attr(50156, 9) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 9
        ,exp = 8192
        ,attr = [{attr_pet_defence, 1156},{attr_pet_resist_earth, 925}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2275], 312},{attr_pet_mp, 3, [1, 260], 312},{attr_pet_defence, 3, [1, 650], 312},{attr_pet_resist_metal, 3, [1, 520], 312},{attr_pet_resist_wood, 3, [1, 520], 312},{attr_pet_resist_water, 3, [1, 520], 312},{attr_pet_resist_fire, 3, [1, 520], 312},{attr_pet_resist_earth, 3, [1, 520], 312},{attr_pet_anti_stone, 1, [1, 37], 416},{attr_pet_anti_stun, 1, [1, 37], 416},{attr_pet_anti_sleep, 1, [1, 37], 416},{attr_pet_anti_taunt, 1, [1, 37], 416},{attr_pet_anti_silent, 1, [1, 37], 416},{attr_pet_anti_poison, 1, [1, 37], 416},{attr_pet_dmg, 1, [1, 163], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50156, 10) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 10
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1400},{attr_pet_resist_earth, 1120}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 2714], 312},{attr_pet_mp, 3, [1, 311], 312},{attr_pet_defence, 3, [1, 776], 312},{attr_pet_resist_metal, 3, [1, 621], 312},{attr_pet_resist_wood, 3, [1, 621], 312},{attr_pet_resist_water, 3, [1, 621], 312},{attr_pet_resist_fire, 3, [1, 621], 312},{attr_pet_resist_earth, 3, [1, 621], 312},{attr_pet_anti_stone, 1, [1, 41], 416},{attr_pet_anti_stun, 1, [1, 41], 416},{attr_pet_anti_sleep, 1, [1, 41], 416},{attr_pet_anti_taunt, 1, [1, 41], 416},{attr_pet_anti_silent, 1, [1, 41], 416},{attr_pet_anti_poison, 1, [1, 41], 416},{attr_pet_dmg, 1, [1, 195], 1250},{attr_pet_dmg_magic, 1, [1, 117], 1250}]
    };
get_item_attr(50156, 11) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 11
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1665},{attr_pet_resist_earth, 1332}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3192], 312},{attr_pet_mp, 3, [1, 365], 312},{attr_pet_defence, 3, [1, 913], 312},{attr_pet_resist_metal, 3, [1, 730], 312},{attr_pet_resist_wood, 3, [1, 730], 312},{attr_pet_resist_water, 3, [1, 730], 312},{attr_pet_resist_fire, 3, [1, 730], 312},{attr_pet_resist_earth, 3, [1, 730], 312},{attr_pet_anti_stone, 1, [1, 45], 416},{attr_pet_anti_stun, 1, [1, 45], 416},{attr_pet_anti_sleep, 1, [1, 45], 416},{attr_pet_anti_taunt, 1, [1, 45], 416},{attr_pet_anti_silent, 1, [1, 45], 416},{attr_pet_anti_poison, 1, [1, 45], 416},{attr_pet_dmg, 1, [1, 229], 1250},{attr_pet_dmg_magic, 1, [1, 137], 1250}]
    };
get_item_attr(50156, 12) ->
    #pet_item_attr{
        base_id = 50156
        ,name = <<"御土之灵">>
        ,lev = 12
        ,exp = 32768
        ,attr = [{attr_pet_defence, 1952},{attr_pet_resist_earth, 1561}]
        ,polish = {2, 3}
        ,polish_list = [{attr_pet_hp, 3, [1, 3710], 312},{attr_pet_mp, 3, [1, 425], 312},{attr_pet_defence, 3, [1, 1060], 312},{attr_pet_resist_metal, 3, [1, 848], 312},{attr_pet_resist_wood, 3, [1, 848], 312},{attr_pet_resist_water, 3, [1, 848], 312},{attr_pet_resist_fire, 3, [1, 848], 312},{attr_pet_resist_earth, 3, [1, 848], 312},{attr_pet_anti_stone, 1, [1, 49], 416},{attr_pet_anti_stun, 1, [1, 49], 416},{attr_pet_anti_sleep, 1, [1, 49], 416},{attr_pet_anti_taunt, 1, [1, 49], 416},{attr_pet_anti_silent, 1, [1, 49], 416},{attr_pet_anti_poison, 1, [1, 49], 416},{attr_pet_dmg, 1, [1, 266], 1250},{attr_pet_dmg_magic, 1, [1, 159], 1250}]
    };
get_item_attr(50201, 1) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 1
        ,exp = 16
        ,attr = []
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 120], 312},{attr_pet_mp, 3, [1, 14], 312},{attr_pet_defence, 3, [1, 34], 312},{attr_pet_resist_metal, 3, [1, 28], 312},{attr_pet_resist_wood, 3, [1, 28], 312},{attr_pet_resist_water, 3, [1, 28], 312},{attr_pet_resist_fire, 3, [1, 28], 312},{attr_pet_resist_earth, 3, [1, 28], 312},{attr_pet_anti_stone, 1, [1, 4], 416},{attr_pet_anti_stun, 1, [1, 4], 416},{attr_pet_anti_sleep, 1, [1, 4], 416},{attr_pet_anti_taunt, 1, [1, 4], 416},{attr_pet_anti_silent, 1, [1, 4], 416},{attr_pet_anti_poison, 1, [1, 4], 416},{attr_pet_dmg, 1, [1, 9], 1250},{attr_pet_dmg_magic, 1, [1, 6], 1250}]
    };
get_item_attr(50201, 2) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 2
        ,exp = 32
        ,attr = [{attr_pet_hp, 123},{attr_pet_mp, 12}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 180], 312},{attr_pet_mp, 3, [1, 21], 312},{attr_pet_defence, 3, [1, 52], 312},{attr_pet_resist_metal, 3, [1, 41], 312},{attr_pet_resist_wood, 3, [1, 41], 312},{attr_pet_resist_water, 3, [1, 41], 312},{attr_pet_resist_fire, 3, [1, 41], 312},{attr_pet_resist_earth, 3, [1, 41], 312},{attr_pet_anti_stone, 1, [1, 5], 416},{attr_pet_anti_stun, 1, [1, 5], 416},{attr_pet_anti_sleep, 1, [1, 5], 416},{attr_pet_anti_taunt, 1, [1, 5], 416},{attr_pet_anti_silent, 1, [1, 5], 416},{attr_pet_anti_poison, 1, [1, 5], 416},{attr_pet_dmg, 1, [1, 13], 1250},{attr_pet_dmg_magic, 1, [1, 8], 1250}]
    };
get_item_attr(50201, 3) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 3
        ,exp = 64
        ,attr = [{attr_pet_hp, 323},{attr_pet_mp, 35}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 283], 312},{attr_pet_mp, 3, [1, 33], 312},{attr_pet_defence, 3, [1, 81], 312},{attr_pet_resist_metal, 3, [1, 65], 312},{attr_pet_resist_wood, 3, [1, 65], 312},{attr_pet_resist_water, 3, [1, 65], 312},{attr_pet_resist_fire, 3, [1, 65], 312},{attr_pet_resist_earth, 3, [1, 65], 312},{attr_pet_anti_stone, 1, [1, 8], 416},{attr_pet_anti_stun, 1, [1, 8], 416},{attr_pet_anti_sleep, 1, [1, 8], 416},{attr_pet_anti_taunt, 1, [1, 8], 416},{attr_pet_anti_silent, 1, [1, 8], 416},{attr_pet_anti_poison, 1, [1, 8], 416},{attr_pet_dmg, 1, [1, 21], 1250},{attr_pet_dmg_magic, 1, [1, 12], 1250}]
    };
get_item_attr(50201, 4) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 4
        ,exp = 128
        ,attr = [{attr_pet_hp, 569},{attr_pet_mp, 63}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 410], 312},{attr_pet_mp, 3, [1, 47], 312},{attr_pet_defence, 3, [1, 117], 312},{attr_pet_resist_metal, 3, [1, 94], 312},{attr_pet_resist_wood, 3, [1, 94], 312},{attr_pet_resist_water, 3, [1, 94], 312},{attr_pet_resist_fire, 3, [1, 94], 312},{attr_pet_resist_earth, 3, [1, 94], 312},{attr_pet_anti_stone, 1, [1, 10], 416},{attr_pet_anti_stun, 1, [1, 10], 416},{attr_pet_anti_sleep, 1, [1, 10], 416},{attr_pet_anti_taunt, 1, [1, 10], 416},{attr_pet_anti_silent, 1, [1, 10], 416},{attr_pet_anti_poison, 1, [1, 10], 416},{attr_pet_dmg, 1, [1, 30], 1250},{attr_pet_dmg_magic, 1, [1, 18], 1250}]
    };
get_item_attr(50201, 5) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 5
        ,exp = 256
        ,attr = [{attr_pet_hp, 861},{attr_pet_mp, 97}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 560], 312},{attr_pet_mp, 3, [1, 64], 312},{attr_pet_defence, 3, [1, 160], 312},{attr_pet_resist_metal, 3, [1, 128], 312},{attr_pet_resist_wood, 3, [1, 128], 312},{attr_pet_resist_water, 3, [1, 128], 312},{attr_pet_resist_fire, 3, [1, 128], 312},{attr_pet_resist_earth, 3, [1, 128], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 40], 1250},{attr_pet_dmg_magic, 1, [1, 24], 1250}]
    };
get_item_attr(50201, 6) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 6
        ,exp = 512
        ,attr = [{attr_pet_hp, 1200},{attr_pet_mp, 135}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 734], 312},{attr_pet_mp, 3, [1, 84], 312},{attr_pet_defence, 3, [1, 210], 312},{attr_pet_resist_metal, 3, [1, 168], 312},{attr_pet_resist_wood, 3, [1, 168], 312},{attr_pet_resist_water, 3, [1, 168], 312},{attr_pet_resist_fire, 3, [1, 168], 312},{attr_pet_resist_earth, 3, [1, 168], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 53], 1250},{attr_pet_dmg_magic, 1, [1, 32], 1250}]
    };
get_item_attr(50201, 7) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 7
        ,exp = 1024
        ,attr = [{attr_pet_hp, 1584},{attr_pet_mp, 179}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 932], 312},{attr_pet_mp, 3, [1, 107], 312},{attr_pet_defence, 3, [1, 267], 312},{attr_pet_resist_metal, 3, [1, 213], 312},{attr_pet_resist_wood, 3, [1, 213], 312},{attr_pet_resist_water, 3, [1, 213], 312},{attr_pet_resist_fire, 3, [1, 213], 312},{attr_pet_resist_earth, 3, [1, 213], 312},{attr_pet_anti_stone, 1, [1, 18], 416},{attr_pet_anti_stun, 1, [1, 18], 416},{attr_pet_anti_sleep, 1, [1, 18], 416},{attr_pet_anti_taunt, 1, [1, 18], 416},{attr_pet_anti_silent, 1, [1, 18], 416},{attr_pet_anti_poison, 1, [1, 18], 416},{attr_pet_dmg, 1, [1, 67], 1250},{attr_pet_dmg_magic, 1, [1, 40], 1250}]
    };
get_item_attr(50201, 8) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 8
        ,exp = 2048
        ,attr = [{attr_pet_hp, 2015},{attr_pet_mp, 228}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1154], 312},{attr_pet_mp, 3, [1, 132], 312},{attr_pet_defence, 3, [1, 330], 312},{attr_pet_resist_metal, 3, [1, 264], 312},{attr_pet_resist_wood, 3, [1, 264], 312},{attr_pet_resist_water, 3, [1, 264], 312},{attr_pet_resist_fire, 3, [1, 264], 312},{attr_pet_resist_earth, 3, [1, 264], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 83], 1250},{attr_pet_dmg_magic, 1, [1, 50], 1250}]
    };
get_item_attr(50201, 9) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 9
        ,exp = 4096
        ,attr = [{attr_pet_hp, 2493},{attr_pet_mp, 283}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1400], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 23], 416},{attr_pet_anti_stun, 1, [1, 23], 416},{attr_pet_anti_sleep, 1, [1, 23], 416},{attr_pet_anti_taunt, 1, [1, 23], 416},{attr_pet_anti_silent, 1, [1, 23], 416},{attr_pet_anti_poison, 1, [1, 23], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250}]
    };
get_item_attr(50201, 10) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 10
        ,exp = 8192
        ,attr = [{attr_pet_hp, 3017},{attr_pet_mp, 343}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1670], 312},{attr_pet_mp, 3, [1, 191], 312},{attr_pet_defence, 3, [1, 478], 312},{attr_pet_resist_metal, 3, [1, 382], 312},{attr_pet_resist_wood, 3, [1, 382], 312},{attr_pet_resist_water, 3, [1, 382], 312},{attr_pet_resist_fire, 3, [1, 382], 312},{attr_pet_resist_earth, 3, [1, 382], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 120], 1250},{attr_pet_dmg_magic, 1, [1, 72], 1250}]
    };
get_item_attr(50201, 11) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 11
        ,exp = 16384
        ,attr = [{attr_pet_hp, 3588},{attr_pet_mp, 408}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1964], 312},{attr_pet_mp, 3, [1, 225], 312},{attr_pet_defence, 3, [1, 562], 312},{attr_pet_resist_metal, 3, [1, 449], 312},{attr_pet_resist_wood, 3, [1, 449], 312},{attr_pet_resist_water, 3, [1, 449], 312},{attr_pet_resist_fire, 3, [1, 449], 312},{attr_pet_resist_earth, 3, [1, 449], 312},{attr_pet_anti_stone, 1, [1, 28], 416},{attr_pet_anti_stun, 1, [1, 28], 416},{attr_pet_anti_sleep, 1, [1, 28], 416},{attr_pet_anti_taunt, 1, [1, 28], 416},{attr_pet_anti_silent, 1, [1, 28], 416},{attr_pet_anti_poison, 1, [1, 28], 416},{attr_pet_dmg, 1, [1, 141], 1250},{attr_pet_dmg_magic, 1, [1, 85], 1250}]
    };
get_item_attr(50201, 12) ->
    #pet_item_attr{
        base_id = 50201
        ,name = <<"血法之灵">>
        ,lev = 12
        ,exp = 16384
        ,attr = [{attr_pet_hp, 4206},{attr_pet_mp, 479}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 2283], 312},{attr_pet_mp, 3, [1, 261], 312},{attr_pet_defence, 3, [1, 653], 312},{attr_pet_resist_metal, 3, [1, 522], 312},{attr_pet_resist_wood, 3, [1, 522], 312},{attr_pet_resist_water, 3, [1, 522], 312},{attr_pet_resist_fire, 3, [1, 522], 312},{attr_pet_resist_earth, 3, [1, 522], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 164], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50202, 1) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 1
        ,exp = 16
        ,attr = []
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 120], 312},{attr_pet_mp, 3, [1, 14], 312},{attr_pet_defence, 3, [1, 34], 312},{attr_pet_resist_metal, 3, [1, 28], 312},{attr_pet_resist_wood, 3, [1, 28], 312},{attr_pet_resist_water, 3, [1, 28], 312},{attr_pet_resist_fire, 3, [1, 28], 312},{attr_pet_resist_earth, 3, [1, 28], 312},{attr_pet_anti_stone, 1, [1, 4], 416},{attr_pet_anti_stun, 1, [1, 4], 416},{attr_pet_anti_sleep, 1, [1, 4], 416},{attr_pet_anti_taunt, 1, [1, 4], 416},{attr_pet_anti_silent, 1, [1, 4], 416},{attr_pet_anti_poison, 1, [1, 4], 416},{attr_pet_dmg, 1, [1, 9], 1250},{attr_pet_dmg_magic, 1, [1, 6], 1250}]
    };
get_item_attr(50202, 2) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 2
        ,exp = 32
        ,attr = [{attr_pet_defence, 35},{attr_pet_resist_metal, 27}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 180], 312},{attr_pet_mp, 3, [1, 21], 312},{attr_pet_defence, 3, [1, 52], 312},{attr_pet_resist_metal, 3, [1, 41], 312},{attr_pet_resist_wood, 3, [1, 41], 312},{attr_pet_resist_water, 3, [1, 41], 312},{attr_pet_resist_fire, 3, [1, 41], 312},{attr_pet_resist_earth, 3, [1, 41], 312},{attr_pet_anti_stone, 1, [1, 5], 416},{attr_pet_anti_stun, 1, [1, 5], 416},{attr_pet_anti_sleep, 1, [1, 5], 416},{attr_pet_anti_taunt, 1, [1, 5], 416},{attr_pet_anti_silent, 1, [1, 5], 416},{attr_pet_anti_poison, 1, [1, 5], 416},{attr_pet_dmg, 1, [1, 13], 1250},{attr_pet_dmg_magic, 1, [1, 8], 1250}]
    };
get_item_attr(50202, 3) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 3
        ,exp = 64
        ,attr = [{attr_pet_defence, 92},{attr_pet_resist_metal, 73}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 283], 312},{attr_pet_mp, 3, [1, 33], 312},{attr_pet_defence, 3, [1, 81], 312},{attr_pet_resist_metal, 3, [1, 65], 312},{attr_pet_resist_wood, 3, [1, 65], 312},{attr_pet_resist_water, 3, [1, 65], 312},{attr_pet_resist_fire, 3, [1, 65], 312},{attr_pet_resist_earth, 3, [1, 65], 312},{attr_pet_anti_stone, 1, [1, 8], 416},{attr_pet_anti_stun, 1, [1, 8], 416},{attr_pet_anti_sleep, 1, [1, 8], 416},{attr_pet_anti_taunt, 1, [1, 8], 416},{attr_pet_anti_silent, 1, [1, 8], 416},{attr_pet_anti_poison, 1, [1, 8], 416},{attr_pet_dmg, 1, [1, 21], 1250},{attr_pet_dmg_magic, 1, [1, 12], 1250}]
    };
get_item_attr(50202, 4) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 4
        ,exp = 128
        ,attr = [{attr_pet_defence, 162},{attr_pet_resist_metal, 129}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 410], 312},{attr_pet_mp, 3, [1, 47], 312},{attr_pet_defence, 3, [1, 117], 312},{attr_pet_resist_metal, 3, [1, 94], 312},{attr_pet_resist_wood, 3, [1, 94], 312},{attr_pet_resist_water, 3, [1, 94], 312},{attr_pet_resist_fire, 3, [1, 94], 312},{attr_pet_resist_earth, 3, [1, 94], 312},{attr_pet_anti_stone, 1, [1, 10], 416},{attr_pet_anti_stun, 1, [1, 10], 416},{attr_pet_anti_sleep, 1, [1, 10], 416},{attr_pet_anti_taunt, 1, [1, 10], 416},{attr_pet_anti_silent, 1, [1, 10], 416},{attr_pet_anti_poison, 1, [1, 10], 416},{attr_pet_dmg, 1, [1, 30], 1250},{attr_pet_dmg_magic, 1, [1, 18], 1250}]
    };
get_item_attr(50202, 5) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 5
        ,exp = 256
        ,attr = [{attr_pet_defence, 246},{attr_pet_resist_metal, 196}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 560], 312},{attr_pet_mp, 3, [1, 64], 312},{attr_pet_defence, 3, [1, 160], 312},{attr_pet_resist_metal, 3, [1, 128], 312},{attr_pet_resist_wood, 3, [1, 128], 312},{attr_pet_resist_water, 3, [1, 128], 312},{attr_pet_resist_fire, 3, [1, 128], 312},{attr_pet_resist_earth, 3, [1, 128], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 40], 1250},{attr_pet_dmg_magic, 1, [1, 24], 1250}]
    };
get_item_attr(50202, 6) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 6
        ,exp = 512
        ,attr = [{attr_pet_defence, 342},{attr_pet_resist_metal, 273}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 734], 312},{attr_pet_mp, 3, [1, 84], 312},{attr_pet_defence, 3, [1, 210], 312},{attr_pet_resist_metal, 3, [1, 168], 312},{attr_pet_resist_wood, 3, [1, 168], 312},{attr_pet_resist_water, 3, [1, 168], 312},{attr_pet_resist_fire, 3, [1, 168], 312},{attr_pet_resist_earth, 3, [1, 168], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 53], 1250},{attr_pet_dmg_magic, 1, [1, 32], 1250}]
    };
get_item_attr(50202, 7) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 7
        ,exp = 1024
        ,attr = [{attr_pet_defence, 452},{attr_pet_resist_metal, 361}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 932], 312},{attr_pet_mp, 3, [1, 107], 312},{attr_pet_defence, 3, [1, 267], 312},{attr_pet_resist_metal, 3, [1, 213], 312},{attr_pet_resist_wood, 3, [1, 213], 312},{attr_pet_resist_water, 3, [1, 213], 312},{attr_pet_resist_fire, 3, [1, 213], 312},{attr_pet_resist_earth, 3, [1, 213], 312},{attr_pet_anti_stone, 1, [1, 18], 416},{attr_pet_anti_stun, 1, [1, 18], 416},{attr_pet_anti_sleep, 1, [1, 18], 416},{attr_pet_anti_taunt, 1, [1, 18], 416},{attr_pet_anti_silent, 1, [1, 18], 416},{attr_pet_anti_poison, 1, [1, 18], 416},{attr_pet_dmg, 1, [1, 67], 1250},{attr_pet_dmg_magic, 1, [1, 40], 1250}]
    };
get_item_attr(50202, 8) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 8
        ,exp = 2048
        ,attr = [{attr_pet_defence, 575},{attr_pet_resist_metal, 459}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1154], 312},{attr_pet_mp, 3, [1, 132], 312},{attr_pet_defence, 3, [1, 330], 312},{attr_pet_resist_metal, 3, [1, 264], 312},{attr_pet_resist_wood, 3, [1, 264], 312},{attr_pet_resist_water, 3, [1, 264], 312},{attr_pet_resist_fire, 3, [1, 264], 312},{attr_pet_resist_earth, 3, [1, 264], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 83], 1250},{attr_pet_dmg_magic, 1, [1, 50], 1250}]
    };
get_item_attr(50202, 9) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 9
        ,exp = 4096
        ,attr = [{attr_pet_defence, 712},{attr_pet_resist_metal, 568}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1400], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 23], 416},{attr_pet_anti_stun, 1, [1, 23], 416},{attr_pet_anti_sleep, 1, [1, 23], 416},{attr_pet_anti_taunt, 1, [1, 23], 416},{attr_pet_anti_silent, 1, [1, 23], 416},{attr_pet_anti_poison, 1, [1, 23], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250}]
    };
get_item_attr(50202, 10) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 10
        ,exp = 8192
        ,attr = [{attr_pet_defence, 862},{attr_pet_resist_metal, 688}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1670], 312},{attr_pet_mp, 3, [1, 191], 312},{attr_pet_defence, 3, [1, 478], 312},{attr_pet_resist_metal, 3, [1, 382], 312},{attr_pet_resist_wood, 3, [1, 382], 312},{attr_pet_resist_water, 3, [1, 382], 312},{attr_pet_resist_fire, 3, [1, 382], 312},{attr_pet_resist_earth, 3, [1, 382], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 120], 1250},{attr_pet_dmg_magic, 1, [1, 72], 1250}]
    };
get_item_attr(50202, 11) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 11
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1025},{attr_pet_resist_metal, 819}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1964], 312},{attr_pet_mp, 3, [1, 225], 312},{attr_pet_defence, 3, [1, 562], 312},{attr_pet_resist_metal, 3, [1, 449], 312},{attr_pet_resist_wood, 3, [1, 449], 312},{attr_pet_resist_water, 3, [1, 449], 312},{attr_pet_resist_fire, 3, [1, 449], 312},{attr_pet_resist_earth, 3, [1, 449], 312},{attr_pet_anti_stone, 1, [1, 28], 416},{attr_pet_anti_stun, 1, [1, 28], 416},{attr_pet_anti_sleep, 1, [1, 28], 416},{attr_pet_anti_taunt, 1, [1, 28], 416},{attr_pet_anti_silent, 1, [1, 28], 416},{attr_pet_anti_poison, 1, [1, 28], 416},{attr_pet_dmg, 1, [1, 141], 1250},{attr_pet_dmg_magic, 1, [1, 85], 1250}]
    };
get_item_attr(50202, 12) ->
    #pet_item_attr{
        base_id = 50202
        ,name = <<"御金之灵">>
        ,lev = 12
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1201},{attr_pet_resist_metal, 960}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 2283], 312},{attr_pet_mp, 3, [1, 261], 312},{attr_pet_defence, 3, [1, 653], 312},{attr_pet_resist_metal, 3, [1, 522], 312},{attr_pet_resist_wood, 3, [1, 522], 312},{attr_pet_resist_water, 3, [1, 522], 312},{attr_pet_resist_fire, 3, [1, 522], 312},{attr_pet_resist_earth, 3, [1, 522], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 164], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50203, 1) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 1
        ,exp = 16
        ,attr = []
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 120], 312},{attr_pet_mp, 3, [1, 14], 312},{attr_pet_defence, 3, [1, 34], 312},{attr_pet_resist_metal, 3, [1, 28], 312},{attr_pet_resist_wood, 3, [1, 28], 312},{attr_pet_resist_water, 3, [1, 28], 312},{attr_pet_resist_fire, 3, [1, 28], 312},{attr_pet_resist_earth, 3, [1, 28], 312},{attr_pet_anti_stone, 1, [1, 4], 416},{attr_pet_anti_stun, 1, [1, 4], 416},{attr_pet_anti_sleep, 1, [1, 4], 416},{attr_pet_anti_taunt, 1, [1, 4], 416},{attr_pet_anti_silent, 1, [1, 4], 416},{attr_pet_anti_poison, 1, [1, 4], 416},{attr_pet_dmg, 1, [1, 9], 1250},{attr_pet_dmg_magic, 1, [1, 6], 1250}]
    };
get_item_attr(50203, 2) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 2
        ,exp = 32
        ,attr = [{attr_pet_defence, 35},{attr_pet_resist_wood, 27}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 180], 312},{attr_pet_mp, 3, [1, 21], 312},{attr_pet_defence, 3, [1, 52], 312},{attr_pet_resist_metal, 3, [1, 41], 312},{attr_pet_resist_wood, 3, [1, 41], 312},{attr_pet_resist_water, 3, [1, 41], 312},{attr_pet_resist_fire, 3, [1, 41], 312},{attr_pet_resist_earth, 3, [1, 41], 312},{attr_pet_anti_stone, 1, [1, 5], 416},{attr_pet_anti_stun, 1, [1, 5], 416},{attr_pet_anti_sleep, 1, [1, 5], 416},{attr_pet_anti_taunt, 1, [1, 5], 416},{attr_pet_anti_silent, 1, [1, 5], 416},{attr_pet_anti_poison, 1, [1, 5], 416},{attr_pet_dmg, 1, [1, 13], 1250},{attr_pet_dmg_magic, 1, [1, 8], 1250}]
    };
get_item_attr(50203, 3) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 3
        ,exp = 64
        ,attr = [{attr_pet_defence, 92},{attr_pet_resist_wood, 73}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 283], 312},{attr_pet_mp, 3, [1, 33], 312},{attr_pet_defence, 3, [1, 81], 312},{attr_pet_resist_metal, 3, [1, 65], 312},{attr_pet_resist_wood, 3, [1, 65], 312},{attr_pet_resist_water, 3, [1, 65], 312},{attr_pet_resist_fire, 3, [1, 65], 312},{attr_pet_resist_earth, 3, [1, 65], 312},{attr_pet_anti_stone, 1, [1, 8], 416},{attr_pet_anti_stun, 1, [1, 8], 416},{attr_pet_anti_sleep, 1, [1, 8], 416},{attr_pet_anti_taunt, 1, [1, 8], 416},{attr_pet_anti_silent, 1, [1, 8], 416},{attr_pet_anti_poison, 1, [1, 8], 416},{attr_pet_dmg, 1, [1, 21], 1250},{attr_pet_dmg_magic, 1, [1, 12], 1250}]
    };
get_item_attr(50203, 4) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 4
        ,exp = 128
        ,attr = [{attr_pet_defence, 162},{attr_pet_resist_wood, 129}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 410], 312},{attr_pet_mp, 3, [1, 47], 312},{attr_pet_defence, 3, [1, 117], 312},{attr_pet_resist_metal, 3, [1, 94], 312},{attr_pet_resist_wood, 3, [1, 94], 312},{attr_pet_resist_water, 3, [1, 94], 312},{attr_pet_resist_fire, 3, [1, 94], 312},{attr_pet_resist_earth, 3, [1, 94], 312},{attr_pet_anti_stone, 1, [1, 10], 416},{attr_pet_anti_stun, 1, [1, 10], 416},{attr_pet_anti_sleep, 1, [1, 10], 416},{attr_pet_anti_taunt, 1, [1, 10], 416},{attr_pet_anti_silent, 1, [1, 10], 416},{attr_pet_anti_poison, 1, [1, 10], 416},{attr_pet_dmg, 1, [1, 30], 1250},{attr_pet_dmg_magic, 1, [1, 18], 1250}]
    };
get_item_attr(50203, 5) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 5
        ,exp = 256
        ,attr = [{attr_pet_defence, 246},{attr_pet_resist_wood, 196}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 560], 312},{attr_pet_mp, 3, [1, 64], 312},{attr_pet_defence, 3, [1, 160], 312},{attr_pet_resist_metal, 3, [1, 128], 312},{attr_pet_resist_wood, 3, [1, 128], 312},{attr_pet_resist_water, 3, [1, 128], 312},{attr_pet_resist_fire, 3, [1, 128], 312},{attr_pet_resist_earth, 3, [1, 128], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 40], 1250},{attr_pet_dmg_magic, 1, [1, 24], 1250}]
    };
get_item_attr(50203, 6) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 6
        ,exp = 512
        ,attr = [{attr_pet_defence, 342},{attr_pet_resist_wood, 273}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 734], 312},{attr_pet_mp, 3, [1, 84], 312},{attr_pet_defence, 3, [1, 210], 312},{attr_pet_resist_metal, 3, [1, 168], 312},{attr_pet_resist_wood, 3, [1, 168], 312},{attr_pet_resist_water, 3, [1, 168], 312},{attr_pet_resist_fire, 3, [1, 168], 312},{attr_pet_resist_earth, 3, [1, 168], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 53], 1250},{attr_pet_dmg_magic, 1, [1, 32], 1250}]
    };
get_item_attr(50203, 7) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 7
        ,exp = 1024
        ,attr = [{attr_pet_defence, 452},{attr_pet_resist_wood, 361}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 932], 312},{attr_pet_mp, 3, [1, 107], 312},{attr_pet_defence, 3, [1, 267], 312},{attr_pet_resist_metal, 3, [1, 213], 312},{attr_pet_resist_wood, 3, [1, 213], 312},{attr_pet_resist_water, 3, [1, 213], 312},{attr_pet_resist_fire, 3, [1, 213], 312},{attr_pet_resist_earth, 3, [1, 213], 312},{attr_pet_anti_stone, 1, [1, 18], 416},{attr_pet_anti_stun, 1, [1, 18], 416},{attr_pet_anti_sleep, 1, [1, 18], 416},{attr_pet_anti_taunt, 1, [1, 18], 416},{attr_pet_anti_silent, 1, [1, 18], 416},{attr_pet_anti_poison, 1, [1, 18], 416},{attr_pet_dmg, 1, [1, 67], 1250},{attr_pet_dmg_magic, 1, [1, 40], 1250}]
    };
get_item_attr(50203, 8) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 8
        ,exp = 2048
        ,attr = [{attr_pet_defence, 575},{attr_pet_resist_wood, 459}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1154], 312},{attr_pet_mp, 3, [1, 132], 312},{attr_pet_defence, 3, [1, 330], 312},{attr_pet_resist_metal, 3, [1, 264], 312},{attr_pet_resist_wood, 3, [1, 264], 312},{attr_pet_resist_water, 3, [1, 264], 312},{attr_pet_resist_fire, 3, [1, 264], 312},{attr_pet_resist_earth, 3, [1, 264], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 83], 1250},{attr_pet_dmg_magic, 1, [1, 50], 1250}]
    };
get_item_attr(50203, 9) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 9
        ,exp = 4096
        ,attr = [{attr_pet_defence, 712},{attr_pet_resist_wood, 568}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1400], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 23], 416},{attr_pet_anti_stun, 1, [1, 23], 416},{attr_pet_anti_sleep, 1, [1, 23], 416},{attr_pet_anti_taunt, 1, [1, 23], 416},{attr_pet_anti_silent, 1, [1, 23], 416},{attr_pet_anti_poison, 1, [1, 23], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250}]
    };
get_item_attr(50203, 10) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 10
        ,exp = 8192
        ,attr = [{attr_pet_defence, 862},{attr_pet_resist_wood, 688}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1670], 312},{attr_pet_mp, 3, [1, 191], 312},{attr_pet_defence, 3, [1, 478], 312},{attr_pet_resist_metal, 3, [1, 382], 312},{attr_pet_resist_wood, 3, [1, 382], 312},{attr_pet_resist_water, 3, [1, 382], 312},{attr_pet_resist_fire, 3, [1, 382], 312},{attr_pet_resist_earth, 3, [1, 382], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 120], 1250},{attr_pet_dmg_magic, 1, [1, 72], 1250}]
    };
get_item_attr(50203, 11) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 11
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1025},{attr_pet_resist_wood, 819}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1964], 312},{attr_pet_mp, 3, [1, 225], 312},{attr_pet_defence, 3, [1, 562], 312},{attr_pet_resist_metal, 3, [1, 449], 312},{attr_pet_resist_wood, 3, [1, 449], 312},{attr_pet_resist_water, 3, [1, 449], 312},{attr_pet_resist_fire, 3, [1, 449], 312},{attr_pet_resist_earth, 3, [1, 449], 312},{attr_pet_anti_stone, 1, [1, 28], 416},{attr_pet_anti_stun, 1, [1, 28], 416},{attr_pet_anti_sleep, 1, [1, 28], 416},{attr_pet_anti_taunt, 1, [1, 28], 416},{attr_pet_anti_silent, 1, [1, 28], 416},{attr_pet_anti_poison, 1, [1, 28], 416},{attr_pet_dmg, 1, [1, 141], 1250},{attr_pet_dmg_magic, 1, [1, 85], 1250}]
    };
get_item_attr(50203, 12) ->
    #pet_item_attr{
        base_id = 50203
        ,name = <<"御木之灵">>
        ,lev = 12
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1201},{attr_pet_resist_wood, 960}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 2283], 312},{attr_pet_mp, 3, [1, 261], 312},{attr_pet_defence, 3, [1, 653], 312},{attr_pet_resist_metal, 3, [1, 522], 312},{attr_pet_resist_wood, 3, [1, 522], 312},{attr_pet_resist_water, 3, [1, 522], 312},{attr_pet_resist_fire, 3, [1, 522], 312},{attr_pet_resist_earth, 3, [1, 522], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 164], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50204, 1) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 1
        ,exp = 16
        ,attr = []
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 120], 312},{attr_pet_mp, 3, [1, 14], 312},{attr_pet_defence, 3, [1, 34], 312},{attr_pet_resist_metal, 3, [1, 28], 312},{attr_pet_resist_wood, 3, [1, 28], 312},{attr_pet_resist_water, 3, [1, 28], 312},{attr_pet_resist_fire, 3, [1, 28], 312},{attr_pet_resist_earth, 3, [1, 28], 312},{attr_pet_anti_stone, 1, [1, 4], 416},{attr_pet_anti_stun, 1, [1, 4], 416},{attr_pet_anti_sleep, 1, [1, 4], 416},{attr_pet_anti_taunt, 1, [1, 4], 416},{attr_pet_anti_silent, 1, [1, 4], 416},{attr_pet_anti_poison, 1, [1, 4], 416},{attr_pet_dmg, 1, [1, 9], 1250},{attr_pet_dmg_magic, 1, [1, 6], 1250}]
    };
get_item_attr(50204, 2) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 2
        ,exp = 32
        ,attr = [{attr_pet_defence, 35},{attr_pet_resist_water, 27}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 180], 312},{attr_pet_mp, 3, [1, 21], 312},{attr_pet_defence, 3, [1, 52], 312},{attr_pet_resist_metal, 3, [1, 41], 312},{attr_pet_resist_wood, 3, [1, 41], 312},{attr_pet_resist_water, 3, [1, 41], 312},{attr_pet_resist_fire, 3, [1, 41], 312},{attr_pet_resist_earth, 3, [1, 41], 312},{attr_pet_anti_stone, 1, [1, 5], 416},{attr_pet_anti_stun, 1, [1, 5], 416},{attr_pet_anti_sleep, 1, [1, 5], 416},{attr_pet_anti_taunt, 1, [1, 5], 416},{attr_pet_anti_silent, 1, [1, 5], 416},{attr_pet_anti_poison, 1, [1, 5], 416},{attr_pet_dmg, 1, [1, 13], 1250},{attr_pet_dmg_magic, 1, [1, 8], 1250}]
    };
get_item_attr(50204, 3) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 3
        ,exp = 64
        ,attr = [{attr_pet_defence, 92},{attr_pet_resist_water, 73}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 283], 312},{attr_pet_mp, 3, [1, 33], 312},{attr_pet_defence, 3, [1, 81], 312},{attr_pet_resist_metal, 3, [1, 65], 312},{attr_pet_resist_wood, 3, [1, 65], 312},{attr_pet_resist_water, 3, [1, 65], 312},{attr_pet_resist_fire, 3, [1, 65], 312},{attr_pet_resist_earth, 3, [1, 65], 312},{attr_pet_anti_stone, 1, [1, 8], 416},{attr_pet_anti_stun, 1, [1, 8], 416},{attr_pet_anti_sleep, 1, [1, 8], 416},{attr_pet_anti_taunt, 1, [1, 8], 416},{attr_pet_anti_silent, 1, [1, 8], 416},{attr_pet_anti_poison, 1, [1, 8], 416},{attr_pet_dmg, 1, [1, 21], 1250},{attr_pet_dmg_magic, 1, [1, 12], 1250}]
    };
get_item_attr(50204, 4) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 4
        ,exp = 128
        ,attr = [{attr_pet_defence, 162},{attr_pet_resist_water, 129}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 410], 312},{attr_pet_mp, 3, [1, 47], 312},{attr_pet_defence, 3, [1, 117], 312},{attr_pet_resist_metal, 3, [1, 94], 312},{attr_pet_resist_wood, 3, [1, 94], 312},{attr_pet_resist_water, 3, [1, 94], 312},{attr_pet_resist_fire, 3, [1, 94], 312},{attr_pet_resist_earth, 3, [1, 94], 312},{attr_pet_anti_stone, 1, [1, 10], 416},{attr_pet_anti_stun, 1, [1, 10], 416},{attr_pet_anti_sleep, 1, [1, 10], 416},{attr_pet_anti_taunt, 1, [1, 10], 416},{attr_pet_anti_silent, 1, [1, 10], 416},{attr_pet_anti_poison, 1, [1, 10], 416},{attr_pet_dmg, 1, [1, 30], 1250},{attr_pet_dmg_magic, 1, [1, 18], 1250}]
    };
get_item_attr(50204, 5) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 5
        ,exp = 256
        ,attr = [{attr_pet_defence, 246},{attr_pet_resist_water, 196}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 560], 312},{attr_pet_mp, 3, [1, 64], 312},{attr_pet_defence, 3, [1, 160], 312},{attr_pet_resist_metal, 3, [1, 128], 312},{attr_pet_resist_wood, 3, [1, 128], 312},{attr_pet_resist_water, 3, [1, 128], 312},{attr_pet_resist_fire, 3, [1, 128], 312},{attr_pet_resist_earth, 3, [1, 128], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 40], 1250},{attr_pet_dmg_magic, 1, [1, 24], 1250}]
    };
get_item_attr(50204, 6) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 6
        ,exp = 512
        ,attr = [{attr_pet_defence, 342},{attr_pet_resist_water, 273}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 734], 312},{attr_pet_mp, 3, [1, 84], 312},{attr_pet_defence, 3, [1, 210], 312},{attr_pet_resist_metal, 3, [1, 168], 312},{attr_pet_resist_wood, 3, [1, 168], 312},{attr_pet_resist_water, 3, [1, 168], 312},{attr_pet_resist_fire, 3, [1, 168], 312},{attr_pet_resist_earth, 3, [1, 168], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 53], 1250},{attr_pet_dmg_magic, 1, [1, 32], 1250}]
    };
get_item_attr(50204, 7) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 7
        ,exp = 1024
        ,attr = [{attr_pet_defence, 452},{attr_pet_resist_water, 361}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 932], 312},{attr_pet_mp, 3, [1, 107], 312},{attr_pet_defence, 3, [1, 267], 312},{attr_pet_resist_metal, 3, [1, 213], 312},{attr_pet_resist_wood, 3, [1, 213], 312},{attr_pet_resist_water, 3, [1, 213], 312},{attr_pet_resist_fire, 3, [1, 213], 312},{attr_pet_resist_earth, 3, [1, 213], 312},{attr_pet_anti_stone, 1, [1, 18], 416},{attr_pet_anti_stun, 1, [1, 18], 416},{attr_pet_anti_sleep, 1, [1, 18], 416},{attr_pet_anti_taunt, 1, [1, 18], 416},{attr_pet_anti_silent, 1, [1, 18], 416},{attr_pet_anti_poison, 1, [1, 18], 416},{attr_pet_dmg, 1, [1, 67], 1250},{attr_pet_dmg_magic, 1, [1, 40], 1250}]
    };
get_item_attr(50204, 8) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 8
        ,exp = 2048
        ,attr = [{attr_pet_defence, 575},{attr_pet_resist_water, 459}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1154], 312},{attr_pet_mp, 3, [1, 132], 312},{attr_pet_defence, 3, [1, 330], 312},{attr_pet_resist_metal, 3, [1, 264], 312},{attr_pet_resist_wood, 3, [1, 264], 312},{attr_pet_resist_water, 3, [1, 264], 312},{attr_pet_resist_fire, 3, [1, 264], 312},{attr_pet_resist_earth, 3, [1, 264], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 83], 1250},{attr_pet_dmg_magic, 1, [1, 50], 1250}]
    };
get_item_attr(50204, 9) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 9
        ,exp = 4096
        ,attr = [{attr_pet_defence, 712},{attr_pet_resist_water, 568}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1400], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 23], 416},{attr_pet_anti_stun, 1, [1, 23], 416},{attr_pet_anti_sleep, 1, [1, 23], 416},{attr_pet_anti_taunt, 1, [1, 23], 416},{attr_pet_anti_silent, 1, [1, 23], 416},{attr_pet_anti_poison, 1, [1, 23], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250}]
    };
get_item_attr(50204, 10) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 10
        ,exp = 8192
        ,attr = [{attr_pet_defence, 862},{attr_pet_resist_water, 688}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1670], 312},{attr_pet_mp, 3, [1, 191], 312},{attr_pet_defence, 3, [1, 478], 312},{attr_pet_resist_metal, 3, [1, 382], 312},{attr_pet_resist_wood, 3, [1, 382], 312},{attr_pet_resist_water, 3, [1, 382], 312},{attr_pet_resist_fire, 3, [1, 382], 312},{attr_pet_resist_earth, 3, [1, 382], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 120], 1250},{attr_pet_dmg_magic, 1, [1, 72], 1250}]
    };
get_item_attr(50204, 11) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 11
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1025},{attr_pet_resist_water, 819}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1964], 312},{attr_pet_mp, 3, [1, 225], 312},{attr_pet_defence, 3, [1, 562], 312},{attr_pet_resist_metal, 3, [1, 449], 312},{attr_pet_resist_wood, 3, [1, 449], 312},{attr_pet_resist_water, 3, [1, 449], 312},{attr_pet_resist_fire, 3, [1, 449], 312},{attr_pet_resist_earth, 3, [1, 449], 312},{attr_pet_anti_stone, 1, [1, 28], 416},{attr_pet_anti_stun, 1, [1, 28], 416},{attr_pet_anti_sleep, 1, [1, 28], 416},{attr_pet_anti_taunt, 1, [1, 28], 416},{attr_pet_anti_silent, 1, [1, 28], 416},{attr_pet_anti_poison, 1, [1, 28], 416},{attr_pet_dmg, 1, [1, 141], 1250},{attr_pet_dmg_magic, 1, [1, 85], 1250}]
    };
get_item_attr(50204, 12) ->
    #pet_item_attr{
        base_id = 50204
        ,name = <<"御水之灵">>
        ,lev = 12
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1201},{attr_pet_resist_water, 960}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 2283], 312},{attr_pet_mp, 3, [1, 261], 312},{attr_pet_defence, 3, [1, 653], 312},{attr_pet_resist_metal, 3, [1, 522], 312},{attr_pet_resist_wood, 3, [1, 522], 312},{attr_pet_resist_water, 3, [1, 522], 312},{attr_pet_resist_fire, 3, [1, 522], 312},{attr_pet_resist_earth, 3, [1, 522], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 164], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50205, 1) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 1
        ,exp = 16
        ,attr = []
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 120], 312},{attr_pet_mp, 3, [1, 14], 312},{attr_pet_defence, 3, [1, 34], 312},{attr_pet_resist_metal, 3, [1, 28], 312},{attr_pet_resist_wood, 3, [1, 28], 312},{attr_pet_resist_water, 3, [1, 28], 312},{attr_pet_resist_fire, 3, [1, 28], 312},{attr_pet_resist_earth, 3, [1, 28], 312},{attr_pet_anti_stone, 1, [1, 4], 416},{attr_pet_anti_stun, 1, [1, 4], 416},{attr_pet_anti_sleep, 1, [1, 4], 416},{attr_pet_anti_taunt, 1, [1, 4], 416},{attr_pet_anti_silent, 1, [1, 4], 416},{attr_pet_anti_poison, 1, [1, 4], 416},{attr_pet_dmg, 1, [1, 9], 1250},{attr_pet_dmg_magic, 1, [1, 6], 1250}]
    };
get_item_attr(50205, 2) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 2
        ,exp = 32
        ,attr = [{attr_pet_defence, 35},{attr_pet_resist_fire, 27}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 180], 312},{attr_pet_mp, 3, [1, 21], 312},{attr_pet_defence, 3, [1, 52], 312},{attr_pet_resist_metal, 3, [1, 41], 312},{attr_pet_resist_wood, 3, [1, 41], 312},{attr_pet_resist_water, 3, [1, 41], 312},{attr_pet_resist_fire, 3, [1, 41], 312},{attr_pet_resist_earth, 3, [1, 41], 312},{attr_pet_anti_stone, 1, [1, 5], 416},{attr_pet_anti_stun, 1, [1, 5], 416},{attr_pet_anti_sleep, 1, [1, 5], 416},{attr_pet_anti_taunt, 1, [1, 5], 416},{attr_pet_anti_silent, 1, [1, 5], 416},{attr_pet_anti_poison, 1, [1, 5], 416},{attr_pet_dmg, 1, [1, 13], 1250},{attr_pet_dmg_magic, 1, [1, 8], 1250}]
    };
get_item_attr(50205, 3) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 3
        ,exp = 64
        ,attr = [{attr_pet_defence, 92},{attr_pet_resist_fire, 73}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 283], 312},{attr_pet_mp, 3, [1, 33], 312},{attr_pet_defence, 3, [1, 81], 312},{attr_pet_resist_metal, 3, [1, 65], 312},{attr_pet_resist_wood, 3, [1, 65], 312},{attr_pet_resist_water, 3, [1, 65], 312},{attr_pet_resist_fire, 3, [1, 65], 312},{attr_pet_resist_earth, 3, [1, 65], 312},{attr_pet_anti_stone, 1, [1, 8], 416},{attr_pet_anti_stun, 1, [1, 8], 416},{attr_pet_anti_sleep, 1, [1, 8], 416},{attr_pet_anti_taunt, 1, [1, 8], 416},{attr_pet_anti_silent, 1, [1, 8], 416},{attr_pet_anti_poison, 1, [1, 8], 416},{attr_pet_dmg, 1, [1, 21], 1250},{attr_pet_dmg_magic, 1, [1, 12], 1250}]
    };
get_item_attr(50205, 4) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 4
        ,exp = 128
        ,attr = [{attr_pet_defence, 162},{attr_pet_resist_fire, 129}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 410], 312},{attr_pet_mp, 3, [1, 47], 312},{attr_pet_defence, 3, [1, 117], 312},{attr_pet_resist_metal, 3, [1, 94], 312},{attr_pet_resist_wood, 3, [1, 94], 312},{attr_pet_resist_water, 3, [1, 94], 312},{attr_pet_resist_fire, 3, [1, 94], 312},{attr_pet_resist_earth, 3, [1, 94], 312},{attr_pet_anti_stone, 1, [1, 10], 416},{attr_pet_anti_stun, 1, [1, 10], 416},{attr_pet_anti_sleep, 1, [1, 10], 416},{attr_pet_anti_taunt, 1, [1, 10], 416},{attr_pet_anti_silent, 1, [1, 10], 416},{attr_pet_anti_poison, 1, [1, 10], 416},{attr_pet_dmg, 1, [1, 30], 1250},{attr_pet_dmg_magic, 1, [1, 18], 1250}]
    };
get_item_attr(50205, 5) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 5
        ,exp = 256
        ,attr = [{attr_pet_defence, 246},{attr_pet_resist_fire, 196}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 560], 312},{attr_pet_mp, 3, [1, 64], 312},{attr_pet_defence, 3, [1, 160], 312},{attr_pet_resist_metal, 3, [1, 128], 312},{attr_pet_resist_wood, 3, [1, 128], 312},{attr_pet_resist_water, 3, [1, 128], 312},{attr_pet_resist_fire, 3, [1, 128], 312},{attr_pet_resist_earth, 3, [1, 128], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 40], 1250},{attr_pet_dmg_magic, 1, [1, 24], 1250}]
    };
get_item_attr(50205, 6) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 6
        ,exp = 512
        ,attr = [{attr_pet_defence, 342},{attr_pet_resist_fire, 273}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 734], 312},{attr_pet_mp, 3, [1, 84], 312},{attr_pet_defence, 3, [1, 210], 312},{attr_pet_resist_metal, 3, [1, 168], 312},{attr_pet_resist_wood, 3, [1, 168], 312},{attr_pet_resist_water, 3, [1, 168], 312},{attr_pet_resist_fire, 3, [1, 168], 312},{attr_pet_resist_earth, 3, [1, 168], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 53], 1250},{attr_pet_dmg_magic, 1, [1, 32], 1250}]
    };
get_item_attr(50205, 7) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 7
        ,exp = 1024
        ,attr = [{attr_pet_defence, 452},{attr_pet_resist_fire, 361}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 932], 312},{attr_pet_mp, 3, [1, 107], 312},{attr_pet_defence, 3, [1, 267], 312},{attr_pet_resist_metal, 3, [1, 213], 312},{attr_pet_resist_wood, 3, [1, 213], 312},{attr_pet_resist_water, 3, [1, 213], 312},{attr_pet_resist_fire, 3, [1, 213], 312},{attr_pet_resist_earth, 3, [1, 213], 312},{attr_pet_anti_stone, 1, [1, 18], 416},{attr_pet_anti_stun, 1, [1, 18], 416},{attr_pet_anti_sleep, 1, [1, 18], 416},{attr_pet_anti_taunt, 1, [1, 18], 416},{attr_pet_anti_silent, 1, [1, 18], 416},{attr_pet_anti_poison, 1, [1, 18], 416},{attr_pet_dmg, 1, [1, 67], 1250},{attr_pet_dmg_magic, 1, [1, 40], 1250}]
    };
get_item_attr(50205, 8) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 8
        ,exp = 2048
        ,attr = [{attr_pet_defence, 575},{attr_pet_resist_fire, 459}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1154], 312},{attr_pet_mp, 3, [1, 132], 312},{attr_pet_defence, 3, [1, 330], 312},{attr_pet_resist_metal, 3, [1, 264], 312},{attr_pet_resist_wood, 3, [1, 264], 312},{attr_pet_resist_water, 3, [1, 264], 312},{attr_pet_resist_fire, 3, [1, 264], 312},{attr_pet_resist_earth, 3, [1, 264], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 83], 1250},{attr_pet_dmg_magic, 1, [1, 50], 1250}]
    };
get_item_attr(50205, 9) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 9
        ,exp = 4096
        ,attr = [{attr_pet_defence, 712},{attr_pet_resist_fire, 568}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1400], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 23], 416},{attr_pet_anti_stun, 1, [1, 23], 416},{attr_pet_anti_sleep, 1, [1, 23], 416},{attr_pet_anti_taunt, 1, [1, 23], 416},{attr_pet_anti_silent, 1, [1, 23], 416},{attr_pet_anti_poison, 1, [1, 23], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250}]
    };
get_item_attr(50205, 10) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 10
        ,exp = 8192
        ,attr = [{attr_pet_defence, 862},{attr_pet_resist_fire, 688}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1670], 312},{attr_pet_mp, 3, [1, 191], 312},{attr_pet_defence, 3, [1, 478], 312},{attr_pet_resist_metal, 3, [1, 382], 312},{attr_pet_resist_wood, 3, [1, 382], 312},{attr_pet_resist_water, 3, [1, 382], 312},{attr_pet_resist_fire, 3, [1, 382], 312},{attr_pet_resist_earth, 3, [1, 382], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 120], 1250},{attr_pet_dmg_magic, 1, [1, 72], 1250}]
    };
get_item_attr(50205, 11) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 11
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1025},{attr_pet_resist_fire, 819}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1964], 312},{attr_pet_mp, 3, [1, 225], 312},{attr_pet_defence, 3, [1, 562], 312},{attr_pet_resist_metal, 3, [1, 449], 312},{attr_pet_resist_wood, 3, [1, 449], 312},{attr_pet_resist_water, 3, [1, 449], 312},{attr_pet_resist_fire, 3, [1, 449], 312},{attr_pet_resist_earth, 3, [1, 449], 312},{attr_pet_anti_stone, 1, [1, 28], 416},{attr_pet_anti_stun, 1, [1, 28], 416},{attr_pet_anti_sleep, 1, [1, 28], 416},{attr_pet_anti_taunt, 1, [1, 28], 416},{attr_pet_anti_silent, 1, [1, 28], 416},{attr_pet_anti_poison, 1, [1, 28], 416},{attr_pet_dmg, 1, [1, 141], 1250},{attr_pet_dmg_magic, 1, [1, 85], 1250}]
    };
get_item_attr(50205, 12) ->
    #pet_item_attr{
        base_id = 50205
        ,name = <<"御火之灵">>
        ,lev = 12
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1201},{attr_pet_resist_fire, 960}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 2283], 312},{attr_pet_mp, 3, [1, 261], 312},{attr_pet_defence, 3, [1, 653], 312},{attr_pet_resist_metal, 3, [1, 522], 312},{attr_pet_resist_wood, 3, [1, 522], 312},{attr_pet_resist_water, 3, [1, 522], 312},{attr_pet_resist_fire, 3, [1, 522], 312},{attr_pet_resist_earth, 3, [1, 522], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 164], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(50206, 1) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 1
        ,exp = 16
        ,attr = []
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 120], 312},{attr_pet_mp, 3, [1, 14], 312},{attr_pet_defence, 3, [1, 34], 312},{attr_pet_resist_metal, 3, [1, 28], 312},{attr_pet_resist_wood, 3, [1, 28], 312},{attr_pet_resist_water, 3, [1, 28], 312},{attr_pet_resist_fire, 3, [1, 28], 312},{attr_pet_resist_earth, 3, [1, 28], 312},{attr_pet_anti_stone, 1, [1, 4], 416},{attr_pet_anti_stun, 1, [1, 4], 416},{attr_pet_anti_sleep, 1, [1, 4], 416},{attr_pet_anti_taunt, 1, [1, 4], 416},{attr_pet_anti_silent, 1, [1, 4], 416},{attr_pet_anti_poison, 1, [1, 4], 416},{attr_pet_dmg, 1, [1, 9], 1250},{attr_pet_dmg_magic, 1, [1, 6], 1250}]
    };
get_item_attr(50206, 2) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 2
        ,exp = 32
        ,attr = [{attr_pet_defence, 35},{attr_pet_resist_earth, 27}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 180], 312},{attr_pet_mp, 3, [1, 21], 312},{attr_pet_defence, 3, [1, 52], 312},{attr_pet_resist_metal, 3, [1, 41], 312},{attr_pet_resist_wood, 3, [1, 41], 312},{attr_pet_resist_water, 3, [1, 41], 312},{attr_pet_resist_fire, 3, [1, 41], 312},{attr_pet_resist_earth, 3, [1, 41], 312},{attr_pet_anti_stone, 1, [1, 5], 416},{attr_pet_anti_stun, 1, [1, 5], 416},{attr_pet_anti_sleep, 1, [1, 5], 416},{attr_pet_anti_taunt, 1, [1, 5], 416},{attr_pet_anti_silent, 1, [1, 5], 416},{attr_pet_anti_poison, 1, [1, 5], 416},{attr_pet_dmg, 1, [1, 13], 1250},{attr_pet_dmg_magic, 1, [1, 8], 1250}]
    };
get_item_attr(50206, 3) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 3
        ,exp = 64
        ,attr = [{attr_pet_defence, 92},{attr_pet_resist_earth, 73}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 283], 312},{attr_pet_mp, 3, [1, 33], 312},{attr_pet_defence, 3, [1, 81], 312},{attr_pet_resist_metal, 3, [1, 65], 312},{attr_pet_resist_wood, 3, [1, 65], 312},{attr_pet_resist_water, 3, [1, 65], 312},{attr_pet_resist_fire, 3, [1, 65], 312},{attr_pet_resist_earth, 3, [1, 65], 312},{attr_pet_anti_stone, 1, [1, 8], 416},{attr_pet_anti_stun, 1, [1, 8], 416},{attr_pet_anti_sleep, 1, [1, 8], 416},{attr_pet_anti_taunt, 1, [1, 8], 416},{attr_pet_anti_silent, 1, [1, 8], 416},{attr_pet_anti_poison, 1, [1, 8], 416},{attr_pet_dmg, 1, [1, 21], 1250},{attr_pet_dmg_magic, 1, [1, 12], 1250}]
    };
get_item_attr(50206, 4) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 4
        ,exp = 128
        ,attr = [{attr_pet_defence, 162},{attr_pet_resist_earth, 129}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 410], 312},{attr_pet_mp, 3, [1, 47], 312},{attr_pet_defence, 3, [1, 117], 312},{attr_pet_resist_metal, 3, [1, 94], 312},{attr_pet_resist_wood, 3, [1, 94], 312},{attr_pet_resist_water, 3, [1, 94], 312},{attr_pet_resist_fire, 3, [1, 94], 312},{attr_pet_resist_earth, 3, [1, 94], 312},{attr_pet_anti_stone, 1, [1, 10], 416},{attr_pet_anti_stun, 1, [1, 10], 416},{attr_pet_anti_sleep, 1, [1, 10], 416},{attr_pet_anti_taunt, 1, [1, 10], 416},{attr_pet_anti_silent, 1, [1, 10], 416},{attr_pet_anti_poison, 1, [1, 10], 416},{attr_pet_dmg, 1, [1, 30], 1250},{attr_pet_dmg_magic, 1, [1, 18], 1250}]
    };
get_item_attr(50206, 5) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 5
        ,exp = 256
        ,attr = [{attr_pet_defence, 246},{attr_pet_resist_earth, 196}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 560], 312},{attr_pet_mp, 3, [1, 64], 312},{attr_pet_defence, 3, [1, 160], 312},{attr_pet_resist_metal, 3, [1, 128], 312},{attr_pet_resist_wood, 3, [1, 128], 312},{attr_pet_resist_water, 3, [1, 128], 312},{attr_pet_resist_fire, 3, [1, 128], 312},{attr_pet_resist_earth, 3, [1, 128], 312},{attr_pet_anti_stone, 1, [1, 13], 416},{attr_pet_anti_stun, 1, [1, 13], 416},{attr_pet_anti_sleep, 1, [1, 13], 416},{attr_pet_anti_taunt, 1, [1, 13], 416},{attr_pet_anti_silent, 1, [1, 13], 416},{attr_pet_anti_poison, 1, [1, 13], 416},{attr_pet_dmg, 1, [1, 40], 1250},{attr_pet_dmg_magic, 1, [1, 24], 1250}]
    };
get_item_attr(50206, 6) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 6
        ,exp = 512
        ,attr = [{attr_pet_defence, 342},{attr_pet_resist_earth, 273}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 734], 312},{attr_pet_mp, 3, [1, 84], 312},{attr_pet_defence, 3, [1, 210], 312},{attr_pet_resist_metal, 3, [1, 168], 312},{attr_pet_resist_wood, 3, [1, 168], 312},{attr_pet_resist_water, 3, [1, 168], 312},{attr_pet_resist_fire, 3, [1, 168], 312},{attr_pet_resist_earth, 3, [1, 168], 312},{attr_pet_anti_stone, 1, [1, 15], 416},{attr_pet_anti_stun, 1, [1, 15], 416},{attr_pet_anti_sleep, 1, [1, 15], 416},{attr_pet_anti_taunt, 1, [1, 15], 416},{attr_pet_anti_silent, 1, [1, 15], 416},{attr_pet_anti_poison, 1, [1, 15], 416},{attr_pet_dmg, 1, [1, 53], 1250},{attr_pet_dmg_magic, 1, [1, 32], 1250}]
    };
get_item_attr(50206, 7) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 7
        ,exp = 1024
        ,attr = [{attr_pet_defence, 452},{attr_pet_resist_earth, 361}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 932], 312},{attr_pet_mp, 3, [1, 107], 312},{attr_pet_defence, 3, [1, 267], 312},{attr_pet_resist_metal, 3, [1, 213], 312},{attr_pet_resist_wood, 3, [1, 213], 312},{attr_pet_resist_water, 3, [1, 213], 312},{attr_pet_resist_fire, 3, [1, 213], 312},{attr_pet_resist_earth, 3, [1, 213], 312},{attr_pet_anti_stone, 1, [1, 18], 416},{attr_pet_anti_stun, 1, [1, 18], 416},{attr_pet_anti_sleep, 1, [1, 18], 416},{attr_pet_anti_taunt, 1, [1, 18], 416},{attr_pet_anti_silent, 1, [1, 18], 416},{attr_pet_anti_poison, 1, [1, 18], 416},{attr_pet_dmg, 1, [1, 67], 1250},{attr_pet_dmg_magic, 1, [1, 40], 1250}]
    };
get_item_attr(50206, 8) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 8
        ,exp = 2048
        ,attr = [{attr_pet_defence, 575},{attr_pet_resist_earth, 459}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1154], 312},{attr_pet_mp, 3, [1, 132], 312},{attr_pet_defence, 3, [1, 330], 312},{attr_pet_resist_metal, 3, [1, 264], 312},{attr_pet_resist_wood, 3, [1, 264], 312},{attr_pet_resist_water, 3, [1, 264], 312},{attr_pet_resist_fire, 3, [1, 264], 312},{attr_pet_resist_earth, 3, [1, 264], 312},{attr_pet_anti_stone, 1, [1, 20], 416},{attr_pet_anti_stun, 1, [1, 20], 416},{attr_pet_anti_sleep, 1, [1, 20], 416},{attr_pet_anti_taunt, 1, [1, 20], 416},{attr_pet_anti_silent, 1, [1, 20], 416},{attr_pet_anti_poison, 1, [1, 20], 416},{attr_pet_dmg, 1, [1, 83], 1250},{attr_pet_dmg_magic, 1, [1, 50], 1250}]
    };
get_item_attr(50206, 9) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 9
        ,exp = 4096
        ,attr = [{attr_pet_defence, 712},{attr_pet_resist_earth, 568}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1400], 312},{attr_pet_mp, 3, [1, 160], 312},{attr_pet_defence, 3, [1, 400], 312},{attr_pet_resist_metal, 3, [1, 320], 312},{attr_pet_resist_wood, 3, [1, 320], 312},{attr_pet_resist_water, 3, [1, 320], 312},{attr_pet_resist_fire, 3, [1, 320], 312},{attr_pet_resist_earth, 3, [1, 320], 312},{attr_pet_anti_stone, 1, [1, 23], 416},{attr_pet_anti_stun, 1, [1, 23], 416},{attr_pet_anti_sleep, 1, [1, 23], 416},{attr_pet_anti_taunt, 1, [1, 23], 416},{attr_pet_anti_silent, 1, [1, 23], 416},{attr_pet_anti_poison, 1, [1, 23], 416},{attr_pet_dmg, 1, [1, 100], 1250},{attr_pet_dmg_magic, 1, [1, 60], 1250}]
    };
get_item_attr(50206, 10) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 10
        ,exp = 8192
        ,attr = [{attr_pet_defence, 862},{attr_pet_resist_earth, 688}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1670], 312},{attr_pet_mp, 3, [1, 191], 312},{attr_pet_defence, 3, [1, 478], 312},{attr_pet_resist_metal, 3, [1, 382], 312},{attr_pet_resist_wood, 3, [1, 382], 312},{attr_pet_resist_water, 3, [1, 382], 312},{attr_pet_resist_fire, 3, [1, 382], 312},{attr_pet_resist_earth, 3, [1, 382], 312},{attr_pet_anti_stone, 1, [1, 25], 416},{attr_pet_anti_stun, 1, [1, 25], 416},{attr_pet_anti_sleep, 1, [1, 25], 416},{attr_pet_anti_taunt, 1, [1, 25], 416},{attr_pet_anti_silent, 1, [1, 25], 416},{attr_pet_anti_poison, 1, [1, 25], 416},{attr_pet_dmg, 1, [1, 120], 1250},{attr_pet_dmg_magic, 1, [1, 72], 1250}]
    };
get_item_attr(50206, 11) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 11
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1025},{attr_pet_resist_earth, 819}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 1964], 312},{attr_pet_mp, 3, [1, 225], 312},{attr_pet_defence, 3, [1, 562], 312},{attr_pet_resist_metal, 3, [1, 449], 312},{attr_pet_resist_wood, 3, [1, 449], 312},{attr_pet_resist_water, 3, [1, 449], 312},{attr_pet_resist_fire, 3, [1, 449], 312},{attr_pet_resist_earth, 3, [1, 449], 312},{attr_pet_anti_stone, 1, [1, 28], 416},{attr_pet_anti_stun, 1, [1, 28], 416},{attr_pet_anti_sleep, 1, [1, 28], 416},{attr_pet_anti_taunt, 1, [1, 28], 416},{attr_pet_anti_silent, 1, [1, 28], 416},{attr_pet_anti_poison, 1, [1, 28], 416},{attr_pet_dmg, 1, [1, 141], 1250},{attr_pet_dmg_magic, 1, [1, 85], 1250}]
    };
get_item_attr(50206, 12) ->
    #pet_item_attr{
        base_id = 50206
        ,name = <<"御土之灵">>
        ,lev = 12
        ,exp = 16384
        ,attr = [{attr_pet_defence, 1201},{attr_pet_resist_earth, 960}]
        ,polish = {1, 2}
        ,polish_list = [{attr_pet_hp, 3, [1, 2283], 312},{attr_pet_mp, 3, [1, 261], 312},{attr_pet_defence, 3, [1, 653], 312},{attr_pet_resist_metal, 3, [1, 522], 312},{attr_pet_resist_wood, 3, [1, 522], 312},{attr_pet_resist_water, 3, [1, 522], 312},{attr_pet_resist_fire, 3, [1, 522], 312},{attr_pet_resist_earth, 3, [1, 522], 312},{attr_pet_anti_stone, 1, [1, 30], 416},{attr_pet_anti_stun, 1, [1, 30], 416},{attr_pet_anti_sleep, 1, [1, 30], 416},{attr_pet_anti_taunt, 1, [1, 30], 416},{attr_pet_anti_silent, 1, [1, 30], 416},{attr_pet_anti_poison, 1, [1, 30], 416},{attr_pet_dmg, 1, [1, 164], 1250},{attr_pet_dmg_magic, 1, [1, 98], 1250}]
    };
get_item_attr(_BaseId, _Lev) -> false.

%% 获取兑换数据
exchange_list() -> [50051,50052,50053,50054,50055,50056,50057,50058,50101,50102
   ,50103,50104,50105,50106,50107,50013,50011].

get_exchange(50051) -> 30;
get_exchange(50052) -> 30;
get_exchange(50053) -> 30;
get_exchange(50054) -> 30;
get_exchange(50055) -> 30;
get_exchange(50056) -> 30;
get_exchange(50057) -> 30;
get_exchange(50058) -> 30;
get_exchange(50101) -> 8;
get_exchange(50102) -> 8;
get_exchange(50103) -> 8;
get_exchange(50104) -> 8;
get_exchange(50105) -> 8;
get_exchange(50106) -> 8;
get_exchange(50107) -> 8;
get_exchange(50013) -> 2;
get_exchange(50011) -> 10;
get_exchange(_BaseId) -> false.

%% 魔晶洗炼星级数
get_polish_star(0, RandVal) when RandVal >= 0 andalso RandVal =< 1700 -> 1;
get_polish_star(0, RandVal) when RandVal >= 1700 andalso RandVal =< 3300 -> 2;
get_polish_star(0, RandVal) when RandVal >= 3300 andalso RandVal =< 4800 -> 3;
get_polish_star(0, RandVal) when RandVal >= 4800 andalso RandVal =< 6200 -> 4;
get_polish_star(0, RandVal) when RandVal >= 6200 andalso RandVal =< 7500 -> 5;
get_polish_star(0, RandVal) when RandVal >= 7500 andalso RandVal =< 8600 -> 6;
get_polish_star(0, RandVal) when RandVal >= 8600 andalso RandVal =< 9100 -> 7;
get_polish_star(0, RandVal) when RandVal >= 9100 andalso RandVal =< 9500 -> 8;
get_polish_star(0, RandVal) when RandVal >= 9500 andalso RandVal =< 9800 -> 9;
get_polish_star(0, RandVal) when RandVal >= 9800 andalso RandVal =< 10000 -> 10;
get_polish_star(1, RandVal) when RandVal >= 0 andalso RandVal =< 1800 -> 1;
get_polish_star(1, RandVal) when RandVal >= 1800 andalso RandVal =< 3500 -> 2;
get_polish_star(1, RandVal) when RandVal >= 3500 andalso RandVal =< 5100 -> 3;
get_polish_star(1, RandVal) when RandVal >= 5100 andalso RandVal =< 6600 -> 4;
get_polish_star(1, RandVal) when RandVal >= 6600 andalso RandVal =< 8000 -> 5;
get_polish_star(1, RandVal) when RandVal >= 8000 andalso RandVal =< 9160 -> 6;
get_polish_star(1, RandVal) when RandVal >= 9160 andalso RandVal =< 9460 -> 7;
get_polish_star(1, RandVal) when RandVal >= 9460 andalso RandVal =< 9700 -> 8;
get_polish_star(1, RandVal) when RandVal >= 9700 andalso RandVal =< 9880 -> 9;
get_polish_star(1, RandVal) when RandVal >= 9880 andalso RandVal =< 10000 -> 10;
get_polish_star(2, RandVal) when RandVal >= 0 andalso RandVal =< 1830 -> 1;
get_polish_star(2, RandVal) when RandVal >= 1830 andalso RandVal =< 3560 -> 2;
get_polish_star(2, RandVal) when RandVal >= 3560 andalso RandVal =< 5190 -> 3;
get_polish_star(2, RandVal) when RandVal >= 5190 andalso RandVal =< 6720 -> 4;
get_polish_star(2, RandVal) when RandVal >= 6720 andalso RandVal =< 8150 -> 5;
get_polish_star(2, RandVal) when RandVal >= 8150 andalso RandVal =< 9370 -> 6;
get_polish_star(2, RandVal) when RandVal >= 9370 andalso RandVal =< 9595 -> 7;
get_polish_star(2, RandVal) when RandVal >= 9595 andalso RandVal =< 9775 -> 8;
get_polish_star(2, RandVal) when RandVal >= 9775 andalso RandVal =< 9910 -> 9;
get_polish_star(2, RandVal) when RandVal >= 9910 andalso RandVal =< 10000 -> 10;
get_polish_star(3, RandVal) when RandVal >= 0 andalso RandVal =< 1840 -> 1;
get_polish_star(3, RandVal) when RandVal >= 1840 andalso RandVal =< 3580 -> 2;
get_polish_star(3, RandVal) when RandVal >= 3580 andalso RandVal =< 5220 -> 3;
get_polish_star(3, RandVal) when RandVal >= 5220 andalso RandVal =< 6760 -> 4;
get_polish_star(3, RandVal) when RandVal >= 6760 andalso RandVal =< 8200 -> 5;
get_polish_star(3, RandVal) when RandVal >= 8200 andalso RandVal =< 9440 -> 6;
get_polish_star(3, RandVal) when RandVal >= 9440 andalso RandVal =< 9640 -> 7;
get_polish_star(3, RandVal) when RandVal >= 9640 andalso RandVal =< 9800 -> 8;
get_polish_star(3, RandVal) when RandVal >= 9800 andalso RandVal =< 9920 -> 9;
get_polish_star(3, RandVal) when RandVal >= 9920 andalso RandVal =< 10000 -> 10;
get_polish_star(4, RandVal) when RandVal >= 0 andalso RandVal =< 1860 -> 1;
get_polish_star(4, RandVal) when RandVal >= 1860 andalso RandVal =< 3620 -> 2;
get_polish_star(4, RandVal) when RandVal >= 3620 andalso RandVal =< 5280 -> 3;
get_polish_star(4, RandVal) when RandVal >= 5280 andalso RandVal =< 6840 -> 4;
get_polish_star(4, RandVal) when RandVal >= 6840 andalso RandVal =< 8300 -> 5;
get_polish_star(4, RandVal) when RandVal >= 8300 andalso RandVal =< 9510 -> 6;
get_polish_star(4, RandVal) when RandVal >= 9510 andalso RandVal =< 9685 -> 7;
get_polish_star(4, RandVal) when RandVal >= 9685 andalso RandVal =< 9825 -> 8;
get_polish_star(4, RandVal) when RandVal >= 9825 andalso RandVal =< 9930 -> 9;
get_polish_star(4, RandVal) when RandVal >= 9930 andalso RandVal =< 10000 -> 10;
get_polish_star(_LockNum, _RandVal) -> 1.
