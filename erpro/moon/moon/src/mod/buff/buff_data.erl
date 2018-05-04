%%----------------------------------------------------
%% 预定义BUFF
%% @author yeahoo2000@gmail.com jackguan@jieyou.cn
%%----------------------------------------------------
-module(buff_data).
-export([
        exclude/1
        ,get/1
        ,cover/1
        ,conflict/1
        ,get_look_id/1
        ,get_mount_look_id/1
    ]
).
-include("buff.hrl").

%% BUFF互斥设定，返回的列表中包含不能共存的buff
exclude(_) -> [].

%% 覆盖设定
cover(hp_max_per_low) -> [hp_max_per_low];
cover(hp_max_per_middle) -> [hp_max_per_middle, hp_max_per_low];
cover(hp_max_per_high) -> [hp_max_per_low, hp_max_per_middle, hp_max_per_high];
cover(mp_max_per_low) -> [mp_max_per_low];
cover(mp_max_per_middle) -> [mp_max_per_middle,mp_max_per_low];
cover(mp_max_per_high) -> [mp_max_per_high,mp_max_per_middle,mp_max_per_low];
cover(df_max_per_low) -> [df_max_per_low];
cover(df_max_per_middle) -> [df_max_per_middle,df_max_per_low];
cover(df_max_per_high) -> [df_max_per_high,df_max_per_middle,df_max_per_low];
cover(exp_low) -> [exp_low];
cover(exp_middle) -> [exp_middle,exp_low];
cover(exp_high) -> [exp_high,exp_middle,exp_low];
cover(spirit_low) -> [spirit_low];
cover(spirit_middle) -> [spirit_middle,spirit_low];
cover(spirit_high) -> [spirit_high,spirit_middle,spirit_low];
cover(pet_exp_double) -> [pet_exp_double];
cover(pet_exp_triple) -> [pet_exp_triple,pet_exp_double];
cover(dmg_max_per_low) -> [dmg_max_per_low];
cover(dmg_max_per_middle) -> [dmg_max_per_middle,dmg_max_per_low];
cover(dmg_max_per_high) -> [dmg_max_per_high,dmg_max_per_middle,dmg_max_per_low];
cover(hitrate_max_per_low) -> [hitrate_max_per_low];
cover(hitrate_max_per_middle) -> [hitrate_max_per_middle,hitrate_max_per_low];
cover(hitrate_max_per_high) -> [hitrate_max_per_high,hitrate_max_per_middle,hitrate_max_per_low];
cover(evasion_max_per_low) -> [evasion_max_per_low];
cover(evasion_max_per_middle) -> [evasion_max_per_middle,evasion_max_per_low];
cover(evasion_max_per_high) -> [evasion_max_per_high,evasion_max_per_middle,evasion_max_per_low];
cover(vip_bless_3) -> [vip_bless_3];
cover(vip_bless_2) -> [vip_bless_2,vip_bless_3];
cover(vip_bless) -> [vip_bless,vip_bless_2,vip_bless_3];
cover(sns_buff_lv1) -> [sns_buff_lv1];
cover(sns_buff_lv2) -> [sns_buff_lv1,sns_buff_lv2];
cover(sns_buff_lv3) -> [sns_buff_lv1,sns_buff_lv2,sns_buff_lv3];
cover(sns_buff_lv4) -> [sns_buff_lv1,sns_buff_lv2,sns_buff_lv3,sns_buff_lv4];
cover(sns_buff_lv5) -> [sns_buff_lv1,sns_buff_lv2,sns_buff_lv3,sns_buff_lv4,sns_buff_lv5];
cover(sit_exp5_1) -> [sit_exp5_1, sit_exp5_3];
cover(sit_exp5_3) -> [sit_exp5_1, sit_exp5_3];
cover(guild_war_winer) -> [guild_war_winer];
cover(resist_all_per_high) -> [resist_all_per_high];
cover(super_boss_atk20) -> [super_boss_atk20];
cover(super_boss_atk40) -> [super_boss_atk20,super_boss_atk40];
cover(super_boss_atk60) -> [super_boss_atk20,super_boss_atk40,super_boss_atk60];
cover(super_boss_atk80) -> [super_boss_atk20,super_boss_atk40,super_boss_atk60,super_boss_atk80];
cover(super_boss_atk100) -> [super_boss_atk20,super_boss_atk40,super_boss_atk60,super_boss_atk80,super_boss_atk100];
cover(married_buff_1) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_2) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_3) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_4) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_5) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_6) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_7) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_8) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_9) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(married_buff_10) -> [married_buff_1,married_buff_2,married_buff_3,married_buff_4,married_buff_5,married_buff_6,married_buff_7,married_buff_8,married_buff_9,married_buff_10];
cover(_) -> [].

%%冲突设定
conflict(hp_max_per_low) -> [hp_max_per_middle, hp_max_per_high];
conflict(hp_max_per_middle) -> [hp_max_per_high];
conflict(mp_max_per_low) -> [mp_max_per_middle,mp_max_per_high];
conflict(mp_max_per_middle) -> [mp_max_per_high];
conflict(df_max_per_low) -> [df_max_per_middle,df_max_per_high];
conflict(df_max_per_middle) -> [df_max_per_high];
conflict(exp_low) -> [exp_middle,exp_high];
conflict(exp_middle) -> [exp_high];
conflict(spirit_low) -> [spirit_middle,spirit_high];
conflict(spirit_middle) -> [spirit_high];
conflict(dmg_max_per_low) -> [dmg_max_per_middle,dmg_max_per_high];
conflict(dmg_max_per_middle) -> [dmg_max_per_high];
conflict(hitrate_max_per_low) -> [hitrate_max_per_middle,hitrate_max_per_high];
conflict(hitrate_max_per_middle) -> [hitrate_max_per_high];
conflict(evasion_max_per_low) -> [evasion_max_per_middle,evasion_max_per_high];
conflict(evasion_max_per_middle) -> [evasion_max_per_high];
conflict(vip_bless_3) -> [vip_bless_2,vip_bless];
conflict(vip_bless_2) -> [vip_bless];
conflict(pet_exp_double) -> [pet_exp_triple];
conflict(sns_buff_lv1) -> [sns_buff_lv2,sns_buff_lv3,sns_buff_lv4,sns_buff_lv5];
conflict(sns_buff_lv2) -> [sns_buff_lv3,sns_buff_lv4,sns_buff_lv5];
conflict(sns_buff_lv3) -> [sns_buff_lv4,sns_buff_lv5];
conflict(sns_buff_lv4) -> [sns_buff_lv5];
conflict(wish_lucky) -> [wish_lucky];
conflict(fly_buff_1) -> [fly_buff_1,fly_buff_2,fly_buff_3];
conflict(fly_buff_2) -> [fly_buff_1,fly_buff_2,fly_buff_3];
conflict(fly_buff_3) -> [fly_buff_1,fly_buff_2,fly_buff_3];
conflict(super_boss_atk20) -> [super_boss_atk40,super_boss_atk60,super_boss_atk80,super_boss_atk100];
conflict(super_boss_atk40) -> [super_boss_atk60,super_boss_atk80,super_boss_atk100];
conflict(super_boss_atk60) -> [super_boss_atk80,super_boss_atk100];
conflict(super_boss_atk80) -> [super_boss_atk100];
conflict(_) -> [].

%% 预定义BUFF
get(guild_hp_21) ->
    {ok, #buff{
    		label = guild_hp_21
            ,name = <<"低级黎明之息">>
            ,baseid = 45
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max_per,10}]
        }
    };
get(guild_hp_22) ->
    {ok, #buff{
    		label = guild_hp_22
            ,name = <<"中级黎明之息">>
            ,baseid = 45
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max_per,15}]
        }
    };
get(guild_hp_23) ->
    {ok, #buff{
    		label = guild_hp_23
            ,name = <<"高级黎明之息">>
            ,baseid = 45
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max_per,20}]
        }
    };
get(guild_tenacity_21) ->
    {ok, #buff{
    		label = guild_tenacity_21
            ,name = <<"低级波浪形态">>
            ,baseid = 95
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{tenacity_per,10}]
        }
    };
get(guild_tenacity_22) ->
    {ok, #buff{
    		label = guild_tenacity_22
            ,name = <<"中级波浪形态">>
            ,baseid = 95
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{tenacity_per,15}]
        }
    };
get(guild_tenacity_23) ->
    {ok, #buff{
    		label = guild_tenacity_23
            ,name = <<"高级波浪形态">>
            ,baseid = 95
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{tenacity_per,20}]
        }
    };
get(guild_dmg_21) ->
    {ok, #buff{
    		label = guild_dmg_21
            ,name = <<"低级钻心">>
            ,baseid = 35
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{dmg_per,5}]
        }
    };
get(guild_dmg_22) ->
    {ok, #buff{
    		label = guild_dmg_22
            ,name = <<"中级钻心">>
            ,baseid = 35
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{dmg_per,8}]
        }
    };
get(guild_dmg_23) ->
    {ok, #buff{
    		label = guild_dmg_23
            ,name = <<"高级钻心">>
            ,baseid = 35
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{dmg_per,10}]
        }
    };
get(guild_critrate_21) ->
    {ok, #buff{
    		label = guild_critrate_21
            ,name = <<"低级狂暴">>
            ,baseid = 85
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{critrate_per,10}]
        }
    };
get(guild_critrate_22) ->
    {ok, #buff{
    		label = guild_critrate_22
            ,name = <<"中级狂暴">>
            ,baseid = 85
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{critrate_per,15}]
        }
    };
get(guild_critrate_23) ->
    {ok, #buff{
    		label = guild_critrate_23
            ,name = <<"高级狂暴">>
            ,baseid = 85
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{critrate_per,20}]
        }
    };
get(guild_hitrate_21) ->
    {ok, #buff{
    		label = guild_hitrate_21
            ,name = <<"低级精确打击">>
            ,baseid = 65
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hitrate_per,5}]
        }
    };
get(guild_hitrate_22) ->
    {ok, #buff{
    		label = guild_hitrate_22
            ,name = <<"中级精确打击">>
            ,baseid = 65
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hitrate_per,8}]
        }
    };
get(guild_hitrate_23) ->
    {ok, #buff{
    		label = guild_hitrate_23
            ,name = <<"高级精确打击">>
            ,baseid = 65
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hitrate_per,10}]
        }
    };
get(guild_evasion_21) ->
    {ok, #buff{
    		label = guild_evasion_21
            ,name = <<"低级闪烁">>
            ,baseid = 75
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{evasion_per,5}]
        }
    };
get(guild_evasion_22) ->
    {ok, #buff{
    		label = guild_evasion_22
            ,name = <<"中级闪烁">>
            ,baseid = 75
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{evasion_per,8}]
        }
    };
get(guild_evasion_23) ->
    {ok, #buff{
    		label = guild_evasion_23
            ,name = <<"高级闪烁">>
            ,baseid = 75
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{evasion_per,10}]
        }
    };
get(guild_defence_21) ->
    {ok, #buff{
    		label = guild_defence_21
            ,name = <<"低级龟息">>
            ,baseid = 15
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{defence_per,5}]
        }
    };
get(guild_defence_22) ->
    {ok, #buff{
    		label = guild_defence_22
            ,name = <<"中级龟息">>
            ,baseid = 15
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{defence_per,8}]
        }
    };
get(guild_defence_23) ->
    {ok, #buff{
    		label = guild_defence_23
            ,name = <<"高级龟息">>
            ,baseid = 15
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{defence_per,10}]
        }
    };
get(guild_mp_21) ->
    {ok, #buff{
    		label = guild_mp_21
            ,name = <<"低级芳华">>
            ,baseid = 25
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{mp_max_per,5}]
        }
    };
get(guild_mp_22) ->
    {ok, #buff{
    		label = guild_mp_22
            ,name = <<"中级芳华">>
            ,baseid = 25
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{mp_max_per,8}]
        }
    };
get(guild_mp_23) ->
    {ok, #buff{
    		label = guild_mp_23
            ,name = <<"高级芳华">>
            ,baseid = 25
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{mp_max_per,10}]
        }
    };
get(compete_all_1) ->
    {ok, #buff{
    		label = compete_all_1
            ,name = <<"死亡buff">>
            ,baseid = 100
            ,icon = 100
            ,multi = 2
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max_per,5},{tenacity_per,5},{evasion_per,5},{hitrate_per,5},{dmg_per,5},{critrate_per,5},{mp_max_per,5},{df_max_per,5},{rst_all_per,5}]
        }
    };
get(hp_max_per_low) ->
    {ok, #buff{
    		label = hp_max_per_low
            ,name = <<"初級氣血藥">>
            ,baseid = 1
            ,icon = 1
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{hp_max_per,10}]
        }
    };
get(hp_max_per_middle) ->
    {ok, #buff{
    		label = hp_max_per_middle
            ,name = <<"中級氣血藥">>
            ,baseid = 2
            ,icon = 2
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{hp_max_per,15}]
        }
    };
get(hp_max_per_high) ->
    {ok, #buff{
    		label = hp_max_per_high
            ,name = <<"高級氣血藥">>
            ,baseid = 3
            ,icon = 3
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{hp_max_per,20}]
        }
    };
get(mp_max_per_low) ->
    {ok, #buff{
    		label = mp_max_per_low
            ,name = <<"初級法力藥">>
            ,baseid = 4
            ,icon = 4
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{mp_max_per,10}]
        }
    };
get(mp_max_per_middle) ->
    {ok, #buff{
    		label = mp_max_per_middle
            ,name = <<"中級法力藥">>
            ,baseid = 5
            ,icon = 5
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{mp_max_per,20}]
        }
    };
get(mp_max_per_high) ->
    {ok, #buff{
    		label = mp_max_per_high
            ,name = <<"高級法力藥">>
            ,baseid = 6
            ,icon = 6
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{mp_max_per,40}]
        }
    };
get(df_max_per_low) ->
    {ok, #buff{
    		label = df_max_per_low
            ,name = <<"初級防禦藥">>
            ,baseid = 7
            ,icon = 7
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{df_max_per,10}]
        }
    };
get(df_max_per_middle) ->
    {ok, #buff{
    		label = df_max_per_middle
            ,name = <<"中級防禦藥">>
            ,baseid = 8
            ,icon = 8
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{df_max_per,15}]
        }
    };
get(df_max_per_high) ->
    {ok, #buff{
    		label = df_max_per_high
            ,name = <<"高級防禦藥">>
            ,baseid = 9
            ,icon = 9
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{df_max_per,20}]
        }
    };
get(hp_pool) ->
    {ok, #buff{
    		label = hp_pool
            ,name = <<"氣血包">>
            ,baseid = 10
            ,icon = 10
            ,multi = 2
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = 50000
            ,msg = <<"">>
            ,effect = [{hp_pool,50000}]
        }
    };
get(hp_pool_big) ->
    {ok, #buff{
    		label = hp_pool_big
            ,name = <<"大氣血包">>
            ,baseid = 11
            ,icon = 11
            ,multi = 2
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = 200000 
            ,msg = <<"">>
            ,effect = [{hp_pool,200000}]
        }
    };
get(mp_pool) ->
    {ok, #buff{
    		label = mp_pool
            ,name = <<"法力包">>
            ,baseid = 12
            ,icon = 12
            ,multi = 2
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = 50000
            ,msg = <<"">>
            ,effect = [{mp_pool,50000}]
        }
    };
get(mp_pool_big) ->
    {ok, #buff{
    		label = mp_pool_big
            ,name = <<"大法力包">>
            ,baseid = 13
            ,icon = 13
            ,multi = 2
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = 200000
            ,msg = <<"">>
            ,effect = [{mp_pool,200000}]
        }
    };
get(exp_low) ->
    {ok, #buff{
    		label = exp_low
            ,name = <<"初級經驗符">>
            ,baseid = 14
            ,icon = 14
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{exp_time,50}]
        }
    };
get(exp_middle) ->
    {ok, #buff{
    		label = exp_middle
            ,name = <<"中級經驗符">>
            ,baseid = 15
            ,icon = 15
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{exp_time,50}]
        }
    };
get(exp_high) ->
    {ok, #buff{
    		label = exp_high
            ,name = <<"高級經驗符">>
            ,baseid = 16
            ,icon = 16
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{exp_time,100}]
        }
    };
get(spirit_low) ->
    {ok, #buff{
    		label = spirit_low
            ,name = <<"初級靈力符">>
            ,baseid = 17
            ,icon = 17
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{spirit_time,50}]
        }
    };
get(spirit_middle) ->
    {ok, #buff{
    		label = spirit_middle
            ,name = <<"中級靈力符">>
            ,baseid = 18
            ,icon = 18
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{spirit_time,50}]
        }
    };
get(spirit_high) ->
    {ok, #buff{
    		label = spirit_high
            ,name = <<"高級靈力符">>
            ,baseid = 19
            ,icon = 19
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{spirit_time,100}]
        }
    };
get(pet_exp_double) ->
    {ok, #buff{
    		label = pet_exp_double
            ,name = <<"雙倍仙寵經驗仙草">>
            ,baseid = 20
            ,icon = 20
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{xcexp_time,100}]
        }
    };
get(pet_exp_triple) ->
    {ok, #buff{
    		label = pet_exp_triple
            ,name = <<"三倍仙寵經驗仙草">>
            ,baseid = 21
            ,icon = 21
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{xcexp_time,200}]
        }
    };
get(vip_bless) ->
    {ok, #buff{
    		label = vip_bless
            ,name = <<"vip祝福">>
            ,baseid = 22
            ,icon = 22
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 7200
            ,msg = <<"">>
            ,effect = [{dmg,50},{defence,300},{hp_max,300},{resist_wood,100},{resist_water,100},{resist_fire,100},{resist_earth,100},{resist_metal,100}]
        }
    };
get(escort) ->
    {ok, #buff{
    		label = escort
            ,name = <<"護送美女">>
            ,baseid = 23
            ,icon = 23
            ,multi = 0
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{speed_per_reduce,40}]
        }
    };
get(dmg_max_per_low) ->
    {ok, #buff{
    		label = dmg_max_per_low
            ,name = <<"初級攻擊藥">>
            ,baseid = 24
            ,icon = 24
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{dmg_per,5}]
        }
    };
get(dmg_max_per_middle) ->
    {ok, #buff{
    		label = dmg_max_per_middle
            ,name = <<"中級攻擊藥">>
            ,baseid = 25
            ,icon = 25
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{dmg_per,10}]
        }
    };
get(dmg_max_per_high) ->
    {ok, #buff{
    		label = dmg_max_per_high
            ,name = <<"高級攻擊藥">>
            ,baseid = 26
            ,icon = 26
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{dmg_per,15}]
        }
    };
get(hitrate_max_per_low) ->
    {ok, #buff{
    		label = hitrate_max_per_low
            ,name = <<"初級命中藥">>
            ,baseid = 27
            ,icon = 27
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{hitrate,30}]
        }
    };
get(hitrate_max_per_middle) ->
    {ok, #buff{
    		label = hitrate_max_per_middle
            ,name = <<"中級命中藥">>
            ,baseid = 28
            ,icon = 28
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{hitrate,50}]
        }
    };
get(hitrate_max_per_high) ->
    {ok, #buff{
    		label = hitrate_max_per_high
            ,name = <<"高級命中藥">>
            ,baseid = 29
            ,icon = 29
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{hitrate,70}]
        }
    };
get(evasion_max_per_low) ->
    {ok, #buff{
    		label = evasion_max_per_low
            ,name = <<"初級躲閃藥">>
            ,baseid = 30
            ,icon = 30
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{evasion,30}]
        }
    };
get(evasion_max_per_middle) ->
    {ok, #buff{
    		label = evasion_max_per_middle
            ,name = <<"中級躲閃藥">>
            ,baseid = 31
            ,icon = 31
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{evasion,50}]
        }
    };
get(evasion_max_per_high) ->
    {ok, #buff{
    		label = evasion_max_per_high
            ,name = <<"高級躲閃藥">>
            ,baseid = 32
            ,icon = 32
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{evasion,70}]
        }
    };
get(resist_all_per_high) ->
    {ok, #buff{
    		label = resist_all_per_high
            ,name = <<"五行抗性藥">>
            ,baseid = 33
            ,icon = 33
            ,multi = 0
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = [{resist_wood_per,15},{resist_water_per,15},{resist_fire_per,15},{resist_earth_per,15},{resist_metal_per,15}]
        }
    };
get(guild_dmg_1) ->
    {ok, #buff{
    		label = guild_dmg_1
            ,name = <<"加攻擊">>
            ,baseid = 34
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,20}]
        }
    };
get(guild_dmg_2) ->
    {ok, #buff{
    		label = guild_dmg_2
            ,name = <<"加攻擊">>
            ,baseid = 35
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,40}]
        }
    };
get(guild_dmg_3) ->
    {ok, #buff{
    		label = guild_dmg_3
            ,name = <<"加攻擊">>
            ,baseid = 36
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,60}]
        }
    };
get(guild_dmg_4) ->
    {ok, #buff{
    		label = guild_dmg_4
            ,name = <<"加攻擊">>
            ,baseid = 37
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,80}]
        }
    };
get(guild_dmg_5) ->
    {ok, #buff{
    		label = guild_dmg_5
            ,name = <<"加攻擊">>
            ,baseid = 38
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,100}]
        }
    };
get(guild_dmg_6) ->
    {ok, #buff{
    		label = guild_dmg_6
            ,name = <<"加攻擊">>
            ,baseid = 39
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,120}]
        }
    };
get(guild_dmg_7) ->
    {ok, #buff{
    		label = guild_dmg_7
            ,name = <<"加攻擊">>
            ,baseid = 40
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,140}]
        }
    };
get(guild_dmg_8) ->
    {ok, #buff{
    		label = guild_dmg_8
            ,name = <<"加攻擊">>
            ,baseid = 41
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,160}]
        }
    };
get(guild_dmg_9) ->
    {ok, #buff{
    		label = guild_dmg_9
            ,name = <<"加攻擊">>
            ,baseid = 42
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,180}]
        }
    };
get(guild_dmg_10) ->
    {ok, #buff{
    		label = guild_dmg_10
            ,name = <<"加攻擊">>
            ,baseid = 43
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,200}]
        }
    };
get(guild_dmg_11) ->
    {ok, #buff{
    		label = guild_dmg_11
            ,name = <<"加攻擊">>
            ,baseid = 200
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,220}]
        }
    };
get(guild_dmg_12) ->
    {ok, #buff{
    		label = guild_dmg_12
            ,name = <<"加攻擊">>
            ,baseid = 201
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,240}]
        }
    };
get(guild_dmg_13) ->
    {ok, #buff{
    		label = guild_dmg_13
            ,name = <<"加攻擊">>
            ,baseid = 202
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,260}]
        }
    };
get(guild_dmg_14) ->
    {ok, #buff{
    		label = guild_dmg_14
            ,name = <<"加攻擊">>
            ,baseid = 203
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,280}]
        }
    };
get(guild_dmg_15) ->
    {ok, #buff{
    		label = guild_dmg_15
            ,name = <<"加攻擊">>
            ,baseid = 204
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,300}]
        }
    };
get(guild_dmg_16) ->
    {ok, #buff{
    		label = guild_dmg_16
            ,name = <<"加攻擊">>
            ,baseid = 205
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,320}]
        }
    };
get(guild_dmg_17) ->
    {ok, #buff{
    		label = guild_dmg_17
            ,name = <<"加攻擊">>
            ,baseid = 206
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,340}]
        }
    };
get(guild_dmg_18) ->
    {ok, #buff{
    		label = guild_dmg_18
            ,name = <<"加攻擊">>
            ,baseid = 207
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,360}]
        }
    };
get(guild_dmg_19) ->
    {ok, #buff{
    		label = guild_dmg_19
            ,name = <<"加攻擊">>
            ,baseid = 208
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,380}]
        }
    };
get(guild_dmg_20) ->
    {ok, #buff{
    		label = guild_dmg_20
            ,name = <<"加攻擊">>
            ,baseid = 209
            ,icon = 34
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{dmg,400}]
        }
    };
get(guild_hp_1) ->
    {ok, #buff{
    		label = guild_hp_1
            ,name = <<"加氣血">>
            ,baseid = 44
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,200}]
        }
    };
get(guild_hp_2) ->
    {ok, #buff{
    		label = guild_hp_2
            ,name = <<"加氣血">>
            ,baseid = 45
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,300}]
        }
    };
get(guild_hp_3) ->
    {ok, #buff{
    		label = guild_hp_3
            ,name = <<"加氣血">>
            ,baseid = 46
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,400}]
        }
    };
get(guild_hp_4) ->
    {ok, #buff{
    		label = guild_hp_4
            ,name = <<"加氣血">>
            ,baseid = 47
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,500}]
        }
    };
get(guild_hp_5) ->
    {ok, #buff{
    		label = guild_hp_5
            ,name = <<"加氣血">>
            ,baseid = 48
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,600}]
        }
    };
get(guild_hp_6) ->
    {ok, #buff{
    		label = guild_hp_6
            ,name = <<"加氣血">>
            ,baseid = 49
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,700}]
        }
    };
get(guild_hp_7) ->
    {ok, #buff{
    		label = guild_hp_7
            ,name = <<"加氣血">>
            ,baseid = 50
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,800}]
        }
    };
get(guild_hp_8) ->
    {ok, #buff{
    		label = guild_hp_8
            ,name = <<"加氣血">>
            ,baseid = 51
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,900}]
        }
    };
get(guild_hp_9) ->
    {ok, #buff{
    		label = guild_hp_9
            ,name = <<"加氣血">>
            ,baseid = 52
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1000}]
        }
    };
get(guild_hp_10) ->
    {ok, #buff{
    		label = guild_hp_10
            ,name = <<"加氣血">>
            ,baseid = 53
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1100}]
        }
    };
get(guild_hp_11) ->
    {ok, #buff{
    		label = guild_hp_11
            ,name = <<"加氣血">>
            ,baseid = 210
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1200}]
        }
    };
get(guild_hp_12) ->
    {ok, #buff{
    		label = guild_hp_12
            ,name = <<"加氣血">>
            ,baseid = 211
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1300}]
        }
    };
get(guild_hp_13) ->
    {ok, #buff{
    		label = guild_hp_13
            ,name = <<"加氣血">>
            ,baseid = 212
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1400}]
        }
    };
get(guild_hp_14) ->
    {ok, #buff{
    		label = guild_hp_14
            ,name = <<"加氣血">>
            ,baseid = 213
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1500}]
        }
    };
get(guild_hp_15) ->
    {ok, #buff{
    		label = guild_hp_15
            ,name = <<"加氣血">>
            ,baseid = 214
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1600}]
        }
    };
get(guild_hp_16) ->
    {ok, #buff{
    		label = guild_hp_16
            ,name = <<"加氣血">>
            ,baseid = 215
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1700}]
        }
    };
get(guild_hp_17) ->
    {ok, #buff{
    		label = guild_hp_17
            ,name = <<"加氣血">>
            ,baseid = 216
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1800}]
        }
    };
get(guild_hp_18) ->
    {ok, #buff{
    		label = guild_hp_18
            ,name = <<"加氣血">>
            ,baseid = 217
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,1900}]
        }
    };
get(guild_hp_19) ->
    {ok, #buff{
    		label = guild_hp_19
            ,name = <<"加氣血">>
            ,baseid = 218
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,2000}]
        }
    };
get(guild_hp_20) ->
    {ok, #buff{
    		label = guild_hp_20
            ,name = <<"加氣血">>
            ,baseid = 219
            ,icon = 35
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hp_max,2100}]
        }
    };
get(guild_df_1) ->
    {ok, #buff{
    		label = guild_df_1
            ,name = <<"加防禦">>
            ,baseid = 54
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,40}]
        }
    };
get(guild_df_2) ->
    {ok, #buff{
    		label = guild_df_2
            ,name = <<"加防禦">>
            ,baseid = 55
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,60}]
        }
    };
get(guild_df_3) ->
    {ok, #buff{
    		label = guild_df_3
            ,name = <<"加防禦">>
            ,baseid = 56
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,80}]
        }
    };
get(guild_df_4) ->
    {ok, #buff{
    		label = guild_df_4
            ,name = <<"加防禦">>
            ,baseid = 57
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,100}]
        }
    };
get(guild_df_5) ->
    {ok, #buff{
    		label = guild_df_5
            ,name = <<"加防禦">>
            ,baseid = 58
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,120}]
        }
    };
get(guild_df_6) ->
    {ok, #buff{
    		label = guild_df_6
            ,name = <<"加防禦">>
            ,baseid = 59
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,140}]
        }
    };
get(guild_df_7) ->
    {ok, #buff{
    		label = guild_df_7
            ,name = <<"加防禦">>
            ,baseid = 60
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,160}]
        }
    };
get(guild_df_8) ->
    {ok, #buff{
    		label = guild_df_8
            ,name = <<"加防禦">>
            ,baseid = 61
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,180}]
        }
    };
get(guild_df_9) ->
    {ok, #buff{
    		label = guild_df_9
            ,name = <<"加防禦">>
            ,baseid = 62
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,200}]
        }
    };
get(guild_df_10) ->
    {ok, #buff{
    		label = guild_df_10
            ,name = <<"加防禦">>
            ,baseid = 63
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,220}]
        }
    };
get(guild_df_11) ->
    {ok, #buff{
    		label = guild_df_11
            ,name = <<"加防禦">>
            ,baseid = 220
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,240}]
        }
    };
get(guild_df_12) ->
    {ok, #buff{
    		label = guild_df_12
            ,name = <<"加防禦">>
            ,baseid = 221
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,260}]
        }
    };
get(guild_df_13) ->
    {ok, #buff{
    		label = guild_df_13
            ,name = <<"加防禦">>
            ,baseid = 222
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,280}]
        }
    };
get(guild_df_14) ->
    {ok, #buff{
    		label = guild_df_14
            ,name = <<"加防禦">>
            ,baseid = 223
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,300}]
        }
    };
get(guild_df_15) ->
    {ok, #buff{
    		label = guild_df_15
            ,name = <<"加防禦">>
            ,baseid = 224
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,320}]
        }
    };
get(guild_df_16) ->
    {ok, #buff{
    		label = guild_df_16
            ,name = <<"加防禦">>
            ,baseid = 225
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,340}]
        }
    };
get(guild_df_17) ->
    {ok, #buff{
    		label = guild_df_17
            ,name = <<"加防禦">>
            ,baseid = 226
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,360}]
        }
    };
get(guild_df_18) ->
    {ok, #buff{
    		label = guild_df_18
            ,name = <<"加防禦">>
            ,baseid = 227
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,380}]
        }
    };
get(guild_df_19) ->
    {ok, #buff{
    		label = guild_df_19
            ,name = <<"加防禦">>
            ,baseid = 228
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,400}]
        }
    };
get(guild_df_20) ->
    {ok, #buff{
    		label = guild_df_20
            ,name = <<"加防禦">>
            ,baseid = 229
            ,icon = 36
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{defence,420}]
        }
    };
get(guild_hitrate_1) ->
    {ok, #buff{
    		label = guild_hitrate_1
            ,name = <<"加命中">>
            ,baseid = 64
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,5}]
        }
    };
get(guild_hitrate_2) ->
    {ok, #buff{
    		label = guild_hitrate_2
            ,name = <<"加命中">>
            ,baseid = 65
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,7}]
        }
    };
get(guild_hitrate_3) ->
    {ok, #buff{
    		label = guild_hitrate_3
            ,name = <<"加命中">>
            ,baseid = 66
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,9}]
        }
    };
get(guild_hitrate_4) ->
    {ok, #buff{
    		label = guild_hitrate_4
            ,name = <<"加命中">>
            ,baseid = 67
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,11}]
        }
    };
get(guild_hitrate_5) ->
    {ok, #buff{
    		label = guild_hitrate_5
            ,name = <<"加命中">>
            ,baseid = 68
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,13}]
        }
    };
get(guild_hitrate_6) ->
    {ok, #buff{
    		label = guild_hitrate_6
            ,name = <<"加命中">>
            ,baseid = 69
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,15}]
        }
    };
get(guild_hitrate_7) ->
    {ok, #buff{
    		label = guild_hitrate_7
            ,name = <<"加命中">>
            ,baseid = 70
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,17}]
        }
    };
get(guild_hitrate_8) ->
    {ok, #buff{
    		label = guild_hitrate_8
            ,name = <<"加命中">>
            ,baseid = 71
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,19}]
        }
    };
get(guild_hitrate_9) ->
    {ok, #buff{
    		label = guild_hitrate_9
            ,name = <<"加命中">>
            ,baseid = 72
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,21}]
        }
    };
get(guild_hitrate_10) ->
    {ok, #buff{
    		label = guild_hitrate_10
            ,name = <<"加命中">>
            ,baseid = 73
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,23}]
        }
    };
get(guild_hitrate_11) ->
    {ok, #buff{
    		label = guild_hitrate_11
            ,name = <<"加命中">>
            ,baseid = 230
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,26}]
        }
    };
get(guild_hitrate_12) ->
    {ok, #buff{
    		label = guild_hitrate_12
            ,name = <<"加命中">>
            ,baseid = 231
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,29}]
        }
    };
get(guild_hitrate_13) ->
    {ok, #buff{
    		label = guild_hitrate_13
            ,name = <<"加命中">>
            ,baseid = 232
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,32}]
        }
    };
get(guild_hitrate_14) ->
    {ok, #buff{
    		label = guild_hitrate_14
            ,name = <<"加命中">>
            ,baseid = 233
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,35}]
        }
    };
get(guild_hitrate_15) ->
    {ok, #buff{
    		label = guild_hitrate_15
            ,name = <<"加命中">>
            ,baseid = 234
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,38}]
        }
    };
get(guild_hitrate_16) ->
    {ok, #buff{
    		label = guild_hitrate_16
            ,name = <<"加命中">>
            ,baseid = 235
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,41}]
        }
    };
get(guild_hitrate_17) ->
    {ok, #buff{
    		label = guild_hitrate_17
            ,name = <<"加命中">>
            ,baseid = 236
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,44}]
        }
    };
get(guild_hitrate_18) ->
    {ok, #buff{
    		label = guild_hitrate_18
            ,name = <<"加命中">>
            ,baseid = 237
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,47}]
        }
    };
get(guild_hitrate_19) ->
    {ok, #buff{
    		label = guild_hitrate_19
            ,name = <<"加命中">>
            ,baseid = 238
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,50}]
        }
    };
get(guild_hitrate_20) ->
    {ok, #buff{
    		label = guild_hitrate_20
            ,name = <<"加命中">>
            ,baseid = 239
            ,icon = 37
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{hitrate,53}]
        }
    };
get(guild_evasion_1) ->
    {ok, #buff{
    		label = guild_evasion_1
            ,name = <<"加躲閃">>
            ,baseid = 74
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,5}]
        }
    };
get(guild_evasion_2) ->
    {ok, #buff{
    		label = guild_evasion_2
            ,name = <<"加躲閃">>
            ,baseid = 75
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,7}]
        }
    };
get(guild_evasion_3) ->
    {ok, #buff{
    		label = guild_evasion_3
            ,name = <<"加躲閃">>
            ,baseid = 76
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,9}]
        }
    };
get(guild_evasion_4) ->
    {ok, #buff{
    		label = guild_evasion_4
            ,name = <<"加躲閃">>
            ,baseid = 77
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,11}]
        }
    };
get(guild_evasion_5) ->
    {ok, #buff{
    		label = guild_evasion_5
            ,name = <<"加躲閃">>
            ,baseid = 78
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,13}]
        }
    };
get(guild_evasion_6) ->
    {ok, #buff{
    		label = guild_evasion_6
            ,name = <<"加躲閃">>
            ,baseid = 79
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,15}]
        }
    };
get(guild_evasion_7) ->
    {ok, #buff{
    		label = guild_evasion_7
            ,name = <<"加躲閃">>
            ,baseid = 80
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,17}]
        }
    };
get(guild_evasion_8) ->
    {ok, #buff{
    		label = guild_evasion_8
            ,name = <<"加躲閃">>
            ,baseid = 81
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,19}]
        }
    };
get(guild_evasion_9) ->
    {ok, #buff{
    		label = guild_evasion_9
            ,name = <<"加躲閃">>
            ,baseid = 82
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,21}]
        }
    };
get(guild_evasion_10) ->
    {ok, #buff{
    		label = guild_evasion_10
            ,name = <<"加躲閃">>
            ,baseid = 83
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,23}]
        }
    };
get(guild_evasion_11) ->
    {ok, #buff{
    		label = guild_evasion_11
            ,name = <<"加躲閃">>
            ,baseid = 240
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,26}]
        }
    };
get(guild_evasion_12) ->
    {ok, #buff{
    		label = guild_evasion_12
            ,name = <<"加躲閃">>
            ,baseid = 241
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,29}]
        }
    };
get(guild_evasion_13) ->
    {ok, #buff{
    		label = guild_evasion_13
            ,name = <<"加躲閃">>
            ,baseid = 242
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,32}]
        }
    };
get(guild_evasion_14) ->
    {ok, #buff{
    		label = guild_evasion_14
            ,name = <<"加躲閃">>
            ,baseid = 243
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,35}]
        }
    };
get(guild_evasion_15) ->
    {ok, #buff{
    		label = guild_evasion_15
            ,name = <<"加躲閃">>
            ,baseid = 244
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,38}]
        }
    };
get(guild_evasion_16) ->
    {ok, #buff{
    		label = guild_evasion_16
            ,name = <<"加躲閃">>
            ,baseid = 245
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,41}]
        }
    };
get(guild_evasion_17) ->
    {ok, #buff{
    		label = guild_evasion_17
            ,name = <<"加躲閃">>
            ,baseid = 246
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,44}]
        }
    };
get(guild_evasion_18) ->
    {ok, #buff{
    		label = guild_evasion_18
            ,name = <<"加躲閃">>
            ,baseid = 247
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,47}]
        }
    };
get(guild_evasion_19) ->
    {ok, #buff{
    		label = guild_evasion_19
            ,name = <<"加躲閃">>
            ,baseid = 248
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,50}]
        }
    };
get(guild_evasion_20) ->
    {ok, #buff{
    		label = guild_evasion_20
            ,name = <<"加躲閃">>
            ,baseid = 249
            ,icon = 38
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{evasion,53}]
        }
    };
get(guild_critrate_1) ->
    {ok, #buff{
    		label = guild_critrate_1
            ,name = <<"加暴擊">>
            ,baseid = 84
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,5}]
        }
    };
get(guild_critrate_2) ->
    {ok, #buff{
    		label = guild_critrate_2
            ,name = <<"加暴擊">>
            ,baseid = 85
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,7}]
        }
    };
get(guild_critrate_3) ->
    {ok, #buff{
    		label = guild_critrate_3
            ,name = <<"加暴擊">>
            ,baseid = 86
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,9}]
        }
    };
get(guild_critrate_4) ->
    {ok, #buff{
    		label = guild_critrate_4
            ,name = <<"加暴擊">>
            ,baseid = 87
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,11}]
        }
    };
get(guild_critrate_5) ->
    {ok, #buff{
    		label = guild_critrate_5
            ,name = <<"加暴擊">>
            ,baseid = 88
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,13}]
        }
    };
get(guild_critrate_6) ->
    {ok, #buff{
    		label = guild_critrate_6
            ,name = <<"加暴擊">>
            ,baseid = 89
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,15}]
        }
    };
get(guild_critrate_7) ->
    {ok, #buff{
    		label = guild_critrate_7
            ,name = <<"加暴擊">>
            ,baseid = 90
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,17}]
        }
    };
get(guild_critrate_8) ->
    {ok, #buff{
    		label = guild_critrate_8
            ,name = <<"加暴擊">>
            ,baseid = 91
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,19}]
        }
    };
get(guild_critrate_9) ->
    {ok, #buff{
    		label = guild_critrate_9
            ,name = <<"加暴擊">>
            ,baseid = 92
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,21}]
        }
    };
get(guild_critrate_10) ->
    {ok, #buff{
    		label = guild_critrate_10
            ,name = <<"加暴擊">>
            ,baseid = 93
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,23}]
        }
    };
get(guild_critrate_11) ->
    {ok, #buff{
    		label = guild_critrate_11
            ,name = <<"加暴擊">>
            ,baseid = 250
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,26}]
        }
    };
get(guild_critrate_12) ->
    {ok, #buff{
    		label = guild_critrate_12
            ,name = <<"加暴擊">>
            ,baseid = 251
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,29}]
        }
    };
get(guild_critrate_13) ->
    {ok, #buff{
    		label = guild_critrate_13
            ,name = <<"加暴擊">>
            ,baseid = 252
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,32}]
        }
    };
get(guild_critrate_14) ->
    {ok, #buff{
    		label = guild_critrate_14
            ,name = <<"加暴擊">>
            ,baseid = 253
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,35}]
        }
    };
get(guild_critrate_15) ->
    {ok, #buff{
    		label = guild_critrate_15
            ,name = <<"加暴擊">>
            ,baseid = 254
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,38}]
        }
    };
get(guild_critrate_16) ->
    {ok, #buff{
    		label = guild_critrate_16
            ,name = <<"加暴擊">>
            ,baseid = 255
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,41}]
        }
    };
get(guild_critrate_17) ->
    {ok, #buff{
    		label = guild_critrate_17
            ,name = <<"加暴擊">>
            ,baseid = 256
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,44}]
        }
    };
get(guild_critrate_18) ->
    {ok, #buff{
    		label = guild_critrate_18
            ,name = <<"加暴擊">>
            ,baseid = 257
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,47}]
        }
    };
get(guild_critrate_19) ->
    {ok, #buff{
    		label = guild_critrate_19
            ,name = <<"加暴擊">>
            ,baseid = 258
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,50}]
        }
    };
get(guild_critrate_20) ->
    {ok, #buff{
    		label = guild_critrate_20
            ,name = <<"加暴擊">>
            ,baseid = 259
            ,icon = 39
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{critrate,53}]
        }
    };
get(guild_tenacity_1) ->
    {ok, #buff{
    		label = guild_tenacity_1
            ,name = <<"加堅韌">>
            ,baseid = 94
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,5}]
        }
    };
get(guild_tenacity_2) ->
    {ok, #buff{
    		label = guild_tenacity_2
            ,name = <<"加堅韌">>
            ,baseid = 95
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,7}]
        }
    };
get(guild_tenacity_3) ->
    {ok, #buff{
    		label = guild_tenacity_3
            ,name = <<"加堅韌">>
            ,baseid = 96
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,9}]
        }
    };
get(guild_tenacity_4) ->
    {ok, #buff{
    		label = guild_tenacity_4
            ,name = <<"加堅韌">>
            ,baseid = 97
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,11}]
        }
    };
get(guild_tenacity_5) ->
    {ok, #buff{
    		label = guild_tenacity_5
            ,name = <<"加堅韌">>
            ,baseid = 98
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,13}]
        }
    };
get(guild_tenacity_6) ->
    {ok, #buff{
    		label = guild_tenacity_6
            ,name = <<"加堅韌">>
            ,baseid = 99
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,15}]
        }
    };
get(guild_tenacity_7) ->
    {ok, #buff{
    		label = guild_tenacity_7
            ,name = <<"加堅韌">>
            ,baseid = 100
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,17}]
        }
    };
get(guild_tenacity_8) ->
    {ok, #buff{
    		label = guild_tenacity_8
            ,name = <<"加堅韌">>
            ,baseid = 101
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,19}]
        }
    };
get(guild_tenacity_9) ->
    {ok, #buff{
    		label = guild_tenacity_9
            ,name = <<"加堅韌">>
            ,baseid = 102
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,21}]
        }
    };
get(guild_tenacity_10) ->
    {ok, #buff{
    		label = guild_tenacity_10
            ,name = <<"加堅韌">>
            ,baseid = 103
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,23}]
        }
    };
get(guild_tenacity_11) ->
    {ok, #buff{
    		label = guild_tenacity_11
            ,name = <<"加堅韌">>
            ,baseid = 260
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,26}]
        }
    };
get(guild_tenacity_12) ->
    {ok, #buff{
    		label = guild_tenacity_12
            ,name = <<"加堅韌">>
            ,baseid = 261
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,29}]
        }
    };
get(guild_tenacity_13) ->
    {ok, #buff{
    		label = guild_tenacity_13
            ,name = <<"加堅韌">>
            ,baseid = 262
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,32}]
        }
    };
get(guild_tenacity_14) ->
    {ok, #buff{
    		label = guild_tenacity_14
            ,name = <<"加堅韌">>
            ,baseid = 263
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,35}]
        }
    };
get(guild_tenacity_15) ->
    {ok, #buff{
    		label = guild_tenacity_15
            ,name = <<"加堅韌">>
            ,baseid = 264
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,38}]
        }
    };
get(guild_tenacity_16) ->
    {ok, #buff{
    		label = guild_tenacity_16
            ,name = <<"加堅韌">>
            ,baseid = 265
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,41}]
        }
    };
get(guild_tenacity_17) ->
    {ok, #buff{
    		label = guild_tenacity_17
            ,name = <<"加堅韌">>
            ,baseid = 266
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,44}]
        }
    };
get(guild_tenacity_18) ->
    {ok, #buff{
    		label = guild_tenacity_18
            ,name = <<"加堅韌">>
            ,baseid = 267
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,47}]
        }
    };
get(guild_tenacity_19) ->
    {ok, #buff{
    		label = guild_tenacity_19
            ,name = <<"加堅韌">>
            ,baseid = 268
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,50}]
        }
    };
get(guild_tenacity_20) ->
    {ok, #buff{
    		label = guild_tenacity_20
            ,name = <<"加堅韌">>
            ,baseid = 269
            ,icon = 40
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{tenacity,53}]
        }
    };
get(guild_anti_stun_1) ->
    {ok, #buff{
    		label = guild_anti_stun_1
            ,name = <<"抗眩暈">>
            ,baseid = 104
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,10}]
        }
    };
get(guild_anti_stun_2) ->
    {ok, #buff{
    		label = guild_anti_stun_2
            ,name = <<"抗眩暈">>
            ,baseid = 105
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,18}]
        }
    };
get(guild_anti_stun_3) ->
    {ok, #buff{
    		label = guild_anti_stun_3
            ,name = <<"抗眩暈">>
            ,baseid = 106
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,26}]
        }
    };
get(guild_anti_stun_4) ->
    {ok, #buff{
    		label = guild_anti_stun_4
            ,name = <<"抗眩暈">>
            ,baseid = 107
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,34}]
        }
    };
get(guild_anti_stun_5) ->
    {ok, #buff{
    		label = guild_anti_stun_5
            ,name = <<"抗眩暈">>
            ,baseid = 108
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,42}]
        }
    };
get(guild_anti_stun_6) ->
    {ok, #buff{
    		label = guild_anti_stun_6
            ,name = <<"抗眩暈">>
            ,baseid = 109
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,50}]
        }
    };
get(guild_anti_stun_7) ->
    {ok, #buff{
    		label = guild_anti_stun_7
            ,name = <<"抗眩暈">>
            ,baseid = 110
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,58}]
        }
    };
get(guild_anti_stun_8) ->
    {ok, #buff{
    		label = guild_anti_stun_8
            ,name = <<"抗眩暈">>
            ,baseid = 111
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,66}]
        }
    };
get(guild_anti_stun_9) ->
    {ok, #buff{
    		label = guild_anti_stun_9
            ,name = <<"抗眩暈">>
            ,baseid = 112
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,74}]
        }
    };
get(guild_anti_stun_10) ->
    {ok, #buff{
    		label = guild_anti_stun_10
            ,name = <<"抗眩暈">>
            ,baseid = 113
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,82}]
        }
    };
get(guild_anti_stun_11) ->
    {ok, #buff{
    		label = guild_anti_stun_11
            ,name = <<"抗眩暈">>
            ,baseid = 270
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,92}]
        }
    };
get(guild_anti_stun_12) ->
    {ok, #buff{
    		label = guild_anti_stun_12
            ,name = <<"抗眩暈">>
            ,baseid = 271
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,100}]
        }
    };
get(guild_anti_stun_13) ->
    {ok, #buff{
    		label = guild_anti_stun_13
            ,name = <<"抗眩暈">>
            ,baseid = 272
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,110}]
        }
    };
get(guild_anti_stun_14) ->
    {ok, #buff{
    		label = guild_anti_stun_14
            ,name = <<"抗眩暈">>
            ,baseid = 273
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,120}]
        }
    };
get(guild_anti_stun_15) ->
    {ok, #buff{
    		label = guild_anti_stun_15
            ,name = <<"抗眩暈">>
            ,baseid = 274
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,130}]
        }
    };
get(guild_anti_stun_16) ->
    {ok, #buff{
    		label = guild_anti_stun_16
            ,name = <<"抗眩暈">>
            ,baseid = 275
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,140}]
        }
    };
get(guild_anti_stun_17) ->
    {ok, #buff{
    		label = guild_anti_stun_17
            ,name = <<"抗眩暈">>
            ,baseid = 276
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,150}]
        }
    };
get(guild_anti_stun_18) ->
    {ok, #buff{
    		label = guild_anti_stun_18
            ,name = <<"抗眩暈">>
            ,baseid = 277
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,160}]
        }
    };
get(guild_anti_stun_19) ->
    {ok, #buff{
    		label = guild_anti_stun_19
            ,name = <<"抗眩暈">>
            ,baseid = 278
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,170}]
        }
    };
get(guild_anti_stun_20) ->
    {ok, #buff{
    		label = guild_anti_stun_20
            ,name = <<"抗眩暈">>
            ,baseid = 279
            ,icon = 41
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stun,180}]
        }
    };
get(guild_anti_sleep_1) ->
    {ok, #buff{
    		label = guild_anti_sleep_1
            ,name = <<"抗睡眠">>
            ,baseid = 114
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,10}]
        }
    };
get(guild_anti_sleep_2) ->
    {ok, #buff{
    		label = guild_anti_sleep_2
            ,name = <<"抗睡眠">>
            ,baseid = 115
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,18}]
        }
    };
get(guild_anti_sleep_3) ->
    {ok, #buff{
    		label = guild_anti_sleep_3
            ,name = <<"抗睡眠">>
            ,baseid = 116
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,26}]
        }
    };
get(guild_anti_sleep_4) ->
    {ok, #buff{
    		label = guild_anti_sleep_4
            ,name = <<"抗睡眠">>
            ,baseid = 117
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,34}]
        }
    };
get(guild_anti_sleep_5) ->
    {ok, #buff{
    		label = guild_anti_sleep_5
            ,name = <<"抗睡眠">>
            ,baseid = 118
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,42}]
        }
    };
get(guild_anti_sleep_6) ->
    {ok, #buff{
    		label = guild_anti_sleep_6
            ,name = <<"抗睡眠">>
            ,baseid = 119
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,50}]
        }
    };
get(guild_anti_sleep_7) ->
    {ok, #buff{
    		label = guild_anti_sleep_7
            ,name = <<"抗睡眠">>
            ,baseid = 120
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,58}]
        }
    };
get(guild_anti_sleep_8) ->
    {ok, #buff{
    		label = guild_anti_sleep_8
            ,name = <<"抗睡眠">>
            ,baseid = 121
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,66}]
        }
    };
get(guild_anti_sleep_9) ->
    {ok, #buff{
    		label = guild_anti_sleep_9
            ,name = <<"抗睡眠">>
            ,baseid = 122
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,74}]
        }
    };
get(guild_anti_sleep_10) ->
    {ok, #buff{
    		label = guild_anti_sleep_10
            ,name = <<"抗睡眠">>
            ,baseid = 123
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,82}]
        }
    };
get(guild_anti_sleep_11) ->
    {ok, #buff{
    		label = guild_anti_sleep_11
            ,name = <<"抗睡眠">>
            ,baseid = 280
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,92}]
        }
    };
get(guild_anti_sleep_12) ->
    {ok, #buff{
    		label = guild_anti_sleep_12
            ,name = <<"抗睡眠">>
            ,baseid = 281
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,100}]
        }
    };
get(guild_anti_sleep_13) ->
    {ok, #buff{
    		label = guild_anti_sleep_13
            ,name = <<"抗睡眠">>
            ,baseid = 282
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,110}]
        }
    };
get(guild_anti_sleep_14) ->
    {ok, #buff{
    		label = guild_anti_sleep_14
            ,name = <<"抗睡眠">>
            ,baseid = 283
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,120}]
        }
    };
get(guild_anti_sleep_15) ->
    {ok, #buff{
    		label = guild_anti_sleep_15
            ,name = <<"抗睡眠">>
            ,baseid = 284
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,130}]
        }
    };
get(guild_anti_sleep_16) ->
    {ok, #buff{
    		label = guild_anti_sleep_16
            ,name = <<"抗睡眠">>
            ,baseid = 285
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,140}]
        }
    };
get(guild_anti_sleep_17) ->
    {ok, #buff{
    		label = guild_anti_sleep_17
            ,name = <<"抗睡眠">>
            ,baseid = 286
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,150}]
        }
    };
get(guild_anti_sleep_18) ->
    {ok, #buff{
    		label = guild_anti_sleep_18
            ,name = <<"抗睡眠">>
            ,baseid = 287
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,160}]
        }
    };
get(guild_anti_sleep_19) ->
    {ok, #buff{
    		label = guild_anti_sleep_19
            ,name = <<"抗睡眠">>
            ,baseid = 288
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,170}]
        }
    };
get(guild_anti_sleep_20) ->
    {ok, #buff{
    		label = guild_anti_sleep_20
            ,name = <<"抗睡眠">>
            ,baseid = 289
            ,icon = 42
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_sleep,180}]
        }
    };
get(guild_anti_silent_1) ->
    {ok, #buff{
    		label = guild_anti_silent_1
            ,name = <<"抗沉默">>
            ,baseid = 124
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,10}]
        }
    };
get(guild_anti_silent_2) ->
    {ok, #buff{
    		label = guild_anti_silent_2
            ,name = <<"抗沉默">>
            ,baseid = 125
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,18}]
        }
    };
get(guild_anti_silent_3) ->
    {ok, #buff{
    		label = guild_anti_silent_3
            ,name = <<"抗沉默">>
            ,baseid = 126
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,26}]
        }
    };
get(guild_anti_silent_4) ->
    {ok, #buff{
    		label = guild_anti_silent_4
            ,name = <<"抗沉默">>
            ,baseid = 127
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,34}]
        }
    };
get(guild_anti_silent_5) ->
    {ok, #buff{
    		label = guild_anti_silent_5
            ,name = <<"抗沉默">>
            ,baseid = 128
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,42}]
        }
    };
get(guild_anti_silent_6) ->
    {ok, #buff{
    		label = guild_anti_silent_6
            ,name = <<"抗沉默">>
            ,baseid = 129
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,50}]
        }
    };
get(guild_anti_silent_7) ->
    {ok, #buff{
    		label = guild_anti_silent_7
            ,name = <<"抗沉默">>
            ,baseid = 130
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,58}]
        }
    };
get(guild_anti_silent_8) ->
    {ok, #buff{
    		label = guild_anti_silent_8
            ,name = <<"抗沉默">>
            ,baseid = 131
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,66}]
        }
    };
get(guild_anti_silent_9) ->
    {ok, #buff{
    		label = guild_anti_silent_9
            ,name = <<"抗沉默">>
            ,baseid = 132
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,74}]
        }
    };
get(guild_anti_silent_10) ->
    {ok, #buff{
    		label = guild_anti_silent_10
            ,name = <<"抗沉默">>
            ,baseid = 133
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,82}]
        }
    };
get(guild_anti_silent_11) ->
    {ok, #buff{
    		label = guild_anti_silent_11
            ,name = <<"抗沉默">>
            ,baseid = 290
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,92}]
        }
    };
get(guild_anti_silent_12) ->
    {ok, #buff{
    		label = guild_anti_silent_12
            ,name = <<"抗沉默">>
            ,baseid = 291
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,100}]
        }
    };
get(guild_anti_silent_13) ->
    {ok, #buff{
    		label = guild_anti_silent_13
            ,name = <<"抗沉默">>
            ,baseid = 292
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,110}]
        }
    };
get(guild_anti_silent_14) ->
    {ok, #buff{
    		label = guild_anti_silent_14
            ,name = <<"抗沉默">>
            ,baseid = 293
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,120}]
        }
    };
get(guild_anti_silent_15) ->
    {ok, #buff{
    		label = guild_anti_silent_15
            ,name = <<"抗沉默">>
            ,baseid = 294
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,130}]
        }
    };
get(guild_anti_silent_16) ->
    {ok, #buff{
    		label = guild_anti_silent_16
            ,name = <<"抗沉默">>
            ,baseid = 295
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,140}]
        }
    };
get(guild_anti_silent_17) ->
    {ok, #buff{
    		label = guild_anti_silent_17
            ,name = <<"抗沉默">>
            ,baseid = 296
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,150}]
        }
    };
get(guild_anti_silent_18) ->
    {ok, #buff{
    		label = guild_anti_silent_18
            ,name = <<"抗沉默">>
            ,baseid = 297
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,160}]
        }
    };
get(guild_anti_silent_19) ->
    {ok, #buff{
    		label = guild_anti_silent_19
            ,name = <<"抗沉默">>
            ,baseid = 298
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,170}]
        }
    };
get(guild_anti_silent_20) ->
    {ok, #buff{
    		label = guild_anti_silent_20
            ,name = <<"抗沉默">>
            ,baseid = 299
            ,icon = 43
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_silent,180}]
        }
    };
get(guild_anti_stone_1) ->
    {ok, #buff{
    		label = guild_anti_stone_1
            ,name = <<"抗石化">>
            ,baseid = 134
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,10}]
        }
    };
get(guild_anti_stone_2) ->
    {ok, #buff{
    		label = guild_anti_stone_2
            ,name = <<"抗石化">>
            ,baseid = 135
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,18}]
        }
    };
get(guild_anti_stone_3) ->
    {ok, #buff{
    		label = guild_anti_stone_3
            ,name = <<"抗石化">>
            ,baseid = 136
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,26}]
        }
    };
get(guild_anti_stone_4) ->
    {ok, #buff{
    		label = guild_anti_stone_4
            ,name = <<"抗石化">>
            ,baseid = 137
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,34}]
        }
    };
get(guild_anti_stone_5) ->
    {ok, #buff{
    		label = guild_anti_stone_5
            ,name = <<"抗石化">>
            ,baseid = 138
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,42}]
        }
    };
get(guild_anti_stone_6) ->
    {ok, #buff{
    		label = guild_anti_stone_6
            ,name = <<"抗石化">>
            ,baseid = 139
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,50}]
        }
    };
get(guild_anti_stone_7) ->
    {ok, #buff{
    		label = guild_anti_stone_7
            ,name = <<"抗石化">>
            ,baseid = 140
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,58}]
        }
    };
get(guild_anti_stone_8) ->
    {ok, #buff{
    		label = guild_anti_stone_8
            ,name = <<"抗石化">>
            ,baseid = 141
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,66}]
        }
    };
get(guild_anti_stone_9) ->
    {ok, #buff{
    		label = guild_anti_stone_9
            ,name = <<"抗石化">>
            ,baseid = 142
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,74}]
        }
    };
get(guild_anti_stone_10) ->
    {ok, #buff{
    		label = guild_anti_stone_10
            ,name = <<"抗石化">>
            ,baseid = 143
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,82}]
        }
    };
get(guild_anti_stone_11) ->
    {ok, #buff{
    		label = guild_anti_stone_11
            ,name = <<"抗石化">>
            ,baseid = 300
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,92}]
        }
    };
get(guild_anti_stone_12) ->
    {ok, #buff{
    		label = guild_anti_stone_12
            ,name = <<"抗石化">>
            ,baseid = 301
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,100}]
        }
    };
get(guild_anti_stone_13) ->
    {ok, #buff{
    		label = guild_anti_stone_13
            ,name = <<"抗石化">>
            ,baseid = 302
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,110}]
        }
    };
get(guild_anti_stone_14) ->
    {ok, #buff{
    		label = guild_anti_stone_14
            ,name = <<"抗石化">>
            ,baseid = 303
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,120}]
        }
    };
get(guild_anti_stone_15) ->
    {ok, #buff{
    		label = guild_anti_stone_15
            ,name = <<"抗石化">>
            ,baseid = 304
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,130}]
        }
    };
get(guild_anti_stone_16) ->
    {ok, #buff{
    		label = guild_anti_stone_16
            ,name = <<"抗石化">>
            ,baseid = 305
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,140}]
        }
    };
get(guild_anti_stone_17) ->
    {ok, #buff{
    		label = guild_anti_stone_17
            ,name = <<"抗石化">>
            ,baseid = 306
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,150}]
        }
    };
get(guild_anti_stone_18) ->
    {ok, #buff{
    		label = guild_anti_stone_18
            ,name = <<"抗石化">>
            ,baseid = 307
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,160}]
        }
    };
get(guild_anti_stone_19) ->
    {ok, #buff{
    		label = guild_anti_stone_19
            ,name = <<"抗石化">>
            ,baseid = 308
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,170}]
        }
    };
get(guild_anti_stone_20) ->
    {ok, #buff{
    		label = guild_anti_stone_20
            ,name = <<"抗石化">>
            ,baseid = 309
            ,icon = 44
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_stone,180}]
        }
    };
get(guild_anti_taunt_1) ->
    {ok, #buff{
    		label = guild_anti_taunt_1
            ,name = <<"抗嘲諷">>
            ,baseid = 144
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,10}]
        }
    };
get(guild_anti_taunt_2) ->
    {ok, #buff{
    		label = guild_anti_taunt_2
            ,name = <<"抗嘲諷">>
            ,baseid = 145
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,18}]
        }
    };
get(guild_anti_taunt_3) ->
    {ok, #buff{
    		label = guild_anti_taunt_3
            ,name = <<"抗嘲諷">>
            ,baseid = 146
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,26}]
        }
    };
get(guild_anti_taunt_4) ->
    {ok, #buff{
    		label = guild_anti_taunt_4
            ,name = <<"抗嘲諷">>
            ,baseid = 147
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,34}]
        }
    };
get(guild_anti_taunt_5) ->
    {ok, #buff{
    		label = guild_anti_taunt_5
            ,name = <<"抗嘲諷">>
            ,baseid = 148
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,42}]
        }
    };
get(guild_anti_taunt_6) ->
    {ok, #buff{
    		label = guild_anti_taunt_6
            ,name = <<"抗嘲諷">>
            ,baseid = 149
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,50}]
        }
    };
get(guild_anti_taunt_7) ->
    {ok, #buff{
    		label = guild_anti_taunt_7
            ,name = <<"抗嘲諷">>
            ,baseid = 150
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,58}]
        }
    };
get(guild_anti_taunt_8) ->
    {ok, #buff{
    		label = guild_anti_taunt_8
            ,name = <<"抗嘲諷">>
            ,baseid = 151
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,66}]
        }
    };
get(guild_anti_taunt_9) ->
    {ok, #buff{
    		label = guild_anti_taunt_9
            ,name = <<"抗嘲諷">>
            ,baseid = 152
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,74}]
        }
    };
get(guild_anti_taunt_10) ->
    {ok, #buff{
    		label = guild_anti_taunt_10
            ,name = <<"抗嘲諷">>
            ,baseid = 153
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,82}]
        }
    };
get(guild_anti_taunt_11) ->
    {ok, #buff{
    		label = guild_anti_taunt_11
            ,name = <<"抗嘲諷">>
            ,baseid = 310
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,92}]
        }
    };
get(guild_anti_taunt_12) ->
    {ok, #buff{
    		label = guild_anti_taunt_12
            ,name = <<"抗嘲諷">>
            ,baseid = 311
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,100}]
        }
    };
get(guild_anti_taunt_13) ->
    {ok, #buff{
    		label = guild_anti_taunt_13
            ,name = <<"抗嘲諷">>
            ,baseid = 312
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,110}]
        }
    };
get(guild_anti_taunt_14) ->
    {ok, #buff{
    		label = guild_anti_taunt_14
            ,name = <<"抗嘲諷">>
            ,baseid = 313
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,120}]
        }
    };
get(guild_anti_taunt_15) ->
    {ok, #buff{
    		label = guild_anti_taunt_15
            ,name = <<"抗嘲諷">>
            ,baseid = 314
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,130}]
        }
    };
get(guild_anti_taunt_16) ->
    {ok, #buff{
    		label = guild_anti_taunt_16
            ,name = <<"抗嘲諷">>
            ,baseid = 315
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,140}]
        }
    };
get(guild_anti_taunt_17) ->
    {ok, #buff{
    		label = guild_anti_taunt_17
            ,name = <<"抗嘲諷">>
            ,baseid = 316
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,150}]
        }
    };
get(guild_anti_taunt_18) ->
    {ok, #buff{
    		label = guild_anti_taunt_18
            ,name = <<"抗嘲諷">>
            ,baseid = 317
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,160}]
        }
    };
get(guild_anti_taunt_19) ->
    {ok, #buff{
    		label = guild_anti_taunt_19
            ,name = <<"抗嘲諷">>
            ,baseid = 318
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,170}]
        }
    };
get(guild_anti_taunt_20) ->
    {ok, #buff{
    		label = guild_anti_taunt_20
            ,name = <<"抗嘲諷">>
            ,baseid = 319
            ,icon = 45
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_taunt,180}]
        }
    };
get(guild_anti_seal_1) ->
    {ok, #buff{
    		label = guild_anti_seal_1
            ,name = <<"抗封印">>
            ,baseid = 154
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,10}]
        }
    };
get(guild_anti_seal_2) ->
    {ok, #buff{
    		label = guild_anti_seal_2
            ,name = <<"抗封印">>
            ,baseid = 155
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,18}]
        }
    };
get(guild_anti_seal_3) ->
    {ok, #buff{
    		label = guild_anti_seal_3
            ,name = <<"抗封印">>
            ,baseid = 156
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,26}]
        }
    };
get(guild_anti_seal_4) ->
    {ok, #buff{
    		label = guild_anti_seal_4
            ,name = <<"抗封印">>
            ,baseid = 157
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,34}]
        }
    };
get(guild_anti_seal_5) ->
    {ok, #buff{
    		label = guild_anti_seal_5
            ,name = <<"抗封印">>
            ,baseid = 158
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,42}]
        }
    };
get(guild_anti_seal_6) ->
    {ok, #buff{
    		label = guild_anti_seal_6
            ,name = <<"抗封印">>
            ,baseid = 159
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,50}]
        }
    };
get(guild_anti_seal_7) ->
    {ok, #buff{
    		label = guild_anti_seal_7
            ,name = <<"抗封印">>
            ,baseid = 160
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,58}]
        }
    };
get(guild_anti_seal_8) ->
    {ok, #buff{
    		label = guild_anti_seal_8
            ,name = <<"抗封印">>
            ,baseid = 161
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,66}]
        }
    };
get(guild_anti_seal_9) ->
    {ok, #buff{
    		label = guild_anti_seal_9
            ,name = <<"抗封印">>
            ,baseid = 162
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,74}]
        }
    };
get(guild_anti_seal_10) ->
    {ok, #buff{
    		label = guild_anti_seal_10
            ,name = <<"抗封印">>
            ,baseid = 163
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,82}]
        }
    };
get(guild_anti_seal_11) ->
    {ok, #buff{
    		label = guild_anti_seal_11
            ,name = <<"抗封印">>
            ,baseid = 320
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,92}]
        }
    };
get(guild_anti_seal_12) ->
    {ok, #buff{
    		label = guild_anti_seal_12
            ,name = <<"抗封印">>
            ,baseid = 321
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,100}]
        }
    };
get(guild_anti_seal_13) ->
    {ok, #buff{
    		label = guild_anti_seal_13
            ,name = <<"抗封印">>
            ,baseid = 322
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,110}]
        }
    };
get(guild_anti_seal_14) ->
    {ok, #buff{
    		label = guild_anti_seal_14
            ,name = <<"抗封印">>
            ,baseid = 323
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,120}]
        }
    };
get(guild_anti_seal_15) ->
    {ok, #buff{
    		label = guild_anti_seal_15
            ,name = <<"抗封印">>
            ,baseid = 324
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,130}]
        }
    };
get(guild_anti_seal_16) ->
    {ok, #buff{
    		label = guild_anti_seal_16
            ,name = <<"抗封印">>
            ,baseid = 325
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,140}]
        }
    };
get(guild_anti_seal_17) ->
    {ok, #buff{
    		label = guild_anti_seal_17
            ,name = <<"抗封印">>
            ,baseid = 326
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,150}]
        }
    };
get(guild_anti_seal_18) ->
    {ok, #buff{
    		label = guild_anti_seal_18
            ,name = <<"抗封印">>
            ,baseid = 327
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,160}]
        }
    };
get(guild_anti_seal_19) ->
    {ok, #buff{
    		label = guild_anti_seal_19
            ,name = <<"抗封印">>
            ,baseid = 328
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,170}]
        }
    };
get(guild_anti_seal_20) ->
    {ok, #buff{
    		label = guild_anti_seal_20
            ,name = <<"抗封印">>
            ,baseid = 329
            ,icon = 46
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_seal,180}]
        }
    };
get(guild_anti_poison_1) ->
    {ok, #buff{
    		label = guild_anti_poison_1
            ,name = <<"抗毒">>
            ,baseid = 164
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,10}]
        }
    };
get(guild_anti_poison_2) ->
    {ok, #buff{
    		label = guild_anti_poison_2
            ,name = <<"抗毒">>
            ,baseid = 165
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,18}]
        }
    };
get(guild_anti_poison_3) ->
    {ok, #buff{
    		label = guild_anti_poison_3
            ,name = <<"抗毒">>
            ,baseid = 166
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,26}]
        }
    };
get(guild_anti_poison_4) ->
    {ok, #buff{
    		label = guild_anti_poison_4
            ,name = <<"抗毒">>
            ,baseid = 167
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,34}]
        }
    };
get(guild_anti_poison_5) ->
    {ok, #buff{
    		label = guild_anti_poison_5
            ,name = <<"抗毒">>
            ,baseid = 168
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,42}]
        }
    };
get(guild_anti_poison_6) ->
    {ok, #buff{
    		label = guild_anti_poison_6
            ,name = <<"抗毒">>
            ,baseid = 169
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,50}]
        }
    };
get(guild_anti_poison_7) ->
    {ok, #buff{
    		label = guild_anti_poison_7
            ,name = <<"抗毒">>
            ,baseid = 170
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,58}]
        }
    };
get(guild_anti_poison_8) ->
    {ok, #buff{
    		label = guild_anti_poison_8
            ,name = <<"抗毒">>
            ,baseid = 171
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,66}]
        }
    };
get(guild_anti_poison_9) ->
    {ok, #buff{
    		label = guild_anti_poison_9
            ,name = <<"抗毒">>
            ,baseid = 172
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,74}]
        }
    };
get(guild_anti_poison_10) ->
    {ok, #buff{
    		label = guild_anti_poison_10
            ,name = <<"抗毒">>
            ,baseid = 173
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,82}]
        }
    };
get(guild_anti_poison_11) ->
    {ok, #buff{
    		label = guild_anti_poison_11
            ,name = <<"抗毒">>
            ,baseid = 330
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,92}]
        }
    };
get(guild_anti_poison_12) ->
    {ok, #buff{
    		label = guild_anti_poison_12
            ,name = <<"抗毒">>
            ,baseid = 321
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,100}]
        }
    };
get(guild_anti_poison_13) ->
    {ok, #buff{
    		label = guild_anti_poison_13
            ,name = <<"抗毒">>
            ,baseid = 322
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,110}]
        }
    };
get(guild_anti_poison_14) ->
    {ok, #buff{
    		label = guild_anti_poison_14
            ,name = <<"抗毒">>
            ,baseid = 323
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,120}]
        }
    };
get(guild_anti_poison_15) ->
    {ok, #buff{
    		label = guild_anti_poison_15
            ,name = <<"抗毒">>
            ,baseid = 324
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,130}]
        }
    };
get(guild_anti_poison_16) ->
    {ok, #buff{
    		label = guild_anti_poison_16
            ,name = <<"抗毒">>
            ,baseid = 325
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,140}]
        }
    };
get(guild_anti_poison_17) ->
    {ok, #buff{
    		label = guild_anti_poison_17
            ,name = <<"抗毒">>
            ,baseid = 326
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,150}]
        }
    };
get(guild_anti_poison_18) ->
    {ok, #buff{
    		label = guild_anti_poison_18
            ,name = <<"抗毒">>
            ,baseid = 327
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,160}]
        }
    };
get(guild_anti_poison_19) ->
    {ok, #buff{
    		label = guild_anti_poison_19
            ,name = <<"抗毒">>
            ,baseid = 328
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,170}]
        }
    };
get(guild_anti_poison_20) ->
    {ok, #buff{
    		label = guild_anti_poison_20
            ,name = <<"抗毒">>
            ,baseid = 329
            ,icon = 47
            ,multi = 0
            ,type = 1
            ,cancel = 1
            ,end_date = 0
            ,duration = 86400
            ,msg = <<"">>
            ,effect = [{anti_poison,180}]
        }
    };
get(campaign_double_exp) ->
    {ok, #buff{
    		label = campaign_double_exp
            ,name = <<"經驗靈力大放送">>
            ,baseid = 174
            ,icon = 16
            ,multi = 0
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 7200
            ,msg = <<"">>
            ,effect = [{exp_time,100},{spirit_time,100}]
        }
    };
get(arena_encourage) ->
    {ok, #buff{
    		label = arena_encourage
            ,name = <<"鼓舞">>
            ,baseid = 175
            ,icon = 48
            ,multi = 0
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 120
            ,msg = <<"">>
            ,effect = [{dmg_per,20},{resist_wood_per,20},{resist_water_per,20},{resist_fire_per,20},{resist_earth_per,20},{resist_metal_per,20}]
        }
    };
get(vip_bless_2) ->
    {ok, #buff{
    		label = vip_bless_2
            ,name = <<"vip祝福">>
            ,baseid = 176
            ,icon = 22
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 7200
            ,msg = <<"">>
            ,effect = [{dmg,30},{defence,200},{hp_max,200},{resist_wood,70},{resist_water,70},{resist_fire,70},{resist_earth,70},{resist_metal,70}]
        }
    };
get(vip_bless_3) ->
    {ok, #buff{
    		label = vip_bless_3
            ,name = <<"vip祝福">>
            ,baseid = 177
            ,icon = 22
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 7200
            ,msg = <<"">>
            ,effect = [{dmg,20},{defence,100},{hp_max,100},{resist_wood,50},{resist_water,50},{resist_fire,50},{resist_earth,50},{resist_metal,50}]
        }
    };
get(sns_buff_lv1) ->
    {ok, #buff{
    		label = sns_buff_lv1
            ,name = <<"一面之交">>
            ,baseid = 178
            ,icon = 49
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{mp_max,300}]
        }
    };
get(sns_buff_lv2) ->
    {ok, #buff{
    		label = sns_buff_lv2
            ,name = <<"心腹之交">>
            ,baseid = 179
            ,icon = 50
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,300},{mp_max,300}]
        }
    };
get(sns_buff_lv3) ->
    {ok, #buff{
    		label = sns_buff_lv3
            ,name = <<"忘形之交">>
            ,baseid = 180
            ,icon = 51
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,300},{mp_max,300},{defence,300}]
        }
    };
get(sns_buff_lv4) ->
    {ok, #buff{
    		label = sns_buff_lv4
            ,name = <<"莫逆之交">>
            ,baseid = 181
            ,icon = 52
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,300},{mp_max,300},{defence,300},{resist_wood,150},{resist_water,150},{resist_fire,150},{resist_earth,150},{resist_metal,150}]
        }
    };
get(sns_buff_lv5) ->
    {ok, #buff{
    		label = sns_buff_lv5
            ,name = <<"生死之交">>
            ,baseid = 182
            ,icon = 53
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,300},{mp_max,300},{defence,300},{tenacity,100},{resist_wood,150},{resist_water,150},{resist_fire,150},{resist_earth,150},{resist_metal,150}]
        }
    };
get(sit_exp5_1) ->
    {ok, #buff{
    		label = sit_exp5_1
            ,name = <<"五倍修煉">>
            ,baseid = 183
            ,icon = 16
            ,multi = 3
            ,type = 2
            ,cancel = 0
            ,end_date = 0
            ,duration = 3600
            ,msg = <<"">>
            ,effect = [{sit_exp,500}, {sit_psychic, 500}]
        }
    };
get(sit_exp5_3) ->
    {ok, #buff{
    		label = sit_exp5_3
            ,name = <<"五倍修煉">>
            ,baseid = 184
            ,icon = 16
            ,multi = 3
            ,type = 2
            ,cancel = 0
            ,end_date = 0
            ,duration = 10800
            ,msg = <<"">>
            ,effect = [{sit_exp,500}, {sit_psychic, 500}]
        }
    };
get(wish_lucky) ->
    {ok, #buff{
    		label = wish_lucky
            ,name = <<"幸運泉水">>
            ,baseid = 185
            ,icon = 54
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = []
        }
    };
get(guild_war_winer) ->
    {ok, #buff{
    		label = guild_war_winer
            ,name = <<"聖戰王者">>
            ,baseid = 186
            ,icon = 55
            ,multi = 0
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max_per,5}]
        }
    };
get(double_drop) ->
    {ok, #buff{
    		label = double_drop
            ,name = <<"雙倍掉落">>
            ,baseid = 187
            ,icon = 56
            ,multi = 0
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 3600
            ,msg = <<"">>
            ,effect = [{exp_time,100},{spirit_time,100}]
        }
    };
get(fly_buff_1) ->
    {ok, #buff{
    		label = fly_buff_1
            ,name = <<"飛行">>
            ,baseid = 188
            ,icon = 57
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 120
            ,msg = <<"">>
            ,effect = []
        }
    };
get(fly_buff_2) ->
    {ok, #buff{
    		label = fly_buff_2
            ,name = <<"飛行">>
            ,baseid = 189
            ,icon = 57
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 240
            ,msg = <<"">>
            ,effect = []
        }
    };
get(super_boss_atk20) ->
    {ok, #buff{
    		label = super_boss_atk20
            ,name = <<"鼓舞">>
            ,baseid = 190
            ,icon = 58
            ,multi = 3
            ,type = 2
            ,cancel = 0
            ,end_date = 0
            ,duration = 1200
            ,msg = <<"">>
            ,effect = [{dmg_per,20}]
        }
    };
get(super_boss_atk40) ->
    {ok, #buff{
    		label = super_boss_atk40
            ,name = <<"鼓舞">>
            ,baseid = 191
            ,icon = 58
            ,multi = 3
            ,type = 2
            ,cancel = 0
            ,end_date = 0
            ,duration = 1200
            ,msg = <<"">>
            ,effect = [{dmg_per,40}]
        }
    };
get(super_boss_atk60) ->
    {ok, #buff{
    		label = super_boss_atk60
            ,name = <<"鼓舞">>
            ,baseid = 192
            ,icon = 58
            ,multi = 3
            ,type = 2
            ,cancel = 0
            ,end_date = 0
            ,duration = 1200
            ,msg = <<"">>
            ,effect = [{dmg_per,60}]
        }
    };
get(super_boss_atk80) ->
    {ok, #buff{
    		label = super_boss_atk80
            ,name = <<"鼓舞">>
            ,baseid = 193
            ,icon = 58
            ,multi = 3
            ,type = 2
            ,cancel = 0
            ,end_date = 0
            ,duration = 1200
            ,msg = <<"">>
            ,effect = [{dmg_per,80}]
        }
    };
get(super_boss_atk100) ->
    {ok, #buff{
    		label = super_boss_atk100
            ,name = <<"鼓舞">>
            ,baseid = 194
            ,icon = 58
            ,multi = 3
            ,type = 2
            ,cancel = 0
            ,end_date = 0
            ,duration = 1200
            ,msg = <<"">>
            ,effect = [{dmg_per,100}]
        }
    };
get(guard_honor) ->
    {ok, #buff{
    		label = guard_honor
            ,name = <<"洛水城主">>
            ,baseid = 195
            ,icon = 55
            ,multi = 0
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{defence_per,3}]
        }
    };
get(fly_buff_3) ->
    {ok, #buff{
    		label = fly_buff_3
            ,name = <<"飛行">>
            ,baseid = 196
            ,icon = 57
            ,multi = 3
            ,type = 1
            ,cancel = 0
            ,end_date = 0
            ,duration = 1800
            ,msg = <<"">>
            ,effect = []
        }
    };
get(master) ->
    {ok, #buff{
    		label = master
            ,name = <<"首席弟子">>
            ,baseid = 197
            ,icon = 59
            ,multi = 0
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{resist_wood,300},{resist_water,300},{resist_fire,300},{resist_earth,300},{resist_metal,300},{dmg,80},{hp_max,800}]
        }
    };
get(married_buff_1) ->
    {ok, #buff{
    		label = married_buff_1
            ,name = <<"情比金堅">>
            ,baseid = 400
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,50},{mp_max,20},{dmg,20},{defence,20}]
        }
    };
get(married_buff_2) ->
    {ok, #buff{
    		label = married_buff_2
            ,name = <<"情比金堅">>
            ,baseid = 401
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,100},{mp_max,30},{dmg,30},{defence,40}]
        }
    };
get(married_buff_3) ->
    {ok, #buff{
    		label = married_buff_3
            ,name = <<"情比金堅">>
            ,baseid = 402
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,200},{mp_max,50},{dmg,50},{defence,80}]
        }
    };
get(married_buff_4) ->
    {ok, #buff{
    		label = married_buff_4
            ,name = <<"情比金堅">>
            ,baseid = 403
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,300},{mp_max,80},{dmg,80},{defence,120}]
        }
    };
get(married_buff_5) ->
    {ok, #buff{
    		label = married_buff_5
            ,name = <<"情比金堅">>
            ,baseid = 404
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,400},{mp_max,100},{dmg,100},{defence,150},{tenacity,10}]
        }
    };
get(married_buff_6) ->
    {ok, #buff{
    		label = married_buff_6
            ,name = <<"情比金堅">>
            ,baseid = 405
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,600},{mp_max,150},{dmg,150},{defence,200},{tenacity,30}]
        }
    };
get(married_buff_7) ->
    {ok, #buff{
    		label = married_buff_7
            ,name = <<"情比金堅">>
            ,baseid = 406
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,900},{mp_max,200},{dmg,200},{defence,280},{tenacity,40},{resist_all,100}]
        }
    };
get(married_buff_8) ->
    {ok, #buff{
    		label = married_buff_8
            ,name = <<"情比金堅">>
            ,baseid = 407
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,1200},{mp_max,250},{dmg,250},{defence,400},{tenacity,60},{resist_all,200}]
        }
    };
get(married_buff_9) ->
    {ok, #buff{
    		label = married_buff_9
            ,name = <<"情比金堅">>
            ,baseid = 408
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,1500},{mp_max,300},{dmg,300},{defence,500},{tenacity,80},{resist_all,300}]
        }
    };
get(married_buff_10) ->
    {ok, #buff{
    		label = married_buff_10
            ,name = <<"情比金堅">>
            ,baseid = 409
            ,icon = 60
            ,multi = 3
            ,type = 0
            ,cancel = 0
            ,end_date = 0
            ,duration = -1
            ,msg = <<"">>
            ,effect = [{hp_max,2000},{mp_max,400},{dmg,400},{defence,700},{tenacity,100},{resist_all,500}]
        }
    };
get(_Code) ->
    {false, <<"不存在的BUFF">>}.

%% 人物变身BUFF外观ID
get_look_id(_label) -> null.

%% 坐骑变身BUFF外观ID
get_mount_look_id(_label) -> null.

