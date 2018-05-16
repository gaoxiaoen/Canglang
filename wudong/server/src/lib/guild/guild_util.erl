%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 13:49
%%%-------------------------------------------------------------------
-module(guild_util).
-author("hxming").

-include("guild.hrl").
-include("server.hrl").
-include("common.hrl").
-include("money.hrl").
-include("task.hrl").
-include("cross_war.hrl").
-include("kindom_guard.hrl").
-include("hot_well.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
-include("scene.hrl").
%% API
-compile(export_all).


-define(PAGE_NUM, 10).
-define(PAGE_NUM1, 9).

%%获取仙盟名称
get_guild_name(GuildKey) ->
    case guild_ets:get_guild(GuildKey) of
        false -> <<>>;
        Guild -> Guild#guild.name
    end.

%%根据玩家KEY获取仙盟名称
get_guild_name_key_by_pkey(Pkey) ->
    case guild_ets:get_guild_member(Pkey) of
        false -> {0, <<>>};
        Member ->
            {Member#g_member.gkey, get_guild_name(Member#g_member.gkey)}
    end.


%% 角色名合法性检测:长度
validate_name(len, Name) ->
    Len = util:char_len(xmerl_ucs:to_unicode(Name, 'utf-8')),
    case Len < 6 andalso Len > 0 of
        true ->
            validate_name(keyword, Name);
        false ->
            %%角色名称长度为2~6个汉字
            {false, 13}
    end;

%%判断是有敏感词
validate_name(keyword, Name) ->
    case util:check_keyword(Name) of
        true ->
            {false, 14};
        false ->
            true
    end.


%%获取仙盟信息
get_guild_info(Player) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    if GuildKey == 0 -> {false, 3};
        true ->
            case guild_ets:get_guild(GuildKey) of
                false ->
                    {false, 5};
                Guild ->
                    Base = data_guild:get(Guild#guild.lv),
                    MaxLv = data_guild:max_lv(),
                    NextLv = min(MaxLv, Guild#guild.lv + 1),
                    NextBase = data_guild:get(NextLv),
                    Rank = get_guild_rank(Guild),
                    #guild{
                        name = Name,
                        pname = Pname,
                        pvip = Pvip,
                        pkey = _GPkey,
                        lv = Lv,
                        num = Num,
                        dedicate = Dedicate,
                        notice = Notice,
                        last_hy_key = HyKey,
                        icon = GuildIcon,
                        last_hy_val = HyVal,
                        like_times = LikeTimes,
                        hy_gift_time = HyGiftTime
                    } = Guild,

                    IsGetGift = case Player#player.key == HyKey of
                                    false -> 0;
                                    true ->
                                        Now = util:unixtime(),
                                        case util:is_same_date(Now, HyGiftTime) of
                                            true -> 2;
                                            false -> 1
                                        end
                                end,

                    GiftId = ?GUILD_DAILY_HY_GIFT_ID,

                    HyPlayer =
                        case HyKey == Player#player.key of
                            true -> Player;
                            false ->
                                case player_util:get_player(HyKey) of
                                    [] -> shadow_proc:get_shadow(HyKey);
                                    Player1 -> Player1
                                end
                        end,

                    Lan = version:get_lan_config(),
                    GuildMedal = guild_fight:get_guild_medal(GuildKey),
                    {
                        1,
                        Name,
                        Pname,
                        Pvip,
                        Lv,
                        Num,
                        Base#base_guild.max_num,
                        Rank,
                        Dedicate,
                        NextBase#base_guild.dedicate,
                        ?IF_ELSE(Lan == korea, Notice, guild_util:get_guild_notice()),
                        HyPlayer#player.key,
                        HyPlayer#player.nickname,
                        HyPlayer#player.career,
                        HyPlayer#player.sex,
                        HyPlayer#player.wing_id,
                        HyPlayer#player.equip_figure#equip_figure.weapon_id,
                        HyPlayer#player.equip_figure#equip_figure.clothing_id,
                        HyPlayer#player.light_weaponid,
                        HyPlayer#player.fashion#fashion_figure.fashion_cloth_id,
                        HyPlayer#player.fashion#fashion_figure.fashion_head_id,
                        HyPlayer#player.vip_lv,

                        HyVal,
                        IsGetGift,
                        GiftId,
                        LikeTimes,
                        GuildMedal,
                        GuildIcon
                    }
            end
    end.

%%获取仙盟排名
get_guild_rank(Guild) ->
    Now = util:unixtime(),
    Res =
        case get({"my_guild_rank", Guild#guild.gkey}) of
            undefined -> not_found;
            {Rank, Time} ->
                case Now - Time > 100 of
                    true -> not_found;
                    false -> Rank
                end
        end,
    case Res of
        not_found ->
            MS = ets:fun2ms(fun(G) when G#guild.type /= ?GUILD_TYPE_SYS -> {G#guild.gkey, G#guild.cbp} end),
            All = ets:select(?ETS_GUILD, MS),
            List1 = lists:reverse(lists:keysort(2, All)),
            R =
                case lists:keyfind(Guild#guild.gkey, 1, List1) of
                    false -> 0;
                    Find -> util:get_list_elem_index(Find, List1)
                end,
            put({"my_guild_rank", Guild#guild.gkey}, {R, Now}),
            R;
        R -> R
    end.

%获取仙盟日志
get_guild_log(Player, Page) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    if GuildKey == 0 -> {0, 0, []};
        true ->
            case guild_ets:get_guild(GuildKey) of
                false ->
                    {0, 0, []};
                Guild ->
                    LogLen = length(Guild#guild.log),
                    MaxPage = LogLen div ?PAGE_NUM + 1,
                    if Page > MaxPage orelse Page < 0 -> {0, MaxPage, []};
                        true ->
                            NowPage = if Page == 0 -> 1;true -> Page end,
                            Log = lists:sublist(Guild#guild.log, NowPage * ?PAGE_NUM - ?PAGE_NUM1, ?PAGE_NUM),
                            NewLog = [[Time, Msg] || {_, Time, Msg} <- Log],
                            {NowPage, MaxPage, NewLog}
                    end
            end
    end.

%%仙盟每日改名
change_guild_name(Player, GuildName) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    if GuildKey == 0 -> {3, 0, Player};
        Player#player.guild#st_guild.guild_position >= ?GUILD_POSITION_ELDER -> {51, 0, Player};
        true ->
            case guild_ets:get_guild(GuildKey) of
                false -> {4, 0, Player};
                Guild ->
                    case guild_ets:get_guild_by_name(GuildName) of
                        [_] -> {8, 0, Player};
                        [] ->
                            case validate_name(len, GuildName) of
                                {false, Err} -> {Err, 0, Player};
                                true ->
                                    NowTime = util:unixtime(),
                                    Cd = 12 * 3600,
                                    case Guild#guild.cn_time + Cd < NowTime of
                                        false -> {52, Guild#guild.cn_time + Cd - NowTime, Player};
                                        true ->
                                            case money:is_enough(Player, ?GUILD_CHANGE_NAME_GOLD, bgold) of
                                                false -> {53, 0, Player};
                                                true ->
                                                    NewGuild = Guild#guild{name = GuildName, cn_time = NowTime},
                                                    guild_ets:set_guild(NewGuild),
                                                    guild_load:replace_guild(NewGuild),
                                                    update_guild_name_to_all(NewGuild),
                                                    NewPlayer = money:add_gold(Player, -?GUILD_CHANGE_NAME_GOLD, 6, 0, 0),
                                                    guild_load:log_guild_name(Guild#guild.gkey, Guild#guild.name, GuildName, Player#player.key, NowTime),
                                                    {1, 0, NewPlayer}
                                            end
                                    end
                            end
                    end
            end
    end.

%%改名卡改名
change_guild_name_use_goods(Player, GuildName) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    if GuildKey == 0 -> 3;
        Player#player.guild#st_guild.guild_position >= ?GUILD_POSITION_ELDER -> 51;
        true ->
            case guild_ets:get_guild(GuildKey) of
                false -> 4;
                Guild ->
                    Now = util:unixtime(),
                    if
                        Guild#guild.cn_time + ?ONE_DAY_SECONDS > Now -> 55;
                        true ->
                            case guild_ets:get_guild_by_name(GuildName) of
                                [_] -> 8;
                                [] ->
                                    case validate_name(len, GuildName) of
                                        {false, Err} -> Err;
                                        true ->
                                            GoodsId = 1026001,
                                            case goods_util:get_goods_count(GoodsId) > 0 of
                                                false -> 54;
                                                true ->
                                                    goods:subtract_good(Player, [{GoodsId, 1}], 93),
                                                    NewGuild = Guild#guild{name = GuildName, cn_time = Now},
                                                    guild_ets:set_guild(NewGuild),
                                                    guild_load:replace_guild(NewGuild),
                                                    update_guild_name_to_all(NewGuild),
                                                    guild_load:log_guild_name(Guild#guild.gkey, Guild#guild.name, GuildName, Player#player.key, util:unixtime()),
                                                    1
                                            end
                                    end
                            end
                    end
            end
    end.

%%更新场景仙盟成员仙盟名称
update_guild_name_to_all(Guild) ->
    MemberList = guild_ets:get_guild_member_list(Guild#guild.gkey),
    F = fun(Member) ->
        if Member#g_member.is_online /= 1 -> ok;
            true ->
                Member#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, Member#g_member.position]}
        end
        end,
    lists:foreach(F, MemberList),
    ok.

%%获取仙盟列表
get_guild_list(0, Pkey, Gkey, Page) ->
    GuildList = [G || G <- guild_ets:get_all_guild(), G#guild.type /= ?GUILD_TYPE_SYS],
    MaxPage = min(length(GuildList) div ?PAGE_NUM + 1, 50),

    NewGuildList = lists:reverse(lists:keysort(#guild.cbp, GuildList)),

    NowPage = if Page =< 0 -> 1;
                  Page >= MaxPage -> MaxPage;
                  true -> Page
              end,
    Rank = NowPage * ?PAGE_NUM - ?PAGE_NUM1,
    List =
        case NewGuildList of
            [] -> [];
            _ ->
                lists:sublist(NewGuildList, Rank, ?PAGE_NUM)
        end,
    F1 = fun(Guild, {L, R}) ->
        Data = pack_guild(Guild, Pkey, Gkey, 0, R),
        {[Data | L], R + 1}
         end,
    {Info, _} = lists:foldl(F1, {[], Rank}, List),
    {NowPage, MaxPage, lists:reverse(Info)};
get_guild_list(_1, Pkey, Gkey, Page) ->
    GuildList = guild_ets:get_all_guild(),
%%     GuildList =
%%         case GuildList1 of
%%             [] ->
%%                 [guild_sys:new_guild()];
%%             _ ->
%%                 GuildList1
%%         end,
%%     Len = length(GuildList),

    NewGuildList = lists:reverse(lists:keysort(#guild.cbp, GuildList)),

%%     List =
%%         if Len =< 3 ->
%%             SortGuildList;
%%             true ->
%%                 [G1, G2, G3 | T] = SortGuildList,
%%                 [G1, G2, G3] ++ match_guild(T)
%%         end,

    MaxPage = min(length(GuildList) div ?PAGE_NUM + 1, 50),
    NowPage = if Page =< 0 -> 1;
                  Page >= MaxPage -> MaxPage;
                  true -> Page
              end,
    Rank = NowPage * ?PAGE_NUM - ?PAGE_NUM1,
    List =
        case NewGuildList of
            [] -> [];
            _ ->
                lists:sublist(NewGuildList, Rank, ?PAGE_NUM)
        end,

    F1 = fun(Guild, {L, R}) ->
        Data = pack_guild(Guild, Pkey, Gkey, 1, R),
        {[Data | L], R + 1}
         end,
    {Info, _} = lists:foldl(F1, {[], 1}, List),
    {NowPage, MaxPage, lists:reverse(Info)}.

get_guild_rank_1() ->
    GuildList = guild_ets:get_all_guild(),
    NewGuildList = lists:reverse(lists:keysort(#guild.cbp, GuildList)),
    NewGuildList.

match_guild(GuildList) ->
    F = fun(G) ->
        JoinFree = case data_guild:get(G#guild.lv) of
                       [] -> 0;
                       Base ->
                           max(0, Base#base_guild.max_num - G#guild.num)
                   end,
        ApplyList = guild_ets:get_guild_apply_by_gkey(G#guild.gkey),
        ApplyFree = max(0, ?GUILD_APPLY_MAX - length(ApplyList)),
        if JoinFree > 0 andalso ApplyFree > 0 -> [G];
            true -> []
        end
        end,
    GList = lists:flatmap(F, GuildList),
    GList2 = lists:reverse(lists:keysort(#guild.cbp, GList)),
    lists:sublist(GList2, 7).

pack_guild(Guild, Pkey, Gkey, Type, Rank) ->
    Base = data_guild:get(Guild#guild.lv),
    IsApply =
        if Gkey /= 0 -> 2;
            true ->
                case guild_ets:get_guild_apply_one(Pkey, Guild#guild.gkey) of
                    false -> 0;
                    _ -> 1
                end
        end,
    StarList = [],
    {JoinType, Lv, Cbp} =
        case Guild#guild.condition of
            [] ->
                {0, 0, 0};
            _ ->
                list_to_tuple(Guild#guild.condition)
        end,
    [Rank, Guild#guild.gkey, Guild#guild.name, Guild#guild.realm, Guild#guild.pname, Guild#guild.pvip, Guild#guild.lv, Guild#guild.cbp, Guild#guild.num,
        Base#base_guild.max_num, Guild#guild.notice, IsApply, Type, JoinType, Lv, Cbp, Guild#guild.icon, StarList].

%%搜索仙盟
search_guild(Name, Player) ->
    GuildList = guild_ets:get_all_guild(),
    F = fun(Guild) ->
        case match_name(unicode:characters_to_list(Name), unicode:characters_to_list(Guild#guild.name)) of
            true -> [Guild];
            false -> []
        end
        end,
    NewGuildList = lists:flatmap(F, GuildList),
    F1 = fun(Guild, {L, R}) ->
        Data = pack_guild(Guild, Player#player.key, Player#player.guild#st_guild.guild_key, 0, R),
        {[Data | L], R + 1}
         end,
    {Info, _} = lists:foldl(F1, {[], 1}, NewGuildList),
    Info.


match_name([], _) -> false;
match_name([Head | Tail], Match) ->
    case string:chr(Match, Head) > 0 of
        true ->
            true;
        false ->
            match_name(Tail, Match)
    end.

%%获取仙盟成员列表
get_guild_member_list(_Player, Gkey) ->
    case guild_ets:get_guild(Gkey) of
        false -> [];
        _Guild ->
            MemberList = guild_ets:get_guild_member_list(Gkey),
            FriendList = relation:get_friend_list(),
            Now = util:unixtime(),
            F = fun(M) ->
                IsFriend =
                    case lists:member(M#g_member.pkey, FriendList) of
                        false -> 0;
                        true -> 1
                    end,
                LeaveTime =
                    case version:get_lan_config() of
                                korea -> max(0, abs(Now - M#g_member.last_login_time));
                                _ -> min(?ONE_DAY_SECONDS, abs(Now - M#g_member.last_login_time))
                    end,
                [
                    M#g_member.pkey,
                    M#g_member.name,
                    M#g_member.career,
                    M#g_member.sex,
                    M#g_member.position,
                    M#g_member.acc_dedicate,
                    M#g_member.lv,
                    M#g_member.cbp,
                    M#g_member.is_online,
                    LeaveTime,
                    M#g_member.vip,
                    M#g_member.ip,
                    IsFriend,
                    M#g_member.avatar
                ]
                end,
            lists:map(F, MemberList)
    end.

%%申请仙盟
%%ERR 1成功，2已经加入仙盟，3仙盟不存在，4阵营不符合,5已经申请该仙盟
guild_apply(Player, GuildKey, From) ->
    if Player#player.guild#st_guild.guild_key /= 0 -> {2, 0, Player};
        true ->
            case guild_ets:get_guild(GuildKey) of
                false -> {4, 0, Player};
                Guild ->
                    if Guild#guild.realm /= Player#player.realm -> {7, 0, Player};
                        true ->
                            ApplyList = guild_ets:get_guild_apply_by_gkey(GuildKey),
                            case length(ApplyList) >= ?GUILD_APPLY_MAX andalso Guild#guild.type /= ?GUILD_TYPE_SYS of
                                true ->
                                    {72, 0, Player};
                                false ->
                                    Now = util:unixtime(),
                                    case guild_history:check_quit_cd(Player#player.key, Now) of
                                        {true, Cd} ->
                                            {73, Cd, Player};
                                        false ->
                                            case lists:keymember(Player#player.key, #g_apply.pkey, ApplyList) of
                                                false ->
                                                    case check_apply_condition(Guild#guild.condition, Player) of
                                                        {err, Err} -> {Err, 0, Player};
                                                        apply ->
                                                            make_apply(Player, GuildKey, Now, From);
                                                        join ->
                                                            Base = data_guild:get(Guild#guild.lv),
                                                            if Guild#guild.num >= Base#base_guild.max_num ->
                                                                {104, 0, Player};
                                                                true ->
                                                                    auto_join(Player, Guild)
                                                            end
                                                    end;
                                                true ->
                                                    {71, 0, Player}
                                            end
                                    end
                            end
                    end
            end
    end.

make_apply(Player, GuildKey, Now, From) ->
    Key = misc:unique_key(),
    Apply = #g_apply{
        akey = Key,
        pkey = Player#player.key,
        gkey = GuildKey,
        nickname = Player#player.nickname,
        career = Player#player.career,
        lv = Player#player.lv,
        cbp = Player#player.cbp,
        from = From,
        timestamp = Now
    },
    guild_ets:set_guild_apply(Apply),
    guild_load:insert_guild_apply(Apply),
    guild_apply_notice(GuildKey),
    {1, 0, Player}.

guild_apply_notice(GuildKey) ->
    Guild = guild_ets:get_guild(GuildKey),
    if
        Guild == false -> skip;
        Guild#guild.pkey == 0 -> skip;
        true ->
            ApplyList = guild_ets:get_guild_apply_by_gkey(GuildKey),
            if
                ApplyList == [] -> skip;
                true ->
                    case player_util:get_player_online(Guild#guild.pkey) of
                        [] -> skip;
                        _Online ->
                            {ok, Bin} = pt_400:write(40016, {}),
                            server_send:send_to_key(Guild#guild.pkey, Bin),
                            ok
                    end
            end
    end.

auto_join(Player, Guild) ->
    guild_ets:del_guild_apply_by_pkey(Player#player.key),
    guild_load:del_guild_apply_by_pkey(Player#player.key),
    Msg = io_lib:format(t_guild:log_msg(2), [Player#player.nickname]),
    Log = guild_log:add_log(Guild#guild.log, 2, util:unixtime(), Msg),
    Now = util:unixtime(),
    NewGuild = Guild#guild{num = Guild#guild.num + 1, log = Log},
    guild_ets:set_guild(NewGuild),
    _Member = guild_create:make_new_guild_member(Player, Guild, ?GUILD_POSITION_NORMAL, Now),
    guild_load:log_guild_mb(Guild#guild.gkey, Guild#guild.name, Player#player.key, Player#player.nickname, 1, util:unixtime(), ?GUILD_POSITION_NORMAL, ?GUILD_POSITION_NORMAL),
    {Title, Content} = t_mail:mail_content(23),
    mail:sys_send_mail([Player#player.key], Title, io_lib:format(Content, [Guild#guild.name])),
    guild_skill:load_player_guild_skill(Player#player.lv, Guild#guild.gkey),
    StGuild = #st_guild{guild_key = Guild#guild.gkey, guild_name = Guild#guild.name, guild_position = ?GUILD_POSITION_NORMAL},
    Player1 = Player#player{guild = StGuild},
    NewPlayer = player_util:count_player_attribute(Player1, true),
    {77, 0, NewPlayer}.

%%检查入会条件
check_apply_condition(Condition, Player) ->
    case Condition of
        [] ->
            apply;
        [0, _, _] ->
            apply;
        [1, Lv, Cbp] ->
            if Player#player.lv < Lv -> {err, 74};
                Player#player.cbp < Cbp -> {err, 75};
                true ->
                    join
            end;
        _ -> {err, 76}
    end.

%%检查仙盟申请状态
check_guild_apply_state(Player) ->
    if Player#player.guild#st_guild.guild_key /= 0 andalso Player#player.guild#st_guild.guild_position =< 2 ->
        case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
            false -> 0;
            Guild ->
                Base = data_guild:get(Guild#guild.lv),
                if Guild#guild.num >= Base#base_guild.max_num -> 0;
                    true ->
                        case length(guild_ets:get_guild_apply_by_gkey(Player#player.guild#st_guild.guild_key)) > 0 of
                            true -> 1;
                            false -> 0
                        end

                end
        end;
        true -> 0
    end.

%%升级自动加入仙盟
%% upgrade_auto_apply(Player) when Player#player.lv == 33 ->
%%     {Ret, _Cd, NewPlayer} = auto_apply(Player),
%%     if Ret == 77 ->
%%         scene_agent_dispatch:guild_update(NewPlayer);
%%         true -> ok
%%     end,
%%     NewPlayer;
upgrade_auto_apply(Player) -> Player.


%%系统自动申请仙盟
auto_apply(Player) ->
    if Player#player.guild#st_guild.guild_key /= 0 -> {2, 0, Player};
        true ->
            Now = util:unixtime(),
            case guild_history:check_quit_cd(Player#player.key, Now) of
                {true, Cd} -> {73, Cd, Player};
                false ->
                    GuildList = guild_ets:get_all_guild(),
                    %%过滤符合条件的可立即加入的仙盟
                    F = fun(Guild, {JList, AList}) ->
                        Base = data_guild:get(Guild#guild.lv),
                        if Guild#guild.num >= Base#base_guild.max_num -> {JList, AList};
                            Guild#guild.type == ?GUILD_TYPE_SYS -> {JList, AList};
                            true ->
                                case check_apply_condition(Guild#guild.condition, Player) of
                                    join ->
                                        {[Guild | JList], AList};
                                    apply ->
                                        GuildApplyList = guild_ets:get_guild_apply_by_gkey(Guild#guild.gkey),
                                        case ?GUILD_APPLY_MAX >= length(GuildApplyList) of
                                            true ->
                                                {JList, AList};
                                            false ->
                                                case lists:keyfind(Player#player.key, #g_apply.pkey, GuildApplyList) of
                                                    false ->
                                                        {JList, [Guild | AList]};
                                                    _ ->
                                                        {JList, AList}
                                                end
                                        end;
                                    _ -> {JList, AList}
                                end
                        end
                        end,
                    {JoinList, ApplyList} = lists:foldl(F, {[], []}, GuildList),
                    case JoinList of
                        [] ->
                            %%可申请的仙盟
                            ApplyList1 = util:get_random_list(ApplyList, 5),
                            F1 = fun(Guild) ->
                                make_apply(Player, Guild#guild.gkey, Now, 1)
                                 end,
                            lists:foreach(F1, ApplyList1),
                            {804, 0, Player};
                        GList ->
                            Guild = lists:last(lists:keysort(#guild.cbp, GList)),
                            auto_join(Player, Guild)
                    end
            end
    end.

%%获取入会条件
%%TYPE 0需审核,1条件入会,2拒绝
get_apply_condition(Player) ->
    case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
        false -> {0, 0, 0};
        Guild ->
            case Guild#guild.condition of
                [Type, Lv, Cbp] ->
                    {Type, Lv, Cbp};
                _ -> {0, 0, 0}
            end
    end.

%%设置入会条件
set_apply_condition(Player, Type, Lv, Cbp) ->
    case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
        false -> 3;
        Guild ->
            if Player#player.guild#st_guild.guild_position > ?GUILD_POSITION_VICE_CHAIRMAN -> 18;
                true ->
                    NewGuild = Guild#guild{condition = [Type, Lv, Cbp]},
                    guild_ets:set_guild(NewGuild),
                    1
            end
    end.

%%获取仙盟申请列表
guild_apply_list(Player, Page) ->
    List =
        case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
            false -> [];
            Guild ->
                if Guild#guild.type == ?GUILD_TYPE_SYS ->
                    [];
                    true ->
                        guild_ets:get_guild_apply_by_gkey(Player#player.guild#st_guild.guild_key)
                end
        end,

    MaxPage = length(List) div ?PAGE_NUM + 1,
    NowPage = if Page =< 0 orelse Page >= MaxPage -> 1;true -> Page end,
    NewList = lists:sublist(List, NowPage * ?PAGE_NUM - ?PAGE_NUM1, ?PAGE_NUM),
    F = fun(Apply) ->
        [Apply#g_apply.pkey, Apply#g_apply.nickname, Apply#g_apply.vip, Apply#g_apply.career, Apply#g_apply.lv, Apply#g_apply.cbp]
        end,
    {Page, MaxPage, lists:map(F, NewList)}.

%%仙盟审批
guild_approval(Player, Pkey, Result) ->
    if
        Player#player.guild#st_guild.guild_position > ?GUILD_POSITION_ELDER -> 101;
        true ->
            case guild_ets:get_guild_apply_one(Pkey, Player#player.guild#st_guild.guild_key) of
                false -> 102;
                Apply ->
                    case Result of
                        0 ->
                            guild_ets:del_guild_apply(Apply#g_apply.akey),
                            guild_load:del_guild_apply(Apply#g_apply.akey),
                            {Title, Content} = t_mail:mail_content(70),
                            mail:sys_send_mail([Apply#g_apply.pkey], Title, io_lib:format(Content, [Player#player.guild#st_guild.guild_name])),
                            1;
                        1 ->
                            case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
                                false -> 4;
                                Guild ->
                                    Base = data_guild:get(Guild#guild.lv),
                                    if Guild#guild.num >= Base#base_guild.max_num -> 104;
                                        true ->
                                            case guild_ets:get_guild_member(Apply#g_apply.pkey) of
                                                false ->
                                                    guild_ets:del_guild_apply_by_pkey(Apply#g_apply.pkey),
                                                    guild_load:del_guild_apply_by_pkey(Apply#g_apply.pkey),
                                                    Msg = io_lib:format(t_guild:log_msg(2), [Apply#g_apply.nickname]),
                                                    Log = guild_log:add_log(Guild#guild.log, 2, util:unixtime(), Msg),
                                                    Now = util:unixtime(),
                                                    NewGuild = Guild#guild{num = Guild#guild.num + 1, log = Log},
                                                    guild_ets:set_guild(NewGuild),
                                                    _Member = guild_create:make_apply_new_guild_member(Apply, Guild, ?GUILD_POSITION_NORMAL, Now),
                                                    guild_load:log_guild_mb(Guild#guild.gkey, Guild#guild.name, Pkey, Apply#g_apply.nickname, 1, util:unixtime(), ?GUILD_POSITION_NORMAL, ?GUILD_POSITION_NORMAL),
                                                    {Title, Content} = t_mail:mail_content(23),
                                                    mail:sys_send_mail([Pkey], Title, io_lib:format(Content, [Guild#guild.name])),
                                                    1;
                                                _ ->
                                                    guild_ets:del_guild_apply(Apply#g_apply.akey),
                                                    guild_load:del_guild_apply(Apply#g_apply.akey),
                                                    105
                                            end
                                    end
                            end;
                        _ -> 103
                    end
            end
    end.


%%退出工会
%%ERR 1成功，2没有加入工会，3会长不能退出工会，4工会不存在，5工会成员不存在
guild_quit(Player) ->
    case check_guild_quit(Player) of
        {false, Res} -> {Res, Player};
        {ok, Guild, Member} ->
            Msg = io_lib:format(t_guild:log_msg(3), [Player#player.nickname]),
            Log = guild_log:add_log(Guild#guild.log, 3, util:unixtime(), Msg),
            Num = max(0, Guild#guild.num - 1),
            case Num == 0 of
                true ->
                    guild_create:dismiss(Guild#guild.gkey, Guild#guild.name, Player#player.key, Player#player.nickname, 2),
                    {1, Player};
                false ->
                    NewGuild = Guild#guild{num = Num, log = Log},
                    guild_ets:set_guild(NewGuild),
                    guild_ets:del_guild_member(Player#player.key),
                    guild_load:del_guild_member_by_pkey(Player#player.key),
                    Player1 = Player#player{guild = #st_guild{}},
                    NewPlayer = player_util:count_player_attribute(Player1, true),
                    guild_load:log_guild_mb(Guild#guild.gkey, Guild#guild.name, Player#player.key, Player#player.nickname, 2, util:unixtime(), Member#g_member.position, Member#g_member.position),
                    guild_history:update_history(Member, util:unixtime()),
                    guild_demon:update_guild_demon_pass(Member#g_member.gkey),
                    task_guild:quit_guild(Player1),
                    guild_create:player_quit_guild(Member),
                    cross_war_util:guild_quit(Guild#guild.gkey, Player#player.key),
                    guild_load:replace_guild(NewGuild),
                    guild_scene:quit_guild_scene(Player),
                    NewPlayer#player.pid ! cacl_attr_guild_fight,
                    {1, NewPlayer}
            end
    end.
check_guild_quit(Player) ->
    CrossBossState = cross_area:apply_call(cross_boss, get_act_state, []),
    CrossWarState = cross_war:get_act_open_state(),
    OpenDay = config:get_open_days(),
    ActLimitOpenDay = data_cross_war_time:get_limit_open_day(),
    if
        Player#player.lv >= 70 andalso CrossBossState == 1 -> {false, 22};
        Player#player.guild#st_guild.guild_key == 0 -> {false, 3};
        OpenDay > ActLimitOpenDay andalso CrossWarState == ?CROSS_WAR_STATE_START -> {false, 24};
        true ->
            case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
                false -> {false, 4};
                Guild ->
                    if
                        Player#player.guild#st_guild.guild_position == ?GUILD_POSITION_CHAIRMAN andalso Guild#guild.num > 1 ->
                            {false, 111};
                        true ->
                            case guild_ets:get_guild_member(Player#player.key) of
                                false -> {false, 5};
                                Member ->
                                    {ok, Guild, Member}
                            end
                    end
            end
    end.

%%开除仙盟成员
guild_kickout(Player, Pkey) ->
    case guild_ets:get_guild_member(Pkey) of
        false -> 5;
        Member ->
            CrossWarState = cross_war:get_act_open_state(),
            OpenDay = config:get_open_days(),
            ActLimitOpenDay = data_cross_war_time:get_limit_open_day(),
            if
                OpenDay > ActLimitOpenDay andalso CrossWarState == ?CROSS_WAR_STATE_START -> {false, 26};
                Player#player.guild#st_guild.guild_key /= Member#g_member.gkey -> 121;
                Player#player.guild#st_guild.guild_position >= Member#g_member.position -> 122;
                true ->
                    case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
                        false -> 4;
                        Guild ->
                            Msg = io_lib:format(t_guild:log_msg(4), [Member#g_member.name]),
                            Log = guild_log:add_log(Guild#guild.log, 4, util:unixtime(), Msg),
                            Num = max(0, Guild#guild.num - 1),
                            NewGuild = Guild#guild{num = Num, log = Log},
                            guild_ets:set_guild(NewGuild),
                            guild_ets:del_guild_member(Pkey),
                            guild_load:del_guild_member_by_pkey(Pkey),
                            if Member#g_member.is_online == 1 ->
                                Member#g_member.pid ! {update_guild, [0, <<>>, 0]};
                                true ->
                                    skip
                            end,
                            guild_load:log_guild_mb(Guild#guild.gkey, Guild#guild.name, Pkey, Member#g_member.name, 3, util:unixtime(), Member#g_member.position, Member#g_member.position),
                            guild_history:update_history(Member, util:unixtime()),
                            guild_demon:update_guild_demon_pass(Member#g_member.gkey),
                            {Title, Content} = t_mail:mail_content(24),
                            mail:sys_send_mail([Pkey], Title, io_lib:format(Content, [Guild#guild.name])),
                            guild_create:player_quit_guild(Member),
                            cross_war_util:guild_quit(Guild#guild.gkey, Pkey),
                            guild_load:replace_guild(NewGuild),
                            1
                    end
            end
    end.


%%修改公告
change_notice(Player, Notice0) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    Position = Player#player.guild#st_guild.guild_position,
    Notice = util:filter_utf8(Notice0),
    if GuildKey == 0 -> 3;
        Position /= ?GUILD_POSITION_CHAIRMAN andalso Position /= ?GUILD_POSITION_VICE_CHAIRMAN -> 151;
        true ->
            case validate_name(keyword, Notice) of
                {false, _} ->
                    152;
                true ->
                    case guild_ets:get_guild(GuildKey) of
                        false -> 4;
                        Guild ->
                            Now = util:unixtime(),
                            if Guild#guild.notice_cd > Now ->
                                153;
                                true ->
                                    Msg = io_lib:format(t_guild:log_msg(5), [Player#player.nickname, Notice]),
                                    Log = guild_log:add_log(Guild#guild.log, 5, util:unixtime(), Msg),
                                    NewGuild = Guild#guild{notice = Notice, log = Log, notice_cd = Now + 120},
                                    guild_ets:set_guild(NewGuild),
%%                                    guild_load:replace_guild(NewGuild),
                                    1
                            end
                    end

            end
    end.

%%修改公告
change_name(Player, GuildName0) ->
    GuildKey = Player#player.guild#st_guild.guild_key,
    Position = Player#player.guild#st_guild.guild_position,
    GuildName = util:filter_utf8(GuildName0),
    if
        GuildKey == 0 -> 3;
        Position /= ?GUILD_POSITION_CHAIRMAN andalso Position /= ?GUILD_POSITION_VICE_CHAIRMAN -> 154;
        true ->
            case validate_name(keyword, GuildName) of
                {false, _} ->
                    155;
                true ->
                    case guild_ets:get_guild(GuildKey) of
                        false -> 4;
                        Guild ->
                            NewGuild = Guild#guild{name = GuildName},
                            guild_ets:set_guild(NewGuild),
%%                            MemberList = guild_util:get_guild_member_list(Player, GuildKey),
                            ok
%%                            F = fun(#g_member{pid = Pid}) ->
%%                                ok
%%%%                                 player:apply_state(async, Pid, {?MODULE, change_guild_name()})
%%                            end,
%%                            lists:map(F, MemberList)
                    end
            end
    end.

reward_key(PKey, Id) ->
    io_lib:format("~s_~p", [PKey, Id]).


%%获取在线的仙盟成员PIDs
get_guild_member_pids_online(Gkey) ->
    case guild_ets:get_guild_member_list(Gkey) of
        [] -> [];
        MbList ->
            [Mb#g_member.pid || Mb <- MbList, Mb#g_member.is_online == 1]
    end.

get_guild_member_key_list(Gkey) ->
    case guild_ets:get_guild_member_list(Gkey) of
        [] -> [];
        MbList ->
            [Mb#g_member.pkey || Mb <- MbList]
    end.

get_guild_top_n_list(N) ->
    GuildList = [Guild || Guild <- guild_ets:get_all_guild(), Guild#guild.type == ?GUILD_TYPE_NORMAL],
    NewGuildList = lists:reverse(lists:keysort(#guild.cbp, GuildList)),
    lists:sublist(NewGuildList, N).


%%获取仙盟名称，会长名称
get_name(GKey) ->
    case guild_ets:get_guild(GKey) of
        false ->
            {<<>>, <<>>};
        Guild ->
            {Guild#guild.name, Guild#guild.pname}
    end.

reset_guild_war_data(GKey) ->
    MemberList = guild_ets:get_guild_member_list(GKey),
    F = fun(Mb) ->
        NewMb = Mb#g_member{war_p = 0},
        guild_ets:set_guild_member(NewMb)
        end,
    lists:foreach(F, MemberList).


get_member_info_list(Gkey) ->
    case guild_ets:get_guild_member_list(Gkey) of
        [] -> [];
        MbList ->
            [{Mb#g_member.pkey, Mb#g_member.name, Mb#g_member.career, Mb#g_member.sex, Mb#g_member.vip, Mb#g_member.lv, Mb#g_member.cbp, Mb#g_member.avatar} || Mb <- MbList, Mb#g_member.is_online == 1]
    end.

get_guild_lv(Gkey) ->
    case guild_ets:get_guild(Gkey) of
        false -> 0;
        Guild ->
            Guild#guild.lv
    end.

%%仙盟长、成员改名
change_guild_pname(Player, NewName) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    if
        Gkey /= 0 ->
            case guild_ets:get_guild_member(Player#player.key) of
                false -> skip;
                Mb ->
                    NewMb = Mb#g_member{name = NewName},
                    guild_ets:set_guild_member(NewMb)
            end;
        true -> skip
    end,
    case guild_ets:get_guild(Gkey) of
        false -> <<>>;
        Guild ->
            case Guild#guild.pkey == Player#player.key of
                true ->
                    NewGuild = Guild#guild{pname = NewName},
                    guild_ets:set_guild(NewGuild),
                    Sql1 = io_lib:format("update guild set pname = '~s' where gkey = ~p", [NewName, Gkey]),
                    db:execute(Sql1);
                false ->
                    skip
            end
    end.

%%仙盟成员变性
change_guild_psex(Player, NewSex) ->
    Gkey = Player#player.guild#st_guild.guild_key,
    if
        Gkey /= 0 ->
            case guild_ets:get_guild_member(Player#player.key) of
                false -> skip;
                Mb ->
                    NewMb = Mb#g_member{sex = NewSex},
                    guild_ets:set_guild_member(NewMb)
            end;
        true -> skip
    end.

%%发起弹劾
start_impeach(Player) ->
    if
        Player#player.guild#st_guild.guild_key == 0 -> {3, <<>>, Player};
        true ->
            case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
                false -> {4, <<>>, Player};
                Guild ->
                    MyMember = guild_ets:get_guild_member(Player#player.key),
                    if
                        MyMember == false -> {4, <<>>, Player};
                        Guild#guild.pkey == Player#player.key -> {251, <<>>, Player};
                        Guild#guild.type /= 0 -> {253, <<>>, Player};
                        true ->
                            Now = util:unixtime(),
                            case guild_ets:get_guild_member(Guild#guild.pkey) of
                                false ->
                                    case money:is_enough(Player, ?GUILD_IMPEACH_PRICE, gold) of
                                        false -> {256, <<>>, Player};
                                        true ->
                                            do_impeach(Guild, Player, Now)
                                    end;
                                Member ->
                                    DiffTime = Now - Member#g_member.last_login_time,
                                    case DiffTime >= 3 * ?ONE_DAY_SECONDS of
                                        false ->
                                            {254, <<>>, Player};
                                        true ->
                                            case money:is_enough(Player, ?GUILD_IMPEACH_PRICE, gold) of
                                                false -> {256, <<>>, Player};
                                                true ->
                                                    do_impeach(Guild, Player, Now)
                                            end
                                    end
                            end
                    end
            end
    end.

do_impeach(Guild, Player, Now) ->
    %%更换帮主
    MyMember = guild_ets:get_guild_member(Player#player.key),
    NewMyMember = MyMember#g_member{position = ?GUILD_POSITION_CHAIRMAN},
    guild_ets:set_guild_member(NewMyMember),
    if
        NewMyMember#g_member.is_online == 1 ->
            NewMyMember#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_CHAIRMAN]};
        true -> ok
    end,
    case guild_ets:get_guild_member(Guild#guild.pkey) of
        false -> skip;
        Mb ->
            NewMb = Mb#g_member{position = ?GUILD_POSITION_NORMAL},
            guild_ets:set_guild_member(NewMb),
            {Title, Content} = t_mail:mail_content(57),
            NewContent = io_lib:format(Content, [MyMember#g_member.name]),
            mail:sys_send_mail([Mb#g_member.pkey], Title, NewContent),
            if NewMb#g_member.is_online == 1 ->
                Mb#g_member.pid ! {update_guild, [Guild#guild.gkey, Guild#guild.name, ?GUILD_POSITION_NORMAL]};
                true ->
                    ok
            end
    end,
    Msg = io_lib:format(t_guild:log_msg(11), [MyMember#g_member.name]),
    Log = guild_log:add_log(Guild#guild.log, 11, Now, Msg),
    NewGuild = Guild#guild{log = Log, pkey = MyMember#g_member.pkey, pname = MyMember#g_member.name, pcareer = MyMember#g_member.career},
    guild_ets:set_guild(NewGuild),

    NewPlayer = money:add_no_bind_gold(Player, -?GUILD_IMPEACH_PRICE, 183, 0, 0),
    {Title1, Content1} = t_mail:mail_content(55),
    NewContent1 = io_lib:format(Content1, [Player#player.nickname]),
    mail:sys_send_mail([Guild#guild.pkey], Title1, NewContent1),
    chat:sys_send_to_guild(Player, MyMember#g_member.gkey, io_lib:format(?T("~s玩家成功弹劾，当选为新任掌门！"), [Player#player.nickname])),
    {1, <<>>, NewPlayer}.


cmd_set_login(Player) ->
    case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
        false -> skip;
        Guild ->
            case guild_ets:get_guild_member(Guild#guild.pkey) of
                false -> skip;
                Mb ->
                    NewMb = Mb#g_member{is_online = 0, last_login_time = Mb#g_member.last_login_time - ?ONE_DAY_SECONDS * 10},
                    guild_ets:set_guild_member(NewMb)
            end
    end.


%%修改职业
career(Pkey, Gkey, Career) ->
    case guild_ets:get_guild_member(Pkey) of
        false -> ok;
        Mb ->
            NewMb = Mb#g_member{career = Career},
            guild_ets:set_guild_member_new(NewMb)
    end,
    case guild_ets:get_guild(Gkey) of
        false -> ok;
        Guild ->
            if Guild#guild.pkey == Pkey ->
                NewGuild = Guild#guild{pcareer = Career},
                guild_ets:set_guild(NewGuild);
                true -> ok
            end
    end,
    ok.


%%修改头像
update_avatar(Pkey, Avatar) ->
    case guild_ets:get_guild_member(Pkey) of
        false -> ok;
        Mb ->
            NewMb = Mb#g_member{avatar = Avatar},
            guild_ets:set_guild_member_new(NewMb)
    end,
    ok.


%%获取仙盟成员--跨服副本
get_member_for_dun_cross(Gkey, Pkey, Lv) ->
    case guild_ets:get_guild_member_list(Gkey) of
        [] -> [];
        MbList ->
            [[Mb#g_member.pkey, Mb#g_member.name, Mb#g_member.lv, Mb#g_member.cbp] || Mb <- MbList, Mb#g_member.is_online == 1, Mb#g_member.lv >= Lv, Mb#g_member.pkey /= Pkey]
    end.

%%获取仙盟成员--野外组队
get_member_for_team(Gkey, Lv) ->
    case guild_ets:get_guild_member_list(Gkey) of
        [] -> [];
        MbList ->
            F = fun(Mb) ->
                case ets:lookup(?ETS_ONLINE, Mb#g_member.pkey) of
                    [] -> [];
                    _ ->
                        ?IF_ELSE(Mb#g_member.lv >= Lv, [Mb#g_member.pkey], [])
                end
                end,
            lists:flatmap(F, MbList)
    end.

%%更新玩家帮派成员信息
change_mb_attr(Pkey, AttrList) ->
    case guild_ets:get_guild_member(Pkey) of
        false -> ok;
        Mb ->
            case guild_ets:get_guild(Mb#g_member.gkey) of
                false -> ok;
                Guild ->
                    {NewMb, NewGuild} = change_mb_attr_1(Mb, Guild, AttrList),
                    guild_ets:set_guild_member_new(NewMb),
                    case NewGuild =/= Guild of
                        true -> guild_ets:set_guild(NewGuild);
                        false -> ok
                    end
            end
    end.
change_mb_attr_1(Mb, Guild, []) -> {Mb, Guild};
change_mb_attr_1(Mb, Guild, [{K, V} | Tail]) ->
    {NewMb, NewGuild} =
        case K of
            vip ->
                {Mb#g_member{vip = V}, ?IF_ELSE(Guild#guild.pkey == Mb#g_member.pkey, Guild#guild{pvip = V}, Guild)};
            _ -> {Mb, Guild}
        end,
    change_mb_attr_1(NewMb, NewGuild, Tail).

re_set_notice(Gkey) ->
    case guild_ets:get_guild(Gkey) of
        false -> 4;
        Guild ->
            Now = util:unixtime(),
            NewGuild = Guild#guild{notice = ?T("欢迎大家加入仙盟，文明游戏，快乐竞技！"), notice_cd = Now + 120},
            guild_ets:set_guild(NewGuild),
            1
    end.

re_set_guild_name(Gkey) ->
    case guild_ets:get_guild(Gkey) of
        false -> 4;
        Guild ->
            NewGuild = Guild#guild{name  = ?T("仙盟")},
            guild_ets:set_guild(NewGuild),
            1
    end.

get_guild_notice() ->
    Now = util:unixtime(),
    F = fun(Id, Str) ->
        case get_open_time(Id, Now) of
            false -> Str;
            {H, M} ->
                Content0 = data_guild_notice:get(Id),
                if
                    M == 0 ->
                        Str1 = io_lib:format("~p:00", [H]);
                    true -> Str1 =
                        Str1 = io_lib:format("~p:~p", [H, M])
                end,
                Content = io_lib:format(Content0, [Str1]),
                Str ++ Content
        end
        end,
    List = lists:foldl(F, "", data_guild_notice:get_all()),
    if
        List == [] -> ?T("快乐游戏，共建美好仙盟！请勿相信任何非官方的充值、广告信息。");
        true -> List
    end.



get_guild_notice_help(Now, Id) ->
    case Id of
        1 -> hot_well:get_open_time(Now); %% 温泉
        2 -> convoy_proc:get_open_time(Now); %% 双倍护送
        3 -> answer:get_open_time(Now); %% 答题
        4 -> cross_six_dragon:get_open_time(Now); %% 六龙争霸
        5 -> grace_proc:get_open_time(Now); %% 神谕恩泽(王城夺宝)
        6 -> kindom_guard:get_open_time(Now); %% 王城守卫
        7 -> guild_war_proc:get_open_time(Now); %% 领地战(领土争霸)
        8 -> cross_war_proc:get_open_time(Now); %% 跨服攻城
        9 -> cross_battlefield_proc:get_open_time(Now); %% 巅峰塔(跨服战场)
        10 -> cross_elite_proc:get_open_time(Now); %% 跨服竞技(跨服1v1)
        11 -> cross_boss_proc:get_open_time(Now); %% 世界首领(跨服首领)
        _ -> false
    end.


get_open_time(Id, Now) ->
    StartList = start_time_list(Id, Now),
    NowSec = util:get_seconds_from_midnight(Now),
    F = fun({H, M}, Flag) ->
        Start = H * 3600 + M * 60,
        Ready = Start - 1800,
        if
            NowSec < Ready ->
                Flag;
            NowSec < Start ->
                {H, M};
            true ->
                Flag
        end
        end,


    case lists:foldl(F, false, StartList) of
        false -> false;
        Other -> Other
    end.

%% 1 温泉
start_time_list(1, _Now) ->
    ?HOT_WELL_OPEN_TIME;

%% 2 双倍护送
start_time_list(2, _Now) ->
    F = fun(Id) ->
        Base = data_convoy_time:get(Id),
        [{S, E}, _] = Base#base_convoy_time.time,
        {S, E}
        end,
    lists:map(F, data_convoy_time:ids());

%% 3 答题
start_time_list(3, Now) ->
    WeekDay = util:get_day_of_week(Now),
    OpenList = data_question_open_time:get(),
    case lists:keyfind(WeekDay, 1, OpenList) of
        false -> [];
        {_, {H1, M1}, _Long, _NoticeTime} ->
            [{H1, M1}]
    end;

%% 4 六龙争霸
start_time_list(4, Now) ->
    WeekDay = util:get_day_of_week(Now),
    OpenList = data_six_dragon_time:get_all(),
    case lists:keyfind(WeekDay, 1, OpenList) of
        false -> [];
        {_, {H1, M1}, _Long, _NoticeTime} ->
            [{H1, M1}]
    end;

%% 5 神谕恩泽(王城夺宝)
start_time_list(5, _Now) ->
    F = fun(Id) ->
        Base = data_grace_time:get(Id),
        [{S, E}, _] = Base,
        {S, E}
        end,
    lists:map(F, data_grace_time:ids());

%% 6 王城守卫
start_time_list(6, Now) ->
    WeekDay = util:get_day_of_week(Now),
    case lists:keyfind(WeekDay, 1, ?OPEN_TIME_LIST) of
        false -> [];
        {_, {H1, M1}} ->
            [{H1, M1}]
    end;

%% 7 领地战(领土争霸)
start_time_list(7, Now) ->
    Week = util:get_day_of_week(Now),
    F = fun(Id) ->
        {WeekList, TimeList} = data_guild_war_time:get(Id),
        case lists:member(Week, WeekList) of
            false -> [];
            true ->
                [{H, M}, _] = TimeList,
                [{H, M}]
        end
        end,
    lists:flatmap(F, data_guild_war_time:ids());

%% 8 王城守卫
start_time_list(8, Now) ->
    OpenDay = config:get_open_days(),
    LimitDay = data_cross_war_time:get_limit_open_day(),
    if
        OpenDay < LimitDay -> [];
        true ->
            Week = util:get_day_of_week(Now),
            F = fun(Id) ->
                {WeekList, TimeList} = data_cross_war_time:get(Id),
                case lists:member(Week, WeekList) of
                    false -> [];
                    true ->
                        [{SH, SM}, _] = TimeList,
                        [{SH, SM}]
                end
                end,
            lists:flatmap(F, data_cross_war_time:ids())
    end;

%% 9  巅峰塔(跨服战场)
start_time_list(9, Now) ->
    Week = util:get_day_of_week(Now),
    F = fun(Id) ->
        {WeekList, TimeList} = data_cross_battlefield_time:get(Id),
        case lists:member(Week, WeekList) of
            false -> [];
            true ->
                [{H, M}, _] = TimeList,
                [{H, M}]
        end
        end,
    lists:flatmap(F, data_cross_battlefield_time:ids());

%% 10  跨服竞技(跨服1v1)
start_time_list(10, _Now) ->
    TimeList = data_cross_elite_time:open_time(),
    [{H, M}, _] = TimeList,
    [{H, M}];

%% 11 世界首领(跨服首领)
start_time_list(11, Now) ->
    Week = util:get_day_of_week(Now),
    F = fun(Id) ->
        {WeekList, TimeList} = data_cross_boss_time:get(Id),
        case lists:member(Week, WeekList) of
            false -> [];
            true ->
                F0 = fun({{SH, SM}, _}) ->
                    [{SH, SM}]
                     end,
                lists:flatmap(F0, TimeList)
        end
        end,
    lists:flatmap(F, data_cross_boss_time:ids());

start_time_list(_, _) -> [].
