%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 十月 2015 10:32
%%%-------------------------------------------------------------------
-module(guild_skill).
-author("hxming").

-include("guild.hrl").
-include("server.hrl").
-include("common.hrl").
%% API
-compile(export_all).

%%===========================技能类型=================================================

%% 1生命，2攻击，3护甲，4魔抗，5破甲，6穿透，7命中，8闪避，9暴击，10韧性，11最终伤害，12最终减伤

%%====================================================================================

init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            Skill = #g_skill{pkey = Player#player.key, is_change = 1},
            set_skill(Skill#g_skill{attribute = #attribute{}});
        false ->
            case guild_load:select_guild_skill(Player#player.key) of
                [] ->
                    Skill = #g_skill{pkey = Player#player.key, is_change = 1},
                    set_skill(Skill#g_skill{attribute = #attribute{}});
                [SkillList] ->
                    Skill = #g_skill{
                        pkey = Player#player.key,
                        skill_list = util:bitstring_to_term(SkillList)
                    },
                    if Player#player.guild#st_guild.guild_key =/= 0 ->
                        Glv = guild_util:get_guild_lv(Player#player.guild#st_guild.guild_key),
                        Attribute = lv_to_attribute(Skill, Glv, Player#player.lv),
                        set_skill(Skill#g_skill{attribute = Attribute});
                        true ->
                            set_skill(Skill#g_skill{attribute = #attribute{}})
                    end

            end
    end,
    Player.

logout() ->
    Skill = get_skill(),
    if Skill#g_skill.is_change == 1 ->
        guild_load:replace_guild_skill(Skill);
        true -> skip
    end.

timer_update() ->
    Skill = get_skill(),
    if Skill#g_skill.is_change == 1 ->
        set_skill(Skill#g_skill{is_change = 0}),
        guild_load:replace_guild_skill(Skill);
        true -> skip
    end.

%%获取仙盟技能
get_guild_skill_attribute() ->
    Skill = get_skill(),
    Skill#g_skill.attribute.

reset_guild_kill_attribute() ->
    Skill = get_skill(),
    set_skill(Skill#g_skill{attribute = #attribute{}}).

load_player_guild_skill(Plv, GKey) ->
    case guild_ets:get_guild(GKey) of
        false -> skip;
        Guild ->
            Skill = get_skill(),
            Attribute = lv_to_attribute(Skill, Guild#guild.lv, Plv),
            set_skill(Skill#g_skill{attribute = Attribute})
    end.

%%计算仙盟技能属性
lv_to_attribute(Skill, Glv, Plv) ->
    F = fun(Id, Attribute) ->
        case lists:keyfind(Id, 1, Skill#g_skill.skill_list) of
            false ->
                Attribute;
            {_, Lv} ->
                Val = calc_attribute(Id, Lv, Glv, Plv),
                case Id of
                    1 ->
                        Attribute#attribute{hp_lim = Val};
                    2 ->
                        Attribute#attribute{att = Val};
                    3 ->
                        Attribute#attribute{def = Val};
                    7 ->
                        Attribute#attribute{hit = Val};
                    8 ->
                        Attribute#attribute{dodge = Val};
                    9 ->
                        Attribute#attribute{crit = Val};
                    10 ->
                        Attribute#attribute{ten = Val};
                    11 ->
                        Attribute#attribute{hurt_fix = Val};
                    12 ->
                        Attribute#attribute{hurt_dec = Val};
                    _ -> Attribute
                end
        end
        end,
    lists:foldl(F, #attribute{}, data_guild_skill:ids()).

%%计算属性
calc_attribute(_Id, 0, _Glv, _Plv) -> 0;
calc_attribute(Id, MaxLv, Glv, Plv) ->
    calc_attribute_loop(lists:seq(1, MaxLv), Id, Glv, Plv, 0).

calc_attribute_loop([], _Id, _Glv, _Plv, Val) ->
    Val;
calc_attribute_loop([Slv | T], Id, Glv, Plv, Val) ->
    case data_guild_skill:get(Id, Slv) of
        [] -> Val;
        Base ->
            if Base#base_guild_skill.glv =< Glv andalso Base#base_guild_skill.plv =< Plv ->
                calc_attribute_loop(T, Id, Glv, Plv, Base#base_guild_skill.attribute);
                true -> Val
            end
    end.

%%获取技能
get_skill() ->
    lib_dict:get(?PROC_STATUS_GUILD_SKILL).

set_skill(Skill) ->
    lib_dict:put(?PROC_STATUS_GUILD_SKILL, Skill).

%%获取仙盟技能信息
get_guild_skill(Player) ->
    case guild_ets:get_guild_member(Player#player.key) of
        false -> {0, [], []};
        Member ->
            case guild_ets:get_guild(Member#g_member.gkey) of
                false -> {0, [], []};
                Guild ->
                    Skill = get_skill(),
                    F = fun(Id) ->
                        Lv = get_skill_lv(Skill, Id),
                        %%{ID，名称，描述，当前等级，当前属性，下一级，下一级属性，是否可升级，开启的仙盟等级，提升所需的玩家等级，贡献消耗}
                        {IsUp, NextLv, NextAttribute, Glv, Plv, Contrib, Name, Desc} =
                            check_upgrade(Id, Lv, Guild#guild.lv, Player#player.lv),
                        MaxLv = max_lv(Id),
                        if Lv == 0 ->
                            [Id, Name, Desc, Lv, MaxLv, 0, NextLv, NextAttribute, Desc, IsUp, Glv, Plv, Contrib];
                            true ->
                                Base = data_guild_skill:get(Id, Lv),
                                [Id, Base#base_guild_skill.name, Base#base_guild_skill.desc,
                                    Lv, MaxLv, Base#base_guild_skill.attribute, NextLv, NextAttribute, Desc,
                                    IsUp, Glv, Plv, Contrib]
                        end
                        end,
                    SKillList = lists:map(F, data_guild_skill:ids()),
                    {
                        Member#g_member.leave_dedicate,
                        SKillList,
                        attribute_list()
                    }
            end
    end.

attribute_list() ->
    Attribute = get_guild_skill_attribute(),
    F = fun(Type) ->
        case Type of
            1 -> [[Type, Attribute#attribute.hp_lim]];
            2 -> [[Type, Attribute#attribute.att]];
            3 -> [[Type, Attribute#attribute.def]];
            4 -> [[Type, 0]];
            5 -> [[Type, 0]];
            6 -> [[Type, 0]];
            7 -> [[Type, Attribute#attribute.hit]];
            8 -> [[Type, Attribute#attribute.dodge]];
            9 -> [[Type, Attribute#attribute.crit]];
            10 -> [[Type, Attribute#attribute.ten]];
            11 -> [[Type, Attribute#attribute.hurt_fix]];
            12 -> [[Type, Attribute#attribute.hurt_dec]];
            _ -> []
        end
        end,
    lists:flatmap(F, data_guild_skill:ids()).

max_lv(Id) ->
    case data_guild_skill:id_lvs(Id) of
        [] -> 0;
        Lvs ->
            lists:max(Lvs)
    end.

%%检查是否可升级
check_upgrade(Id, Lv, Glv, Plv) ->
    case data_guild_skill:get(Id, Lv + 1) of
        [] -> {0, 0, 0, 0, 0, 0, <<>>, <<>>};
        Base ->
            if Base#base_guild_skill.glv =< Glv andalso Base#base_guild_skill.plv =< Plv ->
                {1, Lv + 1, Base#base_guild_skill.attribute, Base#base_guild_skill.glv, Base#base_guild_skill.plv,
                    Base#base_guild_skill.contrib, Base#base_guild_skill.name, Base#base_guild_skill.desc};
                true ->
                    {0, Lv + 1, Base#base_guild_skill.attribute, Base#base_guild_skill.glv, Base#base_guild_skill.plv,
                        Base#base_guild_skill.contrib, Base#base_guild_skill.name, Base#base_guild_skill.desc}
            end
    end.

%%获取开启技能仙盟等级
get_open_glv(Id) ->
    case data_guild_skill:get(Id, 1) of
        [] -> 0;
        Base -> Base#base_guild_skill.glv
    end.

%%获取技能等级
get_skill_lv(Skill, Id) ->
    case lists:keyfind(Id, 1, Skill#g_skill.skill_list) of
        false -> 0;
        {_, Lv} -> Lv
    end.

%%提升仙盟技能
upgrade_guild_skill(Player, Id) ->
    if Player#player.guild#st_guild.guild_key == 3 ->
        {2, Player};
        true ->
            case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
                false -> {4, Player};
                Guild ->
                    case guild_ets:get_guild_member(Player#player.key) of
                        false -> {5, Player};
                        Member ->
                            case lists:member(Id, data_guild_skill:ids()) of
                                false -> {411, Player};
                                true ->
                                    Skill = get_skill(),
                                    Slv = get_skill_lv(Skill, Id),
                                    case data_guild_skill:get(Id, Slv + 1) of
                                        [] -> {412, Player};
                                        Base ->
                                            if Base#base_guild_skill.glv > Guild#guild.lv -> {413, Player};
                                                Base#base_guild_skill.plv > Player#player.lv -> {414, Player};
                                                Base#base_guild_skill.contrib > Member#g_member.leave_dedicate -> {415, Player};
                                                true ->
                                                    %%更新等级
                                                    NewSkill = upgrade_lv(Skill, Id, Slv + 1),
                                                    Attribute = lv_to_attribute(NewSkill, Guild#guild.lv, Player#player.lv),
                                                    set_skill(NewSkill#g_skill{is_change = 1, attribute = Attribute}),
                                                    %%扣除贡献
                                                    NewMember = Member#g_member{leave_dedicate = Member#g_member.leave_dedicate - Base#base_guild_skill.contrib},
                                                    guild_ets:set_guild_member(NewMember),
                                                    guild_load:replace_guild_member(NewMember),
                                                    %%重新计算属性
                                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                                    Now = util:unixtime(),
                                                    guild_load:log_guild_skill(Player#player.key, Player#player.nickname, Id, Slv, Slv + 1, Now),
                                                    guild_load:log_guild_dedicate(Player#player.key, Player#player.nickname, Player#player.guild#st_guild.guild_key, 0, 0, Now, -Base#base_guild_skill.contrib, NewMember#g_member.acc_dedicate, NewMember#g_member.leave_dedicate, ?T("提升仙盟技能")),
                                                    {1, NewPlayer}
                                            end
                                    end
                            end
                    end
            end
    end.

upgrade_lv(Skill, Id, Lv) ->
    SkillList = [{Id, Lv} | lists:keydelete(Id, 1, Skill#g_skill.skill_list)],
    Skill#g_skill{skill_list = SkillList}.

%%获取玩家仙盟技能总等级
get_sum_guild_skill_lv() ->
    Skill = get_skill(),
    lists:sum([Lv || {_, Lv} <- Skill#g_skill.skill_list]).


%%仙盟升级,重新计算属性
upgrade_glv(Player, Glv) ->
    Skill = get_skill(),
    Attribute = lv_to_attribute(Skill, Glv, Player#player.lv),
    set_skill(Skill#g_skill{is_change = 1, attribute = Attribute}),
    player_util:count_player_attribute(Player, true).

