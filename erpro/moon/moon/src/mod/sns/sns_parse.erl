%%----------------------------------------------------
%% @doc 社区模块转换
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(sns_parse).
-export([
        do/2
    ]
).

-include("common.hrl").
-include("sns.hrl").

%% @spec do(RecordName::atom(), InitData::tuple()) -> {ok, Data::tuple()} | {false, Reason::bitstring()}
%% @doc #sns{}记录版本转换
do(sns, {sns, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature}) ->
    do(sns, {sns, 1, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, {0, 0}, 0});
do(sns, {sns, Ver, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, WishTimes, WishedTimes}) ->
    do(sns, {sns, Ver + 1, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, WishTimes, WishedTimes, 0});
do(sns, {sns, Ver, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, WishTimes, WishedTimes, ReceiveGift}) ->
    do(sns, {sns, Ver + 1, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, WishTimes, WishedTimes, ReceiveGift, []});
do(sns, {sns, Ver, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, WishTimes, WishedTimes, ReceiveGift, ChatFace}) ->
    do(sns, {sns, Ver + 1, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, WishTimes, WishedTimes, ReceiveGift, ChatFace, []});
do(sns, {sns, Ver, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, WishTimes, WishedTimes, ReceiveGift, ChatFace, FaceGroup, RecvTime, RecvCnt}) ->   %% 增加赠送次数计数
    do(sns, {sns, Ver + 1, RoleId, SrvId, FrMax, OnlineLate, FrGroup, Signature, WishTimes, WishedTimes, ReceiveGift, ChatFace, FaceGroup, RecvTime, RecvCnt, ?max_give_cnt});


do(sns, Sns) ->
    Ver = element(2, Sns),
    case Ver =:= ?sns_ver andalso is_record(Sns, sns) of
        true -> {ok, Sns};
        false -> {false, ?L(<<"角色sns扩展数据解析时发生异常">>)}
    end.
