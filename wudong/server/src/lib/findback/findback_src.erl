%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 资源找回
%%% @end
%%% Created : 13. 二月 2017 下午2:31
%%%-------------------------------------------------------------------
-module(findback_src).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("findback.hrl").
-include("tips.hrl").

-export([
    get_findback_src_info/1,
    get_findback_src/3
]).

%% API
-export([
    game_init/0,
    update_act_time/2,
    update_act_time/3,
    init/1,
    logout/1,
    update/1,
    timer_update/1,
    fb_trigger_src/3,
    check_find_state/1,
    get_state/1
]).


%% 1坐骑副本
%% 2仙羽副本
%% 3法器副本
%% 4神兵副本
%% 5宠物副本
%% 6妖灵副本
%% 7足迹副本
%% 8灵猫副本
%% 9法身副本
%% 10天罡副本
%%
%% 11经验副本
%% 12九霄塔
%% 13剧情副本
%% 14神器
%% 15筋脉
%% 16灵脉
%% 17守护副本
%% 20日常任务
%% 25悬赏任务
%% 30帮派任务
%% 31王城守卫
%% 32六龙争霸
%% 33跨服1v1
%% 34巅峰塔
%% 35答题
%% 36领土争夺
%% 37温泉
%% 41灵羽副本
%% 42灵弓副本
%% 43灵骑副本
%% 44跨服副本


game_init() ->
    Sql = io_lib:format("select type,last_open_time,args from log_findback_act_time", []),
    case db:get_all(Sql) of
        [] -> skip;
        L ->
            F = fun([Type, Time, ArgsBin]) ->
                ets:insert(?ETS_FINDBACK_ACT_TIME, #fd_act_time{
                    type = Type,
                    last_open_time = Time,
                    args = util:bitstring_to_term(ArgsBin)
                })
            end,
            lists:foreach(F, L)
    end.

update_act_time(Type, Time) ->
    update_act_time(Type, Time, []).
update_act_time(Type, Time, Args) ->
    case config:is_center_node() of
        true ->
            NodeList = center:get_nodes(),
            F = fun(Node) ->
                center:apply(Node, findback_src, update_act_time, [Type, Time, Args])
            end,
            lists:foreach(F, NodeList);
        false ->
            do_update_act_time(Type, Time, Args)
    end,
    ok.
do_update_act_time(Type, Time, Args) ->
    ets:insert(?ETS_FINDBACK_ACT_TIME, #fd_act_time{type = Type, last_open_time = Time, args = Args}),
    Sql = io_lib:format("replace into log_findback_act_time set type=~p,last_open_time=~p,args='~s'",
        [Type, Time, util:term_to_bitstring(Args)]),
    db:execute(Sql),
    ok.

%%获取是否有可领取状态
get_state(Player) ->
    List = get_can_findback_list(Player),
    case List == [] of
        true -> 0;
        false -> 1
    end.

check_find_state(Player) ->
    List = get_can_findback_list(Player),
    case List == [] of
        true ->
            #tips{};
        false ->
            #tips{state = 1}
    end.

get_can_findback_list(Player) ->
    St = get_dict(),
    AllType = data_findback_src:get_all_type(),
    F = fun(Type) ->
        findback_type_info(St, Type, Player)
    end,
    lists:flatmap(F, AllType).


%%获取找回信息
get_findback_src_info(Player) ->
    St = get_dict(),
    AllType = data_findback_src:get_all_type(),
    F = fun(Type) ->
       findback_type_info(St, Type, Player)
    end,
    List = lists:flatmap(F, AllType),
    case catch pt_381:write(38110, {List}) of
        {ok, Bin} -> server_send:send_to_sid(Player#player.sid, Bin);
        _Err ->
            ?ERR("38110 ~p~n", [List])
    end,
    ok.

%%检查是否有找回数据
findback_type_info(St, Type, Player) ->

    case lists:keyfind(Type, #fb_src.type, St#st_findback_src.type_list) of
        false ->
       [];
        FBSrc ->
            Base = data_findback_src:get(Type, Player#player.lv),
            if
                Base == [] -> [];
                true ->
                    Now = util:unixtime(),
                    DiffDay = util:get_diff_days(Now, FBSrc#fb_src.last_findback_time),
                    case DiffDay =< 0 orelse Now < FBSrc#fb_src.last_findback_time of
                        true -> [];
                        false ->
                            case get_type_info(Type, FBSrc, Base, Player#player.lv) of
                                [] ->  [];
                                Info -> [Info]
                            end
                    end
            end
    end.
get_type_info(11, FBSrc, Base, _Plv) ->
    Type = 11,
    #fb_src{
        fb_exp_round = {St, En}
    } = FBSrc,
    case St >= En of
        true ->
            [];
        false ->
            #base_findback_src{
                name = Name,
                cost_gold = CostGold
            } = Base,
            SumCostGold = round(CostGold * (En - St + 1)),
            F = fun(Round) -> tuple_to_list(data_dungeon_exp:get_pass_goods(Round)) end,
            GoodsList = goods:merge_goods(lists:flatmap(F, lists:seq(St, En))),
            GoodsList1 = [tuple_to_list(I) || I <- GoodsList],
            [Type, Name, SumCostGold, GoodsList1]
    end;
get_type_info(17, FBSrc, Base, _Plv) ->
    Type = 17,
    #fb_src{
        fb_guard_round = {St, En}
    } = FBSrc,
    case St >= En of
        true ->
            [];
        false ->
            #base_findback_src{
                name = Name,
                cost_gold = CostGold
            } = Base,
            SumCostGold = round(CostGold * (En - St + 1)),
            F = fun(Round) -> data_dungeon_guard:get_reward_list(Round) end,
            GoodsList = goods:merge_goods(lists:flatmap(F, lists:seq(St, En))),
            GoodsList1 = [tuple_to_list(I) || I <- GoodsList],
            [Type, Name, SumCostGold, GoodsList1]
    end;
get_type_info(12, FBSrc, Base, _Plv) ->
    Type = 12,
    #fb_src{
        fb_dun_ids = DunIdList
    } = FBSrc,
    case DunIdList of
        [] ->
            [];
        _ ->
            GoodsList1 = lists:flatten([dungeon_tower:get_dun_pass_goods(DunId) || DunId <- DunIdList]),
            GoodsList2 = goods:merge_goods(GoodsList1),
            GoodsList3 = util:list_tuple_to_list(GoodsList2),
            #base_findback_src{
                name = Name,
                cost_gold = CostGold
            } = Base,
            SumCostGold = round(length(DunIdList) * CostGold),
            [Type, Name, SumCostGold, GoodsList3]
    end;
get_type_info(Type, FBSrc, Base, _Plv) when Type >= 13 andalso Type =< 16 ->
    #fb_src{
        fb_dun_ids = DunIdList
    } = FBSrc,
    case DunIdList of
        [] ->
            [];
        _ ->
            GoodsList1 = lists:flatten([dungeon_daily:get_pass_goods(DunId) || DunId <- DunIdList]),
            GoodsList2 = goods:merge_goods(GoodsList1),
            GoodsList3 = util:list_tuple_to_list(GoodsList2),
            #base_findback_src{
                name = Name,
                cost_gold = CostGold
            } = Base,
            SumCostGold = round(length(DunIdList) * CostGold),
            [Type, Name, SumCostGold, GoodsList3]
    end;
get_type_info(20, FBSrc, Base, _Plv) ->
    Type = 20,
    #fb_src{
        fb_leave_times = FindTimes,
        fb_daily_task_gift = _IsCanGet
    } = FBSrc,
    #base_findback_src{
        name = Name,
        cost_gold = CostGold,
        find_goods = FindGoods
    } = Base,
    SumCostGold = round(FindTimes * CostGold),
    case SumCostGold =< 0 of
        true -> [];
        false ->
            GoodsList1 = [[Gid, Gnum * FindTimes] || {Gid, Gnum} <- FindGoods],
            [Type, Name, SumCostGold, GoodsList1]
    end;
get_type_info(25, FBSrc, Base, _Plv) ->
    Type = 25,
    #fb_src{
        fb_leave_times = FindTimes
    } = FBSrc,
    #base_findback_src{
        name = Name,
        cost_gold = CostGold,
        find_goods = FindGoods
    } = Base,
    SumCostGold = round(FindTimes * CostGold),
    case SumCostGold =< 0 of
        true -> [];
        false ->
            GoodsList1 = [[Gid, Gnum * FindTimes] || {Gid, Gnum} <- FindGoods],
            [Type, Name, SumCostGold, GoodsList1]
    end;
get_type_info(30, FBSrc, Base, _Plv) ->
    Type = 30,
    #fb_src{
        fb_leave_times = FindTimes,
        fb_guild_task_gift = _IsCanGet
    } = FBSrc,
    #base_findback_src{
        name = Name,
        cost_gold = CostGold,
        find_goods = FindGoods
    } = Base,
    SumCostGold = round(FindTimes * CostGold),
    case SumCostGold =< 0 of
        true -> [];
        false ->
            GoodsList1 = [[Gid, Gnum * FindTimes] || {Gid, Gnum} <- FindGoods],
            [Type, Name, SumCostGold, GoodsList1]
    end;


get_type_info(Type, FBSrc, Base, _Plv) when Type >= 1 andalso Type =< 10 orelse Type == 45 orelse Type == 46 ->
    #fb_src{
        fb_leave_times = FindTimes
    } = FBSrc,
    #base_findback_src{
        name = Name,
        cost_gold = CostGold
    } = Base,
    SumCostGold = round(FindTimes * CostGold),
    DunId =
        case Type of
            1 -> 50001;
            2 -> 50002;
            3 -> 50003;
            4 -> 50004;
            5 -> 50005;
            6 -> 50006;
            7 -> 50007;
            8 -> 50008;
            9 -> 50009;
            10 -> 50010;
            45 -> 50015;
            46 -> 50014
        end,
    case SumCostGold =< 0 of
        true ->
            [];
        false ->
            PassGoods = dungeon_material:pass_goods(DunId, _Plv),
            GoodsList1 = util:list_tuple_to_list(goods:merge_goods(PassGoods)),
            [Type, Name, SumCostGold, GoodsList1]
    end;


get_type_info(Type, FBSrc, Base, _Plv) when Type >= 31 andalso Type =< 37 ->
    #fb_src{
        fb_leave_times = FindTimes
    } = FBSrc,
    #base_findback_src{
        name = Name,
        cost_gold = CostGold,
        find_goods = FindGoods
    } = Base,
    case FindTimes > 0 of
        true ->
            SumCostGold = round(FindTimes * CostGold),
            GoodsList1 = util:list_tuple_to_list(FindGoods),
            [Type, Name, SumCostGold, GoodsList1];
        false ->
            []
    end;

get_type_info(44, FBSrc, Base, _Plv) ->
    #fb_src{
        fb_leave_times = FindTimes
    } = FBSrc,
    #base_findback_src{
        name = Name,
        cost_gold = CostGold,
        find_goods = FindGoods
    } = Base,
    case FindTimes > 0 of
        true ->
            SumCostGold = round(FindTimes * CostGold),
            GoodsList1 = [[Gid, Gnum * FindTimes] || {Gid, Gnum} <- FindGoods],
            [44, Name, SumCostGold, GoodsList1];
        false ->
            []
    end;

get_type_info(_Type, _FBSrc, _Base, _Plv) ->
    [].

%%找回
get_findback_src(Player, Type, FindType) ->
    case check_get_findback_src(Player, Type, FindType) of
        {false, Res} ->
            {false, Res};
        {ok, FbSrcList, SumGold} ->
            Now = util:unixtime(),
            St = get_dict(),
            Player1 = ?IF_ELSE(FindType == 2 andalso SumGold > 0, money:add_no_bind_gold(Player, -SumGold, 140, 0, 0), Player),
            F = fun({_T, _Gold, GoodsList, FbSrc}, AccSrcList) ->
                GoodsList1 = [list_to_tuple(Info) || Info <- GoodsList],
                NewFbSrc = FbSrc#fb_src{
                    fb_leave_times = 0,
                    fb_exp_round = {0, 0},
                    fb_dun_ids = [],
                    fb_daily_task_gift = 0,
                    get_daily_task_gift_time = Now,
                    fb_guild_task_gift = 0,
                    get_guild_task_gift_time = Now,
                    last_findback_time = Now
                },
                GetGoodsList =
                    case FindType == 2 of
                        true ->  %%钻石找回 全得
                            GoodsList1;
                        false -> %%免费找回 只得资源物品 一半
                            FreeGoodsIdList = [10101, 10106, 10108, 10199, 1021000, 1022000, 1023000, 1024000],
                            Ff = fun(Gid) ->
                                case lists:keyfind(Gid, 1, GoodsList1) of
                                    false -> [];
                                    {Gid, Gnum} -> [{Gid, util:ceil(Gnum / 2)}]
                                end
                            end,
                            lists:flatmap(Ff, FreeGoodsIdList)

                    end,
                {GetGoodsList, [NewFbSrc | lists:keydelete(FbSrc#fb_src.type, #fb_src.type, AccSrcList)]}
            end,
            {GetGList, NewFbList} = lists:mapfoldl(F, St#st_findback_src.type_list, FbSrcList),
            GetGList1 = lists:flatten(GetGList),
            GetGList2 = goods:merge_goods(GetGList1),
            NewSt = St#st_findback_src{
                type_list = NewFbList
            },
            put_dict(NewSt),
            GetGList3 = goods:make_give_goods_list(140, GetGList2),
            {ok, Player2} = goods:give_goods(Player1, GetGList3),
            get_findback_src_info(Player2),
            GetGList4 = util:list_tuple_to_list(GetGList2),
            activity:get_notice(Player, [90], true),
            {ok, Player2, GetGList4}
    end.
check_get_findback_src(Player, Type, FindType) ->
    St = get_dict(),
    TypeList =
        case Type of
            0 -> data_findback_src:get_all_type();
            _ -> [Type]
        end,
    F = fun(AType) ->
        case findback_type_info(St, AType, Player) of
            [[AType, _Name, SumCostGold, GoodsList] | _] ->
                case GoodsList == [] of
                    true -> [];
                    false ->
                        FBSrc = lists:keyfind(AType, #fb_src.type, St#st_findback_src.type_list),
                        [{AType, SumCostGold, GoodsList, FBSrc}]
                end;
            _ ->
                []
        end
    end,
    FindList = lists:flatmap(F, TypeList),
    SumGold = lists:sum([Gold || {_T, Gold, _G, _Fb} <- FindList]),
    IsEnough = money:is_enough(Player, SumGold, gold),
    if
        not IsEnough andalso FindType == 2 -> {false, 2};
        SumGold == 0 -> {false, 5};
        true ->
            {ok, FindList, SumGold}
    end.

%%功能触发
fb_trigger_src(Player, Type, Args) ->
    FindBackSrcSt = get_dict(),
    #st_findback_src{
        type_list = TypeList
    } = FindBackSrcSt,
    case lists:keyfind(Type, #fb_src.type, TypeList) of
        false ->
            ok;
        FBSrc ->
            Now = util:unixtime(),
            NewFBSrc0 = do_src_trigger(Player, FBSrc, Type, Args),
            NewFBSrc = NewFBSrc0#fb_src{
                last_update_time = Now
            },
            NewTypeList = [NewFBSrc | lists:keydelete(Type, #fb_src.type, TypeList)],
            NewSt = FindBackSrcSt#st_findback_src{
                type_list = NewTypeList
            },
            put_dict(NewSt),
            ok
    end.
do_src_trigger(_Player, FBSrc, 11, PassRound) ->
    FBSrc#fb_src{
        exp_round = PassRound
    };
do_src_trigger(_Player, FBSrc, 17, PassRound) ->
    FBSrc#fb_src{
        guard_round = PassRound
    };
do_src_trigger(_Player, FBSrc, Type, DunIdList) when Type == 12 orelse Type == 13 orelse Type == 14 orelse Type == 15 orelse Type == 16 ->
    case is_list(DunIdList) of
        true -> FBSrc#fb_src{
            pass_dun_ids = DunIdList ++ FBSrc#fb_src.pass_dun_ids
        };
        _ -> FBSrc
    end;

do_src_trigger(_Player, FBSrc, 20, {Times, GetGiftTime}) ->
    FBSrc#fb_src{
        today_use_times = FBSrc#fb_src.today_use_times + Times,
        get_daily_task_gift_time = GetGiftTime
    };
do_src_trigger(_Player, FBSrc, 30, {Times, GetGiftTime}) ->
    FBSrc#fb_src{
        today_use_times = FBSrc#fb_src.today_use_times + Times,
        get_guild_task_gift_time = GetGiftTime
    };
do_src_trigger(_Player, FBSrc, _Type, Times) ->
    FBSrc#fb_src{
        today_use_times = FBSrc#fb_src.today_use_times + Times
    }.

init(Player) ->
    St = findback_load:dbget_findback_src(Player),
    put_dict(St),
    update(Player),
    Player.

logout(Player) ->
    timer_update(Player),
    ok.

timer_update(_Player) ->
    St = get_dict(),
    case St#st_findback_src.is_update_db == 1 of
        true ->
            findback_load:dbup_findback_src(St),
            put_dict(St#st_findback_src{is_update_db = 0}, 0);
        false ->
            skip
    end.

update(Player) ->
    St = get_dict(),
    #st_findback_src{
        type_list = TypeList
    } = St,
    NewTypeList = update_helper(Player, TypeList),
    NewSt = St#st_findback_src{
        type_list = NewTypeList
    },
    put_dict(NewSt),
    ok.
update_helper(Player, TypeList) ->
    Now = util:unixtime(),
    AllType = data_findback_src:get_all_type(),
    update_helper_1(AllType, TypeList, Now, Player, []).
update_helper_1([], _TypeList, _Now, _Player, AccTypeList) -> AccTypeList;
update_helper_1([Type | Tail], TypeList, Now, Player, AccTypeList) ->
    FBSrc =
        case lists:keyfind(Type, #fb_src.type, TypeList) of
            false ->
                #fb_src{
                    type = Type,
                    last_update_time = Now
                };
            FBSrc0 -> FBSrc0
        end,
    #fb_src{
        type = Type,
        last_update_time = LastUpdateTime
    } = FBSrc,
    Base = data_findback_src:get(Type, Player#player.lv),
    if
        Base == [] ->
            update_helper_1(Tail, TypeList, Now, Player, AccTypeList);
        true ->
            DiffDay = util:get_diff_days(Now, LastUpdateTime),
            if
                DiffDay =< 0 -> update_helper_1(Tail, TypeList, Now, Player, [FBSrc | AccTypeList]);
                true ->
                    NewFBSrc0 = do_update(Type, Player, FBSrc, DiffDay),
                    NewFBSrc = NewFBSrc0#fb_src{
                        last_update_time = Now
                    },
                    update_helper_1(Tail, TypeList, Now, Player, [NewFBSrc | AccTypeList])
            end
    end.

do_update(11, Player, FBSrc, DiffDay) ->  %%经验副本
    case DiffDay > 1 of
        true ->
            FBSrc#fb_src{
                fb_exp_round = {1, dungeon_exp:get_sweep_round(Player)},
                exp_round = 0
            };
        false ->
            FBSrc#fb_src{
                fb_exp_round = {FBSrc#fb_src.exp_round + 1, dungeon_exp:get_sweep_round(Player)},
                exp_round = 0
            }
    end;
%%do_update(12, Player, FBSrc, DiffDay) -> %%九霄塔
%%    case DiffDay > 1 of
%%        true ->
%%            FBSrc#fb_src{
%%                fb_dun_ids = dungeon_tower:get_sweep_round(Player),
%%                pass_dun_ids = []
%%            };
%%        false ->
%%            FBSrc#fb_src{
%%                fb_dun_ids = dungeon_tower:get_sweep_round(Player) -- FBSrc#fb_src.pass_dun_ids,
%%                pass_dun_ids = []
%%            }
%%    end;
do_update(Type, Player, FBSrc, DiffDay) when Type == 13 orelse Type == 14 orelse Type == 15 orelse Type == 16 ->
    DunType = get_daily_dun_type(Type),
    case DiffDay > 1 of
        true ->
            FBSrc#fb_src{
                fb_dun_ids = dungeon_daily:get_sweep_round(Player, DunType),
                pass_dun_ids = []
            };
        false ->
            PassDunIds =
                case is_list(FBSrc#fb_src.pass_dun_ids) of
                    true ->
                        lists:filter(fun(Item) -> is_integer(Item) end, FBSrc#fb_src.pass_dun_ids);
                    false -> []
                end,
            FBSrc#fb_src{
                fb_dun_ids = dungeon_daily:get_sweep_round(Player, DunType) -- PassDunIds,
                pass_dun_ids = []
            }
    end;
do_update(17, _Player, FBSrc, DiffDay) ->  %%守护副本
    case DiffDay > 1 of
        true ->
            FBSrc#fb_src{
                fb_guard_round = {1, dungeon_guard:get_can_sweep_round()},
                guard_round = 0
            };
        false ->
            FBSrc#fb_src{
                fb_guard_round = {FBSrc#fb_src.guard_round + 1, dungeon_guard:get_can_sweep_round()},
                guard_round = 0
            }
    end;
do_update(20, Player, FBSrc, DiffDay) ->
    MaxTimes = get_type_times(20, Player),
    case DiffDay > 1 of
        true ->
            FBSrc#fb_src{
                fb_leave_times = MaxTimes,
                today_use_times = 0,
                fb_daily_task_gift = 1,
                get_daily_task_gift_time = 0
            };
        false ->
            Now = util:unixtime(),
            IsGet =
                case util:get_diff_days(Now, FBSrc#fb_src.get_daily_task_gift_time) > 1 of
                    true -> 1;
                    false -> 0
                end,
            FBSrc#fb_src{
                fb_leave_times = max(0, MaxTimes - FBSrc#fb_src.today_use_times),
                today_use_times = 0,
                fb_daily_task_gift = IsGet,
                get_daily_task_gift_time = 0
            }
    end;
do_update(25, Player, FBSrc, DiffDay) ->
    MaxTimes = get_type_times(25, Player),
    case DiffDay > 1 of
        true ->
            FBSrc#fb_src{
                fb_leave_times = MaxTimes,
                today_use_times = 0
            };
        false ->
            FBSrc#fb_src{
                fb_leave_times = max(0, MaxTimes - FBSrc#fb_src.today_use_times),
                today_use_times = 0
            }
    end;
do_update(30, Player, FBSrc, DiffDay) ->
    MaxTimes = get_type_times(30, Player),
    case DiffDay > 1 of
        true ->
            FBSrc#fb_src{
                fb_leave_times = MaxTimes,
                today_use_times = 0,
                fb_guild_task_gift = 1,
                get_guild_task_gift_time = 0
            };
        false ->
            Now = util:unixtime(),
            IsGet =
                case util:get_diff_days(Now, FBSrc#fb_src.get_guild_task_gift_time) > 1 of
                    true -> 1;
                    false -> 0
                end,
            FBSrc#fb_src{
                fb_leave_times = max(0, MaxTimes - FBSrc#fb_src.today_use_times),
                today_use_times = 0,
                fb_guild_task_gift = IsGet,
                get_guild_task_gift_time = 0
            }
    end;
do_update(Type, _Player, FBSrc, _DiffDay) when Type >= 31 andalso Type =< 37 -> %%玩法活动
    LastOpenTime =
        case ets:lookup(?ETS_FINDBACK_ACT_TIME, Type) of
            [] -> 0;
            [FbAct | _] -> FbAct#fd_act_time.last_open_time
        end,
    case FBSrc#fb_src.last_update_time >= LastOpenTime of
        true ->
            FBSrc;
        false ->
            FBSrc#fb_src{
                fb_leave_times = 1,
                today_use_times = 0
            }
    end;
do_update(44, Player, FBSrc, DiffDay) ->
    MaxTimes = get_type_times(44, Player),
    case DiffDay > 1 of
        true ->
            FBSrc#fb_src{
                fb_leave_times = MaxTimes,
                today_use_times = 0
            };
        false ->
            FBSrc#fb_src{
                fb_leave_times = max(0, MaxTimes - FBSrc#fb_src.today_use_times),
                today_use_times = 0
            }
    end;
do_update(Type, Player, FBSrc, DiffDay) ->
    MaxTimes = get_type_times(Type, Player),
    case DiffDay > 1 of
        true ->
            FBSrc#fb_src{
                fb_leave_times = MaxTimes,
                today_use_times = 0
            };
        false ->
            FBSrc#fb_src{
                fb_leave_times = max(0, MaxTimes - FBSrc#fb_src.today_use_times),
                today_use_times = 0
            }
    end.


%%获取各功能每天的可完成次数
get_type_times(Type, _Player) ->
    if
        Type >= 1 andalso Type =< 10 -> 1;
        Type == 20 -> 20;
        Type == 25 -> 20;
        Type == 30 -> 20;
        Type == 44 -> 40;
        Type == 45 -> 1;
        Type == 46 -> 1;
        true -> 0
    end.

get_dict() ->
    lib_dict:get(?PROC_STATUS_FINDBACK_SRC).

put_dict(St) ->
    put_dict(St, 1).
put_dict(St, IsUpdate) ->
    lib_dict:put(?PROC_STATUS_FINDBACK_SRC, St#st_findback_src{is_update_db = IsUpdate}).

%%日常副本类型转换
get_daily_dun_type(FbType) ->
    case FbType of
        13 -> 1;
        14 -> 2;
        15 -> 3;
        _ -> 4
    end.
