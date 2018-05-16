%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 九月 2017 15:02
%%%-------------------------------------------------------------------
-module(dvip_util).
-author("lzx").
-include("common.hrl").
-include("server.hrl").
-include("dvip.hrl").
-include("dungeon.hrl").
-include("daily.hrl").
-include("player_mask.hrl").

%% API
-export([
    vip_update/1,
    check_buy_dungeon_free/2,
    inc_dungeon_time/2,
    get_active_skill/1,
    free_act_buy_money/1,
    free_act_buy_money2/1,
    add_act_buy_money/1,
    check_dvip_end_time/2,
    get_act_buy_money_free_time/1,
    add_act_buy_money2/1,
    get_act_buy_money_free_time2/1,
    vip_time_out_mail/1
]).


%% vip 场景更新
vip_update(Player) ->
    {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(Player)),
    server_send:send_to_sid(Player#player.sid, Bin1),
    scene_agent_dispatch:update_d_vip(Player).


%% 检查购买副本是否免费
check_buy_dungeon_free(#player{d_vip = #dvip{vip_type = VipType}} = _Player, #dungeon{id = _DungeonId}) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{dungeon = DungeonList} when DungeonList /= [] ->
            {rs_time, RsTime} = lists:keyfind(rs_time, 1, DungeonList),
            NowTime = daily:get_count(?DAILY_DVIP_DUN_DAILY_SWEEP(_DungeonId), 0),
            ?IF_ELSE(RsTime > NowTime, 1, 0);
        _ ->
            0
    end.


%% 招财进宝是否免费
free_act_buy_money(#player{d_vip = #dvip{vip_type = VipType}} = _Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{draw = DrawTime} when DrawTime > 0 ->
            NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY, 0),
            ?IF_ELSE(DrawTime > NowTime, true, false);
        _ ->
            false
    end.


%% 招财进宝是否免费
free_act_buy_money2(#player{d_vip = #dvip{vip_type = VipType}} = _Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{draw = DrawTime} when DrawTime > 0 ->
            NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY_2, 0),
            ?IF_ELSE(DrawTime > NowTime, true, false);
        _ ->
            false
    end.

%% 获取招财进宝免费次数
get_act_buy_money_free_time(#player{d_vip = #dvip{vip_type = VipType}} = _Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{draw = DrawTime} when DrawTime > 0 ->
            NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY, 0),
            max(DrawTime - NowTime, 0);
        _ ->
            0
    end.

get_act_buy_money_free_time2(#player{d_vip = #dvip{vip_type = VipType}} = _Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{draw = DrawTime} when DrawTime > 0 ->
            NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY_2, 0),
            max(DrawTime - NowTime, 0);
        _ ->
            0
    end.


%%
add_act_buy_money(_Player) ->
    NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY, 0),
    daily:set_count(?DAILY_DVIP_DRAW_ACT_BUY, NowTime + 1).


add_act_buy_money2(_Player) ->
    NowTime = daily:get_count(?DAILY_DVIP_DRAW_ACT_BUY_2, 0),
    daily:set_count(?DAILY_DVIP_DRAW_ACT_BUY_2, NowTime + 1).


%%
inc_dungeon_time(_Player, DungeonId) ->
    NowTime = daily:get_count(?DAILY_DVIP_DUN_DAILY_SWEEP(DungeonId), 0),
    daily:set_count(?DAILY_DVIP_DUN_DAILY_SWEEP(DungeonId), NowTime + 1).


%% 激活技能
get_active_skill(#player{d_vip = #dvip{vip_type = VipType}} = _Player) ->
    case data_d_vip:get(VipType) of
        #base_d_vip_config{active_skill = ActiveSkill} when ActiveSkill > 0 ->
            [ActiveSkill, 1];
        _ ->
            #base_d_vip_config{active_skill = ActiveSkill} = data_d_vip:get(1),
            [ActiveSkill, 0]
    end.


%% vip 过期了
check_dvip_end_time(#player{d_vip = #dvip{vip_type = VipType, time = Time}} = _Player, NowTime) ->
    case (VipType == 1 orelse ?DVIP_EFFECT_SP_TIME /= 0) andalso NowTime > Time andalso Time > 0 of
        true ->
            dvip:dvip_time_out(_Player);
        _ ->
            _Player
    end.


%% vip 超时邮件推送
vip_time_out_mail(#player{d_vip = #dvip{vip_type = VipType}} = _Player) ->
    NowTime = util:unixtime(),
    case VipType > 0 of
        true -> skip;
        _ ->
            EvenVip = player_mask:get(?PLAYER_EVER_DVIP_STATE, 0),
            case EvenVip > 0 of %%曾经是vip
                true ->
                    {Time, PushTime} = player_mask:get(?PLAYER_DVIP_TIME_OUT_PUSH, {0, 0}),
                    case util:is_same_date(NowTime, Time) of
                        true -> skip;
                        false ->
                            case PushTime > 3 of
                                true -> skip;
                                false ->
                                    player_mask:set(?PLAYER_DVIP_TIME_OUT_PUSH, {NowTime, PushTime + 1}),
                                    {ok, BinData} = pt_404:write(40411, {3}),
                                    server_send:send_to_sid(_Player#player.sid, BinData)
                            end
                    end;
                _ ->
                    skip
            end
    end.














