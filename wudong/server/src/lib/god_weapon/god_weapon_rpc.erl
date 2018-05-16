%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2017 15:36
%%%-------------------------------------------------------------------
-module(god_weapon_rpc).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
%% API
-export([handle/3]).

%%获取神器信息
handle(15601, Player, {}) ->
    Data = god_weapon:god_weapon_info(Player),
    {ok, Bin} = pt_156:write(15601, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%激活
handle(15602, Player, {WeaponId}) ->
    {Ret, NewPlayer} = god_weapon:activate(Player, WeaponId),
    {ok, Bin} = pt_156:write(15602, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%幻化
handle(15603, Player, {WeaponId}) ->
    {Ret, NewPlayer} = god_weapon:equip_weapon(Player, WeaponId),
    {ok, Bin} = pt_156:write(15603, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%切换技能
handle(15604, Player, {WeaponId}) ->
    {Ret, NewPlayer} = god_weapon:equip_skill(Player, WeaponId),
    {ok, Bin} = pt_156:write(15604, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取器灵信息
handle(15605, Player, {WeaponId}) ->
    Data = god_weapon:spirit_info(WeaponId),
    {ok, Bin} = pt_156:write(15605, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%提升器灵
handle(15606, Player, {WeaponId}) ->
    {Ret, NewPlayer} = god_weapon:upgrade_spirit(Player, WeaponId),
    {ok, Bin} = pt_156:write(15606, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    handle(15608, NewPlayer, {}),
    {ok, NewPlayer};


handle(15607, Player, {}) ->
    Data = god_weapon:skill_list(),
    {ok, Bin} = pt_156:write(15607, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取可以注灵的神器列表
handle(15608, Player, _) ->
    List = god_weapon:get_upgrade_spirit_list(Player),
    {ok, Bin} = pt_156:write(15608, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};


%% 获取十荒神器列表
handle(15609, Player, _) ->
    List = god_weapon_upgrade:get_info(Player),
    {ok, Bin} = pt_156:write(15609, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 获取十荒神器进阶信息
handle(15610, Player, {WeaponId}) ->
    Data = god_weapon_upgrade:get_upgrade_info(Player, WeaponId),
    {ok, Bin} = pt_156:write(15610, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};


%% 十荒神器进阶
handle(15611, Player, {WeaponId}) ->
    {Res, NewPlayer} = god_weapon_upgrade:upgrade_star(Player, WeaponId),
    {ok, Bin} = pt_156:write(15611, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 获取神器洗练信息
handle(15612, Player, {WeaponId}) ->
    Data = god_weapon_wash:get_wash_info(Player, WeaponId),
    ?DEBUG("data ~p~n",[Data]),
    {ok, Bin} = pt_156:write(15612, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%% 神器洗练
handle(15613, Player, {WeaponId, Type, Ids,LockIds}) ->
    {Res, NewPlayer} = god_weapon_wash:wash_weapon(Player, WeaponId, Type, Ids,LockIds),
    ?DEBUG("Res ~p~n",[Res]),
    {ok, Bin} = pt_156:write(15613, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 神器洗练替换
handle(15614, Player, {WeaponId}) ->
    {Res, NewPlayer} = god_weapon_wash:wash_replace(Player, WeaponId),
    {ok, Bin} = pt_156:write(15614, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 神器升阶消耗
handle(15615, Player, {}) ->
    Data = god_weapon_upgrade:get_cost_list(Player),
    {ok, Bin} = pt_156:write(15615, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


handle(_cmd, _player, _data) ->
    ?ERR("_Cmd not match ~p/ ~p", [_cmd, _data]),
    ok.


%% [100501830,
%% 100204651,
%% 100100197,
%% 100103161,
%% 100201477,
%% 100104357,
%% 100500571,
%% 100104876,
%% 100109384,
%% 100204768,
%% 100705559,
%% 100703829,
%% 100706274,
%% 100705161,
%% 100703466,
%% 100703075,
%% 100703744,
%% 100803129,
%% 100705198,
%% 100802991,
%% 101006501,
%% 101005315,
%% 101006634,
%% 101004777,
%% 101000900,
%% 101000252,
%% 100902177,
%% 101003319,
%% 100301606,
%% 101001592,
%% 101401054,
%% 101903231,
%% 101302629,
%% 101901901,
%% 101101493,
%% 101901474,
%% 101500898,
%% 101401834,
%% 101400277,
%% 101502933,
%% 101601836,
%% 101601568,
%% 101601717,
%% 102502013,
%% 101201980,
%% 101602832,
%% 101200694,
%% 102503290,
%% 101201680,
%% 101602672,
%% 103401230,
%% 103000833,
%% 102202923,
%% 103100431,
%% 103002932,
%% 102201928,
%% 103100773,
%% 103002689,
%% 103100402,
%% 102200540,
%% 102702913,
%% 101803052,
%% 101802700,
%% 102000241,
%% 103600669,
%% 103501625,
%% 103601973,
%% 101803254,
%% 103503370,
%% 101803330,
%% 104002783,
%% 103901695,
%% 103900305,
%% 104002661,
%% 103900332,
%% 103200006,
%% 102301175,
%% 103901524,
%% 102903589,
%% 104001573,
%% 103303437,
%% 102101281,
%% 102100781,
%% 102102570,
%% 102104056,
%% 103700493,
%% 103702897,
%% 102102639,
%% 102103677,
%% 102103676,
%% 102802546,
%% 104602600,
%% 104602805,
%% 103800988,
%% 104202360,
%% 102800044,
%% 104603785,
%% 104301807,
%% 104102570,
%% 104202490,
%% 105000450,
%% 105002042,
%% 105102070,
%% 105102458,
%% 105102976,
%% 105101888,
%% 105002998,
%% 105101564,
%% 105103310,
%% 105102956,
%% 104902468,
%% 105300214,
%% 105300585,
%% 105302558,
%% 105402148,
%% 105400087,
%% 104800144,
%% 105301171,
%% 104801870,
%% 104403299,
%% 106502222,
%% 106202631,
%% 106501237,
%% 106201815,
%% 106200813,
%% 105801342,
%% 105802458,
%% 105802598,
%% 106201558,
%% 106100557,
%% 105501635,
%% 105501927,
%% 105600668,
%% 105901072,
%% 106301732,
%% 106700033,
%% 105202924,
%% 106103039,
%% 106700019,
%% 106902816,
%% 106801291,
%% 106800729,
%% 107000469,
%% 107000111,
%% 106900614,
%% 107000315,
%% 106903308,
%% 106900337,
%% 107001698,
%% 107700050,
%% 107702749,
%% 107700097,
%% 107500021,
%% 107700012,
%% 107500276,
%% 107500923,
%% 107602980,
%% 107703036,
%% 107700019,
%% 108000698,
%% 107200008,
%% 107203135,
%% 107102901,
%% 107100101,
%% 107300530,
%% 107401104,
%% 108001048,
%% 107201385,
%% 107203213,
%% 107300005,
%% 107801669,
%% 107802826,
%% 107902968,
%% 107900890,
%% 108101833,
%% 107902534,
%% 107802814,
%% 107902888,
%% 107902498,
%% 108102153,
%% 108200578,
%% 108300925,
%% 108202138,
%% 108200482,
%% 108300354,
%% 108301710,
%% 108201966,
%% 108302689,
%% 108200730,
%% 108201429,
%% 108501912,
%% 108400095,
%% 108400005,
%% 108400006,
%% 108400377,
%% 108402756,
%% 108500128,
%% 108400031,
%% 108400083,
%% 108500200,
%% 108700601,
%% 108602002,
%% 108702156,
%% 108602299,
%% 108702608,
%% 108700349,
%% 108601562,
%% 108603241,
%% 108602695,
%% 108702560,
%% 108900960,
%% 109001450,
%% 108901385,
%% 108900520,
%% 109001452,
%% 108800250,
%% 108800325,
%% 108800698,
%% 109001538,
%% 108803124,
%% 109201285,
%% 109300578,
%% 109200003,
%% 109200354,
%% 109200368,
%% 109201639,
%% 109200127,
%% 109200290,
%% 109100010,
%% 109203040,
%% 109402760,
%% 109400150,
%% 109400063,
%% 109402494,
%% 109400097,
%% 109402834,
%% 109400297,
%% 109400007,
%% 109400909,
%% 109400008,
%% 109500019,
%% 109502401,
%% 109500018,
%% 109500046,
%% 109500140,
%% 109500006,
%% 109500163,
%% 109500041,
%% 109500083,
%% 109500409]





