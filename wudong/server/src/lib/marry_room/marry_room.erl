%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 七月 2017 20:25
%%%-------------------------------------------------------------------
-module(marry_room).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("marry_room.hrl").

%% API
-export([
    get_my_info/0, %% 读取玩家面板信息
    get_marry_room_list/2, %% 获取大厅数据
    get_my_look/1, %% 读取我关注的
    get_my_face/1, %% 读取我的关注
    looup_player/2, %% 关注玩家
    update_face/2, %% 被关注后，更新粉丝
    update_cancel_face/2, %% 取消关注后，更新粉丝
    cancel_looup_player/2, %% 取消关注
    love_desc/3, %% 发布爱情宣言
    notice/3,
    create_trem/2,
    divorce/1, %% 离婚触发
    divorce/2,
    marry_update/2, %% 结婚触发
    sort_list/1, %% 按照一定顺序排列
    update_friend/1, %% 关注后自动相互加好友
    add_friend/2,
    add_ta_friend/2,
    update_photo/1, %% 上次头像
    get_notice_state/1,
    change_info/1,

    to_record/2,
    logout/1
]).

change_info(Player) ->
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    ets:insert(?ETS_MARRY_ROOM, to_record(StMarryRoom, Player)),
    ok.

%%获取大厅玩家自己信息
get_my_info() ->
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    Num = ets:info(?ETS_MARRY_ROOM, size),
    Page =
        if
            Num rem ?MARRY_PAGE_TOTAL_NUM > 0 -> Num div ?MARRY_PAGE_TOTAL_NUM + 1;
            true -> Num div ?MARRY_PAGE_TOTAL_NUM
        end,
    #st_marry_room{
        rp_val = RpVal,
        qm_val = QmVal,
        is_first_photo = IsFirstPhoto
    } = StMarryRoom,
    {RpVal, QmVal, Page, IsFirstPhoto}.

%%获取大厅排行信息
get_marry_room_list([KeyList, Page], Player) ->
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    #st_marry_room{my_look = MyLook} = StMarryRoom,
    FriendList = relation:get_friend_list(),
    F0 = fun(Key) ->
        [Ets] = ets:lookup(?ETS_MARRY_ROOM, Key),
        Ets
    end,
    EtsList = sort_list2(lists:map(F0, KeyList)),
    F = fun(Ets) ->
        #ets_marry_room{
            pkey = Pkey,
            nickname = NickName,
            career = Career,
            sex = Sex,
            avatar = Avatar,
            vip_lv = VipLv,
            rp_val = RpVal,
%%             qm_val = _QmVal,
            is_marry = IsMarry,
            love_desc = LoveDesc,
            online = Online
        } = Ets,
%%         QmVal = relation:get_friend_qmd(Pkey),
        IsLook = ?IF_ELSE(lists:member(Pkey, MyLook) == true, 1, 0),
        IsFriend = ?IF_ELSE(lists:member(Pkey, FriendList) == true, 1, 0),
        [Pkey, NickName, Career, Sex, VipLv, Avatar, RpVal, IsMarry, LoveDesc, Online, IsLook, IsFriend]
    end,
    ProList = lists:map(F, EtsList),
    {ok, Bin} = pt_436:write(43602, {Page, ProList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%% 获取我关注的
get_my_look(Player) ->
    MarryPkey = Player#player.marry#marry.couple_key,
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    F = fun(Pkey) ->
        case ets:lookup(?ETS_MARRY_ROOM, Pkey) of
            [] -> [];
            [Ets] ->
                [Ets]
        end
    end,
    EtsList = lists:flatmap(F, StMarryRoom#st_marry_room.my_look),
    FriendList = relation:get_friend_list(),
    F1 = fun(Ets) ->
        #ets_marry_room{
            pkey = Pkey,
            nickname = NickName,
            career = Career,
            sex = Sex,
            avatar = Avatar,
            vip_lv = VipLv,
            rp_val = RpVal,
            qm_val = _QmVal,
            is_marry = IsMarry,
            love_desc = LoveDesc,
            online = Online
        } = Ets,
        QmVal = relation:get_friend_qmd(Pkey),
        IsFriend = ?IF_ELSE(lists:member(Pkey, FriendList) == true, 1, 0),
        IsLook = ?IF_ELSE(lists:member(Pkey, StMarryRoom#st_marry_room.my_look) == true, 1, 0),
        [Pkey, NickName, Career, Sex, VipLv, Avatar, RpVal, QmVal, IsMarry, LoveDesc, Online, IsLook, IsFriend]
    end,
    FriendList = relation:get_friend_list(),
    ProList = lists:map(F1, lists:sublist(sort_list3(Player#player.key, EtsList, FriendList, MarryPkey), 40)),
    ProList.

%% 获取我的粉丝
get_my_face(Player) ->
    MarryPkey = Player#player.marry#marry.couple_key,
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    F = fun(Pkey) ->
        case ets:lookup(?ETS_MARRY_ROOM, Pkey) of
            [] -> [];
            [Ets] ->
                [Ets]
        end
    end,
    EtsList = lists:flatmap(F, StMarryRoom#st_marry_room.my_face),
    FriendList = relation:get_friend_list(),
    F1 = fun(Ets) ->
        #ets_marry_room{
            pkey = Pkey,
            nickname = NickName,
            career = Career,
            sex = Sex,
            avatar = Avatar,
            vip_lv = VipLv,
            rp_val = RpVal,
            qm_val = _QmVal,
            is_marry = IsMarry,
            love_desc = LoveDesc,
            online = Online
        } = Ets,
        QmVal = relation:get_friend_qmd(Pkey),
        IsFriend = ?IF_ELSE(lists:member(Pkey, FriendList) == true, 1, 0),
        IsLook = ?IF_ELSE(lists:member(Pkey, StMarryRoom#st_marry_room.my_look) == true, 1, 0),
        [Pkey, NickName, Career, Sex, VipLv, Avatar, RpVal, QmVal, IsMarry, LoveDesc, Online, IsLook, IsFriend]
    end,
    ProList = lists:map(F1, lists:sublist(sort_list3(Player#player.key, EtsList, FriendList, MarryPkey), 40)),
    ProList.

%% 点击关注玩家
looup_player(Player, Pkey) ->
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    #st_marry_room{my_look = MyLook} = StMarryRoom,
    Flag = lists:member(Pkey, MyLook),
    if
        Flag == true -> 4; %% 已经关注过的玩家
        Pkey == Player#player.key -> 5; %% 不可关注自己
        true ->
            NewStMarryRoom = StMarryRoom#st_marry_room{my_look = [Pkey | MyLook]},
            lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewStMarryRoom),
            ets:insert(?ETS_MARRY_ROOM, to_record(NewStMarryRoom, Player)),
            marry_room_load:update(NewStMarryRoom),
            update_other_player(looup_player, Pkey, Player#player.key),
            PlayerShadow = shadow_proc:get_shadow(Pkey),
            relation:put_recently_contacts(PlayerShadow),
            1
    end.

%% 更新被关注的玩家数据
update_other_player(looup_player, Pkey, FaceKey) ->
    case ets:lookup(?ETS_MARRY_ROOM, Pkey) of
        [] -> skip;
        [Ets] ->
            if
                Ets#ets_marry_room.online == 0 -> %% 不在线
                    NewMyFace = util:list_filter_repeat([FaceKey] ++ Ets#ets_marry_room.my_face),
                    NewEts = Ets#ets_marry_room{my_face = NewMyFace, rp_val = length(cacl_rp_val(NewMyFace))},
                    ets:insert(?ETS_MARRY_ROOM, NewEts),
                    marry_room_load:update(NewEts);
                true -> %% 在线玩家
                    player:apply_state(async, Ets#ets_marry_room.pid, {marry_room, update_face, FaceKey})
            end
    end;
%% 更新被取消关注的玩家数据
update_other_player(cancel_looup_player, Pkey, FaceKey) ->
    case ets:lookup(?ETS_MARRY_ROOM, Pkey) of
        [] -> skip;
        [Ets] ->
            if
                Ets#ets_marry_room.online == 0 -> %% 不在线
                    NewMyFace = util:list_filter_repeat(Ets#ets_marry_room.my_face -- [FaceKey]),
                    NewEts = Ets#ets_marry_room{my_face = NewMyFace, rp_val = length(cacl_rp_val(NewMyFace))},
                    ets:insert(?ETS_MARRY_ROOM, NewEts),
                    marry_room_load:update(NewEts);
                true -> %% 在线玩家
                    player:apply_state(async, Ets#ets_marry_room.pid, {marry_room, update_cancel_face, FaceKey})
            end
    end.

%% 被关注，更新粉丝数据
update_face(FaceKey, Player) ->
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    #st_marry_room{my_face = MyFace} = StMarryRoom,
    NewMyFace = util:list_filter_repeat([FaceKey | MyFace]),
    NewStMarryRoom = StMarryRoom#st_marry_room{my_face = NewMyFace, rp_val = length(cacl_rp_val(NewMyFace))},
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewStMarryRoom),
    marry_room_load:update(NewStMarryRoom),
    ets:insert(?ETS_MARRY_ROOM, to_record(NewStMarryRoom, Player)),
    ok.

%% 被取消，更新粉丝数据
update_cancel_face(FaceKey, Player) ->
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    #st_marry_room{my_face = MyFace} = StMarryRoom,
    NewMyFace = MyFace -- [FaceKey],
    NewStMarryRoom = StMarryRoom#st_marry_room{my_face = NewMyFace, rp_val = length(cacl_rp_val(NewMyFace))},
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewStMarryRoom),
    marry_room_load:update(NewStMarryRoom),
    ets:insert(?ETS_MARRY_ROOM, to_record(NewStMarryRoom, Player)),
    ok.

%% 取消关注
cancel_looup_player(Player, Pkey) ->
    StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    #st_marry_room{my_look = MyLook} = StMarryRoom,
    Flag = lists:member(Pkey, MyLook),
    if
        Flag == false -> 1; %% 已经取消关注过的玩家
        true ->
            NewStMarryRoom = StMarryRoom#st_marry_room{my_look = MyLook -- [Pkey]},
            lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewStMarryRoom),
            ets:insert(?ETS_MARRY_ROOM, to_record(NewStMarryRoom, Player)),
            marry_room_load:update(NewStMarryRoom),
            update_other_player(cancel_looup_player, Pkey, Player#player.key),
            1
    end.

%% 发布爱情宣言
love_desc(Player, LoveDescType, LoveDesc) ->
    case check_love_desc(Player, LoveDescType) of
        {fail, Code} ->
            {Code, Player};
        {true, bgold} ->
            NPlayer = money:add_bind_gold(Player, -?MARRY_ROOM_LOVE_DESC_0, 644, 0, 0),
            StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
            NewStMarryRoom =
                StMarryRoom#st_marry_room{
                    love_desc = LoveDesc,
                    love_desc_time = util:unixtime(),
                    love_desc_type = LoveDescType
                },
            lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewStMarryRoom),
            marry_room_load:update(NewStMarryRoom),
            ets:insert(?ETS_MARRY_ROOM, to_record(NewStMarryRoom, NPlayer)),
            ?CAST(marry_room_proc:get_server_pid(), refresh_marry_room_list),
            spawn(fun() -> notice(Player, LoveDesc) end),
            {1, NPlayer};
        {true, gold} ->
            NPlayer = money:add_no_bind_gold(Player, -?MARRY_ROOM_LOVE_DESC_1, 645, 0, 0),
            StMarryRoom = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
            NewStMarryRoom =
                StMarryRoom#st_marry_room{
                    love_desc = LoveDesc,
                    love_desc_time = util:unixtime(),
                    love_desc_type = LoveDescType
                },
            lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewStMarryRoom),
            marry_room_load:update(NewStMarryRoom),
            ets:insert(?ETS_MARRY_ROOM, to_record(NewStMarryRoom, NPlayer)),
            ?CAST(marry_room_proc:get_server_pid(), refresh_marry_room_list),
            spawn(fun() -> notice(Player, LoveDesc) end),
            {1, NPlayer}
    end.

notice(Player, LoveDesc) ->
    notice_sys:add_notice(marry_room_love_desc,[Player, LoveDesc, t_tv:gz(Player, ?T("【关注TA】"))]),
    ok.

check_love_desc(Player, LoveDescType) ->
    if
        Player#player.marry#marry.mkey > 0 ->
            {fail, 3}; %% 已婚
        true ->
            case LoveDescType of
                0 -> %% 普通
                    Flag = money:is_enough(Player, ?MARRY_ROOM_LOVE_DESC_0, bgold),
                    ?IF_ELSE(Flag == false, {fail, 2}, {true, bgold});
                1 -> %% 豪华
                    Flag = money:is_enough(Player, ?MARRY_ROOM_LOVE_DESC_1, gold),
                    ?IF_ELSE(Flag == false, {fail, 2}, {true, gold})
            end
    end.

to_record(RR, #player{nickname = NickName, sex = Sex, vip_lv = VipLv, career = Career, avatar = Avatar, pid = Pid, sid = Sid}) ->
    #ets_marry_room{
        pkey = RR#st_marry_room.pkey,
        nickname = NickName,
        career = Career,
        sex = Sex,
        avatar = Avatar,
        vip_lv = VipLv,
        rp_val = RR#st_marry_room.rp_val, %% 人气值
        qm_val = RR#st_marry_room.qm_val, %% 亲密度
        is_marry = RR#st_marry_room.is_marry, %% 是否结婚
        love_desc = RR#st_marry_room.love_desc, %% 爱情宣言
        love_desc_type = RR#st_marry_room.love_desc_type, %% 爱情宣言类型
        love_desc_time = RR#st_marry_room.love_desc_time, %% 爱情宣言有效时间
        my_look = RR#st_marry_room.my_look, %% 我的关注
        my_face = RR#st_marry_room.my_face, %% 我的粉丝
        is_first_photo = RR#st_marry_room.is_first_photo,
        pid = Pid,
        sid = Sid,
        online = 1
    }.

%% 下线处理
logout(Player) ->
    case ets:lookup(?ETS_MARRY_ROOM, Player#player.key) of
        [] -> skip;
        [Ets] ->
            NewEts = Ets#ets_marry_room{pid = null, sid = null, online = 0},
            ets:insert(?ETS_MARRY_ROOM, NewEts)
    end.

notice(Player, Type, Desc) ->
    Now = util:unixtime(),
    case get({marry_room, Type}) of
        Time when is_integer(Time) ->
            if
                Now - Time < 300 ->
                    8; %% cd时间
                true ->
                    Args = get_str(Type, Player),
                    notice_sys:add_notice(marry_room, [t_tv:pn(Player), Desc, Args]),
                    put({marry_room, Type}, Now),
                    1
            end;
        _ ->
            Args = get_str(Type, Player),
            notice_sys:add_notice(marry_room, [t_tv:pn(Player), Desc, Args]),
            put({marry_room, Type}, Now),
            1
    end.

get_str(Type, Player) ->
    case Type of
        0 ->
            S = ?T("【给TA送花】");
        1 ->
            S = ?T("【关注TA】")
    end,
    ?IF_ELSE(Type == 0, t_tv:sh(Player, S), t_tv:gz(Player, S)).

create_trem([Pkey], Player) ->
    %% 离开队伍
    if
        Player#player.team_key == 0 -> NewPlayer = Player;
        true ->
            case team_rpc:handle(22008, Player, {}) of
                ok -> NewPlayer = Player;
                {ok, team, NewPlayer} ->
                    scene_agent_dispatch:team_update(NewPlayer)
            end
    end,
    %% 发起组建队伍
    case team_rpc:handle(22004, NewPlayer, {Pkey}) of
        {ok, team, NewPlayer99} ->
            scene_agent_dispatch:team_update(NewPlayer99);
        _ ->
            NewPlayer99 = NewPlayer
    end,
    {ok, NewPlayer99}.

divorce(Pkey) when is_integer(Pkey) ->
    case ets:lookup(?ETS_MARRY_ROOM, Pkey) of
        [] ->
            skip;
        [Ets] ->
            ets:insert(?ETS_MARRY_ROOM, Ets#ets_marry_room{is_marry = 0})
    end;

divorce(#player{} = Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    NewSt = St#st_marry_room{is_marry = 0},
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewSt),
    marry_room_load:update(NewSt),
    ets:insert(?ETS_MARRY_ROOM, to_record(NewSt, Player)),
    case ets:lookup(?ETS_ONLINE, Player#player.marry#marry.couple_key) of
        [] ->
            divorce(Player#player.marry#marry.couple_key);
        [#ets_online{pid = Pid}] ->
            player:apply_state(async, Pid, {marry_room, divorce, []})
    end.

divorce(_, Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    NewSt = St#st_marry_room{is_marry = 0},
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewSt),
    marry_room_load:update(NewSt),
    ets:insert(?ETS_MARRY_ROOM, to_record(NewSt, Player)),
    {ok, Player}.

marry_update(#player{} = Player, MarryPkey) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    NewSt = St#st_marry_room{is_marry = 1},
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewSt),
    marry_room_load:update(NewSt),
    case ets:lookup(?ETS_MARRY_ROOM, Player#player.key) of
        [] ->
            skip;
        [Ets] ->
            ets:insert(?ETS_MARRY_ROOM, Ets#ets_marry_room{is_marry = 1})
    end,
    case ets:lookup(?ETS_ONLINE, MarryPkey) of
        [] ->
            case ets:lookup(?ETS_MARRY_ROOM, MarryPkey) of
                [] ->
                    skip;
                [Ets0] ->
                    ets:insert(?ETS_MARRY_ROOM, Ets0#ets_marry_room{is_marry = 1})
            end;
        [#ets_online{pid = Pid}] ->
            player:apply_state(async, Pid, {marry_room, marry_update, []})
    end;

marry_update(_, Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    NewSt = St#st_marry_room{is_marry = 1},
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewSt),
    marry_room_load:update(NewSt),
    case ets:lookup(?ETS_MARRY_ROOM, Player#player.key) of
        [] ->
            skip;
        [Ets] ->
            ets:insert(?ETS_MARRY_ROOM, Ets#ets_marry_room{is_marry = 1})
    end,
    {ok, Player}.


sort_list(List) ->
    F = fun(
        #ets_marry_room{
            online = Online1,
            love_desc_type = LoveDescType1,
            love_desc_time = LoveDescTime1,
            rp_val = RpVal1
        },
        #ets_marry_room{
            online = Online2,
            love_desc_type = LoveDescType2,
            love_desc_time = LoveDescTime2,
            rp_val = RpVal2
        }) ->
        Online1 > Online2 orelse
            Online1 == Online2 andalso LoveDescType1 > LoveDescType2 orelse
            Online1 == Online2 andalso LoveDescType1 == LoveDescType2 andalso RpVal1 > RpVal2 orelse
            Online1 == Online2 andalso LoveDescType1 == LoveDescType2 andalso RpVal1 == RpVal2 andalso LoveDescTime1 > LoveDescTime2

    end,
    NewList = lists:sort(F, List),
    F2 = fun(#ets_marry_room{pkey = Pkey}) -> Pkey end,
    lists:map(F2, NewList).

sort_list2(List) ->
    F = fun(
        #ets_marry_room{
            online = Online1,
            love_desc_type = LoveDescType1,
            love_desc_time = LoveDescTime1,
            rp_val = RpVal1
        },
        #ets_marry_room{
            online = Online2,
            love_desc_type = LoveDescType2,
            love_desc_time = LoveDescTime2,
            rp_val = RpVal2
        }) ->
        Online1 > Online2 orelse
            Online1 == Online2 andalso LoveDescType1 > LoveDescType2 orelse
            Online1 == Online2 andalso LoveDescType1 == LoveDescType2 andalso RpVal1 > RpVal2 orelse
            Online1 == Online2 andalso LoveDescType1 == LoveDescType2 andalso RpVal1 == RpVal2 andalso LoveDescTime1 > LoveDescTime2

    end,
    lists:sort(F, List).

sort_list3(_Pkey, List, FriendList, MarryPkey) ->
    F = fun(
        #ets_marry_room{
            pkey = Pkey1,
            online = Online1
        },
        #ets_marry_room{
            pkey = Pkey2,
            online = Online2
        }) ->
        Flag1 = ?IF_ELSE(lists:member(Pkey1, FriendList) == true, 1, 0),
        Flag2 = ?IF_ELSE(lists:member(Pkey2, FriendList) == true, 1, 0),
        QmVal = relation:get_friend_qmd(Pkey1),
        QmVa2 = relation:get_friend_qmd(Pkey2),
        Bool1 = ?IF_ELSE(Pkey1 == MarryPkey, 1, 0),
        Bool2 = ?IF_ELSE(Pkey2 == MarryPkey, 1, 0),
        Online1 > Online2 orelse
            Online1 == Online2 andalso Bool1 > Bool2 orelse
            Online1 == Online2 andalso Bool1 == Bool2 andalso Flag1 > Flag2 orelse
            Online1 == Online2 andalso Bool1 == Bool2 andalso Flag1 == Flag2 andalso QmVal > QmVa2
    end,
    lists:sort(F, List).

update_friend(St) ->
    #st_marry_room{my_look = MyLook, my_face = MyFace} = St,
    L = relation:get_friend_list(),
    NewMyLook = util:list_filter_repeat(L ++ MyLook),
    NewMyFace = util:list_filter_repeat(L ++ MyFace),
    NewSt = St#st_marry_room{my_look = NewMyLook, my_face = NewMyFace, rp_val = length(cacl_rp_val(NewMyFace))},
    NewSt.

add_friend(Pkey, Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    #st_marry_room{my_look = MyLook, my_face = MyFace} = St,
    L = [Pkey],
    NewMyLook = util:list_filter_repeat(L ++ MyLook),
    NewMyFace = util:list_filter_repeat(L ++ MyFace),
    NewSt = St#st_marry_room{my_look = NewMyLook, my_face = NewMyFace, rp_val = length(cacl_rp_val(NewMyFace))},
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewSt),
    marry_room_load:update(NewSt),
    ets:insert(?ETS_MARRY_ROOM, to_record(NewSt, Player)),
    MarryPkey = Player#player.marry#marry.couple_key,
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            case ets:lookup(?ETS_MARRY_ROOM, MarryPkey) of
                [] ->
                    skip;
                [Ets0] ->
                    #ets_marry_room{my_look = MyLook0, my_face = MyFace0} = Ets0,
                    NewMyLook0 = util:list_filter_repeat([Player#player.key | MyLook0]),
                    NewMyFace0 = util:list_filter_repeat([Player#player.key | MyFace0]),
                    NewEts0 = Ets0#ets_marry_room{my_look = NewMyLook0, my_face = NewMyFace0, rp_val = length(cacl_rp_val(NewMyFace0))},
                    ets:insert(?ETS_MARRY_ROOM, NewEts0),
                    marry_room_load:update(NewEts0)
            end;
        [#ets_online{pid = Pid}] ->
            player:apply_state(async, Pid, {?MODULE, add_ta_friend, Player#player.key})
    end.

add_ta_friend(Pkey, Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    #st_marry_room{my_look = MyLook, my_face = MyFace} = St,
    L = [Pkey],
    NewMyLook = util:list_filter_repeat(L ++ MyLook),
    NewMyFace = util:list_filter_repeat(L ++ MyFace),
    NewSt = St#st_marry_room{my_look = NewMyLook, my_face = NewMyFace, rp_val = length(cacl_rp_val(NewMyFace))},
    lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewSt),
    marry_room_load:update(NewSt),
    ets:insert(?ETS_MARRY_ROOM, to_record(NewSt, Player)),
    {ok, Player}.

update_photo(Player) ->
    Lv = data_menu_open:get(49),
    St = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    if
        Player#player.lv < Lv -> skip;
        St#st_marry_room.is_first_photo == 1 -> skip;
        true ->
            NewSt = St#st_marry_room{is_first_photo = 1},
            lib_dict:put(?PROC_STATUS_MARRY_ROOM, NewSt),
            marry_room_load:update(NewSt),
            GiveGoodsList = goods:make_give_goods_list(651, [{6605014, 1}]),
            goods:give_goods(Player, GiveGoodsList),
            activity:get_notice(Player, [133], true),
            ok
    end.

cacl_rp_val(List) ->
    F = fun(Pkey) ->
        case ets:lookup(?ETS_MARRY_ROOM, Pkey) of
            [] -> false;
            _ -> true
        end
    end,
    lists:filter(F, List).

get_notice_state(_Player) ->
    St = lib_dict:get(?PROC_STATUS_MARRY_ROOM),
    #st_marry_room{is_first_photo = IsFirstPhoto} = St,
    ?IF_ELSE(IsFirstPhoto == 1, 0, 1).