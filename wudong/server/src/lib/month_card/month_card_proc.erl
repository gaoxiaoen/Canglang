%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 十一月 2017 11:26
%%%-------------------------------------------------------------------
-module(month_card_proc).
-author("hxming").


-include("common.hrl").
-include("goods.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0,
    get_server_pid/0,
    midnight/1,
    set_card/4,
    get_left_day/2
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
    card_list = []%%[{key,pkey,type,date,bgold}]
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


set_card(Pkey, Type, Day, BGold) when Day > 0 ->
    get_server_pid() ! {set_card, Pkey, Type, Day, BGold};
set_card(_Pkey, _Type, _Day, _BGold) -> ok.

%%获取剩余天数0无
get_left_day(Pkey, Id) ->
    case ?CALL(get_server_pid(), {left_day, Pkey, Id}) of
        [] -> 0;
        Val -> Val
    end.


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    CardList = load_card_all(),
    {ok, #state{card_list = CardList}}.


handle_call({left_day, Pkey, Type}, _from, State) ->
    Now = util:unixtime(),
    Key = to_key(Pkey, Type),
    Ret =
        case lists:keyfind(Key, 1, State#state.card_list) of
            false -> 0;
            {_, _, _, Date, _} ->
                util:get_diff_days(Date, Now)
        end,
    {reply, Ret, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.



handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({set_card, Pkey, Type, Day, BGold}, State) ->
    Now = util:unixtime(),
    Midnight = util:get_today_midnight(Now),
    Key = to_key(Pkey, Type),
    CardList =
        case lists:keytake(Key, 1, State#state.card_list) of
            false ->
                mail_card(Pkey, Type, BGold, Day - 1),
                spawn(fun() -> log_charge_gift(Pkey, BGold, Day, Now) end),
                Date = Midnight + ?ONE_DAY_SECONDS * (Day - 1),
                [{to_key(Pkey, Type), Pkey, Type, Date, BGold} | State#state.card_list];
            {value, {_, _, _, OldDate, _BGold}, T} ->
                Date =
                    if OldDate < Midnight ->
                        mail_card(Pkey, Type, BGold, Day - 1),
                        spawn(fun() -> log_charge_gift(Pkey, BGold, Day, Now) end),
                        Midnight + ?ONE_DAY_SECONDS * (Day - 1);
                        true ->
                            NewDate = OldDate + ?ONE_DAY_SECONDS * Day,
                            mail_notice(Pkey, Type, util:diff_day(NewDate)),
                            NewDate
                    end,
                [{Key, Pkey, Type, Date, BGold} | T]
        end,
    replace_card(Pkey, Type, Date, BGold),
    {noreply, State#state{card_list = CardList}};

handle_info({midnight, Now}, State) ->
    Midnight = util:get_today_midnight(Now),
    F = fun({Key, Pkey, Type, Date, BGold}) ->
        if Date < Midnight ->
            del_card(Pkey, Type),
            [];
            true ->
                Day = util:get_diff_days(Midnight, Date),
                mail_card(Pkey, Type, BGold, Day),
                spawn(fun() -> log_charge_gift(Pkey, BGold, Day, Now) end),
                [{Key, Pkey, Type, Date, BGold}]
        end
        end,
    CardList = lists:flatmap(F, State#state.card_list),
    {noreply, State#state{card_list = CardList}};


handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
to_key(Pkey, Type) ->
    lists:concat([Pkey, "_", Type]).

load_card_all() ->
    Data = db:get_all("select pkey,type,date ,bgold from player_card"),
    [{to_key(Pkey, Type), Pkey, Type, Date, Bgold} || [Pkey, Type, Date, Bgold] <- Data].


replace_card(Pkey, Type, Date, Bgold) ->
    Sql = io_lib:format("replace into player_card set pkey=~p,type=~p,date=~p,bgold=~p", [Pkey, Type, Date, Bgold]),
    db:execute(Sql).


del_card(Pkey, Type) ->
    Sql = io_lib:format("delete from player_card where pkey=~p and type =~p", [Pkey, Type]),
    db:execute(Sql),
    ok.

mail_card(Pkey, Type, BGold, Day) ->
    case Type of
        102 ->
            Content = io_lib:format(?T("少侠，年卡今日赠送~p绑定元宝。你的剩余领取天数：~p天"), [BGold, Day]),
            mail:sys_send_mail([Pkey], ?T("年卡返还"), Content, [{?GOODS_ID_BGOLD, BGold}]);
        101 ->
            Content = io_lib:format(?T("少侠，月卡今日赠送~p绑定元宝。你的剩余领取天数：~p天"), [BGold, Day]),
            mail:sys_send_mail([Pkey], ?T("月卡返还"), Content, [{?GOODS_ID_BGOLD, BGold}]);
        100 ->
            Content = io_lib:format(?T("少侠，绑元礼包今日赠送~p绑定元宝。你的剩余领取天数：~p天"), [BGold, Day]),
            mail:sys_send_mail([Pkey], ?T("绑元礼包"), Content, [{?GOODS_ID_BGOLD, BGold}]);
        _ -> ok

    end,
    ok.

mail_notice(Pkey, Type, Day) ->
    {Title, Content} =
        case Type of
            100 ->
                {?T("绑元礼包"), ?T("您的绑元礼包续期成功！当前有效天数为~p！")};
            101 ->
                {?T("月卡福利"), ?T("您的月卡续期成功！当前有效天数为~p！")};
            102 ->
                {?T("年卡福利"), ?T("您的年卡续期成功！当前有效天数为~p！")};
            _ -> {"", "~p"}
        end,
    Content1 = io_lib:format(Content, [Day]),
    mail:sys_send_mail([Pkey], Title, Content1, []),
    ok.

log_charge_gift(Pkey, BGold, Day, Now) ->
    Sql = io_lib:format("insert into log_charge_gift set pkey=~p,nickname='~s',bgold=~p,day=~p ,time=~p", [Pkey, shadow_proc:get_name(Pkey), BGold, Day, Now]),
    log_proc:log(Sql),
    ok.
