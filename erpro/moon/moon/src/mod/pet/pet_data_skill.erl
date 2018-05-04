
%%----------------------------------------------------
%% 宠物技能数据
%% @author wangweibiao
%%----------------------------------------------------
-module(pet_data_skill).
-export([
        get/1
		,get_all_lev_exp_by_step/1
    ]
).
-include("pet.hrl").

get_all_lev_exp_by_step(Step) ->
    case Step of 
        1 ->[0,4,8,16,32,64,128,256,512,1024];
        2 ->[0,8,16,32,64,128,256,512,1024,2048];
        3 ->[0,16,32,64,128,256,512,1024,2048,4096];
		_ ->[]
    end.

%% 宠物技能列表
get(100101) ->
    {ok, #pet_skill{
            id = 100101
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 100102
            ,script_id = 110000
            ,args = [5 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有5%<font color='#ffe100'>（下一级7%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100102) ->
    {ok, #pet_skill{
            id = 100102
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 100103
            ,script_id = 110000
            ,args = [7 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有7%<font color='#ffe100'>（下一级9%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100103) ->
    {ok, #pet_skill{
            id = 100103
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 100104
            ,script_id = 110000
            ,args = [9 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有9%<font color='#ffe100'>（下一级11%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100104) ->
    {ok, #pet_skill{
            id = 100104
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 100105
            ,script_id = 110000
            ,args = [11 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有11%<font color='#ffe100'>（下一级13%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100105) ->
    {ok, #pet_skill{
            id = 100105
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 100106
            ,script_id = 110000
            ,args = [13 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有13%<font color='#ffe100'>（下一级15%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100106) ->
    {ok, #pet_skill{
            id = 100106
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 100107
            ,script_id = 110000
            ,args = [15 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有15%<font color='#ffe100'>（下一级17%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100107) ->
    {ok, #pet_skill{
            id = 100107
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 100108
            ,script_id = 110000
            ,args = [17 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有17%<font color='#ffe100'>（下一级19%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100108) ->
    {ok, #pet_skill{
            id = 100108
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 100109
            ,script_id = 110000
            ,args = [19 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有19%<font color='#ffe100'>（下一级21%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100109) ->
    {ok, #pet_skill{
            id = 100109
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 100110
            ,script_id = 110000
            ,args = [21 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有21%<font color='#ffe100'>（下一级23%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100110) ->
    {ok, #pet_skill{
            id = 100110
            ,name = <<"低阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 110000
            ,args = [23 ]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有23%几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100201) ->
    {ok, #pet_skill{
            id = 100201
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 100202
            ,script_id = 110000
            ,args = [7]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有7%<font color='#ffe100'>（下一级10%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100202) ->
    {ok, #pet_skill{
            id = 100202
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 100203
            ,script_id = 110000
            ,args = [10]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有10%<font color='#ffe100'>（下一级13%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100203) ->
    {ok, #pet_skill{
            id = 100203
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 100204
            ,script_id = 110000
            ,args = [13]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有13%<font color='#ffe100'>（下一级16%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100204) ->
    {ok, #pet_skill{
            id = 100204
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 100205
            ,script_id = 110000
            ,args = [16]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有16%<font color='#ffe100'>（下一级19%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100205) ->
    {ok, #pet_skill{
            id = 100205
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 100206
            ,script_id = 110000
            ,args = [19]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有19%<font color='#ffe100'>（下一级22%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100206) ->
    {ok, #pet_skill{
            id = 100206
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 100207
            ,script_id = 110000
            ,args = [22]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有22%<font color='#ffe100'>（下一级25%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100207) ->
    {ok, #pet_skill{
            id = 100207
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 100208
            ,script_id = 110000
            ,args = [25]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有25%<font color='#ffe100'>（下一级28%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100208) ->
    {ok, #pet_skill{
            id = 100208
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 100209
            ,script_id = 110000
            ,args = [28]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有28%<font color='#ffe100'>（下一级31%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100209) ->
    {ok, #pet_skill{
            id = 100209
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 100210
            ,script_id = 110000
            ,args = [31]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有31%<font color='#ffe100'>（下一级34%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100210) ->
    {ok, #pet_skill{
            id = 100210
            ,name = <<"中阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 110000
            ,args = [34]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有34%<font color='#ffe100'>（下一级10%）</font>几率追加一次攻击">>
            ,n_args = []
        }
    };

get(100301) ->
    {ok, #pet_skill{
            id = 100301
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 100302
            ,script_id = 110000
            ,args = [10]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有10%几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100302) ->
    {ok, #pet_skill{
            id = 100302
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 100303
            ,script_id = 110000
            ,args = [15]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有15%<font color='#ffe100'>（下一级20%）</font>几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100303) ->
    {ok, #pet_skill{
            id = 100303
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 100304
            ,script_id = 110000
            ,args = [20]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%<font color='#ffe100'>（下一级25%）</font>几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100304) ->
    {ok, #pet_skill{
            id = 100304
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 100305
            ,script_id = 110000
            ,args = [25]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有25%<font color='#ffe100'>（下一级30%）</font>几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100305) ->
    {ok, #pet_skill{
            id = 100305
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 100306
            ,script_id = 110000
            ,args = [30]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有30%<font color='#ffe100'>（下一级35%）</font>几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100306) ->
    {ok, #pet_skill{
            id = 100306
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 100307
            ,script_id = 110000
            ,args = [35]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有35%<font color='#ffe100'>（下一级40%）</font>几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100307) ->
    {ok, #pet_skill{
            id = 100307
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 100308
            ,script_id = 110000
            ,args = [40]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有40%<font color='#ffe100'>（下一级45%）</font>几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100308) ->
    {ok, #pet_skill{
            id = 100308
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 100309
            ,script_id = 110000
            ,args = [45]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有45%<font color='#ffe100'>（下一级50%）</font>几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100309) ->
    {ok, #pet_skill{
            id = 100309
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 100310
            ,script_id = 110000
            ,args = [50]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有50%<font color='#ffe100'>（下一级55%）</font>几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(100310) ->
    {ok, #pet_skill{
            id = 100310
            ,name = <<"高阶连击">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 110000
            ,args = [55]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有55%几率追加一次攻击">>
            ,n_args = [{1, [3, 1]},{2, [6, 1]},{3, [9, 1]},{4, [12, 1]},{5, [15, 1]},{6, [18, 1]},{7, [21, 1]},{8, [24, 1]},{9, [27, 1]},{10, [30, 1]},{11, [33, 1]},{12, [36, 1]},{13, [39, 1]},{14, [42, 1]},{15, [45, 1]},{16, [48, 1]},{17, [51, 1]},{18, [54, 1]},{19, [57, 1]},{20, [60, 1]}]
        }
    };

get(110101) ->
    {ok, #pet_skill{
            id = 110101
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 110102
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,40]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加4%<font color='#ffe100'>（下一级5%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110102) ->
    {ok, #pet_skill{
            id = 110102
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 110103
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,50]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加5%<font color='#ffe100'>（下一级6%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110103) ->
    {ok, #pet_skill{
            id = 110103
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 110104
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,60]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加6%<font color='#ffe100'>（下一级7%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110104) ->
    {ok, #pet_skill{
            id = 110104
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 110105
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110105) ->
    {ok, #pet_skill{
            id = 110105
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 110106
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,80]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加8%<font color='#ffe100'>（下一级9%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110106) ->
    {ok, #pet_skill{
            id = 110106
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 110107
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加9%<font color='#ffe100'>（下一级10%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110107) ->
    {ok, #pet_skill{
            id = 110107
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 110108
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110108) ->
    {ok, #pet_skill{
            id = 110108
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 110109
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110109) ->
    {ok, #pet_skill{
            id = 110109
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 110110
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,120]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加12%<font color='#ffe100'>（下一级13%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110110) ->
    {ok, #pet_skill{
            id = 110110
            ,name = <<"低阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加13%暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110201) ->
    {ok, #pet_skill{
            id = 110201
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 110202
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,55]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加5.5%<font color='#ffe100'>（下一级7%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110202) ->
    {ok, #pet_skill{
            id = 110202
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 110203
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8.5%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110203) ->
    {ok, #pet_skill{
            id = 110203
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 110204
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,85]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加8.5%<font color='#ffe100'>（下一级10%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110204) ->
    {ok, #pet_skill{
            id = 110204
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 110205
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11.5%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110205) ->
    {ok, #pet_skill{
            id = 110205
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 110206
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,115]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加11.5%<font color='#ffe100'>（下一级13%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110206) ->
    {ok, #pet_skill{
            id = 110206
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 110207
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加13%<font color='#ffe100'>（下一级14.5%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110207) ->
    {ok, #pet_skill{
            id = 110207
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 110208
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,145]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加14.5%<font color='#ffe100'>（下一级16%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110208) ->
    {ok, #pet_skill{
            id = 110208
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 110209
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,160]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加16%<font color='#ffe100'>（下一级17.5%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110209) ->
    {ok, #pet_skill{
            id = 110209
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 110210
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,175]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加17.5%<font color='#ffe100'>（下一级19%）</font>暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110210) ->
    {ok, #pet_skill{
            id = 110210
            ,name = <<"中阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,190]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加19%暴怒（持续两个回合)">>
            ,n_args = []
        }
    };

get(110301) ->
    {ok, #pet_skill{
            id = 110301
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 110302
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加7%<font color='#ffe100'>（下一级9%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110302) ->
    {ok, #pet_skill{
            id = 110302
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 110303
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加9%<font color='#ffe100'>（下一级11%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110303) ->
    {ok, #pet_skill{
            id = 110303
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 110304
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加11%<font color='#ffe100'>（下一级13%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110304) ->
    {ok, #pet_skill{
            id = 110304
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 110305
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加13%<font color='#ffe100'>（下一级15%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110305) ->
    {ok, #pet_skill{
            id = 110305
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 110306
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,150]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加15%<font color='#ffe100'>（下一级17%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110306) ->
    {ok, #pet_skill{
            id = 110306
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 110307
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,170]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加17%<font color='#ffe100'>（下一级19%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110307) ->
    {ok, #pet_skill{
            id = 110307
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 110308
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,190]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加19%<font color='#ffe100'>（下一级21%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110308) ->
    {ok, #pet_skill{
            id = 110308
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 110309
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,210]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加21%<font color='#ffe100'>（下一级23%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110309) ->
    {ok, #pet_skill{
            id = 110309
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 110310
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,230]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加23%<font color='#ffe100'>（下一级25%）</font>暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(110310) ->
    {ok, #pet_skill{
            id = 110310
            ,name = <<"高阶暴怒光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101126,[100,2,1,250]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加25%暴怒（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120101) ->
    {ok, #pet_skill{
            id = 120101
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 120102
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,40]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加4%<font color='#ffe100'>（下一级5%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120102) ->
    {ok, #pet_skill{
            id = 120102
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 120103
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,50]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加5%<font color='#ffe100'>（下一级6%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120103) ->
    {ok, #pet_skill{
            id = 120103
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 120104
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,60]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加6%<font color='#ffe100'>（下一级7%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120104) ->
    {ok, #pet_skill{
            id = 120104
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 120105
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120105) ->
    {ok, #pet_skill{
            id = 120105
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 120106
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,80]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加8%<font color='#ffe100'>（下一级9%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120106) ->
    {ok, #pet_skill{
            id = 120106
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 120107
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加9%<font color='#ffe100'>（下一级10%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120107) ->
    {ok, #pet_skill{
            id = 120107
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 120108
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120108) ->
    {ok, #pet_skill{
            id = 120108
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 120109
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120109) ->
    {ok, #pet_skill{
            id = 120109
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 120110
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,120]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加12%<font color='#ffe100'>（下一级13%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120110) ->
    {ok, #pet_skill{
            id = 120110
            ,name = <<"低阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加13%精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120201) ->
    {ok, #pet_skill{
            id = 120201
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 120202
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,55]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加5.5%<font color='#ffe100'>（下一级7%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120202) ->
    {ok, #pet_skill{
            id = 120202
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 120203
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8.5%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120203) ->
    {ok, #pet_skill{
            id = 120203
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 120204
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,85]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加8.5%<font color='#ffe100'>（下一级10%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120204) ->
    {ok, #pet_skill{
            id = 120204
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 120205
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11.5%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120205) ->
    {ok, #pet_skill{
            id = 120205
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 120206
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,115]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加11.5%<font color='#ffe100'>（下一级13%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120206) ->
    {ok, #pet_skill{
            id = 120206
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 120207
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加13%<font color='#ffe100'>（下一级14.5%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120207) ->
    {ok, #pet_skill{
            id = 120207
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 120208
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,145]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加14.5%<font color='#ffe100'>（下一级16%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120208) ->
    {ok, #pet_skill{
            id = 120208
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 120209
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,160]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加16%<font color='#ffe100'>（下一级17.5%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120209) ->
    {ok, #pet_skill{
            id = 120209
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 120210
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,175]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加17.5%<font color='#ffe100'>（下一级19%）</font>精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120210) ->
    {ok, #pet_skill{
            id = 120210
            ,name = <<"中阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,190]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加19%精准（持续两个回合)">>
            ,n_args = []
        }
    };

get(120301) ->
    {ok, #pet_skill{
            id = 120301
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 120302
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加7%<font color='#ffe100'>（下一级9%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120302) ->
    {ok, #pet_skill{
            id = 120302
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 120303
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加9%<font color='#ffe100'>（下一级11%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120303) ->
    {ok, #pet_skill{
            id = 120303
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 120304
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加11%<font color='#ffe100'>（下一级13%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120304) ->
    {ok, #pet_skill{
            id = 120304
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 120305
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加13%<font color='#ffe100'>（下一级15%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120305) ->
    {ok, #pet_skill{
            id = 120305
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 120306
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,150]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加15%<font color='#ffe100'>（下一级17%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120306) ->
    {ok, #pet_skill{
            id = 120306
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 120307
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,170]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加17%<font color='#ffe100'>（下一级19%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120307) ->
    {ok, #pet_skill{
            id = 120307
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 120308
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,190]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加19%<font color='#ffe100'>（下一级21%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120308) ->
    {ok, #pet_skill{
            id = 120308
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 120309
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,210]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加21%<font color='#ffe100'>（下一级23%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120309) ->
    {ok, #pet_skill{
            id = 120309
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 120310
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,230]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加23%<font color='#ffe100'>（下一级25%）</font>精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(120310) ->
    {ok, #pet_skill{
            id = 120310
            ,name = <<"高阶精准光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101100,[100,2,1,250]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加25%精准（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130101) ->
    {ok, #pet_skill{
            id = 130101
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 130102
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,40]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加4%<font color='#ffe100'>（下一级5%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130102) ->
    {ok, #pet_skill{
            id = 130102
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 130103
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,50]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加5%<font color='#ffe100'>（下一级6%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130103) ->
    {ok, #pet_skill{
            id = 130103
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 130104
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,60]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加6%<font color='#ffe100'>（下一级7%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130104) ->
    {ok, #pet_skill{
            id = 130104
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 130105
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130105) ->
    {ok, #pet_skill{
            id = 130105
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 130106
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,80]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加8%<font color='#ffe100'>（下一级9%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130106) ->
    {ok, #pet_skill{
            id = 130106
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 130107
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加9%<font color='#ffe100'>（下一级10%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130107) ->
    {ok, #pet_skill{
            id = 130107
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 130108
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130108) ->
    {ok, #pet_skill{
            id = 130108
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 130109
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130109) ->
    {ok, #pet_skill{
            id = 130109
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 130110
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,120]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加12%<font color='#ffe100'>（下一级13%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130110) ->
    {ok, #pet_skill{
            id = 130110
            ,name = <<"低阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加13%格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130201) ->
    {ok, #pet_skill{
            id = 130201
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 130202
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,55]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加5.5%<font color='#ffe100'>（下一级7%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130202) ->
    {ok, #pet_skill{
            id = 130202
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 130203
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8.5%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130203) ->
    {ok, #pet_skill{
            id = 130203
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 130204
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,85]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加8.5%<font color='#ffe100'>（下一级10%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130204) ->
    {ok, #pet_skill{
            id = 130204
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 130205
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11.5%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130205) ->
    {ok, #pet_skill{
            id = 130205
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 130206
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,115]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加11.5%<font color='#ffe100'>（下一级13%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130206) ->
    {ok, #pet_skill{
            id = 130206
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 130207
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加13%<font color='#ffe100'>（下一级14.5%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130207) ->
    {ok, #pet_skill{
            id = 130207
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 130208
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,145]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加14.5%<font color='#ffe100'>（下一级16%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130208) ->
    {ok, #pet_skill{
            id = 130208
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 130209
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,160]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加16%<font color='#ffe100'>（下一级17.5%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130209) ->
    {ok, #pet_skill{
            id = 130209
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 130210
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,175]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加17.5%<font color='#ffe100'>（下一级19%）</font>格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130210) ->
    {ok, #pet_skill{
            id = 130210
            ,name = <<"中阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,190]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加19%格挡（持续两个回合)">>
            ,n_args = []
        }
    };

get(130301) ->
    {ok, #pet_skill{
            id = 130301
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 130302
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加7%<font color='#ffe100'>（下一级9%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130302) ->
    {ok, #pet_skill{
            id = 130302
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 130303
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加9%<font color='#ffe100'>（下一级11%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130303) ->
    {ok, #pet_skill{
            id = 130303
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 130304
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加11%<font color='#ffe100'>（下一级13%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130304) ->
    {ok, #pet_skill{
            id = 130304
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 130305
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加13%<font color='#ffe100'>（下一级15%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130305) ->
    {ok, #pet_skill{
            id = 130305
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 130306
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,150]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加15%<font color='#ffe100'>（下一级17%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130306) ->
    {ok, #pet_skill{
            id = 130306
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 130307
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,170]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加17%<font color='#ffe100'>（下一级19%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130307) ->
    {ok, #pet_skill{
            id = 130307
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 130308
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,190]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加19%<font color='#ffe100'>（下一级21%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130308) ->
    {ok, #pet_skill{
            id = 130308
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 130309
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,210]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加21%<font color='#ffe100'>（下一级23%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130309) ->
    {ok, #pet_skill{
            id = 130309
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 130310
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,230]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加23%<font color='#ffe100'>（下一级25%）</font>格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(130310) ->
    {ok, #pet_skill{
            id = 130310
            ,name = <<"高阶格挡光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101110,[100,2,1,250]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加25%格挡（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140101) ->
    {ok, #pet_skill{
            id = 140101
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 140102
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,40]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加4%<font color='#ffe100'>（下一级5%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140102) ->
    {ok, #pet_skill{
            id = 140102
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 140103
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,50]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加5%<font color='#ffe100'>（下一级6%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140103) ->
    {ok, #pet_skill{
            id = 140103
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 140104
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,60]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加6%<font color='#ffe100'>（下一级7%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140104) ->
    {ok, #pet_skill{
            id = 140104
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 140105
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140105) ->
    {ok, #pet_skill{
            id = 140105
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 140106
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,80]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加8%<font color='#ffe100'>（下一级9%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140106) ->
    {ok, #pet_skill{
            id = 140106
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 140107
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加9%<font color='#ffe100'>（下一级10%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140107) ->
    {ok, #pet_skill{
            id = 140107
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 140108
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140108) ->
    {ok, #pet_skill{
            id = 140108
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 140109
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140109) ->
    {ok, #pet_skill{
            id = 140109
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 140110
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,120]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加12%<font color='#ffe100'>（下一级13%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140110) ->
    {ok, #pet_skill{
            id = 140110
            ,name = <<"低阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加13%坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140201) ->
    {ok, #pet_skill{
            id = 140201
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 140202
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,55]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加5.5%<font color='#ffe100'>（下一级7%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140202) ->
    {ok, #pet_skill{
            id = 140202
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 140203
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8.5%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140203) ->
    {ok, #pet_skill{
            id = 140203
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 140204
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,85]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加8.5%<font color='#ffe100'>（下一级10%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140204) ->
    {ok, #pet_skill{
            id = 140204
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 140205
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11.5%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140205) ->
    {ok, #pet_skill{
            id = 140205
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 140206
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,115]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加11.5%<font color='#ffe100'>（下一级13%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140206) ->
    {ok, #pet_skill{
            id = 140206
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 140207
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加13%<font color='#ffe100'>（下一级14.5%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140207) ->
    {ok, #pet_skill{
            id = 140207
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 140208
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,145]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加14.5%<font color='#ffe100'>（下一级16%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140208) ->
    {ok, #pet_skill{
            id = 140208
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 140209
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,160]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加16%<font color='#ffe100'>（下一级17.5%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140209) ->
    {ok, #pet_skill{
            id = 140209
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 140210
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,175]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加17.5%<font color='#ffe100'>（下一级19%）</font>坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140210) ->
    {ok, #pet_skill{
            id = 140210
            ,name = <<"中阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,190]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加19%坚韧（持续两个回合)">>
            ,n_args = []
        }
    };

get(140301) ->
    {ok, #pet_skill{
            id = 140301
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 140302
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加7%<font color='#ffe100'>（下一级9%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140302) ->
    {ok, #pet_skill{
            id = 140302
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 140303
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加9%<font color='#ffe100'>（下一级11%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140303) ->
    {ok, #pet_skill{
            id = 140303
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 140304
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加11%<font color='#ffe100'>（下一级13%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140304) ->
    {ok, #pet_skill{
            id = 140304
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 140305
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加13%<font color='#ffe100'>（下一级15%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140305) ->
    {ok, #pet_skill{
            id = 140305
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 140306
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,150]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加15%<font color='#ffe100'>（下一级17%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140306) ->
    {ok, #pet_skill{
            id = 140306
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 140307
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,170]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加17%<font color='#ffe100'>（下一级19%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140307) ->
    {ok, #pet_skill{
            id = 140307
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 140308
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,190]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加19%<font color='#ffe100'>（下一级21%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140308) ->
    {ok, #pet_skill{
            id = 140308
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 140309
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,210]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加21%<font color='#ffe100'>（下一级23%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140309) ->
    {ok, #pet_skill{
            id = 140309
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 140310
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,230]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加23%<font color='#ffe100'>（下一级25%）</font>坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(140310) ->
    {ok, #pet_skill{
            id = 140310
            ,name = <<"高阶坚韧光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{101130,[100,2,1,250]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加25%坚韧（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(150101) ->
    {ok, #pet_skill{
            id = 150101
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,100}]
            ,exp = 2
            ,next_id = 150102
            ,script_id = 120000
            ,args = [33,800]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"33%<font color='#ffe100'>（下一级36%）</font>概率复活主人,复活后,主人拥有800<font color='#ffe100'>（下一级840)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150102) ->
    {ok, #pet_skill{
            id = 150102
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,120}]
            ,exp = 4
            ,next_id = 150103
            ,script_id = 120000
            ,args = [36,840]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"36%<font color='#ffe100'>（下一级39%）</font>概率复活主人,复活后,主人拥有840<font color='#ffe100'>（下一级880)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150103) ->
    {ok, #pet_skill{
            id = 150103
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,140}]
            ,exp = 8
            ,next_id = 150104
            ,script_id = 120000
            ,args = [39,880]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"39%<font color='#ffe100'>（下一级42%）</font>概率复活主人,复活后,主人拥有880<font color='#ffe100'>（下一级920)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合。">>
            ,n_args = []
        }
    };

get(150104) ->
    {ok, #pet_skill{
            id = 150104
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,160}]
            ,exp = 16
            ,next_id = 150105
            ,script_id = 120000
            ,args = [42,920]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"42%<font color='#ffe100'>（下一级45%）</font>概率复活主人,复活后,主人拥有920<font color='#ffe100'>（下一级960)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150105) ->
    {ok, #pet_skill{
            id = 150105
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,180}]
            ,exp = 32
            ,next_id = 150106
            ,script_id = 120000
            ,args = [45,960]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"45%<font color='#ffe100'>（下一级48%）</font>概率复活主人,复活后,主人拥有960<font color='#ffe100'>（下一级1000)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合。">>
            ,n_args = []
        }
    };

get(150106) ->
    {ok, #pet_skill{
            id = 150106
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,200}]
            ,exp = 64
            ,next_id = 150107
            ,script_id = 120000
            ,args = [48,1000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"48%<font color='#ffe100'>（下一级51%）</font>概率复活主人,复活后,主人拥有1000<font color='#ffe100'>（下一级1040)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150107) ->
    {ok, #pet_skill{
            id = 150107
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,220}]
            ,exp = 128
            ,next_id = 150108
            ,script_id = 120000
            ,args = [51,1040]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"51%<font color='#ffe100'>（下一级54%）</font>概率复活主人,复活后,主人拥有1040<font color='#ffe100'>（下一级1080)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150108) ->
    {ok, #pet_skill{
            id = 150108
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,250}]
            ,exp = 256
            ,next_id = 150109
            ,script_id = 120000
            ,args = [54,1080]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"54%<font color='#ffe100'>（下一级57%）</font>概率复活主人,复活后,主人拥有1080<font color='#ffe100'>（下一级1120)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合。">>
            ,n_args = []
        }
    };

get(150109) ->
    {ok, #pet_skill{
            id = 150109
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,280}]
            ,exp = 512
            ,next_id = 150110
            ,script_id = 120000
            ,args = [57,1120]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"57%<font color='#ffe100'>（下一级60%）</font>概率复活主人,复活后,主人拥有1120<font color='#ffe100'>（下一级1160)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150110) ->
    {ok, #pet_skill{
            id = 150110
            ,name = <<"低阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,300}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 120000
            ,args = [60,1160]
            ,buff_self = []
            ,buff_target = []
            ,cd = 10
            ,desc = <<"60%概率复活主人,复活后,主人拥有1160生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150201) ->
    {ok, #pet_skill{
            id = 150201
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,150}]
            ,exp = 4
            ,next_id = 150202
            ,script_id = 120000
            ,args = [44,1000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"44%<font color='#ffe100'>（下一级48%）</font>概率复活主人,复活后,主人拥有1000<font color='#ffe100'>（下一级1100)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150202) ->
    {ok, #pet_skill{
            id = 150202
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,180}]
            ,exp = 8
            ,next_id = 150203
            ,script_id = 120000
            ,args = [48,1100]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"48%<font color='#ffe100'>（下一级52%）</font>概率复活主人,复活后,主人拥有1100<font color='#ffe100'>（下一级1200)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150203) ->
    {ok, #pet_skill{
            id = 150203
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,210}]
            ,exp = 16
            ,next_id = 150204
            ,script_id = 120000
            ,args = [52,1200]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"52%<font color='#ffe100'>（下一级56%）</font>概率复活主人,复活后,主人拥有1200<font color='#ffe100'>（下一级1300)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150204) ->
    {ok, #pet_skill{
            id = 150204
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,240}]
            ,exp = 32
            ,next_id = 150205
            ,script_id = 120000
            ,args = [56,1300]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"56%<font color='#ffe100'>（下一级60%）</font>概率复活主人,复活后,主人拥有1300<font color='#ffe100'>（下一级1400)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150205) ->
    {ok, #pet_skill{
            id = 150205
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,270}]
            ,exp = 64
            ,next_id = 150206
            ,script_id = 120000
            ,args = [60,1400]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"60%<font color='#ffe100'>（下一级64%）</font>概率复活主人,复活后,主人拥有1400<font color='#ffe100'>（下一级1500)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150206) ->
    {ok, #pet_skill{
            id = 150206
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,300}]
            ,exp = 128
            ,next_id = 150207
            ,script_id = 120000
            ,args = [64,1500]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"64%<font color='#ffe100'>（下一级68%）</font>概率复活主人,复活后,主人拥有1500<font color='#ffe100'>（下一级1600)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150207) ->
    {ok, #pet_skill{
            id = 150207
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,330}]
            ,exp = 256
            ,next_id = 150208
            ,script_id = 120000
            ,args = [68,1600]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"68%<font color='#ffe100'>（下一级72%）</font>概率复活主人,复活后,主人拥有1600<font color='#ffe100'>（下一级1700)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150208) ->
    {ok, #pet_skill{
            id = 150208
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,360}]
            ,exp = 512
            ,next_id = 150209
            ,script_id = 120000
            ,args = [72,1700]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"72%<font color='#ffe100'>（下一级76%）</font>概率复活主人,复活后,主人拥有1700<font color='#ffe100'>（下一级1800)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150209) ->
    {ok, #pet_skill{
            id = 150209
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,380}]
            ,exp = 1024
            ,next_id = 150210
            ,script_id = 120000
            ,args = [76,1800]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"76%<font color='#ffe100'>（下一级80%）</font>概率复活主人,复活后,主人拥有1800<font color='#ffe100'>（下一级1900)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150210) ->
    {ok, #pet_skill{
            id = 150210
            ,name = <<"中阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,400}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 120000
            ,args = [80,1900]
            ,buff_self = []
            ,buff_target = []
            ,cd = 8
            ,desc = <<"80%概率复活主人,复活后,主人拥有1900生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = []
        }
    };

get(150301) ->
    {ok, #pet_skill{
            id = 150301
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,200}]
            ,exp = 8
            ,next_id = 150302
            ,script_id = 120000
            ,args = [55,1400]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"55%<font color='#ffe100'>（下一级60%）</font>概率复活主人,复活后,主人拥有1400<font color='#ffe100'>（下一级1600)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150302) ->
    {ok, #pet_skill{
            id = 150302
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,240}]
            ,exp = 16
            ,next_id = 150303
            ,script_id = 120000
            ,args = [60,1600]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"60%<font color='#ffe100'>（下一级65%）</font>概率复活主人,复活后,主人拥有1600<font color='#ffe100'>（下一级1800)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150303) ->
    {ok, #pet_skill{
            id = 150303
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,280}]
            ,exp = 32
            ,next_id = 150304
            ,script_id = 120000
            ,args = [65,1800]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"65%<font color='#ffe100'>（下一级70%）</font>概率复活主人,复活后,主人拥有1800<font color='#ffe100'>（下一级2000)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150304) ->
    {ok, #pet_skill{
            id = 150304
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,320}]
            ,exp = 64
            ,next_id = 150305
            ,script_id = 120000
            ,args = [70,2000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"70%<font color='#ffe100'>（下一级75%）</font>概率复活主人,复活后,主人拥有2000<font color='#ffe100'>（下一级2200)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150305) ->
    {ok, #pet_skill{
            id = 150305
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,360}]
            ,exp = 128
            ,next_id = 150306
            ,script_id = 120000
            ,args = [75,2200]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"75%<font color='#ffe100'>（下一级80%）</font>概率复活主人,复活后,主人拥有2200<font color='#ffe100'>（下一级2400)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150306) ->
    {ok, #pet_skill{
            id = 150306
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,400}]
            ,exp = 256
            ,next_id = 150307
            ,script_id = 120000
            ,args = [80,2400]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"80%<font color='#ffe100'>（下一级85%）</font>概率复活主人,复活后,主人拥有2400<font color='#ffe100'>（下一级2600)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150307) ->
    {ok, #pet_skill{
            id = 150307
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,430}]
            ,exp = 512
            ,next_id = 150308
            ,script_id = 120000
            ,args = [85,2600]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"85%<font color='#ffe100'>（下一级90%）</font>概率复活主人,复活后,主人拥有2600<font color='#ffe100'>（下一级2800)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150308) ->
    {ok, #pet_skill{
            id = 150308
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,460}]
            ,exp = 1024
            ,next_id = 150309
            ,script_id = 120000
            ,args = [90,2800]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"90%<font color='#ffe100'>（下一级95%）</font>概率复活主人,复活后,主人拥有2800<font color='#ffe100'>（下一级3000)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150309) ->
    {ok, #pet_skill{
            id = 150309
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,480}]
            ,exp = 2048
            ,next_id = 150310
            ,script_id = 120000
            ,args = [95,3000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"95%<font color='#ffe100'>（下一级100%）</font>概率复活主人,复活后,主人拥有3000<font color='#ffe100'>（下一级3200)</font>生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(150310) ->
    {ok, #pet_skill{
            id = 150310
            ,name = <<"高阶重生">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,500}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 120000
            ,args = [100,3200]
            ,buff_self = []
            ,buff_target = []
            ,cd = 7
            ,desc = <<"100%概率复活主人,复活后,主人拥有3200生命（不超过主人生命上限的30%）。释放一次后冷却10个回合">>
            ,n_args = [{1, [4, 1000]},{2, [8, 2000]},{3, [12, 3000]},{4, [16, 4000]},{5, [20, 5000]},{6, [24, 6000]},{7, [28, 7000]},{8, [32, 8000]},{9, [36, 9000]},{10, [40, 10000]},{11, [44, 11000]},{12, [48, 12000]},{13, [52, 13000]},{14, [56, 14000]},{15, [60, 15000]},{16, [64, 16000]},{17, [68, 17000]},{18, [72, 18000]},{19, [76, 19000]},{20, [80, 20000]}]
        }
    };

get(160101) ->
    {ok, #pet_skill{
            id = 160101
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 160102
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,40]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加4%<font color='#ffe100'>（下一级4.7%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160102) ->
    {ok, #pet_skill{
            id = 160102
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 160103
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,47]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加4.7%<font color='#ffe100'>（下一级5.4%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160103) ->
    {ok, #pet_skill{
            id = 160103
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 160104
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,54]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加5.4%<font color='#ffe100'>（下一级6.1%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160104) ->
    {ok, #pet_skill{
            id = 160104
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 160105
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,61]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加6.1%<font color='#ffe100'>（下一级6.8%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160105) ->
    {ok, #pet_skill{
            id = 160105
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 160106
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,68]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加6.8%<font color='#ffe100'>（下一级7.5%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160106) ->
    {ok, #pet_skill{
            id = 160106
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 160107
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,75]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加7.5%<font color='#ffe100'>（下一级8.2%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160107) ->
    {ok, #pet_skill{
            id = 160107
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 160108
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,82]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加8.2%<font color='#ffe100'>（下一级8.9%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160108) ->
    {ok, #pet_skill{
            id = 160108
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 160109
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,89]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加8.9%<font color='#ffe100'>（下一级9.6%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160109) ->
    {ok, #pet_skill{
            id = 160109
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 160110
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,96]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加9.6%<font color='#ffe100'>（下一级10.3%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160110) ->
    {ok, #pet_skill{
            id = 160110
            ,name = <<"低阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,103]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加10.3%抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160201) ->
    {ok, #pet_skill{
            id = 160201
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 160202
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,50]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加5%<font color='#ffe100'>（下一级6%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160202) ->
    {ok, #pet_skill{
            id = 160202
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 160203
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,60]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加6%<font color='#ffe100'>（下一级7%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160203) ->
    {ok, #pet_skill{
            id = 160203
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 160204
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160204) ->
    {ok, #pet_skill{
            id = 160204
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 160205
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,80]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加8%<font color='#ffe100'>（下一级9%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160205) ->
    {ok, #pet_skill{
            id = 160205
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 160206
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加9%<font color='#ffe100'>（下一级10%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160206) ->
    {ok, #pet_skill{
            id = 160206
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 160207
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160207) ->
    {ok, #pet_skill{
            id = 160207
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 160208
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160208) ->
    {ok, #pet_skill{
            id = 160208
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 160209
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,120]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加12%<font color='#ffe100'>（下一级13%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160209) ->
    {ok, #pet_skill{
            id = 160209
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 160210
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加13%<font color='#ffe100'>（下一级14%）</font>抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160210) ->
    {ok, #pet_skill{
            id = 160210
            ,name = <<"中阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,140]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加14%抗性（持续两个回合)">>
            ,n_args = []
        }
    };

get(160301) ->
    {ok, #pet_skill{
            id = 160301
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 160302
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,65]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加6.5%<font color='#ffe100'>（下一级8%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160302) ->
    {ok, #pet_skill{
            id = 160302
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 160303
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,80]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加8%<font color='#ffe100'>（下一级9.5%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160303) ->
    {ok, #pet_skill{
            id = 160303
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 160304
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,95]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加9.5%<font color='#ffe100'>（下一级11%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160304) ->
    {ok, #pet_skill{
            id = 160304
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 160305
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12.5%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160305) ->
    {ok, #pet_skill{
            id = 160305
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 160306
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,125]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加12.5%<font color='#ffe100'>（下一级14%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160306) ->
    {ok, #pet_skill{
            id = 160306
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 160307
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,140]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加14%<font color='#ffe100'>（下一级15.5%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160307) ->
    {ok, #pet_skill{
            id = 160307
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 160308
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,155]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加15.5%<font color='#ffe100'>（下一级17%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160308) ->
    {ok, #pet_skill{
            id = 160308
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 160309
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,170]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加17%<font color='#ffe100'>（下一级18.5%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160309) ->
    {ok, #pet_skill{
            id = 160309
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 160310
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,185]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加18.5%<font color='#ffe100'>（下一级20%）</font>抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(160310) ->
    {ok, #pet_skill{
            id = 160310
            ,name = <<"高阶抗性光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{102160,[100,2,1,200]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加20%抗性（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170101) ->
    {ok, #pet_skill{
            id = 170101
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 170102
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,40]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加4%<font color='#ffe100'>（下一级4.7%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170102) ->
    {ok, #pet_skill{
            id = 170102
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 170103
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,47]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加4.7%<font color='#ffe100'>（下一级5.4%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170103) ->
    {ok, #pet_skill{
            id = 170103
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 170104
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,54]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加5.4%<font color='#ffe100'>（下一级6.1%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170104) ->
    {ok, #pet_skill{
            id = 170104
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 170105
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,61]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加6.1%<font color='#ffe100'>（下一级6.8%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170105) ->
    {ok, #pet_skill{
            id = 170105
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 170106
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,68]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加6.8%<font color='#ffe100'>（下一级7.5%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170106) ->
    {ok, #pet_skill{
            id = 170106
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 170107
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,75]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加7.5%<font color='#ffe100'>（下一级8.2%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170107) ->
    {ok, #pet_skill{
            id = 170107
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 170108
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,82]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加8.2%<font color='#ffe100'>（下一级8.9%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170108) ->
    {ok, #pet_skill{
            id = 170108
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 170109
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,89]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加8.9%<font color='#ffe100'>（下一级9.6%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170109) ->
    {ok, #pet_skill{
            id = 170109
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 170110
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,96]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加9.6%<font color='#ffe100'>（下一级10.3%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170110) ->
    {ok, #pet_skill{
            id = 170110
            ,name = <<"低阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,103]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加10.3%防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170201) ->
    {ok, #pet_skill{
            id = 170201
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 170202
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,50]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加5%<font color='#ffe100'>（下一级6%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170202) ->
    {ok, #pet_skill{
            id = 170202
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 170203
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,60]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加6%<font color='#ffe100'>（下一级7%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170203) ->
    {ok, #pet_skill{
            id = 170203
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 170204
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,70]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加7%<font color='#ffe100'>（下一级8%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170204) ->
    {ok, #pet_skill{
            id = 170204
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 170205
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,80]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加8%<font color='#ffe100'>（下一级9%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170205) ->
    {ok, #pet_skill{
            id = 170205
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 170206
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,90]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加9%<font color='#ffe100'>（下一级10%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170206) ->
    {ok, #pet_skill{
            id = 170206
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 170207
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,100]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170207) ->
    {ok, #pet_skill{
            id = 170207
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 170208
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170208) ->
    {ok, #pet_skill{
            id = 170208
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 170209
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,120]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加12%<font color='#ffe100'>（下一级13%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170209) ->
    {ok, #pet_skill{
            id = 170209
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 170210
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,130]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加13%<font color='#ffe100'>（下一级14%）</font>防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170210) ->
    {ok, #pet_skill{
            id = 170210
            ,name = <<"中阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,140]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加14%防御（持续两个回合)">>
            ,n_args = []
        }
    };

get(170301) ->
    {ok, #pet_skill{
            id = 170301
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 170302
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,65]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加6.5%<font color='#ffe100'>（下一级8%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170302) ->
    {ok, #pet_skill{
            id = 170302
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 170303
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,80]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加8%<font color='#ffe100'>（下一级9.5%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170303) ->
    {ok, #pet_skill{
            id = 170303
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 170304
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,95]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加9.5%<font color='#ffe100'>（下一级11%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170304) ->
    {ok, #pet_skill{
            id = 170304
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 170305
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,110]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12.5%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170305) ->
    {ok, #pet_skill{
            id = 170305
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 170306
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,125]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加12.5%<font color='#ffe100'>（下一级14%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170306) ->
    {ok, #pet_skill{
            id = 170306
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 170307
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,140]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加14%<font color='#ffe100'>（下一级15.5%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170307) ->
    {ok, #pet_skill{
            id = 170307
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 170308
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,155]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加15.5%<font color='#ffe100'>（下一级17%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170308) ->
    {ok, #pet_skill{
            id = 170308
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 170309
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,170]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加17%<font color='#ffe100'>（下一级18.5%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170309) ->
    {ok, #pet_skill{
            id = 170309
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 170310
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,185]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加18.5%<font color='#ffe100'>（下一级20%）</font>防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(170310) ->
    {ok, #pet_skill{
            id = 170310
            ,name = <<"高阶防御光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{102150,[100,2,1,200]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加20%防御（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(180101) ->
    {ok, #pet_skill{
            id = 180101
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 180102
            ,script_id = 210000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,50,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%<font color='#ffe100'>（下一级22%）</font>几率使对方中毒,每回合造成50<font color='#ffe100'>（下一级100）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180102) ->
    {ok, #pet_skill{
            id = 180102
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 180103
            ,script_id = 210000
            ,args = [22]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,100,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有22%<font color='#ffe100'>（下一级24%）</font>几率使对方中毒,每回合造成100<font color='#ffe100'>（下一级150）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180103) ->
    {ok, #pet_skill{
            id = 180103
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 180104
            ,script_id = 210000
            ,args = [24]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,150,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有24%<font color='#ffe100'>（下一级26%）</font>几率使对方中毒,每回合造成150<font color='#ffe100'>（下一级200）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180104) ->
    {ok, #pet_skill{
            id = 180104
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 180105
            ,script_id = 210000
            ,args = [26]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,200,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有26%<font color='#ffe100'>（下一级28%）</font>几率使对方中毒,每回合造成200<font color='#ffe100'>（下一级250）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180105) ->
    {ok, #pet_skill{
            id = 180105
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 180106
            ,script_id = 210000
            ,args = [28]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,250,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有28%<font color='#ffe100'>（下一级30%）</font>几率使对方中毒,每回合造成250<font color='#ffe100'>（下一级300）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180106) ->
    {ok, #pet_skill{
            id = 180106
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 180107
            ,script_id = 210000
            ,args = [30]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,300,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有30%<font color='#ffe100'>（下一级32%）</font>几率使对方中毒,每回合造成300<font color='#ffe100'>（下一级350）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180107) ->
    {ok, #pet_skill{
            id = 180107
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 180108
            ,script_id = 210000
            ,args = [32]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,350,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有32%<font color='#ffe100'>（下一级34%）</font>几率使对方中毒,每回合造成350<font color='#ffe100'>（下一级400）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180108) ->
    {ok, #pet_skill{
            id = 180108
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 180109
            ,script_id = 210000
            ,args = [34]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,400,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有34%<font color='#ffe100'>（下一级36%）</font>几率使对方中毒,每回合造成400<font color='#ffe100'>（下一级450）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180109) ->
    {ok, #pet_skill{
            id = 180109
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 180110
            ,script_id = 210000
            ,args = [36]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,450,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有36%<font color='#ffe100'>（下一级40%）</font>几率使对方中毒,每回合造成450<font color='#ffe100'>（下一级500）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180110) ->
    {ok, #pet_skill{
            id = 180110
            ,name = <<"低阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 210000
            ,args = [40]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,500,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有40%几率使对方中毒,每回合造成500点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180201) ->
    {ok, #pet_skill{
            id = 180201
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 180202
            ,script_id = 210000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,100,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%<font color='#ffe100'>（下一级22%）</font>几率使对方中毒,每回合造成100<font color='#ffe100'>（下一级160）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180202) ->
    {ok, #pet_skill{
            id = 180202
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 180203
            ,script_id = 210000
            ,args = [22]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,160,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有22%<font color='#ffe100'>（下一级24%）</font>几率使对方中毒,每回合造成160<font color='#ffe100'>（下一级220）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180203) ->
    {ok, #pet_skill{
            id = 180203
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 180204
            ,script_id = 210000
            ,args = [24]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,220,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有24%<font color='#ffe100'>（下一级26%）</font>几率使对方中毒,每回合造成220<font color='#ffe100'>（下一级280）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180204) ->
    {ok, #pet_skill{
            id = 180204
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 180205
            ,script_id = 210000
            ,args = [26]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,280,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有26%<font color='#ffe100'>（下一级28%）</font>几率使对方中毒,每回合造成280<font color='#ffe100'>（下一级340）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180205) ->
    {ok, #pet_skill{
            id = 180205
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 180206
            ,script_id = 210000
            ,args = [28]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,340,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有28%<font color='#ffe100'>（下一级30%）</font>几率使对方中毒,每回合造成340<font color='#ffe100'>（下一级400）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180206) ->
    {ok, #pet_skill{
            id = 180206
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 180207
            ,script_id = 210000
            ,args = [30]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,400,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有30%<font color='#ffe100'>（下一级32%）</font>几率使对方中毒,每回合造成400<font color='#ffe100'>（下一级460）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180207) ->
    {ok, #pet_skill{
            id = 180207
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 180208
            ,script_id = 210000
            ,args = [32]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,460,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有32%<font color='#ffe100'>（下一级34%）</font>几率使对方中毒,每回合造成460<font color='#ffe100'>（下一级520）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180208) ->
    {ok, #pet_skill{
            id = 180208
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 180209
            ,script_id = 210000
            ,args = [34]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,520,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有34%<font color='#ffe100'>（下一级36%）</font>几率使对方中毒,每回合造成520<font color='#ffe100'>（下一级580）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180209) ->
    {ok, #pet_skill{
            id = 180209
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 180210
            ,script_id = 210000
            ,args = [36]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,580,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有36%<font color='#ffe100'>（下一级40%）</font>几率使对方中毒,每回合造成580<font color='#ffe100'>（下一级640）</font>点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180210) ->
    {ok, #pet_skill{
            id = 180210
            ,name = <<"中阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 210000
            ,args = [40]
            ,buff_self = []
            ,buff_target = [{209030,[100,2,1,640,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有40%几率使对方中毒,每回合造成640点伤害,持续两回合">>
            ,n_args = []
        }
    };

get(180301) ->
    {ok, #pet_skill{
            id = 180301
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 180302
            ,script_id = 210000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,150,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%<font color='#ffe100'>（下一级22%）</font>几率使对方中毒,每回合造成150<font color='#ffe100'>（下一级200）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180302) ->
    {ok, #pet_skill{
            id = 180302
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 180303
            ,script_id = 210000
            ,args = [22]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,200,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有22%<font color='#ffe100'>（下一级24%）</font>几率使对方中毒,每回合造成200<font color='#ffe100'>（下一级260）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180303) ->
    {ok, #pet_skill{
            id = 180303
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 180304
            ,script_id = 210000
            ,args = [24]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,260,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有24%<font color='#ffe100'>（下一级26%）</font>几率使对方中毒,每回合造成260<font color='#ffe100'>（下一级320）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180304) ->
    {ok, #pet_skill{
            id = 180304
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 180305
            ,script_id = 210000
            ,args = [26]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,320,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有26%<font color='#ffe100'>（下一级28%）</font>几率使对方中毒,每回合造成320<font color='#ffe100'>（下一级400）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180305) ->
    {ok, #pet_skill{
            id = 180305
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 180306
            ,script_id = 210000
            ,args = [28]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,400,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有28%<font color='#ffe100'>（下一级30%）</font>几率使对方中毒,每回合造成400<font color='#ffe100'>（下一级480）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180306) ->
    {ok, #pet_skill{
            id = 180306
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 180307
            ,script_id = 210000
            ,args = [30]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,480,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有30%<font color='#ffe100'>（下一级32%）</font>几率使对方中毒,每回合造成480<font color='#ffe100'>（下一级540）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180307) ->
    {ok, #pet_skill{
            id = 180307
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 180308
            ,script_id = 210000
            ,args = [32]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,540,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有32%<font color='#ffe100'>（下一级34%）</font>几率使对方中毒,每回合造成540<font color='#ffe100'>（下一级620）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180308) ->
    {ok, #pet_skill{
            id = 180308
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 180309
            ,script_id = 210000
            ,args = [34]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,620,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有34%<font color='#ffe100'>（下一级36%）</font>几率使对方中毒,每回合造成620<font color='#ffe100'>（下一级700）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180309) ->
    {ok, #pet_skill{
            id = 180309
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 180310
            ,script_id = 210000
            ,args = [36]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,700,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有36%<font color='#ffe100'>（下一级40%）</font>几率使对方中毒,每回合造成700<font color='#ffe100'>（下一级800）</font>点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(180310) ->
    {ok, #pet_skill{
            id = 180310
            ,name = <<"高阶毒焰">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 210000
            ,args = [40]
            ,buff_self = []
            ,buff_target = [{209030,[100,3,1,800,0]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有40%几率使对方中毒,每回合造成800点伤害,持续三回合">>
            ,n_args = []
        }
    };

get(190101) ->
    {ok, #pet_skill{
            id = 190101
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 190102
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,90,0]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加9%<font color='#ffe100'>（下一级10%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190102) ->
    {ok, #pet_skill{
            id = 190102
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 190103
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,100,0]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加10%<font color='#ffe100'>（下一级11%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190103) ->
    {ok, #pet_skill{
            id = 190103
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 190104
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,110,0]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加11%<font color='#ffe100'>（下一级12%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190104) ->
    {ok, #pet_skill{
            id = 190104
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 190105
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,120,0]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加12%<font color='#ffe100'>（下一级13%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190105) ->
    {ok, #pet_skill{
            id = 190105
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 190106
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,130,0]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加13%<font color='#ffe100'>（下一级14%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190106) ->
    {ok, #pet_skill{
            id = 190106
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 190107
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,140,0]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加14%<font color='#ffe100'>（下一级15%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190107) ->
    {ok, #pet_skill{
            id = 190107
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 190108
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,150,0]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加15%<font color='#ffe100'>（下一级16%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190108) ->
    {ok, #pet_skill{
            id = 190108
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 190109
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,160,0]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加16%<font color='#ffe100'>（下一级17%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190109) ->
    {ok, #pet_skill{
            id = 190109
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 190110
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,170,0]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加17%<font color='#ffe100'>（下一级18%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190110) ->
    {ok, #pet_skill{
            id = 190110
            ,name = <<"低阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,180,0]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加18%攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190201) ->
    {ok, #pet_skill{
            id = 190201
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 190202
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,100,0]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加10%<font color='#ffe100'>（下一级12%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190202) ->
    {ok, #pet_skill{
            id = 190202
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 190203
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,120,0]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加12%<font color='#ffe100'>（下一级14%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190203) ->
    {ok, #pet_skill{
            id = 190203
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 190204
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,140,0]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加14%<font color='#ffe100'>（下一级16%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190204) ->
    {ok, #pet_skill{
            id = 190204
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 190205
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,160,0]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加16%<font color='#ffe100'>（下一级18%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190205) ->
    {ok, #pet_skill{
            id = 190205
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 190206
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,180,0]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加18%<font color='#ffe100'>（下一级20%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190206) ->
    {ok, #pet_skill{
            id = 190206
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 190207
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,200,0]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加20%<font color='#ffe100'>（下一级22%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190207) ->
    {ok, #pet_skill{
            id = 190207
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 190208
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,220,0]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加22%<font color='#ffe100'>（下一级24%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190208) ->
    {ok, #pet_skill{
            id = 190208
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 190209
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,240,0]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加24%<font color='#ffe100'>（下一级26%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190209) ->
    {ok, #pet_skill{
            id = 190209
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 190210
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,260,0]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加26%<font color='#ffe100'>（下一级28%）</font>攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190210) ->
    {ok, #pet_skill{
            id = 190210
            ,name = <<"中阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,280,0]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加28%攻击（持续两个回合)">>
            ,n_args = []
        }
    };

get(190301) ->
    {ok, #pet_skill{
            id = 190301
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 190302
            ,script_id = 200000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,130,0]}]
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加13%<font color='#ffe100'>（下一级16%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190302) ->
    {ok, #pet_skill{
            id = 190302
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 190303
            ,script_id = 200000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,160,0]}]
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加16%<font color='#ffe100'>（下一级19%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190303) ->
    {ok, #pet_skill{
            id = 190303
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 190304
            ,script_id = 200000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,190,0]}]
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加19%<font color='#ffe100'>（下一级22%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190304) ->
    {ok, #pet_skill{
            id = 190304
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 190305
            ,script_id = 200000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,220,0]}]
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加22%<font color='#ffe100'>（下一级25%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190305) ->
    {ok, #pet_skill{
            id = 190305
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 190306
            ,script_id = 200000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,250,0]}]
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加25%<font color='#ffe100'>（下一级28%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190306) ->
    {ok, #pet_skill{
            id = 190306
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 190307
            ,script_id = 200000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,280,0]}]
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加28%<font color='#ffe100'>（下一级31%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190307) ->
    {ok, #pet_skill{
            id = 190307
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 190308
            ,script_id = 200000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,310,0]}]
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加31%<font color='#ffe100'>（下一级34%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190308) ->
    {ok, #pet_skill{
            id = 190308
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 190309
            ,script_id = 200000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,340,0]}]
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加34%<font color='#ffe100'>（下一级37%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190309) ->
    {ok, #pet_skill{
            id = 190309
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 190310
            ,script_id = 200000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,370,0]}]
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加37%<font color='#ffe100'>（下一级40%）</font>攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(190310) ->
    {ok, #pet_skill{
            id = 190310
            ,name = <<"高阶攻击光环">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 200000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{104140,[100,2,1,400,0]}]
            ,cd = 0
            ,desc = <<"20%几率给主人增加40%攻击（持续两个回合)">>
            ,n_args = [{1, [2]},{2, [4]},{3, [6]},{4, [8]},{5, [10]},{6, [12]},{7, [14]},{8, [16]},{9, [18]},{10, [20]},{11, [22]},{12, [24]},{13, [26]},{14, [28]},{15, [30]},{16, [32]},{17, [34]},{18, [36]},{19, [38]},{20, [40]}]
        }
    };

get(200101) ->
    {ok, #pet_skill{
            id = 200101
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 200102
            ,script_id = 210000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,9]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有10%<font color='#ffe100'>（下一级11%）</font>几率使敌人受到的伤害加深9%<font color='#ffe100'>（下一级10%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200102) ->
    {ok, #pet_skill{
            id = 200102
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 200103
            ,script_id = 210000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,10]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有11%<font color='#ffe100'>（下一级12%）</font>几率使敌人受到的伤害加深10%<font color='#ffe100'>（下一级11%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200103) ->
    {ok, #pet_skill{
            id = 200103
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 200104
            ,script_id = 210000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,11]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有12%<font color='#ffe100'>（下一级13%）</font>几率使敌人受到的伤害加深11%<font color='#ffe100'>（下一级12%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200104) ->
    {ok, #pet_skill{
            id = 200104
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 200105
            ,script_id = 210000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,12]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有13%<font color='#ffe100'>（下一级14%）</font>几率使敌人受到的伤害加深12%<font color='#ffe100'>（下一级13%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200105) ->
    {ok, #pet_skill{
            id = 200105
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 200106
            ,script_id = 210000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,13]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有14%<font color='#ffe100'>（下一级15%）</font>几率使敌人受到的伤害加深13%<font color='#ffe100'>（下一级14%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200106) ->
    {ok, #pet_skill{
            id = 200106
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 200107
            ,script_id = 210000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,14]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有15%<font color='#ffe100'>（下一级16%）</font>几率使敌人受到的伤害加深14%<font color='#ffe100'>（下一级15%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200107) ->
    {ok, #pet_skill{
            id = 200107
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 200108
            ,script_id = 210000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,15]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有16%<font color='#ffe100'>（下一级17%）</font>几率使敌人受到的伤害加深15%<font color='#ffe100'>（下一级16%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200108) ->
    {ok, #pet_skill{
            id = 200108
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 200109
            ,script_id = 210000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,16]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有17%<font color='#ffe100'>（下一级18%）</font>几率使敌人受到的伤害加深16%<font color='#ffe100'>（下一级17%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200109) ->
    {ok, #pet_skill{
            id = 200109
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 200110
            ,script_id = 210000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,17]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有18%<font color='#ffe100'>（下一级20%）</font>几率使敌人受到的伤害加深17%<font color='#ffe100'>（下一级18%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200110) ->
    {ok, #pet_skill{
            id = 200110
            ,name = <<"低阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 210000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,18]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%几率使敌人受到的伤害加深18%,持续两回合">>
            ,n_args = []
        }
    };

get(200201) ->
    {ok, #pet_skill{
            id = 200201
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 200202
            ,script_id = 210000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,10]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有10%<font color='#ffe100'>（下一级11%）</font>几率使敌人受到的伤害加深10%<font color='#ffe100'>（下一级12%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200202) ->
    {ok, #pet_skill{
            id = 200202
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 200203
            ,script_id = 210000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,12]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有11%<font color='#ffe100'>（下一级12%）</font>几率使敌人受到的伤害加深12%<font color='#ffe100'>（下一级14%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200203) ->
    {ok, #pet_skill{
            id = 200203
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 200204
            ,script_id = 210000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,14]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有12%<font color='#ffe100'>（下一级13%）</font>几率使敌人受到的伤害加深14%<font color='#ffe100'>（下一级16%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200204) ->
    {ok, #pet_skill{
            id = 200204
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 200205
            ,script_id = 210000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,16]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有13%<font color='#ffe100'>（下一级14%）</font>几率使敌人受到的伤害加深16%<font color='#ffe100'>（下一级18%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200205) ->
    {ok, #pet_skill{
            id = 200205
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 200206
            ,script_id = 210000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,18]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有14%<font color='#ffe100'>（下一级15%）</font>几率使敌人受到的伤害加深18%<font color='#ffe100'>（下一级20%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200206) ->
    {ok, #pet_skill{
            id = 200206
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 200207
            ,script_id = 210000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,20]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有15%<font color='#ffe100'>（下一级16%）</font>几率使敌人受到的伤害加深20%<font color='#ffe100'>（下一级22%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200207) ->
    {ok, #pet_skill{
            id = 200207
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 200208
            ,script_id = 210000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,22]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有16%<font color='#ffe100'>（下一级17%）</font>几率使敌人受到的伤害加深22%<font color='#ffe100'>（下一级24%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200208) ->
    {ok, #pet_skill{
            id = 200208
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 200209
            ,script_id = 210000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,24]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有17%<font color='#ffe100'>（下一级18%）</font>几率使敌人受到的伤害加深24%<font color='#ffe100'>（下一级26%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200209) ->
    {ok, #pet_skill{
            id = 200209
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 200210
            ,script_id = 210000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,26]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有18%<font color='#ffe100'>（下一级20%）</font>几率使敌人受到的伤害加深26%<font color='#ffe100'>（下一级28%）</font>,持续两回合">>
            ,n_args = []
        }
    };

get(200210) ->
    {ok, #pet_skill{
            id = 200210
            ,name = <<"中阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 210000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,28]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%几率使敌人受到的伤害加深28%,持续两回合">>
            ,n_args = []
        }
    };

get(200301) ->
    {ok, #pet_skill{
            id = 200301
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 200302
            ,script_id = 210000
            ,args = [10]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,13]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有10%<font color='#ffe100'>（下一级11%）</font>几率使敌人受到的伤害加深13%<font color='#ffe100'>（下一级16%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200302) ->
    {ok, #pet_skill{
            id = 200302
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 200303
            ,script_id = 210000
            ,args = [11]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,16]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有11%<font color='#ffe100'>（下一级12%）</font>几率使敌人受到的伤害加深16%<font color='#ffe100'>（下一级19%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200303) ->
    {ok, #pet_skill{
            id = 200303
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 200304
            ,script_id = 210000
            ,args = [12]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,19]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有12%<font color='#ffe100'>（下一级13%）</font>几率使敌人受到的伤害加深19%<font color='#ffe100'>（下一级22%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200304) ->
    {ok, #pet_skill{
            id = 200304
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 200305
            ,script_id = 210000
            ,args = [13]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,22]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有13%<font color='#ffe100'>（下一级14%）</font>几率使敌人受到的伤害加深22%<font color='#ffe100'>（下一级25%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200305) ->
    {ok, #pet_skill{
            id = 200305
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 200306
            ,script_id = 210000
            ,args = [14]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,25]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有14%<font color='#ffe100'>（下一级15%）</font>几率使敌人受到的伤害加深25%<font color='#ffe100'>（下一级28%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200306) ->
    {ok, #pet_skill{
            id = 200306
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 200307
            ,script_id = 210000
            ,args = [15]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,28]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有15%<font color='#ffe100'>（下一级16%）</font>几率使敌人受到的伤害加深28%<font color='#ffe100'>（下一级31%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200307) ->
    {ok, #pet_skill{
            id = 200307
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 200308
            ,script_id = 210000
            ,args = [16]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,31]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有16%<font color='#ffe100'>（下一级17%）</font>几率使敌人受到的伤害加深31%<font color='#ffe100'>（下一级34%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200308) ->
    {ok, #pet_skill{
            id = 200308
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 200309
            ,script_id = 210000
            ,args = [17]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,34]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有17%<font color='#ffe100'>（下一级18%）</font>几率使敌人受到的伤害加深34%<font color='#ffe100'>（下一级37%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200309) ->
    {ok, #pet_skill{
            id = 200309
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 200310
            ,script_id = 210000
            ,args = [18]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,37]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有18%<font color='#ffe100'>（下一级20%）</font>几率使敌人受到的伤害加深37%<font color='#ffe100'>（下一级40%）</font>,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(200310) ->
    {ok, #pet_skill{
            id = 200310
            ,name = <<"高阶破甲">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 210000
            ,args = [20]
            ,buff_self = []
            ,buff_target = [{201240,[100,2,1,40]}]
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%几率使敌人受到的伤害加深40%,持续两回合">>
            ,n_args = [{1, [2, 1]},{2, [4, 1]},{3, [6, 1]},{4, [8, 1]},{5, [10, 1]},{6, [12, 1]},{7, [14, 1]},{8, [16, 1]},{9, [18, 1]},{10, [20, 1]},{11, [22, 1]},{12, [24, 1]},{13, [26, 1]},{14, [28, 1]},{15, [30, 1]},{16, [32, 1]},{17, [34, 1]},{18, [36, 1]},{19, [38, 1]},{20, [40, 1]}]
        }
    };

get(210101) ->
    {ok, #pet_skill{
            id = 210101
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 210102
            ,script_id = 220000
            ,args = [10, 200]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有10%<font color='#ffe100'>（下一级11%）</font>几率使敌人减少200<font color='#ffe100'>（下一级220）</font>点魔法">>
            ,n_args = []
        }
    };

get(210102) ->
    {ok, #pet_skill{
            id = 210102
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 210103
            ,script_id = 220000
            ,args = [11, 220]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有11%<font color='#ffe100'>（下一级12%）</font>几率使敌人减少220<font color='#ffe100'>（下一级240）</font>点魔法">>
            ,n_args = []
        }
    };

get(210103) ->
    {ok, #pet_skill{
            id = 210103
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 210104
            ,script_id = 220000
            ,args = [12, 240]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有12%<font color='#ffe100'>（下一级13%）</font>几率使敌人减少240<font color='#ffe100'>（下一级260）</font>点魔法">>
            ,n_args = []
        }
    };

get(210104) ->
    {ok, #pet_skill{
            id = 210104
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 210105
            ,script_id = 220000
            ,args = [13, 260]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有13%<font color='#ffe100'>（下一级14%）</font>几率使敌人减少260<font color='#ffe100'>（下一级280）</font>点魔法">>
            ,n_args = []
        }
    };

get(210105) ->
    {ok, #pet_skill{
            id = 210105
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 210106
            ,script_id = 220000
            ,args = [14, 280]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有14%<font color='#ffe100'>（下一级15%）</font>几率使敌人减少280<font color='#ffe100'>（下一级300）</font>点魔法">>
            ,n_args = []
        }
    };

get(210106) ->
    {ok, #pet_skill{
            id = 210106
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 210107
            ,script_id = 220000
            ,args = [15, 300]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有15%<font color='#ffe100'>（下一级16%）</font>几率使敌人减少300<font color='#ffe100'>（下一级320）</font>点魔法">>
            ,n_args = []
        }
    };

get(210107) ->
    {ok, #pet_skill{
            id = 210107
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 210108
            ,script_id = 220000
            ,args = [16, 320]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有16%<font color='#ffe100'>（下一级17%）</font>几率使敌人减少320<font color='#ffe100'>（下一级340）</font>点魔法">>
            ,n_args = []
        }
    };

get(210108) ->
    {ok, #pet_skill{
            id = 210108
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 210109
            ,script_id = 220000
            ,args = [17, 340]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有17%<font color='#ffe100'>（下一级18%）</font>几率使敌人减少340<font color='#ffe100'>（下一级360）</font>点魔法">>
            ,n_args = []
        }
    };

get(210109) ->
    {ok, #pet_skill{
            id = 210109
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 210110
            ,script_id = 220000
            ,args = [18, 360]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有18%<font color='#ffe100'>（下一级20%）</font>几率使敌人减少360<font color='#ffe100'>（下一级250）</font>点魔法">>
            ,n_args = []
        }
    };

get(210110) ->
    {ok, #pet_skill{
            id = 210110
            ,name = <<"低阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 220000
            ,args = [20, 250]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%几率使敌人减少250点魔法">>
            ,n_args = []
        }
    };

get(210201) ->
    {ok, #pet_skill{
            id = 210201
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 210202
            ,script_id = 220000
            ,args = [10, 280]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有10%<font color='#ffe100'>（下一级11%）</font>几率使敌人减少280<font color='#ffe100'>（下一级310）</font>点魔法">>
            ,n_args = []
        }
    };

get(210202) ->
    {ok, #pet_skill{
            id = 210202
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 210203
            ,script_id = 220000
            ,args = [11, 310]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有11%<font color='#ffe100'>（下一级12%）</font>几率使敌人减少310<font color='#ffe100'>（下一级340）</font>点魔法">>
            ,n_args = []
        }
    };

get(210203) ->
    {ok, #pet_skill{
            id = 210203
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 210204
            ,script_id = 220000
            ,args = [12, 340]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有12%<font color='#ffe100'>（下一级13%）</font>几率使敌人减少340<font color='#ffe100'>（下一级370）</font>点魔法">>
            ,n_args = []
        }
    };

get(210204) ->
    {ok, #pet_skill{
            id = 210204
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 210205
            ,script_id = 220000
            ,args = [13, 370]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有13%<font color='#ffe100'>（下一级14%）</font>几率使敌人减少370<font color='#ffe100'>（下一级400）</font>点魔法">>
            ,n_args = []
        }
    };

get(210205) ->
    {ok, #pet_skill{
            id = 210205
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 210206
            ,script_id = 220000
            ,args = [14, 400]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有14%<font color='#ffe100'>（下一级15%）</font>几率使敌人减少400<font color='#ffe100'>（下一级430）</font>点魔法">>
            ,n_args = []
        }
    };

get(210206) ->
    {ok, #pet_skill{
            id = 210206
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 210207
            ,script_id = 220000
            ,args = [15, 430]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有15%<font color='#ffe100'>（下一级16%）</font>几率使敌人减少430<font color='#ffe100'>（下一级460）</font>点魔法">>
            ,n_args = []
        }
    };

get(210207) ->
    {ok, #pet_skill{
            id = 210207
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 210208
            ,script_id = 220000
            ,args = [16, 460]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有16%<font color='#ffe100'>（下一级17%）</font>几率使敌人减少460<font color='#ffe100'>（下一级490）</font>点魔法">>
            ,n_args = []
        }
    };

get(210208) ->
    {ok, #pet_skill{
            id = 210208
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 210209
            ,script_id = 220000
            ,args = [17, 490]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有17%<font color='#ffe100'>（下一级18%）</font>几率使敌人减少490<font color='#ffe100'>（下一级520）</font>点魔法">>
            ,n_args = []
        }
    };

get(210209) ->
    {ok, #pet_skill{
            id = 210209
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 210210
            ,script_id = 220000
            ,args = [18, 520]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有18%<font color='#ffe100'>（下一级20%）</font>几率使敌人减少520<font color='#ffe100'>（下一级550）</font>点魔法">>
            ,n_args = []
        }
    };

get(210210) ->
    {ok, #pet_skill{
            id = 210210
            ,name = <<"中阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 220000
            ,args = [20, 550]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%几率使敌人减少550点魔法">>
            ,n_args = []
        }
    };

get(210301) ->
    {ok, #pet_skill{
            id = 210301
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 210302
            ,script_id = 220000
            ,args = [10, 300]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有10%<font color='#ffe100'>（下一级11%）</font>几率使敌人减少300<font color='#ffe100'>（下一级350）</font>点魔法">>
            ,n_args = []
        }
    };

get(210302) ->
    {ok, #pet_skill{
            id = 210302
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 210303
            ,script_id = 220000
            ,args = [11, 350]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有11%<font color='#ffe100'>（下一级12%）</font>几率使敌人减少350<font color='#ffe100'>（下一级400）</font>点魔法">>
            ,n_args = []
        }
    };

get(210303) ->
    {ok, #pet_skill{
            id = 210303
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 210304
            ,script_id = 220000
            ,args = [12, 400]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有12%<font color='#ffe100'>（下一级13%）</font>几率使敌人减少400<font color='#ffe100'>（下一级450）</font>点魔法">>
            ,n_args = []
        }
    };

get(210304) ->
    {ok, #pet_skill{
            id = 210304
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 210305
            ,script_id = 220000
            ,args = [13, 450]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有13%<font color='#ffe100'>（下一级14%）</font>几率使敌人减少450<font color='#ffe100'>（下一级500）</font>点魔法">>
            ,n_args = []
        }
    };

get(210305) ->
    {ok, #pet_skill{
            id = 210305
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 210306
            ,script_id = 220000
            ,args = [14, 500]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有14%<font color='#ffe100'>（下一级15%）</font>几率使敌人减少500<font color='#ffe100'>（下一级550）</font>点魔法">>
            ,n_args = []
        }
    };

get(210306) ->
    {ok, #pet_skill{
            id = 210306
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 210307
            ,script_id = 220000
            ,args = [15, 550]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有15%<font color='#ffe100'>（下一级16%）</font>几率使敌人减少550<font color='#ffe100'>（下一级600）</font>点魔法">>
            ,n_args = []
        }
    };

get(210307) ->
    {ok, #pet_skill{
            id = 210307
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 210308
            ,script_id = 220000
            ,args = [16, 600]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有16%<font color='#ffe100'>（下一级17%）</font>几率使敌人减少600<font color='#ffe100'>（下一级650）</font>点魔法">>
            ,n_args = []
        }
    };

get(210308) ->
    {ok, #pet_skill{
            id = 210308
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 210309
            ,script_id = 220000
            ,args = [17, 650]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有17%<font color='#ffe100'>（下一级18%）</font>几率使敌人减少650<font color='#ffe100'>（下一级700）</font>点魔法">>
            ,n_args = []
        }
    };

get(210309) ->
    {ok, #pet_skill{
            id = 210309
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 210310
            ,script_id = 220000
            ,args = [18, 700]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有18%<font color='#ffe100'>（下一级20%）</font>几率使敌人减少700<font color='#ffe100'>（下一级750）</font>点魔法">>
            ,n_args = []
        }
    };

get(210310) ->
    {ok, #pet_skill{
            id = 210310
            ,name = <<"高阶破魔">>
            ,mutex = 0
            ,type = 1
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 220000
            ,args = [20, 750]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴攻击敌人时,有20%几率使敌人减少750点魔法">>
            ,n_args = []
        }
    };

get(220101) ->
    {ok, #pet_skill{
            id = 220101
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 220102
            ,script_id = 140000
            ,args = [18, 10]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,20%<font color='#ffe100'>（下一级22%）</font>几率保守护主人,抵挡10%<font color='#ffe100'>（下一级13%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220102) ->
    {ok, #pet_skill{
            id = 220102
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 220103
            ,script_id = 140000
            ,args = [19, 13]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,22%<font color='#ffe100'>（下一级24%）</font>几率保守护主人,抵挡13%<font color='#ffe100'>（下一级16%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220103) ->
    {ok, #pet_skill{
            id = 220103
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 220104
            ,script_id = 140000
            ,args = [20, 16]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,24%<font color='#ffe100'>（下一级26%）</font>几率保守护主人,抵挡16%<font color='#ffe100'>（下一级19%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220104) ->
    {ok, #pet_skill{
            id = 220104
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 220105
            ,script_id = 140000
            ,args = [22, 19]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,26%<font color='#ffe100'>（下一级28%）</font>几率保守护主人,抵挡19%<font color='#ffe100'>（下一级22%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220105) ->
    {ok, #pet_skill{
            id = 220105
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 220106
            ,script_id = 140000
            ,args = [25, 22]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,28%<font color='#ffe100'>（下一级30%）</font>几率保守护主人,抵挡22%<font color='#ffe100'>（下一级25%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220106) ->
    {ok, #pet_skill{
            id = 220106
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 220107
            ,script_id = 140000
            ,args = [27, 25]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,30%<font color='#ffe100'>（下一级32%）</font>几率保守护主人,抵挡25%<font color='#ffe100'>（下一级28%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220107) ->
    {ok, #pet_skill{
            id = 220107
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 220108
            ,script_id = 140000
            ,args = [28, 28]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,32%<font color='#ffe100'>（下一级34%）</font>几率保守护主人,抵挡28%<font color='#ffe100'>（下一级31%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220108) ->
    {ok, #pet_skill{
            id = 220108
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 220109
            ,script_id = 140000
            ,args = [29, 31]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,34%<font color='#ffe100'>（下一级36%）</font>几率保守护主人,抵挡31%<font color='#ffe100'>（下一级34%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220109) ->
    {ok, #pet_skill{
            id = 220109
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 220110
            ,script_id = 140000
            ,args = [32, 34]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,36%<font color='#ffe100'>（下一级40%）</font>几率保守护主人,抵挡34%<font color='#ffe100'>（下一级37%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220110) ->
    {ok, #pet_skill{
            id = 220110
            ,name = <<"低阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 140000
            ,args = [36, 37]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,40%几率保守护主人,抵挡37%的伤害">>
            ,n_args = []
        }
    };

get(220201) ->
    {ok, #pet_skill{
            id = 220201
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 220202
            ,script_id = 140000
            ,args = [27, 15]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,30%<font color='#ffe100'>（下一级34%）</font>几率保守护主人,抵挡15%<font color='#ffe100'>（下一级20%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220202) ->
    {ok, #pet_skill{
            id = 220202
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 220203
            ,script_id = 140000
            ,args = [29, 20]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,34%<font color='#ffe100'>（下一级38%）</font>几率保守护主人,抵挡20%<font color='#ffe100'>（下一级25%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220203) ->
    {ok, #pet_skill{
            id = 220203
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 220204
            ,script_id = 140000
            ,args = [33, 25]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,38%<font color='#ffe100'>（下一级42%）</font>几率保守护主人,抵挡25%<font color='#ffe100'>（下一级30%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220204) ->
    {ok, #pet_skill{
            id = 220204
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 220205
            ,script_id = 140000
            ,args = [37, 30]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,42%<font color='#ffe100'>（下一级46%）</font>几率保守护主人,抵挡30%<font color='#ffe100'>（下一级35%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220205) ->
    {ok, #pet_skill{
            id = 220205
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 220206
            ,script_id = 140000
            ,args = [39, 35]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,46%<font color='#ffe100'>（下一级50%）</font>几率保守护主人,抵挡35%<font color='#ffe100'>（下一级40%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220206) ->
    {ok, #pet_skill{
            id = 220206
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 220207
            ,script_id = 140000
            ,args = [45, 40]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,50%<font color='#ffe100'>（下一级54%）</font>几率保守护主人,抵挡40%<font color='#ffe100'>（下一级45%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220207) ->
    {ok, #pet_skill{
            id = 220207
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 220208
            ,script_id = 140000
            ,args = [47, 45]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,54%<font color='#ffe100'>（下一级58%）</font>几率保守护主人,抵挡45%<font color='#ffe100'>（下一级50%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220208) ->
    {ok, #pet_skill{
            id = 220208
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 220209
            ,script_id = 140000
            ,args = [52, 50]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,58%<font color='#ffe100'>（下一级62%）</font>几率保守护主人,抵挡50%<font color='#ffe100'>（下一级55%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220209) ->
    {ok, #pet_skill{
            id = 220209
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 220210
            ,script_id = 140000
            ,args = [54, 55]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,62%<font color='#ffe100'>（下一级66%）</font>几率保守护主人,抵挡55%<font color='#ffe100'>（下一级60%）</font>的伤害">>
            ,n_args = []
        }
    };

get(220210) ->
    {ok, #pet_skill{
            id = 220210
            ,name = <<"中阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 140000
            ,args = [60, 60]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,66%几率保守护主人,抵挡60%的伤害">>
            ,n_args = []
        }
    };

get(220301) ->
    {ok, #pet_skill{
            id = 220301
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 220302
            ,script_id = 140000
            ,args = [30, 19]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,35%<font color='#ffe100'>（下一级40%）</font>几率保守护主人,抵挡19%<font color='#ffe100'>（下一级28%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220302) ->
    {ok, #pet_skill{
            id = 220302
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 220303
            ,script_id = 140000
            ,args = [36, 28]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,40%<font color='#ffe100'>（下一级45%）</font>几率保守护主人,抵挡28%<font color='#ffe100'>（下一级37%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220303) ->
    {ok, #pet_skill{
            id = 220303
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 220304
            ,script_id = 140000
            ,args = [40, 37]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,45%<font color='#ffe100'>（下一级50%）</font>几率保守护主人,抵挡37%<font color='#ffe100'>（下一级46%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220304) ->
    {ok, #pet_skill{
            id = 220304
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 220305
            ,script_id = 140000
            ,args = [45, 46]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,50%<font color='#ffe100'>（下一级54%）</font>几率保守护主人,抵挡46%<font color='#ffe100'>（下一级55%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220305) ->
    {ok, #pet_skill{
            id = 220305
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 220306
            ,script_id = 140000
            ,args = [50, 55]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,54%<font color='#ffe100'>（下一级58%）</font>几率保守护主人,抵挡55%<font color='#ffe100'>（下一级64%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220306) ->
    {ok, #pet_skill{
            id = 220306
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 220307
            ,script_id = 140000
            ,args = [52, 64]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,58%<font color='#ffe100'>（下一级61%）</font>几率保守护主人,抵挡64%<font color='#ffe100'>（下一级73%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220307) ->
    {ok, #pet_skill{
            id = 220307
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 220308
            ,script_id = 140000
            ,args = [54, 73]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,61%<font color='#ffe100'>（下一级64%）</font>几率保守护主人,抵挡73%<font color='#ffe100'>（下一级82%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220308) ->
    {ok, #pet_skill{
            id = 220308
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 220309
            ,script_id = 140000
            ,args = [56, 82]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,64%<font color='#ffe100'>（下一级67%）</font>几率保守护主人,抵挡82%<font color='#ffe100'>（下一级91%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220309) ->
    {ok, #pet_skill{
            id = 220309
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 220310
            ,script_id = 140000
            ,args = [60, 91]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,67%<font color='#ffe100'>（下一级70%）</font>几率保守护主人,抵挡91%<font color='#ffe100'>（下一级100%）</font>的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(220310) ->
    {ok, #pet_skill{
            id = 220310
            ,name = <<"高阶守护">>
            ,mutex = 0
            ,type = 2
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 140000
            ,args = [63, 100]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"主人受到敌人攻击时,70%几率保守护主人,抵挡100%的伤害">>
            ,n_args = [{1, [2, 1]},{2, [4, 2]},{3, [6, 3]},{4, [8, 4]},{5, [10, 5]},{6, [12, 6]},{7, [14, 7]},{8, [16, 8]},{9, [18, 9]},{10, [20, 10]},{11, [22, 11]},{12, [24, 12]},{13, [26, 13]},{14, [28, 14]},{15, [30, 15]},{16, [32, 16]},{17, [34, 17]},{18, [36, 18]},{19, [38, 19]},{20, [40, 20]}]
        }
    };

get(230101) ->
    {ok, #pet_skill{
            id = 230101
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 230102
            ,script_id = 130000
            ,args = [10, 400]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加400<font color='#ffe100'>（下一级420）</font>点生命">>
            ,n_args = []
        }
    };

get(230102) ->
    {ok, #pet_skill{
            id = 230102
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 230103
            ,script_id = 130000
            ,args = [11, 420]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加420<font color='#ffe100'>（下一级440）</font>点生命">>
            ,n_args = []
        }
    };

get(230103) ->
    {ok, #pet_skill{
            id = 230103
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 230104
            ,script_id = 130000
            ,args = [12, 440]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加440<font color='#ffe100'>（下一级480）</font>点生命">>
            ,n_args = []
        }
    };

get(230104) ->
    {ok, #pet_skill{
            id = 230104
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 230105
            ,script_id = 130000
            ,args = [13, 480]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加480<font color='#ffe100'>（下一级520）</font>点生命">>
            ,n_args = []
        }
    };

get(230105) ->
    {ok, #pet_skill{
            id = 230105
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 230106
            ,script_id = 130000
            ,args = [14, 520]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加520<font color='#ffe100'>（下一级600）</font>点生命">>
            ,n_args = []
        }
    };

get(230106) ->
    {ok, #pet_skill{
            id = 230106
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 230107
            ,script_id = 130000
            ,args = [15, 600]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加600<font color='#ffe100'>（下一级700）</font>点生命">>
            ,n_args = []
        }
    };

get(230107) ->
    {ok, #pet_skill{
            id = 230107
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 230108
            ,script_id = 130000
            ,args = [16, 700]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加700<font color='#ffe100'>（下一级800）</font>点生命">>
            ,n_args = []
        }
    };

get(230108) ->
    {ok, #pet_skill{
            id = 230108
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 230109
            ,script_id = 130000
            ,args = [17, 800]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加800<font color='#ffe100'>（下一级1000）</font>点生命">>
            ,n_args = []
        }
    };

get(230109) ->
    {ok, #pet_skill{
            id = 230109
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 230110
            ,script_id = 130000
            ,args = [18, 1000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加1000<font color='#ffe100'>（下一级1250）</font>点生命">>
            ,n_args = []
        }
    };

get(230110) ->
    {ok, #pet_skill{
            id = 230110
            ,name = <<"低阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 130000
            ,args = [20, 1250]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"20%几率给主人增加1250点生命">>
            ,n_args = []
        }
    };

get(230201) ->
    {ok, #pet_skill{
            id = 230201
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 230202
            ,script_id = 130000
            ,args = [10, 500]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加500<font color='#ffe100'>（下一级550）</font>点生命">>
            ,n_args = []
        }
    };

get(230202) ->
    {ok, #pet_skill{
            id = 230202
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 230203
            ,script_id = 130000
            ,args = [11, 550]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加550<font color='#ffe100'>（下一级600）</font>点生命">>
            ,n_args = []
        }
    };

get(230203) ->
    {ok, #pet_skill{
            id = 230203
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 230204
            ,script_id = 130000
            ,args = [12, 600]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加600<font color='#ffe100'>（下一级750）</font>点生命">>
            ,n_args = []
        }
    };

get(230204) ->
    {ok, #pet_skill{
            id = 230204
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 230205
            ,script_id = 130000
            ,args = [13, 750]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加750<font color='#ffe100'>（下一级900）</font>点生命">>
            ,n_args = []
        }
    };

get(230205) ->
    {ok, #pet_skill{
            id = 230205
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 230206
            ,script_id = 130000
            ,args = [14, 900]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加900<font color='#ffe100'>（下一级1250）</font>点生命">>
            ,n_args = []
        }
    };

get(230206) ->
    {ok, #pet_skill{
            id = 230206
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 230207
            ,script_id = 130000
            ,args = [15, 1250]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加1250<font color='#ffe100'>（下一级1600）</font>点生命">>
            ,n_args = []
        }
    };

get(230207) ->
    {ok, #pet_skill{
            id = 230207
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 230208
            ,script_id = 130000
            ,args = [16, 1600]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加1600<font color='#ffe100'>（下一级2000）</font>点生命">>
            ,n_args = []
        }
    };

get(230208) ->
    {ok, #pet_skill{
            id = 230208
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 230209
            ,script_id = 130000
            ,args = [17, 2000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加2000<font color='#ffe100'>（下一级2500）</font>点生命">>
            ,n_args = []
        }
    };

get(230209) ->
    {ok, #pet_skill{
            id = 230209
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 230210
            ,script_id = 130000
            ,args = [18, 2500]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加2500<font color='#ffe100'>（下一级3000）</font>点生命">>
            ,n_args = []
        }
    };

get(230210) ->
    {ok, #pet_skill{
            id = 230210
            ,name = <<"中阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 130000
            ,args = [20, 3000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"20%几率给主人增加3000点生命">>
            ,n_args = []
        }
    };

get(230301) ->
    {ok, #pet_skill{
            id = 230301
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 230302
            ,script_id = 130000
            ,args = [10, 700]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加700<font color='#ffe100'>（下一级800）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230302) ->
    {ok, #pet_skill{
            id = 230302
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 230303
            ,script_id = 130000
            ,args = [11, 800]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加800<font color='#ffe100'>（下一级900）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230303) ->
    {ok, #pet_skill{
            id = 230303
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 230304
            ,script_id = 130000
            ,args = [12, 900]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加900<font color='#ffe100'>（下一级1200）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230304) ->
    {ok, #pet_skill{
            id = 230304
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 230305
            ,script_id = 130000
            ,args = [13, 1200]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加1200<font color='#ffe100'>（下一级1600）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230305) ->
    {ok, #pet_skill{
            id = 230305
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 230306
            ,script_id = 130000
            ,args = [14, 1600]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加1600<font color='#ffe100'>（下一级2400）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230306) ->
    {ok, #pet_skill{
            id = 230306
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 230307
            ,script_id = 130000
            ,args = [15, 2400]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加2400<font color='#ffe100'>（下一级3500）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230307) ->
    {ok, #pet_skill{
            id = 230307
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 230308
            ,script_id = 130000
            ,args = [16, 3500]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加3500<font color='#ffe100'>（下一级5000）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230308) ->
    {ok, #pet_skill{
            id = 230308
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 230309
            ,script_id = 130000
            ,args = [17, 5000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加5000<font color='#ffe100'>（下一级6500）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230309) ->
    {ok, #pet_skill{
            id = 230309
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 230310
            ,script_id = 130000
            ,args = [18, 6500]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加6500<font color='#ffe100'>（下一级8000）</font>点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(230310) ->
    {ok, #pet_skill{
            id = 230310
            ,name = <<"高阶治愈">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 130000
            ,args = [20, 8000]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"20%几率给主人增加8000点生命">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240101) ->
    {ok, #pet_skill{
            id = 240101
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 1
            ,cost = [{mp,10}]
            ,exp = 2
            ,next_id = 240102
            ,script_id = 131000
            ,args = [10, 100]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加100<font color='#ffe100'>（下一级120）</font>点魔法">>
            ,n_args = []
        }
    };

get(240102) ->
    {ok, #pet_skill{
            id = 240102
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 2
            ,cost = [{mp,12}]
            ,exp = 4
            ,next_id = 240103
            ,script_id = 131000
            ,args = [11, 120]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加120<font color='#ffe100'>（下一级140）</font>点魔法">>
            ,n_args = []
        }
    };

get(240103) ->
    {ok, #pet_skill{
            id = 240103
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 3
            ,cost = [{mp,14}]
            ,exp = 8
            ,next_id = 240104
            ,script_id = 131000
            ,args = [12, 140]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加140<font color='#ffe100'>（下一级160）</font>点魔法">>
            ,n_args = []
        }
    };

get(240104) ->
    {ok, #pet_skill{
            id = 240104
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 4
            ,cost = [{mp,16}]
            ,exp = 16
            ,next_id = 240105
            ,script_id = 131000
            ,args = [13, 160]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加160<font color='#ffe100'>（下一级180）</font>点魔法">>
            ,n_args = []
        }
    };

get(240105) ->
    {ok, #pet_skill{
            id = 240105
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 5
            ,cost = [{mp,18}]
            ,exp = 32
            ,next_id = 240106
            ,script_id = 131000
            ,args = [14, 180]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加180<font color='#ffe100'>（下一级200）</font>点魔法">>
            ,n_args = []
        }
    };

get(240106) ->
    {ok, #pet_skill{
            id = 240106
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 6
            ,cost = [{mp,20}]
            ,exp = 64
            ,next_id = 240107
            ,script_id = 131000
            ,args = [15, 200]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加200<font color='#ffe100'>（下一级220）</font>点魔法">>
            ,n_args = []
        }
    };

get(240107) ->
    {ok, #pet_skill{
            id = 240107
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 7
            ,cost = [{mp,22}]
            ,exp = 128
            ,next_id = 240108
            ,script_id = 131000
            ,args = [16, 220]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加220<font color='#ffe100'>（下一级250）</font>点魔法">>
            ,n_args = []
        }
    };

get(240108) ->
    {ok, #pet_skill{
            id = 240108
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 8
            ,cost = [{mp,24}]
            ,exp = 256
            ,next_id = 240109
            ,script_id = 131000
            ,args = [17, 250]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加250<font color='#ffe100'>（下一级280）</font>点魔法">>
            ,n_args = []
        }
    };

get(240109) ->
    {ok, #pet_skill{
            id = 240109
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 9
            ,cost = [{mp,26}]
            ,exp = 512
            ,next_id = 240110
            ,script_id = 131000
            ,args = [18, 280]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加280<font color='#ffe100'>（下一级320）</font>点魔法">>
            ,n_args = []
        }
    };

get(240110) ->
    {ok, #pet_skill{
            id = 240110
            ,name = <<"低阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 1
            ,lev = 10
            ,cost = [{mp,30}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 131000
            ,args = [20, 320]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"20%几率给主人增加320点魔法">>
            ,n_args = []
        }
    };

get(240201) ->
    {ok, #pet_skill{
            id = 240201
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 1
            ,cost = [{mp,15}]
            ,exp = 4
            ,next_id = 240202
            ,script_id = 131000
            ,args = [10, 150]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加150<font color='#ffe100'>（下一级180）</font>点魔法">>
            ,n_args = []
        }
    };

get(240202) ->
    {ok, #pet_skill{
            id = 240202
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 2
            ,cost = [{mp,17}]
            ,exp = 8
            ,next_id = 240203
            ,script_id = 131000
            ,args = [11, 180]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加180<font color='#ffe100'>（下一级210）</font>点魔法">>
            ,n_args = []
        }
    };

get(240203) ->
    {ok, #pet_skill{
            id = 240203
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 3
            ,cost = [{mp,19}]
            ,exp = 16
            ,next_id = 240204
            ,script_id = 131000
            ,args = [12, 210]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加210<font color='#ffe100'>（下一级240）</font>点魔法">>
            ,n_args = []
        }
    };

get(240204) ->
    {ok, #pet_skill{
            id = 240204
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 4
            ,cost = [{mp,21}]
            ,exp = 32
            ,next_id = 240205
            ,script_id = 131000
            ,args = [13, 240]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加240<font color='#ffe100'>（下一级270）</font>点魔法">>
            ,n_args = []
        }
    };

get(240205) ->
    {ok, #pet_skill{
            id = 240205
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 5
            ,cost = [{mp,23}]
            ,exp = 64
            ,next_id = 240206
            ,script_id = 131000
            ,args = [14, 270]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加270<font color='#ffe100'>（下一级300）</font>点魔法">>
            ,n_args = []
        }
    };

get(240206) ->
    {ok, #pet_skill{
            id = 240206
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 6
            ,cost = [{mp,25}]
            ,exp = 128
            ,next_id = 240207
            ,script_id = 131000
            ,args = [15, 300]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加300<font color='#ffe100'>（下一级340）</font>点魔法">>
            ,n_args = []
        }
    };

get(240207) ->
    {ok, #pet_skill{
            id = 240207
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 7
            ,cost = [{mp,27}]
            ,exp = 256
            ,next_id = 240208
            ,script_id = 131000
            ,args = [16, 340]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加340<font color='#ffe100'>（下一级380）</font>点魔法">>
            ,n_args = []
        }
    };

get(240208) ->
    {ok, #pet_skill{
            id = 240208
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 8
            ,cost = [{mp,29}]
            ,exp = 512
            ,next_id = 240209
            ,script_id = 131000
            ,args = [17, 380]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加380<font color='#ffe100'>（下一级430）</font>点魔法">>
            ,n_args = []
        }
    };

get(240209) ->
    {ok, #pet_skill{
            id = 240209
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 9
            ,cost = [{mp,31}]
            ,exp = 1024
            ,next_id = 240210
            ,script_id = 131000
            ,args = [18, 430]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加430<font color='#ffe100'>（下一级480）</font>点魔法">>
            ,n_args = []
        }
    };

get(240210) ->
    {ok, #pet_skill{
            id = 240210
            ,name = <<"中阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 2
            ,lev = 10
            ,cost = [{mp,35}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 131000
            ,args = [20, 480]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"20%几率给主人增加480点魔法">>
            ,n_args = []
        }
    };

get(240301) ->
    {ok, #pet_skill{
            id = 240301
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 240302
            ,script_id = 131000
            ,args = [10, 200]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"10%<font color='#ffe100'>（下一级11%）</font>几率给主人增加200<font color='#ffe100'>（下一级250）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240302) ->
    {ok, #pet_skill{
            id = 240302
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 240303
            ,script_id = 131000
            ,args = [11, 250]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"11%<font color='#ffe100'>（下一级12%）</font>几率给主人增加250<font color='#ffe100'>（下一级300）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240303) ->
    {ok, #pet_skill{
            id = 240303
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 240304
            ,script_id = 131000
            ,args = [12, 300]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"12%<font color='#ffe100'>（下一级13%）</font>几率给主人增加300<font color='#ffe100'>（下一级350）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240304) ->
    {ok, #pet_skill{
            id = 240304
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 240305
            ,script_id = 131000
            ,args = [13, 350]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"13%<font color='#ffe100'>（下一级14%）</font>几率给主人增加350<font color='#ffe100'>（下一级400）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240305) ->
    {ok, #pet_skill{
            id = 240305
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 240306
            ,script_id = 131000
            ,args = [14, 400]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"14%<font color='#ffe100'>（下一级15%）</font>几率给主人增加400<font color='#ffe100'>（下一级460）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240306) ->
    {ok, #pet_skill{
            id = 240306
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 240307
            ,script_id = 131000
            ,args = [15, 460]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"15%<font color='#ffe100'>（下一级16%）</font>几率给主人增加460<font color='#ffe100'>（下一级520）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240307) ->
    {ok, #pet_skill{
            id = 240307
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 240308
            ,script_id = 131000
            ,args = [16, 520]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"16%<font color='#ffe100'>（下一级17%）</font>几率给主人增加520<font color='#ffe100'>（下一级580）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240308) ->
    {ok, #pet_skill{
            id = 240308
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 240309
            ,script_id = 131000
            ,args = [17, 580]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"17%<font color='#ffe100'>（下一级18%）</font>几率给主人增加580<font color='#ffe100'>（下一级650）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240309) ->
    {ok, #pet_skill{
            id = 240309
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 240310
            ,script_id = 131000
            ,args = [18, 650]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"18%<font color='#ffe100'>（下一级20%）</font>几率给主人增加650<font color='#ffe100'>（下一级720）</font>点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(240310) ->
    {ok, #pet_skill{
            id = 240310
            ,name = <<"高阶回魔">>
            ,mutex = 0
            ,type = 3
            ,step = 3
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 131000
            ,args = [20, 720]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"20%几率给主人增加720点魔法">>
            ,n_args = [{1, [4]},{2, [8]},{3, [12]},{4, [16]},{5, [20]},{6, [24]},{7, [28]},{8, [32]},{9, [36]},{10, [40]},{11, [44]},{12, [48]},{13, [52]},{14, [56]},{15, [60]},{16, [64]},{17, [68]},{18, [72]},{19, [76]},{20, [80]}]
        }
    };

get(250101) ->
    {ok, #pet_skill{
            id = 250101
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 250102
            ,script_id = 410000
            ,args = [14, 18]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有14%<font color='#ffe100'>（下一级16%）</font>几率减少18%<font color='#ffe100'>（下一级19%）</font>伤害">>
            ,n_args = []
        }
    };

get(250102) ->
    {ok, #pet_skill{
            id = 250102
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 250103
            ,script_id = 410000
            ,args = [16, 19]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有16%<font color='#ffe100'>（下一级18%）</font>几率减少19%<font color='#ffe100'>（下一级20%）</font>伤害">>
            ,n_args = []
        }
    };

get(250103) ->
    {ok, #pet_skill{
            id = 250103
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 250104
            ,script_id = 410000
            ,args = [18, 20]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有18%<font color='#ffe100'>（下一级20%）</font>几率减少20%<font color='#ffe100'>（下一级21%）</font>伤害">>
            ,n_args = []
        }
    };

get(250104) ->
    {ok, #pet_skill{
            id = 250104
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 250105
            ,script_id = 410000
            ,args = [20, 21]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有20%<font color='#ffe100'>（下一级22%）</font>几率减少21%<font color='#ffe100'>（下一级22%）</font>伤害">>
            ,n_args = []
        }
    };

get(250105) ->
    {ok, #pet_skill{
            id = 250105
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 250106
            ,script_id = 410000
            ,args = [22, 22]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有22%<font color='#ffe100'>（下一级24%）</font>几率减少22%<font color='#ffe100'>（下一级24%）</font>伤害">>
            ,n_args = []
        }
    };

get(250106) ->
    {ok, #pet_skill{
            id = 250106
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 250107
            ,script_id = 410000
            ,args = [24, 24]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有24%<font color='#ffe100'>（下一级26%）</font>几率减少24%<font color='#ffe100'>（下一级26%）</font>伤害">>
            ,n_args = []
        }
    };

get(250107) ->
    {ok, #pet_skill{
            id = 250107
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 250108
            ,script_id = 410000
            ,args = [26, 26]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有26%<font color='#ffe100'>（下一级28%）</font>几率减少26%<font color='#ffe100'>（下一级28%）</font>伤害">>
            ,n_args = []
        }
    };

get(250108) ->
    {ok, #pet_skill{
            id = 250108
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 250109
            ,script_id = 410000
            ,args = [28, 28]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有28%<font color='#ffe100'>（下一级30%）</font>几率减少28%<font color='#ffe100'>（下一级30%）</font>伤害">>
            ,n_args = []
        }
    };

get(250109) ->
    {ok, #pet_skill{
            id = 250109
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 250110
            ,script_id = 410000
            ,args = [30, 30]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有30%<font color='#ffe100'>（下一级32%）</font>几率减少30%<font color='#ffe100'>（下一级32%）</font>伤害">>
            ,n_args = []
        }
    };

get(250110) ->
    {ok, #pet_skill{
            id = 250110
            ,name = <<"招架">>
            ,mutex = 210000
            ,type = 2
            ,step = 4
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 410000
            ,args = [32, 32]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"受到伤害时有32%几率减少32%伤害">>
            ,n_args = []
        }
    };

get(260101) ->
    {ok, #pet_skill{
            id = 260101
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 1
            ,cost = [{mp,25}]
            ,exp = 8
            ,next_id = 260102
            ,script_id = 0
            ,args = [5]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加5<font color='#ffe100'>（下一级8）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260102) ->
    {ok, #pet_skill{
            id = 260102
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 2
            ,cost = [{mp,27}]
            ,exp = 16
            ,next_id = 260103
            ,script_id = 0
            ,args = [8]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加8<font color='#ffe100'>（下一级11）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260103) ->
    {ok, #pet_skill{
            id = 260103
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 3
            ,cost = [{mp,29}]
            ,exp = 32
            ,next_id = 260104
            ,script_id = 0
            ,args = [11]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加11<font color='#ffe100'>（下一级14）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260104) ->
    {ok, #pet_skill{
            id = 260104
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 4
            ,cost = [{mp,31}]
            ,exp = 64
            ,next_id = 260105
            ,script_id = 0
            ,args = [14]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加14<font color='#ffe100'>（下一级17）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260105) ->
    {ok, #pet_skill{
            id = 260105
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 5
            ,cost = [{mp,33}]
            ,exp = 128
            ,next_id = 260106
            ,script_id = 0
            ,args = [17]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加17<font color='#ffe100'>（下一级21）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260106) ->
    {ok, #pet_skill{
            id = 260106
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 6
            ,cost = [{mp,35}]
            ,exp = 256
            ,next_id = 260107
            ,script_id = 0
            ,args = [21]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加21<font color='#ffe100'>（下一级24）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260107) ->
    {ok, #pet_skill{
            id = 260107
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 7
            ,cost = [{mp,37}]
            ,exp = 512
            ,next_id = 260108
            ,script_id = 0
            ,args = [24]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加24<font color='#ffe100'>（下一级28）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260108) ->
    {ok, #pet_skill{
            id = 260108
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 8
            ,cost = [{mp,39}]
            ,exp = 1024
            ,next_id = 260109
            ,script_id = 0
            ,args = [28]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加28<font color='#ffe100'>（下一级32）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260109) ->
    {ok, #pet_skill{
            id = 260109
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 9
            ,cost = [{mp,41}]
            ,exp = 2048
            ,next_id = 260110
            ,script_id = 0
            ,args = [32]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加32<font color='#ffe100'>（下一级36）</font>点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(260110) ->
    {ok, #pet_skill{
            id = 260110
            ,name = <<"反击">>
            ,mutex = 0
            ,type = 4
            ,step = 1
            ,lev = 10
            ,cost = [{mp,45}]
            ,exp = 0
            ,next_id = 0
            ,script_id = 0
            ,args = [36]
            ,buff_self = []
            ,buff_target = []
            ,cd = 0
            ,desc = <<"伙伴增加36点反击值，反击值越高，伙伴反击概率越高">>
            ,n_args = []
        }
    };

get(_) ->
    {false, <<"无相关宠物技能数据">>}.
