%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 十一月 2015 14:11
%%%-------------------------------------------------------------------
-module(dungeon_load).
-author("hxming").

-include("dungeon.hrl").
%% API
-compile(export_all).


select_dun_tower(Pkey) ->
    Sql = io_lib:format("select dun_list,layer,use_time,click,time from player_dun_tower where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_dun_tower(StDunTower) ->
    DunList = dungeon_tower:record2list(StDunTower#st_dun_tower.dun_list),
    Sql = io_lib:format("replace into player_dun_tower set pkey=~p,dun_list='~s',layer=~p,use_time=~p,click=~p,time=~p",
        [StDunTower#st_dun_tower.pkey,
            util:term_to_bitstring(DunList),
            StDunTower#st_dun_tower.layer,
            StDunTower#st_dun_tower.use_time,
            StDunTower#st_dun_tower.click,
            StDunTower#st_dun_tower.time
        ]),
    db:execute(Sql).

load_dun_tower_rank() ->
    Sql = "select d.pkey,p.nickname,d.layer,d.use_time from player_dun_tower AS d left join player_state as p on d.pkey = p.pkey order by layer desc, use_time asc,time asc limit 10",
    db:get_all(Sql).


load_dun_material(Pkey) ->
    Sql = io_lib:format("select dun_list,time from player_dun_material where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_dun_material(St) ->
    Sql = io_lib:format("replace into player_dun_material set pkey=~p,dun_list='~s',time=~p ",
        [St#st_dun_material.pkey, dungeon_material:dun2list(St#st_dun_material.dun_list), St#st_dun_material.time]),
    db:execute(Sql).

load_dun_exp(Pkey) ->
    Sql = io_lib:format("select round_highest,round,time from player_dun_exp where pkey=~p", [Pkey]),
    db:get_row(Sql).


replace_dun_exp(St) ->
    Sql = io_lib:format("replace into player_dun_exp set pkey=~p,round_highest=~p,round=~p,time=~p",
        [St#st_dun_exp.pkey, St#st_dun_exp.round_highest, St#st_dun_exp.round, St#st_dun_exp.time]),
    db:execute(Sql).

load_dun_daily(Pkey) ->
    Sql = io_lib:format("select dun_list from player_dun_daily where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_dun_daily(St) ->
    Sql = io_lib:format("replace into player_dun_daily set pkey=~p,dun_list='~s'",
        [St#st_dun_daily.pkey, util:term_to_bitstring(St#st_dun_daily.dun_list)]),
    db:execute(Sql).

load_dun_fuwen_tower(Pkey) ->
    Sql = io_lib:format("select dun_list,layer_highest, sub_layer, unlock_pos,unlock_fuwen_subtype,op_time from player_dun_fuwen_tower where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_dun_fuwen_tower(St) ->
    #st_dun_fuwen_tower{
        pkey = Pkey,
        layer_highest = LayerHighest,
        sub_layer = SubLayer,
        unlock_pos = UnLockPos,
        unlock_fuwen_subtype = UnLockFuwenSubtype,
        op_time = OpTime,
        dun_list = DunList
    } = St,
    DunListBin = util:term_to_bitstring(util:list_filter_repeat(DunList)),
    UnLockFuwenSubtypeBin = util:term_to_bitstring(UnLockFuwenSubtype),
    Sql = io_lib:format("replace into player_dun_fuwen_tower set pkey=~p, dun_list='~s',layer_highest=~p, sub_layer=~p, unlock_pos=~p,unlock_fuwen_subtype='~s',op_time=~p",
        [Pkey, DunListBin, LayerHighest, SubLayer, UnLockPos, UnLockFuwenSubtypeBin, OpTime]),
    db:execute(Sql).

load_dun_god_weapon(Pkey) ->
    Sql = io_lib:format("select layer,layer_h,round,round_h,time from player_dun_god_weapon where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_dun_god_weapon(St) ->
    Sql = io_lib:format("replace into player_dun_god_weapon set pkey=~p,layer=~p,layer_h=~p,round=~p,round_h=~p,time=~p",
        [St#st_dun_god_weapon.pkey,
            St#st_dun_god_weapon.layer,
            St#st_dun_god_weapon.layer_h,
            St#st_dun_god_weapon.round,
            St#st_dun_god_weapon.round_h,
            St#st_dun_god_weapon.time
        ]),
    db:execute(Sql).


load_dun_guard(Pkey) ->
    Sql = io_lib:format("select round,round_max,first_round,reward_list,change_time, first_time,is_sweep,sweep_round from player_dun_guard_td where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_dun_guard(St) ->
    Sql = io_lib:format("replace into player_dun_guard_td set pkey=~p,round=~p,round_max=~p,first_round=~p,reward_list='~s',change_time=~p,first_time=~p,is_sweep = ~p,sweep_round=~p",
        [St#st_dun_guard.pkey,
            St#st_dun_guard.round,
            St#st_dun_guard.round_max,
            St#st_dun_guard.first_round,
            util:term_to_bitstring(St#st_dun_guard.reward_list),
            St#st_dun_guard.change_time,
            St#st_dun_guard.first_time,
            St#st_dun_guard.is_sweep,
            St#st_dun_guard.sweep_round
        ]),
    db:execute(Sql).

load_dun_marry(Pkey) ->
    Sql = io_lib:format("select pass,op_time,is_reset,saodang from player_dun_marry where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_dun_marry(St) ->
    #st_dun_marry{
        pkey = Pkey,
        pass = Pass,
        op_time = OpTime,
        is_reset = IsReset,
        saodang = Saodang
    } = St,
    Sql = io_lib:format("replace into player_dun_marry set pkey=~p, pass=~p, is_reset=~p, op_time=~p, saodang=~p",
        [Pkey, Pass, IsReset, OpTime, Saodang]),
    db:execute(Sql).

delete_dun_marry(Pkey) ->
    Sql = io_lib:format("delete from player_dun_marry where pkey=~p", [Pkey]),
    db:execute(Sql).


load_dun_equip(Pkey) ->
    Sql = io_lib:format("select times,dun_list,time from player_dun_equip where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace_dun_equip(St) ->
    Sql = io_lib:format("replace into player_dun_equip set pkey=~p,times=~p,dun_list='~s',time=~p",
        [St#st_dun_equip.pkey, St#st_dun_equip.times, util:term_to_bitstring(St#st_dun_equip.dun_list), St#st_dun_equip.time]),
    db:execute(Sql),
    ok.