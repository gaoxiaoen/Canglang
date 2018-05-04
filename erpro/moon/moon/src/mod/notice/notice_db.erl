%%----------------------------------------------------
%% notice系统数据库操作
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(notice_db).
-export([load/0, load_boards/0]).
-export([save_claim_notice_attach/4, load_claim_attach_log/0, charge_info_for_notice/0]).

-include("notice.hrl").
-include("common.hrl").

-define(max_deadline, (util:unixtime() + (40 * 24 * 3600))).

%% @spec load() -> NoticeState
%% NoticeState = #notice_state{}
%% @doc 重载系统公告
load() ->
    Flag = check_notice_flag(),
    Sql = <<"select nid, type, timing, beg, end, msg from sys_notice where flag = ~s and able = 1">>,
    case db:get_all(Sql, [Flag]) of
        {ok, Notice} ->
            convert(Notice, Flag);
        _ ->
            ?ERR("系统公告重载失败"),
            #notice_state{}
    end.

check_notice_flag() ->
    OpenTime = case sys_env:get(srv_open_time) of
        Time when is_integer(Time) ->
            Time;
        _Time ->
            ?ERR("系统开服时间设置有问题，获取到的值是{~w}, 不是一个整型", [_Time]),
            util:unixtime()
    end,
    Now = util:unixtime(),
    OpenDay = util:unixtime({today, OpenTime}) + 86400,     %% 开服那天晚上24点时间
    NowDiffOpen = Now - OpenTime,
    DayDiffOpen = OpenDay - OpenTime,
    if
        NowDiffOpen < DayDiffOpen -> 1;                 %% 开服第一天
        NowDiffOpen < (DayDiffOpen + 86400) -> 2;       %% 开服第二天
        NowDiffOpen < (DayDiffOpen + 2*86400) -> 3;     %% 开服第三天
        NowDiffOpen < (DayDiffOpen + 3*86400) -> 4;     %% 开服第四天
        NowDiffOpen < (DayDiffOpen + 4*86400) -> 5;     %% 开服第五天
        NowDiffOpen < (DayDiffOpen + 5*86400) -> 6;     %% 开服第六天
        NowDiffOpen < (DayDiffOpen + 6*86400) -> 7;     %% 开服第七天
        true -> 8                                       %% 开服七天之后
    end.

%% @spec load_boards() -> {NoticeBoards, Ver}
%% Noticeboards = [#notice_board{} | ...]
%% Ver = integer()
%% @doc 重载系统公告板内容
load_boards() ->
    Sql = <<"select id, vtime, stime, gold, coin, bind_gold, bind_coin, subject, summary, msg, cond, items from sys_notice_board where status = 1 and vtime < ~s">>,
    case db:get_all(Sql, [?max_deadline]) of
        {ok, Boards} ->
            covert_boards(Boards);
        {error, _Why} ->
            ?ERR("重载公告版内容失败，【Reason: ~s】", [_Why]),
            []
    end.

%% 保存领取公告附件的角色到数据库
save_claim_notice_attach(Rid, Srvid, Name, Notice) ->
    Sql = <<"replace into log_notice_board(id, srv_id, name, notice) values (~s,~s,~s,~s)">>,
    case db:execute(Sql, [Rid, Srvid, Name, util:term_to_string(Notice)]) of
        {error, _Why} ->
            ?ERR("角色【~s】领取公告[~w]附件，保存日志到数据中时发生错误，【Reason:~s】", [Name, Notice, _Why]),
            false;
        {ok, _Result} ->
            true
    end.

load_claim_attach_log() ->
    Sql = <<"select id, srv_id, notice from log_notice_board">>,
    case db:get_all(Sql) of
        {ok, Logs} ->
            covert_notice_claim_log(Logs);
        {error, _Why} ->
            ?ERR("获取公告附件领取日志时发生错误【~s】", [_Why]),
            []
    end.

charge_info_for_notice() ->
    Sql = <<"SELECT rid, srv_id, SUM(gold) gold FROM sys_charge GROUP BY rid, srv_id">>,
    case db:get_all(Sql) of
        {ok, Charges} ->
            [{{Rid, Srvid}, Gold} || [Rid, Srvid, Gold] <- Charges];
        {error, _Why} ->
            ?ERR("获充值日志时发生错误【~s】", [_Why]),
            []
    end.

covert_notice_claim_log(Logs) ->
    covert_notice_claim_log(Logs, []).
covert_notice_claim_log([], Logs) ->
    Logs;
covert_notice_claim_log([[Rid, Srvid, NoticeLog] | T], Logs) ->
    case util:bitstring_to_term(NoticeLog) of
        {ok, undefined} ->
            ?ERR("转换角色[{~w,~s}]的公告领取日志[Notice:~w]时发生错误[Reason: undefined]", [Rid, Srvid, NoticeLog]),
            covert_notice_claim_log(T, [{Rid, Srvid, forbid} | Logs]);
        {ok, Term} -> 
            covert_notice_claim_log(T, [{Rid, Srvid, Term} | Logs]);
        {error, Why} ->
            ?ERR("转换角色[{~w,~s}]的公告领取日志[Notice:~w]时发生错误[Reason:~w]", [Rid, Srvid, NoticeLog, Why]),
            [{Rid, Srvid, forbid}]
    end.


%% 将重载出来的公告转换成 notice 进程状态数据
convert(Notice, Flag) ->
    convert(Notice, #notice_state{}, Flag).
convert([], State = #notice_state{top = TopNotice, left = LeftNotice}, _Flag) ->
    State#notice_state{top = lists:keysort(#notice.id, TopNotice), left = lists:keysort(#notice.id, LeftNotice)};

%% 开服一周内的顶部公告
convert([[ID, ?notice_top, Time, _Beg, _End, Msg] | T], State = #notice_state{top_gap = Gap, top = Top}, Flag) when Flag < 8 ->
    Notice = #notice{id = ID, type = ?notice_top, msg = Msg},
    convert(T, State#notice_state{top_gap = max(Time, Gap), top = [Notice|Top]}, Flag);

%% 开服一周后的顶部公告
convert([[ID, ?notice_top, Time, Beg, End, Msg] | T], State = #notice_state{top_gap = Gap, top = Top}, Flag) ->
    case End > util:unixtime() orelse End =:= 0 of  %% 没有结束时间的是需要一直播报
        true ->
            Notice = #notice{id = ID, type = ?notice_top, start = Beg, finish = End, msg = Msg},
            convert(T, State#notice_state{top_gap = max(Time, Gap), top = [Notice|Top]}, Flag);
        false ->
            convert(T, State, Flag)
    end;

%% 开服一周内的左下公告
convert([[ID, ?notice_left, Time, _Beg, _End, Msg] | T], State = #notice_state{left_gap = Gap, left = Left}, Flag) when Flag < 8 ->
    Notice = #notice{id = ID, type = ?notice_left, msg = Msg},
    convert(T, State#notice_state{left_gap = max(Time, Gap), left = [Notice|Left]}, Flag);

%% 开服一周后的左下公告
convert([[ID, ?notice_left, Time, Beg, End, Msg] | T], State = #notice_state{left_gap = Gap, left = Left}, Flag) ->
    case End > util:unixtime() orelse End =:= 0 of
        true ->
            Notice = #notice{id = ID, type = ?notice_left, start = Beg, finish = End, msg = Msg},
            convert(T, State#notice_state{left_gap = max(Time, Gap), left = [Notice|Left]}, Flag);
        false ->
            convert(T, State, Flag)
    end;

convert([[_ID, Type, _Time, _Beg, _End, _Msg] | T], State, Flag) ->
    ?ERR("非法公告类型 ~w", [Type]),
    convert(T, State, Flag).

%% 将重载出来的公告板内容转换成 notice_board 数据
covert_boards(Boards) ->
    covert_boards(Boards, []).
covert_boards([], Boards) -> Boards;
covert_boards([[ID, Time, Stime, Gold, Coin, B_gold, B_coin, Sub, Sum, Msg, CondStr, ItemsStr] | T], Boards) -> 
    case Time > util:unixtime() of
        true ->
            Cond = case util:bitstring_to_term(CondStr) of
                {ok, BtCond} -> BtCond;
                _ -> []
            end,
            case covert_notice_items(ItemsStr) of
                false ->
                    covert_boards(T, Boards);
                Items ->
                    covert_boards(T, [#notice_board{
                                id = ID, time = Time, stime = Stime, gold = Gold, coin = Coin, bind_gold = B_gold, 
                                bind_coin = B_coin, subject = Sub, summary = Sum, text = Msg, condition = Cond, items = Items} |Boards])
            end;
        false ->
            covert_boards(T, Boards)
    end.

covert_notice_items(ItemsStr) ->
    case util:bitstring_to_term(ItemsStr) of
        {ok, undefined} ->
            [];
        {ok, Items} ->
            case covert_item_tuple(Items) of
                false ->
                    ?ERR("错误的物品附件[~w]", [Items]),
                    false;
                NewItems ->
                    NewItems
            end;
        {error, Why} ->
            ?ERR("转换公告版的物品物件时发生错误【Reason:~s】", [Why]),
            []
    end.

covert_item_tuple(Items) ->
    covert_item_tuple(Items, []).
covert_item_tuple([], Items) ->
    Items;
covert_item_tuple([[BaseID, Bind, Num] | T], Items) when (Bind =:= 0 orelse Bind =:= 1) andalso Num > 0 ->
    case item_data:get(BaseID) of
        {ok, _} ->
            covert_item_tuple(T, [{BaseID, Bind, Num} | Items]);
        _ ->
            false
    end;
covert_item_tuple(_, _) ->
    false.
