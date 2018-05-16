%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2017 15:04
%%%-------------------------------------------------------------------
-module(cross_1vn_handle).
-author("Administrator").
-include("cross_1vN.hrl").
-include("server.hrl").
-include("common.hrl").
-include("scene.hrl").

-define(PAGE_NUM, 10).
-define(PAGE_NUM1, 9).

-export([handle_call/3, handle_cast/2, handle_info/2]).
-export([hot/0]).
-export([get_fianl_floor_exp/1]).

handle_call({player_bet, Pkey, _Sn, Group, Floor, _Cost, _Type}, _From, State) ->
    case lists:keytake({Group, Floor}, #cross_1vn_bet_info.key, State#st_1vn.bet_list) of
        false ->
            Res = {false, 0};
        {value, Cross1vnBetInfo, _T} ->
            case lists:keyfind(Pkey, #cross_1vn_final_player_bet_info.pkey, Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list) of
                false ->
                    if
                        Cross1vnBetInfo#cross_1vn_bet_info.state >= 3 ->
                            Res = {false, 11};
                        true ->
                            Res = ok
                    end;
                _ ->
                    Res = {false, 12}
            end
    end,
    {reply, Res, State};

%% 擂主竞猜投注
handle_call({player_winner_bet, _Pkey, _Sn, Group, WinnerKey, _Cost}, _From, State) ->
    case lists:keytake(Group, #cross_1vn_group.group, State#st_1vn.winner_bet_list) of
        false ->
            ?DEBUG("111~n"),
            Res = {false, 0};
        {value, WinnerBetInfo, _T0} ->
            case lists:keytake(WinnerKey, #cross_1vn_mb.pkey, WinnerBetInfo#cross_1vn_group.mb_list) of
                false ->
                    Res = {false, 0};
                {value, WinnerMb, _T1} ->
                    if
                        WinnerMb#cross_1vn_mb.is_lose == 1 ->
                            Res = {false, 16};
                        true ->
                            Len = length([X || X <- WinnerBetInfo#cross_1vn_group.mb_list, X#cross_1vn_mb.is_lose == 0]),
                            if
                                Len =< 1 ->
                                    Res = {false, 15};
                                true ->
                                    Res =
                                        {ok, WinnerMb#cross_1vn_mb.nickname, WinnerMb#cross_1vn_mb.ratio}
                            end
                    end
            end
    end,
    {reply, Res, State};

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

%% 获取参赛信息
handle_cast({get_sign_info, Pkey, Node, Sid, Lv}, State) ->
%%     Len = [length(X#cross_1vn_group.mb_list) || X <- State#st_1vn.sign_list],
%%     Count = ?IF_ELSE(Len == [], 0, lists:sum(Len)),
    Group1 = case cross_1vn_util:get_group(Lv) of
                 [] -> 0;
                 Other -> Other
             end,
    F = fun(GroupList, {SignState0, Group0}) ->
        case lists:keyfind(Pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
            false -> {SignState0, Group0};
            Mb0 ->
                {true, Mb0#cross_1vn_mb.lv_group}
        end
        end,
    {SignState, Group} = lists:foldl(F, {false, Group1}, State#st_1vn.sign_list),
    {ok, Bin} = pt_642:write(64201, {State#st_1vn.open_state, State#st_1vn.sign_num, ?IF_ELSE(SignState == true, 1, 0), Group}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

%% 膜拜次数增加
handle_cast(orz_winner, State) ->
    {noreply, State#st_1vn{orz_count = State#st_1vn.orz_count + 1}};

%% 获取历史记录
handle_cast({get_bet_history_info, Sid, Node, Pkey}, State) ->
    ?DEBUG("get_bet_history_info ~n"),
    List1 = get_my_bet_history(Pkey, State#st_1vn.bet_list), %% 中场投注记录
    List2 = get_my_final_bet_history(Pkey, State#st_1vn.winner_bet_list), %% 擂主投注记录

    Data = List1 ++ List2,
    ?DEBUG("data ~p~n", [Data]),
    {ok, Bin} = pt_642:write(64230, {List1 ++ List2}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};


%% 获取擂主竞猜信息
handle_cast({get_winner_bet_info, Sid, Node, Pkey, Group, Count}, State) ->
    case lists:keyfind(Group, #cross_1vn_group.group, State#st_1vn.winner_bet_list) of
        false ->
            {ok, Bin} = pt_642:write(64228, {0, 0, [], [], []}),
            server_send:send_to_sid(Node, Sid, Bin);
        WinnerBetInfo ->
            F = fun(Mb) ->
                case lists:keyfind(Pkey, 1, Mb#cross_1vn_mb.bet_list) of
                    false -> [];
                    {_Pkey, _Sn, Cost, Ratio} -> [[Mb#cross_1vn_mb.pkey, Cost, util:floor(Ratio * 100)]]
                end
                end,
            MyBetList = lists:flatmap(F, WinnerBetInfo#cross_1vn_group.mb_list),
            F0 = fun(Id0) ->
                [Id0, data_cross_1vn_bet_winner_cost:get(Id0)]
                 end,
            RatioList = lists:map(F0, data_cross_1vn_bet_winner_cost:get_all()),
            Data = {
                Count,
                30,
                MyBetList,
                RatioList,
                cross_1vn_util:make_winner_bet_info(WinnerBetInfo#cross_1vn_group.mb_list)
            },
            {ok, Bin} = pt_642:write(64228, Data),
            server_send:send_to_sid(Node, Sid, Bin)
    end,
    {noreply, State};


%% 擂主竞猜投注
handle_cast({player_winner_bet, Pkey, Sn, Group, WinnerKey, Cost}, State) when State#st_1vn.open_state >= ?CROSS_1VN_STATE_FAINAL_READY ->
    case lists:keytake(Group, #cross_1vn_group.group, State#st_1vn.winner_bet_list) of
        false ->
            NewWinnerBetList = State#st_1vn.winner_bet_list;
        {value, WinnerBetInfo, T0} ->
            case lists:keytake(WinnerKey, #cross_1vn_mb.pkey, WinnerBetInfo#cross_1vn_group.mb_list) of
                false ->
                    NewWinnerBetList = State#st_1vn.winner_bet_list;
                {value, WinnerMb, T1} ->
                    NewWinnerMb =
                        WinnerMb#cross_1vn_mb{
                            bet_list = [{Pkey, Sn, Cost, WinnerMb#cross_1vn_mb.ratio} | WinnerMb#cross_1vn_mb.bet_list]
                        },
                    NewWinnerBetInfo = WinnerBetInfo#cross_1vn_group{
                        mb_list = [NewWinnerMb | T1]
                    },
                    NewWinnerBetList = [NewWinnerBetInfo | T0]
            end
    end,
    {noreply, State#st_1vn{winner_bet_list = NewWinnerBetList}};

%% 获取中场投注信息
handle_cast({get_bet_info, Sid, Node, Pkey, Group, Exp, ExpUp}, State) ->
    BetInfoList = get_bet_info_list(State),
    case lists:keyfind(Group, #cross_1vn_bet_info.group, BetInfoList) of
        false ->
            {ok, Bin} = pt_642:write(64226, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, [], [], []}),
            server_send:send_to_sid(Node, Sid, Bin);
        Cross1vnBetInfo ->
            {IsBet, MyBetCost, MyBetRatio} =
                case lists:keyfind(Pkey, #cross_1vn_final_player_bet_info.pkey, Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list) of
                    false -> {0, 0, 0};
                    MyBetInfo ->
                        {
                            MyBetInfo#cross_1vn_final_player_bet_info.type,
                            MyBetInfo#cross_1vn_final_player_bet_info.cost,
                            MyBetInfo#cross_1vn_final_player_bet_info.ratio
                        }
                end,
            ChallengeNum =
                case get_num(Cross1vnBetInfo#cross_1vn_bet_info.floor) of
                    [] ->
                        0;
                    Num0 -> Num0
                end,
            F0 = fun(Id0) ->
                [Id0, data_cross_1vn_bet_cost:get(Id0)]
                 end,
            RatioList = lists:map(F0, data_cross_1vn_bet_cost:get_all()),
            {Hidden, Open} =
                case data_cross_1vn_bet_ratio:get(Cross1vnBetInfo#cross_1vn_bet_info.floor) of
                    [] -> {0, 0};
                    Other -> Other
                end,
            Ratio =
                if Cross1vnBetInfo#cross_1vn_bet_info.state =< 1 ->
                    Hidden * 100;
                    true -> Open * 100
                end,
            Data =
                {Exp, ExpUp,
                    Cross1vnBetInfo#cross_1vn_bet_info.bet_num,
                    Ratio,
                    Cross1vnBetInfo#cross_1vn_bet_info.floor,
                    ChallengeNum,
                    Cross1vnBetInfo#cross_1vn_bet_info.state,
                    IsBet, MyBetCost, MyBetRatio,
                    RatioList,
                    pack_bet_player_info([Cross1vnBetInfo#cross_1vn_bet_info.winner]),
                    pack_bet_player_info(Cross1vnBetInfo#cross_1vn_bet_info.challenge_list)},
            {ok, Bin} = pt_642:write(64226, Data),
            server_send:send_to_sid(Node, Sid, Bin)
    end,
    {noreply, State};


handle_cast({player_bet, Pkey, Sn, Group, Floor, Cost, Type}, State) ->
    case lists:keytake({Group, Floor}, #cross_1vn_bet_info.key, State#st_1vn.bet_list) of
        false ->
            NewBetList = State#st_1vn.bet_list;
        {value, Cross1vnBetInfo, T} ->
            case lists:keyfind(Pkey, #cross_1vn_final_player_bet_info.pkey, Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list) of
                false ->
                    if
                        Cross1vnBetInfo#cross_1vn_bet_info.state >= 3 ->
                            NewBetList = State#st_1vn.bet_list;
                        true ->
                            {Hidden, Open} = data_cross_1vn_bet_ratio:get(Cross1vnBetInfo#cross_1vn_bet_info.floor),
                            Ratio =
                                if Cross1vnBetInfo#cross_1vn_bet_info.state =< 1 ->
                                    Hidden;
                                    true -> Open
                                end,
                            New = #cross_1vn_final_player_bet_info{
                                pkey = Pkey,
                                sn = Sn,
                                type = Type,
                                cost = Cost,
                                ratio = Ratio
                            },
                            NewCross1vnBetInfo = Cross1vnBetInfo#cross_1vn_bet_info{
                                bet_num = Cross1vnBetInfo#cross_1vn_bet_info.bet_num + 1,
                                player_bet_list = [New | Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list]},
                            NewBetList = [NewCross1vnBetInfo | T]
                    end;
                _ ->
                    NewBetList = State#st_1vn.bet_list
            end
    end,
    {noreply, State#st_1vn{bet_list = NewBetList}};


handle_cast({update_bet_info, NewBetInfoList}, State) ->
    F = fun(BetInfo, BetList) ->
        case lists:keytake(BetInfo#cross_1vn_bet_info.key, #cross_1vn_bet_info.key, BetList) of
            false -> BetList;
            {value, OldBetInfo, T} ->
                if
                    OldBetInfo#cross_1vn_bet_info.state >= 2 -> BetList;
                    true ->
                        [OldBetInfo#cross_1vn_bet_info{
                            state = 2,
                            challenge_list = BetInfo#cross_1vn_bet_info.challenge_list
                        } | T]
                end
        end
        end,
    NewBetList = lists:foldl(F, State#st_1vn.bet_list, NewBetInfoList),
    {noreply, State#st_1vn{bet_list = NewBetList}};


%% 历史守擂记录
handle_cast({get_history_info, Sid, Node, Month, Day, Group}, State) ->
    case lists:keyfind({Month, Day}, 1, State#st_1vn.history_info) of
        false ->
            {ok, Bin} = pt_642:write(64225, {[]}),
            server_send:send_to_sid(Node, Sid, Bin);
        {_, Cross1vnGroup} ->
            case lists:keyfind(Group, #cross_1vn_group.group, Cross1vnGroup) of
                false ->
                    {ok, Bin} = pt_642:write(64225, {[]}),
                    server_send:send_to_sid(Node, Sid, Bin);
                GroupList ->
                    Data = make_history_info(GroupList#cross_1vn_group.mb_list),
                    {ok, Bin} = pt_642:write(64225, {Data}),
                    server_send:send_to_sid(Node, Sid, Bin)
            end
    end,
    {noreply, State};

%% 历史守擂记录
handle_cast({get_history_group, Node, Sid}, State) ->
    Data = [tuple_to_list(X) || X <- State#st_1vn.history_group],
    {ok, Bin} = pt_642:write(64224, {Data}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

%% 获取膜拜记录
handle_cast({get_orz_info, Node, Sid, Count, State1, Group}, State) ->
    ShopList =
        case lists:keyfind(Group, 1, State#st_1vn.history_shop) of
            false -> [];
            {Group, Other} -> Other
        end,
    Data = {State#st_1vn.orz_count, Count, State1, ShopList},
    {ok, Bin} = pt_642:write(64223, Data),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

%% 玩家报名参赛
handle_cast({sign_up, Pkey, Node, Sid, Mb}, State) when (State#st_1vn.open_state /= ?CROSS_1VN_STATE_CLOSE andalso State#st_1vn.open_state =< 3) ->
    case cross_1vn_util:get_group(Mb#cross_1vn_mb.lv) of
        [] ->
            {ok, Bin} = pt_642:write(64202, {4}),
            server_send:send_to_sid(Node, Sid, Bin),
            NewSignNum = State#st_1vn.sign_num,
            Newsignlist = State#st_1vn.sign_list;
        Group ->
            F = fun(GroupList) ->
                lists:keymember(Pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list)
                end,
            SignState = lists:any(F, State#st_1vn.sign_list),
            if
                SignState == true ->
                    NewSignNum = State#st_1vn.sign_num,
                    Newsignlist = State#st_1vn.sign_list,
                    {ok, Bin} = pt_642:write(64202, {3}),
                    server_send:send_to_sid(Node, Sid, Bin);
                true ->
                    case lists:keytake(Group, #cross_1vn_group.group, State#st_1vn.sign_list) of
                        {value, GroupList, T} ->
                            GroupList0 = GroupList#cross_1vn_group{mb_list = [Mb#cross_1vn_mb{lv_group = Group} | GroupList#cross_1vn_group.mb_list]},
                            NewSignNum = State#st_1vn.sign_num + util:random(3, 10),
                            Newsignlist = [GroupList0 | T],
                            {ok, Bin} = pt_642:write(64202, {1}),
                            server_send:send_to_sid(Node, Sid, Bin);
                        false ->
                            {ok, Bin} = pt_642:write(64202, {1}),
                            server_send:send_to_sid(Node, Sid, Bin),
                            NewSignNum = State#st_1vn.sign_num + util:random(3, 10),
                            Newsignlist = [#cross_1vn_group{group = Group, mb_list = [Mb#cross_1vn_mb{lv_group = Group}]} | State#st_1vn.sign_list]
                    end
            end
    end,
    {noreply, State#st_1vn{sign_list = Newsignlist, sign_num = NewSignNum}};


%% 更新玩家信息列表
handle_cast({update_mb_info, MbList}, State) ->
    F = fun(Mb, {SignList, TopRoleList}) ->
        case cross_1vn_util:get_group(Mb#cross_1vn_mb.lv) of
            [] -> {SignList, TopRoleList};
            Group ->
                case lists:keytake(Group, #cross_1vn_group.group, SignList) of
                    false -> {SignList, TopRoleList};
                    {value, GroupList, T} ->
                        case lists:keytake(Mb#cross_1vn_mb.pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
                            false ->
                                NewTopRole =
                                    case lists:keytake(Mb#cross_1vn_mb.lv_group, 1, TopRoleList) of
                                        false -> [{Mb#cross_1vn_mb.lv_group, Mb} | TopRoleList];
                                        {value, {_, TopRole}, TT} ->
                                            if
                                                TopRole#cross_1vn_mb.score < Mb#cross_1vn_mb.score ->
                                                    [{Mb#cross_1vn_mb.lv_group, Mb} | TT];
                                                TopRole#cross_1vn_mb.score == Mb#cross_1vn_mb.score andalso TopRole#cross_1vn_mb.cbp < Mb#cross_1vn_mb.cbp ->
                                                    [{Mb#cross_1vn_mb.lv_group, Mb} | TT];
                                                true -> TopRoleList
                                            end
                                    end,
                                cross_1vn_init:dbup_cross_1vn_mb(Mb),
                                {[GroupList#cross_1vn_group{mb_list = [Mb | GroupList#cross_1vn_group.mb_list]} | T], NewTopRole};
                            {value, _, T0} ->
                                NewTopRole =
                                    case lists:keytake(Mb#cross_1vn_mb.lv_group, 1, TopRoleList) of
                                        false -> [{Mb#cross_1vn_mb.lv_group, Mb} | TopRoleList];
                                        {value, {_, TopRole11}, TT} ->
                                            if
                                                TopRole11#cross_1vn_mb.score < Mb#cross_1vn_mb.score ->
                                                    [{Mb#cross_1vn_mb.lv_group, Mb} | TT];
                                                TopRole11#cross_1vn_mb.score == Mb#cross_1vn_mb.score andalso TopRole11#cross_1vn_mb.cbp < Mb#cross_1vn_mb.cbp ->
                                                    [{Mb#cross_1vn_mb.lv_group, Mb} | TT];
                                                true -> TopRoleList
                                            end
                                    end,
                                cross_1vn_init:dbup_cross_1vn_mb(Mb),
                                {[GroupList#cross_1vn_group{mb_list = [Mb | T0]} | T], NewTopRole}
                        end
                end
        end
        end,
    {NewSignList, NewTopRole} = lists:foldl(F, {State#st_1vn.sign_list, State#st_1vn.top_role}, MbList),
    {noreply, State#st_1vn{sign_list = NewSignList, top_role = NewTopRole}};


%% 更新决赛玩家信息列表
handle_cast({update_final_mb_info, MbList}, State) ->
    NewFinalList = update_final_mb_info(State#st_1vn.final_list, MbList),    %% 更新玩家个人信息
    NewWinnerNum = update_winner_num(State#st_1vn.winner_num, MbList),    %% 更新擂主人数
    NewCross1vnBetInfo = update_bet_info(State#st_1vn.bet_list, MbList, State#st_1vn.floor),    %% 更新投注信息
    NewWinnerBetList = update_winner_bet_info(State#st_1vn.winner_bet_list, MbList, State#st_1vn.floor),    %% 更新擂主竞猜信息
    {noreply, State#st_1vn{final_list = NewFinalList, winner_num = NewWinnerNum, bet_list = NewCross1vnBetInfo, winner_bet_list = NewWinnerBetList}};


%%获取个人比赛信息
handle_cast({get_fight_info, Pkey, Sid, Node, Exp}, State) ->
    F = fun(GroupList, Mb0) ->
        case lists:keyfind(Pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
            false -> Mb0;
            Mb1 -> Mb1
        end
        end,
    Mb = lists:foldl(F, [], State#st_1vn.sign_list),
    {TopScore, TopSn, TopNickName} =
        if State#st_1vn.top_role == [] -> {0, 0, ""};
            Mb == [] -> {0, 0, ""};
            true ->
                case lists:keyfind(Mb#cross_1vn_mb.lv_group, 1, State#st_1vn.top_role) of
                    false -> {0, 0, ""};
                    {_, TopRole} ->
                        {TopRole#cross_1vn_mb.score, TopRole#cross_1vn_mb.sn, TopRole#cross_1vn_mb.nickname}
                end
        end,
    NextTime =
        case misc:read_timer(cross_1vn_match) of
            false -> 0;
            Time -> Time div 1000
        end,
    case Mb of
        [] -> Data = {0, 0, State#st_1vn.floor, NextTime, 0, 0, 0, Exp, TopScore, TopSn, TopNickName};
        _ ->
            Time11 = State#st_1vn.time - util:unixtime(),
            NextTime1 = ?IF_ELSE(Mb#cross_1vn_mb.times >= 6, max(0, Time11), NextTime),
            Data = {
                Mb#cross_1vn_mb.score,
                ?CROSS_1VN_TIMES - Mb#cross_1vn_mb.times,
                State#st_1vn.floor,
                NextTime1,
                Mb#cross_1vn_mb.rank,
                Mb#cross_1vn_mb.win,
                Mb#cross_1vn_mb.lose,
                Exp,
                TopScore, TopSn, TopNickName}
    end,
    {ok, Bin} = pt_642:write(64208, Data),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};


%%获取决赛个人比赛信息
handle_cast({get_final_fight_info, Pkey, Sid, Node, Exp, ExpUp}, State) ->
    F = fun(GroupList, Mb0) ->
        case lists:keyfind(Pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
            false -> Mb0;
            Mb1 -> Mb1
        end
        end,
    Mb = lists:foldl(F, [], State#st_1vn.final_list),

    F1 = fun(GroupList, Mb0) ->
        case lists:keyfind(Pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
            false -> Mb0;
            Mb1 -> Mb1
        end
         end,
    Mb1 = lists:foldl(F1, [], State#st_1vn.sign_list),


    NextTime =
        case misc:read_timer(cross_1vn_final_match) of
            false ->
                case misc:read_timer(final_start) of
                    false -> 0;
                    Time22 -> Time22 div 1000
                end;
            Time -> Time div 1000
        end,
    MyGroup =
        case Mb1 of
            [] -> 2;
            _ -> Mb1#cross_1vn_mb.lv_group
        end,
    Nums = [Num0 || {Group0, Num0} <- State#st_1vn.winner_num, Group0 == MyGroup],
    WinnerNum =
        case Nums of
            [] -> 0;
            _ -> lists:sum(Nums)
        end,
    case Mb of
        [] ->
            NewxTime00 = State#st_1vn.time - util:unixtime(),
            NextTime1 = ?IF_ELSE(WinnerNum == 0, erlang:max(0, NewxTime00), NextTime),
            Data = {0, State#st_1vn.floor - 1, 0, Exp, ExpUp, NextTime1, WinnerNum};
        _ ->
            NewxTime00 = State#st_1vn.time - util:unixtime(),
            State0 = ?IF_ELSE(Mb#cross_1vn_mb.final_floor >= State#st_1vn.floor, 1, 0),
            NextTime1 = ?IF_ELSE(WinnerNum == 0, erlang:max(0, NewxTime00), NextTime),
            Data = {State0, State#st_1vn.floor - 1, Mb#cross_1vn_mb.score, Exp, ExpUp, NextTime1, WinnerNum}
    end,
    {ok, Bin} = pt_642:write(64214, Data),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

%%获取排名信息
handle_cast({get_rank_info, Group, Pkey, Sid, Page, Node}, State) ->
    F = fun(GroupList, Mb0) ->
        case lists:keyfind(Pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
            false -> Mb0;
            Mb1 -> Mb1
        end
        end,
    Mb = lists:foldl(F, #cross_1vn_mb{}, State#st_1vn.sign_list),
    case lists:keyfind(Group, #cross_1vn_group.group, State#st_1vn.rank_list) of
        false ->
            Data = {0, 0, 0, 0, [], 1, 1, 0, []},
            {ok, Bin} = pt_642:write(64209, Data),
            server_send:send_to_sid(Node, Sid, Bin);
        #cross_1vn_group{mb_list = RankList} ->
            MaxPage = length(RankList) div ?PAGE_NUM + 1,
            NowPage = if Page =< 0 -> 1;
                          Page >= MaxPage -> MaxPage;
                          true -> Page
                      end,
            Rank = NowPage * ?PAGE_NUM - ?PAGE_NUM1,
            List =
                case RankList of
                    [] -> [];
                    _ ->
                        lists:sublist(RankList, Rank, ?PAGE_NUM)
                end,
            F1 = fun(MbInfo) ->
                pack_rank_info(MbInfo)
                 end,
            Info = lists:map(F1, List),

            Reward =
                case data_cross_1vn_rank_reward:get(Mb#cross_1vn_mb.lv_group, Mb#cross_1vn_mb.rank) of
                    [] -> [];
                    Base -> goods:pack_goods(tuple_to_list(Base))
                end,
            Data = {
                Mb#cross_1vn_mb.score,
                Mb#cross_1vn_mb.rank,
                Mb#cross_1vn_mb.win,
                Mb#cross_1vn_mb.lose,
                Reward,
                NowPage, MaxPage, length(RankList), lists:reverse(Info)},
            {ok, Bin} = pt_642:write(64209, Data),
            server_send:send_to_sid(Node, Sid, Bin)
    end,
    {noreply, State};


%%获取决赛排名信息
handle_cast({get_final_rank_info, Group, Pkey, Sid, Page, Node}, State) ->
    F = fun(GroupList, Mb0) ->
        case lists:keyfind(Pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
            false -> Mb0;
            Mb1 -> Mb1
        end
        end,
    Mb = lists:foldl(F, #cross_1vn_mb{}, State#st_1vn.final_rank_list),
    case lists:keyfind(Group, #cross_1vn_group.group, State#st_1vn.final_rank_list) of
        false ->
            Data = {0, 0, 0, 0, 0, [], 1, 1, 0, []},
            {ok, Bin} = pt_642:write(64211, Data),
            server_send:send_to_sid(Node, Sid, Bin);
        Other ->
            #cross_1vn_group{mb_list = RankList} = Other,
            MaxPage = length(RankList) div ?PAGE_NUM + 1,
            NowPage = if Page =< 0 -> 1;
                          Page >= MaxPage -> MaxPage;
                          true -> Page
                      end,
            Rank = NowPage * ?PAGE_NUM - ?PAGE_NUM1,
            List =
                case RankList of
                    [] -> [];
                    _ ->
                        lists:sublist(RankList, Rank, ?PAGE_NUM)
                end,
            F1 = fun(MbInfo) ->
                pack_final_rank_info(MbInfo, State#st_1vn.floor)
                 end,
            Info = lists:map(F1, List),
            Reward =
                case data_cross_1vn_final_rank_reward:get(Mb#cross_1vn_mb.lv_group, Mb#cross_1vn_mb.rank) of
                    [] -> [];
                    Base -> goods:pack_goods(tuple_to_list(Base))
                end,
            Data = {
                Mb#cross_1vn_mb.score,
                Mb#cross_1vn_mb.rank,
                min(6, Mb#cross_1vn_mb.final_floor),
                Mb#cross_1vn_mb.win,
                Mb#cross_1vn_mb.lose,
                Reward, NowPage, MaxPage, length(RankList), Info},
            {ok, Bin} = pt_642:write(64211, Data),
            server_send:send_to_sid(Node, Sid, Bin)
    end,
    {noreply, State};


handle_cast(_msg, State) ->
    {noreply, State}.

handle_info(init_data, State) ->
    {History, HistoryGroup} = cross_1vn_init:dbget_cross_1vn_final_log(),
    {MaxMonth, MaxDay} =
        case HistoryGroup of
            [] -> {0, 0};
            _ -> lists:max(HistoryGroup)
        end,
    HistoryShop =
        case lists:keyfind({MaxMonth, MaxDay}, 1, History) of
            false ->
                ?ERR("History ~p~n", [History]),
                ?ERR("{MaxMonth, MaxDay} ~p~n", [{MaxMonth, MaxDay}]),
                [];
            {_, CrossGroupList} ->
                F = fun(CrossGroup, List) ->
                    F0 = fun(Rank) ->
                        case lists:keyfind(Rank, #cross_1vn_mb.rank, CrossGroup#cross_1vn_group.mb_list) of
                            false -> [];
                            Mb ->
                                [[Mb#cross_1vn_mb.rank,
                                    Mb#cross_1vn_mb.pkey,
                                    Mb#cross_1vn_mb.sn,
                                    Mb#cross_1vn_mb.nickname,
                                    Mb#cross_1vn_mb.career,
                                    Mb#cross_1vn_mb.sex,
                                    Mb#cross_1vn_mb.guild_name,
                                    Mb#cross_1vn_mb.cbp,
                                    Mb#cross_1vn_mb.head_id,
                                    Mb#cross_1vn_mb.wing_id,
                                    Mb#cross_1vn_mb.wepon_id,
                                    Mb#cross_1vn_mb.clothing_id,
                                    Mb#cross_1vn_mb.light_wepon_id,
                                    Mb#cross_1vn_mb.fashion_cloth_id]]
                        end
                         end,
                    List1 = lists:flatmap(F0, [1, 2, 3]),
                    [{CrossGroup#cross_1vn_group.group, List1} | List]
                    end,
                lists:foldl(F, [], CrossGroupList)
        end,
    ?DEBUG("HistoryShop ~p~n", [HistoryShop]),
    {noreply, State#st_1vn{history_info = History, history_shop = HistoryShop, history_group = HistoryGroup}};

%%资格赛准备 20:00  ReadyTime 30分钟 // LastTime 20分钟
handle_info({ready, ReadyTime, LastTime}, State) ->
    reset_scene_copy(),  %% 重置场景分线
    util:cancel_ref([State#st_1vn.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_642:write(64200, {?CROSS_1VN_STATE_READY, ReadyTime}),
    F = fun(Node) ->
        center:apply(Node, cross_1vn_util, set_act_state, [?CROSS_1VN_STATE_READY, Now + ReadyTime]),
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_1vn{
        open_state = ?CROSS_1VN_STATE_READY,
        time = Now + ReadyTime,
        type = ?CROSS_1VN_PLAY_TYPE_0,
        ref = Ref
    },
    {noreply, NewState};

%%资格赛开始  20:30  LastTime 20分钟  150s之后开始匹配
handle_info({start, LastTime}, State) ->
    util:cancel_ref([State#st_1vn.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_642:write(64200, {?CROSS_1VN_STATE_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, cross_1vn_util, set_act_state, [?CROSS_1VN_STATE_START, Now + LastTime]),
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),
    MatchRef = erlang:send_after(?CROSS_1VN_START_READY_TIME * 1000, self(), cross_1vn_match),
    put(cross_1vn_match, MatchRef),
    NewState = State#st_1vn{
        open_state = ?CROSS_1VN_STATE_START,
        time = Now + LastTime,
        floor = 1
    },
    {noreply, NewState};

%%数据匹配 每一轮 100s   结束后 50s等待时间
handle_info(cross_1vn_match, State) when State#st_1vn.open_state == ?CROSS_1VN_STATE_START ->
    misc:cancel_timer(cross_1vn_match),
    erlang:send_after(5000, self(), timer_update),
    ?DEBUG("floor ~p~n", [State#st_1vn.floor]),
    if
        State#st_1vn.floor == 11 ->
            NewList = sort_rank(State#st_1vn.sign_list),
            F1 = fun(GroupList) ->
                Len = length([X || X <- GroupList#cross_1vn_group.mb_list, X#cross_1vn_mb.score > 0]),
%%                 WinnerNum = max(1, Len div 2),
                WinnerNum = max(1, Len div 5),
                WinnerList0 = lists:sublist(GroupList#cross_1vn_group.mb_list, WinnerNum),
                WinnerList1 = lists:map(fun(Mb0) ->
                    Mb0#cross_1vn_mb{final_floor = 1, score = 0, combo = 0, win = 0, lose = 0} end, WinnerList0),
                GroupList#cross_1vn_group{mb_list = WinnerList1}
                 end,
            FinalList = lists:map(F1, NewList),
            FinalList1 = sort_winner_rank(FinalList),

            WinnerBetList1 = init_bet_ratio(FinalList1), %% 选中擂主竞猜

            F2 = fun(GroupList) ->
                Len = length([X || X <- GroupList#cross_1vn_group.mb_list, X#cross_1vn_mb.score > 0]),
%%                 WinnerNum = max(1, Len div 2),
                WinnerNum = max(1, Len div 5),
                WinnerList0 = lists:sublist(GroupList#cross_1vn_group.mb_list, WinnerNum),
                WinnerList2 = lists:sublist(GroupList#cross_1vn_group.mb_list, WinnerNum + 1, Len),
                WinnerList1 = lists:map(fun(Mb0) ->
                    Mb0#cross_1vn_mb{final_floor = 1} end, WinnerList0),
                GroupList#cross_1vn_group{mb_list = WinnerList1 ++ WinnerList2}
                 end,
            NewList2 = lists:map(F2, NewList),
            F = fun(GroupList) ->
                F0 = fun(Mb) ->
                    case data_cross_1vn_rank_reward:get(GroupList#cross_1vn_group.group, Mb#cross_1vn_mb.rank) of
                        [] ->
                            ?ERR("Mb rank err ! ~p~n", [Mb#cross_1vn_mb.rank]),
                            skip;
                        Reward0 ->
                            if
                                Mb#cross_1vn_mb.score =< 0 -> skip;
                                true ->
                                    Reward = tuple_to_list(Reward0),
                                    {Title, Content0} = t_mail:mail_content(154),
                                    Content = io_lib:format(Content0, [Mb#cross_1vn_mb.rank]),
                                    {ok, Bin} = pt_642:write(64215, {Mb#cross_1vn_mb.rank, Mb#cross_1vn_mb.score, Mb#cross_1vn_mb.final_floor, goods:pack_goods(lists:reverse(Reward))}),
                                    center:apply(Mb#cross_1vn_mb.node, server_send, send_to_key, [Mb#cross_1vn_mb.pkey, Bin]),
                                    center:apply(Mb#cross_1vn_mb.node, cross_1vn, set_cross_1vn_winner_state, [Mb#cross_1vn_mb.pkey, Mb#cross_1vn_mb.final_floor, get_fianl_floor_exp(Mb#cross_1vn_mb.final_floor)]),
                                    center:apply(Mb#cross_1vn_mb.node, mail, sys_send_mail, [[Mb#cross_1vn_mb.pkey], Title, Content, lists:reverse(Reward)]),
                                    ok
                            end
                    end
                     end,
                lists:foreach(F0, GroupList#cross_1vn_group.mb_list)
                end,
            lists:foreach(F, NewList2),
            erlang:send_after(?CROSS_1VN_WAIT_TIME * 1000, self(), {final_ready, ?CROSS_1VN_FINAL_READY_TIME, ?CROSS_1VN_FINAL_TOTAL_TIME}),
            F3 = fun(GroupList) ->
                WinnerNum = length(GroupList#cross_1vn_group.mb_list),
                {GroupList#cross_1vn_group.group, WinnerNum}
                 end,
            WinnerList = lists:map(F3, FinalList),
            NewState = State#st_1vn{rank_list = NewList, sign_list = NewList, final_list = FinalList1, final_rank_list = FinalList1, winner_num = WinnerList, winner_bet_list = WinnerBetList1};
        true ->
            MatchRef = erlang:send_after(?CROSS_1VN_NEXT_TIME * 1000, self(), cross_1vn_match),
            put(cross_1vn_match, MatchRef),
            PlayList = cross_1vn_util:match(State#st_1vn.type, State#st_1vn.sign_list, State#st_1vn.floor, State#st_1vn.play_list),
            NewState = State#st_1vn{play_list = PlayList, floor = State#st_1vn.floor + 1}
    end,
    {noreply, NewState#st_1vn{open_state = ?CROSS_1VN_STATE_START}};

%%决赛准备
handle_info({final_ready, ReadyTime, LastTime}, State) ->
    ScenePlayerList = scene_agent:get_scene_player(?SCENE_ID_CROSS_1VN_READY), %% 场景玩家
    spawn(fun() ->
        lists:foreach(fun(ScenePlayer) ->
            util:sleep(util:rand(50, 100)),
            Copy = scene_copy_proc:get_scene_copy(?SCENE_ID_CROSS_1VN_FINAL_READY, 0),
            ScenePlayer#scene_player.pid ! {enter_dungeon_scene, ?SCENE_ID_CROSS_1VN_FINAL_READY, Copy, 20, 40, 0}
                      end, ScenePlayerList)
          end),
    util:cancel_ref([State#st_1vn.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_642:write(64200, {?CROSS_1VN_STATE_FAINAL_READY, LastTime}),
    F = fun(Node) ->
        center:apply(Node, cross_1vn_util, set_act_state, [?CROSS_1VN_STATE_FAINAL_READY, Now + LastTime]),
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {final_start, LastTime}),
    put(final_start, Ref),

    misc:cancel_timer(choose_luck_winner),
    LuckWinnerRef = erlang:send_after(2 * 1000, self(), choose_luck_winner),%% 选出竞猜擂主
    put(choose_luck_winner, LuckWinnerRef),

    NewState = State#st_1vn{
        open_state = ?CROSS_1VN_STATE_FAINAL_READY,
        time = Now + LastTime,
        ref = Ref,
        type = ?CROSS_1VN_PLAY_TYPE_1,
        floor = 1
    },
    {noreply, NewState};


%%决赛开始
handle_info({final_start, LastTime}, State) ->
    util:cancel_ref([State#st_1vn.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_642:write(64200, {?CROSS_1VN_STATE_FAINAL_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, cross_1vn_util, set_act_state, [?CROSS_1VN_STATE_FAINAL_START, Now + LastTime]),
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),
    MatchRef = erlang:send_after(1 * 1000, self(), cross_1vn_final_match),
    put(cross_1vn_final_match, MatchRef),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    NewState = State#st_1vn{
        open_state = ?CROSS_1VN_STATE_FAINAL_START,
        time = Now + LastTime,
        ref = Ref,
        floor = 1
    },
    {noreply, NewState};

%%数据匹配
handle_info(cross_1vn_final_match, State) when State#st_1vn.open_state == ?CROSS_1VN_STATE_FAINAL_START ->
    misc:cancel_timer(cross_1vn_final_match),
    if
        State#st_1vn.floor == 7 ->
            NewList = sort_winner_rank(State#st_1vn.final_list),
            NewFinalList = send_final_mail(NewList), %% 发送决赛结算邮件
            send_winner_bet_mail(NewList, State#st_1vn.winner_bet_list), %% 发送擂主竞猜邮件
            F1 = fun(GroupList) ->
                F10 = fun(Mb) ->
                    case center:get_node_by_sn(Mb#cross_1vn_mb.sn) of
                        false -> skip;
                        Node ->
                            center:apply(Node, server_send, send_node_pkey, [Mb#cross_1vn_mb.pkey, update_cross_1vn_shop])
                    end
                      end,
                lists:foreach(F10, GroupList#cross_1vn_group.mb_list)
                 end,
            lists:foreach(F1, State#st_1vn.sign_list),
            MatchRef = erlang:send_after(20 * 1000, self(), close),
            NewState = State#st_1vn{final_list = NewFinalList, final_rank_list = NewFinalList};
        true ->
            NewList = sort_winner_rank(State#st_1vn.final_list),
            MatchRef = erlang:send_after(?CROSS_1VN_FINAL_NEXT_TIME * 1000, self(), cross_1vn_final_match),
            put(cross_1vn_final_match, MatchRef),
            BetInfoList0 = get_bet_info_list(State),
            BetInfoList = [X || X <- BetInfoList0, X#cross_1vn_bet_info.floor >= State#st_1vn.floor],
            {PlayList, OtherList, NotInSceneList, NewBetInfoList} = cross_1vn_util:final_match(?CROSS_1VN_PLAY_TYPE_1, State#st_1vn.final_list, State#st_1vn.sign_list, State#st_1vn.floor, State#st_1vn.play_list, BetInfoList),
            F = fun(Mb) ->
                {ok, Bin1} = pt_642:write(64217, {?CROSS_1VN_FINAL_NEXT_TIME}),
                center:apply(Mb#cross_1vn_mb.node, server_send, send_to_key, [Mb#cross_1vn_mb.pkey, Bin1])
                end,
            lists:foreach(F, OtherList),
            ?CAST(cross_1vn_proc:get_server_pid(), {update_final_mb_info, NotInSceneList}), %% 未在场景擂主
            ?CAST(cross_1vn_proc:get_server_pid(), {update_bet_info, NewBetInfoList}), %% 更新中场投注挑战者列表
            misc:cancel_timer(choose_luck_winner),
            LuckWinnerRef = erlang:send_after(?CROSS_1VN_FINAL_CHOOSE_LUCK_WINNER_TIME * 1000, self(), choose_luck_winner),%% 选出竞猜擂主
            put(choose_luck_winner, LuckWinnerRef),
            NewWinnerBetList =
                if State#st_1vn.floor == 1 -> State#st_1vn.winner_bet_list;
                    true -> change_bet_ratio(State#st_1vn.winner_bet_list)
                end,
            NewState = State#st_1vn{play_list = PlayList, floor = State#st_1vn.floor + 1, final_rank_list = NewList, winner_bet_list = NewWinnerBetList}
    end,
    {noreply, NewState};

%%擂主赛关闭
handle_info(close, State) ->
    ?DEBUG("close ~n"),
    util:cancel_ref([State#st_1vn.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_642:write(64200, {?CROSS_1VN_STATE_CLOSE, 0}),
    F = fun(Node) ->
        center:apply(Node, cross_1vn_util, set_act_state, [?CROSS_1VN_STATE_CLOSE, 0]),
        center:apply(Node, server_send, send_to_all, [Bin])
        end,
    lists:foreach(F, center:get_nodes()),

    %%
    PlayerList0 = scene_agent:get_scene_player(?SCENE_ID_CROSS_1VN_READY),
    PlayerList1 = scene_agent:get_scene_player(?SCENE_ID_CROSS_1VN_WAR),
    PlayerList2 = scene_agent:get_scene_player(?SCENE_ID_CROSS_1VN_FINAL_READY),
    PlayerList3 = scene_agent:get_scene_player(?SCENE_ID_CROSS_1VN_FINAL_WAR),
    F1 = fun(ScenePlayer) ->
        server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, change_scene_back)
         end,
    lists:foreach(F1, PlayerList0 ++ PlayerList1 ++ PlayerList2 ++ PlayerList3),
    NewFinalList = sort_winner_rank(State#st_1vn.final_list),
    {HistoryInfo, Month, Day} = cross_1vn_init:dbup_cross_1vn_final_log_list(NewFinalList),
    NewHistoryGroup0 =
        case lists:member({Month, Day}, State#st_1vn.history_group) of
            false -> [{Month, Day} | State#st_1vn.history_group];
            true -> State#st_1vn.history_group
        end,
    Len = length(NewHistoryGroup0),
    if
        Len =< 5 ->
            NewHistoryGroup = NewHistoryGroup0,
            NewHistoryInfo = [HistoryInfo | State#st_1vn.history_info];
        true ->
            {MinMonth, MinDay} =
                case NewHistoryGroup0 of
                    [] -> {0, 0};
                    _ -> lists:min(NewHistoryGroup0)
                end,
            HistoryInfo0 = lists:keydelete({MinMonth, MinDay}, 1, State#st_1vn.history_info),
            NewHistoryGroup = lists:delete({MinMonth, MinDay}, NewHistoryGroup0),
            cross_1vn_init:dbdelete_history(MinMonth, MinDay),
            NewHistoryInfo = [HistoryInfo | HistoryInfo0]
    end,
    erlang:send_after(5000, self(), init_data),

    NewState = cross_1vn_proc:set_timer(State#st_1vn{history_info = NewHistoryInfo, history_group = NewHistoryGroup}, Now),
    {noreply, NewState};


%% 选出竞猜擂主
handle_info(choose_luck_winner, State) when State#st_1vn.open_state >= ?CROSS_1VN_STATE_FAINAL_READY ->
%%     ?DEBUG("choose_luck_winner ~n"),
%%     ?DEBUG("choose_luck_winner ~n"),
    NextTime =
        case misc:read_timer(cross_1vn_final_match) of
            false ->
                0;
            Time -> Time div 1000
        end,
    if
        (NextTime == 0 orelse NextTime > 60) andalso State#st_1vn.floor =/= 1 ->
            misc:cancel_timer(choose_luck_winner),
            LuckWinnerRef = erlang:send_after(10 * 1000, self(), choose_luck_winner),%% 选出竞猜擂主
            put(choose_luck_winner, LuckWinnerRef),
            {noreply, State};
        true ->
            NewFinalList = sort_winner_rank(State#st_1vn.final_list),
%%             ?ERR(" State#st_1vn.bet_list ~p~n",[ State#st_1vn.bet_list]),
            F = fun(Cross1vnGroup, BetList) ->
%%                 ?ERR(" BetList ~p~n",[ BetList]),
%%                 ?ERR("Cross1vnGroup#cross_1vn_group.group ~p~n", [Cross1vnGroup#cross_1vn_group.group]),
%%                 ?ERR("State#st_1vn.floor ~p~n", [State#st_1vn.floor]),
                case lists:keyfind({Cross1vnGroup#cross_1vn_group.group, State#st_1vn.floor}, #cross_1vn_bet_info.key, BetList) of
                    false ->
%%                         ?DEBUG("false false false~n"),
                        List = [X || X <- Cross1vnGroup#cross_1vn_group.mb_list, X#cross_1vn_mb.final_floor >= State#st_1vn.floor, X#cross_1vn_mb.is_lose == 0],
                        if
                            List == [] ->
                                misc:cancel_timer(choose_luck_winner),
                                LuckWinnerRef = erlang:send_after(10 * 1000, self(), choose_luck_winner),%% 选出竞猜擂主
                                put(choose_luck_winner, LuckWinnerRef),
                                BetList;
                            true ->
                                Len = length(List),
                                RandList = lists:sublist(List, util:ceil(Len / 5), util:ceil(Len * 4 / 5)),
                                LuckMb = util:list_rand(RandList),
                                [#cross_1vn_bet_info{key = {Cross1vnGroup#cross_1vn_group.group, State#st_1vn.floor}, group = Cross1vnGroup#cross_1vn_group.group, floor = State#st_1vn.floor, pkey = LuckMb#cross_1vn_mb.pkey, state = 1, winner = LuckMb} | BetList]
                        end;
                    _ ->
%%                         ?DEBUG("true true true~n"),
                        BetList
                end
                end,
            NewBetList = lists:foldl(F, State#st_1vn.bet_list, NewFinalList),
            {noreply, State#st_1vn{final_list = NewFinalList, final_rank_list = NewFinalList, bet_list = NewBetList}}
    end;

handle_info(show, State) ->
    ?DEBUG("floor ~p~n", [State#st_1vn.floor]),
%%     ?DEBUG("bet_list ~p~n", [State#st_1vn.bet_list]),
    F = fun(Cross1vnBetInfo) ->
        ?DEBUG("key  ~p~n", [Cross1vnBetInfo#cross_1vn_bet_info.key]),
        ?DEBUG("winner ~p~n", [Cross1vnBetInfo#cross_1vn_bet_info.winner])
        end,
    lists:foreach(F, State#st_1vn.bet_list),

    ?DEBUG(" winner_bet_list ~p~n", [State#st_1vn.winner_bet_list]),
    {noreply, State};

handle_info(show1, State) ->
    ?DEBUG(" open_state ~p~n", [State#st_1vn.bet_list]),
    L = get_bet_info_list(State),
    ?DEBUG(" L  ~p~n", [L]),

    {noreply, State};

handle_info(show2, State) ->
    F = fun(GroupList) ->
        F0 = fun(Mb) ->
            [{Mb#cross_1vn_mb.pkey,
                Mb#cross_1vn_mb.sn,
                Mb#cross_1vn_mb.win,
                Mb#cross_1vn_mb.lose,
                Mb#cross_1vn_mb.score,
                Mb#cross_1vn_mb.lv_group}]
             end,
        lists:flatmap(F0, GroupList#cross_1vn_group.mb_list)
        end,
    List1 = lists:map(F, State#st_1vn.sign_list),
    write_to_text(List1),
    F2 = fun(GroupList) ->
        F20 = fun(Mb) ->
            [{Mb#cross_1vn_mb.pkey,
                Mb#cross_1vn_mb.sn,
                Mb#cross_1vn_mb.lv_group,
                Mb#cross_1vn_mb.rank,
                Mb#cross_1vn_mb.final_floor,
                Mb#cross_1vn_mb.win,
                Mb#cross_1vn_mb.lose,
                Mb#cross_1vn_mb.score,
                Mb#cross_1vn_mb.is_lose
            }]
              end,
        lists:flatmap(F20, GroupList#cross_1vn_group.mb_list)
         end,
    List2 = lists:map(F2, State#st_1vn.final_list),
    write_to_text2(List2),
%%     {config:get_server_num(),List1,List2},
    {noreply, State};

handle_info(cross_1vn_set_floor, State) ->
    ?DEBUG("floor ~p~n", [State#st_1vn.floor]),
    {noreply, State#st_1vn{floor = 1}};

handle_info(reset, State) ->
    ?DEBUG("sign_list ~p~n", [State#st_1vn.time]),
    ?DEBUG("open_state ~p~n", [State#st_1vn.open_state]),
    ?DEBUG("sign_list ~p~n", [State#st_1vn.sign_list]),
    {noreply, #st_1vn{open_state = 1}};

handle_info({reset, Now}, State) ->
    ?DEBUG("1111111~n"),
    ?DEBUG("1111111~n"),
    ?DEBUG("1111111~n"),
    util:cancel_ref([State#st_1vn.ref]),
    if
        Now < 1514995260 ->
            NewState = cross_1vn_proc:set_timer(#st_1vn{}, Now);
        true ->
            NewState = cross_1vn_proc:set_timer(State, Now)
    end,
    {noreply, NewState};

handle_info(timer_update, State) ->
    util:cancel_ref([State#st_1vn.timer_update_ref]),
    Ref = erlang:send_after(?CROSS_1VN_TIMER_UPDATE * 2 * 1000, self(), timer_update),
    if
        State#st_1vn.open_state == 0 ->
            NewList = State#st_1vn.sign_list,
            NewFinalList = State#st_1vn.final_list;
        true ->
            NewList = sort_rank(State#st_1vn.sign_list),
            NewFinalList0 = sort_winner_rank(State#st_1vn.final_list),
            NewFinalList = check_final_state(NewFinalList0) %% 检查分组擂主情况
    end,
    spawn(fun() ->
        F = fun(Node) ->
            center:apply(Node, cross_1vn_util, set_act_state, [State#st_1vn.open_state, State#st_1vn.time])
            end,
        lists:foreach(F, center:get_nodes())
          end),
    {noreply, State#st_1vn{timer_update_ref = Ref, sign_list = NewList, rank_list = NewList, final_list = NewFinalList, final_rank_list = NewFinalList}};

handle_info(_Msg, State) ->
    {noreply, State}.


pack_final_rank_info(MbInfo, Floor) ->
    IsLose =
        if
            MbInfo#cross_1vn_mb.is_lose == 1 -> 1;
            Floor > MbInfo#cross_1vn_mb.final_floor + 1 -> 1;
            true -> 0
        end,
    [
        MbInfo#cross_1vn_mb.rank,
        MbInfo#cross_1vn_mb.pkey,
        MbInfo#cross_1vn_mb.sn,
        MbInfo#cross_1vn_mb.nickname,
        MbInfo#cross_1vn_mb.career,
        MbInfo#cross_1vn_mb.sex,
        MbInfo#cross_1vn_mb.guild_name,
        MbInfo#cross_1vn_mb.guild_position,
        MbInfo#cross_1vn_mb.score,
        min(6, MbInfo#cross_1vn_mb.final_floor),
        IsLose,
        MbInfo#cross_1vn_mb.cbp
    ].

pack_rank_info(MbInfo) ->
    [
        MbInfo#cross_1vn_mb.rank,
        MbInfo#cross_1vn_mb.pkey,
        MbInfo#cross_1vn_mb.sn,
        MbInfo#cross_1vn_mb.nickname,
        MbInfo#cross_1vn_mb.career,
        MbInfo#cross_1vn_mb.sex,
        MbInfo#cross_1vn_mb.guild_name,
        MbInfo#cross_1vn_mb.guild_position,
        MbInfo#cross_1vn_mb.score,
        MbInfo#cross_1vn_mb.win,
        MbInfo#cross_1vn_mb.lose,
        MbInfo#cross_1vn_mb.cbp
    ].

sort_rank(List) ->
    F = fun(GroupList) ->
        F0 = fun(Mb0, Mb1) ->
            if
                Mb0#cross_1vn_mb.score > Mb1#cross_1vn_mb.score -> true;
                Mb0#cross_1vn_mb.score < Mb1#cross_1vn_mb.score -> false;
                Mb0#cross_1vn_mb.cbp > Mb1#cross_1vn_mb.cbp -> true;
                true -> false
            end
             end,
        NewMbList = lists:sort(F0, GroupList#cross_1vn_group.mb_list),
        F = fun(Mb0, {Rank, L}) ->
            {Rank + 1, L ++ [Mb0#cross_1vn_mb{rank = Rank}]} end,
        {_, RankList} = lists:foldl(F, {1, []}, NewMbList),
        GroupList#cross_1vn_group{mb_list = RankList}
        end,
    NewList = lists:map(F, List),
    NewList.

sort_winner_rank(List) ->
    F = fun(GroupList) ->
        F0 = fun(Mb0, Mb1) ->
            if
                Mb0#cross_1vn_mb.final_floor > Mb1#cross_1vn_mb.final_floor -> true;
                Mb0#cross_1vn_mb.final_floor < Mb1#cross_1vn_mb.final_floor -> false;
                Mb0#cross_1vn_mb.score > Mb1#cross_1vn_mb.score -> true;
                Mb0#cross_1vn_mb.score < Mb1#cross_1vn_mb.score -> false;
                Mb0#cross_1vn_mb.cbp > Mb1#cross_1vn_mb.cbp -> true;
                true -> false
            end
             end,
        NewMbList = lists:sort(F0, GroupList#cross_1vn_group.mb_list),
        F = fun(Mb0, {Rank, L}) ->
            {Rank + 1, L ++ [Mb0#cross_1vn_mb{rank = Rank}]} end,
        {_, RankList} = lists:foldl(F, {1, []}, NewMbList),
        GroupList#cross_1vn_group{mb_list = RankList}
        end,
    NewList = lists:map(F, List),
    NewList.

get_fianl_floor_exp(Floor) ->
    Len = length(data_cross_1vn_fianl_floor_exp:get_all()),
    case data_cross_1vn_fianl_floor_exp:get(min(Len, Floor)) of
        [] -> 0;
        Other -> Other / 100
    end.


make_history_info(MbList) ->
    F = fun(Mb) ->
        [Mb#cross_1vn_mb.rank,
            Mb#cross_1vn_mb.sn,
            Mb#cross_1vn_mb.pkey,
            Mb#cross_1vn_mb.nickname,
            Mb#cross_1vn_mb.vip,
            Mb#cross_1vn_mb.lv_group,
            Mb#cross_1vn_mb.guild_name]
        end,
    lists:map(F, MbList).

get_num(Floor) when Floor == 1 -> 2;
get_num(Floor) when Floor == 2 -> 4;
get_num(Floor) when Floor == 3 -> 6;
get_num(Floor) when Floor == 4 -> 10;
get_num(Floor) when Floor == 5 -> 15;
get_num(Floor) when Floor == 6 -> 20;
get_num(Floor) when Floor == 7 -> 20;
get_num(_) -> 0.


%% 写入文本
write_to_text(Sign) ->
    FileName = io_lib:format("../cross_1vn_~p.txt", [node()]),
    {ok, S} = file:open(FileName, write),
    io:format(S, "nodes ~p ~n ~p   ~n", [nodes(), Sign]),
    file:close(S).

%% 写入文本
write_to_text2(Sign) ->
    FileName = io_lib:format("../cross_1vn2_~p.txt", [node()]),
    {ok, S} = file:open(FileName, write),
    io:format(S, "nodes ~p ~n ~p   ~n", [nodes(), Sign]),
    file:close(S).

hot() ->
    cross_1vn_proc:get_server_pid() ! show2,
    ok.

get_bet_text(1) -> ?T("赢");
get_bet_text(2) -> ?T("输");
get_bet_text(_) -> ?T("").


%% 获取当前最大中场投注信息
get_bet_info_list(State) ->
%%     ?DEBUG("State#st_1vn.final_list ~p~n", [State#st_1vn.final_list]),
%%     ?DEBUG("State#st_1vn.final_list ~p~n", [State#st_1vn.bet_list]),
    F = fun(Cross1vnGroup, {[BetInfoList | T], MaxBetInfoList}) ->
        List = [X || X <- State#st_1vn.bet_list, X#cross_1vn_bet_info.group == Cross1vnGroup#cross_1vn_group.group],
        if
            List == [] -> {BetInfoList, MaxBetInfoList};
            true ->
                F0 = fun(Cross1vnBetInfo, MaxCross1vnBetInfo) ->
                    if
                        Cross1vnBetInfo#cross_1vn_bet_info.floor >= MaxCross1vnBetInfo#cross_1vn_bet_info.floor ->
                            Cross1vnBetInfo;
                        true -> MaxCross1vnBetInfo
                    end
                     end,
                MaxBetInfoList0 = lists:foldl(F0, #cross_1vn_bet_info{}, List),
%%                 ?DEBUG("MaxBetInfoList0 ~p~n",[MaxBetInfoList0]),
%%                 ?DEBUG("MaxBetInfoList0 ~p~n", [MaxBetInfoList0]),
                {T, [MaxBetInfoList0 | MaxBetInfoList]}
        end
        end,
    {_, NewBetList} = lists:foldl(F, {State#st_1vn.bet_list, []}, State#st_1vn.final_list),
    NewBetList.

pack_bet_player_info(List) ->
%%     ?DEBUG("List ~p~n", [List]),
    F = fun(Mb) ->
        [
            Mb#cross_1vn_mb.pkey,
            Mb#cross_1vn_mb.sn,
            Mb#cross_1vn_mb.nickname,
            Mb#cross_1vn_mb.career,
            Mb#cross_1vn_mb.sex,
            Mb#cross_1vn_mb.guild_name,
            Mb#cross_1vn_mb.cbp,
            Mb#cross_1vn_mb.head_id,
            Mb#cross_1vn_mb.avatar
        ]
        end,
    lists:map(F, List).


%% 初始化下注赔率
init_bet_ratio(FinalList) ->
    Len = length(FinalList),
    Ranks =
        if Len =< 10 -> lists:seq(1, 3); %% 选出三名擂主
            true -> lists:seq(1, 6) %% 选出六名擂主
        end,
    F = fun(GroupList, WinnerBetList) ->
        F0 = fun(Rank) ->
            case lists:keyfind(Rank, #cross_1vn_mb.rank, GroupList#cross_1vn_group.mb_list) of
                false -> [];
                Mb ->
                    case data_cross_1vn_bet_winner_ratio:get(Mb#cross_1vn_mb.rank) of
                        [] -> [Mb];
                        Ratio ->
                            [Mb#cross_1vn_mb{ratio = Ratio}]
                    end
            end
             end,
        RankList = lists:flatmap(F0, Ranks),
        [#cross_1vn_group{group = GroupList#cross_1vn_group.group, mb_list = RankList} | WinnerBetList]
        end,
    lists:foldl(F, [], FinalList).


%% 下注赔率变化
change_bet_ratio(WinnerBetList0) ->
    WinnerBetList = sort_winner_rank(WinnerBetList0),
    F = fun(GroupList) ->
        F0 = fun(Mb) ->
            if
                Mb#cross_1vn_mb.is_lose == 1 -> Mb;
                true ->
                    case data_cross_1vn_bet_winner_ratio_change:get_ratio_change(Mb#cross_1vn_mb.rank) of
                        [] -> Mb;
                        {Type, RandDown, RandTop} ->
                            Rand = util:rand(util:floor(RandDown * 100), util:floor(RandTop * 100)),
                            NewMb =
                                case Type of
                                    1 ->
                                        Mb#cross_1vn_mb{ratio = max(1.01, Mb#cross_1vn_mb.ratio - Rand / 100)};
                                    _ ->
                                        Mb#cross_1vn_mb{ratio = max(1.01, Mb#cross_1vn_mb.ratio + Rand / 100)}
                                end,
                            spawn(fun() -> stage_notice(NewMb) end),
                            NewMb
                    end
            end
             end,
        RankList = lists:map(F0, GroupList#cross_1vn_group.mb_list),
        GroupList#cross_1vn_group{mb_list = RankList}
        end,
    lists:map(F, WinnerBetList).

%% 赔率变化公告
stage_notice(Mb) ->
    case version:get_lan_config() of
        korea -> skip;
        _ ->
            Id =
                if Mb#cross_1vn_mb.lv_group == 1 -> 292;
                    true -> 294
                end,
            F = fun(Node) ->
                center:apply(Node, notice_sys, add_notice, [cross_1vn_ratio_change, [Mb#cross_1vn_mb.sn, Mb#cross_1vn_mb.nickname, Mb#cross_1vn_mb.ratio, Id]])
                end,
            lists:foreach(F, center:get_nodes()),
            ok
    end.

update_final_mb_info(StFinalList, MbList) ->
    F = fun(Mb, SignList) ->
        case cross_1vn_util:get_group(Mb#cross_1vn_mb.lv) of
            [] -> SignList;
            Group ->
                case lists:keytake(Group, #cross_1vn_group.group, SignList) of
                    false -> SignList;
                    {value, GroupList, T} ->
                        case lists:keytake(Mb#cross_1vn_mb.pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
                            false ->
                                SignList;
                            {value, _, T0} ->
                                cross_1vn_init:dbup_cross_1vn_mb(Mb),
                                center:apply(Mb#cross_1vn_mb.node, cross_1vn, set_cross_1vn_winner_state, [Mb#cross_1vn_mb.pkey, Mb#cross_1vn_mb.final_floor, get_fianl_floor_exp(Mb#cross_1vn_mb.final_floor)]),
                                [GroupList#cross_1vn_group{mb_list = [Mb | T0]} | T]
                        end
                end
        end
        end,
    lists:foldl(F, StFinalList, MbList).

%%更新冠军人数
update_winner_num(StWinnerNum, MbList) ->
    F0 = fun(Mb0, WinnerNum) ->
        if
            Mb0#cross_1vn_mb.is_lose == 0 -> WinnerNum;
            true ->
                case lists:keytake(Mb0#cross_1vn_mb.lv_group, 1, WinnerNum) of
                    false -> WinnerNum;
                    {value, {Group, Num}, T} ->
                        [{Group, max(0, Num - 1)} | T]
                end
        end
         end,
    lists:foldl(F0, StWinnerNum, MbList).


%%更新中场投注信息
update_bet_info(StBetList, MbList, Floor) ->
    F1 = fun(Mb0, BetList) ->
        case lists:keytake({Mb0#cross_1vn_mb.lv_group, Floor - 1}, #cross_1vn_bet_info.key, BetList) of
            false ->
                BetList;
            {value, Cross1vnBetInfo, T} ->
                if
                    Mb0#cross_1vn_mb.pkey =/= Cross1vnBetInfo#cross_1vn_bet_info.pkey ->
                        BetList;
                    Cross1vnBetInfo#cross_1vn_bet_info.state >= 3 ->
                        BetList; %% 已经结算
                    true ->
                        if
                            Mb0#cross_1vn_mb.is_lose == 0 ->  %% 擂主胜利
                                WinList = [X || X <- Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list, X#cross_1vn_final_player_bet_info.type == 1],
                                LoseList = [X || X <- Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list, X#cross_1vn_final_player_bet_info.type == 2],
                                NewCross1vnBetInfo0 = Cross1vnBetInfo#cross_1vn_bet_info{state = 3};
                            true -> %% 挑战者胜利
                                WinList = [X || X <- Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list, X#cross_1vn_final_player_bet_info.type == 2],
                                LoseList = [X || X <- Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list, X#cross_1vn_final_player_bet_info.type == 1],
                                NewCross1vnBetInfo0 = Cross1vnBetInfo#cross_1vn_bet_info{state = 4}
                        end,
                        F2 = fun(MbBet) ->
                            {Title, Content0} = t_mail:mail_content(159),
                            Content = io_lib:format(Content0, [Mb0#cross_1vn_mb.nickname, get_bet_text(MbBet#cross_1vn_final_player_bet_info.type)]),
                            center:apply_sn(MbBet#cross_1vn_final_player_bet_info.sn, mail, sys_send_mail, [[MbBet#cross_1vn_final_player_bet_info.pkey], Title, Content, lists:reverse([{10106, util:floor(MbBet#cross_1vn_final_player_bet_info.cost * MbBet#cross_1vn_final_player_bet_info.ratio)}])])
                             end,
                        lists:map(F2, WinList),
                        F3 = fun(MbBet) ->
                            {Title, Content0} = t_mail:mail_content(160),
                            Content = io_lib:format(Content0, [Mb0#cross_1vn_mb.nickname, get_bet_text(MbBet#cross_1vn_final_player_bet_info.type)]),
                            center:apply_sn(MbBet#cross_1vn_final_player_bet_info.sn, mail, sys_send_mail, [[MbBet#cross_1vn_final_player_bet_info.pkey], Title, Content, []])
                             end,
                        lists:map(F3, LoseList),
                        [NewCross1vnBetInfo0 | T]
                end
        end
         end,
    lists:foldl(F1, StBetList, MbList).

update_winner_bet_info(WinnerBetList, MbList, _Floor) ->
    F = fun(Mb, SignList) ->
        case cross_1vn_util:get_group(Mb#cross_1vn_mb.lv) of
            [] -> SignList;
            Group ->
                case lists:keytake(Group, #cross_1vn_group.group, SignList) of
                    false -> SignList;
                    {value, GroupList, T} ->
                        case lists:keytake(Mb#cross_1vn_mb.pkey, #cross_1vn_mb.pkey, GroupList#cross_1vn_group.mb_list) of
                            false ->
                                SignList;
                            {value, Mb0, T0} ->
                                cross_1vn_init:dbup_cross_1vn_mb(Mb),
                                NewMb = Mb0#cross_1vn_mb{
                                    score = Mb#cross_1vn_mb.score,
                                    is_lose = Mb#cross_1vn_mb.is_lose,
                                    final_floor = Mb#cross_1vn_mb.final_floor
                                },
                                [GroupList#cross_1vn_group{mb_list = [NewMb | T0]} | T]
                        end
                end
        end
        end,
    lists:foldl(F, WinnerBetList, MbList).

send_final_mail(NewList) ->
    F = fun(GroupList) ->
        if
            GroupList#cross_1vn_group.is_final == 1 -> GroupList;
            true ->
                F0 = fun(Mb) ->
                    case data_cross_1vn_final_rank_reward:get(GroupList#cross_1vn_group.group, Mb#cross_1vn_mb.rank) of
                        [] ->
                            skip;
                        Reward0 ->
                            Reward = tuple_to_list(Reward0),
                            {Title, Content0} = t_mail:mail_content(155),
                            Content = io_lib:format(Content0, [Mb#cross_1vn_mb.rank]),
                            {ok, Bin} = pt_642:write(64216, {Mb#cross_1vn_mb.rank, Mb#cross_1vn_mb.score, Mb#cross_1vn_mb.final_floor, goods:pack_goods(lists:reverse(Reward))}),
                            center:apply(Mb#cross_1vn_mb.node, server_send, send_to_key, [Mb#cross_1vn_mb.pkey, Bin]),
                            center:apply(Mb#cross_1vn_mb.node, mail, sys_send_mail, [[Mb#cross_1vn_mb.pkey], Title, Content, lists:reverse(Reward)]),
%%                             cross_1vn_init:dbup_cross_1vn_final_log(Mb, Month, Day),
                            ok
                    end
                     end,
                lists:foreach(F0, GroupList#cross_1vn_group.mb_list),
                GroupList#cross_1vn_group{is_final = 1}
        end
        end,
    lists:map(F, NewList).


send_winner_bet_mail(MbList, WinnerBetList) ->
    F = fun(GroupList) ->
        F0 = fun(Mb) ->
            F1 = fun(MbGroup) ->
                case lists:keyfind(Mb#cross_1vn_mb.pkey, #cross_1vn_mb.pkey, MbGroup#cross_1vn_group.mb_list) of
                    false -> skip;
                    FinalMb ->
                        if
                            FinalMb#cross_1vn_mb.rank == 1 -> %% 最终擂主
                                F2 = fun({Pkey, Sn, Cost, Ratio}) ->
                                    {Title, Content0} = t_mail:mail_content(161),
                                    Content = io_lib:format(Content0, [Mb#cross_1vn_mb.nickname]),
                                    center:apply_sn(Sn, mail, sys_send_mail, [[Pkey], Title, Content, [{10199, util:floor(Cost * Ratio)}]])
                                     end,
                                lists:foreach(F2, Mb#cross_1vn_mb.bet_list);
                            true ->
                                F2 = fun({Pkey, Sn, _Cost, _Ratio}) ->
                                    {Title, Content0} = t_mail:mail_content(162),
                                    Content = io_lib:format(Content0, [Mb#cross_1vn_mb.nickname]),
                                    center:apply_sn(Sn, mail, sys_send_mail, [[Pkey], Title, Content, []])
                                     end,
                                lists:foreach(F2, Mb#cross_1vn_mb.bet_list)
                        end
                end
                 end,
            lists:foreach(F1, MbList)
             end,
        lists:foreach(F0, GroupList#cross_1vn_group.mb_list)
        end,
    lists:foreach(F, WinnerBetList).

%% 获取自身投注记录
get_my_bet_history(Pkey, BetList) ->
    F = fun(Cross1vnBetInfo) ->
        case lists:keyfind(Pkey, #cross_1vn_final_player_bet_info.pkey, Cross1vnBetInfo#cross_1vn_bet_info.player_bet_list) of
            false -> [];
            Info ->
                Winner = Cross1vnBetInfo#cross_1vn_bet_info.winner,
                Result =
                    if
                        Cross1vnBetInfo#cross_1vn_bet_info.state =< 2 -> 0;
                        Cross1vnBetInfo#cross_1vn_bet_info.state == 3 ->
                            1;
                        true ->
                            2
                    end,
                ?DEBUG("Result ~p~n", [Result]),
                [[1,
                    Winner#cross_1vn_mb.nickname,
                    Winner#cross_1vn_mb.sn,
                    Info#cross_1vn_final_player_bet_info.cost,
                    util:floor(Info#cross_1vn_final_player_bet_info.ratio * 100),
                    Info#cross_1vn_final_player_bet_info.type,
                    Result
                ]]
        end
        end,
    lists:flatmap(F, BetList).

get_my_final_bet_history(Pkey, BetList) ->
    F = fun(Cross1vnGroup, WinBet) ->
        F0 = fun(Mb) ->
            List1 = [[2, Mb#cross_1vn_mb.nickname, Mb#cross_1vn_mb.sn, Cost, util:floor(Ratio * 100), 1, 0] || {Pkey0, _Sn, Cost, Ratio} <- Mb#cross_1vn_mb.bet_list, Pkey0 == Pkey],
            List1
             end,
        List1 = lists:flatmap(F0, Cross1vnGroup#cross_1vn_group.mb_list),
        List1 ++ WinBet
        end,
    lists:foldl(F, [], BetList).


check_final_state(FinalList) ->
    F = fun(GroupList) ->
        Len = length([X || X <- GroupList#cross_1vn_group.mb_list, X#cross_1vn_mb.is_lose == 0]),
        if
            GroupList#cross_1vn_group.is_final == 0 andalso Len == 0 ->
                [NewGroupList] = send_final_mail([GroupList]),
                NewGroupList;
            true ->
                GroupList
        end
        end,
    lists:map(F, FinalList).

reset_scene_copy() ->
    scene_copy_proc:reset_scene_copy(?SCENE_ID_CROSS_1VN_READY),
    scene_copy_proc:reset_scene_copy(?SCENE_ID_CROSS_1VN_WAR),
    scene_copy_proc:reset_scene_copy(?SCENE_ID_CROSS_1VN_FINAL_READY),
    scene_copy_proc:reset_scene_copy(?SCENE_ID_CROSS_1VN_FINAL_WAR),
    ok.


