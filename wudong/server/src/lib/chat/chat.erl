%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 一月 2015 下午3:57
%%%-------------------------------------------------------------------
-module(chat).
-author("fancy").

-include("common.hrl").
-include("server.hrl").
-include("daily.hrl").
-include("chat.hrl").
-include("player_mask.hrl").
-include("guild.hrl").

%% 协议接口
-export([
    chat/7,
    send_scene_face/2,
    shaizi/2,
    guild_sincere_word/1
]).
%%内部接口
-export([
    init_lim/1,
    init_lim_sp/1,
    set_lim/2,
    set_lim_sp/2,
    set_player_lim/2,
    set_player_lim_sp/2,
    send_to_kf/1,
    kf2public/1,
    logout/1,
    sys_send_to_public/2,
    sys_send_to_guild/3,
    check_content/1,
    refresh_res/0,
    send_to_cross_war/2,
    cross_war2public/2,
    send_to_cross_war_team/4,
    cross_war_team2public/4
]).
%%工具接口
-export([
    limit_digit_num/3,
    check_digit/1,
    check_special/3,
    check_send_content/2,
    get_player_chat_info/1,
    pack_chat_data/4,
    pack_chat_data/5
]).
-define(CHAT_TYPE_NOTICE, 10).

-define(LAST_CHAT_TIME, last_chat_time).
-define(CHAT_CD, 6).

%%聊天
%%GM
chat(Player, _Type, [First | TailContent], _Voice, _Pkey, _Name, _IsLog) when First == 64 ->
    case config:is_debug() of
        true ->
            ContentList = string:tokens(TailContent, "_"),
            case catch chat_gm:gm(Player, ContentList) of
                {ok, NewPlayer} ->
                    {ok, NewPlayer};
                {ok, RetType, NewPlayer} ->
                    {ok, RetType, NewPlayer};
                ok -> ok;
                Error ->
                    ?ERR("gm_error:~p~n", [Error]),
                    ok
            end;
        _ ->
            ok
    end;
chat(Player, Type, Content, Voice, Pkey, Name, IsLog) ->
%%    Content = util:filter_spec_chat(Content1),
    case Type of
        ?CHAT_TYPE_TEAM -> chat2team(Player, Content, Voice); %%队伍聊天
        ?CHAT_TYPE_GUILD -> chat2guild(Player, Content, Voice); %%帮派聊天
        ?CHAT_TYPE_FRIEND -> chat2friend(Player, Content, Voice, Pkey, Name, IsLog);  %%私聊
        ?CHAT_TYPE_KF -> chat2kf(Player, Content, Voice); %%跨服聊天
        ?CHAT_TYPE_WAR_TEAM -> chat2war_team(Player, Content, Voice); %%战队聊天
        ?CHAT_TYPE_SCENE ->%%场景
            chat2scene(Player, Content, Voice);
        ?CHAT_TYPE_SCENE_GROUP ->%%场景分组
            chat2scene_group(Player, Content, Voice);
        ?CHAT_TYPE_CROSS_WAR_DEF ->
            chat2cross_war(Player, Content, Voice, ?CHAT_TYPE_CROSS_WAR_DEF); %%跨服攻城会议聊天
        ?CHAT_TYPE_CROSS_WAR_ATT ->
            chat2cross_war(Player, Content, Voice, ?CHAT_TYPE_CROSS_WAR_ATT); %%跨服攻城会议聊天
        _ -> chat2public(Player, Content, Voice)  %%世界聊天
    end.

%%  世界聊天
chat2public(Player, Content, Voice) when Player#player.pf == 888 ->
    %%过滤掉链接
    Type = ?CHAT_TYPE_PUBLIC,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        EndLimTime > Now -> {false, 4};
        LimSpEndTime > Now ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            put_last_chat_time(Type, Now),
            server_send:send_to_all(Bin),
            chat_proc:log_chat(Type, Data, [Player#player.key, Player#player.nickname, Now, Content]),
            self() ! {d_v_trigger, 12, 1},
            ok
    end;

chat2public(Player, Content, Voice) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    Type = ?CHAT_TYPE_PUBLIC,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    {LvLimit, VipLvLimit} = data_version_different:get(2),
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        EndLimTime > Now -> {false, 4};
        Player#player.vip_lv < VipLvLimit -> {false, 15};
        Player#player.lv < LvLimit -> {false, 6};
        LimSpEndTime > Now ->
            Data0 = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin0} = pt_110:write(11000, {Data0}),
            server_send:send_to_sid(Player#player.sid, Bin0),
            ok;
        true ->
            Data0 = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin0} = pt_110:write(11000, {Data0}),
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                true ->
                    Content1 = xmerl_ucs:to_unicode(Content, 'utf-8'), %%utf8转unicode
                    SendContent = filter_content(ReplaceContent, Content1),
                    SendContent1 = unicode:characters_to_binary(SendContent),
%%                    case SendContent1 == <<>> of
%%                        true ->
%%                            ok;
%%                        false ->
                    Data1 = pack_chat_data(Player, Type, SendContent1, Voice),
                    {ok, Bin} = pt_110:write(11000, {Data1}),
                    put_last_chat_time(Type, Now),
                    server_send:send_to_all(Bin),
                    chat_proc:log_chat(Type, Data1, [Player#player.key, Player#player.nickname, Now, SendContent1]),
                    self() ! {d_v_trigger, 12, 1},
                    spawn(fun() ->
                        log_chat(Player#player.key, Player#player.nickname, Player#player.lv, Player#player.vip_lv, Type, Content, Now, 0, "", 0, 0) end),
                    case update_scene_face(Player, Content) of
                        {new, NewPlayer} ->
                            {ok, scene_face, NewPlayer};
                        NewPlayer ->
                            {ok, NewPlayer}
%%                            end
                    end;
                false ->
                    server_send:send_to_sid(Player#player.sid, Bin0),
                    ok
            end
    end.

%% 跨服攻城战会议聊天
chat2cross_war(Player, Content, Voice, Type) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    IsCrossWar = cross_area:war_apply_call(cross_war, judge_sign, [Player#player.guild#st_guild.guild_key]),
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        EndLimTime > Now -> {false, 4};
        IsCrossWar == 0 -> {false, 14};
        LimSpEndTime > 0 ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                false ->
                    case util:check_keyword(ReplaceContent) of %%屏蔽字
                        true ->
                            lim_send_chat(Player, Type, Content, Voice);
                        false ->
                            {ok, Bin} = pt_110:write(11000, {Data}),
                            server_send:send_to_sid(Player#player.sid, Bin)
                    end;
                true ->
                    cross_area:war_apply(?MODULE, send_to_cross_war, [Data, Type])
            end,
            put_last_chat_time(Type, Now)
    end.

%%攻城战聊天发送
send_to_cross_war(Data, Type) ->
    [center:apply(Node, chat, cross_war2public, [Data, Type]) || Node <- center:get_nodes()],
    ok.

cross_war2public(Data, Type) ->
    chat_proc:log_chat(Type, Data, []),
    {ok, Bin} = pt_110:write(11000, {Data}),
    server_send:send_to_all(Bin),
    ok.

%%仙盟聊天
chat2guild(Player, Content, Voice) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    Type = ?CHAT_TYPE_GUILD,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    GuildKey = Player#player.guild#st_guild.guild_key,
    LimSpEndTime = get_lim_state(),
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        GuildKey == 0 -> {false, 3};
        LimSpEndTime > Now ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            Content1 = xmerl_ucs:to_unicode(Content, 'utf-8'), %%utf8转unicode
            SendContent = filter_content(ReplaceContent, Content1),
            SendContent1 = unicode:characters_to_binary(SendContent),
            Data = pack_chat_data(Player, Type, SendContent1, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                false ->
                    ?DEBUG("false ~n"),
                    server_send:send_to_sid(Player#player.sid, Bin);
                true ->
                    case util:check_keyword(ReplaceContent) of %%屏蔽字
                        true ->
                            lim_send_chat(Player, Type, Content, Voice);
                        false ->
                            MbList = guild_ets:get_guild_member_list(GuildKey),
                            F = fun(Mb) ->
                                if Mb#g_member.is_online /= 1 -> skip;
                                    true ->
                                        case relation:is_my_black(Mb#g_member.pkey) of
                                            true ->
                                                skip;
                                            false ->
                                                Mb#g_member.pid ! {guild_chat,Player#player.key,Bin}
%%                                                server_send:send_to_pid(Mb#g_member.pid, Bin)
                                        end
                                end
                                end,
                            lists:foreach(F, MbList),
                            self() ! {d_v_trigger, 12, 1},
                            spawn(fun() ->
                                log_chat(Player#player.key, Player#player.nickname, Player#player.lv, Player#player.vip_lv, Type, Content, Now, 0, "", 0, 0) end),
                            chat_proc:log_chat(Type, Data, GuildKey)
                    end
            end,
            put_last_chat_time(Type, Now),
            ok
    end.

%%跨服聊天
chat2kf(Player, Content, Voice) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    Type = ?CHAT_TYPE_KF,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    Cost = 5,
%%    Lv = 80,
    IsEnough = money:is_enough(Player, Cost, bgold),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    KfLim = lists:member(Player#player.sn_cur, lim_chat_kf()),
    if
        KfLim -> {false, 0};
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        not IsEnough -> {false, 5};
%%        Player#player.lv < Lv -> {false, 6};
        EndLimTime > Now -> {false, 4};
        LimSpEndTime > Now ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            server_send:send_to_sid(Player#player.sid, Bin), ok;
        true ->
            Content1 = xmerl_ucs:to_unicode(Content, 'utf-8'), %%utf8转unicode
            SendContent = filter_content(ReplaceContent, Content1),
            SendContent1 = unicode:characters_to_binary(SendContent),
            Data = pack_chat_data(Player, Type, SendContent1, Voice),
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                false ->
                    case util:check_keyword(ReplaceContent) of %%屏蔽字
                        true ->
                            lim_send_chat(Player, Type, Content, Voice),
                            NewPlayer = Player;
                        false ->
                            NewPlayer = Player,
                            {ok, Bin} = pt_110:write(11000, {Data}),
                            server_send:send_to_sid(Player#player.sid, Bin)
                    end;
                true ->
                    NewPlayer = money:add_gold(Player, -Cost, 47, 0, 0),
                    cross_area:apply(chat, send_to_kf, [Data])
            end,
            put_last_chat_time(Type, Now),
            {ok, NewPlayer}
    end.
%%跨服聊天发送
send_to_kf(Data) ->
    [center:apply(Node, chat, kf2public, [Data]) || Node <- center:get_nodes()],
    ok.

kf2public(Data) ->
    case lists:member(config:get_server_num(), lim_chat_kf()) of
        true -> skip;
        false ->
            chat_proc:log_chat(?CHAT_TYPE_KF, Data, []),
            {ok, Bin} = pt_110:write(11000, {Data}),
            server_send:send_to_all(Bin)
    end.


lim_chat_kf() ->
    [8003].

%%战队聊天
chat2war_team(Player, Content, Voice) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    Type = ?CHAT_TYPE_WAR_TEAM,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        EndLimTime > Now -> {false, 4};
        LimSpEndTime > 0 ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                false ->
                    case util:check_keyword(ReplaceContent) of %%屏蔽字
                        true ->
                            lim_send_chat(Player, Type, Content, Voice);
                        false ->
                            {ok, Bin} = pt_110:write(11000, {Data}),
                            server_send:send_to_sid(Player#player.sid, Bin)
                    end;
                true ->
                    cross_all:apply(?MODULE, send_to_cross_war_team, [Data, Type, Player#player.war_team#st_war_team.war_team_key, node()]),
                    chat_proc:log_chat(Type, Data, Player#player.war_team#st_war_team.war_team_key)
            end,
            put_last_chat_time(Type, Now),
            ok
    end.

%%战队聊天发送
send_to_cross_war_team(Data, Type, WarTeamKey, Node) ->
    KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(WarTeamKey),
    center:apply(Node, chat, cross_war_team2public, [Data, Type, WarTeamKey, KeyList]),
    ok.

cross_war_team2public(Data, Type, WarTeamKey, KeyList) ->
    chat_proc:log_chat(Type, Data, [WarTeamKey]),
    {ok, Bin} = pt_110:write(11000, {Data}),
    F = fun(Pkey) ->
        server_send:send_to_key(Pkey, Bin)
        end,
    lists:map(F, KeyList),
    ok.

%%队伍聊天
chat2team(Player, Content, Voice) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    Type = ?CHAT_TYPE_TEAM,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        EndLimTime > Now -> {false, 4};
        Player#player.team_key == 0 -> {false, 7};
        LimSpEndTime > Now ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            server_send:send_to_pid(Player#player.pid, Bin),
            ok;
        true ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                true ->
                    case util:check_keyword(ReplaceContent) of %%屏蔽字
                        true ->
                            lim_send_chat(Player, Type, Content, Voice);
                        false ->
                            put_last_chat_time(Type, Now),
                            [server_send:send_to_pid(Pid, Bin) || Pid <- team_util:get_team_mb_pids(Player#player.team_key)],
                            chat_proc:log_chat(Type, Data, [Player#player.team_key])
                    end;
                false ->
                    server_send:send_to_sid(Player#player.sid, Bin)
            end,
            ok
    end.

%%私聊
chat2friend(Player, Content, Voice, Pkey0, Name, IsLog) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    Type = ?CHAT_TYPE_FRIEND,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    IsMyBlack = relation:is_my_black(Pkey0),  %% 判断对方是否在自己屏蔽名单中
    IsHisBlack = relation:is_his_black(Player#player.key, Pkey0), %% 判断自己是否在对方屏蔽名单中
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        Player#player.lv < 27 -> {false, 6};
        EndLimTime > Now -> {false, 4};
        Pkey0 == Player#player.key -> {false, 11};
        IsMyBlack -> {false, 12};    %% 对方在您的屏蔽名单中
        IsHisBlack -> {false, 13};  %% 您在对方屏蔽名单中
        true ->
            %%查找私聊玩家
            Pkey =
                case Pkey0 =/= 0 of
                    true -> Pkey0;
                    false ->
                        case player_load:dbget_name_key(Name) of
                            [] -> false;
                            [Key, _Sn, _Pf] -> Key
                        end
                end,
            Data = pack_chat_data(Player, Type, Content, Voice),
            ToPlayer = shadow_proc:get_shadow(Pkey),
            {ok, Bin} = pt_110:write(11003, {Player#player.key, Pkey, ToPlayer#player.nickname, ToPlayer#player.avatar, ToPlayer#player.sex, ToPlayer#player.vip_lv, ToPlayer#player.career, Data}), %% 新增对方性别
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                true ->
                    if
                        Pkey == false -> {false, 8};
                        LimSpEndTime > Now ->
                            server_send:send_to_sid(Player#player.sid, Bin),
                            ok;
                        true ->
                            case util:check_keyword(ReplaceContent) of %% 屏蔽字
%%                             case false of
                                true ->
                                    server_send:send_to_sid(Player#player.sid, Bin),
                                    ok;
%%                                    {false, 10};
                                false ->

                                    relation:put_recently_contacts(ToPlayer),

                                    %% 将自己添加进对方最近联系人
                                    case player_util:get_player_pid(ToPlayer#player.key) of
                                        false -> skip;
                                        TargetPid ->
                                            TargetPid ! {put_recently_contacts, [Player]}
                                    end,


                                    MyChatFir = #fri_chat{
                                        mykey = Player#player.key,
                                        pkey = Pkey,
                                        name = ToPlayer#player.nickname,
                                        avatar = ToPlayer#player.avatar,
                                        psex = ToPlayer#player.sex, %% 新增性别
                                        vip = ToPlayer#player.vip_lv,
                                        career = ToPlayer#player.career,
                                        chat_list = [Data]
                                    },
                                    ToChatFir =
                                        #fri_chat{
                                            mykey = Pkey,
                                            pkey = Player#player.key,
                                            name = Player#player.nickname,
                                            avatar = Player#player.avatar,
                                            psex = ToPlayer#player.sex, %% 新增性别
                                            vip = Player#player.vip_lv,
                                            career = Player#player.career,
                                            chat_list = [Data]
                                        },
                                    if
                                        IsLog == 1 -> spawn(fun() ->
                                            log_chat(Player#player.key, Player#player.nickname, Player#player.lv, Player#player.vip_lv, Type, Content, Now, Pkey, ToPlayer#player.nickname, ToPlayer#player.lv, ToPlayer#player.vip_lv) end);
                                        true -> skip
                                    end,
                                    case player_util:get_player_online(Pkey) of
                                        [] ->  %%不在线，保存离线记录
                                            server_send:send_to_sid(Player#player.sid, Bin),
                                            chat_proc:log_chat(Type, Data, [MyChatFir, ToChatFir]),
                                            {false, 8};
                                        Online ->
                                            #ets_online{
                                                sid = Sid
                                            } = Online,
                                            put_last_chat_time(Type, Now),
                                            server_send:send_to_sid(Sid, Bin),
                                            server_send:send_to_sid(Player#player.sid, Bin),
                                            chat_proc:log_chat(Type, Data, [MyChatFir, ToChatFir]),
                                            ok
                                    end
                            end
                    end;
                false ->
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok
%%                    {false, 10}
            end
    end.

chat2scene(Player, Content, Voice) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    Type = ?CHAT_TYPE_SCENE,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        EndLimTime > Now -> {false, 4};
        true ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                true ->
                    if
                        LimSpEndTime > 0 ->
                            server_send:send_to_sid(Player#player.sid, Bin);
                        true ->
                            case util:check_keyword(ReplaceContent) of %%屏蔽字
                                true ->
                                    lim_send_chat(Player, Type, Content, Voice);
                                false ->
                                    put_last_chat_time(Type, Now),
                                    server_send:send_to_scene(Player#player.scene, Player#player.copy, Bin)
                            end
                    end;
                false ->
                    server_send:send_to_sid(Player#player.sid, Bin)
            end,
            ok
    end.
chat2scene_group(Player, Content, Voice) ->
    %%过滤掉链接
    ReplaceContent = replace_link_content(Content),
    Type = ?CHAT_TYPE_SCENE_GROUP,
    ChatTime = last_chat_time(Type),
    Now = util:unixtime(),
    EndLimTime = get_lim_time(),
    LimSpEndTime = get_lim_state(),
    if
        Now - ChatTime < ?CHAT_CD -> {false, 2};
        EndLimTime > Now -> {false, 4};
        true ->
            Data = pack_chat_data(Player, Type, Content, Voice),
            {ok, Bin} = pt_110:write(11000, {Data}),
            case check_send_content(Player#player.vip_lv, ReplaceContent) of
                true ->
                    if
                        LimSpEndTime > Now ->
                            server_send:send_to_sid(Player#player.sid, Bin);
                        true ->
                            case util:check_keyword(ReplaceContent) of %%屏蔽字
                                true ->
                                    lim_send_chat(Player, Type, Content, Voice);
                                false ->
                                    put_last_chat_time(Type, Now),
                                    server_send:send_to_scene_group(Player#player.scene, Player#player.copy, Player#player.group, Bin)
                            end
                    end;
                false ->
                    server_send:send_to_sid(Player#player.sid, Bin)
            end,
            ok
    end.


%%发送场景表情
send_scene_face(Player, FaceStr) ->
    case update_scene_face(Player, FaceStr) of
        {new, NewPlayer} ->
            {ok, NewPlayer};
        NewPlayer ->
            {ok, NewPlayer}
    end.

%%敏感词发言
lim_send_chat(Player, Type, Content, Voice) ->
    ReplaceContent = replace_link_content(Content),
    Content1 = xmerl_ucs:to_unicode(Content, 'utf-8'), %%utf8转unicode
    SendContent = filter_content(ReplaceContent, Content1),
    SendContent1 = unicode:characters_to_binary(SendContent),
    Data = pack_chat_data(Player, Type, SendContent1, Voice),
    {ok, Bin} = pt_110:write(11000, {Data}),
%%     Data1 = pack_chat_data(Player, Type, "*********", ""),
%%     {ok, Bin1} = pt_110:write(11000, {Data1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%打包聊天信息
pack_chat_data(Player, Type, Content, Voice) ->
    pack_chat_data(Player, Type, Content, Voice, 0).
pack_chat_data(Player, Type, Content, Voice, IsBugle) ->
    [Key, Name, GM, _Title, Vip, Career, Avatar, Dvip] = get_player_chat_info(Player),
    Now = util:unixtime(),
    Sn = config:get_server_num(),
    [Type, Sn, Key, Name, Avatar, GM, Player#player.fashion#fashion_figure.fashion_bubble_id, Vip, Now, Career, min(100, Player#player.lv), Player#player.cbp,
        Content, Voice, IsBugle, Player#player.sex, Player#player.fashion#fashion_figure.fashion_decoration_id, Player#player.guild#st_guild.guild_position, Player#player.guild#st_guild.guild_name, Dvip].

%%获取聊天所需的玩家信息
get_player_chat_info(Player) ->
    #player{
        key = Key,
        nickname = Name,
        design = DesList,
        career = Career,
        vip_lv = Vip,
        gm = GM,
        avatar = Avatar,
        d_vip = #dvip{vip_type = Dvip}
    } = Player,
    Title = ?IF_ELSE(DesList == [], 0, hd(DesList)),
    [Key, Name, GM, Title, Vip, Career, Avatar, Dvip].

%%禁言初始化
%%玩家进程
init_lim(_Player) ->
    LimEndTime = daily:get_count(?DAILY_CHAT_LIM),
    put(lim_chat_end_time, LimEndTime),
    ok.

%%禁言初始化
%%玩家进程
init_lim_sp(_Player) ->
    LimState = player_mask:get(?PLAYER_CHAT_LIM_STATE, 0),
    if
        LimState == 1 ->
            put(lim_chat_state, util:unixtime() + ?ONE_DAY_SECONDS),
            save_lim_sp(_Player); %% 旧数据兼容
        true ->
            put(lim_chat_state, LimState)
    end,
    ok.

%%禁言保存
%%玩家进程
save_lim(_Player) ->
    case get(lim_chat_end_time) of
        undefined -> ok;
        Time ->
            daily:set_count(?DAILY_CHAT_LIM, Time),
            ok
    end.
%%禁言保存
%%玩家进程
save_lim_sp(_Player) ->
    case get(lim_chat_state) of
        undefined -> ok;
        Time ->
            player_mask:set(?PLAYER_CHAT_LIM_STATE, Time),
            ok
    end.

%%设置禁言
set_lim(Pkey, Time) ->
    ?DEBUG("lim_chat ~p/~p~n", [Pkey, Time]),
    Now = util:unixtime(),
    LimEndTime = round(Now + Time * 3600),
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> ok;
        [Online | _] ->
            case is_pid(Online#ets_online.pid) of
                true ->
                    Online#ets_online.pid ! {apply_state, {chat, set_player_lim, LimEndTime}};
                false ->
                    ok
            end
    end.

%%设置禁言
set_lim_sp(Pkey, State) ->
    Now = util:unixtime(),
    case State of
        1 -> LimEndTime = round(Now + ?ONE_DAY_SECONDS);    %% 一天
        2 -> LimEndTime = round(Now + 2 * ?ONE_DAY_SECONDS); %% 两天
        3 -> LimEndTime = round(Now + 365 * ?ONE_DAY_SECONDS); %% 永久
        0 -> LimEndTime = 0; %% 解除
        _ ->
            ?ERR("set_lim_sp State :~p~n", [State]),
            LimEndTime = round(Now + ?ONE_DAY_SECONDS)
    end,
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> ok;
        [Online | _] ->
            case is_pid(Online#ets_online.pid) of
                true ->
                    Online#ets_online.pid ! {apply_state, {chat, set_player_lim_sp, LimEndTime}};
                false ->
                    ok
            end
    end.


%%设置禁言
%%玩家进程
set_player_lim(LimEndTime, Player) ->
    put(lim_chat_end_time, LimEndTime),
    save_lim(Player),
    ok.

%%设置特殊禁言
%%玩家进程
set_player_lim_sp(Time, Player) ->
    put(lim_chat_state, Time),
    save_lim_sp(Player),
    ok.

%%获取禁言时间
get_lim_time() ->
    case get(lim_chat_end_time) of
        undefined -> 0;
        LimEndTime -> LimEndTime
    end.
%%获取特殊禁言时间
get_lim_state() ->
    case get(lim_chat_state) of
        undefined -> 0;
        LimSpEndTime -> LimSpEndTime
    end.

%%先替换掉超链接内容
replace_link_content(Content0) ->
    {Content, _FaceNum, _FaceList} = replace_face(Content0), %% 过滤表情
    %%先检查头部
    case string:str(Content, "[#$a") of
        0 -> Content;
        SIndex ->
            case string:str(Content, "]") of
                0 -> Content;
                EIndex when is_integer(EIndex), EIndex > SIndex ->
                    Head = string:sub_string(Content, SIndex, EIndex),
                    case string:str(Head, "type") > 0 andalso string:str(Head, "color") > 0 of
                        true ->
                            Left = string:sub_string(Content, 1, SIndex - 1),
                            Right = string:sub_string(Content, EIndex + 1),
                            NewContent = string:concat(Left, Right),
                            %%检查尾部
                            case string:str(NewContent, "[#$/a]") of
                                0 -> Content;
                                TailIndex ->
                                    TailLeft = string:sub_string(NewContent, 1, TailIndex - 1),
                                    TailRight = string:sub_string(NewContent, TailIndex + 6),
                                    NewContent1 = string:concat(TailLeft, TailRight),
                                    replace_link_content(NewContent1)
                            end;
                        false ->
                            Content
                    end;
                _ -> Content
            end
    end.

%%检查广告等
check_send_content(VipLv, Content0) ->
    {Content, FaceNum, _FaceList} = replace_face(Content0),
    case FaceNum >= 5 of %%表情过去
        true ->
            false;
        false ->
            case Content == "" of
                true -> true;  %%纯表情
                false ->
                    case catch unicode:characters_to_list(Content) of
                        {ok, Content1} -> ok;
                        _ -> Content1 = Content
                    end,
                    case check_special(Content1, 0, 6) of
                        false ->
                            case check_same_content(Content, 3) of
                                false -> true;
                                true -> false
                            end;
                        true -> %%特殊字符过多
                            Lan = version:get_lan_config(),
                            if
                                Lan == bt andalso VipLv > 5 -> true;
                                VipLv > 0 -> true;
                                true -> false
                            end
                    end
            end
    end.

%%数字 判断
check_digit(Content) ->
    limit_digit_num(Content, 0, 5).

limit_digit_num([], _DigitNum, _LimNum) -> false;
limit_digit_num([Char, Char2 | Tail], DigitNum, LimNum) when Char == 47 andalso Char2 == 101 -> %%表情过滤
    case Tail of
        [] -> limit_digit_num([], DigitNum, LimNum);
        [_Num] -> limit_digit_num(Tail, DigitNum, LimNum);
        [Num, 47 | Tail1] ->
            case Num >= 49 andalso Num =< 57 of
                true -> limit_digit_num(Tail1, DigitNum, LimNum);
                false -> limit_digit_num(Tail, DigitNum, LimNum)
            end;
        [Num1, Num2, 47 | Tail1] ->
            case Num1 >= 49 andalso Num1 =< 50 andalso Num2 >= 49 andalso Num2 =< 53 of
                true -> limit_digit_num(Tail1, DigitNum, LimNum);
                false -> limit_digit_num(Tail, DigitNum, LimNum)
            end;
        _ ->
            limit_digit_num(Tail, DigitNum, LimNum)
    end;
limit_digit_num([Char | Tail], DigitNum, LimNum) ->
    case Char >= 48 andalso Char =< 57 of
        true ->
            case DigitNum + 1 >= LimNum of
                true -> true;
                false ->
                    limit_digit_num(Tail, DigitNum + 1, LimNum)
            end;
        false -> limit_digit_num(Tail, DigitNum, LimNum)
    end.

%%检查是否含有特殊字符
check_special(String0, Times, LimTimes) ->
    String = xmerl_ucs:to_unicode(String0, 'utf-8'), %%utf8转unicode
    SpecText = special_text(),
    check_special_helper(String, Times, LimTimes, SpecText).

check_special_helper([], _Times, _LimTimes, _SpecText) -> false;
check_special_helper([Head | Tail], Times, LimTimes, SpecText) ->
    case string:chr(SpecText, Head) > 0 of
        true ->
            case Times + 1 >= LimTimes of
                true ->
                    true;
                false ->
                    check_special_helper(Tail, Times + 1, LimTimes, SpecText)
            end;
        false ->
            check_special_helper(Tail, Times, LimTimes, SpecText)
    end.
%%特殊字符
special_text() ->
    case get("special_text") of
        undefined ->
            Str = "1234567890△▽○◇□☆▷◁♤♡♢♧☼☺☏•▲▼●◆■★▶◀♠♥♦♣☀☻☎*☉⊙⊕Θ◎❤¤✪の⊿☜☞▁▂▃▅▆▇█▉▊▋▌▍▎▏⊱⋛⋌⋚⊰⊹⌒☌☍☋╱▁╲↖↑↗®©¢℡™ª㈱▬〓≡▏㊣▕←↔→▧▤▨▥▩▥▨▤▧▦╲▔╱↙↓↘卍♀※&◤◥♩♪♫♬€§¶†¬卐♂∷№@◣◢♭♯$Ψ¥∮‖‡￢▫◈▣◑◕░▒▓☑☒Ω☢☣☭❂☪➹☃☂❦❧✎✄Ю✟۩＊✲❈❉✿❀❃❁ღஐ☠♨۞♈♉♊♋♌♍♎♏♐♐♑♒♓♒♍①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑴⑵⑶⑷⑸⑺⑺⑻⑼⑽⑾⑿⒀⒁⒂⒃⒈⒉⒊⒋⒌⒎⒎⒏⒐⒑⒒⒓⒔⒕⒖⒗ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫⅰⅱⅲⅳⅴⅵⅷⅷⅸⅹ❶❷❸❹❺❻❼❽❾❿㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩零壹贰叁肆伍陆柒捌玖拾佰仟-一二三四五六七八九１２３４５６７８９０bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
            StrList = unicode:characters_to_list(Str),
            put("special_text", StrList),
            StrList;
        StrList ->
            StrList
    end.

%%检查相同的聊天记录数
check_same_content(Content, LimTimes) ->
    HistoryList =
        case get(chat_record_content) of
            undefined -> [];
            ContentList -> ContentList
        end,
    SameTimes = count_num(HistoryList, Content, 0),
    put(chat_record_content, lists:sublist([Content | HistoryList], 1, 10)),
    case SameTimes >= LimTimes of
        false -> check_same_content_1(Content) >= 3;
        true -> true
    end.

%% 统计聊天内容出现次数
count_num([], _Content, Num) -> Num;
count_num([H | T], Content, Num) ->
    case H =:= Content of
        true -> count_num(T, Content, Num + 1);
        false -> count_num(T, Content, Num)
    end.

%% 统计聊天
check_same_content_1(Content) ->
    String = xmerl_ucs:to_unicode(Content, 'utf-8'), %%utf8转unicode
    HistoryList =
        case get(chat_record_content) of
            undefined -> [];
            ContentList -> ContentList
        end,
    case length(String) =< 3 of
        true ->
            0;
        false ->
            check_same_content_1(HistoryList, String, 0)
    end.
check_same_content_1([], _String, Count) -> Count;
check_same_content_1([History | Tail], String, Count) ->
    String1 = xmerl_ucs:to_unicode(History, 'utf-8'), %%utf8转unicode
    F = fun(Char, AccCount) ->
        case string:chr(String1, Char) > 0 of
            true ->
                AccCount + 1;
            false ->
                AccCount
        end
        end,
    SameCount = lists:foldl(F, 0, String),
    case SameCount >= round(length(String) * 0.7) of
        true -> check_same_content_1(Tail, String, Count + 1);
        false -> check_same_content_1(Tail, String, Count)
    end.

%%最后聊天时间
last_chat_time(Type) ->
    case get({?LAST_CHAT_TIME, Type}) of
        undefined -> 0;
        Time -> Time
    end.
put_last_chat_time(Type, Time) ->
    put({?LAST_CHAT_TIME, Type}, Time).

logout(Player) ->
    chat_proc:del_friend_chat_log(Player#player.key, Player#player.lv).

%%过滤表情
replace_face(Content) ->
    FaceList = get_face_list(),
    {NewContent, FaceNum, UseFaceList} = replace_face_1(FaceList, Content, 0, []),
    {NewContent, FaceNum, UseFaceList}.
replace_face_1([], Content, FaceNum, FaceList) -> {Content, FaceNum, lists:reverse(FaceList)};
replace_face_1([Face | Tail], Content, FaceNum, FaceList) ->
    case string:str(Content, Face) of
        0 -> replace_face_1(Tail, Content, FaceNum, FaceList);
        SIndex ->
            Left = string:sub_string(Content, 1, SIndex - 1),
            Right = string:sub_string(Content, SIndex + length(Face)),
            NewContent = string:concat(Left, Right),
            replace_face_1([Face | Tail], NewContent, FaceNum + 1, [Face | FaceList])
    end.

get_face_list() ->
    [
        "/e1/", "/e2/", "/e3/",
        "/e4/", "/e5/", "/e6/",
        "/e7/", "/e1/", "/e1/",
        "/e10/", "/e11/", "/e12/",
        "/e13/", "/e14/", "/e15/",
        "/e16/", "/e17/", "/e18/",
        "/e19/", "/e20/", "/e21/",
        "/e22/", "/e23/", "/e24/",
        "/e25/", "/e26/", "/e27/",
        "/e28/", "/e29/", "/e30/",
        "/e31/", "/e32/", "/e33/",
        "/e34/", "/e35/", "/e36/",
        "/e37/","/e1000/","/e1001/",
        "/e1002/","/e1003/","/e1004/"
        "/e1005/","/e1006/","/e1007/"
        "/e1008/","/e1009/","/e1010/"
        "/e1011/","/e1012/","/e1013/"
        "/e1014/"
    ].

update_scene_face(Player, Content) ->
    {_NewContent, _Num, FaceList} = replace_face(Content),
    case FaceList == [] of
        true -> Player#player{scene_face = ""};
        false ->
            SubList = lists:sublist(FaceList, 3),
            FaceStr = lists:concat(SubList),
            {new, Player#player{scene_face = FaceStr}}
    end.

sys_send_to_public(Player, Content) ->
    Data = chat:pack_chat_data(Player, 1, Content, ""),
    {ok, Bin} = pt_110:write(11000, {Data}),
    server_send:send_to_all(Bin),
    ok.

sys_send_to_guild(Player, GuildKey, Content) ->
    Data = pack_chat_data(Player, ?CHAT_TYPE_GUILD, Content, ""),
    {ok, Bin} = pt_110:write(11000, {Data}),
    MembersPidList = guild_util:get_guild_member_pids_online(GuildKey),
    F = fun(MPid) ->
        server_send:send_to_pid(MPid, Bin)
        end,
    lists:foreach(F, MembersPidList),
    chat_proc:log_chat(?CHAT_TYPE_GUILD, Data, GuildKey),
    ok.

log_chat(Pkey, Nickname, Lv, Vip, Type, Content, Now, ToKey, ToName, ToLv, ToVip) ->
    Content1 = util:filter_utf8(Content),
    Sql = io_lib:format("insert into log_chat set pkey=~p,nickname='~s',lv=~p,vip=~p,`type`=~p,content ='~s',tokey = ~p ,toname = '~s',tolv=~p,tovip=~p,time=~p",
        [Pkey, Nickname, Lv, Vip, Type, Content1, ToKey, ToName, ToLv, ToVip, Now]),
    db:execute(Sql).


check_content(Content) ->
    ReplaceContent = replace_link_content(Content),
    %%屏蔽字
    case util:check_keyword(ReplaceContent) of
        false -> true;
        true -> {fail, keyword1}
    end.

%%通知客户端加载配置资源
refresh_res() ->
    ?WARNING("refresh res ~p~n", [1]),
    {ok, Bin} = pt_110:write(11011, {1}),
    server_send:send_to_all(Bin).



filter_content(ReplaceContent, Content1) ->
    XXX = xmerl_ucs:to_unicode("***", 'utf-8'),
    SendContent =
        case util:keyword_filter(ReplaceContent) of
            [] -> Content1;
            FilterList ->
                Fc = fun(Word, AccContent) ->
                    TokenList = string:tokens(AccContent, Word),
                    AccContent1 = string:join(TokenList, XXX),
                    case AccContent1 == [] of
                        true -> XXX;
                        false ->
                            AccContent2 =
                                case hd(AccContent1) == hd(AccContent) of
                                    true -> AccContent1;
                                    false -> lists:concat([XXX, AccContent1])
                                end,
                            AccContent3 =
                                case lists:last(AccContent2) == lists:last(AccContent) of
                                    true -> AccContent2;
                                    false -> lists:concat([AccContent2, XXX])
                                end,
                            AccContent3
                    end
                     end,
                string:strip(lists:foldl(Fc, Content1, FilterList))
%%
%%                 Fc = fun(Word, AccContent) ->
%%                     TokenList = string:tokens(AccContent, Word),
%%                     AccContent1 = string:join(TokenList, XXX),
%%                     case AccContent1 == [] of
%%                         true -> XXX;
%%                         false ->
%%                             AccContent2 =
%%                                 case hd(AccContent1) == hd(AccContent) of
%%                                     true -> AccContent1;
%%                                     false -> lists:concat([XXX, AccContent1])
%%                                 end,
%%                             AccContent3 =
%%                                 case lists:last(AccContent2) == lists:last(AccContent) of
%%                                     true -> AccContent2;
%%                                     false -> lists:concat([AccContent2, XXX])
%%                                 end,
%%                             AccContent3
%%                     end
%%                 end,
%%
%%                 string:strip(lists:foldl(Fc, Content1, SendContent0))


        end,
    SendContent.

shaizi(Player, Type) ->
    case Type of
        1 -> %% 公会
            GuildMemberList = guild_ets:get_guild_member_list(Player#player.guild#st_guild.guild_key),
            Rand = util:rand(1, 100),
            {ok, Bin} = pt_110:write(11012, {Player#player.nickname, Rand}),
            F = fun(#g_member{is_online = IsOnline, pid = Pid}) ->
                if
                    IsOnline == 0 -> skip;
                    true ->
                        server_send:send_to_pid(Pid, Bin)
                end
                end,
            lists:map(F, GuildMemberList),
            ok
    end.

guild_sincere_word(Player) ->
    GuildMemberList = guild_ets:get_guild_member_list(Player#player.guild#st_guild.guild_key),
    RandId = util:list_rand(data_guild_problem:get_all()),
    ?DEBUG("RandId:~p", [RandId]),
    {ok, Bin} = pt_110:write(11013, {RandId}),
    F = fun(#g_member{is_online = IsOnline, pid = Pid}) ->
        if
            IsOnline == 0 -> skip;
            true ->
                server_send:send_to_pid(Pid, Bin)
        end
    end,
    lists:map(F, GuildMemberList),
    ok.