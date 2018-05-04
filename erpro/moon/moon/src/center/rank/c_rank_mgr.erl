%%----------------------------------------------------
%% 跨服排行榜管理器
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(c_rank_mgr).

-behaviour(gen_server).

-export([
        start_link/0,
        commit_rank_data/2,
        cast/1,
        cross_flower/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("rank.hrl").

-record(state, {
        cur_sn = 0      %% 当前采集任务序号
        ,group_id = 1   %% 采集组号
    }
).

-define(UPDATE_TIME, 60000 * 7).    %% 更新排行榜数据间隔
-define(UPDATE_TIMEOUT, 60000). %% 更新排行榜数据超时时间
-define(RECAST_CROSS_FLOWER, 120000). %% 更新排行榜数据超时时间

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 远端服务器提交排行榜数据
commit_rank_data(Sn, CompressedData) ->
    gen_server:cast(?MODULE, {commit_rank_data, Sn, CompressedData}).

%% 对外接口
cast(Args) ->
    gen_server:cast(?MODULE, Args).

%% 统计鲜花榜
cross_flower() ->
    ?MODULE ! update_flower.

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    State = #state{cur_sn = gen_collect_sn()},
    ets:new(c_rank_role_info, [set, named_table, public, {keypos, #rank_cross_role.id}]),
    dets:open_file(c_rank_role_info, [{file, "../var/c_rank_role_info.dets"}, {keypos, #rank_cross_role.id}, {type, set}]),
    load_data(),
    erlang:send_after(60000 * 2, self(), update),
    %% erlang:send_after(util:unixtime({nexttime, 71400}) * 1000, self(), update_flower),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call({get_flower_award, Data}, _From, State) ->
    AwardFlowerData = get(cross_flower_award),
    NewAwardFlowerData = AwardFlowerData -- Data,
    ?DEBUG("送花奖励总共:~w 发放:~w,剩余:~w",[length(AwardFlowerData), length(Data), length(NewAwardFlowerData)]),
    put(cross_flower_award, NewAwardFlowerData),
    {reply, ok, State};
handle_call({get_glamor_award, Data}, _From, State) ->
    AwardGlamorData = get(cross_glamor_award),
    NewAwardGlamorData = AwardGlamorData -- Data,
    ?DEBUG("魅力奖励总共:~w 发放:~w,剩余:~w",[length(AwardGlamorData), length(Data), length(NewAwardGlamorData)]),
    put(cross_glamor_award, NewAwardGlamorData),
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({commit_rank_data, Sn, CompressedData}, State = #state{cur_sn = CurSn}) when Sn =:= CurSn ->
    case catch binary_to_term(CompressedData) of
        [CrossType, LocalType, Data] ->
            ?DEBUG("收集到跨服排行榜数据:Sn=~w, Type=~w, Data_length=~p", [Sn, CrossType, length(Data)]),
            merge_rank_data(CrossType, LocalType, Data);
        _ ->
            ?ERR("收集到远端服务器提交的排行榜数据无法正常解压")
    end,
    {noreply, State};
handle_cast({commit_rank_data, Sn, _CompressedData}, State = #state{cur_sn = CurSn}) ->
    ?ERR("收到远端服务器提交的排行榜数据[sn=~w]，但是已经超时了[当前sn=~w]", [Sn, CurSn]),
    {noreply, State};

%% 更新排行榜 GM
handle_cast(gm_update_rank, State = #state{cur_sn = Sn}) ->
    RankList = update_rank_group_list(gm),
    [collect_rank_data(Type, Sn) || Type <- RankList],
    erlang:send_after(10 * 1000, self(), gm_update_rank),
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

%%  更新送花排行榜
handle_info(update_flower, State) ->
    %% 清空上次奖励缓存列表
    put(cross_flower_award, []),
    put(cross_glamor_award, []),
    case get(cross_flower_rank) of
        undefined ->
            ?INFO("暂无排行榜数据, 稍后再进行奖励统计"),
            Ref = erlang:send_after(240000, self(), update_flower),
            reset_send_after(cross_update_flower, Ref),
            {noreply, State};
        FlowerData ->
            GlamorData = case get(cross_glamor_rank) of
                undefined -> [];
                Data -> Data
            end,
            ?INFO("跨服送花排行榜奖励统计"),
            DoFlowerData = lists:sublist(FlowerData, 10),
            DoGlamorData = lists:sublist(GlamorData, 10),
            AwardFlowerData = do_sort_flower(DoFlowerData),
            AwardGlamorData = do_sort_flower(DoGlamorData), 
            put(cross_flower_award, AwardFlowerData),
            put(cross_glamor_award, AwardGlamorData),
            self() ! {cast_cross_flower_award, 1, AwardFlowerData, AwardGlamorData},
            Ref = erlang:send_after(util:unixtime({nexttime, 71400}) * 1000, self(), update_flower),
            reset_send_after(cross_update_flower, Ref),
            {noreply, State}
    end;

%% 重试发送奖励
handle_info(cast_cross_flower_award, State) ->
    AwardFlowerData = case get(cross_flower_award) of
        FlowerData when is_list(FlowerData) -> FlowerData;
        _ -> []
    end,
    AwardGlamorData = case get(cross_glamor_award) of
        GlamorData when is_list(GlamorData) -> GlamorData;
        _ -> []
    end,
    self() ! {cast_cross_flower_award, 0, AwardFlowerData, AwardGlamorData},
    {noreply, State};

%% 发放奖励
handle_info({cast_cross_flower_award, 0, [], []}, State) ->
    ?INFO("跨服送花榜无奖励发放或者已经发放完毕"),
    {noreply, State};
handle_info({cast_cross_flower_award, Type, AwardFlowerData, AwardGlamorData}, State) ->
    ?INFO("跨服送花榜进行奖励发放"),
    Msg = {cross_flower, Type, AwardFlowerData, AwardGlamorData},
    c_mirror_group:cast(all, rank_mgr, async, [Msg]),
    erlang:send_after(?RECAST_CROSS_FLOWER, self(), cast_cross_flower_award), 
    {noreply, State};

handle_info(update, State = #state{cur_sn = Sn, group_id = GroupId}) ->
    case is_collect_time() of
        true ->
            ?INFO("开始收集跨服排行榜数据[~p]", [GroupId]),
            RankList = update_rank_group_list(GroupId),
            [collect_rank_data(Type, Sn) || Type <- RankList];
        false ->
            ?INFO("当前活动时间，不进行排行榜数据采集")
    end,
    erlang:send_after(?UPDATE_TIMEOUT, self(), check_update_timeout),
    {noreply, State};

handle_info(check_update_timeout, State = #state{group_id = GroupId}) ->
    TypeList = update_rank_group_list(GroupId),
    ?DEBUG("收集跨服排行榜数据时间到"),
    erlang:statistics(wall_clock),
    [sort_rank_data(Type) || Type <- TypeList],
    {_, _Time1} = erlang:statistics(wall_clock),
    ?DEBUG("排序时间:~w ms", [_Time1]),
    [cast_rank_data(Type) || Type <- TypeList],
    {_, _Time2} = erlang:statistics(wall_clock),
    ?DEBUG("广播时间:~w ms", [_Time2]),
    NextSn = gen_collect_sn(),
    NextGroupId = case update_rank_group_list(GroupId + 1) of
        false -> 1;  %% 从头开始处理
        _ -> GroupId + 1
    end,
    erlang:send_after(?UPDATE_TIME, self(), update),
    {noreply, State#state{cur_sn = NextSn, group_id = NextGroupId}};

%% GM更新榜
handle_info(gm_update_rank, State) ->
    TypeList = update_rank_group_list(gm),
    [sort_rank_data(Type) || Type <- TypeList],
    [cast_rank_data(Type) || Type <- TypeList],
    {noreply, State};

handle_info(Info, State) ->
    ?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------
%% 定时执行获取排行榜数据的任务
%%----------------------------------------

load_data() ->
    case dets:first(c_rank_role_info) of
        '$end_of_table' -> ?INFO("没有排行榜角色信息数据");
        _ ->
            dets:traverse(c_rank_role_info,
                fun(R) when is_record(R, rank_cross_role) ->
                        ets:insert(c_rank_role_info, R),
                        continue;
                    (_R) ->
                        continue
                end
            ),
            ?INFO("排行榜角色信息数据加载完毕")
    end.

%% 重置定时器
reset_send_after(Key, NewRef) ->
    case get(Key) of
        undefined -> ok;
        Ref -> catch erlang:cancel_timer(Ref)
    end,
    put(Key, NewRef).

do_sort_flower(Data) ->
    do_sort_flower(Data, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], []).
do_sort_flower([], _, Data) -> Data;
do_sort_flower([#rank_cross_flower{rid = Rid, srv_id = SrvId, name = Name} | T], [Rank | T1], Data) ->
    do_sort_flower(T, T1, [{Rid, SrvId, Name, Rank} | Data]);
do_sort_flower([#rank_cross_glamor{rid = Rid, srv_id = SrvId, name = Name} | T], [Rank | T1], Data) ->
    do_sort_flower(T, T1, [{Rid, SrvId, Name, Rank} | Data]).

%% 广播收集任务请求
collect_rank_data(CrossType, Sn) ->
    LocalType = collect_type_mapping(CrossType),
    Msg = {collect_rank_data, Sn, CrossType, LocalType},
    c_mirror_group:cast(all, rank_mgr, async, [Msg]).

%% 广播收集任务的结果
cast_rank_data(Type) ->
    Mod = rank_type_model(Type),
    cast_rank_data(Type, Mod).
cast_rank_data(Type, all) -> %% 不分平台处理方式
    case get({rank, Type}) of
        Data when is_list(Data) andalso length(Data) > 0 ->
            Data1 = lists:sublist(Data, max_rank_num(Type)),
            CompressedData = term_to_binary([Type, Data1], [compressed]),
            Msg = {update_cross_rank_data, CompressedData},
            c_mirror_group:cast(all, rank_mgr, async, [Msg]),
            %% case Type of
            %%    ?rank_cross_glamor -> put(cross_glamor_rank, Data1);
            %%    ?rank_cross_flower -> put(cross_flower_rank, Data1);
            %%    _ -> ok
            %% end,
            erase({rank, Type}),
            put({rank, Type}, []);
        _ ->
            ok
    end;
cast_rank_data(Type, platform) -> %% 分平台处理方式
    ?DEBUG("Type:~w",[Type]),
    Data = get({rank, Type}),
    %% 按平台分组
    ?DEBUG("排行榜数据按平台分组"),
    Data1 = classify_rank_by_platform(Data),
    %% ?DEBUG("按平台分好后的数据:~w", [Data1]),
    %% [{PlatformName, [#rank_cross_total_power{}]}]
    ?DEBUG("广播排行榜开始"),
    lists:foreach(fun({PlatformName, Ranks}) ->
            Ranks1 = lists:reverse(Ranks),
            Result = lists:sublist(Ranks1, max_rank_num(Type)),
            case length(Result) > 0 of
                true ->
                    CompressedData = term_to_binary([Type, Result], [compressed]),
                    Msg = {update_cross_rank_data, CompressedData},
                    c_mirror_group:cast(platform, [PlatformName], rank_mgr, async, [Msg]);
                false -> ignore
            end
        end, Data1),
    ?DEBUG("广播排行榜结束"),
    erase({rank, Type}),
    put({rank, Type}, []).

%% 生成采集任务序列号
gen_collect_sn() ->
    util:unixtime().

%% 合成排行榜数据
merge_rank_data(CrossType, _LocalType, Data) when is_list(Data) ->
    Data1 = lists:reverse(Data),
    NewData0 = [convert(CrossType, D) || D <- Data1],
    NewData = [D1 || D1 <- NewData0, D1 =/= false], %% 过滤转换失败的数据 
    case get({tmp_rank, CrossType}) of
        undefined -> put({tmp_rank, CrossType}, NewData);
        L -> put({tmp_rank, CrossType}, L ++ NewData)
    end;
merge_rank_data(_CrossType, _LocalType, _Data) -> ok.

%% 对排行榜数据进行排序
sort_rank_data(CrossType) ->
    case get({tmp_rank, CrossType}) of
        undefined -> put({rank, CrossType}, []);
        L ->
            Keys = get_sort_key(CrossType),
            SortL = keys_sort(Keys, L),
            Result = lists:reverse(SortL),
            put({rank, CrossType}, Result),
            erase({tmp_rank, CrossType}),
            put({tmp_rank, CrossType}, [])
    end.

%% 按多键排序 后面优先 即第二个键优先于第一个键
keys_sort(_, []) -> [];
keys_sort([],TupleList) ->
    TupleList;
keys_sort([H|T], TupleList) ->
    NewTupleList = lists:keysort(H, TupleList),
    keys_sort(T,NewTupleList).

%% 按平台来把排行榜数据分组（有些排行榜可能会有几个平台参与）-> [{PlatformName, [#rank_cross_total_power{}]}]
classify_rank_by_platform(Ranks) ->
    do_classify_rank_by_platform(Ranks, []).
do_classify_rank_by_platform([], Result) -> Result;
do_classify_rank_by_platform([Rank|T], Result) ->
    case get_srv_id(Rank) of
        <<>> ->
            ?ERR("错误的数据:~w", [Rank]),
            do_classify_rank_by_platform(T, Result);
        SrvId ->
            case c_mirror_group:get_platform(SrvId) of
                undefined ->
                    %% ?ERR("无法获取正确的平台名称:SrvId=~w", [SrvId]),
                    do_classify_rank_by_platform(T, Result);
                PlatformName ->
                    Result1 = case lists:keyfind(PlatformName, 1, Result) of
                        false ->
                            Result ++ [{PlatformName, [Rank]}];
                        {_, L} ->
                            L1 = [Rank|L],
                            lists:keyreplace(PlatformName, 1, Result, {PlatformName, L1})
                    end,
                    do_classify_rank_by_platform(T, Result1)
            end
    end.

%%----------------------------------------
%% 各类型配置数据
%%----------------------------------------

%% 获取当前批次排行榜信息
update_rank_group_list(gm) -> %% GM命令专用 方便测试
    update_rank_group_list(1) ++ update_rank_group_list(2) ++ update_rank_group_list(3) ++ update_rank_group_list(4);
update_rank_group_list(1) -> [
        ?rank_cross_total_power, ?rank_cross_role_pet_power, ?rank_cross_mount_power, ?rank_cross_flower, ?rank_cross_glamor
    ];
update_rank_group_list(2) -> [
        ?rank_cross_pet_lev, ?rank_cross_pet_power, ?rank_cross_pet_grow, ?rank_cross_pet_potential
        ,?rank_cross_world_compete_win
    ];
update_rank_group_list(3) -> [
        ?rank_cross_role_power, ?rank_cross_role_lev, ?rank_cross_role_coin, ?rank_cross_role_achieve
        ,?rank_cross_role_skill, ?rank_cross_role_soul
    ];
update_rank_group_list(4) -> [
        ?rank_cross_arena_kill, ?rank_cross_arms, ?rank_cross_armor
        ,?rank_cross_mount_power1, ?rank_cross_mount_lev
        ,?rank_cross_soul_world, ?rank_cross_soul_world_array, ?rank_cross_soul_world_spirit
    ];
update_rank_group_list(_GroupId) -> false.

%% 不同榜不同处理方式(分平台 不分平台)
rank_type_model(?rank_cross_total_power) -> platform;
rank_type_model(?rank_cross_role_pet_power) -> platform;
rank_type_model(?rank_cross_mount_power) -> platform;
rank_type_model(_Type) -> all.

%% 获取排行榜排序key
get_sort_key(?rank_cross_total_power) -> [#rank_cross_total_power.total_power];
get_sort_key(?rank_cross_role_pet_power) -> [#rank_cross_role_pet_power.petlev, #rank_cross_role_pet_power.power];
get_sort_key(?rank_cross_mount_power) -> [#rank_cross_mount_power.power];
get_sort_key(?rank_cross_mount_power1) -> [#rank_cross_mount_power.power];
get_sort_key(?rank_cross_mount_lev) -> [#rank_cross_mount_lev.mount_lev];
get_sort_key(?rank_cross_flower) -> [#rank_cross_flower.vip, #rank_cross_flower.lev, #rank_cross_flower.flower];
get_sort_key(?rank_cross_glamor) -> [#rank_cross_glamor.glamor];
get_sort_key(?rank_cross_pet_lev) -> [#rank_cross_pet_lev.growrate, #rank_cross_pet_lev.aptitude, #rank_cross_pet_lev.petlev];
get_sort_key(?rank_cross_pet_power) -> [#rank_cross_role_pet_power.petlev, #rank_cross_role_pet_power.power];
get_sort_key(?rank_cross_pet_grow) -> [#rank_cross_pet_grow.petlev, #rank_cross_pet_grow.grow];
get_sort_key(?rank_cross_pet_potential) -> [#rank_cross_pet_potential.petlev, #rank_cross_pet_potential.potential];
get_sort_key(?rank_cross_role_power) -> [#rank_cross_role_power.vip, #rank_cross_role_power.lev, #rank_cross_role_power.power];
get_sort_key(?rank_cross_role_lev) -> [#rank_cross_role_lev.lev];
get_sort_key(?rank_cross_role_coin) -> [#rank_cross_role_coin.vip, #rank_cross_role_coin.gold, #rank_cross_role_coin.coin];
get_sort_key(?rank_cross_role_achieve) -> [#rank_cross_role_achieve.vip, #rank_cross_role_achieve.lev, #rank_cross_role_achieve.achieve];
get_sort_key(?rank_cross_role_skill) -> [#rank_cross_role_skill.vip, #rank_cross_role_skill.lev, #rank_cross_role_skill.skill];
get_sort_key(?rank_cross_role_soul) -> [#rank_cross_role_soul.vip, #rank_cross_role_soul.lev, #rank_cross_role_soul.soul];
get_sort_key(?rank_cross_guild_lev) -> [#rank_cross_guild_lev.num, #rank_cross_guild_lev.fund, #rank_cross_guild_lev.lev];
get_sort_key(?rank_cross_arena_kill) -> [#rank_cross_vie_kill.vip, #rank_cross_vie_kill.lev, #rank_cross_vie_kill.kill];
get_sort_key(?rank_cross_world_compete_win) -> [#rank_cross_world_compete_win.win_count];
get_sort_key(?rank_cross_arms) -> [#rank_cross_equip_arms.vip, #rank_cross_equip_arms.lev, #rank_cross_equip_arms.score];
get_sort_key(?rank_cross_armor) -> [#rank_cross_equip_armor.vip, #rank_cross_equip_armor.lev, #rank_cross_equip_armor.score];
get_sort_key(?rank_cross_soul_world) -> [#rank_cross_soul_world.power];
get_sort_key(?rank_cross_soul_world_array) -> [#rank_cross_soul_world_array.lev];
get_sort_key(?rank_cross_soul_world_spirit) -> [#rank_cross_soul_world_spirit.power];
get_sort_key(_) -> [].

%% 采集任务跨服类型->原始类型的映射
collect_type_mapping(?rank_cross_total_power) -> ?rank_total_power;
collect_type_mapping(?rank_cross_role_pet_power) -> ?rank_role_pet_power;
collect_type_mapping(?rank_cross_mount_power) -> ?rank_mount_power;
collect_type_mapping(?rank_cross_mount_power1) -> ?rank_mount_power;
collect_type_mapping(?rank_cross_mount_lev) -> ?rank_mount_lev;
collect_type_mapping(?rank_cross_flower) -> ?rank_flower_day;
collect_type_mapping(?rank_cross_glamor) -> ?rank_glamor_day;
collect_type_mapping(?rank_cross_pet_lev) -> ?rank_role_pet;
collect_type_mapping(?rank_cross_pet_power) -> ?rank_role_pet_power;
collect_type_mapping(?rank_cross_pet_grow) -> ?rank_pet_grow;
collect_type_mapping(?rank_cross_pet_potential) -> ?rank_pet_potential;
collect_type_mapping(?rank_cross_role_lev) -> ?rank_role_lev;
collect_type_mapping(?rank_cross_role_power) -> ?rank_role_power;
collect_type_mapping(?rank_cross_role_coin) -> ?rank_role_coin;
collect_type_mapping(?rank_cross_role_achieve) -> ?rank_role_achieve;
collect_type_mapping(?rank_cross_role_skill) -> ?rank_role_skill;
collect_type_mapping(?rank_cross_role_soul) -> ?rank_role_soul;
collect_type_mapping(?rank_cross_guild_lev) -> ?rank_guild_lev;
collect_type_mapping(?rank_cross_arena_kill) -> ?rank_vie_kill;
collect_type_mapping(?rank_cross_world_compete_win) -> ?rank_world_compete_win;
collect_type_mapping(?rank_cross_arms) -> ?rank_arms;
collect_type_mapping(?rank_cross_armor) -> ?rank_armor;
collect_type_mapping(?rank_cross_soul_world) -> ?rank_soul_world;
collect_type_mapping(?rank_cross_soul_world_array) -> ?rank_soul_world_array;
collect_type_mapping(?rank_cross_soul_world_spirit) -> ?rank_soul_world_spirit;
collect_type_mapping(Type) -> Type.

%% 跨服排行榜数据上限
max_rank_num(?rank_cross_total_power) -> 100;
max_rank_num(?rank_cross_role_pet_power) -> 100;
max_rank_num(?rank_cross_mount_power) -> 100;
max_rank_num(?rank_cross_flower) -> 100;
max_rank_num(?rank_cross_glamor) -> 100;
max_rank_num(_) -> 100.

%% 获取数据取SRVID
get_srv_id(#rank_cross_total_power{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_role_pet_power{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_mount_power{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_mount_lev{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_flower{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_glamor{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_pet_lev{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_pet_grow{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_pet_potential{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_role_power{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_role_lev{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_role_coin{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_role_achieve{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_role_skill{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_role_soul{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_guild_lev{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_vie_kill{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_equip_arms{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_equip_armor{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_world_compete_win{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_soul_world{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_soul_world_array{srv_id = SrvId}) -> SrvId;
get_srv_id(#rank_cross_soul_world_spirit{srv_id = SrvId}) -> SrvId;
get_srv_id(_) -> <<>>.

%%-------------------------------------------------
%% 数据转换
%%-------------------------------------------------
convert(?rank_cross_total_power, #rank_total_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, sex = Sex, career = Career, lev = Lev, guild = Guild, role_power = RolePower, pet_power = PetPower, total_power = TotalPower, eqm = Eqm, looks = Looks, pet = Pet, realm = Realm, vip = Vip, wc_lev = WcLev, ascend = Ascend}) ->
    #rank_cross_total_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, sex = Sex, career = Career, lev = Lev, guild = Guild, role_power = RolePower, pet_power = PetPower, total_power = TotalPower, eqm = Eqm, looks = Looks, pet = Pet, realm = Realm, vip = Vip, wc_lev = WcLev, ascend = Ascend};

convert(?rank_cross_flower, #rank_flower_day{id = Id, rid = Rid, srv_id = SrvId, guild = Gname, name = Name, career = Career, realm = Realm, sex = Sex, flower = Flower, lev = Lev, vip = Vip, face = Face}) ->
    #rank_cross_flower{id = Id, rid = Rid, srv_id = SrvId, guild = Gname, name = Name, career = Career, realm = Realm, sex = Sex, flower = Flower, lev = Lev, vip = Vip, face = Face};

convert(?rank_cross_glamor, #rank_glamor_day{id = Id, rid = Rid, srv_id = SrvId, guild = Gname, name = Name, career = Career, realm = Realm, sex = Sex, glamor = Glamor, lev = Lev, vip = Vip, face = Face}) ->
    #rank_cross_glamor{id = Id, rid = Rid, srv_id = SrvId, guild = Gname, name = Name, career = Career, realm = Realm, sex = Sex, glamor = Glamor, lev = Lev, vip = Vip, face = Face};

%%---------------------------------
%% 个人
%%---------------------------------

convert(_RankType = ?rank_cross_role_power, #rank_role_power{id = Id, rid = Rid, srv_id = SrvId, power = Power, name = Name, career = Career, realm = Realm, sex = Sex, guild = Gname, lev = Lev, vip = Vip, eqm = Eqm, looks = Looks, ascend = Ascend}) ->
    #rank_cross_role_power{id = Id, rid = Rid, srv_id = SrvId, power = Power,
        name = Name, career = Career, realm = Realm, sex = Sex, guild = Gname, lev = Lev, vip = Vip, date = util:unixtime(),
        eqm = Eqm, looks = Looks, ascend = Ascend};

convert(_RankType = ?rank_cross_role_lev, #rank_role_lev{id = Id, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, lev = Lev, exp = Exp, vip = Vip, eqm = Eqm, looks = Looks, realm = Realm}) ->
    #rank_cross_role_lev{id = Id, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, lev = Lev, exp = Exp, vip = Vip, date = util:unixtime(), eqm = Eqm, looks = Looks, realm = Realm};

convert(_RankType = ?rank_cross_role_coin, #rank_role_coin{id = Id, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, coin = Coin, gold = Gold, vip = Vip, lev = Lev, eqm = Eqm, looks = Looks, realm = Realm}) ->
    #rank_cross_role_coin{id = Id, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, coin = Coin, gold = Gold, vip = Vip, date = util:unixtime(), lev = Lev, eqm = Eqm, looks = Looks, realm = Realm};

convert(_RankType = ?rank_cross_role_achieve, #rank_role_achieve{id = Id, rid = Rid, srv_id = SrvId, name = Name, career = Career, realm = Realm, sex = Sex, guild = Gname, achieve = Ach, lev = Lev, vip = Vip, eqm = Eqm, looks = Looks}) ->
    #rank_cross_role_achieve{id = Id, rid = Rid, srv_id = SrvId, name = Name, career = Career, realm = Realm, sex = Sex, guild = Gname, achieve = Ach, lev = Lev, vip = Vip, date = util:unixtime(), eqm = Eqm, looks = Looks};

convert(_RankType = ?rank_cross_role_skill, #rank_role_skill{id = Id, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, skill = Skill, career = Career, sex = Sex, guild = Gname, lev = Lev, vip = Vip, eqm = Eqm, looks = Looks}) ->
    #rank_cross_role_skill{id = Id, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, skill = Skill, career = Career, sex = Sex, guild = Gname, lev = Lev, vip = Vip, date = util:unixtime(), eqm = Eqm, looks = Looks};

convert(_RankType = ?rank_cross_role_soul, #rank_role_soul{id = Id, rid = Rid, srv_id = SrvId, name = Name, soul = Soul, career = Career, sex = Sex, realm = Realm, guild = Gname, lev = Lev, vip = Vip, eqm = Eqm, looks = Looks}) ->
    #rank_cross_role_soul{id = Id, rid = Rid, srv_id = SrvId, name = Name, soul = Soul, career = Career, sex = Sex, realm = Realm, guild = Gname, lev = Lev, vip = Vip, date = util:unixtime(), eqm = Eqm, looks = Looks};

%%--------------------------
%% 宠物相关
%%--------------------------
convert(_RankType = ?rank_cross_pet_lev, #rank_role_pet{id = Id, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, petid = Petid, color = Color, petname = PetName, petlev = PetLev, aptitude = Avg, growrate = GrowRate, realm = Realm, vip = Vip, pet = Pet, petrb = PetRb}) ->
    #rank_cross_pet_lev{id = Id, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, petid = Petid, color = Color, petname = PetName, petlev = PetLev, aptitude = Avg, growrate = GrowRate, realm = Realm, vip = Vip, date = util:unixtime(), pet = Pet, petrb = PetRb};

convert(_RankType = ?rank_cross_role_pet_power, #rank_role_pet_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, petid = PetId, color = Color, petname = PetName, petlev = PetLev, power = Power, vip = Vip, pet = Pet, petrb = PetRb}) ->
    #rank_cross_role_pet_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, petid = PetId, color = Color, petname = PetName, petlev = PetLev, power = Power, vip = Vip, pet = Pet, date = util:unixtime(), petrb = PetRb};

convert(_RankType = ?rank_cross_pet_power, #rank_role_pet_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, petid = PetId, color = Color, petname = PetName, petlev = PetLev, power = Power, vip = Vip, pet = Pet, petrb = PetRb}) ->
    #rank_cross_role_pet_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, petid = PetId, color = Color, petname = PetName, petlev = PetLev, power = Power, vip = Vip, pet = Pet, date = util:unixtime(), petrb = PetRb};

convert(_RankType = ?rank_cross_pet_grow, #rank_pet_grow{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, petid = PetId, color = Color, petname = PetName, petlev = PetLev, grow = Grow, vip = Vip, pet = Pet, petrb = PetRb}) ->
    #rank_cross_pet_grow{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, petid = PetId, color = Color, petname = PetName, petlev = PetLev, grow = Grow, vip = Vip, pet = Pet, date = util:unixtime(), petrb = PetRb};

convert(_RankType = ?rank_cross_pet_potential, #rank_pet_potential{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, petid = PetId, color = Color, petname = PetName, petlev = PetLev, potential = Potential, vip = Vip, pet = Pet, petrb = PetRb}) ->
    #rank_cross_pet_potential{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, petid = PetId, color = Color, petname = PetName, petlev = PetLev, potential = Potential, vip = Vip, pet = Pet, date = util:unixtime(), petrb = PetRb};

%%-----------------------------------
%% 坐骑相关
%%-----------------------------------
convert(_RankType = ?rank_cross_mount_power, #rank_mount_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, lev = Lev, guild = Guild, mount = Mount, step = Step, mount_lev = MountLev, quality = Quality, power = Power, vip = Vip, eqm = Eqm, looks = Looks}) ->
    #rank_cross_mount_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, lev = Lev, guild = Guild, mount = Mount, step = Step, mount_lev = MountLev, quality = Quality, power = Power, vip = Vip, eqm = Eqm, looks = Looks, date = util:unixtime()};

convert(_RankType = ?rank_cross_mount_power1, #rank_mount_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, lev = Lev, guild = Guild, mount = Mount, step = Step, mount_lev = MountLev, quality = Quality, power = Power, vip = Vip, eqm = Eqm, looks = Looks}) ->
    #rank_cross_mount_power{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, lev = Lev, guild = Guild, mount = Mount, step = Step, mount_lev = MountLev, quality = Quality, power = Power, vip = Vip, eqm = Eqm, looks = Looks, date = util:unixtime()};

convert(_RankType = ?rank_cross_mount_lev, #rank_mount_lev{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, lev = Lev, guild = Guild, mount = Mount, step = Step, mount_lev = MountLev, quality = Quality, power = Power, vip = Vip, eqm = Eqm, looks = Looks}) ->
    #rank_cross_mount_lev{id = Id, rid = Rid, srv_id = SrvId, name = Name, realm = Realm, career = Career, sex = Sex, lev = Lev, guild = Guild, mount = Mount, step = Step, mount_lev = MountLev, quality = Quality, vip = Vip, eqm = Eqm, looks = Looks, date = util:unixtime(), power = Power};

%%-------------------------------------
%% 装备
%%-------------------------------------
convert(_RankType = ?rank_cross_arms, #rank_equip_arms{id = Id, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, arms = NewAname, score = Score, lev = Lev, vip = Vip, quality = Q, item = Item}) ->
    #rank_cross_equip_arms{id = Id, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, arms = NewAname, score = Score, lev = Lev, vip = Vip, quality = Q, item = Item, date = util:unixtime()};

convert(_RankType = ?rank_cross_armor, #rank_equip_armor{id = Id, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, armor = NewAname, score = Score, lev = Lev, vip = Vip, quality = Q, type = Type, item = Item}) ->
    #rank_cross_equip_armor{id = Id, realm = Realm, rid = Rid, srv_id = SrvId, name = Name, career = Career, sex = Sex, guild = Gname, armor = NewAname, score = Score, lev = Lev, vip = Vip, quality = Q, type = Type, item = Item, date = util:unixtime()};

%%-----------------------------
%% 帮会
%%-----------------------------
convert(_RankType = ?rank_cross_guild_lev, #rank_guild_lev{id = Id, rid = Gid, srv_id = Gsrvid, name = Gname, cName = Chief, lev = Glev, fund = Fund, num = Num, chief_rid = Rid, chief_srv_id = Srvid, realm = Realm}) ->
    #rank_cross_guild_lev{id = Id, rid = Gid, srv_id = Gsrvid, name = Gname, cName = Chief, lev = Glev, fund = Fund, num = Num, chief_rid = Rid, chief_srv_id = Srvid, realm = Realm, date = util:unixtime()};

%%-------------------------------------------
%% 战场
%%-------------------------------------------
convert(_RankType = ?rank_cross_arena_kill, #rank_vie_kill{id = Id, realm = Realm, rid = Rid, srv_id = Srvid, name = Name, guild = Gname, 
                    career = Career, sex = Sex, kill = Kill, lev = Lev, vip = Vip}) ->
    #rank_cross_vie_kill{id = Id, realm = Realm, rid = Rid, srv_id = Srvid, name = Name, guild = Gname, career = Career, sex = Sex, kill = Kill, lev = Lev, vip = Vip, date = util:unixtime()};

convert(_RankType = ?rank_cross_world_compete_win, #rank_world_compete_win{id = Id, rid = Rid, srv_id = SrvId, looks = Looks, eqm = Eqm, name = Name, career = Career, sex = Sex, win_count = WinCount, lev = Lev, realm = Realm, guild = Gname, vip = Vip}) ->
    #rank_cross_world_compete_win{id = Id, rid = Rid, srv_id = SrvId, looks = Looks, eqm = Eqm, name = Name, career = Career, sex = Sex, win_count = WinCount, lev = Lev, date = util:unixtime(), realm = Realm, guild = Gname, vip = Vip};

%%------------------------------------------
%% 灵戒洞天
%%------------------------------------------
convert(_RankType = ?rank_cross_soul_world, #rank_soul_world{id = Id, rid = Rid, srv_id = SrvId, spirits = Spirits, arrays = Arrays, name = Name, career = Career, sex = Sex, power = Power, realm = Realm, guild = Gname, vip = Vip, role_lev = RoleLev}) ->
    #rank_cross_soul_world{id = Id, rid = Rid, srv_id = SrvId, spirits = Spirits, arrays = Arrays, name = Name, career = Career, sex = Sex, power = Power, date = util:unixtime(), realm = Realm, guild = Gname, vip = Vip, role_lev = RoleLev};

convert(_RankType = ?rank_cross_soul_world_array, #rank_soul_world_array{id = Id, rid = Rid, srv_id = SrvId, arrays = Arrays, name = Name, career = Career, sex = Sex, lev = Lev, realm = Realm, guild = Gname, vip = Vip, role_lev = RoleLev}) ->
    #rank_cross_soul_world_array{id = Id, rid = Rid, srv_id = SrvId, arrays = Arrays, name = Name, career = Career, sex = Sex, lev = Lev, date = util:unixtime(), realm = Realm, guild = Gname, vip = Vip, role_lev = RoleLev};

convert(_RankType = ?rank_cross_soul_world_spirit, #rank_soul_world_spirit{id = Id, rid = Rid, srv_id = SrvId, spirit = Spirit, name = Name, career = Career, sex = Sex, power = Power, realm = Realm, guild = Gname, vip = Vip, quality = Quality, spirit_name = SpiritName, spirit_lev = SpiritLev, role_lev = RoleLev}) ->
    #rank_cross_soul_world_spirit{id = Id, rid = Rid, srv_id = SrvId, spirit = Spirit, name = Name, career = Career, sex = Sex, power = Power, date = util:unixtime(), realm = Realm, guild = Gname, vip = Vip, quality = Quality, spirit_name = SpiritName, spirit_lev = SpiritLev, role_lev = RoleLev};

convert(_Type, _Data) -> false.

%%--------------------------------
%% 排行榜活动时间过滤
%%--------------------------------

%% 判断当前是否为采集合法时间 无活动
is_collect_time() ->
    {Date, {Hour, Min, _Sec}} = calendar:local_time(),
    WeekDate = calendar:day_of_the_week(Date),
    is_collect_time(WeekDate, Hour, Min).
%% 跨服竞技场 
is_collect_time(_WeekDate, Hour, Min) when Hour =:= 14 andalso Min =< 30 -> false;
is_collect_time(_WeekDate, Hour, Min) when Hour =:= 19 andalso Min =< 30 -> false;
%% 跨服帮战
is_collect_time(1, Hour, Min) when Hour =:= 20 andalso Min =< 30 -> false;
is_collect_time(3, Hour, Min) when Hour =:= 20 andalso Min =< 30 -> false;
is_collect_time(5, Hour, Min) when Hour =:= 20 andalso Min =< 30 -> false;
is_collect_time(7, Hour, Min) when Hour =:= 20 andalso Min =< 30 -> false;
%% 天位
is_collect_time(6, Hour, _Min) when Hour >= 10 andalso Hour < 12 -> false;
is_collect_time(6, Hour, _Min) when Hour >= 14 andalso Hour < 16 -> false;
is_collect_time(7, Hour, _Min) when Hour >= 10 andalso Hour < 12 -> false;
is_collect_time(7, Hour, _Min) when Hour >= 14 andalso Hour < 16 -> false;
%% 王者挑战
is_collect_time(4, Hour, Min) when Hour =:= 15 andalso Min =< 30 -> false;
is_collect_time(5, Hour, Min) when Hour =:= 15 andalso Min =< 30 -> false;
%% 仙道会
%% is_collect_time(_WeekDate, Hour, _Min) when Hour >= 16 andalso Hour =< 18 -> false;

is_collect_time(_WeekDate, _Hour, _Min) -> true.


