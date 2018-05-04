%%----------------------------------------------------
%% vip 奖励
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(vip_effect).
-export([do/2]).

-include("common.hrl").
-include("role.hrl").
-include("vip.hrl").
%%
-include("gain.hrl").

%% @spec do(Effect, Role) -> {ok, NewRole} | {false, Reason}
%% @doc 发放VIP奖励
%% Effect = list{} 
%% Role = #role{}
do([], Role) -> {ok, Role};
do([H | T], Role) ->
    case do(H, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NRole} -> do(T, NRole);
        {skip, NRole} -> do(T, NRole)
    end;

%% 绑定晶钻发放
do({gold_bind, Val}, Role) -> 
    case role_gain:do(#gain{label = gold_bind, val = Val}, Role) of
        {false, _} -> {false, ?L(<<"发放VIP绑定晶钻失败">>)};
        {ok, NRole} -> {ok, NRole}
    end;

%% 传音符发放
do({hearsay, Val}, Role = #role{vip = Vip}) ->
    {ok, Role#role{vip = Vip#vip{hearsay = Val}}};

%% 飞天符发放
do({fly_sign, Val}, Role = #role{vip = Vip}) ->
    {ok, Role#role{vip = Vip#vip{fly_sign = Val}}};

%% 其它发放
do({Label, Val}, Role) ->
    case role_gain:do(#gain{label = Label, val = Val}, Role) of
        {false, _} -> {false, ?L(<<"发放VIP奖励失败">>)};
        {ok, NRole} -> {ok, NRole}
    end;

%% 容错处理
do(_Eff, Role) ->
    {skip, Role}.
