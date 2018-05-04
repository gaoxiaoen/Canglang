%% *************************
%% 竞技场的协议处理
%% @author mobin
%% *************************
-module(compete_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("pos.hrl").
-include("link.hrl").
%%
-include("compete.hrl").
-include("hall.hrl").

%% 请求活动状态
handle(16200, _, #role{link = #link{conn_pid = ConnPid}}) ->
    compete_mgr:get_status(ConnPid),
    {ok};

handle(16203, _, #role{id = Rid, link = #link{conn_pid = ConnPid}}) ->
    compete_mgr:cancel_match(Rid, ConnPid),
    {ok};

handle(16210, {}, Role = #role{id = Rid, compete = Compete, hall = #role_hall{id = HallId}}) ->
    TodayHonor = compete_mgr:get_today_honor(Rid),
    BuffCount = compete_mgr:get_buff_count(Rid),
    LeftCount = compete_mgr:get_left_count(Compete),

    {Result, Role4} = case ets:lookup(compete_role, Rid) of
        [#sign_up_role{}] ->
            {?false, Role};
        _ ->
            %%战斗结束才可退出
            Role2 = case LeftCount of
                0 ->
                    hall:leave(HallId, Role),
                    Role#role{event = ?event_no};
                _ ->
                    hall:back_to_hall(Role)
            end,
            {?true, Role2}
    end,
    {reply, {Result, LeftCount, TodayHonor, BuffCount}, Role4};
    
handle(16220, {}, _Role = #role{id = Rid}) ->
    Items = compete_change:list(Rid),
    {reply, {Items}};

handle(16221, {Id, Num}, Role) when Num >= 1 ->
    case compete_change:buy(Id, Num, Role) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok};
        {ok, NewAssets, NewBag} ->
            Role2 = Role#role{assets = NewAssets, bag = NewBag},
            role_api:push_assets(Role, Role2),
            notice:alert(succ, Role, ?MSGID(<<"兑换成功，物品已经发送到你的背包">>)),
            {reply, {}, Role2}
    end;

handle(16225, {}, _Role = #role{link = #link{conn_pid = ConnPid}}) ->
    compete_rank:get_ranks(ConnPid),
    {ok};

%% 容错
handle(_Cmd, _Data, _Role = #role{name = _Name}) ->
    ?ERR("收到[~s]发送的无效信息[Cmd:~w Data:...]", [_Name, _Cmd]),
    {ok}.
