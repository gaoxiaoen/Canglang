%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2015 下午12:06
%%%-------------------------------------------------------------------
-module(notice_proc).
-author("fengzhenlin").

-behaviour(gen_server).

-include("notice.hrl").
-include("common.hrl").

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
    get_notice_pid/0
]).

-define(SERVER, ?MODULE).

-define(REFRESH_NOTICE_TIME, 360).  %%刷新广播队列
-define(SHOW_NEXT_TIME, 10).  %%播放下一条广播
-define(SHOW_NEXT_BUGLE, 10).  %%播放下一条喇叭

-record(state, {
    notice_list = [],  %%运营广播列表
    sys_notice_list = [],  %%系统广播列表
    ref = 0,  %%刷新计时器
    next_ref = 0,  %%广播下一条计时器
    last_notice_time = 0,  %%上一条广播的时间
    bugle_list = [],  %%喇叭队列
    bugle_ref = 0  %%播放喇叭计时器
}).

%%%===================================================================
%%% API
%%%===================================================================
get_notice_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            Pid = misc:whereis_name(local,?MODULE),
            put(?MODULE,Pid),
            Pid
    end.

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
    Ref = erlang:send_after(5000,self(),refresh_notice),
    Ref1 = erlang:send_after(10000,self(),show_next),
    Ref2 = erlang:send_after(10000,self(),bugle_next),
    {ok, #state{ref=Ref,next_ref = Ref1,bugle_ref = Ref2}}.

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

%%增加系统广播
handle_cast({add_sys_notice,Content,NoticeSysId,ShowPosList,SendToScene,Copy,GuildKey}, State) ->
    Notice = #notice{
        id = NoticeSysId,
        type = 2, %%系统公告
        content = Content,
        showposlist = ShowPosList,
        send_to_scene = SendToScene,
        scene_copy = Copy,
        guild_key = GuildKey,
        next_time = util:unixtime()
    },
    #state{
        last_notice_time = LastNoticeTime
    } = State,
    Now = util:unixtime(),
    NewState =
        case Now - LastNoticeTime >= ?SHOW_NEXT_TIME of
            true -> %%可直接发广播
                util:cancel_ref([State#state.next_ref]),
                Ref = erlang:send_after(10,self(),show_next),
                State#state{next_ref = Ref};
            false ->
                State
        end,
    NewState1 = NewState#state{
        sys_notice_list = lists:sublist(State#state.sys_notice_list++[Notice],60)
    },
    {noreply, NewState1};

%%获取所有公告
handle_cast({get_all_notice,Sid}, State) ->
    List = State#state.notice_list,
    Bin = pack_all_notice(List),
    server_send:send_to_sid(Sid,Bin),
    {noreply, State};

%%获取喇叭状态信息
handle_cast({get_bugle_state_info,Sid}, State) ->
    Len = length(State#state.bugle_list),
    {ok, Bin} = pt_490:write(49012,{Len}),
    server_send:send_to_sid(Sid,Bin),
    {noreply, State};

%%发喇叭
handle_cast({send_bugle,Data}, State) ->
    NewBugleList = State#state.bugle_list++[Data],
    NewState = State#state{
        bugle_list = NewBugleList
    },
    {noreply, NewState};

handle_cast(_Request, State) ->
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

%%刷新广播列表
handle_info(refresh_notice, State) ->
    util:cancel_ref([State#state.ref]),
    Ref = erlang:send_after(?REFRESH_NOTICE_TIME*1000,self(),refresh_notice),
    NewNoticeList =
        case notice:get_center_notice() of
            1 -> %%没有改变
                State#state.notice_list;
            NoticeList ->
                Bin = pack_all_notice(NoticeList),
                server_send:send_to_all(Bin),
                NoticeList
        end,
    {noreply, State#state{ref = Ref,notice_list = NewNoticeList}};

%%播放下一条广播
handle_info(show_next, State) ->
    util:cancel_ref([State#state.next_ref]),
    Ref = erlang:send_after(?SHOW_NEXT_TIME*1000,self(),show_next),
    {List,NewNoticeList,NewSysNoticeList} = notice:get_next_show(State#state.notice_list,State#state.sys_notice_list),
%%    io:format("###show next ~p~n",[List]),
    F = fun(N,TypeList) ->
            Content =
                case N#notice.type of
                    1 -> %%运营广播
                        [N#notice.id,"",[]];
                    _ -> %%系统广播
                        [0,N#notice.content,N#notice.showposlist]
                end,
            SendType =
                case N#notice.type == 1 of
                    true -> 1;
                    false ->
                        case data_notice_sys:get(N#notice.id) of
                            [] -> 1;
                            BaseNoticeSys -> BaseNoticeSys#base_notice.send_type
                        end
                end,
            {ok, Bin} = pt_490:write(49001,{[Content]}),
            case SendType of
                2 -> %%直接发送到当前场景
                    server_send:send_to_scene(N#notice.send_to_scene, Bin),
                    TypeList;
                {scene, SceneList} -> %%发送到指定场景
                    [server_send:send_to_scene(Scene, Bin)||Scene<-SceneList],
                    TypeList;
                {lv, MinLv, MaxLv} ->
                    server_send:send_to_lv(MinLv, MaxLv, Bin),
                    TypeList;
                5 -> %%发送到帮派
                    MembersPidList = guild_util:get_guild_member_pids_online(N#notice.guild_key),
                    Fg= fun(MPid) ->
                        server_send:send_to_pid(MPid,Bin)
                    end,
                    lists:foreach(Fg,MembersPidList),
                    TypeList;
                6 -> %%发送到当前场景分线
                    server_send:send_to_scene(N#notice.send_to_scene, N#notice.scene_copy, Bin),
                    TypeList;
                _ ->
                    [Content|TypeList]
            end
        end,
    ShowList = lists:foldl(F,[],List),
%%     io:format("#####ShowList ~p~n",[ShowList]),
    NewLastNoticeTime =
        case length(ShowList) > 0 of
            true ->
                spawn(fun() ->
                    {ok, Bin} = pt_490:write(49001,{ShowList}),
                    server_send:send_to_all(Bin)
                end),
                util:unixtime();
            false ->
                State#state.last_notice_time
        end,
    NewState = State#state{
        next_ref = Ref,
        notice_list = NewNoticeList,
        sys_notice_list = NewSysNoticeList,
        last_notice_time = NewLastNoticeTime
    },
    {noreply, NewState};

%%播放下一条喇叭
handle_info(bugle_next, State) ->
    util:cancel_ref([State#state.bugle_ref]),
    NextTime = ?IF_ELSE(State#state.bugle_list == [], 2, ?SHOW_NEXT_BUGLE),
    Ref = erlang:send_after(NextTime*1000,self(),bugle_next),
    NewBugleList =
        case State#state.bugle_list of
            [] -> [];
            [Bugle|Tail] ->
                spawn(fun() ->
                        {ok, Bin} = pt_490:write(49011,Bugle),
                        server_send:send_to_all(Bin)
                    end),
                Tail
        end,
    {noreply, State#state{bugle_ref = Ref,bugle_list = NewBugleList}};

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

%%打包所有广播
pack_all_notice(List) ->
    F = fun(R) ->
        #notice{
            id = Id,
            content = Content,
            showposlist = ShowposList
        } = R,
        [Id,Content,ShowposList]
    end,
    L = lists:map(F,List),
    {ok, Bin} = pt_490:write(49000,{L}),
    Bin.
