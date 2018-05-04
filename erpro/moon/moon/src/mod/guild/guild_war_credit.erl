%% --------------------------------------------------------------------
%% 帮战积分计算逻辑
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------
-module(guild_war_credit).

-export([
        credit/3,
        calc_compete_credit/2
    ]).

%% include files 
-include("common.hrl").
-include("guild_war.hrl").
%%

%% 主将赛积分
-define(compete_credit_type_union(No), 
    case No of
        0 -> ?guild_war_credit_compete_union_0;
        1 -> ?guild_war_credit_compete_union_1;
        2 -> ?guild_war_credit_compete_union_2;
        3 -> ?guild_war_credit_compete_union_3;
        _ -> ?guild_war_credit_compete_union_4
    end
).

-define(compete_credit_type_win(No), 
    case No of
        0 -> ?guild_war_credit_compete_0;
        1 -> ?guild_war_credit_compete_1;
        2 -> ?guild_war_credit_compete_2;
        3 -> ?guild_war_credit_compete_3;
        _ -> ?guild_war_credit_compete_4
    end
).

-define(compete_credit_type_lose(No), 
    case No of
        0 -> ?guild_war_credit_compete_lose_0;
        1 -> ?guild_war_credit_compete_lose_1;
        2 -> ?guild_war_credit_compete_lose_2;
        3 -> ?guild_war_credit_compete_lose_3;
        _ -> ?guild_war_credit_compete_lose_4
    end
).

%% --------------------------------------------------------------------
%% api functions
%% --------------------------------------------------------------------

%% 计算主将赛积分
calc_compete_credit(TeamNo, RemainHp) ->
    do_calc_compete_credit(?compete_credit_type_union(TeamNo), RemainHp).

%% @spec credit(Type, Rid, State) -> NewState
%% Type = term()
%% Rid = rid() | [rid(), ...]
%% State = NewState = #guild_war{}
%% 计算积分
credit(_Type, [], State) ->
    State;
credit(Type, [H | T], State) ->
    NewState = do_credit(Type, H, State),
    credit(Type, T, NewState);
credit(_Type = combat_win_union, {Union, Count}, State) ->
    credit_type(union, {combat_win, Union, Count}, State);
credit(_Type = combat_win_union, _, State) ->
    State;
credit(_Type = {compete_union, TeamNo}, {Union, Hp}, State) ->
    credit_type(union, {TeamNo, Union, Hp}, State);
credit(Type, Rid, State) ->
    do_credit(Type, Rid, State).


%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% 计算积分
do_credit(Type, Rid, State = #guild_war{roles = Roles, guilds = Guilds}) ->
    ?debug_log([credit, {Type, Rid}]),
    {GuildId, NewRoles} = case lists:keyfind(Rid, #guild_war_role.id, Roles) of
        false ->
            {0, Roles};
        Grole = #guild_war_role{guild_id = Gid} ->
            NewGrole = credit_type(role, Type, Grole),
            {Gid, lists:keyreplace(Rid, #guild_war_role.id, Roles, NewGrole)}
    end,
    NewGuilds = case lists:keyfind(GuildId, #guild_war_guild.id, Guilds) of
        false ->
            Guilds;
        Gguild ->
            NewGuild = credit_type(guild, Type, Gguild),
            lists:keyreplace(GuildId, #guild_war_guild.id, Guilds, NewGuild)
    end,
    State#guild_war{roles = NewRoles, guilds = NewGuilds}.

%% 积分类别
%% 战斗胜利
credit_type(role, {combat_win, IsDie, Count}, Grole = #guild_war_role{pid = Rpid, credit = Credit, credit_combat = Ckill, credit_dead = Cdead}) ->
    NewCdead = case IsDie of
        ?true ->
            Cdead + 1;
        _ ->
            Cdead
    end,
    GainCredit = Count * ?guild_war_credit_combat,
    guild_war_util:send_notice(Rpid, util:fbin(?L(<<"战斗胜利，获得~w积分">>), [GainCredit]), 1),
    Grole#guild_war_role{credit = Credit + GainCredit, credit_combat = Ckill + GainCredit, credit_dead = NewCdead};
credit_type(guild, {combat_win, _IsDie, Count}, Guild = #guild_war_guild{credit = Credit, credit_combat = Ccombat}) ->
    C = Count * ?guild_war_credit_combat,
    Guild#guild_war_guild{credit = Credit + C, credit_combat = Ccombat + C};
credit_type(union, {combat_win, Union, Count}, State = #guild_war{attack_union = AtkUnion = #guild_war_union{credit_combat = AtkCombat}, defend_union = DfdUnion = #guild_war_union{credit_combat = DfdCombat}}) ->
    {NewAtkUnion, NewDfdUnion} = case Union of
        ?guild_war_union_attack ->
            {AtkUnion#guild_war_union{credit_combat = Count + AtkCombat}, DfdUnion};
        ?guild_war_union_defend ->
            {AtkUnion, DfdUnion#guild_war_union{credit_combat = Count + DfdCombat}};
        _ ->
            {AtkUnion, DfdUnion}
    end,
    State#guild_war{attack_union = NewAtkUnion, defend_union = NewDfdUnion};

%% 战斗失败
credit_type(role, combat_lose, Grole = #guild_war_role{pid = Rpid, credit_dead = Cdead, credit = Credit}) ->
    guild_war_util:send_notice(Rpid, util:fbin(?L(<<"战斗失败，获得~w积分">>), [?guild_war_credit_combat_lost]), 1),
    Grole#guild_war_role{credit_dead = Cdead + 1, credit = Credit + ?guild_war_credit_combat_lost};
credit_type(guild, combat_lose, Guild = #guild_war_guild{credit = Credit}) ->
    Guild#guild_war_guild{credit = Credit + ?guild_war_credit_combat_lost};

%% 主将赛积分
credit_type(role, {compete_win, TeamNo}, Grole) ->
    do_compete_credit(win, role, ?compete_credit_type_win(TeamNo), Grole);
credit_type(guild, {compete_win, TeamNo}, Guild) ->
    do_compete_credit(win, guild, ?compete_credit_type_win(TeamNo), Guild);
credit_type(role, {compete_lose, TeamNo}, Grole) ->
    do_compete_credit(lose, role, ?compete_credit_type_lose(TeamNo), Grole);
credit_type(guild, {compete_lose, TeamNo}, Guild) ->
    do_compete_credit(lose, guild, ?compete_credit_type_lose(TeamNo), Guild);
credit_type(union, {CompeteUnionType, Union, Hp}, State) ->
    do_compete_credit(win, {union, Union}, calc_compete_credit(CompeteUnionType, Hp), State);
   
%% 晶石
credit_type(role, stone, Grole = #guild_war_role{credit = Credit, credit_stone = Cstone}) ->
    Grole#guild_war_role{credit = Credit + ?guild_war_credit_stone, credit_stone = Cstone + ?guild_war_credit_stone};
credit_type(guild, stone, Guild = #guild_war_guild{credit = Credit, credit_stone = Cstone}) ->
    Guild#guild_war_guild{credit = Credit + ?guild_war_credit_stone, credit_stone = Cstone + ?guild_war_credit_stone};

%% 封印神剑
credit_type(role, sword, Grole = #guild_war_role{credit = Credit, credit_sword = Csword}) ->
    Grole#guild_war_role{credit = Credit + ?guild_war_credit_sword, credit_sword = Csword + ?guild_war_credit_sword};
credit_type(guild, sword, Guild = #guild_war_guild{credit = Credit, credit_sword = Csword}) ->
    Guild#guild_war_guild{credit = Credit + ?guild_war_credit_sword, credit_sword = Csword + ?guild_war_credit_sword};

    
credit_type(_Type, _CreditType, Data) ->
    ?debug_log([credit_not_handle, {_Type, _CreditType}]),
    Data.

%% 主将赛积分
do_compete_credit(win, role, C, Grole = #guild_war_role{pid = Rpid, credit = Credit, credit_compete = Ccompete}) ->
    guild_war_util:send_notice(Rpid, util:fbin(?L(<<"主将赛胜利，获得~w积分">>), [C]), 1),
    Grole#guild_war_role{credit = Credit + C, credit_compete = Ccompete + C};
do_compete_credit(lose, role, C, Grole = #guild_war_role{pid = Rpid, credit = Credit, credit_compete = Ccompete}) ->
    guild_war_util:send_notice(Rpid, util:fbin(?L(<<"主将赛失败，获得~w积分">>), [C]), 1),
    Grole#guild_war_role{credit = Credit + C, credit_compete = Ccompete + C};
do_compete_credit(_, guild, C, Guild = #guild_war_guild{credit = Credit, credit_compete = Ccompete}) ->
    Guild#guild_war_guild{credit = Credit + C, credit_compete = Ccompete + C};
do_compete_credit(win, {union, Union}, Credit, State = #guild_war{attack_union = AtkUnion, defend_union = DfdUnion}) ->
    case Union of
        ?guild_war_union_defend ->
            #guild_war_union{credit = DedCredit, credit_compete = DfdCompete} = DfdUnion,
            State#guild_war{defend_union = DfdUnion#guild_war_union{credit = DedCredit + Credit, credit_compete = DfdCompete + Credit}};
        ?guild_war_union_attack ->
            #guild_war_union{credit = AtkCredit, credit_compete = AtkCompete} = AtkUnion,
            State#guild_war{attack_union = AtkUnion#guild_war_union{credit = AtkCredit + Credit, credit_compete = AtkCompete + Credit}};
        _ ->
            State
    end;
do_compete_credit(_, _, _, Data) ->
    Data.

%% 计算联盟积分
do_calc_compete_credit(Credit, RemainHp) ->
    C = util:ceil(Credit * RemainHp / 100),
    case C < util:ceil(Credit / 5) of
        true ->
            util:ceil(Credit / 5);
        false ->
            C
    end.

