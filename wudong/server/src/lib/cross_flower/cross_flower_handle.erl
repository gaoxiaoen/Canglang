%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:17
%%%-------------------------------------------------------------------
-module(cross_flower_handle).
-author("Administrator").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").
%% API
-export([
    handle_call/3,
    handle_cast/2,
    handle_info/2]).

handle_call(_Request, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {reply, ok, State}.

%%刷新排行榜
handle_info(refresh_rank, State) ->
    LogList = cross_flower_load:init(),
    RankGiveList = cross_flower_load:rank_give_list(LogList),
    RankGetList = cross_flower_load:rank_get_list(LogList),
    {noreply, State#st_cross_flower{log_list = LogList, rank_give_list = RankGiveList, rank_get_list = RankGetList}};

%%刷新排行榜
handle_info(refresh_rank_nodb, State) ->
    LogList = State#st_cross_flower.log_list,
    RankGiveList = cross_flower_load:rank_give_list(LogList),
    RankGetList = cross_flower_load:rank_get_list(LogList),
    {noreply, State#st_cross_flower{rank_give_list = RankGiveList, rank_get_list = RankGetList}};

handle_info(end_reward, _State) ->
    case cross_flower:get_act() of
        [] ->
            ?ERR("cross_flower  [] ~n"),
            [];
        Base ->
            LogList = cross_flower_load:init(),
            RankGiveList = cross_flower_load:rank_give_list(LogList),
            RankGetList = cross_flower_load:rank_get_list(LogList),
            cross_flower:end_reward(RankGiveList, RankGetList,Base),
            cross_flower_load:clean()
    end,
    %% cross_flower_load:clean(),
    {noreply, #st_cross_flower{}};

handle_info(test, State) ->
    ?DEBUG("State State ~p~n", [State]),
    {noreply, State};

handle_info(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

%% 送花更新
handle_cast({update_send_flower, _Node, Sn, GiveKey, GiveName, GiveSex, GiveAvatar, GetKey, GetName, GetSex, GetAvatar, Value}, State) ->
    Now = util:unixtime(),
    LogList1 = update_give(State#st_cross_flower.log_list, Sn, GiveKey, GiveName, GiveSex, GiveAvatar, Value, Now),
    LogList2 = update_get(LogList1, Sn, GetKey, GetName, GetSex, GetAvatar, Value, Now),
    GroupList = activity_area_group:get_group_list(data_cross_flower, cross_flower),
    %%刷新分组排行
    Group = activity_area_group:get_sn_group(Sn, GroupList),
    RankGiveList = cross_flower_load:rank_give_list_by_group(LogList2, State#st_cross_flower.rank_give_list, Group),
    RankGetList = cross_flower_load:rank_get_list_by_group(LogList2, State#st_cross_flower.rank_get_list, Group),
    {noreply, State#st_cross_flower{log_list = LogList2, rank_give_list = RankGiveList, rank_get_list = RankGetList}};

%% 查看鲜花榜
handle_cast({check_info, Node, Sn, Pkey, Sid}, State) ->
    #st_cross_flower{
        rank_give_list = GiveList,
        rank_get_list = GetList
    } = State,
    GroupList = activity_area_group:get_group_list(data_cross_flower, cross_flower),
    Group = activity_area_group:get_sn_group(Sn, GroupList),
    {Give, GiveRank, GiveList1} = give_info(Group, Pkey, GiveList),
    {Get, GetRank, GetList1} = get_info(Group, Pkey, GetList),
    LeaveTime = cross_flower:get_leave_time(),
    GetReward = cross_flower:get_reward_list(),
    GiveReward = cross_flower:give_reward_list(),
    LimitList = flower_rank:get_limit_all(),
    {ok, Bin} = pt_602:write(60200, {LeaveTime, Give, GiveRank, GiveList1, GiveReward, Get, GetRank, GetList1, GetReward,LimitList,LimitList}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

make_give_list(List) ->
    F = fun(Base) ->
        [Base#flower_log.sn,
            Base#flower_log.pkey,
            Base#flower_log.nickname,
            Base#flower_log.sex,
            Base#flower_log.avatar,
            Base#flower_log.give_rank,
            Base#flower_log.give]
    end,
    lists:map(F, List).

make_get_list(List) ->
    F = fun(Base) ->
        [Base#flower_log.sn,
            Base#flower_log.pkey,
            Base#flower_log.nickname,
            Base#flower_log.sex,
            Base#flower_log.avatar,
            Base#flower_log.get_rank,
            Base#flower_log.get]
    end,
    lists:map(F, List).

update_give(LogList, Sn, GiveKey, GiveName, GiveSex, GiveAvatar, Value, Now) ->
    case lists:keytake(GiveKey, #flower_log.pkey, LogList) of
        false ->
            NewGive = #flower_log{
                sn = Sn,
                pkey = GiveKey,
                give = Value,
                nickname = GiveName,
                sex = GiveSex,
                avatar = GiveAvatar,
                give_change_time = Now
            },
            cross_flower_load:replace(NewGive),
            [NewGive | LogList];
        {value, Give, T} ->
            NewGive = Give#flower_log{sn = Sn, give = Give#flower_log.give + Value, give_change_time = Now},
            cross_flower_load:replace(NewGive),
            [NewGive | T]
    end.
update_get(LogList, Sn, GetKey, GetName, GetSex, GetAvatar, Value, Now) ->
    case lists:keytake(GetKey, #flower_log.pkey, LogList) of
        false ->
            NewGet = #flower_log{
                sn = Sn,
                pkey = GetKey,
                nickname = GetName,
                get = Value,
                sex = GetSex,
                avatar = GetAvatar,
                get_change_time = Now
            },
            cross_flower_load:replace(NewGet),
            [NewGet | LogList];
        {value, Get, T} ->
            NewGet = Get#flower_log{sn = Sn, get = Get#flower_log.get + Value, get_change_time = Now},
            cross_flower_load:replace(NewGet),
            [NewGet | T]
    end.


give_info(Group, Pkey, GiveList) ->
    GiveList0 =
        case lists:keyfind(Group, 1, GiveList) of
            false -> [];
            {_, L} -> L
        end,

    {Give, GiveRank} =
        case lists:keyfind(Pkey, #flower_log.pkey, GiveList0) of
            false ->
                {0, 0};
            GiveLog ->
                {GiveLog#flower_log.give, GiveLog#flower_log.give_rank}
        end,
    GiveList1 = lists:sublist(make_give_list(GiveList0), ?RANK_LIMIT),
    {Give, GiveRank, GiveList1}.

get_info(Group, Pkey, GetList) ->
    GetList0 =
        case lists:keyfind(Group, 1, GetList) of
            false -> [];
            {_, L} -> L
        end,
    {Get, GetRank} =
        case lists:keyfind(Pkey, #flower_log.pkey, GetList0) of
            false ->
                {0, 0};
            GetLog ->
                {GetLog#flower_log.get, GetLog#flower_log.get_rank}
        end,
    GetList1 = lists:sublist(make_get_list(GetList0), ?RANK_LIMIT),
    {Get, GetRank, GetList1}.
