%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 14:57
%%%-------------------------------------------------------------------
-module(marry_rank).
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
%% API
-export([
    init/1,
    get_rank_player/5,
    sort_rank_list/1,
    reload_rank/0,
    night_refresh/2,
    night_refresh_all/0,
    get_state/1,
    clean/0,
    receive_reward/1,
    dbup_marry_rank/1,
    marry_trigger/2,
    sys_midnight_cacl/0,
    cross_get_marry_info/4,
    update_marry_rank/6,
    delete_marry_rank/0,
    get_act/0
]).

init(Player) ->
    StMarry = activity_load:dbget_player_marry_rank(Player),
    lib_dict:put(?PROC_STATUS_MARRY_RANK, StMarry),
    update(Player),
    ok.

update(#player{key = Pkey} = _Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_RANK),
    #st_marry_rank{
        act_id = ActId
    } = St,
    NewSt0 = #st_marry_rank{
        pkey = Pkey
    },
    NewSt =
        case activity:get_work_list(data_marry_rank) of
            [] -> St;
            [Base | _] ->
                #base_marry_rank{
                    act_id = BaseActId
                } = Base,
                case BaseActId =/= ActId of
                    true ->
                        NewSt0#st_marry_rank{
                            act_id = BaseActId
                        };
                    false ->
                        St
                end
        end,
    lib_dict:put(?PROC_STATUS_MARRY_RANK, NewSt),
    ok.

get_rank_player(Node, MarryRankList, Pid, Pkey, ReceiveState) ->
    %% 排行榜信息发给玩家
    {Rank, RankList} = make_to_client(Pkey, MarryRankList),
    server_send:send_node_pid(Node, Pid, {marry_rank_send, Rank, RankList, ReceiveState}),
    ok.

make_to_client(Pkey, MarryRankList) ->
    Rank = case lists:keyfind(Pkey, #marry_rank_info.bpkey, MarryRankList) of
               false ->
                   case lists:keyfind(Pkey, #marry_rank_info.gpkey, MarryRankList) of
                       false ->
                           0;
                       Other ->
                           Other#marry_rank_info.rank
                   end;
               Other ->
                   Other#marry_rank_info.rank
           end,
    F = fun(Info) ->
        #marry_rank_info{rank = Rank0, bname = BName, gname = GName, bavatar = BAvatar, gavatar = GAvatar} = Info,
        [Rank0, BName, BAvatar, GName, GAvatar]
    end,
    RankList = lists:map(F, MarryRankList),
    {Rank, RankList}.

%% 重置数据
night_refresh(clean, Player) ->
    StMarryRank = lib_dict:get(?PROC_STATUS_MARRY_RANK),
    Base = get_act(),
    case Base == [] of
        true ->
            NewMarryRank = #st_marry_rank{pkey = Player#player.key},
            lib_dict:put(?PROC_STATUS_MARRY_RANK, NewMarryRank);
        false ->
            ActId = StMarryRank#st_marry_rank.act_id,
            case Base#base_marry_rank.act_id =/= ActId of
                true ->
                    NewStMarryRank = #st_marry_rank{
                        pkey = Player#player.key,
                        act_id = Base#base_marry_rank.act_id
                    };
                false ->
                    NewStMarryRank = StMarryRank
            end,
            lib_dict:put(?PROC_STATUS_MARRY_RANK, NewStMarryRank)
    end,
    ok.

%%凌晨数据更新
night_refresh_all() ->
    ActList = get_act(),
    case ActList == [] of
        true ->
            skip;
        false ->
            Pids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
            F = fun([P]) ->
                player:apply_state(async, P, {marry_rank, night_refresh, clean})
            end,
            [F(Pid) || Pid <- Pids]
    end.

get_act() ->
    case activity:get_work_list(data_marry_rank) of
        [] -> [];
        [Base | _] -> Base
    end.

%% 刷新排行榜
sort_rank_list(LogList) ->
    F0 = fun(A, B) ->
        A#marry_rank_info.marry_time < B#marry_rank_info.marry_time
    end,
    LogList1 = lists:sort(F0, LogList),
    F = fun(Log, {Rank, L}) ->
        {Rank + 1, L ++ [Log#marry_rank_info{rank = Rank}]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

%%重载排行榜
reload_rank() ->
    BaseList = get_act(),
    case BaseList of
        [] -> [];
        #base_marry_rank{act_id = _ActId} ->
            load_rank()
    end.

load_rank() ->
    Sql = io_lib:format("SELECT bpkey,bname,bavatar,gpkey,gname,gavatar,marry_time FROM marry_rank;", []),
    Data =
        case db:get_all(Sql) of
            [] ->
                [];
            L ->
                F = fun([BPkey, BName, BAvatar, GPkey, GName, GAvatar, MarryTime]) ->
                    #marry_rank_info{
                        bpkey = BPkey,
                        bname = util:bitstring_to_term(BName),
                        bavatar = util:bitstring_to_term(BAvatar),
                        gpkey = GPkey,
                        gname = util:bitstring_to_term(GName),
                        gavatar = util:bitstring_to_term(GAvatar),
                        marry_time = MarryTime
                    }
                end,
                L1 = lists:map(F, L),
                sort_rank_list(L1)
        end,
    Data.

dbup_marry_rank(Info) ->
    #marry_rank_info{
        bpkey = BPkey,
        bname = BName,
        bavatar = BAvatar,
        gpkey = GPkey,
        gname = GName,
        gavatar = GAvatar,
        marry_time = MarryTime
    } = Info,
    Sql = io_lib:format("insert into marry_rank(bpkey,bname,bavatar,gpkey,gname,gavatar,marry_time) values (~p,'~s','~s',~p,'~s','~s',~p)",
        [BPkey, util:term_to_bitstring(BName), util:term_to_bitstring(BAvatar), GPkey, util:term_to_bitstring(GName), util:term_to_bitstring(GAvatar), MarryTime]),
    db:execute(Sql),
    ok.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            Args = activity:get_base_state(Base#base_marry_rank.act_info),
            case check_receive_reward() of
                false -> {0, Args};
                true -> {1, Args}
            end
    end.

clean() ->
    db:execute("truncate marry_rank ").

receive_reward(Player) ->
    case check_receive_reward() of
        false -> {false, 0};
        true ->
            case get_act() of
                [] -> {false, 0};
                #base_marry_rank{reward_list = RewardList} ->
                    StMarryRank = lib_dict:get(?PROC_STATUS_MARRY_RANK),
                    lib_dict:put(?PROC_STATUS_MARRY_RANK, StMarryRank#st_marry_rank{state = 2}),
                    activity_load:dbup_player_marry_rank(StMarryRank#st_marry_rank{state = 2}),
                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(288, RewardList)),
                    activity:get_notice(Player, [131], true),
                    {ok, NewPlayer}
            end
    end.

check_receive_reward() ->
    StMarryRank = lib_dict:get(?PROC_STATUS_MARRY_RANK),
    #st_marry_rank{
        state = State
    } = StMarryRank,
    ?IF_ELSE(State == 1, true, false).

marry_trigger(Player, Role) ->
    LeaveTime = activity:get_leave_time(data_marry_rank),
    Player#player.pid ! update_marry_rank,
    Role#player.pid ! update_marry_rank,
    if
        LeaveTime =< 0 -> skip;
        true ->
            if
                Player#player.sex == 1 ->
                    cross_all:apply(marry_rank, update_marry_rank, [Player#player.key, Player#player.nickname, Player#player.avatar, Role#player.key, Role#player.nickname, Role#player.avatar]);
                true ->
                    cross_all:apply(marry_rank, update_marry_rank, [Role#player.key, Role#player.nickname, Role#player.avatar, Player#player.key, Player#player.nickname, Player#player.avatar])
            end
    end,
    ok.

%% 凌晨邮件结算
sys_midnight_cacl() ->
    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    if
        H == 23 andalso M == 58 ->
            sys_midnight_cacl2();
        true ->
            ok
    end.

sys_midnight_cacl2() ->
    case config:is_center_node() of
        false ->
            ok;
        true ->
            Pid = activity_proc:get_act_pid(),
            spawn(fun() -> Pid ! marry_rank_reward end)
    end.

cross_get_marry_info(Node, Key, Pid0, State) ->
%%     [node(), config:get_server_num(), Player#player.key, Player#player.sid,State]
    Pid = activity_proc:get_act_pid(),
    Pid ! {get_marry_rank_info, Node, Pid0, Key, State},
    ok.

update_marry_rank(Key1, NickName1, Avatar1, Key2, NickName2, Avatar2) ->
    Pid = activity_proc:get_act_pid(),
    Pid ! {update_marry_rank, Key1, NickName1, Avatar1, Key2, NickName2, Avatar2},
    ok.

delete_marry_rank() ->
    Time = util:unixtime() - 3 * ?ONE_DAY_SECONDS,
    Sql = io_lib:format("DELETE FROM marry_rank WHERE marry_time < ~p", [Time]),
    db:execute(Sql),
    ok.
