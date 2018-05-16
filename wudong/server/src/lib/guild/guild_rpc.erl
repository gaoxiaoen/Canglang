%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 17:16
%%%-------------------------------------------------------------------
-module(guild_rpc).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("achieve.hrl").
-include("guild_fight.hrl").
%% API
-export([handle/3]).


%%获取创建仙盟信息
handle(40000, Player, _) ->
    guild_create:get_create_guild_info(Player),
    ok;

%%创建仙盟
handle(40001, Player, {GuildName, Type}) ->
    case guild_create:create_guild(Player, GuildName, Type) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40001, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {Ret, NewPlayer} ->
            {ok, Bin} = pt_400:write(40001, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            task_guild:enter_guild(NewPlayer),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4009, 0, 1),
            {ok, guild, NewPlayer}
    end;

%%解散仙盟
handle(40002, Player, _) ->
    Ret = guild_create:guild_dismiss(Player),
    {ok, Bin} = pt_400:write(40002, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取仙盟信息
handle(40003, Player, {}) ->
    case guild_util:get_guild_info(Player) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40003, {Res, <<>>, <<>>, 0, 0, 0, 0, 0, 0, 0, <<>>, 0, <<>>, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        Data ->
            {ok, Bin} = pt_400:write(40003, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%获取仙盟日志
handle(40004, Player, {Page}) ->
    Data = guild_util:get_guild_log(Player, Page),
    {ok, Bin} = pt_400:write(40004, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟改名
handle(40005, Player, {Name}) ->
    GuildName = util:filter_utf8(Name),
    {Ret, Cd, NewPlayer} = guild_util:change_guild_name(Player, GuildName),
    {ok, Bin} = pt_400:write(40005, {Ret, Cd}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取仙盟列表
handle(40006, Player, {Page, _}) ->
%%     From = ?IF_ELSE(Player#player.guild#st_guild.guild_key /= 0, 0, 1),
    From = 1,
    Data = guild_util:get_guild_list(From, Player#player.key, Player#player.guild#st_guild.guild_key, Page),
    {ok, Bin} = pt_400:write(40006, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%获取仙盟成员列表
handle(40007, Player, {Gkey}) ->
    Data = guild_util:get_guild_member_list(Player, Gkey),
    {ok, Bin} = pt_400:write(40007, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟申请
handle(40008, Player, {GuildKey, From}) ->
    {Ret, Cd, NewPlayer} = guild_util:guild_apply(Player, GuildKey, From),
    {ok, Bin} = pt_400:write(40008, {Ret, GuildKey, Cd}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 77 ->
        task_guild:enter_guild(NewPlayer),
        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4008, 0, 1),
        {ok, guild, NewPlayer};
        true -> ok
    end;

%%获取仙盟申请列表
handle(40009, Player, {Page}) ->
    Data = guild_util:guild_apply_list(Player, Page),
    {ok, Bin} = pt_400:write(40009, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟申请审批
handle(40010, Player, {Key, Result}) ->
    Ret = guild_util:guild_approval(Player, Key, Result),
    {ok, Bin} = pt_400:write(40010, {Ret, Key}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%退出工会
handle(40011, Player, _) ->
    {Ret, NewPlayer} = guild_util:guild_quit(Player),
    {ok, Bin} = pt_400:write(40011, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    StGuildFight = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{shop = Shop} = StGuildFight,
    Now = util:unixtime(),
    if
        Ret == 1 andalso Shop /= [] ->
            cache:set({guild_quit, Player#player.key}, Now, ?ONE_DAY_SECONDS);
        true -> skip
    end,
    {ok, guild, NewPlayer};

%%开除成员
handle(40012, Player, {PKey}) ->
    Ret = guild_util:guild_kickout(Player, PKey),
    {ok, Bin} = pt_400:write(40012, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    StGuildFight = lib_dict:get(?PROC_STATUS_GUILD_FIGHT),
    #st_guild_fight{shop = Shop} = StGuildFight,
    Now = util:unixtime(),
    if
        Ret == 1 andalso Shop /= [] ->
            cache:set({guild_quit, PKey}, Now, ?ONE_DAY_SECONDS);
        true -> skip
    end,
    ok;

%%转让会长
handle(40013, Player, {PKey}) ->
    {Ret, NewPlayer} = guild_appointment:guild_position_transfer(Player, PKey),
    {ok, Bin} = pt_400:write(40013, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%职位任命
handle(40014, Player, {PKey, Position}) ->
    Ret = guild_appointment:guild_position_appointment(Player, PKey, Position),
    {ok, Bin} = pt_400:write(40014, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%修改仙盟公告
handle(40015, Player, {Msg}) ->
    Ret = guild_util:change_notice(Player, Msg),
    {ok, Bin} = pt_400:write(40015, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),

    ok;

%%仙盟模糊查询
handle(40020, Player, {Name}) ->
    Data = guild_util:search_guild(Name, Player),
    {ok, Bin} = pt_400:write(40020, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟一键申请
handle(40021, Player, {}) ->
    {Ret, Cd, NewPlayer} = guild_util:auto_apply(Player),
    {ok, Bin} = pt_400:write(40021, {Ret, Cd}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 77 ->
        task_guild:enter_guild(NewPlayer),
        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4008, 0, 1),
        {ok, guild, NewPlayer};
        true -> ok
    end;

%%查询仙盟入会条件
handle(40022, Player, {}) ->
    Data = guild_util:get_apply_condition(Player),
    {ok, Bin} = pt_400:write(40022, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%设置仙盟入会条件
handle(40023, Player, {Type, Lv, Cbp}) ->
    Ret = guild_util:set_apply_condition(Player, Type, Lv, Cbp),
    {ok, Bin} = pt_400:write(40023, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        handle(40022, Player, {});
        true ->
            ok
    end;

%%仙盟改名卡改名
handle(40024, Player, {Name}) ->
    GuildName = util:filter_utf8(Name),
    Ret = guild_util:change_guild_name_use_goods(Player, GuildName),
    {ok, Bin} = pt_400:write(40024, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%发起弹劾
handle(40025, Player, {}) ->
    {Ret, NickName, NewPlayer} = guild_util:start_impeach(Player),
    {ok, Bin} = pt_400:write(40025, {Ret, NickName}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取奉献信息
handle(40030, Player, {}) ->
    Data = guild_dedicate:get_guild_dedicate_info(Player),
    {ok, Bin} = pt_400:write(40030, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%奉献了喂
handle(40031, Player, {GoodsNum, ColdNum}) ->
    {Ret, NewPlayer} = guild_dedicate:guild_dedicate(Player, GoodsNum, ColdNum),
    {ok, Bin} = pt_400:write(40031, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取技能列表
handle(40040, Player, _) ->
    Data = guild_skill:get_guild_skill(Player),
    {ok, Bin} = pt_400:write(40040, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%提升仙盟技能
handle(40041, Player, {Id}) ->
    {Ret, NewPlayer} = guild_skill:upgrade_guild_skill(Player, Id),
    {ok, Bin} = pt_400:write(40041, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%查看仙盟神兽信息
handle(40050, Player, _) ->
    Data = guild_boss:get_guild_boss_info(Player),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_400:write(40050, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟神兽喂养
handle(40051, Player, {Type}) ->
    {Res, NewPlayer} = guild_boss:guild_boss_feeding(Player, Type),
    ?DEBUG("Res ~p~n", [Res]),
    {ok, Bin} = pt_400:write(40051, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%仙盟神兽-超级召唤
handle(40052, Player, {}) ->
    {Res, NewPlayer} = guild_boss:sp_call(Player),
    {ok, Bin} = pt_400:write(40052, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%仙盟神兽-获取活动状态
handle(40053, Player, {}) ->
    Data =
        case guild_boss:is_activity_time() of
            true -> 1;
            false -> 0
        end,
    LeaveTime = guild_boss:get_leave_time(),

    {ok, Bin} = pt_400:write(40053, {Data,LeaveTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟神兽-获取伤害排名
handle(40054, Player, {}) ->
    Data = guild_boss:get_boss_damage(Player),
    ?DEBUG("40054 ~p~n", [Data]),
    {ok, Bin} = pt_400:write(40054, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟神兽-获取奖励
handle(40055, Player, {}) ->
    Data = guild_boss:get_boss_reward(Player),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_400:write(40055, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟神兽-获取神兽状态
handle(40056, Player, {}) ->
    Data = guild_boss:get_boss_state(Player#player.guild#st_guild.guild_key),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_400:write(40056, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%仙盟神兽-获取神兽血量信息
handle(40057, Player, {}) ->
    case get(cmd_40057) of
        undefined ->
            put(cmd_40057, util:unixtime()),
            Data = guild_boss:get_boss_hp(Player#player.guild#st_guild.guild_key),
            {ok, Bin} = pt_400:write(40057, Data),
            server_send:send_to_sid(Player#player.sid, Bin);
        Time ->
            Now = util:unixtime(),
            Timecheck = Now - Time,
            if
                Timecheck >= 3 ->
                    put(cmd_40057, Now),
                    Data = guild_boss:get_boss_hp(Player#player.guild#st_guild.guild_key),
                    {ok, Bin} = pt_400:write(40057, Data),
                    server_send:send_to_sid(Player#player.sid, Bin);
                true -> skip
            end
    end,
    ok;


%%修改仙盟图标
handle(40060, Player, {Id}) ->
    ?DEBUG("Id ~p~n",[Id]),
    Res = guild_icon:set_guid_icon(Player, Id),
    {ok, Bin} = pt_400:write(40060, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取仙盟图标
handle(40061, Player, {}) ->
    List = guild_icon:get_guid_icon_list(Player),
    {ok, Bin} = pt_400:write(40061, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%查看活跃度排行
handle(40071, Player, _) ->
    guild_hy:get_guild_hy_rank(Player),
    ok;

%%领取每日活跃度奖励
handle(40072, Player, _) ->
    case guild_hy:get_guild_hy_gift(Player) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40072, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_400:write(40072, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%点赞
handle(40073, Player, _) ->
    case guild_hy:like_player(Player) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40073, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_400:write(40073, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%查看活跃度排行
handle(40075, Player, _) ->
    guild_daily_gift:get_daily_gift_info(Player),
    ok;

%%领取每日福利奖励
handle(40076, Player, _) ->
    case guild_daily_gift:get_daily_gift(Player) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40076, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_400:write(40076, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%获取妖魔入侵面板信息
handle(40080, Player, _) ->
    guild_demon:get_guild_demon_info(Player),
    ok;

%%领取通关波数奖励
handle(40081, Player, {Floor}) ->
    case guild_demon:get_demon_gift(Player, Floor) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40081, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_400:write(40081, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%扫荡
handle(40082, Player, _) ->
    case guild_demon:sweep(Player) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40082, {Res, 0, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, Floor, GoodsList} ->
            {ok, Bin} = pt_400:write(40082, {1, Floor, GoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            guild_demon:get_guild_demon_info(NewPlayer),
            {ok, NewPlayer}
    end;

%%获取今日助威
handle(40083, Player, _) ->
    guild_demon:get_cheer_list(Player),
    ok;

%%获取我的助威
handle(40084, Player, _) ->
    guild_demon:get_my_cheer(Player),
    ok;

%%助威
handle(40085, Player, {Pkey}) ->
    case guild_demon:cheer_player(Player, Pkey) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40085, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_400:write(40085, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%请求助威
handle(40086, Player, _) ->
    case guild_demon:help_cheer(Player) of
        {false, Res} ->
            {ok, Bin} = pt_400:write(40086, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_400:write(40086, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%获取仙盟宝箱信息
handle(40090, Player, _) ->
    guild_box:get_box_info(Player),
    ok;

%%获取已协助列表
handle(40091, Player, _) ->
    guild_box:get_box_help_list(Player),
    ok;

%%获取可协助列表
handle(40092, Player, _) ->
    guild_box:get_box_not_help_list(Player),
    ok;

%%获取新宝箱
handle(40093, Player, _) ->
    Res = guild_box:get_new_box(Player),
    {ok, Bin} = pt_400:write(40093, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(Player, [178], true), ok;

%%提升宝箱品质
handle(40094, Player, {Color}) ->
    {Res, NewPlayer} = guild_box:up_box_color(Player, Color),
    {ok, Bin} = pt_400:write(40094, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%协助宝箱
handle(40095, Player, {Bkey}) ->
    guild_box:help_box(Player, Bkey),
    ok;

%% 清除获取cd
handle(40096, Player, {}) ->
    {Res, NewPlayer} = guild_box:clean_get_cd(Player),
    ?DEBUG("Res ~p~n",[Res]),
    {ok, Bin} = pt_400:write(40096, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 清除协助cd
handle(40097, Player, {}) ->
    {Res, NewPlayer} = guild_box:clean_help_cd(Player),
    {ok, Bin} = pt_400:write(40097, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 领取宝箱
handle(40098, Player, {Bkey}) ->
    guild_box:get_box_reward(Player, Bkey),
    activity:get_notice(Player, [178], true),
    ok;

%% 宝箱求助
handle(40099, Player, {Bkey}) ->
    Res = guild_box:box_help_notice(Player, Bkey),
    {ok, Bin} = pt_400:write(40099, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%============家园==pt_401=============

handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p ~p~n", [_cmd, _Data]),
    ok.