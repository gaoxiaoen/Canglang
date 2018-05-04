%%----------------------------------------------------
%% 仙道会勋章相关处理
%% @author wpf0208@jieyou.cn
%% @end
%%----------------------------------------------------

-module(world_compete_medal).
-export([
        calc/1
        ,recalc_medal/2
        ,get_world_compete_data/1
        ,get_other_world_compete_data/1
        ,get_other_world_compete_data/2
        ,get_mark/1
        ,get_wc_lev_by_win_cnt/1
        ,calc_lev/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("attr.hrl").
-include("link.hrl").
-include("world_compete.hrl").

%% @spec calc(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 计算仙道勋章的属性
calc(Role = #role{assets = #assets{wc_lev = 0}}) -> Role;
calc(Role = #role{assets = #assets{wc_lev = WcLev}}) ->
    Attr = world_compete_medal_data:get_attr(WcLev),
    case role_attr:do_attr(Attr, Role) of
        {false, _} ->
            Role;
        {ok, NewRole} ->
            NewRole
    end.

%% @spec recalc_medal(Role, Mark) -> {ok} | {ok, NewRole}
%% Mark = #world_compete_mark{}
%% @doc 本地重载玩家的仙道勋章等级
recalc_medal(Role = #role{assets = Assets = #assets{wc_lev = WcLev}, link = #link{conn_pid = ConnPid}, attr = #attr{fight_capacity = Power}},
    M = #world_compete_mark{win_count = WinCnt, combat_count = ComCnt, loss_count = LossCnt, ko_perfect_count = KoPerCnt, win_rate = WinRate, continuous_win_count = CWinCnt, gain_lilian = Lilian, win_top_power = WinTopPower, section_mark = SectionMark, section_lev = SectionLev}) ->
    NewWcLev = calc_lev(WcLev, WinCnt),
    rank:listener(world_compete, Role, M),
    Group = world_compete_mgr:power_to_world_compete_group(Power),
    SectionMarkNext = case c_world_compete_section_data:get(SectionLev+1) of
        #world_compete_section_data{mark = UpgradeMark} -> UpgradeMark;
        undefined ->
            MaxSectionData = c_world_compete_section_data:get(c_world_compete_section_data:max_lev()),
            MaxSectionData#world_compete_section_data.mark
    end,
    case NewWcLev > WcLev of
        true ->
            sys_conn:pack_send(ConnPid, 16010, {NewWcLev, ComCnt, WinCnt, LossCnt, KoPerCnt, WinRate, CWinCnt, Lilian, Group, WinTopPower, SectionLev, round(SectionMark), SectionMarkNext, 0, 0, ?false}),
            {ok, role_api:push_attr(Role#role{assets = Assets#assets{wc_lev = NewWcLev}})};
        false ->
            sys_conn:pack_send(ConnPid, 16010, {WcLev, ComCnt, WinCnt, LossCnt, KoPerCnt, WinRate, CWinCnt, Lilian, Group, WinTopPower, SectionLev, round(SectionMark), SectionMarkNext, 0, 0, ?false}),
            {ok} 
    end;
recalc_medal(_, _) -> {ok}.

%% @spec get_world_compete_data(Role) -> {ok, Msg, NewRole} | any()
%% Role = #role{} | {Rid, SrvId}
%% @doc 向中央服请求当前玩家的仙道战绩数据
get_world_compete_data(Role = #role{id = RoleId, assets = Assets = #assets{wc_lev = WcLev}, attr = #attr{fight_capacity = Power}}) ->
    case center:call(world_compete_medal, get_mark, [RoleId]) of
        #world_compete_mark{combat_count = ComCnt, win_count = WinCnt, loss_count = LossCnt, ko_perfect_count = KoPerCnt, win_rate = WinRate, continuous_win_count = CWinCnt, gain_lilian = Lilian, win_top_power = WinTopPower, section_lev = SectionLev, section_mark = SectionMark} ->
            CWinCnt1 = case CWinCnt > 0 of
                true -> CWinCnt;
                false -> 0
            end,
            NewWcLev = calc_lev(WcLev, WinCnt),
            Group = world_compete_mgr:power_to_world_compete_group(Power),
            SectionMarkNext = case c_world_compete_section_data:get(SectionLev+1) of
                #world_compete_section_data{mark = UpgradeMark} -> UpgradeMark;
                undefined ->
                    MaxSectionData = c_world_compete_section_data:get(c_world_compete_section_data:max_lev()),
                    MaxSectionData#world_compete_section_data.mark
            end,
            {DayLilian, DayAttainment, CanDrawDayRewards} = world_compete_mgr:get_day_section_reward_info(RoleId),
            case NewWcLev > WcLev of
                true ->
                    NewRole = role_api:push_attr(Role#role{assets = Assets#assets{wc_lev = NewWcLev}}),
                    {ok, {NewWcLev, ComCnt, WinCnt, LossCnt, KoPerCnt, WinRate, CWinCnt1, Lilian, Group, WinTopPower, SectionLev, round(SectionMark), SectionMarkNext, DayLilian, DayAttainment, CanDrawDayRewards}, NewRole};
                false ->
                    {ok, {WcLev, ComCnt, WinCnt, LossCnt, KoPerCnt, WinRate, CWinCnt1, Lilian, Group, WinTopPower, SectionLev, round(SectionMark), SectionMarkNext, DayLilian, DayAttainment, CanDrawDayRewards}}
            end;
        _ -> {ok, {WcLev, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, ?false}}
    end.

%% @spec get_other_world_compete_data(RoleId) -> error | tuple()
%% @spec get_other_world_compete_data(WcLev, RoleId) -> error | tuple()
%% @doc 查看其他人的仙道战绩数据
get_other_world_compete_data(RoleId = {Id, SrvId}) ->
    case role_api:c_lookup(by_id, RoleId, #role.assets) of
        {ok, _, #assets{wc_lev = WcLev}} ->
            case center:call(world_compete_medal, get_mark, [RoleId]) of
                #world_compete_mark{combat_count = ComCnt, win_count = WinCnt, loss_count = LossCnt, ko_perfect_count = KoPerCnt, win_rate = WinRate, continuous_win_count = CWinCnt, gain_lilian = Lilian, role_power = RolePower, win_top_power = WinTopPower, section_lev = SectionLev, section_mark = SectionMark} ->
                    CWinCnt1 = case CWinCnt > 0 of
                        true -> CWinCnt;
                        false -> 0
                    end,
                    Group = world_compete_mgr:power_to_world_compete_group(RolePower),
                    SectionMarkNext = case c_world_compete_section_data:get(SectionLev+1) of
                        #world_compete_section_data{mark = UpgradeMark} -> UpgradeMark;
                        undefined ->
                            MaxSectionData = c_world_compete_section_data:get(c_world_compete_section_data:max_lev()),
                            MaxSectionData#world_compete_section_data.mark
                    end,
                    {Id, SrvId, WcLev, ComCnt, WinCnt, LossCnt, KoPerCnt, WinRate, CWinCnt1, Lilian, Group, WinTopPower, SectionLev, SectionMark, SectionMarkNext};
                _ -> error
            end;
        _ -> error
    end.
get_other_world_compete_data(WcLev, RoleId = {Id, SrvId}) ->
    case center:call(world_compete_medal, get_mark, [RoleId]) of
        #world_compete_mark{combat_count = ComCnt, win_count = WinCnt, loss_count = LossCnt, ko_perfect_count = KoPerCnt, win_rate = WinRate, continuous_win_count = CWinCnt, gain_lilian = Lilian, role_power = RolePower, win_top_power = WinTopPower, section_lev = SectionLev, section_mark = SectionMark} ->
            CWinCnt1 = case CWinCnt > 0 of
                true -> CWinCnt;
                false -> 0
            end,
            Group = world_compete_mgr:power_to_world_compete_group(RolePower),
            SectionMarkNext = case c_world_compete_section_data:get(SectionLev+1) of
                #world_compete_section_data{mark = UpgradeMark} -> UpgradeMark;
                undefined ->
                    MaxSectionData = c_world_compete_section_data:get(c_world_compete_section_data:max_lev()),
                    MaxSectionData#world_compete_section_data.mark
            end,
            {Id, SrvId, WcLev, ComCnt, WinCnt, LossCnt, KoPerCnt, WinRate, CWinCnt1, Lilian, Group, WinTopPower, SectionLev, SectionMark, SectionMarkNext};
        _ -> {Id, SrvId, WcLev, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0}
    end.

%% @spec get_world_compete_medal(RoleId) -> #world_compete_mark{}
%% @doc 中央服提取战绩数据
get_mark(RoleId) ->
    case ets:lookup(world_compete_marks, RoleId) of
        [Mark = #world_compete_mark{}] ->
            Mark;
        _ -> #world_compete_mark{}
    end.

%% 根据当前等级重新计算一次等级
calc_lev(WcLev, _WinCnt) when WcLev > 150 -> WcLev;
calc_lev(WcLev, WinCnt) ->
    NeedCnt = world_compete_medal_data:get_win_cnt(WcLev + 1),
    if
        WinCnt >= NeedCnt ->
            calc_lev(WcLev + 1, WinCnt);
        true ->
            WcLev 
    end.
%% TODO: 强制检测重计算等级怕会有问题，一旦中央服数据异常，玩家等级会丢失,升级这里需要加个日志
%%     case WinCnt < world_compete_medal_data:get_win_cnt(WcLev) of
%%         true -> %% 先判断当前等级是否
%%             calc_lev(0, WinCnt);
%%         false ->
%%             NeedCnt = world_compete_medal_data:get_win_cnt(WcLev + 1),
%%             if
%%                 WinCnt >= NeedCnt ->
%%                     calc_lev(WcLev + 1, WinCnt);
%%                 true ->
%%                     WcLev 
%%             end
%%     end.

%% @doc 根据次数推算等级
get_wc_lev_by_win_cnt(Cnt) ->
    do_match_medal(1, Cnt).
do_match_medal(N, Cnt) ->
    case world_compete_medal_data:get_win_cnt(N) of
        Cnt -> N;
        NeedCnt when Cnt > NeedCnt ->
            do_match_medal(N + 1, Cnt);
        _ -> N - 1
    end.
