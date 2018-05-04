%%----------------------------------------------------
%% 淘宝金币活动
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(campaign_taobao_tjb).

-behaviour(gen_server).

-export([
        start_link/0
        ,reload/0
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(camp_taobao_role_tjb, {
        account = <<>>      %% 账号
        ,status = 0
    }
).
-record(state, {}).

-define(camp_taobao_campid, taobao_tjb20130428).   %% 活动id

-include("common.hrl").
-include("mail.hrl").

%%----------------------------------------------------
%% API
%%----------------------------------------------------
%% 启动
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 重载
reload() ->
    gen_server:cast(?MODULE, {reload}).

%%----------------------------------------------------
%% gen_server fun
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(ets_taobao_tjb, [set, named_table, public, {keypos, #camp_taobao_role_tjb.account}]),
    do_reload(),
    case util:platform(undefined) of
        "taobao" -> erlang:send_after(60 * 1000, self(), {check_account});
        _ -> ignore
    end,
    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({reload}, State) ->
    Now = util:unixtime(),
    case get(reload_time) of
        undefined ->
            do_reload(),
            put(reload_time, Now);
        Time when (Time + 3) < Now ->
            do_reload(),
            put(reload_time, Now);
        _ -> ignore
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 检查
handle_info({check_account}, State) ->
    SelectMs = [{
        {'$1','$2','$3'},
        [{'=:=', '$3', 0}],
        ['$_']}],
    case ets:select(ets_taobao_tjb, SelectMs) of
        [] -> ignore;
        AccountList ->
            send_account(AccountList)
    end,
    erlang:send_after(60 * 1000, self(), {check_account}),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% internal
%%----------------------------------------------------
%% 重载数据
do_reload() ->
    case get_all() of 
        {ok, Data} ->
            ets:delete_all_objects(ets_taobao_tjb),
            insert_ets(Data);
        {false, Reason} ->
            {false, Reason}
    end.

get_all() ->
    Sql = <<"select account, status from sys_camp_progress where type = 'taobao_tjb' and camp_id = ~s and status = 0">>,
    case db:get_all(Sql, [?camp_taobao_campid]) of
        {ok, Data} -> {ok, Data};
        {error, Msg} ->
            ?ERR("执行数据库出错了[Msg:~w]", [Msg]),
            {false, Msg}
    end.

insert_ets([]) -> ok;
insert_ets([[Account, Status] | T]) ->
    ets:insert(ets_taobao_tjb, #camp_taobao_role_tjb{account = Account, status = Status}),
    insert_ets(T).

update_status(Account) ->
    Sql = <<"update sys_camp_progress set status = 1 where type = 'taobao_tjb' and account = ~s">>,
    db:execute(Sql, [Account]).

send_account([]) -> ok;
send_account([#camp_taobao_role_tjb{account = Account} | T]) ->
    Sql = <<"select id, srv_id, account from role where account = ~s">>,
    case db:get_all(Sql, [Account]) of
        {ok, Data} -> 
            case update_status(Account) of
                {ok, Affected} when Affected > 0 ->
                    send_role(Data),
                    send_account(T);
                _ ->
                    send_account(T)
            end;
        {error, Msg} ->
            ?ERR("执行数据库出错了[Msg:~w]", [Msg]),
            send_account(T)
    end;
send_account([_H | T]) ->
    send_account(T).

send_role([]) -> ok;
send_role([[RoleId, SrvId, Account] | T]) ->
    send_mail(RoleId, SrvId),
    ets:insert(ets_taobao_tjb, #camp_taobao_role_tjb{account = Account, status = 1}),
    send_role(T).

send_mail(RoleId, SrvId) ->
    Subject = ?L(<<"惊喜兑换，绑定晶钻大礼">>),
    MailGold = [{?mail_gold_bind, 288}],
    mail_mgr:deliver({RoleId, SrvId}, {Subject, <<"亲爱的玩家，恭喜您获得100淘金币兑换的288晶钻大礼，请注意查收！感谢您对梦幻飞仙的鼎力支持，祝您游戏愉快！">>, MailGold, []}).
