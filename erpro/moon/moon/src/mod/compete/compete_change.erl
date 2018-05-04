%%-----------------------------------------
%% 纹章兑换
%%
%% @author mobin
%%-----------------------------------------
-module(compete_change).
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
    {ok, compete_data:change_items()}.

pay(Assets = #assets{badge = Asset}, Cost) ->
    Asset2 = Asset - Cost,
    case Asset2 >= 0 of 
        true ->
            {ok, Assets#assets{badge = Asset2}};
        false ->
            {false, ?MSGID(<<"纹章不足，无法兑换">>)}
    end.
