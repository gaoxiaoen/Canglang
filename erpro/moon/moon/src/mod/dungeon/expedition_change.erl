%%-----------------------------------------
%% 合作值兑换
%%
%% @author mobin
%%-----------------------------------------
-module(expedition_change).
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
    {ok, expedition_data:change_items()}.

pay(Assets = #assets{cooperation = Asset}, Cost) ->
    Asset2 = Asset - Cost,
    case Asset2 >= 0 of 
        true ->
            {ok, Assets#assets{cooperation = Asset2}};
        false ->
            {false, ?MSGID(<<"合作值不足，无法兑换">>)}
    end.
