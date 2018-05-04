%% 日常任务代理管理器

-module(role_num_counter).
-behaviour(gen_server).

-export([
        start_link/0
        ,lookup/0
        ,update/1
    ]
).

-include("common.hrl").
-include("role.hrl").

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%-define(career_cike, 2).     %% 刺客
%%-define(career_xianzhe, 3).     %% 贤者
%%-define(career_qishi, 5).     %% 骑士

-record(state, {cike_0 = 0, cike_1 = 0, xianzhe_0 = 0, xianzhe_1 = 0, qishi_0 = 0, qishi_1 = 0}).

lookup() -> gen_server:call({global, ?MODULE}, {lookup}).

%%  = {Career, Sex, Num}
update(Info) -> gen_server:cast({global, ?MODULE}, {update, Info}).

%%----------------------------------------------------
%% 系统函数
%%----------------------------------------------------

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]), 
    ?INFO("[~w]启动完成~~", [?MODULE]),
    Order = [{?career_cike, 0}, {?career_cike, 1}, {?career_xianzhe, 0}, {?career_xianzhe, 1}, {?career_qishi, 0}, {?career_qishi, 1}],
    State = lists:foldl(fun(Info, S) -> init_num(Info, S) end, #state{}, Order),
    ?DEBUG("***** 当前服务器拥有角色情况 : ~w", [State]),
    {ok, State}.  

%%----------------------------------------------------
%% handle_call
%%----------------------------------------------------

handle_call({lookup}, _From, State) ->
    {reply, State, State};

handle_call(_Request, _From, _State) ->
    {noreply, _State}.

%%----------------------------------------------------
%% handle_cast
%%----------------------------------------------------
handle_cast({update, Info}, State)->
    State1 = update_state(Info, State),
    {noreply, State1};

handle_cast(_Msg, _State) ->
    {noreply, _State}.

%%----------------------------------------------------
%% handle_info
%%----------------------------------------------------

handle_info(_Info, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% 系统关闭
%%----------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%----------------------------------------------------
%% 热代码切换
%%----------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 私有函数。
%%----------------------------------------------------

update_state({Career, Sex, Num}, State = #state{cike_0 = Cike0, cike_1 = Cike1, xianzhe_0 = Xianzhe0, xianzhe_1 = Xianzhe1, qishi_0 = Qi0, qishi_1 = Qi1}) ->
    case {Career, Sex} of
        {?career_cike, 0} ->
            State#state{cike_0 = Cike0 + Num};
        {?career_cike, 1} ->
            State#state{cike_1 = Cike1 + Num};
        {?career_xianzhe, 0} ->
            State#state{xianzhe_0 = Xianzhe0 + Num};
        {?career_xianzhe, 1} ->
            State#state{xianzhe_1 = Xianzhe1 + Num};
        {?career_qishi, 0} ->
            State#state{qishi_0 = Qi0 + Num};
        {?career_qishi, 1} ->
            State#state{qishi_1 = Qi1 + Num}
    end.

init_num({Career, Sex}, State) ->
    SrvId = sys_env:get(srv_id),
    [PlatformPrefix | _T] = re:split(util:to_list(SrvId), "_", [{return, list}]),
    case db:get_one("select count(*) from role where career = ~s and sex = ~s and SUBSTRING_INDEX(srv_id,  '_', 1 ) = ~s", [Career, Sex, PlatformPrefix]) of
        {error, _Err} -> 
            State;
        {ok, N} when N > 0 ->
            ?DEBUG("         ******* 数量  ~w", [N]),
            update_state({Career, Sex, N}, State);
        {ok, _} ->
            State
    end.
