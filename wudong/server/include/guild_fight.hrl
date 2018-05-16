%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 15:28
%%%-------------------------------------------------------------------
-author("li").

-record(sys_guild_fight, {
    log_count = 0 %% 日志计数器
    , shadow_player_key_list = [] %% [{Pkey, Gkey}]
    , flag_mon_list = [] %% [{Gkey, Key, Pid}]
}).

-record(guild_fight_shadow, {
    gkey = 0
    , g_sn = 0
    , g_name = 0
    , g_lv = 0
    , g_cbp = 0
    , g_num = 0
    , member_list = [] %% [pkey]
}).

-record(guild_fight, {
    gkey = 0
    , medal = 0 %% 仙盟勋章总数
    , guild_flag_lv = 1 %% 仙盟旗帜等级
    , guild_flag_exp = 0 %% 仙盟旗帜经验
    , guild_sum_lv = 0 %% 攻破仙盟等级总数
    , guild_num = 0 %% 攻破仙盟数量
    , fight_list = [] %% [{Index, Gkey, FightMemberList}]
    , challenge_pkey_cache = []
    , op_time = 0
}).

-record(st_guild_fight, {
    pkey = 0
    , challenge_num = 0
    , recv_list = []
    , shop = [] %% 兑换商城购买信息 [{GoodsId, BuyTime}]
    , cd_time = 0 %% CD时间限制
    , fail_reward = 0 %% 战败获取的勋章数量
    , op_time = 0
}).

-record(ets_guild_fight_log, {
    count = 0,
    att_pkey = 0,
    def_pkey = 0,
    result = 0,
    challenge_time = 0
}).

-record(base_guild_flag, {
    lv = 0
    , guild_lv = 0
    , mon_id = 0
    , icon = 0
    , need_medal = 0
    , attrs_list = []
    , z_attrs_list = []
}).

-define(ETS_GUILD_FIGHT_LOG, ets_guild_fight_log).
-define(ETS_GUILD_FIGHT, ets_guild_fight).
-define(ETS_GUILD_FIGHT_SHADOW, ets_guild_fight_shadow).
