%%----------------------------------------------------
%% 宠物数据处理 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(pet_api).
-export([
        can_catch/2
        ,is_capturable_npc/1
        ,add/2
        ,get_max/2
        ,list_pets/1
        ,get_pet/2
        ,broadcast_pet/2
        ,push_pet/3
        ,push_pet2/2
        ,update_skill/2
        ,get_new_skill/2
        ,list_to_client/2
        ,pet_to_client/1
        ,pet_to_client1/1
        ,pet_to_client2/1
        ,wash_batch_to_client/1
        ,double_talent_to_client/1
        ,open_double_talent/2
        ,change_double_talent/4
        ,del_double_talent_cd/2
        ,update_double_talent/1
        ,reset_all/1
        ,reset/2
        % ,reset2/3
        ,calc_fight_capacity/1
        ,upgrage/2
        ,feed/2
        ,skill_join/4
        ,rand_pet_list/1
        ,rand_pet_list/2
        % ,asc_potential/4
        ,asc_potential/3
        ,grow/2
        ,set_sys_attr_per/2
        ,test_gm/3
        ,wash_batch/3
        ,do_sys_attr/2
        ,get_base_id/1
        ,active_power/1
        ,get_grow_type/1
        ,explore_batch/2
        ,explore/2
        ,buy_item/2
        ,get_pet_lev_exp/1
        ,asc_pet_exp/2
        ,add_eqm_attr_value/1
        ,add_eqm_attr_value/2
        ,update_next_max/1
        ,get_slot/1
        ,calc_eqm_fight_capacity/1
        ,calc_potential_fight/1
        ,do_calc_skill_fighting/2
        ,deal_buff_skill/3
        ,update_next_max2/1
    ]
).

-include("common.hrl").
-include("pet.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("looks.hrl").
%%

%%获取宠物等级经验下一级经验值
get_pet_lev_exp(#pet{exp = Exp ,lev = Lev}) ->
    NeedExp = pet_data_exp:get(Lev + 1),
    {Lev, Exp, NeedExp}.

%%宠物加经验
% asc_pet_exp(Role, AddExp) -> NRole :: #role{}
% Role :: #role{}
% AddExp :: number()
asc_pet_exp(Role = #role{pet = #pet_bag{active = undefined}}, _GainExp) ->
    Role;
asc_pet_exp(Role = #role{link = #link{conn_pid = ConnPid}, lev = RLev, pet = PetBag = #pet_bag{active = Pet = #pet{exp = Exp, lev = Lev}}}, GainExp) 
    when is_record(Pet, pet) ->
    case Lev > RLev of 
        true ->
            Role;
        false ->
            case GainExp > 0 of 
                true ->
                    case calc_new_lev_exp({Lev, Exp}, GainExp, RLev) of 
                        {Lev, NewExp} ->
                            NeedExp = pet_data_exp:get(Lev),
                            sys_conn:pack_send(ConnPid, 12618, {Lev, NewExp, NeedExp, 0}), %%当前等级，当前经验值，升级需要的经验值, 0表示不需要升阶
                            Role#role{pet = PetBag#pet_bag{active = Pet#pet{exp = NewExp}}};
                        {NewLev, NewExp} ->
                            NeedExp = 
                                case pet_data_exp:get(NewLev) of
                                    0 ->
                                        notice:alert(succ, ConnPid, ?MSGID(<<"恭喜你，小伙伴满级啦^_^">>)),
                                        0;
                                    Need -> 
                                        Need
                                end,

                            NPet0         = Pet#pet{exp = NewExp, lev = NewLev},
                            {NPet, NextMax}  = update_next_max(NPet0),
                            sys_conn:pack_send(ConnPid, 12618, {NewLev, NewExp, NeedExp, NextMax}), %% Step表示新的阶

                            NRole         = Role#role{pet = PetBag#pet_bag{active = NPet}},
                            NR            = reset(NPet, NRole),
                            push_pet2(refresh, NR),
                            medal:listener(dragon_level, NR)
                    end;
                false ->
                    Role
            end
    end.

calc_new_lev_exp({CurLev, CurExp}, GainExp, RLev) ->
    CurNeedExp = pet_data_exp:get(CurLev),
    case CurLev =:= RLev of 
        true ->
            case GainExp >= CurNeedExp - CurExp of 
                true ->
                    {CurLev, CurNeedExp - 1};
                false ->
                    {CurLev, GainExp + CurExp}
            end;
        false ->
            case GainExp >= CurNeedExp - CurExp of 
                true ->
                    case pet_data_exp:get(CurLev + 1) of 
                        0 ->
                            {CurLev + 1, 0};
                        _ ->
                            calc_new_lev_exp({CurLev + 1, 0}, GainExp - (CurNeedExp - CurExp), RLev)
                    end;
                false ->
                    {CurLev, GainExp + CurExp}
            end
    end.


%% 获取出战宠物战斗力
active_power(#role{pet = #pet_bag{active = #pet{fight_capacity = FC}}}) -> FC;
active_power(#pet_bag{active = #pet{fight_capacity = FC}}) -> FC;
active_power(#pet{fight_capacity = FC}) -> FC;
active_power(_) -> 0.

%% GM测试
test_gm(attr_sys, _Role, Type) ->
    MR = rand_attr_sys_per(Type),
    rand_sys_per(MR).

%% 获取宠物场境外观
get_base_id(Pet = #pet{base_id = BaseId, skin_id = SkinId, skin_grade = Grade}) ->
    case pet_buff:get_buff_base_id(Pet) of
        BuffBaseId when is_integer(BuffBaseId) -> 
            pet_data:get_next_baseid(Grade, BuffBaseId);
        _ ->
            case SkinId =:= 0 of
                true -> BaseId;
                false -> SkinId
            end
    end.

%% 判断当前状态下是否可捉NPC仙宠
%% Role = #role{}
%% NpcBaseId = integer()
%% @spec can_catch(Role, NpcBaseId) -> true | {false, full} | false
can_catch(Role = #role{pet = #pet_bag{pet_limit_num = PLN}}, NpcBaseId) ->
    case length(list_pets(Role)) < PLN of
        false -> {false, full};
        true ->
            is_capturable_npc(NpcBaseId)
    end;
%% 判断当前状态是否可捉NPC仙宠
%% PetNum = 1 | 0
%% NpcBaseId = integer()
%% @spec can_catch(Role, NpcBaseId) -> true | {false, full} | false
can_catch(1, NpcBaseId) ->
    is_capturable_npc(NpcBaseId);
can_catch(_, _NpcBaseId) ->
    {false, full}.

%% 判断是否可以捕捉的NPC
%% NpcBaseId = integer()
%% @spec is_capturable_npc(NpcBaseId) -> true | false
is_capturable_npc(NpcBaseId) ->
    case pet_data:get_from_npc(NpcBaseId) of
        {ok, #pet_base{}} -> true;
        _ -> false
    end.

%% 增加仙宠到宠物背包
%% @spec add(Pet, Role) -> {false, Reason} | {ok, NewRole}
%% Pet = #pet{}
%% Role = NewRole = #role{}
add(#pet{base_id = _BaseId}, #role{pet = _PetBag = #pet_bag{active = Pet}}) when is_record(Pet,pet)->
    {false, ?MSGID(<<"已经有一个伙伴啦！！">>)};
add(Pet = #pet{base_id = _BaseId}, Role = #role{pet = PetBag = #pet_bag{active = undefined}}) when is_record(Pet,pet)->
    {ok,Role#role{pet = PetBag#pet_bag{active = Pet}}}. 

% add(Pet = #pet{base_id = BaseId}, Role = #role{pet = PetBag = #pet_bag{next_id = Id, pets = Pets, pet_limit_num = PLN}}) ->
%     case length(list_pets(Role)) < PLN of
%         false -> {false, ?L(<<"玩家宠物个数已是最大值">>)};
%         true ->
%             [NewPet0] = pet_ex:init_cloud_attr([Pet#pet{id = Id, skin_id = BaseId}], PetBag, []),
%             NRole = #role{pet = NPetBag} = pet_ex:update_skin_and_push(Role, NewPet0),
%             NewPet = reset(NewPet0, NRole),
%             push_pet(add, [NewPet], Role),
%             NewPetBag = NPetBag#pet_bag{next_id = Id + 1, pets = [NewPet | Pets]},
%             {ok, NRole#role{pet = NewPetBag}}
%     end.

%% 返回指定键值最大的宠物
get_max(Key, Role) ->
    case list_pets(Role) of
        [] -> false;
        Pets ->
            SortPets = lists:keysort(Key, Pets),
            [Pet | _] = lists:reverse(SortPets),
            Pet 
    end.

%% 获取当前所有宠物列表
%% @spec list_pets(Role) -> Pets 
%% Role = #role{}
%% Pets = [#pet{}]
list_pets(#role{pet = #pet_bag{active = undefined, pets = Pets, deposit = {0, _, _}}}) -> Pets;
list_pets(#role{pet = #pet_bag{active = undefined, pets = Pets, deposit = {Pet, _, _}}}) -> [Pet | Pets];
list_pets(#role{pet = #pet_bag{active = WarPet, pets = Pets, deposit = {0, _, _}}}) -> [WarPet | Pets];
list_pets(#role{pet = #pet_bag{active = WarPet, pets = Pets, deposit = {Pet, _, _}}}) -> [WarPet, Pet | Pets].

%%获取宠物，仅有一只宠物 by bwang
get_pet(PetId, #role{pet = #pet_bag{active = Pet = #pet{id = PetId}}}) -> Pet;
get_pet(_PetId, #role{pet = #pet_bag{active = undefined}}) -> false.



%% 广播宠物数据
broadcast_pet(#pet{base_id = _BaseId, name = _Name}, Role = #role{special = _Special}) -> %% 有宠物
    ?DEBUG("------NRole Sepcial----~p~n~n~n~n", [_Special]),
    map:role_update(Role),
    Role.


%% 宠物进化推送
push_pet(evolve, #pet{id = Id, evolve = Evo, base_id = BaseId}, #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 12637, {Id, Evo, pet_data:baseid_type(BaseId), pet_data:get_next_baseid(0, BaseId), pet_data:get_next_baseid(1, BaseId), pet_data:get_next_baseid(2, BaseId), pet_data:get_next_baseid(3, BaseId)});
%% 重新推送某仙宠数据
push_pet(refresh, Pets, #role{link = #link{conn_pid = ConnPid}}) when length(Pets) > 0 ->
    ReList = list_to_client(Pets, []),
    sys_conn:pack_send(ConnPid, 12630, {ReList});
%% 更新双天赋面板  
push_pet(double_talent, Pet = #pet{id = Id}, #role{link = #link{conn_pid = ConnPid}}) ->
    {Switch, UseId, CoolDown, AttrList} = double_talent_to_client(Pet),
    sys_conn:pack_send(ConnPid, 12642, {1, <<>>, Id, Switch, UseId, CoolDown, AttrList});
%% 重新推送刷新仙宠蛋数据
push_pet(refresh_egg, Pets, #role{link = #link{conn_pid = ConnPid}}) ->
    ReList = list_to_client(Pets, []),
    sys_conn:pack_send(ConnPid, 12634, {ReList});
%% 推送新增宠物数据
push_pet(add, Pets, #role{link = #link{conn_pid = ConnPid}}) ->
    DelList = list_to_client(Pets, []),
    sys_conn:pack_send(ConnPid, 12631, {DelList});
%% 推送删除宠物数据
push_pet(del, IdList, #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 12632, {IdList});
%% 重新推送某宠物的部分属性
push_pet(attr, #pet{id = Id, name = Name, happy_val = HV, exp = Exp, skill_num = SN, mod = Mod, bind = Bind}, #role{link = #link{conn_pid = ConnPid}}) -> 
    sys_conn:pack_send(ConnPid, 12633, {Id, Name, HV, SN, Exp, Mod, Bind});

%% 重新推送宠物BUFF数据
push_pet(pet_buff, _, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 12651, {pet_buff:to_client_buff_list(Role)});

%% 推送宠物其它数据
push_pet(other, #pet_bag{exp_time = ExpTime}, #role{link = #link{conn_pid = ConnPid}}) -> 
    sys_conn:pack_send(ConnPid, 12635, {ExpTime});
%% 推送删除宠物装备
push_pet(del_item, {#pet{id = PetId}, Items}, #role{link = #link{conn_pid = ConnPid}}) -> 
    ItemInfo = [{Id, Pos} || #item{id = Id, pos = Pos} <- Items],
    sys_conn:pack_send(ConnPid, 12668, {PetId, ItemInfo});
push_pet(add_item, {#pet{id = PetId}, Items}, #role{link = #link{conn_pid = ConnPid}}) -> 
    sys_conn:pack_send(ConnPid, 12669, {PetId, 1, Items});
push_pet(refresh_item, {#pet{id = PetId}, Items}, #role{link = #link{conn_pid = ConnPid}}) -> 
    sys_conn:pack_send(ConnPid, 12669, {PetId, 2, Items});
push_pet(_Label, _Arg, _Role) ->
    ok.

%%by bwang
push_pet2(refresh, #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = Pet}})->
    sys_conn:pack_send(ConnPid, 12630, pet_to_client2(Pet)).

%% 转换成客户端数据
list_to_client([], List) -> 
    List;
list_to_client([I | T], List) ->
    list_to_client(T, [pet_to_client(I) | List]).

%% 批洗结果转换成客户端数据
wash_batch_to_client(Pet = #pet{wash_list = WL}) ->
    wash_batch_to_client(Pet, WL, []).
wash_batch_to_client(_Pet, [], NewWL) -> NewWL;
wash_batch_to_client(Pet = #pet{attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq}}, [{NO, AttrSys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}} | T], NewWL) ->
    {XlSys, TzSys, JsSys, LqSys} = do_sys_attr(Xl + Tz + Js + Lq, AttrSys),
    SendInfo = {NO, XlSys, TzSys, JsSys, LqSys, XlPer, TzPer, JsPer, LqPer},
    wash_batch_to_client(Pet, T, [SendInfo | NewWL]).

double_talent_to_client(#pet{attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq}, double_talent = #pet_double_talent{switch = Switch, use_id = UseId, cooldown = CoolDown, attr_list = AttrList}}) ->
    NewAttrList = attr_list_to_client(Xl + Tz + Js + Lq, AttrList), 
    Time = case CoolDown of
        0 -> 0;
        _T ->
            case util:unixtime() - CoolDown >= 3600 of
                true -> 0;
                false -> (3600 - (util:unixtime() - CoolDown))
            end
    end,
    {Switch, UseId, Time, NewAttrList}. 

attr_list_to_client(Val, AttrList) ->
    case length(AttrList) =:= 1 of
        true ->
            attr_list_to_client(Val, [{2, #pet_attr_sys{xl_per = 25, tz_per = 25, js_per = 25, lq_per = 25}} | AttrList], []);
        false ->
            attr_list_to_client(Val, AttrList, [])
    end.
attr_list_to_client(_Val, [], NewAttrList) -> NewAttrList;
attr_list_to_client(Val, [{Id, AttrSys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}} | T], NewAttrList) ->
    {XlSys, TzSys, JsSys, LqSys} = do_sys_attr(Val, AttrSys),
    Data = {Id, XlSys, TzSys, JsSys, LqSys, XlPer, TzPer, JsPer, LqPer},
    attr_list_to_client(Val, T, [Data | NewAttrList]).

%% 发送到客户端的数据转换
pet_to_client(_Pet = #pet{id = Id, name = Name, type = Type, base_id = _BaseId, lev = Lev, mod = Mod, grow_val = GrowVal, happy_val = HappyVal, exp = Exp, eqm_num = EqmNum, attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq, xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal, dmg = Dmg, critrate = Cri, hp_max = HpMax, mp_max = MpMax, defence = Def, tenacity = Ten, hitrate = Hit, evasion = Eva, dmg_magic = DmgMagic, anti_js = AntiJs, anti_attack = Attack, anti_seal = Seal, anti_stone = Stone, anti_stun = Stun, anti_sleep = Sleep, anti_taunt = Taunt, anti_silent = Silent, anti_poison = Poison, blood = Blood, rebound = Rebound, resist_metal = Metal, resist_wood = Wood, resist_water = Water, resist_fire = Fire, resist_earth = Earth, xl_max = XlMax, tz_max = TzMax, js_max = JsMax, lq_max = LqMax}, attr_sys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}, skill = Skills, skill_num = SkillNum, fight_capacity = Power, bind = Bind, append_attr = AppendAttr, wish_val = Wish, ext_attr_limit = ExtAttrLimit, ascended = Ascended, ascend_num = AscendNum}) -> 
    %% NewSkills = [{SkillId, SkillExp} || {SkillId, SkillExp, _Args} <- Skills],
    ChangeType = case AppendAttr of
        [{CType, _} | _] -> CType;
        _ -> 0
    end,
    %% ?DEBUG("~w", [{XlMax, TzMax, JsMax, LqMax}]),
    {Id, Name, Type, get_base_id(_Pet), Lev, Mod, GrowVal, HappyVal, Exp, pet_data_exp:get(Lev), Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, XlPer, TzPer, JsPer, LqPer, SkillNum, Skills, Dmg, Cri, HpMax, MpMax, Def, Ten, Hit, Eva, Power, Bind, ChangeType, Wish, EqmNum, DmgMagic, AntiJs, Attack, Seal, Stone, Stun, Sleep, Taunt, Silent, Poison, Blood, Rebound, Metal, Wood, Water, Fire, Earth, XlMax, TzMax, JsMax, LqMax, ExtAttrLimit, Ascended, AscendNum, pet_attr:get_ascend_attr(AscendNum), pet_attr:get_ascend_attr(AscendNum + 1)}.

pet_to_client1(#pet{name = Name, base_id = BaseId, lev = Lev, exp = Exp, fight_capacity = Power, eqm_num = Eqm_num, eqm = Eqm,
         attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq, xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal, step = Step,
         dmg = Dmg, critrate = Cri, hp_max = HpMax, mp_max = MpMax, defence = Def,tenacity = Ten, hitrate = Hit, evasion = Eva}, 
          attr_sys = #pet_attr_sys{
         xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}, skill = Skill, skill_num = SkillNum}) -> 

    PetData = {Name, BaseId, Lev, Exp, pet_data_exp:get(Lev), Step, Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, 
            XlPer, TzPer, JsPer, LqPer, erlang:abs(SkillNum), Skill, Dmg, Cri, HpMax, MpMax, Def, Ten, Hit, Eva, Power, erlang:abs(Eqm_num), Eqm},
    PetData.

pet_to_client2(_Pet = #pet{
    attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq, dmg = Dmg, critrate = Cri, hp_max = HpMax, mp_max = MpMax, defence = Def,
    tenacity = Ten, hitrate = Hit, evasion = Eva}, 
    attr_sys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer},fight_capacity = Power}) -> 
    ?DEBUG("-----重新计算推送新的宠物战力----~p~n",[Power]),
    {   
        Xl, Tz, Js, Lq, XlPer,TzPer, JsPer, LqPer, Dmg,Cri, HpMax, MpMax, Def, Ten, Hit, Eva, Power
     }.


%% 重置所有宠物数据
reset_all(Role = #role{pet = PetBag = #pet_bag{active = ActPet = #pet{}, deposit = {DepPet = #pet{}, A, B}, pets = Pets}}) ->
    NewActPet = reset(ActPet, Role),
    NewDepPet = reset(DepPet, Role),
    NewPets = [reset(Pet, Role) || Pet <- Pets],
    push_pet(refresh, [NewActPet, NewDepPet | NewPets], Role),
    Role#role{pet = PetBag#pet_bag{active = NewActPet, deposit = {NewDepPet, A, B}, pets = NewPets}};
reset_all(Role = #role{pet = PetBag = #pet_bag{deposit = {DepPet = #pet{}, A, B}, pets = Pets}}) ->
    NewDepPet = reset(DepPet, Role),
    NewPets = [reset(Pet, Role) || Pet <- Pets],
    push_pet(refresh, [NewDepPet | NewPets], Role),
    Role#role{pet = PetBag#pet_bag{deposit = {NewDepPet, A, B}, pets = NewPets}};
reset_all(Role = #role{pet = PetBag = #pet_bag{active = ActPet = #pet{}, pets = Pets}}) ->
    NewActPet = reset(ActPet, Role),
    NewPets = [reset(Pet, Role) || Pet <- Pets],
    push_pet(refresh, [NewActPet | NewPets], Role),
    Role#role{pet = PetBag#pet_bag{active = NewActPet, pets = NewPets}};
reset_all(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) ->
    NewPets = [reset(Pet, Role) || Pet <- Pets],
    push_pet(refresh, NewPets, Role),
    Role#role{pet = PetBag#pet_bag{pets = NewPets}};
reset_all(Role) -> 
    Role.

%% 重新计算设置一个宠物
reset(Pet = #pet{lev = Lev, attr = Attr, attr_sys = AttrSys}, Role = #role{pet = PetBag}) ->
    {XlSys, TzSys, JsSys, LqSys} = do_sys_attr(Lev * 20, AttrSys), %%计算系统属性的分配，根据比例
    Avg = pet_attr:calc_avg_potential(Pet),
    NewPet = Pet#pet{attr = Attr#pet_attr{xl = XlSys, tz = TzSys, js = JsSys, lq = LqSys, avg_val = Avg}},

    Attach = pet_attr:get_add_attr(Avg),
    ?DEBUG("---Avg---~p~n", [Avg]),
    ?DEBUG("---Attach---~p~n", [Attach]),
    NP = calc_second_attr(NewPet, Attach), %%计算一级属性到二级属性的转化

    NewPet1 = add_eqm_attr_value(NP),           %%不能去掉，更新宠物装备以及宠物潜能提升等都需重新计算装备带来的属性加成
    Power = calc_fight_capacity(NewPet1),   %%计算战斗力
    NewPet2 = NewPet1#pet{fight_capacity = Power},
    NRole = Role#role{pet = PetBag#pet_bag{active = NewPet2}},
    rank:listener(pet, NRole),
    rank_celebrity:listener(dragon_fight_capacity, NRole, Power),
    medal:listener(dragon_fight_capacity, NRole).

%%6、二级属性 攻击 暴怒 生命 魔法 防御 坚韧 精准 格挡
%%计算一级属性到二级属性的转化                    
calc_second_attr(Pet = #pet{attr = Attr}, Attach) -> 
    {Dmg, Critrate, Hp_Max, Mp_Max, Defence, Tenacity, Hitrate, Evasion} = do_calc_second_attr(Pet, Attach),
    Pet#pet{attr = Attr#pet_attr{dmg = Dmg, critrate = Critrate, hp = Hp_Max, hp_max = Hp_Max, mp = Mp_Max, mp_max = Mp_Max, defence = Defence, 
        tenacity = Tenacity, hitrate = Hitrate, evasion = Evasion}}.

%% 
do_calc_second_attr(_Pet = #pet{attr = #pet_attr{xl = XlSys, tz = TzSys, js = JsSys, lq = LqSys, xl_val = Xl_Val, tz_val = Tz_Val,
    js_val = Js_Val, lq_val = Lq_Val}}, Attach) ->
    {Dmg, Critrate, Hp_Max, Mp_Max, Defence, Tenacity, Hitrate, Evasion} = 
        case Attach of 
            [] ->{
                    do_calc_base_attr(750,  XlSys, Xl_Val, 10),     %%攻击
                    do_calc_base_attr(300,  XlSys, Xl_Val, 4),      %%暴怒
                    do_calc_base_attr(3000, TzSys, Tz_Val, 40),     %%生命
                    do_calc_base_attr(2000, TzSys, Tz_Val, 27),     %%魔法
                    do_calc_base_attr(1500, JsSys, Js_Val, 20),     %%防御
                    do_calc_base_attr(300,  JsSys, Js_Val, 4),      %%坚韧
                    do_calc_base_attr(120,  LqSys, Lq_Val, 2),      %%精准
                    do_calc_base_attr(120,  LqSys, Lq_Val, 2)       %%格挡
                };
            % {攻击, 暴击, 生命, 魔法,  防御,  坚韧, 精准，格挡}
            {AddDmg, AddCri, AddHp, AddMp, AddDef, AddTen, AddHit, AddEva} ->
                {
                    AddDmg  + do_calc_base_attr(750,    XlSys,  Xl_Val, 10),     %%攻击
                    AddCri  + do_calc_base_attr(300,    XlSys,  Xl_Val, 4),      %%暴怒
                    AddHp   + do_calc_base_attr(3000,   TzSys,  Tz_Val, 40),     %%生命
                    AddMp   + do_calc_base_attr(2000,   TzSys,  Tz_Val, 27),     %%魔法
                    AddDef  + do_calc_base_attr(1500,   JsSys,  Js_Val, 20),     %%防御
                    AddTen  + do_calc_base_attr(300,    JsSys,  Js_Val, 4),      %%坚韧
                    AddHit  + do_calc_base_attr(120,    LqSys,  Lq_Val, 2),      %%精准
                    AddEva  + do_calc_base_attr(120,    LqSys,  Lq_Val, 2)       %%格挡
                }
        end,
    {Dmg, Critrate, Hp_Max, Mp_Max, Defence, Tenacity, Hitrate, Evasion}.


% %% 属性算法公式
% %% BaseVal = integer() 基础底值
% %% N = integer() 点数
% %% M = integer() 潜力
% %% X = integer() 系数
% do_calc_base_attr(BaseVal, N, M, X) ->
%     BaseVal + erlang:round((N + M / 10) * (M * 0.6/4 + 4) * X / 120).

%% 属性算法公式
% 伙伴2级属性=（伙伴升级1级属性+潜能/a）*转化系数             
% a暂定为10
% %% N = integer() （伙伴升级1级属性
% %% M = integer() 潜能
% %% X = integer() 系数
do_calc_base_attr(BaseVal, N, M, X) ->
    BaseVal + erlang:round((N + M) * X).

%% 计算潜力带来的战力
calc_potential_fight(Pet) ->
    Avg = pet_attr:calc_avg_potential(Pet),
    Attach = pet_attr:get_add_attr(Avg),
    {Dmg, Cri, HpMax, MpMax, Def, Ten, Hit, Eva} = do_calc_second_attr(Pet, Attach),
    AttrL = [{Dmg, 7.7}, {Cri, 10}, {HpMax, 1}, {MpMax, 0.1}, {Def, 2}, {Ten, 10}, {Hit, 25}, {Eva, 25}],
    AttrFight = do_calc_attr_fighting(AttrL, 0),
    Power = erlang:round(AttrFight),
    Power.

% 二级属性c=基础值+round（(n+m/10)(0.6*m/4+4)*x/120)  m为潜能值 n为一级属性值 x为属性转换系数
    % BaseVal + erlang:round((N + M / 20) * (M * 0.3/4 + 4) * X / 120).

% reset2(Pet = #pet{lev = Lev, attr = Attr, attr_sys = AttrSys}, Role = #role{pet = PetBag}) -> %%添加了附加属性，计算时直接加上附加值
%     {XlSys, TzSys, JsSys, LqSys} = do_sys_attr(Lev * 20, AttrSys), %%计算系统属性的分配，根据比例
%     Avg = pet_attr:calc_avg_potential(Pet),
%     NewPet = Pet#pet{attr = Attr#pet_attr{xl = XlSys, tz = TzSys, js = JsSys, lq = LqSys, avg_val = Avg}},
%     NewPet1 = add_eqm_attr_value(NewPet),
%     Attach = pet_attr:get_add_attr(Avg),
%     NP = calc_second_attr(NewPet1, Attach), %%计算一级属性到二级属性的转化
%     Power = calc_fight_capacity(NP), %%计算战斗力
%     NP2 = NP#pet{fight_capacity = Power},
%     NRole = Role#role{pet = PetBag#pet_bag{active = NP2}},
%     rank:listener(pet, NRole),
%     medal:listener(dragon_fight_capacity, NRole).

%% 计算宠物战斗力
%% 总得分=round(∑(技能基础分数*对应阶系数*对应级系数)+∑(对应属性*对应属性系数)/4,0) * 0.4
calc_fight_capacity(Pet) ->

    #pet{skill = Skills, attr = #pet_attr{hp_max = HpMax, mp_max = MpMax, dmg = Dmg, critrate = Cri, defence = Def, tenacity = Ten, hitrate = Hit, evasion = Eva, dmg_magic = DmgMagic, anti_attack = Attack, anti_seal = Seal, anti_stone = Stone, anti_stun = Stun, anti_sleep = Sleep, anti_taunt = Taunt, anti_silent = Silent, anti_poison = Poison, resist_metal = Metal, resist_wood = Wood, resist_water = Water, resist_fire = Fire, resist_earth = Earth}} = Pet,
    SkillFight = do_calc_skill_fighting(Skills, 0),
    %% ?DEBUG("攻击:~p, 暴击:~p, 气血:~p, 法力:~p, 防御:~p, 坚韧:~p, 命中:~p, 躲闪:~p", [Dmg, Cri, HpMax, MpMax, Def, Ten, Hit, Eva]),
    AttrL = [{Dmg, 7.7}, {Cri, 10}, {HpMax, 1}, {MpMax, 0.1}, {Def, 2}, {Ten, 10}, {Hit, 25}, {Eva, 25}, {DmgMagic, 7.7}, {Attack, 100}, {Metal, 1}, {Wood, 1}, {Water, 1}, {Fire, 1}, {Earth, 1}, {Stone, 3}, {Stun, 3}, {Poison, 3}, {Silent, 3}, {Sleep, 3}, {Taunt, 3}, {Seal, 3}],
    AttrFight = do_calc_attr_fighting(AttrL, 0),
    Power = erlang:round(SkillFight * 0.4 + AttrFight),
    Power.

%% 计算宠物技能战斗力
do_calc_skill_fighting([], FC) -> FC;
do_calc_skill_fighting([{SkillId, _Exp, _, _Args} | T], FC) ->
    case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{step = Step, lev = Lev}} ->
            StepRatio = element(Step, {1, 1.6, 2.5, 3.7}),
            LevRatio = element(Lev, {0.7, 1.4, 2.1, 2.8, 3.5, 4.2, 4.9, 5.6, 6.3, 7}),
            AddFC = 65 * StepRatio * LevRatio,
            do_calc_skill_fighting(T, FC + AddFC);
        _ ->
            do_calc_skill_fighting(T, FC)
    end.

%% 计算宠物属性战斗力
do_calc_attr_fighting([], FC) -> FC / 18;
do_calc_attr_fighting([{N, X} | T], FC) ->
    AddFC = N * X,
    do_calc_attr_fighting(T, AddFC + FC).


%%宠物装备属性加成
add_eqm_attr_value(Pet = #pet{eqm = Eqm}) ->
    F = fun(#item{special = Special}, L) ->  
        Special ++ L
    end,
    AttrValue = lists:foldl(F, [], Eqm),
    AttrValue1 = lists:flatten(AttrValue),
    add_eqm_attr_value(AttrValue1, Pet).

add_eqm_attr_value([], Pet) ->Pet;
add_eqm_attr_value([{Key, Value}|Rest], Pet) ->
    NPet = attr_key(Key, Value, Pet),
    add_eqm_attr_value(Rest, NPet).

attr_key(?attr_evasion, Value, Pet = #pet{attr = Attr = #pet_attr{evasion = Evasion}}) -> Pet#pet{attr = Attr#pet_attr{evasion = Evasion + Value}};
attr_key(?attr_hitrate, Value, Pet = #pet{attr = Attr = #pet_attr{hitrate = Hitrate}}) -> Pet#pet{attr = Attr#pet_attr{hitrate = Hitrate + Value}};
attr_key(?attr_hp_max, Value, Pet = #pet{attr = Attr = #pet_attr{hp = Hp, hp_max = Hp_max}}) -> Pet#pet{attr = Attr#pet_attr{hp = Hp + Value, hp_max = Hp_max + Value}};
attr_key(?attr_mp_max, Value, Pet = #pet{attr = Attr = #pet_attr{mp = Mp, mp_max = Mp_max}}) -> Pet#pet{attr = Attr#pet_attr{mp = Mp + Value, mp_max = Mp_max + Value}};
attr_key(?attr_dmg, Value, Pet = #pet{attr = Attr = #pet_attr{dmg = Dmg}}) -> Pet#pet{attr = Attr#pet_attr{dmg = Dmg + Value}};
attr_key(?attr_critrate, Value, Pet = #pet{attr = Attr = #pet_attr{critrate = Critrate}}) -> Pet#pet{attr = Attr#pet_attr{critrate = Critrate + Value}};
attr_key(?attr_defence, Value, Pet = #pet{attr = Attr = #pet_attr{defence = Defence}}) -> Pet#pet{attr = Attr#pet_attr{defence = Defence + Value}};
attr_key(?attr_tenacity, Value, Pet = #pet{attr = Attr = #pet_attr{tenacity = Tenacity}}) -> Pet#pet{attr = Attr#pet_attr{tenacity = Tenacity + Value}};
attr_key(_Key, _Value, Pet) -> Pet.

calc_eqm_fight_capacity(_Eqm = #item{attr = Attr}) ->
    ValueList = [{K, V}||{K, _, V} <- Attr],
    FVal = [attr_parm(K1) * V1||{K1, V1} <- ValueList],
    Sum = erlang:round(lists:sum(FVal) / 4 * 0.4),
    Sum.

attr_parm(?attr_evasion) -> 10;
attr_parm(?attr_hitrate) -> 10;
attr_parm(?attr_hp_max) -> 0.25;
attr_parm(?attr_mp_max) -> 0;
attr_parm(?attr_dmg) -> 3;
attr_parm(?attr_critrate) -> 5;
attr_parm(?attr_defence) -> 0.5;
attr_parm(?attr_tenacity) -> 5;
attr_parm(_) -> 0.



%% 重新计算宠物技能级别
%%calc_pet_skill(Skill = {SkillId, Exp,_Need_Exp,_, Args}) ->
%%    case pet_data_skill:get(SkillId) of
%%        {ok, #pet_skill{exp = NeedExp}} when Exp >= NeedExp -> %% 经验可以升级
%%            do_skill_upgrage(Skill);
%%        {ok, #pet_skill{}} -> 
%%            case pet_data_skill:get(SkillId - 1) of
%%                {ok, #pet_skill{exp = NeedExp}} when Exp < NeedExp -> %% 宠物技能经验达不到此级别 不作降级处理直接给此级别所需经验 
%%                    {SkillId, NeedExp, Args};
%%                _ ->
%%                    Skill
%%            end;
%%        _ -> 
%%            Skill 
%%    end.

%% 处理升级事件
%% @spec upgrage(Pet, Role) -> {false, Reason} | {ok, NewPet}
%% Pet = NewPet = #pet{}
%% Role = #role{}
upgrage(#pet{lev = PetLev}, #role{lev = RoleLev}) when PetLev >= RoleLev ->
    {false, ?L(<<"宠物等级不能高于人物等级">>)};
upgrage(Pet = #pet{lev = Lev, exp = Exp}, Role) ->
    NeedExp = pet_data_exp:get(Lev),
    if
        NeedExp =:= 0 ->
            {false, ?L(<<"宠物已是最高等级">>)};
        Exp >= NeedExp - 15 ->
            {ok, reset(Pet#pet{lev = Lev + 1, exp = 0}, Role)};
        true -> {false, exp_not_enough}
    end.

%% 喂养宠物
%% @spec feed(Pet, Arg) -> {false, Reason} | {ok, NewPet, NewRole} | {ok, NewPet}
%% Pet = NewPet = #pet{}
%% Arg = Role | Value
%% Role = NewRole = #role{}
%% Value = integer()  增加快乐值
feed(#pet{happy_val = ?pet_max_happy}, _) ->
    {false, ?L(<<"宠物不需要喂养">>)};
feed(Pet, Role = #role{bag = #bag{items = Items}}) ->
    case find_food_from_bag(Items, ?pet_food_item) of
        {false, Reason} -> {false, Reason};
        {ok, Value, #item{base_id = BaseId, bind = Bind}} ->
            L1 = #loss{label = item, val = [BaseId, Bind, 1]},
            case feed(Pet, Value) of
                {false, Reason} -> {false, Reason};
                {ok, NewPet} ->
                    case role_gain:do([L1], Role) of
                        {false, _} -> {false, ?L(<<"扣除宠物口粮失败，无法喂养宠物">>)};
                        {ok, NRole} ->
                            {ok, NewPet, NRole}
                    end
            end
    end;
feed(Pet = #pet{happy_val = HappyVal}, Value) ->
    HV = case (Value + HappyVal) >= ?pet_max_happy of
        true -> ?pet_max_happy;
        false -> Value + HappyVal
    end,
    NewPet = Pet#pet{happy_val = HV},
    {ok, NewPet}.

%% 技能合并处理
%% @spec skill_join(Type, MainSkills, Num, SecondSkills) -> NewSkills;
%% MainSkills = SecondSkills = NewSkills = [SkillId, Exp]
%% Type = integer() 类型 0:预览 1:真实合并
%% Num = integer() 技能最大数量
%% SkillId = integer() 技能ID
%% Exp = integer() 技能经验值
skill_join(Type, MainSkills, Num, SecondSkills) ->
    skill_join(Type, MainSkills, Num, SecondSkills, []).
skill_join(0, MainSkills, Num, [], Skills) ->
    case MainSkills ++ Skills of
        TatolSkills when length(TatolSkills) > Num -> %% 合并后技能数超出宠物最大技能数
            NewSkills = [{0, Exp, []} || {_SkillId, Exp, _Args} <- Skills],
            do_move_skill(MainSkills, Num, NewSkills);
        TatolSkills ->
            TatolSkills
    end;
skill_join(1, MainSkills, Num, [], Skills) -> 
    do_move_skill(MainSkills, Num, Skills);
skill_join(Type, MainSkills, Num, [Skill2 = {SkillId, _Exp, _Args} | T], Skills) -> 
    MutexList = pet_data_skill:mutex(SkillId),
    case check_mutex(MutexList, MainSkills) of
        false -> %% 无互斥技能
            skill_join(Type, MainSkills, Num, T, [Skill2 | Skills]);
        {ok, Skill1 = {SId, _, _}} -> %% 存在互斥技能
            NewSkill = do_skill_join(Skill1, Skill2),
            NewMainSkills = lists:keyreplace(SId, 1, MainSkills, NewSkill),
            skill_join(Type, NewMainSkills, Num, T, Skills)
    end.


asc_potential(Type, IsAuto, Role = #role{pet = #pet_bag{active = Pet = #pet{attr = Attr, 
                skin_grade = CostNum, asc_times = Asc_times, last_asc_time = Last_asc_time}}}
            ) -> 
    case get_potential_val(Type, Attr) of
        false -> {false, ?MSGID(<<"请选择提升潜力类型">>)};
        {?pet_max_potential, ?pet_max_potential} -> {false, ?MSGID(<<"当前已是最高潜力值">>)};           
        {Val, MaxVal} ->
            Avg = pet_attr:calc_avg_potential(Pet),
            if
                Avg == MaxVal ->
                    {false, ?MSGID(<<"当前已是等级最高潜力值">>)};
                Val == MaxVal ->
                    {false, ?MSGID(<<"当前已是同阶最高潜力值">>)};
                true ->
                    Now = util:unixtime(),
                    {Success, Asc_times1} = 
                        case {util:is_same_day2(Last_asc_time, Now), Asc_times > 0} of %%超过一天的周期
                            {false, _} ->    %%100%成功
                                {100, ?pet_asc_free - 1};
                            {true, true} ->  %%更新Asc_Times为 2，并使用一次100%%成功的机会
                                {100, Asc_times - 1};  
                            {true, false} ->  %%3次100%已使用完，根据配表获得成功概率
                                S = get_ratio(Val),
                                ?DEBUG("----获取成功率----~p~n", [S]),
                                {S, 0}
                        end,
                    Rand  = util:rand(1, 100), %% 以100作为100%的标准                  
                    case Rand =< Success of
                        false -> %% 失败 
                            ?DEBUG("----失败-----~n"),
                            NPet = case Type of
                                    1 -> %% 力
                                        Pet#pet{bind = 1, attr = Attr#pet_attr{xl_val = Val}};
                                    2 -> %% 体
                                        Pet#pet{bind = 1, attr = Attr#pet_attr{tz_val = Val}};
                                    3 -> %% 毅
                                        Pet#pet{bind = 1, attr = Attr#pet_attr{js_val = Val}};
                                    4 -> %% 巧
                                        Pet#pet{bind = 1, attr = Attr#pet_attr{lq_val = Val}}
                                end,
                            case make_cost(Role, IsAuto, CostNum) of
                                {ok, NRole} -> 
                                    {0, [], NRole, NPet#pet{asc_times = Asc_times1, last_asc_time = util:unixtime()}, 0, 0};
                                {false, Reason} ->
                                    {0, Reason, Role, Pet, 0, 0}
                            end;
                        true -> %%成功
                            AddVal  = util:rand(1, 3),
                            AddVal1 = Val + AddVal - MaxVal,
                            {Val1, NPet1} = 
                                case {Type, AddVal1 > 0} of %%AddVal1 表示增加的与已有的减去最大的，有可能为负值
                                    {1, true} -> %% 力 
                                        {MaxVal - Val, Pet#pet{bind = 1, attr = Attr#pet_attr{xl_val = MaxVal}}};
                                    {1, false} -> %% 力 
                                        {AddVal, Pet#pet{bind = 1, attr = Attr#pet_attr{xl_val = Val + AddVal}}};
                                    {2, true} -> %% 体 
                                        {MaxVal - Val, Pet#pet{bind = 1, attr = Attr#pet_attr{tz_val = MaxVal}}};
                                    {2, false} -> %% 体 
                                        {AddVal, Pet#pet{bind = 1, attr = Attr#pet_attr{tz_val = Val + AddVal}}};
                                    {3, true} -> %% 毅 
                                        {MaxVal - Val, Pet#pet{bind = 1, attr = Attr#pet_attr{js_val = MaxVal}}};
                                    {3, false} -> %% 毅 
                                        {AddVal, Pet#pet{bind = 1, attr = Attr#pet_attr{js_val = Val + AddVal}}};
                                    {4, true} -> %% 巧 
                                        {MaxVal - Val, Pet#pet{bind = 1, attr = Attr#pet_attr{lq_val = MaxVal}}};
                                    {4, false} -> %% 巧 
                                        {AddVal, Pet#pet{bind = 1, attr = Attr#pet_attr{lq_val = Val + AddVal}}}
                                end,
                            {NP2, Step, Next_Max} =  
                                case Val1 >= 0 of  %%为正数时说明已经大于最大值，可能可以更新到下一阶最大值 
                                    true ->
                                        update_next_max2(NPet1);
                                    false ->
                                        {NPet1, 0} %% 0表示阶数没有变化，附加属性为空
                                end,
                            case make_cost(Role, IsAuto, CostNum) of
                                {ok, NRole} ->
                                    {Val1, [], NRole, NP2#pet{asc_times = Asc_times1, last_asc_time = util:unixtime()}, Step, Next_Max};
                                {false, Reason} -> 
                                    {0, Reason, Role, Pet, 0, 0}
                            end
                    end
            end
    end.

%% 潜能石价格需要去商城获取, 暂时为10
make_cost(Role = #role{bag = #bag{items = Items}}, IsAuto, CostNum) ->
    StoneNum = 
        case storage:find(Items, #item.base_id, 621100) of 
            {false, _Msg} -> 0;
            {ok, Num, _, _, _} -> Num
        end,
    Loss = 
        case StoneNum >= CostNum of
            true ->
                [#loss{label = item, val = [621100, 0, CostNum]}];
            false ->
                case IsAuto of
                    1 -> 
                        [#loss{label = item, val = [621100, 0, StoneNum]},
                         #loss{label = gold, val = (CostNum - StoneNum) * 10, msg = ?MSGID(<<"晶钻不足">>)}
                         ];
                    _ -> 
                        {false, ?MSGID(<<"潜能石不足">>)}
                end
        end,
    case Loss of
        {false, Reason} ->
            {false, Reason};
        _ ->
            case role_gain:do(Loss, Role) of
                {false, #loss{msg = Msg}} -> 
                    {false, Msg};
                {ok, NRole} ->
                    {ok, NRole}
            end
    end.

        % ,xl_val = 120 %% 攻潜力
        % ,tz_val = 120 %% 体潜力
        % ,js_val = 120 %% 防潜力
        % ,lq_val = 120 %% 巧潜力
        % ,xl_max = 1200       %% 攻潜力上限
        % ,tz_max = 1200       %% 体潜力上限
        % ,js_max = 1200       %% 防潜力上限
        % ,lq_max = 1200       %% 巧潜力上限

update_next_max2(Pet = #pet{lev = Lev, attr = Attr = #pet_attr{step = Step, xl_max = Xl_Max}}) ->
    Avg = pet_attr:calc_avg_potential(Pet),
    if 
        Avg >= Xl_Max ->
            NStep = Step + 1,
            Stone = lists:nth(NStep, pet_asc_ratio:get_all_cost()),
            NAttr = Attr#pet_attr{step = NStep}, %%更新了新的阶
            NP    = Pet#pet{skin_grade = Stone, attr = NAttr},

            Next_Max = find_next_max(Xl_Max, Lev),
            case Next_Max > Xl_Max of
                true ->
                    NAttr1 = NAttr#pet_attr{xl_max = Next_Max, tz_max = Next_Max, js_max = Next_Max, lq_max = Next_Max}, %%更新了新的阶，同时获取附加属性
                    NP1    = NP#pet{attr = NAttr1},
                    {NP1, NStep, Next_Max}; %%返回附加属性，在重新计算二级属性时直接增加上去
                false ->
                    {NP, NStep, 0}
            end;
        true ->
            {Pet, 0, 0} %% 0表示阶数没有变化，附加属性为空
    end.

% calc_next_max(LastMax) ->
%     AllStep = pet_asc_ratio:get_all_step(),
%     Steps2  = lists:sort([S||S <- AllStep, S > LastMax]),
%     case Steps2 of
%         [] -> 
%             LastMax;
%         [H|_] -> 
%             H
%     end.

update_next_max(Pet = #pet{lev = Lev, attr = Attr = #pet_attr{xl_max = Xl_Max}}) ->
    Avg = pet_attr:calc_avg_potential(Pet),
    if 
        Avg >= Xl_Max ->
            Next_Max = find_next_max(Xl_Max, Lev),
            case Next_Max > Xl_Max of
                true ->
                    NAttr = Attr#pet_attr{xl_max = Next_Max, tz_max = Next_Max, js_max = Next_Max, lq_max = Next_Max}, %%更新了新的阶，同时获取附加属性
                    NP    = Pet#pet{attr = NAttr},
                    {NP, Next_Max}; %%返回附加属性，在重新计算二级属性时直接增加上去
                false ->
                    {Pet, 0} %% 0表示阶数没有变化，附加属性为空
            end;
        true ->
            {Pet, 0} %% 0表示阶数没有变化，附加属性为空
    end.

find_next_max(LastMax, Lev) ->
    AllStep = pet_asc_ratio:get_all_step(),
    Levs    = pet_asc_ratio:get_all_lev(),
    N       = erlang:length([1||L <- Levs, Lev >= L]) + 1,
    Steps2  = lists:sort([S||S <- lists:sublist(AllStep, N), S > LastMax]),
    case Steps2 of
        [] -> 
            LastMax;
        [H|_] -> 
            H
    end.


  % layout.fight1_lbl:setString("攻击：" .. pet_vo.dmg)
    % layout.fight2_lbl:setString("生命：" .. pet_vo.hp_max)
    % layout.fight3_lbl:setString("防御：" .. pet_vo.defence)
    % layout.fight4_lbl:setString("精准：" .. pet_vo.hitrate)
    % layout.fight5_lbl:setString("暴怒：" .. pet_vo.critrate)
    % layout.fight6_lbl:setString("魔法：" .. pet_vo.mp_max)
    % layout.fight7_lbl:setString("韧性：" .. pet_vo.tenacity)
    % layout.fight8_lbl:setString("闪避：" .. pet_vo.evasion)


%% 宠物成长提升
grow(#pet{lev = PetLev, grow_val = Grow}, _Role) when Grow >= PetLev * 7 ->
    {false, ?L(<<"宠物成长值不能高于7倍宠物等级">>)};
grow(Pet = #pet{grow_val = Grow, wish_val = Wish}, Role) -> 
    L = [
        #loss{label = item, val = [23001, 0, 1], msg = ?L(<<"仙宠成长丹不足">>)}
        ,#loss{label = coin_all, val = 2000, msg = ?L(<<"所有金币不足">>)}
    ],
    case role_gain:do(L, Role) of
        {false, #loss{label = coin_all, msg = Msg}} -> {coin_all, Msg};
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, NRole} ->
            #pet_grow_base{base_suc = BaseSuc, max_wish = MaxWish, min_wish = MinWish, attr_val = OldAttrVal, cli_base_suc = CliBaseSuc, cli_max_wish = CliMaxWish} = pet_data:get_grow(Grow),
            RandVal = util:rand(1, MaxWish),
            SucVal = BaseSuc + Wish,
            CliSuc = round(CliBaseSuc + (Wish * 100 / CliMaxWish)), %% 客户端显示的成功率
            case Wish >= MinWish of
                true when RandVal =< SucVal orelse Wish >= 500 orelse CliSuc >= 100 ->  %% 提升成功，增加潜力 当前祝福值大于575必成功
                    ?DEBUG("基础成功值:~p 值祝福值:~p 下限祝福值:~p 上限祝福值:~p 随机值:~p 客户端成功率:~p", [BaseSuc, Wish, MinWish, MaxWish, RandVal, CliSuc]),
                    NewPet = reset(Pet#pet{bind = 1, grow_val = Grow + 1, wish_val = 0}, Role),
                    #pet_grow_base{attr_val = NewAttrVal} = pet_data:get_grow(Grow + 1),
                    {{suc, NewAttrVal - OldAttrVal}, NRole, NewPet};
                _ -> %% 提升失败 祝福值增加[1~3]
                    NewWish = lists:min([Wish + util:rand(15, 25), MaxWish]),
                    NewPet = Pet#pet{wish_val = NewWish},
                    {{fail, NewWish - Wish}, NRole, NewPet}
            end
    end.


%% 重新生成宠物的系统分配属性比例 by bwang
%% @spec set_sys_attr_per(Pet, Role) -> {false, Reason} | {ok, NewRole, NewPet}
%% Pet = NewPet = #pet{}
%% Role = NewRole = #role{}
set_sys_attr_per(Auto, Role = #role{pet = #pet_bag{active = Pet}}) ->
    Num = storage:count(Role#role.bag, 621201),
    Need = 
        case Num >= 1 of 
            true -> 0;
            false -> 1
        end,
    L = 
        case Need of 
            0 ->    %%消耗物品
                [
                #loss{label = coin, val = 2000, msg = ?MSGID(<<"金币不足">>)},
                #loss{label = item, val = [621201, 0, 1]}
                ];
            _ ->
                case Auto of 
                    1 ->
                        [
                        #loss{label = gold, val = 12, msg = ?MSGID(<<"晶钻不足">>)}
                        ,#loss{label = coin, val = 2000, msg = ?MSGID(<<"金币不足">>)}
                        ];
                    0 ->
                        [] %%表示缺少命运币又不自动购买材料
                end
        end,
    case L of 
        [] -> {false, ?MSGID(<<"材料不足，请购买材料">>)};
        _ ->
            role:send_buff_begin(),
            case role_gain:do(L, Role) of
               {false, #loss{msg = Msg}} -> 
                    role:send_buff_clean(),
                    {false, Msg};
               {false, Msg} -> 
                    role:send_buff_clean(),
                    {false, Msg};
               {ok, NRole} ->
                    NewAttrSys = rand_new_sys_per(),
                    NRole1 = reset(Pet#pet{bind = 1, attr_sys = NewAttrSys}, NRole),
                    log:log(log_pet2, {<<"伙伴天赋">>, util:term_to_bitstring(NewAttrSys), NRole1}),
                    role:send_buff_flush(),
                    {ok, NRole1}
            end
    end.

%% 进行批量洗髓一次
wash_batch(Auto, Pet, Role) ->
    Num = storage:count(Role#role.bag, 621201),
    Need = 
        case Num >= 5 of 
            true -> 0;
            false -> 5 - Num
        end,
    L = 
        case Need of 
            0 ->    %%消耗物品
                [
                    #loss{label = coin, val = 10000, msg = ?MSGID(<<"金币不足">>)},
                    #loss{label = item, val = [621201, 0, 5]}
                ];
            _ ->
                case Auto of 
                    1 ->
                        [
                            #loss{label = coin, val = 10000, msg = ?MSGID(<<"金币不足">>)}
                            ,#loss{label = gold, val = Need * 12,msg = ?MSGID(<<"晶钻不足">>)}
                            ,#loss{label = item, val = [621201, 0, Num]}
                        ];
                    0 ->
                        [] %%表示缺少命运币又不自动购买材料
                end
        end,
    case L of 
        [] -> {false, ?MSGID(<<"材料不足，请购买材料">>)};
        _ ->
            role:send_buff_begin(),
            case role_gain:do(L, Role) of
               {false, #loss{msg = Msg}} -> 
                    role:send_buff_clean(),
                    {false, Msg};
               {false, Msg} -> 
                    role:send_buff_clean(),
                    {false, Msg};
               {ok, NRole} ->
                    L1 = lists:seq(1, ?pet_wash_num),
                    WL = [{N, rand_new_sys_per()} || N <- L1],
                    NewPet = Pet#pet{wash_list = WL},
                    role:send_buff_flush(),
                    {ok, NRole, NewPet}
            end
    end.
%%宠物进行一次批量探寻龙族遗迹
explore_batch(Role = #role{pet = PetBag = #pet_bag{active = Pet =#pet{lucky_value = Lucky}}}, _Bind) ->
    L = 
        % case Bind of 
        % 0 ->   
        %     [
        %         #loss{label = gold, val =110 , msg = ?MSGID(<<"晶钻不足">>)}
        %     ];
        % 1 ->
        %     [
        %         #loss{label = gold_all, val =110 , msg = ?MSGID(<<"晶钻不足">>)}
        %     ]
        % end,
        [ #loss{label = gold, val =110 , msg = ?MSGID(<<"晶钻不足">>)}],
    role:send_buff_begin(),
    case role_gain:do(L, Role) of
        {false, #loss{msg = Msg}} -> 
             role:send_buff_clean(),
            {false, Msg};
        {false, Msg} -> 
             role:send_buff_clean(),
            {false, Msg};
        {ok, NRole} ->
            Item_Weight = get_item_weight(Lucky),
            Items = get_item_batch(Item_Weight, 12, 0, []),
            Table = 
                if 
                    Lucky >= 1250 ->
                        3;
                    Lucky >= 500 ->
                        2;
                    true ->
                        1
                end,
            NPet = Pet#pet{
            lucky_value = Lucky + 60,
            tab = Table,
            explore_list = Items}, %%批量探寻一次增加的幸运值，需要跟策划确认
            role:send_buff_flush(),
            {ok, NRole#role{pet = PetBag#pet_bag{active = NPet}}, Items}
    end.
    
get_item_batch(_, 12, 12, L) -> L;    
get_item_batch(Item_Weight, 12, Num, L) ->
    Item = get_item(Item_Weight),
    case Item of 
        0 ->
            get_item_batch(Item_Weight, 12, Num, L); %%Num没有加1，保证能产生12个结果
        _ ->
            get_item_batch(Item_Weight, 12, Num + 1, [Item#pet_dragon_item.item_id|L])
    end.

%%宠物进行一次龙族遗迹探寻
explore(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{lucky_value = Lucky}}}, _Bind) ->
    L =  
        % case Bind of 
        %     0 ->
        %         [
        %             #loss{label = gold, val =10 , msg = ?MSGID(<<"晶钻不足">>)}
        %         ];
        %     1 ->
        %         [
        %             #loss{label = gold_all, val =10 , msg = ?MSGID(<<"晶钻不足">>)}
        %         ]
        % end,
                   [#loss{label = gold, val =10 , msg = ?MSGID(<<"晶钻不足">>)}],
    role:send_buff_begin(),
    case role_gain:do(L, Role) of
       {false, #loss{msg = Msg}} -> 
            role:send_buff_clean(),
            {false, Msg};
       {false, Msg} -> 
            role:send_buff_clean(),
            {false, Msg};
       {ok, NRole} ->
           
            Item_Weight = get_item_weight(Lucky),
            Item = get_item(Item_Weight),
            case Item of 
                0 ->
                    role:send_buff_clean(),
                    {false, ?MSGID(<<"无法探寻到宝藏-_-">>)};
                _ ->
                    Table = 
                        if 
                            Lucky >= 1250 ->
                                3;
                            Lucky >= 500 ->
                                2;
                            true ->
                                1
                        end,
                    NPet = Pet#pet{
                    lucky_value = Lucky + 5,
                    tab = Table,
                    explore_once = Item#pet_dragon_item.item_id}, %%探寻一次增加的幸运值，需要跟策划确认
                    role:send_buff_flush(),
                    {ok, NRole#role{pet = PetBag#pet_bag{active = NPet}}, Item#pet_dragon_item.item_id}
            end
    end.

get_item_weight(Lucky) ->
     Items = 
        if 
            Lucky >= 2500 ->  %%根据配置表中权重的最小值
                pet_dragon_data3:get_all_item();
            Lucky >= 1000 ->        %%根据配置表中权重的最小值
                pet_dragon_data2:get_all_item();
            true ->                 
                pet_dragon_data1:get_all_item()
        end, 
    Item_List = [I||I = #pet_dragon_item{lucky = Min, weight = W} <- Items, Lucky >= Min andalso W =/= 0], %%过滤出权重不为0 ，虔诚值小于当前宠物虔诚值的
    Sorted_Items = lists:keysort(#pet_dragon_item.weight, Item_List),
    Weight = [Wei || #pet_dragon_item{weight = Wei} <-Sorted_Items],
    Sorted_Weight = lists:sort(Weight),
    Sum = lists:sum(Sorted_Weight),
    {Sorted_Weight, Sum, Sorted_Items}.
    

%%获得符合条件的一个物品
get_item({Sorted_Weight, Sum, Sorted_Items}) ->
    case erlang:length(Sorted_Items) of 
        0 ->
            0;
        _ ->
            Rand = util:rand(1, Sum),
            N = get_fit_item_num(Sorted_Weight, Rand, 1),
            case (N == 0) or (erlang:length(Sorted_Items) == 0) of 
                true -> 0;
                false ->
                    case N > erlang:length(Sorted_Items) of 
                        true -> lists:nth(N - 1, Sorted_Items);
                        false -> lists:nth(N, Sorted_Items)
                    end
            end
    end.

get_fit_item_num([], _, N) -> N; %%没有一个值可以匹配时选择最小的那一个
get_fit_item_num([Weight|T], Rand, N) ->
    case  Rand - Weight > 0 of 
        true ->
            get_fit_item_num(T, Rand - Weight, N + 1) ;
        false ->
            N
    end.

%%购买探寻龙族遗迹获得的物品
buy_item({Table, ItemId}, Role = #role{}) ->
    {ok, Item} = 
        if 
            Table == 1 ->
                pet_dragon_data1:get(ItemId);                   
            Table == 2 ->
                pet_dragon_data2:get(ItemId);
            true ->
                pet_dragon_data3:get(ItemId)
        end,
    Gain = [#gain{label = item, val = [ItemId, 0, 1]}], 
    case role_gain:do(Gain, Role) of 
        % {ok, NR = #role{pet = PetBag = #pet_bag{active = Pet = #pet{lucky_value = Lucky, devout_value = Devout}}}}->
        {ok, NR}->
            % NDevout = Devout + erlang:round(Lucky * 0.2),
            % NPet = Pet#pet{lucky_value = 0, devout_value = NDevout, explore_once = 0, explore_list = []}, %%需要将宠物的幸运值变为0，同时需要将幸运值的20%转化为虔诚值
            % NR2 = NR#role{pet = PetBag#pet_bag{active = NPet}},
            % case Item#pet_dragon_item.high_lev of 
            %     1 ->
            %         pet_mgr:update_ets(Name, Item#pet_dragon_item.item_name),
            %         RoleMsg = notice:role_to_msg(Name),
            %         ItemMsg = notice:item_msg({ItemId, 1, 1}),
            %         Msg = util:fbin(?L(<<"<u>~s</u>在龙族遗迹中幸运地获得了<u>~s</u>">>), [RoleMsg, ItemMsg]),
            %         role_group:pack_cast(world, 10932, {7, 0, Msg});
            %     0 ->
            %         ok
            % end,
            % {ok, NR2, NDevout};
            do_add_item(NR, Item, ItemId);
        {_, _Reason} ->
            {false, ?MSGID(<<"背包已满！">>)}
    end.

do_add_item(Role = #role{name = Name, pet = PetBag = #pet_bag{active = Pet = #pet{lucky_value = Lucky, devout_value = Devout}}}, Item, ItemId) ->
    NDevout = Devout + erlang:round(Lucky * 0.2),
    NPet = Pet#pet{lucky_value = 0, devout_value = NDevout, explore_once = 0, explore_list = []}, %%需要将宠物的幸运值变为0，同时需要将幸运值的20%转化为虔诚值
    NR2 = Role#role{pet = PetBag#pet_bag{active = NPet}},
    case Item#pet_dragon_item.high_lev of 
        1 ->
            pet_mgr:update_ets(Name, Item#pet_dragon_item.item_name),
            RoleMsg = notice:role_to_msg(Name),
            ItemMsg = notice:item_msg({ItemId, 1, 1}),
            Msg = util:fbin(?L(<<"<u>~s</u>在龙族遗迹中幸运地获得了<u>~s</u>">>), [RoleMsg, ItemMsg]),
            role_group:pack_cast(world, 10932, {7, 0, Msg});
        0 ->
            ok
    end,
    {ok, NR2, NDevout}.

%% 开启双天赋
open_double_talent(#pet{double_talent = #pet_double_talent{switch = 1}}, _Role) ->
    {false, ?L(<<"已经开启双天赋，无需再次开启">>)};
open_double_talent(Pet = #pet{double_talent = DoubleTalent = #pet_double_talent{attr_list = AttrList}}, Role) ->
    L = [#loss{label = gold, val = pay:price(?MODULE, open_double_talent, null), msg = ?L(<<"晶钻不足">>)}],
    case role_gain:do(L, Role) of
        {false, #loss{label = gold, msg = Msg}} -> {gold_less, Msg};
        {ok, NRole} ->
            NewPet = Pet#pet{double_talent = DoubleTalent#pet_double_talent{switch = 1,
                    attr_list = [{2, #pet_attr_sys{xl_per = 25, tz_per = 25, js_per = 25, lq_per = 25}} | AttrList]
                    }},
            {ok, NRole, NewPet}
    end.

%% 更换双天赋
change_double_talent(_, #pet{double_talent = #pet_double_talent{switch = 0}}, _UseId, _Role) ->
    {false, ?L(<<"双天赋未开启, 请先开启后再使用">>)};
change_double_talent(active, Pet = #pet{double_talent = DoubleTalent = #pet_double_talent{cooldown = CoolDown, attr_list = AttrList}}, UseId, Role = #role{pet = PetBag}) ->
    Now = util:unixtime(),
    TimeCheck = case CoolDown of
        0 -> true;
        _Time ->
            util:unixtime() - CoolDown >= 3600
    end,
    case TimeCheck of
        false -> {false, ?L(<<"切换天赋冷却时间未到, 无法更换天赋">>)};
        true ->
            case lists:keyfind(UseId, 1, AttrList) of
                false -> {false, ?L(<<"未找到该天赋属性, 无法更换天赋">>)};
                {UseId, AttrSys} ->
                    {ok, NPet, NPetBag} = pet:refresh_war_pet(Pet, PetBag),
                    NewPet = reset(NPet#pet{attr_sys = AttrSys, double_talent = DoubleTalent#pet_double_talent{cooldown = Now, use_id = UseId}}, Role),
                    push_pet(refresh, [NewPet], Role),
                    NRole1 = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
                    NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
                    push_pet(double_talent, NewPet, NewRole),
                    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"宠物更换天赋">>}),
                    rank:listener(pet, NewRole),
                    {ok, NewRole}
            end
    end;
change_double_talent(bag, Pet = #pet{id = Id, double_talent = DoubleTalent = #pet_double_talent{cooldown = CoolDown, attr_list = AttrList}}, UseId, Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) ->
    Now = util:unixtime(),
    TimeCheck = case CoolDown of
        0 -> true;
        _Time ->
            util:unixtime() - CoolDown >= 3600
    end,
    case TimeCheck of
        false -> {false, ?L(<<"切换天赋冷却时间未到, 无法更换天赋">>)};
        true ->
            case lists:keyfind(UseId, 1, AttrList) of
                false -> {false, ?L(<<"未找到该天赋属性, 无法更换天赋">>)};
                {UseId, AttrSys} ->
                    NewPet = reset(Pet#pet{attr_sys = AttrSys, double_talent = DoubleTalent#pet_double_talent{cooldown = Now, use_id = UseId}}, Role),
                    push_pet(refresh, [NewPet], Role),
                    NewPets = lists:keyreplace(Id, #pet.id, Pets, NewPet),
                    NewRole = Role#role{pet = PetBag#pet_bag{pets = NewPets}},
                    push_pet(double_talent, NewPet, NewRole),
                    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"宠物更换天赋">>}),
                    {ok, NewRole}
            end
    end.

del_double_talent_cd(#pet{double_talent = #pet_double_talent{switch = 0}}, _Role) ->
    {false, ?L(<<"双天赋未开启, 无需加速冷却时间">>)};
del_double_talent_cd(#pet{double_talent = #pet_double_talent{cooldown = 0}}, _Role) ->
    {false, ?L(<<"冷却时间为0, 无需加速冷却时间">>)};
del_double_talent_cd(Pet = #pet{double_talent = DoubleTalent = #pet_double_talent{cooldown = CoolDown}}, Role) ->
    Now = util:unixtime(),
    TimeCheck = case Now - CoolDown >= 3600 of
        true -> 0;
        false -> (3600 - (Now - CoolDown))
    end,
    case TimeCheck of
        0 -> {false, ?L(<<"冷却时间为0, 无需加速冷却时间">>)};
        Time when Time > 0 ->
            L = [#loss{label = gold, val = pay:price(?MODULE, del_double_talent_cd, Time), msg = ?L(<<"晶钻不足">>)}],
            case role_gain:do(L, Role) of
                {false, #loss{label = gold, msg = Msg}} -> {gold_less, Msg};
                {ok, NRole} ->
                    NewPet = Pet#pet{double_talent = DoubleTalent#pet_double_talent{cooldown = 0}},
                    {ok, NRole, NewPet}
            end;
        _ ->
            ?ERR("双天赋加速冷却时间异常"),
            {false, ?L(<<"加速冷却时间失败">>)}
    end.

update_double_talent(Pet = #pet{attr_sys = AttrSys, double_talent = DoubleTalent = #pet_double_talent{use_id = UseId, attr_list = AttrList}}) ->
    case lists:keyfind(UseId, 1, AttrList) of
        false ->
            ?ERR("更新宠物双天赋属性出错,UseId:~w,AttrList:~w",[UseId, AttrList]),
            Pet;
        _ ->
            NewAttrList = lists:keyreplace(UseId, 1, AttrList, {UseId, AttrSys}),
            Pet#pet{double_talent = DoubleTalent#pet_double_talent{attr_list = NewAttrList}}
    end.

%% @doc 随机生成多个宠物
%% @spec random_pet_list(Refresh, Num) -> list()
%% Refresh = integer() 刷新类型
%% Num = integer() 生成宠物数量
rand_pet_list(Num) ->
    Refresh = get_rand_val(rand_refresh_type()),
    rand_pet_list(Refresh, Num).
rand_pet_list(Refresh, Num) ->
    do_rand_pet_list(Refresh, Num, []).

%% 获取宠物成长类型
get_grow_type(GrowVal) ->
    if
        GrowVal < 20 -> 0;
        GrowVal < 50 -> 1;
        GrowVal < 100 -> 2;
        GrowVal < 200 -> 3;
        true -> 4
    end.

%%-----------------------------------------------------------
%% 内部方法
%%-----------------------------------------------------------

%% 计算系统属性分配
do_sys_attr(0, _) -> {0, 0, 0, 0};
do_sys_attr(Val, #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}) ->
    Xl = erlang:round(Val * XlPer / 100),
    Tz = erlang:round(Val * TzPer / 100),
    Js = erlang:round(Val * JsPer / 100),
    Lq = erlang:round(Val * LqPer / 100),
    case (Xl + Tz + Js + Lq) - Val of
        0 -> {Xl, Tz, Js, Lq};
        Reg when Reg > 0 -> %% 多分配 从最大值中扣除
            case do_sys_attr(max, [{tz, Tz, TzPer}, {js, Js, JsPer}, {lq, Lq, LqPer}], {xl, Xl, XlPer}) of
                {xl, Xl, XlPer} -> {Xl - Reg, Tz, Js, Lq};
                {tz, Tz, TzPer} -> {Xl, Tz - Reg, Js, Lq};
                {js, Js, JsPer} -> {Xl, Tz, Js - Reg, Lq};
                {lq, Lq, LqPer} -> {Xl, Tz, Js, Lq - Reg}
            end;
        Reg -> %% 少分配 分给最少值
            case do_sys_attr(min, [{tz, Tz, TzPer}, {js, Js, JsPer}, {lq, Lq, LqPer}], {xl, Xl, XlPer}) of
                {xl, Xl, XlPer} -> {Xl - Reg, Tz, Js, Lq};
                {tz, Tz, TzPer} -> {Xl, Tz - Reg, Js, Lq};
                {js, Js, JsPer} -> {Xl, Tz, Js - Reg, Lq};
                {lq, Lq, LqPer} -> {Xl, Tz, Js, Lq - Reg}
            end
    end.

%% 查找系统分配属性中最大项
do_sys_attr(max, [], Max) -> Max;
do_sys_attr(max, [{Key1, Val1, Per1} | T], {Key2, Val2, Per2}) ->
    case Val1 > Val2 of
        false -> do_sys_attr(max, T, {Key2, Val2, Per2});
        true -> do_sys_attr(max, T, {Key1, Val1, Per1})
    end;
%% 查找系统分配属性中最小项
do_sys_attr(min, [], Min) -> Min;
do_sys_attr(min, [{Key1, Val1, Per1} | T], {Key2, Val2, Per2}) ->
    case Val1 > Val2 andalso Per2 > 0 of
        false when Per1 > 0 -> do_sys_attr(min, T, {Key1, Val1, Per1});
        _ -> do_sys_attr(min, T, {Key2, Val2, Per2})
    end.

%% 获取背包内宠物口粮
find_food_from_bag(_Items, []) -> {false, ?L(<<"背包里没有仙宠口粮">>)};
find_food_from_bag(Items, [BaseId | T]) ->
    case storage:find(Items, #item.base_id, BaseId) of
        {false, _Reason} -> find_food_from_bag(Items, T);
        {ok, _Num, [Food | _], _, _} -> 
            case get_food_happy_value(BaseId) of
                {false, _Reason} -> find_food_from_bag(Items, T);
                {ok, Value} -> {ok, Value, Food}
            end
    end.

%% 获取宠物口粮的增益值
get_food_happy_value(BaseId) -> 
    case item_data:get(BaseId) of
        {ok, #item_base{effect = [{pet_happy, Value} | _]}} -> {ok, Value};
        _ -> {false, ?L(<<"宠物口粮无效">>)}
    end.

%% 移动多出技能到主宠
do_move_skill(MainSkills, _Num, []) -> MainSkills;
do_move_skill(MainSkills, Num, _Skills) when length(MainSkills) >= Num -> MainSkills;
do_move_skill(MainSkills, Num, Skills) ->
    Skill = {SkillId, Exp, _Args} = util:rand_list(Skills),
    do_move_skill(MainSkills ++ [{SkillId, Exp, []}], Num, Skills -- [Skill]).

%% 两个互斥技能合并
do_skill_join({SkillId1, Exp1, Args}, {SkillId2, Exp2, _Args}) ->
    NewSkillId = case SkillId1 < SkillId2 of
        false -> SkillId1;
        true -> SkillId2
    end,
    NewExp = Exp1 + Exp2,
    do_skill_upgrage({NewSkillId, NewExp, Args}).

%% 升级技能
do_skill_upgrage(Skill = {SkillId, Exp, Args}) ->
    case pet_data_skill:get(SkillId) of
        {false, _Reason} -> Skill;
        {ok, #pet_skill{next_id = 0, exp = NeedExp}} -> {SkillId, NeedExp, Args};
        {ok, #pet_skill{next_id = NId, exp = NeedExp}} when Exp >= NeedExp ->
            do_skill_upgrage({NId, Exp, Args});
        _ -> Skill
    end.

%% 生成随机系统分配比例
rand_sys_per(MR) ->
    rand_sys_per(MR, 100, {0, 0, 0, 0}).
rand_sys_per(_MR, 0, {XlPer, TzPer, JsPer, LqPer}) -> 
    #pet_attr_sys{
        xl_per = XlPer
        ,tz_per = TzPer
        ,js_per = JsPer
        ,lq_per = LqPer
    };
rand_sys_per(MR, Num, {XlPer, TzPer, JsPer, LqPer}) ->
    R = util:rand(1, MR),
    N = case R < Num of
        true -> R;
        false -> Num
    end,
    case util:rand(1, 4) of
        1 -> rand_sys_per(MR, Num - N, {XlPer + N, TzPer, JsPer, LqPer});
        2 -> rand_sys_per(MR, Num - N, {XlPer, TzPer + N, JsPer, LqPer});
        3 -> rand_sys_per(MR, Num - N, {XlPer, TzPer, JsPer + N, LqPer});
        4 -> rand_sys_per(MR, Num - N, {XlPer, TzPer, JsPer, LqPer + N})
    end.

%% 获取相应类型的当前潜力值
get_potential_val(1, #pet_attr{xl_val = Val, xl_max = Max}) -> {Val, Max};
get_potential_val(2, #pet_attr{tz_val = Val, tz_max = Max}) -> {Val, Max};
get_potential_val(3, #pet_attr{js_val = Val, js_max = Max}) -> {Val, Max};
get_potential_val(4, #pet_attr{lq_val = Val, lq_max = Max}) -> {Val, Max};
get_potential_val(_, _) -> false.

%% 生成多个随机宠物
do_rand_pet_list(_Refresh, 0, Pets) -> Pets;
do_rand_pet_list(Refresh, Num, Pets) ->
    Pet = rand_pet(Refresh, Num),
    do_rand_pet_list(Refresh, Num -1, [Pet | Pets]).

%% 随机生成一个宠物
rand_pet(Refresh, Id) ->
    PList = pet_data:list(),
    NewPetIds = [PetId || PetId <- PList, PetId =/= ?pet_new_id], %% 去掉新手宠
    BaseId = util:rand_list(NewPetIds), %% 随机获取宠物形像
    {ok, #pet_base{name = Name}} = pet_data:get(BaseId),
    {Min, Max} = rand_refresh_potential(Refresh),
    MR = rand_attr_sys_per(Refresh),
    AttrSys =  rand_sys_per(MR),            
    Attr = #pet_attr{
        xl_val = util:rand(Min, Max)
        ,tz_val = util:rand(Min, Max)
        ,js_val = util:rand(Min, Max)
        ,lq_val = util:rand(Min, Max)
    },
    DoubleTalent = #pet_double_talent{attr_list = [{1, AttrSys}]},
    Pet = #pet{
        id = Id
        ,name = Name
        ,base_id = BaseId
        ,skin_id = BaseId
        ,attr = Attr        
        ,attr_sys = AttrSys
        ,skill = rand_skills(Refresh, 2, [])
        ,double_talent = DoubleTalent
    },
    Pet. 

%% 生成多个宠物技能
rand_skills(_Refresh, 0, SList) -> SList;
rand_skills(Refresh, Num, SList) ->
    case rand_skill(Refresh) of
        false -> %% 生成技能失败 继续
            rand_skills(Refresh, Num, SList);
        {SkillId, Exp, Args} ->
            MutexList = pet_data_skill:mutex(SkillId),
            case check_mutex(MutexList, SList) of
                {ok, _} -> %% 技能重复 继续
                    rand_skills(Refresh, Num, SList);
                false -> %% 取到新技能
                    rand_skills(Refresh, Num - 1, [{SkillId, Exp, Args} | SList])
            end
    end.

%% 随机生成一个指定类型技能
rand_skill(?pet_type_golden) ->
    Step = get_rand_val(rand_step_val(?pet_type_golden)),
    case pet_data_skill:golden_step(Step) of
        R = {_Max, L} when is_list(L) ->
            SkillId = get_rand_val(R),
            Exp = get_skill_exp(Step),
            {SkillId, Exp, []};
        _ -> false
    end;
rand_skill(Refresh) ->
    Step = get_rand_val(rand_step_val(Refresh)),
    case pet_data_skill:step(Step) of
        R = {_Max, L} when is_list(L) ->
            SkillId = get_rand_val(R),
            Exp = get_skill_exp(Step),
            {SkillId, Exp, []};
        _ -> false
    end.

%% 根据随机设置获取随机项
get_rand_val({Max, L}) ->
    Rand = util:rand(1, Max),
    get_rand_val(Rand, L).
get_rand_val(_Rand, []) -> %% 设置概率数据合法 不可能出现事件
    false;
get_rand_val(Rand, [{Val, Min, Max} | T]) ->
    if
        Rand >= Min andalso Rand =< Max -> %% 随机值在区间内
            Val;
        true -> %% 随机值不在区间内 继续查找下一区间
            get_rand_val(Rand, T)
    end.

%% 检测某技能是否已在技能列表中存在 互斥关系
check_mutex(_MutexList, []) -> false;
check_mutex(MutexList, [I = {SkillId, _Exp, _Args} | T]) ->
    case lists:member(SkillId, MutexList) of
        true -> {ok, I};
        false -> check_mutex(MutexList, T)
    end.

%% 宠物技能个数
% get_skill_num(Avg) when Avg < 50 -> 2;
% get_skill_num(Avg) when Avg < 80 -> 3;
% get_skill_num(Avg) when Avg < 130 -> 4;
% get_skill_num(Avg) when Avg < 180 -> 5;
% get_skill_num(Avg) when Avg < 230 -> 6;
% get_skill_num(Avg) when Avg < 280 -> 7;
% get_skill_num(_Avg) -> 8.

% get_skill_add_num(Lev) when Lev >= 60 -> 2;
% get_skill_add_num(Lev) when Lev >= 50 -> 1;
% get_skill_add_num(_) -> 0.

%% 宠物类型
% get_type(Avg) when Avg >= 250 -> ?pet_type_orange;
% get_type(Avg) when Avg >= 200 -> ?pet_type_purple;
% get_type(Avg) when Avg >= 150 -> ?pet_type_blue;
% get_type(Avg) when Avg >= 100 -> ?pet_type_green;
% get_type(_Avg) -> ?pet_type_white.

%% 技能初始经验 
%% @spec get_skill_exp(Step) -> Exp
get_skill_exp(1) -> 1;
get_skill_exp(2) -> 2;
get_skill_exp(3) -> 4;
get_skill_exp(_) -> 0.

%%-------------------------------------------
%% 随机概率设置
%%-------------------------------------------

%% 生成技能阶数的随机值
%% {MaxRand, [{Step, Min, Max}]}  
%% MaxRand : util:rand(1, MaxRand).
%% Step = 1:一阶技能 2:二阶技能 3:三阶技能  
rand_step_val(?pet_type_green) -> %% 绿色刷新
    {100, [{1, 1, 85}, {2, 86, 100}]};
rand_step_val(?pet_type_blue) -> %% 蓝色刷新
    {100, [{1, 1, 90}, {2, 91, 100}]};
rand_step_val(?pet_type_purple) -> %% 紫色刷新
    {100, [{1, 1, 75}, {2, 76, 95}, {3, 96, 100}]};
rand_step_val(?pet_type_orange) -> %% 橙色刷新
    {100, [{1, 1, 55}, {2, 56, 90}, {3, 91, 100}]};
rand_step_val(?pet_type_golden) -> %% 金色刷新
    {100, [{1, 1, 61}, {2, 62, 96}, {3, 97, 100}]};
rand_step_val(_) ->
    {1, [{1, 1, 1}]}.

%% 生成新技能随机

%% 随机技能刷新类型值
%% {MaxRand, [{RefreshType, Min, Max}]}  
%% MaxRand : util:rand(1, MaxRand).
%% RefreshType = 1:绿色刷新 2:蓝色刷新 3:紫色刷新 4:橙色刷新 
rand_refresh_type() ->
    {100, [
            {?pet_type_green, 1, 80}
            ,{?pet_type_blue, 81, 90}
            ,{?pet_type_purple, 91, 97}
            ,{?pet_type_orange, 98, 100}
        ]
    }.

%% 潜力刷新数值范围设定
rand_refresh_potential(?pet_type_white) -> {20, 40}; %% 白
rand_refresh_potential(?pet_type_green) -> {20, 50}; %% 绿
rand_refresh_potential(?pet_type_blue) -> {20, 50}; %% 蓝
rand_refresh_potential(?pet_type_purple) -> {60, 60}; %% 紫
rand_refresh_potential(?pet_type_orange) -> {50, 120}; %% 橙
rand_refresh_potential(?pet_type_golden) -> {68, 68}; %% 金蛋
rand_refresh_potential(_) -> {20, 20}. %% 容错其它

%% 提升潜力成功值
%% {MaxRand, [{Val, Min, Max}]} 
%% MaxRand : util:rand(1, MaxRand).
%% Val = 提升的点数
%%rand_potential_add_val() ->
%%    {3, [{1, 1, 1}, {2, 2, 2}, {3, 3, 3}]}.

%% 洗随变化情况(宠物属性分配比) 单次分配值 值越大 分配波动越大
rand_attr_sys_per(?pet_type_white) -> 1; %% 白
rand_attr_sys_per(?pet_type_green) -> 3; %% 绿
rand_attr_sys_per(?pet_type_blue) -> 5; %% 蓝
rand_attr_sys_per(?pet_type_purple) -> 7; %% 紫
rand_attr_sys_per(?pet_type_orange) -> 9; %% 橙
rand_attr_sys_per(reset) -> 10; %% 洗髓
rand_attr_sys_per(_) -> 1. %% 容错其它

%%新的宠物洗点规则，单项属性40%以下为普通 单项属性过40%为良 单项属性过50%为优 单项属性过60%为极品                             
rand_new_sys_per() ->
    X = util:rand(1, 100),
    List_Per = get_val(X),
    L = get_rand_seq([], 4),
    List_Per2 = lists:map(fun(N) ->lists:nth(N, List_Per) end, L),
    {XlPer, TzPer, JsPer, LqPer} = list_to_tuple(List_Per2),
     #pet_attr_sys{
        xl_per = XlPer
        ,tz_per = TzPer
        ,js_per = JsPer
        ,lq_per = LqPer
    }.
get_val(X) when X < 5 -> %% 5%的概率为极品
    A = util:rand(60, 99),
    B = 
        case 100 - A > 0 of 
            true ->
                util:rand(1, 100 - A);
            false ->
                0
        end,
    C = 
        case 100 -A - B > 0 of 
            false ->
                0;
            true ->
                util:rand(1, 100 - A - B)
        end,
    D = 100 - A - B - C,
    [A, B, C, D];
get_val(X) when X < 20 -> %% 15%的概率为优秀
    A = util:rand(50, 60),
    [A|get_val_res(1, 39, 100 - A)];
get_val(X) when X < 40 -> %% 20%的概率为良
    A = util:rand(40, 50),
    [A|get_val_res(1, 39, 100 - A)];
get_val(_)  -> %% 60%的概率为普通
    A = util:rand(1, 40),
    [A|get_val_res(1, 40, 100 - A)].
get_val_res(Min, Max, Total) ->
    T1 = util:rand(Min, Max),
    T2 = util:rand(Min, Max),
    T3 = Total - T1 - T2,
    if  T3 > 0, T3 < Max ->
            [T1, T2, T3];
        true ->
            get_val_res(Min, Max, Total)
    end.
get_rand_seq(L, 0) -> L;
get_rand_seq(L, N) ->
    T = util:rand(1, 4),
    case lists:member(T, L) of 
        true -> get_rand_seq(L, N);
        false -> get_rand_seq([T|L], N - 1)
    end.



%%获取宠物新的技能id
get_new_skill(Skill_List, Item_SkillId) ->
    TempSkill =  erlang:round(Item_SkillId / 100),
    {Low_SkillId, Low_Exp, _} = find_skill(Skill_List, TempSkill),   %%找到已有技能id

    _Low_Step = erlang:round(Low_SkillId / 100) rem 10,   %%所属的阶
    
    Low_Exp_Cost = get_exp_cost2(Low_SkillId), %%较低阶已消耗的经验值

    Low_Exp_All = Low_Exp + Low_Exp_Cost,
    {New_SkillId, New_Exp} = calc_new_skillid2(Item_SkillId, Low_Exp_All),  %%由物品对应技能id与总exp计算新的技能id
    Need_Exp = get_next_exp(New_SkillId), %%根据新的技能id算出该id下一级需要的经验值
    {New_SkillId, New_Exp, Need_Exp}.

%%查询已有宠物技能
find_skill([], _) -> {0, 0};
find_skill([{Id, Exp, Loc, _}|T], F) -> 
    case erlang:round(Id / 100) == (F - 1) of %%F-1表示将较高阶降为较低阶
        true ->
            {Id, Exp, Loc};
        false ->
            find_skill(T, F)
    end.
%%获得宠物技能升级已消耗的经验
get_exp_cost2(SkillId) ->
    Low_Lev = SkillId - (SkillId div 100) * 100,
    Temp = SkillId - Low_Lev + 1, %% 得到第一级
    do_calc(Temp, Temp + Low_Lev, 0).

do_calc(_Temp, _Temp, All)-> All;
do_calc(Temp, TLev, All)-> 
    case pet_data_skill:get(Temp) of
        {ok, #pet_skill{exp = Exp}} -> 
            do_calc(Temp + 1, TLev, All + Exp);
        _ -> 
            ?ERR("有找不到基础数据的宠物技能id为~p", [Temp]),
            do_calc(Temp + 1, TLev, All)
    end.
  
%%计算新的技能id                 
calc_new_skillid2(SkillId, Low_Exp_All) -> %%技能id，总的经验值
    case Low_Exp_All > 0 of 
        true ->
            case pet_data_skill:get(SkillId) of 
                {ok, #pet_skill{exp = Exp}} ->
                    case Low_Exp_All >= Exp of 
                        true ->
                            calc_new_skillid2(SkillId + 1, Low_Exp_All - Exp);
                        false -> 
                            {SkillId, Low_Exp_All}
                    end;
                _ -> 
                    ?ERR("有找不到基础数据的宠物技能id为~p", [SkillId]),
                    {SkillId, 0}
            end;
        false -> {SkillId, 0}
    end.


% calc_new_skillid(SkillId, Low_Exp_All) -> %%技能id，总的经验值
%     case Low_Exp_All of 
%         0 ->        %%总的经验值为0
%             {SkillId, 0};
%         _ -> 
%             Temp = erlang:round(SkillId / 100),
%             List = 
%                 case Temp rem 10 of %% 获取属于哪一个阶
%                     2 ->
%                         pet_data_skill:get_all_lev_exp_by_step(2);
%                     3 ->
%                         pet_data_skill:get_all_lev_exp_by_step(3)
%                 end,
%             {NLev, Left_Exp} = cal_new_lev(Low_Exp_All, List),
%             {Temp * 100 + NLev, Left_Exp}
%     end.
% cal_new_lev(Low_Exp_All, List) ->
%     do_cal_new_lev(Low_Exp_All, List, 1).
% do_cal_new_lev(NExp, [], N) -> {N, NExp};
% do_cal_new_lev(NExp, [H|T], N) ->
%     case NExp - H =< 0 of
%         true ->
%             {N - 1, NExp};
%         false ->
%             do_cal_new_lev(NExp - H, T, N + 1)
%     end.



% get_lev(Exp,N,T) ->
%     case (T1 = erlang:round(math:pow(2,N)) + T)  > Exp of 
%         true ->
%             {N,Exp-T};
%         false ->
%             get_lev(Exp,N + 1,T1)
%     end.
%%根据技能id算出下一级需要的经验
get_next_exp(New_SkillId) -> %%该技能为合成的技能，为中阶或者高阶
    case pet_data_skill:get(New_SkillId + 1) of
        {ok, #pet_skill{exp = Exp}} -> Exp;
        _ -> 
            ?ERR("有找不到基础数据的宠物技能id为~p", [New_SkillId]),
            0
    end.

% get_next_exp(New_SkillId) -> %%该技能为合成的技能，为中阶或者高阶
%     Lev = New_SkillId rem 10,
%     Step = erlang:round(New_SkillId / 100) rem 10,
%     Exp_List = 
%         case Step of 
%             2 ->
%                 pet_data_skill:get_all_lev_exp_by_step(2);
%             3 ->
%                 pet_data_skill:get_all_lev_exp_by_step(3)
%         end,
%     lists:nth(Lev + 1, Exp_List).

%%更新宠物技能列表,ID表示物品对应的{pet_skill,ID}
update_skill(ID, Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{skill = Skill, skill_slot = Skill_slot, skill_num = Skill_num}}}) ->
    TempSkill =  erlang:round(ID / 100),
    {NSkill1, ActID, NSkill_slot, NSkill_num} = 
        case TempSkill rem 10 == 1 of  
            true ->   %%低阶，直接学习
                Loc = lists:nth(1, lists:sort(Skill_slot)),
                {[{ID, 0, Loc, []}|Skill], ID, Skill_slot -- [Loc], Skill_num - 1};
            false ->
                {Low_SkillId, _, Loc} = find_skill(Skill, TempSkill), 
                NSkill = lists:keydelete(Low_SkillId, 1, Skill), %%替换掉旧的技能
                {New_SkillId, New_Exp, _} = get_new_skill(Skill, ID),

                {[{New_SkillId, New_Exp, Loc, []}|NSkill], New_SkillId, Skill_slot, Skill_num}
        end,

    random_award:dragon_skill(Role, ActID div 100),

    NPet = Pet#pet{skill = NSkill1, skill_slot = NSkill_slot, skill_num = NSkill_num},
    
    NPet1 = deal_buff_skill(add, ID, NPet),

    NRole = Role#role{pet = PetBag#pet_bag{active = NPet1}},
    NRole1 = reset(NPet1, NRole),

    push_pet2(refresh, NRole1),
    NRole2 = role_listener:special_event(NRole1, {1071, ActID}), 
    {ok, NRole2, NSkill1}.

%% 反击buff的增加是直接替换的方式,目前是只有一种技能会带来反击Buff所以才适用
deal_buff_skill(add, SkillId, Pet = #pet{attr = Attr = #pet_attr{anti_attack = _Anti_Attack}}) ->
    case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{type = Type, args = Args}} ->
            case Type == ?pet_skill_type_buff of 
                true ->
                    [Arg|_] = Args,
                    Pet#pet{attr = Attr#pet_attr{anti_attack = Arg}};
                false ->
                    Pet
            end;
        {false, _} ->
            Pet
    end;

deal_buff_skill(del, SkillId, Pet = #pet{attr = Attr = #pet_attr{anti_attack = Anti_Attack}}) ->
    case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{type = Type, args = Args}} ->
            case Type == ?pet_skill_type_buff of 
                true ->
                    [Arg|_] = Args,
                    Pet#pet{attr = Attr#pet_attr{anti_attack = Anti_Attack - Arg}};
                false ->
                    Pet
            end;
        {false, _} ->
            Pet
    end;

deal_buff_skill(_Label, _SkillId, Pet) ->
    Pet.

%%获取潜能值对应的成功率
get_ratio(Val) ->
    List = pet_asc_ratio:get_all_ratio_step(),
    Next = find(Val, List, lists:nth(1, List)),
    pet_asc_ratio:get_val(Next).

find(_Val, [], F) -> F;
find(Val, [H|T], _F) ->
    case Val > H of 
        true ->
            find(Val, T, H);
        false ->
            H
    end.

 %%获取潜能值对应的技能槽的个数   
get_slot(Avg) ->
    List =pet_asc_ratio:get_all_step(),
    Num = find2(Avg, List, 1),
    lists:nth(Num, pet_asc_ratio:get_all_slot()).

find2(_Avg, [], Num) -> Num - 1;
find2(Avg, [H|T], Num) ->
    case Avg >= H of 
        true ->
            find2(Avg, T, Num + 1);
        false ->
            Num - 1
    end.

