%%----------------------------------------------------
%% 信件系统 唯一ID生成管器
%% 
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(mail_id_mgr).
-behaviour(gen_server).
-export([
        get_id/0
        ,start_link/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {next_id = 1}).
-include("common.hrl").

%% 获取唯一ID
get_id() ->
    case catch gen_server:call(?MODULE, get_id) of
        Id when is_integer(Id) -> Id;
        _Reason ->
            ?ERR("生成信件唯一ID失败:~w", [_Reason]),
            util:unixtime()
    end.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("正在启动..."),
    case mail_dao:get_maxid() of
        {ok, MaxId} ->
            State = #state{next_id = MaxId + 1},
            ?INFO("启动完成"),
            {ok, State};
        _ ->
            ?ERR("信件系统启动失败，无法取得信件最大ID值"),
            {stop, load_failure}
    end.

%% 获取下一个可用ID
handle_call(get_id, _From, State = #state{next_id = Id}) ->
    {reply, Id, State#state{next_id = Id + 1}};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
