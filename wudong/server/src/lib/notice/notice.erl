%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十二月 2015 下午8:40
%%%-------------------------------------------------------------------
-module(notice).
-author("fengzhenlin").
-include("common.hrl").
-include("notice.hrl").
-include("server.hrl").
-include("new_shop.hrl").
%% API
-export([
    use_bugle/4,   %%使用喇叭
    get_center_notice/0,
    get_next_show/2,
    add_sys_notice/1, %%增加系统公告  给各功能模块调用
    add_sys_notice/2,  %%指定系统公告位置
    add_sys_notice_scene/3,%%指定场景发送公告
    add_sys_notice_scene_copy/4,%%指定场景发送公告
    add_sys_notice_guild/3,%%工会公告
    bugle2kf/2,
    kf2bugle/1

]).

%%使用喇叭
use_bugle(Player, BugleType, Content, IsAuto) ->
    BugleId =
        case BugleType of
            1 -> 20510;
            2 -> 20520
        end,
            case util:check_keyword_base(Content) of
                true ->
                    {3, Player};
                false ->
                    case check_bugle_use(Content,Player, BugleId, IsAuto) of
                        {false, Err} ->
                            {Err, Player};
                        NewPlayer ->
                            [Key, Name, _GM, Title, Vip, Career, _Avatar,_Dvip] = chat:get_player_chat_info(Player),
                            Now = util:unixtime(),
                            Sn = config:get_server_num(),
                            Data = {BugleType, Content, Sn, Key, Name, Title, Vip, Now, Career},
                            case BugleType of
                                1 ->
                                    ?CAST(notice_proc:get_notice_pid(), {send_bugle, Data});
                                2 ->
                                    ?CAST(notice_proc:get_notice_pid(), {send_bugle, Data}),
                                    %%区域跨服喇叭
                                    cross_area:apply(notice, bugle2kf, [Data, node()])
                            end,
                            {1, NewPlayer}
                    end
    end.

check_bugle_use(Content,Player, BugleId, IsAuto) ->
    case goods:subtract_good(Player, [{BugleId, 1}], 0) of
        {false, _Res} ->
            if IsAuto == 0 ->
                goods_util:client_popup_goods_not_enough(Player, BugleId, 1, 187),
                {false, 2};
                true ->
                    case data_new_shop:get_by_goods_id(BugleId) of
                        [] ->
                            goods_util:client_popup_goods_not_enough(Player, BugleId, 1, 187),
                            {false, 2};
                        Shop ->
                            case money:is_enough(Player, Shop#base_shop.gold, gold) of
                                true ->
                                    case chat:check_send_content(Player#player.vip_lv,Content) of
                                        false -> {false,3};
                                        true -> money:add_no_bind_gold(Player, -Shop#base_shop.gold, 187, BugleId, 1)
                                    end;
                                false ->
                                    {false, 4}
                            end
                    end
            end;
        _ ->
            Player
    end.


%%跨服喇叭
bugle2kf(Data, NodeS) ->
    [center:apply(Node, notice, kf2bugle, [Data]) || Node <- center:get_nodes(), Node /= NodeS].

%%跨服喇叭到本地
kf2bugle(Data) ->
    ?CAST(notice_proc:get_notice_pid(), {send_bugle, Data}),
    ok.

%%增加系统广播
%%Content string
%%ShowPosList 1主界面左边,2世界聊天频道,3主界面上边,4主界面中间 例如：normal/[2,3]
%%normal 代表 [2,4]
add_sys_notice(Content) ->
    add_sys_notice(Content, 0).
add_sys_notice(Content, NoticeId) ->
    P = case lib_dict:is_role_process() of
            true -> self();
            false -> 0
        end,
    spawn(fun() -> add_sys_notice_helper(P, Content, NoticeId, 0, 0, 0) end).
add_sys_notice_guild(Content, NoticeId, Gkey) ->
    spawn(fun() -> add_sys_notice_helper(0, Content, NoticeId, Gkey, 0, 0) end).
add_sys_notice_scene(Content, NoticeId, Scene) ->
    spawn(fun() -> add_sys_notice_helper(0, Content, NoticeId, 0, Scene, 0) end).
add_sys_notice_scene_copy(Content, NoticeId, Scene, Copy) ->
    spawn(fun() -> add_sys_notice_helper(0, Content, NoticeId, 0, Scene, Copy) end).
add_sys_notice_helper(P, Content, NoticeId, Gkey, ToScene, ToCopy) ->
    BaseNoticeSys = data_notice_sys:get(NoticeId),
    ShowPosList =
        case BaseNoticeSys of
            [] -> [2, 4];
            _ -> BaseNoticeSys#base_notice.show_pos
        end,
    [SendToScene, Copy] =
        case BaseNoticeSys of  %%发送到玩家当前场景，需要获取玩家当前场景
            [] -> [[], 0];
            _ ->
                case ToScene =/= 0 of
                    true -> [ToScene, ToCopy];
                    false ->
                        case lists:member(BaseNoticeSys#base_notice.send_type, [2, 6]) andalso is_pid(P) of
                            true -> ?CALL(P, {get_player_info, scene_copy});
                            false -> [[], 0]
                        end
                end
        end,
    GuildKey =
        if Gkey /= 0 -> Gkey;
            true ->
                case BaseNoticeSys of
                    [] -> 0;
                    _ ->
                        case BaseNoticeSys#base_notice.send_type == 5 of
                            true -> ?CALL(P, {get_player_info, guildkey});
                            false -> 0
                        end
                end
        end,
    gen_server:cast(notice_proc:get_notice_pid(), {add_sys_notice, Content, NoticeId, ShowPosList, SendToScene, Copy, GuildKey}).


%%http请求中心服获取广播列表
get_center_notice() ->
    Sn = config:get_server_num(),
    OpenDay = config:get_open_days(),
    Url = lists:concat([config:get_api_url(), "/broadcast.php"]),
%%     Url = "http://www.arpgrpc.com/broadcast.php",
    PostData = io_lib:format("sn=~p&openday=~p", [Sn, OpenDay]),
    PostData2 = unicode:characters_to_list(PostData, unicode),
    case httpc:request(post, {Url, [], "application/x-www-form-urlencoded", PostData2}, [{timeout,2000}], []) of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, JSONlist}, _} ->
                    %%?PRINT("JSON:~p~n",[JSONlist]),
                    case lists:keyfind("ret", 1, JSONlist) of
                        {_, 1} -> 1;
                        {_, {obj, List}} ->
                            L = make_notice_record(List, []),
%%                             io:format("####L ~p~n",[L]),
                            L;
                        {_, []} ->
                            [];
                        _ ->
                            ?ERR("get_center_notice err bad json ~n"),
                            []
                    end;
                _ ->
%%                     ?ERR("get_center_notice err bad decode ~p ~n",[Body]),
                    []
            end;
        _ ->
%%             ?ERR("get_center_notice err ~n"),
            []
    end.

make_notice_record([], L) -> L;
make_notice_record([JSONlist | Tail], AccL) ->
    {_IdStr, {obj, JSONlist1}} = JSONlist,
    case lists:keyfind("id", 1, JSONlist1) of
        {_, Id} ->
            case lists:keyfind("content", 1, JSONlist1) of
                {_, Content} ->
                    case lists:keyfind("one_time", 1, JSONlist1) of
                        {_, OneTime} ->
                            case lists:keyfind("show_pos", 1, JSONlist1) of
                                {_, ShowPosList} ->
                                    Now = util:unixtime(),
                                    ShowPosList1 = [util:to_integer(Pos) || Pos <- ShowPosList],
                                    Notice = #notice{
                                        id = Id,
                                        type = 1,
                                        content = Content,
                                        one_time = OneTime,
                                        showposlist = ShowPosList1,
                                        next_time = Now + OneTime
                                    },
                                    make_notice_record(Tail, [Notice | AccL])
                            end;
                        _ ->
                            make_notice_record(Tail, AccL)
                    end;
                _ ->
                    make_notice_record(Tail, AccL)
            end;
        _ ->
            make_notice_record(Tail, AccL)
    end.

%%获取下次播放内容
get_next_show(NoticeList, SysNoticeList) ->
    %%广播位置
    ShowPosList = get_can_show_pos(),
    %%获取系统广播 系统广播优先
    SortSysNoticeList = lists:keysort(#notice.next_time, SysNoticeList),
    {NewPosList, ShowSysL, NewSysL} = get_sys_notice_helper(SortSysNoticeList, ShowPosList, [], []),
    %%获取运营广播
    Now = util:unixtime(),
    {NewPosList1, ShowL, NewL} = get_notice_helper(Now, NoticeList, NewPosList, [], []),
    %%位置3做特殊处理
    cd_pos_3(ShowPosList, NewPosList1),
    {ShowSysL ++ ShowL, NewL, NewSysL}.
get_sys_notice_helper([], AccPos, AccNotice, AccLeaveNotice) ->
    {AccPos, AccNotice, lists:reverse(AccLeaveNotice)};
get_sys_notice_helper([Notice | Tail], AccPos, AccNotice, AccLeaveNotice) ->
    #notice{
        showposlist = PosList
    } = Notice,
    case check_pos(PosList, AccPos) of
        false -> get_sys_notice_helper(Tail, AccPos, AccNotice, [Notice | AccLeaveNotice]);
        {ok, NewAccPos} ->
            get_sys_notice_helper(Tail, NewAccPos, [Notice | AccNotice], AccLeaveNotice)
    end.
get_notice_helper(_Now, [], AccPos, AccNotice, AccNewNotice) ->
    {AccPos, AccNotice, lists:keysort(#notice.next_time, AccNewNotice)};
get_notice_helper(Now, [Notice | Tail], AccPos, AccNotice, AccNewNotice) ->
    #notice{
        next_time = ShowTime,
        showposlist = PosList
    } = Notice,
    case Now >= ShowTime of
        false -> get_notice_helper(Now, Tail, AccPos, AccNotice, [Notice | AccNewNotice]);
        true ->
            case check_pos(PosList, AccPos) of
                false -> get_notice_helper(Now, Tail, AccPos, AccNotice, [Notice | AccNewNotice]);
                {ok, NewAccPos} ->
                    NewNotice = Notice#notice{
                        next_time = Now + Notice#notice.one_time
                    },
                    get_notice_helper(Now, Tail, NewAccPos, [Notice | AccNotice], [NewNotice | AccNewNotice])
            end
    end.

%%检查播放位置是否空闲
check_pos([], AccPos) -> {ok, AccPos};
check_pos([Pos | Tail], AccPos) ->
    case lists:member(Pos, AccPos) of
        false -> false;
        true -> check_pos(Tail, lists:delete(Pos, AccPos))
    end.

%%给显示位置3加CD
cd_pos_3(OldPosList, NewPosList) ->
    case lists:member(3, OldPosList) andalso (not lists:member(3, NewPosList)) of
        true ->
            %put(notice_pos_3_cd, util:unixtime() + 20);
            ok;
        false -> skip
    end.
%%获取可显示位置
get_can_show_pos() ->
    PosList = [1, 2, 3, 4, 5, 6, 7, 8],
    case get(notice_pos_3_cd) of
        undefined -> PosList;
        Time ->
            case util:unixtime() > Time of
                true -> PosList;
                false -> lists:delete(3, PosList)
            end
    end.


