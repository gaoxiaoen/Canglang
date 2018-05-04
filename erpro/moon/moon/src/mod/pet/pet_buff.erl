%%----------------------------------------------------
%% 宠物BUFF系统
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(pet_buff).
-export([
        login_reset_pet_buff/1
        ,logoff_reset_pet_buff/1
        ,get_buff_base_id/1
        ,to_client_buff_list/1
        ,add/2
        ,add_buff_check_time/1
        ,check_pet_buff/1
        ,handle_pet_buff/2
        ,login/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("pet.hrl").
-include("link.hrl").

%% 获取指定宠物的BUFF中基础ID BUFF效果外观
get_buff_base_id(#pet{buff = BuffList}) ->
    get_buff_base_id(BuffList);
get_buff_base_id([#pet_buff{effect = Effect} | T]) ->
    case lists:keyfind(buff_baseid, 1, Effect) of 
        {_, BaseId} -> BaseId;
        _ -> get_buff_base_id(T)
    end;
get_buff_base_id(_) -> false.

%% 转换成客户端BUFF列表
to_client_buff_list(#role{pet = #pet_bag{active = undefined}}) -> [];
to_client_buff_list(#role{pet = #pet_bag{active = #pet{buff = BuffList}}}) ->
    [{Id, BaseId, ICon, EndTime} || #pet_buff{id = Id, baseid = BaseId, icon = ICon, endtime = EndTime} <- BuffList].

login(Role, Pet) ->
    NewPet = login_reset_pet_buff(Pet),
    pet_api:reset(NewPet, Role).

%% 角色登录处理
login_reset_pet_buff(Pet = #pet{buff = BuffList}) ->
    NewBuffList = login_reset_pet_buff(BuffList, []),
    handle_pet_buff(not_push, Pet#pet{buff = NewBuffList}).
login_reset_pet_buff([], BuffList) ->
    lists:reverse(BuffList);
login_reset_pet_buff([Buff = #pet_buff{type = 1, duration = Duration} | T], BuffList) -> %% 下线不计时
    Now = util:unixtime(),
    login_reset_pet_buff(T, [Buff#pet_buff{endtime = Now + Duration} | BuffList]);
login_reset_pet_buff([Buff | T], BuffList) when is_record(Buff, pet_buff) ->
    login_reset_pet_buff(T, [Buff | BuffList]);
login_reset_pet_buff([_ | T], BuffList) ->
    login_reset_pet_buff(T, BuffList).

%% 角色退出处理
logoff_reset_pet_buff(Pet) ->
    NewPet = #pet{buff = BuffList} = handle_pet_buff(not_push, Pet),
    NewBuffList = logoff_reset_pet_buff(BuffList, []),
    NewPet#pet{buff = NewBuffList}.
logoff_reset_pet_buff([], BuffList) ->
    lists:reverse(BuffList);
logoff_reset_pet_buff([Buff = #pet_buff{type = 1, duration = Duration, endtime = EndTime} | T], BuffList) when Duration =/= -1 -> %% 下线不计时
    Now = util:unixtime(),
    logoff_reset_pet_buff(T, [Buff#pet_buff{duration = lists:max([0, EndTime - Now])} | BuffList]);
logoff_reset_pet_buff([Buff | T], BuffList) ->
    logoff_reset_pet_buff(T, [Buff | BuffList]).

%% 增加一个BUFF
add(Role, Label) when is_atom(Label) ->
    case pet_data_buff:get(Label) of
        {false, Reason} -> {false, Reason};
        {ok, Buff} ->
            add(Role, Buff)
    end;
add(#role{pet = #pet_bag{active = undefined}}, _Buff) ->
    {false, ?L(<<"当前没有出战宠物，使用失败">>)};
add(Role = #role{pet = PetBag = #pet_bag{active = Pet}}, Buff = #pet_buff{msg = Msg}) ->
    {ok, NPet, NPetBag} = pet:refresh_war_pet(Pet, PetBag),
    case add_to_pet(NPet, Buff) of
        {false, Reason} -> {false, Reason};
        {ok, NP} ->
            NewPet = pet_api:reset(NP, Role),
            NRole = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
            NewRole = pet_api:broadcast_pet(NewPet, NRole),
            role:pack_send(Role#role.pid, 10931, {57, Msg, []}),
            pet_api:push_pet(refresh, [NewPet], NRole),
            pet_api:push_pet(pet_buff, NewPet, NRole),
            {ok, add_buff_check_time(NewRole)}
    end.

%% 增加BUFF定时检查时间
add_buff_check_time(Role) ->
    NRole = case role_timer:del_timer(check_pet_buff_timer, Role) of
        {ok, _, NR} -> NR;
        false -> Role
    end,
    AllPets = case Role#role.pet of
        #pet_bag{active = undefined, pets = Pets} -> Pets;
        #pet_bag{active = ActPet, pets = Pets} -> [ActPet | Pets]
    end,
    AllBuffList = all_pet_buff_list(AllPets, []),
    Now = util:unixtime(),
    case check_del_buff(AllBuffList) of
        {_Flag, NextCheckTime, _BuffList} when NextCheckTime > Now ->
            NextTime = NextCheckTime - Now,
            ?DEBUG("[~s][~p]秒后检查宠物BUFF数据", [Role#role.name, NextTime]),
            role_timer:set_timer(check_pet_buff_timer, NextTime * 1000, {pet_buff, check_pet_buff, []}, 1, NRole);
        _ ->
            NRole
    end.

%% 检查宠物BUFF
check_pet_buff(Role = #role{pet = PetBag = #pet_bag{active = undefined, pets = Pets}}) -> %% 无出战宠
    NewPets = [handle_pet_buff(Role, Pet) || Pet <- Pets],
    NewRole = Role#role{pet = PetBag#pet_bag{pets = NewPets}},
    {ok, add_buff_check_time(NewRole)};
check_pet_buff(Role = #role{pet = PetBag = #pet_bag{active = ActPet, pets = Pets}}) ->
    NewActPet = handle_pet_buff(Role, ActPet),
    NewPets = [handle_pet_buff(Role, Pet) || Pet <- Pets],
    NRole = Role#role{pet = PetBag#pet_bag{active = NewActPet, pets = NewPets}},
    NewRole = pet_api:broadcast_pet(NewActPet, NRole),
    pet_api:push_pet(pet_buff, NewActPet, NRole),
    {ok, add_buff_check_time(NewRole)}.

%% 处理一个宠物的BUFF
handle_pet_buff(_Role, Pet = #pet{buff = []}) ->
    Pet;
handle_pet_buff(Role, Pet = #pet{buff = BuffList}) ->
    case check_del_buff(BuffList) of
        {true, _, NewBuffList} when is_record(Role, role) ->
            NewPet = pet_api:reset(Pet#pet{buff = NewBuffList}, Role),
            pet_api:push_pet(refresh, [NewPet], Role),
            NewPet;
        {true, _, NewBuffList} ->
            pet_api:reset(Pet#pet{buff = NewBuffList}, Role);
        _ ->
            Pet 
    end.

%%-----------------------------------------
%% 内部方法
%%-----------------------------------------

%% 返回所有宠物的BUFF
all_pet_buff_list([], BuffList) -> BuffList;
all_pet_buff_list([#pet{buff = BList} | T], BuffList) ->
    all_pet_buff_list(T, BList ++ BuffList).

%% 给指定宠物增加BUFF
add_to_pet(Pet = #pet{buff = BuffList}, Buff = #pet_buff{label = Label, multi = 0}) -> %% 不允许多个相同BUFF
    case lists:keyfind(Label, #pet_buff.label, BuffList) of
        false ->
            do_add_to_pet(Pet, Buff);
        _ ->
            {false, ?L(<<"相同宠物BUFF只能同时使用一个哦">>)}
    end;
add_to_pet(Pet = #pet{buff = BuffList}, Buff = #pet_buff{label = Label, multi = 2, duration = Duration}) -> %% 时间累加
    case lists:keyfind(Label, #pet_buff.label, BuffList) of
        false ->
            do_add_to_pet(Pet, Buff);
        OldBuff = #pet_buff{endtime = EndTime} ->
            NewBuff = OldBuff#pet_buff{endtime = EndTime + Duration},
            NewBuffList = lists:keyreplace(Label, #pet_buff.label, BuffList, NewBuff),
            {ok, Pet#pet{buff = NewBuffList}}
    end;
add_to_pet(Pet = #pet{buff = BuffList}, Buff = #pet_buff{label = Label, multi = 3}) -> %% 覆盖
    case has_cover(BuffList, pet_data_buff:cover(Label), Buff) of
        false -> 
            do_add_to_pet(Pet, Buff);
        {true, NewBuffList, _DelBuffLabel} ->
            do_add_to_pet(Pet#pet{buff = NewBuffList}, Buff)
    end;
add_to_pet(Pet, Buff) -> %% 根据互斥设置而定
    do_add_to_pet(Pet, Buff).

%% 执行增加操作
do_add_to_pet(Pet = #pet{buff = BuffList}, Buff = #pet_buff{label = Label}) ->
    case has_conflict(BuffList, pet_data_buff:conflict(Label), Buff) of
        false -> {false, ?L(<<"不能替换同类效果">>)};
        true ->
            BuffId = get_buff_next_id(BuffList),
            NewBuff = init_buff(Buff),
            {ok, Pet#pet{buff = [NewBuff#pet_buff{id = BuffId} | BuffList]}}
    end.

%% 初始化BUFF数据
init_buff(Buff = #pet_buff{duration = -1}) -> 
    Buff#pet_buff{endtime = 0, msg = <<>>};
init_buff(Buff = #pet_buff{duration = Duration}) ->
    Now = util:unixtime(),
    Buff#pet_buff{endtime = Now + Duration, msg = <<>>}.

%% @spec has_cover(BuffList, CoverList, CoverBuff) -> {true, NewBuffList, DelBuffLabel} | false
%% @doc  判断Bufflist是否存在CoverList里面的BUff,存在 则替换, 不存在 直接添加
has_cover(_BuffList, [], _CoverBuff) -> false;
has_cover([], _CoverList, _CoverBuff) -> false;
has_cover(BuffList, [Label | T], CoverBuff) ->
    case lists:keyfind(Label, #pet_buff.label, BuffList) of
        false -> 
            has_cover(BuffList, T, CoverBuff);
        _ ->
            {true, lists:keydelete(Label, #pet_buff.label, BuffList), Label}
    end.

%% @spec has_conflict(BuffList, ConflictBuffList, ConflictBuff) -> true | false
%% @doc  判断Bufflist是否存在ConflictBuffList里面的BUff,存在则冲突, 不存在则可添加
has_conflict(_BuffList, [], _ConflictBuff) -> true;
has_conflict([], _ConflictBuffList, _ConflictBuff) -> true;
has_conflict(BuffList, [Label | T], ConflictBuff) ->
    case lists:keyfind(Label, #pet_buff.label, BuffList) of
        false -> 
            has_conflict(BuffList, T, ConflictBuff);
        _ ->
            false
    end.

%% 获取下一个BUFF ID形成唯一值
get_buff_next_id(#pet{buff = BuffList}) ->
    get_buff_next_id(BuffList);
get_buff_next_id(BuffList) ->
    get_buff_next_id(BuffList, 0).
get_buff_next_id([], MaxId) -> MaxId + 1;
get_buff_next_id([#pet_buff{id = Id} | T], MaxId) ->
    case Id > MaxId of
        true -> get_buff_next_id(T, Id);
        false -> get_buff_next_id(T, MaxId)
    end;
get_buff_next_id([_ | T], MaxId) ->
    get_buff_next_id(T, MaxId).

%% 检查是否有过期BUFF需要删除
check_del_buff(BuffList) ->
    check_del_buff(BuffList, [], 0, false).
check_del_buff([], BuffList, NextCheckTime, Flag) -> 
    {Flag, NextCheckTime, lists:reverse(BuffList)};
check_del_buff([Buff = #pet_buff{duration = -1} | T], BuffList, NextCheckTime, Flag) ->
    check_del_buff(T, [Buff | BuffList], NextCheckTime, Flag);
check_del_buff([Buff = #pet_buff{endtime = EndTime} | T], BuffList, NextCheckTime, Flag) ->
    Now = util:unixtime(),
    case Now >= EndTime of
        true -> %% 过期BUFF 删除
            check_del_buff(T, BuffList, NextCheckTime, true);
        _ when NextCheckTime =:= 0 orelse EndTime < NextCheckTime ->
            check_del_buff(T, [Buff | BuffList], EndTime, Flag);
        false -> 
            check_del_buff(T, [Buff | BuffList], NextCheckTime, Flag)
    end;
check_del_buff([_ | T], BuffList, NextCheckTime, Flag) ->
    check_del_buff(T, BuffList, NextCheckTime, Flag).
