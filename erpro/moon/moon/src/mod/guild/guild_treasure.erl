%%----------------------------------------------------
%% 帮会宝库
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_treasure).
-export([add/3]).
-export([add_async/3]).
-export([start/1
        ,get_treasures/2
        ,allocate/6
        ,allocate_async/4
        ,allocate/2
        ,allocate_async/2
        ,get_guild_war_info/1
        ,get_guild_arena_info/1
        ,get_guild_war_member_info_rank/1
        ,get_guild_arena_member_info_rank/1
        ,get_allocate_log/1
        ,async_maintain/1
        ,get_treasures_score/2
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
%%
-include("link.hrl").
-include("guild_war.hrl").
-include("chat_rpc.hrl").
-include("item.hrl").
-include("guild_arena.hrl").
-include("guild_boss.hrl").

-define(treasure_log, 50).                      %% 宝库日志只保留50条

%% @type gid() :: {integer(), binary()}.

%% @spec start(GuildID) -> ok
%% GuildID = gid()
%% @doc 注册宝库日志午夜清理函数
start({Gid, Gsrvid}) ->
    guild:reg_maintain_callback({Gid, Gsrvid}, {?MODULE,  async_maintain, []}).

%% @spec async_maintain(Guild) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% @doc 宝库日志清理回调函数
async_maintain(Guild = #guild{treasure = {{NextID1, Treasure1, Log1}, {NextID2, Treasure2, Log2}, {NextID3, Treasure3, Log3}}}) ->
    {ok, Guild#guild{treasure = {{NextID1, Treasure1, lists:sublist(Log1, ?treasure_log)}, {NextID2, Treasure2, lists:sublist(Log2, ?treasure_log)}, {NextID3, Treasure3, lists:sublist(Log3, ?treasure_log)}}}}.

%% @spec get_treasures(Type, Gid) -> Lists
%% Gid = gid()
%% Type = 1 | 2
%% List = [{Value, BaseID, Bind, Quantity} | ...]
%% @doc Type 为1时获取圣战宝库情况， Type 为2时获取帮战宝库情况
get_treasures(?guild_treasure_war, {Gid, Gsrvid}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            [];
        #guild{treasure = {{_NextID, Treasures, _}, _, _}} ->
            [{ID, Value, BaseID, Bind, Quantity} || {ID, Value, {BaseID, Bind}, Quantity} <- Treasures]
    end;

get_treasures(?guild_treasure_arean, {Gid, Gsrvid}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            [];
        #guild{treasure = {_, {_NextID, Treasures, _}, _}} ->
            [{ID, Value, BaseID, Bind, Quantity} || {ID, Value, {BaseID, Bind}, Quantity} <- Treasures];
        _R ->
            ?DEBUG("数据结构是 ~p", [_R]),
            []
    end;
get_treasures(?guild_treasure_guild_boss, {Gid, Gsrvid}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            [];
        #guild{treasure = {_, _, {_NextID, Treasures, _}}} ->
            [{ID, Value, BaseID, Bind, Quantity} || {ID, Value, {BaseID, Bind}, Quantity} <- Treasures]
    end;
get_treasures(_Type, _) ->
    ?ERR("错误的帮会宝库类型 ~w", [_Type]),
    [].

%% @spec get_allocate_log(Role) -> List
%% Role = #role{}
%% @doc 宝库日志
get_allocate_log(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            {[], [], []};
        #guild{treasure = {{_, _, Log1}, {_, _, Log2}, {_, _, Log3}}} ->
            {Log1, Log2, Log3}
    end.

%% @spec get_treasures_score(Type, gid()) -> List
%% Type = 1 | 2
%% @doc Type 为1获取圣战宝库积分，Type 为2获取帮战宝库积分
get_treasures_score(?guild_treasure_war, {Gid, Gsrvid}) ->
    get_guild_war_score({Gid, Gsrvid});
get_treasures_score(?guild_treasure_arean, {Gid, Gsrvid}) ->
    get_guild_arean_score({Gid, Gsrvid});
get_treasures_score(?guild_treasure_guild_boss, {Gid, Gsrvid}) ->
    get_guild_boss_score({Gid, Gsrvid});
get_treasures_score(_Type, _Gid) ->
    ?ERR("错误的帮会宝库类型 ~w", [_Type]),
    [].

%% @spec get_guild_war_score(Gid) -> ScoreList
%% Gid = gid()
%% ScoreList = [{integer(), binary(), binary(), integer(), integer()} |..]
%% @doc 获取上场帮战/圣战积分, 用于宝库物品分配
get_guild_war_score({Gid, Gsrvid}) ->
    LastWarInfo = get_guild_war_member_info({Gid, Gsrvid}),
    List = [{Rid, Rsrvid, Rname, Rlev, Credit} || #guild_war_role{id = {Rid, Rsrvid}, name = Rname, lev = Rlev, credit = Credit} <- LastWarInfo],
    lists:reverse(lists:keysort(5, List)).

get_guild_arean_score({Gid, Gsrvid}) ->
    LastArenaInfo = get_guild_arena_member_info({Gid, Gsrvid}),
    List = [{Rid, Rsrvid, Rname, Rlev, Credit} || #guild_arena_role{id = {Rid, Rsrvid}, name = Rname, lev = Rlev, sum_score = Credit} <- LastArenaInfo],
    lists:reverse(lists:keysort(5, List)).

%% 帮会boss击杀积分
get_guild_boss_score({Gid, Gsrvid}) ->
    KillLog = guild_boss:get_info({kill_log, {Gid, Gsrvid}}),
    List = [{Rid, Rsrvid, Rname, Rlev, RDmg} || #guild_boss_role{id = {Rid, Rsrvid}, name = Rname, lev = Rlev, total_dmg = RDmg} <- KillLog],
    lists:reverse(lists:keysort(5, List)).

%% @spec get_guild_war_member_info_rank(Gid) -> List
%% Gid = gid()
%% List = [{binary(), integer(), integer(), integer(), integer(), integer()} |...]
%% @doc 获取上场圣战绩排行榜, 用于帮会面板的 圣战成绩标签页
get_guild_war_member_info_rank({Gid, Gsrvid}) ->
    LastWarInfo = get_guild_war_member_info({Gid, Gsrvid}),
    List = [{Rname, CreditCombat, CreditStone, CreditCompete, CreditSword, Credit} || 
        #guild_war_role{name = Rname, credit_combat = CreditCombat, credit = Credit,
            credit_stone = CreditStone, credit_compete = CreditCompete, credit_sword = CreditSword} <- LastWarInfo],
    lists:reverse(lists:keysort(6, List)).

%% @spec get_guild_arena_member_info_rank(Gid) -> List
%% Gid = gid()
%% List = [{binary(), integer(), integer(), integer(), integer(), integer()} |...]
%% @doc 获取上场帮战排行榜, 用于帮会面板的 帮战成绩标签页
get_guild_arena_member_info_rank({Gid, Gsrvid}) ->
    LastWarInfo = get_guild_arena_member_info({Gid, Gsrvid}),
    List = [{Name, Lev, Fc, Kill, Total} || #guild_arena_role{name = Name, lev = Lev, fc = Fc, sum_kill = Kill, sum_score = Total} <- LastWarInfo],
    lists:reverse(lists:keysort(5, List)).

%% 获取帮会上场战斗成员积分列表
get_guild_war_member_info({Gid, Gsrvid}) ->
    try guild_war_mgr:last_war_info(guild_member_war_info, 0, {Gid, Gsrvid}) of
        false -> [];
        {false, _Reason} -> [];
        Reply -> Reply
    catch
        Error:Info ->
            ?ERR("向帮战管理进程请求上场帮站成员积分情况时发生错误[~w:~w]", [Error, Info]),
            []
    end.

%% 获取上场帮战成员积分列表
get_guild_arena_member_info({Gid, Gsrvid}) ->
    try guild_arena:get_info({guild_member, {Gid, Gsrvid}}) of
        {specify_guild_member_score, Reply} -> Reply;
        _ -> []
    catch
        Error:Info ->
            ?ERR("向帮战进程请求上场帮站成员积分情况时发生错误[~w:~w]", [Error, Info]),
            []
    end.

%% @spec get_guild_war_info(Gid) -> {integer(), integer(), integer()}
%% Gid = gid()
%% @doc 获取帮会的上场帮会战绩
get_guild_war_info({Gid, Gsrvid}) ->
    try guild_war_mgr:last_war_info(guild_war_info, 0, {Gid, Gsrvid}) of
        false -> 
            {0,0,0};
        {false, _Reason} -> {0,0,0};
        #guild_war_guild{credit_compete = CreditCompete, credit_sword = CreditSword, credit = Credit} ->
            {CreditCompete, CreditSword, Credit}
    catch
        Error:Info ->
            ?ERR("向帮战管理进程请求上场帮站情况时发生错误[~w:~w]", [Error, Info]),
            {0,0,0}
    end.

%% @spec get_guild_arena_info(Gid) -> {integer(), integer(), integer(), integer()}
%% Gid = gid()
%% @doc 获取帮战上场帮会战绩
get_guild_arena_info({Gid, Gsrvid}) ->
    try guild_arena:get_info({guild, {Gid, Gsrvid}}) of
        {specify_guild, #arena_guild{round_score = {First, Second, Third}, sum_score = Total}} -> {First, Second, Third, Total};
        _ -> {0, 0, 0, 0}
    catch
        Error:Info ->
            ?ERR("向帮战管理进程请求上场帮站情况时发生错误[~w:~w]", [Error, Info]),
            {0, 0, 0, 0}
    end.

%% @spec add({Gid, Gsrvid}, Items) -> ok
%% Gid = integer()
%% Gsrvid = bianry()
%% Type = 1 | 2 
%% Items = [{Baseid, Bind, Quantity} | ...]
%% Baseid = Bind = Quantity = integer()
%% @doc 向帮会宝库增加物品, Type 为 1 时是圣战宝物，Type 为 2 时是帮战宝物
add({Gid, Gsrvid}, Type, Items) ->
    case lists:all(fun({BaseID, Bind, Quantity}) -> 
                    is_integer(BaseID) andalso (Bind =:= 0 orelse Bind =:= 1) andalso is_integer(Quantity) andalso Quantity > 0 
            end, Items) of
        true ->
            guild:apply(async, {Gid, Gsrvid}, {?MODULE, add_async, [Type, Items]});
        false ->
            ?ERR("向帮会宝库添加物品时出入错误的物品数据, [~w]", [Items]),
            ok
    end.

%% @spec add_async(Guild, Items) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% @doc 异步向帮会宝库添加物品
add_async(Guild = #guild{id = {Gid, Gsrvid}, name = Gname, treasure = {WarTreasure, AreanTreasure, BossTreasure}}, ?guild_treasure_war, Items) ->
    spawn(guild_log, log, [Gid, Gsrvid, Gname, 0, <<>>, <<"system">>, <<"添加圣战宝物">>, util:fbin(<<"~w">>, [Items])]),
    {ok, Guild#guild{treasure = {add_treasure(WarTreasure, Items), AreanTreasure, BossTreasure}}};
add_async(Guild = #guild{id = {Gid, Gsrvid}, name = Gname, treasure = {WarTreasure, AreanTreasure, BossTreasure}}, ?guild_treasure_arean, Items) ->
    spawn(guild_log, log, [Gid, Gsrvid, Gname, 0, <<>>, <<"system">>, <<"添加帮战宝物">>, util:fbin(<<"~w">>, [Items])]),
    {ok, Guild#guild{treasure = {WarTreasure, add_treasure(AreanTreasure, Items), BossTreasure}}};
add_async(Guild = #guild{id = {Gid, Gsrvid}, name = Gname, treasure = {WarTreasure, AreanTreasure, BossTreasure}}, ?guild_treasure_guild_boss, Items) ->
    spawn(guild_log, log, [Gid, Gsrvid, Gname, 0, <<>>, <<"system">>, <<"添加神兽宝物">>, util:fbin(<<"~w">>, [Items])]),
    {ok, Guild#guild{treasure = {WarTreasure, AreanTreasure, add_treasure(BossTreasure, Items)}}};
add_async(_Guild, Type, Items) ->
    ?ERR("向帮会宝库添加错误的宝库类型 [~w] 物品 [~w]", [Type, Items]),
    {ok}.

%% 转换并增加宝库数据
add_treasure({NextID, Treasure, Log}, Items) ->
    {NewNextID, NewTreasure} = add_treasure(NextID, Treasure, Items),
    {NewNextID, NewTreasure, Log}.

add_treasure(NextID, Treasures, []) ->
    {NextID, lists:keysort(1, Treasures)};
add_treasure(NextID, Treasures, [{BaseID, Bind, Quantity} | Items]) ->
    case lists:keyfind({BaseID, Bind}, 3, Treasures) of
        false ->
            Value = guild_treasure_data:get(BaseID),
            add_treasure(NextID + 1, [{NextID, Value, {BaseID, Bind}, Quantity} | Treasures], Items);
        {ID, Value, _, Quantity1} ->
            add_treasure(NextID, lists:keyreplace({BaseID, Bind}, 3, Treasures, {ID, Value, {BaseID, Bind}, Quantity + Quantity1}), Items)
    end;
add_treasure(NextID, Treasures, [Item | Items]) ->
    ?ERR("传入非法的宝库数据: ~w", [Item]),
    add_treasure(NextID, Treasures, Items).

%% @spec allocate(Role, Tid, Tsrvid, ID, Quantity) -> ok | {false, Reason}
%% Role = #role{}
%% Tid = ID = Quantity = integer()
%% Tsrvid = Reason = binary()
%% @doc 帮主分配宝库物品
allocate(_Role, _Tid, _Tsrvid, _ID, Quantity, _Type) when Quantity > 5 ->
    {false, ?L(<<"每次分配不能超过 5 件">>)};
allocate(#role{id = {Cid, Csrvid}, link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid, position = ?guild_chief}}, Tid, Tsrvid, ID, Quantity, Type) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, allocate_async, [{Cid, Csrvid, ConnPid}, {Tid, Tsrvid}, {ID, Quantity, Type}]});
allocate(_Role, _Rid, _Rsrvid, _ID, _Quantity, _Type) ->
    {false, ?L(<<"您不是帮主，不能分配宝库物品">>)}.

%% @spec allocate(Role) -> ok | {false, Reason}
%% Role  = #role{}
%% Reason = binary()
%% @doc 帮主需要自动分配宝库物品
allocate(#role{id = {Rid, Rsrvid}, link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid, position = ?guild_chief}}, Type) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, allocate_async, [{Rid, Rsrvid, ConnPid, Type}]});
allocate(_Role, _Type) ->
    {false, ?L(<<"您不是帮主，不能分配宝库物品">>)}.

%% @spec allocate_async(Guild, Gainer) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% Gainer = {integer(), binary(), pid()}
%% @doc 自动分配宝库物品
allocate_async(Guild, {Rid, Rsrvid, ConnPid, Type}) ->
    case allocate_auth_check(Rid, Rsrvid, Guild) of
        ok ->
            case allocate_treasure(Guild, Type) of
                {false, Reason} ->
                    sys_conn:pack_send(ConnPid, 12772, {?false, Reason}),
                    {ok};
                {ok, NewGuild} ->
                    sys_conn:pack_send(ConnPid, 12773, {?true, ?L(<<"宝库物品自动分配完成">>)}),
                    sys_conn:pack_send(ConnPid, 12776, {Type}),
                    {ok, NewGuild}
            end;
        {false, Reason} ->
            sys_conn:pack_send(ConnPid, 12772, {?false, Reason}),
            {ok}
    end.

%% @spec allocate_async(Guild, ChiefInfo, GainerInfo, ItemInfo) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% ChiefInfo = {integer(), binary(), pid()}
%% GainerInfo = {integer(), binary()}
%% ItemInfo = {integer(), integer()}
%% @doc 异步调用分配宝库物品
allocate_async(Guild, {Cid, Csrvid, ConnPid}, {Tid, Tsrvid}, {ID, Quantity, Type}) ->
    case allocate_auth_check(Cid, Csrvid, Guild) of
        ok ->
            case allocate_object_check(Tid, Tsrvid, Guild) of
                ok ->
                    case allocate_treasure(Guild, {Tid, Tsrvid}, {ID, Quantity, Type}) of
                        {false, Reason} ->
                            sys_conn:pack_send(ConnPid, 12772, {?false, Reason}),
                            {ok};
                        {ok, Rem, NewGuild} ->
                            sys_conn:pack_send(ConnPid, 12772, {?true, ?L(<<"分配成功">>)}),
                            sys_conn:pack_send(ConnPid, 12775, {Type, ID, Rem}),
                            {ok, NewGuild}
                    end;
                {false, Reason} ->
                    sys_conn:pack_send(ConnPid, 12772, {?false, Reason}),
                    {ok}
            end;
        {false, Reason} ->
            sys_conn:pack_send(ConnPid, 12772, {?false, Reason}),
            {ok}
    end.

allocate_auth_check(Cid, Csrvid, Guild = #guild{members = Mems}) ->
    case lists:keyfind({Cid, Csrvid}, #guild_member.id, Mems) of
        false ->
            {false, util:fbin(?L(<<"您不是 ~s 帮成员，无权分配该帮会宝库物品">>), [Guild#guild.name])};
        #guild_member{position = ?guild_chief} ->
            ok;
        _ ->
            {false, ?L(<<"您不是帮主，不能分配宝库物品">>)}
    end.

allocate_object_check(Rid, Rsrvid, Guild = #guild{members = Mems}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Mems) of
        false ->
            {false, util:fbin(?L(<<"请求分配给的玩家不是 ~s 帮成员">>), [Guild#guild.name])};
        _ ->
            ok
    end.

allocate_treasure(Guild = #guild{id = {Gid, Gsrvid}, chief = Chief, treasure = {{NextID, Treasures, Logs}, AreaTreasure, BossTreasure}}, {Tid, Tsrvid}, {ID, Quantity, ?guild_treasure_war}) ->
    LastWarRoles = get_guild_war_member_info({Gid, Gsrvid}),
    case lists:keyfind({Tid, Tsrvid}, #guild_war_role.id, LastWarRoles) of
        false ->
            {false, ?L(<<"分配失败，不可分配给没有参加上场圣地之战的成员!">>)};
        #guild_war_role{credit = Credit, name = Rname} when Credit > 0 ->
            case lists:keyfind(ID, 1, Treasures) of
                false ->
                    {false, ?L(<<"该物品已经配完了">>)};
                {ID, Value, {BaseID, Bind}, QuantityRem} when QuantityRem >= Quantity andalso Quantity > 0 ->
                    Rem = QuantityRem - Quantity,
                    NewTreasures = case Rem =:= 0 of
                        true -> lists:keydelete({BaseID, Bind}, 3, Treasures);
                        false -> lists:keyreplace({BaseID, Bind}, 3, Treasures, {ID, Value, {BaseID, Bind}, Rem})
                    end,
                    {Sub, Text} = get_allocate_email_context(?guild_treasure_war),
                    spawn(mail, send_system, [{Tid, Tsrvid}, {Sub, Text, [], {BaseID, Bind, Quantity}}]),
                    Log = allocate_log(BaseID, Quantity, Credit, Rname, 0, Chief),
                    inform_allocate_result([Log], Guild, ?guild_treasure_war),
                    {ok, Rem, Guild#guild{treasure = {{NextID, NewTreasures, [Log] ++ Logs}, AreaTreasure, BossTreasure}}};
                _ ->
                    {false, ?L(<<"物品数量不足，分配失败">>)}
            end;
        _ ->
            {false, ?L(<<"不可分配给上场圣地之战积分为0的成员">>)}
    end;

allocate_treasure(Guild = #guild{id = {Gid, Gsrvid}, chief = Chief, treasure = {WarTreasure, {NextID, Treasures, Logs}, BossTreasure}}, {Tid, Tsrvid}, {ID, Quantity, ?guild_treasure_arean}) ->
    LastWarRoles = get_guild_arena_member_info({Gid, Gsrvid}),
    ?DEBUG("allocate_treasure ~w", [LastWarRoles]),
    case lists:keyfind({Tid, Tsrvid}, #guild_arena_role.id, LastWarRoles) of
        false ->
            {false, ?L(<<"分配失败，不可分配给没有参加上场帮战的成员!">>)};
        #guild_arena_role{sum_score = Credit, name = Rname} when Credit > 0 ->
            case lists:keyfind(ID, 1, Treasures) of
                false ->
                    {false, ?L(<<"该物品已经配完了">>)};
                {ID, Value, {BaseID, Bind}, QuantityRem} when QuantityRem >= Quantity andalso Quantity > 0 ->
                    Rem = QuantityRem - Quantity,
                    NewTreasures = case Rem =:= 0 of
                        true -> lists:keydelete({BaseID, Bind}, 3, Treasures);
                        false -> lists:keyreplace({BaseID, Bind}, 3, Treasures, {ID, Value, {BaseID, Bind}, Rem})
                    end,
                    {Sub, Text} = get_allocate_email_context(?guild_treasure_arean),
                    spawn(mail, send_system, [{Tid, Tsrvid}, {Sub, Text, [], {BaseID, Bind, Quantity}}]),
                    Log = allocate_log(BaseID, Quantity, Credit, Rname, 0, Chief),
                    inform_allocate_result([Log], Guild, ?guild_treasure_arean),
                    {ok, Rem, Guild#guild{treasure = {WarTreasure, {NextID, NewTreasures, [Log] ++ Logs}, BossTreasure}}};
                _ ->
                    {false, ?L(<<"物品数量不足，分配失败">>)}
            end;
        _ ->
            {false, ?L(<<"不可分配给上场帮战积分为0的成员">>)}
    end;
allocate_treasure(Guild = #guild{id = {Gid, Gsrvid}, chief = Chief, treasure = {WarTreasure, AreanTreasure, {NextID, Treasures, Logs}}}, {Tid, Tsrvid}, {ID, Quantity, ?guild_treasure_guild_boss}) ->
    KillLog = guild_boss:get_info({kill_log, {Gid, Gsrvid}}),
    ?DEBUG("allocate_treasure ~w", [KillLog]),
    case lists:keyfind({Tid, Tsrvid}, #guild_boss_role.id, KillLog) of
        false ->
            {false, ?L(<<"分配失败，不可分配给没有参加击杀神兽的成员!">>)};
        #guild_boss_role{total_dmg = RDmg, name = Rname} when RDmg > 0 ->
            case lists:keyfind(ID, 1, Treasures) of
                false ->
                    {false, ?L(<<"该物品已经配完了">>)};
                {ID, Value, {BaseID, Bind}, QuantityRem} when QuantityRem >= Quantity andalso Quantity > 0 ->
                    Rem = QuantityRem - Quantity,
                    NewTreasures = case Rem =:= 0 of
                        true -> lists:keydelete({BaseID, Bind}, 3, Treasures);
                        false -> lists:keyreplace({BaseID, Bind}, 3, Treasures, {ID, Value, {BaseID, Bind}, Rem})
                    end,
                    {Sub, Text} = get_allocate_email_context(?guild_treasure_guild_boss),
                    spawn(mail, send_system, [{Tid, Tsrvid}, {Sub, Text, [], {BaseID, Bind, Quantity}}]),
                    Log = allocate_log(BaseID, Quantity, RDmg, Rname, 0, Chief),
                    inform_allocate_result([Log], Guild, ?guild_treasure_guild_boss),
                    {ok, Rem, Guild#guild{treasure = {WarTreasure, AreanTreasure, {NextID, NewTreasures, [Log] ++ Logs}}}};
                _ ->
                    {false, ?L(<<"物品数量不足，分配失败">>)}
            end;
        _ ->
            {false, ?L(<<"不可分配给没有击杀过神兽的成员">>)}
    end;
allocate_treasure(_Guild, _Tid, _ItemInfo) ->
    {false, ?L(<<"错误的宝库类型">>)}.

allocate_treasure(Guild = #guild{id = {Gid, Gsrvid}, members = Mems, treasure = {{_NextID, Treasures, Logs}, AreaTreasure, BossTreasure}}, ?guild_treasure_war) ->
    WarPart = get_guild_war_score({Gid, Gsrvid}),
    Winners = [{Id, Srvid, Score, Name} || {Id, Srvid, Name, _Lev, Score} <- WarPart, lists:keymember({Id, Srvid}, #guild_member.id, Mems), Score > 0],
    case Winners =/= [] of
        true ->
            NewLogs = allocate_auto(?guild_treasure_war, lists:reverse(lists:keysort(2, Treasures)), lists:reverse(lists:keysort(3, Winners))),
            inform_allocate_result(NewLogs, Guild, ?guild_treasure_war),
            {ok, Guild#guild{treasure = {{1, [], NewLogs ++ Logs}, AreaTreasure, BossTreasure}}};
        false ->
            {false, ?L(<<"分配失败，上场圣地之战没有参加且获得积分成员">>)}
    end;

allocate_treasure(Guild = #guild{id = {Gid, Gsrvid}, members = Mems, treasure = {WarTreasure, {_NextID, Treasures, Logs}, BossTreasure}}, ?guild_treasure_arean) ->
    WarPart = get_guild_arean_score({Gid, Gsrvid}),
    Winners = [{Id, Srvid, Score, Name} || {Id, Srvid, Name, _Lev, Score} <- WarPart, lists:keymember({Id, Srvid}, #guild_member.id, Mems), Score > 0],
    case Winners =/= [] of
        true ->
            NewLogs = allocate_auto(?guild_treasure_arean, lists:reverse(lists:keysort(2, Treasures)), lists:reverse(lists:keysort(3, Winners))),
            inform_allocate_result(NewLogs, Guild, ?guild_treasure_arean),
            {ok, Guild#guild{treasure = {WarTreasure, {1, [], NewLogs ++ Logs}, BossTreasure}}};
        false ->
            {false, ?L(<<"分配失败，上场帮战没有参加且获得积分成员">>)}
    end;

allocate_treasure(Guild = #guild{id = {Gid, Gsrvid}, members = Mems, treasure = {WarTreasure, AreanTreasure, {_NextID, Treasures, Logs}}}, ?guild_treasure_guild_boss) ->
    WarPart = get_guild_boss_score({Gid, Gsrvid}),
    Winners = [{Id, Srvid, Score, Name} || {Id, Srvid, Name, _Lev, Score} <- WarPart, lists:keymember({Id, Srvid}, #guild_member.id, Mems), Score > 0],
    case Winners =/= [] of
        true ->
            NewLogs = allocate_auto(?guild_treasure_guild_boss, lists:reverse(lists:keysort(2, Treasures)), lists:reverse(lists:keysort(3, Winners))),
            inform_allocate_result(NewLogs, Guild, ?guild_treasure_guild_boss),
            {ok, Guild#guild{treasure = {WarTreasure, AreanTreasure, {1, [], NewLogs ++ Logs}}}};
        false ->
            {false, ?L(<<"分配失败，没有击杀神兽的成员记录">>)}
    end;

allocate_treasure(_Guild, _Type) ->
    {false, ?L(<<"错误的宝库类型">>)}.

%% 自动分配宝库物品
allocate_auto(Type, Treasures, Winners) ->
    allocate_auto(Type, Treasures, Winners, []).

allocate_auto(_Type, [], _Winners, Logs) ->
    lists:reverse(Logs);
allocate_auto(Type, [Treasure | Treasures], Winners, Logs) ->
    {NewWinners, NewLogs} = allocate_single_auto(Type, Treasure, Winners, Logs),
    allocate_auto(Type, Treasures, NewWinners, NewLogs).

%% 单件宝库物品分配
allocate_single_auto(_Type, {_ID, _Values, {_BaseID, _Bind}, Quantity}, Winners, Logs) when Quantity =< 0 ->
    {Winners, Logs};
allocate_single_auto(Type, {_ID, _Values, {BaseID, Bind}, Quantity}, [H = {Rid, Rsrvid, Credit, Rname} | T], Logs) when Quantity > 0 ->
    {Sub, Text} = get_allocate_email_context(Type),
    spawn(mail, send_system, [{Rid, Rsrvid}, {Sub, Text, [], {BaseID, Bind, 1}}]),
    Log = allocate_log(BaseID, 1, Credit, Rname, 1, <<>>),
    allocate_single_auto(Type, {_ID, _Values, {BaseID, Bind}, Quantity - 1}, T ++ [H], [Log | Logs]).

%% 宝库物品分配物品信息
allocate_log(BaseID, Quantity, Credit, Rname, Type, Chief) ->
    ItemName = case item_data:get(BaseID) of
        {ok, #item_base{name = Iname}} -> Iname;
        _ -> <<>>
    end,
    case Type of
        0 -> {Rname, util:fbin(<<"~s~w">>, [ItemName, Quantity]), Credit, util:fbin(?L(<<"帮主:~s">>), [Chief]), util:unixtime()};
        _ -> {Rname, util:fbin(<<"~s~w">>, [ItemName, Quantity]), Credit, ?L(<<"自动分配">>), util:unixtime()}
    end.

inform_allocate_result([], _Guild, _Type) ->
    ok;
inform_allocate_result([{Rname, ItemName, Credit, Mode, _Time} | Logs], Guild = #guild{id = {Gid, Gsrvid}, name = Gname, members = Mems}, TreasureType) ->
    case Mode =:= ?L(<<"自动分配">>) of
        true ->
            spawn(guild_log, log, [Gid, Gsrvid, Gname, 0, <<>>, <<"system">>, <<"宝库分配">>, util:fbin(<<"自动分配给 ~s ~s">>, [ItemName, Rname])]),
            guild:guild_chat(Mems, util:fbin(get_allocate_inform_msg(auto, TreasureType), [ItemName, Credit, Rname])),
            inform_allocate_result(Logs, Guild, TreasureType);
        _ ->
            spawn(guild_log, log, [Gid, Gsrvid, Gname, 0, <<>>, <<"system">>, <<"宝库分配">>, util:fbin(<<"~s 分配给 ~s ~s">>, [Mode, ItemName, Rname])]),
            guild:guild_chat(Mems, util:fbin(get_allocate_inform_msg(chief, TreasureType), [ItemName, Credit, Rname])),
            inform_allocate_result(Logs, Guild, TreasureType)
    end.

%% 获取对应的邮件内容
get_allocate_email_context(?guild_treasure_war) -> {?L(<<"圣地之争奖励分配">>), ?L(<<"上场圣地之争，经过大家齐心协力，取得了优异成绩，鉴于您表现优秀，帮主把帮会宝库里的该物品奖励给您。">>)};
get_allocate_email_context(?guild_treasure_arean) -> {?L(<<"帮战奖励分配">>), ?L(<<"上场帮战，经过大家齐心协力，取得了优异成绩，鉴于您表现优秀，帮主把帮会宝库里的该物品奖励给您。">>)};
get_allocate_email_context(?guild_treasure_guild_boss) -> {?L(<<"击杀神兽奖励分配">>), ?L(<<"经过大家齐心协力，终于成功把帮会神兽击杀，鉴于您表现优秀，帮主把帮会宝库里的该物品奖励给您。">>)}.
get_allocate_inform_msg(auto, ?guild_treasure_arean) -> ?L(<<"帮主采用自动分配，按照积分高低，\n系统分配了宝库物品 {str,~s,FFFF66} 给在上场帮战中获得 {str,~w,FFFF66} 积分的 {str,~s,FFFF66}">>);
get_allocate_inform_msg(chief, ?guild_treasure_arean) -> ?L(<<"帮主分配了宝库物品 {str,~s,FFFF66} 给在上场帮战中获得 {str,~w,FFFF66} 积分的 {str,~s,FFFF66}">>);
get_allocate_inform_msg(auto, ?guild_treasure_guild_boss) -> ?L(<<"帮主采用自动分配，按照对神兽伤害高低，\n系统分配了宝库物品 {str,~s,FFFF66} 给对神兽造成 {str,~w,FFFF66} 伤害的 {str,~s,FFFF66}">>);
get_allocate_inform_msg(chief, ?guild_treasure_guild_boss) -> ?L(<<"帮主分配了宝库物品 {str,~s,FFFF66} 给对神兽造成 {str,~w,FFFF66} 伤害的 {str,~s,FFFF66}">>);

get_allocate_inform_msg(auto, ?guild_treasure_war) -> ?L(<<"帮主采用自动分配，按照积分高低，\n系统分配了宝库物品 {str,~s,FFFF66} 给在上场圣地之争中获得 {str,~w,FFFF66} 积分的 {str,~s,FFFF66}">>);
get_allocate_inform_msg(chief, ?guild_treasure_war) -> ?L(<<"帮主分配了宝库物品 {str,~s,FFFF66} 给在上场圣地之争中获得 {str,~w,FFFF66} 积分的 {str,~s,FFFF66}">>).
