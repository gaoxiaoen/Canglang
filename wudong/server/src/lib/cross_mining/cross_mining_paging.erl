%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 矿洞进程
%%% @end
%%% Created : 09. 四月 2018 上午11:41
%%%-------------------------------------------------------------------
-module(cross_mining_paging).
-author("luobaqun").
-include("server.hrl").
-include("common.hrl").
-include("cross_mining.hrl").

-behaviour(gen_server).
-define(MINE_COUNT_LIMIT, 3).

%% API
-export([
    start/3,
    info/2
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-define(UPDATE_TIEM, 10).

start(Type, Page, MineList) ->
    gen_server:start(?MODULE, [Type, Page, MineList], []).

init([Type, Page, MineList]) ->
    Ref = erlang:send_after(?UPDATE_TIEM * 1000, self(), timer_update),
    lists:foreach(fun(Ets) -> cross_mining_util:insert_ets(Ets) end, MineList),
    {ok, #st_cross_mining{type = Type, page = Page, ref = Ref}}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.


handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Request, State) ->
    case catch info(Request, State) of
        {stop, NewState} ->
            {stop, normal, NewState};
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross_mining_paging info ~p/~p~n", [Request, Reason]),
            {noreply, State}
    end.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 获取分矿信息
info({get_mine_info, Node, Sid, Pid, Pkey, MaxPage}, State) ->
    List = cross_mining_util:make_mine_info_60401(cross_mining_util:get_ets_by_type_page(State#st_cross_mining.type, State#st_cross_mining.page)),
    AttList = cross_mining_util:get_att_list(Pkey),

    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    Ids = data_mining_retime:get_all(),
    TimeList = lists:map(fun(Id) -> data_mining_retime:get(Id) end, Ids),

    F = fun({H0, M0}) ->
        if
            H0 > H -> [{H0, M0}];
            H0 == H andalso M0 > M -> [{H0, M0}];
            true -> []
        end

        end,
    {NextTimeH, NextTimeM} =
        case lists:flatmap(F, TimeList) of
            [] -> hd(TimeList);
            TimeList0 ->
                hd(TimeList0)
        end,
    Data = {MaxPage, State#st_cross_mining.type, State#st_cross_mining.page, NextTimeH, NextTimeM, AttList, List},
    {ok, Bin} = pt_604:write(60401, Data),
    server_send:send_to_sid(Node, Sid, Bin),
    NewSeeList = %% 加入观察列表
    case lists:keytake(Pkey, 1, State#st_cross_mining.see_list) of
        false ->
            [{Pkey, Pid, Sid} | lists:sublist(State#st_cross_mining.see_list, 100)];
        {value, _, T} ->
            [{Pkey, Pid, Sid} | lists:sublist(T, 100)]
    end,
    {noreply, State#st_cross_mining{see_list = NewSeeList}};

%% 退出矿洞
info({exit_mine, Node, Sid, Pkey}, State) ->
    NewSeeList = lists:keydelete(Pkey, 1, State#st_cross_mining.see_list),
    {ok, Bin} = pt_604:write(60407, {1}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State#st_cross_mining{see_list = NewSeeList}};

%% 手动领取
info({get_mine_reward, Node, Sid, Type, Page, Id, Pkey, Pid}, State) ->
    Res =
        case cross_mining_util:get_ets_by_key({Type, Page, Id}) of
            [] -> 2;
            MineralInfo ->
                Now = util:unixtime(),
                if
                    MineralInfo#mineral_info.hold_key =/= Pkey -> 9; %% 未占领
                    MineralInfo#mineral_info.ripe_time > Now -> 10; %% 未成熟
                    MineralInfo#mineral_info.end_time < Now -> 2; %% 已消失
                    true ->
                        cross_mining_util:delete_mine(MineralInfo), %% 先删除再发奖
                        Base = data_mineral_info:get(MineralInfo#mineral_info.mtype),
                        Reward = cross_mining_util:get_hold_time_reward(MineralInfo#mineral_info.ripe_time - MineralInfo#mineral_info.last_hold_time, Base#base_mineral_info.reward),
                        if
                            MineralInfo#mineral_info.is_hit == 0 ->
                                cross_mining_notice:notice_sys(#mineral_info{type = MineralInfo#mineral_info.type, page = MineralInfo#mineral_info.page, id = MineralInfo#mineral_info.id, hold_key = Pkey}, State#st_cross_mining.see_list),
                                cross_mining_notice:log_cross_mine_get_mine_reward(Pkey, ?LOG_TYPE1, 0, Type, Page, Id, Reward),
                                Pid ! {give_goods, Reward, 356};
                            true ->
                                cross_mining_notice:notice_sys(#mineral_info{type = MineralInfo#mineral_info.type, page = MineralInfo#mineral_info.page, id = MineralInfo#mineral_info.id, hold_key = Pkey}, State#st_cross_mining.see_list),
                                cross_mining_notice:log_cross_mine_get_mine_reward(Pkey, ?LOG_TYPE1, 1, Type, Page, Id, [{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- Reward]),
                                Pid ! {give_goods, [{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- Reward], 356}
                        end,
                        1
                end
        end,
    {ok, Bin} = pt_604:write(60405, {Res}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};


%% 援助
info({cross_help_friend, Node, Sid, Pid, MyKey, Type, Page, Id, _Pkey, HelpInfo}, State) ->
    Res =
        case cross_mining_util:get_ets_by_key({Type, Page, Id}) of
            [] -> 2;
            MineralInfo ->
                case lists:keyfind(MyKey,#help_info.pkey,MineralInfo#mineral_info.help_list) of
                     false ->
                         Len = length(MineralInfo#mineral_info.help_list),
                         case data_mineral_info:get(MineralInfo#mineral_info.mtype) of
                              [] ->0;
                             #base_mineral_info{help_limit = HelpLimit} ->
                                 if
                                     Len >= HelpLimit -> 23;
                                     true ->
                                         List = lists:seq(1, Len + 1),
                                         Ids = [X#help_info.id || X <- MineralInfo#mineral_info.help_list],
                                         NewId = hd(List --Ids),
                                         NewMineralInfo = MineralInfo#mineral_info{help_list = [HelpInfo#help_info{id = NewId} | MineralInfo#mineral_info.help_list]},
                                         cross_mining_util:insert_ets(NewMineralInfo),
                                         cross_mining_notice:notice_sys(NewMineralInfo, State#st_cross_mining.see_list),
                                         Pid ! {update_cross_help_att, 0, 1},
                                         1
                                 end
                         end;
                    _ ->
                        24
                end
        end,
    ?DEBUG("Res ~p~n",[Res]),
    {ok, Bin} = pt_604:write(60420, {Res}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

%% 进攻小偷
info({att_thief, Node, Sid, Type, Page, Id, Pkey, Pname, Cbp, Sn, Vip, Dvip}, State) ->
    {Res, RewardList} =
        case cross_mining_util:get_ets_by_key({Type, Page, Id}) of
            [] ->
                {2, []};
            MineralInfo ->
                Now = util:unixtime(),
                if
                    MineralInfo#mineral_info.thief_end_time < Now -> {7, []}; %%小偷不存在
                    Cbp < MineralInfo#mineral_info.thief_cbp -> {8, []}; %% 战力不足
                    true -> %% 进攻成功
                        NewMineralInfo =
                            MineralInfo#mineral_info{
                                thief_start_time = 0,
                                thief_end_time = 0,
                                thief_cbp = 0
                            },
                        cross_mining_util:insert_ets(NewMineralInfo),
                        Base = data_mining_event:get(?MINERAL_TYPE_2),
                        Reward = util:list_rand_ratio(Base#base_mining_event.reward),
                        center:apply(Node, cross_mining_notice, send_att_thief_reward, [Pkey, Reward]),
                        cross_mining_notice:notice_sys(NewMineralInfo, State#st_cross_mining.see_list),
                        cross_mining_notice:notice_thief_end(Pname, MineralInfo#mineral_info.type, MineralInfo#mineral_info.page, MineralInfo#mineral_info.id),
                        cross_mining_util:insert_event_log(?MINE_EVENT_LOG_TYPE_2, Pkey, Pname, MineralInfo#mineral_info.hold_key, Type, Page, Id, Reward, MineralInfo#mineral_info.mtype),
                        cross_mining_util:add_sore(Pkey, Pname, Vip, Cbp, Dvip, Sn, ?SCORE_TYPE_11),
                        {1, Reward}
                end
        end,
    {ok, Bin} = pt_604:write(60404, {Res, goods:pack_goods(RewardList)}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

%% 进攻矿点
info({att_mine, Node, Sid, Pid, Type, Page, Id, Pkey, Sn, Cbp, Pname, GuildName, Sex, Avatar, Vip, Dvip}, State) ->
    Now = util:unixtime(),
    {Res, RemainHp, OldMineralInfo, AttReward} =
        case cross_mining_util:get_ets_by_key({Type, Page, Id}) of
            [] ->
                {2, 0, #mineral_info{}, []};
            MineralInfo ->
                Base = data_mineral_info:get(MineralInfo#mineral_info.mtype),
                if
                    MineralInfo#mineral_info.end_time < Now andalso MineralInfo#mineral_info.end_time =/= 0 -> %% 已经结算
                        {2, 0, MineralInfo, []};
                    MineralInfo#mineral_info.hold_key == Pkey -> %% 已经结算
                        {11, 0, MineralInfo, []};
                    MineralInfo#mineral_info.hold_key == 0 -> %% 无人占领
                        MyList = cross_mining_util:get_ets_by_pkey(Pkey),
                        Len = length(MyList),
                        if
                            Len >= ?MINE_COUNT_LIMIT -> {14, 0, MineralInfo, []};
                            Base#base_mineral_info.cbp_limit > Cbp -> {3, 0, MineralInfo, []}; %%战力不足
                            true ->
                                Ratio0 = data_mineral_hp:get(Cbp),
                                Ratio = ?IF_ELSE(Ratio0 == 0, 1, Ratio0),
                                NewMineralInfo =
                                    MineralInfo#mineral_info{
                                        first_hold_time = Now,
                                        last_hold_time = Now,
                                        hold_avatar = Avatar,
                                        hold_sex = Sex,
                                        ripe_time = Now + Base#base_mineral_info.life_time,
                                        end_time = Now + Base#base_mineral_info.life_time + Base#base_mineral_info.ripe_time,
                                        hp = round(Base#base_mineral_info.hp_lim * Ratio),
                                        hp_lim = round(Base#base_mineral_info.hp_lim * Ratio),
                                        hold_sn = Sn,
                                        hold_key = Pkey,
                                        hold_cbp = Cbp,
                                        hold_name = Pname,
                                        hold_vip = Vip,
                                        hold_dvip = Dvip,
                                        hold_guild_name = GuildName
                                    },
                                cross_mining_util:insert_ets(NewMineralInfo),
                                Pid ! cross_mine_add_att_cd,    %%增加进攻cd
                                cross_mining_notice:notice_sys(NewMineralInfo, State#st_cross_mining.see_list),
                                cross_mining_notice:log_cross_mine_att(Pkey, 0, 1, Type, Page, Id, [], 0, 0, 0, util:unixtime()),
                                ScoreType =
                                    case NewMineralInfo#mineral_info.mtype of
                                        ?MINERAL_TYPE_1 -> ?SCORE_TYPE_1;
                                        ?MINERAL_TYPE_2 -> ?SCORE_TYPE_2;
                                        ?MINERAL_TYPE_3 -> ?SCORE_TYPE_3;
                                        ?MINERAL_TYPE_4 -> ?SCORE_TYPE_4;
                                        ?MINERAL_TYPE_5 -> ?SCORE_TYPE_5;
                                        _ -> 0
                                    end,
                                cross_mining_util:add_sore(Pkey, Pname, Vip, Cbp, Dvip, Sn, ScoreType),
                                {1, round(Base#base_mineral_info.hp_lim * Ratio), MineralInfo, []}
                        end;
                    MineralInfo#mineral_info.is_hit == 1 -> %% 收获期已经被攻击
                        {4, 0, MineralInfo, []};
                    true ->
                        MyList = cross_mining_util:get_ets_by_pkey(Pkey),
                        Len = length(MyList),
                        if
                            Len >= ?MINE_COUNT_LIMIT -> {14, 0, MineralInfo, []};
                            MineralInfo#mineral_info.hp > 0 ->
                                HoldTime = Now - MineralInfo#mineral_info.last_hold_time,
                                F = fun({Down, Top, Att}, Hp0) ->
                                    ?IF_ELSE(HoldTime >= Down andalso HoldTime =< Top, Att, Hp0)
                                    end,
                                AttHp0 = lists:foldl(F, 0, Base#base_mineral_info.att_hp),
                                if
                                    AttHp0 == 0 ->
                                        ?ERR("att hp =0  ~p~n"),
                                        {0, 0, MineralInfo, []};
                                    true ->
                                        OtherCbp = lists:sum([X#help_info.cbp || X <- MineralInfo#mineral_info.help_list]),
                                        Att0 = data_mineral_att:get(max(0, Cbp - MineralInfo#mineral_info.hold_cbp - OtherCbp)),
                                        Att = ?IF_ELSE(Att0 == [], 1, Att0),
                                        AttHp = round(AttHp0 * Att),
                                        if
                                            MineralInfo#mineral_info.hp > AttHp ->
                                                cross_mining_util:insert_ets(MineralInfo#mineral_info{hp = MineralInfo#mineral_info.hp - AttHp}),
                                                Pid ! cross_mine_add_att_cd,    %%增加进攻cd
                                                cross_mining_notice:log_cross_mine_att(Pkey, MineralInfo#mineral_info.hold_key, 5, Type, Page, Id, [], MineralInfo#mineral_info.hp, MineralInfo#mineral_info.hp - AttHp, 0, util:unixtime()),
                                                {5, MineralInfo#mineral_info.hp - AttHp, MineralInfo, []};
                                            true ->
                                                if
                                                    MineralInfo#mineral_info.end_time > Now andalso MineralInfo#mineral_info.ripe_time < Now -> %% 收获期
                                                        NewMineralInfo = MineralInfo#mineral_info{hp = 0, is_hit = 1},
                                                        cross_mining_util:insert_ets(NewMineralInfo),
                                                        Reward = cross_mining_util:get_hold_time_reward(Now - MineralInfo#mineral_info.last_hold_time, Base#base_mineral_info.reward),
                                                        ?DEBUG("reward ~p~n", [[{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- Reward]]),
                                                        Reward1 = [{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- Reward],
                                                        center:apply(Node, cross_mining_notice, send_ripe_att_mail, [Pkey, Reward1]),
                                                        ?DO_IF(Sn =/= 0, center:apply_sn(Sn, cross_mining_notice, send_ripe_def_mail, [MineralInfo#mineral_info.hold_key, Pname, Reward1])),
                                                        Pid ! cross_mine_add_att_cd,    %%增加进攻cd
                                                        spawn(fun()-> util:sleep(1000), cross_mining_notice:notice_sys(NewMineralInfo, State#st_cross_mining.see_list) end),
                                                        cross_mining_notice:log_cross_mine_att(Pkey, MineralInfo#mineral_info.hold_key, 6, Type, Page, Id, Reward1, MineralInfo#mineral_info.hp, 0, 1, util:unixtime()),
                                                        ScoreType =
                                                            case NewMineralInfo#mineral_info.mtype of
                                                                ?MINERAL_TYPE_1 -> ?SCORE_TYPE_6;
                                                                ?MINERAL_TYPE_2 -> ?SCORE_TYPE_7;
                                                                ?MINERAL_TYPE_3 -> ?SCORE_TYPE_8;
                                                                ?MINERAL_TYPE_4 -> ?SCORE_TYPE_9;
                                                                ?MINERAL_TYPE_5 -> ?SCORE_TYPE_10;
                                                                _ -> 0
                                                            end,
                                                        cross_mining_util:add_sore(Pkey, Pname, Vip, Cbp, Dvip, Sn, ScoreType),
                                                        {6, 0, MineralInfo, Reward1};
                                                    true -> %% 非收获期，交换所有权
                                                        NewMineralInfo = MineralInfo#mineral_info{
                                                            last_hold_time = Now,
                                                            hp = Base#base_mineral_info.hp_lim,
                                                            hold_sn = Sn,
                                                            hold_key = Pkey,
                                                            hold_avatar = Avatar,
                                                            hold_sex = Sex,
                                                            hold_name = Pname,
                                                            hold_cbp = Cbp,
                                                            hold_vip = Vip,
                                                            hold_dvip = Dvip,
                                                            hold_guild_name = GuildName,
                                                            help_list = []
                                                        },
                                                        Reward = cross_mining_util:get_hold_time_reward(Now - MineralInfo#mineral_info.last_hold_time, Base#base_mineral_info.reward),
                                                        ?DEBUG("reward ~p~n", [[{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- Reward]]),
                                                        Reward1 = [{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- Reward],
                                                        center:apply(Node, cross_mining_notice, send_att_mail, [Pkey, Reward1]),
                                                        ?DO_IF(Sn =/= 0, center:apply_sn(Sn, cross_mining_notice, send_def_mail, [MineralInfo#mineral_info.hold_key, Pname, Reward1])),
                                                        cross_mining_util:insert_ets(NewMineralInfo),
                                                        Pid ! cross_mine_add_att_cd,    %%增加进攻cd
                                                        spawn(fun()-> util:sleep(1000),cross_mining_notice:notice_sys(NewMineralInfo, State#st_cross_mining.see_list) end),
                                                        cross_mining_notice:log_cross_mine_att(Pkey, MineralInfo#mineral_info.hold_key, 1, Type, Page, Id, Reward1, MineralInfo#mineral_info.hp, 0, 0, util:unixtime()),
                                                        ScoreType =
                                                            case NewMineralInfo#mineral_info.mtype of
                                                                ?MINERAL_TYPE_1 -> ?SCORE_TYPE_6;
                                                                ?MINERAL_TYPE_2 -> ?SCORE_TYPE_7;
                                                                ?MINERAL_TYPE_3 -> ?SCORE_TYPE_8;
                                                                ?MINERAL_TYPE_4 -> ?SCORE_TYPE_9;
                                                                ?MINERAL_TYPE_5 -> ?SCORE_TYPE_10;
                                                                _ -> 0

                                                            end,
                                                        cross_mining_util:add_sore(Pkey, Pname, Vip, Cbp, Dvip, Sn, ScoreType),
                                                        {1, 0, MineralInfo, Reward1}
                                                end
                                        end
                                end;
                            true ->
                                {4, 0, MineralInfo, []}
                        end
                end
        end,
    cross_mining_util:insert_att_log(Pkey, Pname, OldMineralInfo#mineral_info.hold_key, OldMineralInfo#mineral_info.hold_sn, OldMineralInfo#mineral_info.hold_name, Type, Page, Id, Res, AttReward),
    {ok, Bin} = pt_604:write(60403, {Res, RemainHp}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

%% 刷新分矿
info(time_reset_mining, State) ->
    ?DEBUG("State ~p/~p~n", [State#st_cross_mining.type, State#st_cross_mining.page]),
    List0 = cross_mining_util:get_ets_by_type_page(State#st_cross_mining.type, State#st_cross_mining.page),
    MineralInfoList = [X || X <- List0, X#mineral_info.hold_key =/= 0], %%有主的矿
    lists:foreach(fun(Ets) -> cross_mining_util:delete_mine(Ets) end, List0--MineralInfoList), %% 删除无主的矿
    MTypes = data_mineral_info:get_all(),
    F = fun(MType) ->
        RatioList = data_mineral_info:get_ratio(MType),
        case lists:keyfind(State#st_cross_mining.type, 1, RatioList) of
            false -> [];
            {_, Ratio0} ->
                [{MType, Ratio0}]
        end
        end,
    List1 = lists:flatmap(F, MTypes),
    Ids = [X#mineral_info.id || X <- MineralInfoList],
    OtherIds = lists:seq(1, ?MINING_MAP_MAX) -- Ids,
    Now = util:unixtime(),
    F1 = fun({MType, Ratio}, OtherIds0) ->
        Num = Ratio * ?MINING_MAP_MAX div 100,
        Len = length([X || X <- MineralInfoList, X#mineral_info.mtype == MType]),
        Base = data_mineral_info:get(MType),
        if
            Len >= Num -> OtherIds0;
            true ->
                Num0 = Num - Len, %% 需要补充矿点数
                IdLen = length(OtherIds0),
                Num1 = ?IF_ELSE(IdLen >= Num0, Num0, IdLen),
                IdList = util:get_random_list(OtherIds0, Num1),
                F2 = fun(Id) ->
                    Ets = #mineral_info{
                        key = {State#st_cross_mining.type, State#st_cross_mining.page, Id},
                        type = State#st_cross_mining.type,
                        page = State#st_cross_mining.page,
                        id = Id,
                        hp = Base#base_mineral_info.hp_lim,
                        hp_lim = Base#base_mineral_info.hp_lim,
                        mtype = MType,
                        start_time = Now
                    },
                    cross_mining_util:insert_ets(Ets)
                     end,
                lists:foreach(F2, IdList),
                OtherIds0 -- IdList
        end
         end,
    lists:foldl(F1, OtherIds, List1),
    cross_mining_notice:reset_notice(State#st_cross_mining.see_list),
    {noreply, State};

%% 奇遇
info({time_mining_meet, Num}, State) ->
    List0 = cross_mining_util:get_ets_by_type_page(State#st_cross_mining.type, State#st_cross_mining.page),
    EventRatio = data_mineral_info:get_event_ratio(),
    util:list_rand_ratio(EventRatio),
    Now = util:unixtime(),
    Base = data_mining_event:get(?EVENT_TYPE_1),
    F = fun(_, List1) ->
        MType = util:list_rand_ratio(EventRatio),
        LuckList = [X || X <- List1, X#mineral_info.meet_start_time == 0, X#mineral_info.mtype == MType],
        if
            LuckList == [] ->
                List1;
            true ->
                LuckMineral = util:list_rand(LuckList),
                Ets = LuckMineral#mineral_info{
                    meet_type = 1,
                    meet_start_time = Now,
                    meet_end_time = Now + Base#base_mining_event.life_time
                },
                cross_mining_util:insert_event_log(?MINE_EVENT_LOG_TYPE_1, LuckMineral#mineral_info.hold_key, LuckMineral#mineral_info.hold_name, LuckMineral#mineral_info.hold_key, LuckMineral#mineral_info.type, LuckMineral#mineral_info.page, LuckMineral#mineral_info.id, [], LuckMineral#mineral_info.mtype),
                {ok, Bin} = pt_430:write(43099, {[[196, 1] ++ activity:pack_act_state([])]}),
                ?DO_IF(LuckMineral#mineral_info.hold_sn =/= 0, center:apply_sn(LuckMineral#mineral_info.hold_sn, server_send, send_to_key, [LuckMineral#mineral_info.hold_key, Bin])),
%%                 cross_mining_notice:notice_meet_start(LuckMineral#mineral_info.hold_name, LuckMineral#mineral_info.type, LuckMineral#mineral_info.page, LuckMineral#mineral_info.id),
                cross_mining_util:insert_ets(Ets),
                lists:delete(LuckMineral, List1)
        end
        end,
    lists:foldl(F, List0, lists:seq(1, Num)),
    {noreply, State};

info({time_mining_thief, Num}, State) ->
    List0 = cross_mining_util:get_ets_by_type_page(State#st_cross_mining.type, State#st_cross_mining.page),
    EventRatio = data_mineral_info:get_event_ratio(),
    util:list_rand_ratio(EventRatio),
    Now = util:unixtime(),
%% 小偷
    Base = data_mining_event:get(?EVENT_TYPE_2),
    {CbpL, CbpR} = Base#base_mining_event.cbp,
    F = fun(_, List1) ->
        MType = util:list_rand_ratio(EventRatio),
        LuckList = [X || X <- List1, X#mineral_info.thief_start_time == 0, X#mineral_info.mtype == MType],
        if
            LuckList == [] -> List1;
            true ->
                LuckMineral = util:list_rand(LuckList),
                Ets = LuckMineral#mineral_info{
                    thief_cbp = util:rand(CbpL, CbpR),
                    thief_start_time = Now,
                    thief_end_time = Now + Base#base_mining_event.life_time
                },
                cross_mining_util:insert_event_log(?MINE_EVENT_LOG_TYPE_4, LuckMineral#mineral_info.hold_key, LuckMineral#mineral_info.hold_name, LuckMineral#mineral_info.hold_key, LuckMineral#mineral_info.type, LuckMineral#mineral_info.page, LuckMineral#mineral_info.id, [], LuckMineral#mineral_info.mtype),
%%                 cross_mining_notice:notice_thief_start(LuckMineral#mineral_info.hold_name, LuckMineral#mineral_info.type, LuckMineral#mineral_info.page, LuckMineral#mineral_info.id),
                cross_mining_util:insert_ets(Ets),
                lists:delete(LuckMineral, List1)
        end
        end,
    lists:foldl(F, List0, lists:seq(1, Num)),
    {noreply, State};


%% 定时更新
info(timer_update, State) ->

    util:cancel_ref([State#st_cross_mining.ref]),
    List0 = cross_mining_util:get_ets_by_type_page(State#st_cross_mining.type, State#st_cross_mining.page),
    Now = util:unixtime(),
    F = fun(MineralInfo) ->
        {ChangeFlag0, MineralInfo1} = timer_update_meet(MineralInfo, Now, false), %% 检查奇遇
        {ChangeFlag1, MineralInfo2} = timer_update_thief(MineralInfo1, Now, ChangeFlag0), %% 检查小偷
        timer_update_mine(MineralInfo2, Now, ChangeFlag1, State#st_cross_mining.see_list),  %%  检查矿点情况
        ok
        end,
    lists:foreach(F, List0),
    Ref = erlang:send_after(?UPDATE_TIEM * 1000, self(), timer_update),
    {noreply, State#st_cross_mining{ref = Ref}};


info(_Msg, State) ->
    {noreply, State}.

%% 检查奇遇
timer_update_meet(MineralInfo, Now, ChangeFlag) ->
    if
        MineralInfo#mineral_info.meet_end_time > Now orelse MineralInfo#mineral_info.meet_end_time == 0 ->
            {ChangeFlag, MineralInfo};
        true ->
            NewMineralInfo =
                MineralInfo#mineral_info{
                    meet_type = 0,
                    meet_start_time = 0,
                    meet_end_time = 0
                },
            cross_mining_util:insert_ets(NewMineralInfo),  %% 先写入ets，防止后续报错的情况下无限发邮件
            if
                MineralInfo#mineral_info.hold_key == 0 ->
                    skip;
                true ->
                    Base = data_mining_event:get(?EVENT_TYPE_1),
                    Reward = util:list_rand_ratio(Base#base_mining_event.reward),
                    cross_mining_notice:notice_meet_end(MineralInfo#mineral_info.hold_name, MineralInfo#mineral_info.type, MineralInfo#mineral_info.page, MineralInfo#mineral_info.id, Reward),
                    cross_mining_util:insert_event_log(?MINE_EVENT_LOG_TYPE_3, MineralInfo#mineral_info.hold_key, MineralInfo#mineral_info.hold_name, MineralInfo#mineral_info.hold_key, MineralInfo#mineral_info.type, MineralInfo#mineral_info.page, MineralInfo#mineral_info.id, Reward, MineralInfo#mineral_info.mtype),
                    cross_mining_notice:log_cross_mine_get_mine_reward(MineralInfo#mineral_info.hold_key, ?LOG_TYPE2, 0, MineralInfo#mineral_info.type, MineralInfo#mineral_info.page, MineralInfo#mineral_info.id, Reward),
                    cross_mining_util:add_sore(MineralInfo#mineral_info.hold_key, MineralInfo#mineral_info.hold_name, MineralInfo#mineral_info.hold_vip, MineralInfo#mineral_info.hold_cbp, MineralInfo#mineral_info.hold_dvip, MineralInfo#mineral_info.hold_sn, ?SCORE_TYPE_12),
                    ?DO_IF(MineralInfo#mineral_info.hold_sn =/= 0, center:apply_sn(MineralInfo#mineral_info.hold_sn, cross_mining_notice, send_meet_mail, [MineralInfo#mineral_info.hold_key, Reward]))
            end,
            {true, NewMineralInfo}
    end.

%% 检查小偷
timer_update_thief(MineralInfo, Now, ChangeFlag) ->
    if
        MineralInfo#mineral_info.meet_end_time > Now orelse MineralInfo#mineral_info.meet_end_time == 0 ->
            {ChangeFlag, MineralInfo};
        true ->
            {true, MineralInfo#mineral_info{
                thief_start_time = 0,
                thief_end_time = 0
            }}
    end.

timer_update_mine(MineralInfo, Now, ChangeFlag, SeeList) ->
    if
        MineralInfo#mineral_info.hold_key == 0 ->   %% 未被人占领
            ?DO_IF(ChangeFlag, cross_mining_notice:notice_sys(MineralInfo, SeeList)),
            ?DO_IF(ChangeFlag, cross_mining_util:insert_ets(MineralInfo));
        MineralInfo#mineral_info.ripe_time > Now orelse MineralInfo#mineral_info.ripe_time == 0 -> %% 未到收获期
            ?DO_IF(ChangeFlag, cross_mining_notice:notice_sys(MineralInfo, SeeList)),
            ?DO_IF(ChangeFlag, cross_mining_util:insert_ets(MineralInfo));
        MineralInfo#mineral_info.ripe_time < Now andalso MineralInfo#mineral_info.end_time > Now andalso MineralInfo#mineral_info.is_notice == 0 -> %% 收获期未收获
            {ok, Bin} = pt_604:write(60412, {MineralInfo#mineral_info.type, MineralInfo#mineral_info.page, MineralInfo#mineral_info.id}),
            ?DO_IF(MineralInfo#mineral_info.hold_sn =/= 0, center:apply_sn(MineralInfo#mineral_info.hold_sn, server_send, send_to_key, [MineralInfo#mineral_info.hold_key, Bin])),
            spawn(fun() ->
                {ok, Bin1} = pt_430:write(43099, {[[196, 1] ++ activity:pack_act_state([])]}),
                ?DO_IF(MineralInfo#mineral_info.hold_sn =/= 0, center:apply_sn(MineralInfo#mineral_info.hold_sn, server_send, send_to_key, [MineralInfo#mineral_info.hold_key, Bin1]))
                  end),


            cross_mining_util:insert_ets(MineralInfo#mineral_info{is_notice = 1});
        MineralInfo#mineral_info.end_time < Now andalso MineralInfo#mineral_info.end_time =/= 0 -> %% 已经过了收获期
            cross_mining_util:delete_mine(MineralInfo), %% 先删除再发奖
            Base = data_mineral_info:get(MineralInfo#mineral_info.mtype),
            Reward = cross_mining_util:get_hold_time_reward(MineralInfo#mineral_info.ripe_time - MineralInfo#mineral_info.last_hold_time, Base#base_mineral_info.reward),
            if
                MineralInfo#mineral_info.is_hit == 0 ->
                    cross_mining_notice:notice_sys(#mineral_info{type = MineralInfo#mineral_info.type, page = MineralInfo#mineral_info.page, id = MineralInfo#mineral_info.id}, SeeList),
                    cross_mining_notice:log_cross_mine_get_mine_reward(MineralInfo#mineral_info.hold_key, ?LOG_TYPE3, 0, MineralInfo#mineral_info.type, MineralInfo#mineral_info.page, MineralInfo#mineral_info.id, Reward),
                    center:apply_sn(MineralInfo#mineral_info.hold_sn, cross_mining_notice, send_hold_reward, [MineralInfo#mineral_info.hold_key, Reward]);
                true ->
                    cross_mining_notice:notice_sys(#mineral_info{type = MineralInfo#mineral_info.type, page = MineralInfo#mineral_info.page, id = MineralInfo#mineral_info.id}, SeeList),
                    cross_mining_notice:log_cross_mine_get_mine_reward(MineralInfo#mineral_info.hold_key, ?LOG_TYPE3, 1, MineralInfo#mineral_info.type, MineralInfo#mineral_info.page, MineralInfo#mineral_info.id, [{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- Reward]),
                    center:apply_sn(MineralInfo#mineral_info.hold_sn, cross_mining_notice, send_hold_reward2, [MineralInfo#mineral_info.hold_key, [{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- Reward]])
            end;
        true ->
            ?DO_IF(ChangeFlag, cross_mining_notice:notice_sys(MineralInfo, SeeList)),
            ?DO_IF(ChangeFlag, cross_mining_util:insert_ets(MineralInfo))
    end.
