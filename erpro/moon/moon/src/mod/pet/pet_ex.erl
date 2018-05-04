%%----------------------------------------------------
%% 宠物系统额外功能 
%% @author lishen(105326073@qq.com)
%%----------------------------------------------------
-module(pet_ex).
-export([
        change_skin/3
        ,cancel_skin_time/1
        ,add_skins/2
        ,add_skin_and_push/5
        ,update_skin_and_push/1
        ,update_skin_and_push/2
        ,push_skins/4
        ,fix_skins/2
        ,talk/2
        ,talk/3
        ,talk/5
        ,text_banned/1
        ,check_custom_speak/1
        ,use_cloud_item/2
        ,clean_pet_cloud/1
        ,calc_looks/1
        ,calc_cloud_attr/2
        ,init_cloud_attr/3
    ]).

%%
-include("pet.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("common.hrl").
-include("item.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("map.hrl").
-include("combat.hrl").
-include("condition.hrl").
-include("looks.hrl").

%%----------------------------------------------
%% 后台命令
%%----------------------------------------------
clean_pet_cloud(Role = #role{pet = PetBag, looks = Looks}) ->
    Role#role{pet = PetBag#pet_bag{cloud = #pet_cloud{}}, looks = lists:keydelete(?LOOKS_TYPE_PET_CLOUD, 1, Looks)}.

%%----------------------------------------------
%% 外部接口
%%----------------------------------------------
%% @spec change_skin(SkinId, Grade, Role) -> {ok, Time, NewRole} | {false, Reason}
%% SkinId = Grade = Time = integer()
%% Role = NewRole = #role{}
%% @doc 更换外观
change_skin(_SkinId, _Grade, #role{pet = #pet_bag{active = undefined}}) ->
    {false, ?L(<<"当前没有出战中的仙宠，更换外观失败">>)};
change_skin(_SkinId, 1, #role{pet = #pet_bag{active = #pet{evolve = Evo}}}) when Evo < 1 ->
    {false, ?L(<<"当前仙宠没有进化到仙级形象，不能选用仙级形象。">>)};
change_skin(_SkinId, 2, #role{pet = #pet_bag{active = #pet{evolve = Evo}}}) when Evo < 2 ->
    {false, ?L(<<"当前仙宠没有进化到帝级形象，不能选用帝级形象。">>)};
change_skin(_SkinId, 3, #role{pet = #pet_bag{active = #pet{evolve = Evo}}}) when Evo < 3 ->
    {false, ?L(<<"当前仙宠没有进化到神级形象，不能选用神级形象。">>)};
change_skin(SkinId, Grade, Role = #role{pet = PetBag = #pet_bag{active = Pet, skins = Skins, skin_time = Time}}) ->
    Now = util:unixtime(),
    case Now > Time of
        true ->
            case lists:member(SkinId, Skins) of
                false -> {false, ?L(<<"您还没拥有该宠物外观">>)};
                true ->
                    BaseId = pet_data:get_next_baseid(Grade, SkinId),
                    NextTime = Now + 3600 * 12,
                    NewPet = Pet#pet{base_id = BaseId, skin_id = BaseId, skin_grade = Grade},
                    pet_api:push_pet(refresh, [NewPet], Role),
                    NewRole = Role#role{pet = PetBag#pet_bag{active = NewPet, skin_time = NextTime}},
                    {ok, 3600 * 12, pet_api:broadcast_pet(NewPet, NewRole)}
            end;
        false ->
            {false, ?L(<<"冷却时间还没到，不能更换宠物形象">>)}
    end.

%% @spec cancel_skin_time(Role) -> {ok, NewRole} | {false, Msg}
%% Role = NewRole = #role{}
%% @doc 取消更换外观冷却时间
cancel_skin_time(Role = #role{pet = PetBag = #pet_bag{skin_time = Time}}) ->
    Now = util:unixtime(),
    case Time > Now of
        true ->
            Gold = pay:price(?MODULE, cancel_skin_time, (Time - Now)),
            case role_gain:do([#loss{label = gold, val = Gold, msg = ?L(<<"晶钻不足，不能取消冷却时间">>)}], Role) of
                {false, #loss{msg = Msg}} ->
                    {false, Msg};
                {ok, Role1} ->
                    {ok, Role1#role{pet = PetBag#pet_bag{skin_time = 0}}}
            end
    end.

%% @spec add_skins(Skins, NewSkins) -> NewSkins.
%% Skins = NewSkins = [SkinId, ....]
%% @doc 增加宠物外观
add_skins([], Skins) -> Skins;
add_skins([BaseId0 | T], Skins)->
    BaseId = pet_data:get_next_baseid(0, BaseId0),
    case lists:member(BaseId, Skins) of
        true ->
            add_skins(T, Skins);
        false ->
            add_skins(T, [(BaseId) | Skins])
    end.

%% 更新外观并推送
update_skin_and_push(Role = #role{pet = PetBag = #pet_bag{skins = Skins, active = #pet{skin_grade = SkinGrade, skin_id = SkinId, base_id = BaseId}}}) ->
    BaseId0 = pet_data:get_next_baseid(0, BaseId),
    case lists:member(BaseId0, Skins) of
        true -> %% 外观数量不变
            push_skins(PetBag, SkinId, SkinGrade, Role#role.link#link.conn_pid),
            Role;
        false -> %% 新外观
            NewPetBag = PetBag#pet_bag{skins = [BaseId0 | Skins]},
            push_skins(NewPetBag, SkinId, SkinGrade, Role#role.link#link.conn_pid),
            pet_api:reset_all(Role#role{pet = NewPetBag})
    end;
update_skin_and_push(Role) -> 
    Role.

%% 更新外观并推送
update_skin_and_push(Role = #role{pet = PetBag = #pet_bag{skins = Skins, active = ActivePet}}, #pet{base_id = BaseId}) ->
    BaseId0 = pet_data:get_next_baseid(0, BaseId),
    case lists:member(BaseId0, Skins) of
        true -> %% 外观数量不变
            Role;
        false -> %% 新外观
            NewPetBag = PetBag#pet_bag{skins = [BaseId0 | Skins]},
            {SkinId, SkinGrade} = case ActivePet =:= undefined of
                true -> {0, 0};
                false -> {ActivePet#pet.skin_id, ActivePet#pet.skin_grade}
            end,
            push_skins(NewPetBag, SkinId, SkinGrade, Role#role.link#link.conn_pid),
            pet_api:reset_all(Role#role{pet = NewPetBag})
    end;
update_skin_and_push(Role, _Pet) -> 
    Role.


%% @spec add_skin_and_push(NewSkinId, PetBag, UseSkinId, SkinGrade, ConnPid) -> NewPetBag.
%% NewSkinId = integer() 新增皮肤Id
%% PetBag = NewPetBag = #pet_bag{}
%% UseSkinId = UseGrade = integer() 使用的皮肤ID和皮肤等级
%% @doc 增加宠物外观
add_skin_and_push(NewSkinId, PetBag = #pet_bag{skins = Skins}, UseSkinId, UseGrade, ConnPid) ->
    BaseId = pet_data:get_next_baseid(0, NewSkinId),
    case lists:member(BaseId, Skins) of
        true ->
            push_skins(PetBag, UseSkinId, UseGrade, ConnPid),
            PetBag;
        false ->
            NewPetBag = PetBag#pet_bag{skins = [BaseId | Skins]},
            push_skins(NewPetBag, UseSkinId, UseGrade, ConnPid),
            NewPetBag
    end.
      
%% @spec push_skins(PetBag, SkinId, Grade, ConnPid) -> ok.
%% PetBag = #pet_bag{}
%% SkinId = Grade = integer()
%% ConnPid = pid()
%% @doc 推送宠物外观列表
push_skins(#pet_bag{skins = Skins, skin_time = Time}, SkinId, Grade, ConnPid) ->
    Now = util:unixtime(),
    RemainTime = case Time > Now of
        true ->
            Time - Now;
        false ->
            0
    end,
    sys_conn:pack_send(ConnPid, 12640, {RemainTime, pet_data:get_next_baseid(0, SkinId), Grade, Skins}).

%% @spec fix_skins(Skins, NewSkins) -> NewSkins.
%% Skins = NewSkins = [SkinId, ....]
%% @doc 修复宠物外观列表
fix_skins([], NewSkins) -> NewSkins;
fix_skins([SkinId | T], NewSkins) ->
    fix_skins(T, [pet_data:get_next_baseid(0, SkinId) | NewSkins]).

%% @spec talk(lev, Lev) -> ok.
%% Lev = integer()
%% @doc 宠物说话（主人升级类型）
talk(role_lev, Role) ->
    IdList = petspeak_data:get_id_by_type(5),
    handle_talk(role_lev, IdList, Role);
talk(_Flag, _Data1) -> ok.

%% @spec talk(eqm, Item, Role) -> ok.
%% Item = #item{}, Role = #role{}
%% @doc 宠物说话（装备一件装备类型）
talk(eqm, Item, Role = #role{}) ->
    IdList = petspeak_data:get_id_by_type(3),
    handle_talk(eqm, IdList, Item, Role);
talk(pet_lev, #pet{lev = Lev}, Role) ->
    IdList = petspeak_data:get_id_by_type(6),
    handle_talk(pet_lev, IdList, Lev, Role);
talk(_Flag, _Data1, _Data2) -> ok.

%% @spec talk(fight, Round, Fighter) -> ok.
%% Round = integer(), Fighter = #fighter{}
%% @doc 宠物说话（战斗AI类型）
talk(fight, Round, Fighter = #fighter{}, PetId, RoleList) ->
    IdList = petspeak_data:get_id_by_type(11),
    handle_talk(fight, IdList, Round, Fighter, PetId, RoleList);
%% @spec talk(combat, CombatData, Fighter) -> ok.
%% Event = integer(), Fighter = #fighter{}
%% @doc 宠物说话（战斗事件类型）
talk(combat, Event, Fighter = #fighter{}, PetId, RoleList) ->
    IdList = petspeak_data:get_id_by_type(1),
    handle_talk(combat, IdList, Event, Fighter, PetId, RoleList);
talk(_Flag, _Data1, _Data2, _Data3, _Data4) -> ok.

%% @spec text_banned(Text) -> bool()
%% Text = string()
%% @doc 检查文本中是否含有非法字符或者关键词，返回true表示需要屏蔽，false表示可以通过
text_banned(Text) when is_bitstring(Text) ->
    do_text_banned(Text);
text_banned(Text) when is_list(Text) ->
    do_text_banned(list_to_bitstring(Text));
text_banned(_) ->
    false.

%% @spec check_custom_speak(SpeakList) -> NewSpeakList.
%% SpeakList = [{Id, Content}, ...]
%% @doc 检查宠物自定义对话
check_custom_speak(SpeakList) ->
    CustomList = petspeak_data:get_custom(),
    NewSpeakList = remove_unused_speak(SpeakList, CustomList, []),
    check_custom_speak(CustomList, NewSpeakList).

%% @spec use_cloud_item(Role, Num) -> {ok, NewRole} | {false, Reason}.
%% @doc 使用筋斗云道具
use_cloud_item(#role{pet = #pet_bag{cloud = #pet_cloud{lev = Lev}}}, _Num) when Lev >= 100 -> {false, ?L(<<"仙宠彩云已达到最大等级30级，无法再升级">>)};
use_cloud_item(Role = #role{lev = RoleLev, looks = Looks, pet = PetBag = #pet_bag{active = undefined, pets = Pets, cloud = #pet_cloud{lev = Lev, exp = Exp}}, link = #link{conn_pid = ConnPid}}, Num) ->
    case RoleLev =< Lev of
        true ->
            {false, ?L(<<"彩云使用数量无法超过您的人物等级">>)};
        false ->
            {NewLev, NewExp} = handle_cloud_item(Lev, Exp, Num, RoleLev),
            sys_conn:pack_send(ConnPid, 12652, {0, <<>>, NewLev, NewExp}),
            if
                NewLev > Lev andalso Lev =:= 0 ->  %% 获得筋斗云
                    NewLooks = calc_cloud_looks(NewLev, Looks),
                    ?DEBUG("NewLev = ~w, Lev = ~w, Looks = ~w", [NewLev, Lev, NewLooks]),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{looks = NewLooks, pet = PetBag#pet_bag{pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    map:role_update(NewRole),
                    pet_api:push_pet(refresh, NewPets, NewRole),
                    ProtoMsg = {?true, ?L(<<"使用成功，仙宠获得了一朵神秘的仙宠彩云。">>)},
                    {ok, ProtoMsg, NewRole};
                NewLev > Lev andalso NewLev rem 5 =:= 0, NewLev < 30  ->  %% 筋斗云升级并升品质
                    NewLooks = calc_cloud_looks(NewLev, Looks),
                    ?DEBUG("NewLev = ~w, Lev = ~w, Looks = ~w", [NewLev, Lev, NewLooks]),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{looks = NewLooks, pet = PetBag#pet_bag{pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    map:role_update(NewRole),
                    pet_api:push_pet(refresh, NewPets, NewRole),
                    ProtoMsg = {?true, util:fbin(?L(<<"仙宠彩云增加了~w点升级经验，升级成功，属性得到了大幅提高。">>), [Num])},
                    {ok, ProtoMsg, NewRole};
                NewLev > Lev andalso NewLev =:= 50  ->  %% 筋斗云升级并升品质
                    NewLooks = calc_cloud_looks(30, Looks),
                    ?DEBUG("NewLev = ~w, Lev = ~w, Looks = ~w", [NewLev, Lev, NewLooks]),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{looks = NewLooks, pet = PetBag#pet_bag{pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    map:role_update(NewRole),
                    pet_api:push_pet(refresh, NewPets, NewRole),
                    ProtoMsg = {?true, util:fbin(?L(<<"仙宠彩云增加了~w点升级经验，升级成功，属性得到了大幅提高。">>), [Num])},
                    {ok, ProtoMsg, NewRole};
                NewLev > Lev andalso NewLev =:= 70 ->  %% 筋斗云升级并升品质
                    NewLooks = calc_cloud_looks(35, Looks),
                    ?DEBUG("NewLev = ~w, Lev = ~w, Looks = ~w", [NewLev, Lev, NewLooks]),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{looks = NewLooks, pet = PetBag#pet_bag{pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    map:role_update(NewRole),
                    pet_api:push_pet(refresh, NewPets, NewRole),
                    ProtoMsg = {?true, util:fbin(?L(<<"仙宠彩云增加了~w点升级经验，升级成功，属性得到了大幅提高。">>), [Num])},
                    {ok, ProtoMsg, NewRole};
                NewLev > Lev -> %% 筋斗云升级
                    ProtoMsg = {?true, util:fbin(?L(<<"仙宠彩云增加了~w点升级经验，升级成功，属性得到了大幅提高。">>), [Num])},
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{pet = PetBag#pet_bag{pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    pet_api:push_pet(refresh, NewPets, NewRole),
                    {ok, ProtoMsg, NewRole};
                true -> %% 筋斗云加经验
                    ?DEBUG("NewLev = ~w, Lev = ~w", [NewLev, Lev]),
                    ProtoMsg = {?true, util:fbin(?L(<<"使用成功，仙宠彩云，增加了~w点升级经验。">>), [Num])},
                    {ok, ProtoMsg, Role#role{pet = PetBag#pet_bag{cloud = #pet_cloud{lev = NewLev, exp = NewExp}}}}
            end
    end;
use_cloud_item(Role = #role{lev = RoleLev, looks = Looks, pet = PetBag = #pet_bag{active = ActPet, pets = Pets, cloud = #pet_cloud{lev = Lev, exp = Exp}}, link = #link{conn_pid = ConnPid}}, Num) ->
    case RoleLev =< Lev of
        true ->
            {false, ?L(<<"彩云使用数量无法超过您的人物等级">>)};
        false ->
            {NewLev, NewExp} = handle_cloud_item(Lev, Exp, Num, RoleLev),
            sys_conn:pack_send(ConnPid, 12652, {0, <<>>, NewLev, NewExp}),
            if
                NewLev > Lev andalso Lev =:= 0 ->  %% 获得筋斗云
                    NewLooks = calc_cloud_looks(NewLev, Looks),
                    ?DEBUG("NewLev = ~w, Lev = ~w, Looks = ~w", [NewLev, Lev, NewLooks]),
                    [NewActPet] = upgrade_cloud_attr(Role, [ActPet], NewLev, []),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{looks = NewLooks, pet = PetBag#pet_bag{active = NewActPet, pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    map:role_update(NewRole),
                    pet_api:push_pet(refresh, [NewActPet | NewPets], NewRole),
                    ProtoMsg = {?true, ?L(<<"使用成功，仙宠获得了一朵神秘的仙宠彩云。">>)},
                    {ok, ProtoMsg, NewRole};
                NewLev > Lev andalso NewLev rem 5 =:= 0 , NewLev < 30 ->  %% 筋斗云升级并升品质
                    NewLooks = calc_cloud_looks(NewLev, Looks),
                    ?DEBUG("NewLev = ~w, Lev = ~w, Looks = ~w", [NewLev, Lev, NewLooks]),
                    [NewActPet] = upgrade_cloud_attr(Role, [ActPet], NewLev, []),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{looks = NewLooks, pet = PetBag#pet_bag{active = NewActPet, pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    map:role_update(NewRole),
                    pet_api:push_pet(refresh, [NewActPet | NewPets], NewRole),
                    ProtoMsg = {?true, util:fbin(?L(<<"仙宠彩云增加了~w点升级经验，升级成功，属性得到了大幅提高。">>), [Num])},
                    {ok, ProtoMsg, NewRole};
                NewLev > Lev andalso NewLev =:= 50  ->  %% 筋斗云升级并升品质
                    NewLooks = calc_cloud_looks(30, Looks),
                    ?DEBUG("NewLev = ~w, Lev = ~w, Looks = ~w", [NewLev, Lev, NewLooks]),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{looks = NewLooks, pet = PetBag#pet_bag{pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    map:role_update(NewRole),
                    pet_api:push_pet(refresh, NewPets, NewRole),
                    ProtoMsg = {?true, util:fbin(?L(<<"仙宠彩云增加了~w点升级经验，升级成功，属性得到了大幅提高。">>), [Num])},
                    {ok, ProtoMsg, NewRole};
                NewLev > Lev andalso NewLev =:= 70  ->  %% 筋斗云升级并升品质
                    NewLooks = calc_cloud_looks(35, Looks),
                    ?DEBUG("NewLev = ~w, Lev = ~w, Looks = ~w", [NewLev, Lev, NewLooks]),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{looks = NewLooks, pet = PetBag#pet_bag{pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    map:role_update(NewRole),
                    pet_api:push_pet(refresh, NewPets, NewRole),
                    ProtoMsg = {?true, util:fbin(?L(<<"仙宠彩云增加了~w点升级经验，升级成功，属性得到了大幅提高。">>), [Num])},
                    {ok, ProtoMsg, NewRole};
                NewLev > Lev -> %% 筋斗云升级
                    ?DEBUG("NewLev = ~w, Lev = ~w", [NewLev, Lev]),
                    ProtoMsg = {?true, util:fbin(?L(<<"仙宠彩云增加了~w点升级经验，升级成功，属性得到了大幅提高。">>), [Num])},
                    [NewActPet] = upgrade_cloud_attr(Role, [ActPet], NewLev, []),
                    NewPets = upgrade_cloud_attr(Role, Pets, NewLev, []),
                    NewRole = Role#role{pet = PetBag#pet_bag{active = NewActPet, pets = NewPets, cloud = #pet_cloud{lev = NewLev, exp = NewExp}}},
                    pet_api:push_pet(refresh, [NewActPet | NewPets], NewRole),
                    {ok, ProtoMsg, NewRole};
                true -> %% 筋斗云加经验
                    ?DEBUG("NewLev = ~w, Lev = ~w", [NewLev, Lev]),
                    ProtoMsg = {?true, util:fbin(?L(<<"使用成功，仙宠彩云，增加了~w点升级经验。">>), [Num])},
                    {ok, ProtoMsg, Role#role{pet = PetBag#pet_bag{cloud = #pet_cloud{lev = NewLev, exp = NewExp}}}}
            end
    end.

%% @spec calc_looks(Role) -> Looks.
%% @doc 计算筋斗云外观
calc_looks(#role{pet = #pet_bag{cloud = #pet_cloud{lev = 0}}}) ->
    [];
calc_looks(#role{pet = #pet_bag{cloud = #pet_cloud{lev = Lev}}}) when Lev >= 50, Lev < 70 ->
    [{?LOOKS_TYPE_PET_CLOUD, 1, 7}];
calc_looks(#role{pet = #pet_bag{cloud = #pet_cloud{lev = Lev}}}) when Lev >= 70 ->
    [{?LOOKS_TYPE_PET_CLOUD, 1, 8}];
calc_looks(#role{pet = #pet_bag{cloud = #pet_cloud{lev = Lev}}}) when Lev < 50, Lev >= 25 ->
    [{?LOOKS_TYPE_PET_CLOUD, 1, 6}];
calc_looks(#role{pet = #pet_bag{cloud = #pet_cloud{lev = Lev}}}) ->
    [{?LOOKS_TYPE_PET_CLOUD, 1, Lev div 5 + 1}].

%% @spec calc_cloud_attr(Pets, []) -> NewPets.
%% @doc 计算筋斗云加成
calc_cloud_attr([], Pets) -> Pets;
calc_cloud_attr([Pet = #pet{attr = Attr = #pet_attr{dmg_magic = DmgMag, dmg = Dmg}, cloud_lev = Lev} | T], Pets) ->
    {AddDmgMag, AddDmg} = pet_cloud_data:get_add_attr(Lev),
    calc_cloud_attr(T, [Pet#pet{attr = Attr#pet_attr{dmg_magic = DmgMag + AddDmgMag, dmg = Dmg + AddDmg}} | Pets]).

%% @spec init_cloud_attr(Pets, Lev, []) -> NewPets.
%% @doc 计算筋斗云加成
init_cloud_attr([], _, Pets) -> Pets;
init_cloud_attr(Pets, #pet_bag{cloud = #pet_cloud{lev = Lev}}, NewPets) ->
    init_cloud_attr(Pets, Lev, NewPets);
init_cloud_attr([Pet = #pet{attr = Attr = #pet_attr{dmg_magic = DmgMag, dmg = Dmg}} | T], Lev, Pets) ->
    {AddDmgMag, AddDmg} = pet_cloud_data:get_add_attr(Lev),
    ?DEBUG("AddDmgMag = ~w, AddDmg = ~w #################", [AddDmgMag, AddDmg]),
    NewPet = Pet#pet{attr = Attr#pet_attr{dmg_magic = DmgMag + AddDmgMag, dmg = Dmg + AddDmg}, cloud_lev = Lev},
    Power = pet_api:calc_fight_capacity(NewPet),
    init_cloud_attr(T, Lev, [NewPet#pet{fight_capacity = Power} | Pets]).

%%----------------------------------------------
%% 私有函数
%%----------------------------------------------
%% @doc 处理战斗外宠物说话
handle_talk(_Flag, [], _Role) -> ok;
handle_talk(role_lev, IdList, #role{id = {RoleId, SrvId}, pet = #pet_bag{custom_speak = Contents}, pos = #pos{map_pid = MapPid, x = X, y = Y}, lev = Lev, link = #link{conn_pid = ConnPid}}) ->
    case handle_match(IdList, Lev) of
        {true, #pet_speak{id = TalkId, broadcast = BC, custom = Custom}} ->
            scene_send(BC, ConnPid, RoleId, SrvId, Custom, TalkId, Contents, MapPid, X, Y);
        false ->
            ignore
    end;
handle_talk(_Flag, _List, _Data1) ->
    ?DEBUG("handle_talk error: Flag=~w, Data=~w", [_Flag, _Data1]).

handle_talk(_Flag, [], _Data, _Role) -> ok;
handle_talk(eqm, IdList, Item, #role{id = {RoleId, SrvId}, pet = #pet_bag{custom_speak = Contents}, pos = #pos{map_pid = MapPid, x = X, y = Y}, link = #link{conn_pid = ConnPid}}) ->
    case handle_match(IdList, Item) of
        {true, #pet_speak{id = TalkId, broadcast = BC, custom = Custom}} ->
            scene_send(BC, ConnPid, RoleId, SrvId, Custom, TalkId, Contents, MapPid, X, Y);
        false ->
            ignore
    end;
handle_talk(pet_lev, IdList, Lev, #role{id = {RoleId, SrvId}, pet = #pet_bag{custom_speak = Contents}, pos = #pos{map_pid = MapPid, x = X, y = Y}, link = #link{conn_pid = ConnPid}}) ->
    case handle_match(IdList, Lev) of
        {true, #pet_speak{id = TalkId, broadcast = BC, custom = Custom}} ->
            scene_send(BC, ConnPid, RoleId, SrvId, Custom, TalkId, Contents, MapPid, X, Y);
        false ->
            ignore
    end;
handle_talk(_Flag, _List, _Data1, _Data2) ->
    ?DEBUG("handle_talk error: Flag=~w, Data=~w", [_Flag, _Data1]).

%% @doc 处理条件匹配
handle_match([], _Value) -> false;
handle_match([Id | T], Value) ->
    case petspeak_data:get(Id) of
        {false, _Reason} ->
            handle_match(T, Value);
        {ok, PetSpeak = #pet_speak{prob = Prob, condition = Condition}} ->
            case match_rule(Condition, Value) of
                false ->
                    handle_match(T, Value);
                true ->
                    case do_prob(Prob) of
                        true ->
                            {true, PetSpeak};
                        false ->
                            handle_match(T, Value)
                    end
            end
    end.

%% @doc 处理战斗中宠物说话
handle_talk(fight, IdList, Round, Fighter = #fighter{rid = RoleId, srv_id = SrvId, pet_speak = Contents}, PetId, RoleList) ->
    case handle_match(fight, IdList, Round, Fighter) of
        {true, #pet_speak{id = TalkId, broadcast = BC, custom = Custom}} ->
            combat_send(BC, RoleId, SrvId, Custom, TalkId, Contents, PetId, RoleList);
        false ->
            ignore
    end;    
handle_talk(combat, IdList, Event, Fighter = #fighter{rid = RoleId, srv_id = SrvId, pet_speak = Contents}, PetId, RoleList) ->
    case handle_match(combat, IdList, Event, Fighter) of
        {true, #pet_speak{id = TalkId, broadcast = BC, custom = Custom}} ->
            combat_send(BC, RoleId, SrvId, Custom, TalkId, Contents, PetId, RoleList);
        false ->
            ignore
    end;
handle_talk(_Flag, _List, _Data1, _Data2, _Data3, _Data4) ->
    ?DEBUG("handle_talk error: Flag=~w, Data=~w", [_Flag, _Data1]).

%% @doc 处理条件匹配
handle_match(_Flag, [], _Value, _Fighter) -> false;
handle_match(Flag, [Id | T], Value, Fighter) ->
    case petspeak_data:get(Id) of
        {false, _Reason} ->
            handle_match(Flag, T, Value, Fighter);
        {ok, PetSpeak = #pet_speak{prob = Prob, condition = Condition}} ->
            case match_rule(Flag, Condition, Value, Fighter) of
                false ->
                    handle_match(Flag, T, Value, Fighter);
                true ->
                    case do_prob(Prob) of
                        true ->
                            {true, PetSpeak};
                        false ->
                            handle_match(Flag, T, Value, Fighter)
                    end
            end
    end.

%% @doc 匹配对话条件 
match_rule([], _Data) -> true;
match_rule([{_Target, Key, Rela, Value} | T], Item = #item{}) ->
    case handle_con_compare(Rela, handle_con_key(Key, Item), Value) of
        true ->
            match_rule(T, Item);
        false ->
            false
    end;
match_rule([{_Target, _Key, Rela, Value} | T], Value2) when is_integer(Value2) ->
    case handle_con_compare(Rela, Value2, Value) of
        true ->
            match_rule(T, Value2);
        false ->
            false
    end;
match_rule(_, _) -> false.

match_rule(_Flag, [], _Data1, _Data2) -> true;
match_rule(fight, [{_Target, round, Rela, Value} | T], Round, Fighter = #fighter{}) ->
    case handle_con_compare(Rela, Round, Value) of
        true ->
            match_rule(fight, T, Round, Fighter);
        false ->
            false
    end;
match_rule(fight, [{_Target, Key, Rela, Value} | T], Round, Fighter = #fighter{}) ->
    case handle_con_compare(Rela, handle_con_key(Key, Fighter), handle_con_key(Key, Fighter, Value)) of
        true ->
            match_rule(fight, T, Round, Fighter);
        false ->
            false
    end;
match_rule(combat, [{_Target, _Key, Rela, Value} | T], Event, Fighter = #fighter{}) ->
    case handle_con_compare(Rela, Event, Value) of
        true ->
            match_rule(combat, T, Event, Fighter);
        false ->
            false
    end;
match_rule(_, _, _, _) -> false.

%% @doc 获取数值
handle_con_key(item_id, #item{base_id = BaseId}) ->
    BaseId;
handle_con_key(quality, #item{quality = Quality}) ->
    Quality;
handle_con_key(item_level, #item{base_id = BaseId}) ->
    case item_data:get(BaseId) of
        {false, _Reason} ->
            0;
        {ok, #item_base{condition = Condition}} ->
            case lists:keyfind(lev, #condition.label, Condition) of
                false ->
                    0;
                #condition{target_value = Lev} ->
                    Lev
            end
    end;
handle_con_key(hp, #fighter{hp = Hp}) ->
    Hp;
handle_con_key(hp_per, #fighter{hp = Hp}) ->
    Hp;
handle_con_key(mp, #fighter{mp = Mp}) ->
    Mp;
handle_con_key(mp_per, #fighter{mp = Mp}) ->
    Mp;
handle_con_key(buff, #fighter{is_stun = ?true}) ->
    200040;
handle_con_key(buff, #fighter{is_sleep = ?true}) ->
    200050;
handle_con_key(buff, #fighter{is_silent = ?true}) ->
    200060;
handle_con_key(buff, #fighter{is_stone = ?true}) ->
    200070;
handle_con_key(buff, #fighter{is_taunt = ?true}) ->
    200080;
handle_con_key(_, _) -> 0.

handle_con_key(hp_per, _Target = #fighter{hp_max = HpMax}, Value) ->
    HpMax /100 * Value;
handle_con_key(mp_per, _Target = #fighter{mp_max = MpMax}, Value) ->
    MpMax /100 * Value;
handle_con_key(_Key, _Fighter, Value) ->
    Value. 

%% @doc 数值对比
handle_con_compare(<<"=">>, Left, Right) ->
    %?DEBUG("~w =:= ~w", [Left, Right]),
    Left =:= Right;
handle_con_compare(<<">">>, Left, Right) ->
    %?DEBUG("~w > ~w", [Left, Right]),
    Left > Right;
handle_con_compare(<<"<">>, Left, Right) ->
    %?DEBUG("~w < ~w", [Left, Right]),
    Left < Right;
handle_con_compare(<<">=">>, Left, Right) ->
    %?DEBUG("~w >= ~w", [Left, Right]),
    Left >= Right;
handle_con_compare(<<"=<">>, Left, Right) ->
    %?DEBUG("~w =< ~w", [Left, Right]),
    Left =< Right;
handle_con_compare(_, _, _) -> false.

%% @doc 处理概率
do_prob(100) -> true;
do_prob(Prob) ->
    util:rand(1, 100) =< Prob.

%% @doc 获取自定义对话内容
get_custom_content(TalkId, Contents) ->
    case lists:keyfind(TalkId, 1, Contents) of
        false -> <<>>;
        {_Id, Content} -> Content
    end.

%% @doc 发送场景宠物聊天
scene_send(BC, ConnPid, RoleId, SrvId, Custom, TalkId, Contents, MapPid, X, Y) ->
    case BC =:= 0 of
        true ->
            case Custom =:= 0 of
                true ->
                    sys_conn:pack_send(ConnPid, 12649, {1, RoleId, SrvId, TalkId});
                false ->
                    sys_conn:pack_send(ConnPid, 12650, {1, RoleId, SrvId, get_custom_content(TalkId, Contents)})
            end;
        false ->
            case Custom =:= 0 of
                true ->
                    {ok, Msg} = proto_126:pack(srv, 12649, {1, RoleId, SrvId, TalkId}),
                    map:send_to_near(MapPid, {X, Y}, Msg);
                false ->
                    {ok, Msg} = proto_126:pack(srv, 12650, {1, RoleId, SrvId, get_custom_content(TalkId, Contents)}),
                    map:send_to_near(MapPid, {X, Y}, Msg)
            end
    end.

%% @doc 发送战斗宠物聊天
combat_send(BC, RoleId, SrvId, Custom, TalkId, Contents, PetId, RoleList) ->
    case BC =:= 0 of
        true ->
            case Custom =:= 0 of
                true ->
                    role_group:pack_send({RoleId, SrvId}, 12649, {2, PetId, SrvId, TalkId});
                false ->
                    role_group:pack_send({RoleId, SrvId}, 12650, {2, PetId, SrvId, get_custom_content(TalkId, Contents)})
            end;
        false ->
            case Custom =:= 0 of
                true ->
                    combat_broadcast(RoleList, PetId, 12649, TalkId);
                false ->
                    combat_broadcast(RoleList, PetId, 12650, get_custom_content(TalkId, Contents))
            end
    end.

%% @doc 战斗宠物聊天广播
combat_broadcast([], _PetId, _ProtoNum, _Data) -> ok;
combat_broadcast([{RoleId, SrvId} | T], PetId, 12649, TalkId) ->
    role_group:pack_send({RoleId, SrvId}, 12649, {2, PetId, SrvId, TalkId}),
    combat_broadcast(T, PetId, 12649, TalkId);
combat_broadcast([{RoleId, SrvId} | T], PetId, 12650, Content) ->
    role_group:pack_send({RoleId, SrvId}, 12650, {2, PetId, SrvId, Content}),
    combat_broadcast(T, PetId, 12650, Content).

%% @doc 处理屏蔽词
do_text_banned(Text) ->
    L = filter_data:get(),
    text_banned(Text, L).
        
%% @spec text_banned(Text, Keywords) -> bool()
%% Text = string()
%% Keywords = list()
%% @doc 检查文本中是否含有指定的关键词; true表示含有屏蔽词 false表示不含
text_banned(_Text, []) -> false;
text_banned(Text, [H | L]) ->
    case re:run(Text, H, [{capture, none}, caseless]) of
        match -> true;
        _ -> text_banned(Text, L)
    end.

%% @doc 检查自定义对话是否有更新
check_custom_speak([], SpeakList) -> SpeakList;
check_custom_speak([Id | T], SpeakList) ->
    case lists:keyfind(Id, 1, SpeakList) of
        false ->
            case petspeak_data:get(Id) of
                {false, _Reason} ->
                    check_custom_speak(T, SpeakList);
                {ok, #pet_speak{content = Content}} ->
                    check_custom_speak(T, [{Id, Content} | SpeakList])
            end;
        _ ->
            check_custom_speak(T, SpeakList)
    end.

%% @doc 移除不用的自定义对话
remove_unused_speak([], _CustomList, NewSpeakList) -> NewSpeakList;
remove_unused_speak([Speak = {Id, _} | T], CustomList, NewSpeakList) ->
    case lists:member(Id, CustomList) of
        true ->
            remove_unused_speak(T, CustomList, [Speak | NewSpeakList]);
        false ->
            remove_unused_speak(T, CustomList, NewSpeakList)
    end.

%% @doc 计算筋斗云外观
calc_cloud_looks(Lev, Looks) ->
    case lists:keyfind(?LOOKS_TYPE_PET_CLOUD, 1, Looks) of
        false ->
            [{?LOOKS_TYPE_PET_CLOUD, 1, Lev div 5 + 1} | Looks];
        _ ->
            lists:keyreplace(?LOOKS_TYPE_PET_CLOUD, 1, Looks, {?LOOKS_TYPE_PET_CLOUD, 1, Lev div 5 + 1})
    end.

%% @doc 处理筋斗云升级
handle_cloud_item(Lev, Exp, _, Lev) -> {Lev, Exp};
handle_cloud_item(Lev, Exp, 0, _RoleLev) -> {Lev, Exp};
handle_cloud_item(Lev, Exp, AddExp, RoleLev) ->
    UpExp = pet_cloud_data:get_up_exp(Lev + 1) - Exp,
    case AddExp < UpExp of
        true ->
            handle_cloud_item(Lev, Exp + AddExp, 0, RoleLev);
        false ->
            handle_cloud_item(Lev + 1, Exp + AddExp - UpExp, AddExp - UpExp, RoleLev)
    end.

%% @spec upgrade_cloud_attr(Pets, Lev, []) -> NewPets.
%% @doc 计算筋斗云加成
upgrade_cloud_attr(_Role, [], _, Pets) -> Pets;
upgrade_cloud_attr(Role, [Pet | T], Lev, Pets) ->
    NewPet = pet_api:reset(Pet#pet{cloud_lev = Lev}, Role),
    upgrade_cloud_attr(Role, T, Lev, [NewPet | Pets]).
