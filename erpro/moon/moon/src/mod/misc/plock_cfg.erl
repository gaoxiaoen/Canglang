%% **************************
%% 密码锁配置文件
%% @author wpf (wprehard@qq.com)
%% **************************

-module(plock_cfg).
-export([
        check/3
        ,handle_locked/3
    ]).

-include("role.hrl").
-include("link.hrl").

%% 密码锁检测配置：
%% check/4 匹配需要检测的操作
%% handle_lock/4 特殊处理客户端返回

%% @spec check(Mod, Cmd) -> boolean()
%% @doc 返回是否需要检测密码锁
%% <div>
%%  1、默认返回false不做检测
%%  2、各个模块自行添加需要检测的协议操作，并做好注释
%%  3、"晶钻消费"的操作
%%      a、没有通过role_gain:do/2接口调用晶钻消费的，需要检测
%%      b、其他的考虑到返回提示问题，视情况可以不在这里检测
%% </div>
%% ----------------------------------------------
%% item模块
check(item_rpc, 10333, _) -> true;
check(item_rpc, 10330, _) -> true; %% 删除物品
%% vip模块
check(vip_rpc, 12404, _) -> true;
%% market模块
check(market_rpc, 11302, _) -> true;
check(market_rpc, 11303, _) -> true;
check(market_rpc, 11304, _) -> true;
check(market_rpc, 11305, _) -> true;
check(market_rpc, 11306, _) -> true;
check(market_rpc, 11332, _) -> true;
check(market_rpc, 11334, _) -> true;
%% 帮会
check(guild_rpc, 12712, _) -> true;
check(guild_rpc, 12727, _) -> true;
%% 商城
check(shop_rpc, 12010, _) -> true;
check(shop_rpc, 12015, _) -> true;
check(shop_rpc, 12016, _) -> true;
check(shop_rpc, 12020, _) -> true;
check(shop_rpc, 12025, _) -> true;
check(shop_rpc, 12026, _) -> true;
check(shop_rpc, 12027, _) -> true;
%% 交易
check(exchange_rpc, 11200, _) -> true;
check(exchange_rpc, 11205, _) -> true;
%% 炼炉
check(blacksmith_rpc, 10502, _) -> false;
check(blacksmith_rpc, 10503, _) -> false;
check(blacksmith_rpc, 10525, _) -> false;
check(blacksmith_rpc, Proto, _) when Proto >= 10536 andalso Proto =< 10538 -> false;
check(blacksmith_rpc, _, _) -> true;
%% 技能
check(skill_rpc, 11501, _) -> true; %% 技能熟练度购买
check(skill_rpc, 11506, _) -> true; %% 技能熟练度购买
%% 元神
check(channel_rpc, 12903, _) -> true;
check(channel_rpc, 12905, _) -> true;
check(channel_rpc, 12912, _) -> true;
%% 飞鞋
check(role_rpc, 10021, {Type, _, _, _}) when Type =:= 3 -> true;
%% 宠物
check(pet_rpc, 12601, _) -> true;
check(pet_rpc, 12608, _) -> true;
check(pet_rpc, 12609, _) -> true;
check(pet_rpc, 12611, _) -> true;
check(pet_rpc, 12614, _) -> true;
check(pet_rpc, 12615, _) -> true;
check(pet_rpc, 12616, _) -> true;
check(pet_rpc, 12617, _) -> true;
check(pet_rpc, 12621, _) -> true;
check(pet_rpc, 12622, _) -> true;
check(pet_rpc, 12626, _) -> true;
check(pet_rpc, 12661, _) -> true;
check(pet_rpc, 12662, _) -> true;
check(pet_rpc, 12663, _) -> true;
check(pet_rpc, 12665, _) -> true;
check(pet_rpc, 12666, _) -> true;
check(pet_rpc, 12670, _) -> true;
check(pet_rpc, 12671, _) -> true;
check(pet_rpc, 12672, _) -> true;
check(pet_rpc, 12673, _) -> true;
check(pet_rpc, 12674, _) -> true;
%% NPC商店
check(npc_store_rpc, 11903, _) -> true;
check(npc_store_rpc, 11905, _) -> true;
check(npc_store_rpc, 11907, _) -> true;
check(npc_store_rpc, 11908, _) -> true;
%% 信件
check(mail_rpc, 11701, _) -> true;
check(mail_rpc, 11703, _) -> true;
%% 坐骑
check(mount_rpc, 12502, _) -> true;
check(mount_rpc, 12508, _) -> true;
check(mount_rpc, 12510, _) -> true;
%% 仙境寻宝
check(casino_rpc, 14205, _) -> true;
check(casino_rpc, 14203, _) -> true;
%% 离线经验
check(offline_exp_rpc, 13904, {3, _}) -> true; %% 晶钻领取
%% 帮会
check(guild_rpc, 12703, _) -> true;
check(guild_rpc, 12706, _) -> true;
check(guild_rpc, 12720, _) -> true;
%% 好友
check(sns_rpc, 12120, _) -> true;
check(sns_rpc, 12157, _) -> true;
%% 刷镖
check(escort_rpc, 13101, {2}) -> true;
check(escort_rpc, 13109, {2}) -> true;
%% 嘉年华
%% check(lottery_rpc, 14705, _) -> true;
check(lottery_rpc, 14734, _) -> true;
%% 副本
check(dungeon_rpc, 13542, _) -> true;
%% 副本挂机
check(dungeon_rpc, 13565, _) -> true;
%% 任务
check(task_rpc, 10217, _) -> true;
check(task_rpc, 10221, _) -> true;
%% 通缉发布
check(wanted_rpc, 15001, _) -> true;
%% 师门竞技
check(arena_career_rpc, 16104, _) -> true;
check(arena_career_rpc, 16105, _) -> true;
%% 护送
check(escort_rpc, 13101, _) -> true;
check(escort_rpc, 13109, _) -> true;
%% 翅膀
check(wing_rpc, 16705, _) -> true;
check(wing_rpc, 16709, _) -> true;
check(wing_rpc, 16710, _) -> true;
check(wing_rpc, 16711, _) -> true;
check(wing_rpc, 16712, _) -> true;
check(wing_rpc, 16713, _) -> true;
%% 守护
check(demon_rpc, 17227, _) -> true;
check(demon_rpc, 17225, {0}) -> false;
check(demon_rpc, 17225, _) -> true;
%% 神魔阵
check(soul_world_rpc, 17901, _) -> true;
check(soul_world_rpc, 17909, _) -> true;

%% 其他忽略
check(_, _, _) -> false.

%% @spec handle_locked(Cmd, Data, Role) -> ok | {ok, NewRole}
%% @doc 处理有锁情况下的操作及返回
%% ----------------------------------------------
%% item模块
handle_locked(10330, {Id, StorageType}, #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 10330, {Id, StorageType, 0, <<>>}),
    ok;

%% 其他 返回ok
handle_locked(_Cmd, _Data, _Role) -> ok.
