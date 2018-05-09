%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%% 笔记：在创建一个start之后，如果一切都执行成功，则可以执行所有的方法，但是如果此时有一个函数执行失败，则之后的所有的函数执行都不会执行下去，
%%       应该就可以算是理解为程序执行失败.为什么要这样设计？
%% 应该是可以将 gen_server_template 模板函数单服放开处理，这样就可以模拟线程见的互相调用模式
%%% Created : 07. 五月 2018 19:36
%%%-------------------------------------------------------------------
-module(my_bank).
-author("Administrator").
-behaviour(gen_server).
%% API
-export([start/0, deposit/2, stop/0, new_account/1, withdraw/2]).

-export([init/1,handle_call/3,handle_info/2,terminate/2,code_change/3,handle_cast/2]).

-define(SERVER,?MODULE).

init([]) -> {ok, ets:new(?MODULE, [])}.

handle_call({new, Who}, _From, Tab) ->
    Reply = case ets:lookup(Tab, Who) of
                [] -> ets:insert(Tab, {Who, 0}),
                    {welcome, Who};
                [_] -> {Who, you_already_are_a_customer}
            end,
    {reply, Reply, Tab};

handle_call({add, Who, X}, _From, Tab) ->
    Reply = case ets:lookup(Tab, Who) of
                [] -> not_a_customer;
                [{Who, Balance}] ->
                    NewBalance = Balance + X,
                    ets:insert(Tab, {Who, NewBalance}),
                    {thanks, Who, your_balance_is, NewBalance}
            end,
    {reply, Reply, Tab};

handle_call({remove, Who, X}, _From, Tab) ->
    Reply = case ets:lookup(Tab, Who) of
                [] -> not_a_customer;
                [{Who, Balance}] when X =< Balance ->
                    Newbanlance = Balance - X,
                    ets:insert(Tab, {Who, Newbanlance}),
                    {thanks, Who, your_balance_is, Newbanlance};
                [{Who, Balance}] ->
                    {sorry, Who, you_only_have, Balance, in_the_bank}
            end,
    {reply, Reply, Tab};

handle_call(stop, _From, Tab) ->
    {stop, normal, stopped, Tab}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


start() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
stop() ->
    gen_server:call(?MODULE, stop).

new_account(Who) ->
    gen_server:call(?MODULE, {new, Who}).

deposit(Who, Amount) ->
    gen_server:call(?MODULE, {add, Who, Amount}).

withdraw(Who, Amount) ->
    gen_server:call(?MODULE, {remove, Who, Amount}).


