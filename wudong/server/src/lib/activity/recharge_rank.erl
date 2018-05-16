%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 六月 2017 10:03
%%%-------------------------------------------------------------------
-module(recharge_rank).
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
%% API
-export([
    init/1,
    add_recharge_val/2,
    get_rank_player/3,
    get_recharge/0,
    sort_rank_list/2,
    reload_rank/1,
    night_refresh/2,
    night_refresh_all/0,
    reward/2,
    sys_midnight_cacl/0,
    gm_reward/0,
    get_state/1,
    clean/0,
    get_reward_list/0,
    make_to_client/2,
    get_act/0,
    get_limit/2,
    sort_rank_list_limit/2
]).
-define(SHOW_LIMIT_LV, 50).
-define(SEND_RANK_LIMIT, 50).

init(Player) ->
    StRecharge = activity_load:dbget_recharge_rank(Player),
    lib_dict:put(?PROC_STATUS_RECHARGE_RANK, StRecharge),
    update(Player),
    ok.

update(#player{key = Pkey, nickname = Name} = Player) ->
    St = lib_dict:get(?PROC_STATUS_RECHARGE_RANK),
    #st_recharge_rank{
        act_id = ActId
    } = St,
    NewSt0 = #st_recharge_rank{
        pkey = Pkey,
        act_id = 0,
        recharge_gold = 0,
        name = Name,
        lv = Player#player.lv
    },
    NewSt =
        case activity:get_work_list(data_recharge_rank) of
            [] -> St;
            [Base | _] ->
                #base_recharge_rank{
                    act_id = BaseActId
                } = Base,
                case BaseActId =/= ActId of
                    true ->
                        NewSt0#st_recharge_rank{
                            act_id = BaseActId
                        };
                    false ->
                        St
                end
        end,
    lib_dict:put(?PROC_STATUS_RECHARGE_RANK, NewSt),
    ok.

add_recharge_val(Player, Val) ->
    StRechargeRank = lib_dict:get(?PROC_STATUS_RECHARGE_RANK),
    #st_recharge_rank{recharge_gold = RechargeGold} = StRechargeRank,
    case get_act() of
        [] ->
            skip;
        _ ->
            if
                Player#player.lv > ?SHOW_LIMIT_LV + 5 andalso Val == 0 -> skip;
                Player#player.lv < ?SHOW_LIMIT_LV - 3 andalso Val == 0 -> skip;
                true ->
                    Now = util:unixtime(),
                    NewStRechargeRank = StRechargeRank#st_recharge_rank{recharge_gold = RechargeGold + Val, change_time = Now, name = Player#player.nickname, lv = Player#player.lv},
                    lib_dict:put(?PROC_STATUS_RECHARGE_RANK, NewStRechargeRank),
                    activity_load:dbup_recharge_rank(NewStRechargeRank),
                    Pid = activity_proc:get_act_pid(),
                    Pid ! {update_recharge_rank, Player#player.key, Player#player.nickname, Val, Player#player.lv}
            end
    end.

%% 重置数据
night_refresh(clean, Player) ->
    Recharge = lib_dict:get(?PROC_STATUS_RECHARGE_RANK),
    Base = get_act(),
    case Base == [] of
        true ->
            NewRecharge = #st_recharge_rank{pkey = Player#player.key},
            lib_dict:put(?PROC_STATUS_RECHARGE_RANK, NewRecharge);
        false ->
            ActId = Recharge#st_recharge_rank.act_id,
            case Base#base_recharge_rank.act_id =/= ActId of
                true ->
                    NewRecharge = #st_recharge_rank{
                        pkey = Player#player.key,
                        act_id = Base#base_recharge_rank.act_id,
                        recharge_gold = 0
                    };
                false ->
                    NewRecharge = Recharge
            end,
            lib_dict:put(?PROC_STATUS_RECHARGE_RANK, NewRecharge)
    end,
    ok.

%%凌晨数据更新
night_refresh_all() ->
    ?DEBUG("night_refresh_all ~n"),
    ActList = get_act(),
    case ActList == [] of
        true ->
            skip;
        false ->
            Pids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
            F = fun([P]) ->
                player:apply_state(async, P, {recharge_rank, night_refresh, clean})
            end,
            [F(Pid) || Pid <- Pids]
    end.

get_act() ->
    case activity:get_work_list(data_recharge_rank) of
        [] -> [];
        [Base | _] -> Base
    end.

get_rank_player(RechargeRankList, Pid, MyRecharge) ->
    Pid ! {recharge_rank_send, RechargeRankList, MyRecharge},
    ok.

make_to_client(Pkey, RechargeRankList) ->
    Rank = case lists:keyfind(Pkey, #recharge_rank_info.pkey, RechargeRankList) of
               false -> 0;
               Other ->
                   ?IF_ELSE(Other#recharge_rank_info.recharge_gold =< 0, 0, Other#recharge_rank_info.rank)
           end,
    F = fun(Info) ->
        #recharge_rank_info{rank = Rank0, name = NickName, recharge_gold = RechargeGold} = Info,
        [Rank0, NickName, RechargeGold]
    end,
    RankList = lists:map(F, [X || X <- RechargeRankList, X#recharge_rank_info.rank =< ?SEND_RANK_LIMIT]),
    {Rank, RankList}.

get_recharge() ->
    StRechargeRank = lib_dict:get(?PROC_STATUS_RECHARGE_RANK),
    #st_recharge_rank{recharge_gold = RechargeGold} = StRechargeRank,
    RechargeGold.

%% 刷新排行榜
sort_rank_list(LogList, Base) ->
    F0 = fun(A, B) ->
        if
            A#recharge_rank_info.recharge_gold > B#recharge_rank_info.recharge_gold -> true;
            A#recharge_rank_info.recharge_gold < B#recharge_rank_info.recharge_gold -> false;
            true ->
                A#recharge_rank_info.change_time < B#recharge_rank_info.change_time
        end
    end,
    LogList1 = lists:sort(F0, LogList),
    F = fun(Log, {Rank0, L}) ->
        Rank = check_rank(Rank0, Log, Base),
        {Rank + 1, L ++ [Log#recharge_rank_info{rank = Rank}]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

%% 刷新排行榜 等级限制
sort_rank_list_limit(LogList, Base) ->
    F0 = fun(A, B) ->
        if
            A#recharge_rank_info.recharge_gold > B#recharge_rank_info.recharge_gold -> true;
            A#recharge_rank_info.recharge_gold < B#recharge_rank_info.recharge_gold -> false;
            true ->
                A#recharge_rank_info.change_time < B#recharge_rank_info.change_time
        end
    end,
    LogList1 = lists:sort(F0, [X || X <- LogList, X#recharge_rank_info.lv >= ?SHOW_LIMIT_LV orelse X#recharge_rank_info.lv == 0]),
    F = fun(Log, {Rank0, L}) ->
        Rank = check_rank(Rank0, Log, Base),
        {Rank + 1, L ++ [Log#recharge_rank_info{rank = Rank}]}
    end,
    {_, RankList} = lists:foldl(F, {1, []}, LogList1),
    RankList.

check_rank(Rank0, Log, Base) ->
    Rank1 = get_rank(Rank0, Log#recharge_rank_info.recharge_gold, Base),
    if
        Rank1 == [] -> Rank0;
        Rank1 =< Rank0 -> Rank0;
        true -> Rank1
    end.

%%重载排行榜
reload_rank(Base) ->
    case Base of
        [] -> [];
        #base_recharge_rank{act_id = ActId} ->
            load_rank(ActId, Base)
    end.

load_rank(ActId, Base) ->
    Sql = io_lib:format("SELECT pkey,recharge_gold,change_time,nickname,lv FROM player_recharge_rank WHERE act_id =  ~p", [ActId]),
    Data =
        case db:get_all(Sql) of
            [] ->
                [];
            L ->
                F = fun([Pkey, RechargeGold, ChangeTime, NickName, Lv]) ->
                    #recharge_rank_info{
                        pkey = Pkey,
                        recharge_gold = RechargeGold,
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
        Reward = get_rank_val(Info#recharge_rank_info.rank, Info#recharge_rank_info.recharge_gold, Base),
        if
            Reward == [] -> skip, Str;
            Info#recharge_rank_info.rank > ?RECHARGE_RANK_LIMIT ->
                reward_msg2(Info#recharge_rank_info.pkey, tuple_to_list(Reward), 91, Str),
                Str;
            true ->
                reward_msg(Info#recharge_rank_info.pkey, Info#recharge_rank_info.rank, tuple_to_list(Reward), 85, Str),
                Str
        end
    end,

    F0 = fun(Rank, Str0) ->
        case lists:keyfind(Rank, #recharge_rank_info.rank, RankList) of
            false ->
                Str1 = io_lib:format(?T("第~s名  无人满足  ~p  元宝数<br/>"), [to_chinese(Rank), get_limit(Rank, Base)]),
                string:concat(Str0, Str1);
            Log0 ->
                Str1 = io_lib:format(?T("第~s名  ~s  ~p 元宝<br/>"), [to_chinese(Rank), Log0#recharge_rank_info.name, Log0#recharge_rank_info.recharge_gold]),
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
    NowStr =
        case version:get_lan_config() of
            vietnam ->
                util:unixtime_to_time_string5(util:unixtime());
            _ ->
                util:unixtime_to_time_string2(util:unixtime())
        end,
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
            LTime = activity:get_leave_time(data_recharge_rank),
            if
                LTime > 150 -> skip;
                true ->
                    spawn(fun() -> timer:sleep(110000), Pid ! {recharge_rank_reward, Base} end)
            end
    end.

sys_midnight_cacl2_gm() ->
    case get_act() of
        [] ->
            ok;
        _Base ->
            Pid = activity_proc:get_act_pid(),
            if
                true ->
                    spawn(fun() -> timer:sleep(1500), Pid ! {recharge_rank_reward, _Base} end)
            end
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        _ -> 0
    end.

clean() ->
    db:execute("truncate player_recharge_rank ").


get_rank(Rank0, Gold, Base) ->
    RankInfoList = Base#base_recharge_rank.rank_info,
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
    RankInfoList = Base#base_recharge_rank.rank_info,
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
            lists:map(F, Base#base_recharge_rank.rank_info)
    end.




to_chinese(1) -> ?T("一");
to_chinese(2) -> ?T("二");
to_chinese(3) -> ?T("三");
to_chinese(_) -> ?T("零").

get_limit(_, []) -> 0;
get_limit(Rank0, Base) ->
    RankInfoList = Base#base_recharge_rank.rank_info,
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
