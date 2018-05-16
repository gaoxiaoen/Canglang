%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 九月 2017 11:22
%%%-------------------------------------------------------------------
-module(hotfix10).

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("equip.hrl").

%% API
-export([
    back/0,
    back_equip_streng/0,
    back_show_lv/0,
    back_show_skill/0,
    back_show_put_down_equip/0,
    back_up_dan/0,
    back_attr_dan/0,
    back_equip_jl_lv/0,
    back_soul/0,
    back_god_forging/0
]).

%% 回滚精炼等级
back_god_forging() ->
    {BackTime, PlayerKeyList} = get_back_info(),
    F10 = fun(Pkey) ->
        back_god_forging(Pkey, BackTime),
        timer:sleep(500),
        io:format("back_god_forging Pkey:~p~n", [Pkey])
          end,
    lists:map(F10, PlayerKeyList).

back_soul() ->
    %% 修复宝石
    F9 = fun({Pkey, GoodsId, Num}) ->
        back_soul(get_lv_by_id(GoodsId) * Num, Pkey),
        timer:sleep(500),
        io:format("back_soul Pkey:~p~n", [Pkey])
         end,
    lists:map(F9, get_player_list()).

%% 回滚装备精炼
back_equip_jl_lv() ->
    {BackTime, PlayerKeyList} = get_back_info(),
    F7 = fun(Pkey) ->
        back_equip_refine(Pkey, BackTime),
        timer:sleep(500),
        io:format("back_equip_refine Pkey:~p~n", [Pkey])
         end,
    lists:map(F7, PlayerKeyList).

%% 回收属性丹
back_attr_dan() ->
    {BackTime, PlayerKeyList} = get_back_info(),
    F6 = fun(Pkey) ->
        back_attr_dan(Pkey, BackTime),
        timer:sleep(500),
        io:format("back_attr_dan Pkey:~p~n", [Pkey])
         end,
    %% 回收精魄丹
    lists:map(F6, PlayerKeyList),
    ok.

%% 回收成长丹
back_up_dan() ->
    {BackTime, PlayerKeyList} = get_back_info(),
    List = [
        mount, wing, magic_weapon, light_weapon, pet_weapon, footprint, cat, golden_body, baby_wing
    ],
    F5 = fun(Pkey) ->
        FF5 = fun(GoodsId) ->
            back_to_zero_time6(GoodsId, Pkey, BackTime)
              end,
        lists:map(FF5, List),
        timer:sleep(500),
        io:format("back_to_zero_time6 Pkey:~p~n", [Pkey])
         end,
    %% 回收成长丹
    lists:map(F5, PlayerKeyList),
    ok.

%% 脱下外观装备
back_show_put_down_equip() ->
    {_BackTime, PlayerKeyList} = get_back_info(),
    List = [
        mount, wing, magic_weapon, light_weapon, pet_weapon, footprint, cat, golden_body, baby_wing
    ],
    F4 = fun(Pkey) ->
        FF4 = fun(GoodsId) ->
            back_to_zero_time5(GoodsId, 1, Pkey)
              end,
        lists:map(FF4, List),
        timer:sleep(500),
        io:format("back_to_zero_time5 Pkey:~p~n", [Pkey])
         end,
    lists:map(F4, PlayerKeyList),
    ok.

%% 回滚外观技能ID
back_show_skill() ->
    {BackTime, PlayerKeyList} = get_back_info(),
    List = [
        mount, wing, magic_weapon, light_weapon, pet_weapon, footprint, cat, golden_body, baby_wing
    ],
    F3 = fun(Pkey) ->
        FF3 = fun(GoodsId) ->
            back_to_zero_time4(GoodsId, 1, Pkey, BackTime)
              end,
        lists:map(FF3, List),
        timer:sleep(500),
        io:format("back_to_zero_time4 Pkey:~p~n", [Pkey])
         end,
    lists:map(F3, PlayerKeyList).

%% 回滚外观阶级
back_show_lv() ->
    {BackTime, PlayerKeyList} = get_back_info(),
    List = [
        mount, wing, magic_weapon, light_weapon, pet_weapon, footprint, cat, golden_body, baby_wing
    ],
    F = fun(Pkey) ->
        FF = fun(GoodsId) ->
            back_to_zero_time3(GoodsId, 1, Pkey, BackTime)
             end,
        lists:map(FF, List),
        timer:sleep(500),
        io:format("back_to_zero_time3 Pkey:~p~n", [Pkey])
        end,
    lists:map(F, PlayerKeyList).

%% 回滚装备强化等级
back_equip_streng() ->
    {BackTime, PlayerKeyList} = get_back_info(),
    F2 = fun(Pkey) ->
        back_to_equip(Pkey, BackTime),
        timer:sleep(500),
        io:format("back_to_equip Pkey:~p~n", [Pkey])
         end,
    lists:map(F2, PlayerKeyList).

get_back_info() ->
    BackTime = 1505689200,
    PlayerKeyList = [
        101100012,
        101100015,
        101100154,
        101100163,
        101100244,101100324,101100458,101100630,101100794,101101072,101101415,101101648
    ],
    {BackTime, PlayerKeyList}.

back() ->
%%   BackTime = 1505750400,
    BackTime = 1505689200,
    PlayerKeyList = [
        101100012,
        101100015,
        101100154,
        101100163,
        101100244,101100324,101100458,101100630,101100794,101101072,101101415,101101648
    ],
    List = [
        mount, wing, magic_weapon, light_weapon, pet_weapon, footprint, cat, golden_body, baby_wing
    ],
    F = fun(Pkey) ->
        FF = fun(GoodsId) ->
            back_to_zero_time3(GoodsId, 1, Pkey, BackTime)
             end,
        lists:map(FF, List),
        timer:sleep(500),
        io:format("back_to_zero_time3 Pkey:~p~n", [Pkey])
        end,
    %% 回滚外观阶级
    lists:map(F, PlayerKeyList),
    F2 = fun(Pkey) ->
        back_to_equip(Pkey, BackTime),
        timer:sleep(500),
        io:format("back_to_equip Pkey:~p~n", [Pkey])
         end,
    %% 回滚装备强化等级
    lists:map(F2, PlayerKeyList),
    F3 = fun(Pkey) ->
        FF3 = fun(GoodsId) ->
            back_to_zero_time4(GoodsId, 1, Pkey, BackTime)
              end,
        lists:map(FF3, List),
        timer:sleep(500),
        io:format("back_to_zero_time4 Pkey:~p~n", [Pkey])
         end,
    %% 回滚外观技能ID
    lists:map(F3, PlayerKeyList),
    F4 = fun(Pkey) ->
        FF4 = fun(GoodsId) ->
            back_to_zero_time5(GoodsId, 1, Pkey)
              end,
        lists:map(FF4, List),
        timer:sleep(500),
        io:format("back_to_zero_time5 Pkey:~p~n", [Pkey])
         end,
    %% 脱下外观装备
    lists:map(F4, PlayerKeyList),
    F5 = fun(Pkey) ->
        FF5 = fun(GoodsId) ->
            back_to_zero_time6(GoodsId, Pkey, BackTime)
              end,
        lists:map(FF5, List),
        timer:sleep(500),
        io:format("back_to_zero_time6 Pkey:~p~n", [Pkey])
         end,
    %% 回收成长丹
    lists:map(F5, PlayerKeyList),
    F6 = fun(Pkey) ->
        back_attr_dan(Pkey, BackTime),
        timer:sleep(500),
        io:format("back_attr_dan Pkey:~p~n", [Pkey])
         end,
    %% 回收精魄丹
    lists:map(F6, PlayerKeyList),
    %% 回滚装备精炼
    F7 = fun(Pkey) ->
        back_equip_refine(Pkey, BackTime),
        timer:sleep(500),
        io:format("back_equip_refine Pkey:~p~n", [Pkey])
         end,
    lists:map(F7, PlayerKeyList),
%%   %% 回滚神炼等级
%%   F8 = fun(Pkey) ->
%%     back_god_forging(Pkey, BackTime)
%%   end,
%%   lists:map(F8, PlayerKeyList),
%%   %% 修复宝石
%%   F9 = fun({Pkey, GoodsId, Num}) ->
%%     back_soul(get_lv_by_id(GoodsId) * Num, Pkey),
%%     timer:sleep(500),
%%     io:format("back_soul Pkey:~p~n", [Pkey])
%%   end,
%%   %%神炼宝典 等级
%%   lists:map(F9, get_player_list()),
%%   F10 = fun(Pkey) ->
%%     back_god_forging(Pkey, BackTime),
%%     timer:sleep(500),
%%     io:format("back_god_forging Pkey:~p~n", [Pkey])
%%   end,
%%   lists:map(F10, PlayerKeyList),
    ok.

back_to_equip(_PlayerId, Time) ->
    Sql = io_lib:format("select goods_id, max(after_lv) as lv from log_equip_streng where pkey=~p and time < ~p group by goods_id", [_PlayerId, Time]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            ?DEBUG("Rows:~p", [Rows]),
            F = fun([GoodsId, Lv]) ->
                Sql99 = io_lib:format("update goods set stren=~p where pkey=~p and goods_id=~p", [Lv, _PlayerId, GoodsId]),
                db:execute(Sql99)
                end,
            lists:map(F, Rows);
        _ ->
            ?ERR("2003000", [])
    end,
    ok.

%%坐骑进阶 等级
back_to_zero_time3(mount, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_mount_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update mount set stage = ~p,exp = ~p, current_image_id=100001, current_sword_id=1 where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
%%仙羽进阶 等级
back_to_zero_time3(wing, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_wing_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update wing set stage = ~p,exp = ~p,  current_image_id=1020001 where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
%%法器进阶 等级
back_to_zero_time3(magic_weapon, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_magic_weapon_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update magic_weapon set stage = ~p,exp = ~p, weapon_id = 10001 where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
%%神兵进阶 等级
back_to_zero_time3(light_weapon, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_light_weapon_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update light_weapon set stage = ~p,exp = ~p, weapon_id = 110001 where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            ?DEBUG("######_R:~p", [_R]),
            skip
    end,
    ok;
%%妖灵进阶 等级
back_to_zero_time3(pet_weapon, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_pet_weapon_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update pet_weapon set stage = ~p,exp = ~p, weapon_id = 110001 where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
%%足迹进阶 等级
back_to_zero_time3(footprint, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_footprint_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update footprint set footprint_id=110001, stage = ~p,exp = ~p where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

%%灵猫进阶 等级
back_to_zero_time3(cat, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_cat_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update cat set cat_id=110001, stage = ~p,exp = ~p where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

%%法身进阶 等级
back_to_zero_time3(golden_body, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_golden_body_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update golden_body set golden_body_id=110001, stage = ~p,exp = ~p where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

%%灵羽进阶 等级
back_to_zero_time3(baby_wing, _GoodsNum, _PlayerId, Time) ->
    Sql = io_lib:format("SELECT old_stage,exp FROM log_baby_wing_stage WHERE pkey = ~p AND `time` >= ~p ORDER BY `time`,`exp` limit 1", [_PlayerId, Time]),
    case db:get_row(Sql) of
        [Lv, Exp] ->
            ?DEBUG("Lv:~p,Exp:~p", [Lv, Exp]),
            UpdateSql = io_lib:format("update baby_wing set current_image_id=10001, stage = ~p,exp = ~p where pkey = ~p", [Lv, Exp, _PlayerId]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok.

%% 修复外观技能
back_to_zero_time4(mount, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_mount_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update mount set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

back_to_zero_time4(wing, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_wing_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update wing set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

back_to_zero_time4(light_weapon, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_light_weapon_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update light_weapon set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

back_to_zero_time4(magic_weapon, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_magic_weapon_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update magic_weapon set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

back_to_zero_time4(pet_weapon, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_pet_weapon_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update pet_weapon set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

back_to_zero_time4(footprint, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_footprint_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update footprint set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

back_to_zero_time4(cat, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_cat_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update cat set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

back_to_zero_time4(golden_body, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_golden_body_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update golden_body set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

back_to_zero_time4(baby_wing, 1, Pkey, Time) ->
    Sql = io_lib:format("SELECT cell, min(new_sid) FROM `log_baby_wing_skill` where `time` > ~p and pkey =~p group by cell;", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) andalso Rows /= [] ->
            ?DEBUG("Rows:~p", [Rows]),
            NewList = lists:map(fun([Cell, NewSid]) -> {Cell, NewSid} end, Rows),
            UpdateSql = io_lib:format("update baby_wing set skill_list = '~s' where pkey = ~p", [util:term_to_bitstring(NewList), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok.

%% 脱下外观装备
back_to_zero_time5(mount, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from mount where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update mount set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

%% 脱下外观装备
back_to_zero_time5(wing, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from wing where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update wing set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
%% 脱下外观装备
back_to_zero_time5(magic_weapon, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from magic_weapon where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update magic_weapon set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

%% 脱下外观装备
back_to_zero_time5(light_weapon, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from light_weapon where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update light_weapon set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
%% 脱下外观装备
back_to_zero_time5(pet_weapon, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from pet_weapon where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update pet_weapon set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

%% 脱下外观装备
back_to_zero_time5(footprint, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from footprint where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update footprint set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
%% 脱下外观装备
back_to_zero_time5(cat, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from cat where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update cat set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;

%% 脱下外观装备
back_to_zero_time5(golden_body, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from golden_body where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update golden_body set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
%% 脱下外观装备
back_to_zero_time5(baby_wing, 1, Pkey) ->
    Sql = io_lib:format("select equip_list from baby_wing where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [EquipListBin] ->
            EquipList = util:bitstring_to_term(EquipListBin),
            lists:map(fun({_, _, Gkey}) ->
                UpdateSql = io_lib:format("update goods set location = 2, cell = 0 where gkey = ~p", [Gkey]),
                db:execute(UpdateSql)
                      end, EquipList),
            UpdateSql = io_lib:format("update baby_wing set equip_list = '[]' where pkey = ~p", [Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok.

%% 回滚进阶丹
back_to_zero_time6(mount, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3102000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update mount set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update mount set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
back_to_zero_time6(wing, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3202000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update wing set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update wing set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
back_to_zero_time6(magic_weapon, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3302000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update magic_weapon set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update magic_weapon set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
back_to_zero_time6(light_weapon, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3402000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update light_weapon set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update light_weapon set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
back_to_zero_time6(pet_weapon, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3502000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update pet_weapon set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update pet_weapon set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
back_to_zero_time6(footprint, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3602000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update footprint set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update footprint set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
back_to_zero_time6(cat, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3702000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update cat set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update cat set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
back_to_zero_time6(golden_body, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3802000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update golden_body set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update golden_body set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok;
back_to_zero_time6(baby_wing, Pkey, Time) ->
    Sql = io_lib:format("select sum(create_num) from log_goods_use where `time` < ~p and goods_id=3902000 and pkey=~p", [Time, Pkey]),
    case db:get_row(Sql) of
        [] ->
            UpdateSql = io_lib:format("update baby_wing set grow_num=~p where pkey = ~p", [0, Pkey]),
            db:execute(UpdateSql);
        [Num] when is_integer(Num) ->
            ?DEBUG("Num:~p", [Num]),
            UpdateSql = io_lib:format("update baby_wing set grow_num=~p where pkey = ~p", [Num, Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok.

%%回滚属性丹
back_attr_dan(Pkey, Time) ->
    Sql = io_lib:format("select goods_id, sum(create_num) from log_goods_use where pkey=~p and goods_id in (3104000,3105000,3106000,3204000,3205000,3206000,3304000,3305000,3306000,3404000,3405000,3406000,3504000,3505000,3506000,3604000,3605000,3606000,3704000,3705000,3706000,3804000,3805000,3806000,3904000,3905000,3906000) and `time` < ~p group by goods_id", [Pkey, Time]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            ?DEBUG("Rows:~p", [Rows]),
            NewRows = lists:map(fun([GId, GNum]) -> {GId, GNum} end, Rows),
            UpdateSql = io_lib:format("update attr_dan set attr_dan='~s' where pkey = ~p", [util:term_to_bitstring(NewRows), Pkey]),
            db:execute(UpdateSql);
        _R ->
            skip
    end,
    ok.

%% 回滚装备精炼等级
back_equip_refine(Pkey, Time) ->
    Sql = io_lib:format("select cost_goods_id, subtype, max(refine_after) from log_equip_refine where `time` < ~p and pkey=~p group by cost_goods_id,subtype", [Time, Pkey]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            ?DEBUG("Rows:~p", [Rows]),
            List =
                lists:foldl(fun([GoodsId, SubType, Lv], Acc) ->
                    case GoodsId of
                        2011000 -> %% 处理攻击
                            case lists:keytake(SubType, 4, Acc) of
                                false ->
                                    [{Lv, 0, 0, SubType} | Acc];
                                {value, {_AttLv, DefLv, HpLv, SubType}, Rest} ->
                                    [{Lv, DefLv, HpLv, SubType} | Rest]
                            end;
                        2012000 -> %% 处理防御
                            case lists:keytake(SubType, 4, Acc) of
                                false ->
                                    [{0, Lv, 0, SubType} | Acc];
                                {value, {AttLv, _DefLv, HpLv, SubType}, Rest} ->
                                    [{AttLv, Lv, HpLv, SubType} | Rest]
                            end;
                        2013000 -> %% 处理气血
                            case lists:keytake(SubType, 4, Acc) of
                                false ->
                                    [{0, 0, Lv, SubType} | Acc];
                                {value, {AttLv, DefLv, _HpLv, SubType}, Rest} ->
                                    [{AttLv, DefLv, Lv, SubType} | Rest]
                            end;
                        _ -> Acc
                    end
                            end, [], Rows),
            ListBin = util:term_to_bitstring(List),
            UpdateSql = io_lib:format("update equip_refine set refine_info='~s' where pkey=~p ", [ListBin, Pkey]),
            db:execute(UpdateSql),
            ok;
        _R ->
            skip
    end,
    ok.

%% 回滚精炼等级
back_god_forging(Pkey, Time) ->
    Sql = io_lib:format(" SELECT pkey,goods_id,befor_lv FROM log_equip_god_forging WHERE pkey = ~p AND time > ~p ORDER BY time ", [Pkey, Time]),
    case db:get_all(Sql) of
        Rows when is_list(Rows) ->
            F = fun([_Pkey, GoodsId, BeforLv], List) ->
                GoodsType = data_goods:get(GoodsId),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, List) of
                    false ->
                        [{GoodsType#goods_type.subtype, BeforLv} | List];
                    _ ->
                        List
                end
                end,
            List1 = lists:foldl(F, [], Rows),

            GoodsList = goods_load:load_player_goods(Pkey, "goods"),
            PlayerGoodsList = goods_info_init(GoodsList),
            F0 = fun(Goods, {L1, L2}) ->
                if Goods#goods.location == ?GOODS_LOCATION_BODY ->
                    {L1, [Goods | L2]};
                    true ->
                        {[Goods | L1], L2}
                end
                 end,
            {_PlayerGoodsList1, EquipList} = lists:foldl(F0, {[], []}, PlayerGoodsList),
            F1 = fun(Goods) ->
                GoodsType0 = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType0#goods_type.subtype, 1, List1) of
                    false -> ok;
                    {_Subtype0, Lv0} ->
                        NewGoods = Goods#goods{god_forging = Lv0},
                        goods_load:dbup_goods_god_forging(NewGoods)
                end
                 end,
            lists:map(F1, EquipList),
            ok;
        _ ->
            []
    end,
    ok.

%% 回滚宝石信息
back_soul(GoodsNum, PlayerId) ->
    Sql = io_lib:format("select soul_info from equip_soul where pkey = ~p", [PlayerId]),
    case db:get_row(Sql) of
        [] ->
            skip;
        [Soul] ->
            SoulList = equip_soul:pack_equip_soul(util:bitstring_to_term(Soul)),
            F = fun(St, {List11, Num}) ->
                F0 = fun({Location, State, GoodsId}, {List0, Num0}) ->
                    Base = data_equip_soul:get_gid(GoodsId),
                    Sum = get_lv(Base#base_equip_soul.lv),
                    if
                        Sum < Num0 -> {[{Location, State, 0} | List0], Num0 - Sum};
                        true -> {[{Location, State, GoodsId} | List0], Num0}
                    end
                     end,
                {Att_list, Num1} = lists:foldl(F0, {[], Num}, St#st_soul_info.info_list),
                Q = max(0, Num1),
                {[#st_soul_info{info_list = Att_list, subtype = St#st_soul_info.subtype} | List11], Q}
%%                     Att_list = St#st_magic_info.att_list,
                end,
            {NewSoulList, Num11} = lists:foldl(F, {[], GoodsNum}, SoulList),
            Data = util:term_to_bitstring(equip_soul:format_equip_soul(NewSoulList)),
            Sql1 = io_lib:format("replace into equip_soul set pkey= ~p,soul_info='~s'", [PlayerId, Data]),
            db:execute(Sql1),

            GoodsList = goods_load:load_player_goods(PlayerId, "goods"),
            PlayerGoodsList = goods_info_init(GoodsList),
            F0 = fun(Goods, {L1, L2}) ->
                if Goods#goods.location == ?GOODS_LOCATION_BAG ->
                    {L1, [Goods | L2]};
                    true ->
                        {[Goods | L1], L2}
                end
                 end,
            {_PlayerGoodsList1, GoodsList1} = lists:foldl(F0, {[], []}, PlayerGoodsList),
            F1 = fun(Goods, Num111) ->
                Base = data_equip_soul:get_gid(Goods#goods.goods_id),
                if
                    Base#base_equip_soul.lv == 0 -> Num111;
                    true ->
                        Sum = get_lv(Base#base_equip_soul.lv),
%%             ?DEBUG("Goods#goods.num ~p~n", [Goods#goods.num]),
                        if
                            Goods#goods.num * Sum =< Num111 ->
                                NewGoods = Goods#goods{num = 0},
                                goods_load:dbup_goods_num(NewGoods),
%%                 ?DEBUG(" Num1111111 ~p~n", [Num111]),
%%                 ?DEBUG(" Sum11111 ~p~n", [Sum]),
                                max(0, Num111 - Goods#goods.num * Sum);
                            true ->
%%                 ?DEBUG(" Num111 ~p~n", [Num111]),
%%                 ?DEBUG(" Sum ~p~n", [Sum]),
                                Count = Num111 div Sum,
                                NewGoods = Goods#goods{num = Goods#goods.num - Count},
                                goods_load:dbup_goods_num(NewGoods),
                                0
                        end
                end
                 end,
            lists:foldl(F1, Num11, GoodsList1)
    end,
    ok.

get_lv(1) -> 1;
get_lv(2) -> 2;
get_lv(3) -> 4;
get_lv(4) -> 8;
get_lv(5) -> 24;
get_lv(6) -> 72;
get_lv(7) -> 216;
get_lv(8) -> 864;
get_lv(9) -> 4320;
get_lv(10) -> 21600;
get_lv(_) -> 21600.

get_player_list() ->
    [{101100012, 8002402, 879},
        {101100015, 8002401, 378},
        {101100015, 8002402, 1829},
        {101100154, 8002401, 318},
        {101100154, 8002402, 539},
        {101100163, 8002401, 495},
        {101100163, 8002401, 772},
        {101100244, 8002402, 159},
        {101100244, 8002401, 255},
        {101100244, 8002401, 653},
        {101100324, 8002402, 30},
        {101100324, 8002402, 10},
        {101100324, 8002401, 27},
        {101100458, 8002401, 3783},
        {101100458, 8002402, 1395},
        {101100630, 8002401, 13053},
        {101100630, 8002402, 337},
        {101100794, 8002402, 723},
        {101100794, 8002402, 1473},
        {101100794, 8002401, 4251},
        {101101072, 8002401, 198},
        {101101072, 8002402, 672},
        {101101415, 8002401, 1473},
        {101101415, 8002402, 1665},
        {101101415, 8002402, 1115},
        {101101648, 8002401, 180},
        {101101648, 8002401, 870},
        {101101648, 8002401, 941}].

get_lv_by_id(8002402) ->
    1;
get_lv_by_id(8002401) ->
    2;
get_lv_by_id(_) ->
    0.

goods_info_init(GoodsList) ->
    goods_info_init(util:unixtime(), GoodsList, []).

goods_info_init(_Now, [], GoodsList) ->
    GoodsList;

goods_info_init(Now, [[Gkey, Pkey, GoodsId, Location, Cell, Num, Bind, Expiretime, GoodsLv, Star, Stren, Color, Wash_luck_value, WashAttrs, GemstoneGroove, TotalAttrs, CombatPower, RefineAttr, Exp, GodForging, Lock, FixAttrs, RandomAttrs, Sex] | Tail], GoodsList) ->
    case data_goods:get(GoodsId) of
        [] ->
            ?ERR("goods_info_init goods ~p udef~n", [GoodsId]),
            goods_info_init(Now, Tail, GoodsList);
        _ ->
            GemstoneGrooveList = util:bitstring_to_term(GemstoneGroove),
            WashAttrsList = util:bitstring_to_term(WashAttrs),
            TotalAttrsList = util:bitstring_to_term(TotalAttrs),
            RefineAttrList = util:bitstring_to_term(RefineAttr),
            FixAttrsList = util:bitstring_to_term(FixAttrs),
            RandomAttrsList = util:bitstring_to_term(RandomAttrs),
            Goods = #goods{key = Gkey, pkey = Pkey, goods_id = GoodsId, location = Location, cell = Cell, num = Num,
                bind = Bind, expire_time = Expiretime, goods_lv = GoodsLv, star = Star, stren = Stren, color = Color, wash_luck_value = Wash_luck_value, gemstone_groove = GemstoneGrooveList,
                total_attrs = TotalAttrsList, wash_attr = WashAttrsList, combat_power = CombatPower, refine_attr = RefineAttrList, exp = Exp, god_forging = GodForging, lock = Lock,
                fix_attrs = FixAttrsList, random_attrs = RandomAttrsList, sex = Sex
            },
            goods_info_init(Now, Tail, [Goods | GoodsList])
    end.

%% %%神炼宝典 等级
%% back_god_forging(PlayerId, Time) ->
%% %% 300012991
%%   Sql = io_lib:format(" SELECT pkey,goods_id,befor_lv FROM log_equip_god_forging WHERE pkey = ~p AND time > ~p ORDER BY time ", [PlayerId, Time]),
%%   case db:get_all(Sql) of
%%     Rows when is_list(Rows) ->
%%       F = fun([_Pkey, GoodsId, BeforLv], List) ->
%%         GoodsType = data_goods:get(GoodsId),
%%         case lists:keyfind(GoodsType#goods_type.subtype, 1, List) of
%%           false ->
%%             [{GoodsType#goods_type.subtype, BeforLv} | List];
%%           _ ->
%%             List
%%         end
%%       end,
%%       List1 = lists:foldl(F, [], Rows),
%%
%%       GoodsList = goods_load:load_player_goods(PlayerId, "goods"),
%%       PlayerGoodsList = goods_info_init(GoodsList),
%%       F0 = fun(Goods, {L1, L2}) ->
%%         if Goods#goods.location == ?GOODS_LOCATION_BODY ->
%%           {L1, [Goods | L2]};
%%           true ->
%%             {[Goods | L1], L2}
%%         end
%%       end,
%%       {_PlayerGoodsList1, EquipList} = lists:foldl(F0, {[], []}, PlayerGoodsList),
%%       F1 = fun(Goods) ->
%%         GoodsType0 = data_goods:get(Goods#goods.goods_id),
%%         case lists:keyfind(GoodsType0#goods_type.subtype, 1, List1) of
%%           false -> ok;
%%           {_Subtype0, Lv0} ->
%%             NewGoods = Goods#goods{god_forging = Lv0},
%%             goods_load:dbup_goods_god_forging(NewGoods)
%%         end
%%       end,
%%       lists:map(F1, EquipList),
%%       ok;
%%     _ ->
%%       []
%%   end,
%%   ok.