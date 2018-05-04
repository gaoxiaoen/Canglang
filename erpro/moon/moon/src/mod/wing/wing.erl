%%----------------------------------------------------
%% 翅膀系统
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(wing).
-export([
        login/1
        ,gm/3
        ,gm_get_wing_grade/1
        ,put_wing/2
        ,takeoff_wing/1
        ,change_skin/3
        ,use_skin_item/2
        ,raise_step/2
        ,calc_looks/1
        ,get_wing_step/1
        ,fresh_wing/2
        ,replace_wing/2
        ,push_info/2
        ,move_attr/3
        ,use_lingxidan/3
        ,reset_lingxi_attr/3
        ,calc_lingxi_attr/4
        ,ext_attr/3
        ,skins/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("wing.hrl").
-include("item.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("storage.hrl").
-include("looks.hrl").
-include("condition.hrl").

%% GM命令
gm(Role = #role{wing = #wing{items = Items}}, step, _Val) ->
    WingPos = eqm:type_to_pos(?item_wing),
    case lists:keyfind(WingPos, #item.pos, Items) of
        false -> {false, ?L(<<"当前没有装备翅膀">>)};
        Wing = #item{extra = Extra} ->
            Step = get_wing_step(Wing),
            MaxLuck = wing_data:get_max_luck(Step),
            NewExtra = update_extra_val(Extra, {?extra_wing_luck, MaxLuck, <<>>}),
            NewWing = Wing#item{extra = NewExtra},
            NRole = fresh_wing(Role, NewWing),
            {ok, NRole}
    end;
gm(_Role, _Label, _Val) ->
    {ok}.

%% @spec skins(Role) -> List
%% Role = #role{}
%% List = [#item{} | ..]
%% @doc 获取所有的翅膀外观
skins(#role{wing = #wing{skin_list = List}}) -> List.

%% 获取翅膀阶数
gm_get_wing_grade(#role{wing = Wing}) ->
    gm_get_wing_grade(Wing);
gm_get_wing_grade(#wing{items = Items}) ->
    WingPos = eqm:type_to_pos(?item_wing),
    case lists:keyfind(WingPos, #item.pos, Items) of
        false -> 0;
        Wing ->
            get_wing_step(Wing)
    end.

%% 角色登录处理
login(Role) -> Role.
    %% wing_parse:dress_to_wing(Role).

%% 信息推送
push_info(skin_list, #role{link = #link{conn_pid = ConnPid}, wing = #wing{skin_id = SkinId, skin_grade = SkinGrade, skin_list = SkinList}}) -> 
    sys_conn:pack_send(ConnPid, 16703, {SkinId, SkinGrade, SkinList});
push_info(skill_bag, #role{link = #link{conn_pid = ConnPid}, wing = #wing{skill_bag = SkillBag}}) -> 
    sys_conn:pack_send(ConnPid, 16706, {SkillBag});
push_info(skill_tmp, #role{link = #link{conn_pid = ConnPid}, wing = #wing{skill_coin = CoinLuckVal, skill_gold = GoldLuckVal, skill_tmp = SkillList}}) -> 
    sys_conn:pack_send(ConnPid, 16707, {CoinLuckVal, GoldLuckVal, SkillList});
push_info(_Label, _Role) -> ok.

%% 获取翅膀阶数 
get_wing_step(#item{base_id = BaseID}) ->
    get_wing_step(BaseID);
get_wing_step(BaseID) ->
    case item_data:get(BaseID) of
        {ok, #item_base{value = Values}} ->
            case lists:keyfind(wing_step, 1, Values) of
                {_, N} when is_integer(N) andalso N >= 0 -> N;
                _ -> baseid_step(BaseID)
            end;
        _ -> 
            ?ERR("物品不存在[~p]", [BaseID]),
            0
    end.

%% 更新翅膀数据
fresh_wing(Role = #role{eqm = Eqm, wing = Wing = #wing{items = Items}, link = #link{conn_pid = ConnPid}}, WingItem = #item{id = Id, pos = Pos}) ->
    NewItems = lists:keyreplace(Id, #item.id, Items, WingItem),
    storage_api:refresh_client_item(refresh, ConnPid, [{?storage_wing, [WingItem]}]),
    case lists:keyfind(Pos, #item.pos, Eqm) of
        #item{} when Pos > 0 -> %% 身上翅膀
            NewWingEqm = WingItem#item{id = Pos},
            NewEqm = lists:keyreplace(Pos, #item.pos, Eqm, NewWingEqm),
            storage_api:refresh_client_item(refresh, ConnPid, [{?storage_eqm, [NewWingEqm]}]),
            role_api:push_attr(Role#role{eqm = NewEqm, wing = Wing#wing{items = NewItems}});
        _ -> %% 非身上翅膀
            Role#role{wing = Wing#wing{items = NewItems}}
    end.
%% 更换翅膀数据
replace_wing(Role = #role{eqm = Eqm, wing = Wing = #wing{items = Items}, link = #link{conn_pid = ConnPid}}, WingItem = #item{id = Id, pos = Pos}) ->
    NewItems = lists:keyreplace(Id, #item.id, Items, WingItem),
    storage_api:refresh_client_item(del, ConnPid, [{?storage_wing, [WingItem]}]),
    storage_api:refresh_client_item(add, ConnPid, [{?storage_wing, [WingItem]}]),
    case lists:keyfind(Pos, #item.pos, Eqm) of
        OldInEqm when Pos > 0 -> %% 身上翅膀
            NewWingEqm = WingItem#item{id = Pos},
            NewEqm = lists:keyreplace(Pos, #item.pos, Eqm, NewWingEqm),
            storage_api:refresh_client_item(del, ConnPid, [{?storage_eqm, [OldInEqm]}]),
            storage_api:refresh_client_item(add, ConnPid, [{?storage_eqm, [NewWingEqm]}]),
            role_api:push_attr(Role#role{eqm = NewEqm, wing = Wing#wing{items = NewItems}});
        _ -> %% 非身上翅膀
            Role#role{wing = Wing#wing{items = NewItems}}
    end.

%% 转移翅膀属性
move_attr(Role = #role{wing = #wing{items = Items}}, WingId1, WingId2) ->
    case {lists:keyfind(WingId1, #item.id, Items), lists:keyfind(WingId2, #item.id, Items)}of
        {#item{enchant = Enchant1}, #item{enchant = Enchant2}} when Enchant1 < Enchant2 ->
            {false, ?L(<<"较低的强化等级不能转移到较高的强化等级翅膀上">>)};
        {Item1 = #item{base_id = BaseId1, enchant = Enchant1, attr = Attr1, enchant_fail = EnchantFail}, Item2 = #item{enchant = Enchant2, base_id = BaseId2, attr = Attr2}} ->
            Step1 = get_wing_step(Item1),
            Step2 = get_wing_step(Item2),
            case Step1 > Step2 of
                true -> {false, ?L(<<"高阶翅膀属性不能转移到低阶翅膀上">>)};
                false ->
                    GL = [#loss{label = coin_all, val = 2000}],
                    case role_gain:do(GL, Role) of
                        {false, _} -> {false, coin_all};
                        {ok, NRole0} ->
                            Inform = notice_inform:gain_loss(GL, ?L(<<"属性转移">>)),
                            notice:inform(Role#role.pid, Inform),
                            {ok, [#item{attr = BaseAttr}]} = item:make(BaseId1, 1, 1),
                            HoleList = [?attr_hole1, ?attr_hole2, ?attr_hole3, ?attr_hole4, ?attr_hole5],
                            SkillAttr1 = [{Name, Flag, Value} || {Name, Flag, Value} <- Attr1, Name =:= ?attr_skill], %% 技能属性 + 洗炼属性
                            HoleAttr1 = [{Name1, Flag1, Value1} || {Name1, Flag1, Value1} <- Attr1, lists:member(Name1, HoleList) =:= true],
                            PolishAttr1 = [{CodeName1, Flag1, Val1} || {CodeName1, Flag1, Val1} <- Attr1, Flag1 >= 100010],
                            OtherAttr2 = [{CodeName4, Flag4, Val4} || {CodeName4, Flag4, Val4} <- Attr2, Flag4 < 100010, lists:member(CodeName4, HoleList) =:= false],
                            NewItem1 = Item1#item{enchant = 0, enchant_fail = 0, attr = BaseAttr ++ SkillAttr1},
                            NItem2 = blacksmith:recalc_attr(Item2#item{enchant = Enchant1, enchant_fail = EnchantFail, attr = OtherAttr2 ++ PolishAttr1 ++ HoleAttr1}),
                            NewItem2 = blacksmith:check_enchant_hole(NItem2),
                            NRole1 = fresh_wing(NRole0, NewItem1),
                            NRole = fresh_wing(NRole1, NewItem2),
                            log:log(log_blacksmith, {<<"属性转移">>, util:fbin(<<"[+~w]~w转移到[+~w]~w">>, [Enchant1, BaseId1, Enchant2, BaseId2]), <<"成功">>, [Item1, Item2], Role, NRole}),
                            {ok, NRole}
                    end
            end;
        _ ->
            {false, ?L(<<"查找不到翅膀">>)}
    end.

%% 装备翅膀 
put_wing(Role = #role{link = #link{conn_pid = ConnPid}, wing = #wing{lingxidan = LingXiDan}}, WingItem = #item{id = WingId, extra = Extra}) -> %% 从背包上
    case check_can_wing(WingItem, Role) of
        {false, Reason} -> {false, Reason};
        true ->
            case role_gain:do([#loss{label = item_id, val = [{WingId, 1}]}], Role) of
                {false, _} -> {false, ?L(<<"翅膀不存在">>)};
                {ok, NRole = #role{eqm = Eqm, wing = Wing = #wing{items = Items}}} ->
                    NextId = get_wing_next_id(Items, 0),
                    WingPos = eqm:type_to_pos(?item_wing),
                    NewWingItem = WingItem#item{bind = 1, id = NextId, pos = WingPos, extra = [{?extra_wing_lingxi, 0, <<>>} | Extra]},
                    NewWingEqm = WingItem#item{bind = 1, id = WingPos, pos = WingPos, extra = [{?extra_wing_lingxi, 0, <<>>} | Extra]},
                    case {lists:keyfind(WingPos, #item.pos, Eqm), lists:keyfind(WingPos, #item.pos, Items)} of
                        {false, false} -> %% 当前没有装备翅膀 直接装备
                            storage_api:refresh_client_item(add, ConnPid, [{?storage_eqm, [NewWingEqm]}]),
                            storage_api:refresh_client_item(add, ConnPid, [{?storage_wing, [NewWingItem]}]),
                            NewEqm = [NewWingEqm | Eqm],
                            NewItems = [NewWingItem | Items],
                            NewWing = add_skin(WingItem, Wing#wing{items = NewItems}),
                            NRole0 = NRole#role{eqm = NewEqm, wing = NewWing},
                            NRole1 = broadcast_looks(NRole0),
                            case reset_lingxi_attr(NRole1, [NewWingItem], LingXiDan) of
                                {ok, NewRole} ->
                                    {ok, NewRole};
                                {false, Reason} ->
                                    {false, Reason}
                            end;
                        {OldInEqm = #item{base_id = BaseId}, OldItem = #item{base_id = BaseId}} -> %% 当前装备有别的翅膀 先卸下旧翅膀 再装备新翅膀
                            NewEqm = lists:keyreplace(WingPos, #item.pos, Eqm, NewWingEqm),
                            OldItem1 = OldItem#item{pos = 0},
                            NewItems0 = lists:keyreplace(WingPos, #item.pos, Items, OldItem1),
                            NewItems = [NewWingItem | NewItems0],
                            storage_api:refresh_client_item(del, ConnPid, [{?storage_eqm, [OldInEqm]}]),
                            storage_api:refresh_client_item(add, ConnPid, [{?storage_eqm, [NewWingEqm]}]),
                            storage_api:refresh_client_item(refresh, ConnPid, [{?storage_wing, [OldItem1]}]),
                            storage_api:refresh_client_item(add, ConnPid, [{?storage_wing, [NewWingItem]}]),
                            NewWing = add_skin(WingItem, Wing#wing{items = NewItems}),
                            NRole0 = NRole#role{eqm = NewEqm, wing = NewWing},
                            NRole1 = broadcast_looks(NRole0),
                            case reset_lingxi_attr(NRole1, [NewWingItem], LingXiDan) of
                                {ok, NewRole} ->
                                    {ok, NewRole};
                                {false, Reason} ->
                                    {false, Reason}
                            end;
                        _Data ->
                            ?DEBUG("put_wing ErrData = ~w", [_Data]),
                            ?DEBUG("put_wing Items = ~w", [Items]),
                            {false, ?L(<<"翅膀列表数据错误">>)}
                    end
            end
    end;
put_wing(Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm, wing = Wing = #wing{items = Items, lingxidan = LingXiDan}}, WingId) -> %% 从翅膀栏
    case lists:keyfind(WingId, #item.id, Items) of
        false -> 
            {false, ?L(<<"查找不到翅膀">>)};
        #item{pos = Pos} when Pos =/= 0 -> 
            {false, ?L(<<"当前翅膀已装备">>)};
        WingItem = #item{extra = Extra} ->
            WingPos = eqm:type_to_pos(?item_wing),
            NewWingItem = WingItem#item{pos = WingPos, extra = replace_extra_lingxi(Extra, LingXiDan, [])},
            NewWingEqm = WingItem#item{id = WingPos, pos = WingPos, extra = replace_extra_lingxi(Extra, LingXiDan, [])},
            rank_celebrity:listener(wing_step, Role, get_wing_step(WingItem)), %% 名人榜 翅膀升阶
            case {lists:keyfind(WingPos, #item.pos, Eqm), lists:keyfind(WingPos, #item.pos, Items)} of
                {false, false} -> %% 当前没有装备翅膀 直接装备
                    storage_api:refresh_client_item(add, ConnPid, [{?storage_eqm, [NewWingEqm]}]),
                    storage_api:refresh_client_item(refresh, ConnPid, [{?storage_wing, [NewWingItem]}]),
                    NewEqm = [NewWingEqm | Eqm],
                    NewItems = lists:keyreplace(WingId, #item.id, Items, NewWingItem),
                    NewWing = add_skin(WingItem, Wing#wing{items = NewItems}),
                    NRole0 = Role#role{eqm = NewEqm, wing = NewWing},
                    NRole = broadcast_looks(NRole0),
                    NewRole = role_api:push_attr(NRole),
                    {ok, NewRole};
                {OldInEqm = #item{base_id = BaseId}, OldItem = #item{base_id = BaseId}} -> %% 当前装备有别的翅膀 先卸下旧翅膀 再装备新翅膀
                    NewEqm = lists:keyreplace(WingPos, #item.pos, Eqm, NewWingEqm),
                    OldItem1 = OldItem#item{pos = 0},
                    NewItems0 = lists:keyreplace(WingPos, #item.pos, Items, OldItem1),
                    NewItems = lists:keyreplace(WingId, #item.id, NewItems0, NewWingItem),
                    storage_api:refresh_client_item(del, ConnPid, [{?storage_eqm, [OldInEqm]}]),
                    storage_api:refresh_client_item(add, ConnPid, [{?storage_eqm, [NewWingEqm]}]),
                    storage_api:refresh_client_item(refresh, ConnPid, [{?storage_wing, [OldItem1, NewWingItem]}]),
                    NewWing = add_skin(WingItem, Wing#wing{items = NewItems}),
                    NRole0 = Role#role{eqm = NewEqm, wing = NewWing},
                    NRole = broadcast_looks(NRole0),
                    NewRole = role_api:push_attr(NRole),
                    {ok, NewRole};
                _ ->
                    {false, ?L(<<"翅膀列表数据错误">>)}
            end
    end.
check_can_wing(#item{base_id = BaseId}, Role) ->
    case item_data:get(BaseId) of
        {ok, #item_base{condition = Cond}} ->
            case role_cond:check(Cond, Role) of
                {false, RCond} -> {false, RCond#condition.msg};
                true -> true
            end;
        _ ->
            ?ERR("发现未知物品:~w",[BaseId]),
            {false, ?L(<<"未知物品数据">>)}
    end.
get_wing_next_id([], MaxId) -> MaxId + 1;
get_wing_next_id([#item{id = Id} | T], MaxId) ->
    case Id > MaxId of
        true -> get_wing_next_id(T, Id);
        false -> get_wing_next_id(T, MaxId)
    end.
add_skin(WingItem = #item{base_id = BaseId}, Wing = #wing{skin_list = SkinList}) ->
    Grade = enchant_grade(WingItem),
    case lists:member(BaseId, SkinList) of
        true -> Wing#wing{skin_id = BaseId, skin_grade = Grade};
        false -> Wing#wing{skin_id = BaseId, skin_grade = Grade, skin_list = [BaseId | SkinList]}
    end.
add_skin(BaseId, Enchant, Wing = #wing{skin_list = SkinList}) ->
    Grade = enchant_grade(Enchant),
    case lists:member(BaseId, SkinList) of
        true -> Wing#wing{skin_id = BaseId, skin_grade = Grade};
        false -> Wing#wing{skin_id = BaseId, skin_grade = Grade, skin_list = [BaseId | SkinList]}
    end.

%% 翅膀外观物品使用
use_skin_item(Role = #role{eqm = Eqm}, WingSkinItem = #item{id = WingSkinId}) ->
    case lists:keyfind(?item_wing, #item.type, Eqm) of
        false -> {false, ?L(<<"当前没有装备翅膀">>)};
        #item{enchant = Enchant} ->
            case role_gain:do([#loss{label = item_id, val = [{WingSkinId, 1}]}], Role) of
                {false, _} -> {false, ?L(<<"物品不存在">>)};
                {ok, NRole = #role{wing = Wing}} ->
                    NewWing = add_skin(WingSkinItem#item{enchant = Enchant}, Wing),
                    NRole0 = NRole#role{wing = NewWing},
                    NewRole = broadcast_looks(NRole0), 
                    {ok, NewRole}
            end
    end.

%% 脱下翅膀
takeoff_wing(Role = #role{link = #link{conn_pid = ConnPid}, eqm = Eqm, wing = Wing = #wing{items = Items}}) ->
    WingPos = eqm:type_to_pos(?item_wing),
    case {lists:keyfind(WingPos, #item.pos, Eqm), lists:keyfind(WingPos, #item.pos, Items)} of
        {false, false} -> {false, ?L(<<"当前没有装备翅膀">>)};
        {InWing = #item{base_id = BaseId}, OldItem = #item{base_id = BaseId}} ->
            NewEqm = lists:keydelete(WingPos, #item.pos, Eqm),
            OldItem1 = OldItem#item{pos = 0},
            NewItems = lists:keyreplace(WingPos, #item.pos, Items, OldItem1),
            storage_api:refresh_client_item(del, ConnPid, [{?storage_eqm, [InWing]}]),
            storage_api:refresh_client_item(refresh, ConnPid, [{?storage_wing, [OldItem1]}]),
            NRole0 = Role#role{eqm = NewEqm, wing = Wing#wing{skin_id = 0, skin_grade = 0, items = NewItems}},
            NRole = broadcast_looks(NRole0),
            NewRole = role_api:push_attr(NRole),
            {ok, NewRole};
        _ ->
            {false, ?L(<<"翅膀列表数据异常">>)}
    end.

%% 更换场境外观
change_skin(Role = #role{eqm = Eqm, wing = Wing = #wing{skin_list = SkinList}}, SkinId, Grade) when Grade =:= 0 orelse Grade =:= 1 orelse Grade =:= 2 ->
    case lists:keyfind(?item_wing, #item.type, Eqm) of
        false -> {false, ?L(<<"当前没有装备翅膀">>)};
        #item{enchant = Enchant} when Enchant < 12 andalso Grade =:= 2 ->
            {false, ?L(<<"当前翅膀没有强化到+12，不能使用+12形象。">>)};
        #item{enchant = Enchant} when Enchant < 9 andalso Grade =:= 1 ->
            {false, ?L(<<"当前翅膀没有强化到+9，不能使用+9形象。">>)};
        _ ->
            case lists:member(SkinId, SkinList) of
                false -> {false, ?L(<<"当前没有此外观">>)};
                true ->
                    NRole = broadcast_looks(Role#role{wing = Wing#wing{skin_id = SkinId, skin_grade = Grade}}),
                    looks:refresh(Role, NRole),
                    {ok, NRole}
            end
    end;
change_skin(_Role, _SkinId, _Grade) ->
    {false, ?L(<<"非法选择">>)}.

%% 计算翅膀外观
calc_looks(#role{eqm = Eqm, wing = #wing{skin_id = SkinId, skin_grade = Grade}}) ->
    case lists:keyfind(eqm:type_to_pos(?item_wing), #item.id, Eqm) of
        #item{enchant = Enchant} when SkinId > 0 -> %% 有选择外观
            calc_looks(SkinId, Grade, Enchant);
        #item{base_id = BaseId, enchant = Enchant} -> %% 选择外观为0
            calc_looks(BaseId, enchant_grade(Enchant), Enchant);
        _ -> []    %% 没有装备翅膀
    end.
calc_looks(SkinId, Grade, Enchant) when is_integer(SkinId) andalso is_integer(Grade) andalso SkinId > 0 ->
    if 
        Enchant =:= 12 andalso Grade =:= 2 -> %% 使用+12外观
            [{?LOOKS_TYPE_WING, SkinId, ?LOOKS_VAL_ENCHANT_TWELVE}];
        Enchant >= 9 andalso Grade >= 1 -> %% 使用+9~+11外观
            [{?LOOKS_TYPE_WING, SkinId, ?LOOKS_VAL_ENCHANT_NINE}];
        true -> %% 使用普通外观
            [{?LOOKS_TYPE_WING, SkinId, ?LOOKS_VAL_ENCHANT_NORMAL}]
    end;
calc_looks(_SkinId, _Grade, _Enchant) -> [].

%% 翅膀升阶
raise_step(Role = #role{wing = #wing{items = Items}}, WingId) ->
    case lists:keyfind(WingId, #item.id, Items) of 
        false -> {false, ?L(<<"查找不到翅膀数据">>)};
        WingItem = #item{extra = Extra} ->
            WingStep = get_wing_step(WingItem),
            NextBaseId = get_next_step_baseid(WingStep),
            case check_raise_step_cond(Role, WingStep) of
                {false, Reason} -> {false, Reason};
                true ->
                    case wing_data:get_max_luck(WingStep) of
                        MaxLuck when NextBaseId =/= false andalso is_integer(MaxLuck) andalso MaxLuck > 0 ->
                            LuckVal = case lists:keyfind(?extra_wing_luck, 1, Extra) of
                                {_, Luck, _} -> Luck;
                                _ -> 0
                            end,
                            case LuckVal >= MaxLuck of
                                true -> %% 进阶处理
                                    do_raise_step(Role, WingItem, NextBaseId);
                                false -> %% 提升幸运值
                                    do_raise_step_luck(Role, WingItem, WingStep, MaxLuck, LuckVal)
                            end;
                        _ ->
                            {false, ?L(<<"当前翅膀已是最高阶，不能继续进阶">>)}
                    end
            end
    end.

%% 使用翅膀外观卡，并永久附加属性
ext_attr(Role = #role{pid = Pid}, ExtAttrL, Msg) ->
    case add_ext_attr(Role, ExtAttrL) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} ->
            role:pack_send(Pid, 10931, {57, Msg, []}),
            {ok, NewRole}
    end.

add_ext_attr(Role, []) -> {ok, Role};
add_ext_attr(Role = #role{eqm = Eqm, wing = Wing}, [{base_id, BaseId} | T]) ->
    case lists:keyfind(?item_wing, #item.type, Eqm) of
        false -> {false, ?L(<<"当前没有装备翅膀">>)};
        #item{enchant = Enchant} ->
            NewWing = add_skin(BaseId, Enchant, Wing),
            NRole0 = Role#role{wing = NewWing},
            NewRole = broadcast_looks(NRole0),
            add_ext_attr(NewRole, T)
    end;
add_ext_attr(Role = #role{wing = #wing{items = Items, lingxidan = LingXiDan}}, [{lingxi, Num} | T]) ->
    case reset_lingxi_attr(Role, Items, LingXiDan + Num) of
        {false, Reason} -> {false, Reason};
        {ok, NewRole} -> add_ext_attr(NewRole, T)
    end;
add_ext_attr(_Role, _ExtAttrL) -> {false, ?L(<<"翅膀外观卡数据错误">>)}.

%% 使用灵犀丹
use_lingxidan(Role = #role{wing = #wing{items = Items, lingxidan = LingXiDan}}, #item{id = ItemId}, Num) when LingXiDan + Num =< 300 ->
    case role_gain:do([#loss{label = item_id, val = [{ItemId, Num}]}], Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, NewRole} ->
            case reset_lingxi_attr(NewRole, Items, LingXiDan + Num) of
                {false, Reason} -> {false, Reason};
                {ok, Nr} ->
                    log:log(log_item_del_loss, {util:fbin(<<"灵犀值[~w]">>, [LingXiDan + Num]), Nr}),
                    {ok, util:fbin(?L(<<"使用成功，翅膀灵犀值增加~w点，属性得到了加强！">>), [Num]), Nr}
            end
    end;
use_lingxidan(_Role, _Item, _Num) -> {false, ?L(<<"灵犀丹使用已达到上限300个，不能再使用">>)}.

%% 判断进阶等级需求
check_raise_step_cond(#role{lev = Lev}, 0) when Lev < 10 -> {false, ?L(<<"人物需要提升到10级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 1) when Lev < 20 -> {false, ?L(<<"人物需要提升到20级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 2) when Lev < 30 -> {false, ?L(<<"人物需要提升到30级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 3) when Lev < 35 -> {false, ?L(<<"人物需要提升到35级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 4) when Lev < 40 -> {false, ?L(<<"人物需要提升到40级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 5) when Lev < 45 -> {false, ?L(<<"人物需要提升到45级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 6) when Lev < 50 -> {false, ?L(<<"人物需要提升到50级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 7) when Lev < 52 -> {false, ?L(<<"人物需要提升到52级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 8) when Lev < 55 -> {false, ?L(<<"人物需要提升到55级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 9) when Lev < 57 -> {false, ?L(<<"人物需要提升到57级，翅膀才能继续进阶">>)};
check_raise_step_cond(#role{lev = Lev}, 10) when Lev < 60 -> {false, ?L(<<"人物需要提升到60级，翅膀才能继续进阶">>)};
check_raise_step_cond(_Role, _WingStep) -> true.

%% 祝福已满 直接进阶
do_raise_step(Role = #role{wing = Wing = #wing{lingxidan = LingXiDan}}, #item{id = Id, pos = Pos, enchant = Enchant, enchant_fail = EnchantFail, upgrade = Upgrade, attr = OldAttr, craft = Craft, special = Special, extra = Extra, max_base_attr = MaxBaseAttr, polish_list = PolishList}, NextBaseId) ->
    case item:make(NextBaseId, 1, 1) of
        {ok, [NewItem = #item{attr = BaseAttr}]} -> 
            HoleList = [?attr_hole1, ?attr_hole2, ?attr_hole3, ?attr_hole4, ?attr_hole5],
            OldOtherAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- OldAttr, Flag >= 900], %% 技能属性 + 洗炼属性
            OldHoleAttr = [{Name1, Flag1, Value1} || {Name1, Flag1, Value1} <- OldAttr, lists:member(Name1, HoleList) =:= true],
            NewBaseAttr0 = [{Name2, Flag2, Value2} || {Name2, Flag2, Value2} <- BaseAttr, lists:member(Name2, HoleList) =:= false],
            NewExtra0 = lists:keydelete(?extra_wing_luck, 1, Extra),
            {NewBaseAttr, NewExtra} = calc_lingxi_attr(NextBaseId, LingXiDan, NewBaseAttr0, NewExtra0),
            ?DEBUG("NewBaseAttr = ~w", [NewBaseAttr]),
            ?DEBUG("NewExtra = ~w", [NewExtra]),
            NewWingItem0 = blacksmith:recalc_attr(NewItem#item{id = Id, pos = Pos, enchant = Enchant, upgrade = Upgrade, attr = NewBaseAttr ++ OldOtherAttr ++ OldHoleAttr, craft = Craft, special = Special, extra = NewExtra, max_base_attr = MaxBaseAttr, polish_list = PolishList, enchant_fail = EnchantFail}),
            NewWingItem = blacksmith:check_enchant_hole(NewWingItem0),
            NewWing = add_skin(NewWingItem, Wing),
            NRole = replace_wing(Role#role{wing = NewWing}, NewWingItem), 
            NewRole = broadcast_looks(NRole),
            RoleMsg = notice:role_to_msg(Role),
            ItemMsg = notice:item_to_msg(NewWingItem),
            NewStep = get_wing_step(NewWingItem),
            if
                NewStep < 5 -> 
                    {ok, [ItemTmp]} = item:make(32202, 0, 1),
                    ItemTmpMsg = notice:item_to_msg(ItemTmp),
                    notice:send(53, util:fbin(?L(<<"羽化登仙！~s使用~s竟然将翅膀进化到~s（~p阶），那华美的羽翼令人惊叹不已。{open, 33, 我要进阶, #00ff00}">>), [RoleMsg, ItemTmpMsg, ItemMsg, NewStep]));
                true -> 
                    {ok, [ItemTmp]} = item:make(32203, 0, 1),
                    ItemTmpMsg = notice:item_to_msg(ItemTmp),
                    notice:send(53, util:fbin(?L(<<"羽化登仙！~s使用~s竟然将翅膀进化到~s（~p阶），那华美的羽翼令人惊叹不已。{open, 33, 我要进阶, #00ff00}">>), [RoleMsg, ItemTmpMsg, ItemMsg, NewStep]))
            end,
            campaign_reward:handle(wing_step, NewRole, NewStep),
            campaign_listener:handle(wing_step, NewRole, NewStep),
            rank_celebrity:listener(wing_step, NewRole, NewStep), %% 名人榜 翅膀升阶
            log:log(log_handle_all, {16705, <<"翅膀进阶">>, util:fbin("进阶成功:~p", [NewStep]), Role}),
            {ok, NewRole};
        _ ->
            {false, ?L(<<"无法生成新翅膀数据">>)}
    end.

calc_lingxi_attr(_BaseId, undefined, BaseAttr, Extra) -> {BaseAttr, Extra};
calc_lingxi_attr(_BaseId, 0, BaseAttr, Extra) -> {BaseAttr, Extra};
calc_lingxi_attr(BaseId, LingXiDan, BaseAttr, Extra) ->
    LingXi = get_lingxi(BaseId, LingXiDan),
    NewExtra = replace_extra_lingxi(Extra, LingXi, []),
    %[?DEBUG("Name = ~w, Value = ~w, CalValue = ~w", [Name, Value, erlang:round(Value * (1 + LingXi * 5 / 1000))]) || {Name, _Flag, Value} <- BaseAttr],
    {[{Name, Flag, erlang:round(Value * (1 + 5 / 1000 * LingXi))} || {Name, Flag, Value} <- BaseAttr], NewExtra}.

replace_extra_lingxi([], LingXi, NewExtra) -> [{?extra_wing_lingxi, LingXi, <<>>} | NewExtra];
replace_extra_lingxi([{?extra_wing_lingxi, _, _} | T], LingXi, NewExtra) ->
    replace_extra_lingxi(T, LingXi, NewExtra);
replace_extra_lingxi([H | T], LingXi, NewExtra) ->
    replace_extra_lingxi(T, LingXi, [H | NewExtra]).

get_lingxi(_BaseId, LingXiDan) ->
    LingXiDan.
    %Step = get_wing_step(BaseId),
    %case Step > 4 of
    %    true -> Step - 4 + LingXiDan;
    %    false -> LingXiDan
    %end.

reset_lingxi_attr(Role = #role{wing = Wing}, [], LingXiDan) -> {ok, Role#role{wing = Wing#wing{lingxidan = LingXiDan}}};
reset_lingxi_attr(Role, [Item = #item{base_id = BaseId, attr = OldAttr, extra = Extra} | T], LingXiDan) ->
    case item:make(BaseId, 1, 1) of
        {ok, [#item{attr = BaseAttr}]} ->
            HoleList = [?attr_hole1, ?attr_hole2, ?attr_hole3, ?attr_hole4, ?attr_hole5],
            OldOtherAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- OldAttr, Flag >= 900], %% 技能属性 + 洗炼属性
            OldHoleAttr = [{Name1, Flag1, Value1} || {Name1, Flag1, Value1} <- OldAttr, lists:member(Name1, HoleList) =:= true],
            NewBaseAttr0 = [{Name2, Flag2, Value2} || {Name2, Flag2, Value2} <- BaseAttr, lists:member(Name2, HoleList) =:= false],
            {NewBaseAttr, NewExtra} = calc_lingxi_attr(BaseId, LingXiDan, NewBaseAttr0, Extra),
            NewItem0 = blacksmith:recalc_attr(Item#item{attr = NewBaseAttr ++ OldOtherAttr ++ OldHoleAttr, extra = NewExtra}),
            NewItem = blacksmith:check_enchant_hole(NewItem0),
            reset_lingxi_attr(fresh_wing(Role, NewItem), T, LingXiDan);
        _ ->
            {false, ?L(<<"无法生成翅膀数据">>)}
    end.

%% 祝福没满 继续提升祝福
do_raise_step_luck(Role = #role{eqm = Eqm, wing = Wing}, WingItem = #item{pos = Pos, extra = Extra}, WingStep, MaxLuck, LuckVal) ->
    case step_price(WingStep) of
        false -> {false, ?L(<<"查找不到升阶消耗材料">>)};
        GL ->
            case role_gain:do(GL, Role) of
                {false, #loss{label = Label}} when Label =:= gold orelse Label =:= coin_all ->
                    {false, Label};
                {false, Loss} ->
                    {false, Loss#loss.msg};
                {ok, NRole} ->
                    Inform = notice_inform:gain_loss(GL, ?L(<<"翅膀进阶">>)),
                    notice:inform(Role#role.pid, Inform),
                    Suc = wing_data:get_suc(WingStep, LuckVal),
                    {Flag, NewLuckVal} = case util:rand(1, 100) of
                        RandVal when RandVal =< Suc -> %% 成功升满幸运
                            {suc, MaxLuck};
                        _ -> %% 提升失败 增加1~3点幸运值
                            {fail, LuckVal + util:rand(1, 3)}
                    end,
                    NewExtra = update_extra_val(Extra, {?extra_wing_luck, NewLuckVal, <<>>}),
                    NewWingItem = WingItem#item{extra = NewExtra},
                    NewEqm = lists:keyreplace(Pos, #item.pos, Eqm, NewWingItem#item{id = Pos}),
                    NewWing = storage_api:fresh_wing(WingItem, NewWingItem, Wing, Role#role.link#link.conn_pid),
                    NewRole = NRole#role{eqm = NewEqm, wing = NewWing},
                    {Flag, WingStep, NewLuckVal, LuckVal, NewRole}
            end
    end.

%% 更新属性值
update_extra_val(L, {Type, Val1, Val2}) ->
    case lists:keyfind(Type, 1, L) of
        false -> [{Type, Val1, Val2} | L];
        _ -> lists:keyreplace(Type, 1, L, {Type, Val1, Val2})
    end.

%% 获取下一阶的物品BaseID
get_next_step_baseid(0) -> 18850;
get_next_step_baseid(1) -> 18851;
get_next_step_baseid(2) -> 18852;
get_next_step_baseid(3) -> 18853;
get_next_step_baseid(4) -> 18854;
get_next_step_baseid(5) -> 18855;
get_next_step_baseid(6) -> 18856;
get_next_step_baseid(7) -> 18858;
get_next_step_baseid(8) -> 18857;
get_next_step_baseid(9) -> 18859;
get_next_step_baseid(10) -> 18860;
get_next_step_baseid(_) -> false.

%% 根据基础ID取阶数
baseid_step(18850) -> 1;
baseid_step(18851) -> 2;
baseid_step(18852) -> 3;
baseid_step(18853) -> 4;
baseid_step(18854) -> 5;
baseid_step(18855) -> 6;
baseid_step(18856) -> 7;
baseid_step(18858) -> 8;
baseid_step(18857) -> 9;
baseid_step(18859) -> 10;
baseid_step(18860) -> 11;
baseid_step(_) -> 0.

%% 获取相关强化外观
enchant_grade(#item{enchant = Enchant}) -> enchant_grade(Enchant);
enchant_grade(Enchant) when Enchant =:= 12 -> 2;
enchant_grade(Enchant) when Enchant >= 9 -> 1;
enchant_grade(_Enchant) -> 0.

%% 重新广播外观
broadcast_looks(Role) ->
    NRole = looks:calc(Role),
    map:role_update(NRole),
    push_info(skin_list, NRole),
    NRole.
    
%%--------------------------------
%% 内部方法
%%--------------------------------

%% 升阶所需材料
%% step_price(0) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32202, 0, 1], msg = <<"翅膀灵羽数量不足">>}];
step_price(1) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32202, 0, 1], msg = ?L(<<"翅膀灵羽数量不足">>)}];
step_price(2) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32202, 0, 2], msg = ?L(<<"翅膀灵羽数量不足">>)}];
step_price(3) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32202, 0, 2], msg = ?L(<<"翅膀灵羽数量不足">>)}];
step_price(4) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32203, 0, 1], msg = ?L(<<"翅膀仙羽数量不足">>)}];
step_price(5) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32203, 0, 2], msg = ?L(<<"翅膀仙羽数量不足">>)}];
step_price(6) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32203, 0, 3], msg = ?L(<<"翅膀仙羽数量不足">>)}];
step_price(7) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32203, 0, 4], msg = ?L(<<"翅膀仙羽数量不足">>)}];
step_price(8) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32203, 0, 5], msg = ?L(<<"翅膀仙羽数量不足">>)}];
step_price(9) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32203, 0, 6], msg = ?L(<<"翅膀仙羽数量不足">>)}];
step_price(10) -> [#loss{label = coin_all, val = 2000}, #loss{label = item, val = [32203, 0, 7], msg = ?L(<<"翅膀仙羽数量不足">>)}];
step_price(_Step) -> false.


