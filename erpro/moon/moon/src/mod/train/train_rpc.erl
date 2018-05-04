%% --------------------------------------------------------------------
%% @doc 飞仙历练rpc
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(train_rpc).

-export([handle/3]).

-include("common.hrl").
-include("train.hrl").
-include("role.hrl").
-include("attr.hrl").

%% 限制本服历练
-define(local_train_limit_fc, 9999).

%% 第一次进入历练场区 获取所有历练场信息
handle(18901, {}, Role = #role{attr = #attr{fight_capacity = FC}}) ->
    Type = case center:is_connect() of
        false -> local;
        _ when FC =< ?local_train_limit_fc -> local;
        _ -> center
    end,
    case train_common:enter_default(Type, Role) of
        {false, Reason} ->
            {reply, {0, 0, Reason, []}};
        _ ->
            {ok}
    end;

%% 获取各种次数
handle(18902, {}, Role) ->
    {reply, train_common:able_times(Role)};

%% 获取修炼状态
handle(18903, {}, Role) ->
    case train_common:status(Role) of
        {ok, Reply} ->
            {reply, Reply};
        _ ->
            {ok}
    end;

%% 获取指定场区信息
handle(18904, {Lid, Aid}, Role) ->
    train_common:train_info(Role, {Lid, Aid}),
    {ok};

%% 开始历练
handle(18905, {Lid, Aid, Type}, Role) ->
    case train_common:sit(Role, Lid, Aid, Type) of
        {ok, NewRole} ->
            campaign_task:listener(Role, train, 1),
            {reply, {?true, <<>>}, NewRole};
        {false, gold_less} ->
            {reply, {?gold_less, <<>>}};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;

%% 离开历练场
handle(18906, {Lid, Aid}, Role) ->
    train_common:leave(Role, {Lid, Aid}),
    {ok};

%% 获取劫匪信息
handle(18907, {Lid, Aid}, Role) ->
    train_common:rob_info(Role, {Lid, Aid}),
    {ok};

%% 打劫
handle(18908, {Lid, Aid, Rid, Srvid}, Role) ->
    case train_common:rob(Role, Lid, Aid, Rid, Srvid) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        {ok, NewRole} ->
            {reply, {?true, <<>>}, NewRole};
        _ ->
            {ok}
    end;

%% 缉拿
handle(18909, {Lid, Aid, Rid, Srvid}, Role) ->
    case train_common:arrest(Role, Lid, Aid, Rid, Srvid) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        {ok, NewRole} ->
            {reply, {?true, <<>>}, NewRole};
        _ ->
            {ok}
    end;

%% 进入指定场
handle(18916, {Lid, Aid}, Role) ->
    case train_common:enter_specify(Role, {Lid, Aid}) of
        {false, Reason} ->
            {reply, {?false, Reason}};
        _ ->
            {reply, {?true, <<>>}}
    end;

handle(_Cmd, _Data, _Role) ->
    {ok}.
