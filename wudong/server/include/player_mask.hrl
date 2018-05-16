%% 玩家掩定义，由数字组成 往下加
-define(BABY_SINGLE_SIGN_UP_MASK, 1).  %%子女单人签到{上次签到时间,连续次数}
-define(BABY_DOUBLE_SIGN_UP_MASK, 2).  %%子女双人签到{上次签到时间,连续次数}
-define(PLAYER_USE_BABY_GIFT_NUM_MASK(GiftId), {3, GiftId}). %%玩家使用宝宝背包物品数量
-define(PLAYER_CHAT_LIM_STATE, 4). %%玩家特殊禁言
-define(PLAYER_DVIP_STATE, 5).           %%玩家钻石vip 数据{Type,Time}
-define(PLAYER_DIVIP_SIGN_UP_MASK, 6). %% 钻石vip 连续信息 {上次充值时间,连续天数}
-define(PLAYER_DVIP_CHARGE, 7).        %% 当前玩家充值数量
-define(PLAYER_DVIP_CHARGE_GOLD, 8).   %% 玩家成为dvip 未转换成钻石的元宝数量
-define(PLAYER_EVER_DVIP_STATE, 9).    %% 是否曾经是dvip
-define(PLAYER_DVIP_MARKET_GET, 10).   %% 永久兑换的下表
-define(PLAYER_DVIP_TIME_OUT_PUSH, 11). %% 钻石vip 超时推送 {时间,次数}
-define(PLAYER_DVIP_MARKET_MAX_INDEX, 12). %%钻石vip 商城最大兑换下标
-define(PLAYER_TIME_LIMIT_WING, 13). %%玩家限时翅膀
-define(PLAYER_ROLE_ATTR_DAN(Type, Id), 100000 + 1000 + Type * 10 + Id). %%玩家属性丹总使用数量
-define(PLAYER_DUNGEON_COUNT(DunId), 10000000 + DunId). %%副本通关次数
-define(PLAYER_CROSS_DUNGEON_FIRST_REWARD( Times), 20000000  + Times). %%跨服副本领取状态
-define(PLAYER_TIME_LIMIT_VIP, 14). %%玩家高v {体验时间,续费时间,状态}
-define(PLAYER_KOREA_ONE_HUNDRED_DAYS_GIFT, 15). %% 韩文100天礼包/回归礼包


