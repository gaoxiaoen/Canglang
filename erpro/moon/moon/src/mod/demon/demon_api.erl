%%---------------------------------------------
%% 精灵守护(侍宠)系统
%% @author wpf(wprehard@qq.com)
%% @end
%%---------------------------------------------

-module(demon_api).
-export([
        pack_and_send/3
        ,attr_to_int/1
        ,int_to_attr/1
        ,calc/1
        ,get_demon_lev/1
        ,get_combat_skills/1
        ,get_shape_combat_info/1
        ,fix/2
        ,push_demon/1
        ,push_demon/2
        ,push_debris/1
        ,push_debris/2
        ,reset/1
        ,deal_add_buff/1
        ,deal_del_buff/2
        ,refresh_role_special/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("demon.hrl").
-include("item.hrl").
-include("buff.hrl").

%% @spec push_demon(Role) -> ok
%% @doc 推送全部召唤的兽的信息
push_demon(#role{id = {Rid, _}, link = #link{conn_pid = ConnPid}, demon = #role_demon{active = Active, bag = Bag, skill_polish = Devours}}) ->
    AllDemonBaseIds = demon_debris_mgr:get_role_demon(Rid),
    case is_record(Active, demon2) of 
        true ->
            % sys_conn:pack_send(ConnPid, 17235, {demon_list_to_client([attr_ratio_add(Active)|Bag], []), AllDemonBaseIds}),
            sys_conn:pack_send(ConnPid, 17235, {demon_list_to_client([Active|Bag], Devours, []), AllDemonBaseIds}),
            ok;
        false ->
            sys_conn:pack_send(ConnPid, 17235, {demon_list_to_client(Bag, Devours, []), AllDemonBaseIds}),
            ok
    end.

%% @spec push_demon(Role, Demon) -> ok
%% @doc 推送具体某一只兽的信息
push_demon(#role{link = #link{conn_pid = ConnPid}, demon = #role_demon{skill_polish = Devours}}, Demon) ->
    sys_conn:pack_send(ConnPid, 17241, demon_to_client(Demon, Devours)),
    ok.

%%碎片变化时推送
push_debris(#role{link = #link{conn_pid = ConnPid}, demon = #role_demon{shape_skills = NDebris}}) ->
    sys_conn:pack_send(ConnPid, 17240, {NDebris}),
    ok.
push_debris(_Role = #role{demon = #role_demon{shape_skills = Debris}}, _NRole = #role{link = #link{conn_pid = ConnPid}, demon = #role_demon{shape_skills = NDebris}}) ->
    Debris1 = NDebris -- Debris,
    sys_conn:pack_send(ConnPid, 17240, {Debris1}),
    ok.

%% @spec refresh_role_special(Role) ->ok.
%% @doc 刷新角色special信息
refresh_role_special(Role = #role{event = Event, id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}, special = Special}) ->
    case Event =:= ?event_wanted orelse Event =:= ?event_tree of 
        true ->
            sys_conn:pack_send(ConnPid, 10119, {Rid, SrvId, Special});
        _ -> 
            map:role_update(Role)
    end,
    ok.

%% @spec reset(Demon) -> NDemon 
%% @doc 重新计算兽的属性
reset(Demon) when is_record(Demon, demon2)->
    BaseId    = Demon#demon2.base_id,
    Lev       = Demon#demon2.lev,
    Grow      = Demon#demon2.grow,
    ExtAttr   = Demon#demon2.ext_attr,

    Init_Attr = demon_data2:get_demon_init_attr(BaseId),
    Base_Attr = demon_data2:get_demon_base_attr(BaseId),
    Parm      = 1.1 + math:pow((Grow - 1), 1.15) * 0.15, %% m=1.1+(（n-1）^1.15)*0.15
    NewAttr   = calc_new_attr(Init_Attr, Lev, Base_Attr, Parm),
    NSkill    = calc_new_skill(Grow, BaseId),
    NDemon    = Demon#demon2{attr = NewAttr, skills = NSkill},

    ExtAttr1  = role_attr:trans_atrrs(ExtAttr),
    {ok, NDe} = do(ExtAttr1, NDemon),

    attr_ratio_add(NDe);
reset(Demon) ->
    Demon.

%% @spec deal_add_buff(Role, Demon) -> {NRole, NDemon, true|false}
%% @doc 添加Buff到妖精以及人物身上
deal_add_buff(Role = #role{demon = RoleDemon = #role_demon{active = Demon = #demon2{skills = Skills}}}) ->
    Buffs = [SkillId || SkillId <-Skills, is_atom(SkillId) == true],
    case erlang:length(Buffs) > 0 of 
        true ->
            NewRole   = buff_to_role(add, Role, Buffs),
            NewDemon  = buff_to_demon(add, Demon, Buffs),
            NewDemon1 = attr_ratio_add(NewDemon),
            NewRole1  = NewRole#role{demon = RoleDemon#role_demon{active = NewDemon}},
            {NewRole1, NewDemon1, true}; %% 不能存NewDemon1,NewDemon1只是用于显示
        false ->
            {Role, Demon, false}
    end.

%% @spec deal_del_buff(Role, Demon) -> {NRole, NDemon, true|false}
%% @doc 减去妖精以及人物身上的Buff
deal_del_buff(Role = #role{demon = #role_demon{bag = Bag}}, Demon = #demon2{id = Id, skills = Skills}) ->
    Buffs = [SkillId || SkillId <-Skills, is_atom(SkillId) == true],
    case erlang:length(Buffs) > 0 of 
        true -> 
            NewRole   = #role{demon = RoleDemon = #role_demon{bag = Bag}} = buff_to_role(del, Role, Buffs),
            NewDemon  = buff_to_demon(del, Demon, Buffs),
            NewDemon1 = attr_ratio_add(NewDemon),
            NBag      = lists:keydelete(Id, #demon2.id, Bag),
            NBag1     = [NewDemon] ++ NBag,
            NewRole1  = NewRole#role{demon = RoleDemon#role_demon{bag = NBag1}},
            {NewRole1, NewDemon1, true}; %% 不能存NewDemon1,NewDemon1只是用于显示
        false ->
            {Role, Demon, false}
    end;

%% is_record(Demon, demon2) == false
deal_del_buff(Role = #role{}, Demon) -> 
    {Role, Demon, false}.

attr_ratio_add(Demon = #demon2{attr = Attr = #demon_attr{
            dmg         = Dmg, 
            critrate    = Critrate, 
            hp_max      = Hp_max, 
            mp_max      = Mp_max,
            defence     = Defence, 
            tenacity    = Tenacity, 
            evasion     = Evasion, 
            hitrate     = Hitrate
            }, 
        ratio = #demon_ratio{
            dmg_per        = Dmg_per,
            critrate_per   = Critrate_per,
            hp_max_per     = Hp_max_per,
            mp_max_per     = Mp_max_per,
            defence_per    = Defence_per,
            tenacity_per   = Tenacity_per,
            evasion_per    = Evasion_per,
            hitrate_per    = Hitrate_per
        }}) ->
    Demon#demon2{attr = Attr#demon_attr{
          dmg       = erlang:round(Dmg * Dmg_per / 100),
          critrate  = erlang:round(Critrate * Critrate_per / 100),
          hp_max    = erlang:round(Hp_max * Hp_max_per / 100),
          mp_max    = erlang:round(Mp_max * Mp_max_per / 100),
          defence   = erlang:round(Defence * Defence_per / 100),
          tenacity  = erlang:round(Tenacity * Tenacity_per / 100),
          evasion   = erlang:round(Evasion * Evasion_per / 100),
          hitrate   = erlang:round(Hitrate * Hitrate_per / 100)
    }}.

%% @spec pack_and_send(Cmd, Data, Role) -> any()
%% @doc 组装协议发送
pack_and_send(17200, #role_demon{active = ActId, bag = Demons, exp = Exp, step = Step}, #role{link = #link{conn_pid = ConnPid}}) ->
    ExpNeed = round(demon_data:get_exp(Step)),
    Msg = {ActId, Step, Exp, ExpNeed, attr_convert_demon(Demons, [])},
    sys_conn:pack_send(ConnPid, 17200, Msg);
pack_and_send(17201, #demon{id = Did, name = Name, craft = Craft, attr = Attr, skills = Skills, intimacy = Inti, shape_lev = ShapeLev, shape_luck = ShapeLuck}, #role{link = #link{conn_pid = ConnPid}}) ->
    Msg = {Did, Name, Craft, attr_convert(Attr, []), Skills, Inti, ShapeLev, ShapeLuck},
    sys_conn:pack_send(ConnPid, 17201, Msg);
pack_and_send(17202, #role_demon{active = ActId, exp = Exp, step = Step}, #role{link = #link{conn_pid = ConnPid}}) ->
    ExpNeed = demon_data:get_exp(Step),
    Msg = {ActId, Step, Exp, ExpNeed},
    sys_conn:pack_send(ConnPid, 17202, Msg);
pack_and_send(17205, #role_demon{exp = Exp, step = Step, bag = Demons}, ConnPid) ->
    ExpNeed = case Step =:= 0 of
        true -> 0;
        false -> round(demon_data:get_exp(Step))
    end,
    Msg = {Step, Exp, ExpNeed, attr_convert_demon(Demons, [])},
    sys_conn:pack_send(ConnPid, 17205, Msg);
pack_and_send(17213, {Num, Step, NewStep}, #role{link = #link{conn_pid = ConnPid}}) ->
    Msg = case Step =:= NewStep of
        true -> 
            {?true, util:fbin(?L(<<"吞噬守护水晶~w个，精灵守护提升经验值~w点">>), [Num, ?STEP_EXP_STEP_SIZE*Num])};
        false ->
            {?true, util:fbin(?L(<<"成功吞噬，精灵守护提升至~w阶">>), [NewStep])}
    end,
    sys_conn:pack_send(ConnPid, 17213, Msg);
pack_and_send(17210, #demon{id = Did, name = Name}, #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 17210, {Did, ?true, util:fbin(?L(<<"成功激活 ~s">>), [Name])});
%% 批量洗髓列表
pack_and_send(17220, PolishList, #role{link = #link{conn_pid = ConnPid}}) ->
    L = [{N, C, attr_convert(AFC, [])} || {N, C, AFC} <- PolishList],
    sys_conn:pack_send(ConnPid, 17220, {?true, <<>>, L});
%% 技能刷新列表
pack_and_send(17225, #role_demon{luck_coin = LuckC, luck_gold = LuckG, skill_polish = IdList}, #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 17225, {?true, <<>>, LuckC, LuckG, IdList});
%% 守护技能背包刷新
pack_and_send(17228, NewSkillBag, #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 17228, {NewSkillBag});
pack_and_send(_Cmd, _Data, _) ->
    ?ERR("错误的数据大包发送请求:~w", [{_Cmd, _Data}]),
    ok.

%% @spec attr_to_int(AttrAtom) -> integer()
%% 属性转换
attr_to_int(hp_max) ->      1;
attr_to_int(mp_max) ->      2;
attr_to_int(dmg) ->         3;
attr_to_int(defence) ->     4;
attr_to_int(evasion) ->     5;
attr_to_int(hitrate) ->     6;
attr_to_int(critrate) ->    7;
attr_to_int(tenacity) ->    8;
attr_to_int(dmg_magic) ->   9;
attr_to_int(resist_metal) ->10;
attr_to_int(resist_wood) -> 11;
attr_to_int(resist_water) ->12;
attr_to_int(resist_fire) -> 13;
attr_to_int(resist_earth) ->14;
attr_to_int(_) -> 0.

%% @spec int_to_attr(AttrAtom) -> integer()
%% 属性转换
int_to_attr(1) -> hp_max;
int_to_attr(2) -> mp_max;
int_to_attr(3) -> dmg;
int_to_attr(4) -> defence;
int_to_attr(5) -> evasion;
int_to_attr(6) -> hitrate;
int_to_attr(7) -> critrate;
int_to_attr(8) -> tenacity;
int_to_attr(9) -> dmg_magic;
int_to_attr(10) -> resist_metal;
int_to_attr(11) -> resist_wood;
int_to_attr(12) -> resist_water;
int_to_attr(13) -> resist_fire;
int_to_attr(14) -> resist_earth;
int_to_attr(_) -> null.

%% @spec calc(Role) -> NewRole
%% @doc 计算属性附加
calc(Role = #role{demon = #role_demon{attr = AL}}) ->
    % Fun = fun({A, _C, V, _Lock}) ->
    %         {A, V};
    %     ({A, _C, V}) ->
    %         {A, V}
    % end,
    % TmpAL = [Fun(X) || X <- AL],
    % case role_attr:do_attr(TmpAL, Role) of
    AL1 = role_attr:trans_atrrs(AL),
    case role_attr:do_attr(AL1, Role) of
        {false, _} -> Role;
        {ok, NewRole} -> NewRole
    end.

%% @spec get_demon_lev(Role) -> integer()
%% 获取精灵守护等级
get_demon_lev(#role{demon = #role_demon{step = Step}}) ->
    Step.

%% @spec get_combat_skills(Role) -> lists()
%% @doc 获取守护战斗技能(以参数形式)
%% 返回 [false | {c_skill, CSkillId, TargetNum, Cd, Args, Buffs} | {pet_skill, PetSkillId, Args, BuffSelf, BuffTarget, Cd} | ...]
get_combat_skills(#role{demon = RoleDemon}) ->
    get_combat_skills(RoleDemon);
get_combat_skills(#role_demon{active = 0}) -> [];
get_combat_skills(#role_demon{active = ActId, bag = Demons}) ->
    case lists:keyfind(ActId, #demon.id, Demons) of
        false -> [];
        #demon{skills = SL} ->
            Fun = fun(Sid) ->
                    case demon_data:get_skill(Sid) of
                        #demon_skill{combat_info = 0, pet_info = PetSkill} -> PetSkill;
                        #demon_skill{combat_info = CombatSkill} -> CombatSkill;
                        _ -> false
                    end
            end,
            [Fun(Sid) || {Sid, _, _} <- SL]
    end.

%% @spec get_shape_combat_info(Role) -> {Dmg, DmgMagic, SkillId}
%% Role = #role{} | #role_demon{}
%% Dmg = MaigcDmg = SkillId = integer()
%% @doc 获取精灵守护的化形相关战斗数据
get_shape_combat_info(#role{demon = RoleDemon}) ->
    get_shape_combat_info(RoleDemon);
get_shape_combat_info(#role_demon{active = 0}) ->
    {0, 0, 0};
get_shape_combat_info(#role_demon{attr = AL, shape_skills = Skills, shape_lev = ShapeLev}) ->
    Skill = case Skills of
        [One | _] -> One;
        _ -> 0
    end,
    Dmg = case lists:keyfind(dmg, 1, AL) of
        {_, _, V, _} when ShapeLev =:= 10 -> round(V * 4);
        {_, _, V, _} when ShapeLev =:= 9 -> round(V * 3.5);
        {_, _, V, _} when ShapeLev =:= 8 -> round(V * 3.1);
        {_, _, V, _} when ShapeLev =:= 7 -> round(V * 2.7);
        {_, _, V, _} when ShapeLev =:= 6 -> round(V * 2.3);
        {_, _, V, _} when ShapeLev =:= 5 -> round(V * 2);
        {_, _, V, _} when ShapeLev =:= 4 -> round(V * 1.7);
        {_, _, V, _} when ShapeLev =:= 3 -> round(V * 1.4);
        {_, _, V, _} when ShapeLev =:= 2 -> round(V * 1.2);
        {_, _, V, _} when ShapeLev =:= 1 -> round(V);
        _ -> 0
    end,
    DmgMagic = case lists:keyfind(dmg_magic, 1, AL) of
        {_, _, MV, _} when ShapeLev =:= 10 -> round(MV * 4);
        {_, _, MV, _} when ShapeLev =:= 9 -> round(MV * 3.5);
        {_, _, MV, _} when ShapeLev =:= 8 -> round(MV * 3.1);
        {_, _, MV, _} when ShapeLev =:= 7 -> round(MV * 2.7);
        {_, _, MV, _} when ShapeLev =:= 6 -> round(MV * 2.3);
        {_, _, MV, _} when ShapeLev =:= 5 -> round(MV * 2);
        {_, _, MV, _} when ShapeLev =:= 4 -> round(MV * 1.7);
        {_, _, MV, _} when ShapeLev =:= 3 -> round(MV * 1.4);
        {_, _, MV, _} when ShapeLev =:= 2 -> round(MV * 1.2);
        {_, _, MV, _} when ShapeLev =:= 1 -> round(MV);
        _ -> 0
    end,
    {Dmg, DmgMagic, Skill}.

%% --------------------------------------------
%% 后台修复
%% --------------------------------------------
%% 修复
fix(follow, RoleId) ->
    case role_api:lookup(by_id, RoleId, #role.pid) of
        {ok, _, RolePid} ->
            role:apply(async, RolePid, {fun fix_follow/1, []});
        _ -> ?INFO("玩家不在线")
    end.
%% 守护跟随buff在竞技场结束时没有清除跟随looks的bug
fix_follow(Role) ->
    NewRole = demon:unfollow(Role),
    map:role_update(NewRole),
    {ok, NewRole}.

%% --------------------------------------------
%% 内部函数
%% --------------------------------------------

attr_convert([], L) -> L;
attr_convert([{A, C, V, Lock} | T], L) ->
    attr_convert(T, [{attr_to_int(A), C, V, Lock} | L]).

attr_convert_demon([], L) -> L;
attr_convert_demon([D = #demon{attr = Attr} | T], L) ->
    attr_convert_demon(T, [D#demon{attr = attr_convert(Attr, [])} | L]).

%%计算新属性值
calc_new_attr(Init_Attr, Lev, Base_Attr, Parm) ->
    do_calc(Init_Attr, Lev, Base_Attr, Parm, #demon_attr{}).

do_calc([], _Lev, _Base_Attr, _Parm, NewAttr) ->  NewAttr;

do_calc([{?attr_dmg, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Dmg = value({?attr_dmg, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{dmg = Dmg});

do_calc([{?attr_critrate, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Critrate = value({?attr_critrate, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{critrate = Critrate});

do_calc([{?attr_hp_max, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Hp_max = value({?attr_hp_max, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{hp_max = Hp_max});

do_calc([{?attr_mp_max, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Mp_max = value({?attr_mp_max, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{mp_max = Mp_max});

do_calc([{?attr_defence, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Defence = value({?attr_defence, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{defence = Defence});

do_calc([{?attr_tenacity, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Tenacity = value({?attr_tenacity, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{tenacity = Tenacity});

do_calc([{?attr_evasion, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Evasion = value({?attr_evasion, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{evasion = Evasion});

do_calc([{?attr_hitrate, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Hitrate = value({?attr_hitrate, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{hitrate = Hitrate});

do_calc([{?attr_dmg_magic, Init_Val}|T], Lev, Base_Attr, Parm, NewAttr) ->
    Dmg_magic = value({?attr_dmg_magic, Init_Val}, Lev, Base_Attr, Parm),
    do_calc(T, Lev, Base_Attr, Parm, NewAttr#demon_attr{dmg_magic = Dmg_magic}).

%% @doc 计算2级属性的值
%% @doc 二级属性（具体属性）数值=该属性初始数值+（（等级数*20）+m值）*m值*x属性系数
value({Attr, Init_Val}, Lev, Base_Attr, _M) ->
    case lists:keyfind(Attr, 1, Base_Attr) of 
        {_, X} ->
            % erlang:round(Init_Val + ((Lev * 20) + M) * M * X); 
            erlang:round(Init_Val + Lev * X); 
        false ->
            Init_Val
    end.

%% @spec calc_new_skill(Grow, BaseId) -> ::list
%% @doc 计算新的技能个数
calc_new_skill(Grow, BaseId) ->
    ASkills = demon_grow_bless:get_grow_skill_list(),
    Great = [{GrowValue, Num}||{GrowValue, Num} <- ASkills, Grow >= GrowValue],
    case Great of 
        [] -> [];
        _ ->
            SortedGreat = lists:keysort(1, Great),
            {_, SkillNum} = lists:last(SortedGreat),
            case demon_data2:get_demon_base(BaseId) of 
                {ok, #demon2{skills = Skills}} ->
                    lists:sublist(Skills, SkillNum);
                _ -> []
            end
    end.

%% @spec buff_to_role(Label, Role, Buff) -> NewRole;
%% @doc 添加 / 减去妖精buff 到人物身上  
buff_to_role(add, Role, []) -> Role;
buff_to_role(add, Role, [H|T]) -> 
    case buff:add(Role, H) of 
        {ok, NewRole} ->
            buff_to_role(add, NewRole, T);
        {false, _Reason} ->
            ?DEBUG("添加buff出错~n~n"),
            buff_to_role(add, Role, T)
    end;

buff_to_role(del, Role, []) -> Role;
buff_to_role(del, Role, [H|T]) -> 
    case buff:del_buff_by_label_no_push(Role, H) of 
        {ok, NewRole} ->
            buff_to_role(del, NewRole, T);
        _ ->
            buff_to_role(del, Role, T)
    end.

%% @spec buff_to_demon(Label, Demon, Buff) -> NewDemon;
%% @doc 添加妖精buff 到妖精身上  
buff_to_demon(add, Demon, []) -> Demon;
buff_to_demon(add, Demon, [H|T]) -> 
    {ok, NewDemon} = buff_to_self(add, Demon, H),
    buff_to_demon(add, NewDemon, T);

buff_to_demon(del, Demon, []) -> Demon;
buff_to_demon(del, Demon, [H|T]) -> 
    {ok, NewDemon} = buff_to_self(del, Demon, H),
    buff_to_demon(del, NewDemon, T).


buff_to_self(add, Demon, Label) ->
    case buff_data:get(Label) of 
        {ok, #buff{effect = Effect}} -> %% 表示需要附加到战力的buff 
            do(Effect, Demon);
        _ ->
            {ok, Demon}
    end;

buff_to_self(del, Demon, Label) ->
    case buff_data:get(Label) of 
        {ok, #buff{effect = Effect}}-> %% 表示需要附加到战力的buff 
            Effect2 = [{Lable, -Val}||{Lable, Val}<-Effect], %% 负数时需要注意是否会使得相加后总值小于0！！！
            do(Effect2, Demon);
        _ ->
            {ok, Demon}
    end.

demon_list_to_client([], _Devours, Return) -> Return;
demon_list_to_client([Demon|T], Devours, Return) ->
    ProtoDemon = demon_to_client(Demon, Devours),
    demon_list_to_client(T, Devours, [ProtoDemon|Return]).

demon_to_client(_Demon = #demon2{id = Id, base_id = BaseId, name = Name, mod = Mod, debris = Debris, craft = Craft, lev = Lev, exp = Exp, grow = Grow, bless = Bless, 
        grow_max = GrowMax, attr = #demon_attr{dmg = Dmg, critrate = Critrate, hp_max = Hp_max, mp_max = Mp_max, defence = Defence,
        tenacity = Tenacity, evasion = Evasion, hitrate = Hitrate, dmg_magic = Dmg_magic}, skills = Skills}, Devours) ->
    {DevourId1, DevourId2} = 
        case lists:keyfind(Id, 1, Devours) of 
            {_, A, B} -> 
                {A, B};
            _ -> {0, 0}
        end,
    {Id, BaseId, Name, Mod, Craft, Debris, Lev, Exp, Grow, Bless, GrowMax, DevourId1, DevourId2, Dmg, Critrate, Hp_max, Mp_max, Defence, Tenacity, Evasion, Hitrate, round(Dmg_magic), skills_to_proto(Skills)}.

skills_to_proto(Skills) ->
    [get_buff_id(SkillId) || SkillId <- Skills].


%%根据 buff名称获取buffId, 技能id则直接返回
get_buff_id(SkillId) when is_integer(SkillId)->
    SkillId;
get_buff_id(SkillId) when is_atom(SkillId) ->
    demon_data2:get_buff_id(SkillId);
get_buff_id(_) -> 0.

%% @spec do(Effect, Demon) -> {ok, NewDemon} 
%% @doc 添加Buff加值效果
%% Effect = list()  BUFF效果配置数据
%% Demon = NewDemon = #demon2{} 角色数据
do([], Demon) -> {ok, Demon};
do([H | T], Demon) ->
    {ok, NewDemon} = do(H, Demon),
    do(T, NewDemon);

%% 增加气血上限
do({hp_max, Val},  Demon = #demon2{attr = Attr = #demon_attr{hp_max = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{hp_max = V + Val}}};

%% 增加法术上限
do({mp_max, Val},  Demon = #demon2{attr = Attr = #demon_attr{mp_max = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{mp_max = V + Val}}};

%% 增加攻击力
do({dmg, Val},  Demon = #demon2{attr = Attr = #demon_attr{dmg = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{dmg = Val + V}}};

%% 增加攻击力
do({dmg_magic, Val},  Demon = #demon2{attr = Attr = #demon_attr{dmg_magic = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{dmg_magic = Val + V}}};

%% 增加防御
do({defence, Val}, Demon = #demon2{attr = Attr = #demon_attr{defence = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{defence = Val + V}}};

%% 增加命中
do({hitrate, Val}, Demon = #demon2{attr = Attr = #demon_attr{hitrate = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{hitrate = Val + V}}};

%% 增加躲闪
do({evasion, Val}, Demon = #demon2{attr = Attr = #demon_attr{evasion = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{evasion = Val + V}}};

%% 增加暴击
do({critrate, Val}, Demon = #demon2{attr = Attr = #demon_attr{critrate = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{critrate = Val + V}}};

%% 增加坚韧
do({tenacity, Val}, Demon = #demon2{attr = Attr = #demon_attr{tenacity = V}}) ->
    {ok, Demon#demon2{attr = Attr#demon_attr{tenacity = Val + V}}};


%% 加气血上限百分比
do({hp_max_per, Val}, Demon = #demon2{ratio = Ratio = #demon_ratio{hp_max_per = V}}) ->
    {ok, Demon#demon2{ratio = Ratio#demon_ratio{hp_max_per = Val + V}}};

%% 加法力上限百分比
do({mp_max_per, Val}, Demon = #demon2{ratio = Ratio = #demon_ratio{mp_max_per = V}}) ->
    {ok, Demon#demon2{ratio = Ratio#demon_ratio{mp_max_per = Val + V}}};

%% 加命中百分比
do({hitrate_per, Val}, Demon = #demon2{ratio = Ratio = #demon_ratio{hitrate_per = V}}) ->
    {ok, Demon#demon2{ratio = Ratio#demon_ratio{hitrate_per = Val + V}}};

%% 加躲闪百分比
do({evasion_per, Val}, Demon = #demon2{ratio = Ratio = #demon_ratio{evasion_per = V}}) ->
    {ok, Demon#demon2{ratio = Ratio#demon_ratio{evasion_per = Val + V}}};

%% 加防御百分比
do({df_max_per, Val}, Demon = #demon2{ratio = Ratio = #demon_ratio{defence_per = V}}) ->
    {ok, Demon#demon2{ratio = Ratio#demon_ratio{defence_per = Val + V}}};

%% 加攻击百分比
do({dmg_per, Val}, Demon = #demon2{ratio = Ratio = #demon_ratio{dmg_per = V}}) ->
    {ok, Demon#demon2{ratio = Ratio#demon_ratio{dmg_per = Val + V}}};

%% 增加坚韧百分比
do({tenacity_per, Val}, Demon = #demon2{ratio = Ratio = #demon_ratio{tenacity_per = V}}) ->
    {ok, Demon#demon2{ratio = Ratio#demon_ratio{tenacity_per = Val + V}}};

%% 增加暴击百分比
do({critrate_per, Val}, Demon = #demon2{ratio = Ratio = #demon_ratio{critrate_per = V}}) ->
    {ok, Demon#demon2{ratio = Ratio#demon_ratio{critrate_per = Val + V}}};

% %% 匹配处理
% do_ratio(_, Role) ->
%     {skip, Role}.

%% 匹配处理
do(_Eff, Demon) ->
    {ok, Demon}.

%% -------------------------------------------------------------------------
%% @spec do(Effect, Role) -> {ok, NewRole} | {false, Reason}
%% @doc 添加Buff百分比加成效果
%% Effect = list()  BUFF效果配置数据
%% Role = NewRole = #role{} 角色数据
%% Reason = binary() 处理失败原因
% do_ratio([], Role) -> {ok, Role};
% do_ratio([H | T], Role) ->
%     case do_ratio(H, Role) of
%         {skip, NewRole} -> do_ratio(T, NewRole);
%         {ok, NewRole} -> do_ratio(T, NewRole);
%         {false, Reason} -> {false, Reason}
%     end;

