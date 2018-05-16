%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 三月 2016 下午3:47
%%%-------------------------------------------------------------------
-module(global_money_create).
-author("fengzhenlin").

%% API
-behaviour(gen_server).

%% API
-export([
    start_link/0,
    add_money/3,
    get_pid/0
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-record(state,{
    gold = 0,
    bgold = 0,
    coin = 0,
    bcoin = 0,

    cur_gold = 0,
    cur_bgold = 0,
    cur_coin = 0,
    cur_bcoin = 0
}).

%%Type 1元宝2绑定元宝3银币4绑定银币
add_money(Add, Reason, Type) ->
    case lists:member(Reason,[32]) of
        true -> skip;
        false ->
            P = get_pid(),
            case Type of
                1 -> P ! {add_gold, Add};
                2 -> P ! {add_bgold, Add};
                3 -> P ! {add_coin, Add};
                4 -> P ! {add_bcoin, Add};
                _ -> skip
            end
    end.

get_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    process_flag(trap_exit,true),
    Sql = io_lib:format("select gold,bgold,coin,bcoin from cron_money order by `time` desc limit 1",[]),
    State =
        case db:get_row(Sql) of
            [] -> #state{};
            [Gold, BGold, Coin, BCoin] ->
                #state{
                    gold = Gold,
                    bgold = BGold,
                    coin = Coin,
                    bcoin = BCoin
                }
        end,
    Date = util:unixdate(),
    Sql1 = io_lib:format("select gold,bgold,coin,bcoin from cron_cur_money where `time` > ~p",[Date]),
    State1 =
        case db:get_row(Sql1) of
            [] -> State;
            [CurGold, CurBGold, CurCoin, CurBCoin] ->
                State#state{
                    cur_gold = CurGold,
                    cur_bgold = CurBGold,
                    cur_coin = CurCoin,
                    cur_bcoin = CurBCoin
                }
        end,
    {ok, State1}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({add_gold, AddGold}, State) ->
    NewState = State#state{
        gold = State#state.gold + AddGold,
        cur_gold = State#state.cur_gold  + AddGold
    },
    {noreply, NewState};

handle_info({add_bgold, AddGold}, State) ->
    NewState = State#state{
        bgold = State#state.bgold + AddGold,
        cur_bgold = State#state.cur_bgold + AddGold
    },
    {noreply, NewState};

handle_info({add_coin, AddCoin}, State) ->
    NewState = State#state{
        coin = State#state.coin + AddCoin,
        cur_coin = State#state.cur_coin + AddCoin
    },
    {noreply, NewState};

handle_info({add_bcoin, AddCoin}, State) ->
    NewState = State#state{
        bcoin = State#state.bcoin + AddCoin,
        cur_bcoin = State#state.cur_bcoin + AddCoin
    },
    {noreply, NewState};

handle_info(timer_cron, State) ->
    dbsave(State),
    {noreply, State};

handle_info(night_refresh, State) ->
    dbsave(State),
    NewState = State#state{
        cur_gold = 0,
        cur_bgold = 0,
        cur_coin = 0,
        cur_bcoin = 0
    },
    {noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

terminate(_Reason, State) ->
    dbsave(State),
    ok.

dbsave(State) ->
    #state{
        gold = Gold,
        bgold = BGold,
        coin = Coin0,
        bcoin = BCoin0,
        cur_gold = CurGold,
        cur_bgold = CurBGold,
        cur_coin = CurCoin0,
        cur_bcoin = CurBCoin0
    } = State,
    Coin = min(2000000000, Coin0),
    BCoin = min(2000000000, BCoin0),
    CurCoin = min(2000000000, CurCoin0),
    CurBCoin = min(2000000000, CurBCoin0),
    Now = util:unixtime(),
    Sql = io_lib:format("insert into cron_money set gold=~p,bgold=~p,coin=~p,bcoin=~p,`time`=~p",
        [Gold, BGold, Coin, BCoin, Now]),
    db:execute(Sql),

    Sql1 = io_lib:format("insert into cron_cur_money set gold=~p,bgold=~p,coin=~p,bcoin=~p,`time`=~p",
        [CurGold, CurBGold, CurCoin, CurBCoin, Now]),
    db:execute(Sql1),
    ok.


