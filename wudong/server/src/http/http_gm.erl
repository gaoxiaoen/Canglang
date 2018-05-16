%% @author zj
%% @doc http gm控制接口

-module(http_gm).
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("g_daily.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([
    send_mail/1,
    update_online_mail/1,
    update_notice/1,
    lim_chat/1,
    lim_chat_sp/1,
    kick_off/1,
    goods_name/1,
    set_gm/1,
    monitor_chat/1,
    fb_act/1,
    naver_cafe/1,
    get_work_list_by_time/1,
    get_work_list_by_time_all/1,
    gift_hk/1,
    set_anti_addiction/1
]).

%%后台更新玩家邮件列表
update_online_mail(QueryParam) ->
    Pkey = util:to_integer(proplists:get_value("pkey", QueryParam)),
    case player_util:get_player_online(Pkey) of
        [] ->
            Ret = 0;
        OnlinePlayer ->
                catch OnlinePlayer#ets_online.pid ! reload_mail,
            Ret = 1
    end,
    {ok, Ret}.

%%后台发送邮件
send_mail(QueryParam) ->
    Id = util:to_integer(proplists:get_value("id", QueryParam)),
    spawn((fun() -> timer:sleep(2000), mail:gm_all(Id) end)),
    {ok, 1}.

%%禁言
lim_chat(QueryParam) ->
    Pkey = util:to_integer(proplists:get_value("pkey", QueryParam)),
    Hour = util:to_integer(proplists:get_value("hour", QueryParam)),
    chat:set_lim(Pkey, Hour),
    ok.

%%特殊禁言
lim_chat_sp(QueryParam) ->
    Pkey = util:to_integer(proplists:get_value("pkey", QueryParam)),
    ChatState = util:to_integer(proplists:get_value("chat_state", QueryParam)),
    ?DEBUG("lim_chat_sp test ~p~n", [QueryParam]),
    chat:set_lim_sp(Pkey, ChatState),
    ok.

kick_off(QueryParam) ->
    Pkey = util:to_integer(proplists:get_value("pkey", QueryParam)),
    case player_util:get_player_online(Pkey) of
        [] ->
            Ret = 0;
        OnlinePlayer ->
            ?CAST(OnlinePlayer#ets_online.pid, stop),
            Ret = 1
    end,
    {ok, Ret}.


goods_name(QueryParam) ->
    GoodsType = util:to_integer(proplists:get_value("goodstype", QueryParam)),
    Name =
        case data_goods:get(GoodsType) of
            [] -> "";
            Goods -> Goods#goods_type.goods_name
        end,
    {ok, Name}.


set_gm(QueryParam) ->
    Pkey = util:to_integer(proplists:get_value("pkey", QueryParam)),
    GM = util:to_integer(proplists:get_value("gm", QueryParam)),
    Res = player_util:set_gm(Pkey, GM),
    {ok, Res}.

monitor_chat(QueryParam) ->
    case chat_proc:get_monitor_chat() of
        [] ->
            {ok, 0};
        ChatList ->
            TimesTamp = util:to_integer(proplists:get_value("ts", QueryParam)),
            F = fun([Pkey, Nickname, Ts, Content], String) ->
                if Ts + 20 > TimesTamp ->
                    Info = lists:concat([Pkey, ";", Nickname, ";", Ts, ";", Content]),
                    lists:concat([Info, "|", String]);
                    true ->
                        String
                end
                end,
            Res = lists:foldl(F, "", ChatList),
            {ok, Res}
    end.

%%Facebook分享奖励
%%Facebook分享奖励
fb_act(QueryParam) ->
    Pkey = util:to_integer(proplists:get_value("pkey", QueryParam)),
    ActId = util:to_integer(proplists:get_value("act_id", QueryParam)),
    GoodsList = proplists:get_value("goods", QueryParam),
    ?ERR("param ~p GoodsList ~p~n", [QueryParam, GoodsList]),
    Sql = io_lib:format("select time from fb_act where pkey=~p and act_id=~p", [Pkey, ActId]),
    case db:get_row(Sql) of
        [] ->
            Sql1 = io_lib:format("insert into fb_act set pkey=~p,act_id=~p,goods = '~s',time=~p", [Pkey, ActId, GoodsList, util:unixtime()]),
            db:execute(Sql1),
            mail:sys_send_mail([Pkey], ?T("FB奖励"), ?T("您参与了FB活动,获得奖励,请查收!"), util:string_to_term(GoodsList)),
            ok;
        _ -> ok
    end,
    {ok, 1}.

naver_cafe(QueryParam) ->
    Pkey = util:to_integer(proplists:get_value("pkey", QueryParam)),
    ActId = util:to_integer(proplists:get_value("act_id", QueryParam)),
    Title = util:to_integer(proplists:get_value("title", QueryParam)),
    Content = util:to_integer(proplists:get_value("content", QueryParam)),
    GoodsList = proplists:get_value("goods", QueryParam),
    Sql = io_lib:format("select time from fb_act where pkey=~p and act_id=~p", [Pkey, ActId]),
    case db:get_row(Sql) of
        [] ->
            Sql1 = io_lib:format("insert into fb_act set pkey=~p,act_id=~p,goods = '~s',time=~p", [Pkey, ActId, GoodsList, util:unixtime()]),
            db:execute(Sql1),
            mail:sys_send_mail([Pkey], Title, Content, util:string_to_term(GoodsList)),
            ok;
        _ -> ok
    end,
    {ok, 1}.

gift_hk(QueryParam) ->
    ActType = util:to_integer(proplists:get_value("act_type", QueryParam)),
    Pkey = util:to_integer(proplists:get_value("pkey", QueryParam)),
    ActId = util:to_integer(proplists:get_value("act_id", QueryParam)),
    GiftId = util:to_integer(proplists:get_value("gift_id", QueryParam)),
    ?ERR("param ~p GiftId ~p~n", [QueryParam, GiftId]),
    case data_fb_gift:get(GiftId) of
        [] -> ok;
        GoodsList ->
            if ActType == 1 ->
                case g_daily:get_count(?G_FOREVER_HK_GIFT(ActType)) == 0 of
                    true ->
                        mail:mail_all(?T("FB奖励"), ?T("您参与了FB活动,获得奖励,请查收!"), GoodsList),
                        g_daily:increment(?G_FOREVER_HK_GIFT(ActType)),
                        ok;
                    false -> ok
                end;
                true ->
                    Sql = io_lib:format("select time from fb_act where pkey=~p and act_id=~p", [Pkey, ActId]),
                    case db:get_row(Sql) of
                        [] ->
                            Sql1 = io_lib:format("insert into fb_act set pkey=~p,act_id=~p,goods = '~s',time=~p", [Pkey, ActId, util:term_to_bitstring(GoodsList), util:unixtime()]),
                            db:execute(Sql1),
                            mail:sys_send_mail([Pkey], ?T("FB奖励"), ?T("您参与了FB活动,获得奖励,请查收!"), GoodsList),
                            ok;
                        _ -> ok
                    end
            end
    end,
    {ok, 1}.

%%
update_notice(_QueryParam) ->
    OpenTime = config:get_opening_time(),
    {ok, OpenTime}.

%%获取特定时间戳有效的活动列表(所有)
get_work_list_by_time_all(QueryParam) ->
    StartTime = util:to_integer(proplists:get_value("stime", QueryParam)),
    EndTime = util:to_integer(proplists:get_value("etime", QueryParam)),
    StartUnixdate = util:unixdate(StartTime),
    EndUnixdate = util:unixdate(EndTime),
    F = fun(Day) ->
        List = activity:get_work_list_by_time_all(StartUnixdate + Day * ?ONE_DAY_SECONDS),
        List
        end,
    ReList = lists:map(F, lists:seq(0, (EndUnixdate - StartUnixdate) div ?ONE_DAY_SECONDS)),
%%     {ok, 1}.
    {ok, ReList}.

%%获取特定时间戳有效的活动列表
get_work_list_by_time(QueryParam) ->
    StartTime = util:to_integer(proplists:get_value("stime", QueryParam)),
    EndTime = util:to_integer(proplists:get_value("etime", QueryParam)),
    Mod = util:to_integer(proplists:get_value("mod", QueryParam)),
    StartUnixdate = util:unixdate(StartTime),
    EndUnixdate = util:unixdate(EndTime),
    F = fun(Day) ->
        Base = activity:get_work_list_by_time(Mod, StartTime + Day * ?ONE_DAY_SECONDS),
        Base
        end,
    ReList = lists:map(F, lists:seq(0, (EndUnixdate - StartUnixdate) div ?ONE_DAY_SECONDS)),
    {ok, ReList}.

%%设置防沉迷配置
set_anti_addiction(QueryParam) ->
    Status = util:to_integer(proplists:get_value("is_addiction", QueryParam)),
    Notice = util:to_integer(proplists:get_value("addiction_notify", QueryParam)),
    Config = [Status, Notice],
    handle_fcm:set_fcm(util:term_to_string(Config)),
    {ok, 1}.

%% ====================================================================
%% Internal functions
%% ====================================================================
