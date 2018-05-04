%%----------------------------------------------------
%% 排行榜
%% @author LiuWeihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(rank).
-export([
        list/1
        ,find_max_power/1
        ,test_save/0
        ,get_rank_item/3
        ,get_rank_role_attr/3
        ,get_rank_pet/3
        ,role_ranks/1
        ,role_update/4   %% 角色信息变化
        ,login_update/1  %% 更新登陆时间
        ,guild_update/2  %% 帮会更新
        ,listener/2      %% 排行榜监听函数
        ,listener/3      %% 排行榜监听函数
        ,has_open_celebrity/0
        ,sort_num/2
        ,lev_rank/1
        ,fight_rank/1
        ,get_channel_score/1
        ,armor_rank_by_type/2
        ,eqm_rank2/1
        ,to_eqm_type/1
        ,fight_capacity_rank/1
    ]).

-include("common.hrl").
-include("rank.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("attr.hrl").
-include("item.hrl").
-include("achievement.hrl").
-include("pet.hrl").
-include("guild.hrl").

%% 角色数据更新
role_update(_Cmd, _Data, OldRole, NewRole) ->
    coin_rank(OldRole, NewRole).
    % listener(vie_acc, OldRole, NewRole),
    % end.

%% 更新登陆时间
%% @spec login_update(Rid, Srvid) -> ok
%% Rid = integer()
%% Srvid = binary()
login_update(Role = #role{lev = Lev}) when Lev >= 40 ->
    listener(lev, Role),
    % listener(soul, Role),
    listener(skill, Role),
    % listener(glamor, Role),
    % listener(flower, Role),
    % listener(mount, Role),
    % listener(soul_world, Role),
    OldRole = #role{assets = #assets{}, attr = #attr{}, achievement = #role_achievement{}},
    coin_rank(OldRole, Role),
    listener(power, OldRole, Role),
    rank_mgr:async({login_update, Role#role.id}),
    rank_role_info:async({login, Role#role.id});
login_update(Role) -> 
    rank_role_info:async({login, Role#role.id}).

%% 帮会更新
guild_update(in_guild, Role) ->
    rank_mgr:async({in_guild, Role});
guild_update(out_guild, Role) ->
    rank_mgr:async({out_guild, Role});
guild_update(dismiss_guild, Guild) ->
    rank_mgr:async({exit_rank, ?rank_guild_lev, Guild#guild.id});
guild_update(_, _) -> ok.

%% @spec listener(Type, Role) -> ok
%% Type = lev | soul | skill | pet | guild_lev
%% Role = #role{}
%% @doc 排行榜监听函数

%% 角色变性
listener(sex, Role) ->
    rank_mgr:async({update_sex, Role});

%% 监听等级
listener(lev, Role) -> 
    case rank_convert:do(to_role_lev, Role) of       
        {ok, Data = #rank_role_lev{lev = Lev}} when Lev >= ?rank_min_role_lev ->
            rank_mgr:async({in_rank, ?rank_role_lev, Lev, Data}),
            rank_celebrity:listener(lev, Role, Lev);
        _ ->
            ok
    end;
%% 监听元神
listener(soul, Role) ->
    case rank_convert:do(to_role_soul, Role) of      
        {ok, Data = #rank_role_soul{soul = Soul}} when Soul >= ?rank_min_role_soul ->
            rank_mgr:async({in_rank, ?rank_role_soul, Soul, Data});
        _ ->
            ok
    end;
%% 监听技能
listener(skill, Role) ->
    case rank_convert:do(to_role_skill, Role) of       
        {ok, Data = #rank_role_skill{skill = Skill}} when Skill >= ?rank_min_role_skill ->
            rank_mgr:async({in_rank, ?rank_role_skill, Skill, Data});
        _ ->
            ok
    end,
    campaign_listener:handle(skill, Role, 1);
%% 监听帮会等级
listener(guild_lev, Guild) ->
    case rank_convert:do(to_guild_lev, Guild) of
        {ok, Data = #rank_guild_lev{lev = Lev}} when Lev >= ?rank_min_guild_lev ->
            rank_mgr:async({in_rank, ?rank_guild_lev, Lev, Data}),
            rank_celebrity:listener(guild_lev, Guild, Lev);
        _ ->
            ok
    end;


%% 灵戒战力
listener(soul_world, Role) ->
    case rank_convert:do(to_soul_world, Role) of       
        {ok, Data1 = #rank_soul_world{power = Power1}} ->
            rank_mgr:async({in_rank, ?rank_soul_world, Power1, Data1});
        _ ->
            ok
    end,
    case rank_convert:do(to_soul_world_array, Role) of       
        {ok, Data2 = #rank_soul_world_array{lev = Lev}} ->
            rank_mgr:async({in_rank, ?rank_soul_world_array, Lev, Data2});
        _ ->
            ok
    end,
    case rank_convert:do(to_soul_world_spirit, Role) of       
        {ok, Data3 = #rank_soul_world_spirit{power = Power3}} ->
            rank_mgr:async({in_rank, ?rank_soul_world_spirit, Power3, Data3});
        _ ->
            ok
    end;

%% 仙岛斗法升级信息 TODO
listener(guild_combat, RGCombat = #rank_guild_combat{accScore = Score}) when Score >= ?rank_min_guild_combat ->
    rank_mgr:async({in_rank, ?rank_guild_combat, Score, RGCombat});

%% 上场仙岛斗法升级信息 TODO
listener(guild_last, RGLast = #rank_guild_last{score = Score}) when Score >= ?rank_min_guild_last ->
    rank_mgr:async({in_rank, ?rank_guild_last, Score, RGLast});

%% 个人战功升级信息 TODO
listener(guild_exploits, RGExploits = #rank_guild_exploits{score = Score})when Score >= ?rank_min_guild_exploits ->
    rank_mgr:async({in_rank, ?rank_guild_exploits, Score, RGExploits});

%% 累积送花排行榜
listener(flower, Role) ->
    case rank_convert:do(to_flower_acc, Role) of
        {ok, Data = #rank_flower_acc{flower = Flower}} when Flower >= ?rank_min_flower_acc ->
            rank_mgr:async({in_rank, ?rank_flower_acc, Flower, Data});
        _ ->
            ok
    end;

%% 累积魅力排行榜
listener(glamor, Role) ->
    case rank_convert:do(to_glamor_acc, Role) of
        {ok, Data = #rank_glamor_acc{glamor = Glamor}} when Glamor >= ?rank_min_glamor_acc ->
            rank_mgr:async({in_rank, ?rank_glamor_acc, Glamor, Data});
        _ ->
            ok
    end;

%% 今日送花
listener(flower_day, Role) ->
    case rank_convert:do(to_flower_day, Role) of
        {ok, Data = #rank_flower_day{flower = Flower}} when Flower >= ?rank_min_flower_day ->
            rank_mgr:async({in_rank, ?rank_flower_day, Flower, Data});
        _ -> ok
    end;

%% 今日魅力
listener(glamor_day, Role) ->
    case rank_convert:do(to_glamor_day, Role) of
        {ok, Data = #rank_glamor_day{glamor = Glamor}} when Glamor >= ?rank_min_glamor_day ->
            rank_mgr:async({in_rank, ?rank_glamor_day, Glamor, Data});
        _ -> ok
    end;


%% 累积人气排行榜 TODO
listener(popu_acc, RPAcc = #rank_popu_acc{popu = Popu}) when Popu >= ?rank_min_popu_acc ->
    rank_mgr:async({in_rank, ?rank_popu_acc, Popu, RPAcc});

%% 上场答题排行
%% listener(wit_last, []) -> ok;
listener(wit_last, QList) when is_list(QList) ->
    rank_mgr:async({clear, ?rank_wit_last}),
    lists:foreach(fun(Q) ->
                case rank_convert:do(to_wit_last, Q) of
                    {ok, Data = #rank_wit_last{score = Score}} when Score >= ?rank_min_wit_last ->
                        rank_mgr:async({in_rank, ?rank_wit_last, Score, Data});
                    _ ->
                        ok
                end
        end, QList),
    rank_mgr:async({update_honor, ?rank_wit_last});

%% 监听宠物
listener(pet, Role) ->
    % case rank_convert:do(to_role_pet, Role) of
    %     {ok, Data1 = #rank_role_pet{petlev = PetLev}} when PetLev >= ?rank_min_role_pet ->
    %         rank_mgr:async({in_rank, ?rank_role_pet, PetLev, Data1});
    %     _ ->
    %         rank_mgr:async({exit_rank, ?rank_role_pet, Role#role.id})
    % end,
    case rank_convert:do(to_role_pet_power, Role) of
        {ok, Data2 = #rank_role_pet_power{power = Power1}} when Power1 >= ?rank_min_role_pet_power ->
            ?DEBUG("---监听宠物-power-:~w~n",[Power1]),
            rank_mgr:async({in_rank, ?rank_role_pet_power, Power1, Data2});
        _ ->
            rank_mgr:async({exit_rank, ?rank_role_pet_power, Role#role.id})
    end,
    % case rank_convert:do(to_pet_grow, Role) of
    %     {ok, Data3 = #rank_pet_grow{grow = Grow}} ->
    %         rank_mgr:async({in_rank, ?rank_pet_grow, Grow, Data3});
    %     _ ->
    %         ok
    % end,
    % case rank_convert:do(to_pet_potential, Role) of
    %     {ok, Data4 = #rank_pet_potential{potential = AvgVal}} ->
    %         rank_mgr:async({in_rank, ?rank_pet_potential, AvgVal, Data4});
    %     _ ->
    %         ok
    % end,
    case rank_convert:do(to_total_power, Role) of
        {ok, Data5 = #rank_total_power{total_power = TotalPower}} when TotalPower >= ?rank_min_total_power ->
            rank_mgr:async({in_rank, ?rank_total_power, TotalPower, Data5});
        _ ->
            rank_mgr:async({exit_rank, ?rank_total_power, Role#role.id})
    end;
    % case pet_api:get_max(#pet.type, Role) of
    %     #pet{type = PetType} -> rank_celebrity:listener(pet_type, Role, PetType);
    %     _ -> ok
    % end,
    % case pet_api:get_max(#pet.fight_capacity, Role) of
    %     Pet = #pet{fight_capacity = PetPower, skill = Skills} -> 
    %         campaign_listener:handle(pet, Role, Pet),
    %         rank_celebrity:listener(pet_power, Role, PetPower),
    %         rank_celebrity:listener(pet_skill, Role, Skills);
    %     _ -> ok
    % end;

%% 坐骑
listener(mount, Role) ->
    case lists:keyfind(?item_zuo_qi, #item.type, Role#role.eqm) of
        false -> ok;
        Item -> listener(mount, Role, Item)
    end;

listener(_Cmd, _Role) ->
    ok.

%%----------------------------------------------------
%% @spec listener(Type, OldRole, NewRole) -> ok
%% Type = atom()
%% OldRole = NewRole = #role{}
%% @doc 排行榜监听函数
%%---------------------------------------------------

%% 监听帮会战斗力
listener(guild_fc, Guild, FC) when is_record(Guild, guild) ->
    % FC = guild_common:guild_fc({Gid, Srvid}),
    ?DEBUG("----军团战力~p~n~n~n~n~n~n--", [FC]),
    case rank_convert:do(to_guild_power, Guild) of
        {ok, Data} when FC >= ?rank_min_guild_power ->
            rank_mgr:async({in_rank, ?rank_guild_power, FC, Data#rank_guild_power{power = FC}});
            % rank_celebrity:listener(guild_lev, Guild, Lev);
        _ ->
            ok
    end;

%% 金币达人榜
listener(darren_coin, #role{assets = #assets{coin = OldCoin, coin_bind = OldCoinBind}}, NewRole = #role{assets = #assets{coin = NewCoin, coin_bind = NewCoinBind}}) when NewCoin + NewCoinBind < OldCoin + OldCoinBind ->
    Val = OldCoin + OldCoinBind - NewCoin - NewCoinBind,
    rank_role_info:async({update_info, darren_coin, NewRole, Val});
listener(darren_coin, Role, Val) when is_integer(Val) ->
    case rank_convert:do(to_darren_coin, {Role, Val}) of
        {ok, Data = #rank_darren_coin{}} ->
            rank_mgr:async({in_rank, ?rank_darren_coin, Val, Data});
        _ -> 
            ok
    end;

%% 经验达人榜
listener(darren_exp, #role{lev = OldLev, assets = #assets{exp = OldExp}}, NewRole = #role{lev = NewLev, assets = #assets{exp = NewExp}}) when OldLev < NewLev orelse OldExp < NewExp ->
    Val = case OldLev =:= NewLev of
        true -> NewExp - OldExp;
        false -> 
            L = lists:seq(OldLev, NewLev - 1),
            ExpL = [role_exp_data:get(Lev) || Lev <- L],
            lists:sum(ExpL) + NewExp - OldExp
    end,
    rank_role_info:async({update_info, darren_exp, NewRole, Val});
listener(darren_exp, Role, Val) when is_integer(Val) ->
    case rank_convert:do(to_darren_exp, {Role, Val}) of
        {ok, Data = #rank_darren_exp{}} ->
            rank_mgr:async({in_rank, ?rank_darren_exp, Val, Data});
        _ -> 
            ok
    end;

%% 阅历达人榜
listener(darren_attainment, #role{assets = #assets{attainment = OldAtta}}, NewRole = #role{assets = #assets{attainment = NewAtta}}) when NewAtta > OldAtta ->
    Val = NewAtta - OldAtta,
    rank_role_info:async({update_info, darren_attainment, NewRole, Val});
listener(darren_attainment, Role, Val) when is_integer(Val) ->
    case rank_convert:do(to_darren_attainment, {Role, Val}) of
        {ok, Data = #rank_darren_attainment{}} ->
            rank_mgr:async({in_rank, ?rank_darren_attainment, Val, Data});
        _ -> 
            ok
    end;

%% 试练积分排行榜
listener(practice, #role{assets = #assets{practice_acc = Acc1}}, NewRole = #role{assets = #assets{practice_acc = Acc2}}) when Acc1 =/= Acc2 ->
    case rank_convert:do(to_rank_practice, NewRole) of
        {ok, Data = #rank_practice{score = Score}} when Score >= ?rank_min_practice ->
            rank_mgr:async({in_rank, ?rank_practice, Score, Data});
        _ ->
            ok
    end;

%% 竞技场累计积分
listener(vie_acc, #role{assets = #assets{acc_arena = Acc1}}, NewRole = #role{assets = #assets{acc_arena = Acc2}}) when Acc1 =/= Acc2 ->
    case rank_convert:do(to_vie_acc, NewRole) of
        {ok, Data = #rank_vie_acc{score = Score}} when Score >= ?rank_min_vie_acc ->
            rank_mgr:async({in_rank, ?rank_vie_acc, Score, Data});
        _ -> 
            ok
    end;

%% 监听战斗力
listener(power, 
    #role{attr = #attr{fight_capacity = Power1}}, 
    Role = #role{id = {Rid, Srvid}, lev = _Lev, attr = #attr{fight_capacity = Power2}}) when Power1 =/= Power2 ->
    % friend:listener_power2kuafu(Role#role.id, Lev, Power2), %% 监测跨服好友聊天
    % case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
    %     Guild when is_record(Guild, guild) ->
    %         rank:listener(guild_fc, Guild),
    %         ok;
    %     _ ->
    %        ok
    % end,

    medal_mgr ! {update_role, Rid, Srvid, Power2},

    case rank_convert:do(to_role_power, Role) of
        {ok, Data1 = #rank_role_power{power = Power}} when Power >= ?rank_min_role_power ->
            ?DEBUG("--监听战斗力--\n"),
            rank_mgr:async({in_rank, ?rank_role_power, Power, Data1}),
            rank_celebrity:listener(fight_capacity, Role, Power2);
        _ ->
            ok
    end,
    case rank_convert:do(to_total_power, Role) of
        {ok, Data2 = #rank_total_power{total_power = TotalPower}} when TotalPower >= ?rank_min_total_power ->
            rank_mgr:async({in_rank, ?rank_total_power, TotalPower, Data2});
        _R ->
            rank_mgr:async({exit_rank, ?rank_total_power, Role#role.id})
    end;
    % campaign_listener:handle(power, Role, 1);  %% 活动事件
    

%% 监听装备
listener(equip, OldRole, NewRole = #role{eqm = _Eqm}) ->
    arms_rank(OldRole, NewRole),
    armor_rank(OldRole, NewRole, to_eqm_type(?armor_pos_jacket)),
    armor_rank(OldRole, NewRole, to_eqm_type(?armor_pos_belt)),
    armor_rank(OldRole, NewRole, to_eqm_type(?armor_pos_cuff)),
    armor_rank(OldRole, NewRole, to_eqm_type(?armor_pos_nipper)),
    armor_rank(OldRole, NewRole, to_eqm_type(?armor_pos_pants)),
    armor_rank(OldRole, NewRole, to_eqm_type(?armor_pos_shoes)),
    rank_celebrity:listener(suit, NewRole, NewRole#role.eqm);
    % [rank_celebrity:listener(on_eqm, NewRole, {Pos, N}) || #item{pos = Pos, enchant = N} <- Eqm, N >= 10],
    % campaign_listener:handle(eqm, NewRole, 1);

%% 监听成就
listener(achieve, #role{achievement = #role_achievement{value = Ach1}}, 
    NewRole = #role{achievement = #role_achievement{value = Ach2}}
) when Ach1 =/= Ach2 ->
    case rank_convert:do(to_role_achieve, NewRole) of
        {ok, Data = #rank_role_achieve{achieve = Achieve}} when Achieve >= ?rank_min_role_achieve ->
            rank_mgr:async({in_rank, ?rank_role_achieve, Achieve, Data});
        _ ->
            ok
    end;

%% 寻宝达人榜
listener(casino, Role = #role{rank = L}, N) ->
    Now = util:unixtime(),
    {NewL, Val} = case lists:keyfind(?rank_darren_casino, 1, L) of
        {?rank_darren_casino, X, Time} ->
            case util:is_same_day2(Time, Now) of
                true -> {lists:keyreplace(?rank_darren_casino, 1, L, {?rank_darren_casino, X + N, Now}), X + N};
                false -> {lists:keyreplace(?rank_darren_casino, 1, L, {?rank_darren_casino, N, Now}), N}
            end;
        _ -> 
            {[{?rank_darren_casino, N, Now} | L], N}
    end,
    NewRole = Role#role{rank = NewL},
    case rank_convert:do(to_darren_casino, {NewRole, Val}) of
        {ok, Data = #rank_darren_casino{}} ->
            rank_mgr:async({in_rank, ?rank_darren_casino, Val, Data});
        _ -> 
            ok
    end,
    NewRole;

%% 竞技场杀人数
listener(arena_kill, Role = #role{rank = L}, Kill) ->
    {NewRole, TotalKill} = case lists:keyfind(?rank_vie_kill, 1, L) of
        {?rank_vie_kill, Val} ->
            NewL = lists:keyreplace(?rank_vie_kill, 1, L, {?rank_vie_kill, Val + Kill}),
            {Role#role{rank = NewL}, Val + Kill};
        _ -> 
            {Role#role{rank = [{?rank_vie_kill, Kill} | L]}, Kill}
    end,
    case rank_convert:do(to_vie_kill, NewRole) of
        {ok, Data = #rank_vie_kill{kill = AccKill}} when AccKill >= ?rank_min_vie_kill ->
            rank_mgr:async({in_rank, ?rank_vie_kill, AccKill, Data}),
            rank_celebrity:listener(arena_kill, Role, AccKill);
        _ -> 
            ok
    end,
    role_listener:special_event(NewRole, {20022, TotalKill});


%% 坐骑战斗力
listener(mount, Role, _MountItem) ->
    case rank_convert:do(to_mount_power, Role) of
        {ok, Data = #rank_mount_power{power = Power}} when Power >= ?rank_min_mount_power ->
            rank_mgr:async({in_rank, ?rank_mount_power, Power, Data});
        _ ->
            ok
    end,
    case rank_convert:do(to_mount_lev, Role) of
        {ok, Data2 = #rank_mount_lev{mount_lev = MountLev}} ->
            rank_mgr:async({in_rank, ?rank_mount_lev, MountLev, Data2});
        _ ->
            ok
    end;

%% 角色仙道会数据
listener(world_compete, Role, WorldMark) ->
    case rank_convert:do(to_world_compete_win, {Role, WorldMark}) of
        {ok, Data = #rank_world_compete_win{win_count = WinCount}} ->
            rank_mgr:async({in_rank, ?rank_world_compete_win, WinCount, Data});
        _ ->
            ok
    end;

listener(_Cmd, _Role1, _Role2) ->
    ?DEBUG("Error -- _Cmd :~p~n~n", _Cmd),
    ok.

%% @spec has_open_celebrity() -> boolean()
%% @doc 看看还有没有可追求的名人榜位置
%% @author Jange 2012/4/13
has_open_celebrity() ->
    NowList = list(?rank_celebrity),
    BaseList = rank_data_celebrity:list(),
    has_open_celebrity(BaseList, NowList).

has_open_celebrity([], _) ->
    false;
has_open_celebrity([Id | Rest], NowList) ->
    case lists:keyfind(Id, #rank_global_celebrity.id, NowList) of
        false -> true;
        _ ->
            has_open_celebrity(Rest, NowList)
    end.

%% 武器排行榜检测
arms_rank(#role{id = {Rid, Srvid}, eqm = PreEqm}, NewRole = #role{eqm = NewEqm}) ->
    ?DEBUG("-武器排行榜检测--\n"),
    case eqm:find_eqm_by_id(NewEqm, to_eqm_type(?arms_pos)) of
        {ok, #item{quality = _Q, require_lev = _Lev}} ->  %% 换上了新武器
            case rank_convert:do(to_equip_arms, NewRole) of
                {ok, Data = #rank_equip_arms{score = Score}} when Score >= ?rank_min_arms ->
                    ?DEBUG("-武器排行榜检测评分----:~w~n",[Score]),
                    rank_mgr:async({exit_rank, ?rank_arms, {Rid, Srvid}}),
                    rank_mgr:async({in_rank, ?rank_arms, Score, Data});
                _ ->
                    ok
            end;
        _ ->    %% 脱下武器
            case eqm:find_eqm_by_id(PreEqm, to_eqm_type(?arms_pos)) of
                % {ok, #item{quality = Q}} when Q >= ?quality_purple ->  %% 换上了新武器
                {ok, #item{quality = _Q}} ->  %% 换上了新武器
                    rank_mgr:async({exit_rank, ?rank_arms, {Rid, Srvid}});
                _ ->
                    ok
            end
    end.

%% 防具排行榜检测
armor_rank(Role = #role{id = {Rid, Srvid}, eqm = PreEqm}, NewRole = #role{eqm = NewEqm}, Type) ->
    ?DEBUG("--防具排行榜检测---:~w~n",[Type]),
    % ?DEBUG("--防具排行榜检测-old--:~w~n",[PreEqm]),
    % ?DEBUG("--防具排行榜检测-new--:~w~n",[NewEqm]),
    case eqm:find_eqm_by_id(NewEqm, Type) of
        % {ok, #item{quality = Q, require_lev = _Lev}} when Q >= ?quality_pink ->  %% 换上了新防具
        {ok, #item{quality = _Q, require_lev = _Lev}} ->  %% 换上了新防具
            % ?DEBUG("---quality--:~w~n",[Q]),
            % rank_celebrity:listener(armor_quality, NewRole, {Lev, Q}),
            case rank_convert:do({to_equip_armor, Role, Type}, NewRole) of
                {ok, Data = #rank_equip_armor{score = Score}} when Score >= ?rank_min_armor  ->
                    ?DEBUG("--防具排行榜检测--评分--:~w~n",[Score]),
                    rank_mgr:async({exit_rank, ?rank_armor, {Rid, Srvid, Type}}),
                    rank_mgr:async({in_rank, ?rank_armor, Score, Data});
                _ ->
                    ?DEBUG("--Convert error-\n"),
                    ok
            end;
        _ ->  
            ?DEBUG("---find none--\n"),  
            case eqm:find_eqm_by_id(PreEqm, Type) of
                % {ok, #item{quality = Q}} when Q >= ?quality_pink ->  
                {ok, #item{quality = _Q}} ->  
                    rank_mgr:async({exit_rank, ?rank_armor, {Rid, Srvid, Type}});
                _ ->
                    ok
            end
    end.

%% 财富排行榜检测
coin_rank(#role{assets = #assets{coin = Coin1}}, NewRole = #role{assets = #assets{coin = Coin2}}) ->
    case Coin1 =/= Coin2 of
        true ->
            case rank_convert:do(to_role_coin, NewRole) of
                {ok, Data = #rank_role_coin{coin = Coin}} when Coin >= ?rank_min_role_coin ->
                    rank_mgr:async({in_rank, ?rank_role_coin, Coin, Data});
                _ ->
                    ok
            end;
        false ->
            ok
    end.

armor_rank_by_type(Type,_Role = #role{id={Rid, Srvid}}) ->
    Data = list(?rank_armor),
    % NData = lists:filtermap(fun(E = #rank_equip_armor{type = T}) -> case T == Type of true -> {true,E}; _ -> false end end ,Data),
    NData = [E ||E = #rank_equip_armor{type = T} <-Data, T =:= Type],
    {IdPos, _} = rank_mgr:keys(?rank_armor),
    {N, _} = find_sort_num(1, {Rid, Srvid}, IdPos, lists:keysort(#rank_equip_armor.score, NData)),
    N.

eqm_rank2(_Role = #role{id={Rid, _Srvid}}) ->
    Data1 = list(?rank_armor),
    Data2 = list(?rank_arms),
    NData = Data1 ++ Data2,
    {N, _} = find_sort_num(1, Rid, #rank_equip_armor.rid, lists:keysort(#rank_equip_armor.score, NData)),
    ?DEBUG("----N---~w~n",[N]),
    N.


%% 根据职业取战斗力最前的角色ID
find_max_power(Career) ->
    L = list(?rank_role_power),
    case [R || R <- L, R#rank_role_power.career =:= Career] of
        [] -> false;
        [I | _T] -> I#rank_role_power.id
    end.

%% 数据保存测试
test_save() ->
    rank_dao:save().

%% 获取各类排行榜数据 信息
list(Type) ->
    #rank{roles = L} = rank_mgr:lookup(Type),
    L.

%% 获取综合战力排名
fight_rank(Role) when is_record(Role, role) ->
    case rank:sort_num(?rank_total_power, Role) of
        0 -> 0;
        N -> N
    end;
fight_rank({Rid, Srvid}) ->
    case rank:sort_num(?rank_total_power, {Rid, Srvid}) of
        0 -> 0;
        N -> N
    end.
%% 获取战力排行的名次
%% @spec fight_capacity_rank({Rid, Srvid}) -> ::integer()
fight_capacity_rank({Rid, Srvid}) ->
    case rank:sort_num(?rank_role_power, {Rid, Srvid}) of
        0 -> 0;
        N -> N
    end.

%% 获取等级排名
lev_rank(Role) ->
    case rank:sort_num(?rank_role_lev, Role) of
        0 -> 0;
        N -> N
    end.

%% 获取玩家元神评分
get_channel_score(Role) ->
    case rank_convert:do(to_role_soul, Role) of      
        {ok, #rank_role_soul{soul = Soul}} ->
            Soul;
        _ ->
            0
    end.

%% @spec sort_num(Type, Role) -> N;
%% @doc 获取角色排行位置
%% Type = integer() 排行榜类型 副本评分排行榜为评分ID
%% Role = #role{} | {Rid, Srvid}
%% N = integer() 排序位置 0:表示不在榜上
sort_num(?rank_guild_power, #role{guild = #role_guild{gid = Gid, srv_id = SrvId}}) ->
    sort_num(?rank_guild_power, {Gid, SrvId});

%%伐龙
sort_num(?rank_super_boss, #role{id = Rid}) ->
    super_boss_mgr:sort_num(Rid);

sort_num(Type, #role{id = {Rid, Srvid}}) ->
    sort_num(Type, {Rid, Srvid});
sort_num(Type, {Rid, Srvid}) ->
    Data = list(Type),
    % ?DEBUG("--Data---~p~n~n~n~n", [Data]),
    {IdPos, _} = rank_mgr:keys(Type),
    {N, _} = find_sort_num(1, {Rid, Srvid}, IdPos, Data),
    N.

find_sort_num(_N, _Id, _IdPos, []) -> 
    {0, false}; %% 不在榜上
find_sort_num(N, Id, IdPos, [I | T]) ->
    case element(IdPos, I) of
        Id -> {N, I};
        _ -> find_sort_num(N + 1, Id, IdPos, T)
    end.

%% 获取装备物品类排行TIP
get_rank_item(Rid, Srvid, ?arms_pos) -> %% 武器类
    L = list(?rank_arms),
    case lists:keyfind({Rid, Srvid}, #rank_equip_arms.id, L) of
        #rank_equip_arms{item = Item} -> Item;
        _ -> false
    end;
get_rank_item(Rid, Srvid, Type) -> %% 防具类
    L = list(?rank_armor),
    case lists:keyfind({Rid, Srvid, Type}, #rank_equip_armor.id, L) of
        #rank_equip_armor{item = Item} -> Item;
        _ -> false
    end.

%% 获取角色属性数据
get_rank_role_attr(Rid, Srvid, ?rank_role_lev) -> %% 等级排行榜
    L = list(?rank_role_lev),
    case lists:keyfind({Rid, Srvid}, #rank_role_lev.id, L) of
        #rank_role_lev{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> 
            {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, ?rank_role_coin) -> %% 财富排行榜
    L = list(?rank_role_coin),
    case lists:keyfind({Rid, Srvid}, #rank_role_coin.id, L) of
        #rank_role_coin{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> 
            {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, ?rank_role_power) -> %% 战斗力排行榜
    L = list(?rank_role_power),
    case lists:keyfind({Rid, Srvid}, #rank_role_power.id, L) of
        #rank_role_power{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> 
            {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, ?rank_total_power) ->
    L = list(?rank_total_power),
    case lists:keyfind({Rid, Srvid}, #rank_total_power.id, L) of
        #rank_total_power{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, ?rank_cross_total_power) ->
    L = list(?rank_cross_total_power),
    case lists:keyfind({Rid, Srvid}, #rank_cross_total_power.id, L) of
        #rank_cross_total_power{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_mount_power) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_mount_power.id, L) of
        #rank_mount_power{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_cross_mount_power) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_cross_mount_power.id, L) of
        #rank_cross_mount_power{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;

get_rank_role_attr(Rid, Srvid, Type = ?rank_cross_world_compete_winrate) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_world_compete.id, L) of
        #rank_world_compete{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_world_compete_winrate) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_world_compete.id, L) of
        #rank_world_compete{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_platform_world_compete_winrate) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_world_compete.id, L) of
        #rank_world_compete{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_cross_world_compete_lilian) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_world_compete.id, L) of
        #rank_world_compete{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_world_compete_lilian) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_world_compete.id, L) of
        #rank_world_compete{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_platform_world_compete_lilian) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_world_compete.id, L) of
        #rank_world_compete{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_world_compete_section) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_world_compete.id, L) of
        #rank_world_compete{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;
get_rank_role_attr(Rid, Srvid, Type = ?rank_platform_world_compete_section) ->
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_world_compete.id, L) of
        #rank_world_compete{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end;

get_rank_role_attr(_Rid, _Srvid, _Type) -> %% 容错
    false.

%% 获取宠物属性数据
get_rank_pet(Rid, Srvid, ?rank_role_pet) -> 
    L = list(?rank_role_pet),
    case lists:keyfind({Rid, Srvid}, #rank_role_pet.id, L) of
        #rank_role_pet{pet = Pet} -> Pet;
        _ -> false
    end;
get_rank_pet(Rid, Srvid, ?rank_role_pet_power) -> 
    L = list(?rank_role_pet_power),
    case lists:keyfind({Rid, Srvid}, #rank_role_pet_power.id, L) of
        #rank_role_pet_power{pet = Pet} -> Pet;
        _ -> false
    end;
get_rank_pet(Rid, Srvid, ?rank_total_power) ->
    L = list(?rank_total_power),
    case lists:keyfind({Rid, Srvid}, #rank_total_power.id, L) of
        #rank_total_power{pet = Pet} -> Pet;
        _ -> false
    end;
get_rank_pet(Rid, Srvid, ?rank_cross_total_power) ->
    L = list(?rank_cross_total_power),
    case lists:keyfind({Rid, Srvid}, #rank_cross_total_power.id, L) of
        #rank_cross_total_power{pet = Pet} -> Pet;
        _ -> false
    end;
get_rank_pet(Rid, Srvid, Type = ?rank_cross_role_pet_power) -> 
    L = list(Type),
    case lists:keyfind({Rid, Srvid}, #rank_cross_role_pet_power.id, L) of
        #rank_cross_role_pet_power{pet = Pet} -> Pet;
        _ -> false
    end;
get_rank_pet(_Rid, _Srvid, _Type) ->
    false.

%% @spec role_ranks(Role) -> List
%% Role = #role{}
%% 获取角色所有的排行榜
role_ranks(#role{id = {Rid, Srvid}}) ->
    L1 = get_role_rank(?rank_role_lev, {Rid, Srvid}, #rank_role_lev.id, #rank_role_lev.name, []),
    L2 = get_role_rank(?rank_role_coin, {Rid, Srvid}, #rank_role_coin.id, #rank_role_coin.name, L1),
    L3 = get_role_rank(?rank_role_pet, {Rid, Srvid}, #rank_role_pet.id, #rank_role_pet.name, L2),
    L4 = get_role_rank(?rank_role_pet_power, {Rid, Srvid}, #rank_role_pet_power.id, #rank_role_pet_power.name, L3),
    L5 = get_role_rank(?rank_role_power, {Rid, Srvid}, #rank_role_power.id, #rank_role_power.name, L4),
    L6 = get_role_rank(?rank_role_soul, {Rid, Srvid}, #rank_role_soul.id, #rank_role_soul.name, L5),
    L7 = get_role_rank(?rank_role_skill, {Rid, Srvid}, #rank_role_skill.id, #rank_role_skill.name, L6),
    L8 = get_role_rank(?rank_role_achieve, {Rid, Srvid}, #rank_role_achieve.id, #rank_role_achieve.name, L7),
    L9 = get_role_rank(?rank_arms, {Rid, Srvid}, #rank_equip_arms.id, #rank_equip_arms.name, L8),
    L10 = get_role_rank(?rank_armor, {Rid, Srvid}, #rank_equip_armor.id, #rank_equip_armor.name, L9),
    L11 = get_role_rank(?rank_vie_acc, {Rid, Srvid}, #rank_vie_acc.id, #rank_vie_acc.name, L10),
    L12 = get_role_rank(?rank_vie_kill, {Rid, Srvid}, #rank_vie_kill.id, #rank_vie_kill.name, L11),
    L13 = get_role_rank(?rank_flower_acc, {Rid, Srvid}, #rank_flower_acc.id, #rank_flower_acc.name, L12),
    L14 = get_role_rank(?rank_glamor_acc, {Rid, Srvid}, #rank_glamor_acc.id, #rank_glamor_acc.name, L13),
    L15 = get_role_rank(?rank_wit_acc, {Rid, Srvid}, #rank_wit_acc.id, #rank_wit_acc.name, L14),
    L16 = get_role_rank(?rank_total_power, {Rid, Srvid}, #rank_total_power.id, #rank_total_power.name, L15),
    L = get_role_rank(?rank_cross_total_power, {Rid, Srvid}, #rank_cross_total_power.id, #rank_cross_total_power.name, L16),
    %% ?DEBUG("list:~w", [L]),
    L.

%%----------------------------------------------------------------
%% 内部方法
%%----------------------------------------------------------------

%% 查询角色个人排行信息
get_role_rank(Type, ID, IdPos, NamePos, List) ->
    #rank{roles = L} = rank_mgr:lookup(Type),
    get_role_rank(Type, L, ID, IdPos, NamePos, List).
get_role_rank(_Type, [], _ID, _IdPos, _NamePos, List) ->
    List;
get_role_rank(Type, [H|T], ID = {Rid, Srvid}, IdPos, NamePos, List) ->
    case element(IdPos, H) of
        {Rid, Srvid}-> %% 双键类排行榜 排在第一位 无上一级玩家
            [{Type, 1, <<>>, 0, <<>>, 1} | List];
        {Rid, Srvid, ItemType} -> %% 三键类排行榜 排在第一位 无上一级玩家
            [{Type, 1, <<>>, 0, <<>>, ItemType} | List];
            %% get_role_rank(Type, H, T, ID, IdPos, NamePos, 2, [{Type, 1, <<>>, 0, <<>>, ItemType} | List]);
        _ -> %% 不在第一位 存在上一级玩家
            get_role_rank(Type, H, T, ID, IdPos, NamePos, 2, List)
    end.
get_role_rank(_Type, _PrevH, [], _ID, _IdPos, _NamePos, _Index, List) -> %% 第二名以后查找 
    List;
get_role_rank(Type, PrevH ,[H | L], ID = {Rid, Srvid}, IdPos, NamePos, Index, List) ->
    case element(IdPos, H) of
        {Rid, Srvid} -> %% 双键类排行榜 在榜上
            {PrevRid, PrevSrvid} = element(IdPos, PrevH),
            [{Type, Index, PrevSrvid, PrevRid, element(NamePos, PrevH), 1} | List];
        {Rid, Srvid, _} -> %% 三键类排行榜 防具类排行榜 需历遍整个列表
            {PrevRid, PrevSrvid, ItemType} = element(IdPos, PrevH),
            [{Type, Index, PrevSrvid, PrevRid, element(NamePos, PrevH), ItemType} | List]; 
            %% get_role_rank(Type, H, L, ID, IdPos, NamePos, Index + 1, [Info | List]);
        _ ->
            get_role_rank(Type, H, L, ID, IdPos, NamePos, Index + 1, List)
    end.


%% rank.hrl到item.hrl的转化
to_eqm_type(?arms_pos) -> ?item_weapon;
to_eqm_type(?armor_pos_jacket) -> ?item_yi_fu;
to_eqm_type(?armor_pos_belt) -> ?item_yao_dai;
to_eqm_type(?armor_pos_cuff) -> ?item_hu_wan;
to_eqm_type(?armor_pos_nipper) -> ?item_hu_shou;
to_eqm_type(?armor_pos_pants) -> ?item_ku_zi;
to_eqm_type(?armor_pos_shoes) -> ?item_xie_zi.
