%%----------------------------------------------------
%% 后台邮件系统 
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(mail_adm_mgr).
-behaviour(gen_fsm).
-export([add_buff/1, send_buff_mail/1, state/0]).
-export([start_link/0, init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([idle/2, busy/2]).
-export([idle/3, busy/3]).

-include("common.hrl").
-include("mail.hrl").
-include("item.hrl").
-include("gain.hrl").

-define(MAIL_BUFF_CHECK, (3 * 1000)).  %% 工作的时候 6 秒钟发一次
-define(MAIL_ONETIME_SEND_MAX, 100).   %% 1 次允许发送最多100封邮件

%% @spec add_buff(MailBuff) -> ok
%% MailBuff = #mail_buff{}
%% @doc 添加一条邮件缓存
add_buff(MailBuff = #mail_buff{}) ->
    gen_fsm:send_event({global, ?MODULE}, {mail_buff, MailBuff});
add_buff(_MailBuff) ->

    ?ERR("错误的邮件缓存数据 ~w", [_MailBuff]),
    ok.

%% @spec state() -> term()
%% @doc 获取当前状态
state() ->
    gen_fsm:sync_send_all_state_event({global, ?MODULE}, get_state).

%%----------------------------------------------------------------
%% 系统函数
%%----------------------------------------------------------------
start_link() ->
    gen_fsm:start_link({global, ?MODULE}, ?MODULE, [], []).

%%----------------------------------------------------------------
%% 初始化
%%----------------------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, idle, [], hibernate}.

%% 添加邮件缓存
idle({mail_buff, MailBuff}, _State) ->
    gen_fsm:send_event_after(?MAIL_BUFF_CHECK, mail_buff_check),
    {next_state, busy, [MailBuff]};

idle(_Event, State) ->
    {next_state, idle, State, hibernate}.

%% 添加邮件缓存
busy({mail_buff, MailBuff}, MailBuffs) ->
    {next_state, busy, MailBuffs ++ [MailBuff]};

%% 检测邮件缓存
busy(mail_buff_check, Mails) ->
    gen_fsm:send_event_after(?MAIL_BUFF_CHECK, mail_buff_check),
    case length(Mails) > ?MAIL_ONETIME_SEND_MAX of
        true ->
            {GoingSend, Rem} = lists:split(?MAIL_ONETIME_SEND_MAX, Mails),
            spawn(?MODULE, send_buff_mail, [GoingSend]),
            {next_state, busy, Rem};
        false ->
            spawn(?MODULE, send_buff_mail, [Mails]),
            {next_state, idle, [], hibernate}
    end;

busy(_Event, State) ->
    {next_state, busy, State}.

handle_event(_Event, StateName, StateData) ->
    {next_state, StateName, StateData}.

idle(_Event, _From, StateData) ->
    {next_state, idle, StateData, hibernate}.

busy(_Event, _From, StateData) ->
    {next_state, busy, StateData}.

handle_sync_event(get_state, _From, idle, StateData) ->
    {reply, {idle, StateData}, idle, StateData, hibernate};

handle_sync_event(get_state, _From, StateName, StateData) ->
    {reply, {StateName, StateData}, StateName, StateData};

handle_sync_event(_Event, _From, StateName, StateData) ->
    {next_state, StateName, StateData}.

handle_info(_Info, StateName, StateData) ->
    {next_state, StateName, StateData}.

terminate(_Reason, _StateName, _StateData) ->
    ok.

code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.

%%-----------------------------------------------------------------
%% 私有函数
%%-----------------------------------------------------------------
send_buff_mail(Mails) ->
    send_buff_mail(Mails, [], []).

%% 所有邮件发送完毕
send_buff_mail([], Fails, Success) -> 
    ?DEBUG("----Success----~p~n~n~n", [Success]),
    ?DEBUG("----Fails----~p~n~n~n", [Fails]),

    log_send_mail(failed, Fails),
    log_send_mail(success, Success), 
    ok;

send_buff_mail([H = #mail_buff{dest = Dest, subject = SubJect, content = Content, assets = Assets, items = Items} | T], OF, OS) -> 
    ?DEBUG("--Dest--~p~n~n~n", [Dest]),
    %AssetsGain = make_assets(Assets, []), 
    %ItemsGain = make_items(Items, []),
    %Gains = AssetsGain ++ ItemsGain,
    %award:send(Dest, 301000, _SubJect, Content, Gains),
    %send_buff_mail(T, OF, [H | OS]).
     case mail:send_system(Dest, {SubJect, Content, Assets, Items}) of
         ok ->
             send_buff_mail(T, OF, [H | OS]);
         {false, Reason} ->
             send_buff_mail(T, [{H, Reason} | OF], OS)
     end.
    
%%  2 ---> 金币        3 ---> 晶钻     4 ---> 绑定晶钻   5 ---> 龙鳞 6 --->符石
%get_atom(2) -> coin;
% get_atom(1) -> coin_bind;
%get_atom(3) -> gold;
%get_atom(4) -> gold_bind;
%get_atom(5) -> scale;
%get_atom(6) -> stone;
%get_atom(_) -> skip.


%make_assets([], L) -> L;
%make_assets([{Type, Value}|T], L) ->
%    case get_atom(Type) of 
%        skip ->
%            make_assets(T, L);
%        Label ->
%            Gain = #gain{label = Label, val = Value},
%            make_assets(T, [Gain] ++ L)
%    end.
    
%make_items([], L) -> L;
%make_items([#item{base_id = BaseId, bind = Bind, quantity = Quality}|T], L) ->
%    Gain = #gain{label = item, val = [BaseId, Bind, Quality]},
%    make_assets(T, [Gain] ++ L).
    


%% 组装邮件日志，失败
log_send_mail(failed, []) ->
    ok;
log_send_mail(failed, [{#mail_buff{adm = Adm, dest = Dest, name = Name, submit_time = Time, subject = Sub, 
                content = Content, assets = Assets, items_info = ItemsInfo}, Reason} | Fails]
) ->
    {Coin, Gold, BGold, Stone, Scale} = check_send_assets(Assets),
    insert_mail_log([{failed_dest_to_binary(Dest, Name, Reason), Sub, Content, Adm, Time, Coin, Gold, BGold, Stone, Scale, ItemsInfo}]),
    log_send_mail(failed, Fails);

%% 成功
log_send_mail(success, Success) ->
    ArgsList = split(Success),
    insert_mail_log(ArgsList).

%% 失败角色
failed_dest_to_binary({Rid, Srvid}, Name, Reason) -> 
    util:fbin(<<"<font color=\"#FF0000\">[{~w,~s}, ~s]<Br>~s</font>">>, [Rid, Srvid, Name, Reason]).

%% 成功角色
dest_to_binary({Rid, Srvid}, Name) -> 
    util:fbin(<<"[{~w,~s}, ~s]">>, [Rid, Srvid, Name]).

%% 保存后台邮件日志
insert_mail_log([]) ->
    ok;
insert_mail_log([{Roles, Subject, Text, AdmName, Time, Coin, Gold, BindGold, Stone, Scale, Items} | T]) ->
    mail_adm_db:insert_mail_log(Roles, Subject, Text, AdmName, Time, Coin, Gold, BindGold, Stone, Scale, Items),
    insert_mail_log(T).

%% 找出发送的金币，晶钻数
check_send_assets(Assets) ->
    check_send_assets(Assets, {0, 0, 0, 0, 0}).
check_send_assets([], Re) ->
    Re;
check_send_assets([{?mail_coin, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin + Value, Gold, BindGold, Stone, Scale});
check_send_assets([{?mail_gold, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold + Value, BindGold, Stone, Scale});
% check_send_assets([{?mail_coin_bind, Value} | T], {Coin, Gold, BindCoin, BindGold}) ->
%     check_send_assets(T, {Coin, Gold, BindCoin + Value, BindGold});
check_send_assets([{?mail_gold_bind, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold, BindGold + Value, Stone, Scale});

check_send_assets([{?mail_stone, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold, BindGold, Stone + Value, Scale});
check_send_assets([{?mail_scale, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold, BindGold, Stone, Scale + Value});

check_send_assets([_ | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold, BindGold, Stone, Scale}).

%% 分割发送成功的邮件日志
split(Success) ->
    ?DEBUG("---success----:~p~n~n~n",[Success]),
    split(Success, []).
split([], ArgsList) -> ArgsList;
split([#mail_buff{adm = Adm, dest = Dest, name = Name, submit_time = Time, subject = Sub, content = Content, assets = Assets, items_info = ItemsInfo} | T], ArgsList) ->
    case lists:keyfind(Time, 5, ArgsList) of
        false ->
            {Coin, Gold, BGold, Stone, Scale} = check_send_assets(Assets),
            NewArgsList = [{dest_to_binary(Dest, Name), Sub, Content, Adm, Time, Coin, Gold, BGold, Stone, Scale, ItemsInfo} | ArgsList],
            split(T, NewArgsList);
        {Roles, _, _, _, _, Coin, Gold, BGold, Stone, Scale, ItemsInfo} ->
            NewArgsList = lists:keyreplace(Time, 5, ArgsList, {util:fbin(<<"~s<Br>~s">>, [Roles, dest_to_binary(Dest, Name)]), Sub, Content, Adm, Time, Coin, Gold, BGold, Stone, Scale, ItemsInfo}),
            split(T, NewArgsList)
    end.

