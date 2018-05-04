%%----------------------------------------------------
%% 服务器标志转换成平台数据
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(srv_id_mapping).
-export([
        get/1
        ,platform/1
        ,srv_sn/1
    ]
).

%% 获取平台名称
platform(SrvId) ->
    [Srv | _T] = re:split(bitstring_to_list(SrvId), "_", [{return, list}]),
    Srv1 = util:to_binary(Srv),
    srv_id_mapping:get(Srv1).

%% 获取第几服
srv_sn(SrvId) ->
    [Srv | _T] = lists:reverse(re:split(bitstring_to_list(SrvId), "_", [{return, list}])),
    case catch list_to_integer(Srv) of
        SrvSn when is_integer(SrvSn) -> SrvSn;
        _ -> 0
    end.

%% 服务器标志--->平台转换列表
get(<<"05wan">>) -> <<"领我玩">>;
get(<<"0807g">>) -> <<"如意盒子">>;
get(<<"1212">>) -> <<"1212wan">>;
get(<<"123wan">>) -> <<"123wan">>;
get(<<"158wan">>) -> <<"巨人158wan">>;
get(<<"175ha">>) -> <<"175ha">>;
get(<<"17dong">>) -> <<"17dong">>;
get(<<"17lele">>) -> <<"17lele">>;
get(<<"2133">>) -> <<"2133">>;
get(<<"263wan">>) -> <<"263wan">>;
get(<<"2667">>) -> <<"2667">>;
get(<<"2866">>) -> <<"2866">>;
get(<<"2918">>) -> <<"2918">>;
get(<<"31play">>) -> <<"31play">>;
get(<<"360">>) -> <<"360">>;
get(<<"3663">>) -> <<"3663">>;
get(<<"3722">>) -> <<"3722">>;
get(<<"3737">>) -> <<"3737">>;
get(<<"37wanwan">>) -> <<"37玩玩">>;
get(<<"37wan">>) -> <<"37wan">>;
get(<<"3977">>) -> <<"3977">>;
get(<<"4311">>) -> <<"4311">>;
get(<<"4399">>) -> <<"4399">>;
get(<<"49you">>) -> <<"49you">>;
get(<<"5037">>) -> <<"5037">>;
get(<<"51com">>) -> <<"51.com">>;
get(<<"51wan">>) -> <<"51wan">>;
get(<<"522you">>) -> <<"552游">>;
get(<<"54op">>) -> <<"54op">>;
get(<<"56uu">>) -> <<"56uu">>;
get(<<"591yo">>) -> <<"591yo">>;
get(<<"616wan">>) -> <<"616wan">>;
get(<<"61">>) -> <<"61">>;
get(<<"63wan">>) -> <<"63wan">>;
get(<<"6543">>) -> <<"6543">>;
get(<<"655u">>) -> <<"655u">>;
get(<<"65wan">>) -> <<"65wan">>;
get(<<"666wan">>) -> <<"666wan">>;
get(<<"6711">>) -> <<"6711">>;
get(<<"766z">>) -> <<"766z">>;
get(<<"7k7k">>) -> <<"7k7k">>;
get(<<"8090">>) -> <<"8090">>;
get(<<"87kd">>) -> <<"飘渺">>;
get(<<"8zy">>) -> <<"八爪鱼">>;
get(<<"90w">>) -> <<"查不到">>;
get(<<"915">>) -> <<"915">>;
get(<<"91com">>) -> <<"91.com">>;
get(<<"91wan">>) -> <<"91wan">>;
get(<<"91yx">>) -> <<"91yx">>;
get(<<"92you">>) -> <<"92you">>;
get(<<"9377">>) -> <<"9377">>;
get(<<"95k">>) -> <<"95k">>;
get(<<"966wan">>) -> <<"查不到">>;
get(<<"96ak">>) -> <<"96ak">>;
get(<<"9qwan">>) -> <<"就去玩">>;
get(<<"baidu">>) -> <<"百度">>;
get(<<"bigzhu">>) -> <<"大猪网">>;
get(<<"bingc">>) -> <<"星之游">>;
get(<<"cespc">>) -> <<"竞游">>;
get(<<"cmgame">>) -> <<"中国移动">>;
get(<<"cwyx">>) -> <<"畅玩">>;
get(<<"dipan">>) -> <<"地盘网">>;
get(<<"eq">>) -> <<"EQ35">>;
get(<<"feixue">>) -> <<"电玩巴士">>;
get(<<"funshion">>) -> <<"风行">>;
get(<<"g361">>) -> <<"查不到">>;
get(<<"game141">>) -> <<"game141">>;
get(<<"game2">>) -> <<"趣游哥们">>;
get(<<"game66">>) -> <<"game66">>;
get(<<"gamefy">>) -> <<"查不到">>;
get(<<"games7080">>) -> <<"games7080">>;
get(<<"givia">>) -> <<"查不到">>;
get(<<"gviva">>) -> <<"哥玩">>;
get(<<"hly">>) -> <<"欢乐园">>;
get(<<"huowan">>) -> <<"火玩">>;
get(<<"ichengzi">>) -> <<"易橙">>;
get(<<"ihuanju">>) -> <<"欢聚网 ">>;
get(<<"iugame">>) -> <<"欢聚网 ">>;
get(<<"juu">>) -> <<"聚游">>;
get(<<"kaixin">>) -> <<"开心网">>;
get(<<"kedou">>) -> <<"蝌蚪">>;
get(<<"kkguo">>) -> <<"可可国 ">>;
get(<<"koramgame">>) -> <<"马来西亚">>;
get(<<"kuaiwan">>) -> <<"快玩">>;
get(<<"kugou">>) -> <<"酷狗">>;
get(<<"kunlun">>) -> <<"昆仑">>;
get(<<"kuwo">>) -> <<"酷我">>;
get(<<"lava">>) -> <<"点击lava ">>;
get(<<"lkgame">>) -> <<"老Klkgame ">>;
get(<<"maxthon">>) -> <<"傲游">>;
get(<<"mhfx">>) -> <<"mhfx">>;
get(<<"pchome">>) -> <<"pchome">>;
get(<<"pps">>) -> <<"PPS">>;
get(<<"pptv">>) -> <<"PPTV">>;
get(<<"qq163">>) -> <<"qq163">>;
get(<<"renren">>) -> <<"人人网">>;
get(<<"rising">>) -> <<"瑞星">>;
get(<<"sdo">>) -> <<"盛大">>;
get(<<"sina">>) -> <<"新浪">>;
get(<<"sogou">>) -> <<"搜狗">>;
get(<<"sohu">>) -> <<"搜狐">>;
get(<<"sosowan">>) -> <<"sosowan">>;
get(<<"taiwan">>) -> <<"台灣">>;
get(<<"xmfx">>) -> <<"台灣">>;
get(<<"te6">>) -> <<"特牛">>;
get(<<"tymmo">>) -> <<"特游">>;
get(<<"ufojoy">>) -> <<"飞碟游戏">>;
get(<<"uu178">>) -> <<"UU178">>;
get(<<"uuplay">>) -> <<"UUplay">>;
get(<<"ux18">>) -> <<"ux18">>;
get(<<"vvwan">>) -> <<"vvwan">>;
get(<<"wanyou365">>) -> <<"万游">>;
get(<<"weibo">>) -> <<"微游戏">>;
get(<<"wiseie">>) -> <<"wiseie">>;
get(<<"xdwan">>) -> <<"xdwan">>;
get(<<"xilu">>) -> <<"西陆">>;
get(<<"xjwa">>) -> <<"新疆娃">>;
get(<<"xunlei">>) -> <<"迅雷">>;
get(<<"ya247">>) -> <<"ya247">>;
get(<<"yaowan">>) -> <<"要玩">>;
get(<<"youc">>) -> <<"youc">>;
get(<<"youkia">>) -> <<"youkia">>;
get(<<"youwo">>) -> <<"游窝">>;
get(<<"youximenhu">>) -> <<"联合互动">>;
get(<<"youxi">>) -> <<"youxi">>;
get(<<"yx78">>) -> <<"yx78">>;
get(<<"yy">>) -> <<"多玩">>;
get(<<"zhigame">>) -> <<"智游">>;
get(<<"zhulang">>) -> <<"逐浪">>;
get(<<"zixia">>) -> <<"紫霞">>;
get(SrvId) -> SrvId.
