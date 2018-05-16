%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 七月 2017 15:52
%%%-------------------------------------------------------------------
-module(dungeon_marry).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("dungeon.hrl").
-include("marry.hrl").
-include("daily.hrl").
-include("team.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_info/1,
    dun_reset/1,
    check_enter/2,
    dun_ret/4,

    notice_ta/3,
    saodang/1,
    divorce/1,
    divorce/2,
    get_notice_state/1,
    get_notice_state/2
]).

-export([
    get_dun_task_info/1,
    send_to_client/3,
    notice_problem/2,
    answer/3,
    answer_client/4,
    collect_mon/1,
    gm/1
]).

gm(Player) ->
    Player#player.copy ! notice_problem,
    ok.

%%初始化
init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, #st_dun_marry{pkey = Player#player.key, op_time = util:unixtime()});
        false ->
            case dungeon_load:load_dun_marry(Player#player.key) of
                [] ->
                    lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, #st_dun_marry{pkey = Player#player.key, op_time = util:unixtime()});
                [Pass, Optime, IsReset, Saodang] ->
                    Now = util:unixtime(),
                    case util:is_same_date(Optime, Now) of
                        true ->
                            lib_dict:put(?PROC_STATUS_MARRY_DUNGEON,
                                #st_dun_marry{
                                    pkey = Player#player.key,
                                    pass = Pass,
                                    op_time = Optime,
                                    is_reset = IsReset,
                                    saodang = Saodang
                                });
                        false ->
                            lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, #st_dun_marry{pkey = Player#player.key})
                    end
            end
    end.

%% 0点重置扫荡
midnight_refresh(_Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_DUNGEON),
    NewSt = St#st_dun_marry{
        saodang = 0,
        op_time = util:unixtime(),
        is_reset = 0,
        pass = 0
    },
    lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, NewSt),
    ok.

%% 读取面板信息
get_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_DUNGEON),
    Status =
        if
            St#st_dun_marry.pass == 0 -> 1; %% 副本可挑战
            St#st_dun_marry.saodang == 1 -> 2; %% 副本可扫荡
            St#st_dun_marry.is_reset == 0 -> 3; %% 副本可以重置
            true -> 0 %% 挑战完
        end,
    List = data_dungeon_marry_reward:get_passReward_by_lv(Player#player.lv),
    ProList = lists:map(fun({Id, Num}) -> [Id, Num] end, List),
    {Status, ProList}.

%% 副本重置
dun_reset(Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_DUNGEON),
    case check_dun_reset(Player) of
        {fail, Code} ->
            {Code, Player};
        {true, Cost} ->
            NewSt = St#st_dun_marry{saodang = 1, is_reset = St#st_dun_marry.is_reset + 1},
            lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, NewSt),
            dungeon_load:replace_dun_marry(NewSt),
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 649, 0, 0),
            {1, NewPlayer}
    end.

check_dun_reset(Player) ->
    Cost = ?DUN_MARRY_RESET_COST,
    St = lib_dict:get(?PROC_STATUS_MARRY_DUNGEON),
    case money:is_enough(Player, Cost, gold) of
        false -> {fail, 3};
        true ->
            ?IF_ELSE(St#st_dun_marry.is_reset >= 1, {fail, 4}, {true, Cost})
    end.

check_enter(Player, DunId) ->
    case dungeon_util:is_dungeon_marry(DunId) of
        false ->
            true;
        true ->
            St = lib_dict:get(?PROC_STATUS_MARRY_DUNGEON),
            if
                Player#player.marry#marry.mkey == 0 ->
                    {false, ?T("您目前未婚，还不能挑战！")};
                Player#player.team_key == 0 ->
                    {false, ?T("请与Ta一起来挑战吧")};
                St#st_dun_marry.pass == 1 ->
                    {false, ?T("当前关卡已通关")};
                true ->
                    MbList = team_util:get_team_mbs(Player#player.team_key),
                    PkeyList1 = lists:sort(lists:map(fun(#t_mb{pkey = Pkey0}) -> Pkey0 end, MbList)),
                    PkeyList2 = lists:sort([Player#player.key, Player#player.marry#marry.couple_key]),
                    if
                        PkeyList1 == PkeyList2 ->
                            Mb = lists:keyfind(Player#player.marry#marry.couple_key, #t_mb.pkey, MbList),
                            case scene:is_normal_scene(Mb#t_mb.scene) of
                                true -> true;
                                false -> {false, ?T("Ta不在野外场景,暂不可参战")}
                            end;
                        true -> {false, ?T("请与Ta一起来挑战吧")}
                    end
            end
    end.

%% 副本结算
dun_ret(Player, 0, _CollectList, _DunProblem) ->
    {ok, Bin} = pt_126:write(12611, {0, [], [], []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player;

dun_ret(Player, 1, CollectList, DunProblem) ->
    CollectRewardList = data_dungeon_marry_reward:get_collectDrop_by_lv(Player#player.lv),
    AnswerRewardList = data_dungeon_marry_reward:get_anwser_reward(Player#player.lv),
    F = fun({Gid, GNum, Power}) -> {{Gid, GNum}, Power} end,
    NewAnswerReward = util:list_rand_ratio(lists:map(F, AnswerRewardList)),
    NewCollectReward = util:list_rand_ratio(lists:map(F, CollectRewardList)),
    CollectStatus = ?IF_ELSE(length(CollectList) >= length(data_dungeon_marry_collect:get_all()), 1, 0),
    AnwserStatus = get_answer_status(DunProblem, Player#player.key), %% 暂时写死答题正确
    NewCollectRewardList = ?IF_ELSE(CollectStatus == 1, [NewCollectReward], []),
    NewAnswerRewardList =
        if
            AnwserStatus == 1 ->
                [NewAnswerReward];
            AnwserStatus == 2 ->
                [NewAnswerReward, NewAnswerReward];
            true -> []
        end,
    PassRewardList = data_dungeon_marry_reward:get_passReward_by_lv(Player#player.lv),
    RewardList =
        case daily:get_count(?DAILY_DUN_MARRY) of
            0 ->
                daily:set_count(?DAILY_DUN_MARRY, 1),
                {ok, Bin} = pt_126:write(12611, {1, util:list_tuple_to_list(PassRewardList), util:list_tuple_to_list(NewCollectRewardList), util:list_tuple_to_list(NewAnswerRewardList)}),
                server_send:send_to_sid(Player#player.sid, Bin),
                PassRewardList ++ NewCollectRewardList ++ NewAnswerRewardList;
            _ ->
                {ok, Bin} = pt_126:write(12611, {1, [], [], []}),
                server_send:send_to_sid(Player#player.sid, Bin),
                []
        end,
    GiveGoodsList = goods:make_give_goods_list(650, RewardList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    St = lib_dict:get(?PROC_STATUS_MARRY_DUNGEON),
    NewSt = St#st_dun_marry{pass = 1, op_time = util:unixtime()},
    lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, NewSt),
    dungeon_load:replace_dun_marry(NewSt),
    activity:get_notice(Player, [134], true),
    Sql = io_lib:format("insert into log_dun_marry set pkey=~p,problem_id=~p,result='~s', problem_reward='~s',collect_num=~p,collect_reward='~s',pass_reward='~s',`time`=~p",
        [Player#player.key,
            DunProblem#dun_problem.id,
            util:term_to_bitstring(DunProblem#dun_problem.answer_list),
            util:term_to_bitstring(NewAnswerRewardList),
            length(CollectList),
            util:term_to_bitstring(NewCollectRewardList),
            util:term_to_bitstring(PassRewardList),
            util:unixtime()]),
    log_proc:log(Sql),
    NewPlayer.

get_answer_status(DunProblem, Pkey) ->
    #dun_problem{id = Id, answer_list = AnswerList} = DunProblem,
    #base_marry_problem{result_list = ResultList} = data_dungeon_marry_problem:get(Id),
    F = fun({_Pkey, Result}) ->
        case lists:member(Result, ResultList) of
            true -> [Result];
            false -> []
        end
        end,
    LL = lists:flatmap(F, AnswerList),

    F0 = fun({Pkey0, Result}) ->
        case lists:member(Result, ResultList) of
            true -> ?IF_ELSE(Pkey == Pkey0, [Pkey], []);
            false -> []
        end
         end,
    LL0 = lists:flatmap(F0, AnswerList),

    if
        LL0 == [] -> 0;
        LL == [] -> 0;
        length(LL) == 2 ->
            case LL of
                [A, A] -> 2;
                _ -> 1
            end;
        true -> 1
    end.

notice_ta(Player99, ?SCENE_ID_DUN_MARRY, TarCopy) ->
    MarryPkey = Player99#player.marry#marry.couple_key,
    case ets:lookup(?ETS_ONLINE, MarryPkey) of
        [] -> skip;
        [#ets_online{pid = Pid}] ->
            Pid ! {dungeon_marry_change_scene, ?SCENE_ID_DUN_MARRY, TarCopy},
            ok
    end;

notice_ta(_, _, _) -> skip.

%% 副本扫荡
saodang(Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_DUNGEON),
    if
        St#st_dun_marry.saodang == 2 -> {6, [], Player};
        true ->
            NewSt = St#st_dun_marry{saodang = 2, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, NewSt),
            dungeon_load:replace_dun_marry(NewSt),
            RewardList = data_dungeon_marry_reward:get_passReward_by_lv(Player#player.lv),
            GiveGoodsList = goods:make_give_goods_list(651, RewardList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            ProList = lists:map(fun({Id, Num}) -> [Id, Num] end, RewardList),
            activity:get_notice(Player, [134], true),
            {1, ProList, NewPlayer}
    end.

divorce(Player) ->
    lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, #st_dun_marry{pkey = Player#player.key}),
    dungeon_load:delete_dun_marry(Player#player.key),
    case ets:lookup(?ETS_ONLINE, Player#player.marry#marry.couple_key) of
        [] ->
            dungeon_load:delete_dun_marry(Player#player.marry#marry.couple_key);
        [#ets_online{pid = Pid}] ->
            player:apply_state(async, Pid, {?MODULE, divorce, []})
    end,
    player:apply_state(async, self(), {?MODULE, get_notice_state, []}),
    ok.

divorce(_, Player) ->
    lib_dict:put(?PROC_STATUS_MARRY_DUNGEON, #st_dun_marry{pkey = Player#player.key}),
    dungeon_load:delete_dun_marry(Player#player.key),
    {ok, Player}.

get_notice_state(_, Player) ->
    get_notice_state(Player),
    {ok, Player}.

get_notice_state(Player) ->
    if
        Player#player.marry#marry.couple_key == 0 -> 0;
        true ->
            {Status, _} = get_info(Player),
            ?IF_ELSE(Status == 1 orelse Status == 2, 1, 0)
    end.

get_dun_task_info(Player) ->
    case Player#player.scene == ?SCENE_ID_DUN_MARRY of
        true ->
            Player#player.copy ! {dun_marry, get_dun_task_info, Player#player.sid, Player#player.lv};
        false -> skip
    end.

send_to_client(Lv, Sid, State) ->
    #st_dungeon{
        round = Round,
        cur_kill_num = CurKillNum,
        collect_list = CollectList
    } = State,
    CollectNum = length(CollectList),
    MaxCollectNum = length(data_dungeon_marry_collect:get_all()),
    DropList = data_dungeon_marry_reward:get_dropGoods_by_lv(Lv),
    {ok, Bin} = pt_126:write(12608, {Round, CurKillNum, min(CollectNum, MaxCollectNum), MaxCollectNum, util:list_tuple_to_list(DropList)}),
    server_send:send_to_sid(Sid, Bin).

notice_problem(DunProblem, PlayerList) ->
    #dun_problem{id = ProblemId, answer_list = AnswerList} = DunProblem,
    F = fun(#dungeon_mb{sid = Sid, lv = Lv}) ->
        List = data_dungeon_marry_reward:get_anwser_reward(Lv),
        FF = fun({Gid, GNum, _Power}) ->
            [Gid, GNum]
             end,
        NewList = lists:map(FF, List),
        {ok, Bin} = pt_126:write(12610, {ProblemId, util:list_tuple_to_list(AnswerList), NewList}),
        server_send:send_to_sid(Sid, Bin)
        end,
    lists:map(F, PlayerList),
    ok.

answer(Player, Id, Result) ->
    case Player#player.scene == ?SCENE_ID_DUN_MARRY of
        true ->
            Player#player.copy ! {dun_marry, answer, Player#player.key, Id, Result},
            {ok, Bin} = pt_126:write(12609, {1}),
            server_send:send_to_sid(Player#player.sid, Bin);
        false -> ok
    end.

answer_client(Pkey, Id, Result, State) ->
    #st_dungeon{answer = Answer, player_list = PlayerList} = State,
    #dun_problem{id = ProblemId, answer_list = AnswerList} = Answer,
    if
        Id /= ProblemId -> State;
        true ->
            NewAnswerList =
                case lists:keytake(Pkey, 1, AnswerList) of
                    false ->
                        [{Pkey, Result} | AnswerList];
                    {value, _, Rest} ->
                        [{Pkey, Result} | Rest]
                end,
            NewAnswer = Answer#dun_problem{answer_list = NewAnswerList},
            NewState = State#st_dungeon{answer = NewAnswer},
            notice_problem(NewAnswer, PlayerList),
            NewState
    end.

collect_mon(Mon) ->
    Mon#mon.copy ! {dun_marry, collect_mon, Mon#mon.mid}.