%%----------------------------------------------------
%% 全服名人榜 
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_celebrity).
-export([
        gm_in_rank/2
        ,combat_over/1
        ,listener/3
        ,rewards/2
        ,rewards_honor/0

        ,divine_jd/1
        ,divine_lev/1
        ,c_suit/1
        ,enchant_suit/1
        ,bs_suit/1
        ,dragon_suit/1

    ]
).

-include("common.hrl").
-include("role.hrl").
-include("rank.hrl").
-include("condition.hrl").
-include("combat.hrl").
-include("guild.hrl").
-include("achievement.hrl").
-include("item.hrl").
-include("pet.hrl").
-include("dungeon.hrl").
-include("channel.hrl").

%% GM通过控制台直接让某角色上榜
gm_in_rank(Role, Honor) ->
    ?DEBUG("---GM通过控制台直接让某角色上榜----：~s~n~w~n",[Role#role.name, Honor]),
    case convert([Role], []) of
        false ->
            %% ?ERR("角色转换失败,无法更新名人榜"),
            ?DEBUG("---角色转换失败----：~s~n~w~n",[Role#role.name, Honor]),
            false;
        Rlist ->
            case rank_data_celebrity:get(Honor) of
                {ok, D = #rank_data_celebrity{}} ->
                    ?DEBUG("---GM通过控制台直接让某角色上榜----：~s~n~w~n",[Role#role.name,Honor]),
                    rank_mgr:async({gm, ?rank_celebrity, D, Rlist}); %%仍然会检查该项是否已有上榜
                _ ->
                    ok
            end
    end.
% gm_in_rank(Name, Honor) ->
%     ?DEBUG("---GM通过控制台直接让某角色上榜----：~s~n~w~n",[Name,Honor]),
%     case role_api:lookup(by_name, Name) of
%         {ok, _N, Role} -> %% 角色在线 通过异步方式发放称号
%             case convert([Role], []) of
%                 false ->
%                     %% ?ERR("角色转换失败,无法更新名人榜"),
%                     ?DEBUG("---角色转换失败----：~s~n~w~n",[Name,Honor]),
%                     false;
%                 Rlist ->
%                     case rank_data_celebrity:get(Honor) of
%                         {ok, D = #rank_data_celebrity{}} ->
%                             ?DEBUG("---GM通过控制台直接让某角色上榜----：~s~n~w~n",[Name,Honor]),
%                             rank_mgr:async({gm, ?rank_celebrity, D, Rlist}); %%仍然会检查该项是否已有上榜
%                         _ ->
%                             ok
%                     end
%             end; 
%         _ -> %% 角色不在线 通过更新数据库发放称号
%             ?DEBUG("---角色不在线----：~s~n~w~n",[Name,Honor]),
%             ok
%     end.

%%宠物装备
dragon_suit(Role = #role{pet = #pet_bag{active = #pet{eqm = Eqm}}}) ->
    case erlang:length(Eqm) >= 6 of 
        true ->
            ItemsId = [Item#item.base_id|| Item <-Eqm],
            {Levs, Qualities} = get_quality_lev(ItemsId, [], []),
            case erlang:length(Levs) >= 6 andalso erlang:length(Qualities) >= 6 of 
                true ->
                    listener(dragon_suit, Role, {lists:min(Levs), lists:min(Qualities)});
                _ ->skip
            end;
        _ ->
            skip
    end.
           
get_quality_lev([], Levs, Qualities) -> {Levs, Qualities};
get_quality_lev([BaseId|T], Levs, Qualities) ->
    case item_data:get(BaseId) of 
        {ok, #item_base{quality = Q, condition = Cond}} ->
            case lists:keyfind(lev, #condition.label, Cond) of 
                #condition{target_value = Lev} ->
                    get_quality_lev(T, [Lev] ++ Levs, [Q] ++ Qualities);
                _ ->
                    get_quality_lev(T, Levs, Qualities)
            end;
        _ ->
            get_quality_lev(T, Levs, Qualities)
    end.

%%宝石镶嵌
bs_suit(Role = #role{eqm = Eqm}) ->
    case erlang:length(Eqm) >= 10 of 
        true ->
            
            AttrList = [Attr1||#item{attr = Attr1} <- Eqm, lists:keyfind(101, 2, Attr1) =/= false],
            case erlang:length(AttrList) >= 10 of 
                true ->
                    F = fun(List, Re) ->
                            L = [Value2 rem 10||{_, Flag, Value2} <-List, Flag == 101],
                            [lists:max(L)] ++ Re
                        end,  
                    Min = lists:min(lists:foldl(F, [], AttrList)),
                    listener(all_bs_suit, Role, Min);      
                false ->
                    skip
            end;

        false ->
            skip
    end.


%% 全身装备强化
enchant_suit(Role = #role{eqm = Eqm}) ->
    case erlang:length(Eqm) >= 10 of 
        true ->
            List = [E#item.enchant||E<-Eqm],
            listener(all_qh_suit, Role, lists:min(List));   
        false ->
            skip
    end.

%% 全身装备品阶
c_suit(Role = #role{eqm = Eqm}) ->
    % case erlang:length(Eqm) >= 10 of 
    %     true ->
            List = [E#item.quality ||E <- Eqm],
            listener(c_suit, Role, {length(Eqm), lists:min(List)}).
    %     false ->
    %         skip
    % end.

divine_jd(Role = #role{channels = #channels{list = ChannelList}}) ->
    % case erlang:length(ChannelList) >= 8 of
    %     true ->
            Attr_List = [State||#role_channel{state = State} <- ChannelList],
            MinAttr = lists:min(Attr_List),
            listener(divine_jd, Role, {length(ChannelList), MinAttr}).
    %     false -> skip
    % end.
divine_lev(Role = #role{channels = #channels{list = ChannelList}}) ->
    % case erlang:length(ChannelList) >= 8 of
    %     true ->
            MatchChan = [L||#role_channel{lev = L} <- ChannelList],
            MinLev = lists:min(MatchChan),
            listener(divine_lev, Role, {length(ChannelList), MinLev}).
    %     false -> skip
    % end.

%% 战斗
combat_over(#combat{type = ?combat_type_npc, winner = Winner, loser = Loser}) ->
    NpcLoser = [Npc || Npc <- Loser, Npc#fighter.type =:= ?fighter_type_npc],
    % ?DEBUG("-----NpcLoser-----:~p~n~n", [NpcLoser]),
    % ?DEBUG("-----Winner-----:~p~n", [Winner]),
    [listener(kill_npc, Winner, {NpcBaseId, 1}) || #fighter{base_id = NpcBaseId} <- NpcLoser],
    % [listener(pirate_kill, Winner, NpcBaseId) || #fighter{base_id = NpcBaseId} <- NpcLoser],
    [listener(monster_contract, Winner, NpcBaseId) || #fighter{base_id = NpcBaseId} <- NpcLoser],
    % ?DEBUG("--combat_over------"),
    ok;
combat_over(_Combat) -> ok.


%% 监听事件
%% listener(lev, Role, Lev) 等级改变事件
%% listener(kill_npc, Roles, {NpcBaseId, Num}) %% 击杀指定怪物
%% listener(dungeon_kill_npc, Roles, NpcBaseId) %% 击杀副本指定怪物
%% listener(world_boss, Roles, BossLev) %% 击杀世界BOSS
%% listener(on_eqm, Role, {Pos, N})  %% 装备加工改变
%% listener(all_eqm, Role, Num)   %% 全身加工级别
%% listener(pet_type, Role, Type)  %% 宠物类型变化
%% listener(pet_power, Role, Power)  %% 宠物战斗力变化
%% listener(pet_skill, Role, Skill)  %% 宠物技能变化
%% listener(fight_capacity, Role, Power)  %% 战斗力变化
%% listener(arena_kill, Role, Num) %% 竞技场斩杀数
%% listener(guild_lev, Guild, Lev) %% 帮会等级
%% listener(guild_score, Role, Score) %% 帮战积分
%% listener(skill_step, Role, {SkillId, Step}) %% 技能阶数改变
%% listener(gem_lev, Role, {Type, Lev}) %% 宝石合成
%% listener(channel_lev, Role, {Id, Lev}) %% 元神等级改变
%% listener(channel_step, Role, {Id, Step}) %% 元神境界改变
%% listener(super_boss_hurt, Role, Hurt) %% 对远古巨龙总伤害
%% listener(guild_dungeon_score, Role, Score) %% 帮会副本降妖积分
%% listener(mount_step, Role, Step) %% 坐骑升阶
%% listener(wing_step, Role, Step) %% 翅膀升阶
%% listener(pet_magic_lev, Role, Lev) %% 魔晶升级
%% listener(practice_wave, Roles, MaxRound) %% 无限试练
%% listener(cross_boss, Roles, BossBaseId) %% 跨服BOSS [#cross_boss_role{}..]
%% Role = #role{} | #fighter{}
listener(Label, {Rid, SrvId}, Args) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _N, R} ->
            in_rank(Label, [R], Args);
        _ -> %% 查找数据库
            case role_data:fetch_base(by_id, {Rid, SrvId}) of
                {ok, R} -> in_rank(Label, [R], Args);
                {false, _Err} -> ok
            end
    end;
listener(Label, Fighters = [F | _], Args) when is_record(F, fighter) ->
    RoleWinner = [R || R <- Fighters, R#fighter.type =:= ?fighter_type_role],
    in_rank(Label, RoleWinner, Args);
listener(Label, Roles, Args) when is_list(Roles) ->
    in_rank(Label, Roles, Args);
listener(Label, Role, Args) when is_record(Role, role) ->
    in_rank(Label, [Role], Args);
listener(Label, Fighter, Args) when is_record(Fighter, fighter) ->
    in_rank(Label, [Fighter], Args);
listener(Label, Guild, Args) when is_record(Guild, guild) ->
    in_rank(Label, [Guild], Args);
listener(_, _, _) -> %% 容错
    ok.

%% 奖励发放
rewards(_I = #rank_data_celebrity{id = _Honor, name = _Name, rewards = Rewards}, Rlist) ->
    % ?DEBUG("----~w~n",[Rlist]),
    % ?DEBUG("----~w~n",[Rewards]),
    RL = [{RId, SrvId} || #rank_celebrity_role{id = {RId, SrvId}} <- Rlist],
    do_rewards(RL, Rewards).

do_rewards([], _Rewards) ->ok;
do_rewards([{RId, SrvId}|T], Rewards) ->
    award:send({RId, SrvId}, Rewards),
    do_rewards(T, Rewards).

    % Items = make_items(Rewards, []),
    % Content = util:fbin(?L(<<"只有第一，没有第二！恭喜您达成成就“~s”，荣登本服名人榜，特此赠送您珍贵的物品，请查收。">>), [Name]),
    % mail_mgr:deliver(RL, {?L(<<"荣登名人榜">>), Content, [], Items}),
    % notice(I, Rlist).
    % [achievement:add_and_use_honor(Rid, Honor) || #rank_celebrity_role{id = Rid} <- Rlist].

%% 重新发放名人榜称号
rewards_honor() ->
    L = rank:list(?rank_celebrity),
    do_rewards_honor(L).
do_rewards_honor([]) -> ok;
do_rewards_honor([#rank_global_celebrity{id = Honor, r_list = Rlist} | T]) ->
    [achievement:add_and_use_honor(R#rank_celebrity_role.id, Honor) || R <- Rlist],
    do_rewards_honor(T).

%%------------------------------------------------------
%% 内部函数
%%------------------------------------------------------

%% 公告信息
% notice(#rank_data_celebrity{name = CeName, honor = Honor, color = Color}, Rlist) ->
%     Rs = [{Rid, SrvId, RName} || #rank_celebrity_role{rid = Rid, srv_id = SrvId, name = RName} <- Rlist], 
%     RoleMsg = concat_name(Rs, <<>>),
%     Msg = util:fbin(?L(<<"只有第一，没有第二！~s成为了全服{str, ~s, #FFFF00}的名人，荣登名人榜，获得了称号：{open, 4, ~s, ~s}，实在是太强大了!">>), [RoleMsg, CeName, Honor, Color]),
%     ?INFO("[~s]名人榜完成:[~s]", [CeName, RoleMsg]),
%     % notice:send(53, Msg).
%     role_group:pack_cast(world, 10932, {6, 0, Msg}).

%% 连接多个角色
% concat_name([], Str) -> Str;
% concat_name([{Rid, SrvId, Name} | T], Str) ->
%     NewStr = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid, SrvId, Name]),
%     concat_name(T, <<Str/binary, NewStr/binary>>).

%% 生成物品数据
% make_items([], Items) -> Items;
% make_items([{BaseId, Bind, Num} | T], Items) ->
%     case item:make(BaseId, Bind, Num) of
%         {ok, Is} ->
%             make_items(T, Is ++ Items);
%         _ ->
%             ?ERR("无法生成物品基础数据[baseid:~p]", [BaseId]),
%             make_items(T, Items)
%     end.

%% 上榜处理
in_rank(_Label, [], _Args) -> ok;
in_rank(Label, Roles, Args) ->
    case convert(Roles, []) of %% 角色转换
        false ->
            %% ?ERR("角色转换失败,无法更新名人榜"),
            false;
        Rlist ->
            Ids = rank_data_celebrity:list(), %%获得所有配置的名人堂数据
            List = rank:list(?rank_celebrity), %%获得所有已经在名人排行榜的数据
            BaseDatas = base_data(List, Ids, []), %%获得所有可上榜的项目
            % ?DEBUG("----BaseDatas---~p~n", [BaseDatas]),
            in_rank(Label, Rlist, BaseDatas, Args)
    end.

%% 上榜判断触发
in_rank(_Label, _Rlist, [], _Args) -> ok;
%% 等级判断
in_rank(Label = lev, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Lev) when Lev >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Lev);
%% 击杀指定怪物 ，只要target 与传人的Args相同即达到目标，在此之前已过滤已上榜的项目
in_rank(Label = kill_npc, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = NpcBaseId}} | BaseDatas], Args = {NpcBaseId, _Num}) ->
    % ?DEBUG("--kill_npc---"),
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Args);
%%收服了某一个怪
in_rank(Label = monster_contract, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = NpcBaseId}} | BaseDatas], NpcBaseId) ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, NpcBaseId);

%%击杀海盗   
in_rank(Label = pirate_kill, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = NpcBaseId}} | BaseDatas], Id) when Id =:= NpcBaseId ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Id);

%%守城伐龙
in_rank(Label = dragon_boss_hit, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Hit) when Hit >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Hit);


%%爬树    
in_rank(Label = tree_climb, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Meters}} | BaseDatas], MinMeters) when MinMeters >= Meters ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, MinMeters);
%% 击杀副本指定怪物
in_rank(Label = dungeon_kill_npc, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = NpcBaseId}} | BaseDatas], NpcBaseId) ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, NpcBaseId);
%% 击杀世界BOSS
in_rank(Label = world_boss, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = BossLev}} | BaseDatas], BossLev) ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, BossLev);
%% 装备加工
in_rank(Label = on_eqm, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], Args = {Pos, N}) when (Target =:= Pos orelse Target =:= 0) andalso N >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Args);
%% 武器品质
in_rank(Label = eqm, Rlist, [I = #rank_data_celebrity{condition = #condition{label = arms_quality, target = Target, target_value = Q}} | BaseDatas], Items) ->
    case [Item || Item <- Items, (Item#item.require_lev =:= Target orelse Target =:= 0), Item#item.quality =:= Q, Item#item.pos =:= ?arms_pos] of
        [] -> ok;
        _ ->rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist})
    end,
    in_rank(Label, Rlist, BaseDatas, Items);
%% 套装品质
in_rank(Label = eqm, Rlist, [I = #rank_data_celebrity{condition = #condition{label = armor_quality, target = Target, target_value = Q}} | BaseDatas], Items) ->
    PL = [?armor_pos_jacket, ?armor_pos_belt, ?armor_pos_cuff, ?armor_pos_nipper, ?armor_pos_pants, ?armor_pos_shoes],
    case [Item || Item <- Items, (Item#item.require_lev =:= Target orelse Target =:= 0), Item#item.quality =:= Q, lists:member(Item#item.pos, PL)] of
        L when length(L) =:= length(PL) -> rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist});
        _ -> ok
    end,
    in_rank(Label, Rlist, BaseDatas, Items);
%% 饰品品质
in_rank(Label = eqm, Rlist, [I = #rank_data_celebrity{condition = #condition{label = decoration_quality, target = Target, target_value = Q}} | BaseDatas], Items) ->
    PL = [?decoration_pos_amulet_1, ?decoration_pos_amulet_2, ?decoration_pos_ring_1, ?decoration_pos_ring_2],
    case [Item || Item <- Items, (Item#item.require_lev =:= Target orelse Target =:= 0), Item#item.quality =:= Q, lists:member(Item#item.pos, PL)] of
        L when length(L) =:= length(PL) -> rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist});
        _ -> ok
    end,
    in_rank(Label, Rlist, BaseDatas, Items);
%% 全身装备品阶
in_rank(Label = suit, Rlist, [I = #rank_data_celebrity{condition = #condition{label = suit, target_value = Craft}} | BaseDatas], Items) ->
    PL = [?item_weapon, ?item_hu_wan, ?item_yi_fu, ?item_ku_zi, ?item_xie_zi, ?item_yao_dai, ?item_hu_shou, ?item_hu_fu, ?item_jie_zhi, ?item_xiang_lian],
    case [Item || Item <- Items, Item#item.craft >= Craft, lists:member(Item#item.pos, PL)] of
        L when length(L) =:= length(PL) -> rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist});
        _ -> ok
    end,
    in_rank(Label, Rlist, BaseDatas, Items);
%% 全身装备品阶
in_rank(Label = c_suit, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], {Number, Quality}) when Number >= Val andalso Quality >= Target -> 
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Quality);

%% 全身装备强化
in_rank(Label = all_qh_suit, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Enchant) when Enchant >= Val -> 
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Enchant);

%% 全身装备镶嵌宝石
in_rank(Label = all_bs_suit, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Lev) when Lev >= Val -> 
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Lev);

%% 全身装备加工
in_rank(Label = all_eqm, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], N) when N >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, N);
%% 宠物类型
in_rank(Label = pet_type, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Type}} | BaseDatas], Type) ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Type);
%% 宠物战斗力
in_rank(Label = dragon_fight_capacity, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Power) when Power >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Power);

%% 宠物技能
in_rank(Label = dragon_skill_high, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Lev) when Lev >= Val->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Lev);

%% 宠物潜力
in_rank(Label = dragon_bone, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Avg) when Avg >= Val->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Avg);

%% 宠物套装
in_rank(Label = dragon_suit, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], Arg = {Lev, Quality}) when Quality >= Target andalso Lev >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Arg);


%% 宠物技能
in_rank(Label = pet_skill, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = NeedStep, target_value = NeedLev}} | BaseDatas], Skills) ->
    S1 = [pet_data_skill:get(SkillId) || {SkillId, _, _} <- Skills],
    case [S || {_, S} <- S1, S#pet_skill.step >= NeedStep, S#pet_skill.lev >= NeedLev] of
        [] -> ok;
        _ -> rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist})
    end,
    in_rank(Label, Rlist, BaseDatas, Skills);
%% 战斗力
in_rank(Label = fight_capacity, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Power) when Power >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Power);
%% 竞技场斩杀数
in_rank(Label = arena_kill, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Num) when Num >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Num);
%% 帮会等级
in_rank(Label = guild_lev, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Lev) when Lev >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Lev);
%% 帮战积分
in_rank(Label = guild_score, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Num) when Num >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Num);
%% 技能阶数
in_rank(Label = skill_step, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], Args = {SkillId, N}) when (Target =:= SkillId orelse Target =:= 0) andalso N >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Args);
%% 宝石合成
in_rank(Label = gem_lev, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], Args = {Type, N}) when (Target =:= Type orelse Target =:= 0) andalso N >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Args);
%% 元神级别
in_rank(Label = channel_lev, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], Args = {Id, Lev}) when (Target =:= Id orelse Target =:= 0) andalso Lev >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Args);
%% 神觉修炼等级
in_rank(Label = divine_lev, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], {Num, Lev}) when Num >= Val andalso Lev >= Target ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Lev);
%% 神觉修炼强化
in_rank(Label = divine_jd, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], {Num, JdAdd}) when Num >= Val andalso JdAdd >= Target ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, JdAdd);
%% 元神境界
in_rank(Label = channel_step, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Target, target_value = Val}} | BaseDatas], Args = {Id, N}) when (Target =:= Id orelse Target =:= 0) andalso N >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Args);
%% 对远古巨龙总伤害
in_rank(Label = super_boss_hurt, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Hurt) when Hurt >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Hurt);
%% 帮会副本降妖
in_rank(Label = guild_dungeon_score, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Score) when Score >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Score);
%% 坐骑升阶
in_rank(Label = mount_step, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Step) when Step >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Step);
%% 翅膀升阶
in_rank(Label = wing_step, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Step) when Step >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Step);
%% 魔晶升级
in_rank(Label = pet_magic_lev, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Lev) when Lev >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Lev);
%% 无限试练
in_rank(Label = practice_wave, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target_value = Val}} | BaseDatas], Wave) when Wave >= Val ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Wave);
%% 跨服BOSS
in_rank(Label = cross_boss, Rlist, [I = #rank_data_celebrity{condition = #condition{label = Label, target = Boss}} | BaseDatas], Boss) ->
    rank_mgr:async({in_rank, ?rank_celebrity, I, Rlist}),
    in_rank(Label, Rlist, BaseDatas, Boss);
%% 容错
in_rank(Label, Rlist, [_ | BaseDatas], Args) -> 
    in_rank(Label, Rlist, BaseDatas, Args).

%% 角色转换
convert([], []) -> false;
convert([], Rlist) -> Rlist;
convert([R | T], Rlist) ->
    case rank_convert:do(to_celebrity, R) of
        {ok, Ce = #rank_celebrity_role{srv_id = SrvId}} ->
            case role_api:is_local_role(SrvId) of
                true ->
                    convert(T, [Ce | Rlist]);
                _ ->
                    convert(T, Rlist)
            end;
        _ -> 
            false
    end.

% -record(rank_celebrity_role, {
%         id              %% {角色ID, 服务器标志}
%         ,rid            %% 角色ID
%         ,srv_id         %% 服务器标志
%         ,name           %% 名称
%         ,career         %% 职业
%         ,sex            %% 性别
%     }).

%% 获取所有名人榜基础数据
base_data(_RandL, [], L) -> L;
base_data(RankL, [Id | T], L) ->
    case lists:keyfind(Id, #rank_global_celebrity.id, RankL) of
        false -> %% 未有角色上榜 可上榜
            case rank_data_celebrity:get(Id) of
                {ok, D = #rank_data_celebrity{}} ->
                    base_data(RankL, T, [D | L]);
                _ ->
                    base_data(RankL, T, L)
            end;
        _ -> %% 该榜已有角色 不可再上榜
            base_data(RankL, T, L)
    end.
% -record(rank_data_celebrity, {
%         id              %% 唯一标志
%         ,name           %% 名称 
%         ,condition      %% 条件
%         ,rewards = []   %% 奖励
%         ,honor = <<>>   %% 称号
%         ,color = <<>>   %% 称号颜色
%     }
% ).
