%% --------------------------------------------------------------------
%% 跨服至尊相关接口
%% @author shawn 
%% @end
%% --------------------------------------------------------------------
-module(cross_king_rpc).
-export([handle/3]).

-include("role.hrl").
-include("common.hrl").

%% 请求活动状态
handle(17000, {}, #role{}) ->
    case sys_env:get(srv_open_time) of
        T when is_integer(T) ->
            Openday = util:unixtime({today, T}),
            case Openday + 6 * 86400 < util:unixtime() of
                true ->
                    case sys_env:get(cross_king_status) of
                        {0, _} ->
                            ?DEBUG("缓存状态:空闲期"),
                            {reply, {0, 0}};
                        {1, Ts} ->
                            ?DEBUG("缓存状态:报名倒计时"),
                            Time = util:time_left(180 * 1000, Ts) div 1000,
                            {reply, {1, Time}};
                        {2, Ts} ->
                            ?DEBUG("缓存状态:进入正式区倒计时"),
                            Time = util:time_left(300 * 1000, Ts) div 1000,
                            {reply, {2, Time}};
                        {3, EndTime} ->
                            ?DEBUG("缓存状态:比赛期"),
                            Time = EndTime - util:unixtime(),
                            {reply, {3, Time}};
                        _ ->
                            ?DEBUG("无中央服管理器状态,需请求"),
                            case cross_king_api:call_center(get_status) of
                                {ok, {0, _}} ->
                                    sys_env:set(cross_king_status, {0, 0}),
                                    {reply, {0, 0}};
                                {ok, {1, Ts}} ->
                                    sys_env:set(cross_king_status, {1, Ts}),
                                    Time = util:time_left(180 * 1000, Ts) div 1000,
                                    {reply, {1, Time}};
                                {ok, {2, Ts}} ->
                                    sys_env:set(cross_king_status, {2, Ts}),
                                    Time = util:time_left(300 * 1000, Ts) div 1000,
                                    {reply, {2, Time}};
                                {ok, {3, EndTime}} ->
                                    sys_env:set(cross_king_status, {3, EndTime}),
                                    Time = EndTime - util:unixtime(),
                                    {reply, {3, Time}};
                                _ -> {reply, {0, 0}}
                            end
                    end;
                false -> {ok}
            end;
        _ -> {ok}
    end;

%% 报名
handle(17001, {}, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?false, ?L(<<"组队不能报名至尊王者">>)}};
handle(17001, {}, #role{combat_pid = CPid}) when is_pid(CPid) ->
    {reply, {?false, ?L(<<"战斗状态下无法报名至尊王者">>)}};
handle(17001, {}, #role{ride = ?ride_fly}) ->
    {reply, {?false, ?L(<<"至尊王者赛中禁止飞行">>)}};
handle(17001, {}, #role{status = Status}) when Status =/= ?status_normal ->
    {reply, {?false, ?L(<<"该状态下无法参加报名至尊王者">>)}};
handle(17001, {}, Role = #role{event = ?event_no}) ->
    case allow(cross_king_sign) of
        true ->
            case cross_king_api:role_enter(Role) of
                {false, Msg} -> {reply, {?false, Msg}};
                _ -> {ok, Role}
            end;
        {false, Msg} -> {reply, {?false, Msg}};
        false -> {reply, {?false, ?L(<<"请勿频繁的报名参加至尊王者">>)}}
    end;
handle(17001, {}, #role{event = ?event_cross_king_prepare}) ->
    {reply, {?false, ?L(<<"您已经在准备区中，无需再次报名">>)}};
handle(17001, {}, _) ->
    {reply, {?false, ?L(<<"当前状态无法报名至尊王者">>)}};

%% 退出
handle(17002, {}, #role{combat_pid = CPid}) when is_pid(CPid) ->
    {reply, {?false, ?L(<<"战斗状态下不能退出至尊王者">>)}};
handle(17002, {}, #role{event = ?event_no}) -> {ok};
handle(17002, {}, Role = #role{cross_srv_id = <<"center">>}) ->
    case cross_king_mgr:role_leave(Role) of
        {false, Msg} -> {reply, {?false, Msg}};
        _ ->
            {ok}
    end;

%% 个人战区信息
handle(17003, {}, #role{id = Id, event = Event})
when Event =:= ?event_cross_king_match ->
    case cross_king_api:call_center({get_role_info, Id}) of
        {Seq, Type, Score, DeathTime} ->
            {reply, {Seq, Type, Score, DeathTime}};
        false -> {ok};
        _ -> {ok}
    end;
handle(17003, {}, _) -> {ok};

handle(17004, {}, #role{event = Event, event_pid = EventPid})
when Event =:= ?event_cross_king_match ->
    case cross_king:get_zone_list(EventPid) of
        {GfsList, DsList} ->
            {reply, {GfsList, DsList}};
        false -> {ok};
        _ -> {ok}
    end;
handle(17004, {}, _) -> {ok};

handle(17008, {Page}, #role{}) when Page =< 0 -> {ok};
handle(17008, {Page}, #role{}) ->
    case sys_env:get(cross_king_rank_king_1) of
        {AllPage, RankList} when is_list(RankList) ->
            case lists:keyfind(Page, 1, RankList) of
                false -> 
                    case center:call(cross_king_rank, get_rank, [1, Page]) of
                        {NewAllPage, NewPage, Get} ->
                            NewRanklist = [{NewPage, Get} | RankList],
                            sys_env:set(cross_king_rank_king_1, {NewAllPage, NewRanklist}),
                            {reply, {NewPage, NewAllPage, Get}};
                        _ ->
                            {reply, {0, 0, []}}
                    end;
                {_, GetRole} ->
                    {reply, {Page, AllPage, GetRole}}
            end;
        _ ->
            case center:call(cross_king_rank, get_rank, [1, Page]) of
                {NewAllPage, NewPage, Get} ->
                    NewRanklist = [{NewPage, Get}],
                    sys_env:set(cross_king_rank_king_1, {NewAllPage, NewRanklist}), 
                    {reply, {NewPage, NewAllPage, Get}};
                _ ->
                    {reply, {0, 0, []}}
            end
    end;

handle(17009, {Page}, #role{}) when Page =< 0 -> {ok};
handle(17009, {Page}, #role{}) ->
    case sys_env:get(cross_king_rank_king_2) of
        {AllPage, RankList} when is_list(RankList) ->
            case lists:keyfind(Page, 1, RankList) of
                false -> 
                    case center:call(cross_king_rank, get_rank, [0, Page]) of
                        {NewAllPage, NewPage, Get} ->
                            NewRanklist = [{NewPage, Get} | RankList],
                            sys_env:set(cross_king_rank_king_2, {NewAllPage, NewRanklist}),
                            {reply, {NewPage, NewAllPage, Get}};
                        _ ->
                            {reply, {0, 0, []}}
                    end;
                {_, GetRole} ->
                    {reply, {Page, AllPage, GetRole}}
            end;
        _ ->
            case center:call(cross_king_rank, get_rank, [0, Page]) of
                {NewAllPage, NewPage, Get} ->
                    NewRanklist = [{NewPage, Get}],
                    sys_env:set(cross_king_rank_king_2, {NewAllPage, NewRanklist}),
                    {reply, {NewPage, NewAllPage, Get}};
                _ ->
                    {reply, {0, 0, []}}
            end
    end;

handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.

%% -------------------
allow(cross_king_sign) ->
    case sys_env:get(srv_open_time) of
        T when is_integer(T) ->
            Openday = util:unixtime({today, T}),
            case Openday + 6 * 86400 < util:unixtime() of
                true ->
                    do_check(cross_king_sign, 5);
                false ->
                    {false, ?L(<<"开服7天后,才可以报名至尊王者赛">>)}
            end;
        _ ->
            {false, ?L(<<"开服7天后,才可以报名至尊王者赛">>)}
    end.

do_check(Type, N) ->
    case get(Type) of
        T when is_integer(T) ->
            case util:unixtime() - T > N of
                true ->
                    put(Type, util:unixtime()),
                    true;
                false -> false
            end;
        _ ->
            put(Type, util:unixtime()),
            true
    end.
