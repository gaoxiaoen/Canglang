%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. ???? 2017 15:31
%%%-------------------------------------------------------------------
-module(festival_red_gift).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init_ets/0,
    init_data/1,
    sys_midnight_refresh/0,
    sys_midnight_refresh_cast/1,
    init/1,
    midnight_refresh/1,

    add_charge/1,
    add_charge_center/1,
    add_charge_gold_cast/2,
    get_act/0,
    get_open_time/0,
    timer/0,
    update_timer/1,
    timer_cacl/1,
    get_state/0,
    update_sort/0,
    sys_notice_all_client/0,
    sys_notice_all_client_cast/1
]).

%% 协议接口
-export([
    get_act_info/1,
    get_act_info_center/1,
    get_act_info_cast/2,
    get_rank_list/1,
    get_rank_list_center/2,
    get_rank_list_center_cast/3,
    notice_all_client_sn/2,
    recv/2,
    recv_center/2,
    recv_cast/3,
    to_sn_reward_client/3,
    recv_red_gift/2,
    look_10/1,
    look_10_center/1,
    look_10_center_cast/1,
    notice_online/2
]).

%% GM接口
-export([
    gm/0,
    gm_open/0,
    gm_open_center/0,
    gm_sys_midnight_refresh/0
]).

gm_open() ->
    cross_all:apply(?MODULE, gm_open_center, []).

gm_open_center() ->
    activity_proc:get_act_pid() ! {festival_red_gift, timer_cacl}.

sys_notice_all_client() ->
    case config:is_center_node() of
        false -> ok;
        true ->
            case get_act() of
                [] -> ok;
                _ ->
                    ?CAST(activity_proc:get_act_pid(), {festival_red_gift, sys_notice_all_client}),
                    ok
            end
    end.

sys_notice_all_client_cast(State) ->
    if
        length(State#state.festival_red_gift_list) == 0 -> skip;
        State#state.festival_red_gift_id == 0 -> skip;
        true ->
            Now = util:unixtime(),
            case get({festival_red_gift, sys_notice_all_client}) of
                Time when is_integer(Time) ->
                    if
                        Now - Time < 120 ->
                            skip;
                        true ->
                            spawn(fun() -> timer:sleep(500),
                                notice_all_client(State#state.festival_charge_score, State#state.festival_red_gift_id) end),
                            put({festival_red_gift, sys_notice_all_client}, Now)
                    end;
                _ ->
                    put({festival_red_gift, sys_notice_all_client}, Now)
            end
    end.

init_ets() ->
    ets:new(?ETS_FESTIVAL_RED_GIFT, [{keypos, #ets_festival_red_gift.key} | ?ETS_OPTIONS]).

init_data(State) ->
    case config:is_center_node() of
        false ->
            State;
        true ->
            Sql = io_lib:format("select score, op_time from act_festival_red_gift where node='~s'", [node()]),
            case db:get_row(Sql) of
                [Score, OpTime] ->
                    Now = util:unixtime(),
                    case util:is_same_date(Now, OpTime) of
                        true ->
                            State#state{festival_charge_score = Score};
                        _ ->
                            State
                    end;
                _ -> State
            end
    end.

gm_sys_midnight_refresh() ->
    case config:is_center_node() of
        true ->
            sys_midnight_refresh();
        false ->
            cross_all:apply(?MODULE, sys_midnight_refresh, [])
    end.

sys_midnight_refresh() ->
    case config:is_center_node() of
        false ->
            ok;
        true ->
            ets:delete_all_objects(?ETS_FESTIVAL_RED_GIFT),
            ?CAST(activity_proc:get_act_pid(), {festival_red_gift, sys_midnight_refresh})
    end.

sys_midnight_refresh_cast(State) ->
    State#state{festival_charge_score = 0, festival_red_gift_list = []}.

add_charge(ChargeGold) ->
    case get_act() of
        [] -> ok;
        _ ->
            cross_all:apply(?MODULE, add_charge_center, [ChargeGold])
    end.

add_charge_center(ChargeGold) ->
    ?CAST(activity_proc:get_act_pid(), {festival_red_gift, add_charge_gold, ChargeGold}).

add_charge_gold_cast(State, ChargeGold) ->
    case get_act() of
        [] ->
            State;
        #base_act_festival_red_gift{exchange_score = {Min, Max}} ->
            NewScore = State#state.festival_charge_score + ChargeGold * (util:rand(Min, Max)),
            Sql = io_lib:format("replace into act_festival_red_gift set score=~p, op_time=~p, node='~s'", [NewScore, util:unixtime(), node()]),
            db:execute(Sql),
            State#state{
                festival_charge_score = NewScore
            }
    end.

init(#player{key = Pkey} = Player) ->
    StFestivalRedGift =
        case player_util:is_new_role(Player) of
            true -> #st_festival_red_gift{pkey = Pkey};
            false -> activity_load:dbget_festival_red_gift(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_FESTIVAL_RED_GIFT, StFestivalRedGift),
    update_festival_red_gift(),
    Player.

update_festival_red_gift() ->
    StFestivalRedGift = lib_dict:get(?PROC_STATUS_FESTIVAL_RED_GIFT),
    #st_festival_red_gift{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StFestivalRedGift,
    case get_act() of
        [] ->
            NewStFestivalRedGift = #st_festival_red_gift{pkey = Pkey};
        #base_act_festival_red_gift{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(Now, OpTime),
            if
                Flag == false ->
                    NewStFestivalRedGift = #st_festival_red_gift{pkey = Pkey, act_id = BaseActId, op_time = Now};
                BaseActId =/= ActId ->
                    NewStFestivalRedGift = #st_festival_red_gift{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStFestivalRedGift = StFestivalRedGift
            end
    end,
    lib_dict:put(?PROC_STATUS_FESTIVAL_RED_GIFT, NewStFestivalRedGift).

midnight_refresh(_ResetTime) ->
    update_festival_red_gift().

get_act() ->
    case activity:get_work_list(data_act_festival_red_gift) of
        [] -> [];
        [Base | _] -> Base
    end.

get_open_time() ->
    case get_act() of
        [] -> [];
        #base_act_festival_red_gift{open_list = OpenList} ->
            NowSec = util:get_seconds_from_midnight(),
            F = fun(BaseH) ->
                BaseSce = round(BaseH * ?ONE_HOUR_SECONDS),
                if
                    BaseSce > NowSec -> [BaseSce];
                    true -> []
                end
                end,
            lists:flatmap(F, OpenList)
    end.

timer() ->
    case get_act() of
        [] -> skip;
        _ ->
            case config:is_center_node() of
                false ->
                    skip;
                true ->
                    ?CAST(activity_proc:get_act_pid(), {festival_red_gift, update_timer})
            end
    end.

update_timer(State) ->
    #state{festival_red_gift_ref = Ref} = State,
    NowSec = util:get_seconds_from_midnight(),
    case get_open_time() of
        TimeList when TimeList /= [] ->
            SecTime = hd(TimeList),
            if
                SecTime - NowSec < 10 -> State;
                true ->
                    util:cancel_ref([Ref]),
                    NewRef = erlang:send_after(max(0, (SecTime - NowSec)) * 1000, self(), {festival_red_gift, timer_cacl}),
                    State#state{festival_red_gift_ref = NewRef}
            end;
        _ ->
            State
    end.

timer_cacl(State) ->
    case get_act() of
        [] ->
            State;
        _ ->
            ets:delete_all_objects(?ETS_FESTIVAL_RED_GIFT),
            #state{
                festival_red_gift_ref = Ref,
                festival_charge_score = ChargeScore
            } = State,
            util:cancel_ref([Ref]),
            case data_festival_red_gift:get_score(ChargeScore) of
                [] ->
                    State#state{
                        festival_red_gift_list = [],
                        festival_red_gift_id = 0,
                        festival_red_gift_1_key = {0, 0}
                    };
                #base_festival_red_gift{
                    id = BaseId,
                    gift_info = GiftInfo
                } ->
                    RedGiftList = get_red_gift_list(GiftInfo),
                    NewRedList = util:list_shuffle(RedGiftList),
                    spawn(fun() -> timer:sleep(500), notice_all_client(ChargeScore, BaseId) end),
                    put({festival_red_gift, sys_notice_all_client}, util:unixtime()),
                    State#state{
                        festival_red_gift_list = NewRedList,
                        festival_red_gift_id = BaseId,
                        festival_red_gift_1_key = {0, 0}
                    }
            end
    end.

gm() ->
    #base_festival_red_gift{gift_info = GiftInfo} = data_festival_red_gift:get_score(10000),
    RedGiftList = get_red_gift_list(GiftInfo),
    ?DEBUG("RedGiftList:~p", [RedGiftList]),
    ok.

notice_all_client(Score, BaseId) ->
    AllNodes = center:get_all_nodes(),
    F = fun(Node) ->
        center:apply(Node#ets_kf_nodes.node, ?MODULE, notice_all_client_sn, [Score, BaseId])
        end,
    lists:map(F, AllNodes).

notice_all_client_sn(Score, BaseId) ->
    notice_sys:add_notice(festival_red_gift, [Score, BaseId]),
    {ok, Bin} = pt_439:write(43926, {BaseId}),
    notice_online(Bin).

notice_online(Bin) ->
    EtsList = ets:tab2list(?ETS_ONLINE),
    F = fun(#ets_online{pid = Pid}) ->
        player:apply_state(async, Pid, {?MODULE, notice_online, [Bin]})
    end,
    lists:map(F, EtsList).

notice_online([Bin], Player) ->
    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    NewM = M div 30,
    case cache:get({festival_red_gift, Player#player.key, H, NewM}) of
        Flag when is_integer(Flag) -> skip;
        _ -> server_send:send_to_sid(Player#player.sid, Bin)
    end,
    {ok, Player}.

get_red_gift_list(GiftInfo) ->
    F = fun({GoodsId, GoodsNum, SubGiftNum, MultGiftNum}) ->
        get_red_gift_list2(GoodsId, GoodsNum, SubGiftNum, MultGiftNum)
        end,
    lists:flatmap(F, GiftInfo).

get_red_gift_list2(_GoodsId, _GoodsNum, 0, _) ->
    [];

get_red_gift_list2(GoodsId, GoodsNum, 1, N) ->
    F = fun(_) ->
        #red_gift{id = GoodsId, goods_list = [{GoodsId, GoodsNum}]}
    end,
    lists:map(F, lists:seq(1, N));

get_red_gift_list2(GoodsId, GoodsNum, SubGiftNum, MultGiftNum) ->
    F = fun(_N, Acc) ->
        RandNumList = util:get_random_list(lists:seq(1, GoodsNum - 1), SubGiftNum - 1),
        F1 = fun(N, {Count, Acc1}) ->
            {N, [#red_gift{id = GoodsId, goods_list = [{GoodsId, N - Count}]} | Acc1]}
             end,
        {EndCount, EndAcc} = lists:foldl(F1, {0, []}, RandNumList),
        SubList = [#red_gift{id = GoodsId, goods_list = [{GoodsId, GoodsNum - EndCount}]} | EndAcc],
        SubList ++ Acc
        end,
    lists:foldl(F, [], lists:seq(1, MultGiftNum)).

get_state() ->
    case get_act() of
        [] -> -1;
        _ -> 0
    end.

get_act_info(Player) ->
    cross_all:apply(?MODULE, get_act_info_center, [Player#player.sid]).

get_act_info_center(Sid) ->
    ?CAST(activity_proc:get_act_pid(), {festival_red_gift, get_act_info, Sid}).

get_act_info_cast(State, Sid) ->
    case get_act() of
        [] ->
            ok;
        #base_act_festival_red_gift{open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            TimeList = get_open_time(),
            NowSec = util:get_seconds_from_midnight(),
            RemainTime =
                if
                    TimeList == [] -> 0;
                    true ->
                        T = hd(TimeList),
                        max(0, T - NowSec)
                end,
            SysScore = State#state.festival_charge_score,
            EtsKey = State#state.festival_red_gift_1_key,
            case ets:lookup(?ETS_FESTIVAL_RED_GIFT, EtsKey) of
                [] ->
                    NickName = <<>>,
                    Sn = 0,
                    Career = 0,
                    Avatar = "",
                    Sex = 0,
                    HeadId = 0,
                    GoodsList99 = [];
                [Ets] ->
                    #ets_festival_red_gift{
                        nickname = NickName,
                        sn = Sn,
                        career = Career,
                        avatar = Avatar,
                        sex = Sex,
                        red_gift = GoodsList00,
                        head_id = HeadId
                    } = Ets,
                    GoodsList99 = util:list_tuple_to_list(GoodsList00)
            end,
            AllIds = data_festival_red_gift:get_all(),
            F = fun(Id) ->
                #base_festival_red_gift{
                    score_min = ScoreMin,
                    gift_sum = GiftNum,
                    gift_info = GiftInfo
                } = data_festival_red_gift:get(Id),
                FF = fun({Gid, Gnum, _SubN, MultN}) ->
                    [Gid, Gnum*MultN]
                     end,
                GoodsList = lists:map(FF, GiftInfo),
                [Id, GiftNum, ScoreMin, GoodsList]
                end,
            ProList = lists:map(F, AllIds),
            FF = fun(Id) ->
                #base_festival_red_gift{
                    score_min = ScoreMin,
                    rank_1_gift = Rank1Gift
                } = data_festival_red_gift:get(Id),
                [ScoreMin, util:list_tuple_to_list(Rank1Gift)]
                 end,
            BaseProList = lists:map(FF, AllIds),
            {ok, Bin} = pt_439:write(43924, {LTime, RemainTime, SysScore, NickName, Sn, Career, Sex, HeadId, Avatar, GoodsList99, BaseProList, ProList}),
            server_send:send_to_sid(Sid, Bin)
    end.

get_rank_list(Player) ->
    cross_all:apply(?MODULE, get_rank_list_center, [Player#player.sid, Player#player.key]).

get_rank_list_center(Sid, Pkey) ->
    ?CAST(activity_proc:get_act_pid(), {festival_red_gift, get_rank_list_center, Sid, Pkey}).

get_rank_list_center_cast(State, Sid, Pkey) ->
    ProList = update_sort(),
    RedGiftId = State#state.festival_red_gift_id,
    case ets:lookup(?ETS_FESTIVAL_RED_GIFT, {RedGiftId, Pkey}) of
        [] ->
            MyRank = 0, MyGoodsList = [];
        [Ets] ->
            #ets_festival_red_gift{
                rank = MyRank,
                red_gift = RedGift
            } = Ets,
            MyGoodsList = util:list_tuple_to_list(RedGift)
    end,
    F = fun(Ets) ->
        #ets_festival_red_gift{
            rank = Rank,
            nickname = Nickname,
            sn = Sn,
            career = Career,
            sex = Sex,
            head_id = HeadId,
            avatar = Avatar,
            red_gift = RedGift0
        } = Ets,
        GoodsList = util:list_tuple_to_list(RedGift0),
        [Rank, Nickname, Sn, Career, Sex, HeadId, Avatar, GoodsList]
        end,
    NewProList = lists:map(F, ProList),
    {ok, Bin} = pt_439:write(43925, {MyRank, MyGoodsList, NewProList}),
    server_send:send_to_sid(Sid, Bin).

update_sort() ->
    EtsSize = ets:info(?ETS_FESTIVAL_RED_GIFT, size),
    if
        EtsSize =< 10 ->
            AllEtsList = ets:tab2list(?ETS_FESTIVAL_RED_GIFT);
        true ->
            Now = util:unixtime(),
            case get({festival_red_gift, update_sort}) of
                {Time, CacheList} when is_integer(Time) andalso Now - Time < 2 ->
                    AllEtsList = CacheList;
                _Other ->
                    AllEtsList = ets:tab2list(?ETS_FESTIVAL_RED_GIFT),
                    put({festival_red_gift, update_sort}, {Now, AllEtsList})
            end
    end,

    F = fun(EtsA, EtsB) ->
        #ets_festival_red_gift{recv_time = RecvTimeA, red_gift = RedGiftA} = EtsA,
        #ets_festival_red_gift{recv_time = RecvTimeB, red_gift = RedGiftB} = EtsB,
        {GoodsIdA, GoodsNumA} = hd(RedGiftA),
        {GoodsIdB, GoodsNumB} = hd(RedGiftB),
        PriA = data_festival_red_gift_priority:get(GoodsIdA),
        PriB = data_festival_red_gift_priority:get(GoodsIdB),
        PriA < PriB orelse
            PriA == PriB andalso GoodsNumA > GoodsNumB orelse
            PriA == PriB andalso GoodsNumA == GoodsNumB andalso RecvTimeA < RecvTimeB
        end,
    NewEtsList = lists:sort(F, AllEtsList),
    FF = fun(Ets, {Count, Acc}) ->
        NewEts = Ets#ets_festival_red_gift{rank = Count},
        ets:insert(?ETS_FESTIVAL_RED_GIFT, NewEts),
        {Count + 1, [NewEts | Acc]}
         end,
    {_AccCount, AccList} = lists:foldl(FF, {1, []}, NewEtsList),
    RankList = lists:sublist(lists:reverse(AccList), 10),
    if
        RankList == [] -> ok;
        true -> ?CAST(activity_proc:get_act_pid(), {festival_red_gift, update_rank_1_key, hd(RankList)})
    end,
    RankList.

recv(Player, Id) ->
    #player{
        key = Pkey,
        nickname = NickName,
        sex = Sex,
        career = Career,
        avatar = Avatar,
        sn_cur = Sn,
        fashion = Fashion,
        sid = Sid
    } = Player,
    cross_all:apply(?MODULE, recv_center, [{Sid, Pkey, NickName, Sex, Career, Avatar, Sn, Fashion#fashion_figure.fashion_decoration_id}, Id]).

recv_center({Sid, Pkey, NickName, Sex, Career, Avatar, Sn, HeadId}, Id) ->
    case get_act() of
        [] ->
            {ok, Bin} = pt_439:write(43927, {0, []}),
            server_send:send_to_sid(Sid, Bin);
        _ ->
            case ets:lookup(?ETS_FESTIVAL_RED_GIFT, {Id, Pkey}) of
                [] ->
                    ?CAST(activity_proc:get_act_pid(), {festival_red_gift, recv, [{Sid, Pkey, NickName, Sex, Career, Avatar, Sn, HeadId}, Id]});
                _ ->
                    {ok, Bin} = pt_439:write(43927, {5, []}),
                    server_send:send_to_sid(Sid, Bin)
            end
    end.
recv_cast(State, {Sid, Pkey, NickName, Sex, Career, Avatar, Sn, HeadId}, Id) ->
    #state{
        festival_red_gift_list = RedGiftList,
        festival_red_gift_id = NowRedGiftId
    } = State,
    if
        NowRedGiftId /= Id ->
            {ok, Bin} = pt_439:write(43927, {0, []}),
            server_send:send_to_sid(Sid, Bin),
            State;
        true ->
            case RedGiftList == [] of
                true ->
                    {ok, Bin} = pt_439:write(43927, {14, []}),
                    server_send:send_to_sid(Sid, Bin),
                    State;
                _ ->
                    [RedGift | NewRedGiftList] = RedGiftList,
                    #red_gift{type = Type, goods_list = GoodsList} = RedGift,
                    Ets =
                        #ets_festival_red_gift{
                            key = {Id, Pkey},
                            id = Id,
                            pkey = Pkey,
                            nickname = NickName,
                            sex = Sex,
                            avatar = Avatar,
                            career = Career,
                            sn = Sn,
                            recv_time = util:unixtime(),
                            red_gift = GoodsList,
                            type = Type,
                            head_id = HeadId
                        },
                    ets:insert(?ETS_FESTIVAL_RED_GIFT, Ets),
                    spawn(fun() -> to_reward_client(Pkey, Sn, Id, GoodsList) end),
                    {ok, Bin} = pt_439:write(43927, {1, util:list_tuple_to_list(GoodsList)}),
                    server_send:send_to_sid(Sid, Bin),
                    State#state{festival_red_gift_list = NewRedGiftList}
            end
    end.

to_reward_client(Pkey, Sn, Id, GoodsList) ->
    Node = center:get_node_by_sn(Sn),
    center:apply(Node, ?MODULE, to_sn_reward_client, [Pkey, Id, GoodsList]).

to_sn_reward_client(Pkey, Id, GoodsList) ->
    Sql = io_lib:format("insert into log_festival_red_gift set pkey=~p, gift_id=~p, recv_list='~s', time=~p",
        [Pkey, Id, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> ok;
        [Ets] ->
            Ets#ets_online.pid ! {festival_red_gift, recv_red_gift, GoodsList}
    end.

recv_red_gift(Player, GoodsList) ->
    GiveGoodsList = goods:make_give_goods_list(710, GoodsList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    NewM = M div 30,
    ?DEBUG("############recv_red_gift", []),
    cache:set({festival_red_gift, Player#player.key, H, NewM}, 1, ?ONE_HOUR_SECONDS div 2 - 30),
    NewPlayer.

look_10(Player) ->
    case get_act() of
        [] -> ok;
        _ ->
            cross_all:apply(?MODULE, look_10_center, [Player#player.sid])
    end.

look_10_center(Sid) ->
    ?CAST(activity_proc:get_act_pid(), {festival_red_gift, look_10_center, Sid}).

look_10_center_cast(Sid) ->
    ProList = update_sort(),
    F = fun(Ets) ->
        #ets_festival_red_gift{
            rank = Rank,
            nickname = NickName,
            sn = Sn,
            career = Career,
            red_gift = RedGift,
            avatar = Avatar,
            sex = Sex,
            head_id = HeadId
        } = Ets,
        [Rank, NickName, Sn, Sex, Career, Avatar, HeadId, util:list_tuple_to_list(RedGift)]
        end,
    NewPro = lists:map(F, ProList),
    {ok, Bin} = pt_439:write(43928, {NewPro}),
    server_send:send_to_sid(Sid, Bin).
