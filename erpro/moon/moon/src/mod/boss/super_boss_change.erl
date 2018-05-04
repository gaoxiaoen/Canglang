%%-----------------------------------------
%% 龙鳞兑换
%%
%% @author mobin
%%-----------------------------------------
-module(super_boss_change).
-behaviour(change).
-export([
        list/1,
        buy/3,
        items/0,
        pay/2
    ]).
-include("common.hrl").
-include("assets.hrl").

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec list(ItemsType) -> Items
list(Rid) ->
    gen_server:call(?MODULE, {items, Rid}).

buy(Id, Num, Role) ->
    gen_server:call(?MODULE, {buy, Id, Num, Role}).

%%内部函数
items() ->
    {ok, super_boss_data:change_items()}.

pay(Assets = #assets{scale = Asset}, Cost) ->
    Asset2 = Asset - Cost,
    case Asset2 >= 0 of 
        true ->
            {ok, Assets#assets{scale = Asset2}};
        false ->
            {false, ?MSGID(<<"龙鳞不足，无法兑换">>)}
    end.
