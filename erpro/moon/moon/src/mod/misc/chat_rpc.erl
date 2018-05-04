%----------------------------------------------------
%%  聊天相关远程调用
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(chat_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("sns.hrl").
-include("role_online.hrl").
-include("chat_rpc.hrl").
-include("vip.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("guild.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("pet.hrl").
-include("hall.hrl").

-define(limitlength, 240).      %% 最长80个汉字

-define(limit_time, 691200).
%% 获取聊天限制信息
handle(10901, {}, _Role) ->
    OpenTime = sys_env:get(srv_open_time),
    case OpenTime of
        T when is_integer(T) ->
            case util:unixtime() > (T + ?limit_time) of
                true -> %% 开服8天后
                    {reply, {OpenTime, ?true}};
                false ->
                    {reply, {OpenTime, ?false}}
            end;
        _ -> {reply, {OpenTime, ?false}}
    end;

%% GM世界
handle(10910, {?chat_world, Msg}, Role = #role{label = ?role_label_gm, realm = Realm, id = {Rid, SrvId}, name = Name, sex = Sex, vip = #vip{type = Vip}}) ->
    role_group:pack_cast(world, 10930, {?chat_world, 57, Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}),
    {ok};

%% GM场景
handle(10910, {?chat_map, Msg}, Role = #role{label = ?role_label_gm, realm = Realm, id = {Rid, SrvId}, name = Name, sex = Sex, pos = #pos{map_pid = MapPid}, vip = #vip{type = Vip}}) ->
    map:pack_send_to_all(MapPid, 10930, {?chat_map, 57, Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}),
    {ok};

%% GM组队
handle(10910, {?chat_team, Msg}, Role = #role{label = ?role_label_gm, realm = Realm, id = {Rid, SrvId}, name = Name, sex = Sex, team_pid = TeamPid, vip = #vip{type = Vip}}) ->
    team:chat(TeamPid, 10930, {?chat_team, 57, Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}),
    {ok};

%% GM好友
handle(10910, {?chat_friend, Msg}, Role = #role{label = ?role_label_gm, realm = Realm, id = {Rid, SrvId}, name = Name, sex = Sex, link = #link{conn_pid = ConnPid}, vip = #vip{type = Vip}}) ->
    sys_conn:pack_send(ConnPid, 10930, {?chat_friend, 57, Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}),
    FriendList = friend:get_friend_list(),
    gm_chat_to_friends(FriendList, {Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}),
    {ok};

%% GM帮会频道聊天
handle(10910, {?chat_guild, Msg}, Role = #role{label = ?role_label_gm, realm = Realm, id = {Rid, SrvId}, name = Name, sex = Sex, guild = #role_guild{gid = Gid}, vip = #vip{type = Vip}}) ->
    case Gid =/= 0 of
        true -> gm_guild_chat(guild_mem:members(Role), {Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg});
        false -> ignore
    end,
    {ok};

%% GM传音
handle(10910, {?chat_hearsay, Msg}, Role = #role{label = ?role_label_gm, realm = Realm, id = {Rid, SrvId}, name = Name, sex = Sex, vip = #vip{type = Vip}}) ->
    role_group:pack_cast(world, 10930, {?chat_hearsay, 57, Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}),
    {ok};

%% GM 组队招募
handle(10910, {?chat_world_team, Msg}, Role = #role{label = ?role_label_gm, realm = Realm, id = {Rid, SrvId}, name = Name, sex = Sex, team_pid = TeamPid, vip = #vip{type = Vip}}) ->
    role_group:pack_cast(world, 10930, {?chat_world_team, 57, Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}),
    team:chat(TeamPid, 10930, {?chat_world_team, 57, Rid, SrvId, Name, Sex, Vip, [?role_label_gm, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}),
    {ok};

%% ---------------------------------------------------------------------------------------------------------

handle(10910, {Channel, Msg}, Role = #role{id = {Rid, SrvId}, name = Name, label = Label, realm = Realm, sex = Sex, vip = #vip{type = Vip}, link = #link{conn_pid = ConnPid}, lock_info = LockInfo})
when LockInfo =:= 2 orelse LockInfo =:= 3 ->
    case not(is_frequency(world)) andalso is_valid_length(Msg) of
        true -> 
            FaceGroups = chat:get_face_group(Role),
            case gm_rpc:check_role_lock(silent, Role) of
                callback ->
                    sys_conn:pack_send(ConnPid, 10910, {Channel, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg}),
                    {ok};
                ok ->
                    sys_conn:pack_send(ConnPid, 10931, {51, ?L(<<"你已经被禁言,无法发言">>), []}),
                    {ok};
                {ok, NewRole} -> 
                    sys_conn:pack_send(ConnPid, 10910, {Channel, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg}),
                    {ok, NewRole};
                false ->
                    sys_conn:pack_send(ConnPid, 10931, {51, ?L(<<"你已经被禁言,无法发言">>), []}),
                    {ok}
            end;
        false -> {ok} 
    end;

%% 世界频道聊天
handle(10910, {?chat_world, Msg}, Role) ->
    case not(is_frequency(world)) andalso is_valid_length(Msg) of
        true ->
            %%测试系统消息与传闻用，之后会删除
            % role_group:pack_cast(world, 10932, {6, 0, <<"你发了一条世界消息，没有包含禁用字符吧^_^">>}),
            % sys_conn:pack_send(ConnPid, 10932, {7, 0, <<"不考试也要信春哥！！">>}),
            chat:ban(world, Msg, Role);
        false ->
            ignore
    end,
    {ok};

%% 地图频道聊天
handle(10910, {?chat_map, Msg}, Role) ->
    case not(is_frequency(map)) andalso is_valid_length(Msg) of
        true ->
            chat:ban(scene, Msg, Role);
        false ->
            ignore
    end,
    {ok};

%% 帮会频道聊天 TODO
handle(10910, {?chat_guild, Msg}, Role = #role{id = {Rid, SrvId}, name = Name, sex = Sex, guild = #role_guild{gid = Gid}, vip = #vip{type = Vip}}) ->
    ?DEBUG("帮会频道聊天:~p~n",[Msg]),
    case not(is_frequency(guild)) andalso is_valid_length(Msg) andalso Gid =/= 0 of
        true ->
            % FaceGroups = chat:get_face_group(Role),
            guild_chat(guild_mem:members(Role), {Rid, SrvId, Name, Sex, Vip, [], [], Msg});
        false ->
            ignore
    end,
    {ok};

%% 组队频道聊天
handle(10910, {?chat_team, Msg}, Role = #role{id = {Rid, SrvId}, name = Name, label = Label, realm = Realm, sex = Sex, team_pid = TeamPid, vip = #vip{type = Vip}}) ->
    case not(is_frequency(team)) andalso is_valid_length(Msg) of
        true ->
            FaceGroups = chat:get_face_group(Role),
            team:chat(TeamPid, 10910, {?chat_team, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg});
        false ->
            ignore
    end,
    {ok};

%% 好友频道聊天 
handle(10910, {?chat_friend, Msg}, Role = #role{id = {Rid, SrvId}, name = Name, label = Label, realm = Realm, sex = Sex, link = #link{conn_pid = ConnPid}, vip = #vip{type = Vip}}) ->
    case not(is_frequency(friend)) andalso is_valid_length(Msg) of
        true ->
            FaceGroups = chat:get_face_group(Role),
            sys_conn:pack_send(ConnPid, 10910, {?chat_friend, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg}),
            FriendList = friend:get_friend_list(),
            chat_to_friends(FriendList, {Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg});
        false ->
            ignore
    end,
    {ok};

%% 传音频道聊天
handle(10910, {?chat_hearsay, Msg}, Role = #role{id = {Rid, SrvId}, name = Name, label = Label, realm = Realm, sex = Sex, vip = #vip{type = Vip}}) ->
    case is_valid_length(Msg) of
        false -> {ok};
        true ->
            FaceGroups = chat:get_face_group(Role),
            case vip:use(hearsay, Role) of %% 优先扣除VIP传音
                {ok, NewRole} ->
                    vip:push_assets(NewRole),
                    role_group:pack_cast(world, 10910, {?chat_hearsay, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg}),
                    {ok, NewRole};
                false ->
                    L = #loss{label = hearsay, val = 1},
                    case role_gain:do(L, Role) of
                        {ok, NewRole} ->
                            role_group:pack_cast(world, 10910, {?chat_hearsay, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg}),
                            {ok, NewRole};
                        {false, _} ->
                            L1 = #loss{label = item, val = [33010, 0, 1]},
                            case role_gain:do([L1], Role) of
                                {ok, NewRole} ->
                                    role_group:pack_cast(world, 10910, {?chat_hearsay, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg}),
                                    {ok, NewRole};
                                _ ->
                                    role_group:pack_cast(world, 10910, {?chat_hearsay, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, <<>>}),
                                    {ok}
                            end
                    end
            end
    end;

%% 组队招募
handle(10910, {?chat_world_team, Msg}, Role = #role{id = {Rid, SrvId}, name = Name, label = Label, realm = Realm, sex = Sex, vip = #vip{type = Vip}}) ->
    case not(is_frequency(world)) andalso is_valid_length(Msg) of
        true ->
            FaceGroups = chat:get_face_group(Role),
            role_group:pack_cast(world, 10910, {?chat_world_team, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, Msg});
        false ->
            ignore
    end,
    {ok};

%% 跨服群组消息 %% TODO: 未限制（仅在跨服仙道会活动中有效）
handle(10910, {?chat_kuafu_hy, _Msg}, Role = #role{id = {Rid, SrvId}, name = Name, label = Label, realm = Realm, sex = Sex, vip = #vip{type = Vip}, link = #link{conn_pid = ConnPid}}) ->
    FaceGroups = chat:get_face_group(Role),
    sys_conn:pack_send(ConnPid, 10910, {?chat_kuafu_hy, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], FaceGroups, ?L(<<"跨服聊天室技术维护中，暂时关闭，请等待公告通知">>)}),
    {ok};
    %% case role:check_cd(chat_kuafu_group, 10) andalso is_valid_length(Msg) of
    %%     true ->
    %%         case friend:check_kuafu_chat() of
    %%             false -> {ok};
    %%             true ->
    %%                 case friend:chat_kuafu_loss(Role) of
    %%                     {false, _Msg} -> {ok};
    %%                     {ok, NewRole} ->
    %%                         center:cast(c_proxy, chat_kuafu, [sys_env:get(platform), {?chat_kuafu_hy, Rid, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm), chat:get_chat_frame(Role)], Msg}]),
    %%                         {ok, NewRole}
    %%                 end
    %%         end;
    %%     false ->
    %%         {ok}
    %% end;

handle(10910, {?chat_hall_room, Msg}, Role) ->
    hall:chat(Role, Msg),
    {ok};

%% 私聊信息
handle(10920, {Rid, SrvId, Msg}, Role = #role{id = {Srid, SsrvId}, name = Name, sex = Sex, link = #link{conn_pid = ConnPid}})
when Rid =/= Srid ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, #role.pid) of %%检查是否在线
        {ok, _, Pid} when is_pid(Pid)  ->
            case is_valid_length(Msg) of
                true ->
                    Flag = 
                        case is_sns_circle(Rid) of     %%首先check下是不是黑名单
                            {true,#friend{type = ?sns_friend_type_hmd}} ->
                                notice:alert(error, ConnPid, ?MSGID(<<"已加入黑名单，不能聊天">>)),
                                ignore;
                            {false,_} -> %%陌生人聊天
                                friend:update_friend_list(msr, {Rid, SrvId}, Role), %%更新陌生人列表
                                ok;
                            {true,_} -> %%好友，更新好友最后一次聊天时间
                                ok
                        end,
                    Msg1 = forbid_word_filter:filter(Msg),
                    % Msg1 = Msg,
                    case Flag of
                        ok ->
                            %%发给自己的消息
                            case ets:lookup(shield_private_chat, Pid) of 
                                [] ->
                                    case role:apply(sync, Pid, {friend, sync_is_sns_circle, [Srid]}) of
                                        {ok, notfriend} ->
                                            ?DEBUG("----notfriend----"),
                                            sys_conn:pack_send(ConnPid, 10920, {Srid, SsrvId, Name, Sex, [], [], Msg1});
                                        {ok, _} ->
                                            ?DEBUG("----friend----"),
                                            sys_conn:pack_send(ConnPid, 10920, {Srid, SsrvId, Name, Sex, [], [], Msg1}),
                                            role:pack_send(Pid, 10920, {Srid, SsrvId, Name, Sex, [], [], Msg1})
                                    end;
                                _ ->
                                    sys_conn:pack_send(ConnPid, 10920, {Srid, SsrvId, Name, Sex, [], [], Msg1}),
                                    sys_conn:pack_send(ConnPid, 10932, {6, 0, ?MSGID(<<"对方屏蔽了私聊功能">>)})
                            end;
                        _ -> ignore
                    end;
                false ->
                    ignore
            end,
            {ok};
        _ ->
            notice:alert(error, ConnPid, ?MSGID(<<"该玩家不在线，暂时无法使用私聊">>)),
            {ok}
    end;


%% 获取聊天对象的信息 TODO 缺帮会名字，个性签名
handle(10921, RoleId, #role{id = RoleId}) -> {ok};
handle(10921, {Rid, SrvId}, #role{id = {_Srid, SsrvId}, event = Event, link = #link{conn_pid = ConnPid}}) ->
    case role_api:c_lookup(by_id, {Rid, SrvId}, [#role.name, #role.lev, #role.vip, #role.guild, #role.sns]) of
        {ok, Node, [Name, Lev, #vip{type = Vip, portrait_id = Icon}, #role_guild{name = Gname}, #sns{signature = Sign}]}
        when Node =:= node() ->
            sys_conn:pack_send(ConnPid, 10921, {?chat_online, ?chat_circle, Rid, SrvId, Name, Lev, Gname, Icon, Vip, Sign});
        {ok, _Node, [Name, Lev, #vip{type = Vip, portrait_id = Icon}, #role_guild{name = Gname}, #sns{signature = Sign}]} ->
            case is_sns_circle(Rid) of
                {true, _} ->
                    sys_conn:pack_send(ConnPid, 10921, {?chat_online, ?chat_circle, Rid, SrvId, Name, Lev, Gname, Icon, Vip, Sign});
                {false, _} when Event =:= ?event_c_world_compete_11 orelse Event =:= ?event_c_world_compete_22 orelse Event =:= ?event_c_world_compete_33 ->
                    sys_conn:pack_send(ConnPid, 10921, {?chat_online, ?chat_circle, Rid, SrvId, Name, Lev, Gname, Icon, Vip, Sign});
                {false, _} -> %% 跨服非好友，不在仙道会场景，不能私聊
                    sys_conn:pack_send(ConnPid, 10921, {?chat_nocircle_not_kuafu, 0, Rid, SrvId, <<>>, 0, <<>>, 0, 0, <<>>})
            end;
        {error, self_call} ->
            ignore;
        {error, _} when SrvId =:= SsrvId ->
            case is_sns_circle(Rid) of
                {true, #friend{name = CName, lev = CLev, guild = CGuild, face_id = CIcon, vip_type = CVip, signature = CSign}} -> 
                    sys_conn:pack_send(ConnPid, 10921, {?chat_offline, ?chat_circle, Rid, SrvId, CName, CLev, CGuild, CIcon, CVip, CSign});
                {false, _} ->
                    sys_conn:pack_send(ConnPid, 10921, {?chat_offline, ?chat_nocircle, Rid, SrvId, <<>>, 0, <<>>, 0, 0, <<>>})
            end;
        _ ->
            sys_conn:pack_send(ConnPid, 10921, {?chat_offline, ?chat_nocircle, Rid, SrvId, <<>>, 0, <<>>, 0, 0, <<>>})
    end,
    {ok};

%% 处理confirm回应
handle(10941, {Id, Val}, Role) ->
    case erase({confirm_info, Id}) of
        {M, F, A} -> M:F([Role | [Val | A]]);
        _ -> {ok}
    end;

%% 处理prompt回应
handle(10942, {Id, Val}, Role) ->
    case erase({prompt_info, Id}) of
        {M, F, A} -> M:F([Role | [Val | A]]);
        _ -> {ok}
    end;

%% 查看物品缓存信息
handle(10943, {Id}, _Role) ->
    Item = item_srv_cache:get(Id),
    item:item_to_view(Item);

%% 请求服务端缓存物品数据
handle(10944, {?storage_bag, Id}, #role{bag = Bag}) ->
    case storage:find(Bag#bag.items, #item.id, Id) of
        {false, _Reason} -> {reply, {0, 0, 0, 0}};
        {ok, Item = #item{base_id = BaseId, enchant = Enchant}} ->
            CacheId = item_srv_cache:add(Item),
            {reply, {1, BaseId, Enchant, CacheId}}
    end;

%% 请求服务端缓存物品数据
handle(10944, {?storage_store, Id}, #role{store = Store}) ->
    case storage:find(Store#store.items, #item.id, Id) of
        {false, _Reason} -> {reply, {0, 0, 0, 0}};
        {ok, Item = #item{base_id = BaseId, enchant = Enchant}} ->
            CacheId = item_srv_cache:add(Item),
            {reply, {1, BaseId, Enchant, CacheId}}
    end;

%% 请求服务端缓存物品数据
handle(10944, {?storage_eqm, Id}, #role{eqm = Eqm}) ->
    case storage:find(Eqm, #item.id, Id) of
        {false, _Reason} -> {reply, {0, 0, 0, 0}};
        {ok, Item = #item{base_id = BaseId, enchant = Enchant}} ->
            CacheId = item_srv_cache:add(Item),
            {reply, {1, BaseId, Enchant, CacheId}}
    end;

%% 请求魔晶背包物品数据
handle(10944, {?storage_pet_magic, Id}, #role{pet_magic = #pet_magic{items = Items}}) ->
    case lists:keyfind(Id, #item.id, Items) of
        Item = #item{base_id = BaseId} ->
            CacheId = item_srv_cache:add(Item),
            {reply, {1, BaseId, CacheId}};
        _ -> {reply, {0, 0, 0}}
    end;

%% 请求魔晶装备栏物品数据
handle(10944, {?storage_pet_eqm, Id}, Role) ->
    Pets = pet_api:list_pets(Role),
    Items = get_all_pet_eqm(Pets, []),
    case lists:keyfind(Id, #item.id, Items) of
        Item = #item{base_id = BaseId} ->
            CacheId = item_srv_cache:add(Item),
            {reply, {1, BaseId, CacheId}};
        _ -> {reply, {0, 0, 0}}
    end;

%% 请求服务端扣除500金币（报告坐标）
handle(10945, {Map, X, Y}, Role) ->
    case role_gain:do([#loss{label = coin_all, val = 500, msg = <<>>}], Role) of
        {false, #loss{err_code = ErrCode}} ->
            {reply, {ErrCode, Map, X, Y}};
        {ok, NewRole} ->
            log:log(log_coin, {<<"发坐标">>, <<"">>, Role, NewRole}),
            notice:inform(util:fbin(?L(<<"发坐标\n消耗 ~w金币">>), [500])),
            {reply, {?true, Map, X, Y}, NewRole}
    end;

handle(10960, {}, Role) ->
    notice:get_notice_boards(Role),
    {ok};

handle(10965, {}, Role) ->
    notice:get_claimable_notice(Role),
    {ok};

handle(10963, {ID}, Role) ->
    notice:claim_notice_attach(ID, Role),
    {ok};                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        

%% 获取动态表情可用ID列表  
handle(10970, {}, #role{sns = #sns{chat_face = HadFaceL}}) ->
    case chat_data:get(available) of
        Puizs when is_list(Puizs) ->
            NewPuizs = (Puizs -- HadFaceL) ++ HadFaceL,
            {reply, {NewPuizs}};
        _ ->
            ?ERR("获取可用动态表情列表数据失败"),
            {reply, {[]}}
    end;

%% 场景广播动态表情
handle(10971, {Id}, #role{id = {Rid, SrvId}, pos = #pos{map_pid = MapPid}}) ->
    map:pack_send_to_all(MapPid, 10971, {Rid, SrvId, Id}),
    {ok};

%% 获取表情包列表
handle(10972, {}, Role) ->
    chat:push_face_group(Role),
    {ok};

%% 修改表情包顺序
handle(10973, {Orders}, Role) ->
    ?DEBUG("顺序 ~w", [Orders]),
    case chat:update_face_group_order(Role, Orders) of
        {ok, NewRole} ->
            {reply, {?true, ?L(<<"修改成功">>)}, NewRole};
        _ ->
            {reply, {?false, ?L(<<"修改失败">>)}}
    end;

%% 容错
handle(_Cmd, _Data, _Role) ->

    ?DEBUG("远程聊天或动态表情(chat_rpc)信息调用错误, ~p~n,~p~n,~p",[_Cmd, _Data, _Role]),
    {ok}.

%% @doc     检查发言是否频繁
%% @spec    is_frequency(atom()) -> true | false
is_frequency(world) -> %% 世界频道间隔:10秒
    % is_frequency(chat_to_world, 0);
    is_frequency(chat_to_world, 3);

is_frequency(guild) ->
    % is_frequency(chat_to_guild, 0);
    is_frequency(chat_to_guild, 3);

is_frequency(team) ->
    %% is_frequency(chat_to_team, 3);
    false;

is_frequency(friend) ->
    is_frequency(chat_to_friend, 0);
    % is_frequency(chat_to_friend, 2);

is_frequency(_) -> %% 其它频道间隔:2秒
    % is_frequency(chat_to_other, 0).
    is_frequency(chat_to_other, 2).

%% @doc     检查相应频道发言是否频繁
%% @spec    is_frequency(Type, N) -> true | false
%% @type    Type = atom()  
%% @type    N = integer()
is_frequency(Type, N) ->
    case get(Type) of
        T when is_integer(T) ->
            Now = util:unixtime(),
            case (Now - T) < N of
                true ->
                    true;
                false ->
                    put(Type, Now),
                    false
            end;
        _ ->
            put(Type, util:unixtime()),
            false
    end.

%% @doc     检测消息字符长度是否合法, 最长100个字符
%% @spec    check_length(Msg) -> ok | nok
%% @type    Msg = binary()
is_valid_length(Msg) when is_binary(Msg) ->
    byte_size(Msg) =< ?limitlength;

is_valid_length(_Msg) ->
    false.

%% @doc     检测是否为好友
%% @spec    is_sns_circle(Rid, SrvId) -> [#friend{}]
%% @type    Rid = integer()     SrvId = string()
is_sns_circle(Rid) ->
    Friends = friend:get_friend_list(),
    ?DEBUG("**Friend list:~w~n",[Friends]),
    ?DEBUG("**Rid:~w~n",[Rid]),
    case lists:keyfind(Rid, #friend.role_id, Friends) of
        false ->
            {false, notfriend};
        Friend ->
            {true, Friend}
    end.

%% @spec    chat_to_friends([#friend{}], {Rid, SrvId, Name, Sex, Msg}) -> ok
%% @doc     向所有在线好友发送消息
%% 好友列表为空 
chat_to_friends([], _) ->
    ok;

%% 向好友发送消息
chat_to_friends([#friend{type = ?sns_friend_type_hy, role_id = Rid, srv_id = SrvId, online = ?sns_friend_online} | T], {Srid, SsrvId, Name, Sex, Vip, Special, FaceGroups, Msg}) ->
    case global:whereis_name({role, Rid, SrvId}) of
        Pid when is_pid(Pid) ->
            role:pack_send(Pid, 10910, {?chat_friend, Srid, SsrvId, Name, Sex, Vip, Special, FaceGroups, Msg}),
            chat_to_friends(T, {Srid, SsrvId, Name, Sex, Vip, Special, FaceGroups, Msg});
        _ -> 
            chat_to_friends(T, {Srid, SsrvId, Name, Sex, Vip, Special, FaceGroups, Msg})
    end;

%% 好友不在线
chat_to_friends([_H | T], {Srid, SsrvId, Name, Sex, Vip, Special, FaceGroups, Msg}) ->
    chat_to_friends(T, {Srid, SsrvId, Name, Sex, Vip, Special, FaceGroups, Msg}).

%% GM向好友发送消息
gm_chat_to_friends([], _) -> ok;
gm_chat_to_friends([#friend{type = ?sns_friend_type_hy, role_id = Rid, srv_id = SrvId, online = ?sns_friend_online} | T], {Srid, SsrvId, Name, Sex, Vip, Special, Msg}) ->
    case global:whereis_name({role, Rid, SrvId}) of
        Pid when is_pid(Pid) ->
            case ets:lookup(shield_private_chat, Pid) of 
                [] -> 
                    role:pack_send(Pid, 10930, {?chat_friend, 57, Srid, SsrvId, Name, Sex, Vip, Special, Msg});
                _ -> ok
            end,
            gm_chat_to_friends(T, {Srid, SsrvId, Name, Sex, Vip, Special, Msg});
        _ -> 
            gm_chat_to_friends(T, {Srid, SsrvId, Name, Sex, Vip, Special, Msg})
    end;

%% Gm好友不在线
gm_chat_to_friends([_H | T], {Srid, SsrvId, Name, Sex, Vip, Special, Msg}) ->
    gm_chat_to_friends(T, {Srid, SsrvId, Name, Sex, Vip, Special, Msg}).

%% 向所有在线帮会成员发送消息
guild_chat([], _) ->
    ok;
guild_chat([#guild_member{pid = Pid}|T], {Rid, SrvId, Name, Sex, Vip, Special, FaceGroups, Msg}) when is_pid(Pid) ->
    case ets:lookup(shield_guild_chat, Pid) of 
        [] ->
            role:pack_send(Pid, 10910, {?chat_guild, Rid, SrvId, Name, Sex, Vip, Special, FaceGroups, Msg});
        _ ->
            ok
    end,
    guild_chat(T, {Rid, SrvId, Name, Sex, Vip, Special, FaceGroups, Msg});
guild_chat([_H|T], {Rid, SrvId, Name, Sex, Vip, Special, FaceGroups, Msg}) ->
    guild_chat(T, {Rid, SrvId, Name, Sex, Vip, Special, FaceGroups, Msg}).

%% GM向所有在线帮会成员发送消息
gm_guild_chat([], _) -> ok;
gm_guild_chat([#guild_member{pid = Pid}|T], {Rid, SrvId, Name, Sex, Vip, Special, Msg}) when is_pid(Pid) ->
    role:pack_send(Pid, 10930, {?chat_guild, 57, Rid, SrvId, Name, Sex, Vip, Special, Msg}),
    gm_guild_chat(T, {Rid, SrvId, Name, Sex, Vip, Special, Msg});
gm_guild_chat([_H|T], {Rid, SrvId, Name, Sex, Vip, Special, Msg}) ->
    gm_guild_chat(T, {Rid, SrvId, Name, Sex, Vip, Special, Msg}).

%% 获取所以宠物装备
get_all_pet_eqm([], Items) -> Items;
get_all_pet_eqm([#pet{eqm = Eqm} | T], Items) ->
    get_all_pet_eqm(T, Eqm ++ Items).






%%-------------------------------------------------------------------------
%% 单元测试 
%%--------------------------------------------------------------------------
-ifdef(debug).
-include_lib("eunit/include/eunit.hrl").
-endif.
