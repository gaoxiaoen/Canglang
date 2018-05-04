%%----------------------------------------------------
%% 仙宠真身
%% @author weihua@jieyou.cn
%%----------------------------------------------------
-module(pet_rb).
-export([list/1
        ,lookup/1
        ,active/2
        ,calc_attr/1
        ,lookup/2
        ,rare_value/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("pet_rb.hrl").
-include("link.hrl").
-include("pet.hrl").

%% @spec calc(Role) -> List
%% Role = NewRole
%% @doc 计算角色 属性加成
calc_attr(Role) ->
    {_, AccAttrs} = lookup(Role),
    [{L, 0, V} || {L, V} <- AccAttrs].

%% @spec list(Role) -> List
%% Role = #role{}
%% @doc 获取宠物真身列表
list(#role{pet_rb = ActivePrbIds}) ->
    PrbIds = pet_rb_data:list(),
    Prbs = list_all(PrbIds),
    MarkedPrbs = mark_prbs(Prbs, ActivePrbIds),
    [{Name, Id, Type, Value, Status, Image, Desc, Card, Material, Attr} ||
        #pet_rb{name = Name, id = Id, type = Type, value = Value, status = Status, image = Image, desc = Desc, card = Card, material = Material, attr = Attr} <- MarkedPrbs].

list_all(PrbIds) ->
    list_all(PrbIds, []).
list_all([], Prbs) -> Prbs;
list_all([Id | Ids], Prbs) ->
    case pet_rb_data:get(Id) of
        {ok, Prb} when is_record(Prb, pet_rb) ->
            list_all(Ids, [Prb | Prbs]);
        _ ->
            ?ERR("找不到真身[id:~w]的真身数据", [Id]),
            list_all(Ids, Prbs)
    end.

mark_prbs(Prbs, ActivePrbIds) ->
    mark_prbs(Prbs, ActivePrbIds, []).
mark_prbs([], _Ids, MarkedPrbs) -> MarkedPrbs;
mark_prbs([Prb = #pet_rb{id = Id} | Prbs], Ids, MarkedPrbs) ->
    case lists:member(Id, Ids) of
        true -> mark_prbs(Prbs, Ids, [Prb#pet_rb{status = ?true} | MarkedPrbs]);
        false -> mark_prbs(Prbs, Ids, [Prb#pet_rb{status = ?false} | MarkedPrbs])
    end.

%% @spec lookup(by_id, RoleId) -> error | {List, Tuple}
%% RoleId = {integer(), binary()}
%% List = [integer() | ..]
%% Tuple = {integer(), TupleList}
%% Tuplelist = [{integer(), integer() } | ..]
%% @doc 查看指定角色真身数据
lookup(by_id, {Rid, SrvId}) ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.pet_rb) of
        {ok, _Node, Prb} ->
            {Prb, calc_pet_rb(Prb)};
        _ -> error
    end.

%% @spec rare_value(Role) -> {ok, integer()}
%% Role = #role{}
%% @doc 获取宠物珍稀度值
rare_value(#role{pet_rb = PrbIds}) ->
    rare_value(PrbIds, 0).

rare_value([], Value) ->
    {ok, Value};
rare_value([Id | Ids], AccValue) ->
    case pet_rb_data:get(Id) of
        {ok, #pet_rb{value = Value}} ->
            rare_value(Ids, AccValue + Value);
        _ ->
            ?ERR("找不到真身[id:~w]的真身数据", [Id]),
            rare_value(Ids, AccValue)
    end.

%% @spec lookup(Role) -> {AccValue, Accattrs}
%% Role = #role{}
%% AccValue = integer()
%% Accattrs = [{integer(), integer() } | ..]
%% @doc 查看自己的真身数据
lookup(#role{pet_rb = ActivePrbIds}) ->
    calc_pet_rb(ActivePrbIds);
lookup(_Role) -> {0, []}.

calc_pet_rb(Ids) ->
    calc_pet_rb(Ids, {0, []}).
calc_pet_rb([], {AccValue, AccAttrs}) -> {AccValue, AccAttrs};
calc_pet_rb([Id | Ids], {AccValue, AccAttrs}) ->
    case pet_rb_data:get(Id) of
        {ok, #pet_rb{attr = Attrs, value = Value}} ->
            calc_pet_rb(Ids, {AccValue + Value, calc_pet_rb_attrs(AccAttrs, Attrs)});
        _ ->
            ?ERR("找不到真身[id:~w]的真身数据", [Id]),
            calc_pet_rb(Ids, {AccValue, AccAttrs})
    end.

calc_pet_rb_attrs(AccAttrs, []) -> AccAttrs;
calc_pet_rb_attrs(AccAttrs, [{Label, Value} | Attr]) ->
    case lists:keyfind(Label, 1, AccAttrs) of
        {_, AccValue} ->
            calc_pet_rb_attrs(lists:keyreplace(Label, 1, AccAttrs, {Label, Value + AccValue}), Attr);
        _ ->
            calc_pet_rb_attrs([{Label, Value} | AccAttrs], Attr)
    end.

%% @spec active(Role, CardId) -> {false, Reason} | {ok, NewRole}
%% Role = NewRole = #role{}
%% CardId = integer()
%% Reason = Msg = binary()
%% @doc 激活真身
active(Role = #role{pet_rb = PrbIds, link = #link{conn_pid = ConnPid}, pet = PetBag = #pet_bag{active = Active}}, CardId) ->
    case pet_rb_data:card_rb_mapping(CardId) of
        false ->
            ?ERR("没有该真身卡类型 ~w", [CardId]),
            {false, ?L(<<"没有该真身卡类型">>)};
        PrbId ->
            case lists:member(PrbId, PrbIds) of
                true ->
                    {false, ?L(<<"该真身已经激活过！">>)};
                false ->
                    case pet_rb_data:get(PrbId) of
                        {ok, #pet_rb{card = CardId, type = Type, image = Image, name = CardName}} ->
                            Role1 = Role#role{pet_rb = [PrbId | PrbIds]},
                            Data = lookup(Role1),
                            sys_conn:pack_send(ConnPid, 12684, {PrbId, ?true}),
                            sys_conn:pack_send(ConnPid, 12683, Data),
                            Role2 = pet_api:reset_all(Role1),
                            NewPetBag = case Active of
                                #pet{skin_id = UseSkinId, skin_grade = UseGrade} -> pet_ex:add_skin_and_push(Image, PetBag, UseSkinId, UseGrade, ConnPid);
                                _ -> pet_ex:add_skin_and_push(Image, PetBag, 0, 0, ConnPid)
                            end,
                            RbName = case Type of
                                4 -> util:fbin(<<"{str, ~s, #FF8400}">>, [CardName]);
                                3 -> util:fbin(<<"{str, ~s, #CA57FF}">>, [CardName]);
                                2 -> util:fbin(<<"{str, ~s, #0088ff}">>, [CardName]);
                                _ -> util:fbin(<<"{str, ~s, #00FF24}">>, [CardName])
                            end,
                            notice:send(53, util:fbin(?L(<<"只见一道灵光划过长空，原来是~s使用了~s激活了 ~s 真身">>), [notice:role_to_msg(Role), notice:item_to_msg({CardId, 1, 1}), RbName])),
                            NewRole = Role2#role{pet = NewPetBag},
                            pet_rb_reward:listener(pet_rb_qua, NewRole, CardId),
                            rank:listener(pet, NewRole),
                            {ok, NewRole};
                        _ ->
                            {false, ?L(<<"没有该真身类型">>)}
                    end
            end
    end.
