%%----------------------------------------------------
%% 时装数据
%% 增加 时间 武饰 足迹 聊天框 等衣柜内容都需要修改这张表
%% @author shawn 
%%----------------------------------------------------
-module(item_dress_data).
-export([
        baseid_to_id/1
        ,get_dress_type/1
        ,to_sex/1
    ]
).

-include("item.hrl").

%% 真武男
%% 真武女
%% 贤者男
%% 贤者女
%% 飞羽男
%% 飞羽女
%% 刺客男
%% 刺客女
%% 骑士男
%% 骑士女
baseid_to_id(16000) -> 1;
baseid_to_id(16001) -> 1;
baseid_to_id(16002) -> 1;
baseid_to_id(16003) -> 1;
baseid_to_id(16004) -> 1;
baseid_to_id(16005) -> 1;
baseid_to_id(16006) -> 1;
baseid_to_id(16007) -> 1;
baseid_to_id(16008) -> 1;
baseid_to_id(16009) -> 1;
%% 云锦时装
%% 流萦时装
baseid_to_id(16010) -> 2;
baseid_to_id(16011) -> 2;
%% 职业第二套
baseid_to_id(16012) -> 3;
baseid_to_id(16013) -> 3;
baseid_to_id(16014) -> 3;
baseid_to_id(16015) -> 3;
baseid_to_id(16016) -> 3;
baseid_to_id(16017) -> 3;
baseid_to_id(16018) -> 3;
baseid_to_id(16019) -> 3;
baseid_to_id(16020) -> 3;
baseid_to_id(16021) -> 3;
%% 公共第二套
baseid_to_id(16022) -> 4;
baseid_to_id(16023) -> 4;
%% 公共第三套
baseid_to_id(16024) -> 5;
baseid_to_id(16025) -> 5;
%% 公共第四套
baseid_to_id(16026) -> 6;
baseid_to_id(16027) -> 6;
%% 公共第五套
baseid_to_id(16028) -> 7;
baseid_to_id(16029) -> 7;
%% 公共第五套
baseid_to_id(16030) -> 8;
baseid_to_id(16031) -> 8;
%% 公共第六套
baseid_to_id(16032) -> 9;
baseid_to_id(16033) -> 9;
%% 公共第七套
baseid_to_id(16034) -> 10;
baseid_to_id(16035) -> 10;
%% 公共第八套
baseid_to_id(16036) -> 11;
baseid_to_id(16037) -> 11;
%% 公共第九套
baseid_to_id(16038) -> 12;
baseid_to_id(16039) -> 12;
%% 公共第十套
baseid_to_id(16040) -> 13;
baseid_to_id(16041) -> 13;
%% 公共第十一套
baseid_to_id(16042) -> 14;
baseid_to_id(16043) -> 14;
%% 公共第十二套
baseid_to_id(16044) -> 15;
baseid_to_id(16045) -> 15;
%% 公共第十三套
baseid_to_id(16046) -> 16;
baseid_to_id(16047) -> 16;
%% 公共第十四套
baseid_to_id(16048) -> 17;
baseid_to_id(16049) -> 17;
%% 公共第十五套
baseid_to_id(16050) -> 18;
baseid_to_id(16051) -> 18;
%% 公共第十六套
baseid_to_id(16052) -> 19;
baseid_to_id(16053) -> 19;
%% 公共第十七套
baseid_to_id(16054) -> 20;
baseid_to_id(16055) -> 20;
%% 职业第三套
baseid_to_id(16056) -> 21;
baseid_to_id(16057) -> 21;
baseid_to_id(16058) -> 22;
baseid_to_id(16059) -> 22;
baseid_to_id(16060) -> 21;
baseid_to_id(16061) -> 21;
baseid_to_id(16062) -> 22;
baseid_to_id(16063) -> 22;
baseid_to_id(16064) -> 21;
baseid_to_id(16065) -> 21;
baseid_to_id(16066) -> 22;
baseid_to_id(16067) -> 22;
baseid_to_id(16068) -> 21;
baseid_to_id(16069) -> 21;
baseid_to_id(16070) -> 22;
baseid_to_id(16071) -> 22;
baseid_to_id(16072) -> 21;
baseid_to_id(16073) -> 21;
baseid_to_id(16074) -> 22;
baseid_to_id(16075) -> 22;
%% 公共第十八套
baseid_to_id(16076) -> 23;
baseid_to_id(16077) -> 23;
%% 公共第十九套
baseid_to_id(16078) -> 24;
baseid_to_id(16079) -> 24;
%% 公共第二十套
baseid_to_id(16080) -> 25;
baseid_to_id(16081) -> 25;
%% 公共第二十一套
baseid_to_id(16082) -> 26;
baseid_to_id(16083) -> 26;
%% 公共第二十二套
baseid_to_id(16084) -> 27;
baseid_to_id(16085) -> 27;
%% 公共第二十三套
baseid_to_id(16086) -> 28;
baseid_to_id(16087) -> 28;
%% 公共第二十四套
baseid_to_id(16088) -> 29;
baseid_to_id(16089) -> 29;
%% 公共第二十五套
baseid_to_id(16090) -> 30;
baseid_to_id(16091) -> 30;
%% 公共第二十六套
baseid_to_id(16092) -> 31;
baseid_to_id(16093) -> 31;
%% 公共第二十七套
baseid_to_id(16094) -> 32;
baseid_to_id(16095) -> 32;

%% -------------------
%% 翅膀
baseid_to_id(18800) -> 100;
baseid_to_id(18801) -> 101;
baseid_to_id(18802) -> 102;
baseid_to_id(18803) -> 103;
baseid_to_id(18804) -> 104;
baseid_to_id(18805) -> 105;
baseid_to_id(18806) -> 106;
baseid_to_id(18807) -> 107;
baseid_to_id(18808) -> 108;
baseid_to_id(18809) -> 109;

%% -------------------
%% 武器饰品
%% 龙吟套
baseid_to_id(16700) -> 200;
baseid_to_id(16701) -> 200;
baseid_to_id(16702) -> 200;
baseid_to_id(16703) -> 200;
baseid_to_id(16704) -> 200;
%%   棒棒糖
baseid_to_id(16705) -> 201;
baseid_to_id(16706) -> 201;
baseid_to_id(16707) -> 201;
baseid_to_id(16708) -> 201;
baseid_to_id(16709) -> 201;
%% 
baseid_to_id(16710) -> 202;
baseid_to_id(16711) -> 202;
baseid_to_id(16712) -> 202;
baseid_to_id(16713) -> 202;
baseid_to_id(16714) -> 202;
%% 
baseid_to_id(16715) -> 203;
baseid_to_id(16716) -> 203;
baseid_to_id(16717) -> 203;
baseid_to_id(16718) -> 203;
baseid_to_id(16719) -> 203;
%% 
baseid_to_id(16720) -> 204;
baseid_to_id(16721) -> 204;
baseid_to_id(16722) -> 204;
baseid_to_id(16723) -> 204;
baseid_to_id(16724) -> 204;
%%
baseid_to_id(16725) -> 205;
baseid_to_id(16726) -> 205;
baseid_to_id(16727) -> 205;
baseid_to_id(16728) -> 205;
baseid_to_id(16729) -> 205;
%%
baseid_to_id(16730) -> 206;
baseid_to_id(16731) -> 206;
baseid_to_id(16732) -> 206;
baseid_to_id(16733) -> 206;
baseid_to_id(16734) -> 206;
%%
baseid_to_id(16735) -> 207;
baseid_to_id(16736) -> 207;
baseid_to_id(16737) -> 207;
baseid_to_id(16738) -> 207;
baseid_to_id(16739) -> 207;
%%
baseid_to_id(16740) -> 208;
baseid_to_id(16741) -> 208;
baseid_to_id(16742) -> 208;
baseid_to_id(16743) -> 208;
baseid_to_id(16744) -> 208;
%%
baseid_to_id(16745) -> 209;
baseid_to_id(16746) -> 209;
baseid_to_id(16747) -> 209;
baseid_to_id(16748) -> 209;
baseid_to_id(16749) -> 209;
%%
baseid_to_id(16750) -> 210;
baseid_to_id(16751) -> 210;
baseid_to_id(16752) -> 210;
baseid_to_id(16753) -> 210;
baseid_to_id(16754) -> 210;
%%
baseid_to_id(16755) -> 211;
baseid_to_id(16756) -> 211;
baseid_to_id(16757) -> 211;
baseid_to_id(16758) -> 211;
baseid_to_id(16759) -> 211;
%%
baseid_to_id(16760) -> 212;
baseid_to_id(16761) -> 212;
baseid_to_id(16762) -> 212;
baseid_to_id(16763) -> 212;
baseid_to_id(16764) -> 212;

%% -------------------
%% 挂饰 
baseid_to_id(16900) -> 300;
baseid_to_id(16901) -> 301;
baseid_to_id(16902) -> 302;
baseid_to_id(16903) -> 303;
baseid_to_id(16904) -> 304;
baseid_to_id(16905) -> 305;
baseid_to_id(16906) -> 306;
baseid_to_id(16907) -> 307;

%%------------------------
%% 足迹
baseid_to_id(16400) -> 400;
baseid_to_id(16401) -> 401;
baseid_to_id(16402) -> 402;
baseid_to_id(16403) -> 403;
baseid_to_id(16404) -> 404;
baseid_to_id(16405) -> 405;
baseid_to_id(16406) -> 406;
baseid_to_id(16407) -> 407;

%%-----------------------
%% 炫酷聊天框
baseid_to_id(16500) -> 500;
baseid_to_id(16501) -> 501;
baseid_to_id(16502) -> 502;
baseid_to_id(16503) -> 503;
baseid_to_id(16504) -> 504;
baseid_to_id(16505) -> 505;

%%-----------------------
%% 个性文字
baseid_to_id(16600) -> 600;
baseid_to_id(16601) -> 601.

get_dress_type(BaseId) ->
    case item_data:get(BaseId) of
        {ok, #item_base{type = ?item_shi_zhuang}} -> dress;
        {ok, #item_base{type = ?item_weapon_dress}} -> weapon_dress;
        {ok, #item_base{type = ?item_jewelry_dress}} -> jewelry_dress;
        {ok, #item_base{type = ?item_footprint}} -> footprint;
        {ok, #item_base{type = ?item_chat_frame}} -> chat_frame;
        {ok, #item_base{type = ?item_text_style}} -> text_style;
        _ -> false
    end.

%% -------------------------------
%% 转换性别
to_sex(16000) -> 16001;
to_sex(16001) -> 16000;
to_sex(16002) -> 16003;
to_sex(16003) -> 16002;
to_sex(16004) -> 16005;
to_sex(16005) -> 16004;
to_sex(16006) -> 16007;
to_sex(16007) -> 16006;
to_sex(16008) -> 16009;
to_sex(16009) -> 16008;
to_sex(16010) -> 16011;
to_sex(16011) -> 16010;
to_sex(16012) -> 16013;
to_sex(16013) -> 16012;
to_sex(16014) -> 16015;
to_sex(16015) -> 16014;
to_sex(16016) -> 16017;
to_sex(16017) -> 16016;
to_sex(16018) -> 16019;
to_sex(16019) -> 16018;
to_sex(16020) -> 16021;
to_sex(16021) -> 16020;
to_sex(16022) -> 16023;
to_sex(16023) -> 16022;
to_sex(16024) -> 16025;
to_sex(16025) -> 16024;
to_sex(16026) -> 16027;
to_sex(16027) -> 16026;
to_sex(16028) -> 16029;
to_sex(16029) -> 16028;
to_sex(16030) -> 16031;
to_sex(16031) -> 16030;
to_sex(16032) -> 16033;
to_sex(16033) -> 16032;
to_sex(16034) -> 16035;
to_sex(16035) -> 16034;
to_sex(16036) -> 16037;
to_sex(16037) -> 16036;
to_sex(16038) -> 16039;
to_sex(16039) -> 16038;
to_sex(16040) -> 16041;
to_sex(16041) -> 16040;
to_sex(16042) -> 16043;
to_sex(16043) -> 16042;
to_sex(16044) -> 16045;
to_sex(16045) -> 16044;
to_sex(16046) -> 16047;
to_sex(16047) -> 16046;
to_sex(16048) -> 16049;
to_sex(16049) -> 16048;
to_sex(16050) -> 16051;
to_sex(16051) -> 16050;
to_sex(16052) -> 16053;
to_sex(16053) -> 16052;
to_sex(16054) -> 16055;
to_sex(16055) -> 16054;
to_sex(16056) -> 16057;
to_sex(16057) -> 16056;
to_sex(16058) -> 16059;
to_sex(16059) -> 16058;
to_sex(16060) -> 16061;
to_sex(16061) -> 16060;
to_sex(16062) -> 16063;
to_sex(16063) -> 16062;
to_sex(16064) -> 16065;
to_sex(16065) -> 16064;
to_sex(16066) -> 16067;
to_sex(16067) -> 16066;
to_sex(16068) -> 16069;
to_sex(16069) -> 16068;
to_sex(16070) -> 16071;
to_sex(16071) -> 16070;
to_sex(16072) -> 16073;
to_sex(16073) -> 16072;
to_sex(16074) -> 16075;
to_sex(16075) -> 16074;
to_sex(16076) -> 16077;
to_sex(16077) -> 16076;
to_sex(16078) -> 16079;
to_sex(16079) -> 16078;
to_sex(16080) -> 16081;
to_sex(16081) -> 16080;
to_sex(16082) -> 16083;
to_sex(16083) -> 16082;
to_sex(16084) -> 16085;
to_sex(16085) -> 16084;
to_sex(16086) -> 16087;
to_sex(16087) -> 16086;
to_sex(16088) -> 16089;
to_sex(16089) -> 16088;
to_sex(16090) -> 16091;
to_sex(16091) -> 16090;
to_sex(16092) -> 16093;
to_sex(16093) -> 16092;
to_sex(16094) -> 16095;
to_sex(16095) -> 16094;
%% TODO: 时装有新增加男女装时更新到此处

to_sex(_) -> false.
