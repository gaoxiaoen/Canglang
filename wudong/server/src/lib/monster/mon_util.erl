%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 怪物逻辑辅助函数
%%% @end
%%% Created : 14. 七月 2015 下午5:17
%%%-------------------------------------------------------------------
-module(mon_util).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("skill.hrl").
-include("battle.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

%%初始化辅助函数
mon_init_helper([], M) -> M;
mon_init_helper([H | T], M) ->
    NewM =
        case H of
            {link, Pid} when is_pid(Pid) -> link(Pid), M;
            {share, true} ->
                Self = self(),
                M#mon{share_list = [Self | lists:delete(Self, M#mon.share_list)]};
            {share_list, Val} ->
                M#mon{share_list = util:list_filter_repeat(Val ++ M#mon.share_list)};
            {auto_lv, Lv} -> create_attr(M, Lv);
            {lv, Lv} -> M#mon{lv = Lv};
            {group, Group} -> M#mon{group = Group};
            {owner_key, OwnerKey} -> M#mon{owner_key = OwnerKey};
            {mon_name, MonName} -> case MonName == [] of true -> M; false -> M#mon{name = MonName} end;
            {kind, Kind} ->
                if Kind == ?MON_KIND_TREASURE_MON ->
                    M#mon{kind = Kind, trace_area = 10};
                    true ->
                        M#mon{kind = Kind}
                end;
            {boss, Boss} -> M#mon{boss = Boss};
            {color, MonColor} -> M#mon{color = MonColor};
            {ai, Ai} -> M#mon{ai = Ai};
            {skill, Value} -> M#mon{skill = Value};
            {hp, Value} when is_float(Value) -> M#mon{hp = trunc(M#mon.hp_lim * Value)};
            {hp, Value} -> M#mon{hp = Value};
            {hp_lim, Value} -> M#mon{hp_lim = Value};
            {def, Value} when is_float(Value) -> M#mon{def = trunc(M#mon.def * Value)};
            {def, Value} -> M#mon{def = Value};
            {att, Value} when is_float(Value) -> M#mon{att = trunc(M#mon.att * Value)};
            {att, Value} -> M#mon{att = Value};
            {hit, Value} -> M#mon{hit = Value};
            {dodge, Value} -> M#mon{dodge = Value};
            {ten, Value} -> M#mon{ten = Value};
            {crit, Value} -> M#mon{crit = Value};
            {retime, Value} -> M#mon{retime = Value};
            {shadow, Value} -> init_shadow_attr(M, Value);
            {life, Value} -> M#mon{life = Value};
            {path, Value} -> M#mon{path = Value};
            {icon, Value} -> M#mon{icon = Value};
            {trace_area, Value} -> M#mon{trace_area = Value};
            {recover_hp_percent, Timer, Percent} ->
                erlang:send_after(Timer * 1000, self(), {recover_hp_percent, [Timer, Percent]}), M;
            {invade_box, Value} ->
                M#mon{invade = Value};
            {wave, Value} ->
                M#mon{wave = Value};
            {cross_scuff_elite_fight_num, Value} ->
                M#mon{cross_scuff_elite_fight_num = Value};
            {cl_auth, Value} ->
                M#mon{cl_auth = Value, collect_num = length(Value)};
            {return_id_pid, _} -> M;
            {return_pid, _} -> M;
            {eliminate_group, Value} -> M#mon{eliminate_group = Value};
            {godt, Value} ->
                M#mon{time_mark = M#mon.time_mark#time_mark{godt = Value}};
            {set_godt, Timer, Value} ->
                erlang:send_after(Timer * 1000, self(), {godt, Value}), M;
            {show_time, Value} ->
                M#mon{show_time = Value};
            {type, Value} ->
                M#mon{type = Value};
            {is_att_by_mon, Value} ->
                M#mon{is_att_by_mon = Value};
            {is_att_by_player, Value} ->
                M#mon{is_att_by_player = Value};
            {guild_key, Val} ->
                M#mon{guild_key = Val};
            {change_type, Timer, Type} ->
                erlang:send_after(round(Timer * 1000), self(), {act_state, Type}), M;
            {world_lv_mon, _Value} -> %%世界等级怪
                #mon{
                    lv = Lv, att = Att, def = Def, hp_lim = HpLim, crit = Crit, ten = Ten, hit = Hit, dodge = Dodge
                } = M,
                WorldLv = rank:get_world_lv(),
                WorldLvX = data_world_lv:get(WorldLv),
                LvX = data_world_lv:get(Lv),
                [Att1, Def1, HpLim1, Crit1, Ten1, Hit1, Dodge1] = [util:floor(Val * (WorldLvX / LvX)) || Val <- [Att, Def, HpLim, Crit, Ten, Hit, Dodge]],
                M#mon{
                    lv = WorldLv, att = Att1, def = Def1, hp = HpLim1, hp_lim = HpLim1, crit = Crit1, ten = Ten1, hit = Hit1, dodge = Dodge1
                };
            {world_lv, WorldLv} ->
                #mon{
                    lv = Lv, att = Att, def = Def, hp_lim = HpLim, crit = Crit, ten = Ten, hit = Hit, dodge = Dodge
                } = M,
                WorldLvX = data_world_lv:get(WorldLv),
                LvX = data_world_lv:get(Lv),
                [Att1, Def1, HpLim1, Crit1, Ten1, Hit1, Dodge1] = [util:floor(Val * (WorldLvX / LvX)) || Val <- [Att, Def, HpLim, Crit, Ten, Hit, Dodge]],
                M#mon{
                    lv = WorldLv, att = Att1, def = Def1, hp = HpLim1, hp_lim = HpLim1, crit = Crit1, ten = Ten1, hit = Hit1, dodge = Dodge1
                };
            {walk, Val} ->
                M#mon{walk = Val};
            {party_key, Val} ->
                M#mon{party_key = Val};
            {index, Val} ->
                M#mon{index = Val};
            _ ->
                ?DEBUG("mon_init_helper ~p undef ~n", [H]),
                M
        end,
    mon_init_helper(T, NewM);
mon_init_helper(_, M) -> M.

%% 生成属性
create_attr(M, Lv) ->
    if
        Lv == 0 ->
            M;
        Lv > 0 andalso Lv =< 36 ->
            M#mon{
                att = round(M#mon.att * Lv * Lv / 250),
                lv = Lv,
                hp = round(M#mon.hp * Lv * Lv / 30),
                hp_lim = round(M#mon.hp_lim * Lv * Lv / 30),
                hit = round(M#mon.hit * Lv * Lv / 100),
                dodge = round(M#mon.dodge * Lv * Lv / 250),
                crit = 1,
                ten = round(M#mon.ten * Lv * Lv / 100)
            };
        Lv > 36 andalso Lv < 42 ->
            M#mon{
                att = round(M#mon.att * Lv * Lv / 200),
                lv = Lv,
                hp = round(M#mon.hp * Lv * Lv / 20),
                hp_lim = round(M#mon.hp_lim * Lv * Lv / 20),
                hit = round(M#mon.hit * Lv * Lv / 100),
                dodge = round(M#mon.dodge * Lv * Lv / 200),
                crit = 1,
                ten = round(M#mon.ten * Lv * Lv / 100)
            };
        true ->
            M#mon{
                att = round(M#mon.att * Lv * Lv / 100),
                lv = Lv,
                hp = round(M#mon.hp * Lv * Lv / 10),
                hp_lim = round(M#mon.hp_lim * Lv * Lv / 10),
                hit = round(M#mon.hit * Lv * Lv / 100),
                dodge = round(M#mon.dodge * Lv * Lv / 100),
                crit = round(M#mon.crit * Lv * Lv / 100),
                ten = round(M#mon.ten * Lv * Lv / 100)
            }
    end.

%% %%初始化玩家分身属性
init_shadow_attr(Mon, Status) ->
    if Status#player.shadow#st_shadow.shadow_id > 0 ->
        Mon#mon{
            life = 0,
%%            retime = 0,
            shadow_key = Status#player.key,
            speed = ?BASE_SPEED,
            att_area = player_util:att_area(Status#player.career, Status#player.pf),
            trace_area = 999999,
            shadow_status = Status,
            att_speed = 500,
            skill = filter_skill(Status#player.career, Status#player.skill),
            skill_qte = filter_qte_skill(Status#player.skill),
            hp = round(Mon#mon.hp_lim * Status#player.shadow#st_shadow.hp_per),
            hp_lim = round(Mon#mon.hp_lim * Status#player.shadow#st_shadow.hp_per),
            att = round(Mon#mon.att * Status#player.shadow#st_shadow.att_per)
        };
        true ->
            Mon#mon{
                shadow_key = Status#player.key,
                shadow_status = Status,
                lv = Status#player.lv,
                life = 0,
                hp = round(Status#player.attribute#attribute.hp_lim * Status#player.shadow#st_shadow.hp_per),
                hp_lim = round(Status#player.attribute#attribute.hp_lim * Status#player.shadow#st_shadow.hp_per),
                mp_lim = Status#player.attribute#attribute.mp_lim,
%%                retime = 0,
                skill = filter_skill(Status#player.career, Status#player.skill),
                skill_qte = filter_qte_skill(Status#player.skill),
                speed = ?BASE_SPEED,
                att_speed = 500,
                att = round(Status#player.attribute#attribute.att * Status#player.shadow#st_shadow.att_per),
                def = round(Status#player.attribute#attribute.def * Status#player.shadow#st_shadow.def_p_per),
                dodge = Status#player.attribute#attribute.dodge,
                crit = Status#player.attribute#attribute.crit,
                hit = Status#player.attribute#attribute.hit,
                ten = Status#player.attribute#attribute.ten,
                crit_inc = Status#player.attribute#attribute.crit_inc,
                crit_dec = Status#player.attribute#attribute.crit_dec,
                hurt_inc = Status#player.attribute#attribute.hurt_inc,
                hurt_dec = Status#player.attribute#attribute.hurt_dec,
                hp_lim_inc = Status#player.attribute#attribute.hp_lim_inc,
                recover = Status#player.attribute#attribute.recover,
                recover_hit = Status#player.attribute#attribute.recover_hit,
                size = Status#player.attribute#attribute.size,
                cure = Status#player.attribute#attribute.cure,
                att_area = player_util:att_area(Status#player.career, Status#player.pf),
                trace_area = 999999
            }
    end.

filter_skill(Career, SkillList) ->
    lists:foldl(fun(Id, Skill) ->
        case skill:get_skill(Id) of
            [] -> Skill;
            SkillData ->
                %%过滤移步技能
                if SkillData#skill.type == 3 orelse SkillData#skill.type == 2 -> Skill;
                    true ->
                        [Id | Skill]
                end
        end
    end, [], ?IF_ELSE(SkillList == [], skill:shadow_skill(Career), SkillList)).

filter_qte_skill(SkillList) ->
    lists:foldl(fun(Id, Skill) ->
        case skill:get_skill(Id) of
            [] -> Skill;
            SkillData ->
                %%过滤移步技能
                if SkillData#skill.type =/= 2 -> Skill;
                    true ->
                        [Id | Skill]
                end
        end

    end, [], SkillList).
%% 更新怪物属性
change_attr([], Minfo) -> Minfo;
change_attr([{K, V} | T], Minfo) ->
    NewMinfo = case K of
                   group -> %% 组属性
                       Minfo#mon{group = V};
                   hp when is_integer(V) ->   %% hp
                       Minfo#mon{hp = V};
                   hp when is_float(V) ->   %% hp
                       Minfo#mon{hp = trunc(V * Minfo#mon.hp_lim)};
                   att -> %% 攻击力
                       Minfo#mon{att = Minfo#mon.att + V};
                   hp_lim -> %% hp上限
                       Minfo#mon{hp_lim = Minfo#mon.hp_lim + V};

                   skill when is_list(V) -> %% 技能[{技能id, 概率,}...]
                       Minfo#mon{skill = V};
                   att_area -> %% 攻击距离
                       M1 = Minfo#mon{att_area = V},
                       if
                           M1#mon.trace_area < V -> M1#mon{trace_area = V}; %% 追踪范围调整
                           true -> M1
                       end;
                   mon_name -> %% 怪物名字
                       M = Minfo#mon{name = V},
                       show_mon(M),
                       M;
                   owner_key -> %% 拥有者id
                       Minfo#mon{owner_key = V};
                   share_list -> %% 共享怪物进程列表
                       Minfo#mon{share_list = V};
                   path ->
                       Minfo#mon{path = V};
                   xy ->
                       {X, Y} = V,
                       Minfo#mon{x = X, y = Y};
                   pet_name when is_record(Minfo#mon.shadow_status, player) ->
                       NewFPet = Minfo#mon.shadow_status#player.pet#fpet{name = V},
                       NewShadowStatus = Minfo#mon.shadow_status#player{pet = NewFPet},
                       M = Minfo#mon{shadow_status = NewShadowStatus},
                       show_mon(M),
                       M;
                   world_lv ->
                       #mon{
                           lv = Lv, att = Att, def = Def, hp_lim = HpLim, crit = Crit, ten = Ten, hit = Hit, dodge = Dodge
                       } = data_mon:get(Minfo#mon.mid),
                       WorldLvX = data_world_lv:get(V),
                       LvX = data_world_lv:get(Lv),
                       [Att1, Def1, HpLim1, Crit1, Ten1, Hit1, Dodge1] = [util:floor(Val * (WorldLvX / LvX)) || Val <- [Att, Def, HpLim, Crit, Ten, Hit, Dodge]],
                       M = Minfo#mon{
                           lv = V, att = Att1, def = Def1, hp = HpLim1, hp_lim = HpLim1, crit = Crit1, ten = Ten1, hit = Hit1, dodge = Dodge1
                       },
                       show_mon(M),
                       M;
                   type ->
                       Minfo#mon{type = V};
                   _ ->
                       Minfo
               end,
    change_attr(T, NewMinfo).

%%场景显示怪物
show_mon(Mon) ->
    {ok, Bin} = pt_120:write(12006, {[scene_pack:trans12006(Mon, util:unixtime())]}),
    case scene:is_broadcast_scene(Mon#mon.scene) of
        true ->
            server_send:send_to_scene(Mon#mon.scene, Mon#mon.copy, Bin);
        false ->
            server_send:send_to_scene(Mon#mon.scene, Mon#mon.copy, Mon#mon.x, Mon#mon.y, Bin)
    end.

%%场景隐藏怪物
hide_mon(Mon) ->
    {ok, Bin} = pt_120:write(12007, {[Mon#mon.key]}),
    case scene:is_broadcast_scene(Mon#mon.scene) of
        true ->
            server_send:send_to_scene(Mon#mon.scene, Mon#mon.copy, Bin);
        false ->
            server_send:send_to_scene(Mon#mon.scene, Mon#mon.copy, Mon#mon.x, Mon#mon.y, Bin)
    end.

hide_mon(Mkey, Scene, Copy, X, Y) ->
    {ok, Bin} = pt_120:write(12007, {[Mkey]}),
    case scene:is_broadcast_scene(Scene) of
        true ->
            server_send:send_to_scene(Scene, Copy, Bin);
        false ->
            server_send:send_to_scene(Scene, Copy, X, Y, Bin)
    end.

hide_mon(Mkey, Node, Sid) ->
    {ok, Bin} = pt_120:write(12007, {[Mkey]}),
    server_send:send_to_sid(Node, Sid, Bin).

refresh_collect_times(Mon) ->
    if Mon#mon.kind =/= ?MON_KIND_PARTY ->
        ok;
        true ->
            {ok, Bin} = pt_120:write(12058, {Mon#mon.key, Mon#mon.collect_count}),
            case scene:is_broadcast_scene(Mon#mon.scene) of
                true ->
                    server_send:send_to_scene(Mon#mon.scene, Mon#mon.copy, Bin);
                false ->
                    server_send:send_to_scene(Mon#mon.scene, Mon#mon.copy, Mon#mon.x, Mon#mon.y, Bin)
            end

    end.

%% 按队伍调整伤害列表(同一队里面只有队伍里面伤害最大的人存在于伤害列表中)
%% @列表伤害值递减返回
sort_klist([]) -> [];
sort_klist(List) ->
    sort_klist(List, []).

sort_klist([], List) ->
    lists:reverse(lists:keysort(#st_hatred.hurt, List));
sort_klist([Hatred | T], List) ->
    #st_hatred{key = Key, pid = _Pid, team_pid = PidTeam, hurt = Hurt} = Hatred,
    case is_pid(PidTeam) of
        true ->
            case team_util:in_team(PidTeam, Key) of
                true ->
                    case lists:keyfind(PidTeam, #st_hatred.team_pid, List) of
                        false ->
                            sort_klist(T, [Hatred | List]);
                        HatredOld ->
                            case HatredOld#st_hatred.hurt > Hurt of
                                true ->
                                    List1 = lists:keyreplace(HatredOld#st_hatred.pid, #st_hatred.pid, List, HatredOld#st_hatred{hurt = HatredOld#st_hatred.hurt + Hurt});
                                false ->
                                    List1 = lists:keyreplace(HatredOld#st_hatred.pid, #st_hatred.pid, List, Hatred#st_hatred{hurt = HatredOld#st_hatred.hurt + Hurt})
                            end,
                            sort_klist(T, List1)
                    end;
                false ->
                    sort_klist(T, [Hatred | List])
            end;
        false ->
            sort_klist(T, [Hatred | List])
    end.

get_mon_name(MonId) ->
    case data_mon:get(MonId) of
        [] -> <<>>;
        Mon -> Mon#mon.name
    end.

%%匹配boss
match_boss(MonList, Lv) ->
    F = fun(MonId) ->
        case data_mon:get(MonId) of
            [] -> [];
            Mon ->
                if Mon#mon.lv >= Lv -> [MonId];
                    true ->
                        []
                end
        end
    end,
    case lists:flatmap(F, MonList) of
        [] ->
            case config:get_open_days() > 7 of
                false ->
                    hd(MonList);
                true ->
                    lists:last(MonList)
            end;
        Ids ->
            hd(Ids)
    end.
