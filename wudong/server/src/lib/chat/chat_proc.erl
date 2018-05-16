%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 一月 2015 下午4:52
%%%-------------------------------------------------------------------
-module(chat_proc).
-author("fancy").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    get_chat_pid/0,
    log_chat/3,
    get_chat_history/4,
    del_friend_chat_log/2,  %%删除玩家私聊记录
    get_fir_chat_history/2, %%获取私聊记录
    get_monitor_chat/0      %%后台获取监控聊天
]).

-define(SERVER, ?MODULE).
-include("common.hrl").
-include("chat.hrl").


-define(CLEAN_CHAT_HISTORY, 600000).  %%十分钟

-record(state, {
    chat_list = [],
    monitor_chat_list = [], %%后台监控聊天 {pkey,nickname,ts,msg}
    kf_chat_list = [],
    guild_chat_list = dict:new(),  %%帮派聊天 {guildkey,chatlist}
    war_team_chat_list = dict:new(),  %%战队聊天 {war_team_key,chatlist}
    team_chat_list = dict:new(),  %%队伍聊天 {teamkey,chatlist,updateime}  队伍较多，超过1小时没聊天，清除该队伍聊天记录
    friend_chat_list = dict:new(),  %%私聊 {pkey,[#fir_chat{}]}
    refresh_ref = 0         %%清聊天记录计时器
}).

%%%===================================================================
%%% API
%%%===================================================================
get_chat_pid() ->
    case get(?PROC_GLOBAL_CHAT) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            misc:whereis_name(local, ?MODULE)
    end.

log_chat(Type, Data, Extra) ->
    ?CAST(get_chat_pid(), {log_chat, Type, Data, Extra}).

get_chat_history(Pkey, Sid, Type, Extra) ->
    ?CAST(get_chat_pid(), {chat_histroy, Pkey, Sid, Type, Extra}).

get_fir_chat_history(Pkey, Sid) ->
    ?CAST(get_chat_pid(), {get_fir_chat_history, Pkey, Sid}).

del_friend_chat_log(Pkey, PlayerLv) ->
    ?CAST(get_chat_pid(), {del_friend_chat_log, Pkey, PlayerLv}).

get_monitor_chat() ->
    ?CALL(get_chat_pid(), {get_monitor_chat}).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
    {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term()} | ignore).
init([]) ->
    Ref = erlang:send_after(5000, self(), {refresh_history}),
    {ok, #state{refresh_ref = Ref}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
    {reply, Reply :: term(), NewState :: #state{}} |
    {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
    {stop, Reason :: term(), NewState :: #state{}}).

handle_call({get_monitor_chat}, _From, State) ->
    {reply, State#state.monitor_chat_list, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).

%%写入聊天日记
handle_cast({log_chat, Type, Data, Extra}, State) ->
    case Type of
        ?CHAT_TYPE_GUILD ->
            GuildKey = Extra,
            GuildChatDict = State#state.guild_chat_list,
            NewDict =
                case dict:find(GuildKey, GuildChatDict) of
                    error -> dict:store(GuildKey, {GuildKey, [Data]}, GuildChatDict);
                    {ok, {_Key, ChatList}} ->
                        dict:store(GuildKey, {GuildKey, lists:sublist([Data | ChatList], 40)}, GuildChatDict)
                end,
            {noreply, State#state{guild_chat_list = NewDict}};
        ?CHAT_TYPE_KF ->
            ChatList = State#state.kf_chat_list,
            NewChatList = lists:sublist([Data | ChatList], 40),
            {noreply, State#state{kf_chat_list = NewChatList}};
        ?CHAT_TYPE_TEAM ->
            TeamKey = Extra,
            TeamChatDict = State#state.team_chat_list,
            Now = util:unixtime(),
            NewDict =
                case dict:find(TeamKey, TeamChatDict) of
                    error -> dict:store(TeamKey, {TeamKey, [Data], Now}, TeamChatDict);
                    {ok, {_Key, List, _Time}} ->
                        dict:store(TeamKey, {TeamKey, lists:sublist([Data | List], 40), Now}, TeamChatDict)
                end,
            {noreply, State#state{team_chat_list = NewDict}};
        ?CHAT_TYPE_FRIEND ->
            [MyFriChat, FirChat] = Extra,
            FriendDict = State#state.friend_chat_list,
            NewDict = add_fri_chat_log(MyFriChat, FriendDict),
            NewDict1 = add_fri_chat_log(FirChat, NewDict),
            {noreply, State#state{friend_chat_list = NewDict1}};
        ?CHAT_TYPE_CROSS_WAR_ATT ->
            {noreply, State#state{}};
        ?CHAT_TYPE_CROSS_WAR_DEF ->
            {noreply, State#state{}};
        ?CHAT_TYPE_WAR_TEAM ->
            WarTeamKey = Extra,
            WarTeamChatDict = State#state.war_team_chat_list,
            NewDict =
                case dict:find(WarTeamKey, WarTeamChatDict) of
                    error -> dict:store(WarTeamKey, {WarTeamKey, [Data]}, WarTeamChatDict);
                    {ok, {_Key, ChatList}} ->
                        dict:store(WarTeamKey, {WarTeamKey, lists:sublist([Data | ChatList], 20)}, WarTeamChatDict)
                end,
            {noreply, State#state{war_team_chat_list = NewDict}};

        _ ->
%%            [Pkey, Nickname, Ts, Content] = Extra,
            ChatList = State#state.chat_list,
            NewChatList = lists:sublist([Data | ChatList], 40),
            MonitorChatList = State#state.monitor_chat_list,
            NewMonitorChatList = lists:sublist([Extra | MonitorChatList], 10),
            {noreply, State#state{chat_list = NewChatList, monitor_chat_list = NewMonitorChatList}}
    end;

%%获取聊天历史记录
handle_cast({chat_histroy, _Pkey, Sid, Type, Extra}, State) ->
    ChatList =
        case Type of
            ?CHAT_TYPE_PUBLIC -> State#state.chat_list;
            ?CHAT_TYPE_GUILD ->
                GuildKey = Extra,
                ChatDict = State#state.guild_chat_list,
                case dict:find(GuildKey, ChatDict) of
                    error -> [];
                    {_, {GuildKey, List}} -> List
                end;
            ?CHAT_TYPE_WAR_TEAM ->
                WarTeamKey = Extra,
                ChatDict = State#state.war_team_chat_list,
                case dict:find(WarTeamKey, ChatDict) of
                    error -> [];
                    {_, {WarTeamKey, List}} -> List
                end;
            ?CHAT_TYPE_KF -> State#state.kf_chat_list;
            _ -> []
        end,
    {ok, Bin} = pt_110:write(11001, {Type, lists:reverse(ChatList)}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%获取私聊记录
handle_cast({get_fir_chat_history, Pkey, Sid}, State) ->
    SendList =
        case dict:find(Pkey, State#state.friend_chat_list) of
            error -> [];
            {ok, ChatList} ->
                F = fun(FriChat) ->
                    #fri_chat{
                        pkey = ToPkey,
                        name = Name,
                        psex = Sex,  %% 新增玩家性别
                        avatar = Avatar,
                        vip = VipLv,
                        career = Career,
                        chat_list = List
                    } = FriChat,
                    [ToPkey, Name, Avatar, Sex, VipLv, Career, lists:sublist(List, 20)]
                end,
                lists:map(F, lists:sublist(ChatList, 10))
        end,
    {ok, Bin} = pt_110:write(11002, {SendList}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%清理私聊记录
handle_cast({del_friend_chat_log, Pkey, PlayerLv}, State) ->
    FriendDict = State#state.friend_chat_list,
    case PlayerLv < 39 of
        true ->
            NewDict = dict:erase(Pkey, FriendDict);
        false ->
            NewDict = FriendDict
    end,
    {noreply, State#state{friend_chat_list = NewDict}};

handle_cast(_Request, State) ->
    ?ERR("###unknow cast request ~p~n", [_Request]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).

%%清理聊天记录
handle_info({refresh_history}, State) ->
    util:cancel_ref([State#state.refresh_ref]),
    Ref = erlang:send_after(?CLEAN_CHAT_HISTORY, self(), {refresh_history}),
    Now = util:unixtime(),
    %%清理队伍聊天
    F = fun(Key, Val) ->
        {Key, _List, Time} = Val,
        case Now - Time > 3600 of
            true -> false;
            false -> true
        end
    end,
    NewDict = dict:filter(F, State#state.team_chat_list),
    {noreply, State#state{refresh_ref = Ref, team_chat_list = NewDict}};

%%清理聊天记录
handle_info({refresh_history_guild}, State) ->
    {noreply, State#state{guild_chat_list = dict:new()}};

handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
    {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

add_fri_chat_log(FirChat, Dict) ->
    #fri_chat{
        mykey = MyKey,
        pkey = Pkey,
        chat_list = AddChatList
    } = FirChat,
    case dict:find(MyKey, Dict) of
        error ->
            dict:store(MyKey, [FirChat], Dict);
        {ok, ChatList} ->
            NewChatList =
                case lists:keyfind(Pkey, #fri_chat.pkey, ChatList) of
                    false -> lists:sublist([FirChat | ChatList], 15);
                    OldFirChat ->
                        NewFirChat = OldFirChat#fri_chat{
                            chat_list = lists:sublist(AddChatList ++ OldFirChat#fri_chat.chat_list, 20)
                        },
                        [NewFirChat | lists:keydelete(Pkey, #fri_chat.pkey, ChatList)]
                end,
            dict:store(MyKey, NewChatList, Dict)
    end.
