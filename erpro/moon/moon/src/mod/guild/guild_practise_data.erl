%%----------------------------------------------------
%% 帮会历练数据
%% @author whjing2012@game.com
%%----------------------------------------------------
-module(guild_practise_data).
-export([
        list_luck/0
        ,get_luck/1
        ,list_task/0
        ,get_task/1
        ,get_reward/2
    ]
).

-include("condition.hrl").
-include("guild_practise.hrl").
-include("gain.hrl").

%% 所有帮会历练运势数据
list_luck() ->
   [1,2,3,4,5].

%% 获取帮会历练运势基础数据
get_luck(1) ->
    {ok, #guild_practise_luck{
            type = 1
            ,name = <<"运势平平">>
            ,rand = 50
            ,quality_list = [{0,39},{1,29},{2,19},{3,9},{4,4}]
        }
    };
    
get_luck(2) ->
    {ok, #guild_practise_luck{
            type = 2
            ,name = <<"小有运道">>
            ,rand = 25
            ,quality_list = [{0,19},{1,39},{2,29},{3,9},{4,4}]
        }
    };
    
get_luck(3) ->
    {ok, #guild_practise_luck{
            type = 3
            ,name = <<"大吉大利">>
            ,rand = 15
            ,quality_list = [{0,4},{1,19},{2,39},{3,29},{4,9}]
        }
    };
    
get_luck(4) ->
    {ok, #guild_practise_luck{
            type = 4
            ,name = <<"鸿运当头">>
            ,rand = 7
            ,quality_list = [{0,4},{1,9},{2,19},{3,39},{4,29}]
        }
    };
    
get_luck(5) ->
    {ok, #guild_practise_luck{
            type = 5
            ,name = <<"吉星高照">>
            ,rand = 3
            ,quality_list = [{0,4},{1,9},{2,19},{3,29},{4,39}]
        }
    };
    
get_luck(_Id) ->
    {false, <<"不存在此帮会历练运势数据">>}.

%% 所有帮会历练任务数据
list_task() ->
   [1,2,3,4,5,6,7,8,9,10,11,12,13,14,
15,16,17].

%% 获取帮会历练任务基础数据
get_task(1) ->
    {ok, #guild_practise_task{
            id = 1
            ,name = <<"赠送鲜花">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = special_event, target = 20017, target_value = 1}
            ]
            ,desc = <<"赠人玫瑰手有余香，给任意好友<font color='#ffff00'><u><a href='event:1'>赠送鲜花</a></u></font>鲜花1朵即可完成任务。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(2) ->
    {ok, #guild_practise_task{
            id = 2
            ,name = <<"护送佳人">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = acc_event, target = 104, target_value = 1}
            ]
            ,desc = <<"爱江山也爱美人，本日任务<font color='#ffff00'><u><a href='event:2'>护送</a></u></font>1次美女。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(3) ->
    {ok, #guild_practise_task{
            id = 3
            ,name = <<"除魔卫道">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = kill_elite_npc, target = 0, target_value = 1}
            ]
            ,desc = <<"斩妖除魔是仙修之己任，击杀1次<font color='#ffff00'><u><a href='event:3'>狂暴怪</a></u></font>即可完成本次试炼。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(4) ->
    {ok, #guild_practise_task{
            id = 4
            ,name = <<"帮会砥柱">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = finish_task_type, target = 5, target_value = 5}
            ]
            ,desc = <<"接取任务后再做完一轮<font color='#ffff00'><u><a href='event:4'>帮会任务</a></u></font>即可完成本次试炼。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(5) ->
    {ok, #guild_practise_task{
            id = 5
            ,name = <<"师门楷模">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = finish_task_type, target = 4, target_value = 10}
            ]
            ,desc = <<"接取任务后再做完一轮<font color='#ffff00'><u><a href='event:5'>师门任务</a></u></font>即可完成本次试炼。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(6) ->
    {ok, #guild_practise_task{
            id = 6
            ,name = <<"勇闯镇妖">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = kill_npc, target = 0, target_ext = [30054,24050], target_value = 1}
            ]
            ,desc = <<"镇妖塔的妖邪又蠢蠢欲动，击杀镇妖塔的<font color='#ffff00'><u><a href='event:6'>玄冰妖</a></u></font>即可完成试炼。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(7) ->
    {ok, #guild_practise_task{
            id = 7
            ,name = <<"仙法竞技">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = special_event, target = 20022, target_value = 1}
            ]
            ,desc = <<"参加并<font color='#ffff00'><u><a href='event:7'>仙法竞技</a></u></font>击败1名对手即可完成本日试炼。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(8) ->
    {ok, #guild_practise_task{
            id = 8
            ,name = <<"天道酬勤">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = acc_event, target = 115, target_value = 200}
            ]
            ,desc = <<"天道酬勤，只要你比别人更努力就一定能一骑绝尘。本日任务：<font color='#ffff00'><u><a href='event:8'>挂机杀怪</a></u></font>200次。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(9) ->
    {ok, #guild_practise_task{
            id = 9
            ,name = <<"生龙活虎">>
            ,rand = 0
            ,finish_cond = [
                #condition{label = acc_event, target = 116, target_value = 150}
            ]
            ,desc = <<"修仙者必须时刻保持充沛的精力，本日目标：接取任务后再获得<font color='#ffff00'><u><a href='event:9'>精力值</a></u></font>150点。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(10) ->
    {ok, #guild_practise_task{
            id = 10
            ,name = <<"爱宠相伴">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = acc_event, target = 113, target_value = 3}
            ]
            ,desc = <<"仙宠是修道者忠实的伙伴，快<font color='#ffff00'><u><a href='event:10'>喂养</a></u></font>（3次）您的仙宠吧。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(11) ->
    {ok, #guild_practise_task{
            id = 11
            ,name = <<"持家有道">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = buy_item_shop, target = 0, target_value = 1}
            ]
            ,desc = <<"购买也是一门学问，在<font color='#ffff00'><u><a href='event:11'>商城购买</a></u></font>1件非限购物品即可完成本日试炼。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(12) ->
    {ok, #guild_practise_task{
            id = 12
            ,name = <<"能工巧匠">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = acc_event, target = 118, target_value = 3}
            ]
            ,desc = <<"宝石不但好看而且妙用无穷，<font color='#ffff00'><u><a href='event:12'>合成</a></u></font>任意3个宝石相关物品即可完成本日任务。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(13) ->
    {ok, #guild_practise_task{
            id = 13
            ,name = <<"自力更生">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = acc_event, target = 117, target_value = 10}
            ]
            ,desc = <<"自己动手丰衣足食，在生产系统中<font color='#ffff00'><u><a href='event:13'>生产</a></u></font>10个物品即可完成本日任务。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(14) ->
    {ok, #guild_practise_task{
            id = 14
            ,name = <<"神兵玄甲">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = special_event, target = 1002, target_value = 1}
            ]
            ,desc = <<"工欲善其事必先利其器，<font color='#ffff00'><u><a href='event:14'>强化</a></u></font>防具或武器成功1次即可完成本日试炼。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(15) ->
    {ok, #guild_practise_task{
            id = 15
            ,name = <<"生财有道">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = kill_npc, target = 0, target_ext = [30075,30080,30085,30090,30101], target_value = 5}
            ]
            ,desc = <<"君子好财取之有道，听闻<font color='#ffff00'><u><a href='event:15'>洛水殿</a></u></font>是发家致富的好去处，快去看看吧。本日试炼：进入洛水殿击杀5次藏宝老人。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(16) ->
    {ok, #guild_practise_task{
            id = 16
            ,name = <<"惩恶扬善">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = acc_event, target = 119, target_value = 1}
            ]
            ,desc = <<"善有善报恶有恶报，快去看看<font color='#ffff00'><u><a href='event:16'>通缉榜</a></u></font>上还有哪些奸邪之辈还在逍遥法外吧。本日试炼：缉拿通缉榜上逃犯一名。">>
            ,accept_cond = [
                            ]
        }
    };
    
get_task(17) ->
    {ok, #guild_practise_task{
            id = 17
            ,name = <<"神人膜拜">>
            ,rand = 1
            ,finish_cond = [
                #condition{label = acc_event, target = 123, target_value = 1}
            ]
            ,desc = <<"无须多言，<font color='#ffff00'><u><a href='event:17'>跨服神人榜</a></u></font>上都是飞仙世界大拿级人物，没人能无视他们。本日试炼：去膜拜或鄙视1次跨服神人。">>
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 50}
            ]
        }
    };
    
get_task(_Id) ->
    {false, <<"不存在此帮会历练任务数据">>}.


%% 所有帮会历练奖励数据
%% 获取帮会历练奖励基础数据
get_reward(1, 0) ->
    {ok, #guild_practise_reward{
            task_id = 1
            ,task_name = <<"赠送鲜花">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29300, 1, 1]}
            ]
        }
    };
    
get_reward(1, 1) ->
    {ok, #guild_practise_reward{
            task_id = 1
            ,task_name = <<"赠送鲜花">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29301, 1, 1]}
            ]
        }
    };
    
get_reward(1, 2) ->
    {ok, #guild_practise_reward{
            task_id = 1
            ,task_name = <<"赠送鲜花">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29302, 1, 1]}
            ]
        }
    };
    
get_reward(1, 3) ->
    {ok, #guild_practise_reward{
            task_id = 1
            ,task_name = <<"赠送鲜花">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29303, 1, 1]}
            ]
        }
    };
    
get_reward(1, 4) ->
    {ok, #guild_practise_reward{
            task_id = 1
            ,task_name = <<"赠送鲜花">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29304, 1, 1]}
            ]
        }
    };
    
get_reward(2, 0) ->
    {ok, #guild_practise_reward{
            task_id = 2
            ,task_name = <<"护送佳人">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29305, 1, 1]}
            ]
        }
    };
    
get_reward(2, 1) ->
    {ok, #guild_practise_reward{
            task_id = 2
            ,task_name = <<"护送佳人">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29306, 1, 1]}
            ]
        }
    };
    
get_reward(2, 2) ->
    {ok, #guild_practise_reward{
            task_id = 2
            ,task_name = <<"护送佳人">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29307, 1, 1]}
            ]
        }
    };
    
get_reward(2, 3) ->
    {ok, #guild_practise_reward{
            task_id = 2
            ,task_name = <<"护送佳人">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29308, 1, 1]}
            ]
        }
    };
    
get_reward(2, 4) ->
    {ok, #guild_practise_reward{
            task_id = 2
            ,task_name = <<"护送佳人">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29309, 1, 1]}
            ]
        }
    };
    
get_reward(3, 0) ->
    {ok, #guild_practise_reward{
            task_id = 3
            ,task_name = <<"除魔卫道">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29310, 1, 1]}
            ]
        }
    };
    
get_reward(3, 1) ->
    {ok, #guild_practise_reward{
            task_id = 3
            ,task_name = <<"除魔卫道">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29311, 1, 1]}
            ]
        }
    };
    
get_reward(3, 2) ->
    {ok, #guild_practise_reward{
            task_id = 3
            ,task_name = <<"除魔卫道">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29312, 1, 1]}
            ]
        }
    };
    
get_reward(3, 3) ->
    {ok, #guild_practise_reward{
            task_id = 3
            ,task_name = <<"除魔卫道">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29313, 1, 1]}
            ]
        }
    };
    
get_reward(3, 4) ->
    {ok, #guild_practise_reward{
            task_id = 3
            ,task_name = <<"除魔卫道">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29314, 1, 1]}
            ]
        }
    };
    
get_reward(4, 0) ->
    {ok, #guild_practise_reward{
            task_id = 4
            ,task_name = <<"帮会支柱">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29315, 1, 1]}
            ]
        }
    };
    
get_reward(4, 1) ->
    {ok, #guild_practise_reward{
            task_id = 4
            ,task_name = <<"帮会支柱">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29316, 1, 1]}
            ]
        }
    };
    
get_reward(4, 2) ->
    {ok, #guild_practise_reward{
            task_id = 4
            ,task_name = <<"帮会支柱">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29317, 1, 1]}
            ]
        }
    };
    
get_reward(4, 3) ->
    {ok, #guild_practise_reward{
            task_id = 4
            ,task_name = <<"帮会支柱">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29318, 1, 1]}
            ]
        }
    };
    
get_reward(4, 4) ->
    {ok, #guild_practise_reward{
            task_id = 4
            ,task_name = <<"帮会支柱">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29319, 1, 1]}
            ]
        }
    };
    
get_reward(5, 0) ->
    {ok, #guild_practise_reward{
            task_id = 5
            ,task_name = <<"师门楷模">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29315, 1, 1]}
            ]
        }
    };
    
get_reward(5, 1) ->
    {ok, #guild_practise_reward{
            task_id = 5
            ,task_name = <<"师门楷模">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29316, 1, 1]}
            ]
        }
    };
    
get_reward(5, 2) ->
    {ok, #guild_practise_reward{
            task_id = 5
            ,task_name = <<"师门楷模">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29317, 1, 1]}
            ]
        }
    };
    
get_reward(5, 3) ->
    {ok, #guild_practise_reward{
            task_id = 5
            ,task_name = <<"师门楷模">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29318, 1, 1]}
            ]
        }
    };
    
get_reward(5, 4) ->
    {ok, #guild_practise_reward{
            task_id = 5
            ,task_name = <<"师门楷模">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29319, 1, 1]}
            ]
        }
    };
    
get_reward(6, 0) ->
    {ok, #guild_practise_reward{
            task_id = 6
            ,task_name = <<"勇闯镇妖">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29320, 1, 1]}
            ]
        }
    };
    
get_reward(6, 1) ->
    {ok, #guild_practise_reward{
            task_id = 6
            ,task_name = <<"勇闯镇妖">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29321, 1, 1]}
            ]
        }
    };
    
get_reward(6, 2) ->
    {ok, #guild_practise_reward{
            task_id = 6
            ,task_name = <<"勇闯镇妖">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29322, 1, 1]}
            ]
        }
    };
    
get_reward(6, 3) ->
    {ok, #guild_practise_reward{
            task_id = 6
            ,task_name = <<"勇闯镇妖">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29323, 1, 1]}
            ]
        }
    };
    
get_reward(6, 4) ->
    {ok, #guild_practise_reward{
            task_id = 6
            ,task_name = <<"勇闯镇妖">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29324, 1, 1]}
            ]
        }
    };
    
get_reward(7, 0) ->
    {ok, #guild_practise_reward{
            task_id = 7
            ,task_name = <<"仙法竞技">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29315, 1, 1]}
            ]
        }
    };
    
get_reward(7, 1) ->
    {ok, #guild_practise_reward{
            task_id = 7
            ,task_name = <<"仙法竞技">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29316, 1, 1]}
            ]
        }
    };
    
get_reward(7, 2) ->
    {ok, #guild_practise_reward{
            task_id = 7
            ,task_name = <<"仙法竞技">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29317, 1, 1]}
            ]
        }
    };
    
get_reward(7, 3) ->
    {ok, #guild_practise_reward{
            task_id = 7
            ,task_name = <<"仙法竞技">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29318, 1, 1]}
            ]
        }
    };
    
get_reward(7, 4) ->
    {ok, #guild_practise_reward{
            task_id = 7
            ,task_name = <<"仙法竞技">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29319, 1, 1]}
            ]
        }
    };
    
get_reward(8, 0) ->
    {ok, #guild_practise_reward{
            task_id = 8
            ,task_name = <<"天道酬勤">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29325, 1, 1]}
            ]
        }
    };
    
get_reward(8, 1) ->
    {ok, #guild_practise_reward{
            task_id = 8
            ,task_name = <<"天道酬勤">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29326, 1, 1]}
            ]
        }
    };
    
get_reward(8, 2) ->
    {ok, #guild_practise_reward{
            task_id = 8
            ,task_name = <<"天道酬勤">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29327, 1, 1]}
            ]
        }
    };
    
get_reward(8, 3) ->
    {ok, #guild_practise_reward{
            task_id = 8
            ,task_name = <<"天道酬勤">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29328, 1, 1]}
            ]
        }
    };
    
get_reward(8, 4) ->
    {ok, #guild_practise_reward{
            task_id = 8
            ,task_name = <<"天道酬勤">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29329, 1, 1]}
            ]
        }
    };
    
get_reward(9, 0) ->
    {ok, #guild_practise_reward{
            task_id = 9
            ,task_name = <<"生龙活虎">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29305, 1, 1]}
            ]
        }
    };
    
get_reward(9, 1) ->
    {ok, #guild_practise_reward{
            task_id = 9
            ,task_name = <<"生龙活虎">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29306, 1, 1]}
            ]
        }
    };
    
get_reward(9, 2) ->
    {ok, #guild_practise_reward{
            task_id = 9
            ,task_name = <<"生龙活虎">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29307, 1, 1]}
            ]
        }
    };
    
get_reward(9, 3) ->
    {ok, #guild_practise_reward{
            task_id = 9
            ,task_name = <<"生龙活虎">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29308, 1, 1]}
            ]
        }
    };
    
get_reward(9, 4) ->
    {ok, #guild_practise_reward{
            task_id = 9
            ,task_name = <<"生龙活虎">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29309, 1, 1]}
            ]
        }
    };
    
get_reward(10, 0) ->
    {ok, #guild_practise_reward{
            task_id = 10
            ,task_name = <<"爱宠相伴">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29330, 1, 1]}
            ]
        }
    };
    
get_reward(10, 1) ->
    {ok, #guild_practise_reward{
            task_id = 10
            ,task_name = <<"爱宠相伴">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29331, 1, 1]}
            ]
        }
    };
    
get_reward(10, 2) ->
    {ok, #guild_practise_reward{
            task_id = 10
            ,task_name = <<"爱宠相伴">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29332, 1, 1]}
            ]
        }
    };
    
get_reward(10, 3) ->
    {ok, #guild_practise_reward{
            task_id = 10
            ,task_name = <<"爱宠相伴">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29333, 1, 1]}
            ]
        }
    };
    
get_reward(10, 4) ->
    {ok, #guild_practise_reward{
            task_id = 10
            ,task_name = <<"爱宠相伴">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29334, 1, 1]}
            ]
        }
    };
    
get_reward(11, 0) ->
    {ok, #guild_practise_reward{
            task_id = 11
            ,task_name = <<"持家有道">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29305, 1, 1]}
            ]
        }
    };
    
get_reward(11, 1) ->
    {ok, #guild_practise_reward{
            task_id = 11
            ,task_name = <<"持家有道">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29306, 1, 1]}
            ]
        }
    };
    
get_reward(11, 2) ->
    {ok, #guild_practise_reward{
            task_id = 11
            ,task_name = <<"持家有道">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29307, 1, 1]}
            ]
        }
    };
    
get_reward(11, 3) ->
    {ok, #guild_practise_reward{
            task_id = 11
            ,task_name = <<"持家有道">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29308, 1, 1]}
            ]
        }
    };
    
get_reward(11, 4) ->
    {ok, #guild_practise_reward{
            task_id = 11
            ,task_name = <<"持家有道">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29309, 1, 1]}
            ]
        }
    };
    
get_reward(12, 0) ->
    {ok, #guild_practise_reward{
            task_id = 12
            ,task_name = <<"能工巧匠">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29335, 1, 1]}
            ]
        }
    };
    
get_reward(12, 1) ->
    {ok, #guild_practise_reward{
            task_id = 12
            ,task_name = <<"能工巧匠">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29336, 1, 1]}
            ]
        }
    };
    
get_reward(12, 2) ->
    {ok, #guild_practise_reward{
            task_id = 12
            ,task_name = <<"能工巧匠">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29337, 1, 1]}
            ]
        }
    };
    
get_reward(12, 3) ->
    {ok, #guild_practise_reward{
            task_id = 12
            ,task_name = <<"能工巧匠">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29338, 1, 1]}
            ]
        }
    };
    
get_reward(12, 4) ->
    {ok, #guild_practise_reward{
            task_id = 12
            ,task_name = <<"能工巧匠">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29339, 1, 1]}
            ]
        }
    };
    
get_reward(13, 0) ->
    {ok, #guild_practise_reward{
            task_id = 13
            ,task_name = <<"仁心妙手">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29340, 1, 1]}
            ]
        }
    };
    
get_reward(13, 1) ->
    {ok, #guild_practise_reward{
            task_id = 13
            ,task_name = <<"仁心妙手">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29341, 1, 1]}
            ]
        }
    };
    
get_reward(13, 2) ->
    {ok, #guild_practise_reward{
            task_id = 13
            ,task_name = <<"仁心妙手">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29342, 1, 1]}
            ]
        }
    };
    
get_reward(13, 3) ->
    {ok, #guild_practise_reward{
            task_id = 13
            ,task_name = <<"仁心妙手">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29343, 1, 1]}
            ]
        }
    };
    
get_reward(13, 4) ->
    {ok, #guild_practise_reward{
            task_id = 13
            ,task_name = <<"仁心妙手">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29344, 1, 1]}
            ]
        }
    };
    
get_reward(14, 0) ->
    {ok, #guild_practise_reward{
            task_id = 14
            ,task_name = <<"神兵玄甲">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29345, 1, 1]}
            ]
        }
    };
    
get_reward(14, 1) ->
    {ok, #guild_practise_reward{
            task_id = 14
            ,task_name = <<"神兵玄甲">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29346, 1, 1]}
            ]
        }
    };
    
get_reward(14, 2) ->
    {ok, #guild_practise_reward{
            task_id = 14
            ,task_name = <<"神兵玄甲">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29347, 1, 1]}
            ]
        }
    };
    
get_reward(14, 3) ->
    {ok, #guild_practise_reward{
            task_id = 14
            ,task_name = <<"神兵玄甲">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29348, 1, 1]}
            ]
        }
    };
    
get_reward(14, 4) ->
    {ok, #guild_practise_reward{
            task_id = 14
            ,task_name = <<"神兵玄甲">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29349, 1, 1]}
            ]
        }
    };
    
get_reward(15, 0) ->
    {ok, #guild_practise_reward{
            task_id = 15
            ,task_name = <<"生财有道">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29305, 1, 1]}
            ]
        }
    };
    
get_reward(15, 1) ->
    {ok, #guild_practise_reward{
            task_id = 15
            ,task_name = <<"生财有道">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29306, 1, 1]}
            ]
        }
    };
    
get_reward(15, 2) ->
    {ok, #guild_practise_reward{
            task_id = 15
            ,task_name = <<"生财有道">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29307, 1, 1]}
            ]
        }
    };
    
get_reward(15, 3) ->
    {ok, #guild_practise_reward{
            task_id = 15
            ,task_name = <<"生财有道">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29308, 1, 1]}
            ]
        }
    };
    
get_reward(15, 4) ->
    {ok, #guild_practise_reward{
            task_id = 15
            ,task_name = <<"生财有道">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29309, 1, 1]}
            ]
        }
    };
    
get_reward(16, 0) ->
    {ok, #guild_practise_reward{
            task_id = 16
            ,task_name = <<"惩恶扬善">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29305, 1, 1]}
            ]
        }
    };
    
get_reward(16, 1) ->
    {ok, #guild_practise_reward{
            task_id = 16
            ,task_name = <<"惩恶扬善">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29306, 1, 1]}
            ]
        }
    };
    
get_reward(16, 2) ->
    {ok, #guild_practise_reward{
            task_id = 16
            ,task_name = <<"惩恶扬善">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29307, 1, 1]}
            ]
        }
    };
    
get_reward(16, 3) ->
    {ok, #guild_practise_reward{
            task_id = 16
            ,task_name = <<"惩恶扬善">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29308, 1, 1]}
            ]
        }
    };
    
get_reward(16, 4) ->
    {ok, #guild_practise_reward{
            task_id = 16
            ,task_name = <<"惩恶扬善">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29309, 1, 1]}
            ]
        }
    };
    
get_reward(17, 0) ->
    {ok, #guild_practise_reward{
            task_id = 17
            ,task_name = <<"神人膜拜">>
            ,quality = 0
            ,rewards = [
                #gain{label = item, val = [29305, 1, 1]}
            ]
        }
    };
    
get_reward(17, 1) ->
    {ok, #guild_practise_reward{
            task_id = 17
            ,task_name = <<"神人膜拜">>
            ,quality = 1
            ,rewards = [
                #gain{label = item, val = [29306, 1, 1]}
            ]
        }
    };
    
get_reward(17, 2) ->
    {ok, #guild_practise_reward{
            task_id = 17
            ,task_name = <<"神人膜拜">>
            ,quality = 2
            ,rewards = [
                #gain{label = item, val = [29307, 1, 1]}
            ]
        }
    };
    
get_reward(17, 3) ->
    {ok, #guild_practise_reward{
            task_id = 17
            ,task_name = <<"神人膜拜">>
            ,quality = 3
            ,rewards = [
                #gain{label = item, val = [29308, 1, 1]}
            ]
        }
    };
    
get_reward(17, 4) ->
    {ok, #guild_practise_reward{
            task_id = 17
            ,task_name = <<"神人膜拜">>
            ,quality = 4
            ,rewards = [
                #gain{label = item, val = [29309, 1, 1]}
            ]
        }
    };
    
get_reward(_, _) ->
    {false, <<"不存在此帮会历练奖励数据">>}.
