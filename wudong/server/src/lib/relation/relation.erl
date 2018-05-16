%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 角色关系模块
%%% @end
%%% Created : 19. 十一月 2015 下午8:54
%%%-------------------------------------------------------------------
-module(relation).
-author("fancy").

-include("common.hrl").
-include("server.hrl").
-include("relation.hrl").
-include("team.hrl").
-include("achieve.hrl").
-include("daily.hrl").
-include("goods.hrl").
%% API
-export([
    init/1
    , get_relation_list/2
    , add_friend_request/2
    , handle_add_friend_request/2
    , add_friend/2
    , handle_add_friend_confirm/2
    , del_friend/2
    , add_blacklist/2
    , del_blacklist/2
    , get_recommend/1
    , put_recently_contacts/1
    , pack_recently_contacts/1
    , save_recently_contacts/1
    , up_friends_avatar/2
    , add_qinmidu/2
    , del_friend_help/1
    , is_my_black/1
    , is_my_friend/1
    , is_his_black/2
    , get_player_info/2
    , update_relation_list/2
    , send_flower/5
    , send_chat/4
    , player_pack_relation/1
    , relation_change/1
    , notice_relation/1
]).

%%内部接口
-export([
    get_friend_list/0,
    get_friend_info_list/0,
    get_friend_info_list_for_dun_cross/1,
    get_friend_info_list_for_team/1,
    get_friend_qmd_list/1,
    get_friend_qmd/1,
    get_friend_list_to_fashion/0
]).

init(Player) ->
    init_recently_contacts(Player),
    RelationSt =
        case player_util:is_new_role(Player) of
            true -> #st_relation{};
            false ->
                case relation_load:dbget_relations(Player#player.key) of
                    [] ->
                        #st_relation{};
                    Data ->
                        F = fun([Rkey, Key1, Key2, Type, Qinmidu, Key1Avatar, Key2Avatar, Time, QinmiduArgs], RelationSt) ->
                            case Type of
                                ?RTYPE_FRIEND ->
                                    {Pkey, _Avatar} = ?IF_ELSE(Player#player.key == Key1, {Key2, Key2Avatar}, {Key1, Key1Avatar}),
                                    FriendsPlayer = shadow_proc:get_shadow(Pkey),
                                    Friends = [#relation{rkey = Rkey, pkey = Pkey, type = Type, qinmidu = Qinmidu, qinmidu_args = util:bitstring_to_term(QinmiduArgs), avatar = FriendsPlayer#player.avatar, decoration_id = FriendsPlayer#player.fashion#fashion_figure.fashion_decoration_id, time = Time, nickname = FriendsPlayer#player.nickname, career = FriendsPlayer#player.career, sex = FriendsPlayer#player.sex, vip = FriendsPlayer#player.vip_lv, cbp = FriendsPlayer#player.cbp, lv = FriendsPlayer#player.lv, guild = FriendsPlayer#player.guild#st_guild.guild_name} | RelationSt#st_relation.friends],
                                    RelationSt#st_relation{friends = Friends};
                                ?RTYPE_BLACK ->
                                    if
                                        Player#player.key == Key1 ->
                                            {Pkey, Avatar} = {Key2, Key2Avatar},
                                            BlackPlayer = shadow_proc:get_shadow(Pkey),
                                            Blacklist = [#relation{rkey = Rkey, pkey = Pkey, type = Type, qinmidu = Qinmidu, qinmidu_args = util:bitstring_to_term(QinmiduArgs), avatar = Avatar, decoration_id = BlackPlayer#player.fashion#fashion_figure.fashion_decoration_id, time = Time, nickname = BlackPlayer#player.nickname, career = BlackPlayer#player.career, sex = BlackPlayer#player.sex, vip = BlackPlayer#player.vip_lv, cbp = BlackPlayer#player.cbp, lv = BlackPlayer#player.lv, guild = BlackPlayer#player.guild#st_guild.guild_name} | RelationSt#st_relation.blacklist],
                                            RelationSt#st_relation{blacklist = Blacklist};
                                        true ->
                                            RelationSt
                                    end;
                                ?RTYPE_ENEMY ->
                                    {Pkey, Avatar} = ?IF_ELSE(Player#player.key == Key1, {Key2, Key2Avatar}, {Key1, Key1Avatar}),
                                    EnemysPlayer = shadow_proc:get_shadow(Pkey),
                                    Enemys = [#relation{rkey = Rkey, pkey = Pkey, type = Type, qinmidu = Qinmidu, qinmidu_args = util:bitstring_to_term(QinmiduArgs), avatar = Avatar, decoration_id = EnemysPlayer#player.fashion#fashion_figure.fashion_decoration_id, time = Time, nickname = EnemysPlayer#player.nickname, career = EnemysPlayer#player.career, sex = EnemysPlayer#player.sex, vip = EnemysPlayer#player.vip_lv, cbp = EnemysPlayer#player.cbp, lv = EnemysPlayer#player.lv, guild = EnemysPlayer#player.guild#st_guild.guild_name} | RelationSt#st_relation.enemy],
                                    RelationSt#st_relation{enemy = Enemys};
                                _ ->
                                    RelationSt
                            end
                            end,
                        lists:foldl(F, #st_relation{}, Data)
                end
        end,
    {LikeTimes, SelfLikeTimes} = relation_load:dbget_friend_like(Player),
    lib_dict:put(?PROC_STATUS_RELATION, RelationSt#st_relation{like_times = LikeTimes, self_like_times = SelfLikeTimes}),
    Player.

%%获取关系信息
get_relation_list(Player, Type) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    RelationList =
        case Type of
            ?RTYPE_FRIEND -> RelationsSt#st_relation.friends;
            ?RTYPE_BLACK -> RelationsSt#st_relation.blacklist;
            ?RTYPE_ENEMY -> RelationsSt#st_relation.enemy;
            _ -> []
        end,
    %%Total = length(RelationList),
    PackList = lists:map(fun pack_relation/1, RelationList),
%%分页功能，暂时屏蔽
    %%  true ->
    %%     Len = length(RelationList),
    %%      MaxPage = util:ceil(Len / ?PAGE_NUM),
    %%      RealPage = min(MaxPage, Page),
    %%     Start = max(0, (RealPage - 1)) * ?PAGE_NUM + 1,
    %%      RelationList2 = lists:sublist(RelationList, Start, ?PAGE_NUM),
    %%      PackList = lists:map(fun pack_relation/1, RelationList2)
    {ok, Bin} = pt_240:write(24000, {Type, PackList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%申请添加好友
add_friend_request(Player, Pkey) ->
    case player_util:get_player(Pkey) of
        [] ->
            {false, ?RELATION_ERR_OFFLINE};
        TargetPlayer ->
            RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
            Friends = RelationsSt#st_relation.friends,
            case lists:keyfind(Pkey, ?RPOSIT, Friends) of
                false ->
                    OpenLv = ?RELATION_LIM_LV,
                    if
                        Player#player.lv < OpenLv -> %% 自身等级不足
                            {false, 14};
                        TargetPlayer#player.lv < OpenLv -> %% 对方等级不足
                            {false, 15};
                        Player#player.key == Pkey ->    %% 不可添加自己为好友
                            {false, 18};
                        true ->
                            FriendState = ?CALL(TargetPlayer#player.pid, {get_friend_count}),
                            case FriendState of
                                true ->
                                    cache:set({add_friend_request, Player#player.key}, 1, 3600),
                                    TargetPlayer#player.pid ! {add_friend_request, [Player#player.key, Player#player.nickname, Player#player.career, Player#player.realm, Player#player.cbp, Player#player.sex, Player#player.lv, Player#player.avatar, Player#player.guild#st_guild.guild_name]},
                                    ok;
                                _ ->
                                    {false, 17}
                            end
                    end;
                _ ->
                    {false, ?RELATION_ERR_FRIEND_EXISTS}
            end

    end.

handle_add_friend_request(Player, [ReqKey, NickName, Career, Realm, Cbp, Sex, Lv, Avatar, Guild]) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    BlackList = RelationsSt#st_relation.blacklist,
    case lists:keyfind(ReqKey, ?RPOSIT, BlackList) of
        false ->
            {ok, Bin} = pt_240:write(24002, {ReqKey, NickName, Career, Realm, Cbp, Sex, Lv, Avatar, Guild}),
            server_send:send_to_sid(Player#player.sid, Bin),
            tips:send_tips(Player, 12),
            ok;
        _ ->
            skip
    end.

%%添加好友
add_friend(Player, Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Friends = RelationsSt#st_relation.friends,
    case length(Friends) >= ?FRIENDS_LIMIT of
        true ->
            {fail, ?RELATION_ERR_FRIEND_LIMIT};
        false ->
            case lists:keyfind(Pkey, ?RPOSIT, Friends) of
                false ->
                    case cache:get({add_friend_request, Pkey}) of
                        1 ->
                            case player_util:get_player(Pkey) of
                                [] -> {fail, 9};
                                TargetPlayer ->
                                    FriendState = ?CALL(TargetPlayer#player.pid, {get_friend_count}),
                                    case FriendState of
                                        true ->
                                            Rkey = misc:unique_key(),
                                            Now = util:unixtime(),
                                            [Nickname, Career, Realm, Lv, Cbp, Avatar, Sex, VipLv, GuildName, DecorationId] = get_relation_info(Pkey),
                                            Relation = #relation{rkey = Rkey, type = ?RTYPE_FRIEND, pkey = Pkey, avatar = Avatar, decoration_id = DecorationId, time = Now, nickname = Nickname, career = Career, cbp = Cbp, lv = Lv, realm = Realm, sex = Sex, vip = VipLv, guild = GuildName},
                                            relation_load:dbadd_relation(Rkey, Player#player.key, Player#player.avatar, Pkey, Avatar, ?RTYPE_FRIEND, Now),
                                            StRela = update_relation(Relation),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4005, 0, length(StRela#st_relation.friends)),
                                            %%通知好友已通过
                                            TargetPlayer#player.pid ! {add_frined_cofirm, [Rkey, Player#player.key, Now], Player#player.key, Player#player.nickname},
                                            {ok, ?RELATION_ERR_OK};
                                        _ ->
                                            {fail, 17}
                                    end
                            end;
                        _ ->
                            {fail, ?RELATION_ERR_FAIL}
                    end;
                _ ->
                    {fail, ?RELATION_ERR_FRIEND_EXISTS}
            end
    end.

send_chat(Player, Lv, Pkey, Name) ->
    AllIds = if
                 Lv =< 50 -> data_friend_chat:get_less_fifty();
                 true -> data_friend_chat:get_than_fifty()
             end,
    Index = util:random(hd(AllIds), hd(AllIds) + length(AllIds) - 1),
    Content = util:to_list(data_friend_chat:get(Index)),
    chat:chat(Player, 3, Content, [], Pkey, Name, 0),
    ok.

handle_add_friend_confirm(_Player, [Rkey, Pkey, Time]) ->
    [Nickname, Career, Realm, Lv, Cbp, Avatar, Sex, VipLv, GuildName, DecorationId] = get_relation_info(Pkey),
    Relation = #relation{rkey = Rkey, type = ?RTYPE_FRIEND, pkey = Pkey, avatar = Avatar, decoration_id = DecorationId, time = Time, nickname = Nickname, career = Career, cbp = Cbp, lv = Lv, realm = Realm, sex = Sex, vip = VipLv, guild = GuildName},
    StRela = update_relation(Relation),
    achieve:trigger_achieve(_Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4005, 0, length(StRela#st_relation.friends)),
    ok.


%%删除好友
del_friend(Player, Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Frineds = RelationsSt#st_relation.friends,
    case lists:keyfind(Pkey, ?RPOSIT, Frineds) of
        false ->
            {fail, ?RELATION_ERR_FRIEND_NOT_EXISTS};
        Relation ->
            relation_load:dbdel_relation(Relation#relation.rkey),
            %% 删除对方字典
            case player_util:get_player_pid(Pkey) of
                false -> skip;
                TargetPid ->
                    TargetPid ! {del_frined_inform, [Player#player.key]}
            end,
            delete_relation(Relation),
            {ok, ?RELATION_ERR_OK}
    end.

%% 被删除好友
del_friend_help(Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Frineds = RelationsSt#st_relation.friends,
    case lists:keyfind(Pkey, ?RPOSIT, Frineds) of
        false ->
            {fail, ?RELATION_ERR_FRIEND_NOT_EXISTS};
        Relation ->
            delete_relation(Relation),
            {ok, ?RELATION_ERR_OK}
    end.

%%增加亲密度(无限制)
add_qinmidu({Pkey, AddValue}, _Player) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Frineds = RelationsSt#st_relation.friends,
    case lists:keyfind(Pkey, ?RPOSIT, Frineds) of
        false ->
            ok;
        Relation ->
            case AddValue of
                {no_db, AddValue0} ->
                    NewRelation = Relation#relation{qinmidu = max(0, Relation#relation.qinmidu + AddValue0)},
                    update_relation(NewRelation);
                AddValue when is_integer(AddValue) ->
                    NewRelation = Relation#relation{qinmidu = max(0, Relation#relation.qinmidu + AddValue)},
                    relation_load:dbupdate_qinmidu(NewRelation#relation.qinmidu, NewRelation#relation.rkey),
                    update_relation(NewRelation);
                _ -> ok
            end,
            ok
    end;
%%增加亲密度(有限制)
add_qinmidu({Id, Pkey, AddValue}, _Player) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Frineds = RelationsSt#st_relation.friends,
    case lists:keyfind(Pkey, ?RPOSIT, Frineds) of
        false ->
            ok;
        Relation ->
            case AddValue of
                {no_db, AddValue0} ->
                    update_qinmidu_not_to_db(Relation, Id, AddValue0);
                AddValue when is_integer(AddValue) ->
                    update_qinmidu_to_db(Relation, Id, AddValue);
                _ -> ok
            end
    end,
    ok.


update_qinmidu_to_db(Relation, Id, AddValue) ->
    BaseQinmidu = data_qinmidu_args:get(Id),
    QinmiduList = Relation#relation.qinmidu_args,
    Now = util:unixtime(),
    case lists:keytake(Id, 1, QinmiduList) of
        false ->
            NewQinmiduList = [{Id, Now, AddValue} | Relation#relation.qinmidu_args],
            NewRelation = Relation#relation{qinmidu = max(0, Relation#relation.qinmidu + AddValue), qinmidu_args = NewQinmiduList},
            relation_load:dbupdate_qinmidu_and_list(NewRelation#relation.qinmidu_args, NewRelation#relation.qinmidu, NewRelation#relation.rkey),
            update_relation(NewRelation);
        {value, {Id, LastTime, Value}, List} ->
            IsSameDate = util:is_same_date(LastTime, Now),
            if
                Value >= BaseQinmidu#qinmidu.limit -> %% 超过当日上限
                    skip;
                IsSameDate == true -> %% 同一天直接累加
                    NewQinmiduList = [{Id, Now, Value + AddValue} | List],
                    NewRelation = Relation#relation{qinmidu = max(0, Relation#relation.qinmidu + AddValue), qinmidu_args = NewQinmiduList},
                    relation_load:dbupdate_qinmidu_and_list(NewRelation#relation.qinmidu_args, NewRelation#relation.qinmidu, NewRelation#relation.rkey),
                    update_relation(NewRelation);
                true -> %% 不是同一天，直接赋值
                    NewQinmiduList = [{Id, Now, AddValue} | List],
                    NewRelation = Relation#relation{qinmidu = max(0, Relation#relation.qinmidu + AddValue), qinmidu_args = NewQinmiduList},
                    relation_load:dbupdate_qinmidu_and_list(NewRelation#relation.qinmidu_args, NewRelation#relation.qinmidu, NewRelation#relation.rkey),
                    update_relation(NewRelation)
            end
    end.


update_qinmidu_not_to_db(Relation, Id, AddValue) ->
    BaseQinmidu = data_qinmidu_args:get(Id),
    QinmiduList = Relation#relation.qinmidu_args,
    Now = util:unixtime(),
    case lists:keytake(Id, 1, QinmiduList) of
        false ->
            NewQinmiduList = [{Id, Now, AddValue} | Relation#relation.qinmidu_args],
            NewRelation = Relation#relation{qinmidu = max(0, Relation#relation.qinmidu + AddValue), qinmidu_args = NewQinmiduList},
            update_relation(NewRelation);
        {value, {Id, LastTime, Value}, List} ->
            IsSameDate = util:is_same_date(LastTime, Now),
            if
                Value >= BaseQinmidu#qinmidu.limit -> %% 超过当日上限
                    skip;
                IsSameDate == true -> %% 同一天直接累加
                    NewQinmiduList = [{Id, Now, Value + AddValue} | List],
                    NewRelation = Relation#relation{qinmidu = max(0, Relation#relation.qinmidu + AddValue), qinmidu_args = NewQinmiduList},
                    update_relation(NewRelation);
                true -> %% 不是同一天，直接赋值
                    NewQinmiduList = [{Id, Now, AddValue} | List],
                    NewRelation = Relation#relation{qinmidu = max(0, Relation#relation.qinmidu + AddValue), qinmidu_args = NewQinmiduList},
                    update_relation(NewRelation)
            end
    end.


%%添加黑名单
add_blacklist(Player, Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    BlackList = RelationsSt#st_relation.blacklist,
    case length(BlackList) >= ?BLACKLIST_LIMIT of
        true ->
            {fail, ?RELATION_ERR_BLACKLIST_LIMIT};
        false ->
            case lists:keyfind(Pkey, ?RPOSIT, BlackList) of
                false ->
                    if
                        Player#player.key == Pkey ->
                            {fail, 0};
                        true ->
                            case player_util:get_player(Pkey) of
                                [] ->
                                    add_blacklist_help(Player, Pkey),
                                    {ok, ?RELATION_ERR_OK};
                                TargetPlayer ->
                                    OpenLv = ?RELATION_LIM_LV,
                                    if
                                        Player#player.lv < OpenLv -> %% 自身等级不足
                                            {fail, 14};
                                        TargetPlayer#player.lv < OpenLv -> %% 对方等级不足
                                            {fail, 15};
                                        true ->
                                            add_blacklist_help(Player, Pkey),
                                            {ok, ?RELATION_ERR_OK}
                                    end
                            end
                    end;
                _ ->
                    {fail, ?RELATION_ERR_BLACKLIST_EXISTS}
            end
    end.

add_blacklist_help(Player, Pkey) ->
    Rkey = misc:unique_key(),
    Now = util:unixtime(),
    Relation = #relation{rkey = Rkey, pkey = Pkey, type = ?RTYPE_BLACK, time = Now},
    relation_load:dbadd_relation(Rkey, Player#player.key, Player#player.avatar, Pkey, "", ?RTYPE_BLACK, Now),
    update_relation(Relation),
    del_friend(Player, Pkey),%% 添加黑名单同时删除好友
    ok.

%%删除黑名单
del_blacklist(_Player, Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    BlackList = RelationsSt#st_relation.blacklist,
    case lists:keyfind(Pkey, ?RPOSIT, BlackList) of
        false ->
            {fail, ?RELATION_ERR_BLACKLIST_NOT_EXISTS};
        Relation ->
            relation_load:dbdel_relation(Relation#relation.rkey),
            delete_relation(Relation),
            {ok, ?RELATION_ERR_OK}
    end.


%%获取推荐好友
get_recommend(Player) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FrinedList = RelationsSt#st_relation.friends,
    FriendKeylist0 = [Relation#relation.pkey || Relation <- FrinedList],
    FriendKeylist = [Player#player.key | FriendKeylist0],
    OnlineList = get_recommend_from_online(Player, FriendKeylist),
    lists:sublist(OnlineList, 3).

get_recommend_from_online(Player, FriendKeylist) ->
    OnlineList = ets:tab2list(?ETS_ONLINE),
    NewPids = lists:sublist(util:list_shuffle(OnlineList), 7),
    F = fun(E, List) ->
        IsFriend = lists:member(E#ets_online.key, FriendKeylist),
        if
            E#ets_online.key == Player#player.key -> List;
            IsFriend -> List;
            true ->
                case player_util:get_player(E#ets_online.pid) of
                    [] -> List;
                    Role ->
                        OpenLv = ?RELATION_LIM_LV,
                        if
                            Role#player.lv < OpenLv -> List;
                            true ->
                                [[2,
                                    Role#player.key,
                                    Role#player.sn_cur,
                                    list_to_binary(Role#player.nickname),
                                    Role#player.career,
                                    Role#player.realm,
                                    Role#player.cbp,
                                    Role#player.sex,
                                    Role#player.lv,
                                    list_to_binary(Role#player.location),
                                    Player#player.wing_id,
                                    Player#player.equip_figure#equip_figure.weapon_id,
                                    Player#player.equip_figure#equip_figure.clothing_id,
                                    Player#player.light_weaponid,
                                    Role#player.fashion#fashion_figure.fashion_cloth_id,
                                    Role#player.fashion#fashion_figure.fashion_head_id
                                ] | List]
                        end
                end
        end
        end,
    RecommendList = lists:foldl(F, [], NewPids),
    util:list_shuffle(RecommendList).

%%获取自己的好友
get_friend_list() ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FriendList = RelationsSt#st_relation.friends,
    [Relation#relation.pkey || Relation <- FriendList].

get_friend_info_list() ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FriendList = RelationsSt#st_relation.friends,
    F = fun(Friend) ->
        case ets:lookup(?ETS_ONLINE, Friend#relation.pkey) of
            [] -> [];
            _ ->
                [{Friend#relation.pkey, Friend#relation.nickname, Friend#relation.career, Friend#relation.sex, Friend#relation.vip, Friend#relation.lv, Friend#relation.cbp, Friend#relation.avatar, Friend#relation.guild}]
        end
        end,
    lists:flatmap(F, FriendList).

%%邀请好友,跨服副本
get_friend_info_list_for_dun_cross(Lv) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FriendList = RelationsSt#st_relation.friends,
    F = fun(Friend) ->
        case ets:lookup(?ETS_ONLINE, Friend#relation.pkey) of
            [] -> [];
            _ ->
                if Friend#relation.lv < Lv -> [];
                    true ->
                        [[Friend#relation.pkey, Friend#relation.nickname, Friend#relation.lv, Friend#relation.cbp]]
                end
        end
        end,
    lists:flatmap(F, FriendList).

%% 邀请好友，野外组队
get_friend_info_list_for_team(Lv) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FriendList = RelationsSt#st_relation.friends,
    F = fun(Friend) ->
        case ets:lookup(?ETS_ONLINE, Friend#relation.pkey) of
            [] -> [];
            _ ->
                ?IF_ELSE(Friend#relation.lv >= Lv, [Friend#relation.pkey], [])
        end
        end,
    lists:flatmap(F, FriendList).


%%获取好友亲密度列表
get_friend_qmd_list(Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FriendList = RelationsSt#st_relation.friends,
    F = fun(Friend) ->
        {{Pkey, Friend#relation.pkey}, Friend#relation.qinmidu}
        end,
    lists:map(F, FriendList).

%%获取和某玩家的亲密度
get_friend_qmd(Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FriendList = RelationsSt#st_relation.friends,
    case lists:keyfind(Pkey, #relation.pkey, FriendList) of
        false -> 0;
        Friend -> Friend#relation.qinmidu
    end.

%% ----- privte functions -----


pack_relation(Relation) ->
    Relation2 =
        if
            Relation#relation.cbp == 0 ->
                [Nickname, Career, Realm, Lv, Cbp, Avatar, Sex, VipLv, GuildName, DecorationId] = get_relation_info(Relation#relation.pkey),
                Relation1 = Relation#relation{nickname = Nickname, career = Career, realm = Realm, lv = Lv, cbp = Cbp, avatar = Avatar, decoration_id = DecorationId, sex = Sex, vip = VipLv, guild = GuildName},
                update_relation(Relation1),
                Relation1;
            true ->
                Relation
        end,
    [
        Relation2#relation.pkey,
        Relation2#relation.nickname,
        Relation2#relation.career,
        Relation2#relation.realm,
        Relation2#relation.lv,
        Relation2#relation.qinmidu,
        Relation2#relation.sex,
        Relation2#relation.vip,
        Relation2#relation.cbp,
        relation_off_line_time(Relation#relation.pkey, util:unixtime() - 6 * 3600),
        Relation2#relation.avatar,
        Relation2#relation.guild,
        Relation2#relation.decoration_id
    ].


relation_change(Relation0) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Friends = RelationsSt#st_relation.friends,
    Blacklist = RelationsSt#st_relation.blacklist,
    Enemy = RelationsSt#st_relation.enemy,
    F = fun(RelationList) ->
        case lists:keytake(Relation0#relation.rkey, #relation.rkey, RelationList) of
            {value, Relation1, List} ->
                [Relation1#relation{
                    sex = Relation0#relation.sex,
                    avatar = Relation0#relation.avatar,
                    decoration_id = Relation0#relation.decoration_id,
                    nickname = Relation0#relation.nickname
                } | List];
            false ->
                RelationList
        end
        end,
    NewFriends = F(Friends),
    NewBlacklist = F(Blacklist),
    NewEnemy = F(Enemy),
    RelationsSt2 = RelationsSt#st_relation{
        friends = NewFriends,
        blacklist = NewBlacklist,
        enemy = NewEnemy
    },
    lib_dict:put(?PROC_STATUS_RELATION, RelationsSt2),
    RelationsSt2.

notice_relation(Player) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    Friends = RelationsSt#st_relation.friends,
    Blacklist = RelationsSt#st_relation.blacklist,
    Enemy = RelationsSt#st_relation.enemy,
    F = fun(Relation) ->
        case player_util:get_player_pid(Relation#relation.pkey) of
            false -> skip;
            Pid ->
                NewRelation = player_pack_relation(Player),
                Pid ! {relation_change, NewRelation}
        end
        end,
    lists:foreach(F, Friends),
    lists:foreach(F, Blacklist),
    lists:foreach(F, Enemy),
    ok.

player_pack_relation(Player) ->
    Relation = #relation{
        pkey = Player#player.key,
        sex = Player#player.sex,
        avatar = Player#player.avatar,
        decoration_id = Player#player.fashion#fashion_figure.fashion_decoration_id,
        nickname = Player#player.nickname
    },
    Relation.

update_relation(Relation) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    RelationList =
        case Relation#relation.type of
            ?RTYPE_FRIEND -> RelationsSt#st_relation.friends;
            ?RTYPE_BLACK -> RelationsSt#st_relation.blacklist;
            ?RTYPE_ENEMY -> RelationsSt#st_relation.enemy;
            _ -> []
        end,
    RelationList2 = [Relation | lists:keydelete(Relation#relation.rkey, #relation.rkey, RelationList)],
    RelationsSt2 =
        case Relation#relation.type of
            ?RTYPE_FRIEND ->
                RelationsSt#st_relation{friends = RelationList2};
            ?RTYPE_BLACK ->
                RelationsSt#st_relation{blacklist = RelationList2};
            ?RTYPE_ENEMY ->
                RelationsSt#st_relation{enemy = RelationList2};
            _ ->
                RelationsSt
        end,
    lib_dict:put(?PROC_STATUS_RELATION, RelationsSt2),
    RelationsSt2.

delete_relation(Relation) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    RelationList =
        case Relation#relation.type of
            ?RTYPE_FRIEND -> RelationsSt#st_relation.friends;
            ?RTYPE_BLACK -> RelationsSt#st_relation.blacklist;
            ?RTYPE_ENEMY -> RelationsSt#st_relation.enemy;
            _ -> []
        end,
    RelationList2 = lists:keydelete(Relation#relation.rkey, 2, RelationList),
    RelationsSt2 =
        case Relation#relation.type of
            ?RTYPE_FRIEND ->
                RelationsSt#st_relation{friends = RelationList2};
            ?RTYPE_BLACK ->
                RelationsSt#st_relation{blacklist = RelationList2};
            ?RTYPE_ENEMY ->
                RelationsSt#st_relation{enemy = RelationList2};
            _ ->
                RelationsSt
        end,
    lib_dict:put(?PROC_STATUS_RELATION, RelationsSt2).


get_relation_info(Pkey) ->
    Avatar =
        case db:get_row(io_lib:format("select avatar from player_login where pkey = ~p limit 1", [Pkey])) of
            [] ->
                "";
            [AvatarBin] ->
                util:to_list(AvatarBin)
        end,
    FriendsPlayer = shadow_proc:get_shadow(Pkey),
    case relation_load:dbget_relation_info(Pkey) of
        [Nickname, Career, Realm, Lv, Cbp, Sex, VipLv] ->
            [Nickname, Career, Realm, Lv, Cbp, Avatar, Sex, VipLv, FriendsPlayer#player.guild#st_guild.guild_name, FriendsPlayer#player.fashion#fashion_figure.fashion_decoration_id];
        [] ->
            [[], 0, 0, 1, 0, "", 0, 0, "", 0]
    end.

relation_off_line_time(Pkey, LastLoginTime) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] -> max(0, util:unixtime() - LastLoginTime);
        _ -> 0
    end.

put_recently_contacts(FriendPlayer) ->
    RecentlyContactsList = lib_dict:get(recently_contacts),
    Relation = #relation{rkey = misc:unique_key(),
        pkey = FriendPlayer#player.key,
        type = 4,
        time = util:unixtime(),
        nickname = FriendPlayer#player.nickname,
        career = FriendPlayer#player.career,
        sex = FriendPlayer#player.sex,
        vip = FriendPlayer#player.vip_lv,
        cbp = FriendPlayer#player.cbp,
        lv = FriendPlayer#player.lv,
        avatar = FriendPlayer#player.avatar,
        guild = FriendPlayer#player.guild#st_guild.guild_name
    },
    NewRecentlyContactsList =
        case lists:keytake(FriendPlayer#player.key, #relation.pkey, RecentlyContactsList) of
            false ->
                [Relation | RecentlyContactsList];
            {value, _, List} ->
                [Relation | List]
        end,
    case length(NewRecentlyContactsList) >= ?RECENTLY_CONTACTS_LIMIT of
        true ->
            lib_dict:put(recently_contacts, lists:sublist(NewRecentlyContactsList, ?RECENTLY_CONTACTS_LIMIT));
        false ->
            lib_dict:put(recently_contacts, NewRecentlyContactsList)
    end.

pack_recently_contacts(Player) ->
    RecentlyContactsList = lib_dict:get(recently_contacts),
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    RecentlyContactsList1 = lists:foldl(fun(Rrelation, Out) ->
        case lists:keyfind(Rrelation#relation.pkey, ?RPOSIT, RelationsSt#st_relation.friends) of
            false ->
                [Rrelation | Out];
            Relation1 ->
                [Relation1 | Out]
        end
                                        end, [], RecentlyContactsList),
    PackList = lists:map(fun pack_relation/1, RecentlyContactsList1),
    {ok, Bin} = pt_240:write(24014, {PackList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


init_recently_contacts(Player) ->
    RecentlyContactsList =
        case player_util:is_new_role(Player) of
            true ->
                [];
            false ->
                SqSQL = io_lib:format("select contacts from recently_contacts where pkey = ~p ", [Player#player.key]),
                case db:get_row(SqSQL) of
                    [] ->
                        [];
                    [List0] ->
                        List = util:bitstring_to_term(List0),
                        Fun = fun(Pkey, Out) ->
                            FriendsPlayer = shadow_proc:get_shadow(Pkey),
                            [#relation{rkey = 0,
                                pkey = Pkey,
                                type = 4,
                                time = 0,
                                nickname = FriendsPlayer#player.nickname,
                                career = FriendsPlayer#player.career,
                                sex = FriendsPlayer#player.sex,
                                vip = FriendsPlayer#player.vip_lv,
                                cbp = FriendsPlayer#player.cbp,
                                lv = FriendsPlayer#player.lv,
                                guild = FriendsPlayer#player.guild#st_guild.guild_name
                            } | Out]
                              end,
                        lists:foldr(Fun, [], List)
                end
        end,
    lib_dict:put(recently_contacts, RecentlyContactsList).


save_recently_contacts(Player) ->
    RecentlyContactsList = lib_dict:get(recently_contacts),
    Contacts = util:term_to_bitstring([Relation#relation.pkey || Relation <- RecentlyContactsList]),
    Sql = io_lib:format("replace into recently_contacts set pkey=~p, contacts='~s'", [Player#player.key, Contacts]),
    db:execute(Sql).


up_friends_avatar(Player, Url) ->
    SQL1 = io_lib:format("update relation set key1_avatar = '~s' where key1 = ~p", [Url, Player#player.key]),
    db:execute(SQL1),
    SQL2 = io_lib:format("update relation set key2_avatar = '~s' where key2 = ~p", [Url, Player#player.key]),
    db:execute(SQL2).

%% 判断对方是否在自己黑名单
is_my_black(Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    BlackList = RelationsSt#st_relation.blacklist,
    case lists:keyfind(Pkey, ?RPOSIT, BlackList) of
        false ->
            false;
        _ ->
            true
    end.

%% 判断自己是否在对方黑名单
is_his_black(Mkey, Pkey) ->
    case player_util:get_player_pid(Pkey) of
        false -> skip;
        TargetPid ->
            case ?CALL(TargetPid, {is_black, Mkey}) of
                [] -> time_out;
                true -> true;
                false -> false
            end
    end.


%% 判断对方是否是自己好友
is_my_friend(Pkey) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FriendList = RelationsSt#st_relation.friends,
    case lists:keyfind(Pkey, #relation.pkey, FriendList) of
        false ->
            false;
        _ ->
            true
    end.


get_player_info(Player0, Pkey) ->
    Player =
        if Player0#player.key == Pkey -> Player0;
            true ->
                case player_util:get_player(Pkey) of
                    [] ->
                        shadow_proc:get_shadow(Pkey);
                    Role -> Role
                end
        end,
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    RelationList = RelationsSt#st_relation.friends,
    Qingmidu =
        case lists:keyfind(Pkey, #relation.pkey, RelationList) of
            false -> 0;
            Other -> element(#relation.qinmidu, Other)
        end,

    {Player#player.key,
        %%Player#player.sn_cur,
        config:get_server_num(),
        Player#player.nickname,
        Player#player.career,
        Player#player.realm,
        Player#player.lv,
        Qingmidu,
        Player#player.sex,
        Player#player.vip_lv,
        Player#player.cbp,
        relation_off_line_time(Player#player.key, util:unixtime() - 6 * 3600),
        Player#player.avatar,
        Player#player.guild#st_guild.guild_name}.

%% 刷新关系列表
update_relation_list(Player, Type) ->
    relation:get_relation_list(Player, Type),
    ok.

send_flower(Player, Pkey, GoodsId, Num, ChatString) ->
    case player_util:get_player(Pkey) of
        [] ->
            {false, 10};
        OtherPlayer ->
            case data_send_flower:get(GoodsId) of
                [] -> ?ERR("not find goodsid : ~p~n", [GoodsId]);
                BaseFlower ->
                    HaveNum = goods_util:get_goods_count(GoodsId),
                    if
                        Num > HaveNum orelse Num =< 0 ->
                            {false, 12};
                        true ->
                            case util:check_keyword(ChatString) of %% 屏蔽字
                                true -> {false, 16};
                                _ -> goods:subtract_good(Player, [{GoodsId, Num}], 186),
                                    AddQinmidu = BaseFlower#base_flower.qinmidu * Num,
                                    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
                                    Frineds = RelationsSt#st_relation.friends,
                                    case lists:keyfind(Pkey, ?RPOSIT, Frineds) of
                                        false ->
                                            relation:add_friend_request(Player, Pkey);
                                        _ -> skip
                                    end,
                                    relation:add_qinmidu({Pkey, AddQinmidu}, Player),
                                    OtherPlayer#player.pid ! {add_qinmidu, Player#player.key, {no_db, AddQinmidu}},
                                    if
                                        BaseFlower#base_flower.is_show == 1 ->
                                            BaseGoods = data_goods:get(BaseFlower#base_flower.goods_id),
                                            notice:add_sys_notice(io_lib:format(t_tv:get(154), [t_tv:pn(Player), t_tv:pn(OtherPlayer), cl(Num, 4), t_tv:cl(?T(BaseFlower#base_flower.desc), BaseGoods#goods_type.color)]), 154),
                                            {ok, Bin11} = pt_240:write(24019, {Pkey, GoodsId, Num}),
                                            server_send:send_to_all(Bin11);
                                        true -> skip
                                    end,
                                    LeaveTime = cross_flower:get_leave_time(),
                                    if
                                        LeaveTime =< 0 -> skip;
                                        true ->
                                            cross_all:apply(cross_flower, update_send_flower, [node(), Player#player.sn_cur, Player#player.key, Player#player.nickname, Player#player.sex, Player#player.avatar, OtherPlayer#player.key, OtherPlayer#player.nickname, OtherPlayer#player.sex, OtherPlayer#player.avatar, BaseFlower#base_flower.qinmidu * Num]),
                                            cross_flower:update_give(Player, BaseFlower#base_flower.qinmidu * Num)
                                    end,
                                    NewPlayer = add_sweet(Player, OtherPlayer, BaseFlower#base_flower.sweet_give * Num, BaseFlower#base_flower.sweet_get * Num),
                                    flower_rank:update_send_flower(Player#player.key, Player#player.nickname, Player#player.sex, Player#player.avatar, OtherPlayer#player.key, OtherPlayer#player.nickname, OtherPlayer#player.sex, OtherPlayer#player.avatar, BaseFlower#base_flower.qinmidu * Num),
                                    log_flower_rank(Player#player.key, Player#player.nickname, OtherPlayer#player.key, OtherPlayer#player.nickname, BaseFlower#base_flower.qinmidu * Num),
                                    {ok, NewPlayer, BaseFlower#base_flower.charm, OtherPlayer}
                            end
                    end
            end
    end.

add_sweet(Player, OtherPlayer, GiveSweet, GetSweet) ->
    if
        OtherPlayer#player.key == Player#player.marry#marry.couple_key ->
            NewPlayer = money:add_sweet(Player, GiveSweet),
            OtherPlayer#player.pid ! {add_sweet, GetSweet},
            NewPlayer;
        true -> Player
    end.

%%格式化颜色
cl(Content, Color) ->
    io_lib:format("[#$a type=1 color=~p]~p[#$/a]", [Color, Content]).

%%获取关系信息
get_friend_list_to_fashion() ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    RelationList = RelationsSt#st_relation.friends,
    PackList = lists:map(fun pack_relation/1, RelationList),
    PackList.

log_flower_rank(Key, Nickname, Key2, Nickname2, Val) ->
    Sql = io_lib:format("insert into log_flower_rank set pkey1=~p,nickname1='~s',pkey2=~p,nickname2='~s', val = ~p, time = ~p", [Key, Nickname, Key2, Nickname2, Val, util:unixtime()]),
    log_proc:log(Sql),
    ok.

