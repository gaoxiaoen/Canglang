%% **************************************
%% 日志常用字段转换接口
%% @author wpf (wprehard@qq.com)
%% **************************************
-module(log_conv).
-export([
        item/2
        ,parse_item/2
        ,parse_shop_buy_items/1
        ,parse_shop_activity_items/1
        ,npc/2
        ,exchange/2
        ,market/2
        ,score/2
        ,channel/2
        ,ip2bitstring/4
        ,ip2bitstring/1
    ]).
-include("item.hrl").
-include("storage.hrl").
-include("npc.hrl").
-include("market.hrl").
-include("npc_store.hrl").
-include("channel.hrl").

%% @spec parse_item(List, LogInfos) -> list()
%% 解析角色role_gain操作的物品信息，用于物品消耗日志记录
parse_item([], Logs) -> Logs;
parse_item([{Type, _, Dels, Freshs} | T], Logs) ->
    parse_item(T, [{Type, Dels ++ parse_item_fresh(Freshs)} | Logs]).
%% 提取(BaseId, Bind)
parse_item_fresh(Freshs) ->
    parse_item_fresh(Freshs, []).
parse_item_fresh([], IL) -> IL;
parse_item_fresh([#item{base_id = BaseId, bind = Bind} | T], IL) ->
    parse_item_fresh(T, [{BaseId, Bind} | IL]);
parse_item_fresh([_ | T], IL) ->
    parse_item_fresh(T, IL).

%% @spec parse_shop_buy_items(Items) -> bitstring()
%% @doc 解析商城购买的物品列表，记录晶钻日志备注项
parse_shop_buy_items([#item{base_id = BaseId, quantity = Num} | T]) ->
    Name = log_conv:item(name, BaseId),
    parse_shop_buy_items(T, util:fbin(<<"购买:~sx~w">>, [Name, Num]));
parse_shop_buy_items([_ | _]) -> <<"购买了未知物品">>.
parse_shop_buy_items([], Remark) -> Remark;
parse_shop_buy_items([#item{base_id = BaseId, quantity = Num} | T], Remark) ->
    Name = log_conv:item(name, BaseId),
    parse_shop_buy_items(T, util:fbin(<<"~s,~sx~w">>, [Remark, Name, Num])).

%% @spec parse_shop_activity_items(Items) -> list
%% @doc 解析活动商城购买的物品列表
parse_shop_activity_items([#item{base_id = BaseId, quantity = Num} | T]) ->
    Name = log_conv:item(name, BaseId),
    parse_shop_activity_items(T, [{BaseId, Name, Num}]);
parse_shop_activity_items([_ | _]) -> <<"购买了未知物品">>.
parse_shop_activity_items([], Remark) -> Remark;
parse_shop_activity_items([#item{base_id = BaseId, quantity = Num} | T], Remark) ->
    Name = log_conv:item(name, BaseId),
    parse_shop_activity_items(T, [{BaseId, Name, Num} | Remark]).

%% @spec item(ConvertType, Val) -> bitstring()
%% ConvertType = atom()
%% @doc 根据类型和参数值，获取相应返回
item(quality, BaseId) ->
    case item_data:get(BaseId) of
        {ok, #item_base{quality = 0}} -> <<"白色">>;
        {ok, #item_base{quality = 1}} -> <<"绿色">>;
        {ok, #item_base{quality = 2}} -> <<"蓝色">>;
        {ok, #item_base{quality = 3}} -> <<"紫色">>;
        {ok, #item_base{quality = 4}} -> <<"粉色">>;
        {ok, #item_base{quality = 5}} -> <<"橙色">>;
        {ok, #item_base{quality = 6}} -> <<"金色">>;
        
        _ -> <<"无色">>
    end;
item(type, BaseId) ->
    %% 具体定义见策划item_data.xml表
    case item_data:get(BaseId) of
        {ok, #item_base{type = 0}} -> <<"其它类">>;
        {ok, #item_base{type = 01}} -> <<"飞剑">>;
        {ok, #item_base{type = 02}} -> <<"匕首">>;
        {ok, #item_base{type = 03}} -> <<"法杖">>;
        {ok, #item_base{type = 04}} -> <<"神弓">>;
        {ok, #item_base{type = 05}} -> <<"长枪">>;
        {ok, #item_base{type = 06}} -> <<"护手">>;
        {ok, #item_base{type = 07}} -> <<"护腕">>;
        {ok, #item_base{type = 08}} -> <<"腰带">>;
        {ok, #item_base{type = 09}} -> <<"鞋子">>;
        {ok, #item_base{type = 10}} -> <<"裤子">>;
        {ok, #item_base{type = 11}} -> <<"衣服">>;
        {ok, #item_base{type = 12}} -> <<"护符">>;
        {ok, #item_base{type = 13}} -> <<"戒指">>;
        {ok, #item_base{type = 14}} -> <<"时装">>;
        {ok, #item_base{type = 15}} -> <<"仙戒">>;
        {ok, #item_base{type = 16}} -> <<"任务类物品">>;
        {ok, #item_base{type = 17}} -> <<"坐骑">>;
        {ok, #item_base{type = 18}} -> <<"生产原料">>;
        {ok, #item_base{type = 19}} -> <<"丹药">>;
        {ok, #item_base{type = 20}} -> <<"技能道具">>;
        {ok, #item_base{type = 21}} -> <<"仙宠道具">>;
        {ok, #item_base{type = 28}} -> <<"镶嵌道具">>;
        {ok, #item_base{type = 30}} -> <<"元神道具">>;
        {ok, #item_base{type = 38}} -> <<"翅膀">>;
        _ -> <<"神马物品">>
    end;
item(name, #item{base_id = BaseId}) ->
    item(name, BaseId);
item(name, 30000) -> <<"金币">>;
item(name, 30003) -> <<"晶钻">>;
item(name, BaseId) -> 
    case item_data:get(BaseId) of
        {ok, #item_base{name = Name}} -> Name;
        _ -> <<"未知">>
    end;
item(base_id, #item{base_id = BaseId}) ->
    BaseId;
item(base_id, _) ->
    0;
item(bind, #item{bind = Bind}) ->
    Bind;
item(bind, _) ->
    10;
item(storage, ?storage_bag)     -> <<"背包">>;
item(storage, ?storage_store)	-> <<"仓库">>;
item(storage, ?storage_eqm)     -> <<"装备格">>;
item(storage, ?storage_collect)	-> <<"采集">>;
item(storage, ?storage_task)	-> <<"任务背包 ">>;
item(storage, ?storage_guild)	-> <<"帮会仓库">>;
item(storage, ?storage_casino)	-> <<"寻宝仓库">>;
item(storage, _)                -> <<"未知">>;

item(_, _) -> false.

%% @spec npc(ConvertType, Val) -> bitstring()
%% @doc npc相关信息转换
npc(name, BaseId) ->
    case npc_data:get(BaseId) of
        {ok, #npc_base{name = Name}} -> Name;
        _ -> <<"">>
    end;
npc(type, BaseId) ->
    case npc_data:get(BaseId) of
        %% (1:功能NPC，2:任务NPC，3:男小怪，4:女小怪，5:男BOSS，6:女BOSS，7:男世界BOSS，8:女世界BOSS，9:中性普通小怪，10:副本男小怪，11:副本女小怪，12:副本中性小怪)
        {ok, #npc_base{looks_type = 1 }} -> <<"功能NPC">>;
        {ok, #npc_base{looks_type = 2 }} -> <<"任务NPC">>;
        {ok, #npc_base{looks_type = 3 }} -> <<"小怪">>;
        {ok, #npc_base{looks_type = 4 }} -> <<"小怪">>;
        {ok, #npc_base{looks_type = 5 }} -> <<"普通BOSS">>;
        {ok, #npc_base{looks_type = 6 }} -> <<"普通BOSS">>;
        {ok, #npc_base{looks_type = 7 }} -> <<"世界BOSS">>;
        {ok, #npc_base{looks_type = 8 }} -> <<"世界BOSS">>;
        {ok, #npc_base{looks_type = 9 }} -> <<"普通小怪">>;
        {ok, #npc_base{looks_type = 10}} -> <<"副本小怪">>;
        {ok, #npc_base{looks_type = 11}} -> <<"副本小怪">>;
        {ok, #npc_base{looks_type = 12}} -> <<"副本小怪">>;
        {ok, #npc_base{looks_type = 13}} -> <<"超级BOSS">>;
        {ok, #npc_base{looks_type = 14}} -> <<"超级BOSS">>;
        _ -> <<"不知道什么怪">>
    end;
npc(_, _) -> <<"">>.

%% @spec exchange(ConvertType, Val) -> bitstring()
%% @doc 交易信息的转换
exchange(item, Items) ->
    do_exchange_item(Items, "");
exchange(state, {_, _, true, true}) -> <<"交易成功">>;
exchange(state, {_, _, false, true}) -> <<"仅一方确定">>;
exchange(state, {_, _, true, false}) -> <<"仅一方确定">>;
exchange(state, {true, true, _, _}) -> <<"都锁定">>;
exchange(state, {false, true, _, _}) -> <<"仅一方锁定">>;
exchange(state, {true, false, _, _}) -> <<"仅一方锁定">>;
exchange(state, _) -> <<"一方中止">>;

exchange(_, _) -> <<"">>.

%% @spec market(Type, Val) -> any()
%% @doc 市场的相关转换
market(assets_type, ?assets_type_coin) -> <<"金币">>;
market(assets_type, ?assets_type_gold) -> <<"晶钻">>;
market(assets_type, _) -> <<"晶钻">>.

%% @spec score(Type, Val) -> any()
%% @doc 积分相关转换
score(type, ?npc_store_career_devote) -> career_devote;
score(type, ?npc_store_arena_score) -> arena_score;
score(type, ?npc_store_guild_war) -> guild_war;
score(type, ?npc_store_guild_devote) -> guild_devote;
score(type, ?npc_store_lilian) -> lilian;
score(type, career_devote) -> career_devote;
score(type, arena_score) -> arena_score;
score(type, guild_war) -> guild_war;
score(type, guild_devote) -> guild_devote;
score(type, lilian) -> lilian;
score(name, career_devote) -> <<"师门积分">>;
score(name, arena_score) -> <<"竞技积分">>;
score(name, guild_war) -> <<"帮战积分">>;
score(name, guild_devote) -> <<"帮会贡献">>;
score(name, lilian) -> <<"仙道历练">>;
score(name, ?npc_store_career_devote) -> <<"师门积分">>;
score(name, ?npc_store_arena_score) -> <<"竞技积分">>;
score(name, ?npc_store_guild_war) -> <<"帮战积分">>;
score(name, ?npc_store_guild_devote) -> <<"帮会贡献">>;
score(name, ?npc_store_lilian) -> <<"仙道历练">>;
score(name, 12) -> <<"捕宠积分">>;
score(_, Data) -> Data.

%% @spec channel(Type, Val) -> any()
%% @doc 元神转换
channel(name, #role_channel{id = 1}) -> <<"生命之魂">>;
channel(name, #role_channel{id = 2}) -> <<"攻击之拳">>;
channel(name, #role_channel{id = 3}) -> <<"防御之骨">>;
channel(name, #role_channel{id = 4}) -> <<"暴怒之肘">>;
channel(name, #role_channel{id = 5}) -> <<"坚韧之心">>;
channel(name, #role_channel{id = 6}) -> <<"精准之眼">>;
channel(name, #role_channel{id = 7}) -> <<"格挡之臂">>;
channel(name, #role_channel{id = 8}) -> <<"抗性之血">>;

channel(up, {Now, #role_channel{lev = Lev, time = EndTime, state = State}}) ->
    util:fbin(<<"神觉升级[等级:~w强化:~w]，预计耗时~w分~w秒">>, [Lev, State div 10, (EndTime - Now) div 60, (EndTime - Now) rem 60]);
channel(up_cancel, {_, #role_channel{lev = Lev, state = State}}) ->
    util:fbin(<<"取消修炼[等级:~w境界:~w]">>, [Lev, State div 10]);
channel(up_over, {_, #role_channel{lev = Lev, state = State}}) ->
    util:fbin(<<"完成修炼[等级:~w境界:~w]">>, [Lev, State div 10]);
channel(up_onekey, {_, #role_channel{lev = Lev, state = State}}) ->
    util:fbin(<<"一键修炼[等级:~w境界:~w]">>, [Lev, State div 10]);
channel(speed_up, {_, #role_channel{lev = Lev, time = 0, state = State}}) ->
    util:fbin(<<"加速修炼[等级:~w境界:~w]，直接完成">>, [Lev, State div 10]);
channel(speed_up, {Now, #role_channel{lev = Lev, time = EndTime, state = State}}) ->
    util:fbin(<<"加速修炼[等级:~w境界:~w]，预计耗时~w分~w秒">>, [Lev, State div 10, (EndTime - Now) div 60, (EndTime - Now) rem 60]);
channel(handle, {upgrade_suc, #role_channel{state = State}, #role_channel{state = NewState}}) ->
    {State, NewState, 1};
channel(handle, {upgrade_fail, #role_channel{state = State}, #role_channel{state = NewState}}) ->
    {State, NewState, 0};
channel(handle, {upgrade_drop, #role_channel{state = State}, #role_channel{state = NewState}}) ->
    {State, NewState, 0};
channel(_, _) -> <<"未知">>.

%% @spec ip2bitstring(N1, N2, N3, N4) -> bitstring()
%% @doc IP值转换为bitstring
ip2bitstring({N1, N2, N3, N4}) ->
    list_to_bitstring(integer_to_list(N1) ++ "." ++ integer_to_list(N2) ++ "." ++ integer_to_list(N3) ++ "." ++ integer_to_list(N4)).
ip2bitstring(N1, N2, N3, N4) ->
    list_to_bitstring(integer_to_list(N1) ++ "." ++ integer_to_list(N2) ++ "." ++ integer_to_list(N3) ++ "." ++ integer_to_list(N4)).

%% --------------------------------
%% 内部处理
%% --------------------------------
do_exchange_item([], S) -> S;
do_exchange_item([#item{base_id = BaseId, quantity = Quantity} | T], "") ->
     case item_data:get(BaseId) of
         {ok, #item_base{name = Name}} ->
             NewS = util:fbin("~s(~w):~w", [Name, BaseId, Quantity]),
             do_exchange_item(T, NewS);
         _ -> do_exchange_item(T, "")
     end;
do_exchange_item([#item{base_id = BaseId, quantity = Quantity} | T], S) ->
     case item_data:get(BaseId) of
         {ok, #item_base{name = Name}} ->
             NewS = util:fbin("~s~s~s(~w):~w", [S, "|", Name, BaseId, Quantity]),
             do_exchange_item(T, NewS);
         _ -> do_exchange_item(T, S)
     end;
do_exchange_item([_ | T], S) ->
    do_exchange_item(T, S).


%% ----------------------------------------------------
%% 金币日志类型：
%% ******************************
%% 竞技报名
%% 强化
%% 装备打孔
%% 装备镶嵌
%% 洗练
%% 生产
%% 合成宝石
%%  装备精炼
%% 摘除宝石
%% 紫装升级
%% 批量洗练
%% 帮会捐献
%% 建帮
%% 使用金币卡
%% 使用绑定金币卡
%% 装备修理
%% 开礼包
%% 挖宝铜币
%% 抽奖
%% 邮件
%% 拍卖
%% 购买拍卖物品
%% 发布拍卖信息
%% 发布求购信息
%% 礼包/活动奖励
%% 发坐标
%% 公告附件
%% 金银兑换
%% npc商店购买
%% npc商店出售
%% 购买神秘商店物品
%% 领取离线经验
%% 领取5倍修炼
%% 仙宠潜力提升
%% 仙宠洗髓
%% 直接购买金币
%% 技能升阶
%% 任务
%% 
%% 
%% 晶钻日志类型：
%% ******************************
%% 寻宝
%% 刷美女
%% 宠物寄养加速
%% 背包扩展
%% 仓库扩展
%% 帮会捐献
%% 邮件领取
%% 礼包/活动奖励
%% 充值
%% 购买挂机
%% 公告附件
%% 刷新神秘商店
%% 购买神秘商店物品
%% 领取离线经验
%% 刷宠物蛋
%% 复活
%% 传送
%% 商城购买
%% 商城抢购1
%% 商城抢购2
%% 直接购买金币
%% 购买熟练度
%% 元神加速
%% 
%% 
%% 物品删除日志类型：
%% ******************************
%% 分解装备
%% 装备继承
%% 强化
%% 打孔
%% 镶嵌
%% 洗练
%% 生产
%% 合成宝石
%% 装备精炼
%% 摘除宝石
%% 紫装升级
%% 批量洗练
%% 交易
%% 元神加速
%% 元神提升
%% 放帮会仓库
%% 复活
%% 传送
%% 吃技能书
%% 技能升阶
%% 任务
%% 邮件
%% 金银兑换
%% 使用消耗
%% 删除
%% 使用宠粮
