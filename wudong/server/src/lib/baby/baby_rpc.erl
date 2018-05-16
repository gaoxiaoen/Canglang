%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%%  @doc宝宝系统
%%% @end
%%%-------------------------------------------------------------------
-module(baby_rpc).
-author("lzx").

-include("common.hrl").
-include("server.hrl").

%% API
-export([handle/3]).

%% @doc 请求宝宝信息
handle(16301, Player, {}) ->
    PackData = baby:pack_data(Player),
%%    ?PRINT("16301 ~w ============",[PackData]),
    {ok, BinData} = pt_163:write(16301, PackData),
    server_send:send_to_sid(Player#player.sid, BinData),
    ok;


%% @doc 宝宝出战
handle(16302, Player, {}) ->
    case baby:go_fight(Player) of
        {ok, NewPlayer} ->
            {ok, BinData} = pt_163:write(16302, {1}),
            server_send:send_to_sid(Player#player.sid, BinData),
            {ok, attr, NewPlayer};
        {fail, Res} ->
            {ok, BinData} = pt_163:write(16302, {Res}),
            server_send:send_to_sid(Player#player.sid, BinData),
            ok
    end;


%% @doc 宝宝改名
handle(16303, Player, {FigureId,Name}) ->
    BabyName2 = util:filter_utf8(Name),
    case catch baby:change_name(Player,FigureId, BabyName2) of
        {ok, NewPlayer} ->
            Res = 1;
        {fail, Res} -> NewPlayer = Player
    end,
    {ok, BinData} = pt_163:write(16303, {Res}),
    server_send:send_to_sid(Player#player.sid, BinData),
    {ok, NewPlayer};


%%技能升级
handle(16304, Player, {Cell}) ->
    case catch baby:upgrade_skill(Player, Cell) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [145], true),
            {ok, Bin} = pt_163:write(16304, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer};
        {fail, Res} ->
            {ok, Bin} = pt_163:write(16304, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%% @doc 宝宝进阶
handle(16305, Player, {IsAuto}) ->
    case catch baby:upgrade_step(Player, IsAuto) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [145], true),
            {ok, BinData} = pt_163:write(16305, {1}),
            server_send:send_to_sid(Player#player.sid, BinData),
            {ok, attr, NewPlayer};
        {fail, Res} ->
            {ok, BinData} = pt_163:write(16305, {Res}),
            server_send:send_to_sid(Player#player.sid, BinData),
            ok
    end;


%% @doc 宝宝喂养
handle(16306, Player, {IsAuto}) ->
    case catch baby:feed_baby(Player, IsAuto) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [145], true),
            {ok, BinData} = pt_163:write(16306, {1}),
            server_send:send_to_sid(Player#player.sid, BinData),
            {ok, attr, NewPlayer};
        {fail, Res} ->
            {ok, BinData} = pt_163:write(16306, {Res}),
            server_send:send_to_sid(Player#player.sid, BinData),
            ok
    end;


%% @doc 宝宝转性别
handle(16307, Player, {}) ->
    case catch baby:change_sex(Player) of
        {ok, NewPlayer} ->
            {ok, BinData} = pt_163:write(16307, {1}),
            server_send:send_to_sid(Player#player.sid, BinData),
            handle(16301, NewPlayer, {}),
            {ok, attr, NewPlayer};
        {fail, Res} ->
            {ok, BinData} = pt_163:write(16307, {Res}),
            server_send:send_to_sid(Player#player.sid, BinData),
            ok
    end;


%% @doc 创建宝宝
handle(16310, Player, {Sex, BabyName}) ->
    BabyName2 = util:filter_utf8(BabyName),
    case catch baby:create_baby(Player, Sex, BabyName2) of
        {ok, NewPlayer} ->
            {ok, BinData} = pt_163:write(16310, {1}),
            server_send:send_to_sid(Player#player.sid, BinData),
            {ok, attr, NewPlayer};
        {fail, Res} ->
            {ok, BinData} = pt_163:write(16310, {Res}),
            server_send:send_to_sid(Player#player.sid, BinData),
            ok
    end;


%% 获取图鉴列表
handle(16311, Player, _) ->
    Data = baby:pic_list(Player),
    {ok, Bin} = pt_163:write(16311, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%% @doc 激活图鉴
handle(16312, Player, {FigureId}) ->
    case catch baby:active_pic(Player, FigureId) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [145], true),
            {ok, Bin} = pt_163:write(16312, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer};
        {fail, Res} ->
            {ok, Bin} = pt_163:write(16312, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%幻化
handle(16313, Player, {FigureId}) ->
    case catch baby:change_figure(Player, FigureId) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_163:write(16313, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {fail, Res} ->
            {ok, Bin} = pt_163:write(16313, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%装备物品
handle(16315, Player, {GoodsKey}) ->
    case catch baby:equip_goods(Player, GoodsKey) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [145], true),
            {ok, Bin} = pt_163:write(16315, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer#player{baby_equip = baby:baby_equip_attr_view()}};
        {fail, Res} ->
            {ok, Bin} = pt_163:write(16315, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%% 签到信息
handle(16316, Player, {}) ->
    SendSignList = baby:signin_info_list(Player),
    ?PRINT("SendSignList ~w", [SendSignList]),
    {ok, Bin} = pt_163:write(16316, SendSignList),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%% 签到
handle(16317, Player, {SignType, SignDay}) ->
    case catch baby:sign_up(Player, SignType, SignDay) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [145], true),
            {ok, Bin} = pt_163:write(16317, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {fail, Res} ->
            {ok, Bin} = pt_163:write(16317, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%% 领取击杀奖励
handle(16318, Player, {KillId}) ->
    case catch baby:get_kill_award(Player, KillId) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [145], true),
            {ok, Bin} = pt_163:write(16318, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {fail, Res} ->
            {ok, Bin} = pt_163:write(16318, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%% 时间加速
handle(16319, Player, {GoodsId}) ->
    case catch baby:time_speed(Player, GoodsId) of
        {ok, NewPlayer, LeftTime} ->
            {ok, Bin} = pt_163:write(16319, {1, LeftTime}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {fail, Res} ->
            ?PRINT("16319 ========= ~w", [Res]),
            {ok, Bin} = pt_163:write(16319, {Res, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


handle(_Cmd, _, _) ->
    ?DEBUG("cmd undef ~p~n", [_Cmd]),
    ok.

