%%----------------------------------------------------
%%  帮会系统订阅中心
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_rss).
-export([start/1
        ,transfer/1
        ,dismiss/1
        ,upgrade_lev/1
    ]
).

-include("guild.hrl").
-include("common.hrl").

%% 创建帮会初始化
start(Guild = #guild{id = {Gid, Gsrvid}}) ->
    rank:listener(guild_lev, Guild),                         %% 排行榜监听
    guild_mgr:listen(guild_rank, Guild),                     %% 排行榜监听
    guild_pool:new_guild(Guild),                             %% 帮会仙泉监听
    guild_mem:start(Guild),                                  %% 帮会成员管理监听
    guild_practise_mgr:apply(async, {load, Guild}),          %% 帮会历练数据加载 新帮会、数据同步
    guild_treasure:start({Gid, Gsrvid}),                      %% 宝库函数
    guild_store:start({Gid, Gsrvid}),                       %% 仓库函数
    guild_common:start({Gid, Gsrvid}),
    catch guild_boss:vip_upgrade({Gid, Gsrvid}),            %% 幫會BOSS 
    ok;
start(_Guild) -> ok.

%% 转让了帮主
transfer(Guild) ->
    guild_mgr:listen(guild_rank, Guild),     %% 帮会管理进程 数据副本监听
    rank:listener(guild_lev, Guild),         %% 排行榜监听
    ok.

%% 帮会升级
upgrade_lev(Guild = #guild{id = {Gid, Gsrvid}, lev = Lev}) ->
    rank:listener(guild_lev, Guild),                     %% 排行榜监听
    guild_td_mgr:sign_guild_td({Gid, Gsrvid}, Lev),      %% 帮会副本监听
    npc_store:guild_lev_up(Guild),                          %% 帮贡商店
    ok.

%% 帮会解散了
dismiss(#guild{id = {Gid, Gsrvid}, lev = Lev, name = Gname}) ->
    guild_td_mgr:guild_destroy({Gid,Gsrvid}, Lev),      %% 通知帮会副本
    guild_mgr:mgr_cast({dismiss, Gid, Gsrvid, Gname}),  %% 通知管理进程
    ok.