%%----------------------------------------------------
%% 宠物版本控制
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(pet_parse).
-export([
        do/1
        ,do_pet/1
        ,do_pets/2
    ]
).

-include("common.hrl").
-include("pet.hrl").

%% @spec do(OldPetBag) -> {ok, NewPetBag} | {false, Reason}
%% 宠物版本转换
do({pet_bag, Ver = 0, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log}) ->
    do({pet_bag, Ver + 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log});
do({pet_bag, Ver = 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log}) ->
    do({pet_bag, Ver + 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log});
do({pet_bag, Ver = 2, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log}) ->
    do({pet_bag, Ver + 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log});
do({pet_bag, Ver = 3, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log}) ->
    do({pet_bag, Ver + 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, [], 0, 0, 0});
do({pet_bag, Ver = 4, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, Skins, SkinId, SkinGrade, SkinTime}) ->
    do({pet_bag, Ver + 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, Skins, SkinId, SkinGrade, SkinTime, #pet_hunt{}});
do({pet_bag, Ver = 5, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, Skins, SkinId, SkinGrade, SkinTime, PetHunt}) ->
    do({pet_bag, Ver + 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, Skins, SkinId, SkinGrade, SkinTime, PetHunt, []});
do({pet_bag, Ver = 6, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, Skins, SkinId, SkinGrade, SkinTime, PetHunt, Talk}) ->
    do({pet_bag, Ver + 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, Skins, SkinId, SkinGrade, SkinTime, PetHunt, Talk, #pet_cloud{}});
do({pet_bag, Ver = 7, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, Skins, SkinId, SkinGrade, SkinTime, PetHunt, Talk, PetCloud}) ->
    do({pet_bag, Ver + 1, Pets, Active, Deposit, NextId, LastTime, RenameNum, ExpTime, CatchPet, Log, Skins, SkinId, SkinGrade, SkinTime, PetHunt, Talk, PetCloud, ?pet_default_num});
do(PetBag = #pet_bag{ver = ?PET_BAG_VER}) ->
    case parse_field(PetBag, [active, deposit, pets]) of
        {false,Reason} ->
            {false, Reason};
        {ok, NewPetBag} ->
            NewPetBag1 = init_skins(NewPetBag),
            NewPetBag2 = init_speak(NewPetBag1),
            {ok, NewPetBag2}
    end;
do(_PetBag) ->
    ?ERR("宠物数据转换失败"),
    {false, ?L(<<"宠物版本转换失败">>)}.

%%---------------------------
%% 内部方法
%%---------------------------
%% 初始化宠物外观列表
init_skins(PetBag = #pet_bag{skins = []}) ->
    init_skins(PetBag, [active, pets, deposit]);
init_skins(PetBag = #pet_bag{skins = Skins}) -> PetBag#pet_bag{skins = pet_ex:fix_skins(Skins, [])}.

init_skins(PetBag, []) -> PetBag;
init_skins(PetBag, [Field | T]) ->
    NewPetBag = do_init_skins(Field, PetBag),
    init_skins(NewPetBag, T).

do_init_skins(active, PetBag = #pet_bag{active = undefined}) ->
    PetBag;
do_init_skins(active, PetBag = #pet_bag{active = #pet{base_id = BaseId}, skins = Skins}) ->
    PetBag#pet_bag{skins = pet_ex:add_skins([BaseId], Skins)};
do_init_skins(pets, PetBag = #pet_bag{pets = []}) ->
    PetBag;
do_init_skins(pets, PetBag = #pet_bag{pets = Pets, skins = Skins}) ->
    PetBag#pet_bag{skins = pet_ex:add_skins([BaseId || #pet{base_id = BaseId} <- Pets], Skins)};
do_init_skins(deposit, PetBag = #pet_bag{deposit = {0, _, _}}) ->
    PetBag;
do_init_skins(deposit, PetBag = #pet_bag{deposit = {#pet{base_id = BaseId}, _, _}, skins = Skins}) ->
    PetBag#pet_bag{skins = pet_ex:add_skins([BaseId], Skins)};
do_init_skins(_, PetBag) -> PetBag.

parse_field(PetBag, []) -> {ok, PetBag};
parse_field(PetBag, [Field | T]) ->
    case do_parse_field(Field, PetBag) of
        {false, Reason} -> {false, Reason};
        {ok, NewPetBag} ->
            parse_field(NewPetBag, T)
    end.

%% 初始化宠物自定义对话列表
init_speak(PetBag = #pet_bag{custom_speak = []}) ->
    SpeakList = petspeak_data:get_custom(),
    PetBag#pet_bag{custom_speak = init_speak(SpeakList, [])};
init_speak(PetBag) -> PetBag.

init_speak([], List) -> List;
init_speak([Id | T], List) ->
    case petspeak_data:get(Id) of
        false ->
            init_speak(T, List);
        {ok, #pet_speak{content = Content}} ->
            init_speak(T, [{Id, Content} | List])
    end.

%% 宠物背包各属性转换
do_parse_field(active, PetBag = #pet_bag{active = undefined}) -> %% 出战宠物转换
    {ok, PetBag};
do_parse_field(active, PetBag = #pet_bag{active = Active}) ->
    case do_pet(Active) of
        {false, Reason} -> {false, Reason};
        {ok, NewActive} ->
            {ok, PetBag#pet_bag{active = NewActive}}
    end;
do_parse_field(pets, PetBag = #pet_bag{pets = Pets}) -> %% 休息宠物转换
    case do_pets(Pets, []) of
        {false, Reason} -> {false, Reason};
        {ok, NewPets} ->
            {ok, PetBag#pet_bag{pets = NewPets}}
    end;
do_parse_field(deposit, PetBag = #pet_bag{deposit = {0, _, _}}) -> %% 寄养宠物转换
    {ok, PetBag};
do_parse_field(deposit, PetBag = #pet_bag{deposit = {Pet, A, B}}) ->
    case do_pet(Pet) of
        {ok, NewPet} ->
            {ok, PetBag#pet_bag{deposit = {NewPet, A, B}}};
        {false, Reason} ->
            {false, Reason}
    end.

%%------------------------------
%% 宠物数据转换
%%------------------------------

%% 转换多个宠物
do_pets([], Pets) -> {ok, Pets};
do_pets([I | T], Pets) ->
    case do_pet(I) of
        {ok, Pet} ->
            do_pets(T, [Pet | Pets]);
        {false, Reason} ->
            {false, Reason}
    end.

%% 转换一个宠物数据
do_pet({pet, Ver = 0, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind}) ->
    NewSkills = [{SkillId, SkillExp,[]} || {SkillId, SkillExp} <- Skills],
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, NewSkills, SkillNum, WashList, FightCap, Bind, []},
    do_pet(NewPet);
do_pet({pet, Ver = 1, Id, Name, BaseId, Type, Lev, Mod, _GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr}) ->
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, 0, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, 0},
    do_pet(NewPet);
do_pet({pet, Ver = 2, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish}) ->
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, 0},
    do_pet(NewPet);
do_pet({pet, Ver = 3, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo}) ->
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, []},
    do_pet(NewPet);
do_pet({pet, Ver = 4, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff}) ->
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, to_change(Evo), Buff},
    do_pet(NewPet);
do_pet({pet, Ver = 5, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff}) ->
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, init_attr_list(AttrSys)},
    do_pet(NewPet);
do_pet({pet, Ver = 6, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent}) ->
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, 0, 0},
    do_pet(NewPet);
do_pet({pet, Ver = 7, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade}) -> %% 增加宠物装备
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, 0, []},
    do_pet(NewPet);
do_pet({pet, Ver = 8, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, EqmNum, Eqm}) -> %% 增加宠物装备
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, EqmNum, Eqm, []},
    do_pet(NewPet);
do_pet({pet, Ver = 9, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, EqmNum, Eqm, ExtAttr}) -> %% 增加宠物云朵等级
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, EqmNum, Eqm, ExtAttr, 0},
    do_pet(NewPet);
do_pet({pet, Ver = 10, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, EqmNum, Eqm, ExtAttr, CloudLev}) -> %% 增加宠物属性物品使用上限
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, EqmNum, Eqm, ExtAttr, CloudLev, []},
    do_pet(NewPet);
do_pet({pet, Ver = 11, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, EqmNum, Eqm, ExtAttr, CloudLev, ExtAttrLimit}) -> %% 宠物飞升
    NewPet = {pet, Ver + 1, Id, Name, BaseId, Type, Lev, Mod, GrowVal, HappyVal, Exp, Attr, AttrSys, Skills, SkillNum, WashList, FightCap, Bind, AppendAttr, Wish, Evo, Buff, DoubleTalent, SkinId, SkinGrade, EqmNum, Eqm, ExtAttr, CloudLev, ExtAttrLimit, 0, 0},
    do_pet(NewPet);
do_pet(Pet = #pet{ver = ?PET_VER, eqm = Eqm, attr = Attr}) -> 
    case do_pet_attr(Attr) of
        {false, Reason} -> {false, Reason};
        {ok, NewAttr} -> 
            case item_parse:do(Eqm) of
                {ok, NewEqm} ->
                    {ok, Pet#pet{attr = NewAttr, eqm = NewEqm}};
                {false, Reason} ->
                    ?ERR("角色宠物装备数据转换失败"),
                    {false, Reason}
            end
    end;
do_pet(_Pet) -> 
    ?ERR("宠物数据结构不正常，转换失败"),
    
    {false, ?L(<<"宠物数据结构不正常">>)}.


%% ----------------------
%% 内部方法
%% ----------------------
to_change(2) -> 3;
to_change(Evo) -> Evo.

init_attr_list(AttrSys = #pet_attr_sys{}) ->
    #pet_double_talent{attr_list = [{1, AttrSys}]};
init_attr_list(_AttrSys) ->
    ?ERR("宠物天赋数据出错:~w",[_AttrSys]),
    #pet_double_talent{}.
%% 转换宠物属性数据
do_pet_attr({pet_attr, Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, AvgVal, Hp, Mp, HpMax, MpMax, Dmg, Cri, Def, Ten, Hit, Eva}) ->
    do_pet_attr({pet_attr, Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, AvgVal, Hp, Mp, HpMax, MpMax, Dmg, Cri, Def, Ten, Hit, Eva, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
do_pet_attr({pet_attr, Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, AvgVal, Hp, Mp, HpMax, MpMax, Dmg, Cri, Def, Ten, Hit, Eva, DmgMagic, AntiJs, Attack, Seal, Stone, Stun, Sleep, Taunt, Silent, Polison, Blood, Rebound, Metal, Wood, Water, Fire, Earth}) ->
    do_pet_attr({pet_attr, Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, AvgVal, Hp, Mp, HpMax, MpMax, Dmg, Cri, Def, Ten, Hit, Eva, DmgMagic, AntiJs, Attack, Seal, Stone, Stun, Sleep, Taunt, Silent, Polison, Blood, Rebound, Metal, Wood, Water, Fire, Earth, 300, 300, 300, 300});
do_pet_attr(Attr = #pet_attr{}) ->
    {ok, Attr};
do_pet_attr(_) ->
    ?ERR("宠物属性数据转换失败"),
    {false, ?L(<<"宠物属性数据不正常">>)}.
