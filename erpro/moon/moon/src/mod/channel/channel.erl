%% ***********************
%% 元神相关操作
%% @author wprehard@qq.com
%% ***********************
-module(channel).
-export([
        init/0                  %% 初始化
        ,login/1                %% 登陆检测
        ,calc/1                 %% 属性
        ,speed_up/1
        ,check_can_practice/3
        ,broad_msg/4
        ,pack_proto_msg/2       %% 打包消息
        ,practice_callback/1    %% 修炼完成回调
        ,get_upgrade_loss/3
        ,calc_lev_channel/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("channel.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("storage.hrl").
-include("item.hrl").
%%

%% @spec init() -> RoleChannel
%% RoleChannelS = #channels{}
%% @doc 获取初始化的元神列表,都默认为0级未修炼,time = 0标示未修炼
init() ->
    #channels{
        flag = 0
        ,time = 0
        ,cd_time = 0
        ,list = [#role_channel{id = Id, lev = 0} || Id <- ?channels]
    }.

%% @spec login(Role) -> any()
%% @doc 角色登陆时检测元神修炼情况，包括预约队列的判断
login(Role = #role{channels = C = #channels{time=Time, cd_time = Cd}}) ->
    Now = util:unixtime(),
    case Time =:= 0 of
        true ->
            Role;
        false ->
            case (Now-Time) >= Cd  of
                true ->
                    Role#role{channels = C#channels{time=0, cd_time=0}};
                false -> 
                    Elapse = Cd - (Now-Time),
                    %%?DEBUG("**************  Elapse  ~w, Cd: ~w, Time: ~w", [Elapse, Cd, Time]),
                    NR = role_timer:set_timer(channel, Elapse * 1000, {channel, practice_callback, []}, 1, Role),
                    NR1 = NR#role{channels = C#channels{time = Now, cd_time=Elapse}},
                    NR1
            end
    end.

%% @spec calc(Role) -> NewRole
%% @doc 元神的属性计算
calc(R = #role{channels = #channels{list = []}}) ->
    ?ERR("角色属性计算：元神列表为空"),
    R;
calc(Role = #role{channels = #channels{list = Channels}}) ->
    Fun = fun(Id, Lev, State) ->
            case channel_data:get(Id, Lev) of
                error -> [];
                #channel{attr = {A, V}} ->
                    {A, (V * (200 + State * 8) / 300)}
            end
    end,
    AttrList1 = [Fun(Id, Lev, State) || #role_channel{id = Id, lev = Lev, state = State} <- Channels, Lev > 0],
    SumState = get_sum_state(Channels),  %% 算出强化之和
    %%?DEBUG("******* 所有最大强化值  ~w", [SumState]),
    AttrList2 = get_award_attr(SumState),
    %%?DEBUG("**** 奖励属性  ~w", [AttrList2]),
    case role_attr:do_attr(AttrList1, Role) of
        {false, _Reason} ->
            ?DEBUG("角色[ID:~w]元神属性计算错误:~w", [Role#role.id, _Reason]),
            Role;
        {ok, NewRole1} ->
            case role_attr:do_attr(AttrList2, NewRole1) of
                {false, _Reason} ->
                    ?DEBUG("角色[ID:~w]元神奖励属性计算错误:~w", [Role#role.id, _Reason]),
                    NewRole1;
                {ok, NewRole2} ->
                    NewRole2
            end
    end;
calc(Role) ->
    ?ELOG("计算元神出错[Channel: ~w]", [Role#role.channels]),
    Role.

%% 加速Cd
speed_up(Role = #role{channels = C = #channels{time=Time, cd_time=Cd}}) ->
    case Time =:= 0 of
        true -> 
            {false, ?MSGID(<<"不需消除冷却时间">>)};
        false -> 
            Now = util:unixtime(),
            case Now-Time >= Cd of
               true ->
                   {false, ?MSGID(<<"不需消除冷却时间">>)};
               false -> 
                   Elapse = Cd - (Now-Time),
                   NeedYb = manor:sec2yb(Elapse),
                   case role_gain:do([#loss{label=gold, val=NeedYb}], Role) of
                       {false, _} -> 
                           {false, ?MSGID(<<"晶钻不足">>)};
                       {ok, Role1} ->
                            Role2 = Role1#role{channels = C#channels{time = 0, cd_time = 0}},
                            case role_timer:del_timer(channel, Role2) of
                                {ok, _, Role3} -> {ok, Role3};
                                false -> {ok, Role2}
                            end
                    end
            end
    end.


%% @spec broad_msg(Role, ChannelId, OldState, NewState) -> any()
%% @doc 提升境界广播消息
broad_msg(_Role, _, OldState, _) when OldState < 190 -> ignore;
broad_msg(Role, ChannelId, OldState, NewState) when OldState < NewState ->
    RoleMsg = notice:role_to_msg(Role),
    InfoMsg = util:fbin(?L(<<"三魂化形，七魄炼体。~s使用元神成长丹凝魂铸元神，成功将[~s]的境界提升到{str,~w,#ff9600}层！">>), [RoleMsg, id2name(ChannelId), (NewState div 10)]),
    notice:send(53, InfoMsg);
broad_msg(_, _, _, _) -> ignore.

%% @spec pack_proto_msg(Cmd, Data) -> Msg
%% @doc 打包消息, 错误返回空消息
%% 元神列表返回
pack_proto_msg(12900, #channels{list = Channels, time=Time, cd_time=Cd}) ->
    CdTime = case Time =:= 0 of
        true -> 0;
        false -> 
            Now = util:unixtime(),
            case Now-Time >= Cd of
               true -> 0;
               false -> Cd - (Now-Time)
            end
    end,
    {CdTime, [{Id, Lev, State} || #role_channel{id = Id, lev = Lev, state = State} <- Channels]};
pack_proto_msg(12910, Channels) ->
    Fun = fun(Id, Lev, State) ->
            Val = case channel_data:get(Id, Lev) of
                error -> 0;
                #channel{attr = {_, V}} -> V
            end,
            case channel_data:get(Id, Lev + 1) of
                #channel{cond_lev = CondLev,
                    cost_spirit = CostSpirit,
                    cond_before = {BeforeId, BeforeLev},
                    attr = {_, NextVal}
                } -> {Id, Lev, State, Val, NextVal, CostSpirit, CondLev, BeforeId, BeforeLev};
                _ -> {Id, Lev, State, Val, 0, 0, 0, 0, 0}
            end
    end,
    {[Fun(Id, Lev, State) || #role_channel{id = Id, lev = Lev, state = State} <- Channels]};
%% 修炼完成通知
pack_proto_msg(12904, {Id, Lev, State}) ->
    Val = case channel_data:get(Id, Lev) of
        #channel{attr = {_, V}} -> V;
        _ -> 0
    end,
    case channel_data:get(Id, Lev + 1) of
        #channel{cond_lev = CondLev,
            cost_spirit = CostSpirit,
            cond_before = {BeforeId, BeforeLev},
            attr = {_, NextVal}
        } -> {Id, 0, Lev, State, Val, NextVal, CostSpirit, CondLev, BeforeId, BeforeLev};
        _ -> {Id, 0, Lev, State, Val, 0, 0, 0, 0, 0}
    end;
%% 返回单个元神状态
pack_proto_msg(12909, #role_channel{id = Id, lev = Lev, state = State, time = Time}) ->
    Val = case channel_data:get(Id, Lev) of
        #channel{attr = {_, V}} -> V;
        _ -> 0
    end,
    case channel_data:get(Id, Lev + 1) of
        #channel{cond_lev = CondLev,
            cost_spirit = CostSpirit,
            cond_before = {BeforeId, BeforeLev},
            attr = {_, NextVal}
        } -> {Id, Time, Lev, State, Val, NextVal, CostSpirit, CondLev, BeforeId, BeforeLev};
        _ -> {Id, Time, Lev, State, Val, 0, 0, 0, 0, 0}
    end;
%% 提升境界返回
pack_proto_msg(12905, {Msg, #role_channel{id = Id, lev = Lev, state = State}}) ->
    Val = case channel_data:get(Id, Lev) of
        #channel{attr = {_, V}} -> V;
        _ -> 0
    end,
    case channel_data:get(Id, Lev + 1) of
        #channel{attr = {_, NextVal}} -> {Id, State, Val, NextVal, Msg};
        _ -> {Id, State, Val, 0, Msg}
    end;
pack_proto_msg(_, _) -> {}.


price(#role{bag = #bag{items = Items}}) ->
    case storage:find(Items, #item.base_id, 231001) of
        {false, _} ->
            Price = shop:item_price(231001),
            #loss{label = gold, val = Price, msg = ?MSGID(<<"晶钻不足">>)};
        _ ->
            #loss{label = item, val = [231001, 0, 1], msg = ?MSGID(<<"强化神源不足，无法强化神觉">>)}
    end.

%% @spec get_upgrade_loss(IsProtected) -> list()
%% 提升境界的损益数据
get_upgrade_loss(_, 0, 0) -> [#loss{label = item, val = [231001, 0, 1], msg = ?MSGID(<<"强化神源不足，无法强化神觉">>)}];
get_upgrade_loss(Role, 1, 0) -> [price(Role)];
get_upgrade_loss(_, 0, 1) ->
    [   
        #loss{label = item, val = [231001, 0, 1], msg = ?MSGID(<<"强化神源不足，无法强化神觉">>)}
        ,#loss{label = item, val = [231002, 0, 1], msg  = ?MSGID(<<"神觉强化护纹不足">>)}
    ];
get_upgrade_loss(Role, 1, 1) ->
    [   
        price(Role)
        ,#loss{label = item, val = [231002, 0, 1], msg  = ?MSGID(<<"神觉强化护纹不足">>)}
    ];
get_upgrade_loss(Role, _, _) -> get_upgrade_loss(Role, 0, 1).

%% @spec check_can_practice(Cahnnel, Channels, RoleLev) -> true | {false, Msg}
%% @doc
%% <pre>
%% Channel = list() of #role_channel{} 当前角色元神列表
%% 检查当前Channel是否可修炼
%% </pre>
check_can_practice(#channel{cond_lev = CondLev}, #channels{time=Time}, Rlev) ->
    case {Rlev < CondLev, Time =/= 0} of
        {true, _}-> {false, ?MSGID(<<"等级不足，无法修炼">>)};
        {_, true} -> {false, ?MSGID(<<"还在冷却中，不能升级神觉">>)};
        _ -> true
    end.

%% ******************************
%% 回调函数
%% @spec practice_callback(Role, ChannelId) -> {ok, NewRole} | {ok}
%% @doc 修炼完成，更新元神列表
practice_callback(Role = #role{channels = C, link = #link{conn_pid = _ConnPid}}) ->
    NR = Role#role{channels = C#channels{time=0, cd_time=0}},
    manor_rpc:pack_send_19521(NR),
    {ok, NR}.

calc_lev_channel(#role{lev = Rlev, channels = #channels{list = Channels}}) ->
    do_calc_lev_channel(Channels, Rlev, 0).

do_calc_lev_channel([], _Rlev, Num) -> Num;
do_calc_lev_channel([#role_channel{id = ChannelId, lev = Lev} | T], Rlev, Num) ->
    case channel_data:get(ChannelId, Lev + 1) of
        #channel{cond_lev = CondLev}->
            case Rlev < CondLev of
                true ->
                    do_calc_lev_channel(T, Rlev, Num);
                false ->
                    do_calc_lev_channel(T, Rlev, Num + 1)
            end;
        false ->
            do_calc_lev_channel(T, Rlev, Num)
    end.
%% ---------------------------------
%% 内部函数
%% ---------------------------------

%% 最大强化值
get_sum_state(Channels) ->
    Fun = fun(#role_channel{state = State}, V) ->
            case State < V of true -> State; false -> V end end,
    lists:foldl(Fun, 100, Channels).

get_award_attr(SumState) when (SumState div 10 ) =:= 1 -> channel_data:get_award_attr(10);
get_award_attr(SumState) when (SumState div 20 ) =:= 1 -> channel_data:get_award_attr(20);
get_award_attr(SumState) when (SumState div 30 ) =:= 1 -> channel_data:get_award_attr(30);
get_award_attr(SumState) when (SumState div 50 ) =:= 1 -> channel_data:get_award_attr(50);
get_award_attr(SumState) when (SumState div 70 ) =:= 1 -> channel_data:get_award_attr(70);
get_award_attr(SumState) when (SumState div 100 ) =:= 1 -> channel_data:get_award_attr(100);
get_award_attr(_SumState) -> [].

%% ID转名字
id2name(1 ) -> ?L(<<"精">>);
id2name(2 ) -> ?L(<<"灵">>);
id2name(3 ) -> ?L(<<"御">>);
id2name(4 ) -> ?L(<<"准">>);
id2name(5 ) -> ?L(<<"暴">>);
id2name(6 ) -> ?L(<<"避">>);
id2name(7 ) -> ?L(<<"攻">>);
id2name(8 ) -> ?L(<<"金">>);
id2name(_) -> <<>>.



