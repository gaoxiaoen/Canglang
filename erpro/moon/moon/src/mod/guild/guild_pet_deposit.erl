%----------------------------------------------------
%%  帮会宠物寄养
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_pet_deposit).
-export([pet_deposit/3      %% 宠物寄养
        ,pet_deposited/1    %% 获取宠物寄养信息
        ,pet_undeposited/1  %% 停止宠物寄养
        ,pet_undeposited/2  %% 停止宠物寄养
        ,deposit_speed/2    %% 宠物寄养加速
        ,pet_upgrade/1      %% 宠物升级
        ,login/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("pet.hrl").
%%
-include("guild.hrl").
-include("gain.hrl").
-include("link.hrl").

-define(pet_deposit_cost, 1).                                   %% 1分钟消耗1点帮贡
-define(pet_deposit(T), round(T * 60 * ?pet_deposit_cost)).     %% 寄养 T 小时 消费帮贡
-define(pet_speed_cost(M), pay:price(?MODULE, pet_speed_cost, M)).                     %% 宠物寄养加速消费
-define(pet_deposit_speed(Sec), ((Sec) * 4)).                   %% Time 为 秒，1秒钟4点经验
-define(pet_exp_2_sec(Exp), ((Exp) div 4)).                     %% 经验值 转换 需要耗费 秒 数
-define(pet_deposit_sec_devote(Sec), ((Sec) div 60 * ?pet_deposit_cost)).   %% 归还帮贡
-define(pet_deposit_sec_gold(Sec), pay:price(?MODULE, pet_deposit_sec_gold, Sec)).                        %% 归还晶钻
-define(pet_deposit_timeout_delay, 30).

%% 角色上线检测寄养
login(Role = #role{pet = #pet_bag{deposit = {0, 0, 0}}}) ->
    Role;
login(Role = #role{pet = #pet_bag{deposit = {_, Time, Beg}}}) ->
    Diff = case (Time + Beg) - util:unixtime() of
        Difference when Difference >= 0 -> Difference;
        _ -> 0
    end,
    role_timer:set_timer(guild_pet_deposit,  (Diff + ?pet_deposit_timeout_delay) * 1000, {guild_pet_deposit, pet_undeposited, [system]}, 1 ,Role).

%% @spec pet_deposit(Petid, Time, Role) -> {true, NewRole} | {false, Reason}
%% Petid = Time = integer()
%% Role = #role{}
%% @doc 宠物寄养, Time 是以小时为单位
pet_deposit(_Petid, _Time, #role{guild = #role_guild{gid = 0}}) ->
    {false, ?MSGID(<<"您还没有加入任何帮会，赶紧去申请吧！">>)};
pet_deposit(_Petid, _Time, #role{pet = #pet_bag{deposit = {#pet{}, _, _}}}) ->
    {false, ?MSGID(<<"寄养失败，已有其他宠物在寄养中">>)};
pet_deposit(_Petid, Time, _Role) when Time > 24 orelse Time < 1 ->
    {false, util:fbin(?L(<<"寄养时间">>), [Time])};
pet_deposit(Petid, Time, R = #role{ pet = PetBag = #pet_bag{pets = Pets, active = Active}}) ->
    case lists:keyfind(Petid, #pet.id, Pets) of
        false ->
            case Active of
                #pet{id = Petid} -> {false, ?MSGID(<<"寄养失败，宠物未被召回">>)};
                _ -> {false, ?MSGID(<<"寄养失败，宠物已放生或不存在">>)}
            end;
        Pet ->
            case role_gain:do(#loss{label = guild_devote, val = ?pet_deposit(Time)}, R) of
                {false, _} -> {false, ?MSGID(<<"寄养失败，帮会贡献不足">>)};
                {ok, R1} ->
                    NewPet = Pet#pet{mod = ?pet_deposit},
                    R2 = R1#role{pet = PetBag#pet_bag{pets = lists:keydelete(Petid, #pet.id, Pets), deposit = {NewPet, Time * 3600, util:unixtime()}}},
                    NewRole = role_timer:set_timer(guild_pet_deposit,  (Time * 3600 + ?pet_deposit_timeout_delay) * 1000, {guild_pet_deposit, pet_undeposited, [system]}, 1 ,R2),
                    pet_api:push_pet(attr, NewPet, NewRole),
                    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"开始寄养">>}),                            
                    log:log(log_integral, {guild_devote, <<"寄养">>, [], R, NewRole}),
                    {true, NewRole}
            end
    end.

%% @spec pet_deposited(Role) -> Reply | {Reply, NewRole}
%% Reply = tuple{}
%% Role = NewRole = #role{}
%% @doc 获取寄养宠物信息，若有宠物超时寄养，将自动放出
pet_deposited(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    NewBeg = util:unixtime(),
    case deposit_check(0, NewBeg, Role) of
        {0, NewRole} ->
            NewRole;
        {RemSec, Role1} ->
            Return = ?pet_deposit_sec_devote(RemSec),
            sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"寄养宠物受角色等级限制，已取消寄养，同时归还 ~w 帮会贡献与您">>), [Return]), []}),
            {ok, NewRole} = role_gain:do(#gain{label = guild_devote_role, val = ?pet_deposit_sec_devote(RemSec)}, Role1),
            NewRole
    end.

%% @spec pet_undeposited(Role) -> NewRole
%% Role = NewRole = #role{}
%% @doc 角色主动停止宠物寄养
pet_undeposited(Role) ->
    {ok, Role1} = pet_undeposited(Role, role),
    case role_timer:del_timer(guild_pet_deposit, Role1) of
        {ok, _, NewRole} -> NewRole;
        _ -> Role1
    end.

%% @spec pet_undeposited(Role, Type) -> NewRole
%% Role = NewRole = #role{}
%% Type = role | system
%% @doc 停止宠物寄养
pet_undeposited(Role = #role{link = #link{conn_pid = ConnPid}}, Type) ->
    NowNewBeg = util:unixtime(),
    case deposit_check(0, NowNewBeg, Role) of
        {0, NewRole = #role{pet = #pet_bag{deposit = {0, _, _}}}} ->
            case Type of
                role -> sys_conn:pack_send(ConnPid, 10931, {55, ?MSGID(<<"您寄养的宠物已经召回！">>), []});
                _ -> sys_conn:pack_send(ConnPid, 10931, {55, ?MSGID(<<"您寄养的宠物，寄养时间已经到了!">>), []})
            end,
            {ok, NewRole};
        {0, Role1 = #role{pet = PetBag = #pet_bag{pets = Pets, deposit = {Pet, RemSec, _}}}} ->
            Return = ?pet_deposit_sec_devote(RemSec),
            NewPet = Pet#pet{mod = ?pet_rest},
            Role2 = Role1#role{pet = PetBag#pet_bag{pets = [NewPet | Pets], deposit = {0, 0, 0}}}, 
            {ok, NewRole} = role_gain:do(#gain{label = guild_devote_role, val = Return}, Role2),
            pet_api:push_pet(refresh, [NewPet], NewRole),
            case Type of
                role ->
                    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"取消寄养">>}),
                    log:log(log_integral, {guild_devote, <<"取消寄养">>, [], Role, NewRole}),
                    sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"取消寄养成功，同时归还 ~w 帮会贡献与您">>), [Return]), []});
                _ ->
                    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"寄养超时">>}),
                    sys_conn:pack_send(ConnPid, 10931, {55, ?MSGID(<<"您的宠物，寄养时间已到了">>), []})
            end,
            {ok, NewRole};
        {RemSec, Role1} ->
            Return = ?pet_deposit_sec_devote(RemSec),
            {ok, NewRole} = role_gain:do(#gain{label = guild_devote_role, val = Return}, Role1),
            case Type of
                role -> sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"取消寄养成功，同时归还 ~w 帮会贡献与您">>), [Return]), []});
                _ -> sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"您的寄养宠物受角色等级限制，已取消寄养，同时归还 ~w 帮会贡献与您">>), [Return]), []})
            end,
            {ok, NewRole}
    end.

%% 寄养加速
deposit_speed(_Minute, #role{pet = #pet_bag{deposit = {0, _, _}}}) ->
    {false, ?L(<<"没有宠物在寄养!">>)};
deposit_speed(Minute, Role) ->
    case deposit_speed_1(Minute, Role) of
        {Status, Msg} -> {Status, Msg};
        Role1 = #role{pet = #pet_bag{deposit = {_, Time, _Beg}}} ->
            Role2 = case role_timer:del_timer(guild_pet_deposit, Role1) of
                {ok, _, NR} -> NR;
                _ -> Role1
            end,
            case Time of
                0 -> Role2;
                _ -> role_timer:set_timer(guild_pet_deposit,  (Time + ?pet_deposit_timeout_delay) * 1000, {guild_pet_deposit, pet_undeposited, [system]}, 1 ,Role2)
            end
    end.

deposit_speed_1(Minute, Role = #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{deposit = {_, Time, Beg}}}) ->
    NowNewBeg = util:unixtime(),
    SpeedSec = Minute * 60,
    case Time + Beg - NowNewBeg < (SpeedSec - 60) of
        true ->
            {false, ?L(<<"宠物寄养加速时间不能超过剩余寄养时间!">>)};
        false ->
            Cost = ?pet_speed_cost(Minute),
            case role_gain:do([#loss{label = gold, val = Cost}], Role) of
                {ok, Role1} ->
                    case deposit_check(SpeedSec, NowNewBeg, Role1) of
                        {0, NewRole} ->
                            NewRole;
                        {RemSec, Role2} ->
                            case RemSec - Time of
                                Rem when Rem > 0 ->   %% 加回这个价晶钻
                                    ReturnGold = ?pet_deposit_sec_gold(Rem),
                                    ReturnDevote = ?pet_deposit_sec_devote(Time),
                                    sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"加速成功，宠物受角色等级限制，已取消寄养，同时归还 ~w 晶钻，~w 帮会贡献与您">>), [ReturnGold, ReturnDevote]), []}),
                                    {ok, Role3} = role_gain:do(#gain{label = gold, val = ReturnGold}, Role2),
                                    {ok, NewRole} = role_gain:do(#gain{label = guild_devote_role, val = ReturnDevote}, Role3),
                                    role_api:push_assets(Role, NewRole),
                                    NewRole;
                                Rem ->  %% 晶钻加速用完了，加回贡献
                                    ReturnDevote = ?pet_deposit_sec_devote(-Rem),
                                    sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"加速成功，宠物受角色等级限制，已取消寄养，同时归还 ~w 帮会贡献与您">>), [ReturnDevote]), []}),
                                    {ok, NewRole} = role_gain:do(#gain{label = guild_devote_role, val = ReturnDevote}, Role2),
                                    role_api:push_assets(Role, NewRole),
                                    NewRole
                            end
                    end;
                _ ->
                    {?gold_less, ?L(<<"寄养加速失败，晶钻不足">>)}
            end
    end.

pet_upgrade(Role = #role{lev = Lev, pet = PetBag = #pet_bag{pets = Pets, deposit = {Pet = #pet{lev = Plev, exp = Exp}, Time, Beg}}}) ->
    NewBeg = util:unixtime(),
    Interval = NewBeg - Beg,
    NewPlev = Plev+1,
    case Interval >= Time of
        true -> %% 过时，自动放出
            case pet_update_online(Plev, Exp + ?pet_deposit_speed(Time), Lev) of
                true ->
                    NewPet = pet_api:reset(Pet#pet{lev = NewPlev, exp = 0, mod = ?pet_rest}, Role),
                    NewRole = Role#role{pet = PetBag#pet_bag{pets = [NewPet| Pets], deposit = {0, 0, 0}}},
                    pet_api:push_pet(refresh, [NewPet], NewRole),
                    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"寄养宠物，升级通知 超时放出">>}),                            
                    {true, NewRole};
                false ->
                    {false, <<>>}
            end;
        false -> %% 还在寄养中
            case pet_update_online(Plev, Exp + ?pet_deposit_speed(Interval), Lev) of
                true ->
                    NewPet = pet_api:reset(Pet#pet{lev = NewPlev, exp = 0}, Role),
                    NewRole = Role#role{pet = PetBag#pet_bag{deposit = {NewPet, Time - Interval, NewBeg}}},
                    pet_api:push_pet(refresh, [NewPet], NewRole),
                    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"寄养宠物，升级">>}),                            
                    {true, NewRole};
                false ->
                    {false, <<>>}
            end
    end;
pet_upgrade(_Role) ->
    {false, <<>>}.

%%--------------------------------------------------------------------------------------------
%% 寄养宠物相关
%%--------------------------------------------------------------------------------------------
%% 宠物升级与角色等级限制
pet_update(Plev, Exp, Rlev) when Plev =:= Rlev ->
    UpgradeExp = pet_data_exp:get(Plev),
    case Exp - UpgradeExp of
        Rem when Rem >= 0 ->    %% 等级限制，会自动放出
            {lev_limit, Rem, Plev, UpgradeExp};
        _ ->
            {ok, 0, Plev, Exp}
    end;
pet_update(Plev, Exp, Rlev) when Plev < Rlev ->
    UpgradeExp = pet_data_exp:get(Plev),
    case Exp - UpgradeExp of
        Rem when Rem >= 0 ->
            pet_update(Plev + 1, Rem, Rlev);
        _Rem ->
            {ok, 0, Plev, Exp}
    end.

pet_update_online(Plev, Exp, Rlev) when Plev < Rlev ->
    NextExp = pet_data_exp:get(Plev),
    case Exp - NextExp of
        Rem when Rem >= -240 ->
            true;
        _ ->
            false
    end;
pet_update_online(_Plev, _Exp, _Rlev) ->
    false.

%% 寄养中宠物检测
deposit_check(_, _Now, Role = #role{pet = #pet_bag{deposit = {0, _Time, _Beg}}}) ->
    {0, Role};
deposit_check(SpeedSec, Now, Role = #role{pet = PetBag = #pet_bag{pets = Pets, deposit = {OldPet = #pet{}, Time, Beg}}}) ->
    Interval = Now - Beg,
    case Time - Interval of     %% 目前已经寄养 Interval 时间，角色请求寄养时间 Time
        Rem when Rem =< 0 ->    %% 寄养时间超时  宠物将自动放出, 这种情况下不会有资产返回给玩家
            {_, Pet1} = deposit_upgrade(Time, Role),
            NewPet = Pet1#pet{mod = ?pet_rest}, 
            pet_api:push_pet(refresh, [NewPet], Role),
            NewRole = Role#role{pet = PetBag#pet_bag{pets = [NewPet| Pets], deposit = {0, 0, 0}}},
            log:log(log_pet_update, {NewRole, OldPet, NewPet, <<"寄养超时，自动放出">>}),                            
            {SpeedSec, NewRole};
        Rem ->
            case deposit_upgrade(Interval + SpeedSec, Role) of
                {0, Pet1} ->    %% 继续寄养
                    case Rem - SpeedSec of
                        NewRem when NewRem > 0 ->
                            pet_api:push_pet(refresh, [Pet1], Role),
                            NewRole = Role#role{pet = PetBag#pet_bag{pets = Pets, deposit = {Pet1, Rem - SpeedSec, Now}}},
                            {0, NewRole};
                        _ ->        %% 加速时间超过了 寄养剩余时间
                            NewPet = Pet1#pet{mod = ?pet_rest}, 
                            pet_api:push_pet(refresh, [NewPet], Role),
                            NewRole = Role#role{pet = PetBag#pet_bag{pets = [NewPet| Pets], deposit = {0, 0, 0}}},
                            log:log(log_pet_update, {NewRole, OldPet, NewPet, <<"寄养宠物加速后，放出">>}),                            
                            {0, NewRole}
                    end;
                {RemSec, Pet1} ->   %% 等级限制，放出
                    NewPet = Pet1#pet{mod = ?pet_rest}, 
                    pet_api:push_pet(refresh, [NewPet], Role),
                    NewRole = Role#role{pet = PetBag#pet_bag{pets = [NewPet| Pets], deposit = {0, 0, 0}}},
                    log:log(log_pet_update, {NewRole, OldPet, NewPet, <<"寄养宠物等级受人物等级限制，自动放出">>}),                            
                    {RemSec + Rem, NewRole}
            end
    end.

%% 寄养宠物升级
deposit_upgrade(Sec, Role = #role{lev = Lev, pet = #pet_bag{deposit = {Pet = #pet{lev = Plev, exp = Exp}, _Time, _Beg}, cloud = #pet_cloud{lev = CloudLev}}}) ->
    case pet_update(Plev, Exp + ?pet_deposit_speed(Sec), Lev) of
            {lev_limit, Rem, NewPlev, NewExp} ->    %% 等级限制，自动放出
                NewPet = pet_api:reset(Pet#pet{lev = NewPlev, exp = NewExp, cloud_lev = CloudLev}, Role),
                {?pet_exp_2_sec(Rem), NewPet};
            {ok, 0, NewPlev, NewExp} ->
                NewPet = pet_api:reset(Pet#pet{lev = NewPlev, exp = NewExp, cloud_lev = CloudLev}, Role),
                {0, NewPet}
    end.


