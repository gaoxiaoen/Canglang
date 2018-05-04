%%----------------------------------------------------
%% 翅膀版本转换
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(wing_parse).
-export([
        dress_to_wing/1
        ,do/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("wing.hrl").
-include("item.hrl").

%% 角色翅膀数据转移 旧号
dress_to_wing(Role = #role{eqm = Eqm, dress = Dress, wing = Wing = #wing{items = [], skin_list = []}}) -> 
    NewDress = [Item1 || Item1 <- Dress, Item1#item.type =/= ?item_wing],
    WingItems = [Item2#item{pos = 0} || Item2 <- Dress, Item2#item.type =:= ?item_wing],
    WingPos = eqm:type_to_pos(?item_wing),
    SkinList = [Item3#item.base_id || Item3 <- WingItems],
    {NewWing1, NewEqm1} = case lists:keyfind(WingPos, #item.pos, Eqm) of
        Item = #item{base_id = BaseId, enchant = Enchant} -> %% 角色身上有翅膀
            SkinGrade = if
                Enchant =:= 12 -> 2;
                Enchant >= 9 -> 1;
                true -> 0
            end,
            NewWingItems = lists:keyreplace(BaseId, #item.base_id, WingItems, Item),
            NewWing = Wing#wing{skin_id = BaseId, skin_grade = SkinGrade, skin_list = SkinList, items = set_wing_id(1, NewWingItems, []), lingxidan = 0},
            NewEqmItem = reset_calc_attr(Item),
            NewEqm = lists:keyreplace(WingPos, #item.pos, Eqm, NewEqmItem),
            {NewWing, NewEqm};
        false when WingItems =/= [] -> %% 角色有翅膀 但没穿
            NewWing = Wing#wing{skin_list = SkinList, items = set_wing_id(1, WingItems, []), lingxidan = 0},
            {NewWing, Eqm};
        _ ->
            {Wing#wing{lingxidan = 0}, Eqm}
    end,
    Role#role{dress = NewDress, wing = NewWing1, eqm = NewEqm1};
dress_to_wing(Role = #role{eqm = Eqm, wing = Wing = #wing{items = Items, lingxidan = undefined}}) ->
    WingPos = eqm:type_to_pos(?item_wing),
    {NewWing1, NewEqm1} = case lists:keyfind(WingPos, #item.pos, Eqm) of
        false ->
            {Wing#wing{items = calc_lingxi_attr(Items, []), lingxidan = 0}, Eqm};
        EqmItem ->
            [NewEqmItem] = calc_lingxi_attr([EqmItem], []),
            {Wing#wing{items = calc_lingxi_attr(Items, []), lingxidan = 0}, lists:keyreplace(WingPos, #item.pos, Eqm, NewEqmItem)}
    end,
    Role#role{wing = NewWing1, eqm = NewEqm1};
dress_to_wing(Role) -> Role.

set_wing_id(_Id, [], Items) -> Items;
set_wing_id(Id, [Item | T], Items) ->
    NewItem = reset_calc_attr(Item),
    set_wing_id(Id + 1, T, [NewItem#item{id = Id} | Items]).

calc_lingxi_attr([], Items) -> Items;
calc_lingxi_attr([Item = #item{extra = Extra} | T], Items) ->
    NewExtra = case lists:keyfind(?extra_wing_lingxi, 1, Extra) of
        false ->
            [{?extra_wing_lingxi, 0, <<>>} | Extra];
        _ ->
            Extra
    end,
    calc_lingxi_attr(T, [Item#item{extra = NewExtra} | Items]).

%% 物品属性重新计算
reset_calc_attr(Item = #item{attr = OldAttr, base_id = BaseId, extra = Extra}) ->
    case item:make(BaseId, 1, 1) of
        {ok, [#item{attr = NewBaseAttr}]} ->
            OldOtherAttr = [{Name, Flag, Value} || {Name, Flag, Value} <- OldAttr, Flag >= 900], %% 技能属性 + 洗炼属性
            NewExtra = case lists:keyfind(?extra_wing_lingxi, 1, Extra) of
                false ->
                    [{?extra_wing_lingxi, 0, <<>>} | Extra];
                _ ->
                    Extra
            end,    
            NewItem0 = blacksmith:recalc_attr(Item#item{attr = NewBaseAttr ++ OldOtherAttr, extra = NewExtra}),
            blacksmith:check_enchant_hole(NewItem0);
        _ ->
            Item
    end.

%% @spec do(Wing) -> {ok, NewWing} | {false, Reason}
%% 数据版本转换
do({wing, 0, SkinId, SkinGrade, SkinList, Items, SkillCoin, SkillGold, SkillTmp, SkillBag}) ->
    do({wing, 1, SkinId, SkinGrade, SkinList, Items, SkillCoin, SkillGold, SkillTmp, SkillBag, 0});
    
do(Wing = #wing{ver = ?WING_VER, items = Items}) ->
    case item_parse:do(Items) of
        {ok, NewItems} -> 
            {ok, Wing#wing{items = NewItems}};
        {false, Reason} ->
            ?ERR("翅膀列表物品数据转换失败"),
            {false, Reason}
    end;
do(_Wing) ->
    ?ERR("翅膀数据转换失败:~w", [_Wing]),
    {false, ?L(<<"翅膀版本数据转换失败">>)}.
