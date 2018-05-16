%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 八月 2016 16:51
%%%-------------------------------------------------------------------
-module(panic_buying).
-author("hxming").

-include("common.hrl").
-include("panic_buying.hrl").
%% API
-compile(export_all).

%% 判断是否活动期间
check_activity_time(Now) ->
    Start = data_pb_time:start_time(),
    End = data_pb_time:end_time(),
    if Now < Start ->
        put(activity_start, erlang:send_after((Start - Now) * 1000, self(), activity_start)),
        false;
        Now > End -> false;
        true ->
            put(activity_close, erlang:send_after((End - Now) * 1000, self(), activity_close)),
            true
    end.
is_activity_time(Now) ->
    Start = data_pb_time:start_time(),
    End = data_pb_time:end_time(),
    if Now >= Start andalso Now =< End ->
        {true, End - Now};
        true -> false
    end.

%%活动状态查询
check_state(Node, Sid) ->
    ?CAST(panic_buying_proc:get_server_pid(), {check_state, Node, Sid}).
%%查看抢购列表
check_goods_list(Node, Pkey, Sid) ->
    ?CAST(panic_buying_proc:get_server_pid(), {check_goods_list, Node, Pkey, Sid}).
%%往期回顾
review_goods_list(Node, Sid, Type, Page) ->
    ?CAST(panic_buying_proc:get_server_pid(), {review_goods_list, Node, Sid, Type, Page}).
%%查看我的购买列表
check_my_pay(Node, Pkey, Sid, Page) ->
    ?CAST(panic_buying_proc:get_server_pid(), {check_my_pay, Node, Pkey, Sid, Page}).
%%购物
pay_goods(Node, Sn, Pkey, Pid, Nickname, Sid, Id, Num, PayList) ->
    ?CAST(panic_buying_proc:get_server_pid(), {pay_goods, Node, Sn, Pkey, Pid, Nickname, Sid, Id, Num, PayList}).

%%检查是否够钻购买
check_pay(Player, Num) ->
    Count = goods_util:get_goods_count(?PANIC_BUYING_GOODS_ID),
    if Count > Num -> {true, [{goods, ?PANIC_BUYING_GOODS_ID, Num}]};
        true ->
            Gold = (Num - Count) * 10,
            case money:is_enough(Player, Gold, gold) of
                false -> false;
                true ->
                    {true, [{goods, ?PANIC_BUYING_GOODS_ID, Count}, {gold, Gold}]}
            end
    end.

%%邮件奖励
mail_reward(Pkey, Type, Date, LuckyId, Ret, Gid, Num) ->
    {Title, Content} =
        case Ret of
            0 ->
                t_mail:mail_content(60);
            _ ->
                t_mail:mail_content(61)
        end,
    NewContent = io_lib:format(Content, [type_name(Type), Date, LuckyId]),
    mail:sys_send_mail([Pkey], Title, NewContent, [{Gid, Num}]),
    ok.

type_name(Type) ->
    case Type of
        1 -> ?T("精品");
        2 -> ?T("特供");
        _ -> ?T("特价")
    end.

