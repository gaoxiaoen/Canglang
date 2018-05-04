%%----------------------------------------------------
%% 宠物对话数据
%% @author lishen(105326073@qq.com)
%%----------------------------------------------------
-module(petspeak_data).
-export([
    get/1
    ,get_id_by_type/1
    ,get_custom/0
    ]
).

-include("pet.hrl").
-include("common.hrl").
%%


%% 获取同类型对话ID列表
get_id_by_type(1) -> [107000,107001,107002];
get_id_by_type(2) -> [101001,101005,101006,101007,101008,101009,101010,101011,101012];
get_id_by_type(3) -> [101003,101004];
get_id_by_type(4) -> [104000,104001,104002,104003];
get_id_by_type(5) -> [105000,105001,105002];
get_id_by_type(6) -> [102001];
get_id_by_type(7) -> [103000,103001,103002];
get_id_by_type(8) -> [102002,102003];
get_id_by_type(9) -> [106000,106000,106000,106000,106000,106000,106000,106000,106000,106000,106000];
get_id_by_type(10) -> [102000];
get_id_by_type(11) -> [100100,100101,100102,100103,100000,100001,100002,100003,100004,100050,100051];
get_id_by_type(12) -> [];
get_id_by_type(_) -> [].


%% 获取可自定义对话列表
get_custom() -> [107000,107001,100100,100101,100102,100103,100000,100001,100002,100003,100004,100050,101001].



%% 获取宠物对话数据
get(107000) ->
    {ok, 
        #pet_speak{
            id = 107000
            ,type = 1
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,combat_event,<<"=">>,1}]
            ,prob = 10
            ,condition_desc = language:get(<<"获得战斗胜利">>)
            ,content = language:get(<<"我家主人，果然是天下最最厉害的人。。。">>)
        }
    };
get(107001) ->
    {ok, 
        #pet_speak{
            id = 107001
            ,type = 1
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,combat_event,<<"=">>,2}]
            ,prob = 10
            ,condition_desc = language:get(<<"战斗遗憾失利">>)
            ,content = language:get(<<"哎，就只是差那么一点点。。。主人就赢了。。。">>)
        }
    };
get(100100) ->
    {ok, 
        #pet_speak{
            id = 100100
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,round,<<"=">>,1}]
            ,prob = 10
            ,condition_desc = language:get(<<"进入战斗第一回合">>)
            ,content = language:get(<<"我家主人是最棒的！">>)
        }
    };
get(100101) ->
    {ok, 
        #pet_speak{
            id = 100101
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,round,<<"=">>,2}]
            ,prob = 10
            ,condition_desc = language:get(<<"进入战斗第二回合">>)
            ,content = language:get(<<"主人加油，你会成为这个世界上最厉害的人。">>)
        }
    };
get(100102) ->
    {ok, 
        #pet_speak{
            id = 100102
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,round,<<"=">>,3}]
            ,prob = 10
            ,condition_desc = language:get(<<"进入战斗第三回合">>)
            ,content = language:get(<<"战斗貌似有点激烈了。。。。加油，加油！！！">>)
        }
    };
get(100103) ->
    {ok, 
        #pet_speak{
            id = 100103
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,round,<<"=">>,10}]
            ,prob = 10
            ,condition_desc = language:get(<<"进入战斗第十回合">>)
            ,content = language:get(<<"战斗很激烈，对手很厉害，主人加油！！！">>)
        }
    };
get(100000) ->
    {ok, 
        #pet_speak{
            id = 100000
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,buff,<<"=">>,200040}]
            ,prob = 10
            ,condition_desc = language:get(<<"主人被眩晕住">>)
            ,content = language:get(<<"可恶的，又晕我的主人，不能动了。">>)
        }
    };
get(100001) ->
    {ok, 
        #pet_speak{
            id = 100001
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,buff,<<"=">>,200050}]
            ,prob = 10
            ,condition_desc = language:get(<<"主人被被催眠了">>)
            ,content = language:get(<<"我主人今天有些困，先睡会拉。。">>)
        }
    };
get(100002) ->
    {ok, 
        #pet_speak{
            id = 100002
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,buff,<<"=">>,200060}]
            ,prob = 10
            ,condition_desc = language:get(<<"中了技能“遗忘”">>)
            ,content = language:get(<<"虽然只能普通攻击，但是不要小看我的攻击力。">>)
        }
    };
get(100003) ->
    {ok, 
        #pet_speak{
            id = 100003
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,buff,<<"=">>,200070}]
            ,prob = 10
            ,condition_desc = language:get(<<"主人被石化技能控制住">>)
            ,content = language:get(<<"主人被封住了。怕怕，还好，伤害会减少点。">>)
        }
    };
get(100004) ->
    {ok, 
        #pet_speak{
            id = 100004
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,buff,<<"=">>,200080}]
            ,prob = 10
            ,condition_desc = language:get(<<"主人被嘲讽中">>)
            ,content = language:get(<<"逼我打你？？你小心了">>)
        }
    };
get(100050) ->
    {ok, 
        #pet_speak{
            id = 100050
            ,type = 11
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,hp_per,<<"=<">>,20}]
            ,prob = 10
            ,condition_desc = language:get(<<"战斗中，主人气血低于20%">>)
            ,content = language:get(<<"主人，你快没有气血了。磕点药吧！">>)
        }
    };
get(100051) ->
    {ok, 
        #pet_speak{
            id = 100051
            ,type = 11
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,mp,<<"=<">>,200}]
            ,prob = 10
            ,condition_desc = language:get(<<"战斗中，主人法力少于200">>)
            ,content = language:get(<<"主人，你快没有法力了。补点吧。要不放不了强大的技能了哦！">>)
        }
    };
get(101001) ->
    {ok, 
        #pet_speak{
            id = 101001
            ,type = 2
            ,custom = 1
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,25021}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得了一个紫精魂">>)
            ,content = language:get(<<"主人，你背包里有紫精魂哦，这个是制作紫色装备的好材料。">>)
        }
    };
get(101003) ->
    {ok, 
        #pet_speak{
            id = 101003
            ,type = 3
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,quality,<<"=">>,4},{1,item_level,<<"=">>,50}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人装备了一件50级橙色装备">>)
            ,content = language:get(<<"听说，龙宫里面，有水月石，可以把50级以上的橙色装备变得更加厉害哦！">>)
        }
    };
get(101004) ->
    {ok, 
        #pet_speak{
            id = 101004
            ,type = 3
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,quality,<<"=">>,4}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人装备了一件橙色装备">>)
            ,content = language:get(<<"主人好厉害，居然搞到橙色的装备了。">>)
        }
    };
get(101005) ->
    {ok, 
        #pet_speak{
            id = 101005
            ,type = 2
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,22220}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得了一个普通水月石">>)
            ,content = language:get(<<"哇塞，好漂亮的水月石。可以合成精良的水月石哦！">>)
        }
    };
get(101006) ->
    {ok, 
        #pet_speak{
            id = 101006
            ,type = 2
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,22221}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得了一个精良水月石">>)
            ,content = language:get(<<"哇，漂亮，比普通水月石漂亮好多呢。还可以把50以上橙色装备变得更厉害！">>)
        }
    };
get(101007) ->
    {ok, 
        #pet_speak{
            id = 101007
            ,type = 2
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,22222}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得了一个优秀水月石">>)
            ,content = language:get(<<"天啊，主人，我们去买六合彩吧！！">>)
        }
    };
get(101008) ->
    {ok, 
        #pet_speak{
            id = 101008
            ,type = 2
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,22223}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得了一个完美水月石">>)
            ,content = language:get(<<"主人，你真是一个完美的人。运气与智慧集与一身。">>)
        }
    };
get(101009) ->
    {ok, 
        #pet_speak{
            id = 101009
            ,type = 2
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,22201}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得三级星辰石">>)
            ,content = language:get(<<"三级星辰石，可以合成四级的哦。星辰石可以把紫色装备变成厉害的橙色装备。">>)
        }
    };
get(101010) ->
    {ok, 
        #pet_speak{
            id = 101010
            ,type = 2
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,22202}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得四级星辰石">>)
            ,content = language:get(<<"哇嘎嘎，人家得三级星辰石，我的主人得四级！！">>)
        }
    };
get(101011) ->
    {ok, 
        #pet_speak{
            id = 101011
            ,type = 2
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,22203}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得五级星辰石">>)
            ,content = language:get(<<"嘘！！我不会告诉你，我的星辰石是五级的。。">>)
        }
    };
get(101012) ->
    {ok, 
        #pet_speak{
            id = 101012
            ,type = 2
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,item_id,<<"=">>,22204}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人获得六级星辰石">>)
            ,content = language:get(<<"啊！！！！怎么可以，只是六级。。。要是七级的就好了。。。">>)
        }
    };
get(102000) ->
    {ok, 
        #pet_speak{
            id = 102000
            ,type = 10
            ,custom = 0
            ,broadcast = 0
            ,condition = []
            ,prob = 100
            ,condition_desc = language:get(<<"仙宠口粮不足10点">>)
            ,content = language:get(<<"主人，我好饿哦。给我买点口粮吃吧。。。">>)
        }
    };
get(102001) ->
    {ok, 
        #pet_speak{
            id = 102001
            ,type = 6
            ,custom = 0
            ,broadcast = 0
            ,condition = [{2,level,<<">">>,1}]
            ,prob = 100
            ,condition_desc = language:get(<<"仙宠每次升级">>)
            ,content = language:get(<<"主人，我又升级了呢，记得多点带着我哦。跟在你后面我能很快升级。">>)
        }
    };
get(102002) ->
    {ok, 
        #pet_speak{
            id = 102002
            ,type = 8
            ,custom = 0
            ,broadcast = 0
            ,condition = [{2,fight_capacity,<<"=">>,1000}]
            ,prob = 100
            ,condition_desc = language:get(<<"仙宠战斗力提升到1000">>)
            ,content = language:get(<<"看吧，主人，我好牛的哇。">>)
        }
    };
get(102003) ->
    {ok, 
        #pet_speak{
            id = 102003
            ,type = 8
            ,custom = 0
            ,broadcast = 0
            ,condition = [{2,fight_capacity,<<"=">>,2000}]
            ,prob = 100
            ,condition_desc = language:get(<<"仙宠战斗力提升到2000">>)
            ,content = language:get(<<"主人，看我战斗力大大的超过你。。">>)
        }
    };
get(103000) ->
    {ok, 
        #pet_speak{
            id = 103000
            ,type = 7
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,fight_capacity,<<"=">>,1000}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人战斗力提升到1000">>)
            ,content = language:get(<<"1000战斗力了，不错哦主人。继续努力，集齐一套紫装会很厉害哦">>)
        }
    };
get(103001) ->
    {ok, 
        #pet_speak{
            id = 103001
            ,type = 7
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,fight_capacity,<<"=">>,2000}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人战斗力提升到2000">>)
            ,content = language:get(<<"2000战斗力，哇塞，主人别忘了我哦。我也要升战斗力">>)
        }
    };
get(103002) ->
    {ok, 
        #pet_speak{
            id = 103002
            ,type = 7
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,fight_capacity,<<"=">>,3000}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人战斗力提升到3000">>)
            ,content = language:get(<<"3000战斗力，哇塞，主人别忘了我哦。我也要升战斗力的！">>)
        }
    };
get(104000) ->
    {ok, 
        #pet_speak{
            id = 104000
            ,type = 4
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,map_id,<<"=">>,20003}]
            ,prob = 100
            ,condition_desc = language:get(<<"进入35副本">>)
            ,content = language:get(<<"主人，记得每天多来打副本哦。听说这里好多材料。">>)
        }
    };
get(104001) ->
    {ok, 
        #pet_speak{
            id = 104001
            ,type = 4
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,map_id,<<"=">>,20100}]
            ,prob = 100
            ,condition_desc = language:get(<<"进入镇妖塔">>)
            ,content = language:get(<<"星辰石可以把紫色装备变成闪闪发亮的橙色装备哦！">>)
        }
    };
get(104002) ->
    {ok, 
        #pet_speak{
            id = 104002
            ,type = 4
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,map_id,<<"=">>,20300}]
            ,prob = 100
            ,condition_desc = language:get(<<"进入龙宫">>)
            ,content = language:get(<<"这里有好多蓝蓝的水月石，可以把橙色的装备变得更加厉害呢！">>)
        }
    };
get(104003) ->
    {ok, 
        #pet_speak{
            id = 104003
            ,type = 4
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,map_id,<<"=">>,20004}]
            ,prob = 100
            ,condition_desc = language:get(<<"进入45副本">>)
            ,content = language:get(<<"听说这里的怪物好厉害，主人要注意了。">>)
        }
    };
get(105000) ->
    {ok, 
        #pet_speak{
            id = 105000
            ,type = 5
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,level,<<"=">>,52}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人升级到52级。">>)
            ,content = language:get(<<"主人。你升级到52了。那里有很多水月石呢。。。可以把橙色装备变得更加厉害。">>)
        }
    };
get(105001) ->
    {ok, 
        #pet_speak{
            id = 105001
            ,type = 5
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,level,<<"=">>,55}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人升级到55级">>)
            ,content = language:get(<<"55级，比我高级，呜呜！记得学55的超级厉害的大技能哦！">>)
        }
    };
get(105002) ->
    {ok, 
        #pet_speak{
            id = 105002
            ,type = 5
            ,custom = 0
            ,broadcast = 0
            ,condition = [{1,level,<<"=">>,40}]
            ,prob = 100
            ,condition_desc = language:get(<<"主人40级。">>)
            ,content = language:get(<<"继续努力升级哦！升级后，可以带我飞来飞去了。。。">>)
        }
    };
get(107002) ->
    {ok, 
        #pet_speak{
            id = 107002
            ,type = 1
            ,custom = 0
            ,broadcast = 1
            ,condition = [{1,combat_event,<<"=">>,3}]
            ,prob = 100
            ,condition_desc = language:get(<<"战斗中遇到宠物">>)
            ,content = language:get(<<"快快快，主人，捕捉这个宠物！那你就可以有好多可爱的宝宝了。虽然，我只想主人爱我一个。">>)
        }
    };
get(_Id) ->
    ?DEBUG("petspeak_data:get(Id) error! Id=~w", [_Id]),
    {false, ?L(<<"找不到该对话">>)}.
