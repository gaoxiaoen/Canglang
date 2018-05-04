%% --------------------------
%% 礼包缓存服务器
%% @author shawnoyc@vip.qq.com
%% --------------------------
-module(item_srv_gift).
-behaviour(gen_server).
-export([
        start_link/0
       ,query_data/1
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("item.hrl").
%%

%% 清除宝盒时间执行时间 20分钟
-define(CLEAR_NEXT_TIME, 86400000).

%% ---对外接口------------

%% 启动服务器
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 查询某个宝盒的记录,没有的话,插入记录
query_data(BaseId) ->
    gen_server:call(?MODULE, {query_data, BaseId}).

%% ----服务器内部实现--------
init([]) ->
    %% 保存宝盒数据
    ?INFO("[~w] 正在启动...", [?MODULE]),
    self() ! clear_cache,
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, []}.

%% 查询宝盒记录, 如果查不到记录,就插入记录
%% State = [{BaseId, TimeStart, TimeLimit, Num, NumLimit} 
handle_call({query_data, BaseId}, _From, State) ->
    case lists:keyfind(BaseId, 1, State) of
        false -> 
            case item_gift_data:get_super(BaseId) of
                {BaseId, TimeLimit, NumLimit} ->
                    Now = util:unixtime(),
                    NewState = [{BaseId, Now, TimeLimit, 1, NumLimit} | State],
                    {reply, true, NewState};
                false ->
                    {reply, {false, ?L(<<"不存在的礼包">>)}, State}
            end;
        {BaseId, TimeStart, TimeLimit, Num, NumLimit} ->
            Now = util:unixtime(),
            case (Now >= TimeStart + TimeLimit) andalso Num < NumLimit of
                true ->
                    %%TODO 写数据库
                    NewState = [{BaseId, Now, TimeLimit, Num + 1, NumLimit} | State],
                    {reply, true, NewState};
                false ->
                    %% 时间没到, 或者数量已经出完了
                    {reply, {over, <<>>}, State}
            end
    end.

handle_cast(_Info, State) ->
    {noreply, State}.

%% 定时清除宝盒数据
handle_info(clear_cache, _State) ->
    erlang:send_after(?CLEAR_NEXT_TIME, self(), clear_cache),
    {noreply, []};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
