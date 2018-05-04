%% *********************
%% 奖励系统数据
%% *********************
-module(award_data).
-export([
    get/1
]).
-include("common.hrl").
-include("gain.hrl").
-include("award.hrl").

%% -> undefined -> [#gain{}]
%% 守城伐龙 
%% 伐龙的最强先锋，我们崇拜你！ 
get(101000) ->
    #base_award{
        id = 101000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"伐龙的最强先锋，我们崇拜你！">>,
        gains = [
			#gain{label = scale, val = 300} 
        ],   %% 奖励内容 
        limit = 8    %% 同类型奖励保留数量
    };

%% 守城伐龙 
%% 你对恶龙的最终击杀太帅了！ 
get(101001) ->
    #base_award{
        id = 101001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"你对恶龙的最终击杀太帅了！">>,
        gains = [
			#gain{label = scale, val = 100} 
        ],   %% 奖励内容 
        limit = 8    %% 同类型奖励保留数量
    };

%% 守城伐龙 
%% 这是你迎击巨龙的收获，请收好。 
get(101002) ->
    #base_award{
        id = 101002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"这是你迎击巨龙的收获，请收好。">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 8    %% 同类型奖励保留数量
    };

%% 缉猎海盗 
%% 这是被你击杀的海盗掉落的物品！ 
get(102000) ->
    #base_award{
        id = 102000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"这是被你击杀的海盗掉落的物品！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 8    %% 同类型奖励保留数量
    };

%% 缉猎海盗 
%% 居然在海盗那能偷到宝藏！ 
get(102001) ->
    #base_award{
        id = 102001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"居然在海盗那能偷到宝藏！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 8    %% 同类型奖励保留数量
    };

%% 缉猎海盗 
%% 这是你做海盗的时候掠夺的宝藏！ 
get(102002) ->
    #base_award{
        id = 102002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"这是你做海盗的时候掠夺的宝藏！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 8    %% 同类型奖励保留数量
    };

%% 缉猎海盗 
%% 海盗的宝藏统统被你缴获了！ 
get(102003) ->
    #base_award{
        id = 102003,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"海盗的宝藏统统被你缴获了！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 8    %% 同类型奖励保留数量
    };

%% 缉猎海盗 
%% 在与海盗一战中你成功瓜分了宝藏！ 
get(102004) ->
    #base_award{
        id = 102004,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"在与海盗一战中你成功瓜分了宝藏！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 8    %% 同类型奖励保留数量
    };

%% 缉猎海盗 
%% 这是你积极参与缉拿海盗的奖励 
get(102005) ->
    #base_award{
        id = 102005,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"这是你积极参与缉拿海盗的奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 10    %% 同类型奖励保留数量
    };

%% 世界树 
%% 在世界树捡到的物品 
get(103000) ->
    #base_award{
        id = 103000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"在世界树捡到的物品">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 200    %% 同类型奖励保留数量
    };

%% 世界树 
%% 昨天遗留在世界树的物品 
get(103001) ->
    #base_award{
        id = 103001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"昨天遗留在世界树的物品">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 10    %% 同类型奖励保留数量
    };

%% 副本奖励 
%% 副本结算奖励 
get(104000) ->
    #base_award{
        id = 104000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"副本结算奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 普通副本 
%% 普通副本结算奖励 
get(104001) ->
    #base_award{
        id = 104001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"普通副本结算奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 高级副本 
%% 高级副本结算奖励 
get(104002) ->
    #base_award{
        id = 104002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"高级副本结算奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 隐藏副本 
%% 隐藏副本结算奖励 
get(104003) ->
    #base_award{
        id = 104003,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"隐藏副本结算奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 副本扫荡 
%% 扫荡副本掉落的物品 
get(104005) ->
    #base_award{
        id = 104005,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"扫荡副本掉落的物品">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 50    %% 同类型奖励保留数量
    };

%% 副本奖励 
%% 副本的翻牌奖励 
get(104006) ->
    #base_award{
        id = 104006,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"副本的翻牌奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 10    %% 同类型奖励保留数量
    };

%% 星数礼包 
%% 副本蓝星集满的奖励 
get(104007) ->
    #base_award{
        id = 104007,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"副本蓝星集满的奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 10    %% 同类型奖励保留数量
    };

%% 星数礼包 
%% 副本紫星集满的奖励 
get(104008) ->
    #base_award{
        id = 104008,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"副本紫星集满的奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 10    %% 同类型奖励保留数量
    };

%% 副本奖励 
%% 副本内打怪的掉落 
get(104009) ->
    #base_award{
        id = 104009,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"副本内打怪的掉落">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 30    %% 同类型奖励保留数量
    };

%% 中庭战神 
%% 连胜榜奖励 
get(106000) ->
    #base_award{
        id = 106000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"连胜榜奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 10    %% 同类型奖励保留数量
    };

%% 中庭战神 
%% 每日排行奖励 
get(106001) ->
    #base_award{
        id = 106001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"每日排行奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 30    %% 同类型奖励保留数量
    };

%% 怪物掉落 
%% 从怪物身上掉落的物品 
get(107000) ->
    #base_award{
        id = 107000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"从怪物身上掉落的物品">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 远征王军 
%% 从怪物身上掉落的物品 
get(108000) ->
    #base_award{
        id = 108000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"从怪物身上掉落的物品">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 远征王军 
%% 副本结算奖励 
get(108001) ->
    #base_award{
        id = 108001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"副本结算奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 远征王军 
%% 副本翻牌获得的物品 
get(108002) ->
    #base_award{
        id = 108002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"副本翻牌获得的物品">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 匹配竞技场 
%% 荣誉榜第1名奖励 
get(109001) ->
    #base_award{
        id = 109001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"荣誉榜第1名奖励">>,
        gains = [
			#gain{label = honor, val = 10},
			#gain{label = badge, val = 10} 
        ],   %% 奖励内容 
        limit = 3    %% 同类型奖励保留数量
    };

%% 匹配竞技场 
%% 荣誉榜第2名奖励 
get(109002) ->
    #base_award{
        id = 109002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"荣誉榜第2名奖励">>,
        gains = [
			#gain{label = honor, val = 10},
			#gain{label = badge, val = 10} 
        ],   %% 奖励内容 
        limit = 3    %% 同类型奖励保留数量
    };

%% 匹配竞技场 
%% 荣誉榜第3名奖励 
get(109003) ->
    #base_award{
        id = 109003,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"荣誉榜第3名奖励">>,
        gains = [
			#gain{label = honor, val = 10},
			#gain{label = badge, val = 10} 
        ],   %% 奖励内容 
        limit = 3    %% 同类型奖励保留数量
    };

%% 匹配竞技场 
%% 荣誉榜第4-10名奖励 
get(109004) ->
    #base_award{
        id = 109004,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"荣誉榜第4-10名奖励">>,
        gains = [
			#gain{label = honor, val = 10},
			#gain{label = badge, val = 10} 
        ],   %% 奖励内容 
        limit = 3    %% 同类型奖励保留数量
    };

%% 匹配竞技场 
%% 荣誉榜第11-20名奖励 
get(109005) ->
    #base_award{
        id = 109005,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"荣誉榜第11-20名奖励">>,
        gains = [
			#gain{label = honor, val = 10},
			#gain{label = badge, val = 10} 
        ],   %% 奖励内容 
        limit = 3    %% 同类型奖励保留数量
    };

%% 匹配竞技场 
%% 荣誉榜第21-30名奖励 
get(109006) ->
    #base_award{
        id = 109006,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"荣誉榜第21-30名奖励">>,
        gains = [
			#gain{label = honor, val = 10},
			#gain{label = badge, val = 10} 
        ],   %% 奖励内容 
        limit = 3    %% 同类型奖励保留数量
    };

%% 匹配竞技场 
%% 今日完成10次匹配竞技奖励 
get(109007) ->
    #base_award{
        id = 109007,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"今日完成10次匹配竞技奖励">>,
        gains = [
			#gain{label = honor, val = 10},
			#gain{label = badge, val = 10} 
        ],   %% 奖励内容 
        limit = 3    %% 同类型奖励保留数量
    };

%% 匹配竞技场 
%% 匹配竞技补偿奖励 
get(109008) ->
    #base_award{
        id = 109008,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"匹配竞技补偿奖励">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 3    %% 同类型奖励保留数量
    };

%% 雪山地牢 
%% 怪物掉落 
get(110001) ->
    #base_award{
        id = 110001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"怪物掉落">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 200    %% 同类型奖励保留数量
    };

%% 活动结算 
%% 您在活动中没有及时领取的奖励！ 
get(111000) ->
    #base_award{
        id = 111000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"您在活动中没有及时领取的奖励！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 10    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位战力4500的人！ 
get(201001) ->
    #base_award{
        id = 201001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位战力4500的人！">>,
        gains = [
			#gain{label = item, val = [111301, ?true, 20]},
			#gain{label = item, val = [131001, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位战力9000的人！ 
get(201002) ->
    #base_award{
        id = 201002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位战力9000的人！">>,
        gains = [
			#gain{label = item, val = [111301, ?true, 30]},
			#gain{label = item, val = [131001, ?true, 20]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位战力15000的人！ 
get(201003) ->
    #base_award{
        id = 201003,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位战力15000的人！">>,
        gains = [
			#gain{label = item, val = [111301, ?true, 40]},
			#gain{label = item, val = [111001, ?true, 50]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位战力30000的人！ 
get(201004) ->
    #base_award{
        id = 201004,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位战力30000的人！">>,
        gains = [
			#gain{label = item, val = [111301, ?true, 50]},
			#gain{label = item, val = [131001, ?true, 40]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身神觉等级20的人！ 
get(201005) ->
    #base_award{
        id = 201005,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身神觉等级20的人！">>,
        gains = [
			#gain{label = item, val = [231001, ?true, 20]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身神觉等级40的人！ 
get(201006) ->
    #base_award{
        id = 201006,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身神觉等级40的人！">>,
        gains = [
			#gain{label = item, val = [231002, ?true, 20]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身神觉强化+30的人！ 
get(201007) ->
    #base_award{
        id = 201007,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身神觉强化+30的人！">>,
        gains = [
			#gain{label = item, val = [231001, ?true, 40]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身神觉强化+50的人！ 
get(201008) ->
    #base_award{
        id = 201008,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身神觉强化+50的人！">>,
        gains = [
			#gain{label = item, val = [231002, ?true, 40]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身蓝装的人！ 
get(201009) ->
    #base_award{
        id = 201009,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身蓝装的人！">>,
        gains = [
			#gain{label = item, val = [111102, ?true, 20]},
			#gain{label = item, val = [221102, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身紫装的人！ 
get(201010) ->
    #base_award{
        id = 201010,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身紫装的人！">>,
        gains = [
			#gain{label = item, val = [111103, ?true, 20]},
			#gain{label = item, val = [221102, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身粉装的人！ 
get(201011) ->
    #base_award{
        id = 201011,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身粉装的人！">>,
        gains = [
			#gain{label = item, val = [111104, ?true, 20]},
			#gain{label = item, val = [221102, ?true, 20]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身橙装的人！ 
get(201012) ->
    #base_award{
        id = 201012,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身橙装的人！">>,
        gains = [
			#gain{label = item, val = [111105, ?true, 20]},
			#gain{label = item, val = [221102, ?true, 20]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身装备强化+30的人！ 
get(201013) ->
    #base_award{
        id = 201013,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身装备强化+30的人！">>,
        gains = [
			#gain{label = item, val = [111001, ?true, 75]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身装备强化+60的人！ 
get(201014) ->
    #base_award{
        id = 201014,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身装备强化+60的人！">>,
        gains = [
			#gain{label = item, val = [111001, ?true, 150]},
			#gain{label = item, val = [221101, ?true, 20]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身镶嵌3级宝石的人！ 
get(201015) ->
    #base_award{
        id = 201015,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身镶嵌3级宝石的人！">>,
        gains = [
			#gain{label = item, val = [111274, ?true, 2]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位全身镶嵌6级宝石的人！ 
get(201016) ->
    #base_award{
        id = 201016,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位全身镶嵌6级宝石的人！">>,
        gains = [
			#gain{label = item, val = [111277, ?true, 2]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伙伴战力2000的人！ 
get(201017) ->
    #base_award{
        id = 201017,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伙伴战力2000的人！">>,
        gains = [
			#gain{label = item, val = [621101, ?true, 10]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伙伴战力5000的人！ 
get(201018) ->
    #base_award{
        id = 201018,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伙伴战力5000的人！">>,
        gains = [
			#gain{label = item, val = [621101, ?true, 20]},
			#gain{label = item, val = [221101, ?true, 40]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伙伴技能高阶4级的人！ 
get(201019) ->
    #base_award{
        id = 201019,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伙伴技能高阶4级的人！">>,
        gains = [
			#gain{label = item, val = [621501, ?true, 15]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伙伴技能高阶8级的人！ 
get(201020) ->
    #base_award{
        id = 201020,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伙伴技能高阶8级的人！">>,
        gains = [
			#gain{label = item, val = [621502, ?true, 15]},
			#gain{label = item, val = [221101, ?true, 20]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伙伴平均潜力100的人！ 
get(201021) ->
    #base_award{
        id = 201021,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伙伴平均潜力100的人！">>,
        gains = [
			#gain{label = item, val = [621101, ?true, 10]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伙伴平均潜力200的人！ 
get(201022) ->
    #base_award{
        id = 201022,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伙伴平均潜力200的人！">>,
        gains = [
			#gain{label = item, val = [621101, ?true, 20]},
			#gain{label = item, val = [221101, ?true, 20]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伙伴平均潜力300的人！ 
get(201023) ->
    #base_award{
        id = 201023,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伙伴平均潜力300的人！">>,
        gains = [
			#gain{label = item, val = [621101, ?true, 30]},
			#gain{label = item, val = [221101, ?true, 30]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伙伴平均潜力500的人！ 
get(201024) ->
    #base_award{
        id = 201024,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伙伴平均潜力500的人！">>,
        gains = [
			#gain{label = item, val = [621101, ?true, 50]},
			#gain{label = item, val = [221101, ?true, 50]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伤害恶龙50万的人！ 
get(201025) ->
    #base_award{
        id = 201025,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伤害恶龙50万的人！">>,
        gains = [
			#gain{label = item, val = [621100, ?true, 100]},
			#gain{label = item, val = [221102, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位伤害恶龙100万的人！ 
get(201026) ->
    #base_award{
        id = 201026,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位伤害恶龙100万的人！">>,
        gains = [
			#gain{label = item, val = [621100, ?true, 250]},
			#gain{label = item, val = [221102, ?true, 20]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位击杀鼠海盗的人！ 
get(201027) ->
    #base_award{
        id = 201027,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位击杀鼠海盗的人！">>,
        gains = [
			#gain{label = item, val = [111301, ?true, 30]},
			#gain{label = item, val = [221102, ?true, 20]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位击杀维京海盗的人！ 
get(201028) ->
    #base_award{
        id = 201028,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位击杀维京海盗的人！">>,
        gains = [
			#gain{label = item, val = [111301, ?true, 40]},
			#gain{label = item, val = [221102, ?true, 60]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位世界树30层的人！ 
get(201029) ->
    #base_award{
        id = 201029,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位世界树30层的人！">>,
        gains = [
			#gain{label = item, val = [111101, ?true, 10]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位世界树50层的人！ 
get(201030) ->
    #base_award{
        id = 201030,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位世界树50层的人！">>,
        gains = [
			#gain{label = item, val = [111102, ?true, 10]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位世界树80层的人！ 
get(201031) ->
    #base_award{
        id = 201031,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位世界树80层的人！">>,
        gains = [
			#gain{label = item, val = [111103, ?true, 10]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 编年奖酬 
%% 恭喜你成为第一位世界树100层的人！ 
get(201032) ->
    #base_award{
        id = 201032,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你成为第一位世界树100层的人！">>,
        gains = [
			#gain{label = item, val = [111104, ?true, 10]},
			#gain{label = item, val = [221101, ?true, 10]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 庄园 
%% 背包装不下的魔药，请收好。 
get(202000) ->
    #base_award{
        id = 202000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"背包装不下的魔药，请收好。">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 庄园 
%% 背包装不下的宝石，请收好。 
get(202001) ->
    #base_award{
        id = 202001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"背包装不下的宝石，请收好。">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 试炼场 
%% 恭喜你获得试炼场礼包！ 
get(203000) ->
    #base_award{
        id = 203000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你获得试炼场礼包！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 契约礼包 
%% 恭喜你获得初级契约礼包！ 
get(204000) ->
    #base_award{
        id = 204000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你获得初级契约礼包！">>,
        gains = [
			#gain{label = item, val = [532511, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 契约礼包 
%% 恭喜你获得中级契约礼包！ 
get(204001) ->
    #base_award{
        id = 204001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你获得中级契约礼包！">>,
        gains = [
			#gain{label = item, val = [532512, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 契约礼包 
%% 恭喜你获得高级契约礼包！ 
get(204002) ->
    #base_award{
        id = 204002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你获得高级契约礼包！">>,
        gains = [
			#gain{label = item, val = [532513, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 神秘来信 
%% 您在神秘来信的付费取件，请验收~ 
get(205000) ->
    #base_award{
        id = 205000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"您在神秘来信的付费取件，请验收~">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 交易所 
%% 您在交易所收购的物品！ 
get(206000) ->
    #base_award{
        id = 206000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"您在交易所收购的物品！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 100    %% 同类型奖励保留数量
    };

%% 神秘洞穴 
%% 在神秘洞穴捡到的东西 
get(207000) ->
    #base_award{
        id = 207000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"在神秘洞穴捡到的东西">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 100    %% 同类型奖励保留数量
    };

%% 日常任务 
%% 其他人接受了委托信件给予的报酬 
get(208000) ->
    #base_award{
        id = 208000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"其他人接受了委托信件给予的报酬">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 100    %% 同类型奖励保留数量
    };

%% 刮刮乐 
%% 在刮刮乐里刮出来的好东西 
get(209000) ->
    #base_award{
        id = 209000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"在刮刮乐里刮出来的好东西">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 100    %% 同类型奖励保留数量
    };

%% 封测福利 
%% 封测福利 
get(301000) ->
    #base_award{
        id = 301000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"封测福利">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 100    %% 同类型奖励保留数量
    };

%% 签到奖励 
%% 恭喜你获得签到奖励！ 
get(302001) ->
    #base_award{
        id = 302001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你获得签到奖励！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 10    %% 同类型奖励保留数量
    };

%% 活跃奖励 
%% 这是你积极参加活动的奖励！ 
get(301002) ->
    #base_award{
        id = 301002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"这是你积极参加活动的奖励！">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 首冲礼包 
%% 恭喜你获得首冲大礼包，请笑纳~ 
get(303000) ->
    #base_award{
        id = 303000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"恭喜你获得首冲大礼包，请笑纳~">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 每日月卡 
%% 月卡每日额外赠送的晶钻 
get(304000) ->
    #base_award{
        id = 304000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"月卡每日额外赠送的晶钻">>,
        gains = [ 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% 封测新手礼 
%% 封测新手大礼包，内含丰富奖励 
get(305000) ->
    #base_award{
        id = 305000,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"封测新手大礼包，内含丰富奖励">>,
        gains = [
			#gain{label = item, val = [532524, ?false, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% VIP1 
%% VIP1玩家每天福利 
get(306001) ->
    #base_award{
        id = 306001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP1玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 30]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP2 
%% VIP2玩家每天福利 
get(306002) ->
    #base_award{
        id = 306002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP2玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 40]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP3 
%% VIP3玩家每天福利 
get(306003) ->
    #base_award{
        id = 306003,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP3玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 50]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP4 
%% VIP4玩家每天福利 
get(306004) ->
    #base_award{
        id = 306004,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP4玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 60]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP5 
%% VIP5玩家每天福利 
get(306005) ->
    #base_award{
        id = 306005,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP5玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 70]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP6 
%% VIP6玩家每天福利 
get(306006) ->
    #base_award{
        id = 306006,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP6玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 80]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP7 
%% VIP7玩家每天福利 
get(306007) ->
    #base_award{
        id = 306007,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP7玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 90]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP8 
%% VIP8玩家每天福利 
get(306008) ->
    #base_award{
        id = 306008,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP8玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 100]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP9 
%% VIP9玩家每天福利 
get(306009) ->
    #base_award{
        id = 306009,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP9玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 110]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% VIP10 
%% VIP10玩家每天福利 
get(306010) ->
    #base_award{
        id = 306010,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"VIP10玩家每天福利">>,
        gains = [
			#gain{label = item, val = [611501, ?false, 120]} 
        ],   %% 奖励内容 
        limit = 99    %% 同类型奖励保留数量
    };

%% 协同作战礼包 
%% 恭喜你招募到一个队友 
get(532517) ->
    #base_award{
        id = 532517,
        hidden = ?true, %% 是否显示在奖励大厅
        title = <<"恭喜你招募到一个队友">>,
        gains = [
			#gain{label = item, val = [532517, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 首次招募礼包 
%% 恭喜你招募到一个队友 
get(532518) ->
    #base_award{
        id = 532518,
        hidden = ?true, %% 是否显示在奖励大厅
        title = <<"恭喜你招募到一个队友">>,
        gains = [
			#gain{label = item, val = [532518, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 二次招募礼包 
%% 恭喜你招募到一个队友 
get(532519) ->
    #base_award{
        id = 532519,
        hidden = ?true, %% 是否显示在奖励大厅
        title = <<"恭喜你招募到一个队友">>,
        gains = [
			#gain{label = item, val = [532519, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 三次招募礼包 
%% 恭喜你招募到一个队友 
get(532520) ->
    #base_award{
        id = 532520,
        hidden = ?true, %% 是否显示在奖励大厅
        title = <<"恭喜你招募到一个队友">>,
        gains = [
			#gain{label = item, val = [532520, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 四次招募礼包 
%% 恭喜你招募到一个队友 
get(532521) ->
    #base_award{
        id = 532521,
        hidden = ?true, %% 是否显示在奖励大厅
        title = <<"恭喜你招募到一个队友">>,
        gains = [
			#gain{label = item, val = [532521, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 招募大使礼包 
%% 恭喜你招募到一个队友 
get(532522) ->
    #base_award{
        id = 532522,
        hidden = ?true, %% 是否显示在奖励大厅
        title = <<"恭喜你招募到一个队友">>,
        gains = [
			#gain{label = item, val = [532522, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 20    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 人物达到5级！ 
get(400001) ->
    #base_award{
        id = 400001,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"人物达到5级！">>,
        gains = [
			#gain{label = coin, val = 2000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 收集到3件绿色品质的装备！ 
get(400002) ->
    #base_award{
        id = 400002,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"收集到3件绿色品质的装备！">>,
        gains = [
			#gain{label = coin, val = 2500} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 通关沐晨村郊所有普通副本！ 
get(400003) ->
    #base_award{
        id = 400003,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"通关沐晨村郊所有普通副本！">>,
        gains = [
			#gain{label = coin, val = 2000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 伙伴等级达到3级！ 
get(400004) ->
    #base_award{
        id = 400004,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"伙伴等级达到3级！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]},
			#gain{label = coin, val = 2000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 伙伴潜能升至晨辉龙骨！ 
get(400005) ->
    #base_award{
        id = 400005,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"伙伴潜能升至晨辉龙骨！">>,
        gains = [
			#gain{label = coin, val = 8000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 集齐全部防具！ 
get(400006) ->
    #base_award{
        id = 400006,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"集齐全部防具！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]},
			#gain{label = coin, val = 5000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 首次通关了困难副本！ 
get(400007) ->
    #base_award{
        id = 400007,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"首次通关了困难副本！">>,
        gains = [
			#gain{label = item, val = [221102, ?true, 1]},
			#gain{label = stone, val = 600} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功将5个技能升级到2级以上！ 
get(400008) ->
    #base_award{
        id = 400008,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功将5个技能升级到2级以上！">>,
        gains = [
			#gain{label = item, val = [221105, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 伙伴学到第一个技能！ 
get(400009) ->
    #base_award{
        id = 400009,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"伙伴学到第一个技能！">>,
        gains = [
			#gain{label = coin, val = 2000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 人物达到10级！ 
get(400010) ->
    #base_award{
        id = 400010,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"人物达到10级！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]},
			#gain{label = stone, val = 1000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 首次挑战试炼场！ 
get(400011) ->
    #base_award{
        id = 400011,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"首次挑战试炼场！">>,
        gains = [
			#gain{label = coin, val = 3000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 人物达到15级！ 
get(400012) ->
    #base_award{
        id = 400012,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"人物达到15级！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]},
			#gain{label = coin, val = 3500} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功将5个技能升级到3级以上！ 
get(400013) ->
    #base_award{
        id = 400013,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功将5个技能升级到3级以上！">>,
        gains = [
			#gain{label = item, val = [221105, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁贸易行！ 
get(400014) ->
    #base_award{
        id = 400014,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁贸易行！">>,
        gains = [
			#gain{label = item, val = [221102, ?true, 2]},
			#gain{label = stone, val = 1500} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁精灵峡谷！ 
get(400015) ->
    #base_award{
        id = 400015,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁精灵峡谷！">>,
        gains = [
			#gain{label = coin, val = 5000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁装备鉴定功能！ 
get(400016) ->
    #base_award{
        id = 400016,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁装备鉴定功能！">>,
        gains = [
			#gain{label = item, val = [111301, ?true, 3]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁装备强化功能！ 
get(400017) ->
    #base_award{
        id = 400017,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁装备强化功能！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]},
			#gain{label = coin, val = 6000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 6件装备强化到+2！ 
get(400018) ->
    #base_award{
        id = 400018,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"6件装备强化到+2！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 2]},
			#gain{label = coin, val = 10000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 惊人！集齐全套装备！ 
get(400019) ->
    #base_award{
        id = 400019,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"惊人！集齐全套装备！">>,
        gains = [
			#gain{label = item, val = [111011, ?true, 2]},
			#gain{label = stone, val = 3000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁宝石工坊！ 
get(400020) ->
    #base_award{
        id = 400020,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁宝石工坊！">>,
        gains = [
			#gain{label = stone, val = 5000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁寂静高塔！ 
get(400021) ->
    #base_award{
        id = 400021,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁寂静高塔！">>,
        gains = [
			#gain{label = item, val = [231001, ?true, 2]},
			#gain{label = stone, val = 8000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 人物达到20级！ 
get(400022) ->
    #base_award{
        id = 400022,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"人物达到20级！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]},
			#gain{label = coin, val = 8000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 拥有第一只妖精！ 
get(400023) ->
    #base_award{
        id = 400023,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"拥有第一只妖精！">>,
        gains = [
			#gain{label = coin, val = 7000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 拥有自己的庄园！ 
get(400024) ->
    #base_award{
        id = 400024,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"拥有自己的庄园！">>,
        gains = [
			#gain{label = stone, val = 1500} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁装备制作功能！ 
get(400025) ->
    #base_award{
        id = 400025,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁装备制作功能！">>,
        gains = [
			#gain{label = coin, val = 2000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁装备精练功能！ 
get(400026) ->
    #base_award{
        id = 400026,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁装备精练功能！">>,
        gains = [
			#gain{label = coin, val = 5000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁装备镶嵌功能！ 
get(400027) ->
    #base_award{
        id = 400027,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁装备镶嵌功能！">>,
        gains = [
			#gain{label = coin, val = 5000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 第一次加入军团！ 
get(400028) ->
    #base_award{
        id = 400028,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"第一次加入军团！">>,
        gains = [
			#gain{label = coin, val = 2000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁炼金作坊！ 
get(400029) ->
    #base_award{
        id = 400029,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁炼金作坊！">>,
        gains = [
			#gain{label = stone, val = 5000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 成功解锁铁锤炉屋！ 
get(400030) ->
    #base_award{
        id = 400030,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"成功解锁铁锤炉屋！">>,
        gains = [
			#gain{label = stone, val = 5000} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 第一次加入远征王军！ 
get(400031) ->
    #base_award{
        id = 400031,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"第一次加入远征王军！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 第一次踏足世界树！ 
get(400032) ->
    #base_award{
        id = 400032,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"第一次踏足世界树！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 第一次英勇缉猎海盗！ 
get(400033) ->
    #base_award{
        id = 400033,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"第一次英勇缉猎海盗！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 第一次参与守城伐龙！ 
get(400034) ->
    #base_award{
        id = 400034,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"第一次参与守城伐龙！">>,
        gains = [
			#gain{label = item, val = [221104, ?true, 1]} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

%% 达成目标 
%% 拥有了第一位好友！ 
get(400035) ->
    #base_award{
        id = 400035,
        hidden = ?false, %% 是否显示在奖励大厅
        title = <<"拥有了第一位好友！">>,
        gains = [
			#gain{label = coin, val = 2500} 
        ],   %% 奖励内容 
        limit = 1    %% 同类型奖励保留数量
    };

get(0) ->
    #base_award{
        id = 0,
        title = <<>>,
        gains = [],
        limit = 99
    };

get(_) ->
    undefined.

