%% -------------------------------------
%% 
%% 
%% @author qingxuan
%% -------------------------------------
-module(award_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("award.hrl").

%% handle(integer(), tuple(), #role{}) -> Ret
%% Ret = {ok} | {ok, #role{}} | {reply, tuple()} | {reply, tuple(), #role{}}

%% 所有可领取奖励列表
handle(14001, {}, Role = #role{award = AwardList}) ->
    List = award:pack(AwardList),
    {reply, {List}, Role};

%% 领取奖励
handle(14002, {AwardId}, Role = #role{award = OldAwardList}) ->
    case award:fetch(Role, AwardId) of
        {ok, NewRole = #role{award=NewAwardList}} ->
            notice:alert(succ, Role, ?MSGID(<<"领取奖励成功！">>)),
            {reply, {AwardId, award:count_visible(NewAwardList)}, NewRole};
        {error, #gain{msg = ErrMsg}} when ErrMsg=/=undefined ->
            notice:alert(error, Role, ErrMsg),
            {reply, {0, award:count_visible(OldAwardList)}};
        {error, not_exists} ->
            notice:alert(error, Role, ?MSGID(<<"找不到该奖励">>)),
            {reply, {0, award:count_visible(OldAwardList)}};
        {error, _Reason} ->
            ?DEBUG("error: ~p", [_Reason]),
            notice:alert(error, Role, ?MSGID(<<"领取奖励发生错误！">>)),
            {reply, {0, award:count_visible(OldAwardList)}}
    end;

%% 新奖励列表
handle(14003, {}, _Role) ->
    NewList = award:pack(award:get_new()),
    DelList = award:get_del(),
    award:clear_new(),
    award:clear_del(),
    {reply, {NewList, DelList}};


%%--------------------------------------------------------------------------
%% 获取已有的奇遇事件
handle(14010, {}, #role{id = Id}) ->
    List = adventure:get_role_holes(Id),
    Now = util:unixtime(),
    Effective = [Ae||Ae = #adventure_event{expire = Expire} <- List, Expire > Now],
    adventure:update_role_holes(Id, Effective),
    ProtoList = adventure:pack(14010, Effective),
    {reply, {ProtoList}};

%% 删除过期的奇遇事件
% handle(14011, {SerialId, EventId}, #role{id = Id}) ->
%     adventure:delete_expire_event(Id, {SerialId, EventId}),
%     {reply, {?true}};

%% 推送新的奇遇事件
% handle(14012, {}, )

%% 前往奇遇事件
handle(14013, {SerialId, EventId}, Role) ->
    Reply = adventure:adventure({SerialId, EventId}, Role),
    ProtoData = adventure:pack(14013, Reply),
    {reply, ProtoData};

%% 获取到奖励
%%　AwardId 表示一个事件里边遇到的第几个奖励
handle(14014, {SerialId, EncounId}, Role) ->
    {Reply, NewRole} = adventure:gain_reward({SerialId, EncounId}, Role),
    {reply, {Reply}, NewRole};

    

handle(_Cmd, _Data, _) ->
    {error, unknow_cmd}.


%% --私有函数-------------------------------


