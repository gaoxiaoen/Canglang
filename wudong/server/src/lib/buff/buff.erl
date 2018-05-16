%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% buff
%%% @end
%%% Created : 27. 一月 2015 下午6:34
%%%-------------------------------------------------------------------
-module(buff).
-author("fancy").
-include("common.hrl").
-include("skill.hrl").
-include("battle.hrl").
-include("scene.hrl").

%% API
-export([
    buff_to_eff/2,
    add_buff/5,
    skill_add_buff/4,
    prepare/13,
    add_buff_to_player/2,
    add_buff_to_mon/2,
    add_buff_list_to_player/3,
    add_buff_list_to_player/4,
    add_buff_list_to_mon/2,
    add_buff_list_to_mon/3,
    del_buff/2,
    del_buff_only/2,
    del_buff_list/3,
    del_mon_buff_list/2,
    goods_add_buff/2,
    buff_timeout/4,
    merge_buff_list/2,
    check_clean_buff/1,
    clean_buff_by_subtype/2,
    get_buff_by_subtype/2
]).

%%新增buff
add_buff(BS, BuffList, SkillId, Slv, Attacker) ->
    {OldSkillBuff, NewSkillBuff, StartEffList} = do_add_buff(BS, BuffList, SkillId, Slv, Attacker),
    {BS3, _} = effect:active(StartEffList, BS#bs{buff_list = OldSkillBuff ++ NewSkillBuff}, #bs{}, 1),
    BS3.

%%使用技能增加buff
skill_add_buff(BS, BuffList, SkillId, Slv) ->
    {OldSkillBuff, NewSkillBuff, StartEffList} = do_add_buff(BS, BuffList, SkillId, Slv, #attacker{}),
    OldEffList = BS#bs.eff_list,
    {BS#bs{buff_list = OldSkillBuff ++ NewSkillBuff, eff_list = OldEffList ++ StartEffList}, NewSkillBuff}.


%%战斗外给玩家增加buff
add_buff_to_player(Player, BuffId) ->
    Now = util:unixtime(),
    case data_buff:get(BuffId) of
        [] ->
            Player;
        Buff ->
            if Buff#buff.eff_sign == 0 orelse Buff#buff.eff_sign == ?SIGN_PLAYER ->
                {OldSkillBuff2, NewSkillBuff, StartEffList} = prepare([BuffId], Player#player.node, Player#player.pid, Player#player.scene, 8888, 1, Now, Player#player.buff_list, [], 0, #attacker{}, [], []),
                SkillBuffList = OldSkillBuff2 ++ NewSkillBuff,
                %%buff效果
                Player1 = effect:active_eff(StartEffList, Player, Now),
                {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(SkillBuffList, Now)}),
                server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
                Player2 = Player1#player{buff_list = SkillBuffList},
                scene_agent_dispatch:buff_update(Player2),
                Player2;
                true -> Player
            end
    end.

add_buff_to_mon(Mon, BuffId) ->
    Now = util:unixtime(),
    case data_buff:get(BuffId) of
        [] ->
            Mon;
        Buff ->
            if Buff#buff.eff_sign == 0 orelse Buff#buff.eff_sign == ?SIGN_MON ->
                {OldSkillBuff2, NewSkillBuff, _StartEffList} = prepare([BuffId], node(), Mon#mon.pid, Mon#mon.scene, 8888, 1, Now, Mon#mon.buff_list, [], 0, #attacker{}, [], []),
                SkillBuffList = OldSkillBuff2 ++ NewSkillBuff,
                Mon#mon{buff_list = SkillBuffList};
                true -> Mon
            end
    end.

add_buff_list_to_player(Player, BuffList, BC) ->
    add_buff_list_to_player(Player, BuffList, BC, #attacker{}).

add_buff_list_to_player(Player, BuffList, BC, Attacker) ->
    Now = util:unixtime(),
    F = fun(BuffId, {OldSkillBuff1, EffectList}) ->
        case data_buff:get(BuffId) of
            [] ->
                {OldSkillBuff1, EffectList};
            Buff ->
                if Buff#buff.eff_sign == 0 orelse Buff#buff.eff_sign == ?SIGN_PLAYER ->
                    {OldSkillBuff2, NewSkillBuff, StartEffList1} = prepare([BuffId], Player#player.node, Player#player.pid, Player#player.scene, 8888, 1, Now, OldSkillBuff1, [], 0, Attacker, [], []),
                    {OldSkillBuff2 ++ NewSkillBuff, StartEffList1 ++ EffectList};
                    true ->
                        {OldSkillBuff1, EffectList}
                end
        end
    end,
    {SkillBuffList, StartEffList} =
        lists:foldl(F, {Player#player.buff_list, []}, BuffList),
    %%buff效果
    Player1 = effect:active_eff(StartEffList, Player, Now),
    {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(SkillBuffList, Now)}),
    case BC of
        0 ->
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin);
        _ ->
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    Player2 = Player1#player{buff_list = SkillBuffList},
    scene_agent_dispatch:buff_update(Player2),
    Player2.


add_buff_list_to_mon(Mon, BuffList) ->
    add_buff_list_to_mon(Mon, BuffList, #attacker{}).

add_buff_list_to_mon(Mon, BuffList, Attacker) ->
    Now = util:unixtime(),
    Node = node(),
    F = fun(BuffId, {OldSkillBuff1, EffectList}) ->
        case data_buff:get(BuffId) of
            [] ->
                {OldSkillBuff1, EffectList};
            Buff ->
                if Buff#buff.eff_sign == 0 orelse Buff#buff.eff_sign == ?SIGN_MON ->
                    {OldSkillBuff2, NewSkillBuff, StartEffList1} = prepare([BuffId], Node, Mon#mon.pid, Mon#mon.scene, 8888, 1, Now, OldSkillBuff1, [], 0, Attacker, [], []),
                    {OldSkillBuff2 ++ NewSkillBuff, StartEffList1 ++ EffectList};
                    true ->
                        {OldSkillBuff1, EffectList}
                end
        end
    end,
    {SkillBuffList, StartEffList} =
        lists:foldl(F, {Mon#mon.buff_list, []}, BuffList),
    Mon1 = effect:active_eff_mon(StartEffList, Mon, Now),
    Mon1#mon{buff_list = SkillBuffList}.

%%buff_timer(Player, Now) ->
%%    F = fun(Buff, {L, IsDel}) ->
%%        if Buff#skillbuff.time > Now -> {[Buff | L], IsDel};
%%            true -> {L, true}
%%        end
%%        end,
%%    {BuffList, IsRefresh} = lists:foldl(F, {[], false}, Player#player.buff_list),
%%    if IsRefresh ->
%%        {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(BuffList, Now)}),
%%        server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
%%        Player2 = Player#player{buff_list = BuffList},
%%        scene_agent_dispatch:buff_update(Player2),
%%        Player2;
%%        true ->
%%            Player
%%    end.

del_mon_buff_list(MonPid, BuffIds) ->
    F = fun(BuffId) ->
        buff_proc:del_buff(MonPid, BuffId),
        MonPid ! {buff_timeout, BuffId}
    end,
    lists:foreach(F, BuffIds),
    ok.

del_buff_list(Player, BuffIds, BC) ->
    Now = util:unixtime(),
    F = fun(BuffId, {State, List}) ->
        case lists:keytake(BuffId, #skillbuff.buffid, List) of
            false ->
                {State, List};
            {value, _, L} ->
                buff_proc:del_buff(Player#player.node, Player#player.pid, BuffId),
                {true, L}
        end
    end,
    {IsDel, SkillBuffList} = lists:foldl(F, {false, Player#player.buff_list}, BuffIds),
    case IsDel of
        false -> Player;
        true ->
            {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(SkillBuffList, Now)}),
            case BC of
                0 ->
                    server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin);
                _ ->
                    server_send:send_to_sid(Player#player.sid, Bin)
            end,
            Player1 = Player#player{buff_list = SkillBuffList},
            scene_agent_dispatch:buff_update(Player1),
            Player1
    end.

%%删除buff
del_buff(Player, BuffId) ->
    case lists:keytake(BuffId, #skillbuff.buffid, Player#player.buff_list) of
        false -> Player;
        {value, _, SkillBuffList} ->
            Now = util:unixtime(),
            buff_proc:del_buff(Player#player.node, Player#player.pid, BuffId),
            {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(SkillBuffList, Now)}),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
            Player1 = Player#player{buff_list = SkillBuffList},
            scene_agent_dispatch:buff_update(Player1),
            Player1
    end.

%%删除buff
del_buff_only(Player, BuffId) ->
    case lists:keytake(BuffId, #skillbuff.buffid, Player#player.buff_list) of
        false -> Player;
        {value, _, SkillBuffList} ->
            Now = util:unixtime(),
            buff_proc:del_buff(Player#player.node, Player#player.pid, BuffId),
            {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(SkillBuffList, Now)}),
            server_send:send_to_sid(Player#player.sid, Bin),
            Player1 = Player#player{buff_list = SkillBuffList},
            Player1
    end.

%%增加buff主逻辑
do_add_buff(BS, BuffList, SkillId, Slv, Attacker) ->
    TimeMark = BS#bs.time_mark,
    Time = BS#bs.now,
    UnFaint = ?IF_ELSE(BS#bs.now > TimeMark#time_mark.uft, [], [106]),%%硬直buff大类
    UnYun = ?IF_ELSE(BS#bs.now > TimeMark#time_mark.umt, [], [200]),  %%眩晕bff大类
    BsArgs = BS#bs.bs_args,
%%    OldSkillBuff = [SkillBuff || SkillBuff <- BS#bs.buff_list, SkillBuff#skillbuff.time > Time],
    %% ------过滤buff完成添加到排除列表
    ExceptList = UnFaint ++ UnYun,
    prepare(BuffList, BS#bs.node, BS#bs.pid, BS#bs.scene, SkillId, Slv, Time, BS#bs.buff_list, ExceptList, BsArgs#bs_args.unctrl, Attacker, [], []).

%%buff转换成eff
buff_to_eff(BS, BuffList) ->
    F = fun(SkillBuff, BSx) ->
        BaseBuff = data_buff:get(SkillBuff#skillbuff.buffid),
        case lists:member(BS#bs.scene, BaseBuff#buff.un_eff_scene) of
            true -> BSx;
            false ->
                case BaseBuff#buff.eff_scene == [] orelse lists:member(BS#bs.scene, BaseBuff#buff.eff_scene) of
                    true ->
                        effect:add_effect(BSx, BaseBuff#buff.efflist, SkillBuff#skillbuff.skillid, SkillBuff#skillbuff.param);
                    false ->
                        BSx
                end
        end
    end,
    lists:foldl(F, BS, BuffList).

%%转换buff列表
prepare([], _Node, _Pid, _SceneId, _skillid, _slv, _now, OldSkillbuff, _ExceptList, _Unctrl, _Attacker, BuffList, EffList) ->
    {OldSkillbuff, BuffList, EffList};
prepare([BuffId | L], Node, Pid, SceneId, SkillId, Slv, Now, OldSkillbuff, ExceptList, Unctrl, Attacker, BuffList, EffList) ->
    BuffType = BuffId div 100,
    case lists:member(BuffType, ExceptList) of
        true ->
            prepare(L, Node, Pid, SceneId, SkillId, Slv, Now, OldSkillbuff, ExceptList, Unctrl, Attacker, BuffList, EffList);
        false ->
            case data_buff:get(BuffId) of
                [] ->
                    prepare(L, Node, Pid, SceneId, SkillId, Slv, Now, OldSkillbuff, ExceptList, Unctrl, Attacker, BuffList, EffList);
                BaseBuff ->
                    IsUseScene = ?IF_ELSE(BaseBuff#buff.eff_scene == [], true, lists:member(SceneId, BaseBuff#buff.eff_scene)),
                    UnUseScene = lists:member(SceneId, BaseBuff#buff.un_eff_scene),
                    if Unctrl > Now andalso BaseBuff#buff.type == 3 ->
                        prepare(L, Node, Pid, SceneId, SkillId, Slv, Now, OldSkillbuff, ExceptList, Unctrl, Attacker, BuffList, EffList);
                        UnUseScene ->
                            prepare(L, Node, Pid, SceneId, SkillId, Slv, Now, OldSkillbuff, ExceptList, Unctrl, Attacker, BuffList, EffList);
                        IsUseScene ->
                            BuffTime = BaseBuff#buff.time,
                            MaxStack = BaseBuff#buff.stack,
                            BuffParam = BaseBuff#buff.param,  %%技能等级成长系数
                            case BaseBuff#buff.is_cover of
                                2 ->
                                    F = fun(SkillBuff0, {List, Time0}) ->
                                        if SkillBuff0#skillbuff.subtype /= BaseBuff#buff.subtype ->
                                            {[SkillBuff0 | List], Time0};
                                            true ->
                                                OldTime = SkillBuff0#skillbuff.time - util:unixtime(),
                                                buff_proc:del_buff(Node, Pid, SkillBuff0#skillbuff.buffid),
                                                {List, OldTime}
                                        end
                                    end,
                                    {NewOldSkillbuff, Time} = lists:foldl(F, {[], 0}, OldSkillbuff),
                                    SkillBuff =
                                        #skillbuff{
                                            buffid = BuffId,
                                            skillid = SkillId,
                                            skilllv = Slv,
                                            stack_lim = MaxStack,
                                            stack = 1,
                                            param = BuffParam,
                                            time = Now + BuffTime + Time,
                                            type = BaseBuff#buff.type,
                                            subtype = BaseBuff#buff.subtype,
                                            attacker = Attacker,
                                            is_clean = BaseBuff#buff.is_clean
                                        },
                                    %%首次buff效果
                                    StartEff = effect:prepare(BaseBuff#buff.start_eff, SkillId, 1, [], Attacker),
                                    buff_proc:set_buff(Node, Pid, SkillBuff#skillbuff.buffid, SkillBuff#skillbuff.time - Now),
                                    prepare(L, Node, Pid, SceneId, SkillId, Slv, Now, NewOldSkillbuff, ExceptList, Unctrl, Attacker, [SkillBuff | BuffList], EffList ++ StartEff);
                                1 ->
                                    F = fun(SkillBuff) ->
                                        if SkillBuff#skillbuff.subtype /= BaseBuff#buff.subtype -> true;
                                            true ->
                                                buff_proc:del_buff(Node, Pid, SkillBuff#skillbuff.buffid),
                                                false
                                        end
                                    end,
                                    NewOldSkillbuff = lists:filter(F, OldSkillbuff),
                                    SkillBuff =
                                        #skillbuff{
                                            buffid = BuffId,
                                            skillid = SkillId,
                                            skilllv = Slv,
                                            stack_lim = MaxStack,
                                            stack = 1,
                                            param = BuffParam,
                                            time = Now + BuffTime,
                                            type = BaseBuff#buff.type,
                                            subtype = BaseBuff#buff.subtype,
                                            attacker = Attacker,
                                            is_clean = BaseBuff#buff.is_clean
                                        },
                                    %%首次buff效果
                                    StartEff = effect:prepare(BaseBuff#buff.start_eff, SkillId, 1, [], Attacker),
                                    buff_proc:set_buff(Node, Pid, SkillBuff#skillbuff.buffid, BuffTime),
                                    prepare(L, Node, Pid, SceneId, SkillId, Slv, Now, NewOldSkillbuff, ExceptList, Unctrl, Attacker, [SkillBuff | BuffList], EffList ++ StartEff);
                                0 ->
                                    SkillBuff =
                                        case lists:keyfind(BuffId, #skillbuff.buffid, OldSkillbuff) of
                                            false ->
                                                #skillbuff{
                                                    buffid = BuffId,
                                                    skillid = SkillId,
                                                    skilllv = Slv,
                                                    stack_lim = MaxStack,
                                                    stack = 1,
                                                    param = BuffParam,
                                                    time = Now + BuffTime,
                                                    type = BaseBuff#buff.type,
                                                    subtype = BaseBuff#buff.subtype,
                                                    attacker = Attacker,
                                                    is_clean = BaseBuff#buff.is_clean
                                                };
                                            OldBuff ->
                                                OldStack = OldBuff#skillbuff.stack,
                                                OldTime = OldBuff#skillbuff.time,
                                                OldParam = OldBuff#skillbuff.param,
                                                [NewStack, NewParam, NewTime] =
                                                    case BaseBuff#buff.stack_type of
                                                        1 ->
                                                            %%刷新时间，效果叠加
                                                            [min(OldStack + 1, MaxStack), OldParam + 1, Now + BuffTime];
                                                        2 ->
                                                            %%时间延长 t/层数
                                                            [min(OldStack + 1, MaxStack), OldParam, OldTime + BuffTime / (OldStack + 1)];
                                                        3 ->
                                                            %%取最长时间
                                                            [min(OldStack + 1, MaxStack), OldParam, max(Now + BuffTime, OldTime)];
                                                        4 ->
                                                            %%替换
                                                            [1, BuffParam, Now + BuffTime];
                                                        5 ->
                                                            %%时间叠加
                                                            [1, OldParam, OldTime + BuffTime];
                                                        6 ->
                                                            %%时间叠加，并且有最大值
                                                            if
                                                                OldTime >= Now ->
                                                                    AddTime = min(OldTime - Now + BuffTime, BaseBuff#buff.time_max),
                                                                    [1, BuffParam, Now + AddTime];
                                                                true ->
                                                                    [1, BuffParam, Now + BuffTime]
                                                            end;

                                                        _ ->
                                                            [1, BuffParam, Now + BuffTime]
                                                    end,
                                                #skillbuff{
                                                    buffid = BuffId,
                                                    skillid = SkillId,
                                                    skilllv = Slv,
                                                    stack_lim = BaseBuff#buff.stack,
                                                    stack = NewStack,
                                                    param = NewParam,
                                                    time = NewTime,
                                                    type = BaseBuff#buff.type,
                                                    subtype = BaseBuff#buff.subtype,
                                                    attacker = Attacker,
                                                    is_clean = BaseBuff#buff.is_clean
                                                }
                                        end,
                                    %%首次buff效果
                                    StartEff = effect:prepare(BaseBuff#buff.start_eff, SkillId, 1, [], Attacker),
                                    buff_proc:set_buff(Node, Pid, BuffId, max(1, SkillBuff#skillbuff.time - Now)),
                                    prepare(L, Node, Pid, SceneId, SkillId, Slv, Now, lists:keydelete(BuffId, #skillbuff.buffid, OldSkillbuff), ExceptList, Unctrl, Attacker, [SkillBuff | BuffList], EffList ++ StartEff)
                            end;
                        true ->
                            prepare(L, Node, Pid, SceneId, SkillId, Slv, Now, OldSkillbuff, ExceptList, Unctrl, Attacker, BuffList, EffList)
                    end
            end
    end.


%%使用物品增加buff
goods_add_buff(Player, BuffId) ->
    buff_init:add_buff(BuffId),
    add_buff_to_player(Player, BuffId).


%%buff超时
buff_timeout(?SIGN_MON, Mon, BuffId, _Args) ->
    case lists:keytake(BuffId, #skillbuff.buffid, Mon#mon.buff_list) of
        false -> Mon;
        {value, Buff, T} ->
            case data_buff:get(Buff#skillbuff.buffid) of
                [] -> ok;
                BaseBuff ->
                    case BaseBuff#buff.end_eff of
                        [] -> ok;
                        _ ->
                            Bs = battle:init_data(Mon, ?SIGN_MON, util:longunixtime()),
                            NewBS = effect:add_effect(Bs, BaseBuff#buff.end_eff, Buff#skillbuff.skillid, Buff#skillbuff.param),
                            effect:end_eff(NewBS#bs.eff_list, Bs, _Args)
                    end
            end,
            {ok, Bin} = pt_200:write(20005, {?SIGN_MON, Mon#mon.key, battle_pack:pack_buff_list(T, util:unixtime())}),
            server_send:send_to_scene(Mon#mon.scene, Mon#mon.copy, Mon#mon.x, Mon#mon.y, Bin),
            Mon#mon{buff_list = T}
    end;
buff_timeout(?SIGN_PLAYER, Player, BuffId, _Args) ->
    case lists:keytake(BuffId, #skillbuff.buffid, Player#player.buff_list) of
        false ->
            {ok, Bin} = pt_200:write(20005, {?SIGN_PLAYER, Player#player.key, battle_pack:pack_buff_list(Player#player.buff_list, util:unixtime())}),
            server_send:send_to_sid(Player#player.sid, Bin),
            Player;
        {value, Buff, T} ->
            {ok, Bin} = pt_200:write(20005, {?SIGN_PLAYER, Player#player.key, battle_pack:pack_buff_list(T, util:unixtime())}),
            server_send:send_to_sid(Player#player.sid, Bin),
            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
            Player2 = Player#player{buff_list = T},
            scene_agent_dispatch:buff_update(Player2),
            case data_buff:get(Buff#skillbuff.buffid) of
                [] -> ok;
                BaseBuff ->
                    case BaseBuff#buff.end_eff of
                        [] -> ok;
                        _ ->
                            Bs = battle:init_data(scene:player_to_scene_player(Player), ?SIGN_PLAYER, util:longunixtime()),
                            NewBS = effect:add_effect(Bs, BaseBuff#buff.end_eff, Buff#skillbuff.skillid, Buff#skillbuff.param),
                            effect:end_eff(NewBS#bs.eff_list, Bs, _Args)
                    end
            end,
            Player2
    end.


merge_buff_list(BuffList1, BuffList2) ->
    F = fun(SKillBuff, L) ->
        case lists:keymember(SKillBuff#skillbuff.buffid, #skillbuff.buffid, L) of
            false ->
                [SKillBuff | L];
            true -> L
        end
    end,
    lists:foldl(F, BuffList1, BuffList2).


%%死亡清理buff
check_clean_buff(Player) ->
    F = fun(SKillBuff, {L, Bool}) ->
        if SKillBuff#skillbuff.is_clean == 1 ->
            {L, true};
            true ->
                {[SKillBuff | L], Bool}
        end
    end,
    {BuffList, IsClean} = lists:foldl(F, {[], false}, Player#player.buff_list),
    if IsClean ->
        {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(BuffList, util:unixtime())}),
        server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
        NewPlayer = Player#player{buff_list = BuffList},
        scene_agent_dispatch:buff_update(NewPlayer),
        NewPlayer;
        true -> Player
    end.


clean_buff_by_subtype(Player, Subtype) ->
    F = fun(SKillBuff, {L, Bool}) ->
        if SKillBuff#skillbuff.subtype == Subtype ->
            {L, true};
            true ->
                {[SKillBuff | L], Bool}
        end
    end,
    {BuffList, IsClean} = lists:foldl(F, {[], false}, Player#player.buff_list),
    if IsClean ->
        {ok, Bin} = pt_200:write(20005, {1, Player#player.key, battle_pack:pack_buff_list(BuffList, util:unixtime())}),
        server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin),
        NewPlayer = Player#player{buff_list = BuffList},
        scene_agent_dispatch:buff_update(NewPlayer),
        NewPlayer;
        true -> Player
    end.

get_buff_by_subtype(Player, Subtype) ->
    F = fun(SKillBuff) ->
        if
            SKillBuff#skillbuff.subtype == Subtype -> [SKillBuff];
            true -> []
        end
    end,
    lists:flatmap(F, Player#player.buff_list).
