%% --------------------------------------------------------------------
%% 跨服boss战协议处理
%% @author wpf (wprehard@qq.com)
%% @end
%% --------------------------------------------------------------------
-module(cross_boss_rpc).
-export([handle/3]).

-include("common.hrl").
-include("boss.hrl").

%% 获取状态
handle(16801, {}, _Role) ->
    case sys_env:get(srv_open_time) of
        T when is_integer(T) ->
            case T + 7 * 86400 < util:unixtime() of
                true ->
                    {StatusId, Time} = cross_boss:get_status(),
                    {reply, {StatusId, Time}};
                false -> {ok}
            end;
        _ -> {ok}
    end;

%% 获取跨服boss冠军
handle(16802, {}, _Role) ->
    Msg = case center:call(cross_boss_rank, get_champion, []) of
        #cross_boss_rank{boss_id = BossId, round = Round, roles = Roles} ->
            {BossId, Round, [{Rid, SrvId, Name, Sex, Guild, Lev, Career, Vip, Fight, Looks} || #cross_boss_role{id = {Rid, SrvId}, name = Name, sex = Sex, guild_name = Guild, lev = Lev, career = Career, vip_type = Vip, fight = Fight, looks = Looks} <- Roles]};
        _ -> {0, 0, []}
    end,
    {reply, Msg};

%% 获取跨服排行榜
handle(16803, {PageSize, Page}, _) when Page < 0 orelse PageSize =< 0 -> {ok};
handle(16803, {PageSize, Page}, _) ->
    %% 支持分页
    Nth = Page * PageSize + 1,
    Ntail = (Page + 1) * PageSize,
    Msg = case center:call(cross_boss_rank, get_rank, [Nth, Ntail]) of
        L when is_list(L) ->
            pack_msg(Nth, L, []);
        _ -> []
    end,
    {reply, {?DEF_RANK_PAGES, Page, Msg}};

%% 剩余次数
handle(16804, {}, Role) ->
    Cnt = cross_boss:get_enter_count(Role),
    {reply, {Cnt, ?DEF_C_BOSS_COUNT}};

%% 购买次数
handle(16805, {_Cnt}, _Role) ->
    {ok};

%% 进入准备区
handle(16806, {}, Role) ->
    case sys_env:get(srv_open_time) of
        T when is_integer(T) ->
            case T + 7 * 86400 < util:unixtime() of
                true ->
                    case cross_boss:role_enter(Role) of
                        {false, Msg} -> {reply, {?false, Msg}};
                        _ ->
                            {ok, role_listener:special_event(Role, {30026, 1})}
                    end;
                false ->
                    {reply, {?false, ?L(<<"天位之战在开服七天之后的周六、日10:00-12：00、14:00-16:00开启，52级8000战斗力以上的玩家可以参加！">>)}}
            end;
        _ -> {ok}
    end;

%% 退出准备区
handle(16807, {}, Role) ->
    case cross_boss:role_leave(Role) of
        {false, Msg} -> {reply, {?false, Msg}};
        _ ->
            {ok}
    end;

%% 容错
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% --------------------------------------
%% internal functions
%% --------------------------------------

pack_msg(_Nth, [], L) -> lists:reverse(L);
pack_msg(Nth, [#cross_boss_rank{boss_id = BossId, round = Round, roles = Roles} | T], L) ->
    Msg = {Nth, BossId, Round, [{Rid, SrvId, Name, Sex, Guild, Lev, Career, Vip, Fight} || #cross_boss_role{id = {Rid, SrvId}, name = Name, sex = Sex, guild_name = Guild, lev = Lev, career = Career, vip_type = Vip, fight = Fight} <- Roles]},
    pack_msg(Nth+1, T, [Msg | L]);
pack_msg(Nth, [_ | T], L) ->
    pack_msg(Nth, T, L).
