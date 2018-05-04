-module(dress).
-export([
        expire_idx_to_seconds/1
        ,first_clear_dungeon/2
        ,set_exp_fashion/1
        ,puton_exp_fashion/1
        ,clear_exp_fashion/1
        ,change_dress/2
        ,gen_dress_id/1
        ,puton_dress/2
        ,puton_dress_ex/2
        ,takeoff_dress/2
        ,has_the_dress/2
        ,pack_send_dress_info/1
        ,baseid_to_dresstype/1
        ,calc_looks/1
        ,calc_attr/1
        ,get_fashion_looks_type/1
        ,add_dress/2
        ,is_dress/1
        ,find_fashion/2
        ,find_fashion_by_type/2
        ,find_exp_fashion_id/3
    ]
).

-include("common.hrl").
-include("item.hrl").
-include("condition.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("version.hrl").
-include("setting.hrl").
-include("looks.hrl").


exp_fashion(0, ?career_cike) -> [106007,106107,106207,106303];
exp_fashion(1, ?career_cike) -> [106008,106108,106208, 106303];
exp_fashion(0, ?career_xianzhe) -> [106011,106111,106211, 106303];
exp_fashion(1, ?career_xianzhe) -> [106012,106112,106212, 106303];
exp_fashion(0, ?career_qishi) -> [106009,106109,106209, 106303];
exp_fashion(1, ?career_qishi) -> [106010,106110,106210, 106303].

%% 
expire_idx_to_seconds(0) -> 7 * 3600 * 24;
expire_idx_to_seconds(1) -> 30 * 3600 * 24;
expire_idx_to_seconds(2) -> -1;     %% 永久有效的物品设置为
expire_idx_to_seconds(3) -> -2;     %%  试穿时装

expire_idx_to_seconds(_) -> 7 * 3600 * 24.

%% 
%%first_clear_dungeon(12021, Role) ->
%%    set_exp_fashion(Role);
first_clear_dungeon(12041, Role) ->
    Role1 = vip:set_discount_mail(kill_npc, Role),
    clear_exp_fashion(Role1);
first_clear_dungeon(_DungeonId, Role) ->
    Role.

%% 给角色穿上体验时装
set_exp_fashion(Role = #role{sex = Sex, career = Career}) ->
    BaseIds = exp_fashion(Sex, Career),
    Items = gen_exp_fashion_item(BaseIds,[]),
    {_Ids, Role1} = lists:foldl(fun(Item, {RetId, NRole})-> {Id, Role1} = add_dress(Item, NRole), {[Id|RetId], Role1} end, {[],Role}, Items),
    pack_send_dress_info(Role1),
    Role1.

%% 穿上体验时装
puton_exp_fashion(Role = #role{}) -> Role.
%%    BaseIds = exp_fashion(Sex, Career),
%%    Ids = find_exp_fashion_id(Dress, BaseIds, []),
%%    %% {ok, Role1} = change_dress(Ids, Role),
%%    Role1 = puton_dress_ex(Ids, Role),
%%    Role2 = looks:calc(Role1),
%%    Role3 = role_api:push_attr(Role2),
%%    looks:refresh(Role, Role3),
%%    looks:refresh_set(Role3),
%%    pack_send_dress_info(Role3),
%%    Role3.

find_exp_fashion_id([], _CareerFashion, Ids) -> Ids;
find_exp_fashion_id([{Id,_, #item{base_id = BaseId}} | T], CareerFashion, Ids) ->
    case lists:member(BaseId, CareerFashion) of
        true -> find_exp_fashion_id(T, CareerFashion, [{BaseId, Id} | Ids]);
        false -> find_exp_fashion_id(T, CareerFashion, Ids)
    end.

%% 清除角色体验时装
clear_exp_fashion(Role = #role{sex = Sex, career = Career, dress = Dress}) ->
    ExpFashion = exp_fashion(Sex, Career),
    NewDress = do_clear(Dress, 1, ExpFashion, []),
    Role1 = Role#role{dress = NewDress},
    pack_send_dress_info(Role1),
    Role2 = looks:calc(Role1),
    Role3 = role_api:push_attr(Role2),
    looks:refresh(Role, Role3),
    looks:refresh_set(Role3),
    Role3.

do_clear([], _, _, Ret) -> Ret;
do_clear([{_id, IsPuton, Item = #item{base_id = BaseId}} | T], Pos, ExpFashion, Ret) ->
    case lists:member(BaseId, ExpFashion) of
        true ->
            do_clear(T, Pos, ExpFashion, Ret);
        false ->
            do_clear(T, Pos+1, ExpFashion, [{Pos, IsPuton, Item#item{pos = Pos}} | Ret])
    end.

%% 穿时装，如果身上已穿有同类型时装则不穿，否则穿上此时装
%% 
puton_dress_ex([], Role) -> Role;
puton_dress_ex([{BaseId, Id} | T], Role) ->
    case find_fashion_by_type(Role, baseid_to_dresstype(BaseId)) of
        0 ->
            case change_dress([Id], Role) of
                {false, _R} ->
                    ?DEBUG(" 穿戴失败 原因 : ~w", [_R]),
                    puton_dress_ex(T, Role);
                {ok, Role1} ->
                    puton_dress_ex(T, Role1)
            end;
        _ ->
            puton_dress_ex(T, Role)
    end.
            

%% 根据外观类型查找已穿的时装
find_fashion(#role{dress = Dress}, FashionLookType) ->
    Fashion = [BaseId || {_Id, 1, #item{base_id = BaseId}} <- Dress, get_fashion_looks_type(BaseId) =:= FashionLookType],
    case Fashion of
        [] -> 0;
        [FashionBaseId] -> FashionBaseId
    end.

%% 根据时装类型查找已穿时装
find_fashion_by_type(#role{dress = Dress}, FashionType) ->
    Fashion = [BaseId || {_Id, 1, #item{base_id = BaseId}} <- Dress, baseid_to_dresstype(BaseId) =:= FashionType],
    case Fashion of
        [] -> 0;
        [FashionBaseId] -> FashionBaseId
    end.

add_dress(Item, Role = #role{dress = Dress}) when is_record(Item, item) ->
    Id = gen_dress_id(Role),
    Dress1 = [{Id, 0, Item#item{id = Id}} | Dress],
    Role1 = Role#role{dress = Dress1},
    {Id, Role1};
add_dress([], Role) -> {ok, Role};
add_dress([Item | T], Role) ->
    {_Id, Role1} = add_dress(Item, Role),
    add_dress(T, Role1).

%% change_dress() -> {ok, Role} | {false, Reason}
change_dress(Ids, Role) when is_list(Ids), length(Ids) =< 4 ->
    do_change_dress(Ids, Role);
change_dress(_Ids, _Role) ->
    ?DEBUG("穿戴参数错误 ~w", [_Ids]),
    {false, ?L(<<"穿戴参数错误">>)}.

takeoff_dress(Id, Role = #role{}) ->
    case has_the_dress(Id, Role) of
        false ->
            {false, ?L(<<"亲，您暂时没有这件装备哦！请到商城处购买">>)};
        {_, 0, #item{}} ->
            {false, ?L(<<"亲，您现在还没有穿这件装备，怎么脱">>)};
        {_, 1, #item{base_id = BaseId}}->
            Role1 = clear_dress_flag(BaseId, Role),
            Role2 = looks:calc(Role1),
            Role3 = role_api:push_attr(Role2),
            looks:refresh(Role, Role3),
            pack_send_dress_info(Role3),
            {ok, Role3}
    end.

gen_dress_id(#role{dress = Dress}) ->
    length(Dress) + 1.

has_the_dress(Id, #role{dress = Dress}) ->
    case lists:keyfind(Id, 1, Dress) of
        false -> false;
        Ret -> Ret
    end.

calc_looks(#role{dress = Dress}) ->
    Looks = do_calc_looks(Dress, []),
    %% ?DEBUG("*******  计算后时装外观: ~w", [Looks]),
    Looks.
    
calc_attr(Role = #role{dress = Dress}) ->
    Role1 = do_calc_attr(Dress, Role),
    Role2 = calc_set_attr(Role1),
    Role2.

is_dress(BaseId) -> BaseId div 1000 =:= 106.

%% -----------------  私有函数  -------------------------

%% 根据物品 BASE ID生成体验时装 ITEM
gen_exp_fashion_item([], Ret) -> Ret;
gen_exp_fashion_item([BaseId | T], Ret) ->
    case item:make(BaseId, 1, 1) of
        false ->
            ?ELOG(" 生成时装物品失败  ~w", [BaseId]),
            gen_exp_fashion_item(T, Ret);
        {ok, [Item = #item{special = Spec}]} ->
            {ok, #item_base{effect = Effect}} = item_data:get(BaseId),
            Attr = lists:keydelete(?attr_looks_id, 1, Effect), %% 选出体验时装属性
            gen_exp_fashion_item(T, [Item#item{attr = Attr, special = [{?special_expire_time, -2} | Spec]} | Ret])
    end.

calc_set_attr(Role = #role{dress = Dress}) ->
    SetNum = calc_set_num(Dress, []),
    SumAttr = sum_set_attr(SetNum, []),
    Attr = [{Label, 100, Val} || {Label, Val} <- SumAttr],
    {ok, Role1} = eqm_effect:do_attr(Attr, Role),
    Role1.

sum_set_attr([], Attr) -> Attr;
sum_set_attr([{SetId, Num} | T], Attr) ->
    ConfAttr = suit_data:get_fashion_suit_attr(SetId, Num),
    sum_set_attr(T, ConfAttr ++ Attr).

calc_set_num([], SetNum) -> SetNum;
calc_set_num([{_Id, 0, #item{}} | T], SetNum) ->
    calc_set_num(T, SetNum);
calc_set_num([{_Id, 1, #item{base_id = BaseId}} | T], SetNum) ->
    {ok, #item_base{set_id = SetId}} = item_data:get(BaseId),
    case SetId =:= 0 of
        false ->
            case lists:keyfind(SetId, 1, SetNum) of
                {SetId, Num} ->
                    calc_set_num(T, lists:keyreplace(SetId, 1, SetNum, {SetId, Num+1}));
                false ->
                    calc_set_num(T, [{SetId, 1} | SetNum])
            end;
        true ->
            calc_set_num(T, SetNum)
    end.

do_calc_attr([], Role) -> Role;
do_calc_attr([{_Id, 0, #item{}} | T], Role) ->
    do_calc_attr(T, Role);
do_calc_attr([{_Id, 1, #item{attr = Attr}} | T], Role) ->
    {ok, Role1} = eqm_effect:do_attr(Attr, Role),
    do_calc_attr(T, Role1).

do_change_dress([], Role) -> {ok, Role};
do_change_dress([Id | T], Role) -> 
    case has_the_dress(Id, Role) of
        false ->
            {false, ?L(<<"亲，您暂时没有这件装备哦！请到商城处购买">>)};
        {_, 1, #item{}} ->
            {false, ?L(<<"时装已穿戴">>)};
        Dress = {_, 0, #item{base_id = BaseId}} ->
            case item_data:get(BaseId) of
                {ok, #item_base{condition = Conds}} ->
                    case role_cond:check(Conds, Role) of
                        {false, _} ->
                            {false, ?L(<<"角色20级才可穿戴">>)};
                        _ ->
                            case puton_dress(Dress, Role) of
                                {false, Reason} ->
                                    {false, Reason};
                                {ok, Role1} ->
                                    do_change_dress(T, Role1)
                            end
                    end;
                _ -> {false, ?L(<<"找不到物品">>)}
            end
    end.   

do_calc_looks([], Looks) -> Looks;
do_calc_looks([{_, 0, #item{}} | T], Looks) ->
    do_calc_looks(T, Looks);
do_calc_looks([{_, 1, #item{base_id = BaseId}} | T], Looks) ->
    {ok, #item_base{effect = Effect}} = item_data:get(BaseId),
    case lists:keyfind(?attr_looks_id, 1, Effect) of
        {_, _, Looks_Id} ->
            FashionType = get_fashion_looks_type(BaseId),
            Looks1 = [{FashionType, Looks_Id, 0} | Looks],
            do_calc_looks(T, Looks1);
        false ->
            ?DEBUG("找不到外观数据: 物品BASE ID ~w", [BaseId]),
            do_calc_looks(T, Looks)
    end.

puton_dress({Id, _, Item = #item{base_id = BaseId}}, Role) ->
    Role1 = #role{dress = Dress} = clear_dress_flag(BaseId, Role),
    Dress1 = lists:keyreplace(Id, 1, Dress, {Id, 1, Item}),
    {ok, Role1#role{dress = Dress1}}.

%% 清除某类时装穿戴标志
clear_dress_flag(BaseId, Role = #role{dress = Dress}) ->
    DressType = baseid_to_dresstype(BaseId),
    Dress1 = do_clear(DressType, Dress, []),
    Role#role{dress = Dress1}.

do_clear(_DressType, [], Res) -> Res;
do_clear(DressType, [A = {Id, Flag, Item = #item{base_id = BaseId}} | T], Res) ->
    case DressType =:= baseid_to_dresstype(BaseId) andalso Flag =:= 1 of
        true ->
            Res1 = [{Id, 0, Item} | Res],
            do_clear(DressType, T, Res1);
            %% Res1 ++ T;
        false ->
            Res1 = [A | Res],
            do_clear(DressType, T, Res1)
    end.

pack_send_dress_info(#role{link = #link{conn_pid = ConnPid}, dress = Dress}) ->
    Ret = pack_dress(Dress, []),
    ?DEBUG("******** Ret : ~w", [Ret]),
    sys_conn:pack_send(ConnPid, 10342, {Ret}).

pack_dress([], Ret) -> Ret;
pack_dress([{Id, Flag, #item{base_id = BaseId, bind = Bind, durability = Dur, attr = Attr, special = Spec}} | T], Ret) ->
    Expire = case lists:keyfind(?special_expire_time, 1, Spec) of
        {_, V} -> V;
        false -> -1 end,
    pack_dress(T, [{Flag, BaseId, Id, Bind, Dur, Expire, Attr} | Ret]).

baseid_to_dresstype(BaseId) ->
    BaseId rem 100000 div 100.

get_fashion_looks_type(BaseId) ->
    fashion_to_looks(baseid_to_dresstype(BaseId)).

%% 时装类型转换为外观类型
fashion_to_looks(?dress_clothes)    -> ?LOOKS_TYPE_DRESS;            %% 服饰
fashion_to_looks(?dress_weapon)     -> ?LOOKS_TYPE_WEAPON_DRESS;     %% 武饰
fashion_to_looks(?dress_head)       -> ?LOOKS_TYPE_HEAD;             %% 头饰
fashion_to_looks(?dress_wing)       -> ?LOOKS_TYPE_WING.             %% 翅膀

