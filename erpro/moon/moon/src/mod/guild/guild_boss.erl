%%----------------------------------------------------
%% @doc 帮会boss处理模块
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_boss).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
        adopt/2
        ,dismiss/1
        ,vip_upgrade/1
        ,feed/2
        ,play/2
        ,get_boss_list/1
        ,call_out/2
        ,combat_check/2
        ,combat_over/1
        ,get_current_status/2
        ,hit_boss/3
        ,apply_guild_area/1
        ,to_boss_side/1
        ,get_info/1
        ,adm_lev_up/3
        ,adm_clean/1
        ,adm_set_hp/3
        ,adm_feed/3
    ]).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("guild.hrl").
-include("npc.hrl").
-include("combat.hrl").
-include("mail.hrl").
-include("team.hrl").
-include("guild_boss.hrl").
%%

-define(guild_boss_feed_max_by_day, 100). %% 每个boss每天最多可喂养多少次
-define(guild_boss_play_addition, 10). %% 每次调戏增加多少心情
-define(guild_boss_feed_devote_base, 500). %% 需要有足够的帮贡才能喂养boss
-define(guild_boss_day_max_fight, 5). %% 需要有足够的帮贡才能喂养boss

-record(state, {
        roles = [] %% 个人列表
        ,boss_index = [] %% boss索引
        ,guilds = [] %% 帮派列表
    }).


%% @spec get_info(all) -> State
%% State = #state{}
%% @doc 获取进程状态
get_info(all) ->
    gen_server:call(?MODULE, get_all);

%% @spec get_info({kill_log, Gid}) -> Logs
%% Logs = list()
%% @doc 获取进程状态
get_info({kill_log, Gid}) ->
    gen_server:call(?MODULE, {kill_log, Gid}).

%% 角色战斗结束处理
combat_over(#combat{loser = Loser}) ->
    F = fun(Pid) ->
            role:pack_send(Pid, 17507, {}),
            role:apply(async, Pid, {fun apply_guild_area/2, [revive]})
    end,
    [F(Pid) || #fighter{pid = Pid, type = ?fighter_type_role, is_die = ?true} <- Loser],
    ok.

%% @spec adopt(guild, Role) -> Result
%% Role = record(role)
%% Result = atom() = not_in_guild 不在帮派 | no_permission 没有权限 | wrong_level 帮派等级不够
%% @doc 帮主或长老代领养boss
adopt(#role{guild = #role_guild{gid = 0}}, _) ->
    not_in_guild;
adopt(#role{guild = #role_guild{authority = Auth}}, _) when Auth =/= ?chief_op andalso Auth =/= ?elder_op ->
    no_permission;
adopt(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}, Type) when is_integer(Type) andalso Type > 0 andalso Type < 5 ->
    case guild_mgr:lookup(by_id, {Gid, SrvId}) of
        #guild{lev = Lev, name = GName} ->
            case get_adopt_condition(Type) of
                {BaseLv, _} when BaseLv > Lev ->
                    lev_lower;
                {_, GuildLoss} ->
                    gen_server:call(?MODULE, {adopt, {Gid, SrvId}, Type, GuildLoss, GName})
            end;
        _G ->
            ?DEBUG("无效的帮会数据 ~w", [_G]),
            wrong_guild
    end;

adopt(_Role, _Type) -> 
    false.

%% @spec dismiss(Gid) -> ok
%% Gid = {integer(), bitstring()}
%% @doc 解散帮派时要删掉对应的boss记录
dismiss(Gid) ->
    gen_server:cast(?MODULE, {dismiss, Gid}).

%% @spec vip_upgrade(Gid) -> ok
%% Gid = {integer(), bitstring()}
%% @doc 帮派升级为vip帮派时，boss要重现
vip_upgrade(Gid) ->
    gen_server:cast(?MODULE, {vip_upgrade, Gid}).

%% @spec feed(Role, Type) -> {ok, NewRole} | Else
%% Role = NewRole = #role{}
%% Type = integer()
%% Else = atom() 错误类型
%% @doc 喂养boss
feed(#role{guild = #role_guild{gid = 0}}, _) ->
    not_in_guild;
feed(#role{guild = #role_guild{devote = Devote}}, _) when Devote < ?guild_boss_feed_devote_base ->
    no_devote;
feed(Role = #role{pid = Pid, guild = #role_guild{gid = Gid, srv_id = SrvId}}, Type) ->
    case gen_server:call(?MODULE, {feed, convert_role(Role, to_role), {Gid, SrvId}, Type, Pid}) of
        [ok, Addition] ->
            case role_gain:do([#gain{label = exp, val = 5000}], Role) of
                {ok, NewRole} -> {ok, NewRole, Addition};
                _ -> {ok, Role, Addition}
            end;
        Else ->
            Else
    end.

%% @spec play(Role, Type) -> {ok, NewRole} | Else
%% Role = NewRole = #role{}
%% Type = integer()
%% Else = atom()
%% @doc 调戏boss
play(#role{guild = #role_guild{gid = 0}}, _) ->
    not_in_guild;
play(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}, Type) ->
    gen_server:call(?MODULE, {play, {Gid, SrvId}, Type}).

%% @spec combat_check(Role, NpcId) -> {ok} | {false, Reason}
%% Role = #role{}
%% NpcId = integer()
%% Reason = bitstring()
%% @doc 战前检查
combat_check(#role{guild = #role_guild{gid = 0}}, _) ->
    {false, ?L(<<"你还加入任何帮派，赶快加入一个吧">>)};
combat_check(Role = #role{name = Name, guild = #role_guild{gid = Gid, srv_id = SrvId}, team_pid = TeamPid}, NpcId) when is_pid(TeamPid) ->
    case team:get_team_info(TeamPid) of
        {ok, #team{member = Mems}} ->
            Rs = [convert_role(M, start_fight) || M = #team_member{mode = ?MODE_NORMAL} <- Mems],
            case gen_server:call(?MODULE, {combat_check, {Gid, SrvId}, NpcId, [convert_role(Role, start_fight) | Rs]}) of
                ok -> {ok};
                [max_fight, Name] -> {false, ?L(<<"你今天的挑战神兽次数已达5次上限">>)};
                [max_fight, OtherName] -> {false, util:fbin(?L(<<"队伍中的~s今天挑战神兽次数已经达到5次上限">>), [OtherName])};
                lev_lower -> {false, ?L(<<"当前神兽未成长到少年期，尚未长大哦。你忍心欺负它么？">>)};
                boss_dead -> {false, ?L(<<"神兽已经死亡">>)};
                no_boss -> {false, ?L(<<"没有指定类型的神兽">>)};
                no_called -> {false, ?L(<<"帮主还没决定击杀该神兽的时机，不能击杀">>)};
                no_adopted -> {false, ?L(<<"没有领养过神兽">>)}
            end;
        _R ->
            ?DEBUG("未知的队伍数据 ~w", [_R]),
            error
    end;
combat_check(Role = #role{guild = #role_guild{gid = Gid, srv_id = SrvId}}, NpcId) ->
    case gen_server:call(?MODULE, {combat_check, {Gid, SrvId}, NpcId, [convert_role(Role, start_fight)]}) of
        ok -> {ok};
        [max_fight, _] -> {false, ?L(<<"你今天的挑战神兽次数已达5次上限">>)};
        lev_lower -> {false, ?L(<<"当前神兽未成长到少年期，尚未长大哦。你忍心欺负它么？">>)};
        boss_dead -> {false, ?L(<<"神兽已经死亡">>)};
        no_called -> {false, ?L(<<"帮主还没决定击杀该神兽的时机，不能击杀">>)};
        no_boss -> {false, ?L(<<"没有指定类型的神兽">>)};
        no_adopted -> {false, ?L(<<"没有领养过神兽">>)}
    end.

%% @spec to_boss_side(Role) -> {ok} | {false, Reason}
%% Role = #role{}
%% @doc 传送到boss
to_boss_side(#role{event = Event}) when Event =/= ?event_no ->
    wrong_event;
to_boss_side(#role{guild = #role_guild{gid = 0}}) ->
    no_guild;
to_boss_side(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    in_team;
to_boss_side(#role{pid = Pid, guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    gen_server:call(?MODULE, {to_boss_side, Pid, {Gid, SrvId}}).

%% @spec call_out(Role, Type) -> {ok} | {false, Reason}
%% Role = #role{}
%% Type = integer()
%% Reason = bitstring()
%% @doc 召唤boss出来 
call_out(#role{guild = #role_guild{gid = 0}}, _) ->
    no_guild;
call_out(#role{guild = #role_guild{authority = Auth}}, _) when Auth =/= ?chief_op andalso Auth =/= ?elder_op ->
    no_permission;
call_out(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}, Type) ->
    gen_server:call(?MODULE, {call_out, {Gid, SrvId}, Type}).

%% @spec get_boss_list(Role) -> List
%% Role = #role{}
%% List = list()
%% 获取帮会boss列表
get_boss_list(#role{guild = #role_guild{gid = 0}}) ->
    {[]};
get_boss_list(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    {gen_server:call(?MODULE, {get_boss_list, {Gid, SrvId}})}.


%% @spec get_current_status(Role, NpcId) -> {ok, Hp}
%% Role = #role{}
%% NpcId = integer()
%% Hp = integer()
%% @doc 获取boss的当前血量
get_current_status(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}, NpcId) ->
    gen_server:call(?MODULE, {get_boss_status, {Gid, SrvId}, NpcId}).

%% @spec hit_boss(TotalDmg, RoleDmgList) -> ok
%% TotalDmg = integer()
%% RoleDmgList = [{#fighter{}, DmgHpTotal, DmgHpMax, DmgHpTotalByNpc}]
%% @doc 战斗结束记录boss伤害
hit_boss(NpcId, TotalDmg, RoleDmgList) ->
    NewRoleDmgList = [#guild_boss_role{id = {RoleId, SrvId}, name = Name, sex = Sex, lev = Lev, career = Career, total_dmg = DmgHpTotal, max_dmg = DmgHpMax} || {#fighter{rid = RoleId, srv_id = SrvId, sex = Sex, name = Name, career = Career, lev = Lev}, DmgHpTotal, DmgHpMax, _DmgHpTotalByNpc} <- RoleDmgList],
    gen_server:cast(?MODULE, {hit_boss, NpcId, TotalDmg, NewRoleDmgList}).

%% @spec adm_levup(Role, NpcId) -> {ok} | {false, Reason}
%% Role = #role{}
%% NpcId = integer()
%% Reason = bitstring()
%% @doc 召唤boss出来 
adm_lev_up(#role{guild = #role_guild{gid = 0}}, _, _) ->
    {false, ?L(<<"你还加入任何帮派，赶快加入一个吧">>)};
adm_lev_up(_, Type, Lev) when Lev > 3 orelse Lev < 0 orelse Type > 4 orelse Type < 1 ->
    wrong_arg;
adm_lev_up(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}, Type, Lev) ->
    gen_server:call(?MODULE, {lev_up, {Gid, SrvId}, Type, Lev}).

%% 清个人喂养记录
adm_clean(#role{id = Rid, guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    gen_server:cast(?MODULE, {adm_clean, Rid, {Gid, SrvId}});
adm_clean(_) ->
    ok.
%% gm命令喂养
adm_feed(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}, pid = Pid}, Type, Exp) ->
    gen_server:call(?MODULE, {adm_feed, Exp, {Gid, SrvId}, Type, Pid});
adm_feed(_, _, _) ->
    ok.
%% gm命令设血量
adm_set_hp(#role{guild = #role_guild{gid = Gid, srv_id = SrvId}}, Type, Hp) ->
    gen_server:call(?MODULE, {adm_set_hp, {Gid, SrvId}, Type, Hp});
adm_set_hp(_, _, _) ->
    ok.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("帮派boss正在启动..."),
    State = case guild_boss_dao:load_all() of
        [] -> #state{};
        List ->
            {Guilds, Index} = init_npcs(List, {[], []}),
            #state{guilds = Guilds, boss_index = Index}
    end,
    %% 设定一个每10秒一次的数据持久化处理
    erlang:send_after(10000, self(), sync_to_db),
    %% erlang:send_after(5000, self(), start_all_boss),
    erlang:send_after(3600000, self(), boss_chat),
    ?INFO("帮派boss启动完成"),
    {ok, State}.

%% 领养一个boss
handle_call({adopt, Gid, Type, GuildLoss, GName}, _From, State = #state{guilds = Guilds, boss_index = Index}) ->
    {Res, NewGuilds, NewIndex} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        %% 有领养记录要检查是否已经领养过同类
        G = #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(Type, #guild_boss_npc.type, Bosses) of
                false ->
                    case create_boss(Gid, Type) of
                        Boss = #guild_boss_npc{id = NpcId} ->
                            %% 由于帮会资金没有回滚的操作，扣除就先放这里面吧
                            case guild:guild_loss(Gid, GuildLoss) of
                                true ->
                                    NewG = G#guild_boss_guild{bosses = [Boss | Bosses]},
                                    guild_boss_dao:save_one(NewG),
                                    guild_boss_dao:sync_all(),
                                    {ok, lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, NewG), [{NpcId, Gid} | Index]};
                                _ ->
                                    npc_mgr:remove(NpcId),
                                    {no_fund, Guilds, Index}
                            end;
                        _ ->
                            {fail, Guilds, Index}
                    end;
                _ -> 
                    {type_exist, Guilds, Index}
            end;
        %% 创建一条记录
        _ ->
            case create_boss(Gid, Type) of
                Boss = #guild_boss_npc{id = NpcId} ->
                    case guild:guild_loss(Gid, GuildLoss) of
                        true ->
                            NewG = #guild_boss_guild{id = Gid, name = GName, bosses = [Boss]},
                            guild_boss_dao:save_one(NewG),
                            guild_boss_dao:sync_all(),
                            {ok, [NewG | Guilds], [{NpcId, Gid} | Index]};
                        _ ->
                            npc_mgr:remove(NpcId),
                            {no_fund, Guilds, Index}
                    end;
                _ ->
                    {fail, Guilds, Index}
            end
    end,
    {reply, Res, State#state{guilds = NewGuilds, boss_index = NewIndex}};

%% 喂养boss
handle_call({feed, R1 = #guild_boss_role{id = Id = {Rid, RSrvId}, name = RName}, Gid, Type, Pid}, _From, State = #state{guilds = Guilds, boss_index = Index}) ->
    {Res, NewGuilds, NewIndex} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(Type, #guild_boss_npc.type, Bosses) of
                %% 已经召唤出来的boss不能再喂
                #guild_boss_npc{can_fight = CanFight} when CanFight =/= 0 ->
                    {called, Guilds, Index};
                B = #guild_boss_npc{role_log = Roles, last_feed = BossLastFeed, today_feed = BossTodayFeed} ->
                    Now = util:unixtime(),
                    SameDay = util:is_same_day2(Now, BossLastFeed),
                    case lists:keyfind(Id, #guild_boss_role.id, Roles) of
                        _ when SameDay =:= true andalso BossTodayFeed >= ?guild_boss_feed_max_by_day ->
                            {max_feed, Guilds, Index};
                        R2 = #guild_boss_role{last_feed = LastFeed} ->
                            R3 = convert_role(R1, R2),
                            %% 同一天只能喂养一次
                            case util:is_same_day2(Now, LastFeed) of
                                true ->
                                    {feed_today, Guilds, Index};
                                _ ->
                                    NewRoles = lists:keyreplace(Id, #guild_boss_role.id, Roles, R3#guild_boss_role{last_feed = Now, today_feed = 1}),
                                    case update_boss(B, notice:role_to_msg({Rid, RSrvId, RName})) of
                                        {Addition, NewB = #guild_boss_npc{id = NewNpcId, type = Type, lev = Lev, exp = Exp}} ->
                                            NewBosses = lists:keyreplace(Type, #guild_boss_npc.type, Bosses, NewB#guild_boss_npc{role_log = NewRoles}),
                                            Index1 = case lists:keyfind(NewNpcId, 1, Index) of
                                                false -> [{NewNpcId, Gid} | Index];
                                                _ ->
                                                    lists:keyreplace(NewNpcId, 1, Index, {NewNpcId, Gid})
                                            end,
                                            guild_boss_rpc:push(Pid, 17504, {NewNpcId, Type, Exp, Lev}),
                                            NewG = G#guild_boss_guild{bosses = NewBosses},
                                            guild_boss_dao:save_one(NewG),
                                            {[ok, Addition], lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, NewG), Index1};
                                        Else ->
                                            {Else, Guilds, Index}
                                    end
                            end;
                        _ ->
                            NewRoles = [R1#guild_boss_role{last_feed = Now, today_feed = 1} | Roles],
                            case update_boss(B, notice:role_to_msg({Rid, RSrvId, RName})) of
                                {Addition, NewB = #guild_boss_npc{id = NewNpcId, type = Type, exp = Exp, lev = Lev}} ->
                                    NewBosses = lists:keyreplace(Type, #guild_boss_npc.type, Bosses, NewB#guild_boss_npc{role_log = NewRoles}),
                                    Index1 = case lists:keyfind(NewNpcId, 1, Index) of
                                        false -> [{NewNpcId, Gid} | Index];
                                        _ ->
                                            lists:keyreplace(NewNpcId, 1, Index, {NewNpcId, Gid})
                                    end,
                                    guild_boss_rpc:push(Pid, 17504, {NewNpcId, Type, Exp, Lev}),
                                    NewG = G#guild_boss_guild{bosses = NewBosses},
                                    guild_boss_dao:save_one(NewG),
                                    {[ok, Addition], lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, NewG), Index1};
                                Else ->
                                    {Else, Guilds, Index}
                            end
                    end;
                _ ->
                    {no_boss, Guilds, Index}
            end;
        _ ->
            {no_adopted, Guilds, Index}
    end,
    {reply, Res, State#state{guilds = NewGuilds, boss_index = NewIndex}};

%% gm命令喂养boss
handle_call({adm_feed, Exp, Gid, Type, Pid}, _From, State = #state{guilds = Guilds, boss_index = Index}) ->
    {Res, NewGuilds, NewIndex} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(Type, #guild_boss_npc.type, Bosses) of
                %% 已经召唤出来的boss不能再喂
                #guild_boss_npc{can_fight = CanFight} when CanFight =/= 0 ->
                    {called, Guilds, Index};
                B = #guild_boss_npc{id = NpcId, lev = Lev} ->
                    Now = util:unixtime(),
                    NewB = B#guild_boss_npc{exp = Exp, last_feed = Now},
                    NewBosses = lists:keyreplace(Type, #guild_boss_npc.type, Bosses, NewB),
                    guild_boss_rpc:push(Pid, 17504, {NpcId, Type, Exp, Lev}),
                    NewG = G#guild_boss_guild{bosses = NewBosses},
                    guild_boss_dao:save_one(NewG),
                    {[ok, Exp], lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, NewG), Index};
                _ ->
                    {no_boss, Guilds, Index}
            end;
        _ ->
            {no_adopted, Guilds, Index}
    end,
    {reply, Res, State#state{guilds = NewGuilds, boss_index = NewIndex}};

%% gm命令设血量
handle_call({adm_set_hp, Gid, Type, Hp}, _From, State = #state{guilds = Guilds, boss_index = Index}) ->
    {Res, NewGuilds, NewIndex} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(Type, #guild_boss_npc.type, Bosses) of
                B = #guild_boss_npc{} ->
                    NewB = B#guild_boss_npc{hp = Hp},
                    NewBosses = lists:keyreplace(Type, #guild_boss_npc.type, Bosses, NewB),
                    NewG = G#guild_boss_guild{bosses = NewBosses},
                    guild_boss_dao:save_one(NewG),
                    {ok, lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, NewG), Index};
                _ ->
                    {no_boss, Guilds, Index}
            end;
        _ ->
            {no_adopted, Guilds, Index}
    end,
    {reply, Res, State#state{guilds = NewGuilds, boss_index = NewIndex}};

%% 调戏boss
handle_call({play, Gid, Type}, _From, State = #state{guilds = Guilds}) ->
    {Res, NewGuilds} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(Type, #guild_boss_npc.type, Bosses) of
                B = #guild_boss_npc{mood = Mood} ->
                    NewBosses = lists:keyreplace(Type, #guild_boss_npc.type, Bosses, B#guild_boss_npc{mood = Mood + ?guild_boss_play_addition}),
                    {ok, lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, G#guild_boss_guild{bosses = NewBosses})};
                _ ->
                    {no_boss, Guilds}
            end;
        _ ->
            {no_adopted, Guilds}
    end,
    {reply, Res, State#state{guilds = NewGuilds}};

%% 战前检查
handle_call({combat_check, Gid, NpcId, Rs}, _From, State = #state{guilds = Guilds}) ->
    {Res, NewGuilds} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(NpcId, #guild_boss_npc.id, Bosses) of
                #guild_boss_npc{lev = 0} -> 
                    {lev_lower, Guilds};
                #guild_boss_npc{can_fight = 0} -> 
                    {no_called, Guilds};
                #guild_boss_npc{hp = 0} -> 
                    gen_server:cast(?MODULE, {hit_boss, NpcId, 0, []}),
                    {boss_dead, Guilds};
                B = #guild_boss_npc{role_log = Roles} -> 
                    case check_fighers(Rs, Roles) of
                        {ok, NewRoles} ->
                            NewBosses = lists:keyreplace(NpcId, #guild_boss_npc.id, Bosses, B#guild_boss_npc{role_log = NewRoles}),
                            {ok, lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, G#guild_boss_guild{bosses = NewBosses})};
                        Else ->
                            {Else, Guilds}
                    end;
                _ ->
                    {no_boss, Guilds}
            end;
        _ ->
            {no_adopted, Guilds}
    end,
    {reply, Res, State#state{guilds = NewGuilds}};

%% 把boss召唤出来
handle_call({call_out, Gid, Type}, _From, State = #state{guilds = Guilds}) ->
    {Res, NewGuilds} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(Type, #guild_boss_npc.type, Bosses) of
                #guild_boss_npc{lev = 0} -> 
                    {lev_lower, Guilds};
                #guild_boss_npc{can_fight = CanFight} when CanFight =/= 0 ->
                    {called, Guilds};
                B = #guild_boss_npc{} ->
                        NewB = B#guild_boss_npc{can_fight = 1},
                        NewBosses = lists:keyreplace(Type, #guild_boss_npc.type, Bosses, NewB),
                        guild:pack_send(Gid, 17505, {Type}),
                        guild:guild_chat(Gid, ?L(<<"帮会神兽已经被召唤出来，请大家速回帮会领地，共同挑战，共同获取神兽所携带的宝物。">>)),
                        {ok, lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, G#guild_boss_guild{bosses = NewBosses})};
                _ ->
                    {no_boss, Guilds}
            end;
        _ ->
            {no_adopted, Guilds}
    end,
    {reply, Res, State#state{guilds = NewGuilds}};

%% 尝试传送到boss身边
handle_call({to_boss_side, Pid, Gid}, _From, State = #state{guilds = Guilds}) ->
    Res = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        #guild_boss_guild{bosses = Bosses} ->
            case [B || B = #guild_boss_npc{id = Id} <- Bosses, Id =/= 0] of
                [] -> no_called;
                _ ->
                    role:apply(async, Pid, {fun apply_guild_area/1, []}),
                    ok
            end;
        _ ->
            no_adopted
    end,
    {reply, Res, State};

%% 设置boss等级
handle_call({lev_up, Gid, Type, Lev}, _From, State = #state{guilds = Guilds, boss_index = BossIndex}) ->
    {Res, NewGuilds, NewIndex} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(Type, #guild_boss_npc.type, Bosses) of
                B = #guild_boss_npc{id = Id} ->
                    NewB = B#guild_boss_npc{lev = Lev},
                    NewBosses = lists:keyreplace(Type, #guild_boss_npc.type, Bosses, NewB),
                    {ok, lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, G#guild_boss_guild{bosses = NewBosses}), [{Id, Gid} | BossIndex]};
                _ ->
                    {no_boss, Guilds, BossIndex}
            end;
        _ ->
            {no_adopted, Guilds, BossIndex}
    end,
    {reply, Res, State#state{guilds = NewGuilds, boss_index = NewIndex}};

%% 获取boss血量
handle_call({get_boss_status, Gid, NpcId}, _From, State = #state{guilds = Guilds}) ->
    Res = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        #guild_boss_guild{bosses = Bosses} ->
            case lists:keyfind(NpcId, #guild_boss_npc.id, Bosses) of
                #guild_boss_npc{hp = Hp} -> {ok, Hp};
                _ ->
                    no_boss
            end;
        _ ->
            no_adopted
    end,
    {reply, Res, State};

%% 获取boss列表
handle_call({get_boss_list, Gid}, _From, State = #state{guilds = Guilds}) ->
    Res = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        #guild_boss_guild{bosses = Bosses} -> [B || B = #guild_boss_npc{can_fight = 0} <- Bosses];
        _ -> []
    end,
    {reply, Res, State};

%% 获取上一场击杀boss的记录
handle_call({kill_log, Gid}, _From, State = #state{guilds = Guilds}) ->
    Res = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        #guild_boss_guild{kill_log = KillLog} -> [R || R = #guild_boss_role{total_dmg = TotalDmg} <- KillLog, TotalDmg > 0];
        _ -> []
    end,
    {reply, Res, State};

%% 获取全部信息
handle_call(get_all, _From, State) ->
    {reply, State, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% boss的伤害记录
handle_cast({hit_boss, NpcId, TotalDmg, RoleDmgList}, State = #state{boss_index = Index, guilds = Guilds}) ->
    NewGuilds = case lists:keyfind(NpcId, 1, Index) of
        {_, Gid} ->
            case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
                G = #guild_boss_guild{bosses = Bosses, kill_log = KillLog} ->
                    case lists:keyfind(NpcId, #guild_boss_npc.id, Bosses) of
                        B = #guild_boss_npc{hp = Hp, role_log = Roles, type = Type, lev = Lev} ->
                            NewRoles = update_role(fight, RoleDmgList, Roles),
                            %% boss已经挂了要特殊处理
                            {NewBosses, NewKillLog} = case max(0, Hp - TotalDmg) of
                                0 ->
                                    %% 如果已经没有人在打它了，就发奖励
                                    Now = util:unixtime(),
                                    case [FR || FR = #guild_boss_role{is_fighting = 1, last_fighted = RLastFight} <- NewRoles, Now - RLastFight < 3600] of
                                        [] ->
                                            npc_mgr:remove(NpcId),
                                            %% 帮会宝库和个人各一半
                                            reward_roles(B#guild_boss_npc{hp = 0, role_log = NewRoles}),
                                            RewardBase = [{ItemId, Bind, Num div 2} || {ItemId, Bind, Num} <- get_reward_base(Type, Lev)],
                                            guild_treasure:add(Gid, ?guild_treasure_guild_boss, RewardBase),
                                            guild:guild_chat(Gid, ?L(<<"帮会BOSS已经被降服，奖励已经发送到各位勇士的邮箱里。请查收。部分宝物已保存到帮会宝库，请帮主尽快分配">>)),
                                            {lists:keydelete(NpcId, #guild_boss_npc.id, Bosses), NewRoles};
                                        %% 这部分只是被强制结束战斗的
                                        _FRs when Hp =:= 0 ->
                                            {lists:keyreplace(NpcId, #guild_boss_npc.id, Bosses, B#guild_boss_npc{hp = 0, role_log = NewRoles}), KillLog};
                                        %% 最快击杀的那个人，要通知其他人结束战斗
                                        FRs ->
                                            F = fun(#guild_boss_role{id = FRid}) ->
                                                    case role_api:lookup(by_id, FRid, [#role.combat_pid]) of
                                                        {ok, _, [CombatPid]} when is_pid(CombatPid) ->
                                                            CombatPid ! stop;
                                                        _ -> ignore
                                                    end
                                            end,
                                            lists:foreach(F, FRs),
                                            {lists:keyreplace(NpcId, #guild_boss_npc.id, Bosses, B#guild_boss_npc{hp = 0, role_log = NewRoles}), KillLog}
                                    end;
                                %% 战斗结束，boss还活着
                                NewHp ->
                                    {lists:keyreplace(NpcId, #guild_boss_npc.id, Bosses, B#guild_boss_npc{hp = NewHp, role_log = NewRoles}), KillLog}
                            end,
                            %% 数据在最后保存
                            NewG = G#guild_boss_guild{bosses = NewBosses, kill_log = NewKillLog},
                            guild_boss_dao:save_one(NewG),
                            lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, NewG);
                        %% 没有对应boss数据
                        _ ->
                            Guilds
                    end;
                %% 没有boss领养记录
                _ ->
                    Guilds
            end;
        _ ->
            Guilds
    end,
    {noreply, State#state{guilds = NewGuilds}};
%% gm命令请喂养次数
handle_cast({adm_clean, Rid, Gid}, State = #state{guilds = Guilds}) ->
    NewGuilds = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            F = fun(B = #guild_boss_npc{role_log = Log}) ->
                    NewLog = case lists:keyfind(Rid, #guild_boss_role.id, Log) of
                        R = #guild_boss_role{} ->
                            lists:keyreplace(Rid, #guild_boss_role.id, Log, R#guild_boss_role{last_feed = 0});
                        _ -> Log
                    end,
                    B#guild_boss_npc{role_log = NewLog}
            end,
            lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, G#guild_boss_guild{bosses = [F(Bo) || Bo <- Bosses]});
        _ -> Guilds
    end,
    {noreply, State#state{guilds = NewGuilds}};
%% 帮派解散处理
handle_cast({dismiss, Gid}, State = #state{guilds = Guilds}) ->
    NewGuilds = lists:keydelete(Gid, #guild_boss_guild.id, Guilds),
    guild_boss_dao:delete_one(Gid),
    {noreply, State#state{guilds = NewGuilds}};

%% 帮派升级为vip时的处理
handle_cast({vip_upgrade, Gid}, State = #state{guilds = Guilds, boss_index = Index}) ->
    {NewGuilds, NewIndex} = case lists:keyfind(Gid, #guild_boss_guild.id, Guilds) of
        G = #guild_boss_guild{bosses = Bosses} ->
            F = fun(B, {Bs, Idx}) ->
                    case create_boss_npc(Gid, B) of
                        NewB = #guild_boss_npc{id = Id} ->
                            {[NewB | Bs], [{Id, Gid} | Idx]};
                        _ ->
                            {[B | Bs], Idx}
                    end
            end,
            {NewBosses, NewIdx} = lists:foldl(F, {[], Index}, Bosses),
            {lists:keyreplace(Gid, #guild_boss_guild.id, Guilds, G#guild_boss_guild{bosses = NewBosses}), NewIdx};
        _ ->
            {Guilds, Index}
    end,
    {noreply, State#state{guilds = NewGuilds, boss_index = NewIndex}};


handle_cast(_Msg, State) ->
    {noreply, State}.

%% 把缓冲区的数据保存到数据
handle_info(sync_to_db, State) ->
    guild_boss_dao:sync_all(),
    erlang:send_after(10000, self(), sync_to_db),
    {noreply, State};

%% 初始化所有boss形象
handle_info(start_all_boss, State = #state{guilds = Guilds, boss_index = Index}) ->
    {NewGuilds, NewIndex} = start_all_boss(Guilds, [], Index),
    {noreply, State#state{guilds = NewGuilds, boss_index = NewIndex}};

%% 帮会boss周期消息
handle_info(boss_chat, State = #state{guilds = Guilds}) ->
    [guild:guild_chat(Gid, ?L(<<"帮会神兽似乎慢慢的开始沉睡。请各位帮众前去供养，提供神兽成长的力量。神兽成长后，将有更大的力量携带更多的宝物。  {open, 42, 我要供养, ffe100}">>)) || #guild_boss_guild{id = Gid, bosses = Bosses} <- Guilds, [] =/= Bosses],
    erlang:send_after(3600000, self(), boss_chat),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    guild_boss_dao:sync_all(),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ---- 内部函数----
%% 检查战斗者是否符合要求
check_fighers([R1 = #guild_boss_role{id = Id, name = Name} | T], Roles) ->
    Now = util:unixtime(),
    case lists:keyfind(Id, #guild_boss_role.id, Roles) of
        R2 = #guild_boss_role{last_fighted = LastFight, today_fighted = TodayFighted} ->
            case util:is_same_day2(Now, LastFight) of
                true when TodayFighted >= ?guild_boss_day_max_fight ->
                    [max_fight, Name];
                true ->
                    check_fighers(T, lists:keyreplace(Id, #guild_boss_role.id, Roles, R2#guild_boss_role{is_fighting = 1, last_fighted = Now, today_fighted = TodayFighted + 1}));
                _ ->
                    check_fighers(T, lists:keyreplace(Id, #guild_boss_role.id, Roles, R2#guild_boss_role{is_fighting = 1, last_fighted = Now, today_fighted = 1}))
            end;
        _ ->
            check_fighers(T, [R1#guild_boss_role{is_fighting = 1, last_fighted = Now, today_fighted = 1} | Roles])
    end;
check_fighers(_, Roles) ->
    {ok, Roles}.

%% 创建一个boss
create_boss(Gid, Type) ->
    create_boss_npc(Gid, #guild_boss_npc{type = Type, gid = Gid}).

%% 创建boss的npc进程
create_boss_npc(Gid, B = #guild_boss_npc{type = Type, lev = Lev}) ->
    case get_npc_locate(Gid, Type, Lev) of
    {NpcBaseId, Hp, MapId, X, Y}  ->
        case npc_mgr:create(NpcBaseId, MapId, X, Y) of
            {ok, NpcId} -> 
                B#guild_boss_npc{id = NpcId, type = Type, gid = Gid, hp = Hp};
            _ -> 
                B
        end;
    _Else ->
        B
end.

get_npc_locate({Gid, Gsrvid}, Type, Lev) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{gvip = ?guild_piv, entrance = {MapId, _X, _Y}} ->
            case get_npc_base(Type, Lev) of
                {ok, #npc_base{id = BaseId, hp_max = Hp}} ->
                    {BaseId, Hp, MapId, 2400 + Type * 10, 1650 + Type * 10};
                _ ->
                    none
            end;
        #guild{entrance = {MapId, _X, _Y}} ->
            case get_npc_base(Type, Lev) of
                {ok, #npc_base{id = BaseId, hp_max = Hp}} ->
                    {BaseId, Hp, MapId, 2990 + Type * 10, 1790 + Type * 10};
                _ ->
                    none
            end;
        _ ->
            no_area
    end.

get_npc_base(1, 0) ->
    npc_data:get(25073);
get_npc_base(1, 1) ->
    npc_data:get(25073);
get_npc_base(1, 2) ->
    npc_data:get(25074);
get_npc_base(1, 3) ->
    npc_data:get(25075);
get_npc_base(2, 0) ->
    npc_data:get(25076);
get_npc_base(2, 1) ->
    npc_data:get(25076);
get_npc_base(2, 2) ->
    npc_data:get(25077);
get_npc_base(2, 3) ->
    npc_data:get(25078);
get_npc_base(3, 0) ->
    npc_data:get(25079);
get_npc_base(3, 1) ->
    npc_data:get(25079);
get_npc_base(3, 2) ->
    npc_data:get(25080);
get_npc_base(3, 3) ->
    npc_data:get(25081);
get_npc_base(4, 0) ->
    npc_data:get(25082);
get_npc_base(4, 1) ->
    npc_data:get(25082);
get_npc_base(4, 2) ->
    npc_data:get(25083);
get_npc_base(4, 3) ->
    npc_data:get(25084);
get_npc_base(_R, _) ->
    ?ERR("无效参数的帮会boss类型 ~w", [_R]),
    none.

%% 更新角色操作日志
%% 调戏记录
update_role(play, R1 = #guild_boss_role{id = Id}, Roles) ->
    Now = util:unixtime(),
    case lists:keyfind(Id, #guild_boss_role.id, Roles) of
        R2 = #guild_boss_role{last_played = LastPlayed, today_play = TodayPlay} ->
            R3 = convert_role(R1, R2),
            case util:is_same_day2(Now, LastPlayed) of
                true ->
                    lists:keyreplace(Id, #guild_boss_role.id, Roles, R3#guild_boss_role{last_played = Now, today_play = TodayPlay + 1});
                _ ->
                    lists:keyreplace(Id, #guild_boss_role.id, Roles, R3#guild_boss_role{last_played = Now, today_play = 1})
            end;
        _ ->
            [R1#guild_boss_role{last_played = Now, today_play = 1} | Roles]
    end;
%% 战斗记录有可能是组队
update_role(fight, [], Roles) ->
    Roles;
update_role(fight, [R1 = #guild_boss_role{id = Id = {Rid, RSrvId}, name = Name, lev = RLev, max_dmg = MaxDmg, total_dmg = TotalDmg} | T], Roles) ->
    Exp = round(math:pow(TotalDmg, 0.5) * 0.3 * math:pow(RLev, 1.5)),
    AssetInfo = [{?mail_exp, Exp}],
    mail_mgr:deliver({Rid, RSrvId, Name}, {?L(<<"参与击杀帮会神兽奖励">>), util:fbin(?L(<<"您本次挑战神兽，对神兽造成了~w伤害，\n折算成经验：~w \n 每天可挑战神兽5次，\n 神兽被击败后，身上的宝物会掉落。\n 对神兽造成的总伤害越高，获得宝物概率越大。">>), [TotalDmg, Exp]), AssetInfo, []}),
    case lists:keyfind(Id, #guild_boss_role.id, Roles) of
        R2 = #guild_boss_role{total_dmg = OldTotalDmg, max_dmg = OldMaxDmg} ->
            R3 = convert_role(R1, R2),
            NewRoles = lists:keyreplace(Id, #guild_boss_role.id, Roles, R3#guild_boss_role{is_fighting = 0, total_dmg = OldTotalDmg + TotalDmg, max_dmg = max(MaxDmg, OldMaxDmg)}),
            update_role(fight, T, NewRoles);
        _ ->
            update_role(fight, T, [R1#guild_boss_role{total_dmg = TotalDmg, max_dmg = MaxDmg} | Roles])
    end.

%% 转换数据
convert_role(#role{id = Id, name = Name, lev = Lev, career = Career, sex = Sex}, _) ->
    #guild_boss_role{id = Id, name = Name, lev = Lev, career = Career, sex = Sex};
convert_role(#team_member{id = Id, name = Name, lev = Lev, career = Career, sex = Sex}, _) ->
    #guild_boss_role{id = Id, name = Name, lev = Lev, career = Career, sex = Sex};
convert_role(#guild_boss_role{id = Id, name = Name, lev = Lev, career = Career, sex = Sex}, R = #guild_boss_role{}) ->
    R#guild_boss_role{id = Id, name = Name, lev = Lev, career = Career, sex = Sex}.

%% boss经验增加后相关处理
update_boss(#guild_boss_npc{lev = 3}, _) ->
    max_lev;
update_boss(B = #guild_boss_npc{id = Id, gid = Gid, type = Type, lev = Lev, exp = Exp, last_feed = LastFeed, today_feed = TodayFeed}, RName) ->
    %% 增加值随机区间
    {Addition, Msg} = case util:rand(1, 100) of
        R when R >= 95 -> {100, ?L(<<"鸿运当头，前途无量啊。~s诚心供养，神兽成长竟然一下增加了100点。神兽成长越高，掉落宝物越多。{open, 42, 我要供养, ffe100}">>)};
        R when R >= 85 -> {50, ?L(<<"福星高照，~s诚心供养，感动神兽，神兽心情大好，一下成长增加了50点。神兽成长越高，掉落宝物越多。{open, 42, 我要供养, ffe100}">>)};
        R when R >= 55 -> {20, ?L(<<"~s诚心供养，感动神兽，神兽心情大好，成长加快，一下成长增加了20点。神兽成长越高，掉落宝物越多。{open, 42, 我要供养, ffe100}">>)};
        R when R >= 5 -> {10, ?L(<<"~s诚心供养神兽，为神兽增加了10点成长。神兽成长越高，掉落宝物越多。{open, 42, 我要供养, ffe100}">>)};
        _ -> {1, ?L(<<"~s今天运气仿佛一般，喂养神兽，只增加了1点的神兽成长。一定是平时没怎么调戏神兽了。神兽成长越高，掉落宝物越多。{open, 42, 我要供养, ffe100}">>)}
    end,
    Now = util:unixtime(),
    NewTodayFeed = case util:is_same_day2(Now, LastFeed) of
        true -> TodayFeed + 1;
        _ -> 1
    end,
    guild:guild_chat(Gid, util:fbin(Msg, [RName])),
    case get_upgrade_exp(Type, Lev) of
        UpdateExp when UpdateExp > Addition + Exp ->
            {Addition, B#guild_boss_npc{exp = Addition + Exp, last_feed = Now, today_feed = NewTodayFeed}};
        _ when Id =:= 0 ->
            %% 升级了要发飙一下
            case Lev + 1 of
                1 -> guild:guild_chat(Gid, ?L(<<"经过全体帮众的诚心供养，神兽终于成长为少年期。神兽成长越高，身上所携带的宝物越多。通过挑战神兽，可得到神兽身上的宝物祝福。{open, 42, 继续供养, ffe100}">>));
                2 -> guild:guild_chat(Gid, ?L(<<"经过全体帮众的诚心供养，神兽终于成长为青年期。神兽成长越高，身上所携带的宝物越多。通过挑战神兽，可得到神兽身上的宝物祝福。{open, 42, 继续供养, ffe100}">>));
                3 -> guild:guild_chat(Gid, ?L(<<"经过全体帮众的诚心供养，神兽终于成长达到了最高，身上的宝物闪闪发光。帮主可选择挑战神兽，全体帮众一起击杀，获取神兽身上的宝物。{open, 42, 挑战神兽, ffe100}">>));
                _ -> ok
            end,
            {Addition, B#guild_boss_npc{exp = Addition + Exp, lev = Lev + 1, last_feed = Now, today_feed = NewTodayFeed}};
        %% 已经召唤出来的boss升级了要更改boss形象
        _ ->
            npc_mgr:remove(Id),
            NewB = B#guild_boss_npc{exp = Addition + Exp, lev = Lev + 1, last_feed = Now, today_feed = NewTodayFeed},
            %% 升级了要发飙一下
            case Lev + 1 of
                1 -> guild:guild_chat(Gid, ?L(<<"经过全体帮众的诚心供养，神兽终于成长为少年期。神兽成长越高，身上所携带的宝物越多。通过挑战神兽，可得到神兽身上的宝物祝福。{open, 42, 继续供养, ffe100}">>));
                2 -> guild:guild_chat(Gid, ?L(<<"经过全体帮众的诚心供养，神兽终于成长为青年期。神兽成长越高，身上所携带的宝物越多。通过挑战神兽，可得到神兽身上的宝物祝福。{open, 42, 继续供养, ffe100}">>));
                3 -> guild:guild_chat(Gid, ?L(<<"经过全体帮众的诚心供养，神兽终于成长达到了最高，身上的宝物闪闪发光。帮主可选择挑战神兽，全体帮众一起击杀，获取神兽身上的宝物。{open, 42, 挑战神兽, ffe100}">>));
                _ -> ok
            end,
            case create_boss_npc(Gid, NewB) of
                NewB1 = #guild_boss_npc{} ->
                    {Addition, NewB1};
                _ ->
                    false
            end
    end.

%% 初始化boss
init_npcs([], {Guilds, Index}) ->
    {Guilds, Index};
init_npcs([G = #guild_boss_guild{bosses = []} | T], {Guilds, Index}) ->
    init_npcs(T, {[G | Guilds], Index});
init_npcs([G = #guild_boss_guild{bosses = Bosses, kill_log = KillLog} | T], {Guilds, Index}) ->
    F = fun(B = #guild_boss_npc{role_log = Roles}) ->
            NewRoles = [R#guild_boss_role{is_fighting = 0} || R = #guild_boss_role{} <- Roles],
            B#guild_boss_npc{id = 0, role_log = NewRoles};
        %% 兼容旧版本
        ({guild_boss_npc, _Id, Gid, Type, Mood, Exp, Lev, Hp, TodayFeed, TodayPlay, LastFeed, LastPlayed, Roles}) ->
            NewRoles = [R#guild_boss_role{is_fighting = 0} || R = #guild_boss_role{} <- Roles],
            #guild_boss_npc{
                id = 0, 
                gid = Gid, 
                type = Type, 
                mood = Mood,
                exp = Exp, 
                lev = Lev, 
                hp = Hp, 
                today_feed = TodayFeed, 
                today_play = TodayPlay,
                last_feed = LastFeed,
                last_played = LastPlayed,
                role_log = NewRoles};
        (Else) ->
            ?DEBUG("意外版本的数据结构 ~w", [Else]),
            Else
    end,
    NewBosses = [F(B) || B <- Bosses],
    NewLog = [Log || Log = #guild_boss_role{} <- KillLog],
    init_npcs(T, {[G#guild_boss_guild{bosses = NewBosses, kill_log = NewLog} | Guilds], Index}).

%% 初始化boss进程
start_all_boss([], Guilds, Index) ->
    {Guilds, Index};
start_all_boss([G = #guild_boss_guild{bosses = []} | T], Guilds, Index) ->
    start_all_boss(T, [G | Guilds], Index);
start_all_boss([G = #guild_boss_guild{id = Gid, bosses = Bosses} | T], Guilds, Index) ->
    F = fun(B, {Bs, Idx}) ->
            case create_boss_npc(Gid, B) of
                NewB = #guild_boss_npc{id = Id} ->
                    {[NewB | Bs], [{Id, Gid} | Idx]};
                _ ->
                    {[B | Bs], Idx}
            end
    end,
    {NewBosses, NewIndex} = lists:foldl(F, {[], Index}, Bosses),
    start_all_boss(T, [G#guild_boss_guild{bosses = NewBosses} | Guilds], NewIndex).

%% 获取领养boss所需要的等级和帮会资金
%% get_adopt_condition(Type) -> {Lv, GuildLoss}
get_adopt_condition(1) ->
    {15, 10000};
get_adopt_condition(2) ->
    {25, 30000};
get_adopt_condition(3) ->
    {35, 50000};
get_adopt_condition(4) ->
    {40, 100000};
get_adopt_condition(_) ->
    {40, 100000}.

%% boss击毙后发放奖励
reward_roles(#guild_boss_npc{hp = 0, type = Type, lev = Lev, role_log = Roles}) ->
    NewRoles = [R || R = #guild_boss_role{total_dmg = Dmg} <- Roles, Dmg > 0],
    TotalDmg = lists:sum([OneDmg || #guild_boss_role{total_dmg = OneDmg} <- NewRoles]),
    RewardBase = [{ItemId, Bind, Num div 2} || {ItemId, Bind, Num} <- get_reward_base(Type, Lev)],
    RewardList = dispatch_reward(RewardBase, TotalDmg, NewRoles, []),
    F = fun({Rid, Items}) ->
            case lists:keyfind(Rid, #guild_boss_role.id, NewRoles) of
                #guild_boss_role{id = {Id, SrvId}, name = Name, total_dmg = RDmg} ->
                    Fund = RDmg div TotalDmg * 3000,
                    AssetInfo = [{?mail_guild_devote, Fund}],
                    mail_mgr:deliver({Id, SrvId, Name}, {?L(<<"参与击杀帮会神兽奖励">>), util:fbin(?L(<<"你在本次击杀帮会神兽中，共对神兽造成~w点伤害。\n折算成\n帮会贡献：~w\n并幸运的获得了以下物品奖励！（造成伤害越大，获得物品的概率越高）">>), [RDmg, Fund]), AssetInfo, Items});
                _ -> ok
            end
    end,
    [F(One) || One <- RewardList];
reward_roles(_) ->
    ok.

dispatch_reward([], _, _, List) ->
    List;
dispatch_reward(Items, _, [#guild_boss_role{id = Id}], _List) ->
    [{Id, Items}];
dispatch_reward([{ItemId, Bind, Num} | T], TotalDmg, Roles, List) ->
        Rid = rand_reward(util:rand(1, TotalDmg), Roles, 0),
        NewList = case lists:keyfind(Rid, 1, List) of
            {Rid, Items} ->
                NewItems = case lists:keyfind(ItemId, 1, Items) of
                    {ItemId, 1, OwnNum} -> lists:keyreplace(ItemId, 1, Items, {ItemId, 1, OwnNum + 1});
                    _ -> [{ItemId, 1, 1} | Items]
                end,
                lists:keyreplace(Rid, 1, List, {Rid, NewItems});
            _ ->
                [{Rid, [{ItemId, 1, 1}]} | List]
        end,
        case Num > 1 of
            true -> dispatch_reward([{ItemId, Bind, Num - 1} | T], TotalDmg, Roles, NewList);
            _ -> dispatch_reward(T, TotalDmg, Roles, NewList)
        end.

rand_reward(_, [], _Sum) ->
    ?ERR("不应该来到这里"),
    0;
rand_reward(_, [#guild_boss_role{id = Id}], _Sum) ->
    Id;
rand_reward(Rand, [#guild_boss_role{id = Id, total_dmg = TotalDmg} | T], Sum) ->
    NewSum = TotalDmg + Sum,
    case NewSum >= Rand of
        true -> Id;
        _ -> rand_reward(Rand, T, NewSum)
    end.

%% 奖励配置
%% get_reward_base(Type, Lev) -> list()
get_reward_base(Type, Lev) ->
    do_get_reward_base(Type, Lev, 1).

do_get_reward_base(1, Lev, Ratio) ->
    [{25021, 1, 5 * Lev * Ratio}, {30210, 1, 15 * Lev * Ratio}];
do_get_reward_base(2, Lev, Ratio) ->
    [{25026, 1, 4 * Lev * Ratio}, {25021, 1, 5 * Lev * Ratio}, {30210, 1, 15 * Lev * Ratio}];
do_get_reward_base(3, Lev, Ratio) ->
    [{33113, 1, 4 * Lev * Ratio}, {25026, 1, 6 * Lev * Ratio}, {25021, 1, 5 * Lev * Ratio}, {30210, 1, 20 * Lev * Ratio}];
do_get_reward_base(4, Lev, Ratio) ->
    [{33113, 1, 8 * Lev * Ratio}, {25026, 1, 12 * Lev * Ratio}, {25021, 1, 10 * Lev * Ratio}, {30210, 1, 40 * Lev * Ratio}];
do_get_reward_base(_, _, _) ->
    [].

get_upgrade_exp(1, Lev) ->
    (Lev + 1) * 5000;
get_upgrade_exp(2, Lev) ->
    (Lev + 1) * 6000;
get_upgrade_exp(3, Lev) ->
    (Lev + 1) * 7000;
get_upgrade_exp(4, Lev) ->
    (Lev + 1) * 10000.

%% 进入帮派领地
apply_guild_area(Role) ->
    apply_guild_area(Role, go_there).
apply_guild_area(Role = #role{hp = Hp, hp_max = MaxHp, mp = Mp, mp_max = MaxMp, guild = #role_guild{gid = Gid, srv_id = SrvId}}, Type) ->
    {NewHp, NewMp} = case Type of
        revive -> {MaxHp, MaxMp};
        _ -> {Hp, Mp}
    end,
    case guild_mgr:lookup(by_id, {Gid, SrvId}) of
        #guild{entrance = {MapId, _X, _Y}} ->
            case map:role_enter(MapId, 3000, 1500, Role#role{status = ?status_normal, hp = NewHp, mp = NewMp, event = ?event_guild}) of
                {false, _Reason} ->
                    {ok};
                {ok, NewRole2} ->
                    {ok, NewRole2}
            end;
        _ ->
            {ok}
    end;
apply_guild_area(_, _) ->
    {ok}.
