%%----------------------------------------------------
%% VIP版本转换
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(vip_parse).
-export([do/1]).
-include("common.hrl").
-include("vip.hrl").

%% VIP版本转换

do({vip, Ver = 0, Type, Expire, PortraitId, SpecialTime, BuffTime, Hearsay, FlySign, IsTry, RewardTimes}) ->
    do({vip, Ver + 1, Type, Expire, PortraitId, SpecialTime, BuffTime, Hearsay, FlySign, IsTry, RewardTimes, []});
do({vip, Ver = 1, Type, Expire, PortraitId, SpecialTime, BuffTime, Hearsay, FlySign, IsTry, RewardTimes, Effect, V1, V2}) ->
    do({vip, Ver + 1, Type, Expire, PortraitId, SpecialTime, BuffTime, Hearsay, FlySign, IsTry, RewardTimes, Effect, V1, V2, 0}); %% 增加充值次数字段
do({vip, Ver = 2, Type, Expire, PortraitId, SpecialTime, BuffTime, Hearsay, FlySign, IsTry, RewardTimes, Effect, V1, V2, V3}) ->
    do({vip, Ver + 1, Type, Expire, PortraitId, SpecialTime, BuffTime, Hearsay, FlySign, IsTry, RewardTimes, Effect, V1, V2, V3, []}); %% 增加充值次数字段
do({vip, Ver = 3, Type, Expire, PortraitId, SpecialTime, BuffTime, Hearsay, FlySign, IsTry, RewardTimes, Effect, V1, V2, V3, V4}) ->
    do({vip, Ver + 1, Type, Expire, PortraitId, SpecialTime, BuffTime, Hearsay, FlySign, IsTry, RewardTimes, Effect, V1, V2, V3, V4, 0}); %% 增加是否是首次缺卷轴标志
do(Vip = #vip{ver = ?VIP_VER}) ->
    {ok, Vip};
do(_Vip) ->
    ?DEBUG(" --------->>  ~w ", [_Vip]),
    ?ERR("VIP版本转换失败"),
    {false, ?L(<<"VIP版本转换失败">>)}.
