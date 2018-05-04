
%% ------------------------------------
%% 梦幻宝盒系统数据
%% @author wpf(wprehard@qq.com)
%% @end
%% ------------------------------------
-module(pandora_box_data).
-export([get/1, get_base/2]).
-include("pandora_box.hrl").

get({1, 0}) ->
    [
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16700
            ,name = <<"龙吟寒焰剑">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16705
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16710
            ,name = <<"逐风之刃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16715
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16720
            ,name = <<"冰霜之牙">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16725
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16730
            ,name = <<"寒晶雪霁剑">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16735
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({1, 1}) ->
    [
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16700
            ,name = <<"龙吟寒焰剑">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16705
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16710
            ,name = <<"逐风之刃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16715
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16720
            ,name = <<"冰霜之牙">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16725
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16730
            ,name = <<"寒晶雪霁剑">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16735
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({2, 0}) ->
    [
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16701
            ,name = <<"龙吟寒焰刺">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16706
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16711
            ,name = <<"恶魔刀锋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16716
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16721
            ,name = <<"新月之痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16726
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16731
            ,name = <<"寒晶雪霁刃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16736
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({2, 1}) ->
    [
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16701
            ,name = <<"龙吟寒焰刺">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16706
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16711
            ,name = <<"恶魔刀锋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16716
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16721
            ,name = <<"新月之痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16726
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16731
            ,name = <<"寒晶雪霁刃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16736
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({3, 0}) ->
    [
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16702
            ,name = <<"龙吟寒焰杖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16707
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16712
            ,name = <<"圣光祈福">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16717
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16722
            ,name = <<"天使之眸">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16727
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16732
            ,name = <<"寒晶雪霁杖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16737
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({3, 1}) ->
    [
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16702
            ,name = <<"龙吟寒焰杖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16707
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16712
            ,name = <<"圣光祈福">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16717
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16722
            ,name = <<"天使之眸">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16727
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16732
            ,name = <<"寒晶雪霁杖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16737
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({4, 0}) ->
    [
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16703
            ,name = <<"龙吟寒焰弓">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16708
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16713
            ,name = <<"万鸟朝凤">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16718
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16723
            ,name = <<"血龙之吼">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16728
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16733
            ,name = <<"寒晶雪霁弓">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16738
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({4, 1}) ->
    [
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16703
            ,name = <<"龙吟寒焰弓">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16708
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16713
            ,name = <<"万鸟朝凤">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16718
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16723
            ,name = <<"血龙之吼">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16728
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16733
            ,name = <<"寒晶雪霁弓">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16738
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({5, 0}) ->
    [
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16704
            ,name = <<"龙吟寒焰枪">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16709
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16714
            ,name = <<"噬炎之怒">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16719
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16724
            ,name = <<"死神之镰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16729
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16734
            ,name = <<"寒晶雪霁刀">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16739
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({5, 1}) ->
    [
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16704
            ,name = <<"龙吟寒焰枪">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16709
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16714
            ,name = <<"噬炎之怒">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16719
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16724
            ,name = <<"死神之镰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16729
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16734
            ,name = <<"寒晶雪霁刀">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16739
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
        ,#rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        }
    ];
get({_, _}) -> error.

get_base({1, 1}, 16024) ->
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16024) ->
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16024) ->
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16024) ->
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16024) ->
        #rand_base{
            base_id = 16024
            ,name = <<"血修罗">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16025) ->
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16025) ->
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16025) ->
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16025) ->
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16025) ->
        #rand_base{
            base_id = 16025
            ,name = <<"萌少女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16026) ->
        #rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16026) ->
        #rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16026) ->
        #rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16026) ->
        #rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16026) ->
        #rand_base{
            base_id = 16026
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16027) ->
        #rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16027) ->
        #rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16027) ->
        #rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16027) ->
        #rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16027) ->
        #rand_base{
            base_id = 16027
            ,name = <<"魅惑众生">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 0
            ,limit = 2
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16028) ->
        #rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16028) ->
        #rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16028) ->
        #rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16028) ->
        #rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16028) ->
        #rand_base{
            base_id = 16028
            ,name = <<"汉风古绰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16029) ->
        #rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16029) ->
        #rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16029) ->
        #rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16029) ->
        #rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16029) ->
        #rand_base{
            base_id = 16029
            ,name = <<"桃之夭夭">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16030) ->
        #rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16030) ->
        #rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16030) ->
        #rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16030) ->
        #rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16030) ->
        #rand_base{
            base_id = 16030
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16031) ->
        #rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16031) ->
        #rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16031) ->
        #rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16031) ->
        #rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16031) ->
        #rand_base{
            base_id = 16031
            ,name = <<"约会礼服">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16032) ->
        #rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16032) ->
        #rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16032) ->
        #rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16032) ->
        #rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16032) ->
        #rand_base{
            base_id = 16032
            ,name = <<"追梦少年时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16033) ->
        #rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16033) ->
        #rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16033) ->
        #rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16033) ->
        #rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16033) ->
        #rand_base{
            base_id = 16033
            ,name = <<"小魔女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16034) ->
        #rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16034) ->
        #rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16034) ->
        #rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16034) ->
        #rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16034) ->
        #rand_base{
            base_id = 16034
            ,name = <<"青瓷印象·男">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16035) ->
        #rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16035) ->
        #rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16035) ->
        #rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16035) ->
        #rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16035) ->
        #rand_base{
            base_id = 16035
            ,name = <<"青瓷印象·女">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16036) ->
        #rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16036) ->
        #rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16036) ->
        #rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16036) ->
        #rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16036) ->
        #rand_base{
            base_id = 16036
            ,name = <<"海盗·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16037) ->
        #rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16037) ->
        #rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16037) ->
        #rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16037) ->
        #rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16037) ->
        #rand_base{
            base_id = 16037
            ,name = <<"海盗·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16038) ->
        #rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16038) ->
        #rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16038) ->
        #rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16038) ->
        #rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16038) ->
        #rand_base{
            base_id = 16038
            ,name = <<"主神圣衣·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16039) ->
        #rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16039) ->
        #rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16039) ->
        #rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16039) ->
        #rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16039) ->
        #rand_base{
            base_id = 16039
            ,name = <<"主神圣衣·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16040) ->
        #rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16040) ->
        #rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16040) ->
        #rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16040) ->
        #rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16040) ->
        #rand_base{
            base_id = 16040
            ,name = <<"蝙蝠侠时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16041) ->
        #rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16041) ->
        #rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16041) ->
        #rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16041) ->
        #rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16041) ->
        #rand_base{
            base_id = 16041
            ,name = <<"猫女时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16042) ->
        #rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16042) ->
        #rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16042) ->
        #rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16042) ->
        #rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16042) ->
        #rand_base{
            base_id = 16042
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16043) ->
        #rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16043) ->
        #rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16043) ->
        #rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16043) ->
        #rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16043) ->
        #rand_base{
            base_id = 16043
            ,name = <<"终结孤单">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16044) ->
        #rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16044) ->
        #rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16044) ->
        #rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16044) ->
        #rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16044) ->
        #rand_base{
            base_id = 16044
            ,name = <<"凯旋骑士时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16045) ->
        #rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16045) ->
        #rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16045) ->
        #rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16045) ->
        #rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16045) ->
        #rand_base{
            base_id = 16045
            ,name = <<"秋水伊人时装">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16046) ->
        #rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16046) ->
        #rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16046) ->
        #rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16046) ->
        #rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16046) ->
        #rand_base{
            base_id = 16046
            ,name = <<"爱之永恒·男">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16047) ->
        #rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16047) ->
        #rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16047) ->
        #rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16047) ->
        #rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16047) ->
        #rand_base{
            base_id = 16047
            ,name = <<"爱之永恒·女">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16048) ->
        #rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16048) ->
        #rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16048) ->
        #rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16048) ->
        #rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16048) ->
        #rand_base{
            base_id = 16048
            ,name = <<"乖乖虎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16049) ->
        #rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16049) ->
        #rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16049) ->
        #rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16049) ->
        #rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16049) ->
        #rand_base{
            base_id = 16049
            ,name = <<"小熊猫">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16050) ->
        #rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16050) ->
        #rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16050) ->
        #rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16050) ->
        #rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16050) ->
        #rand_base{
            base_id = 16050
            ,name = <<"圣诞时装（男）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16051) ->
        #rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16051) ->
        #rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16051) ->
        #rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16051) ->
        #rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16051) ->
        #rand_base{
            base_id = 16051
            ,name = <<"圣诞时装（女）">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16052) ->
        #rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16052) ->
        #rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16052) ->
        #rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16052) ->
        #rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16052) ->
        #rand_base{
            base_id = 16052
            ,name = <<"新月无痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16053) ->
        #rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16053) ->
        #rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16053) ->
        #rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16053) ->
        #rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16053) ->
        #rand_base{
            base_id = 16053
            ,name = <<"晓梦迷蝶">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16054) ->
        #rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16054) ->
        #rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16054) ->
        #rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16054) ->
        #rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16054) ->
        #rand_base{
            base_id = 16054
            ,name = <<"绝代风华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16055) ->
        #rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16055) ->
        #rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16055) ->
        #rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16055) ->
        #rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16055) ->
        #rand_base{
            base_id = 16055
            ,name = <<"豆蔻年华">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16076) ->
        #rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16076) ->
        #rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16076) ->
        #rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16076) ->
        #rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16076) ->
        #rand_base{
            base_id = 16076
            ,name = <<"水墨年华（男）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16077) ->
        #rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16077) ->
        #rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16077) ->
        #rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16077) ->
        #rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16077) ->
        #rand_base{
            base_id = 16077
            ,name = <<"水墨年华（女）">>
            ,num = 1
            ,price = 388
            ,rand = 300
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16078) ->
        #rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16078) ->
        #rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16078) ->
        #rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16078) ->
        #rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16078) ->
        #rand_base{
            base_id = 16078
            ,name = <<"龙焰帝袍">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16079) ->
        #rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16079) ->
        #rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16079) ->
        #rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16079) ->
        #rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16079) ->
        #rand_base{
            base_id = 16079
            ,name = <<"缎绣绫纱">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16080) ->
        #rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16080) ->
        #rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16080) ->
        #rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16080) ->
        #rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16080) ->
        #rand_base{
            base_id = 16080
            ,name = <<"魂牵梦萦">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16081) ->
        #rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16081) ->
        #rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16081) ->
        #rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16081) ->
        #rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16081) ->
        #rand_base{
            base_id = 16081
            ,name = <<"月明千里">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16700) ->
        #rand_base{
            base_id = 16700
            ,name = <<"龙吟寒焰剑">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16701) ->
        #rand_base{
            base_id = 16701
            ,name = <<"龙吟寒焰刺">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16702) ->
        #rand_base{
            base_id = 16702
            ,name = <<"龙吟寒焰杖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16703) ->
        #rand_base{
            base_id = 16703
            ,name = <<"龙吟寒焰弓">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16704) ->
        #rand_base{
            base_id = 16704
            ,name = <<"龙吟寒焰枪">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16700) ->
        #rand_base{
            base_id = 16700
            ,name = <<"龙吟寒焰剑">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16701) ->
        #rand_base{
            base_id = 16701
            ,name = <<"龙吟寒焰刺">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16702) ->
        #rand_base{
            base_id = 16702
            ,name = <<"龙吟寒焰杖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16703) ->
        #rand_base{
            base_id = 16703
            ,name = <<"龙吟寒焰弓">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16704) ->
        #rand_base{
            base_id = 16704
            ,name = <<"龙吟寒焰枪">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16705) ->
        #rand_base{
            base_id = 16705
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16706) ->
        #rand_base{
            base_id = 16706
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16707) ->
        #rand_base{
            base_id = 16707
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16708) ->
        #rand_base{
            base_id = 16708
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16709) ->
        #rand_base{
            base_id = 16709
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16705) ->
        #rand_base{
            base_id = 16705
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16706) ->
        #rand_base{
            base_id = 16706
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16707) ->
        #rand_base{
            base_id = 16707
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16708) ->
        #rand_base{
            base_id = 16708
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16709) ->
        #rand_base{
            base_id = 16709
            ,name = <<"童年棒棒糖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16710) ->
        #rand_base{
            base_id = 16710
            ,name = <<"逐风之刃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16711) ->
        #rand_base{
            base_id = 16711
            ,name = <<"恶魔刀锋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16712) ->
        #rand_base{
            base_id = 16712
            ,name = <<"圣光祈福">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16713) ->
        #rand_base{
            base_id = 16713
            ,name = <<"万鸟朝凤">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16714) ->
        #rand_base{
            base_id = 16714
            ,name = <<"噬炎之怒">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16710) ->
        #rand_base{
            base_id = 16710
            ,name = <<"逐风之刃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16711) ->
        #rand_base{
            base_id = 16711
            ,name = <<"恶魔刀锋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16712) ->
        #rand_base{
            base_id = 16712
            ,name = <<"圣光祈福">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16713) ->
        #rand_base{
            base_id = 16713
            ,name = <<"万鸟朝凤">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16714) ->
        #rand_base{
            base_id = 16714
            ,name = <<"噬炎之怒">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16715) ->
        #rand_base{
            base_id = 16715
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16716) ->
        #rand_base{
            base_id = 16716
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16717) ->
        #rand_base{
            base_id = 16717
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16718) ->
        #rand_base{
            base_id = 16718
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16719) ->
        #rand_base{
            base_id = 16719
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16715) ->
        #rand_base{
            base_id = 16715
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16716) ->
        #rand_base{
            base_id = 16716
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16717) ->
        #rand_base{
            base_id = 16717
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16718) ->
        #rand_base{
            base_id = 16718
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16719) ->
        #rand_base{
            base_id = 16719
            ,name = <<"玫瑰物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16720) ->
        #rand_base{
            base_id = 16720
            ,name = <<"冰霜之牙">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16721) ->
        #rand_base{
            base_id = 16721
            ,name = <<"新月之痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16722) ->
        #rand_base{
            base_id = 16722
            ,name = <<"天使之眸">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16723) ->
        #rand_base{
            base_id = 16723
            ,name = <<"血龙之吼">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16724) ->
        #rand_base{
            base_id = 16724
            ,name = <<"死神之镰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16720) ->
        #rand_base{
            base_id = 16720
            ,name = <<"冰霜之牙">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16721) ->
        #rand_base{
            base_id = 16721
            ,name = <<"新月之痕">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16722) ->
        #rand_base{
            base_id = 16722
            ,name = <<"天使之眸">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16723) ->
        #rand_base{
            base_id = 16723
            ,name = <<"血龙之吼">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16724) ->
        #rand_base{
            base_id = 16724
            ,name = <<"死神之镰">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16725) ->
        #rand_base{
            base_id = 16725
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16726) ->
        #rand_base{
            base_id = 16726
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16727) ->
        #rand_base{
            base_id = 16727
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16728) ->
        #rand_base{
            base_id = 16728
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16729) ->
        #rand_base{
            base_id = 16729
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16725) ->
        #rand_base{
            base_id = 16725
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16726) ->
        #rand_base{
            base_id = 16726
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16727) ->
        #rand_base{
            base_id = 16727
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16728) ->
        #rand_base{
            base_id = 16728
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16729) ->
        #rand_base{
            base_id = 16729
            ,name = <<"万圣物语">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16730) ->
        #rand_base{
            base_id = 16730
            ,name = <<"寒晶雪霁剑">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16731) ->
        #rand_base{
            base_id = 16731
            ,name = <<"寒晶雪霁刃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16732) ->
        #rand_base{
            base_id = 16732
            ,name = <<"寒晶雪霁杖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16733) ->
        #rand_base{
            base_id = 16733
            ,name = <<"寒晶雪霁弓">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16734) ->
        #rand_base{
            base_id = 16734
            ,name = <<"寒晶雪霁刀">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16730) ->
        #rand_base{
            base_id = 16730
            ,name = <<"寒晶雪霁剑">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16731) ->
        #rand_base{
            base_id = 16731
            ,name = <<"寒晶雪霁刃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16732) ->
        #rand_base{
            base_id = 16732
            ,name = <<"寒晶雪霁杖">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16733) ->
        #rand_base{
            base_id = 16733
            ,name = <<"寒晶雪霁弓">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16734) ->
        #rand_base{
            base_id = 16734
            ,name = <<"寒晶雪霁刀">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16735) ->
        #rand_base{
            base_id = 16735
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16736) ->
        #rand_base{
            base_id = 16736
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16737) ->
        #rand_base{
            base_id = 16737
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16738) ->
        #rand_base{
            base_id = 16738
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16739) ->
        #rand_base{
            base_id = 16739
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16735) ->
        #rand_base{
            base_id = 16735
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16736) ->
        #rand_base{
            base_id = 16736
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16737) ->
        #rand_base{
            base_id = 16737
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16738) ->
        #rand_base{
            base_id = 16738
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16739) ->
        #rand_base{
            base_id = 16739
            ,name = <<"诗意写然">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16900) ->
        #rand_base{
            base_id = 16900
            ,name = <<"长生杯">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16901) ->
        #rand_base{
            base_id = 16901
            ,name = <<"五彩风车">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16902) ->
        #rand_base{
            base_id = 16902
            ,name = <<"合欢铃">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16903) ->
        #rand_base{
            base_id = 16903
            ,name = <<"玲珑鼎">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16904) ->
        #rand_base{
            base_id = 16904
            ,name = <<"奥运圣火">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16905) ->
        #rand_base{
            base_id = 16905
            ,name = <<"翡翠莲心">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16906) ->
        #rand_base{
            base_id = 16906
            ,name = <<"灵犀福袋">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16907) ->
        #rand_base{
            base_id = 16907
            ,name = <<"中国结">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 16908) ->
        #rand_base{
            base_id = 16908
            ,name = <<"吉祥图腾">>
            ,num = 1
            ,price = 888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18800) ->
        #rand_base{
            base_id = 18800
            ,name = <<"白色羽翼">>
            ,num = 1
            ,price = 188
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18801) ->
        #rand_base{
            base_id = 18801
            ,name = <<"鬼魅之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18803) ->
        #rand_base{
            base_id = 18803
            ,name = <<"天堂圣羽">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18804) ->
        #rand_base{
            base_id = 18804
            ,name = <<"精灵之翼">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18805) ->
        #rand_base{
            base_id = 18805
            ,name = <<"炽天使之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18806) ->
        #rand_base{
            base_id = 18806
            ,name = <<"寒冰之翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18807) ->
        #rand_base{
            base_id = 18807
            ,name = <<"梦霓羽翼">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18808) ->
        #rand_base{
            base_id = 18808
            ,name = <<"超时空推进器">>
            ,num = 1
            ,price = 1288
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 18809) ->
        #rand_base{
            base_id = 18809
            ,name = <<"圣光辉耀">>
            ,num = 1
            ,price = 2888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 32230) ->
        #rand_base{
            base_id = 32230
            ,name = <<"赤焰魔翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 32231) ->
        #rand_base{
            base_id = 32231
            ,name = <<"战天使之翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 33173) ->
        #rand_base{
            base_id = 33173
            ,name = <<"轻盈幻羽翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 1}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 1}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 1}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 1}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 1}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({1, 0}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({2, 0}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({3, 0}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({4, 0}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base({5, 0}, 33183) ->
        #rand_base{
            base_id = 33183
            ,name = <<"高达神翼翅膀变身卡">>
            ,num = 1
            ,price = 1888
            ,rand = 200
            ,bind = 0
            ,is_notice = 1
            ,limit = 1
            ,limit_time = {0,0}
            ,limit_num = {0,0}
            ,must_num = 0
        };
get_base(_, _) -> error.
