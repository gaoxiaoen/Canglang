%%----------------------------------------------------
%% 跨服排行榜RPC远程调用
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_cross_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("rank.hrl").
-include("pet.hrl").
-include("item.hrl").
-include("assets.hrl").
-include("soul_world.hrl").


%% 获取跨服宠物等级排行榜
handle(17400,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_pet_lev)}};

%% 获取跨服宠物战力排行榜
handle(17401,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_pet_power)}};

%% 获取跨服宠物成长排行榜
handle(17402,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_pet_grow)}};

%% 获取跨服宠物潜力排行榜
handle(17403,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_pet_potential)}};

%% 获取跨服个人战力排行榜
handle(17404,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_role_power)}};

%% 获取跨服个人等级排行榜
handle(17405,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_role_lev)}};

%% 获取跨服个人金币排行榜
handle(17406,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_role_coin)}};

%% 获取跨服个人技能排行榜
handle(17407,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_role_skill)}};

%% 获取跨服个人成就排行榜
handle(17408,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_role_achieve)}};

%% 获取跨服个人元神排行榜
handle(17409,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_role_soul)}};

%% 获取跨服坐骑战力排行榜
handle(17411,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_mount_power1)}};

%% 获取跨服坐骑等级排行榜
handle(17412,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_mount_lev)}};

%% 获取跨服装备武器排行榜
handle(17413,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_arms)}};

%% 获取跨服装备防具排行榜
handle(17414,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_armor)}};

%% 获取跨服帮会等级排行榜
handle(17415,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_guild_lev)}};

%% 获取跨服竞技斩杀总人数排行榜
handle(17416,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_arena_kill)}};

%% 获取跨服仙道战胜数排行榜
handle(17417,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_world_compete_win)}};

%% 获取跨服灵戒战力排行榜
handle(17418,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_soul_world)}};

%% 获取跨服魔阵等级排行榜
handle(17419,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_soul_world_array)}};

%% 获取跨服妖灵战力排行榜
handle(17420,  {}, _Role) ->
    {reply, {rank:list(?rank_cross_soul_world_spirit)}};

%% 获取角色妖灵TIP信息
handle(17491, {Rid, Srvid, Type}, _Role) ->
    %% ?DEBUG("=======================[~p, ~s, ~p]", [Rid, Srvid, Type]),
    case rank_cross:get_rank_soul_spirit_info({Rid, Srvid}, Type) of
        {Name, #soul_world_spirit{id = Id, name = SpiritName, lev = SpiritLev, quality = Q, fc = FC, array_id = ArrayId, magics = Magics}} -> 
            {reply, {Type, Name, Id, SpiritName, SpiritLev, Q, FC, ArrayId, Magics}};
        _ -> 
            ?DEBUG("查找不到角色妖灵数据[~p, ~s, ~p]", [Rid, Srvid, Type]),
            {ok}
    end;

%% 获取角色神魔阵TIP信息
handle(17492, {Rid, Srvid, Type}, _Role) ->
    %% ?DEBUG("=======================[~p, ~s, ~p]", [Rid, Srvid, Type]),
    case rank_cross:get_rank_soul_array_info({Rid, Srvid}, Type) of
        {Name, ArrayLev, Arrays = [#soul_world_array{} | _]} -> 
            {reply, {Type, Name, ArrayLev, Arrays}};
        _ -> 
            ?DEBUG("查找不到角色神魔阵数据[~p, ~s, ~p]", [Rid, Srvid, Type]),
            {ok}
    end;

%% 获取角色灵戒TIP信息
handle(17493, {Rid, Srvid, Type}, _Role) ->
    %% ?DEBUG("=======================[~p, ~s, ~p]", [Rid, Srvid, Type]),
    case rank_cross:get_rank_soul_spirits_info({Rid, Srvid}, Type) of
        {Name, Power, Arrays = [#soul_world_array{} | _], Spirits = [#soul_world_spirit{} | _]} -> 
            {reply, {Type, Name, Power, Arrays, Spirits}};
        _ -> 
            ?DEBUG("查找不到角色妖灵数据[~p, ~s, ~p]", [Rid, Srvid, Type]),
            {ok}
    end;

%% 获取角色坐骑TIP信息
handle(17494, {Rid, Srvid, Type}, _Role) ->
    %% ?DEBUG("=======================[~p, ~s, ~p]", [Rid, Srvid, Type]),
    case rank_cross:get_rank_mount_info({Rid, Srvid}, Type) of
        {Name, Power, Mount} when is_record(Mount, item) -> {reply, {Name, Power, [Mount]}};
        _ -> 
            ?DEBUG("查找不到角色坐骑数据[~p, ~s, ~p]", [Rid, Srvid, Type]),
            {ok}
    end;

%% 获取装备物品数据
handle(17495, {Rid, Srvid, Type, EqmType}, _Role) ->
    %% ?DEBUG("=======================[~p, ~s, ~p]", [Rid, Srvid, Type]),
    case rank_cross:get_rank_item(Rid, Srvid, Type, EqmType) of
        Item when is_record(Item, item) -> item:item_to_view(Item);
        _ -> 
            ?DEBUG("查找不到物品数据[~p, ~s, ~p]", [Rid, Srvid, Type]),
            {ok}
    end;

%% 获取角色属性TIP信息
handle(17496, {Rid, Srvid, Type}, _Role) ->
    %% ?DEBUG("=======================[~p, ~s, ~p]", [Rid, Srvid, Type]),
    case rank_cross:get_rank_role_info({Rid, Srvid}, Type) of
        {Career, Sex, Lev, Eqm, Looks} -> 
            NewEqm = [Item || Item <- Eqm, is_record(Item, item)],
            {reply, {Career, Sex, Lev, NewEqm, Looks}};
        false -> 
            ?DEBUG("查找不到角色数据[~p, ~s, ~p]", [Rid, Srvid, Type]),
            {ok}
    end;

%% 获取玩家宠物信息
handle(17497, {Rid, Srvid, Type}, _Role) ->
    %% ?DEBUG("=======================[~p, ~s, ~p]", [Rid, Srvid, Type]),
    case rank_cross:get_rank_pet_info({Rid, Srvid}, Type) of
        {Name, #pet{id = Id, name = PetName, type = PetType, base_id = BaseId, lev = Lev, mod = Mod, grow_val = GrowVal, happy_val = HappyVal, exp = Exp, eqm_num = EqmNum, attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq, xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal, dmg = Dmg, critrate = Cri, hp_max = HpMax, mp_max = MpMax, defence = Def, tenacity = Ten, hitrate = Hit, evasion = Eva, dmg_magic = DmgMagic, anti_js = AntiJs, anti_attack = Attack, anti_seal = Seal, anti_stone = Stone, anti_stun = Stun, anti_sleep = Sleep, anti_taunt = Taunt, anti_silent = Silent, anti_poison = Poison, blood = Blood, rebound = Rebound, resist_metal = Metal, resist_wood = Wood, resist_water = Water, resist_fire = Fire, resist_earth = Earth, xl_max = XlMax, tz_max = TzMax, js_max = JsMax, lq_max = LqMax}, attr_sys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}, skill = Skills, skill_num = SkillNum, fight_capacity = Power, bind = Bind, append_attr = AppendAttr, wish_val = Wish}} ->
            ChangeType = case AppendAttr of
                [{CType, _} | _] -> CType;
                _ -> 0
            end,
            {reply, {Rid, Srvid, Name, [{Id, PetName, PetType, BaseId, Lev, Mod, GrowVal, HappyVal, Exp, pet_data_exp:get(Lev), Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, XlPer, TzPer, JsPer, LqPer, SkillNum, Skills, Dmg, Cri, HpMax, MpMax, Def, Ten, Hit, Eva, Power, Bind, ChangeType, Wish, EqmNum, DmgMagic, AntiJs, Attack, Seal, Stone, Stun, Sleep, Taunt, Silent, Poison, Blood, Rebound, Metal, Wood, Water, Fire, Earth, XlMax, TzMax, JsMax, LqMax}]}};
        _ ->
            ?DEBUG("查找不到宠物数据[~p, ~s, ~p]", [Rid, Srvid, Type]),
            {ok}
    end;

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
