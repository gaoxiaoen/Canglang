%% --------------------------------------------------------------------
%% 特殊npc处理： 如主城的荣耀npc, 镇妖塔里的霸主npc
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------

-module(npc_special).

-export([
            role_enter_map/3
            ,sync_npc/1
            ,update_npc/1
            ,update_npc/2
            ,get_special_npc/1
            ,convert_to_msg/1
            ,time_update_honour_npc/0
            ,role_login/2
        ]).

-include("common.hrl").
-include("role.hrl").
-include("npc.hrl").
%%

-define(special_npc_name(P), 
        case P of 
            ?career_feiyu -> ?special_npc_feiyu;
            ?career_zhenwu -> ?special_npc_zhenwu;
            ?career_xianzhe -> ?special_npc_xianzhe;
            ?career_cike -> ?special_npc_cike;
            ?career_qishi -> ?special_npc_qishi
        end
        ).

-define(career(P), 
    case P of 
            ?career_feiyu -> ?L(<<"飞羽">>);
            ?career_zhenwu -> ?L(<<"真武">>);
            ?career_xianzhe -> ?L(<<"天师">>);
            ?career_cike -> ?L(<<"魅影">>);
            ?career_qishi -> ?L(<<"天尊">>);
            _ -> ?L(<<"飞羽">>)
    end
    ).

-define(rank_daren_coin, 72).      %% 金币达人榜
-define(rank_daren_casino, 73).    %% 寻宝达人榜
-define(rank_daren_exp, 74).       %% 练级达人榜
-define(rank_daren_attainment, 75).%% 阅历达人榜

-define(special_npc_honour_1, [
        #npc_special{npc_base_id = 11021, type = ?npc_special_honour, behaviour = ?career_zhenwu, data = []}
        ,#npc_special{npc_base_id = 11023, type = ?npc_special_honour, behaviour = ?career_feiyu, data = []}
        ,#npc_special{npc_base_id = 11022, type = ?npc_special_honour, behaviour = ?career_xianzhe, data = []}
        ,#npc_special{npc_base_id = 11024, type = ?npc_special_honour, behaviour = ?career_cike, data = []}
        ,#npc_special{npc_base_id = 11025, type = ?npc_special_honour, behaviour = ?career_qishi, data = []}
    ]).
-define(special_npc_honour_2, [
        #npc_special{npc_base_id = 11218, type = ?npc_special_honour, behaviour = ?rank_daren_exp, data = []}
        ,#npc_special{npc_base_id = 11219, type = ?npc_special_honour, behaviour = ?rank_daren_coin, data = []}
        ,#npc_special{npc_base_id = 11220, type = ?npc_special_honour, behaviour = ?rank_daren_casino, data = []}
        ,#npc_special{npc_base_id = 11221, type = ?npc_special_honour, behaviour = ?rank_daren_attainment, data = []}
    ]).

-define(special_npc_honour_3, [
        #npc_special{npc_base_id = 10100, type = ?npc_special_honour, behaviour = ?rank_daren_exp, data = []}
    ]).

-define(special_npc_honour_4, [
        #npc_special{npc_base_id = 10106, type = ?npc_special_honour, behaviour = ?rank_daren_exp, data = []}
    ]).
-define(special_npc_honour_5, [
        #npc_special{npc_base_id = 10108, type = ?npc_special_honour, behaviour = ?rank_daren_exp, data = []}
    ]).

%% for test debug
%%-define(debug_log(P), ?DEBUG("type=~w, value=~w ", P)).
-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% api functions
%% --------------------------------------------------------------------

%% 用户进入地图，推送 特殊npc的特效
role_enter_map(ConnPid, NpcBaseIds, Snpcs) ->
    ?debug_log([role_enter_map, {NpcBaseIds, Snpcs}]),
    CastNpcs = [S || S = #npc_special{npc_base_id = NbaseId} <- Snpcs, lists:member(NbaseId, NpcBaseIds) =:= true],
    push_specail_npc(ConnPid, CastNpcs).

%% 用户登录检测，师门弟子发系统传闻
role_login(Rid = {RoleId, SrvId}, Snpcs) ->
    Snpcs2 = [Ns || Ns = #npc_special{behaviour = Beh} <- Snpcs, Beh =:= ?career_feiyu orelse Beh =:= ?career_cike orelse Beh =:= ?career_xianzhe orelse Beh =:= ?career_qishi orelse Beh =:= ?career_zhenwu],
    case [{Name, Career} || #npc_special{type = ?npc_special_honour, data = {Srid, Name, _, Career, _}} <- Snpcs2, Srid =:= Rid] of
        [{N, C}] ->
            notice:send(53, util:fbin(?L(<<"洛水城上空风起云涌，阵阵威压袭来，原来是~s首席弟子-{role, ~w, ~s, ~s, #3ad6f0}，破空而来，器宇不凡!">>), [?career(C), RoleId, SrvId, N]));
        _ ->
            ok
    end;
role_login(_, _) ->
    ok.

%% 同步玩家的装备到npc
sync_npc(Snpcs) ->
    NewSnpcs = do_sync_npc(Snpcs, []),
    cast_special_npc(NewSnpcs),
    NewSnpcs.

%% 根据战斗力排行榜 更新荣耀npc
%% MaxPowers = [{integer, rid()}...]
update_npc(MaxPowers) ->
    ?debug_log([update_npc, {}]),
    Snpcs = get_special_npc(1),
    NewSnpcs = do_update_npc(Snpcs, MaxPowers, []),
    rank_reward:first_power_honor(NewSnpcs),
    cast_special_npc(NewSnpcs),
    notice_special_npc(NewSnpcs),
    NewSnpcs.

update_npc(rank, Ranks) ->
    Snpcs = get_special_npc(2),
    NewSnpcs = do_update_npc(Snpcs, Ranks, []),
    cast_special_npc(NewSnpcs),
    notice_rank_special(NewSnpcs),
    NewSnpcs.

%% 获取npc_special 数据
get_special_npc(1) ->
    do_get_special_npc(?special_npc_honour_1, []);
get_special_npc(2) ->
    do_get_special_npc(?special_npc_honour_2, []);
get_special_npc(3) ->
    do_get_special_npc(?special_npc_honour_3, []);
get_special_npc(4) ->
    do_get_special_npc(?special_npc_honour_4, []);
get_special_npc(5) ->
    do_get_special_npc(?special_npc_honour_5, []).

%% 把npc特效转换为消息
convert_to_msg(Snpcs) ->
    convert_to_msg(Snpcs, []).

convert_to_msg([], Back) ->
    Back;
convert_to_msg(_Snpcs = [H | T], Back) ->
    case do_convert_to_msg(H) of
        false ->
            convert_to_msg(T, Back);
        Other ->
            convert_to_msg(T, [Other | Back])
    end.

%% 开服后获取最近的 12:00 距离now()的时间
time_update_honour_npc() ->
    Now = util:unixtime(),
    case util:datetime_to_seconds({erlang:date(),{18, 0, 0}}) of
        false ->
            ?ELOG("datetime_to_seconds error"),
            util:unixtime();
        T12 ->
            case Now > T12 of
                true ->
                    60000 * 60 * 24 - (Now - T12) * 1000;
                _ ->
                    (T12 - Now) * 1000
            end
    end.

%% --------------------------------------------------------------------
%% 内部函数
%% --------------------------------------------------------------------

%% 更新npc
do_update_npc([], _MaxPowers, Back) ->
    ?debug_log([do_update_npc, Back]),
    Back;
do_update_npc(_Snpcs = [H | T], MaxPowers, Back) ->
    Data = get_update_data(H, MaxPowers),
    NewS = H#npc_special{data = Data},
    do_save_special_npc(NewS),
    do_update_npc(T, MaxPowers, [NewS | Back]).

%% 获取更新数据
get_update_data(#npc_special{type = ?npc_special_honour, npc_base_id = 10100}, Data) ->
    Data; %% 神药阁主数据在中央服进程获得吧
get_update_data(#npc_special{type = ?npc_special_honour, npc_base_id = 10106}, Data) ->
    Data; %% 仙宠阁主和神药阁一样
get_update_data(#npc_special{type = ?npc_special_honour, npc_base_id = 10108}, Data) ->
    Data; %% 珍宝阁主和神药阁一样
get_update_data(#npc_special{type = ?npc_special_honour, behaviour = Behaviour, data = Data}, MaxPowers) ->
    case lists:keyfind(Behaviour, 1, MaxPowers) of
        false ->
            Data;
        {_, Rid} ->
            Flag = lists:member(Behaviour, [?career_zhenwu, ?career_feiyu, ?career_cike, ?career_xianzhe, ?career_qishi]),
            case get_role(Rid) of 
                {ok, _Role = #role{id = Rid, name = Name, sex = Sex, career = Career, looks = Looks}} when (Career =:= Behaviour) orelse Flag =:= false ->
                    {Rid, Name, Sex, Career, Looks};
                {ok, #role{id = Rid, name = Name, sex = Sex}} ->
                    {Rid, Name, Sex, Behaviour, []};
                _ ->
                    Data
            end
    end;

get_update_data(#npc_special{data = Data}, _MaxPowers) ->
    Data.

%% 同步npc特效
do_sync_npc([], Back) ->
    ?debug_log([do_sync_npc, Back]),
    Back;
do_sync_npc(_Snpcs = [H | T], Back) ->
    Data = get_sync_data(H),
    do_sync_npc(T, [H#npc_special{data = Data} | Back]).

%% 获取同步数据
get_sync_data(#npc_special{type = ?npc_special_honour, behaviour = Behaviour, data = Data}) ->
    case Data of 
        {Rid, _, _, _, _} ->
            case get_role(Rid) of
                {ok, #role{name = Name, sex = Sex, career = Career, looks = Looks}} when Behaviour =:= Career ->
                    {Rid, Name, Sex, Career, Looks};
                _ ->
                    Data
            end;
        _ ->
            Data
    end;
            
get_sync_data(#npc_special{data = Data}) ->
    Data.

get_role(Rid) ->
    case role_api:lookup(by_id, Rid) of 
        {ok, _, Role} ->
            {ok, Role};
        _ ->
            case role_data:fetch_role(by_id, Rid) of
                {ok, Role} ->
                    {ok, setting:dress_login_init(Role)};
                _ ->
                    false
            end
    end.

%% 预处理
do_get_special_npc([], Back) ->
    Back;

do_get_special_npc([H = #npc_special{npc_base_id = NbaseId} | T], Back) ->
    Data = do_load_special_npc(NbaseId),
    do_get_special_npc(T, [H#npc_special{data = Data} | Back]);

do_get_special_npc([H | T], Back) ->
    do_get_special_npc(T, [H | Back]).

%% 推送特效npc
push_specail_npc(_ConnPid, []) ->
    ok;
push_specail_npc(ConnPid, Snpcs) ->
    push_specail_npc(ConnPid, Snpcs, []).

push_specail_npc(_ConnPid, [], []) ->
    ok;
push_specail_npc(ConnPid, [], Back) ->
    ?debug_log([push_special_npc, Back]),
    sys_conn:pack_send(ConnPid, 10124, {Back});

push_specail_npc(ConnPid, _Snpcs = [H | T], Back) ->
    case do_convert_to_msg(H) of
        false ->
            push_specail_npc(ConnPid, T, Back);
        Other ->
            push_specail_npc(ConnPid, T, [Other | Back])
    end.

%% 转换特效npc为协议消息
do_convert_to_msg(Snpc = #npc_special{type = ?npc_special_honour}) ->
    #npc_special{npc_base_id = NpcBaseId, data = Data} = Snpc,
    case Data of 
        {_Rid, Name, Sex, Career, Looks} ->
            {NpcBaseId, Name, Sex, Career, Looks};
        _ ->
            false
    end;
do_convert_to_msg(_) ->
    false.

%% 广播npc特效
cast_special_npc(Snpcs) ->
    N = [Sn || Sn = #npc_special{type = ?npc_special_honour} <- Snpcs],
    map:cast_special_npc(10003, convert_to_msg(N)).

%% 发世界公告
notice_special_npc(Snpcs) ->
    Notices = do_convert_to_notice(Snpcs, []),
    case length(Notices) of
        X when X > 0 ->
            erlang:send_after(10000, self(), {send_notice, Notices});
        _ ->
            ok
    end.

%% 发世界公告
notice_rank_special(Snpcs) ->
    Notices = do_rank_convert(Snpcs, []),
    case length(Notices) of
        X when X > 0 ->
            erlang:send_after(10000, self(), {send_notice2, Notices});
        _ ->
            ok
    end.

do_rank_convert([], Back) ->
    Back;

do_rank_convert([#npc_special{type = ?npc_special_honour, behaviour = Behaviour, data = Data} | T], Back) ->
    case Data of 
        {Rid, Name, _, _, _} ->
            {RoleId, SrvId} = Rid,
            case Behaviour of
                ?rank_daren_coin ->
                    Msg = util:fbin(?L(<<"恭喜{role, ~w, ~s, ~s, #3ad6f0}今日拿下一掷千金榜首，获得一掷千金的称号">>), [RoleId, SrvId, Name]),
                    do_rank_convert(T, [Msg | Back]);
                ?rank_daren_casino ->
                    Msg = util:fbin(?L(<<"恭喜{role, ~w, ~s, ~s, #3ad6f0}今日拿下寻宝达人榜首，获得寻宝达人的称号">>), [RoleId, SrvId, Name]),
                    do_rank_convert(T, [Msg | Back]);
                ?rank_daren_exp -> 
                    Msg = util:fbin(?L(<<"恭喜{role, ~w, ~s, ~s, #3ad6f0}今日拿下练级狂人榜首，获得练级狂人的称号">>), [RoleId, SrvId, Name]),
                    do_rank_convert(T, [Msg | Back]);
                ?rank_daren_attainment ->
                    Msg = util:fbin(?L(<<"恭喜{role, ~w, ~s, ~s, #3ad6f0}今日拿下阅历无双榜首，获得阅历无双的称号">>), [RoleId, SrvId, Name]),
                    do_rank_convert(T, [Msg | Back]);
                _ ->
                    do_rank_convert(T, Back)
            end;
        _ ->
            do_rank_convert(T, Back)
    end;

do_rank_convert([_ | T], Back) ->
    do_rank_convert(T, Back).


do_convert_to_notice([], Back) ->
    Back;

do_convert_to_notice([#npc_special{type = ?npc_special_honour, behaviour = Behaviour, data = Data} | T], Back) ->
    case Data of 
        {Rid, Name, _, _Career, _} ->
            {RoleId, SvrId} = Rid,
            Msg = util:fbin(?L(<<"{role, ~w, ~s, ~s, #3ad6f0}修行刻苦，战力惊人，在~s一脉中技压众人，获得~s首席弟子之称号，实至名归。">>), [RoleId, SvrId, Name, ?career(Behaviour), ?career(Behaviour)]),
            do_convert_to_notice(T, [Msg | Back]);
        _ ->
            do_convert_to_notice(T, Back)
    end;

do_convert_to_notice([_ | T], Back) ->
    do_convert_to_notice(T, Back).

do_save_special_npc(#npc_special{npc_base_id = NbaseId, type = Type, behaviour = Behaviour, data = Data}) ->
    SqlSelect = "select * from sys_special_npc where npc_base_id = ~s",
    case db:get_row(SqlSelect, [NbaseId]) of
        {error, _R} ->
            InsertSql = "insert into sys_special_npc (npc_base_id, type, behaviour, data, srv_id) values (~s, ~s, ~s, ~s, ~s)",
            db:execute(InsertSql, [NbaseId, Type, Behaviour, util:term_to_bitstring(Data), "none"]);
        {ok, _R2} ->
            UpdateSql = "update sys_special_npc set type = ~s, behaviour = ~s, data = ~s where npc_base_id = ~s",
            db:execute(UpdateSql, [Type, Behaviour, util:term_to_bitstring(Data), NbaseId])
    end.

do_load_special_npc(NbaseId) ->
    Sql = "select data from sys_special_npc where npc_base_id = ~s limit 1",
    case db:get_row(Sql, [NbaseId]) of
        {ok, [Data]} ->
            case util:bitstring_to_term(Data) of 
                {ok, Term} ->
                    Term;
                _ ->
                    []
            end;
        _Other ->
            []
    end.


