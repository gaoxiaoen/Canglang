%%----------------------------------------------------
%% 信件系统管理 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(mail_mgr).
-behaviour(gen_server).
-export([
        start_link/0
        ,get_id/0
        ,deliver/2
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([timing_online_mail/4]).

-record(state, {
        buffer = []  %% 待发信件列表
    }).

-include("common.hrl").
-include("mail.hrl").
-include("role.hrl").
-include("link.hrl").
-include("item.hrl").
%%

-define(MAIL_TIME_TICK, 86400000).      %% TICK时间间隔1小时

-define(MAIL_DO_MAX_ONCE, 50).          %% 单次处理信件数量
-define(MAIL_SEND_TICK, 10 * 1000).     %% 多久检测是有信件需要发送
-define(MAIL_SEND_MAX_TIMES, 5).        %% 每封信件最多投递多少次

get_id() ->
    mail_id_mgr:get_id().

%% 信件投递
%% 建议采用 To = {ToRid, ToSrvId, ToName} 方式
%% @spec deliver(To, MailInfo) -> ok | {false, Reason}
%% To = [{Rid, SrvId}] | [{Rid, SrvId, Name}] | [#role{}] | {Rid, SrvId} | {Rid, SrvId, Name} | #role{} 
%% MailInfo =  {Subject, Content, Assets, Items} | {Subject, Content}
%%   Subject = binary()
%%   Content = binary() 
%%   Assets = [tuple()]   [{资产类型, 值}]
%%   Items = [#item{}] | [{BaseId, Bind, Num}] 
deliver([], _MailInfo) -> ok;
deliver([To | T], MailInfo) ->
    deliver(To, MailInfo),
    deliver(T, MailInfo);
deliver({Rid, SrvId}, MailInfo) ->
    case mail:get_role({Rid, SrvId}) of
        {false, Reason} -> {false, Reason};
        {ok, #role{name = Name}} ->
            do_deliver({Rid, SrvId, Name}, MailInfo)
    end;
deliver(#role{id = {Rid, SrvId}, name = Name}, MailInfo) ->
    do_deliver({Rid, SrvId, Name}, MailInfo);
deliver(To, MailInfo) ->
    do_deliver(To, MailInfo).

%% 执行投递到信件服务器进程 交由信件进程处理信件发送
do_deliver(To, {Subject, Content}) ->  
    do_deliver(To, {Subject, Content, [], []});
do_deliver(To, {Subject, Content, Assets, [I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, I16, I17, I18 | T]}) when T =/= [] ->  %% 防止信件物品附件数量过多
    do_deliver(To, {Subject, Content, Assets, [I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, I16, I17, I18]}),
    do_deliver(To, {Subject, Content, [], T}); %% 确保资产只发一次
do_deliver({ToRid, ToSrvId, ToName}, {Subject, Content, Assets, Items}) ->  
    {FromRid, FromSrvId} = ?MAIL_SYSTEM_USER(),
    NewItems = make_item(Items, []),
    Isatt = case Assets =:= [] andalso NewItems =:= [] of
        true -> 0;
        false -> 1
    end,
    Mail = #mail{
        id = get_id(), send_time = util:unixtime()
        ,from_rid = FromRid, from_srv_id = FromSrvId, from_name = ?L(<<"系统信件">>)
        ,to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName
        ,mailtype = ?MAIL_TYPE_SYS, subject = util:to_binary(Subject), content = util:to_binary(Content)
        ,assets = Assets, attachment = NewItems, isatt = Isatt
    },
    gen_server:cast(?MODULE, {deliver, Mail});
do_deliver(_, _) ->
    ?ERR("投递信件失败"),
    {false, ?L(<<"参数不正确,投递失败">>)}.

%% @spec timing_online_mail(Args) -> ok
timing_online_mail(Time, Module, Funtion, Args) ->
    gen_server:cast(?MODULE, {timing_online_mail, Time, Module, Funtion, Args}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("正在启动..."),
    State = #state{},
    erlang:send_after(?MAIL_TIME_TICK, self(), tick),
    %% erlang:send_after(?MAIL_SEND_TICK, self(), send_tick),
    ?INFO("启动完成"),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

%%----------------------------------------------------------------
%% handle_cast
%%---------------------------------------------------------------
handle_cast({timing_online_mail, Time, Module, Funtion, Args}, State) ->
    case Time - util:unixtime() of
        Diff when Diff > 0 ->
            erlang:send_after(Diff * 1000, self(), {timing_online_mail, Module, Funtion, Args});
        _ ->
            self() ! {timing_online_mail, Args}
    end,
    {noreply, State};

%% 用户投递信件
handle_cast({deliver, Mail}, State = #state{buffer = Buffer}) ->
    case Buffer of
        [] -> self() ! send_tick;
        _ -> ok
    end,
    {noreply, State#state{buffer = [{0, Mail} | Buffer]}};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%---------------------------------------------------------------
%% handle_info
%%---------------------------------------------------------------
handle_info({timing_online_mail, Module, Funtion, Args}, State) ->
    spawn(Module, Funtion, Args),
    {noreply, State};

%% 定时信件清除
handle_info(tick, State) ->
    ?INFO("开始执行过时邮件清除！"),
    mail_dao:del_timeout(),
    ?INFO("结束执行过时邮件清除"),
    erlang:send_after(?MAIL_TIME_TICK, self(), tick),
    {noreply, State};

%% 发送缓存区信件
handle_info(send_tick, State = #state{buffer = Buffer}) ->
    NewBuffer = do_send(0, Buffer, []),
    case NewBuffer of
        [] -> ok;
        _ -> erlang:send_after(?MAIL_SEND_TICK, self(), send_tick) %% 还有信件 过几秒再继续处理
    end,
    {noreply, State#state{buffer = NewBuffer}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%-------------------------------
%% 内部方法
%%-------------------------------

%% 发送缓存区的信件
do_send(_, [], NewBuffer) -> NewBuffer;
do_send(?MAIL_DO_MAX_ONCE, Buffer, NewBuffer) -> %% 单次投递数量已达
    NewBuffer ++ Buffer;
do_send(N, [{X, Mail = #mail{to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName, subject = Subject}} | Buffer], NewBuffer) -> 
    case mail_dao:insert(1, Mail) of
        {false, _Reason} when X >= ?MAIL_SEND_MAX_TIMES -> %% 该信件发送多次仍失败 丢弃
            ?ERR("信件投递多次仍不成功 丢弃该信件[name:~s][subject:~s]", [ToName, Subject]),
            do_send(N + 1, Buffer, NewBuffer);
        {false, _Reason} -> %% 投递失败 等待下次重试 
            do_send(N + 1, Buffer, [{X + 1, Mail} | NewBuffer]);
        {ok, _} -> %% 信件发送成功
            case role_api:lookup(by_id, {ToRid, ToSrvId}, #role.link) of
                {ok, _N, #link{conn_pid = ConnPid}} -> %% 收信人在线 推送新信件
                    sys_conn:pack_send(ConnPid, 11702, {[Mail]});
                _ ->
                    ok
            end,
            do_send(N + 1, Buffer, NewBuffer)
    end.

%% 生成物品附件数据
make_item([], Items) -> Items;
make_item([Item | T], Items) when is_record(Item, item) ->
    make_item(T, [Item | Items]);
make_item([{BaseId, Bind, Num} | T], Items) ->
    case item:make(BaseId, Bind, Num) of
        {ok, NewItems} ->
            make_item(T, Items ++ NewItems);
        _ ->
            make_item(T, Items)
    end;
make_item([_ | T], Items) ->
    make_item(T, Items);
make_item(_, Items) -> 
    Items.
