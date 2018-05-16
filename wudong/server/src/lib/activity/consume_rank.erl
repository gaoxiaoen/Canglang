%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 六月 2017 10:03
%%%-------------------------------------------------------------------
-module(consume_rank).
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
%% API
-export([
    init/1,
    add_consume_val/3,
    get_rank_player/3,
    get_consume/0,
    sort_rank_list/2,
    reload_rank/1,
    night_refresh/2,
    night_refresh_all/0,
    reward/2,
    sys_midnight_cacl/0,
    gm_reward/0,
    get_state/1,
    clean/0,
    get_act/0,
    recharge_consume_rank_state/1,
    sort_rank_list_limit/2,
    get_reward_list/0,
    make_to_client/2
]).

-define(SHOW_LIMIT_LV, 50).
-define(SEND_RANK_LIMIT, 50).

init(Player) ->
    StConsume = activity_load:dbget_consume_rank(Player),
    lib_dict:put(?PROC_STATUS_CONSUME_RANK, StConsume),
    update(Player),
    ok.

update(#player{key = Pkey, nickname = Name} = Player) ->
    St = lib_dict:get(?PROC_STATUS_CONSUME_RANK),
    #st_consume_rank{
        act_id = ActId
    } = St,
    NewSt0 = #st_consume_rank{
        pkey = Pkey,
        act_id = 0,
        consume_gold = 0,
        name = Name,
        lv = Player#player.lv
    },
    NewSt =
        case activity:get_work_list(data_consume_rank) of
            [] -> St;
            [Base | _] ->
                #base_consume_rank{
                    act_id = BaseActId
                } = Base,
                case BaseActId =/= ActId of
                    true ->
                        NewSt0#st_consume_rank{
                            act_id = BaseActId
                        };
                    false ->
                        St
                end
        end,
    lib_dict:put(?PROC_STATUS_CONSUME_RANK, NewSt),
    ok.


add_consume_val(AddReason, Player, Val) ->
    if
        AddReason == 32 -> skip;
        true ->
            StConsumeRank = lib_dict:get(?PROC_STATUS_CONSUME_RANK),
            #st_consume_rank{consume_gold = ConsumeGold} = StConsumeRank,
            case get_act() of
                [] ->
                    skip;
                _ ->
                    if
                        Player#player.lv > ?SHOW_LIMIT_LV + 5 andalso Val == 0 -> skip;
                        Player#player.lv < ?SHOW_LIMIT_LV - 3 andalso Val == 0 -> skip;
                        true ->
                            Now = util:unixtime(),
                            NewStConsumeRank = StConsumeRank#st_consume_rank{consume_gold = ConsumeGold + Val, change_time = Now, name = Player#player.nickname, lv = Player#player.lv},
                            lib_dict:put(?PROC_STATUS_CONSUME_RANK, NewStConsumeRank),
                            activity_load:dbup_consume_rank(NewStConsumeRank),
                            Pid = activity_proc:get_act_pid(),
                            Pid ! {update_consume_rank, Player#player.key, Player#player.nickname, Val, Player#player.lv}
                    end
            end
    end.

%% 重置数据
night_refresh(clean, Player) ->
    Consume = lib_dict:get(?PROC_STATUS_CONSUME_RANK),
    Base = get_act(),
    case Base == [] of
        true ->
            NewConsume = #st_consume_rank{pkey = Player#player.key},
            lib_dict:put(?PROC_STATUS_CONSUME_RANK, NewConsume);
        false ->
            ActId = Consume#st_consume_rank.act_id,
            case Base#base_consume_rank.act_id =/= ActId of
                true ->
                    Newconsume = #st_consume_rank{
                        pkey = Player#player.key,
                        act_id = Base#base_consume_rank.act_id,
                        consume_gold = 0
                    };
                false ->
                    Newconsume = Consume
            end,
            lib_dict:put(?PROC_STATUS_CONSUME_RANK, Newconsume)
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
                player:apply_state(async, P, {consume_rank, night_refresh, clean})
            end,
            [F(Pid) || Pid <- Pids]
    end.

get_act() ->
    case activity:get_work_list(data_consume_rank) of
        [] -> [];
        [Base | _] -> Base
    end.

get_rank_player(ConsumeRankList, Pid, MyCounsume) ->
    %% 排行榜信息发给玩家
    Pid ! {consume_rank_send, ConsumeRankList, MyCounsume},
    ok.

make_to_client(Pkey, ConsumeRankList) ->
    Rank = case lists:keyfind(Pkey, #consume_rank_info.pkey, ConsumeRankList) of
               false -> 0;
               Other ->
                   ?IF_ELSE(Other#consume_rank_info.consume_gold =< 0, 0, Other#consume_rank_info.rank)
           end,
    F = fun(Info) ->
        #consume_rank_info{rank = Rank0, name = NickName, consume_gold = ConsumeGold} = Info,
        [Rank0, NickName, ConsumeGold]
    end,
    RankList = lists:map(F, [X || X <- ConsumeRankList, X#consume_rank_info.rank =< ?SEND_RANK_LIMIT]),
    {Rank, RankList}.

get_consume() ->
    StConsumeRank = lib_dict:get(?PROC_STATUS_CONSUME_RANK),
    #st_consume_rank{consume_gold = ConsumeGold} = StConsumeRank,
    ConsumeGold.

%% 刷新排行榜
sort_rank_list(LogList, Base) ->
    F0 = fun(A, B) ->
        if
            A#consume_rank_info.consume_gold > B#consume_rank_info.consume_gold -> true;
            A#consume_rank_info.consume_gold < B#consume_rank_info.consume_gold -> false;
            true ->
                A#consume_rank_info.change_time < B#consume_rank_info.change_time
        end
    end,
    LogList1 = lists:sort(F0, LogList),

    F = fun(Log, {Rank0, L}) ->
        Rank = check_rank(Rank0, Log, Base),
        {Rank + 1, L ++ [Log#consume_rank_info{rank = Rank}]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.
%% 刷新排行榜
sort_rank_list_limit(LogList, Base) ->
    F0 = fun(A, B) ->
        if
            A#consume_rank_info.consume_gold > B#consume_rank_info.consume_gold -> true;
            A#consume_rank_info.consume_gold < B#consume_rank_info.consume_gold -> false;
            true ->
                A#consume_rank_info.change_time < B#consume_rank_info.change_time
        end
    end,
    LogList1 = lists:sort(F0, [X || X <- LogList, X#consume_rank_info.lv >= ?SHOW_LIMIT_LV orelse X#consume_rank_info.lv == 0]),
    F = fun(Log, {Rank0, L}) ->
        Rank = check_rank(Rank0, Log, Base),
        {Rank + 1, L ++ [Log#consume_rank_info{rank = Rank}]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

check_rank(Rank0, Log, Base) ->
    Rank1 = get_rank(Rank0, Log#consume_rank_info.consume_gold, Base),
    if
        Rank1 == [] -> Rank0;
        Rank1 =< Rank0 -> Rank0;
        true -> Rank1
    end.

%%重载排行榜
reload_rank(Base) ->
    case Base of
        [] -> [];
        #base_consume_rank{act_id = ActId} ->
            load_rank(ActId, Base)
    end.

load_rank(ActId, Base) ->
    Sql = io_lib:format("SELECT pkey,consume_gold,change_time,nickname,lv FROM player_consume_rank WHERE act_id =  ~p", [ActId]),
    Data =
        case db:get_all(Sql) of
            [] ->
                [];
            L ->
                F = fun([Pkey, ConsumeGold, ChangeTime, NickName, Lv]) ->
                    #consume_rank_info{
                        pkey = Pkey,
                        consume_gold = ConsumeGold,
                        change_time = ChangeTime,
                        name = util:to_list(NickName),
                        lv = Lv
                    }
                end,
                L1 = lists:map(F, L),
                sort_rank_list(L1, Base)
        end,
    Data.

reward(RankList, Base) ->
    F = fun(Info, Str) ->
        Reward = get_rank_val(Info#consume_rank_info.rank, Info#consume_rank_info.consume_gold, Base),
        if
            Reward == [] -> skip, Str;
            Info#consume_rank_info.rank > ?CONSUME_RANK_LIMIT ->
                reward_msg2(Info#consume_rank_info.pkey, tuple_to_list(Reward), 90, Str),
                Str;
            true ->
                reward_msg(Info#consume_rank_info.pkey, Info#consume_rank_info.rank, tuple_to_list(Reward), 84, Str),
                Str
        end
    end,

    F0 = fun(Rank, Str0) ->
        case lists:keyfind(Rank, #consume_rank_info.rank, RankList) of
            false ->
                Str1 = io_lib:format(?T("第~s名  无人满足  ~p  元宝数<br/>"), [to_chinese(Rank), get_limit(Rank, Base)]),
                string:concat(Str0, Str1);
            Log0 ->
                Str1 = io_lib:format(?T("第~s名  ~s  ~p 元宝<br/>"), [to_chinese(Rank), Log0#consume_rank_info.name, Log0#consume_rank_info.consume_gold]),
                string:concat(Str0, Str1)
        end
    end,
    Str2 = lists:foldl(F0, "<br/>", [1, 2, 3]),
    lists:foldl(F, Str2, RankList),
    ok.

reward_msg(Pkey, Rank, GoodsList, Type, Str) ->
    NowStr =
        case version:get_lan_config() of
            vietnam ->
                util:unixtime_to_time_string5(util:unixtime());
            _ ->
                util:unixtime_to_time_string2(util:unixtime())
        end,
    {Title, Content} = t_mail:mail_content(Type),
    Str0 = util:to_binary(Str),
    Date = io_lib:format(<<Content/binary, Str0/binary>>, [NowStr, Rank]),
    mail:sys_send_mail([Pkey], Title, Date, GoodsList),
    ok.

reward_msg2(Pkey, GoodsList, Type, Str) ->
    NowStr = util:unixtime_to_time_string5(util:unixtime()),
    {Title, Content} = t_mail:mail_content(Type),
    Str0 = util:to_binary(Str),
    Date = io_lib:format(<<Content/binary, Str0/binary>>, [NowStr]),
    mail:sys_send_mail([Pkey], Title, Date, GoodsList),
    ok.

gm_reward() ->
    sys_midnight_cacl2_gm().

%% 凌晨邮件结算
sys_midnight_cacl() ->
    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    if
        H == 23 andalso M == 58 -> sys_midnight_cacl2();
        true -> ok
    end.

sys_midnight_cacl2() ->
    case get_act() of
        [] ->
            ok;
        Base ->
            Pid = activity_proc:get_act_pid(),
            LTime = activity:get_leave_time(data_consume_rank),
            if
                LTime > 150 -> skip;
                true ->
                    spawn(fun() -> timer:sleep(110000), Pid ! {consume_rank_reward, Base} end)
            end
    end.

sys_midnight_cacl2_gm() ->
    case get_act() of
        [] ->
            ok;
        Base ->
            Pid = activity_proc:get_act_pid(),
            if
                true ->
                    spawn(fun() -> timer:sleep(1500), Pid ! {consume_rank_reward, Base} end)
            end
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        _ -> 0
    end.

clean() ->
    db:execute("truncate player_consume_rank ").


%% 推送 消费、充值、跨服消费、跨服充值状态
recharge_consume_rank_state(Player) ->
    State = {
        util:diff_day(config:get_open_days()) + 1,
        consume_rank:get_state(Player),
        recharge_rank:get_state(Player),
        cross_consume_rank:get_state(),
        cross_recharge_rank:get_state(),
        area_consume_rank:get_state(),
        area_recharge_rank:get_state()
    },
    {ok, Bin} = pt_432:write(43287, State),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_rank(Rank0, Gold, Base) ->
    RankInfoList = Base#base_consume_rank.rank_info,
    F = fun(Info, List) ->
        if Rank0 =< Info#rank_info.down andalso Gold >= Info#rank_info.limit -> [Info#rank_info.top | List];
            true -> List
        end
    end,
    List1 = lists:foldl(F, [], RankInfoList),
    case lists:reverse(List1) of
        [] -> 51;
        Other -> hd(Other)
    end.

get_rank_val(Rank0, Gold, Base) ->
    RankInfoList = Base#base_consume_rank.rank_info,
    F = fun(Info, List) ->
        if Rank0 =< Info#rank_info.down andalso Gold >= Info#rank_info.limit andalso Gold > 0 ->
            [Info#rank_info.reward | List];
            true -> List
        end
    end,
    List1 = lists:foldl(F, [], RankInfoList),
    case lists:reverse(List1) of
        [] -> [];
        Other -> hd(Other)
    end.


get_reward_list() ->
    case get_act() of
        [] ->
            [];
        Base ->
            F = fun(RankInfo) ->
                [RankInfo#rank_info.top,
                    RankInfo#rank_info.down,
                    RankInfo#rank_info.limit,
                    [tuple_to_list(X) || X <- tuple_to_list(RankInfo#rank_info.reward)]]
            end,
            lists:map(F, Base#base_consume_rank.rank_info)
    end.

to_chinese(1) -> ?T("一");
to_chinese(2) -> ?T("二");
to_chinese(3) -> ?T("三");
to_chinese(_) -> ?T("零").

get_limit(_, []) -> 0;
get_limit(Rank0, Base) ->
    RankInfoList = Base#base_consume_rank.rank_info,
    F = fun(Info, List) ->
        if Rank0 =< Info#rank_info.down andalso Rank0 >= Info#rank_info.top ->
            [Info#rank_info.limit | List];
            true -> List
        end
    end,
    List1 = lists:foldl(F, [], RankInfoList),
    case lists:reverse(List1) of
        [] -> [];
        Other -> hd(Other)
    end.
