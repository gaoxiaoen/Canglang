%%----------------------------------------------------
%% 预定义BUFF
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(pet_data_buff).
-export([
        get/1
        ,cover/1
        ,conflict/1
    ]
).
-include("pet.hrl").

%% 覆盖设定
cover(change_1) -> [change_1];
cover(change_2) -> [change_2];
cover(change_3) -> [change_3];
cover(change_4) -> [change_4];
cover(change_5) -> [change_5];
cover(hp1) -> [hp1];
cover(hp2) -> [hp1,hp2];
cover(hp3) -> [hp1,hp2,hp3];
cover(dmg1) -> [dmg1];
cover(dmg2) -> [dmg1,dmg2];
cover(dmg3) -> [dmg1,dmg2,dmg3];
cover(magic1) -> [magic1];
cover(magic2) -> [magic1,magic2];
cover(magic3) -> [magic1,magic2,magic3];
cover(resist1) -> [resist1];
cover(resist2) -> [resist1,resist2];
cover(resist3) -> [resist1,resist2,resist3];
cover(hitrate1) -> [hitrate1];
cover(hitrate2) -> [hitrate1,hitrate2];
cover(hitrate3) -> [hitrate1,hitrate2,hitrate3];
cover(anti_stun1) -> [anti_stun1];
cover(anti_stun2) -> [anti_stun1,anti_stun2];
cover(anti_stun3) -> [anti_stun1,anti_stun2,anti_stun3];
cover(anti_stone1) -> [anti_stone1];
cover(anti_stone2) -> [anti_stone1,anti_stone2];
cover(anti_stone3) -> [anti_stone1,anti_stone2,anti_stone3];
cover(anti_poison1) -> [anti_poison1];
cover(anti_poison2) -> [anti_poison1,anti_poison2];
cover(anti_poison3) -> [anti_poison1,anti_poison2,anti_poison3];
cover(anti_taunt1) -> [anti_taunt1];
cover(anti_taunt2) -> [anti_taunt1,anti_taunt2];
cover(anti_taunt3) -> [anti_taunt1,anti_taunt2,anti_taunt3];
cover(anti_sleep1) -> [anti_sleep1];
cover(anti_sleep2) -> [anti_sleep1,anti_sleep2];
cover(anti_sleep3) -> [anti_sleep1,anti_sleep2,anti_sleep3];
cover(anti_silent1) -> [anti_silent1];
cover(anti_silent2) -> [anti_silent1,anti_silent2];
cover(anti_silent3) -> [anti_silent1,anti_silent2,anti_silent3];
cover(_) -> [].

%%冲突设定
conflict(hp1) -> [hp2,hp3];
conflict(hp2) -> [hp3];
conflict(dmg1) -> [dmg2,dmg3];
conflict(dmg2) -> [dmg3];
conflict(magic1) -> [magic2,magic3];
conflict(magic2) -> [magic3];
conflict(resist1) -> [resist2,resist3];
conflict(resist2) -> [resist3];
conflict(hitrate1) -> [hitrate2,hitrate3];
conflict(hitrate2) -> [hitrate3];
conflict(anti_stun1) -> [anti_stun2,anti_stun3];
conflict(anti_stun2) -> [anti_stun3];
conflict(anti_stone1) -> [anti_stone2,anti_stone3];
conflict(anti_stone2) -> [anti_stone3];
conflict(anti_poison1) -> [anti_poison2,anti_poison3];
conflict(anti_poison2) -> [anti_poison3];
conflict(anti_taunt1) -> [anti_taunt2,anti_taunt3];
conflict(anti_taunt2) -> [anti_taunt3];
conflict(anti_sleep1) -> [anti_sleep2,anti_sleep3];
conflict(anti_sleep2) -> [anti_sleep3];
conflict(anti_silent1) -> [anti_silent2,anti_silent3];
conflict(anti_silent2) -> [anti_silent3];
conflict(_) -> [].

%% 预定义BUFF
get(change_1) ->
    {ok, #pet_buff{
    		label = change_1
            ,name = <<"镇妖塔仙宠变身卡">>
            ,baseid = 1
            ,icon = 10000
            ,multi = 3
            ,type = 2
            ,duration = 86400
            ,effect = [{buff_baseid, 124039}, {hp,5000},{dmg,200}]
            ,msg = <<"仙宠变身【镇妖塔】成功，\n攻击+200\n气血+5000\n效果持续一天">>
        }
    };
get(change_2) ->
    {ok, #pet_buff{
    		label = change_2
            ,name = <<"小蘑菇仙宠变身卡">>
            ,baseid = 2
            ,icon = 10001
            ,multi = 3
            ,type = 2
            ,duration = 86400
            ,effect = [{buff_baseid, 124042}, {hp,6000},{dmg_magic,200}]
            ,msg = <<"">>
        }
    };
get(change_3) ->
    {ok, #pet_buff{
    		label = change_3
            ,name = <<"瑞兽祝福">>
            ,baseid = 3
            ,icon = 10002
            ,multi = 3
            ,type = 1
            ,duration = 1800
            ,effect = [{buff_baseid, 124050}, {hp,10000},{dmg,2000}]
            ,msg = <<"">>
        }
    };
get(change_4) ->
    {ok, #pet_buff{
    		label = change_4
            ,name = <<"汤圆宝宝祝福">>
            ,baseid = 4
            ,icon = 10003
            ,multi = 3
            ,type = 1
            ,duration = 900
            ,effect = [{buff_baseid, 124052}, {hp,20000},{dmg,1000}]
            ,msg = <<"">>
        }
    };
get(change_5) ->
    {ok, #pet_buff{
    		label = change_5
            ,name = <<"小丑仙宠祝福">>
            ,baseid = 5
            ,icon = 10004
            ,multi = 3
            ,type = 1
            ,duration = 1800
            ,effect = [{buff_baseid, 124078}, {hp,5000},{dmg,800}]
            ,msg = <<"">>
        }
    };
get(hp1) ->
    {ok, #pet_buff{
    		label = hp1
            ,name = <<"初级仙宠气血药">>
            ,baseid = 100
            ,icon = 11000
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{hp,5000}]
            ,msg = <<"">>
        }
    };
get(hp2) ->
    {ok, #pet_buff{
    		label = hp2
            ,name = <<"中级仙宠气血药">>
            ,baseid = 101
            ,icon = 11001
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{hp,10000}]
            ,msg = <<"">>
        }
    };
get(hp3) ->
    {ok, #pet_buff{
    		label = hp3
            ,name = <<"高级仙宠气血药">>
            ,baseid = 102
            ,icon = 11002
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{hp,15000}]
            ,msg = <<"">>
        }
    };
get(dmg1) ->
    {ok, #pet_buff{
    		label = dmg1
            ,name = <<"初级仙宠攻击药">>
            ,baseid = 103
            ,icon = 11003
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{dmg,1000}]
            ,msg = <<"">>
        }
    };
get(dmg2) ->
    {ok, #pet_buff{
    		label = dmg2
            ,name = <<"中级仙宠攻击药">>
            ,baseid = 104
            ,icon = 11004
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{dmg,2000}]
            ,msg = <<"">>
        }
    };
get(dmg3) ->
    {ok, #pet_buff{
    		label = dmg3
            ,name = <<"高级仙宠攻击药">>
            ,baseid = 105
            ,icon = 11005
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{dmg,3000}]
            ,msg = <<"">>
        }
    };
get(magic1) ->
    {ok, #pet_buff{
    		label = magic1
            ,name = <<"初级仙宠法伤药">>
            ,baseid = 106
            ,icon = 11006
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{dmg_magic, 600}]
            ,msg = <<"">>
        }
    };
get(magic2) ->
    {ok, #pet_buff{
    		label = magic2
            ,name = <<"中级仙宠法伤药">>
            ,baseid = 107
            ,icon = 11007
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{dmg_magic, 1300}]
            ,msg = <<"">>
        }
    };
get(magic3) ->
    {ok, #pet_buff{
    		label = magic3
            ,name = <<"高级仙宠法伤药">>
            ,baseid = 108
            ,icon = 11008
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{dmg_magic, 2000}]
            ,msg = <<"">>
        }
    };
get(resist1) ->
    {ok, #pet_buff{
    		label = resist1
            ,name = <<"初级仙宠抗性药">>
            ,baseid = 109
            ,icon = 11009
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{resist_all, 1000}]
            ,msg = <<"">>
        }
    };
get(resist2) ->
    {ok, #pet_buff{
    		label = resist2
            ,name = <<"中级仙宠抗性药">>
            ,baseid = 110
            ,icon = 11010
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{resist_all, 2000}]
            ,msg = <<"">>
        }
    };
get(resist3) ->
    {ok, #pet_buff{
    		label = resist3
            ,name = <<"高级仙宠抗性药">>
            ,baseid = 111
            ,icon = 11011
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{resist_all, 3000}]
            ,msg = <<"">>
        }
    };
get(hitrate1) ->
    {ok, #pet_buff{
    		label = hitrate1
            ,name = <<"初级仙宠命中药">>
            ,baseid = 112
            ,icon = 11012
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{hitrate, 100}]
            ,msg = <<"">>
        }
    };
get(hitrate2) ->
    {ok, #pet_buff{
    		label = hitrate2
            ,name = <<"中级仙宠命中药">>
            ,baseid = 113
            ,icon = 11013
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{hitrate, 200}]
            ,msg = <<"">>
        }
    };
get(hitrate3) ->
    {ok, #pet_buff{
    		label = hitrate3
            ,name = <<"高级仙宠命中药">>
            ,baseid = 114
            ,icon = 11014
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{hitrate, 300}]
            ,msg = <<"">>
        }
    };
get(anti_stun1) ->
    {ok, #pet_buff{
    		label = anti_stun1
            ,name = <<"初级仙宠抗晕药">>
            ,baseid = 115
            ,icon = 11015
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_stun,80}]
            ,msg = <<"">>
        }
    };
get(anti_stun2) ->
    {ok, #pet_buff{
    		label = anti_stun2
            ,name = <<"中级仙宠抗晕药">>
            ,baseid = 116
            ,icon = 11016
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_stun,130}]
            ,msg = <<"">>
        }
    };
get(anti_stun3) ->
    {ok, #pet_buff{
    		label = anti_stun3
            ,name = <<"高级仙宠抗晕药">>
            ,baseid = 117
            ,icon = 11017
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_stun,200}]
            ,msg = <<"">>
        }
    };
get(anti_stone1) ->
    {ok, #pet_buff{
    		label = anti_stone1
            ,name = <<"初级仙宠抗石化药">>
            ,baseid = 118
            ,icon = 11018
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_stone,80}]
            ,msg = <<"">>
        }
    };
get(anti_stone2) ->
    {ok, #pet_buff{
    		label = anti_stone2
            ,name = <<"中级仙宠抗石化药">>
            ,baseid = 119
            ,icon = 11019
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_stone,130}]
            ,msg = <<"">>
        }
    };
get(anti_stone3) ->
    {ok, #pet_buff{
    		label = anti_stone3
            ,name = <<"高级仙宠抗石化药">>
            ,baseid = 120
            ,icon = 11020
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_stone,200}]
            ,msg = <<"">>
        }
    };
get(anti_poison1) ->
    {ok, #pet_buff{
    		label = anti_poison1
            ,name = <<"初级仙宠抗毒药">>
            ,baseid = 121
            ,icon = 11021
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_poison,80}]
            ,msg = <<"">>
        }
    };
get(anti_poison2) ->
    {ok, #pet_buff{
    		label = anti_poison2
            ,name = <<"中级仙宠抗毒药">>
            ,baseid = 122
            ,icon = 11022
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_poison,130}]
            ,msg = <<"">>
        }
    };
get(anti_poison3) ->
    {ok, #pet_buff{
    		label = anti_poison3
            ,name = <<"高级仙宠抗毒药">>
            ,baseid = 123
            ,icon = 11023
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_poison,200}]
            ,msg = <<"">>
        }
    };
get(anti_taunt1) ->
    {ok, #pet_buff{
    		label = anti_taunt1
            ,name = <<"初级仙宠抗嘲讽药">>
            ,baseid = 124
            ,icon = 11024
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_taunt,80}]
            ,msg = <<"">>
        }
    };
get(anti_taunt2) ->
    {ok, #pet_buff{
    		label = anti_taunt2
            ,name = <<"中级仙宠抗嘲讽药">>
            ,baseid = 125
            ,icon = 11025
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_taunt,130}]
            ,msg = <<"">>
        }
    };
get(anti_taunt3) ->
    {ok, #pet_buff{
    		label = anti_taunt3
            ,name = <<"高级仙宠抗嘲讽药">>
            ,baseid = 126
            ,icon = 11026
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_taunt,200}]
            ,msg = <<"">>
        }
    };
get(anti_sleep1) ->
    {ok, #pet_buff{
    		label = anti_sleep1
            ,name = <<"初级仙宠抗睡药">>
            ,baseid = 127
            ,icon = 11027
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_sleep,80}]
            ,msg = <<"">>
        }
    };
get(anti_sleep2) ->
    {ok, #pet_buff{
    		label = anti_sleep2
            ,name = <<"中级仙宠抗睡药">>
            ,baseid = 128
            ,icon = 11028
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_sleep,130}]
            ,msg = <<"">>
        }
    };
get(anti_sleep3) ->
    {ok, #pet_buff{
    		label = anti_sleep3
            ,name = <<"高级仙宠抗睡药">>
            ,baseid = 129
            ,icon = 11029
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_sleep,200}]
            ,msg = <<"">>
        }
    };
get(anti_silent1) ->
    {ok, #pet_buff{
    		label = anti_silent1
            ,name = <<"初级仙宠抗遗忘药">>
            ,baseid = 130
            ,icon = 11030
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_silent,80}]
            ,msg = <<"">>
        }
    };
get(anti_silent2) ->
    {ok, #pet_buff{
    		label = anti_silent2
            ,name = <<"中级仙宠抗遗忘药">>
            ,baseid = 131
            ,icon = 11031
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_silent,130}]
            ,msg = <<"">>
        }
    };
get(anti_silent3) ->
    {ok, #pet_buff{
    		label = anti_silent3
            ,name = <<"高级仙宠抗遗忘药">>
            ,baseid = 132
            ,icon = 11032
            ,multi = 3
            ,type = 1
            ,duration = 3600
            ,effect = [{anti_silent,200}]
            ,msg = <<"">>
        }
    };
get(_Code) ->
    {false, <<"不存在的宠物BUFF">>}.
