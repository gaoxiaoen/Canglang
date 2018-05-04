%%----------------------------------------------------
%%  外观效果相关处理
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(looks).
-export([
        add/4
        ,remove/2
        ,clean_eqm/1
        ,calc/1
        ,first_career_looks/1
        ,suit_looks/1
        ,modify_cloth_look/2
        ,open_cloth_look/2
        ,calc_shapelooks/1
        ,refresh/2
        ,refresh_set/1
        ,refresh_set/2
        ,set_info/1
        ,configure/2
    ]
).

-include("role.hrl").
-include("looks.hrl").
-include("buff.hrl").
-include("item.hrl").
-include("setting.hrl").
-include("common.hrl").
-include("link.hrl").
-include("dungeon.hrl").

%% 开启关闭效果
-define(LOOKS_LOCK_OFF, 0).
-define(LOOKS_LOCK_ON, 1).
-define(LOOKS_ALL_ENCHANT, [?item_shi_zhuang, ?item_zuo_qi, ?item_wing, ?item_weapon_dress, ?item_xian_jie, ?item_footprint, ?item_text_style, ?item_chat_frame]).

%% 外观效果由一个list保存
%% 格式:[{外观类别, 显示内容} | ...]
%% 每次外观变化时会向客户端发送变化后的外观数据
%% 客户端可以通过比对新旧数组得到需要的数据

%% 增加外观效果
%% @spec replace(Role, LooksType, Id, LooksValue) -> NewRole
%% Role = #role{} 角色数据
%% LookType = integer() 外观类型
%% Id = integer() 某些效果需要附带物品的ID,如果没有的话 填0
%% LooksValue = integer() 外观值 参见Looks.hrl
%% @doc 增加某个外观效果,如果同类型的外观效果存在,则会替换
add(Role = #role{looks = Looks}, LooksType, Id, LooksValue) ->
    NewLooks = case lists:keyfind(LooksType, 1, Looks) of
        false -> [{LooksType, Id, LooksValue} | Looks];
        _ -> lists:keyreplace(LooksType, 1, Looks, {LooksType, Id, LooksValue})
    end,
    Role#role{looks = NewLooks}.

%% 移除某个外观效果
%% @spec remove(Role, LooksType) ->
%% Role = #role{} 角色数据
%% LookType = integer() 外观类型
remove(Role = #role{looks = Looks}, LooksType) ->
    Role#role{looks = lists:keydelete(LooksType, 1, Looks)}.

%% 装备系统外观处理
%% @spec clean_eqm(Looks) -> NewLooks
%% @doc 清除Looks里面装备相关的特效
clean_eqm(Looks) ->
    %% 坐骑,武器,时装,套装,全套强化,翅膀,是否穿上衣,变身,宠物
    List = [1, 2, 3, 4, 6, 7, 9, 30, 31, 33, 43, ?LOOKS_TYPE_FOOTPRINT, ?LOOKS_TYPE_CHATFRAME, ?LOOKS_TYPE_TEXT], 
    [{Type, _Id, _Value} || {Type, _Id, _Value} <- Looks, lists:member(Type, List) =:= false].

%% @spec calc(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 重新给角色计算外观
calc(Role = #role{}) ->
    NewFirCareerLooks = first_career_looks(Role),
    NewRole = Role#role{looks = NewFirCareerLooks},
    NewRole;
calc(_Role) -> _Role.

%% @spec first_career_looks(Role) -> List
%% List = [{Type, SkinId, Enchant} | ..]
%% Type = integer()     %% 外观类型
%% SkinId = integer()   %% 外观ID
%% Enchant = integer()  %% 强化效果级别
%% @doc 计算第一职业外观
first_career_looks(Role = #role{looks = _OldLooks, eqm = _Eqm, setting = _Set, special = _Special}) ->
%%    MountsLooks = mount:get_skin(Mounts, Eqm),
%%    WingLooks = wing:calc_looks(Role),
%%    NewL = suit_looks(Eqm),
%%    ShapeLooks = calc_shapelooks(Role),
%%    CloudLooks = pet_ex:calc_looks(Role),
%%    NewLooks1 = looks:clean_eqm(OldLooks) ++ NewL ++ ShapeLooks ++ MountsLooks ++ WingLooks ++ CloudLooks,
%%    NLooks = modify_cloth_look(Set, NewLooks1),
    %% TODO 增加 looks  计算请在加在上面
    Looks = dress:calc_looks(Role),
    Looks1 = calc_eqm_looks(Role, Looks),
    Looks1;
first_career_looks(_) -> [].

%% 武器强化对应脚底的光环，分别为: 8, 11, 13, 15, 17, 20 对应六种不同的光环 记在  LOOKS_TYPE_WEAPON 第三个字段
%% 武器强化到二十还有一个特殊特效， 武器会发光   记在 ?LOOKS_TYPE_WEAPON_DRESS 的第三个字段上
%% 全身强化到 8 , 11,  13,  15,  17, 20 对应角色身上出六种光效  记在 LOOKS_TYPE_SETS 第三个字段
calc_eqm_looks(Role = #role{eqm = Eqm}, Looks) ->
    case eqm:find_eqm_by_id(Eqm, ?item_weapon) of
        false ->
            Looks;
        {ok, #item{enchant = Enchant}} ->
            SpecId =
            case dress:find_fashion(Role, ?LOOKS_TYPE_WEAPON_DRESS) of
                0 -> 100;
                BaseId -> 
                    {ok, #item_base{effect = Effect}} = item_data:get(BaseId),
                        {_, _, LooksId} = lists:keyfind(?attr_looks_id, 1, Effect),
                        LooksId
            end,
            Param = [{skin, ?LOOKS_TYPE_WEAPON, foot_spec(Enchant)}, {skin, ?LOOKS_TYPE_WEAPON_ENCHANT, weapon_spec(Enchant, SpecId)}, 
                        {skin, ?LOOKS_TYPE_SETS, all_enchant_spec(eqm_api:get_suit_enchant(Eqm))}],
                    lists:foldl(fun({Label, Type, V}, Looks1) -> update(Label, Type, V, Looks1) end, Looks, Param)
    end.
            
foot_spec(Enchant) when Enchant >= 45 andalso Enchant < 60 -> 8;
foot_spec(Enchant) when Enchant >= 60 andalso Enchant < 75 -> 11;
foot_spec(Enchant) when Enchant >= 75 andalso Enchant < 90 -> 13;
foot_spec(Enchant) when Enchant >= 90 andalso Enchant < 95 -> 15;
foot_spec(Enchant) when Enchant >= 95 andalso Enchant < 100 -> 17;
foot_spec(Enchant) when Enchant >= 100  -> 20;
foot_spec(_) -> 0.

weapon_spec(Enchant, SpecId) when Enchant =:= 100 -> SpecId;
weapon_spec(_Enchant, _SpecId) -> 0.

all_enchant_spec(Enchant) when Enchant >= 30 andalso Enchant < 45 -> 8;
all_enchant_spec(Enchant) when Enchant >= 45 andalso Enchant < 60 -> 11;
all_enchant_spec(Enchant) when Enchant >= 60 andalso Enchant < 75 -> 13;
all_enchant_spec(Enchant) when Enchant >= 75 andalso Enchant < 90 -> 15;
all_enchant_spec(Enchant) when Enchant >= 90 andalso Enchant < 100 -> 17;
all_enchant_spec(Enchant) when Enchant >= 100  -> 20;
all_enchant_spec(_) -> 0.

%% 更新时装或外观效果
update(_, _Type, 0, Looks) -> Looks;

update(skin, Type, V, Looks) ->           
    case lists:keyfind(Type, 1, Looks) of
        false -> [{Type, V, 0} | Looks];
        {Type, _, Spec} ->
            lists:keyreplace(Type, 1, Looks, {Type, V, Spec})
    end;
update(spec, Type, Spec, Looks) ->
    case lists:keyfind(Type, 1, Looks) of
        false -> [{Type, 0, Spec} | Looks];
        {Type, Skin, _} ->
            lists:keyreplace(Type, 1, Looks, {Type, Skin, Spec})
    end.

%% @spec calc_shapelooks(Role) -> List
%% List = [{Type, SkinId, Enchant} | ..]
%% Type = integer()     %% 外观类型
%% SkinId = integer()   %% 外观ID
%% Enchant = integer()  %% 强化效果级别
%% @doc 变身外观计算
calc_shapelooks(#role{buff = #rbuff{buff_list = BuffList}}) ->
    do_check_buff(BuffList, []).

do_check_buff([], NewLooks) -> NewLooks;
do_check_buff([#buff{label = Label} | T], NewLooks) ->
    case buff_data:get_look_id(Label) of
        null -> do_check_buff(T, NewLooks);
        LookId -> do_check_buff(T, [{?LOOKS_TYPE_CHANGE_MODE, 0, LookId} | NewLooks])
    end.

%% @spec configures(Configures, Role) -> NewRole
%% Role = NewRole
%% Configures = [{Type, SkinId, Enchant} | ..]
%% Type = integer()     %% 外观类型
%% SkinId = integer()   %% 外观ID
%% Enchant = integer()  %% 强化效果级别
%% @doc 设置角色的外观效果
configure(_, Role = #role{link = #link{conn_pid = ConnPid}, event = Event}) when ?EventCantPutItem -> 
    catch sys_conn:pack_send(ConnPid, 19401, {?false, ?L(<<"竞技比赛时，不能随便穿装备的啦">>)}),
    Role;
configure([], Role) ->
    Role;
configure([[?LOOKS_TYPE_WING, SkinId, EnchantLev] | Configures], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    Grade = enchan_look_value_to_grade(EnchantLev),
    case wing:change_skin(Role, SkinId, Grade) of
        {ok, NewRole} ->
            configure(Configures, NewRole);
        {false, Reason} ->
            catch sys_conn:pack_send(ConnPid, 19401, {?false, util:fbin(?L(<<"外观更换失败，~s">>), [Reason])}),
            configure(Configures, Role)
    end;
configure([[Type, BaseId, _Lev] | Configures], Role = #role{link = #link{conn_pid = ConnPid}}) 
when Type =:= ?LOOKS_TYPE_DRESS orelse Type =:= ?LOOKS_TYPE_WEAPON_DRESS orelse Type =:= ?LOOKS_TYPE_CHATFRAME orelse Type =:= ?LOOKS_TYPE_TEXT orelse Type =:= ?LOOKS_TYPE_FOOTPRINT ->
    case storage:check_fly_and_mount(Role, BaseId) of
        {false, Reason} ->
            catch sys_conn:pack_send(ConnPid, 19401, {?false, util:fbin(?L(<<"更换外观失败，~s">>), [Reason])}),
            configure(Configures, Role);
        true -> 
            role:send_buff_begin(),
            case dress:change_dress(BaseId, Role) of
                {false, Reason} -> 
                    role:send_buff_clean(),
                    catch sys_conn:pack_send(ConnPid, 19401, {?false, util:fbin(?L(<<"外观更换失败，~s">>), [Reason])}),
                    configure(Configures, Role);
                {ok, NewRole} ->
                    refresh_set(NewRole),
                    role:send_buff_flush(),
                    configure(Configures, NewRole)
            end
    end;

configure([_ | Configures], Role) ->
    configure(Configures, Role).

%% @spec suit_looks(EqmList) -> LooksList
%% @doc 重新计算套装外观效果
suit_looks(EmqList) ->
    suit_looks(EmqList, [], [], []).
suit_looks([], LooksList, Set, All) ->
    NewLooks = case lists:keyfind(6, 2, Set) of  %% 计算套装数
        false -> LooksList;
        {Id, 6} -> 
            case setid_to_value(Id) =/= false of
                true -> [{?LOOKS_TYPE_SETS, 0, setid_to_value(Id)} | LooksList];
                false -> LooksList
            end
    end,
    TenList = [Num || Num <- All, Num >= 1],
    ElevenList = [Num || Num <- All, Num >= 2],
    TwelveList = [Num || Num <- All, Num >= 3],
    %% 计算全身 强化加成 +10为1点 +11为2点 ,+12为3点 总共11件装备
    NewAllLooks = case length(TwelveList) of
        11 -> [{?LOOKS_TYPE_ALL, 0, ?LOOKS_VAL_ALL_TWELVE} | NewLooks];
        _ ->
            case length(ElevenList) of 
                11 -> [{?LOOKS_TYPE_ALL, 0, ?LOOKS_VAL_ALL_ELEVEN} | NewLooks];
                _ -> 
                    case length(TenList) of
                        11 -> [{?LOOKS_TYPE_ALL, 0, ?LOOKS_VAL_ALL_TEN} | NewLooks];
                        _ -> NewLooks
                    end
            end
    end,
    NewAllLooks;

suit_looks([Eqm = #item{type = Type, enchant = Enchant} | T], LooksList, SetList, All) ->
    NewSetList = case get_set(Eqm) of %% 是否属于套装类
        0 -> SetList;
        Id ->
            case lists:keyfind(Id, 1, SetList) of
                false -> [{Id, 1} | SetList];
                {Id, Num} -> lists:keyreplace(Id, 1, SetList, {Id, Num + 1})
            end
    end,
    NewAll = case lists:member(Type, ?LOOKS_ALL_ENCHANT)of
        true -> All;
        false ->
            if
                Enchant =:= 12 -> [3 | All];
                Enchant =:= 11 -> [2 | All];
                Enchant =:= 10 -> [1 | All];
                true -> All
            end
    end,
    NewLooksList = case type_to_looks(Eqm) of %% 强化外观
        false -> LooksList;
        Look -> [Look | LooksList]
    end,
    suit_looks(T, NewLooksList, NewSetList, NewAll). 

%% @spec modify_cloth_look(Setting, Looks) -> Newlooks
%% Setting = #setting{}
%% @doc 修改时装显示效果
modify_cloth_look(#setting{dress_looks = #dress_looks{dress = Dress, weapon_dress = WeaponDress, all_looks = AllLooks, mount_dress = MountDress, footprint = FootPrint, wing = Wing, chat_frame = ChanFrame}}, Looks) ->
    Looks1 = looks_lock_on_off(Looks, Dress, ?LOOKS_TYPE_DRESS),
    Looks2 = looks_lock_on_off(Looks1, WeaponDress, ?LOOKS_TYPE_WEAPON_DRESS),
    Looks4 = looks_lock_on_off(Looks2, AllLooks, ?LOOKS_TYPE_ALL),
    Looks5 = looks_lock_on_off(Looks4, MountDress, ?LOOKS_TYPE_RIDE),
    Looks6 = looks_lock_on_off(Looks5, FootPrint, ?LOOKS_TYPE_FOOTPRINT),
    Looks7 = looks_lock_on_off(Looks6, ChanFrame, ?LOOKS_TYPE_CHATFRAME),
    Looks8 = looks_lock_on_off(Looks7, Wing, ?LOOKS_TYPE_WING),
    NewLooks = Looks8,
    NewLooks;
modify_cloth_look(_, Looks) -> Looks.

%% @spec open_cloth_look(Role, LockList) -> {ok, NewRole} | {skip, Role}
%% @doc 隐藏时装效果 1:开启 0:关闭
open_cloth_look(Role = #role{eqm = Eqm, looks = Looks, mounts = Mounts}, {Lock1, Lock2, Lock4, Lock5, Lock6, Lock7, Lock8}) ->
    Looks1 = eqm_looks_on_lock(Eqm, Looks, ?LOOKS_TYPE_DRESS, 10, Lock1),
    Looks3 = eqm_looks_on_lock(Eqm, Looks1, ?LOOKS_TYPE_WEAPON_DRESS, 16, Lock2),
    Looks4 = case Lock4 of
        ?LOOKS_LOCK_ON ->
            case lists:keyfind(?LOOKS_TYPE_ALL, 1, Looks3) of
                false -> eqm_enchant_suit_looks(Eqm) ++ Looks3;
                _ -> Looks3
            end;
        ?LOOKS_LOCK_OFF -> lists:keydelete(?LOOKS_TYPE_ALL, 1, Looks3)
    end,
    Looks5 = case Lock5 of
        ?LOOKS_LOCK_ON ->
            case lists:keyfind(?LOOKS_TYPE_RIDE, 1, Looks4) of
                false ->
                    MountLook = mount:get_skin(Mounts, Eqm),
                    MountLook ++ Looks4;
                _ -> Looks4
            end;
        ?LOOKS_LOCK_OFF -> lists:keydelete(?LOOKS_TYPE_RIDE, 1, Looks4)
    end,
    Looks6 = eqm_looks_on_lock(Eqm, Looks5, ?LOOKS_TYPE_FOOTPRINT, 18, Lock6),
    Looks7 = eqm_looks_on_lock(Eqm, Looks6, ?LOOKS_TYPE_CHATFRAME, 19, Lock7),
    Looks8 = case Lock8 of  %% 翅膀外观
        ?LOOKS_LOCK_ON -> Looks7 ++ wing:calc_looks(Role);
        ?LOOKS_LOCK_OFF -> lists:keydelete(?LOOKS_TYPE_WING, 1, Looks7)
    end,
    NewLooks = Looks8,
    {ok, Role#role{looks = NewLooks}};
open_cloth_look(Role, _) -> {skip, Role}.

%% @spec refresh(OldRole, NewRole) -> ok
%% OldRole = NewRole = #role{}
%% @doc 刷新角色外观
refresh(#role{looks = Looks}, NewRole = #role{link = #link{conn_pid = ConnPid}, looks = NewLooks}) ->
    case length(Looks) =:= length(NewLooks) of
        true -> 
            case Looks -- NewLooks of
                [] -> ok;
                _ -> map:role_update(NewRole),ok
            end;
        false -> map:role_update(NewRole),ok
    end,
    YiGui = [{Lable, Mode, Value} || {Lable, Mode, Value} <- NewLooks],
    sys_conn:pack_send(ConnPid, 19400, {YiGui}).

%% @spec refresh_set(Role) ->
%% @doc 刷新效果设置情况
refresh_set(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 14101, {set_info(Role), <<>>});
refresh_set(_) ->
    ok.

%% @spec refresh_set(Role, Msg) ->
%% @doc 刷新效果设置情况
refresh_set(Role = #role{link = #link{conn_pid = ConnPid}}, Msg) when is_binary(Msg) ->
    sys_conn:pack_send(ConnPid, 14101, {set_info(Role), Msg});
refresh_set(_, _) ->
    ok.

%% @spec set_info(Role) -> List
%% Role = #role{}
%% List = [{integer(), integer()} | ..]
%% @doc 外观设置信息
set_info(#role{setting = #setting{dress_looks = #dress_looks{dress = Dress, weapon_dress = WeaponDress, all_looks = AllLooks, mount_dress = MountDress, footprint = FootPrint, chat_frame = ChatFrame, wing = Wing}}}) ->
    [{1, Dress}, {2, WeaponDress}, {4, AllLooks}, {5, MountDress}, {6, FootPrint}, {7, ChatFrame}, {8, Wing}];
set_info(_) ->
    [].


%% -------------------------------------------------------------------
%% 私有函数
%% -------------------------------------------------------------------
setid_to_value(120) -> ?LOOKS_VAL_SET_11;
setid_to_value(130) -> ?LOOKS_VAL_SET_11;
setid_to_value(140) -> ?LOOKS_VAL_SET_12;
setid_to_value(150) -> ?LOOKS_VAL_SET_12;
setid_to_value(160) -> ?LOOKS_VAL_SET_13;
setid_to_value(170) -> ?LOOKS_VAL_SET_14;
setid_to_value(180) -> ?LOOKS_VAL_SET_15;
setid_to_value(190) -> ?LOOKS_VAL_SET_16;
setid_to_value(1100) -> ?LOOKS_VAL_SET_17;

setid_to_value(220) -> ?LOOKS_VAL_SET_21;
setid_to_value(230) -> ?LOOKS_VAL_SET_21;
setid_to_value(240) -> ?LOOKS_VAL_SET_22;
setid_to_value(250) -> ?LOOKS_VAL_SET_22;
setid_to_value(260) -> ?LOOKS_VAL_SET_23;
setid_to_value(270) -> ?LOOKS_VAL_SET_24;
setid_to_value(280) -> ?LOOKS_VAL_SET_25;
setid_to_value(290) -> ?LOOKS_VAL_SET_26;
setid_to_value(2100) -> ?LOOKS_VAL_SET_27;

setid_to_value(320) -> ?LOOKS_VAL_SET_31;
setid_to_value(330) -> ?LOOKS_VAL_SET_31;
setid_to_value(340) -> ?LOOKS_VAL_SET_32;
setid_to_value(350) -> ?LOOKS_VAL_SET_32;
setid_to_value(360) -> ?LOOKS_VAL_SET_33;
setid_to_value(370) -> ?LOOKS_VAL_SET_34;
setid_to_value(380) -> ?LOOKS_VAL_SET_35;
setid_to_value(390) -> ?LOOKS_VAL_SET_36;
setid_to_value(3100) -> ?LOOKS_VAL_SET_37;

setid_to_value(420) -> ?LOOKS_VAL_SET_41;
setid_to_value(430) -> ?LOOKS_VAL_SET_41;
setid_to_value(440) -> ?LOOKS_VAL_SET_42;
setid_to_value(450) -> ?LOOKS_VAL_SET_42;
setid_to_value(460) -> ?LOOKS_VAL_SET_43;
setid_to_value(470) -> ?LOOKS_VAL_SET_44;
setid_to_value(480) -> ?LOOKS_VAL_SET_45;
setid_to_value(490) -> ?LOOKS_VAL_SET_46;
setid_to_value(4100) -> ?LOOKS_VAL_SET_47;

setid_to_value(520) -> ?LOOKS_VAL_SET_51;
setid_to_value(530) -> ?LOOKS_VAL_SET_51;
setid_to_value(540) -> ?LOOKS_VAL_SET_52;
setid_to_value(550) -> ?LOOKS_VAL_SET_52;
setid_to_value(560) -> ?LOOKS_VAL_SET_53;
setid_to_value(570) -> ?LOOKS_VAL_SET_54;
setid_to_value(580) -> ?LOOKS_VAL_SET_55;
setid_to_value(590) -> ?LOOKS_VAL_SET_56;
setid_to_value(5100) -> ?LOOKS_VAL_SET_57;
setid_to_value(_) -> false.

%% 获取Item的set_id
get_set(#item{base_id = BaseId}) ->
    case item_data:get(BaseId) of
        {ok, BaseItem} ->
            BaseItem#item_base.set_id;
        {false, _R} ->
            0
    end.

%% 装备转换效果
%% @spec type_to_looks(Item) -> {LookType, Enchant} | false
type_to_looks(#item{base_id = BaseId, type = Type, enchant = Enchant, extra = Extra}) ->
    IsWeapon = lists:member(Type, ?eqm),
    if
        IsWeapon -> {?LOOKS_TYPE_WEAPON, BaseId, enchant_lev_to_enchant_look_value(Enchant)};
        Type =:= ?item_shi_zhuang ->
            Color = case lists:keyfind(?extra_dress_color, 1, Extra) of
                {_, OldColor, _} -> OldColor;
                _ -> 0
            end,
            NewBaseId = BaseId + Color * 100,
            {?LOOKS_TYPE_DRESS, NewBaseId, enchant_lev_to_enchant_look_value(Enchant)};
        Type =:= ?item_yi_fu ->
            {?LOOKS_TYPE_CLOTHES, BaseId, 0};        
        Type =:= ?item_weapon_dress -> {?LOOKS_TYPE_WEAPON_DRESS, BaseId, enchant_lev_to_enchant_look_value(Enchant)};
        Type =:= ?item_footprint -> {?LOOKS_TYPE_FOOTPRINT, BaseId, enchant_lev_to_enchant_look_value(Enchant)};
        Type =:= ?item_chat_frame -> {?LOOKS_TYPE_CHATFRAME, BaseId, enchant_lev_to_enchant_look_value(Enchant)};
        Type =:= ?item_text_style -> {?LOOKS_TYPE_TEXT, BaseId, enchant_lev_to_enchant_look_value(Enchant)};
        true ->
            false
    end.

%% 强化外观类型值转化
enchan_look_value_to_grade(?LOOKS_VAL_ENCHANT_TWELVE) -> 2;
enchan_look_value_to_grade(?LOOKS_VAL_ENCHANT_NINE) -> 1;
enchan_look_value_to_grade(_) -> 0.

%% 强化等级转换外观值
enchant_lev_to_enchant_look_value(Enchant) when Enchant >= 12 -> ?LOOKS_VAL_ENCHANT_TWELVE;
enchant_lev_to_enchant_look_value(Enchant) when Enchant >= 9 -> ?LOOKS_VAL_ENCHANT_NINE;
enchant_lev_to_enchant_look_value(_Enchant) -> ?LOOKS_VAL_ENCHANT_NORMAL.

%% 计算装备外观效果
eqm_looks_on_lock(_Eqm, Looks, LooksType, _EqmItemId, ?LOOKS_LOCK_OFF) ->
    lists:keydelete(LooksType, 1, Looks);
eqm_looks_on_lock(Eqm, Looks, LooksType, EqmItemId, ?LOOKS_LOCK_ON) ->
    case lists:keyfind(LooksType, 1, Looks) of
        false ->
            case storage:find(Eqm, #item.id, EqmItemId) of
                {false, _} -> Looks;
                {ok, #item{base_id = BaseId, enchant = Enchant, extra = Extra}} ->
                    Color = case lists:keyfind(?extra_dress_color, 1, Extra) of
                        {_, OldColor, _} -> OldColor;
                        _ -> 0
                    end,
                    NewBaseId = BaseId + Color * 100,
                    ClothLook = if
                        Enchant >= 12 -> {LooksType, NewBaseId, ?LOOKS_VAL_ENCHANT_TWELVE};
                        Enchant >= 9 -> {LooksType, NewBaseId, ?LOOKS_VAL_ENCHANT_NINE};
                        true -> {LooksType, NewBaseId, ?LOOKS_VAL_ENCHANT_NORMAL}
                    end,
                    [ClothLook | Looks]
            end;
        _ -> Looks 
    end;
eqm_looks_on_lock(_Eqm, Looks, _Type, _Id, _Lock) -> Looks.

%% 计算套装强化效果
eqm_enchant_suit_looks(Eqm) ->
    All = [Enchant || #item{enchant = Enchant, type = Type} <- Eqm, lists:member(Type, ?LOOKS_ALL_ENCHANT) =:= false],
    TenList = [Enchant || Enchant <- All, Enchant >= 10],
    ElevenList = [Enchant || Enchant <- All, Enchant >= 11],
    TwelveList = [Enchant || Enchant <- All, Enchant >= 12],
    %% 计算全身 强化加成 +10为1点 +11为2点 ,+12为3点 总共11件装备
    case length(TwelveList) of
        11 -> [{?LOOKS_TYPE_ALL, 0, ?LOOKS_VAL_ALL_TWELVE}];
        _ ->
            case length(ElevenList) of 
                11 -> [{?LOOKS_TYPE_ALL, 0, ?LOOKS_VAL_ALL_ELEVEN}];
                _ -> 
                    case length(TenList) of
                        11 -> [{?LOOKS_TYPE_ALL, 0, ?LOOKS_VAL_ALL_TEN}];
                        _ -> [] 
                    end
            end
    end.

%% 修改效果
looks_lock_on_off(Looks, ?LOOKS_LOCK_OFF, Type) -> lists:keydelete(Type, 1, Looks);
looks_lock_on_off(Looks, ?LOOKS_LOCK_ON, _Type) -> Looks.

