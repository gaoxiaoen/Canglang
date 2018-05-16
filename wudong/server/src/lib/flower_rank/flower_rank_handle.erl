%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:17
%%%-------------------------------------------------------------------
-module(flower_rank_handle).
-author("Administrator").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").
%% API
-export([
    handle_call/3,
    handle_cast/2,
    handle_info/2]).
-export([
    give_info/2,
    get_info/2
]).


handle_call(_Request, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {reply, ok, State}.

%%刷新排行榜
handle_info(refresh_rank, State) ->
    LogList = flower_rank_load:init(),
    RankGiveList = flower_rank_load:rank_give_list(LogList),
    RankGetList = flower_rank_load:rank_get_list(LogList),
    {noreply, State#st_flower_rank{log_list = LogList, rank_give_list = RankGiveList, rank_get_list = RankGetList}};


handle_info(end_reward, _State) ->
    case flower_rank:get_act() of
        [] ->
            ?ERR("flower  [] ~n"),
            skip;
        Base ->
            LogList = flower_rank_load:init(),
            RankGiveList = flower_rank_load:rank_give_list(LogList),
            RankGetList = flower_rank_load:rank_get_list(LogList),
            flower_rank:end_reward(RankGiveList, RankGetList, Base),
            flower_rank_load:clean()
    end,
    {noreply, #st_flower_rank{}};

handle_info(test, State) ->
    ?DEBUG("State State ~p~n", [State]),
    {noreply, State};

handle_info(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

%% 送花更新
handle_cast({update_send_flower, GiveKey, GiveName, GiveSex, GiveAvatar, GetKey, GetName, GetSex, GetAvatar, Value}, State) ->
    Now = util:unixtime(),
    LogList1 = update_give(State#st_flower_rank.log_list, GiveKey, GiveName, GiveSex, GiveAvatar, Value, Now),
    LogList2 = update_get(LogList1, GetKey, GetName, GetSex, GetAvatar, Value, Now),
    %%刷新分组排行
    RankGiveList = flower_rank_load:rank_give_list(LogList2),
    RankGetList = flower_rank_load:rank_get_list(LogList2),
    {noreply, State#st_flower_rank{log_list = LogList2, rank_give_list = RankGiveList, rank_get_list = RankGetList}};


%% 查看鲜花榜
handle_cast({check_info, Player}, State) ->
    #st_flower_rank{
        rank_give_list = GiveList,
        rank_get_list = GetList
    } = State,
    Player#player.pid ! {flower_rank_send, GiveList, GetList},
    {noreply, State};

handle_cast(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

make_give_list(List) ->
    F = fun(Base) ->
        [
            config:get_server_num(),
            Base#flower_rank_log.pkey,
            Base#flower_rank_log.nickname,
            Base#flower_rank_log.sex,
            Base#flower_rank_log.avatar,
            Base#flower_rank_log.give_rank,
            Base#flower_rank_log.give]
    end,
    lists:map(F, List).

make_get_list(List) ->
    F = fun(Base) ->
        [
            config:get_server_num(),
            Base#flower_rank_log.pkey,
            Base#flower_rank_log.nickname,
            Base#flower_rank_log.sex,
            Base#flower_rank_log.avatar,
            Base#flower_rank_log.get_rank,
            Base#flower_rank_log.get]
    end,
    lists:map(F, List).

update_give(LogList, GiveKey, GiveName, GiveSex, GiveAvatar, Value, Now) ->
    case lists:keytake(GiveKey, #flower_rank_log.pkey, LogList) of
        false ->
            NewGive = #flower_rank_log{
                pkey = GiveKey,
                give = Value,
                nickname = GiveName,
                sex = GiveSex,
                avatar = GiveAvatar,
                give_change_time = Now
            },
            flower_rank_load:replace(NewGive),
            [NewGive | LogList];
        {value, Give, T} ->
            NewGive = Give#flower_rank_log{give = Give#flower_rank_log.give + Value, give_change_time = Now},
            flower_rank_load:replace(NewGive),
            [NewGive | T]
    end.
update_get(LogList, GetKey, GetName, GetSex, GetAvatar, Value, Now) ->
    case lists:keytake(GetKey, #flower_rank_log.pkey, LogList) of
        false ->
            NewGet = #flower_rank_log{
                pkey = GetKey,
                nickname = GetName,
                get = Value,
                sex = GetSex,
                avatar = GetAvatar,
                get_change_time = Now
            },
            flower_rank_load:replace(NewGet),
            [NewGet | LogList];
        {value, Get, T} ->
            NewGet = Get#flower_rank_log{get = Get#flower_rank_log.get + Value, get_change_time = Now},
            flower_rank_load:replace(NewGet),
            [NewGet | T]
    end.


give_info(Pkey, GiveList) ->
    {Give, GiveRank} =
        case lists:keyfind(Pkey, #flower_rank_log.pkey, GiveList) of
            false ->
                {0, 0};
            GiveLog ->
                {GiveLog#flower_rank_log.give, GiveLog#flower_rank_log.give_rank}
        end,
    GiveList1 = lists:sublist(make_give_list(GiveList), ?RANK_LIMIT),
    {Give, GiveRank, GiveList1}.

get_info(Pkey, GetList) ->
    {Get, GetRank} =
        case lists:keyfind(Pkey, #flower_rank_log.pkey, GetList) of
            false ->
                {0, 0};
            GetLog ->
                {GetLog#flower_rank_log.get, GetLog#flower_rank_log.get_rank}
        end,
    GetList1 = lists:sublist(make_get_list(GetList), ?RANK_LIMIT),
    {Get, GetRank, GetList1}.