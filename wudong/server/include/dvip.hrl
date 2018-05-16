%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 九月 2017 16:00
%%%-------------------------------------------------------------------
-author("lzx").
-include("common.hrl").

-define(DVIP_COST, erlang:element(3, data_version_different:get(3))).               %%成为dvip 需要的元宝数量
-define(DVIP_EFFECT_TIME, erlang:element(1, data_version_different:get(3)) * ?ONE_DAY_SECONDS).    %% 限时生效时间
-define(DVIP_EFFECT_SP_TIME, erlang:element(2, data_version_different:get(3)) * ?ONE_DAY_SECONDS).    %% 尊贵生效时间
-define(DVIP_CHARGE_DAY, erlang:element(6, data_version_different:get(3))).           %% 成为永久vip 连续充值天数
-define(DVIP_CHARGE_TOTAL, erlang:element(4, data_version_different:get(3))).      %% 成为永久vip 累计充值总数
-define(DVIP_PASSIVE_SKILL, 1208001).  %% 被动技能ID
-define(DVIP_GOLD_TO_DIAMOND, erlang:element(5, data_version_different:get(3))).     %% 多少元宝兑换一个钻石

-record(base_d_vip_config, {
    vip = 0,
    active_skill = 0,
    market = [],                     %% 钻石商城
    gift = [],                       %% 每日礼包
    dungeon = [],
    vip_mark = 0,
    draw = 0,
    step_exchange = [],              %% 进阶丹转换
    gold_exchange = []                %% 元宝兑换
}).




