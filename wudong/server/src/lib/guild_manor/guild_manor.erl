%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%     帮派家园
%%% @end
%%% Created : 13. 十二月 2016 10:19
%%%-------------------------------------------------------------------
-module(guild_manor).
-author("hxming").

-include("guild_manor.hrl").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("achieve.hrl").

%% API
-compile(export_all).

-define(MANOR_STATE_LOCK, 0).
-define(MANOR_STATE_UNLOCK, 1).
-define(MANOR_STATE_REWARD, 2).

-define(DAILY_CONTRIBUTE_LIM, 500).


cmd_manor_exp(Player, Exp) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> ok;
        Manor ->
            NewManor = guild_manor_refresh:add_manor_exp(Manor, Exp),
            guild_manor_ets:set_guild_manor(NewManor#g_manor{is_change = 1})

    end.

cmd_build_exp(Player, Exp) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> ok;
        Manor ->
            F = fun(Build) ->
                guild_manor_refresh:add_building_exp(Build, Exp)
                end,
            BuildList = lists:map(F, Manor#g_manor.building_list),
            NewManor = Manor#g_manor{building_list = BuildList, is_change = 1},
            guild_manor_ets:set_guild_manor(NewManor)

    end.


%%新的家园
new_guild_manor(Gkey) ->
    Manor = #g_manor{gkey = Gkey, retinue_list = default_retinue_list(), is_change = 1, time = util:unixtime(), lv = 1},
    guild_manor_ets:set_guild_manor(Manor),
    ok.

%%删除家园
del_guild_manor(Gkey) ->
    guild_manor_ets:del_guild_manor(Gkey),
    guild_manor_load:del_guild_manor(Gkey),
    ok.

%%家园信息
manor_info(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> [];
        Manor1 ->
            Now = util:unixtime(),
            %%刷新建筑
            Manor = guild_manor_refresh:check_refresh_building(Manor1, Now),
            ExpLim = data_guild_manor_exp:get(Manor#g_manor.lv),
            F = fun(Type) ->
                Base = data_manor_building:get(Type),
                %%[类型,等级,经验,经验上限,解锁状态,是否有奖励,任务状态]
                case lists:keyfind(Type, #manor_building.type, Manor#g_manor.building_list) of
                    false ->
                        [Type, 1, 0, 0, Base#base_manor_building.manor_lv, [], []];
                    Building ->
                        BoxList = check_box_state(Building, Player#player.key),
                        RetinueState = check_retinue_state(Manor1#g_manor.retinue_list, Building),
                        BuildingExpLim = data_manor_building_exp:get(Building#manor_building.lv),
                        [Type, Building#manor_building.lv, Building#manor_building.exp, BuildingExpLim, 0, BoxList, RetinueState]
                end
                end,
            BuildingInfo = lists:map(F, data_manor_building:type_list()),

            F1 = fun({Msg, Time}) -> [Msg, Now - Time] end,
            LogInfo = lists:map(F1, Manor#g_manor.log),
            Contribute = daily:get_count(?DAILY_GUILD_MANOR_CONTRIBUTE),
            {Contribute, ?DAILY_CONTRIBUTE_LIM, Manor#g_manor.lv, Manor#g_manor.exp, ExpLim, BuildingInfo, LogInfo}
    end.

%%获取宝箱奖励列表
check_box_state(Building, Key) ->
    F = fun(Box) ->
        case lists:member(Key, Box#manor_building_box.log) of
            true -> [];
            false ->
                [Box#manor_building_box.key]
        end
        end,
    lists:flatmap(F, Building#manor_building.box_list).

%%获取随从任务状态[[key,id,state]]
check_retinue_state(RetinueList, Building) ->
    F1 = fun(Retinue) ->
        case lists:keyfind(Retinue#manor_retinue.key, #manor_retinue.key, RetinueList) of
            false -> [];
            Retinue1 -> [[Retinue#manor_retinue.key, Retinue#manor_retinue.id, Retinue1#manor_retinue.state]]
        end
         end,
    F = fun(Task) ->
        if Task#manor_building_task.time == 0 -> [];
            true ->
                lists:flatmap(F1, Task#manor_building_task.retinue)
        end
        end,
    lists:flatmap(F, Building#manor_building.task).

%%随从列表
retinue_list(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> [];
        Manor ->
            Now = util:unixtime(),
            F = fun(Type) ->
                F1 = fun(Id) ->
                    case lists:keyfind(Id, #manor_retinue.id, Manor#g_manor.retinue_list) of
                        false ->
                            Count = goods_util:get_goods_count(Id),
                            if Count > 0 ->
                                [0, Id, 1, 0];
                                true ->
                                    [0, Id, 0, 0]
                            end;
                        Retinue ->
                            WorkState = ?IF_ELSE(Retinue#manor_retinue.time < Now, 0, 1),
                            [Retinue#manor_retinue.key, Id, 2, WorkState]
                    end
                     end,
                [Type, lists:map(F1, data_manor_retinue:type_list(Type))]
                end,
            lists:map(F, data_manor_retinue:get_type())
    end.

%%激活随从
activate_retinue(Player, GoodsId) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> 2;
        Manor ->
            GoodsCount = goods_util:get_goods_count(GoodsId),
            if GoodsCount =< 0 ->
                13;
                true ->
                    case lists:keymember(GoodsId, #manor_retinue.id, Manor#g_manor.retinue_list) of
                        true ->
                            14;
                        false ->
                            case data_manor_retinue:get(GoodsId) of
                                [] -> 13;
                                Base ->
                                    Retinue = #manor_retinue{key = misc:unique_key(), id = Base#base_manor_retinue.id, color = Base#base_manor_retinue.color, quality = Base#base_manor_retinue.quality, talent = tuple_to_list(Base#base_manor_retinue.talent)},
                                    RetinueList = [Retinue | Manor#g_manor.retinue_list],
                                    Msg = io_lib:format(?T("~s激活了~s"), [Player#player.nickname, Base#base_manor_retinue.name]),
                                    Log = lists:sublist([{Msg, util:unixtime()} | Manor#g_manor.log], 10),
                                    NewManor = Manor#g_manor{retinue_list = RetinueList, log = Log, is_change = 1},
                                    guild_manor_ets:set_guild_manor(NewManor),
                                    goods:subtract_good(Player, [{GoodsId, 1}], 0),
                                    1
                            end
                    end
            end
    end.

default_retinue_list() ->
    F1 = fun(Id) ->
        Base = data_manor_retinue:get(Id),
        #manor_retinue{
            key = misc:unique_key(),
            id = Base#base_manor_retinue.id,
            color = Base#base_manor_retinue.color,
            quality = Base#base_manor_retinue.quality,
            talent = tuple_to_list(Base#base_manor_retinue.talent)
        }
         end,
    F = fun(Type) ->
        lists:map(F1, data_manor_retinue:type_list(Type))
        end,
    lists:flatmap(F, data_manor_retinue:get_type()).


%%激活所以的随从
cmd_activate_retinue(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    F1 = fun(GoodsId) ->
        case guild_manor_ets:get_guild_manor(Gkey) of
            [] -> ok;
            Manor ->
                case lists:keymember(GoodsId, #manor_retinue.id, Manor#g_manor.retinue_list) of
                    true ->
                        ok;
                    false ->
                        case data_manor_retinue:get(GoodsId) of
                            [] -> ok;
                            Base ->
                                Retinue = #manor_retinue{key = misc:unique_key(), id = Base#base_manor_retinue.id, color = Base#base_manor_retinue.color, quality = Base#base_manor_retinue.quality, talent = tuple_to_list(Base#base_manor_retinue.talent)},
                                RetinueList = [Retinue | Manor#g_manor.retinue_list],
                                Msg = io_lib:format(?T("~s激活了~s"), [Player#player.nickname, Base#base_manor_retinue.name]),
                                Log = lists:sublist([{Msg, util:unixtime()} | Manor#g_manor.log], 10),
                                NewManor = Manor#g_manor{retinue_list = RetinueList, log = Log, is_change = 1},
                                guild_manor_ets:set_guild_manor(NewManor)
                        end
                end
        end
         end,
    F = fun(Type) ->
        lists:foreach(F1, data_manor_retinue:type_list(Type))
        end,
    lists:foreach(F, data_manor_retinue:get_type()),
    ok.


%%重置随从状态
reset_retinue(Player, Key) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> {2, [], Player};
        Manor ->
            case lists:keytake(Key, #manor_retinue.key, Manor#g_manor.retinue_list) of
                false -> {5, [], Player};
                {value, Retinue, L} ->
                    Now = util:unixtime(),
                    if Retinue#manor_retinue.time < Now -> {15, [], Player};
                        Retinue#manor_retinue.state == 0 -> {16, [], Player};
                        true ->
                            RetinueList = [Retinue#manor_retinue{state = 0} | L],
                            BaseRetinue = data_manor_retinue:get(Retinue#manor_retinue.id),
                            BaseState = data_manor_retinue_state:get(Retinue#manor_retinue.state),
                            Msg = io_lib:format(?T("~s清除了随从~s的~s状态"), [Player#player.nickname, BaseRetinue#base_manor_retinue.name, BaseState#base_manor_retinue_state.desc]),
                            Log = lists:sublist([{Msg, util:unixtime()} | Manor#g_manor.log], 10),
                            NewManor = Manor#g_manor{retinue_list = RetinueList, log = Log, is_change = 1},
                            guild_manor_ets:set_guild_manor(NewManor),
                            Contribute = daily:get_count(?DAILY_GUILD_MANOR_CONTRIBUTE),
                            GoodsList =
                                if Contribute < ?DAILY_CONTRIBUTE_LIM ->
                                    Add = case lists:keyfind(1025000, 1, BaseState#base_manor_retinue_state.contrib) of
                                              false -> 0;
                                              {_, V} -> V
                                          end,
                                    daily:increment(?DAILY_GUILD_MANOR_CONTRIBUTE, Add),
                                    BaseState#base_manor_retinue_state.contrib;
                                    true ->
                                        BaseState#base_manor_retinue_state.goods
                                end,
                            GiveGoodsList = goods:make_give_goods_list(232, GoodsList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            {1, goods:pack_goods(GoodsList), NewPlayer}
                    end
            end
    end.

%%查看建筑任务列表
building_task(Player, Type) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> {0, []};
        Manor ->
            case lists:keytake(Type, #manor_building.type, Manor#g_manor.building_list) of
                false -> {0, []};
                {value, Building, T} ->
                    Now = util:unixtime(),
                    BuildIng1 = guild_manor_refresh:refresh_task(Building, Now),
                    if BuildIng1 /= Building ->
                        NewManor = Manor#g_manor{building_list = [BuildIng1 | T], is_change = 1},
                        guild_manor_ets:set_guild_manor(NewManor);
                        true ->
                            ok
                    end,
                    F1 = fun(Retinue) -> Retinue#manor_retinue.id end,
                    F = fun(Task) ->
                        [Task#manor_building_task.task_id,
                            max(0, Task#manor_building_task.time - Now),
                            Task#manor_building_task.ratio,
                            lists:map(F1, Task#manor_building_task.retinue),
                            Task#manor_building_task.team_ratio,
                            Task#manor_building_task.team_talent
                        ]
                        end,
                    TaskList = lists:map(F, BuildIng1#manor_building.task),
                    {BuildIng1#manor_building.refresh_time - Now, TaskList}
            end
    end.


%%发布任务
start_task(Player, Type, TaskId, RetinueKeys) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> 2;
        Manor ->
            case lists:keytake(Type, #manor_building.type, Manor#g_manor.building_list) of
                false -> 3;
                {value, Building, T} ->
                    case lists:keytake(TaskId, #manor_building_task.task_id, Building#manor_building.task) of
                        false -> 4;
                        {value, Task, L} ->
                            case data_building_task:get(Task#manor_building_task.task_id) of
                                [] -> 4;
                                Base ->
                                    if Task#manor_building_task.time > 0 -> 7;
                                        true ->
                                            Now = util:unixtime(),
                                            case check_retinue(RetinueKeys, Manor#g_manor.retinue_list, Now) of
                                                {ok, RetinueList} ->
%%                                                    Cd = 120 + Now,
                                                    Cd = Base#base_building_task.time + Now,
                                                    {Ratio, TeamRatio, TeamTalent} = calc_task_ratio(RetinueList, Base#base_building_task.talent, Building#manor_building.talent, Task#manor_building_task.ratio),
                                                    NewTask = Task#manor_building_task{
                                                        time = Cd,
                                                        pkey = Player#player.key,
                                                        ratio = Ratio,
                                                        retinue = RetinueList,
                                                        team_ratio = TeamRatio,
                                                        team_talent = TeamTalent
                                                    },
                                                    NewBuilding = Building#manor_building{task = [NewTask | L]},
                                                    NewRetinueList = update_retinue(Manor#g_manor.retinue_list, RetinueList, Cd),
                                                    Msg = io_lib:format(?T("~s发布了~s任务"), [Player#player.nickname, Base#base_building_task.desc]),
                                                    Log = lists:sublist([{Msg, util:unixtime()} | Manor#g_manor.log], 10),
                                                    NewManor = Manor#g_manor{is_change = 1, retinue_list = NewRetinueList, log = Log, building_list = [NewBuilding | T]},
                                                    guild_manor_ets:set_guild_manor(NewManor),
                                                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4011, 0, 1),
                                                    1;
                                                Err -> Err
                                            end
                                    end
                            end
                    end
            end
    end.

%%检查随从是否可以任务
check_retinue(Keys, RetinueList, Now) ->
    F = fun(Key, L) ->
        case lists:keyfind(Key, #manor_retinue.key, RetinueList) of
            false -> L;
            Val -> [Val | L]
        end
        end,
    FilterList = lists:foldl(F, [], Keys),
    case length(FilterList) == length(Keys) of
        false -> 5;
        true ->
            F1 = fun(Retinue) -> Retinue#manor_retinue.time > Now end,
            case lists:any(F1, FilterList) of
                true -> 6;
                false ->
                    {ok, FilterList}
            end
    end.

%%更新随着工作状态
update_retinue(RetinueList, List, Cd) ->
    F = fun(Retinue, L) ->
        [Retinue#manor_retinue{time = Cd, state_log = []} | lists:keydelete(Retinue#manor_retinue.key, #manor_retinue.key, L)] end,
    lists:foldl(F, RetinueList, List).

%%计算任务宝箱概率
calc_task_ratio(RetinueList, NeedTalentList, BuildingTalent, TaskRatio) ->
    F = fun(Retinue) -> Retinue#manor_retinue.talent end,
    RetinueTalentList = lists:flatmap(F, RetinueList),
    NowTalentList = RetinueTalentList ++ BuildingTalent,
    List = util:list_the_same_path(tuple_to_list(NeedTalentList), NowTalentList),
    F1 = fun(TalentId, R) ->
        case data_manor_retinue_talent:get(TalentId) of
            [] -> R;
            Base ->
                if Base#base_manor_retinue_talent.type == 0 orelse Base#base_manor_retinue_talent.type == 1 orelse Base#base_manor_retinue_talent.type == 2 ->
                    Base#base_manor_retinue_talent.value + R;
                    true -> R
                end
        end
         end,
    %%基础概率
    BaseRatio = lists:foldl(F1, 0, List),
    %%计算小队概率
    F2 = fun(TalentId, {R1, T1, L1}) ->
        case data_manor_retinue_talent:get(TalentId) of
            [] -> {R1, T1, L1};
            Base ->
                %%1-时间,2+成功率
                if Base#base_manor_retinue_talent.type == 3 ->
                    case match_rela(RetinueList, Base#base_manor_retinue_talent.rela) of
                        false ->
                            {R1, T1, L1};
                        true ->
                            {R1, T1 + Base#base_manor_retinue_talent.value, [TalentId | L1]}
                    end;
                    Base#base_manor_retinue_talent.type == 4 ->
                        case match_rela(RetinueList, Base#base_manor_retinue_talent.rela) of
                            false ->
                                {R1, T1, L1};
                            true ->
                                {R1 + Base#base_manor_retinue_talent.value, T1, [TalentId | L1]}
                        end;
                    true ->
                        {R1, T1, L1}
                end
        end
         end,
    {TeamRatio, TeamTime, TeamTalent} = lists:foldl(F2, {0, 0, []}, RetinueTalentList),
    NewRatio = min(100, BaseRatio + TeamRatio + TaskRatio),
    {NewRatio, TeamTime, TeamTalent}.

match_rela([], _Rela) -> false;
match_rela([Retinue | T], Rela) ->
    Base = data_manor_retinue:get(Retinue#manor_retinue.id),
    if Base#base_manor_retinue.type == Rela -> true;
        true ->
            match_rela(T, Rela)
    end.

%%领取宝箱奖励
box_reward(Player, Type, Key) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> {2, Player};
        Manor ->
            case lists:keytake(Type, #manor_building.type, Manor#g_manor.building_list) of
                false -> {3, Player};
                {value, Building, T} ->
                    case lists:keytake(Key, #manor_building_box.key, Building#manor_building.box_list) of
                        false -> {8, Player};
                        {value, Box, L} ->
                            case lists:member(Player#player.key, Box#manor_building_box.log) of
                                true -> {9, Player};
                                false ->
                                    OpenTimes = Box#manor_building_box.open_times - 1,
                                    NewBox = Box#manor_building_box{open_times = OpenTimes, log = [Player#player.key | Box#manor_building_box.log]},
                                    BoxList = ?IF_ELSE(OpenTimes =< 0, L, [NewBox | L]),
                                    NewBuilding = Building#manor_building{box_list = BoxList},
                                    NewManor = Manor#g_manor{building_list = [NewBuilding | T], is_change = 1},
                                    guild_manor_ets:set_guild_manor(NewManor),
                                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(207, [{Box#manor_building_box.box_id, 1}])),
                                    activity:get_notice(Player, [92, 117], true),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

get_box_reward_state(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case Gkey == 0 of
        true ->
            0;
        false ->
            case guild_manor_ets:get_guild_manor(Gkey) of
                [] -> 0;
                Manor ->
                    F = fun(Building) ->
                        F1 = fun(Box) ->
                            case lists:member(Player#player.key, Box#manor_building_box.log) of
                                true -> [];
                                false -> [1]
                            end
                             end,
                        L1 = lists:flatmap(F1, Building#manor_building.box_list),
                        ?IF_ELSE(L1 == [], [], [1])
                        end,
                    L = lists:flatmap(F, Manor#g_manor.building_list),
                    ?IF_ELSE(L == [], 0, 1)
            end
    end.

get_notice_player(Player) ->
    guild_manor:get_box_reward_state(Player).

%%商店列表
shop_list(Player) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> {0, []};
        Manor ->
            F = fun(GoodsId) ->
                OpenLv = data_guild_manor_shop:get_lv(GoodsId),
                State =
                    case Manor#g_manor.lv >= OpenLv of
                        true -> 0;
                        false -> OpenLv
                    end,
                [GoodsId, data_guild_manor_shop:get_price(GoodsId), State]
                end,
            List = lists:map(F, data_guild_manor_shop:goods_list()),
            {Player#player.manor_pt, List}
    end.

%%购买物品
buy_goods(Player, GoodsId, Num) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    case guild_manor_ets:get_guild_manor(Gkey) of
        [] -> {2, Player};
        Manor ->
            case Manor#g_manor.lv >= data_guild_manor_shop:get_lv(GoodsId) of
                false -> {10, Player};
                true ->
                    if Num =< 0 -> {11, Player};
                        true ->
                            Price = data_guild_manor_shop:get_price(GoodsId) * Num,
                            if Player#player.manor_pt < Price ->
                                {12, Player};
                                true ->
                                    NewPlayer = money:add_manor_pt(Player, -Price,2,GoodsId,Num),
                                    goods:give_goods(Player, goods:make_give_goods_list(208, [{GoodsId, Num}])),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

