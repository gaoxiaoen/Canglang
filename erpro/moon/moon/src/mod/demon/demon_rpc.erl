%%----------------------------------------------------
%% 角色相关远程调用
%% @author wpf(wprehard@qq.com)
%%----------------------------------------------------
-module(demon_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("demon.hrl").
-include("item.hrl").
-include("storage.hrl").

%% 等级屏蔽
handle(17200, {}, #role{lev = Lev}) when Lev < 60 -> {ok};

%% 请求精灵守护信息
handle(17200, {}, Role = #role{demon = RoleDemon}) ->
    demon_api:pack_and_send(17200, RoleDemon, Role),
    {ok};

%% 请求查看精灵守护信息
handle(17205, {Id, SrvId}, #role{id = {Id, SrvId}, demon = RoleDemon, link = #link{conn_pid = ConnPid}}) ->
    demon_api:pack_and_send(17205, RoleDemon, ConnPid),
    {ok};
handle(17205, {Id, SrvId}, #role{link = #link{conn_pid = ConnPid}}) ->
    case role:check_cd(role_17205, 3) of
        false -> {ok};
        true ->
            case role_api:c_lookup(by_id, {Id, SrvId}, #role.demon) of
                {ok, _, RoleDemon} ->
                    demon_api:pack_and_send(17205, RoleDemon, ConnPid);
                _ -> ignore
            end,
            {ok}
    end;

%% 激活守护
handle(17210, _, #role{event = Event}) when Event =:= ?event_arena_match orelse Event =:= ?event_arena_prepare ->
    {reply, {0, ?false, ?L(<<"竞技活动中不能激活守护">>)}};
handle(17210, _, #role{event = Event}) when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
    {reply, {0, ?false, ?L(<<"仙道斗法活动中不能激活守护">>)}};
handle(17210, _, #role{event = Event}) when Event =:= ?event_cross_king_prepare orelse Event =:= ?event_cross_king_match ->
    {reply, {0, ?false, ?L(<<"至尊王者活动中不能激活守护">>)}};
handle(17210, _, #role{event = Event}) when Event =:= ?event_top_fight_match orelse Event =:= ?event_top_fight_prepare ->
    {reply, {0, ?false, ?L(<<"巅峰对决活动中不能激活守护">>)}};
handle(17210, {1, DemonId}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
    case demon:activate(DemonId, Role) of
        {ok} -> {ok};
        {false, Msg} ->
            {reply, {DemonId, ?false, Msg}};
        {ok, NewRole} ->
            {ok, NewRole}
    end;
handle(17210, {0, DemonId}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
    case demon:unactivate(DemonId, Role) of
        {ok} -> {ok};
        {false, Msg} -> {reply, {DemonId, ?false, Msg}};
        {ok, NewRole} -> {reply, {DemonId, ?true, ?L(<<"已取消守护激活">>)}, NewRole}
    end;

%% 升级守护技能
%% handle(17211, {DemonId, SkillId}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
%%     case demon:up_skill(DemonId, SkillId, Role) of
%%         {false, Msg} ->
%%             {reply, {?false, Msg}};
%%         {ok, NewRole} ->
%%             {reply, {?true, <<"精灵守护技能升级成功">>}, NewRole}
%%     end;

%% 洗髓
handle(17212, {DemonId, LockList}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
    LL = [#loss{label = item, val = [27506, 1, 1], msg = ?L(<<"背包没有守护洗髓丹">>)}
        ,#loss{label = coin_all, val = 5000, msg = ?L(<<"金币不足">>)}
    ] ++ lock_loss(Role, length(LockList)),
    role:send_buff_begin(),
    case role_gain:do(LL, Role) of
        {false, #loss{msg = Msg}} ->
            role:send_buff_clean(),
            {reply, {?false, Msg}};
        {ok, Role1} ->
            case demon:polish_craft(DemonId, LockList, Role1) of
                {false, Msg} ->
                    role:send_buff_clean(),
                    {reply, {?false, Msg}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    notice:inform(?L(<<"守护洗髓\n消耗 金币5000">>)),
                    log:log(log_coin, {<<"守护洗髓">>, <<>>, Role, NewRole}),
                    {reply, {?true, <<>>}, NewRole}
            end
    end;

%% 喂养
handle(17213, {}, Role) ->
    case demon:feed(Role) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        {ok, NewRole} ->
            {ok, NewRole}
    end;

%% 增加亲密度
handle(17214, {_DemonId, []}, _Role) -> {ok};
handle(17214, {DemonId, ItemList}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
    case demon:add_intimacy(DemonId, ItemList, Role) of
        {false, Msg} -> {reply, {?false, Msg, DemonId, 0}};
        {ok, NowInti, NewRole} ->
            {reply, {?true, <<>>, DemonId, NowInti}, NewRole}
    end;

%% 守护跟随
handle(17215, {DemonId}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
    case demon:follow(DemonId, Role) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        {ok, NewRole} ->
            {reply, {?true, <<>>}, NewRole}
    end;

%% 守护双修
handle(17216, {DemonId}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
    case demon:both_sit(DemonId, Role) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        {ok, NewRole} ->
            {reply, {?true, <<>>}, NewRole}
    end;

%% 批量洗髓预览
handle(17220, {2, DemonId, _LockList}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
    case demon:get_polish_list(DemonId, Role) of
        {false, Msg} -> {reply, {?false, Msg, []}};
        {ok, PL} ->
            demon_api:pack_and_send(17220, PL, Role),
            {ok}
    end;
%% 批量洗髓
handle(17220, {0, _DemonId, _LockList}, _Role) -> {ok};
handle(17220, {1, DemonId, LockList}, Role) when DemonId >= 1 andalso DemonId =< 5 ->
    BaseDels = [{27506, 6}],
    NeedCoin = 5000*6,
    LockNum = length(LockList) * 6,
    case storage:get_del_base_bindlist(Role, BaseDels, [], []) of
        {false, Reason} -> {reply, {?false, Reason, []}};
        {ok, DelList, _} ->
            LL = [
                #loss{label = coin_all, val = NeedCoin, msg = ?L(<<"金币不足">>)}
                ,#loss{label = item_id, val = DelList, msg = ?L(<<"背包洗髓丹不足">>)}
            ] ++ lock_loss(Role, LockNum),
            role:send_buff_begin(),
            case role_gain:do(LL, Role) of
                {false, #loss{err_code = ErrCode, msg = Msg}} ->
                    role:send_buff_clean(),
                    {reply, {ErrCode, Msg, []}};
                {ok, Role1} ->
                    case demon:polish_craft_list(DemonId, LockList, Role1) of
                        {false, Msg} ->
                            role:send_buff_clean(),
                            {reply, {?false, Msg, []}};
                        {ok, PL, NewRole} ->
                            role:send_buff_flush(),
                            notice:inform(?L(<<"守护洗髓\n消耗 金币30000">>)),
                            log:log(log_coin, {<<"守护洗髓">>, <<"批洗">>, Role, NewRole}),
                            demon_api:pack_and_send(17220, PL, NewRole),
                            {ok, NewRole}
                    end
            end
    end;

%% 选定洗髓属性
handle(17221, {DemonId, PolishId}, Role) ->
    case demon:select_polish(DemonId, PolishId, Role) of
        {false, Msg} -> {reply, {?false, Msg}};
        {ok, NewRole} ->
            {reply, {?true, <<>>}, NewRole}
    end;

%% 请求技能刷新列表
handle(17225, {0}, Role) ->
    demon:polish_skill(0, Role),
    {ok};
handle(17225, {PolishType}, Role) when PolishType >= 1 andalso PolishType =< 4 ->
    LL = if
        PolishType =:= 1 ->
            [#loss{label = coin_all, val = ?POLISH_SKILL_COIN, msg = ?L(<<"金币不足">>)}];
        PolishType =:= 3 ->
            [#loss{label = coin_all, val = ?BATCH_POLISH_SKILL_COIN, msg = ?L(<<"金币不足">>)}];
        PolishType =:= 2 ->
            [#loss{label = gold, val = ?POLISH_SKILL_GOLD, msg = ?L(<<"晶钻不足">>)}];
        PolishType =:= 4 ->
            [#loss{label = gold, val = ?BATCH_POLISH_SKILL_GOLD, msg = ?L(<<"晶钻不足">>)}];
        true -> []
    end,
    case role_gain:do(LL, Role) of
        {false, #loss{err_code = ErrCode, msg = Msg}} ->
            {reply, {ErrCode, Msg, 0, 0, []}};
        {ok, Role1} ->
            {ok, NewRole} = demon:polish_skill(PolishType, Role1),
            log:log(log_coin, {<<"刷新神通">>, <<>>, Role, NewRole}),
            {ok, NewRole}
    end;

%% 操作技能刷新列表和背包
handle(17226, {Mode, SelectId, DemonId}, Role) when Mode >= 1 andalso Mode =< 3 ->
    case demon:select_skill(Mode, SelectId, DemonId, Role) of
        {false, Msg} -> {reply, {?false, Msg}};
        {ok, NewRole} -> {reply, {?true, <<>>}, NewRole};
        {ok, Msg, NewRole} -> {reply, {?true, Msg}, NewRole}
    end;

%% 丢弃背包守护技能
handle(17227, {0, OpId}, Role) ->
    case demon:forget_skill(0, OpId, Role) of
        {false, Msg} -> {reply, {?false, Msg}};
        {ok, NewRole} -> {reply, {?true, <<>>}, NewRole}
    end;
%% 遗忘守护技能
handle(17227, {DemonId, SkillId}, Role) ->
    case demon:forget_skill(DemonId, SkillId, Role) of
        {false, Msg} -> {reply, {?false, Msg}};
        {ok, NewRole} -> {reply, {?true, <<>>}, NewRole}
    end;

%% 请求守护技能背包
handle(17228, {}, #role{demon = #role_demon{skill_bag = SkillBag}}) ->
    {reply, {SkillBag}};

%% 守护化形进阶
handle(17229, {DemonId}, Role) ->
    case demon:upgrade_shape(Role, DemonId) of
        {up, NewShapeLev, NewRole} -> {reply, {?true, util:fbin(?L(<<"守护化形成功提升到~w阶">>), [NewShapeLev])}, NewRole};
        {full, NewRole} -> {reply, {2, ?L(<<"守护化形值已满，赶快进阶吧">>)}, NewRole};
        {ok, AddLuck, NewRole} -> {reply, {?true, util:fbin(?L(<<"守护增加~w化形值">>), [AddLuck])}, NewRole};
        step_lower -> {reply, {?false, ?L(<<"精灵守护等阶还不满15阶，不能进行化形">>)}};
        max_lev -> {reply, {?false, ?L(<<"守护的化形已经是最高阶了">>)}};
        demon_not_found -> {reply, {?false, ?L(<<"没有找到对应的守护">>)}};
        item_less -> {reply, {?false, ?L(<<"没有找到对应的守护化形丹">>)}};
        coin_less -> {reply, {?coin_less, ?L(<<"没有找到对应的守护化形丹">>)}};
        {ok, NewRole} -> {reply, {?true, <<>>}, NewRole}
    end;

%%获取已有契约兽信息
handle(17235, {}, Role) ->
    demon_api:push_demon(Role),
    {ok};


%%召唤一只契约兽
handle(17236, {DemonBaseId}, Role = #role{id = {Rid, _}, link = #link{conn_pid = ConnPid}, demon = RoleDemon = #role_demon{active = _Active, op_id = Next_Id, bag = Bag, shape_skills = HadDebris}}) ->
    %%需要加入消耗逻辑
    case demon_data2:get_demon_base(DemonBaseId) of 
        {ok, Demon} when is_record(Demon, demon2) ->
            #demon2{debris = Debris, debris_num = Num} = Demon,
            Weight = demon_data2:get_wake_weight(Debris),
            Rand  = util:rand(1, 100),
            ActDemon = #demon2{base_id = ActBaseId, name = DemonName} = 
                case Rand >= Weight of 
                    true ->
                        {ok, Demon1} = demon_data2:get_demon_base(100000 + DemonBaseId),
                        Demon1;
                    false ->
                        Demon
                end,

            case lists:keyfind(Debris, 1, HadDebris) of 
                {_, Had} ->
                    case Had >= Num of 
                        true ->
                            Id = Next_Id,
                            NDemon = demon_api:reset(ActDemon#demon2{id = Id}), 
                            NBag = [NDemon|Bag],
                            NHadDebris = lists:keyreplace(Debris, 1, HadDebris, {Debris, Had - Num}),
                            NRole = Role#role{demon = RoleDemon#role_demon{bag = NBag, op_id = Next_Id + 1, shape_skills = NHadDebris}},

                            demon_api:push_demon(NRole, NDemon), %%刷新已有的契约兽信息,需要优化为刷一只兽
                            demon_api:push_debris(Role, NRole),

                            demon_debris_mgr:update_role_debris(NRole), %% 更新碎片
                            Msg = get_alert_message(Rid, ActBaseId, DemonName),

                            NRole1 = demon_debris_mgr:update_role_demon(NRole, ActBaseId), %% 更新新增的兽
                            
                            random_award:monsters_contract(NRole1),
                            random_award:monster_contract(NRole1, ActBaseId),
                            notice:alert(succ, ConnPid, Msg),

                            log:log(log_demon2, {<<"妖精召唤">>, util:fbin("~w", [ActBaseId]), 0, 0, NRole1}),

                            NRole2 = role_listener:special_event(NRole1, {1075, DemonBaseId}),  %% 获得怪兽，触特殊事件。暂时远方来信用到
                            NRole3 = medal:listener(monster, NRole2),
                            {reply, {}, NRole3};
                        false ->
                            notice:alert(error, ConnPid, ?MSGID(<<"碎片不足!">>)),
                            {ok}
                    end;
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"没有该类型碎片!">>)),
                    {ok}
            end;
        _ ->
            notice:alert(error, ConnPid, ?MSGID(<<"妖精不存在!">>)),
            {ok}
    end;

%%出战一只契约兽
% handle(17237, {_Id}, _Role = #role{link = #link{conn_pid = ConnPid}, lev = Lev}) when Lev < 28 ->
%     notice:alert(error, ConnPid, ?MSGID(<<"等级不足">>)),
%     {ok};

handle(17237, {Id}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case demon:active_demon(Id, Role) of 
        {ok, NRole} ->
            notice:alert(error, ConnPid, ?MSGID(<<"出战妖精成功!">>)),
            {ok, NRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok};
        _ ->
            {ok}
    end;

%%收回出战契约兽
handle(17238, {}, #role{link = #link{conn_pid = ConnPid}, demon = #role_demon{active = 0}}) ->
    notice:alert(error, ConnPid, ?MSGID(<<"当前没有出战的妖精">>)),
    {ok};
handle(17238, {}, Role = #role{link = #link{conn_pid = ConnPid}, special = Special, demon = RoleDemon = #role_demon{active = Demon, bag = Bag}}) when is_record(Demon, demon2)->
    #demon2{id = Id} = Demon,
    case lists:keyfind(Id, #demon2.id, Bag) of 
        Demon1 when is_record(Demon1, demon2) ->
            notice:alert(error, ConnPid, ?MSGID(<<"收回妖精失败">>)),
            {ok};
        _ ->
            NDemon = Demon#demon2{mod = 0}, 
            NBag = [NDemon] ++ Bag,
            NSpecial = lists:keydelete(?special_demon, 1, Special),
            NRole = Role#role{special = NSpecial, demon = RoleDemon#role_demon{active = 0, bag = NBag}},
            {NRole1, NewDemon, NeedRefresh} = demon_api:deal_del_buff(NRole, NDemon),
            sys_conn:pack_send(ConnPid, 17238, {}),
            NRole2 = 
                case NeedRefresh of 
                    true -> 
                        demon_api:push_demon(NRole1, NewDemon),
                        % NBag3 = NBag2 -- [NDemon],
                        % NBag4 = [NewDemon] ++ NBag3,
                        % NRole3 = NRole1#role{demon = RoleDemon1#role_demon{bag = NBag4}},
                        role_api:push_attr(NRole1);
                    false ->
                        NRole1
                end,
            demon_api:refresh_role_special(NRole2),
            notice:alert(succ, ConnPid, ?MSGID(<<"收回妖精成功">>)),
            {ok, NRole2}
    end;

%%吞噬
%% @spec Parms ::{[K,V]}, 
%% @spec K:: int 契约兽的id, 物品base_id  
%% @spec V :: int  兽或者物品的个数
handle(17239, {_DemonId, Parms}, #role{link = #link{conn_pid = ConnPid}}) when not is_list(Parms) ->
    notice:alert(error, ConnPid, ?MSGID(<<"数据格式有误">>)),
    {ok};

handle(17239, {DemonId, Parms}, Role = #role{link = #link{conn_pid = ConnPid}, demon = #role_demon{active= Demon, shape_skills = HadDebris}})->
    ?DEBUG("---Parms--~p~n", [Parms]),
    ActiveId = 
        case is_record(Demon, demon2) of 
            true ->
                Demon#demon2.id;
            _ -> 0
        end,
    Demons = [K||[K, _] <- Parms, K rem 100000 =:= K],
    Debris = [{K1, V1}||[K1, V1] <- Parms, K1 > 99999],
    case {Demons, Debris} of 
        {[], []} ->
            notice:alert(error, ConnPid, ?MSGID(<<"吞噬材料不能为空！">>)),
            {ok};
        _ -> 
            case lists:member(ActiveId, Demons) of 
                false ->
                    case check_num(Debris, HadDebris) of 
                        true ->
                            case demon:devour(DemonId, {Demons, Debris}, Role) of 
                                {ok, NRole} ->
                                    ?DEBUG("--Finish Devour--"),
                                    NRole1 = medal:listener(monster, NRole),
                                    {reply, {}, NRole1};
                                {false, Reason}->
                                    notice:alert(error, ConnPid, Reason),
                                    {ok}
                            end;
                        false ->
                            notice:alert(error, ConnPid, ?MSGID(<<"碎片数量有误！">>)),
                            {ok}
                    end;        
                _ ->
                    notice:alert(error, ConnPid, ?MSGID(<<"出战妖精不能被吞噬！">>)),
                    {ok}
            end
    end;

%%获取(推送)碎片数量信息
handle(17240, {}, Role) ->
    demon_api:push_debris(Role),
    {ok};

%%进入掠夺面板， 换一批对手
handle(17242, {DebrisId}, Role = #role{lev = Lev, link = #link{conn_pid = ConnPid}, demon = #role_demon{grab_times = {GrabTimes, BuyTimes}}}) ->
    case Lev < 32 of 
        true ->
            notice:alert(error, ConnPid, ?MSGID(<<"等级不足">>)),
            {ok};
        false ->
            case demon_data2:get_grab_info(DebrisId) of 
                1 ->
                    notice:alert(error, ConnPid, ?MSGID(<<"该碎片不能掠夺！">>)),
                    {ok};    
                _ -> 
                    case demon:grab(Role, DebrisId) of 
                        {false, Reason} ->
                            notice:alert(error, ConnPid, Reason),
                            {ok};
                        Reply ->
                            {reply, {GrabTimes, BuyTimes, Reply}}
                    end
            end
    end;

handle(17243, {}, _Role) ->
    demon:flush(),
    {ok};

%% @doc 妖精升级
handle(17244, {DemonId, Is_Auto}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
     case demon:upgrade_once(DemonId, Is_Auto, Role) of 
        {ok, NRole} ->
            {ok, NRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok};
        _ ->
            {ok}
    end;

%% @doc 升到下一级
handle(17245, {DemonId, Is_Auto}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case demon:upgrade_batch(DemonId, Is_Auto, Role) of 
        {ok, NRole} ->
            {ok, NRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {ok};
        _ ->
            {ok}
    end;

%% @doc 献祭
handle(17246, {MDemonId, SDemonId}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case demon:devour2(MDemonId, SDemonId, Role) of 
        {ok, NRole} ->
            {reply, {1}, NRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {reply, {0}};
        _ ->
            {reply, {0}}
    end;

%% @doc 升星
handle(17247, {MDemonId}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case demon:upgrade_grow(MDemonId, Role) of 
        {ok, NRole} ->
            {reply, {1}, NRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            {reply, {0}};
        _ ->
            {reply, {0}}
    end;

%% 发起掠夺战斗
handle(17250, _, Role = #role{demon = #role_demon{grab_times = {GrabTimes, _}}}) when GrabTimes =< 0 ->
    notice:alert(error, Role, ?MSGID(<<"今天您的掠夺次数已经用完了">>)),
    {reply, {?false}};
handle(17250, {Type, TRoleId, TSrvId}, Role) ->
    case demon:get_target_name(Type, TRoleId, TSrvId) of
        {ok, TRoleName} ->
            case demon_challenge:start(Type, TSrvId, TRoleId, TRoleName, Role) of
                {ok, NewRole} ->
                    #role{demon = RoleDemon = #role_demon{grab_times = {GrabTimes, BuyTimes}}} = NewRole,
                    {reply, {?true}, NewRole#role{demon = RoleDemon#role_demon{grab_times = {GrabTimes - 1, BuyTimes}}}};
                {error, ErrMsg, NewRole} ->
                    notice:alert(error, NewRole, ErrMsg),
                    {reply, {?false}, NewRole}
            end;
        _ ->
            ?DEBUG("找不到掠夺对象的名字~n~n~n"),
            {reply, {?false}, Role}
    end;

%% 离开战斗场景
handle(17251, _, Role) ->
    NewRole = demon_challenge:leave_map(Role),
    {ok, NewRole};

%% 购买掠夺次数
handle(17252, _, Role = #role{demon = Demon = #role_demon{grab_times = {GrabTimes, BuyTimes}}}) ->
    case demon_grab_times:get(BuyTimes + 1) of 
        {Loss, Times} when is_list(Loss)->
            case role_gain:do(Loss, Role) of
                {ok, NRole} -> 
                    NRole1 = NRole#role{demon = Demon#role_demon{grab_times = {GrabTimes + Times, BuyTimes + 1}}},
                    {reply, {?true}, NRole1};
                {false, #loss{msg = Msg, err_code = _ErrCode}} ->
                    notice:alert(error, Role, Msg),
                    {ok}
            end;
        _ -> 
            notice:alert(error, Role, ?MSGID(<<"今日购买次数已用完！">>)),
            {ok}
    end;

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% -----------------------------------------------------
%% 内部处理
%% -----------------------------------------------------

check_num([], _HadDebris) -> true;
check_num([{ItemId, Num}|T], HadDebris) ->
    case lists:keyfind(ItemId, 1, HadDebris) of 
        {_, Had} when Had >= Num ->
            check_num(T, HadDebris);
        _ -> 
            false
    end.

get_alert_message(Rid, DemonBaseId, DemonName) ->
    HadDemons = demon_debris_mgr:get_role_demon(Rid),
    {Gt, First, Accord} = 
        case DemonBaseId > 100000 of
            true ->
                {true, [D||D <- HadDemons, D =:= DemonBaseId], [D1||D1 <- HadDemons, (D1 - 100000) =:= DemonBaseId]};
            false ->
                {false, [D0||D0 <- HadDemons, D0 =:= DemonBaseId], [D2||D2 <- HadDemons, D2 =:= (DemonBaseId + 100000)]}
        end,
    case {Gt, erlang:length(First) > 0, erlang:length(Accord) > 0} of
        {true, false, false} -> % 闪耀 第一次出现 未出现普通
            util:fbin(?L(<<"召唤~s成功, 已激活普通和闪耀图鉴加成">>), [DemonName]);
        {true, false, true} -> % 闪耀 第一次出现 已出现普通
            util:fbin(?L(<<"召唤~s成功, 已激活闪耀图鉴加成">>), [DemonName]);
        % {true, true, _} -> % 闪耀 非第一次出现 未出现普通
        {true, true, _} -> % 闪耀 非第一次出现 已出现普通
            util:fbin(?L(<<"召唤闪耀的~s成功">>), [DemonName]);


        {false, false, false} -> % 普通 第一次出现 未出现闪耀
            util:fbin(?L(<<"召唤~s成功, 已激活普通图鉴加成">>), [DemonName]);

        {false, true, false} -> % 普通 非第一次出现 未出现闪耀
            util:fbin(?L(<<"召唤~s成功">>), [DemonName]);


        % {false, _, true} -> % 普通 非第一次出现 出现闪耀
        %     util:fbin(?L(<<"召唤~s成功">>), [DemonName]);
        {false, _, true} -> % 普通 非第一次出现 出现闪耀
            util:fbin(?L(<<"召唤~s成功">>), [DemonName]);

        _ ->
            util:fbin(?L(<<"召唤~s成功">>), [DemonName])
    end.

-define(LOCK_GOLD, pay:price(?MODULE, lock_gold, null)).
%% 洗练锁不足，扣除晶钻
lock_loss(_, LockNum) when LockNum =< 0 -> [];
lock_loss(#role{bag = #bag{items = BagItems}}, LockNum) ->
    HasNum = case storage:find(BagItems, #item.base_id, 33101) of
        {false, _} -> 0;
        {ok, N, _, _, _} -> N
    end,
    if
        HasNum =< 0 ->
            [#loss{label = gold, val = LockNum*?LOCK_GOLD, msg = ?L(<<"晶钻不足">>)}];
        HasNum >= LockNum ->
            [#loss{label = item, val = [33101, 1, LockNum], msg = ?L(<<"洗练锁不足">>)}];
        true ->
            [
                #loss{label = item, val = [33101, 1, HasNum], msg = ?L(<<"洗练锁不足">>)}
                ,#loss{label = gold, val = (LockNum - HasNum)*?LOCK_GOLD, msg = ?L(<<"晶钻不足">>)}
            ]
    end.
