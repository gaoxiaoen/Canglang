%%----------------------------------------------------
%% 宠物系统 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(pet).
-export([
        do_gm/3
        ,gm/3
        ,gm_get_pet_info/1
        ,append_to_special/1
        ,login/1
        %,loss_happy_value/3
        ,catch_pet/2
        ,catch_pet/3
        ,calc/1
        ,effect_sit/1
        ,list/1
        ,get_pet_info/1
        ,del/2
        ,war/2
        ,rest/2
        ,refresh_exp/1
        ,upgrade/2
        ,rename/2
        ,egg_to_pet/2
        ,egg_to_pet2/2
        ,egg_to_item/2
        ,buy_rename/1
        ,expand_limit_num/1
        ,join/2
        ,join_preview/3
        ,feed/3
        ,ascend/2
        ,ascend_skill/2
        ,combat_ascend_skill/1
        ,loss_skill/2
        ,refresh_egg/2
        ,refresh_war_pet/2
        ,asc_potential/3
        ,set_sys_attr_per/2
        ,pet_to_item/2
        ,get_wash/1
        ,get_double_talent/2
        ,open_double_talent/2
        ,change_double_talent/3
        ,del_double_talent_cd/2
        ,wash/2
        ,select_wash/2
        ,everyday_limit_log/2
        ,open_free_egg/1
        ,skill_exp_update/2
        ,exp_update/2
        ,append_attr/2
        ,create/2
        ,grow/2
        ,grow/3
        ,recover_from_log/1
        %,check_pet/1
        ,reset_baseid/3
        ,evolve/2
        ,send_bless/3
        ,do_sync_send_bless/3
        ,asc_potential_max/2
        ,use_change_skin_item/2
        ,ext_attr/3
        ,ext_attr/5
        ,gm_make_pet/3
        ,explore/2
        ,explore_batch/2
        ,buy_item/2
        ,puton_pet_eqm/2
        ,create_default_pet/2
        ,gm_set_skill/3,
        update_asc_free_times/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("pet.hrl").
-include("gain.hrl").
-include("item.hrl").
-include("storage.hrl").
-include("link.hrl").
-include("attr.hrl").
-include("ratio.hrl").
-include("looks.hrl").
-include("pos.hrl").
-include("condition.hrl").
%%
-include("dungeon.hrl").
-include("assets.hrl").


%% 宠物装备穿戴
%% @spec puton_pet_eqm(Item, Pet) -> NPet | {false, Reason}
%% Item :: #item() 
%% Pet :: #pet{} 
%% @doc 宠物装备佩戴之后返回新的宠物 
puton_pet_eqm(Item = #item{attr = Attr, id = Item_Id, pos = Pos, base_id = BaseId, special = Spe}, Role = #role{pet = #pet_bag{active = Pet = #pet{lev = Lev, eqm_num = Num, eqm = Eqm}}})->
    ?DEBUG("----Eqm---~w~n",[Eqm]),

    Haved = [E||E<-Eqm, E#item.base_id div 100  == BaseId div 100],
    ?DEBUG("----Haved---:~w~n",[Haved]),
    Data = 
		case length(Haved) == 0 of 
			true ->
				case Num < 6 of 
					true ->
                        case check_pet_lev(BaseId, Lev) of 
                            ok ->
                                {Num + 1, Eqm, Pet};
                            {false, M} ->
                                {false, M}
                        end;
					false -> {false, ?MSGID(<<"装备已满！">>)}
                end;
			false ->
                case check_pet_lev(BaseId, Lev) of 
                    ok ->
                        [#item{special = Special}] = Haved,
        				Fun = fun(Val) -> -Val end,
                        NSpe = lists:keymap(Fun, 2, Special),

        				NPet = pet_api:add_eqm_attr_value(NSpe, Pet),
        				{Num, Eqm -- Haved, NPet};
                    {false, _Msg} ->
                        {false, _Msg}
                end
		end,
    case Data of 
        {false, Reason} ->
            {false, Reason};
        {Num2, Eqm2, NPet1} ->
            ValueList = [{K, V}||{K, _, V} <- Attr],
            Spe1 = lists:keydelete(?special_eqm_advance, 1, Spe),
            NItem = Item#item{special = lists:umerge(ValueList, Spe1)},

            L1 = [#loss{label = item_id, val = [{Item_Id, 1}], msg = ?MSGID(<<"找不到物品">>)}],
            role:send_buff_begin(),
            case role_gain:do(L1, Role) of
                {false, #loss{msg = Msg}} -> 
                    role:send_buff_clean(),
                    {false, Msg};
                {ok, NRole} -> 
                    case check_old_eqm(Haved, Pos, NRole) of 
                        {ok, NRole1} ->
                            NP = NPet1#pet{eqm_num = Num2, eqm = Eqm2 ++ [NItem#item{bind = 1}]},
                            NRole2 = #role{pet = #pet_bag{active = NP2}} = pet_api:reset(NP, NRole1),

                            pet_api:push_pet2(refresh, NRole2),

                            role:send_buff_flush(),
                            rank_celebrity:dragon_suit(NRole2),
                            
                            Fight_Power = 
                                case lists:keyfind(?special_eqm_point, 1, Spe) of 
                                    {_, Power} -> Power;
                                    false ->
                                        pet_api:calc_eqm_fight_capacity(Item)
                                end,
                            NRole3 = refresh_lower_eqm(BaseId, Fight_Power, NRole2),

                            {ok, NP2#pet.eqm, NRole3};
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {false, Reason}
                    end
            end
    end.

refresh_lower_eqm(BaseId, Power, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Items}}) ->
    L1 = [I||I = #item{base_id = Base_Id}<- Items, BaseId div 100 =:= Base_Id div 100],
    case erlang:length(L1) > 0 of 
        false -> Role;
        true ->
            LItems = get_lower_items(L1, Power, []),
            HItems = get_higher_items(L1, Power, []),

            ?DEBUG("----LItems--~p~n~n", [LItems]),
            ?DEBUG("----HItems--~p~n~n", [HItems]),

            Ids = [Id||#item{id = Id}<-LItems],
            Ids1 = [Id1||#item{id = Id1}<-HItems],

            NItems = delete_items(Items, Ids),
            NItems1 = delete_items(NItems, Ids1),
            
            NItems2 = LItems ++ NItems1,
            NItems3 = HItems ++ NItems2,

            Refresh1 = [{1, I}||I<-LItems],
            Refresh2 = [{1, I}||I<-HItems],

            ?DEBUG("----Refresh1--~p~n~n", [Refresh1]),
            ?DEBUG("----Refresh2--~p~n~n", [Refresh2]),

            storage_api:refresh_mulit(ConnPid, Refresh1 ++ Refresh2),

            Role#role{bag = Bag#bag{items = NItems3}}
    end.

delete_items(Items, []) ->Items;
delete_items(Items, [Id|T]) ->
    NItems = lists:keydelete(Id, #item.id, Items),
    delete_items(NItems, T).

get_lower_items([], _Power, Return) -> Return;
get_lower_items([Item = #item{special = Spe}|T], Power, Return) ->
    case lists:keyfind(?special_eqm_point, 1, Spe) of 
        {_, Point} ->
            case Power >= Point of 
                true ->
                    NSpe = lists:keydelete(?special_eqm_advance, 1, Spe),
                    NItem = Item#item{special = NSpe},
                    get_lower_items(T, Power, [NItem | Return]);
                false -> 
                    get_lower_items(T, Power, Return)
            end;
        _ ->
            get_lower_items(T, Power, Return)
    end.

get_higher_items([], _Power, Return) -> Return;
get_higher_items([Item = #item{special = Spe}|T], Power, Return) ->
    case lists:keyfind(?special_eqm_point, 1, Spe) of 
        {_, Point} ->
            case Point > Power of 
                true ->
                    NSpe = 
                        case lists:keyfind(?special_eqm_advance, 1, Spe) of 
                            false -> [{?special_eqm_advance, 1}] ++ Spe;
                            _ -> Spe
                        end,
                    NItem = Item#item{special = NSpe},
                    get_higher_items(T, Power, [NItem | Return]);
                false -> 
                    get_higher_items(T, Power, Return)
            end;
        _ ->
            get_higher_items(T, Power, Return)
    end.

check_pet_lev(BaseId, Lev) ->    
    case item_data:get(BaseId) of 
        {ok, #item_base{condition = Cond}} ->
            case lists:keyfind(lev, #condition.label, Cond) of 
                #condition{target_value = NeedLev} ->
                    if Lev >= NeedLev ->
                            ok;
                        true ->
                            {false, ?MSGID(<<"等级不足！">>)}
                    end;
                _ -> ok
            end;
        _ -> {false, ?MSGID(<<"装备不存在！">>)}
    end.

check_old_eqm(Haved, Pos, Role) ->
    case Haved of 
        [] -> {ok, Role};
        [Item] ->
            case storage:add(bag, Role, [Item#item{pos = Pos}]) of 
                false -> {false, ?MSGID(<<"背包已满">>)}; 
                {ok, NewBag} ->
                    {ok, Role#role{bag = NewBag}} 
            end; 
            % case make_item(Base_Id, Pos, Role) of 
            %     {ok, NRole, _} ->
                    % {ok, NRole};
            %     {_, Reason} ->
            %         {false, Reason}
            % end
        _ -> {ok, Role}
    end.

% make_item(BaseId, Pos, Role) ->
%     case item:make(BaseId, 1, 1) of 
%         {ok, [Item | T]} -> 
%             case Item#item.type =:= ?item_task of 
%                 false -> %% 非任务物品直接产生在背包  
%                     case storage:add(bag, Role, [Item#item{id = Pos} | T]) of 
%                         false -> {add_error, ?L(<<"背包已满">>)}; 
%                         {ok, NewBag} ->
%                             {ok, Role#role{bag = NewBag}, [Item | T]} 
%                     end; 
%                 true -> %% 任务物品产生在任务包 
%                     case storage:add(task_bag, Role, [Item | T]) of
%                         false -> {add_error, ?L(<<"任务背包已满">>)};
%                         {ok, NewTaskBag} -> {ok, Role#role{task_bag = NewTaskBag}, [Item | T]} 
%                     end
%             end; 
%         false -> {make_error, ?L(<<"物品数据不合法">>)} 
%     end. 

%% 设置宠物技能达到某个阶某个等级
%% St ::number() 技能阶
%% L ::number() 技能等级
gm_set_skill(Role = #role{link = #link{conn_pid = ConnPid}, pet = PetBag = #pet_bag{active = Pet}}, St, L) ->
    Step = 
        if 
            St =< 0 ->
                1;
            St >= 3 ->
                3;
            true ->
                St
        end,
    Lev = 
        if 
            L =< 0 ->
                1;
            L >= 10 ->
                10;
            true ->
                L
        end,
    Exp = 
    case Lev of 
        1 -> 0;
        _ -> if
                Step == 1 ->
                    round(math:pow(2, Lev)/2);
                Step == 2 ->
                    round(math:pow(2, 1+Lev)/2);
                true ->
                    round(math:pow(2, 2+Lev)/2)
            end
    end,
    InitList = [100000, 110000, 120000, 130000, 140000, 150000, 160000, 170000, 180000, 190000],
    NSkillID = [E + Step * 100 + Lev||E <- InitList],
    NSkill = [{Id, Exp, Id div 10000 rem 10 + 1, []}||Id<-NSkillID],
    ?DEBUG("-------NSkill---~w~n",[NSkill]),
    sys_conn:pack_send(ConnPid, 12613, {NSkill}),
    Role#role{pet = PetBag#pet_bag{active = Pet#pet{skill = NSkill, skill_num = 10, skill_slot = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}}}.
    
%% @spec recover_from_log(LogId) -> ok | {logId, Error}
%% LogId -> integer() | list() 日志唯一ID，可以以一个list方式传送多个ID过来
%% Error -> wrong_param:参数错误,not_exists:没有日志记录，fetch_failure:数据库读取失败, has_recovered:已经回复过,miss_data:日志宠物数据不全
%% @doc 从宠物变化日志里恢复一个宠物数据（以邮件发一个宠物蛋的方式发给玩家）
%% @author Jange
recover_from_log(LogIds) when is_list(LogIds) ->
    L = [recover_from_log(LogId) || LogId <- LogIds],
    %% 全部成功就只返回OK，否则返回出错部分
    case [I || I <- L, I =/= ok] of
        [] -> ok;
        EL -> EL
    end;
recover_from_log(LogId) when is_integer(LogId) ->
    case db:get_row(log_db:to_sql(get_log_pet), [LogId]) of
        {error, undefined} -> 
            {LogId, not_exists};
        {error, _Err} ->
            {LogId, fetch_failure};
        {ok, [_Rid, _SrvId, _Name, _PetName, _Msg, <<>>, 0]} ->
            {LogId, miss_data};
        %% 只能恢复一次
        %% <<"select rid, srv_id, rname, pet_id, p_name, status, p_lev, p_exp, msg, pet, recovered from log_pet_update where id= ~p">>;
        {ok, [Rid, SrvId, Name, PetName, Msg, NewPetInfo, OldPetInfo, 0]} ->
            %% 现在就让它可以恢复到各种状态吧
            %% Reasons = [?L(<<"宠物炼魂">>), ?L(<<"放生宠物">>), ?L(<<"宠物融合">>)],
            {PetUse, PetNameUse} = case util:bitstring_to_term(OldPetInfo) of
                {_, [_, Pet | _]} when element(1, Pet) =:= pet ->
                    %% 宠物融合的话只恢复第二宠物（副宠）就可以了
                    {Pet, Pet#pet.name};
                {_, Pet} when element(1, Pet) =:= pet ->
                    {Pet, PetName};
                _ ->
                    case util:bitstring_to_term(NewPetInfo) of
                        {_, [_, Pet | _]} when element(1, Pet) =:= pet -> %% 宠物融合恢复第二个宠
                            {Pet, Pet#pet.name};
                        {_, [Pet | _]} when element(1, Pet) =:= pet ->
                            {Pet, Pet#pet.name};
                        {_, Pet} when element(1, Pet) =:= pet ->
                            {Pet, Pet#pet.name};
                        _ ->
                            ?ERR("宠物恢复不正常，落入非法区"),
                            false
                    end
            end,
            %% 生成个绑定宠物蛋
            case pet_parse:do_pet(PetUse) of
                {ok, EggPet} ->
                    {_, [Item | _]} = item:make(?pet_egg_green, 1, 1),
                    Items = [Item#item{special = [{pet, [EggPet#pet{eqm = [], eqm_num = 0}]}]}],
                    Title = ?L(<<"宠物恢复通知">>),
                    Content = util:fbin(?L(<<"~s您好，您因~s而消失的宠物[~s]现在通过附件以宠物蛋方式已恢复给您，请注意查收后打开宠物蛋来领取!">>), [Name, Msg, PetNameUse]),
                    Info = {Title, Content, [], Items},
                    case mail:send_system({Rid, SrvId}, Info) of
                        ok -> 
                            db:execute(log_db:to_sql(recovered_log_pet), [LogId]),
                            ok;
                        MailErr -> 
                            {LogId, MailErr}
                    end;
                _ ->
                    ?ERR("宠物数据转换失败:[~w]", [PetUse]),
                    {LogId, pet_parse_err}
            end;
        _ -> 
            {LogId, has_recovered}
    end;
recover_from_log(LogId) ->
    {LogId, wrong_param}.

%% 宠物GM命令
gm_make_pet(Role, Pet, Type) ->
    case pet_data_gm:get(Pet, Type) of
        {false, Reason} -> {false, Reason};
        NPet = #pet{skill = Skills, eqm = Eqm} ->  
            NewSkills = [{SkillId, SkillExp, []} || {SkillId, SkillExp} <- Skills],
            NewEqm = pet_magic:gm_make_pet_eqm(Eqm, []),
            NewPet = pet_api:reset(NPet#pet{skill = NewSkills, eqm = NewEqm}, Role),
            {ok, NewPet}
    end.

%% GM命令处理
do_gm(#role{pet = #pet_bag{active = undefined}}, _Mod, _Type) ->
    {false, ?L(<<"无出战宠物">>)};
do_gm(Role = #role{pet = PetBag = #pet_bag{active = Pet}}, refresh, Type) ->
    case gm_make_pet(Role, Pet, Type) of
        {false, Reason} -> {false, Reason};
        {ok, NewPet} ->
            NRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
            rank:listener(pet, NRole),
            pet_api:push_pet(refresh, [NewPet], NRole),
            {ok, pet_api:broadcast_pet(NewPet, NRole)}
    end;
do_gm(Role = #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = Pet = #pet{exp = Exp}}}, lev, Lev) ->
    NLev= 
        if  
            Lev > 100 ->
                100;
            Lev < 1 ->
                1;
            true ->
                Lev
        end,
    {NExp, Need} = 
        case Lev =:= 100 of 
            true ->
                {9900, 0};
            false ->
                {Exp, pet_data_exp:get(NLev) - Exp}
        end,
    NPet = Pet#pet{lev = NLev, exp = NExp},
    {NPet1, Step}  = pet_api:update_next_max2(NPet),
    sys_conn:pack_send(ConnPid, 12618, {NLev, NExp, Need, Step}),
    NRole = pet_api:reset(NPet1, Role),
    pet_api:push_pet2(refresh, NRole),
    NRole1 = medal:listener(dragon_level, NRole),
    {ok, NRole1};

do_gm(Role = #role{pet = PetBag = #pet_bag{active = Pet}}, grow,  Grow) ->
    NewPet = pet_api:reset(Pet#pet{grow_val = Grow}, Role),
    NRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
    rank:listener(pet, NRole),
    grow_notice(Role, NewPet),
    pet_api:push_pet(refresh, [NewPet], NRole),
    ?INFO("设置成功[~p]", [Grow]),
    {ok, pet_api:broadcast_pet(NewPet, NRole)};
do_gm(_Role, color, Type) when Type < 0 orelse Type > 4 ->
    {false, ?L(<<"无效设置">>)};
do_gm(Role = #role{pet = PetBag = #pet_bag{active = Pet}}, color, Type) ->
    NewPet = Pet#pet{type = Type},
    NRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
    rank:listener(pet, NRole),
    pet_api:push_pet(refresh, [NewPet], NRole),
    {ok, pet_api:broadcast_pet(NewPet, NRole)};

do_gm(Role = #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = Pet = #pet{attr = Attr}}}, potential, Val) ->
    NPet = Pet#pet{attr = Attr#pet_attr{
            xl_val = Val, xl_max = Val
            ,tz_val = Val, tz_max = Val
            ,js_val = Val, js_max = Val
            ,lq_val = Val, lq_max = Val
        }},
    {NP, _} = pet_api:update_next_max(NPet),
    Role1 = #role{pet = PetBag = #pet_bag{active = NP2}} = pet_api:reset(NP, Role),

    {_Slot_Num, NP3} = get_alloc_slots(NP2), %%根据新的潜力值重新计算技能槽
    NR = Role1#role{pet = PetBag#pet_bag{active = NP3}},
    ?DEBUG("-----NPet---~p~n", [NP3]),
    rank:listener(pet, NR), %%更新排行榜数据
    sys_conn:pack_send(ConnPid, 12600, get_pet_info(NR)),
    NR1 = medal:listener(dragon_bone, NR),
    {ok, pet_api:broadcast_pet(NP3, NR1)};
 

do_gm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{attr = Attr}}}, max_potential, Val) ->
    NewPet = Pet#pet{attr = Attr#pet_attr{xl_max = Val, tz_max = Val, js_max = Val, lq_max = Val}},
    NRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
    pet_api:push_pet(refresh, [NewPet], NRole),
    {ok, NRole};
do_gm(_Role, happy, Val) when Val < 0 orelse Val > ?pet_max_happy ->
    {false, ?L(<<"无效设置">>)};
do_gm(Role = #role{pet = PetBag = #pet_bag{active = Pet}}, happy, Val) ->
    NewPet = Pet#pet{happy_val = Val},
    NRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
    pet_api:push_pet(attr, NewPet, NRole),
    {ok, NRole};
do_gm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{}}}, skill_talent, {SkillId, Val}) ->
    NewPet = pet_api:reset(Pet#pet{append_attr = [{1, [{?attr_pet_skill_id, Val * 1000 + 1, SkillId}]}]}, Role),
    NRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
    pet_api:push_pet(refresh, [NewPet], NRole),
    {ok, NRole};
do_gm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{attr_sys = AttrSys}}}, attr_per, {V1, V2, V3, V4}) ->
    NewPet = pet_api:reset(Pet#pet{attr_sys = AttrSys#pet_attr_sys{xl_per = V1, tz_per = V2, js_per = V3, lq_per = V4}}, Role),
    NRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
    pet_api:push_pet(refresh, [NewPet], NRole),
    {ok, NRole};
do_gm(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{skill = Skills}}}, skill_exp, Val) ->
    NPet = Pet#pet{skill = [{SkillId, Val, Args} || {SkillId, _, Args} <- Skills]},
    NewPet = pet_api:reset(NPet, Role),
    NRole = Role#role{pet = PetBag#pet_bag{active = NewPet}},
    rank:listener(pet, NRole),
    pet_api:push_pet(refresh, [NewPet], NRole),
    {ok, NRole};
do_gm(Role = #role{pet = PetBag, link = #link{conn_pid = ConnPid}}, clear_log, _Val) ->
    sys_conn:pack_send(ConnPid, 12623, {everyday_limit_num(?pet_log_type_free_egg)}),
    {ok, Role#role{pet = PetBag#pet_bag{log = []}}};
do_gm(Role, add, Pet) when is_record(Pet, pet) ->
    pet_api:add(Pet, Role);
do_gm(_Role, _Mod, _Arg) ->
    {false, ?L(<<"参数不正确">>)}.

%% GM控制台增加角色宠物数据
gm(Role, Mod, Arg) when is_record(Role, role) ->
    case catch do_gm(Role, Mod, Arg) of
        {ok, NRole} -> {ok, NRole};
        _ -> {ok}
    end;
gm({id, Id}, Mod, Arg) ->
    case role_api:lookup(by_id, {Id, <<"4399_mhfx_1">>}, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
            role:apply(async, Pid, {fun gm/3, [Mod, Arg]}),
            ok;
        _ -> %% 角色不在线 通过更新数据库发放称号
            ?INFO("角色不在线"),
            ok
    end;
gm({Rid, SrvId}, Mod, Arg) ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
            role:apply(async, Pid, {fun gm/3, [Mod, Arg]}),
            ok;
        _ -> %% 角色不在线 通过更新数据库发放称号
            ?INFO("角色不在线"),
            ok
    end;
gm(Name, Mod, Arg) ->
   case role_api:lookup(by_name, Name, #role.pid) of
        {ok, _N, Pid} -> %% 角色在线 通过异步方式发放称号
            role:apply(async, Pid, {fun gm/3, [Mod, Arg]}),
            ok;
        _ -> %% 角色不在线 通过更新数据库发放称号
            ok
    end.

%% 获取仙宠的基本信息
%% 成长值、潜力平均值
gm_get_pet_info(#role{pet = PetBag}) ->
    gm_get_pet_info(PetBag);
gm_get_pet_info(#pet_bag{active = undefined}) -> {0, 0};
gm_get_pet_info(#pet_bag{active = #pet{grow_val = GrowVal, attr = #pet_attr{avg_val = AvgVal}}}) ->
    {GrowVal, AvgVal};
gm_get_pet_info(_) -> {0, 0}.

send_bless(Role, OtherName, BlessType) ->
    {StartTime, EndTime} = get_bless_time(BlessType),
    Now = util:unixtime(),
    case Now >= StartTime andalso (Now < EndTime orelse EndTime =:= 0) of
        false -> {false, ?L(<<"活动已过，不能使用">>)};
        true -> do_send_bless(Role, OtherName, BlessType)
    end.

%% 祝福时间
get_bless_time(1) -> {util:datetime_to_seconds({{2012, 6, 9}, {8, 0, 1}}), util:datetime_to_seconds({{2012, 6, 9}, {8, 0, 1}})};
get_bless_time(2) -> {util:datetime_to_seconds({{2012, 6, 9}, {8, 0, 1}}), util:datetime_to_seconds({{2012, 6, 9}, {8, 0, 1}})};
get_bless_time(3) -> {util:datetime_to_seconds({{2013, 5, 15}, {0, 0, 1}}), util:datetime_to_seconds({{2013, 5, 17}, {23, 59, 59}})};
%% TODO
get_bless_time(4) -> {util:datetime_to_seconds({{2013, 2, 22}, {0, 0, 1}}), util:datetime_to_seconds({{2013, 2, 26}, {23, 59, 59}})};
get_bless_time(5) -> {util:datetime_to_seconds({{2013, 3, 29}, {0, 0, 1}}), util:datetime_to_seconds({{2013, 4, 2}, {23, 59, 59}})};
get_bless_time(_) -> {0, 0}.

%% 送祝福
do_send_bless(Role, OtherName, BlessType) ->
    ItemBaseId = case BlessType of
        1 -> 33072;
        2 -> 33082;
        3 -> 33202;
        4 -> 33209; %% 祝福卡ID TODO
        5 -> 33244; %% 小丑仙宠卡
        _ -> 33202
    end,
    GL = [
        #gain{label = exp, val = 10000}
        ,#loss{label = item, val = [ItemBaseId, 1, 1]}
    ],
    case everyday_limit_log(?pet_log_type_send_bless, Role) of
        {{Type, Time, Num}, Logs} when Num > 0 ->
            case role_gain:do(GL, Role) of
                {ok, NRole = #role{pet = PetBag}} ->
                    case role_api:lookup(by_name, OtherName) of
                        {ok, _, OtherRole} ->
                            case role:apply(sync, OtherRole#role.pid, {fun do_sync_send_bless/3, [BlessType, {Role#role.id, Role#role.name}]}) of
                                {false, Reason} -> {false, Reason};
                                ok ->
                                    Msg = notice_inform:gain_loss(GL, ?L(<<"送祝福">>)),
                                    notice:inform(Role#role.pid, Msg),
                                    role:pack_send(Role#role.pid, 10931, {55, ?L(<<"整蛊成功，您获得10000经验！">>), []}),
                                    NewLogs = lists:keyreplace(Type, 1, Logs, {Type, Time, Num - 1}),
                                    {ok, Items} = item:make(ItemBaseId, 0, 1),
                                    ItemMsg = notice:item_to_msg(Items),
                                    RoleMsg = notice:role_to_msg(Role),
                                    OtherRoleMsg = notice:role_to_msg(OtherRole),
                                    case BlessType of
                                        1 -> notice:send(62, util:fbin("~s对~s使用了~s，将~s的宠物变成了一个可爱的【{str, 粽宝宝, #FFA500}】", [RoleMsg, OtherRoleMsg, ItemMsg, OtherRoleMsg]));
                                        2 -> notice:send(62, util:fbin("~s对~s使用了~s，奥运神将附身，将~s的仙宠变身为奥运吉祥物，令~s的战力瞬间暴涨", [RoleMsg, OtherRoleMsg, ItemMsg, OtherRoleMsg, OtherRoleMsg]));
                                        3 -> notice:send(62, util:fbin("~s对~s使用了~s，将~s的宠物变成了一个可爱的【{str, 瑞兽, #FFA500}】", [RoleMsg, OtherRoleMsg, ItemMsg, OtherRoleMsg]));
                                        4 -> notice:send(62, util:fbin("~s对~s使用了~s，将~s的宠物变成了一个可爱的【{str, 萌萌汤圆宝宝, #FFA500}】", [RoleMsg, OtherRoleMsg, ItemMsg, OtherRoleMsg]));
                                        5 -> notice:send(62, util:fbin("愚人节大捣蛋，~s对~s使用了~s，将~s的宠物变成了一个搞笑的【{str, 小丑宝宝, #FFA500}】", [RoleMsg, OtherRoleMsg, ItemMsg, OtherRoleMsg]));
                                        %% TODO
                                        _ -> ok
                                    end,
                                    {ok, NRole#role{pet = PetBag#pet_bag{log = NewLogs}}}
                            end;
                        _ ->
                            {false, ?L(<<"对方不在线">>)}
                    end;
                _ ->
                    {false, ?L(<<"您的背包里没有相关宠物祝福卡">>)}
            end;
        _ ->
            {false, ?L(<<"每天只能对20个好友发起祝福哦">>)}
    end.

do_sync_send_bless(#role{pet = #pet_bag{active = undefined}}, _BlessType, _FromRoleInfo) ->
    {ok, {false, ?L(<<"对方当前没有出战宠物哦">>)}};
do_sync_send_bless(Role = #role{sex = Sex}, BlessType, {{FromRid, FromSrvId}, FromName}) ->
    case everyday_limit_log(?pet_log_type_bless, Role) of
        {{Type, Time, Num}, Logs} when Num > 0 ->
            PetBuffLabel = case BlessType of
                1 -> petchange;
                2 when Sex =:= 1 -> olympicchange;
                2 -> olympicchange;
                3 -> change_3;
                4 -> change_4;
                5 -> change_5;
                %% TODO
                _ -> olympicchange
            end,
            case pet_buff:add(Role, PetBuffLabel) of
                {false, Reason} -> {ok, {false, Reason}};
                {ok, NRole = #role{pet = PetBag}} ->
                    %% Role0 = role_api:push_attr(NRole),
                    GL = [#gain{label = exp, val = 10000}],
                    {ok, Role1} = case role_gain:do(GL, NRole) of
                        {ok, R0} -> {ok, R0};
                        _ -> {ok, NRole}
                    end,
                    Msg = notice_inform:gain_loss(GL, ?L(<<"好友祝福">>)),
                    notice:inform(Role#role.pid, Msg),
                    role:pack_send(Role#role.pid, 12681, {FromRid, FromSrvId, FromName, BlessType}),
                    NewLogs = lists:keyreplace(Type, 1, Logs, {Type, Time, Num - 1}),
                    NewRole = Role1#role{pet = PetBag#pet_bag{log = NewLogs}},
                    {ok, ok, NewRole}
            end;
        _ ->
            {ok, {false, ?L(<<"对方今天已被祝福过10次">>)}}
    end.

append_to_special(Role = #role{pet = #pet_bag{active = ActPet}}) 
when is_record(ActPet, pet) ->
    Role#role{
        special = [{?special_pet, ActPet#pet.base_id, ActPet#pet.name}|Role#role.special]
    }.

%% 登录初始化宠物背包 by bwang
%% @spec login(Role) -> NewRole
%% Role | NewRole = #role{}
login(Role = #role{pet = #pet_bag{active = undefined}}) ->
    ?DEBUG("--Login with no pet--\n"),
    Role;

login(Role = #role{link = #link{conn_pid = ConnPid}, pet = _Pet_Bag = #pet_bag{active = ActPet = #pet{asc_times = Asc_times, last_asc_time = Last_asc_time}}}) 
when is_record(ActPet, pet) ->

    ?DEBUG("--Login with  pet--\n"),
    NewRole = append_to_special(Role),

    Now = util:unixtime(),
    % ?DEBUG("")
    ?DEBUG("-----Asc_times---~p~n", [Asc_times]),
    NAsc_times = 
        case {util:is_same_day2(Last_asc_time, Now), Asc_times} of
            {false, _} -> ?pet_asc_free;
            {true, _} -> Asc_times
        end,
    ?DEBUG("----NAsc_times----~p~n", [NAsc_times]),
    
    Avg = pet_attr:calc_avg_potential(ActPet), 
    case Avg =:= ?pet_max_potential of 
        true -> 
            NewRole;
        false ->
            case NAsc_times of 
                0 -> NewRole;
                _ ->
                    sys_conn:pack_send(ConnPid, 11170, {[{?pet_asc_potential, NAsc_times}]})
            end,
            role_timer:set_timer(update_free_times, util:unixtime({nexttime, 86401}) * 1000, {pet, update_asc_free_times, []}, 1, NewRole)
            % role_timer:set_timer(update_free_times, 10 * 1000, {pet, update_asc_free_times, []}, 1, NewRole)
    end.

update_asc_free_times(Role = #role{link = #link{conn_pid = ConnPid}, pet = #pet_bag{active = Pet}}) ->
    Avg = pet_attr:calc_avg_potential(Pet), 
    case Avg =:= ?pet_max_potential of 
        true -> {ok, Role};
        false ->
            sys_conn:pack_send(ConnPid, 11170, {[{?pet_asc_potential, ?pet_asc_free}]}),
            Time0 = util:unixtime(today),
            Tomorrow0 = (Time0 + 86405) - util:unixtime(),
            {ok, role_timer:set_timer(update_free_times, Tomorrow0*1000, {pet, update_asc_free_times, []}, day_check, Role)}
    end.

      

create_default_pet({pet, [{base_id, BaseId}, {name, Name}, {potential, Xl_Val, Tz_Val, Js_Val, Lq_Val}, {per, XlPer, TzPer, JsPer, LqPer}]},
                    Role = #role{pet = #pet_bag{active = undefined}}
                ) ->
    Step       = 1,
    NewActPet  = #pet{id =0, base_id = BaseId, name = Name, lev = 1, mod = 1, exp = 0, eqm_num =0, eqm= [], 
                    attr = #pet_attr{xl_val = Xl_Val, tz_val = Tz_Val, js_val = Js_Val, lq_val = Lq_Val, step = Step},
                    attr_sys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}, 
                    skill_slot = [1, 2], lucky_value = 0, bind = 0, skin_grade = lists:nth(Step, pet_asc_ratio:get_all_cost())},

    NRole   = #role{pet = PetBag = #pet_bag{active = NPet}} = pet_api:reset(NewActPet, Role), %%计算宠物战力
    NPet2   = init_potential_max(NPet),
    NewRole = NRole#role{pet = PetBag#pet_bag{active = NPet2, pets = [NPet2], rename_num = 3, last_time = util:unixtime()}},
    NewRole.
   
%% 定时计算宠物数据
% add_pet_timer(Role) ->
%     NRole = case role_timer:del_timer(check_pet, Role) of
%         {ok, _, NR} -> NR;
%         false -> Role
%     end,
%     role_timer:set_timer(check_pet, 600 * 1000, {pet, check_pet, []}, 0, NRole).

%% 定时检查结算宠物经验快乐值信息
% check_pet(Role = #role{pet = PetBag = #pet_bag{active = Pet}}) when is_record(Pet, pet) ->
%     case refresh_war_pet(Pet, PetBag) of
%         {ok, NPet = #pet{happy_val = 0}, NPetBag = #pet_bag{pets = Pets}} ->
%             NewPet = NPet#pet{mod = ?pet_rest},
%             NewPetBag = NPetBag#pet_bag{active = undefined, pets = [NewPet | Pets]},
%             pet_api:push_pet(attr, NewPet, Role),
%             {ok, Role#role{pet = NewPetBag}};
%         {ok, NPet, NPetBag} ->
%             {ok, Role#role{pet = NPetBag#pet_bag{active = NPet}}}
%     end;
% check_pet(_) ->
%     {ok}.

%% @doc 退出前重新计算宠物经验
%% @spec refresh_exp(Role) -> PetBag
%% Role = #role{}
%% PetBag = #pet_bag{}
refresh_exp(#role{pet = PetBag = #pet_bag{active = Pet}}) when is_record(Pet, pet) ->
    case refresh_war_pet(Pet, PetBag) of
        {ok, NPet = #pet{happy_val = 0}, NPetBag = #pet_bag{pets = Pets}} ->
            NewPets0 = [NPet#pet{mod = ?pet_rest} | Pets],
            NewPets = [pet_buff:logoff_reset_pet_buff(Pet0) || Pet0 <- NewPets0],
            NPetBag#pet_bag{active = undefined, pets = NewPets};
        {ok, NPet, NPetBag = #pet_bag{pets = Pets}} ->
            NewPets = [pet_buff:logoff_reset_pet_buff(Pet0) || Pet0 <- Pets],
            NPetBag#pet_bag{active = pet_buff:logoff_reset_pet_buff(NPet), pets = NewPets}
    end;
refresh_exp(#role{pet = PetBag = #pet_bag{pets = Pets}}) ->
    NewPets = [pet_buff:logoff_reset_pet_buff(Pet0) || Pet0 <- Pets],
    PetBag#pet_bag{pets = NewPets};
refresh_exp(#role{pet = PetBag}) ->
    PetBag.

%% @doc扣除宠物快乐值
%% @spec loss_happy_value(Role, PetId, Val) -> NewRole;
%% Role = NewRole = #role{}
%% PetId = integer() 宠物快乐值
% loss_happy_value(Role, [], _Val) -> Role;
% loss_happy_value(Role, [PetId | T], Val) ->
%     NewRole = loss_happy_value(Role, PetId, Val),
%     loss_happy_value(NewRole, T, Val);
% loss_happy_value(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = PetId}, pets = Pets}}, PetId, Val) -> %% 宠物处于出战状态
%     {ok, NPet = #pet{happy_val = HV}, NPetBag} = refresh_war_pet(Pet, PetBag),
%     case HV > Val of
%         true ->
%             NewPet = NPet#pet{happy_val = HV - Val},
%             pet_api:push_pet(attr, NewPet, Role),
%             Role#role{pet = NPetBag#pet_bag{active = NewPet}};
%         false -> %% 扣除后宠物快乐值为0,变为休息状态
%             NewPet = NPet#pet{happy_val = 0, mod = ?pet_rest},
%             NRole = Role#role{pet = NPetBag#pet_bag{active = undefined, pets = [NewPet | Pets]}},
%             NewRole = pet_api:broadcast_pet(NewPet, NRole),
%             pet_api:push_pet(attr, NewPet, NewRole),
%             NewRole
%     end;
% loss_happy_value(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}, PetId, Val) -> %% 非出战状态宠物
%     case lists:keyfind(PetId, #pet.id, Pets) of
%         false -> Role;
%         Pet = #pet{happy_val = HV} ->
%             NewPet = case HV > Val of
%                 true -> Pet#pet{happy_val = HV - Val};
%                 false -> Pet#pet{happy_val = 0}
%             end,
%             NewPets = lists:keyreplace(PetId, #pet.id, Pets, NewPet),
%             NewRole = Role#role{pet = PetBag#pet_bag{pets = NewPets}},
%             pet_api:push_pet(attr, NewPet, NewRole),
%             NewRole
%     end.

%% @doc捕捉一个仙宠
%% @spec catch_pet(Role, NpcId) -> {false, Reason} | {ok, NewRole}
%% Role = NewRole = #role{}
%% NpcId = integer()
catch_pet(Role, NpcId) ->
    case pet_data:get_from_npc(NpcId) of
        {false, _Reason} -> {false, ?L(<<"该怪物不可捕捉">>)};
        {ok,  #pet_base{name = Name, id = BaseId, refresh = Refresh, skills = Skills}} ->
            [Pet] = pet_api:rand_pet_list(Refresh, 1),
            NewPet = case [{SkillId, Exp, []} || {SkillId, Exp} <- Skills] of
                NewSkills when length(NewSkills) > 0 -> Pet#pet{name = Name, base_id = BaseId, skill = NewSkills};
                _ -> Pet#pet{name = Name, base_id = BaseId}
            end,
            Bind = case NpcId =:= 124008 orelse NpcId =:= 124016 of %% 35副本小熊猫捉到绑定或者是新手宠
                true -> 1; 
                false -> 0
            end,
            NPet = pet_api:reset(NewPet#pet{bind = Bind}, Role),
            case pet_api:add(NPet, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NRole = #role{pet = PetBag = #pet_bag{catch_pet = Num}}} ->
                    log:log(log_pet_update, {Role, NPet, NPet, <<"捕捉宠物">>}),
                    {ok, NRole#role{pet = PetBag#pet_bag{catch_pet = Num + 1}}}
            end
    end.

%% 为捕宠达人需要只产生0品质的宠物
catch_pet(Role, NpcId, Refresh) ->
    case pet_data:get_from_npc(NpcId) of
        {false, _Reason} -> {false, ?L(<<"该怪物不可捕捉">>)};
        {ok,  #pet_base{name = Name, id = BaseId, refresh = _Refresh, skills = Skills}} ->
            [Pet] = pet_api:rand_pet_list(Refresh, 1),
            NewPet = case [{SkillId, Exp, []} || {SkillId, Exp} <- Skills] of
                NewSkills when length(NewSkills) > 0 -> Pet#pet{name = Name, base_id = BaseId, skill = NewSkills};
                _ -> Pet#pet{name = Name, base_id = BaseId}
            end,
            Bind = case NpcId =:= 124008 orelse NpcId =:= 124016 of %% 35副本小熊猫捉到绑定或者是新手宠
                true -> 1; 
                false -> 0
            end,
            NPet = pet_api:reset(NewPet#pet{bind = Bind}, Role),
            case pet_api:add(NPet, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NRole = #role{pet = PetBag = #pet_bag{catch_pet = Num}}} ->
                    log:log(log_pet_update, {Role, NPet, NPet, <<"捕捉宠物">>}),
                    {ok, NRole#role{pet = PetBag#pet_bag{catch_pet = Num + 1}}}
            end
    end.

%% @doc角色属性重新计算
%% @spec calc(Role) -> NewRole
%% Role | NewRole = #role{}
calc(Role = #role{pet = #pet_bag{active = undefined}}) -> Role;
calc(Role = #role{pet = PetBag}) ->
    pet_api:push_pet(other, PetBag, Role),
    Role.

%% 打坐加成
%% @spec effect_sit(Role) -> {AddSitHp, AddSitMp}
%% Role = #role{}
%% AddSitHp = integer()  回血加成
%% AddSitMp = integer()  回法加成
effect_sit(#role{pet = #pet_bag{active = undefined}}) -> {0, 0};
effect_sit(#role{pet = #pet_bag{active = #pet{skill = Skills}}}) ->
    SkillList = [pet_data_skill:get(SkillId) || {SkillId, _exp, _Args} <- Skills],
    AddSitHp = case [Skill || {ok, Skill} <- SkillList, Skill#pet_skill.mutex =:= 115000] of
        [#pet_skill{args = [Hp]}] -> Hp;
        _ -> 0
    end,
    AddSitMp = case [Skill || {ok, Skill} <- SkillList, Skill#pet_skill.mutex =:= 116000] of
        [#pet_skill{args = [Mp]}] -> Mp;
        _ -> 0
    end,
    {AddSitHp, AddSitMp}.

%% 返回宠物列表信息
list(Role = #role{pet = #pet_bag{rename_num = Num, exp_time = ExpTime, pet_limit_num = PLN}}) ->
    Pets = pet_api:list_pets(Role),
    {ExpTime, Num, PLN, pet_api:list_to_client(Pets, [])}.


%% by bwang返回指定角色的宠物信息，仅有一只宠物 
%% 返回宠物信息
get_pet_info(#role{pet = #pet_bag{active = #pet{name = Name, type = Type, base_id = _BaseId, 
    lev = Lev, exp = Exp, eqm_num = EqmNum, 
    attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq, xl_val = XlVal, tz_val = TzVal, js_val = JsVal, step = Step,
    lq_val = LqVal, dmg = Dmg, critrate = Cri, hp_max = HpMax, mp_max = MpMax, defence = Def,
    tenacity = Ten, hitrate = Hit, evasion = Eva, xl_max = XlMax, tz_max = TzMax, js_max = JsMax, lq_max = LqMax}, 
    attr_sys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}, 
    skill = Skills, skill_num = SkillNum, fight_capacity = Power}, rename_num = Rename_Num}}) ->
    %%todo
    {Rename_Num, Name, Type,_BaseId, Lev,Exp, pet_data_exp:get(Lev),
    Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal,Step, XlPer, TzPer, JsPer, LqPer, SkillNum, Skills, Dmg,
    Cri, HpMax, MpMax, Def, Ten, Hit, Eva, Power, EqmNum, XlMax, TzMax, JsMax, LqMax}.
   


%% 放生一个宠物
del(Id, #role{pet = #pet_bag{active = #pet{id = Id}}}) ->
    {false, ?L(<<"宠物出战状态不能放生">>)};
del(Id, Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) ->
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        #pet{eqm = Eqm} when length(Eqm) > 0 ->
            {false, ?L(<<"装备魔晶的仙宠不能放生">>)};
        Pet ->
            log:log(log_pet_update, {Role, Pet, Pet, <<"放生宠物">>}),
            log:log(log_pet_del, {<<"放生宠物">>, Role, Pet}),
            NewPets = lists:keydelete(Id, #pet.id, Pets),
            pet_api:push_pet(del, [Id], Role),
            NRole = Role#role{pet = PetBag#pet_bag{pets = NewPets}},
            rank:listener(pet, NRole),
            {ok, NRole}
    end.

%% 宠物出战
war(Id, #role{pet = #pet_bag{active = #pet{id = Id}}}) ->
    {false, ?L(<<"宠物已处于出战状态">>)};
war(Id, Role = #role{pet = PetBag = #pet_bag{pets = Pets, active = WarPet = #pet{}}, link = #link{conn_pid = ConnPid}}) -> %% 当前有一个出战宠，潜换
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        #pet{happy_val = 0} ->
            {false, ?L(<<"宠物快乐值为0，不能出战，请先喂养">>)};
        RestPet = #pet{skin_id = SkinId, skin_grade = Grade} ->
            %% TODO 排行榜下线
            NewWarPet = RestPet#pet{mod = ?pet_war},
            {ok, NewRestPet, NPetBag}= refresh_war_pet(WarPet#pet{mod = ?pet_rest}, PetBag),
            NewPets = lists:keydelete(Id, #pet.id, Pets),
            NewPetBag = NPetBag#pet_bag{pets = [NewRestPet | NewPets], active = NewWarPet},
            pet_ex:push_skins(NewPetBag, SkinId, Grade, ConnPid),
            NRole = Role#role{pet = NewPetBag}, 
            NRole1 = role_listener:special_event(NRole, {1011, finish}),
            NRole2 = role_listener:special_event(NRole1, {20006, NewWarPet#pet.lev}),
            NRole3 = role_listener:special_event(NRole2, {20002, NewWarPet#pet.skill}), %%宠物技能数量改变            
            NRole4 = role_listener:special_event(NRole3, {20020, NewWarPet#pet.fight_capacity}), %% 仙宠战斗力变化   N:当前仙宠战斗力
            NRole5 = role_listener:special_event(NRole4, {20021, NewWarPet#pet.attr#pet_attr.avg_val}), %% 仙宠平均潜力变化 N:当前仙宠平均潜力            
            NewRole = role_listener:special_event(NRole5, {20023, NewWarPet#pet.grow_val}), %% 仙宠成长变化 N:当前仙宠成长            
            pet_api:push_pet(attr, NewRestPet, NewRole),
            rank:listener(pet, NewRole),
            pet_buff:check_pet_buff(NewRole)
    end;
war(Id, Role = #role{pet = PetBag = #pet_bag{pets = Pets}, link = #link{conn_pid = ConnPid}}) ->
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        #pet{happy_val = 0} ->
            {false, ?L(<<"宠物快乐值为0，不能出战，请先喂养">>)};
        Pet = #pet{skin_id = SkinId, skin_grade = Grade} ->
            NewPet = Pet#pet{mod = ?pet_war},
            NewPets = lists:keydelete(Id, #pet.id, Pets),
            NewPetBag = PetBag#pet_bag{pets = NewPets, active = NewPet, last_time = util:unixtime()},
            pet_ex:push_skins(NewPetBag, SkinId, Grade, ConnPid),
            NRole = Role#role{pet = NewPetBag},
            NRole1 = role_listener:special_event(NRole, {1011, finish}),
            NRole2 = role_listener:special_event(NRole1, {20006, NewPet#pet.lev}),
            NRole3 = role_listener:special_event(NRole2, {20002, NewPet#pet.skill}), %%宠物技能数量改变 
            NRole4 = role_listener:special_event(NRole3, {20020, NewPet#pet.fight_capacity}), %% 仙宠战斗力变化   N:当前仙宠战斗力
            NRole5 = role_listener:special_event(NRole4, {20021, NewPet#pet.attr#pet_attr.avg_val}), %% 仙宠平均潜力变化 N:当前仙宠平均潜力 
            NewRole = role_listener:special_event(NRole5, {20023, NewPet#pet.grow_val}), %% 仙宠成长变化 N:当前仙宠成长            
            rank:listener(pet, NewRole),
            pet_buff:check_pet_buff(NewRole)
    end.

%% 宠物休息
rest(Id, Role = #role{pet = PetBag = #pet_bag{pets = Pets, active = Pet = #pet{id = Id}}}) ->
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    NewPet = NPet#pet{mod = ?pet_rest},
    NewPetBag = NPetBag#pet_bag{pets = [NewPet | Pets], active = undefined},
    NRole = pet_api:broadcast_pet(NewPet, Role#role{pet = NewPetBag}),
    pet_api:push_pet(attr, NewPet, NRole),
    pet_api:push_pet(pet_buff, NewPet, NRole),
    %% TODO 排行榜下线
    {ok, NRole};
rest(_Id, _Role) ->
    {false, ?L(<<"宠物不在出战状态">>)}.

%% 宠物升级
upgrade(Id, Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = Id}}}) -> %% 出战宠物
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    case pet_api:upgrage(NPet, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewPet} -> 
            NRole = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
            pet_api:push_pet(refresh, [NewPet], NRole),
            rank:listener(pet, NRole),
            pet_ex:talk(pet_lev, NewPet, NRole),
            NRole1 = role_listener:special_event(NRole, {20006, NewPet#pet.lev}),
            NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
            log:log(log_pet_update, {NewRole, Pet, NewPet, <<"出战宠物升级">>}),
            {ok, NewRole}
    end;
upgrade(_Id, _Role) -> %% 非出战宠物
    {false, ?L(<<"宠物不在出战状态">>)}.

%% 重命名宠物 by bwang 宠物无出战与非出战状态
rename(Name, Role = #role{pet = Pet_Bag = #pet_bag{rename_num = ReNum, active = Pet = #pet{base_id = BaseId}}, special = Special}) -> %% 出战状态
    case ReNum > 0 of
        true ->
            NewPet = Pet#pet{name = Name},
            ?DEBUG("---Special---~p~n", [Special]),
            NSpecial = 
                case lists:keyfind(?special_pet, 1, Special) of 
                    false ->
                        [{?special_pet, BaseId, Name}] ++ Special;
                    {_, _B, _N} ->
                        N = lists:keydelete(?special_pet, 1, Special),
                        N ++ [{?special_pet, BaseId, Name}]
                end, 
                ?DEBUG("---NSpecial---~p~n", [NSpecial]),
            NRole = pet_api:broadcast_pet(NewPet, Role#role{special = NSpecial, pet = Pet_Bag#pet_bag{rename_num = ReNum - 1, active = NewPet}}),
            {ok, NRole};
        false ->
            {false, ?MSGID(<<"小伙伴免费更名次数为0">>)}
    end.


%% 破蛋而出
egg_to_pet({ItemId, Id}, Role = #role{link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Items}}) ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, Item = #item{pos = Pos, special = [{pet, Pets}]}} when is_list(Pets) ->
            case lists:keyfind(Id, #pet.id, Pets) of
                false -> {false, ?L(<<"生成宠物失败">>)};
                Pet ->
                    case storage:del_pos(Bag, [{Pos, 1}]) of
                        {false, Reason} -> {false, Reason};
                        {ok, NewBag} ->
                            case pet_api:add(Pet, Role) of
                                {false, Reason} -> {false, Reason};
                                {ok, NRole} ->
                                    storage_api:del_item_info(ConnPid,[{?storage_bag, Item}]),
                                    NewRole = role_listener:acc_event(NRole#role{bag = NewBag}, {112, 1}),
                                    rank:listener(pet, NewRole),
                                    log:log(log_pet_update, {Role, Pet, Pet, <<"破蛋而出宠物">>}),
                                    {ok, NewRole}
                            end
                    end
            end;
        _ -> {false, ?L(<<"查找不到宠物蛋，无法生成宠物数据">>)}
    end.

egg_to_pet2({PetBaseId, Name}, Role = #role{bag = #bag{items = Items}}) ->
    case storage:find(Items, #item.base_id, 621401) of
        {ok, _, _Items, _ , _} -> %{ok, Num, ItemList, BindList, UbindList};
            case pet_config:get_config(PetBaseId) of 
                {ok, Attr} ->
                    role:send_buff_begin(),
                    case role_gain:do([#loss{label = item, val = [621401, 0, 1]}], Role) of 
                        {ok, NRole} ->
                            NR  = #role{pet = PetBag = #pet_bag{active = Pet}} = create_default_pet(Attr, NRole),
                            role:send_buff_flush(),
                            NR1 = NR#role{pet = PetBag#pet_bag{active = NPet = Pet#pet{name = Name}}},
                            {ok, pet_api:broadcast_pet(NPet, NR1#role{special = [{?special_pet, PetBaseId, NPet#pet.name}|NR#role.special]})};
                        {false, #loss{msg = _Rea}} ->
                             role:send_buff_clean(),
                            {false ,?MSGID(<<"没有龙蛋">>)};
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {false, Reason}
                    end;
                {false, Reason} -> {false, Reason}
            end;
        {false, Rea} ->
            {false, Rea}
    end.

init_potential_max(Pet = #pet{attr = Attr}) ->
    Steps = pet_asc_ratio:get_all_step(),
    Val   = lists:nth(2, Steps), %%初始化为下一阶的值
    Pet#pet{attr = Attr#pet_attr{xl_max = Val, tz_max = Val, js_max = Val, lq_max = Val}}.

% ,xl_max = 0       %% 攻潜力上限
% ,tz_max = 0       %% 体潜力上限
% ,js_max = 0       %% 防潜力上限
% ,lq_max = 0       %% 巧潜力上限

%% 宠物蛋练魂
egg_to_item({ItemId, Id}, Role = #role{pid = Pid, link = #link{conn_pid = ConnPid}, bag = Bag = #bag{items = Items}}) ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, Item = #item{pos = Pos, special = [{pet, Pets}]}} when is_list(Pets) ->
            case lists:keyfind(Id, #pet.id, Pets) of
                false -> {false, ?L(<<"生成宠物失败">>)};
                Pet ->
                    case do_pet_to_item(Pet) of
                        {false, Reason} -> {false, Reason};
                        {ok, [NItem]} ->
                            ItemMsg = notice:item3_to_inform(NItem),
                            Msg = util:fbin(?L(<<"练魂成功\n获得 ~s">>), [ItemMsg]),
                            notice:inform(Pid, Msg),
                            NewItem = NItem#item{id = ItemId, pos = Pos},
                            NewItems = lists:keyreplace(ItemId, #item.id, Items, NewItem),
                            storage_api:del_item_info(ConnPid,[{?storage_bag, Item}]),
                            storage_api:add_item_info(ConnPid, [{?storage_bag, NewItem}]),
                            NewRole = role_listener:acc_event(Role#role{bag = Bag#bag{items = NewItems}}, {112, 1}),
                            log:log(log_pet_update, {Role, #pet{}, #pet{}, <<"破蛋成魂">>}),
                            put(item_del, [{?storage_bag, [Item]}]),
                            {ok, NewRole}
                    end
            end;
        _ -> {false, ?L(<<"查找不到宠物蛋，无法生成宠物数据">>)}
    end.

%% 购买更名次数
buy_rename(Role = #role{pet = PetBag = #pet_bag{rename_num = Num}}) ->
    role:send_buff_begin(),
    case role_gain:do([#loss{label = gold, val = 20, msg = ?MSGID(<<"晶钻不足">>)}], Role) of
       {false, #loss{msg = Msg}} -> 
            role:send_buff_clean(),
            {false, Msg};
       {false, Msg} -> 
            role:send_buff_clean(),
            {false, Msg};
       {ok, NRole} ->
            role:send_buff_flush(),
            {ok, NRole#role{pet = PetBag#pet_bag{rename_num = Num + 3}}}
    end.

%% @spec expand_limit_num(Role) -> {false, Reason} | {ok, NewRole}
%% @doc 扩展宠物栏
expand_limit_num(#role{pet = #pet_bag{pet_limit_num = PLN}}) when PLN < ?pet_default_num ->
    {false, ?L(<<"宠物栏数据异常">>)};
expand_limit_num(Role = #role{pet = PetBag = #pet_bag{pet_limit_num = PLN}}) ->
    GL = case PLN of
        8 -> [#loss{label = coin_all, val = 300000}];
        9 -> [#loss{label = coin_all, val = 1000000}];
        _ -> 
            Gold = pay:price(?MODULE, expand_limit_num, PLN),
            [#loss{label = gold, val = Gold}]
    end,
    case role_gain:do(GL, Role) of
        {false, #loss{label = gold}} -> {gold, <<>>};
        {false, #loss{label = coin_all}} -> {coin, <<>>};
        {ok, NRole} ->
            {ok, NRole#role{pet = PetBag#pet_bag{pet_limit_num = PLN+1}}}
    end.

%% 宠物继承合并
join({MainId, SecondId, SelectBaseId}, Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) ->
    case join_preview(1, {MainId, SecondId, SelectBaseId}, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewMainPet} ->
            NPets = lists:keydelete(SecondId, #pet.id, Pets),
            NewPets = lists:keyreplace(MainId, #pet.id, NPets, NewMainPet),
            pet_api:push_pet(del, [SecondId], Role),
            pet_api:push_pet(refresh, [NewMainPet], Role),
            NRole = Role#role{pet = PetBag#pet_bag{pets = NewPets}},
            rank:listener(pet, NRole),
            campaign_listener:handle(pet_skill_lev, Role, NewMainPet),
            {ok, NRole}
    end.

%% 宠物合并预览
join_preview(_Type, {Id, Id, _}, _Role) -> %% 同一个宠物
    {false, ?L(<<"非法合并操作">>)};
join_preview(_Type, {MainId, SecondId, _}, #role{pet = #pet_bag{active = #pet{id = Id}}}) when Id =:= MainId orelse Id =:= SecondId ->
    {false, ?L(<<"出战状态宠物不能进行继承操作">>)};
join_preview(Type, {MainId, SecondId, SelectBaseId}, Role = #role{pet = #pet_bag{pets = Pets}}) ->
    case lists:keyfind(MainId, #pet.id, Pets) of
        false -> {false, ?L(<<"请放入主宠">>)};
        MainPet = #pet{lev = Lev1, base_id = BaseId1, happy_val = HV1, exp = Exp1, attr_sys = AttrSys1, grow_val = GV1, skill = MainSkill, attr = Attr = #pet_attr{xl_val = XlVal1, tz_val = TzVal1, js_val = JsVal1, lq_val = LqVal1, xl_max = XlMax1, tz_max = TzMax1, js_max = JsMax1, lq_max = LqMax1}, evolve = Evo1, append_attr = AppendAttr1, ext_attr = ExtAttrL1, double_talent = Talent1, ext_attr_limit = ExtAttrLimit1, ascended = Ascended1, ascend_num = AscendNum1} -> 
            case lists:keyfind(SecondId, #pet.id, Pets) of
                false -> {false, ?L(<<"请放入副宠">>)};
                #pet{eqm = Eqm} when length(Eqm) > 0 -> 
                    {false, ?L(<<"副宠附带装备，不能融合">>)};
                SecondPet = #pet{lev = Lev2, base_id = BaseId2, happy_val = HV2, exp = Exp2, attr_sys = AttrSys2, grow_val = GV2, skill = SecondSkill, attr = #pet_attr{xl_val = XlVal2, tz_val = TzVal2, js_val = JsVal2, lq_val = LqVal2, xl_max = XlMax2, tz_max = TzMax2, js_max = JsMax2, lq_max = LqMax2}, evolve = Evo2, append_attr = AppendAttr2, ext_attr = ExtAttrL2, double_talent = Talent2, ext_attr_limit = ExtAttrLimit2, ascended = Ascended2, ascend_num = AscendNum2} -> 
                    {MaxLev, Exp, AttrSys, HV, Talent, NewExtAttrL, NewExtLimit} = case Lev1 >= Lev2 of
                        true -> {Lev1, Exp1, AttrSys1, HV1, Talent1, ExtAttrL1, ExtAttrLimit1};
                        false -> {Lev2, Exp2, AttrSys2, HV2, Talent2, ExtAttrL2, ExtAttrLimit2}
                    end,
                    BaseId = case SelectBaseId =:= 1 of
                        true -> BaseId2;
                        _ -> BaseId1
                    end,
                    NewAppendAttr = case AppendAttr1 of
                        [] -> AppendAttr2;
                        _ -> AppendAttr1
                    end,
                    NewAscendNum = case AscendNum1 >= AscendNum2 of
                        true -> AscendNum1;
                        _ -> AscendNum2
                    end,
                    NewAscended = case Ascended2 > Ascended1 of
                        true -> Ascended2;
                        _ -> Ascended1
                    end,
                    NewMainPet = MainPet#pet{
                        bind = 1
                        ,lev = MaxLev
                        ,base_id = BaseId
                        ,exp = Exp
                        ,happy_val = HV
                        ,attr_sys = AttrSys
                        ,append_attr = NewAppendAttr
                        ,ext_attr = NewExtAttrL
                        ,ext_attr_limit = NewExtLimit
                        ,double_talent = Talent
                        ,grow_val = lists:max([GV1, GV2])
                        ,evolve = lists:max([Evo1, Evo2])
                        ,ascended = NewAscended
                        ,ascend_num = NewAscendNum
                        ,attr = Attr#pet_attr{
                            xl_val = lists:max([XlVal1, XlVal2])
                            ,tz_val = lists:max([TzVal1, TzVal2])
                            ,js_val = lists:max([JsVal1, JsVal2])
                            ,lq_val = lists:max([LqVal1, LqVal2])
                            ,xl_max = lists:max([XlMax1, XlMax2])
                            ,tz_max = lists:max([TzMax1, TzMax2])
                            ,js_max = lists:max([JsMax1, JsMax2])
                            ,lq_max = lists:max([LqMax1, LqMax2])
                        }
                    },
                    NMainPet = #pet{skill_num = Num} = pet_api:reset(NewMainPet, Role),
                    Skill = pet_api:skill_join(Type, MainSkill, Num, SecondSkill),
                    NMPet = NMainPet#pet{skill = Skill},
                    NewMPet = pet_api:reset(NMPet, Role),
                    case Type of
                        1 -> log:log(log_pet_update, {Role, [MainPet, SecondPet], NewMPet, <<"宠物融合">>});
                        _ -> ok
                    end,
                    {ok, NewMPet}
            end
    end.

%% 宠物喂养
feed(by_id, Id, Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = Id}}}) -> %% 出战宠物
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    case pet_api:feed(NPet, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NewPet, NRole} ->
            pet_api:push_pet(attr, NewPet, NRole),
            NRole1 = NRole#role{pet = NPetBag#pet_bag{active = NewPet}},
            NewRole0 = role_listener:acc_event(NRole1, {113, 1}), %%宠物喂养
            NewRole = role_listener:special_event(NewRole0, {1040, finish}), %% 喂养宠物            
            {ok, NewRole}
    end;
feed(by_id, Id, Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) -> %% 非出战宠物
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        Pet -> 
            case pet_api:feed(Pet, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NewPet, NRole} ->
                    NewPets = lists:keyreplace(Id, #pet.id, Pets, NewPet),
                    pet_api:push_pet(attr, NewPet, NRole),
                    NRole1 = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    NewRole0 = role_listener:acc_event(NRole1, {113, 1}), %%宠物喂养
                    NewRole = role_listener:special_event(NewRole0, {1040, finish}), %% 喂养宠物            
                    {ok, NewRole}
            end
    end;
feed(by_val, _Value, #role{pet = #pet_bag{active = undefined}}) ->
    {false, ?L(<<"无指定喂养宠物">>)};
feed(by_val, Value, Role = #role{pet = PetBag = #pet_bag{active = Pet}}) ->
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    case pet_api:feed(NPet, Value) of
        {false, Reason} -> {false, Reason};
        {ok, NewPet} ->
            pet_api:push_pet(attr, NewPet, Role),
            NRole1 = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
            NewRole0 = role_listener:acc_event(NRole1, {113, 1}), %%宠物喂养
            NewRole = role_listener:special_event(NewRole0, {1040, finish}), %% 喂养宠物            
            {ok, NewRole}
    end.

%% 宠物技能遗忘 by bwang
loss_skill(SkillId, Role=#role{pet = PetBag = #pet_bag{active = Pet =#pet{skill = Skills, skill_slot = Skill_slot, skill_num = Num}}}) -> %% 出战状态升级
    case lists:keyfind(SkillId, 1, Skills) of
        false -> 
            {false, ?MSGID(<<"宠物没有此技能">>)};
        {_, _, Loc, _}->
            NewPet = Pet#pet{skill = lists:keydelete(SkillId, 1, Skills), skill_slot =[Loc|Skill_slot], skill_num = Num + 1},
            %%遗忘的技能经验根据配置，产生一个物品

            NewPet2 = pet_api:deal_buff_skill(del, SkillId, NewPet),

            NRole = Role#role{pet = PetBag#pet_bag{active = NewPet2}},
            rank:listener(pet, NRole),
            % log:log(log_pet_update, {Role, [Pet], NewPet2, util:fbin("宠物技能遗忘,技能id:~w", [SkillId])}),

            NRole1 = pet_api:reset(NewPet2, NRole),

            log:log(log_pet2, {<<"技能遗忘">>, SkillId, NRole1}),

            pet_api:push_pet2(refresh, NRole1),
            {ok, NRole1, SkillId}
    end.



%% 宠物蛋刷新
refresh_egg({ItemId, -1, _ISBatch}, Role = #role{bag = Bag = #bag{items = Items}}) -> %% 打开宠物蛋
    case storage:find(Items, #item.id, ItemId) of
        {false, Reason} -> {false, Reason};
        {ok, Item = #item{special = [{pet, Pets}]}} when is_list(Pets) -> %% 已打开过
            case pet_parse:do_pets(Pets, []) of
                {false, Reason} -> {false, Reason};
                {ok, NewPets0} ->
                    NewPets = lists:reverse(NewPets0),
                    pet_api:push_pet(refresh_egg, NewPets, Role),
                    NewItem = Item#item{special = [{pet, NewPets}]},
                    NewItems = lists:keyreplace(ItemId, #item.id, Items, NewItem),
                    {ok, Role#role{bag = Bag#bag{items = NewItems}}}
            end;
        {ok, Item = #item{bind = Bind, base_id = BaseId}} -> %% 第一次打开
            case get_item_refresh_type(BaseId) of
                {false, Reason} -> {false, Reason};
                Refresh ->
                    Pets = pet_api:rand_pet_list(Refresh, 1),
                    NewPets = [pet_api:reset(Pet#pet{bind = Bind}, Role) || Pet <- Pets],
                    pet_api:push_pet(refresh_egg, NewPets, Role),
                    NewItem = Item#item{special = [{pet, NewPets}]},
                    NewItems = lists:keyreplace(ItemId, #item.id, Items, NewItem),
                    {ok, Role#role{bag = Bag#bag{items = NewItems}}}
            end
    end;
refresh_egg({ItemId, _Refresh, IsBatch}, Role = #role{bag = Bag = #bag{items = Items}}) -> %% 刷新宠物蛋
    case storage:find(Items, #item.id, ItemId) of
        {false, Reason} -> {false, Reason};
        {ok, Item = #item{bind = Bind, base_id = BaseId}} -> %% 保证不是第一次打开
            case get_refresh_gold(BaseId, IsBatch) of
                {false, Reason} -> {false, Reason};
                {Num, Price} ->
                    case role_gain:do([#loss{label = gold, val = Price, msg = ?L(<<"晶钻不足">>)}], Role) of
                        {false, #loss{msg = Msg}} -> {gold, Msg};
                        {ok, NRole} ->
                            Refresh = get_item_refresh_type(BaseId),
                            Pets = pet_api:rand_pet_list(Refresh, Num),
                            NewPets = [pet_api:reset(Pet#pet{bind = Bind}, Role) || Pet <- Pets],
                            pet_api:push_pet(refresh_egg, NewPets, NRole),
                            NewItem = Item#item{special = [{pet, NewPets}]},
                            NewItems = lists:keyreplace(ItemId, #item.id, Items, NewItem),
                            {ok, NRole#role{bag = Bag#bag{items = NewItems}}}
                    end
            end;
        _ -> {false, ?L(<<"查找不到宠物蛋物品">>)}
    end;
refresh_egg(_, _) -> 
    {false, ?L(<<"匹配不到">>)}.

%% 潜力提升 by bwang (1计算平均潜力的阶是否有变化与附加属性，2计算技能槽个数是否有变化)
asc_potential(Type, IsAuto, Role) -> 
    case pet_api:asc_potential(Type, IsAuto, Role) of
        {_, Reason} -> 
            {false, Reason};
        {Val, Msg, NRole, NewPet, Step, NextMax} ->
            NR = #role{pet = #pet_bag{active = NP}} = pet_api:reset(NewPet, NRole),  %%计算一级属性到二级属性的转化,同时会影响到战斗力啥
                        
            rank:listener(pet, NR), %%更新排行榜数据
            NRole1 = #role{pet = NPBag = #pet_bag{active = NP2}} = pet_api:broadcast_pet(NP, NR), %%更新地图中宠物的信息
            {Slot_Num, NP3} = get_alloc_slots(NP2), %%根据新的潜力值重新计算技能槽
            NRole2 = NRole1#role{pet = NPBag#pet_bag{active = NP3}},
            pet_api:push_pet2(refresh, NRole2),
            NRole3 = medal:listener(dragon_bone, NRole2),
            {Val, Msg, NRole3, Slot_Num, Step, NextMax}
   end.


%% 重置宠物外形
reset_baseid(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = Id}}}, Type, Id) -> %% 正在出战
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    case do_reset_baseid(NPet, Type) of
        {false, Reason} -> {false, Reason};
        {ok, NewPet} ->
            NewRole = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
            pet_api:push_pet(refresh, [NewPet], NewRole),
            pet_api:push_pet(evolve, NewPet, NewRole),
            {ok, pet_api:broadcast_pet(NewPet, NewRole)}
    end;
reset_baseid(Role = #role{pet = PetBag = #pet_bag{pets = Pets}}, Type, Id) -> %% 非出战宠
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        Pet ->
            case do_reset_baseid(Pet, Type) of
                {false, Reason} -> {false, Reason};
                {ok, NewPet} ->
                    NewPets = lists:keyreplace(Id, #pet.id, Pets, NewPet),
                    pet_api:push_pet(refresh, [NewPet], Role),
                    pet_api:push_pet(evolve, NewPet, Role),
                    NewRole = Role#role{pet = PetBag#pet_bag{pets = NewPets}},
                    {ok, NewRole}
            end
    end.

%% 仙宠进化
evolve(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = Id}}, link = #link{conn_pid = ConnPid}}, Id) -> %% 正在出战
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    case do_evolve(Role, NPet) of
        {false, Reason} -> {false, Reason};
        {ok, NewPet0 = #pet{base_id = BaseId, evolve = Evo}, NRole} ->
            pet_ex:push_skins(NPetBag, BaseId, Evo, ConnPid),
            NewPet = NewPet0#pet{skin_id = BaseId, skin_grade = Evo},
            NewRole = NRole#role{pet = NPetBag#pet_bag{active = NewPet}},
            {ok, pet_api:broadcast_pet(NewPet, NewRole), NewPet}
    end;
evolve(Role = #role{pet = PetBag = #pet_bag{pets = Pets}, link = #link{conn_pid = ConnPid}}, Id) ->
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        Pet ->
            case do_evolve(Role, Pet) of
                {false, Reason} -> {false, Reason};
                {ok, NewPet0 = #pet{base_id = BaseId, evolve = Evo}, NRole} ->
                    NewPet = NewPet0#pet{skin_id = BaseId, skin_grade = Evo},
                    NewPets = lists:keyreplace(Id, #pet.id, Pets, NewPet),
                    pet_ex:push_skins(PetBag, BaseId, Evo, ConnPid),
                    NewRole = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    {ok, NewRole, NewPet}
            end
    end.

%% 仙宠进化处理
do_evolve(_Role, #pet{evolve = Evo}) when Evo >= 3 ->
    {false, ?L(<<"仙宠已进化到最高级，不能继续进化">>)};
do_evolve(Role, Pet = #pet{evolve = Evo, grow_val = Grow, base_id = BaseId}) ->
    MaxEvo = if
        Grow >= 300 -> 3;  %% 神级
        Grow >= 200 -> 2;  %% 帝级
        Grow >= 100 -> 1;  %% 仙级
        true -> 0 %% 普通
    end,
    GL = [
        %% #loss{label = coin_all, val = 100000}
        #loss{label = item, val = [23030, 0, 1]}
    ],
    case Evo >= MaxEvo of
        true when MaxEvo =:= 0 -> {false, ?L(<<"仙宠需要提升成长到100才能进化成仙级形象">>)};
        true when MaxEvo =:= 1 -> {false, ?L(<<"仙宠需要提升成长到200才能进化成帝级形象">>)};
        true when MaxEvo =:= 2 -> {false, ?L(<<"仙宠需要提升成长到300才能进化成神级形象">>)};
        false ->
            case role_gain:do(GL, Role) of
                {false, #loss{label = coin_all}} -> {false, coin_all};
                {false, _} -> {false, ?L(<<"进化仙露数量不足">>)};
                {ok, NRole} ->
                    NewBaseId = pet_data:get_next_baseid(Evo + 1, BaseId),
                    NewPet = pet_api:reset(Pet#pet{evolve = Evo + 1, base_id = NewBaseId}, Role),
                    RoleMsg = notice:role_to_msg(Role),
                    PetMsg = pet_to_msg(Role, NewPet),
                    pet_api:push_pet(refresh, [NewPet], NRole),
                    pet_api:push_pet(evolve, NewPet, NRole),
                    log:log(log_pet_update, {Role, Pet, NewPet, util:fbin("宠物进化:~p", [NewPet#pet.evolve])}),
                    case NewPet#pet.evolve of
                        1 -> notice:send(53, util:fbin(?L(<<"~s在~s的精心培育下，竟然慢慢产生了灵性，进化成拥有变身仙级形象能力的仙宠。">>), [PetMsg, RoleMsg]));
                        2 -> notice:send(53, util:fbin(?L(<<"~s在~s的精心培育下，二次进化，竟然拥有了变身帝级形象的能力！">>), [PetMsg, RoleMsg]));
                        3 -> notice:send(53, util:fbin(?L(<<"~s在~s的精心培育下，三次进化，竟然拥有了变身神级形象的能力！">>), [PetMsg, RoleMsg]))
                    end,
                    {ok, NewPet, NRole}
            end
    end.

%% 提升成长
grow(Id, Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = Id}}}) -> %% 出战宠物
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    case pet_api:grow(NPet, Role) of
        {false, Reason} -> {false, Reason};
        {coin_all, Reason} -> {coin_all, Reason};
        {Msg, NRole, NewPet} ->
            pet_api:push_pet(refresh, [NewPet], Role),
            NRole1 = NRole#role{pet = NPetBag#pet_bag{active = NewPet}},
            rank:listener(pet, NRole1),
            NRole2 = role_listener:special_event(NRole1, {20021, NewPet#pet.attr#pet_attr.avg_val}),
            NRole3 = role_listener:special_event(NRole2, {20020, NewPet#pet.fight_capacity}),
            NewRole = role_listener:special_event(NRole3, {20023, NewPet#pet.grow_val}),
            NewRole1 = role_listener:acc_event(NewRole, {133, NewPet#pet.grow_val - Pet#pet.grow_val}), %%当次提升宠物成长值            
            log:log(log_pet_update, {Role, Pet, NewPet, <<"宠物成长提升">>}),
            case Msg of
                {suc, _} -> 
                    campaign_listener:handle(pet_grow, Role, Pet#pet.grow_val, NewPet#pet.grow_val),
                    grow_notice(Role, NewPet);
                _ -> ok
            end,
            {Msg, NewPet#pet.grow_val, pet_api:broadcast_pet(NewPet, NewRole1)}
    end;
grow(Id, Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) -> %% 非出战宠物
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        Pet ->
            case pet_api:grow(Pet, Role) of
                {false, Reason} -> {false, Reason};
                {coin_all, Reason} -> {coin_all, Reason};
                {Msg, NRole, NewPet} ->
                    NewPets = lists:keyreplace(Id, #pet.id, Pets, NewPet),
                    pet_api:push_pet(refresh, [NewPet], Role),
                    NewRole = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    rank:listener(pet, NewRole),
                    case Msg of
                        {suc, _} -> 
                            campaign_listener:handle(pet_grow, Role, Pet#pet.grow_val, NewPet#pet.grow_val),
                            grow_notice(Role, NewPet);
                        _ -> ok
                    end,
                    log:log(log_pet_update, {Role, Pet, NewPet, <<"宠物成长提升">>}),
                    NewRole1 = role_listener:acc_event(NewRole, {133, NewPet#pet.grow_val - Pet#pet.grow_val}), %%当次提升宠物成长值            
                    {Msg, NewPet#pet.grow_val, NewRole1}
            end
    end.

%% 提升成长
grow(Id, GrowVal, #role{pet = #pet_bag{active = #pet{id = Id, grow_val = Grow}}}) when Grow >= GrowVal -> %% 出战宠物
    {false, ?L(<<"目标值不正确">>)};
grow(Id, GrowVal, Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = Id}}}) -> %% 出战宠物
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    case do_grow(0, NPet, GrowVal, Role, 0) of
        {false, Reason} -> {false, Reason};
        {coin_all, Reason} -> {coin_all, Reason};
        {N, NRole, NewPet, AddAttrVal} ->
            pet_api:push_pet(refresh, [NewPet], Role),
            NRole1 = NRole#role{pet = NPetBag#pet_bag{active = NewPet}},
            rank:listener(pet, NRole1),
            NRole2 = role_listener:special_event(NRole1, {20021, NewPet#pet.attr#pet_attr.avg_val}),
            NRole3 = role_listener:special_event(NRole2, {20020, NewPet#pet.fight_capacity}),
            NewRole = role_listener:special_event(NRole3, {20023, NewPet#pet.grow_val}),
            NewRole1 = role_listener:acc_event(NewRole, {133, NewPet#pet.grow_val - Pet#pet.grow_val}), %%当次提升宠物成长值            
            log:log(log_pet_update, {Role, Pet, NewPet, <<"宠物成长一键提升">>}),
            {N, Pet, NewPet, AddAttrVal, pet_api:broadcast_pet(NewPet, NewRole1)}
    end;
grow(Id, GrowVal, Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) -> %% 非出战宠物
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        #pet{grow_val = Grow} when Grow >= GrowVal -> {false, ?L(<<"目标值不正确">>)};
        Pet ->
            case do_grow(0, Pet, GrowVal, Role, 0) of
                {false, Reason} -> {false, Reason};
                {coin_all, Reason} -> {coin_all, Reason};
                {N, NRole, NewPet, AddAttrVal} ->
                    NewPets = lists:keyreplace(Id, #pet.id, Pets, NewPet),
                    pet_api:push_pet(refresh, [NewPet], Role),
                    NewRole = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    rank:listener(pet, NewRole),
                    log:log(log_pet_update, {Role, Pet, NewPet, <<"宠物成长一键提升">>}),
                    NewRole1 = role_listener:acc_event(NewRole, {133, NewPet#pet.grow_val - Pet#pet.grow_val}), %%当次提升宠物成长值            
                    {N, Pet, NewPet, AddAttrVal, NewRole1}
            end
    end.
do_grow(N, Pet = #pet{grow_val = GrowVal1}, GrowVal, Role, AddAttrVal) when GrowVal =< GrowVal1 -> {N, Role, Pet, AddAttrVal};
do_grow(N, Pet, GrowVal, Role, AddAttrVal) ->
    case pet_api:grow(Pet, Role) of
        {false, Reason} when N =:= 0 -> {false, Reason};
        {coin_all, Reason} when N =:= 0 -> {coin_all, Reason};
        {Msg, NRole, NewPet} ->
             AddVal = case Msg of
                 {suc, V} -> 
                     campaign_listener:handle(pet_grow, Role, Pet#pet.grow_val, NewPet#pet.grow_val),
                     grow_notice(NRole, NewPet),
                     V;
                 _ -> 0
             end,
             do_grow(N + 1, NewPet, GrowVal, NRole, AddAttrVal + AddVal);
         _ ->
             {N, Role, Pet, AddAttrVal}
     end.

%% 转换成宠物公告格式
pet_to_msg(#role{id = {Rid, SrvId}}, #pet{id = PetId, name = PetName, type = PetType}) -> 
    util:fbin("{pet,~s,~p,~s,~p,~p}", [PetName, Rid, SrvId, PetId, PetType]).

%% 成长提升公告
grow_notice(Role, Pet = #pet{grow_val = Grow = 20}) ->
    RoleMsg = notice:role_to_msg(Role),
    PetMsg = pet_to_msg(Role, Pet),
    notice:send(53, util:fbin(?L(<<"在~s的精心调教下，~s的成长达到~p，突破境界，成为{str, 灵宠, #00FF35}，能力得到质的飞跃">>), [RoleMsg, PetMsg, Grow]));
grow_notice(Role, Pet = #pet{grow_val = Grow = 50}) ->
    RoleMsg = notice:role_to_msg(Role),
    PetMsg = pet_to_msg(Role, Pet),
    notice:send(53, util:fbin(?L(<<"在~s的精心调教下，~s的成长达到~p，突破境界，成为{str, 仙宠, #00BDFF}，能力得到质的飞跃">>), [RoleMsg, PetMsg, Grow]));
grow_notice(Role, Pet = #pet{grow_val = Grow = 100}) ->
    RoleMsg = notice:role_to_msg(Role),
    PetMsg = pet_to_msg(Role, Pet),
    notice:send(53, util:fbin(?L(<<"在~s的精心调教下，~s的成长达到~p，突破境界成为{str, 神宠, #FD00FD}，能力得到质的飞跃">>), [RoleMsg, PetMsg, Grow]));
grow_notice(Role, Pet = #pet{grow_val = Grow}) when Grow > 100 andalso Grow < 200 andalso (Grow rem 20 =:= 0) ->
    RoleMsg = notice:role_to_msg(Role),
    PetMsg = pet_to_msg(Role, Pet),
    notice:send(53, util:fbin(?L(<<"在~s的精心调教下，~s的成长达到~p，从此飞仙界又多了一只极品{str, 神宠, #FD00FD}">>), [RoleMsg, PetMsg, Grow]));
grow_notice(Role, Pet = #pet{grow_val = Grow = 200}) ->
    RoleMsg = notice:role_to_msg(Role),
    PetMsg = pet_to_msg(Role, Pet),
    notice:send(53, util:fbin(?L(<<"在~s的精心调教下，~s的成长达到~p，突破境界，成为{str, 圣宠, #FF7802}，能力得到质的飞跃">>), [RoleMsg, PetMsg, Grow]));
grow_notice(Role, Pet = #pet{grow_val = Grow}) when Grow > 200 andalso (Grow rem 10 =:= 0) ->
    RoleMsg = notice:role_to_msg(Role),
    PetMsg = pet_to_msg(Role, Pet),
    notice:send(53, util:fbin(?L(<<"在~s的精心调教下，~s的成长达到~p，隐隐要达到更高的层次">>), [RoleMsg, PetMsg, Grow]));
grow_notice(_Role, _Pet) ->
    ok.


%% 宠物洗随 by bwang
set_sys_attr_per(Auto, Role = #role{pet = #pet_bag{active = Pet}}) when is_record(Pet, pet) -> %% 暂不区分出战与非出战宠物
    case pet_api:set_sys_attr_per(Auto, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NRole} ->
            pet_api:push_pet2(refresh, NRole),
            {ok, NRole}
    end;
set_sys_attr_per(_Auto, #role{pet = #pet_bag{active = undefined}}) -> %% 暂不区分出战与非出战宠物
    {false, ?MSGID(<<"没有宠物">>)}.

%% 获取双天赋数据
get_double_talent(Id, #role{pet = #pet_bag{active = Pet = #pet{id = Id}}}) -> %% 出战宠物
    {ok, pet_api:double_talent_to_client(Pet)};
get_double_talent(Id, #role{pet = #pet_bag{pets = Pets}}) -> %% 非出战宠
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        Pet -> {ok, pet_api:double_talent_to_client(Pet)}
    end.

%% 开启双天赋
open_double_talent(Id, Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = Id}}}) ->
    case pet_api:open_double_talent(Pet, Role) of
        {false, Reason} -> {false, Reason};
        {gold_less, Msg} -> {gold_less, Msg};
        {ok, NRole, NewPet} ->
            pet_api:push_pet(double_talent, NewPet, NRole),
            {ok, NRole#role{pet = PetBag#pet_bag{active = NewPet}}}
    end;
open_double_talent(Id, Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) ->
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        Pet ->
            case pet_api:open_double_talent(Pet, Role) of
                {false, Reason} -> {false, Reason};
                {gold_less, Msg} -> {gold_less, Msg};
                {ok, NRole, NewPet} ->
                    NewPets = lists:keyreplace(Id, #pet.id, Pets, NewPet),
                    NRole1 = NRole#role{pet = PetBag#pet_bag{pets = NewPets}},
                    pet_api:push_pet(double_talent, NewPet, NRole1),
                    {ok, NRole1}
            end
    end.

%% 更换天赋
change_double_talent(Id, UseId, Role = #role{pet = #pet_bag{active = Pet = #pet{id = Id}}}) ->
    case pet_api:change_double_talent(active, Pet, UseId, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NRole} ->
            {ok, NRole}
    end;
change_double_talent(Id, UseId, Role = #role{pet = #pet_bag{pets = Pets}}) ->
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        Pet ->
            case pet_api:change_double_talent(bag, Pet, UseId, Role) of
                {false, Reason} -> {false, Reason};
                {ok, NRole} ->
                    {ok, NRole}
            end
    end.

%% 加速CD
del_double_talent_cd(Id, Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{id = Id}}}) ->
    case pet_api:del_double_talent_cd(Pet, Role) of
        {false, Reason} -> {false, Reason};
        {gold_less, Msg} -> {gold_less, Msg};
        {ok, NRole, NewPet} ->
            pet_api:push_pet(double_talent, NewPet, NRole),
            {ok, NRole#role{pet = PetBag#pet_bag{active = NewPet}}}
    end;
del_double_talent_cd(Id, Role = #role{pet = PetBag = #pet_bag{pets = Pets}}) ->
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        Pet ->
            case pet_api:del_double_talent_cd(Pet, Role) of
                {false, Reason} -> {false, Reason};
                {gold_less, Msg} -> {gold_less, Msg};
                {ok, NRole, NewPet} ->
                    NewPets = lists:keyreplace(Id, #pet.id, Pets, NewPet),
                    pet_api:push_pet(double_talent, NewPet, NRole),
                    {ok, NRole#role{pet = PetBag#pet_bag{pets = NewPets}}}
            end
    end.

%% 获取当前批量洗髓结果数据
get_wash(#role{pet = #pet_bag{active = Pet}})when is_record(Pet, pet) -> %% 出战宠
    {ok, pet_api:wash_batch_to_client(Pet)};
get_wash(#role{pet = #pet_bag{active = undefined}}) -> %% 出战宠
    {false, ?MSGID(<<"宠物不存在">>)}.
     


%% 进行批量洗髓一次
wash(Auto, Role = #role{pet = PetBag = #pet_bag{active = Pet}}) -> %% 出战宠物
    case pet_api:wash_batch(Auto, Pet, Role) of
        {false, Reason} -> {false, Reason};
        {ok, NRole, NewPet} ->
            {ok, pet_api:wash_batch_to_client(NewPet), NRole#role{pet = PetBag#pet_bag{active = NewPet}}}
    end.

%宠物进行一次龙族遗迹探寻
explore(Role, Bind) ->
    case pet_api:explore(Role, Bind) of 
        {false, Reason} -> {false, Reason};
        {ok, NRole, ItemId} ->
            {ok, NRole, ItemId}
    end.   

%宠物进行一次批量探寻龙族遗迹
explore_batch(Role, Bind) ->
    case pet_api:explore_batch(Role, Bind) of 
        {false, Reason} -> {false, Reason};
        {ok, NRole, Items} ->
            {ok, NRole, Items}
    end.

%%购买探寻龙族遗迹得到的物品
buy_item({Table,ItemId}, Role) ->
    case pet_api:buy_item({Table, ItemId}, Role) of 
        {ok, NRole, NDevout} ->
            {ok, NRole, NDevout};
        {_, Reason} ->
            {false, Reason}
    end.

%% 选择批量洗髓结果
select_wash(0, Role = #role{pet = PetBag = #pet_bag{active = Pet}}) -> %% 出战宠 保留原值
    NewPet = Pet#pet{wash_list = []},
    Role1 = Role#role{pet = PetBag#pet_bag{active = NewPet}},
    pet_api:push_pet2(refresh, Role1),
    {ok, Role1};
select_wash(N, Role = #role{pet = #pet_bag{active = Pet = #pet{wash_list = WL}}}) -> %% 出战宠 选择结果
    case lists:keyfind(N, 1, WL) of
        {N, AttrSys} when is_record(AttrSys, pet_attr_sys) ->
            Role1 = pet_api:reset(Pet#pet{bind = 1, attr_sys = AttrSys, wash_list = []}, Role),

            log:log(log_pet2, {<<"伙伴天赋">>, util:term_to_bitstring(AttrSys), Role1}),

            pet_api:push_pet2(refresh, Role1),
            {ok, Role1};
        _ ->
            {false, ?MSGID(<<"查找不到洗髓结果">>)}
    end.

%% 获取每天限定类型日志
everyday_limit_log(Type, #role{pet = #pet_bag{log = Logs}}) ->
    Now = util:unixtime(),
    case lists:keyfind(Type, 1, Logs) of
        OldLog = {Type, Time, _N} ->
            case util:is_same_day2(Now, Time) of
                true -> 
                    {OldLog, Logs};
                false ->
                    NewLog = {Type, Now, everyday_limit_num(Type)},
                    NewLogs = lists:keyreplace(Type, 1, Logs, NewLog),
                    {NewLog, NewLogs}
            end;
        _ ->
            NewLog = {Type, Now, everyday_limit_num(Type)},
            {NewLog, [NewLog | Logs]}
    end.

%% 每天免费砸蛋
open_free_egg(Role = #role{pet = PetBag}) ->
    case everyday_limit_log(?pet_log_type_free_egg, Role) of
        {{Type, Time, Free}, Logs} when Free > 0 ->
%%            [Pet | _] = pet_api:rand_pet_list(?pet_egg_blue, 1),
%%            NewPet = Pet#pet{bind = 1},
%%            case pet_api:add(NewPet, Role) of
%%                {false, _Reason} -> {false, ?L(<<"拥有的仙宠已达到上限。可先放生不需要的仙宠，再来砸蛋吧！">>)};
%%                {ok, NRole = #role{pet = NPetBag}} ->
%%                    NewLogs = lists:keyreplace(Type, 1, Logs, {Type, Time, Free - 1}),
%%                    {ok, NRole#role{pet = NPetBag#pet_bag{log = NewLogs}}}
%%            end;
            case do_free_egg() of
                {_Rand, nothing, Msg} -> 
                    erase(pet_free_egg_info),
                    log:log(log_pet_update, {Role, #pet{}, #pet{}, <<"免费砸蛋:什么都没有">>}),
                    NewLogs = lists:keyreplace(Type, 1, Logs, {Type, Time, Free - 1}),
                    {ok, Role#role{pet = PetBag#pet_bag{log = NewLogs}}, Msg};
                {_Rand, {pet, RefreshType}, Msg} ->
                    [Pet | _] = pet_api:rand_pet_list(RefreshType, 1),
                    NewPet = pet_api:reset(Pet#pet{bind = 1}, Role),
                    case pet_api:add(NewPet, Role) of
                        {false, _Reason} -> {false, ?L(<<"拥有的仙宠已达到上限。可先放生不需要的仙宠，再来砸蛋吧！">>)};
                        {ok, NRole = #role{pet = NPetBag}} ->
                            erase(pet_free_egg_info),
                            log:log(log_pet_update, {NRole, NewPet, NewPet, <<"免费砸蛋:得到宠物">>}),
                            NewLogs = lists:keyreplace(Type, 1, Logs, {Type, Time, Free - 1}),
                            {ok, NRole#role{pet = NPetBag#pet_bag{log = NewLogs}}, Msg}
                    end;
                {_Rand, {item, BaseId, Bind, Num}, Msg} ->
                    GL = [#gain{label = item, val = [BaseId, Bind, Num]}],
                    case role_gain:do(GL, Role) of
                        {false, G} -> {false, G#gain.msg};
                        {ok, NRole} ->
                            erase(pet_free_egg_info),
                            {ok, #item_base{name = ItemName}} = item_data:get(BaseId),
                            log:log(log_pet_update, {Role, #pet{}, #pet{}, util:fbin("免费砸蛋:得到物品:~s", [ItemName])}),
                            Inform = notice_inform:gain_loss(GL, ?L(<<"砸蛋成功">>)),
                            notice:inform(Role#role.pid, Inform),
                            NewLogs = lists:keyreplace(Type, 1, Logs, {Type, Time, Free - 1}),
                            {ok, NRole#role{pet = PetBag#pet_bag{log = NewLogs}}, Msg}
                    end;
                _ ->
                    {false, ?L(<<"配置数据存在问题">>)}
            end;
        _ ->
            {false, ?L(<<"今天免费砸蛋次数已使用完">>)}
    end.

do_free_egg() ->
    {L, Max} = pet_data:get_open_free_egg_info(),
    RandVal = case get(pet_free_egg_info) of
        R when is_integer(R) andalso R =< Max -> R;
        _ -> util:rand(1, Max)
    end,
    put(pet_free_egg_info, RandVal),
    do_free_egg(RandVal, L).
do_free_egg(_RandVal, [I]) -> I;
do_free_egg(RandVal, [{Rand, Item, Msg} | _T]) when RandVal =< Rand -> {Rand, Item, Msg};
do_free_egg(RandVal, [{Rand, _Item, _Msg} | T]) ->
    do_free_egg(RandVal - Rand, T).

%% 固定宠物蛋 生成一个宠物
create([{base_id, BaseId}, {name, Name}, {skill, Skills}, {potential, Xl, Tz, Js, Lq}, {per, XlPer, TzPer, JsPer, LqPer}], Role = #role{link = #link{conn_pid = ConnPid}}) ->
    NewPet = pet_api:reset(#pet{
            base_id = BaseId, name = Name
            ,skill = [{SkillId, Exp, Loc, []} || {SkillId, Exp, Loc} <- Skills]
            ,attr = #pet_attr{xl_val = Xl, tz_val = Tz, js_val = Js, lq_val = Lq}
            ,attr_sys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}
            % ,double_talent = #pet_double_talent{attr_list = [{1, #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}}]}
        }, Role),
    case pet_api:add(NewPet, Role) of
        {false, Reason} ->
            notice:alert(error,ConnPid,Reason),
            {false, Reason};
        {ok, NRole} -> 
            % SkillStr = pet_skill_to_msg(NewPet#pet.skill, <<>>),
            % role:pack_send(NRole#role.pid, 10931, {57, util:fbin(?L(<<"获得仙宠【~s】\n平均潜力：~p\n技能：~s">>), [Name, NewPet#pet.attr#pet_attr.avg_val, SkillStr]), []}),
            role:pack_send(NRole#role.pid, 10931, {0, util:fbin(?L(<<"获得仙宠【~s">>), [Name]), []}),
            log:log(log_pet_update, {Role, NewPet, NewPet, <<"开服宠物龙">>}),
            {ok, NRole}
    end.
% pet_skill_to_msg([], Str) -> Str;
% pet_skill_to_msg([{SkillId, _, _} | T], Str) ->
%     case pet_data_skill:get(SkillId) of
%         {ok, #pet_skill{name = Name}} when Str =:= <<>> -> pet_skill_to_msg(T, Name);
%         {ok, #pet_skill{name = Name}} -> pet_skill_to_msg(T, <<Str/binary, <<"、">>/binary, Name/binary>>);
%         _ -> pet_skill_to_msg(T, Str)
%     end.

%% 宠物炼魂
pet_to_item(Id, #role{pet = #pet_bag{active = #pet{id = Id}}}) ->
    {false, ?L(<<"出战宠物无法炼魂">>)};
pet_to_item(Id, Role = #role{pid = Pid, pet = PetBag = #pet_bag{pets = Pets}}) ->
    case lists:keyfind(Id, #pet.id, Pets) of
        false -> {false, ?L(<<"宠物不存在">>)};
        %% #pet{base_id = ?pet_new_id} ->
        %%    {false, ?L(<<"新手宠物不能炼魂">>)};
        #pet{lev = Lev} when Lev >= 5 ->
            {false, ?L(<<"仙宠等级达到5级，不能进行炼魂">>)};
        #pet{eqm = Eqm} when length(Eqm) > 0 ->
            {false, ?L(<<"装备魔晶的宠物不可以炼魂">>)};
        Pet ->
            case do_pet_to_item(Pet) of
                {false, Reason} -> {false, Reason};
                {ok, Items} ->
                    case storage:add(bag, Role, Items) of
                        false -> {false, ?L(<<"背包已满">>)};
                        {ok, NewBag} ->
                            ItemMsg = notice:item3_to_inform(Items),
                            Msg = util:fbin(?L(<<"练魂成功\n获得 ~s">>), [ItemMsg]),
                            notice:inform(Pid, Msg),
                            NewPets = lists:keydelete(Id, #pet.id, Pets),
                            pet_api:push_pet(del, [Id], Role),
                            log:log(log_pet_update, {Role, Pet, Pet, <<"宠物练魂">>}),
                            log:log(log_pet_del, {<<"放生练魂">>, Role, Pet}),
                            NewRole = Role#role{bag = NewBag, pet = PetBag#pet_bag{pets = NewPets}},
                            rank:listener(pet, NewRole),
                            {ok, NewRole}
                    end
            end
    end.

%% 练魂物品使用
skill_exp_update(_Value, #role{pet = #pet_bag{active = undefined}}) ->
    {false, ?L(<<"当前没有出战中的仙宠，使用精魂失败">>)};
skill_exp_update(_Value, #role{pet = #pet_bag{active = #pet{skill = []}}}) ->
    {false, ?L(<<"当前仙宠没有学习技能，使用精魂失败">>)};
skill_exp_update(Value, Role = #role{pid = Pid, pet = PetBag = #pet_bag{active = Pet = #pet{name = PetName, skill = Skills}}}) ->
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    case skill_lev_no_full(Skills, []) of
        [] -> 
            {false, ?L(<<"当前仙宠技能等级已满级，不能继续升级">>)};
        NoFull ->
            {SkillId, Exp, Args} = util:rand_list(NoFull),
            NewSkills = lists:keyreplace(SkillId, 1, Skills, {SkillId, Exp + Value, Args}),
            NewPet = pet_api:reset(NPet#pet{bind = 1, skill = NewSkills}, Role),
            pet_api:push_pet(refresh, [NewPet], Role),
            NRole1 = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
            NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
            log:log(log_pet_update, {NewRole, Pet, NewPet, <<"使用宠物精魂">>}),
            rank:listener(pet, NewRole),
            campaign_listener:handle(pet_skill_lev, Role, NewPet),
            case pet_data_skill:get(SkillId) of
                {ok, #pet_skill{name = SkillName}} ->
                    Msg = util:fbin(?L(<<"~s宝宝的[~s]技能增加了~p点经验">>), [PetName, SkillName, Value]),
                    role:pack_send(Pid, 10931, {57, Msg, []});
                _ -> 
                    ok
            end,
            {ok, NewRole}
    end.

%% 宠物经验丹使用
exp_update(_Value, #role{pet = #pet_bag{active = undefined}}) ->
    {false, ?L(<<"当前没有出战中的仙宠，使用失败">>)};
exp_update(Value, Role = #role{pid = Pid, lev = RoleLev, pet = PetBag = #pet_bag{active = Pet}}) ->
    {ok, NPet = #pet{exp = Exp, lev = PetLev}, NPetBag} = refresh_war_pet(Pet, PetBag),
    case pet_data_exp:get(PetLev) of
        NeedExp when PetLev >= RoleLev andalso Exp >= NeedExp -> 
            {false, ?L(<<"出战宠物等级与人物等级一致,且经验已满,使用失败">>)};
        _ -> %% 
            case do_upgrade(NPet#pet{exp = Exp + Value}, RoleLev, false) of
                {true, NP} -> %% 宠物有升级
                    NewPet = pet_api:reset(NP, Role),
                    pet_api:push_pet(refresh, [NewPet], Role),
                    NRole = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
                    NRole1 = role_listener:special_event(NRole, {20006, NewPet#pet.lev}),
                    NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
                    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"使用经验丹,出战宠物升级">>}),
                    rank:listener(pet, NewRole),
                    role:pack_send(Pid, 10931, {57, util:fbin(?L(<<"使用成功，仙宠升级经验增加~p点">>), [Value]), []}),
                    {ok, NewRole};
                {false, NewPet} -> %% 宠物无升级
                    NRole = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
                    pet_api:push_pet(refresh, [NewPet], NRole),
                    role:pack_send(Pid, 10931, {57, util:fbin(?L(<<"使用成功，仙宠升级经验增加~p点">>), [Value]), []}),
                    {ok, NRole}
            end
    end.

%% 宠物属性符使用
append_attr(_Attrs, #role{pet = #pet_bag{active = undefined}}) ->
    {false, ?L(<<"当前没有出战中的仙宠，使用失败">>)};
append_attr(Attrs = {Type, _}, Role = #role{pid = Pid, pet = PetBag = #pet_bag{active = Pet}}) ->
    {ok, NPet, NPetBag} = refresh_war_pet(Pet, PetBag),
    %% ?DEBUG("--------[~w]", [Attrs]),
    NewPet = pet_api:reset(NPet#pet{append_attr = [Attrs]}, Role),
    pet_api:push_pet(refresh, [NewPet], Role),
    NRole0 = Role#role{pet = NPetBag#pet_bag{active = NewPet}},
    NRole = pet_ex:update_skin_and_push(NRole0),
    NRole1 = pet_api:broadcast_pet(NewPet, NRole),
    NewRole = role_listener:special_event(NRole1, {20020, NewPet#pet.fight_capacity}),
    Msg = case Type of
        1 -> ?L(<<"仙宠变身成功\n仙宠攻击+100\n仙宠暴击+20\n仙宠攻击类技能触发几率+1%">>);
        2 -> ?L(<<"仙宠变身成功\n仙宠气血+800\n仙宠防御+200\n仙宠防御类技能触发几率+1%">>);
        3 -> ?L(<<"仙宠变身成功\n仙宠命中+100\n仙宠躲闪+50\n仙宠辅助类技能触发几率+1%">>);
        4 -> ?L(<<"仙宠变身成功\n仙宠气血+1000\n仙宠攻击+200\n全部技能增加1%释放几率">>);
        5 -> ?L(<<"仙宠变身成功\n仙宠攻击+200\n五行全抗+300\n仙宠反击+10\n全部技能增加1%释放几率">>);
        _ -> ?L(<<"仙宠变身成功">>)
    end,
    log:log(log_pet_update, {NewRole, Pet, NewPet, <<"宠物变身">>}),
    role:pack_send(Pid, 10931, {57, Msg, []}),
    rank:listener(pet, NewRole),
    campaign_listener:handle(pet_grow, Role, Pet#pet.grow_val, NewPet#pet.grow_val),
    campaign_listener:handle(pet_potential_avg, Role, Pet#pet.attr#pet_attr.avg_val, NewPet#pet.attr#pet_attr.avg_val),
    {ok, NewRole}.

%% 宠物潜力金丹使用
asc_potential_max(#role{pet = #pet_bag{active = undefined}}, {_Type, _N}) ->
    {false, ?L(<<"当前没有出战中的仙宠，使用失败">>)};
asc_potential_max(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{attr = Attr = #pet_attr{xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal, xl_max = XlMax, tz_max = TzMax, js_max = JsMax, lq_max = LqMax}}}}, {Type, N}) ->
    {Msg, NewAttr} = case Type of
        1 -> {util:fbin(?L(<<"使用成功\n仙宠的力的潜力值增加~p点\n力的潜力值当前为~p\n力的潜力上限提升到~p">>), [N, XlVal + N, XlMax + N]), Attr#pet_attr{xl_val = XlVal + N, xl_max = XlMax + N}};
        2 -> {util:fbin(?L(<<"使用成功\n仙宠的体的潜力值增加~p点\n体的潜力值当前为~p\n体的潜力上限提升到~p">>), [N, TzVal + N, TzMax + N]), Attr#pet_attr{tz_val = TzVal + N, tz_max = TzMax + N}};
        3 -> {util:fbin(?L(<<"使用成功\n仙宠的防的潜力值增加~p点\n防的潜力值当前为~p\n防的潜力上限提升到~p">>), [N, JsVal + N, JsMax + N]), Attr#pet_attr{js_val = JsVal + N, js_max = JsMax + N}};
        4 -> {util:fbin(?L(<<"使用成功\n仙宠的巧的潜力值增加~p点\n巧的潜力值当前为~p\n巧的潜力上限提升到~p">>), [N, LqVal + N, LqMax + N]), Attr#pet_attr{lq_val = LqVal + N, lq_max = LqMax + N}};
        _ -> {util:fbin(?L(<<"使用成功\n仙宠的所有潜力值增加~p点\n所有潜力上限增加~p点">>), [N, N]), 
                Attr#pet_attr{
                    xl_val = LqVal + N,  xl_max = LqMax + N
                    ,tz_val = TzVal + N, tz_max = TzMax + N
                    ,js_val = JsVal + N, js_max = JsMax + N
                    ,lq_val = LqVal + N, lq_max = LqMax + N
                }
            }
    end,
    role:pack_send(Role#role.pid, 10931, {57, Msg, []}),
    {ok, NPet, NPBag} = refresh_war_pet(Pet, PetBag),
    NewPet = pet_api:reset(NPet#pet{attr = NewAttr}, Role),
    pet_api:push_pet(refresh, [NewPet], Role),
    NRole = Role#role{pet = NPBag#pet_bag{active = NewPet}},
    NRole1 = pet_api:broadcast_pet(NewPet, NRole),
    NRole2 = role_listener:special_event(NRole1, {20021, NewPet#pet.attr#pet_attr.avg_val}), %% 仙宠平均潜力变化 N:当前仙宠平均潜力            
    NewRole = role_listener:special_event(NRole2, {20020, NewPet#pet.fight_capacity}),
    log:log(log_pet_update, {NewRole, Pet, NewPet, util:fbin(<<"宠物潜力金丹使用[~p,~p]">>, [Type, N])}),
    rank:listener(pet, NewRole),
    campaign_listener:handle(pet_potential_avg, Role, Pet#pet.attr#pet_attr.avg_val, NewPet#pet.attr#pet_attr.avg_val),
    NewRole2 = role_listener:acc_event(NewRole, {132, NewPet#pet.attr#pet_attr.avg_val - Pet#pet.attr#pet_attr.avg_val}), %% 当次提升平均潜力值    
    NewRole3 = role_listener:acc_event(NewRole2, {139, NewPet#pet.skill_num - Pet#pet.skill_num}), %%开启宠物技能槽
    {ok, NewRole3}.

%% 宠物变身卷使用
use_change_skin_item(#role{pet = #pet_bag{active = undefined}}, _BaseId) ->
    {false, ?L(<<"当前没有出战中的仙宠，使用失败">>)};
use_change_skin_item(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{skin_grade = Grade}}}, BaseId) ->
    {ok, NPet, NPBag} = refresh_war_pet(Pet, PetBag),
    NewPet = NPet#pet{skin_id = pet_data:get_next_baseid(Grade, BaseId), base_id = pet_data:get_next_baseid(Grade, BaseId)},
    NRole0 = Role#role{pet = NPBag#pet_bag{active = NewPet}},
    pet_api:push_pet(refresh, [NewPet], Role),
    NRole = pet_ex:update_skin_and_push(NRole0),
    NewRole = pet_api:broadcast_pet(NewPet, NRole),
    log:log(log_pet_update, {Role, Pet, NewPet, <<"宠物普通变身">>}),
    role:pack_send(Role#role.pid, 10931, {57, ?L(<<"宠物变身成功">>), []}),
    {ok, NewRole}.

%% 宠物变身卷 带附加属性
ext_attr(#role{pet = #pet_bag{active = undefined}}, _ExtAttrL, _Msg) ->
    {false, ?L(<<"当前没有出战中的仙宠，使用失败">>)};
ext_attr(Role = #role{pet = PetBag = #pet_bag{active = Pet}}, ExtAttrL, Msg) ->
    {ok, NPet, NPBag} = refresh_war_pet(Pet, PetBag),
    NewPet0 = pet_attr:add_ext_attr(NPet, ExtAttrL),
    NewPet = pet_api:reset(NewPet0, Role),
    pet_api:push_pet(refresh, [NewPet], Role),
    NRole0 = Role#role{pet = NPBag#pet_bag{active = NewPet}},
    NRole = pet_ex:update_skin_and_push(NRole0),
    NewRole = pet_api:broadcast_pet(NewPet, NRole),
    log:log(log_pet_update, {Role, Pet, NewPet, <<"宠物变身附加属性">>}),
    role:pack_send(Role#role.pid, 10931, {57, Msg, []}),
    campaign_listener:handle(pet_grow, Role, Pet#pet.grow_val, NewPet#pet.grow_val),
    campaign_listener:handle(pet_potential_avg, Role, Pet#pet.attr#pet_attr.avg_val, NewPet#pet.attr#pet_attr.avg_val),
    NewRole1 = role_listener:acc_event(NewRole, {133, NewPet#pet.grow_val - Pet#pet.grow_val}), %%当次提升宠物成长值            
    NewRole2 = role_listener:acc_event(NewRole1, {132, NewPet#pet.attr#pet_attr.avg_val - Pet#pet.attr#pet_attr.avg_val}), %% 当次提升平均潜力值    
    NewRole3 = role_listener:acc_event(NewRole2, {139, NewPet#pet.skill_num - Pet#pet.skill_num}), %%开启宠物技能槽
    {ok, NewRole3}.

%% 宠物抗性丹 带附加属性 存在使用上限
ext_attr(#role{pet = #pet_bag{active = undefined}}, _ExtAttrL, _Msg, _Type, _Max) ->
    {false, ?L(<<"当前没有出战中的仙宠，使用失败">>)};
ext_attr(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{ext_attr_limit = ExtLimit}}}, ExtAttrL, Msg, Type, Max) ->
    {ok, NPet, NPBag} = refresh_war_pet(Pet, PetBag),
    Val = case lists:keyfind(Type, 1, ExtLimit) of
        {_, V1} -> V1;
        _ -> 0
    end,
    case Val >= Max of
        true ->
            {false, util:fbin(?L(<<"物品使用已达上限~p，不能继续使用了哦">>), [Max])};
        false ->
            NewVal = Val + 1,
            NewExtLimit = [{Type, NewVal} | lists:keydelete(Type, 1, ExtLimit)],
            NewPet0 = pet_attr:add_ext_attr(NPet, ExtAttrL),
            NewPet = pet_api:reset(NewPet0#pet{ext_attr_limit = NewExtLimit}, Role),
            pet_api:push_pet(refresh, [NewPet], Role),
            NRole0 = Role#role{pet = NPBag#pet_bag{active = NewPet}},
            NRole = pet_ex:update_skin_and_push(NRole0),
            NewRole = pet_api:broadcast_pet(NewPet, NRole),
            log:log(log_pet_update, {Role, Pet, NewPet, <<"宠物变身附加属性">>}),
            role:pack_send(Role#role.pid, 10931, {57, util:fbin(?L(<<"~s\n当前该宠物已经使用~p个，上限为~p个">>), [Msg, NewVal, Max]), []}),
            campaign_listener:handle(pet_grow, Role, Pet#pet.grow_val, NewPet#pet.grow_val),
            campaign_listener:handle(pet_potential_avg, Role, Pet#pet.attr#pet_attr.avg_val, NewPet#pet.attr#pet_attr.avg_val),
            NewRole1 = role_listener:acc_event(NewRole, {133, NewPet#pet.grow_val - Pet#pet.grow_val}), %%当次提升宠物成长值            
            NewRole2 = role_listener:acc_event(NewRole1, {132, NewPet#pet.attr#pet_attr.avg_val - Pet#pet.attr#pet_attr.avg_val}), %% 当次提升平均潜力值    
            NewRole3 = role_listener:acc_event(NewRole2, {139, NewPet#pet.skill_num - Pet#pet.skill_num}), %%开启宠物技能槽
            {ok, NewRole3}
    end.

%% @spec ascend(Role, ItemId) -> {ok, NewRole} | {ok, NewRole, NewAscendNum} | {false, Reason}
%% Role = NewRole = #role{}
%% NewAscendNum = ItemId = integer()
%% Reason = bitstring()
%% @doc 宠物飞升（使用飞升丹效果）
ascend(#role{pet = #pet_bag{active = undefined}}, _ItemId) ->
    {false, ?L(<<"没有出战仙宠">>)};
ascend(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{ascended = Ascended}}}, ItemId) -> %% 出战宠物
    case do_ascend(Pet, Role, ItemId) of
        {up, NewPet, NRole} ->
            pet_api:push_pet(refresh, [NewPet], NRole),
            NRole1 = NRole#role{pet = PetBag#pet_bag{active = NewPet}},
            RoleName = notice:role_to_msg(NRole1),
            PetName = pet_to_msg(Role, NewPet),
            notice:send(52, util:fbin(?L(<<"飞升：玩家~s真乃一代神人，经过他的细心教导，他的宠物~s一举突破，进入飞升境界">>), [RoleName, PetName])),
            {ok, NRole1, ?L(<<"仙宠成功飞升">>)};
        {add, NewPet, _NewAscendNum, NRole} when Ascended =:= 0 ->
            pet_api:push_pet(refresh, [NewPet], NRole),
            NRole1 = NRole#role{pet = PetBag#pet_bag{active = NewPet}},
            {ok, NRole1, ?L(<<"您的宠物一口吃下金丹，由于等级不够50级，无法飞升，但属性得到大幅度的增强">>)};
        {add, NewPet, NewAscendNum, NRole} ->
            pet_api:push_pet(refresh, [NewPet], NRole),
            NRole1 = NRole#role{pet = PetBag#pet_bag{active = NewPet}},
            Msg = case NewAscendNum > 10 of
                true ->
                    ?L(<<"你的宠物一口吃下金丹，似乎觉得口味不错，属性得到部分提升！">>);
                _ ->
                    ?L(<<"你的宠物一口吃下金丹，顿时金光四射，似乎潜力被激发，属性大幅度提升！">>)
            end,
            {ok, NRole1, Msg};
        {false, Reason} ->
            {false, Reason}
    end.

%% @spec ascend_skill(Role, SkillId) -> {ok, NewRole} || {false, Reason}
%% Role = NewRole = #role{}
%% SkillId = integer()
%% Reason = bitstring()
%% @doc 技能飞升
ascend_skill(#role{pet = #pet_bag{active = undefined}}, _SkillId) ->
    {false, ?L(<<"当前没有出战仙宠">>)};
ascend_skill(#role{pet = #pet_bag{active = #pet{ascended = 0}}}, _SkillId) ->
    {false, ?L(<<"出战仙宠尚未飞升，不能进行技能飞升">>)};
ascend_skill(Role = #role{pet = PetBag = #pet_bag{active = Pet = #pet{skill = Skills}}}, SkillId) ->
    case pet_data_skill:get(SkillId) of
        {ok, AscendSkill = #pet_skill{name = SkillName}} ->
            case do_ascend_skill(Skills, AscendSkill) of
                {ok, NewSkill, OldSkillId} ->
                    NewSkills = lists:keyreplace(OldSkillId, 1, Skills, NewSkill),
                    NewPet = pet_api:reset(Pet#pet{skill = NewSkills}, Role),
                    NewPetBag = PetBag#pet_bag{active = NewPet},
                    RoleName = notice:role_to_msg(Role),
                    PetName = pet_to_msg(Role, NewPet),
                    pet_api:push_pet(refresh, [NewPet], Role),
                    notice:send(52, util:fbin(?L(<<"玩家~s的宠物~s真是得天独厚，居然学会了{str, ~s, #ff9600}技能">>), [RoleName, PetName, SkillName])),
                    Msg = util:fbin(?L(<<"出战仙宠成功学会 ~s">>), [SkillName]),
                    {ok, Role#role{pet = NewPetBag}, Msg};
                {add, NewSkill, OldSkillId} ->
                    NewSkills = lists:keyreplace(OldSkillId, 1, Skills, NewSkill),
                    NewPet = pet_api:reset(Pet#pet{skill = NewSkills}, Role),
                    NewPetBag = PetBag#pet_bag{active = NewPet},
                    pet_api:push_pet(refresh, [NewPet], Role),
                    Msg = util:fbin(?L(<<"您的宝宝的[~s]技能增加10点经验">>), [SkillName]),
                    {ok, Role#role{pet = NewPetBag}, Msg};
                {false, Why} ->
                    {false, Why}
            end;
        _ ->
            {false, ?L(<<"没有对应的技能">>)}
    end.

%% @spec combat_ascend_skill(Role) -> {ok, NewRole} | {ok}
%% Role = NewRole = #role{}
%% @doc 战斗中获得技能飞升
combat_ascend_skill(#role{pet = #pet_bag{active = undefined}}) ->
    {ok};
combat_ascend_skill(#role{pet = #pet_bag{active = #pet{ascended = 0}}}) ->
    {ok};
combat_ascend_skill(Role = #role{pid = Pid, pet = PetBag = #pet_bag{active = Pet = #pet{skill = Skills}}}) ->
    case get_ascendable_skill(Skills, []) of
        none ->
            {ok};
        SkillId ->
            case pet_data_skill:get(SkillId) of
                {ok, AscendSkill = #pet_skill{name = SkillName}} ->
                    case do_ascend_skill(Skills, AscendSkill) of
                        {ok, NewSkill, OldSkillId} ->
                            NewSkills = lists:keyreplace(OldSkillId, 1, Skills, NewSkill),
                            NewPet = pet_api:reset(Pet#pet{skill = NewSkills}, Role),
                            NewPetBag = PetBag#pet_bag{active = NewPet},
                            RoleName = notice:role_to_msg(Role),
                            PetName = pet_to_msg(Role, NewPet),
                            pet_api:push_pet(refresh, [NewPet], Role),
                            notice:send(52, util:fbin(?L(<<"玩家~s的宠物~s真是资质过人，战斗后居然领悟了{str, ~s, #ff9600}技能">>), [RoleName, PetName, SkillName])),
                            mail_mgr:deliver(Role, {?L(<<"仙宠技能飞升">>), util:fbin(?L(<<"可喜可贺，您的宠物在战斗后领悟了[~s]技能！">>), [SkillName]), [], []}),
                            notice:inform(Pid, util:fbin(?L(<<"仙宠~s成功学会 ~s">>), [PetName, SkillName])),
                            {ok, Role#role{pet = NewPetBag}};
                        {false, _Why} ->
                            {ok}
                    end;
                _ ->
                    {ok}
            end
    end.

%%---------------------------------------------------
%% 内部方法
%%---------------------------------------------------

%% 获取可以飞升的技能
get_ascendable_skill([], []) -> none;
get_ascendable_skill([], Skills) -> 
    R = util:rand(1, 1000000),
    case util:rand_list(Skills) of
        110000 when 1 >= R -> 110401;
        111000 when 1 >= R -> 111401;
        112000 when 1 >= R -> 112401;
        113000 when 1 >= R -> 113401;
        114000 when 5 >= R -> 114401;
        117000 when 1 >= R -> 117401;
        118000 when 5 >= R -> 118401;
        119000 when 5 >= R -> 119401;
        120000 when 5 >= R -> 120401;
        121000 when 1 >= R -> 121401;
        130000 when 1 >= R -> 130401;
        140000 when 5 >= R -> 140401;
        150000 when 1 >= R -> 150401;
        180000 when 1 >= R -> 180401;
        190000 when 5 >= R -> 190401;
        200000 when 1 >= R -> 200401;
        300000 when 1 >= R -> 300401;
        400000 when 1 >= R -> 400401;
        _ -> none
    end;
get_ascendable_skill([{SkillId, _Exp, _Args} | T], Skills) -> 
    case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{step = 3, mutex = Mutex}} ->
            get_ascendable_skill(T, [Mutex| Skills]);
        _ ->
            get_ascendable_skill(T, Skills)
    end.

%% 技能飞升处理
do_ascend_skill([], _) -> 
    {false, ?L(<<"没有对应的三阶技能">>)};
do_ascend_skill([{SkillId, Exp, Args} | T], Skill = #pet_skill{id = NewId, mutex = Mutex}) ->
    case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{mutex = Mutex, step = 4, next_id = 0}} ->
            {false, ?L(<<"该技能已经满级了">>)};
        {ok, #pet_skill{mutex = Mutex, step = 4}} ->
            {add, {SkillId, Exp + 10, Args}, SkillId};
        {ok, #pet_skill{mutex = Mutex, step = 3}} ->
            {ok, {NewId, Exp, Args}, SkillId};
        _ ->
            do_ascend_skill(T, Skill)
    end.

%% 飞升处理
do_ascend(#pet{ascended = 1, ascend_num = 19}, _Role, _ItemId) ->
    {false, ?L(<<"仙宠最多只能使用20个飞升金丹">>)};
do_ascend(Pet = #pet{ascended = Ascended, ascend_num = AscendNum, lev = Lev}, Role, ItemId) ->
    role:send_buff_begin(),
    case role_gain:do([#loss{label = item_id, val = [{ItemId, 1}]}], Role) of
        {ok, NewRole} ->
            case {Ascended, Lev >= 50} of
                {0, true} ->
                    %% 满足条件还没飞升的就飞升一个
                    role:send_buff_flush(),
                    {up, Pet#pet{ascended = 1}, NewRole};
                {0, _}  ->
                    role:send_buff_clean(),
                    {false, ?L(<<"您的仙宠不足50级，暂时无法使用飞升金丹">>)};
                _ ->
                    %% 其他情况都是加属性
                    NewAscendNum = AscendNum + 1,
                    NewPet = Pet#pet{ascend_num = NewAscendNum},
                    NP = pet_api:reset(NewPet, Role),
                    role:send_buff_flush(),
                    {add, NP, NewAscendNum, NewRole}
            end;
        _ ->
            role:send_buff_clean(),
            {false, ?L(<<"没有仙宠飞升金丹">>)}
    end.

%% 宠物数据转换成物品
do_pet_to_item(#pet{bind = Bind, skill = Skills, attr = #pet_attr{avg_val = Avg}}) ->
    case [SkillId || {SkillId, SkillExp, _Args} <- Skills, SkillExp =/= 0] of
        [] ->
            {false, ?L(<<"宠物没有技能经验,不可练魂">>)};
        _ ->
            ItemBaseId = if 
                Avg >= 81 -> 23019; %% 橙魂
                Avg >= 70 -> 23018; %% 紫魂
                Avg >= 60 -> 23017; %% 蓝魂
                Avg >= 41 -> 23016; %% 绿魂
                true -> 23015       %% 白魂
            end,
            case item:make(ItemBaseId, Bind, 1) of
                false -> {false, ?L(<<"物品不存在">>)};
                {ok, Items} -> {ok, Items}
            end
    end.

%% 宠物升级处理
do_upgrade(Pet = #pet{lev = PetLev, exp = Exp}, RoleLev, Flag) ->
    case pet_data_exp:get(PetLev) of
        NeedExp when NeedExp > 0 andalso RoleLev > PetLev andalso Exp >= NeedExp -> %% 可升级
            NewPet = Pet#pet{lev = PetLev + 1, exp = Exp - NeedExp},
            do_upgrade(NewPet, RoleLev, true);
        NeedExp when PetLev >= RoleLev andalso Exp > NeedExp -> %% 宠物等级与人物等级一致 且经验溢出
            {Flag, Pet#pet{exp = NeedExp}};
        _ -> %% 不可升级
            {Flag, Pet} 
    end.

%% 获取没有满级的技能
skill_lev_no_full([], L) -> L;
skill_lev_no_full([{SkillId, Exp, Args} | T], L) ->
    case pet_data_skill:get(SkillId) of
        {ok, #pet_skill{next_id = 0}} -> 
            skill_lev_no_full(T, L);
        _ ->
            skill_lev_no_full(T, [{SkillId, Exp, Args} | L])
    end.

%% 每天限制数量
everyday_limit_num(?pet_log_type_free_egg) -> 1;
everyday_limit_num(?pet_log_type_bless) -> 10;
everyday_limit_num(?pet_log_type_send_bless) -> 20;
everyday_limit_num(?pet_log_type_magic) -> 2;
everyday_limit_num(_) -> 0.


%% 重新计算出战宠物数据
% refresh_war_pet(Pet = #pet{lev = PLev, exp = Exp, happy_val = HV}, PetBag = #pet_bag{exp_time = ExpTime, last_time = LTime}) ->
%     Now = util:unixtime(),
%     T = Now - LTime,
%     HVPer = if
%         PLev =< 20 -> 1;
%         PLev < 40 -> PLev / 20;
%         true -> 2
%     end,
%     NewHV = inc_value(HV, erlang:round(T / ?pet_happy_time * HVPer)),
%     NeedExp = pet_data_exp:get(PLev),
%     NewPet = case Exp >= NeedExp of
%         true -> 
%             Pet#pet{exp = NeedExp, happy_val = NewHV};
%         false ->
%             NewExp = Exp + erlang:round(T * ExpTime / 100),
%             Pet#pet{exp = NewExp, happy_val = NewHV}
%     end,
%     {ok, NewPet, PetBag#pet_bag{last_time = Now}};
refresh_war_pet(Pet, PetBag) -> 
    {ok, Pet, PetBag}.

%% 两数相减，小于0则为0
% inc_value(Val, V) ->
%     NewVal = Val - V,
%     case NewVal < 0 of
%         true -> 0;
%         false -> NewVal
%     end.

%% 处理宠物外观变化
do_reset_baseid(#pet{evolve = Evo}, Type) when Type > Evo ->
    {false, ?L(<<"仙宠尚未进化到该级别！不能选择该形象！">>)};
do_reset_baseid(Pet = #pet{base_id = OldBaseId}, Type) ->
    NewBaseId = pet_data:get_next_baseid(Type, OldBaseId),
    {ok, Pet#pet{base_id = NewBaseId}}.

%% 获取刷新单价
get_refresh_gold(?pet_egg_green, 0) -> {1, pay:price(?MODULE, pet_egg_green, 0)};
get_refresh_gold(?pet_egg_green, 1) -> {12, pay:price(?MODULE, pet_egg_green, 1)};
get_refresh_gold(?pet_egg_blue, 0) -> {1, pay:price(?MODULE, pet_egg_blue, 0)};
get_refresh_gold(?pet_egg_blue, 1) -> {12, pay:price(?MODULE, pet_egg_blue, 1)};
get_refresh_gold(?pet_egg_purple, 0) -> {1, pay:price(?MODULE, pet_egg_purple, 0)};
get_refresh_gold(?pet_egg_purple, 1) -> {12, pay:price(?MODULE, pet_egg_purple, 1)};
get_refresh_gold(?pet_egg_orange, 0) -> {1, pay:price(?MODULE, pet_egg_orange, 0)};
get_refresh_gold(?pet_egg_orange, 1) -> {12, pay:price(?MODULE, pet_egg_orange, 1)};
get_refresh_gold(?pet_egg_golden, 0) -> {1, pay:price(?MODULE, pet_egg_golden, 0)};
get_refresh_gold(?pet_egg_golden, 1) -> {12, pay:price(?MODULE, pet_egg_golden, 1)};
get_refresh_gold(_, _) -> {false, ?L(<<"刷新类型不正确">>)}.

%% 根据物品获取刷新类型
get_item_refresh_type(?pet_egg_green) -> ?pet_type_green; %% 仙宠蛋（绿）
get_item_refresh_type(?pet_egg_blue) -> ?pet_type_blue; %% 仙宠蛋（蓝）
get_item_refresh_type(?pet_egg_purple) -> ?pet_type_purple; %% 仙宠蛋（紫）
get_item_refresh_type(?pet_egg_orange) -> ?pet_type_orange; %% 仙宠蛋（橙）
get_item_refresh_type(?pet_egg_golden) -> ?pet_type_golden; %% 仙宠蛋（金）
get_item_refresh_type(_) -> {false, ?L(<<"物品类型不正确">>)}.


%%技能槽数配置    
% 宠物平均潜力    技能槽数
      % 120           2
      % 240           3
      % 320           4
      % 480           5
      % 600           6
      % 800           7
      % 1000          8
      % 1200          10

% 240 320 480 600 800 1000 1200

get_alloc_slots(Pet) ->
    Avg = pet_attr:calc_avg_potential(Pet),
    Will_Have = pet_api:get_slot(Avg),
    Used = get_used_slot(Pet#pet.skill, []),
    All_Have = Used ++ Pet#pet.skill_slot,
    case Will_Have - erlang:length(All_Have)  of 
        0 -> 
            {0, Pet};
        1 ->
            L = lists:seq(1, 10) -- All_Have,
            N = lists:nth(1, L),
            NSkill_Slot = [N] ++ Pet#pet.skill_slot,
            {1, Pet#pet{skill_slot = NSkill_Slot}};
        2 -> 
            NSkill_Slot = [9, 10] ++ Pet#pet.skill_slot,
            NSkill_Slot1 = lists:sort(NSkill_Slot),
            {2, Pet#pet{skill_slot = NSkill_Slot1}};
        N ->  %% GM命令使用
            case N > 0 of 
                true ->
                    L = lists:last(lists:sort(All_Have)),
                    ?DEBUG("----H----~p~n", [L]),
                    {0, Pet#pet{skill_slot = Pet#pet.skill_slot ++ lists:seq(L + 1, Will_Have)}};
                false ->
                    {0, Pet}
            end
    end.

%% 获得已用技能槽
get_used_slot([], L) ->L;
get_used_slot([{_, _, Num, _}|T], L) ->
    get_used_slot(T, [Num|L]).


