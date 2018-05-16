%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 仙盟创建相关
%%% @end
%%% Created : 23. 一月 2017 下午6:10
%%%-------------------------------------------------------------------
-module(guild_create).
-author("fengzhenlin").
-include("server.hrl").
-include("guild.hrl").
-include("common.hrl").
-include("cross_war.hrl").

%% API
-compile(export_all).

%%获取创建仙盟信息
get_create_guild_info(Player) ->
    F = fun(Type) ->
        Base = data_create_guild:get(Type),
        #base_create_guild{
            need_lv = NeedLv,
            gold = Gold,
            bgold = BGold
        } = Base,
        BaseGift = data_guild_daily_gift:get(Type),
        #base_guild_daily_gift{
            goods_list = GoodsList
        } = BaseGift,
        GoodsList1 = [tuple_to_list(Info) || Info <- GoodsList],
        [Type, NeedLv, Gold, BGold, GoodsList1]
        end,
    List = lists:map(F, [1, 2]),
    {ok, Bin} = pt_400:write(40000, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%创建仙盟
create_guild(Player, Name0, Type) ->
    case check_create_guild(Player, Name0, Type) of
        {false, Res} -> {false, Res};
        {ok, Name, CostGold, CostBGold} ->
            Now = util:unixtime(),
            Guild = make_new_guild(Player, Name, Now, Type),

            _Member = make_new_guild_member(Player, Guild, ?GUILD_POSITION_CHAIRMAN, Now),
            guild_ets:del_guild_apply_by_pkey(Player#player.key),
            guild_load:del_guild_apply_by_pkey(Player#player.key),
            %%扣钱
            Player0 = ?IF_ELSE(CostGold > 0, money:add_no_bind_gold(Player, -CostGold, 3, 0, 0), Player),
            Player1 = ?IF_ELSE(CostBGold > 0, money:add_gold(Player0, -CostBGold, 3, 0, 0), Player0),
            guild_skill:load_player_guild_skill(Player#player.lv, Guild#guild.gkey),
            StGuild = #st_guild{guild_key = Guild#guild.gkey, guild_name = Name, guild_position = ?GUILD_POSITION_CHAIRMAN},
            Player2 = Player1#player{guild = StGuild},
            NewPlayer = player_util:count_player_attribute(Player2, true),
            guild_load:log_guild(Guild#guild.gkey, Guild#guild.name, Player#player.key, Player#player.nickname, 1, util:unixtime()),
            guild_manor:new_guild_manor(Guild#guild.gkey),
            guild_scene:create_scene(Guild#guild.gkey),
            {1, NewPlayer}
    end.
check_create_guild(Player, Name0, Type) ->
    Name = util:filter_utf8(Name0),
    BaseC = data_create_guild:get(Type),
    if
        Player#player.guild#st_guild.guild_key =/= 0 -> {false, 2};
        BaseC == [] -> {false, 0};
        true ->
            case guild_ets:get_guild_by_name(Name) of
                [_] -> {false, 8};
                [] ->
                    case guild_util:validate_name(len, Name) of
                        {false, Err} ->
                            {false, Err};
                        true ->
                            #base_create_guild{
                                need_lv = NeedLv,
                                gold = Gold,
                                bgold = BGold
                            } = BaseC,
                            IsEnough = money:is_enough(Player, Gold, gold),
                            IsEnough1 = money:is_enough(Player, Gold + BGold, bgold),
                            if
                                NeedLv > Player#player.lv -> {false, 12};
                                not IsEnough -> {false, 801};
                                not IsEnough1 -> {false, 801};
                                true ->
                                    {ok, Name, Gold, BGold}
                            end
                    end
            end
    end.

%%新的仙盟
make_new_guild(Player, Name, Now, Type) ->
    GuildKey = misc:unique_key(),
    Msg = io_lib:format(t_guild:log_msg(1), [Player#player.nickname]),
    Log = guild_log:add_log([], 1, util:unixtime(), Msg),
    Lv = ?IF_ELSE(Type == 1, 1, 2),
    Guild = #guild{
        gkey = GuildKey,
        name = Name,
        lv = Lv,
        realm = Player#player.realm,
        pkey = Player#player.key,
        pname = Player#player.nickname,
        pcareer = Player#player.career,
        pvip = Player#player.vip_lv,
        log = Log,
        notice = t_guild:notice(),
        condition = ?GUILD_DEFAULT_CONDITION,
        create_time = Now
    },
    guild_ets:set_guild(Guild),
    Guild.

%%新的仙盟成员
make_new_guild_member(Player, Guild, Position, _Now) ->
    Member0 = make_guild_member([
        Player#player.key,
        Player#player.pid,
        Guild#guild.gkey,
        Position,
        Player#player.nickname,
        Player#player.career,
        Player#player.sex,
        Player#player.lv,
        1,
        Player#player.cbp,
        Player#player.highest_cbp,
        Player#player.last_login_time,
        Player#player.avatar,
        Player#player.vip_lv
    ]),
    Member = guild_history:history_to_member(Member0),
    guild_ets:set_guild_member(Member),
    guild_cbp:update_guild_cbp(Guild#guild.gkey),
    guild_demon:update_guild_demon_pass(Guild#guild.gkey),
    player_join_guild(Member),
    Member.

make_apply_new_guild_member(Apply, Guild, Position, _Now) ->
    Member0 =
        case player_util:get_player(Apply#g_apply.pkey) of
            [] ->
                Player = shadow_proc:get_shadow(Apply#g_apply.pkey),
                make_guild_member([
                    Player#player.key,
                    none,
                    Guild#guild.gkey,
                    Position,
                    Player#player.nickname,
                    Player#player.career,
                    Player#player.sex,
                    Player#player.lv,
                    0,
                    Player#player.cbp,
                    Player#player.highest_cbp,
                    Player#player.last_login_time,
                    Player#player.avatar,
                    Player#player.vip_lv
                ]);
            Player ->
                Player#player.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, Position]},
                make_guild_member([
                    Player#player.key,
                    Player#player.pid,
                    Guild#guild.gkey,
                    Position,
                    Player#player.nickname,
                    Player#player.career,
                    Player#player.sex,
                    Player#player.lv,
                    1,
                    Player#player.cbp,
                    Player#player.highest_cbp,
                    Player#player.last_login_time,
                    Player#player.avatar,
                    Player#player.vip_lv
                ])
        end,
    Member = guild_history:history_to_member(Member0),
    guild_ets:set_guild_member(Member),
%%    guild_history:del_history(Apply#g_apply.pkey),
    guild_demon:update_guild_demon_pass(Member#g_member.gkey),
    player_join_guild(Member),
    Member.

make_guild_member([Pkey,Pid,Gkey,Position,Name,Career,Sex,Lv,IsOnline,Cbp,HightestCbp,LastloginTime,Avatar,VipLv]) ->
    Now = util:unixtime(),
    #g_member{
        pkey = Pkey,
        pid = Pid,
        gkey = Gkey,
        position = Position,
        name = Name,
        career = Career,
        sex = Sex,
        lv = Lv,
        is_online = IsOnline,
        cbp = Cbp,
        h_cbp = HightestCbp,
        last_login_time = LastloginTime,
        dedicate_time = Now,
        demon_update_time = Now,
        timestamp = Now,
        avatar = Avatar,
        vip = VipLv
    }.

%%仙盟解散
guild_dismiss(Player) ->
    CrossBossState = cross_area:apply_call(cross_boss, get_act_state, []),
    CrossWarState = cross_war:get_act_open_state(),
    if Player#player.guild#st_guild.guild_key == 0 -> 2;
        Player#player.guild#st_guild.guild_position /= 1 -> 21;
        CrossBossState == 1 -> 23;
        CrossWarState == ?CROSS_WAR_STATE_START -> 25;
        true ->
            dismiss(Player#player.guild#st_guild.guild_key, Player#player.guild#st_guild.guild_name, Player#player.key, Player#player.nickname, 2),
            cross_war_util:guild_dismiss(Player#player.guild#st_guild.guild_key),
            1
    end.

%%解散数据处理
dismiss(GuildKey, GuildName, Pkey, Pname, Type) ->
    guild_ets:del_guild(GuildKey),
    guild_load:del_guild(GuildKey),
    GuildMember = guild_ets:get_guild_member_list(GuildKey),
    guild_ets:del_guild_member_list(GuildKey),
    guild_load:del_guild_member(GuildKey),
    Now = util:unixtime(),
    F = fun(Member) ->
        if Member#g_member.is_online == 1 ->
            Member#g_member.pid ! {update_guild, [0, <<>>, 0]};
            true ->
                skip
        end,
        guild_history:update_history(Member, Now)
        end,
    lists:foreach(F, GuildMember),
    ?CAST(guild_war_proc:get_server_pid(), {del_apply, GuildKey}),
    guild_load:log_guild(GuildKey, GuildName, Pkey, Pname, Type, util:unixtime()),
    guild_manor:del_guild_manor(GuildKey),
    manor_war:del_guild(GuildKey),
    cross_war_util:guild_dismiss(GuildKey),
    guild_scene:stop_scene(GuildKey),
    ok.

%%玩家加入仙盟
player_join_guild(Member) ->
    Guild = guild_ets:get_guild(Member#g_member.gkey),
    notice_sys:add_notice(join_guild, [Member#g_member.name, Guild#guild.name]),
    Content = io_lib:format(?T("/e37//e37/欢迎~s加入,大家鼓掌！"), [Member#g_member.name]),
    Player = shadow_proc:get_shadow(Guild#guild.pkey),
    spawn(fun() -> timer:sleep(11000), chat:sys_send_to_guild(Player, Guild#guild.gkey, Content) end),
    ok.

%%玩家退出仙盟
player_quit_guild(Member) ->
    case guild_ets:get_guild(Member#g_member.gkey) of
        false ->
            ok;
        Guild ->
            Guild = guild_ets:get_guild(Member#g_member.gkey),
            notice_sys:add_notice(exit_guild, [Member#g_member.name, Guild#guild.name, Guild#guild.gkey]),
            ok
    end.