%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 16:36
%%%-------------------------------------------------------------------
-module(area_recharge_rank).
-author("Administrator").
-include("daily.hrl").
-include("activity.hrl").
-include("server.hrl").
-include("common.hrl").

-include("achieve.hrl").
%% API
-export([
    update_recharge_rank/6
    , add_recharge_val/2
    , check_info/4
    , get_leave_time/0
    , end_reward/2
    , reward_msg/5
    , reward_msg2/4
    , get_state/0
    , get_rank/3
    , get_act/0
    , get_reward_list/0
    , fix/0
    , init/1
    , update_sn/2
]).

init(Player) ->
    LeaveTime = activity:get_leave_time(data_area_recharge_rank),
    if
        LeaveTime > 0 ->
            cross_all:apply(area_recharge_rank, update_sn, [Player#player.sn_cur, Player#player.key]);
        true -> skip
    end,
    ok.

%% 更新消费数据
update_sn(Sn, Pkey) ->
    ?CAST(area_recharge_rank_proc:get_server_pid(), {update_sn, Sn, Pkey}),
    ok.

add_recharge_val(Player, Val) ->
    LeaveTime = activity:get_leave_time(data_area_recharge_rank),
    if
        LeaveTime > 0 ->
            cross_all:apply(area_recharge_rank, update_recharge_rank, [node(), Player#player.sn_cur, Player#player.key, Player#player.nickname, Val, Player#player.lv]);
        true ->
            skip
    end,
    ok.

%% 更新充值数据
update_recharge_rank(Node, Sn, Pkey, PName, Value, Lv) ->
    ?CAST(area_recharge_rank_proc:get_server_pid(), {update_area_recharge_rank, Node, Sn, Pkey, PName, Value, Lv}),
    ok.

%% 查看充值榜
check_info(Node, Sn, Pkey, Sid) ->
    ?CAST(area_recharge_rank_proc:get_server_pid(), {check_info, Node, Sn, Pkey, Sid}),
    ok.

get_leave_time() ->
    ActList = activity:get_work_list(data_area_recharge_rank),
    case ActList of
        [] -> 0;  %%没有活动
        [Base | _] ->
            #base_act_area_recharge_rank{
                open_info = OpenInfo
            } = Base,
            activity:calc_act_leave_time(OpenInfo)
    end.

get_state() ->
    LeaveTime = get_leave_time(),
    ?IF_ELSE(LeaveTime > 0, 0, -1).

%% 开奖
end_reward(RankList, Base) ->
    F1 = fun(Log, Str) ->
%%         {_Node0, _} = center:check_by_sn(Log#area_recharge_rank_log.sn, 0),
        log_area_recharge_rank_final(Log#area_recharge_rank_log.pkey, Log#area_recharge_rank_log.nickname, Log#area_recharge_rank_log.sn, Log#area_recharge_rank_log.rank, Log#area_recharge_rank_log.recharge_gold),
        case get_rank_val(Log#area_recharge_rank_log.rank, Log#area_recharge_rank_log.recharge_gold, Base) of
            [] ->
                skip, Str;
            GoodsList ->
                case center:get_node_by_sn(Log#area_recharge_rank_log.sn) of
                    false ->
                        ?ERR("false ~p~n", [Log#area_recharge_rank_log.sn]),
                        skip, Str;
                    Node ->
                        if
                            Log#area_recharge_rank_log.rank > 50 ->
                                center:apply(Node, area_recharge_rank, reward_msg2, [Log#area_recharge_rank_log.pkey, tuple_to_list(GoodsList), 93, Str]),
                                Str;
                            true ->
                                center:apply(Node, area_recharge_rank, reward_msg, [Log#area_recharge_rank_log.pkey, Log#area_recharge_rank_log.rank, tuple_to_list(GoodsList), 89, Str]),
                                Str
                        end
                end
        end
    end,
    F = fun({_, LogList}) ->
        F0 = fun(Rank, Str0) ->
            case lists:keyfind(Rank, #area_recharge_rank_log.rank, LogList) of
                false ->
                    Str1 = io_lib:format(?T("第~s名  无人满足  ~p  元宝数<br/>"), [to_chinese(Rank), get_limit(Rank, Base)]),
                    string:concat(Str0, Str1);
                Log0 ->
                    Str1 = io_lib:format(?T("第~s名  ~p.~s  ~p 元宝<br/>"), [to_chinese(Rank), Log0#area_recharge_rank_log.sn, Log0#area_recharge_rank_log.nickname, Log0#area_recharge_rank_log.recharge_gold]),
                    string:concat(Str0, Str1)
            end
        end,
        Str2 = lists:foldl(F0, "<br/>", [1, 2, 3]),
        lists:foldl(F1, Str2, LogList)
    end,
    lists:foreach(F, RankList),
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

get_rank(Rank0, Gold, Base) ->
    RankInfoList = Base#base_act_area_recharge_rank.rank_info,
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
    RankInfoList = Base#base_act_area_recharge_rank.rank_info,
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

get_act() ->
    case activity:get_work_list(data_area_recharge_rank) of
        [] -> [];
        [Base | _] -> Base
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
            lists:map(F, Base#base_act_area_recharge_rank.rank_info)
    end.

log_area_recharge_rank_final(Pkey, Nickname, Sn, Rank, Value) ->
    Sql = io_lib:format("insert into  log_area_recharge_rank_final (pkey, nickname,sn,rank,value,time) VALUES(~p,'~s',~p,~p,~p,~p)",
        [Pkey, Nickname, Sn, Rank, Value, util:unixtime()]),
    log_proc:log(Sql),
    ok.

to_chinese(1) -> ?T("一");
to_chinese(2) -> ?T("二");
to_chinese(3) -> ?T("三");
to_chinese(_) -> ?T("零").

get_limit(_, []) -> 0;
get_limit(Rank0, Base) ->
    RankInfoList = Base#base_act_area_recharge_rank.rank_info,
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

fix() ->
    Base = #base_act_area_recharge_rank{open_info = #open_info{gp_id = [{0, 60000}, {30001, 50000}, {8001, 8500}, {1001, 1500}, {1501, 2000}, {2001, 2500}, {2501, 3000}, {50001, 60000}, {3001, 3500}, {3501, 4000}, {5001, 5500}, {6001, 6500}, {4001, 4500}, {8501, 9000}], gs_id = [], open_day = 0, end_day = 0, start_time = {{2017, 11, 18}, {00, 00, 00}}, end_time = {{2017, 11, 19}, {23, 59, 59}}, limit_open_day = 0, limit_end_day = 0, merge_st_day = 0, merge_et_day = 0, ignore_gs = [], priority = 0, after_open_day = 17}, act_id = 1, rank_info = [
        #rank_info{top = 1, down = 1, limit = 8000, reward = {{6602020, 10}, {8002407, 1}, {8002516, 15}}},
        #rank_info{top = 2, down = 3, limit = 5000, reward = {{6602020, 3}, {8002407, 1}, {8002516, 10}}},
        #rank_info{top = 4, down = 10, limit = 1000, reward = {{8002407, 1}, {8001054, 10}}},
        #rank_info{top = 11, down = 50, limit = 500, reward = {{8002406, 1}, {8001054, 5}}},
        #rank_info{top = 51, down = 999, limit = 0, reward = {{8001002, 1}, {2003000, 3}}}], act_info = #act_info{}},
    area_recharge_rank_proc:end_reward(Base),

    ok.
