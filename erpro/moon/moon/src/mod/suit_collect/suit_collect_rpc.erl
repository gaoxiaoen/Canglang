%% --------------------------------------------------------------------
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(suit_collect_rpc).

-export([handle/3]).

%% 套装信息
handle(19450, {}, Role) ->
    Data = suit_collect:info(Role),
    {reply, {Data}};

%% 套装加成
handle(19451, {}, Role) ->
    suit_collect:push_acc_attrs(Role),
    {ok};

handle(_Cmd, _Data, _Role) ->
    {ok}.
