%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 11:20
%%%-------------------------------------------------------------------
-module(cross_war_rpc).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").
-include("guild.hrl").

%% API
-export([handle/3]).

%% 读取活动状态
handle(60101, Player, _) ->
    if
        Player#player.lv < ?CROSS_WAR_LIMIT_LV ->
            {ok, Bin} = pt_601:write(60101, {?CROSS_WAR_STATE_CLOSE, 0, 0, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            cross_war:get_act_state(Player)
    end;

%% 读取面板
handle(60102, Player, _) ->
    cross_war:get_act_info(Player),
    ok;

%% 读取我的公会信息
handle(60103, Player, _) ->
    #player{guild = StGuild, node = Node, sid = Sid} = Player,
    cross_area:war_apply(cross_war, get_my_contrib_info, [StGuild#st_guild.guild_key, Node, Sid]),
    ok;

%% 获取 防守/攻击 公会排行榜
handle(60104, Player, {Type}) ->
    #player{guild = StGuild, node = Node, sid = Sid} = Player,
    cross_area:war_apply(cross_war_rank, get_guild_contrib_rank, [StGuild#st_guild.guild_key, Node, Sid, Type]),
    ok;

%% 获取 防守/攻击 个人排行榜
handle(60105, Player, {Type}) ->
    #player{key = Pkey, node = Node, sid = Sid} = Player,
    cross_area:war_apply(cross_war_rank, get_member_contrib_rank, [Pkey, Node, Sid, Type]),
    ok;

%% 贡献
handle(60108, Player, {GoodsId, GoodsNum}) ->
    Week = util:get_day_of_week(),
    if
        Week < 6 ->
            {ok, Bin} = pt_601:write(60108, {0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            {Code, ConVal, NewPlayer} = cross_war:contrib(Player, GoodsId, GoodsNum),
            {ok, Bin} = pt_601:write(60108, {Code, ConVal}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 攻城会议获取公会列表
handle(60109, Player, {Type}) ->
    Guild = guild_ets:get_guild(Player#player.guild#st_guild.guild_key),
    Code =
        if
            Player#player.guild#st_guild.guild_key == 0 -> 3;
            Player#player.guild#st_guild.guild_position > 2 -> 25;
            Guild#guild.lv < 2 -> 26;
            true ->
                1
        end,
    case Code == 1 of
        true ->
            #player{node = Node, guild = StGuild, sid = Sid} = Player,
            cross_area:war_apply(cross_war, get_meeting_guild_list, [StGuild#st_guild.guild_key, Node, Sid, Type]);
        false ->
            {ok, Bin} = pt_601:write(60109, {Code, []}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

%% 切换阵营方
handle(60110, Player, {Type}) ->
    Week = util:get_day_of_week(),
    OpenDay = config:get_open_days(),
    if
        Week == 5 andalso OpenDay =< 1 orelse Week == 6 andalso OpenDay =< 2 orelse Week == 7 andalso OpenDay =< 3 ->
            {ok, Bin} = pt_601:write(60110, {2, Type}),
            server_send:send_to_sid(Player#player.sid, Bin);
        Week < 6  -> %% 活动当天不切换阵营
            {ok, Bin} = pt_601:write(60110, {31, Type}),
            server_send:send_to_sid(Player#player.sid, Bin);
        Player#player.lv < ?CROSS_WAR_LIMIT_LV ->
            {ok, Bin} = pt_601:write(60110, {16, Type}),
            server_send:send_to_sid(Player#player.sid, Bin);
        true ->
            cross_area:war_apply(cross_war, change_sign, [Player, Type])
    end,
    ok;

%% 领取每日奖励及城主奖励
handle(60111, Player, {Type}) ->
    Week = util:get_day_of_week(),
    PassSec = util:get_seconds_from_midnight(),
    if
        Week == 6 ->
            {ok, Bin} = pt_601:write(60111, {33}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        Week == 7 andalso PassSec < 21 * ?ONE_HOUR_SECONDS ->
            {ok, Bin} = pt_601:write(60111, {33}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            {Code, NewPlayer} =
                case Type of
                    ?CROSS_WAR_TYPE_KING_REWARD ->
                        cross_war:recv_king_reward(Player);
                    _ ->
                        cross_war:recv_member_reward(Player)
                end,
            {ok, Bin} = pt_601:write(60111, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            activity:get_notice(NewPlayer, [143, 149], true),
            {ok, NewPlayer}
    end;

%% 获取防守公会积分排行榜
handle(60112, Player, {Type}) ->
    #player{guild = StGuild, node = Node, sid = Sid} = Player,
    cross_area:war_apply(cross_war_rank, get_guild_score_rank, [StGuild#st_guild.guild_key, Node, Sid, Type]),
    ok;

%% 获取防守成员积分排行榜
handle(60113, Player, {Type}) ->
    #player{key = Pkey, node = Node, sid = Sid} = Player,
    cross_area:war_apply(cross_war_rank, get_member_score_rank, [Pkey, Node, Sid, Type]),
    ok;

%% 获取攻城信息
handle(60116, Player, _) ->
    cross_area:war_apply(cross_war, get_cross_war_info, [Player]),
    ok;

%% 进入战场
handle(60117, Player, _) ->
    case Player#player.lv < ?CROSS_WAR_LIMIT_LV of
        false ->
            cross_war:enter_cross_war(Player),
            NewPlayer = mount_util:get_off(Player),
            St = lib_dict:get(?PROC_STATUS_CROSS_WAR),
            NewSt = St#st_cross_war{op_time = util:unixtime(), guild_key = Player#player.guild#st_guild.guild_key},
            lib_dict:put(?PROC_STATUS_CROSS_WAR, NewSt),
            cross_war_load:update(NewSt),
            {ok, NewPlayer};
        true ->
            {ok, Bin} = pt_601:write(60117, {16}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%% 活动开启通知（服务器主动推送）
handle(60118, _Player, _) ->
    ok;

%% 获取当前战场数据
handle(60119, Player, _) ->
    #player{node = Node, key = Pkey, sid = Sid} = Player,
    cross_area:war_apply(cross_war, get_now_war_info, [Node, Pkey, Sid]),
    ok;

%% 退出战斗
handle(60120, Player, _) ->
    cross_area:war_apply(cross_war, quit_war, [Player]),
    {ok, Player#player{crown = 0}};

%% 活动结束通知（服务器主动推送）
handle(60121, _Player, _) ->
    ok;

%% 兑换炮弹
handle(60123, Player, {Type}) ->
    #player{key = Pkey, node = Node, sid = Sid} = Player,
    Code =
        case Type of
            2 -> cross_war:exchange_car(Pkey, Node, Sid); %% 兑换战车
            1 -> cross_war:exchange_bomb(Pkey, Node, Sid); %% 兑换炸弹
            _ -> 0
        end,
    {ok, Bin} = pt_601:write(60123, {Type,Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 前往携带王珠玩家位置
handle(60124, Player, _) ->
    #player{x = X, y = Y, node = Node, sid = Sid} = Player,
    cross_area:war_apply(cross_war, get_now_king_x_y, [X, Y, Node, Sid]),
    ok;

%% 放下宝珠
handle(60125, Player, _) ->
    cross_area:war_apply(cross_war, put_down_king_gold, [Player]),
    ok;

%% 使用炮弹/战车
handle(60126, Player, _) ->
    cross_area:war_apply(cross_war, use_bomb, [Player]),
    ok;

%% 获取地图信息
handle(60127, Player, _) ->
    #player{node = Node, sid = Sid} = Player,
    cross_area:war_apply(cross_war_map, get_war_map, [Node, Sid]),
    ok;

%% 膜拜
handle(60128, Player, _) ->
    Week = util:get_day_of_week(),
    if
        Week >= 6 -> ok;
        true ->
            ?DEBUG("60128", []),
            {Code, NewPlayer} = cross_war:orz(Player),
            {ok, Bin} = pt_601:write(60128, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(_Cmd, _Player, _Msg) ->
    ?DEBUG("CMD:~p", [_Cmd]),
    ok.
