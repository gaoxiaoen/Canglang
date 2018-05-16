%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 爱情树
%%% @end
%%% Created : 10. 七月 2017 14:06
%%%-------------------------------------------------------------------
-module(marry_tree).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("marry.hrl").

%% API
-export([
    init/1,
    init_ets/0,

    get_marry_tree_lv/0,
    get_marry_tree_attri/0,

    get_info/1,
    upgrade_stage/2,
    update_ta_att/2,
    gm_lv/2,
    recv_tree_reward/3,
    get_notice/1
]).

gm_lv(Lv, Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    NewSt = St#st_marry_tree{lv = Lv},
    Attri = count_attri(NewSt, Player),
    Cbp = attribute_util:calc_combat_power(Attri),
    lib_dict:put(?PROC_STATUS_MARRY_TREE, NewSt#st_marry_tree{attri = Attri, cbp = Cbp}),
    Ets = #ets_marry_tree{pkey = Player#player.key, lv = Lv},
    ets:insert(?ETS_MARRY_TREE, Ets),
    NewPlayer = player_util:count_player_attribute(Player, true),
    NewPlayer.

init_ets() ->
    ets:new(?ETS_MARRY_TREE, [{keypos, #ets_marry_tree.pkey} | ?ETS_OPTIONS]),
    ok.

init(#player{key = Pkey} = Player) ->
    StMarryTree =
        case player_util:is_new_role(Player) of
            true ->
                #st_marry_tree{pkey = Pkey};
            false ->
                marry_load:dbget_marry_tree(Pkey)
        end,
    Attri = count_attri(StMarryTree, Player),
    Cbp = attribute_util:calc_combat_power(Attri),
    case player_util:is_new_role(Player) of
        true -> skip;
        false ->
            ?IF_ELSE(Cbp /= StMarryTree#st_marry_tree.cbp andalso StMarryTree#st_marry_tree.cbp /= 0, player:apply_state(async, self(), {marry_tree, update_ta_att, []}), skip)
    end,
    lib_dict:put(?PROC_STATUS_MARRY_TREE, StMarryTree#st_marry_tree{attri = Attri, cbp = Cbp}),
    Player.

count_attri(StMarryTree, Player) ->
    #st_marry_tree{lv = Lv} = StMarryTree,
    #base_marry_tree{attri = Attri} = data_marry_tree:get(min(Lv, data_marry_tree:get_max_lv())),
    case Player#player.marry#marry.mkey == 0 of
        true ->
            attribute_util:make_attribute_by_key_val_list(Attri);
        false ->
            Pkey = Player#player.marry#marry.couple_key,
            BasePercent =
                case ets:lookup(?ETS_MARRY_TREE, Pkey) of
                    [] ->
                        St = marry_load:dbget_marry_tree(Pkey),
                        ets:insert(?ETS_MARRY_TREE, #ets_marry_tree{pkey = Pkey, lv = St#st_marry_tree.lv}),
                        MinLv = min(Lv, St#st_marry_tree.lv),
                        data_marry_tree_attri:get(MinLv);
                    [#ets_marry_tree{lv = Lv2}] ->
                        MinLv = min(Lv, Lv2),
                        data_marry_tree_attri:get(MinLv)
                end,
            F = fun({Key, Val}) -> {Key, round(Val * (10000 + BasePercent) / 10000)} end,
            NewAttri = lists:map(F, Attri),
            attribute_util:make_attribute_by_key_val_list(NewAttri)
    end.

get_marry_tree_lv() ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    St#st_marry_tree.lv.

get_marry_tree_attri() ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    St#st_marry_tree.attri.

get_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    MyLv = St#st_marry_tree.lv,
    MyExp = St#st_marry_tree.exp,
    MyCbp = St#st_marry_tree.cbp,
    TreeRewardList = St#st_marry_tree.tree_reward_list,
    case Player#player.marry#marry.mkey == 0 of
        true ->
            TaLv = 0, Percent = 0, Percent2 = 0;
        false ->
            Pkey = Player#player.marry#marry.couple_key,
            case ets:lookup(?ETS_MARRY_TREE, Pkey) of
                [] ->
                    St2 = marry_load:dbget_marry_tree(Pkey),
                    ets:insert(?ETS_MARRY_TREE, #ets_marry_tree{pkey = St2#st_marry_tree.pkey, lv = St2#st_marry_tree.lv}),
                    TaLv = St2#st_marry_tree.lv;
                [Ets] ->
                    TaLv = Ets#ets_marry_tree.lv
            end,
            Percent = data_marry_tree_attri:get(min(MyLv, TaLv)),
            Percent2 = data_marry_tree_attri:get(min(min(MyLv + 1, TaLv + 1), data_marry_tree:get_max_lv()))
    end,
    #base_marry_tree{cost = BaseCost, reward_list = RewardList} = data_marry_tree:get(MyLv),
    ProRewardList = lists:map(fun({Id0, Num0}) -> [Id0, Num0] end, RewardList),
    AttriPack = attribute_util:pack_attr(St#st_marry_tree.attri),
    Lv3 = min(min(MyLv, TaLv) + 1, data_marry_tree:get_max_lv()),
    BaseTreeRewardList = get_base_marry_tree(),
    Now = util:unixtime(),
    FF = fun(#base_marry_tree{lv = Lv, cd_time = CdTime}) ->
        case lists:keyfind(Lv, 1, TreeRewardList) of
            false ->
                [Lv, 0];
            {Lv, RecvTime} ->
                [Lv, max(0, RecvTime + CdTime - Now)]
        end
    end,
    ProRewardList99 = lists:map(FF, BaseTreeRewardList),
    ?DEBUG("ProRewardList99:~p", [ProRewardList99]),
    {MyLv, TaLv, Lv3, Percent, Percent2, BaseCost, MyExp, MyCbp, ProRewardList, AttriPack, ProRewardList99}.

get_base_marry_tree() ->
    F = fun(Lv) ->
        Base = data_marry_tree:get(Lv),
        if
            Base#base_marry_tree.tree_reward /= [] -> [Base];
            true -> []
        end
    end,
    lists:flatmap(F, [5, 20, 50, 100, 150, 200]).

upgrade_stage(Player, UpgradeNum) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    F = fun(_N, {AccCount, AccCode, AccPlayer, AccCost}) ->
        case AccCode of
            1 ->
                {NewAccCode, NewAccPlayer, NewAccCost} = upgrade_stage2(AccPlayer, AccCost),
                {AccCount + 1, NewAccCode, NewAccPlayer, NewAccCost};
            _ ->
                {AccCount, AccCode, AccPlayer, AccCost}
        end
    end,
    {ResultCount, Code, NPlayer, SumCost} = lists:foldl(F, {0, 1, Player, 0}, lists:seq(1, UpgradeNum)),
    if
        ResultCount == 1 andalso Code /= 1 -> {Code, NPlayer}; %% 首次升级失败
        true ->
            NewSt = lib_dict:get(?PROC_STATUS_MARRY_TREE),
            marry_load:dbup_marry_tree(NewSt),
            NewPlayer = player_util:count_player_attribute(NPlayer, true),
            {ok, _} = goods:subtract_good(Player, [{?MARRY_TREE_SEED, SumCost}], 665),
            Sql = io_lib:format("insert into log_marry_tree set pkey=~p, befor_lv=~p, after_lv=~p, befor_exp=~p, after_exp=~p, goods_id=~p, goods_num=~p,time=~p",
                [Player#player.key, St#st_marry_tree.lv, NewSt#st_marry_tree.lv, St#st_marry_tree.exp, NewSt#st_marry_tree.exp, ?MARRY_TREE_SEED, SumCost, util:unixtime()]),
            log_proc:log(Sql),
            if
                NewSt#st_marry_tree.lv /= St#st_marry_tree.lv ->
                    update_ta(Player#player.marry#marry.couple_key),
                    {1, NewPlayer};
                true ->
                    {1, Player}
            end
    end.

upgrade_stage2(Player, SumCost) ->
    case check_upgrade_stage(Player, SumCost) of
        {fail, Code} -> {Code, Player, SumCost};
        true ->
            St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
            #st_marry_tree{exp = Exp} = St,
            #base_marry_tree{cost = Cost, reward_list = RewardList} = data_marry_tree:get(min(St#st_marry_tree.lv, data_marry_tree:get_max_lv())),
            St1 = St#st_marry_tree{exp = Exp + Cost},
            NewSt = cacl(St1, Player),
            lib_dict:put(?PROC_STATUS_MARRY_TREE, NewSt),
            Ets = #ets_marry_tree{pkey = Player#player.key, lv = NewSt#st_marry_tree.lv},
            ets:insert(?ETS_MARRY_TREE, Ets),
            if
                NewSt#st_marry_tree.lv /= St#st_marry_tree.lv ->
                    RewardGoodsList = goods:make_give_goods_list(666, RewardList),
                    {ok, NewPlayer} = goods:give_goods(Player, RewardGoodsList),
                    {1, NewPlayer, SumCost + Cost};
                true ->
                    {1, Player, SumCost + Cost}
            end
    end.

update_ta(Pkey) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> ok;
        [#ets_online{pid = Pid}] ->
            player:apply_state(async, Pid, {marry_tree, update_ta_att, []})
    end.

update_ta_att(_, Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    NewSt = cacl(St, Player),
    lib_dict:put(?PROC_STATUS_MARRY_TREE, NewSt),
    marry_load:dbup_marry_tree(NewSt),
    NewPlayer = player_util:count_player_attribute(Player, true),
    marry_rpc:handle(29101, NewPlayer, {}),
    {ok, NewPlayer}.

cacl(St, Player) ->
    #st_marry_tree{exp = Exp, lv = Lv} = St,
    #base_marry_tree{exp = BaseExp} = data_marry_tree:get(min(Lv, data_marry_tree:get_max_lv())),
    case Exp >= BaseExp of
        false ->
            St;
        true ->
            NSt = St#st_marry_tree{lv = min(Lv + 1, data_marry_tree:get_max_lv()), exp = Exp - BaseExp},
            Attri = count_attri(NSt, Player),
            NSt#st_marry_tree{attri = Attri, cbp = attribute_util:calc_combat_power(Attri)}
    end.

check_upgrade_stage(Player, SumCost) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    #base_marry_tree{cost = Cost} = data_marry_tree:get(min(St#st_marry_tree.lv, data_marry_tree:get_max_lv())),
    Count = goods_util:get_goods_count(?MARRY_TREE_SEED),
    MaxLv = data_marry_tree:get_max_lv(),
    if
        Player#player.marry#marry.mkey == 0 -> {fail, 4}; %% 当前没有伴侣
        St#st_marry_tree.lv == MaxLv -> {fail, 3}; %% 已经最高阶级
        Cost > Count - SumCost -> {fail, 2}; %% 情缘种子不足
        true -> true
    end.

recv_tree_reward(Player, RecvLv, 0) ->
    recv_tree_reward2(Player, RecvLv, 0, 0);

recv_tree_reward(Player, RecvLv, 1) ->
    Cost = 20,
    case money:is_enough(Player, Cost, gold) of
        true ->
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 734, 0, 0),
            recv_tree_reward2(NewPlayer, RecvLv, 1, Cost);
        false ->
            {5, Player}
    end.

recv_tree_reward2(Player, RecvLv, Type, Cost) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    #st_marry_tree{tree_reward_list = TreeRewardList, lv = TreeLv} = St,
    Now = util:unixtime(),
    case lists:keytake(RecvLv, 1, TreeRewardList) of
        false ->
            if
                TreeLv < RecvLv -> {6, Player}; %% 未达成
                true ->
                    #base_marry_tree{tree_reward = BaseTreeReward} = data_marry_tree:get(RecvLv),
                    NewSt = St#st_marry_tree{tree_reward_list = [{RecvLv, Now} | TreeRewardList]},
                    marry_load:dbup_marry_tree(NewSt),
                    lib_dict:put(?PROC_STATUS_MARRY_TREE, NewSt),
                    F = fun({Gid, Gnum, Power}) -> {{Gid, Gnum}, Power} end,
                    LL = lists:map(F, BaseTreeReward),
                    Reward = util:list_rand_ratio(LL),
                    if
                        Type == 1 ->
                            Sql = io_lib:format("insert into log_marry_tree_reward set pkey=~p, recv_lv=~p, cost=~p, reward='~s', time=~p",
                                [Player#player.key, RecvLv, Cost, util:term_to_bitstring([Reward, Reward]), util:unixtime()]),
                            GiveGoodsList = goods:make_give_goods_list(735, [Reward, Reward]);
                        true ->
                            Sql = io_lib:format("insert into log_marry_tree_reward set pkey=~p, recv_lv=~p, cost=~p, reward='~s', time=~p",
                                [Player#player.key, RecvLv, Cost, util:term_to_bitstring([Reward]), util:unixtime()]),
                            GiveGoodsList = goods:make_give_goods_list(735, [Reward])
                    end,
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(Player, [173], true),
                    log_proc:log(Sql),
                    {1, NewPlayer}
            end;
        {value, {RecvLv, RecvTime}, Rest} ->
            #base_marry_tree{tree_reward = BaseTreeReward, cd_time = CdTime} = data_marry_tree:get(RecvLv),
            if
                RecvTime + CdTime > Now -> {7, Player}; %% CD时间不足
                true ->
                    NewSt = St#st_marry_tree{tree_reward_list = [{RecvLv, Now} | Rest]},
                    marry_load:dbup_marry_tree(NewSt),
                    lib_dict:put(?PROC_STATUS_MARRY_TREE, NewSt),
                    F = fun({Gid, Gnum, Power}) -> {{Gid, Gnum}, Power} end,
                    LL = lists:map(F, BaseTreeReward),
                    Reward = util:list_rand_ratio(LL),
                    if
                        Type == 1 ->
                            Sql = io_lib:format("insert into log_marry_tree_reward set pkey=~p, recv_lv=~p, cost=~p, reward='~s', time=~p",
                                [Player#player.key, RecvLv, Cost, util:term_to_bitstring([Reward, Reward]), util:unixtime()]),
                            GiveGoodsList = goods:make_give_goods_list(735, [Reward, Reward]);
                        true ->
                            Sql = io_lib:format("insert into log_marry_tree_reward set pkey=~p, recv_lv=~p, cost=~p, reward='~s', time=~p",
                                [Player#player.key, RecvLv, Cost, util:term_to_bitstring([Reward]), util:unixtime()]),
                            GiveGoodsList = goods:make_give_goods_list(735, [Reward])
                    end,
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(Player, [173], true),
                    log_proc:log(Sql),
                    {1, NewPlayer}
            end
    end.


get_notice(_Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_TREE),
    #st_marry_tree{tree_reward_list = TreeRewardList, lv = TreeLv} = St,
    Now = util:unixtime(),
    F = fun(RecvLv) ->
        case lists:keytake(RecvLv, 1, TreeRewardList) of
            false ->
                if
                    TreeLv < RecvLv -> []; %% 未达成
                    true -> [1]
                end;
            {value, {RecvLv, RecvTime}, _Rest} ->
                #base_marry_tree{cd_time = CdTime} = data_marry_tree:get(RecvLv),
                if
                    RecvTime + CdTime > Now -> []; %% CD时间不足
                    true -> [1]
                end
        end
    end,
    LL = lists:flatmap(F, [5, 20, 50, 100, 150, 200]),
    ?IF_ELSE(LL == [], 0, 1).