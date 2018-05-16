%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 九月 2015 下午8:17
%%%-------------------------------------------------------------------
-module(dungeon_util).
-author("fancy").
-include("common.hrl").
-include("dungeon.hrl").
-include("server.hrl").
-include("daily.hrl").
-include("drop.hrl").
%% API
-export([
    parse_dungeon_scene/2
    , add_dungeon_times/1       %%增加副本次数
    , add_dungeon_times/2
    , sub_dungeon_times/2
    , get_dungeon_times/1       %%查询副本次数
    , get_dungeon_buy/1
    , add_dungeon_buy/1
    , make_dungeon_mb/2
    , get_dungeon_name/1
    , get_dungeon_lv/1
    , is_dungeon_normal/1
    , is_dungeon_material/1
    , is_dungeon_cross/1
    , is_dungeon_guard_cross/1
    , is_dungeon_arena/1
    , is_dungeon_daily/1
    , is_dungeon_tower/1
    , is_dungeon_demon/1
    , is_dungeon_fuwen_tower/1
    , is_dungeon_god_weapon/1
    , is_dungeon_vip/1
    , is_dungeon_guard/1
    , is_dungeon_equip/1
    , is_dungeon_xian/1
    , log_dungeon/7
    , get_dungeon_time/1
    , activity_extra_drop/2
    , is_dungeon_exp/1
    , is_dungeon_marry/1
    , is_dungeon_godness/1
    , is_dungeon_elite_boss/1
    , is_dungeon_guild_fight/1
    , is_dungeon_element/1
    , is_dungeon_jiandao/1
]).


%%副本玩家基础
make_dungeon_mb(Player, Now) ->
    {Scene, X, Y, Copy} =
        case scene:is_normal_scene(Player#player.scene) of
            false ->
                case ets:lookup(?ETS_DUN_MB_POS, Player#player.key) of
                    [] ->
                        SceneData = data_scene:get(?SCENE_ID_MAIN),
                        {?SCENE_ID_MAIN, SceneData#scene.x, SceneData#scene.y, 0};
                    [Pos] ->
                        {Pos#ets_dun_mb_pos.scene, Pos#ets_dun_mb_pos.x, Pos#ets_dun_mb_pos.y, Pos#ets_dun_mb_pos.copy}
                end;
            true ->
                ets:insert(?ETS_DUN_MB_POS, #ets_dun_mb_pos{pkey = Player#player.key, scene = Player#player.scene, copy = Player#player.copy, x = Player#player.x, y = Player#player.y}),
                {Player#player.scene, Player#player.x, Player#player.y, Player#player.copy}
        end,
    ?DEBUG("Player#player.attribute#attribute.att:~p", [Player#player.attribute#attribute.att]),
    #dungeon_mb{
        node = node(),
        join_time = Now,
        pkey = Player#player.key,
        sn = config:get_server_num(),
        nickname = Player#player.nickname,
        pid = Player#player.pid,
        sid = Player#player.sid,
        scene = Scene,
        x = X,
        y = Y,
        copy = Copy,
        lv = Player#player.lv,
        career = Player#player.career,
        sex = Player#player.sex,
        avatar = Player#player.avatar,
        power = Player#player.cbp,
        att = Player#player.attribute#attribute.att,
        vip = Player#player.vip_lv,
        fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
        light_weaponid = Player#player.light_weaponid,
        wing_id = Player#player.wing_id,
        clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
        weapon_id = Player#player.equip_figure#equip_figure.weapon_id,
        pet_type_id = Player#player.pet#fpet.type_id,
        pet_figure = Player#player.pet#fpet.figure,
        pet_name = Player#player.pet#fpet.name,
        merge_exp_mul = Player#player.merge_exp_mul
    }.

%%解释副本场景数据
parse_dungeon_scene([], Scenelist) -> Scenelist;
parse_dungeon_scene([{Did, Bool} | L], SceneList) ->
    Dungeon = data_dungeon:get(Did),
    DunScene = #dungeon_scene{
        id = Did,
        sid = Dungeon#dungeon.sid,
        condition = Dungeon#dungeon.condition,
        enable = Bool},
    parse_dungeon_scene(L, [DunScene | SceneList]).


%%增加副本次数
add_dungeon_times(DunId) ->
    daily:increment(?DAILY_DUNGEON_COUNT(DunId), 1).

add_dungeon_times(DunId, Times) ->
    daily:increment(?DAILY_DUNGEON_COUNT(DunId), Times).

sub_dungeon_times(DunId, Times) ->
    daily:decrement(DunId, Times).

%%获取副本次数
get_dungeon_times(DunId) ->
    daily:get_count(?DAILY_DUNGEON_COUNT(DunId)).

%%查询副本购买次数
get_dungeon_buy(DunId) ->
    daily:get_count(?DAILY_DUNGEON_BUY(DunId)).

%%增加购买次数
add_dungeon_buy(DunId) ->
    daily:increment(?DAILY_DUNGEON_BUY(DunId), 1).

%%获取副本名称
get_dungeon_name(DunId) ->
    case data_dungeon:get(DunId) of
        [] -> <<>>;
        Dun -> Dun#dungeon.name
    end.

%%获取副本等级
get_dungeon_lv(DunId) ->
    case data_dungeon:get(DunId) of
        [] -> 0;
        Dun -> Dun#dungeon.lv
    end.

%%是否普通副本
is_dungeon_normal(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_NORMAL.

%%是否材料副本
is_dungeon_material(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_MATERIAL.

%%是否每日副本
is_dungeon_daily(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_DAILY.

%%是否经验副本
is_dungeon_exp(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_EXP.

%%是否跨服组队副本
is_dungeon_cross(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_CROSS.

%%是否跨服试炼副本
is_dungeon_guard_cross(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_CROSS_GUARD.

%%是否神器副本
is_dungeon_god_weapon(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_GOD_WEAPON.

%%是否竞技场
is_dungeon_arena(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_ARENA.

%%是否仙盟对战
is_dungeon_guild_fight(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_GUILD_FIGHT.

%%是否九霄塔副本
is_dungeon_tower(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_TOWER.

is_dungeon_fuwen_tower(#scene{id = DunId}) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_FUWEN_TOWER;

is_dungeon_fuwen_tower(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_FUWEN_TOWER.

is_dungeon_marry(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_MARRY.

is_dungeon_godness(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_GODNESS.

is_dungeon_element(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_ELEMENT.

is_dungeon_jiandao(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_JIANDAO.

is_dungeon_elite_boss(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_ELITE_BOSS.

is_dungeon_xian(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_XIAN.

%%是否帮派妖魔入侵副本
is_dungeon_demon(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_GUILD_DEMON.

%%是否vip副本
is_dungeon_vip(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_VIP.

%%是否守护副本
is_dungeon_guard(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_GUARD.

%%是否神装副本
is_dungeon_equip(DunId) ->
    get_dungeon_type(DunId) == ?DUNGEON_TYPE_EQUIP.

get_dungeon_type(DunId) ->
    Key = {dungeontype, DunId},
    case get(Key) of
        undefined ->
            DunType =
                case data_dungeon:get(DunId) of
                    [] -> 0;
                    Dun ->
                        Dun#dungeon.type
                end,
            put(Key, DunType),
            DunType;
        DunType ->
            DunType
    end.


%%副本日志
log_dungeon(Pkey, Nickname, DunId, Type, IsPass, Reward, Time) ->
    Sql = io_lib:format("insert into log_dungeon set pkey = ~p,nickname = '~s',dun_id=~p,type=~p,is_pass=~p,reward = '~s',time=~p",
        [Pkey, Nickname, DunId, Type, IsPass, util:term_to_string(Reward), Time]),
    log_proc:log(Sql),
    ok.

get_dungeon_time(DunId) ->
    case data_dungeon:get(DunId) of
        [] -> 0;
        Dun ->
            Dun#dungeon.time
    end.

%%活动额外掉落
activity_extra_drop(DunType, DunId) ->
    case DunType of
        ?DUNGEON_TYPE_MATERIAL ->
            case DunId of
                50001 ->
                    data_activity_dun_drop:get(6);
                50002 ->
                    data_activity_dun_drop:get(4);
                50003 ->
                    data_activity_dun_drop:get(5);
                50004 ->
                    data_activity_dun_drop:get(3);
                50005 ->
                    data_activity_dun_drop:get(1);
                50006 ->
                    data_activity_dun_drop:get(2);
                _ -> []
            end;
        _ ->
            []
    end.