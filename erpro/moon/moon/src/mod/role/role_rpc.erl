%%----------------------------------------------------
%% 角色相关远程调用
%%
%% @author yeahoo2000@gmail.com
%%         wpf0208@jieyou.cn
%%----------------------------------------------------
-module(role_rpc).
-export([handle/3]).
-include("common.hrl").
%%
-include("role.hrl").
-include("attr.hrl").
-include("vip.hrl").
-include("assets.hrl").
-include("pos.hrl").
-include("gain.hrl").
-include("team.hrl").
-include("sns.hrl").
-include("guild.hrl").
-include("dungeon.hrl").

%% 角色登录流程，
%% 1.玩家从平台登录成功后，在URL中带上ticket跳转到相应游戏服;
%% 2.当客户端加载完毕后读取URL中的ticket，开始连接游戏服务器，并将ticket发送给服务器进行验证;
%% 3.如果Ticket失效，服务器返回验证失败信息，通知玩家再次从平台登录;
%% 4.如果验证通过则显示角色登录界面
%% 5.角色登录成功后，客户端同步所有角色相关数据(角色属性，任务数据，背包数据，BUFF数据等)
%% 6.客户端跟据角色属性的信息，配置相应的功能或UI
%% 7.客户端发起进入地图请求（相应信息可以在角色属性中查找）
%% 8.当地图加载完成后，开始监听服务端消息，进入正常游戏流程

%% 获取当前角色的初始化属性
handle(10000, {}, Role) ->
    case role_api:pack_proto_msg(10000, Role) of
        {error, _} -> {ok};
        Msg -> {reply, Msg}
    end;

%% 获取角色资产
handle(10002, {}, Role) ->
    case role_api:pack_proto_msg(10002, Role) of
        {error, _} -> {ok};
        Msg -> {reply, Msg}
    end;

%% 获取角色属性
handle(10003, {}, Role) ->
    case role_api:pack_proto_msg(10003, Role) of
        {error, _} -> {ok};
        Msg -> {reply, Msg}
    end;

%% 查看指定角色的属性
%handle(10010, {Id, SrvId}, R = #role{id = {Id, SrvId}}) ->
%    {reply, role_api:pack_proto_msg(10010, R)};
handle(10010, {Rid, SrvId}, _Role)->
    %% ?DEBUG("**************  查看角色ID ~p, SrvId: ~p", [Rid, SrvId]),
    case role:check_cd(lookup_role_10010, ?lookup_cd_time) of
        false ->
            ?DEBUG("************  IN CD"),
            {ok};
        true ->
            case role_api:c_lookup(by_id, {Rid, SrvId}, to_role) of
                {ok, _N, R} when is_record(R, role) ->
                    {reply, role_api:pack_proto_msg(10010, R)};
                _E ->
                    %%notice:alert(error, Role, ?MSGID(<<"对方不在线，查看失败">>)),
                    %%{ok}
                    case role_data:fetch_role(by_id, {Rid, SrvId}) of
                        {ok, R} ->
                            R1 = role_attr:calc_attr(R),
                            R2 = looks:calc(R1),
                            Ret = role_api:pack_proto_msg(10010, R2),
                            {reply, Ret};
                        {false, _Reason} ->
                            ?DEBUG("取离线玩家数据出错，原因: ~w", [_Reason]),
                            {ok}
                    end
            end
    end;

%% 进入/取消飞行骑乘状态
handle(10015, {}, Role) ->
    case role_api:check_fly(Role) of
        true ->
            do_handle_fly(Role);
        {false, Msg} ->
            {reply, {?false, Msg}}
    end;

%% 切换和平/杀戮模式
handle(10016, {}, #role{status = ?status_die}) -> {ok};
handle(10016, {}, #role{lev = Lev, mod = {?mod_peace, _}}) when Lev =< 30 ->
    {reply, {?false, ?mod_peace, ?MSGID(<<"你现在还没有保护自己的能力，请30级以上再使用此模式！">>)}};
handle(10016, {}, Role = #role{mod = {?mod_peace, _}}) ->
    NewRole = Role#role{mod = {?mod_pk, util:unixtime()}},
    map:role_update(NewRole),
    {reply, {?true, ?mod_pk, ?MSGID(<<"你现在还没有保护自己的能力，请30级以上再使用此模式！">>)}, NewRole};
handle(10016, _, _Role) -> {ok};

%% 复活 1:主城复活 2：附近复活 3：原地复活
%% 红名/被通缉复活 5：红名复活 6：通缉复活(听天由命) TODO:
handle(10019, _, #role{name = _Name, status = Status}) when Status =/= ?status_die ->
    ?DEBUG("角色[NAME:~s]没死亡，收到复活请求", [_Name]),
    {ok};
handle(10019, {_Type}, Role) ->
    Role1 = role_api:revive(Role),
    {ok, Role1};

%% 选择职业
handle(10020, {0}, Role = #role{career = ?career_xinshou}) ->
    Career = role_api:get_rand_career(),
    Gain = [#gain{label = item, val = [29022, 1, 1]}],
    case role_gain:do(Gain, Role) of
        {false, _} ->
            {reply, {?false, ?L(<<"背包已满，宿命之约礼包无法领取，请整理后重新转职">>), 0, 0}}; %% TODO:
        {ok, NewRole} ->
            case item:make(29022, 1, 1) of
                {ok, Items} ->
                    ItemMsg = notice:item3_to_inform(Items),
                    notice:inform(util:fbin(?L(<<"选择随机职业\n获得 ~s">>), [ItemMsg]));
                _ -> ignore
            end,
            handle(10020, {Career}, NewRole)
    end;
handle(10020, {Choose}, Role = #role{career = ?career_xinshou}) when Choose >= 1 andalso Choose =< 5 ->
    role:send_buff_begin(),
    NewRole = #role{vip = #vip{portrait_id = FaceId}} = role_api:choose_career(Choose, Role),
    role:send_buff_flush(),
    {reply, {?true, <<>>, Choose, FaceId}, NewRole};
handle(10020, {_}, _Role) ->
    {reply, {?false, <<>>, 0, 0}};

%% 传送飞天 1:消耗vip传送符 2:消耗飞天鞋 3:晶钻传送 4:免费传送(固定点) 5:任务传送(40级以下) 6:护送小孩
handle(10021, _, #role{status = ?status_die}) ->
    {ok};
handle(10021, _, #role{status = ?status_fight}) ->
    {ok};
handle(10021, _, #role{event = ?event_arena_match}) ->
    {reply, {?false, ?MSGID(<<"竞技中，不能使用飞仙传送">>)}}; %% 竞技
handle(10021, _, #role{event = ?event_arena_prepare}) ->
    {reply, {?false, ?MSGID(<<"竞技中，不能使用飞仙传送">>)}};
handle(10021, _, #role{event = ?event_top_fight_match}) ->
    {reply, {?false, ?MSGID(<<"竞技中，不能使用飞仙传送">>)}}; %% 竞技
handle(10021, _, #role{event = ?event_top_fight_prepare}) ->
    {reply, {?false, ?MSGID(<<"竞技中，不能使用飞仙传送">>)}};
handle(10021, _, #role{event = ?event_trade}) ->
    {reply, {?false, ?MSGID(<<"跑商中，不能使用飞仙传送">>)}}; %% 跑商
handle(10021, _, #role{event = ?event_escort}) ->
    {reply, {?false, ?MSGID(<<"护送中，不能使用飞仙传送">>)}}; %% 护送
handle(10021, _, #role{event = ?event_escort_child}) ->
    {reply, {?false, ?MSGID(<<"护送中，不能使用飞仙传送">>)}}; %% 护送
handle(10021, _, #role{event = ?event_dungeon}) ->
    {reply, {?false, ?MSGID(<<"副本中，不能使用飞仙传送">>)}}; %% 副本
handle(10021, {Type, BaseId, X, Y}, Role) ->
    case role:check_cd(role_trans_cd, 2) of
        false ->
            {ok};
        true ->
            do_handle(10021, {Type, BaseId, X, Y}, Role)
    end;

%% 修改角色名称
handle(10022, {Name}, Role = #role{name = RoleName}) ->
    [M | _] = "【",
    case util:to_list(RoleName) of
        [M | _] ->
            case util:check_name(Name) of
                {false, Msg} -> 
                    {reply, {?false, Msg}};
                ok ->
                    case role_api:is_name_used(Name) of
                        true ->
                            {reply, {?false, ?MSGID(<<"角色名已经存在">>)}};
                        _ ->
                            case db:get_one("select count(*) from role where name = ~s", [Name]) of
                                {error, _Err} ->
                                    {reply, {?false, ?MSGID(<<"访问数据库时发生异常，请稍后再重试">>)}};
                                {ok, Num} when Num >= 1 -> %% 已经存在同名的角色
                                    {reply, {?false, ?MSGID(<<"角色名已经存在">>)}};
                                {ok, _} ->
                                    NewRole = Role#role{name = Name},
                                    map:role_update(NewRole),
                                    friend:update_role_name(NewRole),
                                    {reply, {?true, <<>>}, NewRole}
                            end
                    end
            end;
        _ ->
            {reply, {?false, ?MSGID(<<"你的名称不可以修改">>)}}
    end;

%% 修改角色性别
handle(10023, {Flag1, Flag2}, Role = #role{name = RoleName, sex = Sex}) ->
    case check_can_change_sex(Role) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        ok ->
            case role_api:change_sex(Role) of
                {false, Msg} ->
                    {reply, {?false, Msg}};
                {ok, NewRole} ->
                    case Flag1 of
                        ?true ->
                            FriendList = friend:get_friend_list(),
                            Content = util:fbin(?L(<<"您的好友【~s】在经过深思熟虑后终于做出一个艰难的决定，在神医赛华佗处使用【阴阳造化丹】进行了性别转换，希望您能一如既往地支持ta，友谊万岁！">>), [RoleName]),
                            [mail_mgr:deliver({Rid, SrvId, Name}, {?L(<<"好友通知">>), Content, [], []}) ||
                                #friend{role_id = Rid, srv_id = SrvId, name = Name, type = Type} <- FriendList, Type =:= ?sns_friend_type_hy];
                        _ -> ignore
                    end,
                    case Flag2 of
                        ?true when Sex =:= ?male ->
                            notice:send(53, util:fbin(?L(<<"造化神奇，还我本源。~s隐隐觉得女儿身才是自己的本来面目，经过深思熟虑终于在赛华佗的帮助下进行了性别转换。">>), [notice:role_to_msg(Role)]));
                        ?true when Sex =:= ?female ->
                            notice:send(53, util:fbin(?L(<<"造化神奇，还我本源。~s隐隐觉得男儿身才是自己的本来面目，经过深思熟虑终于在赛华佗的帮助下进行了性别转换。">>), [notice:role_to_msg(Role)]));
                        _ -> ignore
                    end,
                    Nr = sworn:change_sex_title(NewRole),
                    {reply, {?true, <<>>}, Nr}
            end
    end;

handle(10024, {}, Role) ->
    L = storage_api:get_dress_to_change_sex(Role),
    {reply, {L}};

%% 转换阵营
handle(10025, {}, #role{status = Status, event = Event})
when Status =/= ?status_normal orelse Event =/= ?event_no ->
    {ok};
handle(10025, {}, #role{lev = Lev, realm = Realm}) when Lev < 50 ->
    {reply, {?false, Realm, ?MSGID(<<"未达到50级，不能更换阵营。">>)}};
handle(10025, {}, #role{guild = #role_guild{gid = Gid}, realm = Realm}) when Gid =/= 0 ->
    {reply, {?false, Realm, ?MSGID(<<"你当前所在阵营并没有连赢两场阵营战(圣地之争)，不能转入其他阵营。">>)}};
handle(10025, {}, #role{realm = Realm}) when Realm =:= ?role_realm_default ->
    {reply, {?false, Realm, ?MSGID(<<"没有阵营可以转换">>)}};
handle(10025, {}, Role = #role{realm = Realm}) ->
    case guild_war_api:check_realm_last_guild_war(Realm) of
        false ->
            {reply, {?false, Realm, ?MSGID(<<"你当前所在阵营并没有连赢两场阵营战(圣地之争)，不能转入其他阵营。">>)}};
        true ->
            case misc_mgr:get_realm_change_cnt() of
                Cnt when Cnt >= 10 ->
                    {reply, {?false, Realm, ?MSGID(<<"当天转阵营人数已达到10人上限。请下次再来。">>)}};
                _ ->
                    LL = [#loss{label = gold, val = pay:price(?MODULE, do_realm, null), msg = ?L(<<"晶钻不足">>)}],
                    case role_gain:do(LL, Role) of
                        {false, #loss{err_code = ErrCode, msg = Msg}} ->
                            {reply, {ErrCode, Realm, Msg}};
                        {ok, Role1} ->
                            notice:inform(?L(<<"转换阵营\n消耗 168晶钻">>)),
                            NewRealm = to_other_realm(Realm),
                            NewRole = Role1#role{realm = NewRealm},
                            misc_mgr:add_realm_change_cnt(),
                            map:role_update(NewRole),
                            notice:send(53, util:fbin(?L(<<"天下无不散之筵席，~s经过深思熟虑，决定转投阵营至【~s】！一时间风起云涌，仿佛预示着更加激烈的阵营战的来临。">>), [notice:role_to_msg(Role), to_realm_str(NewRealm)])),
                            {reply, {?true, NewRealm, ?L(<<"转换阵营成功，现在可以选择加入本阵营的帮会">>)}, NewRole}
                    end
            end
    end;

%% 获取阵营的帮战连赢次数
handle(10026, {}, #role{realm = Realm})
when Realm =:= ?role_realm_a orelse Realm =:= ?role_realm_b ->
    case role:check_cd(role_10026, 2) of
        true ->
            {Cnt1, Cnt2} = guild_war_api:get_last_guild_war_win_cnt(Realm),
            Cnt = misc_mgr:get_realm_change_cnt(),
            {reply, {Cnt1, Cnt2, 10-Cnt}};
        false ->
            {ok}
    end;

%% "我要变强"的数据获取
handle(10030, {}, Role) ->
    case role:check_cd(proto_10030, 2) of
        true ->
            FightNum = rank:fight_rank(Role), %% 等级排名
            LevNum = rank:lev_rank(Role), %% 等级排名
            ChannelScore = rank:get_channel_score(Role),
            {reply, {LevNum, FightNum, ChannelScore, 0, 0}};
        _ ->
            {reply, {0, 0, 0, 0, 0}}
    end;

%% 使用改名卡改名
handle(10031, {NewName}, Role) ->
    case util:check_name(NewName) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        _ ->
            case role_api:rename(Role, NewName) of
                {ok, NewRole} ->
                    {reply, {?true, ?L(<<"改名成功">>)}, NewRole};
                {false, Msg} when is_bitstring(Msg) ->
                    {reply, {?false, Msg}};
                _ ->
                    {reply, {?false, ?L(<<"操作失败">>)}}
            end
    end;

%% 查看改名记录
handle(10032, {Page}, _Role) ->
    PageSize = 10,  %% 每页显示多少条
    Num0 = ets:info(ets_role_name_used, size),
    Num = max(1, Num0),
    TotalPage = util:ceil(Num / PageSize),
    Page = min(TotalPage, max(1, Page)),
    List = lists:sublist(ets:tab2list(ets_role_name_used), (Page - 1) * PageSize + 1, PageSize),
    F = fun(#role_name_used{id = {Id, SrvId}, new_name = NewName, name = OldName, sex = Sex, career = Career, realm = Realm, vip = Vip, ctime = Ctime}) ->
            {Id, SrvId, OldName, NewName, Sex, Career, Realm, Vip, Ctime}
    end,
    Data = {Page, TotalPage, [F(N) || N <- List]},
    {reply, Data};

%% 容错匹配
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% -------------------------------------------------------
%% 内部处理
%% -------------------------------------------------------
%% 传送处理
do_handle(10021, {Type, BaseId, X, Y}, Role = #role{event = ?event_guild})
when BaseId < 20000 -> %% 帮会领地传送出去，限制几个主要城市
    NewRole = guild_area:moved(Role),
    do_handle({Type, BaseId, X, Y}, NewRole#role{event = ?event_no});
do_handle(10021, {Type, BaseId, X, Y}, Role = #role{event = ?event_guild})
when BaseId =:= 31001 orelse BaseId =:= 31002 -> %% 帮会领地内传
    do_handle({Type, BaseId, X, Y}, Role);
do_handle(10021, _, #role{event = ?event_guild}) ->
    {reply, {?false, ?MSGID(<<"帮会领地中，不能使用飞仙传送">>)}}; %% 帮会
do_handle(10021, {Type, MapBaseId, X, Y}, Role = #role{event = ?event_guild_war, team = #role_team{is_leader = ?false, follow = ?false},
        pos = #pos{map_base_id = MapBaseId}}) -> %% 帮战同地图内允许队员vip传送-2012/04/24
    do_handle({Type, MapBaseId, X, Y}, Role);
do_handle(10021, _, #role{event = Event}) when Event =/= ?event_no ->
    %% TODO: 如果此处不屏蔽，则要在飞离一个活动地图时，将活动状态恢复为正常
    {reply, {?false, ?MSGID(<<"活动中不能使用飞仙传送">>)}};
do_handle(10021, {Type, BaseId, X, Y}, Role = #role{action = Action})
when Action >= ?action_sit_both andalso Action =< ?action_sit_lovers ->
    NewRole = sit:handle_sit(?action_no, Role), %% 只取消双修状态
    do_handle({Type, BaseId, X, Y}, NewRole);
do_handle(10021, ToPos, Role) ->
    do_handle(ToPos, Role).

do_handle({Type, BaseId, X, Y}, Role) ->
    role:send_buff_begin(),
    case trans(Type, {BaseId, X, Y}, Role) of
        {false, Msg} ->
            role:send_buff_clean(),
            {reply, {?false, Msg}};
        {inform, Info} ->
            role:send_buff_clean(),
            {reply, Info};
        {ok, NewRole} ->
            role:send_buff_flush(),
            {reply, {?true, <<>>}, NewRole}
    end.
trans(1, ToPos, Role) ->
    role_api:trans_hook({normal, vip}, ToPos, Role);
trans(2, ToPos, Role) ->
    case role_api:trans_hook({normal, item}, ToPos, Role) of
        {false, inform, Msg} -> {inform, {2, Msg}}; %% 通知客户端弹窗消费晶钻
        {false, Msg} -> {false, Msg};
        {ok, NewRole} -> {ok, NewRole}
    end;
trans(3, ToPos, Role) ->
    role_api:trans_hook({normal, gold}, ToPos, Role);
trans(4, _ToPos, Role = #role{pos = #pos{map_base_id = MapBaseId}})
when MapBaseId =:= 10001 orelse MapBaseId =:= 10002 -> %% 护送任务npc位置固定
    role_api:trans_hook(free, {10003, 6060, 2820}, Role);
trans(6, _ToPos, Role = #role{pos = #pos{map_base_id = MapBaseId}})
when MapBaseId =:= 10001 orelse MapBaseId =:= 10002 -> %% 护送小屁孩任务npc位置固定
    role_api:trans_hook(free, {10003, 6060, 2820}, Role);
trans(5, ToPos = {BaseId, X, Y}, Role = #role{lev = Lev})
when Lev < 42
andalso (
    (BaseId =:= 10003 andalso X =:= 480 andalso Y =:= 690)
    orelse (BaseId =:= 10003 andalso X =:= 720 andalso Y =:= 1200)
    orelse (BaseId =:= 10004 andalso X =:= 540 andalso Y =:= 3810)
    orelse (BaseId =:= 10004 andalso X =:= 4380 andalso Y =:= 5040))
    -> %% 42级以下任务免费传
    role_api:trans_hook(free, ToPos, Role);
trans(10, _, Role) ->
    {ok, Role};
trans(free, ToPos, Role) ->
    role_api:trans_hook(free, ToPos, Role);
trans(_, _, _Role) ->
    {false, ?MSGID(<<"未知的传送方式">>)}.

%% 处理飞行
do_handle_fly(Role = #role{ride = ?ride_no}) ->
    case fly_api:check_can_fly(Role) of
        false ->
            {reply, {?false, ?MSGID(<<"您需要装备一双翅膀(需要强化10或进阶6阶)或者一只飞行坐骑，才能自由飞仙">>)}};
        true ->
            NewRole = role_listener:acc_event(Role#role{ride = ?ride_fly}, {101, 1}),
            team:update_ride(NewRole),
            map:role_update(NewRole),
            {reply, {?true, <<>>}, NewRole}
    end;
do_handle_fly(Role = #role{ride = ?ride_fly, pos = #pos{map_base_id = MapBaseId, x = X, y = Y}}) ->
     NewRole = Role#role{ride = ?ride_no},
     case map_mgr:is_blocked(MapBaseId, X, Y) of
         true ->
             {reply, {?false, ?MSGID(<<"当前区域不能降落">>)}};
         _ ->
             team:update_ride(NewRole),
             map:role_update(NewRole),
             {reply, {?true, <<>>}, NewRole}
     end;
 do_handle_fly(_) ->
     {reply, {?false, ?MSGID(<<"暂时不能切换飞行状态">>)}}.

%% 获取对立阵营值
to_other_realm(?role_realm_a) -> ?role_realm_b;
to_other_realm(?role_realm_b) -> ?role_realm_a;
to_other_realm(Realm) -> Realm.

%% 获取阵营的显示string
to_realm_str(?role_realm_a) -> ?L(<<"{str,蓬莱,#00FF00}">>);
to_realm_str(?role_realm_b) -> ?L(<<"{str,逍遥,#0088FF}">>);
to_realm_str(_) -> ?L(<<"{str,无阵营,#ff0000}">>).

%% 判断是否可以转换性别
check_can_change_sex(#role{id = _RoleId}) ->
    ok.

