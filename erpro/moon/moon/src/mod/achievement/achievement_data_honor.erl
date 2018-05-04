%%----------------------------------------------------
%% VIP数据
%% @author whing2012@game.com
%%----------------------------------------------------
-module(achievement_data_honor).
-export([list/0, get/1]).
-include("achievement.hrl").


%% 所有称号
list() ->
   [20003,20007,20011,20015,20019,20023,20027,20028,20035,20042,20049,20054,20058,20062,
20066,20069,20072,20076,20081,20082,20086,20091,20095,20099,20103,20107,20108,20112,20117,
20120,20124,20163,20167,20125,20130,20134,20139,20143,20147,20171,20148,20150,20151,20152,
20153,20154,20155,20156,20157,20158,20159,20160,20161,20162,20180,20181,20182,20183,20184,
20185,20186,20187,20190,20191,20192,20193,20194,20195,20200,20201,20202,20203,20204,20209,
20214,20219,20224,20229,20234,20250,20260,20270,20271,20272,20280,30162,30163,30164,30165,
30166,30167,30168,30169,30170,30171,30172,30173,30174,30175,30176,30177,30178,30179,30180,
30181,30182,30183,30184,30185,30186,30187,30188,30189,30190,30191,30192,30193,30194,30195,
30196,30197,30198,30199,30200,30201,21001,21002,21003,21004,21005,21006,21007,21008,21009,
21010,21011,21012,21013,21014,21015,21016,21017,21018,21019,21020,21021,21022,21023,21024,
21025,21026,21027,21028,21029,21030,21031,21032,21033,21034,21035,21036,21037,21038,21039,
21040,21041,21042,21044,21045,21046,21047,21048,21055,21049,21050,21051,21052,21053,21054,
21056,40002,40003,40004,40005,40006,50001,50002,50003,50004,50005,50006,50007,50008,50009,
50010,50011,50012,50013,50014,50015,50016,50017,60001,60002,60003,60004,60005,60006,60007,
60008,60009,60010,60011,60012,60013,60014,60015,70001,70002,70003,70004,70005,70006,60016,
60017,60018,60019,60020,60021,60022,60023,60024,60025,60026,60027,60028,60029].

%% 称号列表
get(20003) ->
    {ok, #honor_base{
            id = 20003
            ,name = <<"帮中栋梁">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20007) ->
    {ok, #honor_base{
            id = 20007
            ,name = <<"师门精英">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20011) ->
    {ok, #honor_base{
            id = 20011
            ,name = <<"护花使者">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20015) ->
    {ok, #honor_base{
            id = 20015
            ,name = <<"侠肝义胆">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20019) ->
    {ok, #honor_base{
            id = 20019
            ,name = <<"副本尊者">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20023) ->
    {ok, #honor_base{
            id = 20023
            ,name = <<"修行达人">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20027) ->
    {ok, #honor_base{
            id = 20027
            ,name = <<"勤于修行">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20028) ->
    {ok, #honor_base{
            id = 20028
            ,name = <<"飞仙守护者">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20035) ->
    {ok, #honor_base{
            id = 20035
            ,name = <<"圣人无名">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20042) ->
    {ok, #honor_base{
            id = 20042
            ,name = <<"返璞归真">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20042
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20049) ->
    {ok, #honor_base{
            id = 20049
            ,name = <<"一念通天">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20049
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20054) ->
    {ok, #honor_base{
            id = 20054
            ,name = <<"富商巨贾">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20058) ->
    {ok, #honor_base{
            id = 20058
            ,name = <<"笑傲群雄">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20062) ->
    {ok, #honor_base{
            id = 20062
            ,name = <<"绝世防具">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20062
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20066) ->
    {ok, #honor_base{
            id = 20066
            ,name = <<"绝世神兵">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20066
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20069) ->
    {ok, #honor_base{
            id = 20069
            ,name = <<"飞仙天使">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20069
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20072) ->
    {ok, #honor_base{
            id = 20072
            ,name = <<"速度与激情">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20072
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20076) ->
    {ok, #honor_base{
            id = 20076
            ,name = <<"飞仙潮人">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20081) ->
    {ok, #honor_base{
            id = 20081
            ,name = <<"飞仙圣使">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20082) ->
    {ok, #honor_base{
            id = 20082
            ,name = <<"绝世神通">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20086) ->
    {ok, #honor_base{
            id = 20086
            ,name = <<"纷至沓来">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20091) ->
    {ok, #honor_base{
            id = 20091
            ,name = <<"双修达人">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20095) ->
    {ok, #honor_base{
            id = 20095
            ,name = <<"浪漫花雨">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20099) ->
    {ok, #honor_base{
            id = 20099
            ,name = <<"情比金坚">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20103) ->
    {ok, #honor_base{
            id = 20103
            ,name = <<"魅力四射">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20107) ->
    {ok, #honor_base{
            id = 20107
            ,name = <<"中流砥柱">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20107
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20108) ->
    {ok, #honor_base{
            id = 20108
            ,name = <<"飞仙名流">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20112) ->
    {ok, #honor_base{
            id = 20112
            ,name = <<"竞技宗师">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20112
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20117) ->
    {ok, #honor_base{
            id = 20117
            ,name = <<"死神来了">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20120) ->
    {ok, #honor_base{
            id = 20120
            ,name = <<"BOSS杀戮者">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20124) ->
    {ok, #honor_base{
            id = 20124
            ,name = <<"帮中泰斗">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20163) ->
    {ok, #honor_base{
            id = 20163
            ,name = <<"横扫仙府">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20167) ->
    {ok, #honor_base{
            id = 20167
            ,name = <<"傲视仙府">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20125) ->
    {ok, #honor_base{
            id = 20125
            ,name = <<"威震八方">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20130) ->
    {ok, #honor_base{
            id = 20130
            ,name = <<"高级尊宠">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20134) ->
    {ok, #honor_base{
            id = 20134
            ,name = <<"情有独钟">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20134
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20139) ->
    {ok, #honor_base{
            id = 20139
            ,name = <<"战力超群">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20143) ->
    {ok, #honor_base{
            id = 20143
            ,name = <<"潜力无限">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = title_20143
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20147) ->
    {ok, #honor_base{
            id = 20147
            ,name = <<"技压群宠">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20171) ->
    {ok, #honor_base{
            id = 20171
            ,name = <<"资质超群">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20148) ->
    {ok, #honor_base{
            id = 20148
            ,name = <<"绝世异宠">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20150) ->
    {ok, #honor_base{
            id = 20150
            ,name = <<"状元">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20151) ->
    {ok, #honor_base{
            id = 20151
            ,name = <<"榜眼">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20152) ->
    {ok, #honor_base{
            id = 20152
            ,name = <<"探花">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20153) ->
    {ok, #honor_base{
            id = 20153
            ,name = <<"真武首席弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = master
            ,modify = 0
            ,career = 1
            ,sex = 99
        }
    };

get(20154) ->
    {ok, #honor_base{
            id = 20154
            ,name = <<"贤者首席弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = master
            ,modify = 0
            ,career = 3
            ,sex = 99
        }
    };

get(20155) ->
    {ok, #honor_base{
            id = 20155
            ,name = <<"刺客首席弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = master
            ,modify = 0
            ,career = 2
            ,sex = 99
        }
    };

get(20156) ->
    {ok, #honor_base{
            id = 20156
            ,name = <<"飞羽首席弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = master
            ,modify = 0
            ,career = 4
            ,sex = 99
        }
    };

get(20157) ->
    {ok, #honor_base{
            id = 20157
            ,name = <<"骑士首席弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = master
            ,modify = 0
            ,career = 5
            ,sex = 99
        }
    };

get(20158) ->
    {ok, #honor_base{
            id = 20158
            ,name = <<"真武真传弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 1
            ,sex = 99
        }
    };

get(20159) ->
    {ok, #honor_base{
            id = 20159
            ,name = <<"贤者真传弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 3
            ,sex = 99
        }
    };

get(20160) ->
    {ok, #honor_base{
            id = 20160
            ,name = <<"刺客真传弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 2
            ,sex = 99
        }
    };

get(20161) ->
    {ok, #honor_base{
            id = 20161
            ,name = <<"飞羽真传弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 4
            ,sex = 99
        }
    };

get(20162) ->
    {ok, #honor_base{
            id = 20162
            ,name = <<"骑士真传弟子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 5
            ,sex = 99
        }
    };

get(20180) ->
    {ok, #honor_base{
            id = 20180
            ,name = <<"武圣">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = kuafushimen_1
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20181) ->
    {ok, #honor_base{
            id = 20181
            ,name = <<"万人来朝">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = kuafushimen_2
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20182) ->
    {ok, #honor_base{
            id = 20182
            ,name = <<"威震五岳">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = kuafushimen_3
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20183) ->
    {ok, #honor_base{
            id = 20183
            ,name = <<"绝世高手">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = kuafushimen_4
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20184) ->
    {ok, #honor_base{
            id = 20184
            ,name = <<"威名远播">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = kuafushimen_5
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20185) ->
    {ok, #honor_base{
            id = 20185
            ,name = <<"能者为师">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20186) ->
    {ok, #honor_base{
            id = 20186
            ,name = <<"师道楷模">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20187) ->
    {ok, #honor_base{
            id = 20187
            ,name = <<"桃李天下">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20190) ->
    {ok, #honor_base{
            id = 20190
            ,name = <<"鲜花宝贝">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = flowerlist_1
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20191) ->
    {ok, #honor_base{
            id = 20191
            ,name = <<"飞仙情圣">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = flowerlist_1
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20192) ->
    {ok, #honor_base{
            id = 20192
            ,name = <<"绝代佳人">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = flowerlist_1
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20193) ->
    {ok, #honor_base{
            id = 20193
            ,name = <<"翩翩君子">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = flowerlist_1
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20194) ->
    {ok, #honor_base{
            id = 20194
            ,name = <<"至尊花痴">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = flowerlist_1
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20195) ->
    {ok, #honor_base{
            id = 20195
            ,name = <<"至尊情圣">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = flowerlist_1
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20200) ->
    {ok, #honor_base{
            id = 20200
            ,name = <<"一掷千金">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20201) ->
    {ok, #honor_base{
            id = 20201
            ,name = <<"寻宝达人">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20202) ->
    {ok, #honor_base{
            id = 20202
            ,name = <<"练级狂人">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20203) ->
    {ok, #honor_base{
            id = 20203
            ,name = <<"阅历无双">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20204) ->
    {ok, #honor_base{
            id = 20204
            ,name = <<"羽化至尊">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20209) ->
    {ok, #honor_base{
            id = 20209
            ,name = <<"驾驭神兽">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20214) ->
    {ok, #honor_base{
            id = 20214
            ,name = <<"骁勇无敌">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20219) ->
    {ok, #honor_base{
            id = 20219
            ,name = <<"至尊灵戒">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20224) ->
    {ok, #honor_base{
            id = 20224
            ,name = <<"傲视妖界">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20229) ->
    {ok, #honor_base{
            id = 20229
            ,name = <<"封妖尊者">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20234) ->
    {ok, #honor_base{
            id = 20234
            ,name = <<"旷世魔阵">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20250) ->
    {ok, #honor_base{
            id = 20250
            ,name = <<"青瓷古韵">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20260) ->
    {ok, #honor_base{
            id = 20260
            ,name = <<"飘渺仙踪">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20270) ->
    {ok, #honor_base{
            id = 20270
            ,name = <<"寻梦飞仙">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20271) ->
    {ok, #honor_base{
            id = 20271
            ,name = <<"风轻云淡">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20272) ->
    {ok, #honor_base{
            id = 20272
            ,name = <<"燃情岁月">>
            ,picture = 1
            ,type = 0
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(20280) ->
    {ok, #honor_base{
            id = 20280
            ,name = <<"捕宠达人">>
            ,picture = 1
            ,type = 0
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30162) ->
    {ok, #honor_base{
            id = 30162
            ,name = <<"十大战神">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30163) ->
    {ok, #honor_base{
            id = 30163
            ,name = <<"横扫千军">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30164) ->
    {ok, #honor_base{
            id = 30164
            ,name = <<"万夫莫敌">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30165) ->
    {ok, #honor_base{
            id = 30165
            ,name = <<"君临天下">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30166) ->
    {ok, #honor_base{
            id = 30166
            ,name = <<"十大高手">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30167) ->
    {ok, #honor_base{
            id = 30167
            ,name = <<"谁与争锋">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30168) ->
    {ok, #honor_base{
            id = 30168
            ,name = <<"霸气十足">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30169) ->
    {ok, #honor_base{
            id = 30169
            ,name = <<"独孤求败">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30170) ->
    {ok, #honor_base{
            id = 30170
            ,name = <<"十大富豪">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30171) ->
    {ok, #honor_base{
            id = 30171
            ,name = <<"富埒王侯">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30172) ->
    {ok, #honor_base{
            id = 30172
            ,name = <<"富可敌国">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30173) ->
    {ok, #honor_base{
            id = 30173
            ,name = <<"富甲天下">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30174) ->
    {ok, #honor_base{
            id = 30174
            ,name = <<"十大神人">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30175) ->
    {ok, #honor_base{
            id = 30175
            ,name = <<"九转真仙">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30176) ->
    {ok, #honor_base{
            id = 30176
            ,name = <<"三世仙帝">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30177) ->
    {ok, #honor_base{
            id = 30177
            ,name = <<"一代骑士">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30178) ->
    {ok, #honor_base{
            id = 30178
            ,name = <<"十大楷模">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30179) ->
    {ok, #honor_base{
            id = 30179
            ,name = <<"独树一帜">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30180) ->
    {ok, #honor_base{
            id = 30180
            ,name = <<"飞仙楷模">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30181) ->
    {ok, #honor_base{
            id = 30181
            ,name = <<"万人景仰">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30182) ->
    {ok, #honor_base{
            id = 30182
            ,name = <<"十大俊男">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 1
        }
    };

get(30183) ->
    {ok, #honor_base{
            id = 30183
            ,name = <<"花见花开">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 1
        }
    };

get(30184) ->
    {ok, #honor_base{
            id = 30184
            ,name = <<"清新俊逸">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 1
        }
    };

get(30185) ->
    {ok, #honor_base{
            id = 30185
            ,name = <<"美如冠玉">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 1
        }
    };

get(30186) ->
    {ok, #honor_base{
            id = 30186
            ,name = <<"十大美女">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 0
        }
    };

get(30187) ->
    {ok, #honor_base{
            id = 30187
            ,name = <<"闭月羞花">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 0
        }
    };

get(30188) ->
    {ok, #honor_base{
            id = 30188
            ,name = <<"沉鱼落雁">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 0
        }
    };

get(30189) ->
    {ok, #honor_base{
            id = 30189
            ,name = <<"倾国倾城">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 0
        }
    };

get(30190) ->
    {ok, #honor_base{
            id = 30190
            ,name = <<"十大宗师">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30191) ->
    {ok, #honor_base{
            id = 30191
            ,name = <<"空前绝后">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30192) ->
    {ok, #honor_base{
            id = 30192
            ,name = <<"泰山北斗">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30193) ->
    {ok, #honor_base{
            id = 30193
            ,name = <<"天下无双">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30194) ->
    {ok, #honor_base{
            id = 30194
            ,name = <<"十大神宠">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30195) ->
    {ok, #honor_base{
            id = 30195
            ,name = <<"隔世圣宠">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30196) ->
    {ok, #honor_base{
            id = 30196
            ,name = <<"倾世帝宠">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30197) ->
    {ok, #honor_base{
            id = 30197
            ,name = <<"绝世神宠">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30198) ->
    {ok, #honor_base{
            id = 30198
            ,name = <<"十大才子">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30199) ->
    {ok, #honor_base{
            id = 30199
            ,name = <<"博学多才">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30200) ->
    {ok, #honor_base{
            id = 30200
            ,name = <<"才气过人">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(30201) ->
    {ok, #honor_base{
            id = 30201
            ,name = <<"风华绝代">>
            ,picture = 1
            ,type = 1
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21001) ->
    {ok, #honor_base{
            id = 21001
            ,name = <<"一骑绝尘">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21002) ->
    {ok, #honor_base{
            id = 21002
            ,name = <<"锋芒毕露">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21003) ->
    {ok, #honor_base{
            id = 21003
            ,name = <<"巡狩四方">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21004) ->
    {ok, #honor_base{
            id = 21004
            ,name = <<"狩猎之王">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21005) ->
    {ok, #honor_base{
            id = 21005
            ,name = <<"狩猎帝尊">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21006) ->
    {ok, #honor_base{
            id = 21006
            ,name = <<"玄妖伏诛">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21007) ->
    {ok, #honor_base{
            id = 21007
            ,name = <<"镇妖使者">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21008) ->
    {ok, #honor_base{
            id = 21008
            ,name = <<"千骨道人">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21009) ->
    {ok, #honor_base{
            id = 21009
            ,name = <<"睥睨群妖">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21010) ->
    {ok, #honor_base{
            id = 21010
            ,name = <<"镇妖帝尊">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21011) ->
    {ok, #honor_base{
            id = 21011
            ,name = <<"羽化登仙">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21012) ->
    {ok, #honor_base{
            id = 21012
            ,name = <<"神兵玄奇">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21013) ->
    {ok, #honor_base{
            id = 21013
            ,name = <<"神兵玄奇">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21014) ->
    {ok, #honor_base{
            id = 21014
            ,name = <<"极道灵甲">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21015) ->
    {ok, #honor_base{
            id = 21015
            ,name = <<"极道灵甲">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21016) ->
    {ok, #honor_base{
            id = 21016
            ,name = <<"珠光宝气">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21017) ->
    {ok, #honor_base{
            id = 21017
            ,name = <<"珠光宝气">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21018) ->
    {ok, #honor_base{
            id = 21018
            ,name = <<"武林至尊">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21019) ->
    {ok, #honor_base{
            id = 21019
            ,name = <<"唯我独尊">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21020) ->
    {ok, #honor_base{
            id = 21020
            ,name = <<"唯我独尊">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21021) ->
    {ok, #honor_base{
            id = 21021
            ,name = <<"唯我独尊">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21022) ->
    {ok, #honor_base{
            id = 21022
            ,name = <<"御兽通神">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21023) ->
    {ok, #honor_base{
            id = 21023
            ,name = <<"御兽通神">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21024) ->
    {ok, #honor_base{
            id = 21024
            ,name = <<"焚天帝尊">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21025) ->
    {ok, #honor_base{
            id = 21025
            ,name = <<"宇内无敌">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21026) ->
    {ok, #honor_base{
            id = 21026
            ,name = <<"踏破苍穹">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21027) ->
    {ok, #honor_base{
            id = 21027
            ,name = <<"号令天下">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21028) ->
    {ok, #honor_base{
            id = 21028
            ,name = <<"通灵圣石">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21029) ->
    {ok, #honor_base{
            id = 21029
            ,name = <<"初炼神识">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21030) ->
    {ok, #honor_base{
            id = 21030
            ,name = <<"登峰造极">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21031) ->
    {ok, #honor_base{
            id = 21031
            ,name = <<"千军辟易">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21032) ->
    {ok, #honor_base{
            id = 21032
            ,name = <<"睥睨天下">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21033) ->
    {ok, #honor_base{
            id = 21033
            ,name = <<"仙道圣甲">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21034) ->
    {ok, #honor_base{
            id = 21034
            ,name = <<"珠围翠绕">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21035) ->
    {ok, #honor_base{
            id = 21035
            ,name = <<"通灵战宠">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21036) ->
    {ok, #honor_base{
            id = 21036
            ,name = <<"霸绝天下">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21037) ->
    {ok, #honor_base{
            id = 21037
            ,name = <<"通灵神宠">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21038) ->
    {ok, #honor_base{
            id = 21038
            ,name = <<"屠龙者">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21039) ->
    {ok, #honor_base{
            id = 21039
            ,name = <<"降妖尊者">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21040) ->
    {ok, #honor_base{
            id = 21040
            ,name = <<"傲世神兵">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21041) ->
    {ok, #honor_base{
            id = 21041
            ,name = <<"精兵良甲">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21042) ->
    {ok, #honor_base{
            id = 21042
            ,name = <<"神兵圣甲">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21044) ->
    {ok, #honor_base{
            id = 21044
            ,name = <<"镇妖英杰">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21045) ->
    {ok, #honor_base{
            id = 21045
            ,name = <<"镇妖英豪">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21046) ->
    {ok, #honor_base{
            id = 21046
            ,name = <<"龙宫英杰">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21047) ->
    {ok, #honor_base{
            id = 21047
            ,name = <<"龙宫英豪">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21048) ->
    {ok, #honor_base{
            id = 21048
            ,name = <<"龙宫霸者">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21055) ->
    {ok, #honor_base{
            id = 21055
            ,name = <<"狩天猎地">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21049) ->
    {ok, #honor_base{
            id = 21049
            ,name = <<"神龙使者">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21050) ->
    {ok, #honor_base{
            id = 21050
            ,name = <<"孔雀明王">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21051) ->
    {ok, #honor_base{
            id = 21051
            ,name = <<"进阶天位">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21052) ->
    {ok, #honor_base{
            id = 21052
            ,name = <<"魔晶至尊">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21053) ->
    {ok, #honor_base{
            id = 21053
            ,name = <<"试练霸主">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21054) ->
    {ok, #honor_base{
            id = 21054
            ,name = <<"冠绝八门">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(21056) ->
    {ok, #honor_base{
            id = 21056
            ,name = <<"狩猎三界">>
            ,picture = 1
            ,type = 2
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(40002) ->
    {ok, #honor_base{
            id = 40002
            ,name = <<"结婚称号">>
            ,picture = 0
            ,type = 3
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(40003) ->
    {ok, #honor_base{
            id = 40003
            ,name = <<"结拜称号">>
            ,picture = 0
            ,type = 3
            ,is_only = 0
            ,buff = false
            ,modify = 1
            ,career = 0
            ,sex = 99
        }
    };

get(40004) ->
    {ok, #honor_base{
            id = 40004
            ,name = <<"普通结拜称号">>
            ,picture = 0
            ,type = 3
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(40005) ->
    {ok, #honor_base{
            id = 40005
            ,name = <<"普通弟子称号">>
            ,picture = 0
            ,type = 3
            ,is_only = 0
            ,buff = false
            ,modify = 1
            ,career = 0
            ,sex = 99
        }
    };

get(40006) ->
    {ok, #honor_base{
            id = 40006
            ,name = <<"真传弟子称号">>
            ,picture = 0
            ,type = 3
            ,is_only = 0
            ,buff = false
            ,modify = 1
            ,career = 0
            ,sex = 99
        }
    };

get(50001) ->
    {ok, #honor_base{
            id = 50001
            ,name = <<"血继限界">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50001
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50002) ->
    {ok, #honor_base{
            id = 50002
            ,name = <<"法力无边">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50002
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50003) ->
    {ok, #honor_base{
            id = 50003
            ,name = <<"攻无不克">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50003
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50004) ->
    {ok, #honor_base{
            id = 50004
            ,name = <<"绝对防御">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50004
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50005) ->
    {ok, #honor_base{
            id = 50005
            ,name = <<"醉仙望月">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50005
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50006) ->
    {ok, #honor_base{
            id = 50006
            ,name = <<"剑心通明">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50006
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50007) ->
    {ok, #honor_base{
            id = 50007
            ,name = <<"致命一击">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50007
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50008) ->
    {ok, #honor_base{
            id = 50008
            ,name = <<"不动明王">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50008
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50009) ->
    {ok, #honor_base{
            id = 50009
            ,name = <<"五蕴化神">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50009
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50010) ->
    {ok, #honor_base{
            id = 50010
            ,name = <<"补天劫手">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50010
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50011) ->
    {ok, #honor_base{
            id = 50011
            ,name = <<"指间风雨">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50011
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50012) ->
    {ok, #honor_base{
            id = 50012
            ,name = <<"五行相生">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50012
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50013) ->
    {ok, #honor_base{
            id = 50013
            ,name = <<"五星劳模">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50013
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50014) ->
    {ok, #honor_base{
            id = 50014
            ,name = <<"四星劳模">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50014
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50015) ->
    {ok, #honor_base{
            id = 50015
            ,name = <<"三星劳模">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50015
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50016) ->
    {ok, #honor_base{
            id = 50016
            ,name = <<"二星劳模">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50016
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(50017) ->
    {ok, #honor_base{
            id = 50017
            ,name = <<"一星劳模">>
            ,picture = 1
            ,type = 4
            ,is_only = 0
            ,buff = honor_50017
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60001) ->
    {ok, #honor_base{
            id = 60001
            ,name = <<"洛水城主">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = guard_honor_1
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60002) ->
    {ok, #honor_base{
            id = 60002
            ,name = <<"圣地城主">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = guild_war_winer
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60003) ->
    {ok, #honor_base{
            id = 60003
            ,name = <<"联赛冠军">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60004) ->
    {ok, #honor_base{
            id = 60004
            ,name = <<"联赛亚军">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60005) ->
    {ok, #honor_base{
            id = 60005
            ,name = <<"联赛季军">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60006) ->
    {ok, #honor_base{
            id = 60006
            ,name = <<"巅峰霸主">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60007) ->
    {ok, #honor_base{
            id = 60007
            ,name = <<"巅峰王者">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60008) ->
    {ok, #honor_base{
            id = 60008
            ,name = <<"飞仙纪录保持帝">>
            ,picture = 1
            ,type = 5
            ,is_only = 0
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60009) ->
    {ok, #honor_base{
            id = 60009
            ,name = <<"天龙榜第一武神">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60010) ->
    {ok, #honor_base{
            id = 60010
            ,name = <<"武神坛天龙榜亚军">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60011) ->
    {ok, #honor_base{
            id = 60011
            ,name = <<"武神坛天龙榜季军">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60012) ->
    {ok, #honor_base{
            id = 60012
            ,name = <<"玄虎榜第一武神">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60013) ->
    {ok, #honor_base{
            id = 60013
            ,name = <<"武神坛玄虎榜亚军">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60014) ->
    {ok, #honor_base{
            id = 60014
            ,name = <<"武神坛玄虎榜季军">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60015) ->
    {ok, #honor_base{
            id = 60015
            ,name = <<"屠魔勇士">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(70001) ->
    {ok, #honor_base{
            id = 70001
            ,name = <<"神药阁主">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(70002) ->
    {ok, #honor_base{
            id = 70002
            ,name = <<"神药副阁主">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(70003) ->
    {ok, #honor_base{
            id = 70003
            ,name = <<"神药阁砥柱">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(70004) ->
    {ok, #honor_base{
            id = 70004
            ,name = <<"神药阁精英">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(70005) ->
    {ok, #honor_base{
            id = 70005
            ,name = <<"仙宠阁主">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(70006) ->
    {ok, #honor_base{
            id = 70006
            ,name = <<"珍宝阁主">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60016) ->
    {ok, #honor_base{
            id = 60016
            ,name = <<"仙道会七段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60017) ->
    {ok, #honor_base{
            id = 60017
            ,name = <<"仙道会八段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60018) ->
    {ok, #honor_base{
            id = 60018
            ,name = <<"仙道会九段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60019) ->
    {ok, #honor_base{
            id = 60019
            ,name = <<"仙道会十段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60020) ->
    {ok, #honor_base{
            id = 60020
            ,name = <<"仙道会十一段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60021) ->
    {ok, #honor_base{
            id = 60021
            ,name = <<"仙道会十二段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60022) ->
    {ok, #honor_base{
            id = 60022
            ,name = <<"仙道会十三段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60023) ->
    {ok, #honor_base{
            id = 60023
            ,name = <<"仙道会十四段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60024) ->
    {ok, #honor_base{
            id = 60024
            ,name = <<"仙道会十五段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60025) ->
    {ok, #honor_base{
            id = 60025
            ,name = <<"仙道会十六段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60026) ->
    {ok, #honor_base{
            id = 60026
            ,name = <<"仙道会十七段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60027) ->
    {ok, #honor_base{
            id = 60027
            ,name = <<"仙道会十八段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60028) ->
    {ok, #honor_base{
            id = 60028
            ,name = <<"仙道会十九段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(60029) ->
    {ok, #honor_base{
            id = 60029
            ,name = <<"仙道会二十段">>
            ,picture = 1
            ,type = 5
            ,is_only = 1
            ,buff = false
            ,modify = 0
            ,career = 0
            ,sex = 99
        }
    };

get(_) ->
    {false, <<"无相关称号">>}.
