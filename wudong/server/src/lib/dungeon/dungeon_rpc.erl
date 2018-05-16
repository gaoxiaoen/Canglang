%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 九月 2015 下午7:47
%%%-------------------------------------------------------------------
-module(dungeon_rpc).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("task.hrl").
-include("dungeon.hrl").
-include("daily.hrl").
%% API
-export([handle/3]).

%%退出副本
handle(12101, Player, _) ->
    ?DEBUG("*********~n"),
    case scene:is_dungeon_scene(Player#player.scene) of
        false ->
            ?DEBUG("** false **~n"),

            case scene:is_cross_arena_scene(Player#player.scene) of
                false -> skip;
                true ->
                    cross_area:apply(cross_arena_room, quit, [Player#player.copy])
            end;
        true ->
            dungeon:quit_dungeon(Player)
    end,
    ok;

%%查询副本次数
handle(12102, Player, {DunId}) ->
    Data =
        case data_dungeon:get(DunId) of
            [] -> {0, 0, 0};
            Dun ->
                Times = dungeon_util:get_dungeon_times(DunId),
                {1, Times, Dun#dungeon.count}
        end,
    {ok, Bin} = pt_121:write(12102, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%=========九霄塔==========================================
%%获取副本信息
handle(12120, Player, {Page}) ->
    Data = dungeon_tower:dungeon_info(Page),
    {ok, Bin} = pt_121:write(12120, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%查看排行榜
handle(12121, Player, {}) ->
    Data = dungeon_tower:check_rank(),
    {ok, Bin} = pt_121:write(12121, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%扫荡
handle(12122, Player, {}) ->
    {Ret, Layer, GoodsList, NewPlayer} = dungeon_tower:sweep(Player),
    {ok, Bin} = pt_121:write(12122, {Ret, Layer, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%副本目标
handle(12123, Player, {}) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> skip;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;

%%=========九霄塔=====end=====================================
%%=====================经验副本=========================
handle(12130, Player, {}) ->
    Data = dungeon_exp:dungeon_list(Player),
    {ok, Bin} = pt_121:write(12130, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%扫荡
handle(12131, Player, {}) ->
    {Ret, GoodsList, NewPlayer} = dungeon_exp:sweep(Player),
    {ok, Bin} = pt_121:write(12131, {Ret, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(12132, Player, _) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> ok;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;

%%=====================end=========================


%%=====================每日副本.剧情,神器,经脉,仙器=========================
handle(12140, Player, {Type}) ->
    Data = dungeon_daily:dungeon_list(Player, Type),
    {ok, Bin} = pt_121:write(12140, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(12141, Player, {Type}) ->
    {Ret, GoodsList, NewPlayer} = dungeon_daily:sweep(Player, Type),
    {ok, Bin} = pt_121:write(12141, {Ret, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%副本目标
handle(12142, Player, {}) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> ok;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;


%%=====================end=========================


%%=====================神器副本=========================
%%获取神器副本信息
handle(12150, Player, {}) ->
    Data = dungeon_god_weapon:dungeon_list(),
    {ok, Bin} = pt_121:write(12150, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%神器副本目标
handle(12151, Player, {}) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> skip;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;

%%神器副本扫荡
handle(12153, Player, {}) ->
    {Ret, GoodsList, NewPlayer} = dungeon_god_weapon:sweep(Player),
    {ok, Bin} = pt_121:write(12153, {Ret, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%=====================end=========================
%%=====================vip副本=========================

%%获取vip副本信息
handle(12162, Player, _) ->
    Data = dungeon_vip:dungeon_list(Player),
    {ok, Bin} = pt_121:write(12162, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取vip副本目标
handle(12164, Player, _) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> ok;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;

%%vip副本扫荡
handle(12165, Player, {DunId}) ->
    ?DEBUG("12165 ~n"),
    {Res, NewPlayer, BackGoodsList} = dungeon_vip:vip_sweep(Player, DunId),
    ?DEBUG("~p ~n", [{Res, BackGoodsList}]),
    {ok, Bin} = pt_121:write(12165, {Res, BackGoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [103], true),
    {ok, NewPlayer};

%%=======================end============================

%%=====================材料副本=========================
%%获取材料副本次数信息
handle(12170, Player, {}) ->
    Data = dungeon_material:dungeon_list(Player),
    {ok, Bin} = pt_121:write(12170, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%副本统计
handle(12171, Player, _) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> ok;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;
%%购买次数
handle(12173, Player, {DunId}) ->
    {Ret, NewPlayer} = dungeon_material:buy(Player, DunId),
    {ok, Bin} = pt_121:write(12173, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%扫荡
handle(12174, Player, {DunId}) ->
    {Ret, GoodsList, NewPlayer} = dungeon_material:sweep(Player, DunId),
    {ok, Bin} = pt_121:write(12174, {Ret, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [97], true),
    {ok, NewPlayer};

%% 扫荡信息
handle(12175, Player, {SweepType}) ->
    case catch dungeon_material:sweep_all_dungeon(Player, SweepType) of
        {ok, NewPlayer, BackGoodsList} ->
            Res = 1;
        {false, Res} ->
            BackGoodsList = [],
            NewPlayer = Player
    end,
    {ok, Bin} = pt_121:write(12175, {Res, BackGoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ?DO_IF(Res == 1, handle(12170, Player, {})),
    activity:get_notice(Player, [97], true),
    {ok, NewPlayer};


%% 扫荡信息
handle(12176, Player, {}) ->
    Data = dungeon_material:sweep_info(Player),
    {ok, Bin} = pt_121:write(12176, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [97], true),
    ok;


%%=====================end=========================


%%%%神器副本目标
%%handle(12151, Player, {}) ->
%%    case scene:is_dungeon_scene(Player#player.scene) of
%%        false -> skip;
%%        true ->
%%            Player#player.copy ! {dungeon_target, Player#player.sid},
%%            ok
%%    end;
%%
%%%%神器副本扫荡
%%handle(12153, Player, {}) ->
%%    {Ret, GoodsList, NewPlayer} = dungeon_god_weapon:sweep(Player),
%%    {ok, Bin} = pt_121:write(12153, {Ret, GoodsList}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    {ok, NewPlayer};

%%=====================end=========================


%%=====================守护副本=========================
%%获取守护副本信息
handle(12180, Player, _) ->
    Data = dungeon_guard:get_dungeon_info(Player),
    {ok, Bin} = pt_121:write(12180, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%获取守护副本统计
handle(12181, Player, _) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> skip;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;

%%扫荡
handle(12185, Player, _) ->
    case dungeon_guard:sweep(Player) of
        {false, Res} ->
            {ok, Bin} = pt_121:write(12185, {Res, 0, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, SaveRound, GoodsList0} ->
            GoodsList = [[GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList0],
            {ok, Bin} = pt_121:write(12185, {1, SaveRound, GoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;
%%=====================end=========================


%%====================王城守卫=========================

%%获取王城守卫状态信息
handle(12220, Player, _) ->
    kindom_guard:get_kindom_guard_state(Player),
    ok;

%%获取王城守卫副本目标信息
handle(12223, Player, _) ->
    case kindom_guard:is_kindom_guard_dun(Player#player.scene) of
        true ->
            catch Player#player.copy ! {dungeon_target, Player#player.sid};
        false ->
            skip
    end,
    ok;

%%副本目标
handle(12230, Player, {}) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> skip;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;

%%=====================end=========================

%%====================符文塔===========================
handle(12501, Player, _) ->
    {Layer, SubLayer} = dungeon_fuwen_tower:get_dun_info(Player),
    {ok, Bin} = pt_125:write(12501, {Layer, SubLayer}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%%====================爱情试炼=========================
handle(12600, Player, _) ->
    Data = dungeon_marry:get_info(Player),
    {ok, Bin} = pt_126:write(12600, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 发起邀请
handle(12601, Player, {_Pkey}) ->
    MarryPkey = Player#player.marry#marry.couple_key,
    Code =
        if
            MarryPkey == 0 -> 5;
            true ->
                case ets:lookup(?ETS_ONLINE, MarryPkey) of
                    [Ets] ->
                        {ok, Bin0} = pt_126:write(12602, {Player#player.key}),
                        server_send:send_to_sid(Ets#ets_online.sid, Bin0),
                        1; %% 发送邀请成功
                    _ ->
                        2 %% 不在线
                end
        end,
    {ok, Bin} = pt_126:write(12601, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 回应邀请
handle(12603, Player, {Type, Pkey}) ->
    Code =
        case ets:lookup(?ETS_ONLINE, Pkey) of
            [#ets_online{sid = Sid, pid = Pid}] ->
                {ok, Bin0} = pt_126:write(12604, {Type, Player#player.key}),
                server_send:send_to_sid(Sid, Bin0),
                %% 一键拉起组队模式
                ?IF_ELSE(Type == 1, player:apply_state(async, Pid, {marry_room, create_trem, [Player#player.key]}), skip),
                1; %% 发送邀请成功
            _ ->
                2 %% 不在线
        end,
    {ok, Bin} = pt_126:write(12603, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 副本重置
handle(12605, Player, _) ->
    {Code, NewPlayer} = dungeon_marry:dun_reset(Player),
    {ok, Bin} = pt_126:write(12605, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 副本扫荡
handle(12607, Player, _) ->
    {Code, RewardList, NewPlayer} = dungeon_marry:saodang(Player),
    {ok, Bin} = pt_126:write(12607, {Code, RewardList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取桃花岛副本信息
handle(12608, Player, _) ->
    dungeon_marry:get_dun_task_info(Player),
    ok;

%% 答题
handle(12609, Player, {Id, Result}) ->
    dungeon_marry:answer(Player, Id, Result),
    ok;

%%------------神装副本 start------=================
handle(12701, Player, {}) ->
    Data = dungeon_equip:dungeon_info(Player#player.lv),
    {ok, Bin} = pt_127:write(12701, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(12702, Player, {}) ->
    case scene:is_dungeon_scene(Player#player.scene) of
        false -> skip;
        true ->
            Player#player.copy ! {dungeon_target, Player#player.sid},
            ok
    end;
%%------------神装副本 end------=================
handle(12801, Player, _) ->
    ?DEBUG("12801", []),
    Data = dungeon_godness:dungeon_info(Player),
%%     ?DEBUG("Data:~p", [Data]),
    {ok, Bin} = pt_128:write(12801,{Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 购买重置
handle(12803, Player, {Layer}) ->
    ?DEBUG("12803 Layer:~p", [Layer]),
    {Code, NewPlayer} = dungeon_godness:buy_reset(Player, Layer),
    ?DEBUG("Code:~p", [Code]),
    {ok, Bin} = pt_128:write(12803,{Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 扫荡
handle(12804, Player, {DunId, SaodangNum}) ->
    ?DEBUG("12804 DunId:~p, SaodangNum:~p", [DunId, SaodangNum]),
    {Code, List, NewPlayer} = dungeon_godness:saodang_dun(Player, DunId, SaodangNum),
    ?DEBUG("Code:~p, List:~p", [Code, List]),
    {ok, Bin} = pt_128:write(12804,{Code, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 精英bossVIP副本
handle(12901, Player, _) ->
    {Data, MaxNum} = dungeon_elite_boss:dungeon_info(Player),
    {ok, Bin} = pt_129:write(12901, {Data, MaxNum}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取元素副本列表
handle(13301, Player, _) ->
    DunList = dungeon_element:get_dun_list(Player),
    {ok, Bin} = pt_133:write(13301, {DunList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取剑道副本列表
handle(13303, Player, _) ->
    Data = dungeon_jiandao:get_dun_list(Player),
    ?DEBUG("Data:~p", [Data]),
    {ok, Bin} = pt_133:write(13303, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 元素副本扫荡
handle(13306, Player, _) ->
    if
        Player#player.d_vip#dvip.vip_type /= 2 ->
            {ok, Bin} = pt_133:write(13306, {4, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            {Data, NewPlayer} = dungeon_element:saodang(Player),
            Code = ?IF_ELSE(Data == [], 0, 1),
            {ok, Bin} = pt_133:write(13306, {Code, Data}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 购买道具
handle(13307, Player, {GoodsId}) ->
    {Code, NewPlayer} = dungeon_jiandao:buy(Player, GoodsId),
    {ok, Bin} = pt_133:write(13307, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _player, _data) ->
    ok.

