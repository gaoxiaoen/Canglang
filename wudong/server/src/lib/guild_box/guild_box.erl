%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 十二月 2017 11:58
%%%-------------------------------------------------------------------
-module(guild_box).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("daily.hrl").
-include("guild.hrl").
%% API
-export([
    get_box_info/1,
    get_box_help_list/1,
    get_box_not_help_list/1,
    get_new_box/1,
    up_box_color/2,
    help_box/2,
    get_box_reward/2,
    clean_get_cd/1,
    clean_help_cd/1,
    get_state/1,
    box_help_notice/2,
    update_player_list_gkey/2]).

get_box_info(Player) ->
    AllGetCount = data_vip_args:get(58, Player#player.vip_lv),
    St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
    ?CAST(guild_box_proc:get_server_pid(),
        {get_box_info,
            Player,
            max(0, ?GUILD_BOX_FREE_UP_COUTN - daily:get_count(?DAILY_GUILD_FREE_UP)),
            max(0, AllGetCount - daily:get_count(?DAILY_GUILD_BOX_GET)),
            St#player_guild_box.get_cd,
            St#player_guild_box.is_get_cd,
            St#player_guild_box.index_id
        }),
    ok.

get_box_help_list(Player) ->
    ?CAST(guild_box_proc:get_server_pid(), {get_box_help_list, Player#player.sid, Player#player.guild#st_guild.guild_key}),
    ok.

get_box_not_help_list(Player) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
    ?CAST(guild_box_proc:get_server_pid(),
        {get_box_not_help_list, max(0, ?GUILD_BOX_HELP_COUTN - daily:get_count(?DAILY_GUILD_HELP)),
            St#player_guild_box.help_cd,
            St#player_guild_box.is_help_cd,
            Player#player.sid,
            Player#player.key,
            Player#player.guild#st_guild.guild_key}),
    ok.

get_new_box(Player) ->
    case check_get_new_box(Player) of
        {false, Res} -> Res;
        {ok, BaseId} ->
            daily:increment(?DAILY_GUILD_BOX_GET, 1),
            BoxKey = misc:unique_key(),
            Now = util:unixtime(),
            BaseBox = data_guild_box:get(BaseId),
            Reward = util:list_rand_ratio([{{GoodsId0, GoodsNum}, Ratio0} || {GoodsId0, GoodsNum, Ratio0} <- BaseBox#base_guild_box.reward_list]),
            NewGuildBox = #guild_box{
                box_key = BoxKey,
                pkey = Player#player.key,
                pname = Player#player.nickname,
                gkey = Player#player.guild#st_guild.guild_key,
                start_time = Now,
                reward_list = [Reward],
                end_time = Now + BaseBox#base_guild_box.cd_time,
                base_id = BaseId
            },
            St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
            NewGetCd = ?IF_ELSE(St#player_guild_box.get_cd < Now, Now + ?GUILD_BOX_GET_BOX_CD, St#player_guild_box.get_cd + ?GUILD_BOX_GET_BOX_CD),
            IsGetCd = ?IF_ELSE(NewGetCd - Now >= ?GUILD_BOX_GET_BOX_IN_CD, 1, St#player_guild_box.is_get_cd),
            Ratio = data_guild_box_ratio:get(0),
            NewId = util:list_rand_ratio(Ratio),
            NewSt = St#player_guild_box{
                get_cd = NewGetCd,
                is_get_cd = IsGetCd,
                index_id = NewId,
                index_count = 1
            },
            lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
            guild_box_load:update_player_data(NewSt),
            activity:get_notice(Player, [178], true),
            ?CAST(guild_box_proc:get_server_pid(), {get_new_box, NewGuildBox}),
            1
    end.

check_get_new_box(Player) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
    if
        Player#player.guild#guild.gkey == 0 -> {false, 3};
        true ->
            AllGetCount = data_vip_args:get(58, Player#player.vip_lv),
            DailyCount = daily:get_count(?DAILY_GUILD_BOX_GET),
            if
                DailyCount >= AllGetCount -> {false, 700}; %% 次数不足
                true ->
                    Now = util:unixtime(),
                    if
                        St#player_guild_box.is_get_cd == 1 andalso St#player_guild_box.get_cd >= Now ->
                            ?DEBUG("Now ~p~n",[Now]),
                            ?DEBUG("Now ~p~n",[Now]),
                            ?DEBUG("Now ~p~n",[Now]),
                            ?DEBUG("St#player_guild_box.get_cd ~p~n",[St#player_guild_box.get_cd]),
                            ?DEBUG("St#player_guild_box.get_cd ~p~n",[St#player_guild_box.get_cd]),
                            {false, 701}; %% 冷却中
                        true ->
                            if
                                St#player_guild_box.is_get_cd == 1 andalso St#player_guild_box.get_cd < Now ->
                                    NewSt = St#player_guild_box{get_cd = 0, is_get_cd = 0},
                                    lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
                                    guild_box_load:update_player_data(NewSt);
                                true -> skip
                            end,
                            {ok, St#player_guild_box.index_id}
                    end
            end
    end.


%% 提升宝箱品质
%% 提升一次
up_box_color(Player, 0) ->
    case check_up_box_color(Player) of
        {false, Res} -> {Res, Player};
        {ok, Cost} ->
            St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
            MaxColor = data_guild_box:get_max(),
            if
                St#player_guild_box.index_id >= MaxColor -> {707, Player};
                true ->
                    NewPlayer = money:add_no_bind_gold(Player, -Cost, 330, 0, 0),
                    NewSt = up_one(St),
                    lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
                    guild_box_load:update_player_data(NewSt),
                    {1, NewPlayer}
            end
    end;

%% 提升到指定颜色
up_box_color(Player, Color) ->
    MaxColor = data_guild_box:get_max(),
    if
        Color > MaxColor orelse Color < 0 -> {0, Player};
        true ->
            Count = max(0, ?GUILD_BOX_FREE_UP_COUTN - daily:get_count(?DAILY_GUILD_FREE_UP)),
            St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
            if
                St#player_guild_box.index_id >= Color -> {707, Player};
                true ->
                    if
                        Count > 0 ->  %% 使用完免费次数 或 提升到特定品质
                            {NewPlayer, NewSt} = up_box_color_help(Player, St, Count, Color),
                            lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
                            guild_box_load:update_player_data(NewSt),
                            {1, NewPlayer};
                        true ->  %% 使用完元宝 或 提升到特定品质
                            case check_up_box_color(Player) of
                                {false, Res} -> {Res, Player};
                                _ ->
                                    {NewPlayer, NewSt} = up_box_color_help(Player, St, 50, Color), %% 最多随机50次
                                    lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
                                    guild_box_load:update_player_data(NewSt),
                                    {1, NewPlayer}
                            end

                    end
            end
    end.


check_up_box_color(Player) ->
    Count = max(0, ?GUILD_BOX_FREE_UP_COUTN - daily:get_count(?DAILY_GUILD_FREE_UP)),
    Cost =
        if Count == 0 -> ?GUILD_BOX_GET_COST;
            true -> 0
        end,
    case money:is_enough(Player, Cost, gold) of
        false -> {false, 801};
        true ->
            {ok, Cost}
    end.

%% check_up_box_color(Player, 0) ->
%%     Count = max(0, ?GUILD_BOX_FREE_UP_COUTN - daily:get_count(?DAILY_GUILD_FREE_UP)),
%%     Cost =
%%         if Count == 0 -> ?GUILD_BOX_GET_COST;
%%             true -> 0
%%         end,
%%     case money:is_enough(Player, Cost, gold) of
%%         false -> {false, 801};
%%         true ->
%%             {ok, Cost}
%%     end.

up_box_color_help(Player, St, Count, _Color) when Count =< 0 -> {Player, St};
up_box_color_help(Player, St, Count, Color) ->
    if
        St#player_guild_box.index_id >= Color -> {Player, St};
        true ->
            case check_up_box_color(Player) of
                {false, _Res} -> {Player, St};
                {ok, Cost} ->
                    NewPlayer = money:add_no_bind_gold(Player, -Cost, 330, 0, 0),
                    NewSt = up_one(St),
                    up_box_color_help(NewPlayer, NewSt, Count - 1, Color)
            end
    end.

up_one(St) ->
    daily:increment(?DAILY_GUILD_FREE_UP, 1),
    Id = St#player_guild_box.index_id,
    Count = St#player_guild_box.index_count,
    Ratio = data_guild_box_ratio:get(Count),
    Ratio1 = [{Id0, Val} || {Id0, Val} <- Ratio, Id0 >= Id],
    NewId = util:list_rand_ratio(Ratio1),
    NewSt = St#player_guild_box{
        index_id = NewId,
        index_count = Count + 1
    },
    NewSt.

%%协助宝箱
help_box(Player, Bkey) ->
    case check_help_box(Player) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40095, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin);
        ok ->
            ?CAST(guild_box_proc:get_server_pid(), {help_box, Player, Bkey})
    end,
    ok.

check_help_box(Player) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
    if
        Player#player.guild#guild.gkey == 0 -> {false, 3};
        true ->
            HelpCount = max(0, ?GUILD_BOX_HELP_COUTN - daily:get_count(?DAILY_GUILD_HELP)),
            if
                HelpCount == 0 -> {false, 700}; %% 次数不足
                true ->
                    Now = util:unixtime(),
                    if
                        St#player_guild_box.is_help_cd == 1 andalso St#player_guild_box.help_cd >= Now ->
                            {false, 701}; %% 冷却中
                        true ->
                            if
                                St#player_guild_box.is_help_cd == 1 andalso St#player_guild_box.help_cd < Now ->
                                    NewSt = St#player_guild_box{help_cd = 0, is_help_cd = 0},
                                    lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
                                    guild_box_load:update_player_data(NewSt);
                                true -> skip
                            end,
                            ok
                    end
            end
    end.


get_box_reward(Player, Bkey) ->
    ?CAST(guild_box_proc:get_server_pid(), {get_box_reward, Player, Bkey}),
    ok.

clean_get_cd(Player) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
    if
        St#player_guild_box.is_get_cd == 0 -> {706, Player};
        true ->
            case money:is_enough(Player, ?GUILD_BOX_CLEAN_GET_CD_COST, gold) of
                false -> {801, Player};
                true ->
                    NPlayer = money:add_no_bind_gold(Player, -?GUILD_BOX_CLEAN_GET_CD_COST, 333, 0, 0),
                    NewSt = St#player_guild_box{
                        get_cd = 0,
                        is_get_cd = 0
                    },
                    lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
                    guild_box_load:update_player_data(NewSt),
                    {1, NPlayer}
            end
    end.

clean_help_cd(Player) ->
    St = lib_dict:get(?PROC_STATUS_GUILD_BOX),
    if
        St#player_guild_box.is_help_cd == 0 -> {706, Player};
        true ->
            case money:is_enough(Player, ?GUILD_BOX_CLEAN_HELP_CD_COST, gold) of
                false -> {801, Player};
                true ->
                    NPlayer = money:add_no_bind_gold(Player, -?GUILD_BOX_CLEAN_HELP_CD_COST, 334, 0, 0),
                    NewSt = St#player_guild_box{
                        help_cd = 0,
                        is_help_cd = 0
                    },
                    lib_dict:put(?PROC_STATUS_GUILD_BOX, NewSt),
                    guild_box_load:update_player_data(NewSt),
                    {1, NPlayer}
            end
    end.

box_help_notice(Player, Bkey) ->
    case cache:get({Bkey, Player#player.key}) of
        1 -> 708;
        _ ->
            ?CAST(guild_box_proc:get_server_pid(), {box_help_notice, Player, Bkey}),
            cache:set({Bkey, Player#player.key}, 1),
            1
    end.

update_player_list_gkey(KeyList, Gkey) ->
    ?CAST(guild_box_proc:get_server_pid(), {update_player_list_gkey, KeyList, Gkey}),
    ok.

get_state(Player) ->
    Count = max(0, ?GUILD_BOX_FREE_UP_COUTN - daily:get_count(?DAILY_GUILD_FREE_UP)),
    AllGetCount = data_vip_args:get(58, Player#player.vip_lv),
    Count1 = max(0, AllGetCount - daily:get_count(?DAILY_GUILD_BOX_GET)),
    spawn(fun() -> util:sleep(3000),
        ?CAST(guild_box_proc:get_server_pid(), {get_notice_player, Player, Count1, Count}) end),
    ok.
