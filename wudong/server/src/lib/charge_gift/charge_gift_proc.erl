%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     充值绑元礼包
%%% @end
%%% Created : 08. 五月 2017 10:37
%%%-------------------------------------------------------------------
-module(charge_gift_proc).
-author("hxming").


-include("common.hrl").
-include("goods.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0,
    get_server_pid/0,
    midnight/1,
    set_charge_gift/3,
    get_left_day/1
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
    charge_gift_list = []%%[{pkey,date,bgold}]
}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


%%获取进程PID
get_server_pid() ->
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


midnight(Now) ->
    get_server_pid() ! {midnight, Now}.


set_charge_gift(Pkey, Day, BGold) when Day > 0 ->
    get_server_pid() ! {set_charge_gift, Pkey, Day, BGold};
set_charge_gift(_Pkey, _Day, _BGold) -> ok.



get_left_day(Pkey) ->
    case ?CALL(get_server_pid(), {left_day, Pkey}) of
        [] -> 0;
        Days -> Days
    end.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    ChargeGiftList = load_charge_gift(),
    {ok, #state{charge_gift_list = ChargeGiftList}}.

handle_call({left_day, Pkey}, _from, State) ->
    Ret =
        case lists:keyfind(Pkey, 1, State#state.charge_gift_list) of
            false -> 0;
            {_, Date, _} ->
                util:get_diff_days(Date, util:unixtime())
        end,
    {reply, Ret, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.



handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({set_charge_gift, Pkey, Day, BGold}, State) ->
    Now = util:unixtime(),
    Midnight = util:get_today_midnight(Now),
    ChargeGiftList =
        case lists:keytake(Pkey, 1, State#state.charge_gift_list) of
            false ->
                mail_charge_gift(Pkey, BGold, Day - 1),
                spawn(fun() -> log_charge_gift(Pkey, BGold, Day, Now) end),
                Date = Midnight + ?ONE_DAY_SECONDS * (Day - 1),
                [{Pkey, Date, BGold} | State#state.charge_gift_list];
            {value, {_, OldDate, _BGold}, T} ->
                Date =
                    if OldDate < Midnight ->
                        mail_charge_gift(Pkey, BGold, Day - 1),
                        spawn(fun() -> log_charge_gift(Pkey, BGold, Day, Now) end),
                        Midnight + ?ONE_DAY_SECONDS * (Day - 1);
                        true ->
                            OldDate + ?ONE_DAY_SECONDS * Day
                    end,
                [{Pkey, Date, BGold} | T]
        end,
    replace_charge_gift(Pkey, Date, BGold),
    {noreply, State#state{charge_gift_list = ChargeGiftList}};

handle_info({midnight, Now}, State) ->
    Midnight = util:get_today_midnight(Now),
    F = fun({Pkey, Date, BGold}) ->
        if Date < Midnight ->
            del_charge_gift(Pkey),
            [];
            true ->
                Day = util:get_diff_days(Midnight, Date),
                mail_charge_gift(Pkey, BGold, Day),
                spawn(fun() -> log_charge_gift(Pkey, BGold, Day, Now) end),
                [{Pkey, Date, BGold}]
        end
        end,
    ChargeGiftList = lists:flatmap(F, State#state.charge_gift_list),
    {noreply, State#state{charge_gift_list = ChargeGiftList}};


handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
load_charge_gift() ->
    Data = db:get_all("select pkey,date ,bgold from player_charge_gift"),
    [list_to_tuple(Item) || Item <- Data].


replace_charge_gift(Pkey, Date, Bgold) ->
    Sql = io_lib:format("replace into player_charge_gift set pkey=~p,date=~p,bgold=~p", [Pkey, Date, Bgold]),
    db:execute(Sql).


del_charge_gift(Pkey) ->
    Sql = io_lib:format("delete from player_charge_gift where pkey=~p", [Pkey]),
    db:execute(Sql),
    ok.

mail_charge_gift(Pkey, BGold, Day) ->
    Content = io_lib:format(?T("少侠，绑元礼包今日赠送~p绑定元宝。你的剩余领取天数：~p天"), [BGold, Day]),
    mail:sys_send_mail([Pkey], ?T("绑元礼包返还"), Content, [{?GOODS_ID_BGOLD, BGold}]),
    ok.


log_charge_gift(Pkey, BGold, Day, Now) ->
    Sql = io_lib:format("insert into log_charge_gift set pkey=~p,nickname='~s',bgold=~p,day=~p ,time=~p", [Pkey, shadow_proc:get_name(Pkey), BGold, Day, Now]),
    log_proc:log(Sql),
    ok.
