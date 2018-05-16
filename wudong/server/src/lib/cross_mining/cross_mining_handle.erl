%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 四月 2018 上午11:28
%%%-------------------------------------------------------------------
-module(cross_mining_handle).
-author("luobaqun").
-include("server.hrl").
-include("common.hrl").
-include("cross_mining.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).


handle_call(_Msg, _from, State) ->
    {reply, ok, State}.


%%获取分矿信息
handle_cast({get_mine_info, Node, Sid, Type, Page, Pid, Pkey}, State) ->
    case lists:keyfind({Type, Page}, #mining_info.key, State#st_cross_mining_manage.mining_list) of
        false ->
            ?ERR("not find mine type: ~p page: ~p~n", [Type, Page]),
            skip;
        PageInfo ->
            PageInfo#mining_info.mid ! {get_mine_info, Node, Sid, Pid, Pkey, State#st_cross_mining_manage.max_page}
    end,
    {noreply, State};

%%  进攻矿点
handle_cast({att_mine, Node, Sid, Pid, Type, Page, Id, Pkey, Sn, Cbp, Pname, GuildName, Sex, Avatar, Vip, Dvip}, State) ->
    case lists:keyfind({Type, Page}, #mining_info.key, State#st_cross_mining_manage.mining_list) of
        false ->
            ?ERR("not find mine type: ~p page: ~p id:~p~n", [Type, Page, Id]),
            skip;
        PageInfo ->
            PageInfo#mining_info.mid ! {att_mine, Node, Sid, Pid, Type, Page, Id, Pkey, Sn, Cbp, Pname, GuildName, Sex, Avatar, Vip, Dvip}
    end,
    {noreply, State};

%%  进攻小偷
handle_cast({att_thief, Node, Sid, Type, Page, Id, Pkey, Pname, Cbp, Sn, Vip, Dvip}, State) ->
    case lists:keyfind({Type, Page}, #mining_info.key, State#st_cross_mining_manage.mining_list) of
        false ->
            ?ERR("not find mine type: ~p page: ~p id:~p~n", [Type, Page, Id]),
            skip;
        PageInfo ->
            PageInfo#mining_info.mid ! {att_thief, Node, Sid, Type, Page, Id, Pkey, Pname, Cbp, Sn, Vip, Dvip}
    end,
    {noreply, State};


%%  退出矿洞
handle_cast({exit_mine, Node, Sid, Type, Page, Pkey}, State) ->
    case lists:keyfind({Type, Page}, #mining_info.key, State#st_cross_mining_manage.mining_list) of
        false ->
            ?ERR("not find mine type: ~p page: ~p~n", [Type, Page]),
            skip;
        PageInfo ->
            PageInfo#mining_info.mid ! {exit_mine, Node, Sid, Pkey}
    end,
    {noreply, State};

%%  手动收获
handle_cast({get_mine_reward, Node, Sid, Type, Page, Id, Pkey, Pid}, State) ->
    case lists:keyfind({Type, Page}, #mining_info.key, State#st_cross_mining_manage.mining_list) of
        false ->
            ?ERR("not find mine type: ~p page: ~p~n", [Type, Page]),
            skip;
        PageInfo ->
            PageInfo#mining_info.mid ! {get_mine_reward, Node, Sid, Type, Page, Id, Pkey, Pid}
    end,
    {noreply, State};


%%  刷新分矿
handle_cast(time_reset_mining, State) ->
    NewActive =
        if
            State#st_cross_mining_manage.active == 0 ->
                Nodes = ets:tab2list(?ETS_KF_NODES),
                AllActive = lists:sum([Node#ets_kf_nodes.cbp_len || Node <- Nodes, Node#ets_kf_nodes.type == ?CROSS_NODE_TYPE_NORMAL]),
                AllActive;
            true ->
                State#st_cross_mining_manage.active
        end,
    Page = data_mining_active:get(NewActive),
    {NewMiningList, NewMaxPage} =
        if
            Page > State#st_cross_mining_manage.max_page ->
                F2 = fun(Page0) ->
                    F3 = fun(Type) ->
                        {ok, Mid} = cross_mining_paging:start(Type, Page0 + State#st_cross_mining_manage.max_page, []),
                        #mining_info{
                            key = {Type, Page0 + State#st_cross_mining_manage.max_page},
                            type = Type,
                            page = Page0 + State#st_cross_mining_manage.max_page,
                            mid = Mid
                        }
                         end,
                    lists:map(F3, ?MINERAL_TYPE_LIST)
                     end,
                NewminingList0 = lists:flatmap(F2, lists:seq(1, Page - State#st_cross_mining_manage.max_page)),

                lists:foreach(fun(MiningInfo) ->
                    MiningInfo#mining_info.mid ! time_reset_mining end, State#st_cross_mining_manage.mining_list ++ NewminingList0),
                {State#st_cross_mining_manage.mining_list ++ NewminingList0, Page};
            true ->
                lists:foreach(fun(MiningInfo) ->
                    MiningInfo#mining_info.mid ! time_reset_mining end, State#st_cross_mining_manage.mining_list),
                {State#st_cross_mining_manage.mining_list, State#st_cross_mining_manage.max_page}
        end,
    {noreply, State#st_cross_mining_manage{active = NewActive, mining_list = NewMiningList, max_page = NewMaxPage}};


%% 灵宝出世
handle_cast(time_mining_meet, State) ->
    Base = data_mining_event:get(?EVENT_TYPE_1),
    {L, R} = Base#base_mining_event.num,
    Num = util:rand(L, R),
    RatioList = Base#base_mining_event.ratio,
    RatioAll = lists:sum([Ratio || {_, Ratio} <- Base#base_mining_event.ratio]),
    F = fun(MType) ->
        case lists:keyfind(MType, 1, RatioList) of
            false -> skip;
            {_, Ratio0} ->
                Num0 = Num * Ratio0 div RatioAll,
                MineList = [X || X <- State#st_cross_mining_manage.mining_list, X#mining_info.type == MType],
                Len = length(MineList),
                {Flag, Num1} =
                    if
                        Len >= Num0 ->
                            {0, Num0};
                        true ->
                            {Num0 div Len, Num0 rem Len}
                    end,
                if
                    Flag == 0 ->
                        List = util:get_random_list(State#st_cross_mining_manage.mining_list, Num1),
                        lists:foreach(fun(MiningInfo) ->
                            MiningInfo#mining_info.mid ! {time_mining_meet, Flag + 1} end, List);
                    true ->
                        List = util:get_random_list(State#st_cross_mining_manage.mining_list, Num1),
                        lists:foreach(fun(MiningInfo) ->
                            MiningInfo#mining_info.mid ! {time_mining_meet, Flag + 1} end, List),
                        lists:foreach(fun(MiningInfo) ->
                            MiningInfo#mining_info.mid ! {time_mining_meet, Flag} end, State#st_cross_mining_manage.mining_list -- [List])
                end
        end
        end,
    lists:foreach(F, ?MINERAL_TYPE_LIST),
    {noreply, State};

%% 小偷
handle_cast(time_mining_thief, State) ->
    Base = data_mining_event:get(?EVENT_TYPE_2),
    {L, R} = Base#base_mining_event.num,
    Num = util:rand(L, R),
    RatioList = Base#base_mining_event.ratio,
    RatioAll = lists:sum([Ratio || {_, Ratio} <- Base#base_mining_event.ratio]),
    F = fun(MType) ->
        case lists:keyfind(MType, 1, RatioList) of
            false -> skip;
            {_, Ratio0} ->
                Num0 = Num * Ratio0 div RatioAll,
                MineList = [X || X <- State#st_cross_mining_manage.mining_list, X#mining_info.type == MType],
                Len = length(MineList),
                {Flag, Num1} =
                    if
                        Len >= Num0 ->
                            {0, Num0};
                        true ->
                            {Num0 div Len, Num0 rem Len}
                    end,
                if
                    Flag == 0 ->
                        List = util:get_random_list(State#st_cross_mining_manage.mining_list, Num1),
                        lists:foreach(fun(MiningInfo) ->
                            MiningInfo#mining_info.mid ! {time_mining_thief, Flag + 1} end, List);
                    true ->
                        List = util:get_random_list(State#st_cross_mining_manage.mining_list, Num1),
                        lists:foreach(fun(MiningInfo) ->
                            MiningInfo#mining_info.mid ! {time_mining_thief, Flag + 1} end, List),
                        lists:foreach(fun(MiningInfo) ->
                            MiningInfo#mining_info.mid ! {time_mining_thief, Flag} end, State#st_cross_mining_manage.mining_list -- [List])
                end
        end
        end,
    lists:foreach(F, ?MINERAL_TYPE_LIST),
    {noreply, State};



handle_cast({add_score, Pkey, Nickname, Sn, Vip, Dvip, Cbp, Score}, State) ->
    NewState =
        case lists:keytake(Pkey, #mining_info_rank.pkey, State#st_cross_mining_manage.play_list) of
            {value, Mb, T} ->
                NewMb = Mb#mining_info_rank{pkey = Pkey, sn = Sn, vip = Vip, nickname = Nickname, cbp = Cbp, score = Mb#mining_info_rank.score + Score, dvip = Dvip},
                cross_mining_load:dbup_cross_mining_rank(NewMb),
                State#st_cross_mining_manage{play_list = [NewMb | T]};
            false ->
                NewMb = #mining_info_rank{pkey = Pkey, sn = Sn, nickname = Nickname, cbp = Cbp, vip = Vip, score = Score, dvip = Dvip},
                cross_mining_load:dbup_cross_mining_rank(NewMb),
                State#st_cross_mining_manage{play_list = [NewMb | State#st_cross_mining_manage.play_list]}
        end,
    {noreply, NewState};


handle_cast({get_rank_info, Node, Sid, Pkey}, State) ->
    {MyRank, MyScore} =
        case lists:keyfind(Pkey, #mining_info_rank.pkey, State#st_cross_mining_manage.play_list) of
            false ->
                {0, 0};
            Mb ->
                {Mb#mining_info_rank.rank, Mb#mining_info_rank.score}
        end,
    NowSec = util:get_seconds_from_midnight(),
    Data = cross_mining_util:make_mine_info_60417(State#st_cross_mining_manage.rank_list),
    {ok, Bin} = pt_604:write(60417, {MyRank, MyScore, 3600 - (NowSec rem 3600), Data}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

handle_cast({cross_help_friend, Node, Sid, Pid, Key, Type, Page, Id, Pkey, HelpInfo}, State) ->
    case lists:keyfind({Type, Page}, #mining_info.key, State#st_cross_mining_manage.mining_list) of
        false ->
            ?ERR("not find mine type: ~p page: ~p~n", [Type, Page]),
            skip;
        PageInfo ->
            PageInfo#mining_info.mid ! {cross_help_friend, Node, Sid,  Pid,Key, Type, Page, Id, Pkey, HelpInfo}
    end,
    {noreply, State};



handle_cast(time_reset_mining_rank, State) ->
    RankList0 = cross_mining_util:sort_rank_list(State#st_cross_mining_manage.play_list),
    F0 = fun(Mb, {Rank0, List0}) ->
        {Rank0 + 1, [Mb#mining_info_rank{rank = Rank0} | List0]}
         end,
    {_, RankList} = lists:foldl(F0, {1, []}, RankList0),
    {noreply, State#st_cross_mining_manage{rank_list = RankList}};


handle_cast(delete_rank, State) ->
    cross_mining_util:clean_rank(),
    {noreply, State#st_cross_mining_manage{play_list = [], rank_list = []}};


handle_cast(end_reward, State) ->
    RankList0 = cross_mining_util:sort_rank_list(State#st_cross_mining_manage.play_list),
    F = fun(Mb) ->
        if
            Mb#mining_info_rank.sn == 0 -> skip;
            true ->
                case data_cross_mining_rank:get(Mb#mining_info_rank.rank) of
                    [] -> skip;
                    GoodsList ->
                        center:apply_sn(Mb#mining_info_rank.sn, cross_mining_notice, send_rank_mail, [Mb#mining_info_rank.pkey, Mb#mining_info_rank.rank, GoodsList])
                end
        end
        end,
    lists:foreach(F, RankList0),


    {noreply, State};



handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info(_Msg, State) ->
    {noreply, State}.
