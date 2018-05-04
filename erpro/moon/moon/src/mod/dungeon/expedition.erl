%% --------------------------------------------------------------------
%% 远征王军
%% @mobin
%% @end
%% --------------------------------------------------------------------
-module(expedition).

-behaviour(gen_server).

%% export functions
-export([
        start_link/0
        ,get_hall/0
        ,login/1
        ,logout/1
        ,push_status/1
        ,enter_dungeon/5
        ,add_enter_count/2
        ,get_left_count/1
        ,get_enter_times/1
        ,add_enter_times/1
        %,get_left_buy/1
        ,get_buy_times/1
        ,get_highest_room_type/1
        ,get_lev_limit/1
        ,fix_enter_times/1
        ,push_info/1
        ,buy_price/1
        ,get_buy_limit/1
    ]
).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% includes
-include("common.hrl").
-include("hall.hrl").
-include("dungeon.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("assets.hrl").
-include("unlock_lev.hrl").
-include("expedition.hrl").
-include("vip.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_hall() ->
    gen_server:call(?MODULE, get_hall).

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户上线处理
login(Role) ->
    Role1 = version_upgrade(Role),
    %push_status(Role1).
    Role1.

version_upgrade(Role = #role{expedition = {_, _}}) ->
    Role#role{expedition = #expedition{}};
version_upgrade(Role) ->
    Role.

logout(Role = #role{expedition = Exp}) ->
    case Exp of
        #expedition{} ->
            {ok, Role#role{expedition = Exp#expedition{partners = []}}};
        _ ->
            {ok, Role}
    end.

push_status(Role) ->
    Role.
%push_status(Role = #role{lev = Lev, link = #link{conn_pid = ConnPid}, assets = #assets{cooperation = Cooperation}}) ->
%    UnlockLev = ?expedition_unlock_lev,
%    case Lev < UnlockLev of 
%        true ->
%            ignore;
%        false ->
%            LeftCount = get_left_count(Role),
%            sys_conn:pack_send(ConnPid, 13580, {LeftCount, Cooperation})
%    end,
%    Role.

%% 进入副本
enter_dungeon(DungeonId, HallId, RoomNo, #hall_role{pid = LeaderPid}, Members) ->
    role:apply(async, LeaderPid, {fun async_enter_dungeon/5, [DungeonId, HallId, RoomNo, Members]}),
    ok.

add_enter_count(Role = #role{expedition = Exp = #expedition{times = EnterCount, last_time = Last}, link = #link{conn_pid = ConnPid}}, Cooperation) ->
    case role_gain:do(#gain{label = cooperation, val = Cooperation}, Role) of
        {ok, Role2 = #role{assets = #assets{cooperation = Cooperation2}}} ->
            EnterCount2 = case Last >= util:unixtime({today, util:unixtime()}) of
                true ->
                    EnterCount + 1;
                false ->
                    1
            end,
            sys_conn:pack_send(ConnPid, 13580, {?expedition_limit_count - EnterCount2, Cooperation2}),

            {ok, Role3} = medal:join_activity(Role2, kingdomfight),
            random_award:kingdomfight(Role2),
            log:log(log_activity_activeness, {<<"远征王军玩法">>, 2, Role}),

            {ok, Role3#role{expedition = Exp#expedition{times = EnterCount2, last_time = util:unixtime()}}};
        _ ->
            {ok, Role}
    end.

get_left_count(#role{expedition = Expedition}) ->
    get_left_count(Expedition);
get_left_count(Exp = #expedition{times = EnterCount, last_time = Last}) ->
    BuyTimes = get_buy_times(Exp),
    case Last >= util:unixtime({today, util:unixtime()}) of
        true ->
            erlang:max(0, ?expedition_limit_count + BuyTimes - EnterCount);
        false ->
            erlang:max(0, ?expedition_limit_count + BuyTimes)
    end.

get_enter_times(#role{expedition = Expedition}) ->
    get_enter_times(Expedition);
get_enter_times(#expedition{times = EnterCount, last_time = Last}) ->
    case Last >= util:unixtime({today, util:unixtime()}) of
        true -> EnterCount;
        false -> 0
    end.

add_enter_times(Role = #role{expedition = Exp}) ->
    EnterTimes = expedition:get_enter_times(Role),
    Role#role{expedition = Exp#expedition{
            times = EnterTimes + 1 
            ,last_time = util:unixtime()  
            ,partners = []
        }
    }.

get_highest_room_type(Lev) ->
    util:ceil((Lev - 19) / 5).

get_lev_limit(RoomType) ->
    20 + (RoomType - 1) * 5.

% get_left_buy(#role{expedition = Expedition, vip = #vip{type = VipType}}) ->
%     get_left_buy(Expedition, VipType).
% get_left_buy(#expedition{buy_times = BuyCount, last_buy_time = Last}, VipType) ->
%     case Last >= util:unixtime({today, util:unixtime()}) of
%         true ->
%             ?expedition_limit_buy + vip_profit(VipType) - BuyCount;
%         false ->
%             ?expedition_limit_buy + vip_profit(VipType)
%     end.

get_buy_times(#role{expedition = Expedition}) ->
    get_buy_times(Expedition);
get_buy_times(#expedition{buy_times = BuyCount, last_buy_time = Last}) ->
    case Last >= util:unixtime({today, util:unixtime()}) of
        true -> BuyCount;
        false -> 0
    end. 
%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    Hall = #hall{type = ?hall_type_expedition},
    {ok, Id, Pid} = hall_mgr:create(Hall),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, Hall#hall{id = Id, pid = Pid}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages

handle_call(get_hall, _From, State) ->
    {reply, {ok, State}, State};

handle_call(_Request, _From, State) ->
    {reply, ignore, State}.

%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
async_enter_dungeon(Role, DungeonId, HallId, RoomNo, Members) ->
    MemberPids = [RolePid || #hall_role{pid = RolePid} <- Members],
    Extra = [{hall, HallId, RoomNo}],
    %%合作值
    Cooperation = case length(Members) of
        0 ->
            0;
        Count ->
            expedition_data:cooperation(DungeonId, Count + 1)
    end,

    case dungeon_type:roles_enter(Role, dungeon_data:get(DungeonId), MemberPids, Extra, Cooperation) of
        {ok, Role2} ->
            add_enter_count(Role2, Cooperation);
        {false, _Reason} ->
            {ok}
    end.

fix_enter_times(Exp = #expedition{last_time = LastTime}) ->
    case LastTime >= util:unixtime({today, util:unixtime()}) of
        false -> Exp#expedition{times = 0, last_time = 0};
        true -> Exp
    end.

%% 购买次数价格
buy_price(1) -> 10;
buy_price(2) -> 10;
buy_price(3) -> 20;
buy_price(4) -> 20;
buy_price(5) -> 40;
buy_price(_) -> undefined. %% 表示上限

%% vip 附加 购买次数
% vip_profit(0) -> 1;
% vip_profit(1) -> 1;
% vip_profit(2) -> 1;
% vip_profit(3) -> 2;
% vip_profit(4) -> 2;
% vip_profit(5) -> 2;
% vip_profit(6) -> 3;
% vip_profit(7) -> 3;
% vip_profit(8) -> 4;
% vip_profit(9) -> 4;
% vip_profit(10) -> 5;
% vip_profit(_) -> 5.

push_info(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    LeftEnter = get_left_count(Role),
    BuyTimes = get_buy_times(Role),
    BuyPrice = case buy_price(BuyTimes + 1) of undefined -> 0 ; B -> B end,
    %BuyLimit = vip_profit(VipType),
    BuyLimit = get_buy_limit(Role),
    sys_conn:pack_send(ConnPid, 13571, {LeftEnter, BuyTimes, BuyLimit, BuyPrice}).

get_buy_limit(Role) ->
    1 + vip:expedition_buy(Role).
