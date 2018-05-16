%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十二月 2015 下午3:34
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-define(CHAT_TYPE_PUBLIC, 1).
-define(CHAT_TYPE_TEAM, 2).
-define(CHAT_TYPE_FRIEND, 3).
-define(CHAT_TYPE_GUILD, 4).
-define(CHAT_TYPE_KF, 6).
-define(CHAT_TYPE_SCENE, 8).
-define(CHAT_TYPE_SCENE_GROUP, 9).
-define(CHAT_TYPE_CROSS_WAR_DEF, 10).
-define(CHAT_TYPE_CROSS_WAR_ATT, 11).
-define(CHAT_TYPE_WAR_TEAM, 12).

%%私聊记录
-record(fri_chat, {
    mykey = 0, %%自己key
    pkey = 0,  %%对方key
    name = "",  %%对方名字
    avatar = "",%%头像地址
    psex = 1,   %%对方性别 1男 2女
    vip = 0,    %%对方vip
    career = 0, %%对方职业
    chat_list = [] %%聊天历史
}).