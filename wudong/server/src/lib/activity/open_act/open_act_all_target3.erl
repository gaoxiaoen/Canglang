%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 全服总动员
%%% @end
%%% Created : 28. 二月 2017 11:08
%%%-------------------------------------------------------------------
-module(open_act_all_target3).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("mount.hrl").
-include("wing.hrl").
-include("light_weapon.hrl").
-include("magic_weapon.hrl").
-include("pet_weapon.hrl").
-include("pet.hrl").
-include("footprint_new.hrl").
-include("cat.hrl").
-include("golden_body.hrl").

%% API
-export([
    init/1,
    init/0,
    init_ets/0,
    init_login/1,
    act_target/3,
    act_target_cast/3,
    act_target_init/0,
    act_target_init_cast/0,
    sys_midnight_refresh/0,
    midnight_refresh/1,

    get_act_info/1,
    recv/4,
    get_state/1,
    get_act/0,
    get_sub_act_type/0
]).

init_ets() ->
    ets:new(?ETS_OPEN_ALL_TARGET3, [{keypos, #ets_open_all_target.key} | ?ETS_OPTIONS]).

init() ->
    case get_act() of
        [] ->
            skip;
        #base_open_all_target{act_id = BaseActId, list = BaseList} ->
            DbList = activity_load:dbget_all_open_act_all_target3(BaseActId),
            F = fun({ActType, BaseLv, BaseNum, _GiftId}) ->
                F0 = fun({ActId0, ActType0, BaseLv0, BaseNum0, _Num0}) ->
                    BaseActId == ActId0 andalso ActType == ActType0 andalso BaseLv == BaseLv0 andalso BaseNum == BaseNum0
                end,
                L = lists:filter(F0, DbList),
                Ets =
                    #ets_open_all_target{
                        act_id = BaseActId,
                        act_type = ActType,
                        base_lv = BaseLv,
                        base_num = BaseNum,
                        key = {BaseActId, ActType, BaseLv, BaseNum}
                    },
                if
                    L == [] ->
                        ets:insert(?ETS_OPEN_ALL_TARGET3, Ets);
                    true ->
                        {_BaseActId, _ActType, _BaseLv, _BaseNum, Num} = hd(L),
                        NewEts = Ets#ets_open_all_target{num = Num},
                        ets:insert(?ETS_OPEN_ALL_TARGET3, NewEts)
                end
            end,
            lists:map(F, BaseList)
    end,
    ok.

init(#player{key = Pkey} = Player) ->
    StOpenActAllTarget =
        case player_util:is_new_role(Player) of
            true -> #st_open_act_all_target3{pkey = Pkey};
            false -> activity_load:dbget_open_act_all_target3(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_OPEN_ALL_TARGET3, StOpenActAllTarget),
    update_open_act_all_target(),
    Player.

init_login(#player{key = Pkey}) ->
    case get_act() of
        [] ->
            skip;
        _ ->
            F = fun(Type) ->
                Lv = get_stage(Type),
                ?CAST(activity_proc:get_act_pid(), {update_open_act_all_target3, Pkey, Type, Lv})
            end,
            lists:map(F, ?OPEN_ALL_TARGET_LIST)
    end.

get_stage(Type) ->
    open_act_all_target:get_stage(Type).

update_open_act_all_target() ->
    StOpenActAllTarget = lib_dict:get(?PROC_STATUS_OPEN_ALL_TARGET3),
    #st_open_act_all_target3{
        pkey = Pkey,
        act_id = ActId
    } = StOpenActAllTarget,
    case get_act() of
        [] ->
            NewStOpenActAllTarget = #st_open_act_all_target3{pkey = Pkey};
        #base_open_all_target{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStOpenActAllTarget = #st_open_act_all_target3{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStOpenActAllTarget = StOpenActAllTarget
            end
    end,
    lib_dict:put(?PROC_STATUS_OPEN_ALL_TARGET3, NewStOpenActAllTarget).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_open_act_all_target().

get_act_info(_Player) ->
    update_open_act_all_target(),
    StOpenActAllTarget = lib_dict:get(?PROC_STATUS_OPEN_ALL_TARGET3),
    #st_open_act_all_target3{recv_list = RecvList} = StOpenActAllTarget,
    case get_act() of
        [] ->
            {0, 1, []};
        #base_open_all_target{act_id = BaseActId, list = BaseList, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            F = fun({ActType, BaseLv, BaseNum, GiftId}) ->
                Ets = lookup(BaseActId, ActType, BaseLv, BaseNum),
                Num = Ets#ets_open_all_target.num,
                State =
                    if
                        Num < BaseNum -> 0;
                        true ->
                            ?IF_ELSE(lists:member({ActType, BaseLv, BaseNum}, RecvList) == false, 1, 2)
                    end,
                [ActType, BaseLv, BaseNum, Num, GiftId, State]
            end,
            List = lists:map(F, BaseList),
            {Type, _BaseLv, _BaseNum, _GiftId} = hd(BaseList),
            Lv = get_stage(Type),
            {LTime, Lv, List}
    end.

recv(Player, ActType, BaseLv, BaseNum) ->
    update_open_act_all_target(),
    StOpenActAllTarget = lib_dict:get(?PROC_STATUS_OPEN_ALL_TARGET3),
    #st_open_act_all_target3{recv_list = RecvList} = StOpenActAllTarget,
    case get_act() of
        [] ->
            {4, Player};
        #base_open_all_target{list = BaseList, act_id = BaseActId} ->
            State = lists:member({ActType, BaseLv, BaseNum}, RecvList),
            F1 = fun({ActType1, BaseLv1, BaseNum1, _GiftId}) ->
                ActType1 == ActType andalso BaseLv1 == BaseLv andalso BaseNum1 == BaseNum
            end,
            L1 = lists:filter(F1, BaseList),
            Ets = lookup(BaseActId, ActType, BaseLv, BaseNum),
            if
                Ets#ets_open_all_target.num < BaseNum -> {2, Player}; %% 人数不足，还不能领取
                State == true -> {3, Player}; %% 已领取
                L1 == [] -> {0, Player}; %% 配置错误
                true ->
                    {_ActType, _BaseLv, _BaseNum, GiftId} = hd(L1),
                    GiveGoodsList = goods:make_give_goods_list(672, [{GiftId, 1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    NewStOpenActAllTarget =
                        StOpenActAllTarget#st_open_act_all_target3{
                            recv_list = [{ActType, BaseLv, BaseNum} | RecvList]
                        },
                    lib_dict:put(?PROC_STATUS_OPEN_ALL_TARGET3, NewStOpenActAllTarget),
                    activity_load:dbup_open_act_all_target3(NewStOpenActAllTarget),
                    activity:get_notice(Player, [33], true),
                    {1, NewPlayer}
            end
    end.

get_state(_Player) ->
    update_open_act_all_target(),
    StOpenActAllTarget = lib_dict:get(?PROC_STATUS_OPEN_ALL_TARGET3),
    #st_open_act_all_target3{recv_list = RecvList} = StOpenActAllTarget,
    case get_act() of
        [] ->
            -1;
        #base_open_all_target{act_id = BaseActId, list = BaseList} ->
            F = fun({ActType, BaseLv, BaseNum, _GiftId}) ->
                Ets = lookup(BaseActId, ActType, BaseLv, BaseNum),
                Num = Ets#ets_open_all_target.num,
                if
                    Num < BaseNum -> [];
                    true ->
                        ?IF_ELSE(lists:member({ActType, BaseLv, BaseNum}, RecvList) == false, [1], [])
                end
            end,
            List = lists:flatmap(F, BaseList),
            ?IF_ELSE(List == [], 0, 1)
    end.

act_target_init() ->
    ?CAST(activity_proc:get_act_pid(), act_target_init3).

act_target_init_cast() ->
    case get_act() of
        [] ->
            skip;
        #base_open_all_target{list = List, act_id = BaseActId} ->
            {ActType0, _BaseLv0, _BaseNum0, _GiftId0} = hd(List),
            Sql = get_sql(ActType0),
            case db:get_all(Sql) of
                [] ->
                    skip;
                Rows when is_list(Rows) ->
                    F = fun([Pkey, Args]) ->
                        F2 = fun({ActType, BaseLv, BaseNum, _GiftId}) ->
                            if
                                Args < BaseLv -> true;
                                true -> act_target(Pkey, BaseActId, ActType, BaseLv, BaseNum, false), false
                            end
                        end,
                        lists:any(F2, List)
                    end,
                    lists:map(F, Rows)
            end
    end,
    ok.

%% 激活目标
act_target(Pkey, ActType, Lv) ->
    ?CAST(activity_proc:get_act_pid(), {update_open_act_all_target3, Pkey, ActType, Lv}).

act_target_cast(Pkey, ActType, Lv) ->
    case get_act() of
        [] ->
            ok;
        #base_open_all_target{act_id = BaseActId, list = BaseList} ->
            F = fun({ActType0, BaseLv0, _BaseNum0, _GiftId}) ->
                ActType0 == ActType andalso Lv >= BaseLv0
            end,
            %% 选出合格人数
            List = lists:filter(F, BaseList),
            F2 = fun({ActType0, BaseLv0, BaseNum0, _GiftId}) ->
                act_target(Pkey, BaseActId, ActType0, BaseLv0, BaseNum0, true)
            end,
            lists:map(F2, List)
    end.

act_target(Pkey, BaseActId, ActType, BaseLv, BaseNum, IsDb) ->
    Ets = lookup(BaseActId, ActType, BaseLv, BaseNum),
    #ets_open_all_target{
        num = Num,
        player_list = PlayerList
    } = Ets,
    case lists:keyfind(Pkey, 1, PlayerList) of
        false ->
            NewEts = Ets#ets_open_all_target{num = Num + 1, player_list = [{Pkey, BaseLv} | PlayerList]},
            ets:insert(?ETS_OPEN_ALL_TARGET3, NewEts),
            ?IF_ELSE(IsDb == true, activity_load:dbup_open_act_all_target_ets3(NewEts), skip);
        _ -> %% 避免重复计算玩家数量
            skip
    end.

%% 系统晚上12点刷新
sys_midnight_refresh() ->
    case get_act() of
        [] ->
            ets:delete_all_objects(?ETS_OPEN_ALL_TARGET3);
        #base_open_all_target{act_id = BaseActId} ->
            List = ets:tab2list(?ETS_OPEN_ALL_TARGET3),
            if
                List == [] -> skip;
                true ->
                    Ets = hd(List),
                    if
                        Ets#ets_open_all_target.act_id =:= BaseActId -> skip;
                        true -> ets:delete_all_objects(?ETS_OPEN_ALL_TARGET3)
                    end
            end,
            %% 重新load数据
            act_target_init()
    end.

lookup(BaseActId, ActType, BaseLv, BaseNum) ->
    Key = {BaseActId, ActType, BaseLv, BaseNum},
    case ets:lookup(?ETS_OPEN_ALL_TARGET3, Key) of
        [] ->
            Ets =
                #ets_open_all_target{
                    act_id = BaseActId,
                    act_type = ActType,
                    base_lv = BaseLv,
                    base_num = BaseNum,
                    key = {BaseActId, ActType, BaseLv, BaseNum}
                },
            ets:insert(?ETS_OPEN_ALL_TARGET3, Ets),
            Ets;
        [EtsRecord] ->
            EtsRecord
    end.

get_act() ->
    case activity:get_work_list(data_open_all_target3) of
        [] -> [];
        [Base | _] -> Base
    end.

get_sub_act_type() ->
    case get_act() of
        [] ->
            0;
        #base_open_all_target{list = BaseList} ->
            {ActType, _, _, _} = hd(BaseList),
            ActType
    end.

get_sql(ActType) ->
    open_act_all_target:get_sql(ActType).