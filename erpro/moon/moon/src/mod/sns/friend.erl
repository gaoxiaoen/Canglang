%%----------------------------------------------------
%% Author: yqhuang(QQ:19123767)
%% Created: 2011-8-24
%% update:  2012-6-25
%%         wpf(wprehard@qq.com)
%% Description: 好友模块
%%----------------------------------------------------
-module(friend).

-export([
        login/1
        ,logout/1
        ,read_kuafu_friend/2
        ,load_kuafu_friend/1
        ,is_friend/1
        ,is_blacklist/1
        ,is_kuafu_friend/1
        ,get_self_info/1
        ,get_friend_list/0
        ,get_friend_online_list/0
        ,get_friend_info/4
        ,get_friend_intimacy/1
        ,get_friend/2
        ,add_friend/4
        ,send_flower/7
        ,cross_send_flower/7
        ,send_flower/2
        ,flower_cast/3
        ,broad_cast_msg/9
        ,delete_friend_group/2
        ,update_friend_group/3
        ,update_signature/2
        ,do_add_friend_sync/2
        % ,send_add_friend/2
        ,send_del_friend/2
        ,send_upd_friend/2
        ,send_decline_friend/2
        ,send_upd_friend_group/2
        ,pack_send_intimacy/2
        ,pack_send_intimacy/3
        ,delete_friend/2
        ,rpc_delete_friend/3
        ,rpc_delete_friend_async/4
        ,update_friend_type/4
        ,do_update_friend_type_sync/4
        ,agree_add_friend/3
        ,do_agree_add_friend_sync/2
        ,do_pack_send_intimacy/2
        ,do_pack_send_cross_intimacy/2
        ,do_login_notify_async/5
        ,do_guild_login_notify_async/2
        ,do_logout_notify_async/5
        ,do_logout_notify_guild_async/2
        ,add_intimacy/3
        ,add_intimacy/4
        ,incr_flower/2
        ,incr_charm/2
        ,incr_intimacy/4
        ,incr_cross_intimacy/4
        ,check_friends_exist/2
        ,check_condition/3
        ,send_12135/7

        ,refresh_buff/1
        ,do_refresh_buff/2
        ,remove_buff/1
        ,do_remove_buff/1
        ,combat_over/1
        ,apply_kill_update_type/4
        ,intimacy_kill_boss/2

        ,friend_wish/5
        ,wish_lev_up/1
        ,apply_wish_lev_up/1
        ,apply_request_friend_wish/5
        ,apply_friend_wish/6
        ,select_friend_list/1
        ,apply_select_friends/2
        ,rand_chat/5
        ,update_role_name/1
        ,update_role_sex/1
        ,cross_update_friend_name/2
        ,check_kuafu_chat/0
        ,notice_kuafu_chat/1
        ,listener_power2kuafu/3
        ,chat_kuafu_loss/1
        ,pack_send_msg/2
        ,return_gift/3
        ,return_gift_mail/2
        ,add_cross_intimacy/4
        ,add_cross_intimacy/5
        ,cross_flower_cast/3
        ,update_friend_list/3
        ,rpc_update_friend_list_async/3
        ,update_last_chat/1
        ,sync_is_sns_circle/2
        ,get_face_id/2
        ,is_friend_or_applied/2
        ,get_friend_apply/1
        ,do_add_friend_dict/2
        ,send_client_notify/1
        ,get_certain_page_data/2
        ,delete_friend_apply/2

        ,give_energy/2
        ,batch_give_energy/1
        ,recv_energy/2
        ,async_update_friend_recv_flag/5
        ,day_check/1
        ,all_deleted_frd/0
        ,count_can_give_num/0
        ,check_friend_or_applied_to/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("role_online.hrl").
-include("sns.hrl").
-include("vip.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("pos.hrl").
-include("rank.hrl").
-include("guild.hrl").
-include("map.hrl").
-include("combat.hrl").
-include("team.hrl").
%%
-include("attr.hrl").
-include("mail.hrl").
-include("achievement.hrl").

-define(sns_row_count, 5).
-define(energy_num, 5).     %% 领取获得体力数
%%----------------------------------------------------
%% 模块接口
%%----------------------------------------------------

%% 登陆
login(Role) ->
    init_cache(Role),
    login_notify(Role),
    send_client_notify(Role),
    {ok, NRole} = medal:listener(Role, friend),
    % NRole1 = medal:fix_when_necessery(NRole, friend),
    sys_message_notify(NRole),
    init_energy(NRole).

logout(Role) ->
    %% friend_dao:update_friend_onlinlate(RoleId, SrvId),
    save_friend(logout, Role),
    logout_notify(Role),
    ok.


%% 获取好友列表
get_friend_list() ->
    get_dict(sns_role_friends).

%% 获取好友在线列表
get_friend_online_list() ->
    case get_dict(sns_role_friends) of
        [] -> [];
        Friends ->
            [{Rid, SrvId, Name, Lev, Career, Sex, Fight} || #friend{type = ?sns_friend_type_hy, role_id = Rid, srv_id = SrvId, name = Name, sex = Sex, career = Career, lev = Lev, online = ?true, fight = Fight} <- Friends]
    end.

%% 获取好友信息
%% @get_friend_info(rpc, Role::role{}, FrRoleId::integer(), FrSrvId:string()) -> {ok, #friend{}}
get_friend_info(rpc, Role, FrRoleId, FrSrvId) ->
    case get_friend_info(rpc, Role, {FrRoleId, FrSrvId}) of
        {ok, Friend} ->
            {ok, pack_send_msg(12105, Friend)};
        {false, Reason} ->
            {false, Reason}
    end.

sys_message_notify(_Role = #role{id = {RoleId,_},link = #link{conn_pid = ConnPid}}) -> %%推送系统消息
    List = 
        case friend_dao:select_friend_agree_message(RoleId) of 
            {true,Data} -> Data;
            {false,_} -> []
            end,
    ?DEBUG("***Message List:~w~n",[List]),
    send_sys_message(List,ConnPid),
    friend_dao:delete_friend_agree_message_all(RoleId).

send_sys_message([],_) ->ok;
send_sys_message([[Name]|T],ConnPid) ->
    sys_conn:pack_send(ConnPid, 10932, {6, 0, util:fbin(?L(<<"~s已成功添加您为好友！">>), [Name])}),
    send_sys_message(T,ConnPid).


%% 获取与某好友之间的亲密度
get_friend_intimacy(FriendId) ->
    case get_friend(cache, FriendId) of
        {ok, #friend{intimacy = Inti}} -> Inti;
        _ -> 0
    end.

%% 打包消息
pack_send_msg(12105, #friend{type = Type ,role_id = FRoleId ,srv_id = FSrvId ,group_id = GroupId ,name = Name ,sex = Sex ,career = Career ,lev = Lev ,intimacy = Intimacy ,online_late = OnlineLate ,map_id = MapId ,face_id = FaceId ,vip_type = VipType ,signature = Signature ,prestige = Prestige ,guild = Guild ,online = Online, fight = Fight}) ->
    OL = case is_integer(OnlineLate) of
        true -> OnlineLate;
        false -> 0
    end,
    {Type, FRoleId, FSrvId, GroupId, Name, Sex, Career, Lev, Intimacy, OL, MapId, FaceId, VipType, Signature, Prestige, Guild, Online, Fight};
pack_send_msg(12106, #friend{type = Type ,role_id = FRoleId ,srv_id = FSrvId ,group_id = GroupId ,name = Name ,sex = Sex ,career = Career ,lev = Lev ,intimacy = Intimacy ,online_late = OnlineLate ,map_id = MapId ,face_id = FaceId ,vip_type = VipType ,signature = Signature ,prestige = Prestige ,guild = Guild ,online = Online, fight = Fight}) ->
    OL = case is_integer(OnlineLate) of
        true -> OnlineLate;
        false -> 0
    end,
    {Type, FRoleId, FSrvId, GroupId, Name, Sex, Career, Lev, Intimacy, OL, MapId, FaceId, VipType, Signature, Prestige, Guild, Online, Fight};
pack_send_msg(_, _) -> error.
    
%% 通过Id添加好友
% add_friend(_Role = #role{id = {RoleId, SrvId}}, _Type, RoleId, SrvId) -> {ok, ?L(<<"不可以加自己">>)};
add_friend(Role, Type, FrRoleId, FrSrvId) ->
    % ?DEBUG("添加好友类型:~w~n",["ggg"]),
    case is_friend({FrRoleId, FrSrvId}) of 
        {true, _} ->
            {false, ?L(<<"对方已经是好友">>)};
        false ->
            TypeCheck = 
                case Type of 
                    ?sns_friend_type_hmd -> false;
                    _ ->
                        case is_friend_or_applied(Role, {FrRoleId, FrSrvId}) of 
                            true -> %% 这种情况为对方已经向自己申请
                                % friend:agree_add_friend(Role, FrRoleId, FrSrvId),
                                ok;
                            false -> false 
                        end
                end,
            case TypeCheck of
                ok -> friend:agree_add_friend(Role, FrRoleId, FrSrvId);
                false ->
                    Checklist = 
                        case Type of        %%根据Type类型返回需要满足的各个条件
                            ?sns_friend_type_hy ->
                                [max_self, max_friend]; %%减少一个在线的条件 [exist, max_self, online]
                            _Other ->
                                []
                        end,   
                    case check_all(Checklist, Role, {FrRoleId, FrSrvId, Type}) of  %%检查各个条件是否满足
                        {false, Reason} ->
                            ?DEBUG("false添加好友类型:~s~n",[Reason]),
                            {false, Reason};
                        {ok} ->
                            ?DEBUG("添加好友类型:~w~n",[Type]),
                            do_add_friend(Role, {FrRoleId, FrSrvId, Type})
                    end
            end
    end.

%% 删除好友
rpc_delete_friend(#role{id = {RoleId, SrvId}}, FrRoleId, FrSrvId) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Fr = #friend{give_time = GiveTime, give_flag = GiveFlag, recv_flag = RecvFlag, recv_time = RecvTime}} ->
            case role_api:c_lookup(by_id, {FrRoleId, FrSrvId}, #role.pid) of
                {ok, _, Pid} ->
                    role:c_apply(sync, Pid, {friend, rpc_delete_friend_async, [RoleId, SrvId, Fr]});
                _ ->
                    %% friend_dao:insert_del_friend(FrRoleId, FrSrvId, RoleId, SrvId),
                    case has_give(recv, RecvFlag) of
                        true ->
                            friend_dao:insert_del_friend(FrRoleId, FrSrvId, RoleId, SrvId, RecvTime);
                        false ->
                            skip
                    end,
                    friend_dao:delete_friend(FrRoleId, FrSrvId, RoleId, SrvId) %%对方先删除自己
            end,
            delete_friend(cache, {FrRoleId, FrSrvId}),      %%删除自己的缓存
            friend_dao:delete_friend(RoleId, SrvId, FrRoleId, FrSrvId),     %%删除对方
            case has_give(give, GiveFlag) of
                true ->
                    insert_deleted_friend({FrRoleId, FrSrvId, GiveTime}),
                    friend_dao:insert_del_friend(RoleId, SrvId, FrRoleId, FrSrvId, GiveTime);
                false ->
                    skip
            end,
            % log_intimacy(RoleId, SrvId, Name, FrRoleId, FrSrvId),
            {ok};
        _ ->
            {ok}
    end.

%% 删除好友(回调函数) 
rpc_delete_friend_async(#role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}, FrRoleId, FrSrvId, #friend{recv_time = RecvTime, recv_flag = RecvFlag}) ->
    ?DEBUG("====删除好友==rpc_delete_friend async==:~w", [FrRoleId]),
    delete_friend(cache, {FrRoleId, FrSrvId}),
    friend_dao:delete_friend(RoleId, SrvId, FrRoleId, FrSrvId),
    sys_conn:pack_send(ConnPid, 12120, {FrRoleId}),
    case has_give(recv, RecvFlag) of
        true ->
            insert_deleted_friend({FrRoleId, FrSrvId, RecvTime}),
            friend_dao:insert_del_friend(RoleId, SrvId, FrRoleId, FrSrvId, RecvTime);
        false ->
            skip
    end,
    % send_del_friend(ConnPid, {FrRoleId, FrSrvId}),
    {ok, ok}.

has_give(give, GiveFlag) -> GiveFlag =:= ?has_give;
has_give(recv, RecvFlag) ->  RecvFlag =:= ?can_recv orelse RecvFlag =:= ?has_recv.

sync_is_sns_circle(_Role, Rid) ->
    Friends = get_friend_list(),
    ?DEBUG("**Friend list:~w~n",[Friends]),
    ?DEBUG("**Rid:~w~n",[Rid]),
    case lists:keyfind(Rid, #friend.role_id, Friends) of
        false ->
            {ok, {ok, msr_friend}};
        #friend{type = Type} ->
            case Type of 
                ?sns_friend_type_hmd ->
                    {ok, {ok, notfriend}};
                _ ->
                    {ok, {ok, friend}}
            end
    end.

%% 更新陌生人列表
update_friend_list(msr, {FrRoleId, FrSrvId}, Role = #role{id = {RoleId, SrvId}}) ->
    % ?DEBUG("***更新陌生人列表****:~s~n",["ggg"]),
    Friends = get_friend_list(),
    List_hy = [F || F = #friend{type = Type_hy} <- Friends, Type_hy =:= ?sns_friend_type_hy],
    case lists:keyfind(FrRoleId, #friend.role_id, List_hy) of 
        false -> %%不是好友则更新
            List = [F || F = #friend{type = Type} <- Friends, Type =:= ?sns_friend_type_msr],
            case lists:keyfind(FrRoleId,#friend.role_id, List) of 
                false ->
                    case sns_dao:get_role_by_id2(FrRoleId, FrSrvId) of 
                        {true, [_, _, FrName, Sex, Career, Lev]} ->

                            case erlang:length(List) >= 10 of 
                                true ->
                                    List1 = lists:keysort(#friend.last_chat, List),
                                    Oldest = List1:nth(1, List1),
                                    delete_friend(cache, {Oldest#friend.role_id, Oldest#friend.srv_id}),
                                    friend_dao:delete_friend(RoleId, SrvId, FrRoleId, FrSrvId);

                                    % insert_friend(cache, #friend{role_id = FrRoleId, srv_id = FrSrvId, name = FrName, type = ?sns_friend_type_msr, career = Career,
                                    %     sex = Sex, lev = Lev, face_id = get_face_id(Career, Sex), group_id = ?sns_fr_group_id_msr, last_chat = util:unixtime()});
                                    % friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, ?sns_friend_type_msr, 0, type2groupid(?sns_friend_type_msr));
                                false ->
                                    ok
                            end,
                            insert_friend(cache, #friend{role_id = FrRoleId, srv_id = FrSrvId, name = FrName, type = ?sns_friend_type_msr, career = Career,
                                    sex = Sex, lev = Lev, face_id = get_face_id(Career, Sex), group_id = ?sns_fr_group_id_msr,last_chat = util:unixtime()}),
                            friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, ?sns_friend_type_msr, 0, type2groupid(?sns_friend_type_msr)),
                            rpc_update_friend_list(msr, {FrRoleId, FrSrvId}, Role);
                        {false,_} ->
                            ok
                    end;
                Friend -> %%更新聊天时间
                    % ?DEBUG("***聊天时间陌生人****:~w~n",["ggg"]),
                    friend_dao:update_friend_last_chat(util:unixtime(), RoleId, SrvId, FrRoleId, FrSrvId),
                    delete_friend(cache, {Friend#friend.role_id, Friend#friend.srv_id}),
                    insert_friend(cache, Friend#friend{last_chat = util:unixtime()}),
                    rpc_update_friend_list(msr, {FrRoleId, FrSrvId}, Role),
                    ok
            end;
        _ ->
            ok
    end.


rpc_update_friend_list(msr,{FrRoleId, FrSrvId}, #role{id = {RoleId,SrvId}}) ->
    case role_api:c_lookup(by_id, {FrRoleId, FrSrvId}, #role.pid) of
        {ok, _, Pid} ->
            role:c_apply(sync, Pid, {friend, rpc_update_friend_list_async, [RoleId, SrvId]});
        _ ->
            {error,<<"对方不在线">>}
    end.
rpc_update_friend_list_async(#role{id = {RoleId,SrvId}},FrRoleId,FrSrvId) ->
    Friends = get_friend_list(),
    List = [F || F = #friend{type = Type} <- Friends, Type == ?sns_friend_type_msr],
    case lists:keyfind(FrRoleId, #friend.role_id, List) of 
        false ->
            case sns_dao:get_role_by_id2(FrRoleId, FrSrvId) of 
                {true, [_, _, FrName, Sex, Career, Lev]} ->
                    ?DEBUG("---Lev--~p~n~n~n~n", [Lev]),
                    case erlang:length(List) >= 10 of 
                        true ->
                            List1 = lists:keysort(#friend.last_chat, List),
                            Oldest = List1:nth(1, List1),
                            delete_friend(cache, {Oldest#friend.role_id, Oldest#friend.srv_id}),
                            friend_dao:delete_friend(RoleId, SrvId, FrRoleId, FrSrvId);
                            % insert_friend(cache, #friend{role_id = FrRoleId,srv_id = FrSrvId,name = FrName,type = ?sns_friend_type_msr,career = Career,
                            %     sex = Sex, lev = Lev, face_id = get_face_id(Career, Sex), group_id = ?sns_fr_group_id_msr, last_chat = util:unixtime()}),
                            % friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, ?sns_friend_type_msr, 0, type2groupid(?sns_friend_type_msr)),
                            % {ok, <<"">>};
                        false ->
                            % insert_friend(cache, #friend{role_id = FrRoleId, srv_id = FrSrvId, name = FrName, type = ?sns_friend_type_msr, career = Career,
                            %     sex = Sex, lev = Lev, face_id = get_face_id(Career, Sex), group_id = ?sns_fr_group_id_msr, last_chat = util:unixtime()}),
                            % friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, ?sns_friend_type_msr, 0, type2groupid(?sns_friend_type_msr)),
                            % {ok, <<"">>}
                            ok
                    end,
                    insert_friend(cache, #friend{role_id = FrRoleId, srv_id = FrSrvId, name = FrName, type = ?sns_friend_type_msr, career = Career,
                                sex = Sex, lev = Lev, face_id = get_face_id(Career, Sex), group_id = ?sns_fr_group_id_msr, last_chat = util:unixtime()}),
                    friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, ?sns_friend_type_msr, 0, type2groupid(?sns_friend_type_msr)),
                    {ok, <<"">>};
                {false,_} ->
                    {ok, <<"">>}
            end;
        Friend -> %%更新聊天时间
            friend_dao:update_friend_last_chat(util:unixtime(), RoleId, SrvId, FrRoleId, FrSrvId),
            delete_friend(cache, {Friend#friend.role_id, Friend#friend.srv_id}),
            insert_friend(cache, Friend#friend{last_chat = util:unixtime()}),
            {ok, <<"">>}
    end.

 %%更新私聊对象最后的聊天时间   
update_last_chat(FrRoleId) ->
    Friends = get_friend_list(),
    Old = lists:keyfind(FrRoleId,#friend.role_id,Friends),
    delete_friend(cache, {FrRoleId, Old#friend.srv_id}),
    insert_friend(cache, Old#friend{last_chat = util:unixtime()}).

%% 更新好友类型
update_friend_type(Role, FrRoleId, FrSrvId, Type) ->
    Checklist = case Type of
        ?sns_friend_type_hy ->
            [not_exist, online];
        _Other ->
            [not_exist]
    end,
    case check_all(Checklist, Role, {FrRoleId, FrSrvId, Type}) of
        {false, Reason} ->
            {false, Reason};
        {ok} ->
            do_update_friend_type(Role, {FrRoleId, FrSrvId, Type})
    end.

%% 同意加为好友
agree_add_friend(Role, FrRoleId, FrSrvId) ->
    case check_all([max_self], Role, {FrRoleId, FrSrvId, ?sns_friend_type_hy}) of
        {false, Reason} ->
            {false, Reason};
        {ok} ->
            do_agree_add_friend(Role, FrRoleId, FrSrvId, ?sns_friend_type_hy)
    end.
 

%% 删除好友分组，将组内的好友移到“我的好友”分组内
delete_friend_group(Role, FrGroupId) ->
    Friends = get_friend_by_group_id(FrGroupId),
    update_friend_group_type(Role, Friends, ?sns_fr_group_id_hy),
    Rs = [{FrRoleId, FrSrvId, ?sns_fr_group_id_hy} || #friend{role_id = FrRoleId, srv_id = FrSrvId} <- Friends],
    {ok, Rs}.

%% 转移好友分组
update_friend_group(Role, FrGroupId, FriendsTuples) ->
    case check_friends_exist(Role, FriendsTuples) of
        {ok} ->
            update_friend_group_type2(Role, FrGroupId, FriendsTuples);
        {false, Reason} ->
            {false, Reason}
    end.

%% 修改个性签名
update_signature(Role = #role{sns = Sns}, Signature) ->
    NewSns = Sns#sns{signature = Signature},
    {ok, Role#role{sns = NewSns}}.

%% @spec send_flower(NameCode, Type, BaseId, RecvRole, SendRole) -> {ok, Msg, NewRole} | {false, Reason}
%% Type = integer()
%%      1: 1朵鲜花 2:99朵 3:999朵 4:蓝色妖姬 5:99朵康乃馨 6:99朵黄月季 7:感恩
%% @doc 送花给某人
send_flower(NameCode, Type, BaseId, FrName, RecvPid, {FrId, FrSrvId}, Role = #role{id = {Rid, SrvId}, name = Name, pid = SendPid}) ->
    case role_gain:do([#loss{label = item, val = [BaseId, 0, 1], msg = ?L(<<"包包里木有发现可以送的东西">>)}], Role) of
        {false, _L} when BaseId =:= 33203 -> {false, ?L(<<"背包里没有钻戒">>)};
        {false, L} -> {false, L#loss.msg};
        {ok, NewRole} ->
            Val = baseid_to_val(BaseId),
            %% TODO 广播文字公告
            role:apply(async, RecvPid, {friend, incr_charm, [Val]}), %%  收花的增加魅力值
            IsFriend = is_friend({FrId, FrSrvId}),
            MsgReturn = case  IsFriend =/= false of
                true -> 
                    add_intimacy(RecvPid, {Rid, SrvId, ?false}, Val, item:name(BaseId)),
                    add_intimacy(SendPid, {FrId, FrSrvId, ?true}, Val, item:name(BaseId)),
                    pack_send_intimacy(RecvPid, {Rid, SrvId}),
                    pack_send_intimacy(SendPid, {FrId, FrSrvId}),
                    notice_suc(Type, Val, FrName);
                false ->
                    notice_not_friend_suc(Type, Val, FrName)
            end,
            %%通知对方弹窗
            broad_cast_msg(NameCode, Rid, SrvId, Name, FrId, FrSrvId, FrName, Type, Val),
            flower_cast(Type, Val, RecvPid), %% 广播送花特效
            {ok, NowRole} = incr_flower(NewRole, Val), %% 增加送花人的送花积分
            campaign_reward:handle(flower_first, NewRole, Val),
            NowRole0 = campaign_listener:handle(flower, NowRole, Val),
            {ok, MsgReturn, NowRole0}
    end.

cross_send_flower(NameCode, Type, BaseId, FrName, RecvPid, {FrId, FrSrvId}, Role = #role{id = {Rid, SrvId}, name = Name, pid = SendPid}) ->
    case role_gain:do([#loss{label = item, val = [BaseId, 0, 1], msg = ?L(<<"包包里木有发现可以送的东西">>)}], Role) of
        {false, L} -> {false, L#loss.msg};
        {ok, NewRole} ->
            Val = baseid_to_val(BaseId),
            %% TODO 广播文字公告
            role:c_apply(async, RecvPid, {friend, incr_charm, [Val]}), %%  收花的增加魅力值
            IsFriend = is_kuafu_friend({FrId, FrSrvId}),
            MsgReturn = case  IsFriend =/= false of
                true -> 
                    add_cross_intimacy(remote, RecvPid, {Rid, SrvId, ?false}, Val, item:name(BaseId)),
                    add_cross_intimacy(local, SendPid, {FrId, FrSrvId, ?true}, Val, item:name(BaseId)),
                    pack_send_intimacy(remote, RecvPid, {Rid, SrvId}),
                    pack_send_intimacy(local, SendPid, {FrId, FrSrvId}),
                    notice_suc(Type, Val, FrName);
                false ->
                    notice_not_friend_suc(Type, Val, FrName)
            end,
            broad_cast_msg(NameCode, Rid, SrvId, Name, FrId, FrSrvId, FrName, Type, Val),
            center:cast(FrSrvId, friend, broad_cast_msg, [NameCode, Rid, SrvId, Name, FrId, FrSrvId, FrName, Type, Val]),
            cross_flower_cast(Type, Val, RecvPid),
            center:cast(FrSrvId, friend, flower_cast, [Type, Val, RecvPid]),
            {ok, NowRole} = incr_flower(NewRole, Val), %% 增加送花人的送花积分
            NowRole0 = campaign_listener:handle(flower, NowRole, Val),
            {ok, MsgReturn, NowRole0}
    end.

notice_suc(8, Val, FrName) -> util:fbin(?L(<<"您拿起大雪球瞄准~s扔了过去,增加~w亲密度">>), [FrName, Val]);
notice_suc(12, Val, FrName) -> util:fbin(?L(<<"您赠送了一颗钻戒给~s,增加~w亲密度">>), [FrName, Val]);
notice_suc(_, Val, FrName) -> util:fbin(?L(<<"你赠送~w朵花给~s,增加亲密度~w点, 增加~w点送花积分">>), [Val, FrName, Val, Val]).

notice_not_friend_suc(8, _Val, FrName) -> util:fbin(?L(<<"您拿起大雪球瞄准~s扔了过去">>), [FrName]);
notice_not_friend_suc(12, _Val, FrName) -> util:fbin(?L(<<"您赠送了一颗钻戒给~s,由于对方不是你好友，所以不能获得亲密度">>), [FrName]);
notice_not_friend_suc(_, Val, FrName) -> util:fbin(?L(<<"你赠送~w朵花给~s,由于你们不是好友,亲密度不增加, 增加~w点送花积分">>), [Val, FrName, Val]).

%% 婚礼专用接口 - 直接花晶钻赠送
send_flower(#role{id = {FrId, FrSrvId}, pid = RecvPid, name = FrName}, Role) ->
    send_flower({{FrId, FrSrvId}, FrName, RecvPid}, Role);
send_flower({{FrId, FrSrvId}, FrName, RecvPid}, Role = #role{id = {Rid, SrvId}, pid = Pid, name = _Name, link = #link{conn_pid = ConnPid}}) ->
    Val = 999,
    Type = 3, %% 999朵鲜花
    BaseId = 33004,
    %%  收花的增加魅力值
    role:c_apply(async, RecvPid, {friend, incr_charm, [Val]}),
    case is_friend({FrId, FrSrvId}) of
        {true, #friend{type = ?sns_friend_type_hy}} ->
            add_intimacy(RecvPid, {Rid, SrvId, ?false}, Val, item:name(BaseId)),
            add_intimacy(Pid, {FrId, FrSrvId, ?true}, Val, item:name(BaseId)),
            pack_send_intimacy(RecvPid, {Rid, SrvId}),
            pack_send_intimacy(Pid, {FrId, FrSrvId}),
            flower_cast(Type, Val, RecvPid), %% 广播送花特效
            {ok, NowRole} = incr_flower(Role, Val), %% 增加送花人的送花积分
            MsgReturn = util:fbin(?L(<<"你赠送~w朵花给~s,增加亲密度~w点, 增加~w点送花积分">>), [Val, FrName, Val, Val]),
            sys_conn:pack_send(ConnPid, 12160, {?true, MsgReturn}),
            NowRole;
        {true, #friend{type = ?sns_friend_type_kuafu}} ->
            add_cross_intimacy(remote, RecvPid, {Rid, SrvId, ?false}, Val, item:name(BaseId)),
            add_cross_intimacy(local, Pid, {FrId, FrSrvId, ?true}, Val, item:name(BaseId)),
            pack_send_intimacy(remote, RecvPid, {Rid, SrvId}),
            pack_send_intimacy(local, Pid, {FrId, FrSrvId}),
            cross_flower_cast(Type, Val, RecvPid), %% 只放一次特效
            center:cast(FrSrvId, friend, flower_cast, [Type, Val, RecvPid]), %% 发给跨服播放特效
            {ok, NowRole} = incr_flower(Role, Val), %% 增加送花人的送花积分
            MsgReturn = util:fbin(?L(<<"你赠送~w朵花给~s,增加亲密度~w点, 增加~w点送花积分">>), [Val, FrName, Val, Val]),
            sys_conn:pack_send(ConnPid, 12160, {?true, MsgReturn}),
            NowRole;
        false ->
            MsgReturn = util:fbin(?L(<<"你赠送~w朵花给~s,由于你们不是好友,亲密度不增加, 增加~w点送花积分">>),[Val, FrName, Val]),
            sys_conn:pack_send(ConnPid, 12160, {?true, MsgReturn}),
            Role
    end.

%% @spec refresh_buff([{Pid, Rid}]) -> ok
%% @doc 刷新亲密度buff
refresh_buff([]) -> ok;
refresh_buff(RoleInfoList) ->
    MemberList = to_team_member(RoleInfoList),
    do_refresh_buff(MemberList).

%% @spec remove_buff([{Pid, Rid}]) -> ok
%% 删除亲密度buff
remove_buff([]) ->
    ok;
remove_buff([{RolePid, _Rid} | T]) when is_pid(RolePid) ->
    role:c_apply(async, RolePid, {fun do_remove_buff/1, []}),
    remove_buff(T);
remove_buff([_H | T]) ->
    ?ERR("删除亲密度BUFF识别非PID:~w", [_H]),
    remove_buff(T).

%% 现刺杀战斗结束,好友变仇人
combat_over(#combat{loser = Loser, winner = Winner, type = ?combat_type_rob_escort}) ->
    do_combat_over(winner, Winner, Loser);
combat_over(#combat{loser = Loser, winner = Winner, type = ?combat_type_rob_escort_child}) ->
    do_combat_over(winner, Winner, Loser);
combat_over(#combat{loser = Loser, winner = Winner, type = ?combat_type_rob_escort_cyj}) ->
    do_combat_over(winner, Winner, Loser);
combat_over(#combat{loser = Loser, winner = Winner, type = ?combat_type_kill}) ->
    do_combat_over(winner, Winner, Loser);

%% 杀副本怪有亲密度
combat_over(#combat{loser = Loser, winner = Winner, type = ?combat_type_npc}) ->
    WinnerList = [F || F = #fighter{type = ?fighter_type_role} <- Winner],
    do_combat_over(intimacy, WinnerList, Loser).

%% 杀世界boss有亲密度奖励
intimacy_kill_boss(Winner, _Loser) ->
    WinnerList = [F || F = #fighter{type = ?fighter_type_role} <- Winner],
    case group_team_member(WinnerList) of
        [] -> ok;
        GroupList -> 
            intimacy_dungeon(GroupList, 5)
    end.

%% @spec wish_lev_up(Role) -> ok
%% 发送好友祝福提示 
apply_wish_lev_up(Role = #role{lev = Lev, sns = Sns}) ->
    case friend_data_wish:wished(Lev) of
        false -> {ok};
        _ ->
            notice_friend_wish(Role),
            {ok, Role#role{sns = Sns#sns{wished_times = 0}}}
    end.

wish_lev_up(_Role = #role{pid = Pid}) ->
    role:apply(async, Pid, {friend, apply_wish_lev_up, []}).


%% @spec friend_wish(Role, FrRoleId, FrSrvId, Type) -> {ok, NewRole, Result, FrName, Exp} | {false, Reason}
%% 好友祝福送达
friend_wish(Role = #role{id = {RoleId, SrvId}, pid = RolePid, name = Name, lev = RoleLev, sns = Sns = #sns{wish_times = {Date, Times}}}, FrRoleId, FrSrvId, Type, Lev) ->
    Today = today(),
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, #friend{type = ?sns_friend_type_hy, online = 0, name = FrName}} ->
            {ok, Role, 2, FrName, 0, Times}; 
        {ok, #friend{type = ?sns_friend_type_hy, name = FrName}} ->
            case Today =:= Date andalso Times >= 20 of
                true -> {ok, Role, 5, FrName, 0, Times};
                false ->
                    case global:whereis_name({role, FrRoleId, FrSrvId}) of
                        Pid when is_pid(Pid) ->
                            case friend_data_wish:wish(RoleLev) of
                                false -> {false, ?L(<<"好友等级没有经验奖励">>)};
                                Exp ->
                                    case role:apply(sync, Pid, {friend, apply_friend_wish, [RoleId, SrvId, Name, Type, Lev]}) of
                                        {ok, 1} -> 
                                            {ok, NewRole}= role_gain:do([#gain{label = exp, val = Exp}], Role),
                                            notice:inform(RolePid, util:fbin(?L(<<"好友祝福，获得{str,经验,#00ff24} ~w">>), [Exp])),
                                            NewWishTimes = case Date =:= Today of
                                                true -> {Date, Times + 1};
                                                false -> {Today, 1}
                                            end,
                                            {ok, NewRole#role{sns = Sns#sns{wish_times = NewWishTimes}}, 1, FrName, Exp, Times + 1};
                                        {ok, 3} -> {ok, Role, 3, FrName, 0, Times}; 
                                        {false, Reason} -> {false, Reason}
                                    end
                            end;
                        _ -> {ok, Role, 2, FrName, 0, 0}
                    end
            end;
        _Any -> 
            {false, ?L(<<"没有找到好友信息">>)}
    end.

%% 同步调用:接受好友祝福
apply_friend_wish(Role = #role{pid = Pid, link = #link{conn_pid = ConnPid}, sns = Sns = #sns{wished_times = Times}}, FrRoleId, FrSrvId, FrName, Type, Lev) ->
    case friend_data_wish:wished(Lev) of
        false -> {ok, {false, ?L(<<"好友等级没有经验奖励">>)}};
        ExpEd ->
            case Times >= 15 of
                true -> {ok, {ok, 3}};
                false ->
                    {ok, NewRole}= role_gain:do([#gain{label = exp, val = ExpEd}], Role),
                    notice:inform(Pid, util:fbin(?L(<<"好友祝福，获得{str,经验,#00ff24} ~w">>), [ExpEd])),
                    sys_conn:pack_send(ConnPid, 12172, {FrRoleId, FrSrvId, FrName, ExpEd, Type}),
                    {ok, {ok, 1}, NewRole#role{sns = Sns#sns{wished_times = (Times + 1)}}}
            end
    end.

%% 祝福回赠
return_gift(_Name, [], _Type) -> {ok};
return_gift(Name, [[FrRoleId, FrSrvId] | T], Type) ->
    case global:whereis_name({role, FrRoleId, FrSrvId}) of
        Pid when is_pid(Pid) ->
            role:apply(async, Pid, {friend, return_gift_mail, [{Type, Name}]});
        _ ->
            skip
    end,
    return_gift(Name, T, Type);
return_gift(_Name, _, _Type) -> {false, ?L(<<"消息数据异常，无法回赠">>)}.

%% 祝福回赠信件
return_gift_mail(Role = #role{id = {Rid, SrvId}, name = Name, sns = Sns = #sns{receive_gift = Times}}, {Type, FrName}) when Times < 20 ->
    ?DEBUG("Times = ~w", [Times]),
    {Content, Assets, Items} = case Type of
        1 ->
            {util:fbin(?L(<<"恭喜您获得好友【~s】的祝福回赠，经验1888。">>), [FrName]), [{?mail_exp, 1888}], []};
        2 ->
            {util:fbin(?L(<<"恭喜您获得好友【~s】的祝福回赠，绑定金币1888。">>), [FrName]), [{?mail_coin_bind, 1888}], []};
        3 ->
            {util:fbin(?L(<<"恭喜您获得好友【~s】的祝福回赠，鲜花1朵。">>), [FrName]), [], [{33002, 1, 1}]}
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {?L(<<"好友祝福回赠">>), Content, Assets, Items}),
    {ok, Role#role{sns = Sns#sns{receive_gift = Times + 1}}};
return_gift_mail(_, _) -> {ok}.

%% 获取角色列表
select_friend_list(#role{pid = Pid, link = #link{conn_pid = ConnPid}}) ->
    List = ets:tab2list(role_online),
    Length = length(List),
    case Length > 1 of
        true ->
            PidList = pid_select_friends(List, Length),
            Param = #friend_param_rlist{conn_pid = ConnPid, pid = Pid, target_pids = PidList},
            do_select_friends(Param);
        false ->
            sys_conn:pack_send(ConnPid, 12173, {[]})
    end.

%% 修改角色名称
update_role_name(#role{id = {RoleId, SrvId}, name = Name, name_used = NameUsed}) ->
    case get_dict(sns_role_friends) of
        undefined -> skip;
        Friends ->
            friend_dao:update_friend_name(RoleId, SrvId, Name),
            Srvs = get_friend_srvs(Friends, []),
            cross_update_friend_name(Srvs, {RoleId, SrvId, Name}),
            do_update_friend_name(Friends, RoleId, SrvId, Name),
            Mail = {?L(<<"好友改名">>), util:fbin(?L(<<"亲爱的玩家，你的好友【~s】使用了改名卡，成功将名字修改为 【~s】。">>), [NameUsed, Name]), [], []},
            do_mail_friends(Friends, Mail)
    end.

%% 修改角色性别
update_role_sex(#role{id = {RoleId, SrvId}, sex = Sex, vip = #vip{portrait_id = FaceId}}) ->
    case get_dict(sns_role_friends) of
        undefined -> skip;
        Friends ->
            do_update_friend_sex(Friends, RoleId, SrvId, Sex, FaceId)
    end.

%% 监听跨服好友的开启
listener_power2kuafu({_, _}, Lev, Power) when Lev < 52 orelse Power < 6500 ->
    ok;
listener_power2kuafu(RoleId, _Lev, _Power2) ->
    case catch ets:lookup(ets_kuafu_friend_roles, RoleId) of
        [] ->
            case get(conn_pid) of
                ConnPid when is_pid(ConnPid) ->
                    sys_conn:pack_send(ConnPid, 12109, {?true}),
                    ets:insert(ets_kuafu_friend_roles, {RoleId, ?true, util:unixtime(), 5});
                _ -> skip
            end;
        _ -> ok
    end.

%% 跨服聊天口金币
chat_kuafu_loss(Role) ->
    LossList = [#loss{label = coin, val = 5000, msg = ?L(<<"金币不足咯">>)}],
    case role_gain:do(LossList, Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, NewRole} ->
            notice:inform(?L(<<"跨服呐喊\n消耗 5000金币">>)),
            {ok, NewRole}
    end.

%% 检查时间段判断跨服群组聊天时间
-ifdef(debug).
check_kuafu_chat() ->
    true.
-else.
check_kuafu_chat() ->
    true.
%%     Today = util:unixtime(today),
%%     Now = util:unixtime(),
%%     if
%%         (Now >= Today + 57600) andalso (Now =< Today + 64800) -> true; %% 仙道会 16:00-18:00
%%         (Now >= Today + 77400) andalso (Now =< Today + 83000) -> true; %% 仙道会 21:30-23:00
%%         (Now >= Today + 68700) andalso (Now =< Today + 70800) -> true; %% 无双竞技 19:05-19:40
%%         true -> false
%%     end.
-endif.

%% @spec notice_kuafu_chat(IsOpen) -> any()
%% IsOpen = 1 | 0
%% 跨服活动开始通知跨服群组聊天开启，节点运行
notice_kuafu_chat(IsOpen) when IsOpen =:= 1 orelse IsOpen =:= 0 ->
    List = ets:tab2list(ets_kuafu_friend_roles),
    notice_kuafu_chat(IsOpen, List);
notice_kuafu_chat(_) -> ignore.

notice_kuafu_chat(_IsOpen, []) -> ok;
notice_kuafu_chat(IsOpen, [{RoleId, _, _, _} | T]) ->
    case role_api:lookup(by_id, RoleId, #role.link) of
        {ok, _Node, #link{conn_pid = ConnPid}} ->
            sys_conn:pack_send(ConnPid, 12108, {IsOpen});
        _ -> ignore
    end,
    notice_kuafu_chat(IsOpen, T);
notice_kuafu_chat(IsOpen, [_H | T]) ->
    ?ERR("广播通知跨服聊天出错H:~w", [_H]),
    notice_kuafu_chat(IsOpen, T).

%% 加载跨服好友，角色定时器回调函数
load_kuafu_friend(_Role) ->
    case role:get_dict(sns_role_friends) of
        {ok, Friends} when is_list(Friends) ->
            read_kuafu_friend(Friends);
        _ -> {ok}
    end.

%%----------------------------------------------------
%% 二级函数 
%%----------------------------------------------------
init_cache(_Role = #role{id = {RoleId, SrvId}, sns = #sns{fr_group = FrGroup}}) ->
    % {ok, _} = role:put_dict(sns_role_recently, []), %% 最近联系人
    case friend_dao:get_friends(RoleId, SrvId) of
        {false, []} ->
            {ok, _} = role:put_dict(sns_role_friends, []);
        {true, Data} ->
            Friends = read_friend(Data, [], FrGroup),
            % ?DEBUG("---Friends--~p~n~n~n~n~n", [Friends]),
            Friends1 = lists:keysort(#friend.online, Friends),
            Friends2 = lists:reverse(Friends1),
            {ok, _} = role:put_dict(sns_role_friends, Friends2)
    end,
    case friend_dao:get_deleted_friends(RoleId, SrvId) of
        {false, []} ->
            {ok, _} =  role:put_dict(deleted_friend, []);
        {true, DelF} ->
            ?DEBUG("********* 所有删除好友  ~w", [DelF]),
            read_deleted_friend(RoleId, SrvId, DelF)
    end.

%% 导入跨服好友信息
init_kuafu_cache(Role = #role{id = {RoleId, SrvId}, name = Name, sex = Sex}, KuaFuFriend) ->
    do_init_kuafu_cache(Role, KuaFuFriend),
    ?DEBUG("载入跨服好友：~w", [KuaFuFriend]),
    MeFriendRec = #friend{role_id = RoleId, srv_id = SrvId, name = Name, sex = Sex, online = 1},
    {ok, FriendOnline} = get_self_info(Role),
    NewMeFriendRec = convert_to_friend(friend_online, MeFriendRec, FriendOnline),
    do_login_notify([KuaFuFriend], NewMeFriendRec, Role),  %% 此处只能通知跨服好友
    {ok}.
do_init_kuafu_cache(_Role, []) -> {ok};
do_init_kuafu_cache(Role, [KuaFuFr | T]) ->
    update_friend(cache, KuaFuFr),
    do_init_kuafu_cache(Role, T);
do_init_kuafu_cache(_Role, KuafuFr) when is_record(KuafuFr, friend) ->
    update_friend(cache, KuafuFr);
do_init_kuafu_cache(_, _) -> {ok}.

%% 读取好友信息：好友在线时访问PID获取信息，不在线访问数据库
%% 返回的信息转换成#friend{}记录形式
read_friend([[_RoleId, _SrvId, FrRoleId, FrSrvId, FrName, FrType, Intimacy, FrGroupId, OnlineLate, GiveTime, GiveFlag, RecvTime, RecvFlag] | T], Friends, FrGroup) ->
    {MyFrGroupId, _MyFrGroupName} = 
        case lists:keyfind(FrGroupId, 1, FrGroup) of
            false ->
                case FrType of
                    ?sns_friend_type_hy ->
                        {?sns_fr_group_id_hy, ?L(<<"我的好友">>)};
                    ?sns_friend_type_cr ->
                        {?sns_fr_group_id_cr, ?L(<<"仇人">>)};
                    ?sns_friend_type_hmd ->
                        {?sns_fr_group_id_hmd, ?L(<<"黑名单">>)};
                    ?sns_friend_type_kuafu -> 
                        {?sns_fr_group_id_kuafu, ?L(<<"跨服好友">>)};
                    _Else ->
                        {-1, ?L(<<"未知分组">>)}
                end;
            {FrGroupId, FrGroupName} ->
                {FrGroupId, FrGroupName}
        end,
    NewOnlineLate = case OnlineLate of
        undefined -> util:unixtime();
        _ -> OnlineLate
    end,
    Fr = #friend{type = FrType, role_id = FrRoleId, srv_id = FrSrvId, name = FrName, intimacy = Intimacy, group_id = MyFrGroupId, online_late = NewOnlineLate, give_time = GiveTime, give_flag = GiveFlag, recv_time = RecvTime, recv_flag = RecvFlag},

    case do_read_friend(Fr) of 
        false ->
            delete_friend(cache, {FrRoleId, FrSrvId}),
            read_friend(T, Friends, FrGroup);
        Friend ->
            read_friend(T, [Friend | Friends], FrGroup)
    end;
read_friend([], Friends, _FrGroup) ->
    Friends.

read_deleted_friend(_RoleId, _SrvId, []) -> ok;
read_deleted_friend(RoleId, SrvId, [[_, _, FrRoleId, FrSrvId, Time] | T]) ->
    case util:is_today(Time) of
        true ->
            insert_deleted_friend({FrRoleId, FrSrvId, Time});
        false ->
            friend_dao:delete_del_friend(RoleId, SrvId, FrRoleId, FrSrvId)
    end,
    read_deleted_friend(RoleId, SrvId, T).

%% 提取好友信息
% do_read_friend(Fr = #friend{type = ?sns_friend_type_kuafu}) ->
%     Fr;
do_read_friend(Fr = #friend{role_id = FrRoleId, srv_id = FrSrvId}) -> %% 本服所有好友(包括仇人、黑名单、陌生人)
    case global:whereis_name({role, FrRoleId, FrSrvId}) of
        Pid when is_pid(Pid) andalso Pid =/= self() ->
            case role:apply(sync, Pid, {friend, get_self_info, []}) of
                FriendOnline when is_record(FriendOnline, friend_online) ->
                    convert_to_friend(friend_online, Fr#friend{pid = Pid, online = ?sns_friend_online}, FriendOnline);
                _ ->
                    get_friend_info(db, Fr#friend{online = ?sns_friend_offline}, {FrRoleId, FrSrvId})
            end;
        _ ->
            get_friend_info(db, Fr#friend{online = ?sns_friend_offline}, {FrRoleId, FrSrvId})
    end.

%% 提取跨服好友信息
read_kuafu_friend([]) ->
    {ok};
read_kuafu_friend([Friend = #friend{type = ?sns_friend_type_kuafu, online = ?sns_friend_offline, srv_id = FrSrvId} | T]) ->
    center:cast(FrSrvId, friend, read_kuafu_friend, [self(), Friend]), %% 只跨服搜索还不在线的
    read_kuafu_friend(T);
read_kuafu_friend([_ | T]) ->
    read_kuafu_friend(T).

read_kuafu_friend(RolePid, Fr = #friend{type = ?sns_friend_type_kuafu, role_id = FrRoleId, srv_id = FrSrvId}) ->
    case global:whereis_name({role, FrRoleId, FrSrvId}) of
        Pid when is_pid(Pid) ->
            role:apply(async, Pid, {fun do_read_kuafu_friend/3, [RolePid, Fr]});
        _ ->
            %% get_friend_info(db, Fr#friend{online = ?sns_friend_offline}, {FrRoleId, FrSrvId})
            %% 取消离线查找 2012/09/06
            ignore
    end;
read_kuafu_friend(_, _) -> ignore.
%% 好友角色进程执行，异步返回给好友信息
do_read_kuafu_friend(FrRole = #role{pid = FrPid}, RolePid, Fr) ->
    {ok, FrOnline} = friend:get_self_info(FrRole),
    Friend = convert_to_friend(friend_online, Fr#friend{pid = FrPid, online = ?sns_friend_online}, FrOnline),
    ?DEBUG("好友战力：~w", [Friend#friend.fight]),
    role:c_apply(async, RolePid, {fun init_kuafu_cache/2, [Friend]}),
    {ok}.

%% 类型转换为分组ID
type2groupid(?sns_friend_type_hy) -> ?sns_fr_group_id_hy;
type2groupid(?sns_friend_type_cr) -> ?sns_fr_group_id_cr;
type2groupid(?sns_friend_type_hmd) -> ?sns_fr_group_id_hmd;
type2groupid(?sns_friend_type_kuafu) -> ?sns_fr_group_id_kuafu;
type2groupid(_) -> -1.

%% 获取更加详细的信息
get_friend_info(pid, Friend, {Pid}) when is_pid(Pid) ->
    case node(Pid) =:= node() of
        true -> %% 本服好友
            io:format("local server:~p~n",["local friend"]),
            case role:apply(sync, Pid, {friend, get_self_info, []}) of
                FriendOnline when is_record(FriendOnline, friend_online) ->
                    convert_to_friend(friend_online, Friend#friend{pid = Pid, online = 1}, FriendOnline);
                _ -> Friend
            end;
        false ->
            case role:c_apply(sync, Pid, {friend, get_self_info, []}) of
                FriendOnline when is_record(FriendOnline, friend_online) ->
                    convert_to_friend(friend_online, Friend#friend{pid = Pid, online = 1}, FriendOnline);
                _ -> Friend
            end
    end;
get_friend_info(pid, Friend, _) -> Friend;

get_friend_info(db, Friend, {FrRoleId, FrSrvId}) ->
    %% TODO:可能查询其它表获取更多的信息
    case sns_dao:get_role_by_id(FrRoleId, FrSrvId) of
        {false, _} ->
            ?DEBUG("ERROR:好友信息不存在[FrRoleId:~w, FrSrvId:~w]", [FrRoleId, FrSrvId]),
            % Friend#friend{online = 0};
            false;
        {true, [_Rid, _SrvId, Name, Sex, Career, LoginTime]} ->
            FaceId = get_face_id(Career, Sex),
            OnlineLate = case LoginTime of
                undefined -> util:unixtime();
                _ -> LoginTime
            end,
            Friend#friend{name = Name, sex = Sex, career = Career, face_id = FaceId, online_late = OnlineLate}
    end;

%% rpc接口
get_friend_info(rpc, Role = #role{id = {RoleId, SrvId}}, {RoleId, SrvId}) ->
    {ok, FriendOnline} = get_self_info(Role),
    Friend = convert_to_friend(friend_online, #friend{role_id = RoleId, srv_id = SrvId, type = ?sns_friend_type_msr, group_id = ?sns_fr_group_id_msr, intimacy = 0, online_late = util:unixtime(), online = 1}, FriendOnline),
    {ok, Friend};
get_friend_info(rpc, _, {FrRoleId, FrSrvId}) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Friend = #friend{type = ?sns_friend_type_kuafu}} ->
            {ok, Friend}; %% 跨服的不做远程访问
        {ok, Friend = #friend{online = ?sns_friend_online, fight = 0}} ->
            case global:whereis_name({role, FrRoleId, FrSrvId}) of
                Pid when is_pid(Pid) ->
                    case role:apply(sync, Pid, {friend, get_self_info, []}) of
                        FriendOnline when is_record(FriendOnline, friend_online) ->
                            NewFriend = convert_to_friend(friend_online, Friend, FriendOnline),
                            update_friend(cache, NewFriend),
                            {ok, NewFriend};
                        _ -> {ok, Friend}
                    end;
                _ ->
                    {ok, Friend}
            end;
        {ok, Friend = #friend{online = 1, online_late = OnlineLate}} ->
            case (util:unixtime() - OnlineLate) > 30 of
                true ->
                    case global:whereis_name({role, FrRoleId, FrSrvId}) of
                        Pid when is_pid(Pid) ->
                            case role:apply(sync, Pid, {friend, get_self_info, []}) of
                                FriendOnline when is_record(FriendOnline, friend_online) ->
                                    NewFriend = convert_to_friend(friend_online, Friend, FriendOnline),
                                    update_friend(cache, NewFriend),
                                    ?DEBUG("获取的好友战斗力：~w", [NewFriend#friend.fight]),
                                    {ok, NewFriend};
                                _ ->
                                    {ok, Friend}
                            end;
                        _ ->
                            {ok, Friend}
                    end;
                false ->
                    {ok, Friend}
            end;
        {ok, Friend} ->
            {ok, Friend}
        % {false, _Reason} ->
        %     {ok, Data} = role:get_dict(sns_role_recently),
        %     case lists:keyfind({FrRoleId, FrSrvId}, 1, Data) of
        %         false ->
        %             Temp = #friend{type = ?sns_friend_type_msr, role_id = FrRoleId, srv_id = FrSrvId, group_id = ?sns_fr_group_id_msr, online = ?sns_friend_online},
        %             DbFriend = get_friend_info(db, Temp, {FrRoleId, FrSrvId}),
        %             % {ok, _} = role:put_dict(sns_role_recently, [{{FrRoleId, FrSrvId}, DbFriend} | Data]),
        %             {ok, DbFriend};
        %         {{_FrRoleId, _FrSrvId}, Msr} -> %% 陌生人
        %             {ok, Msr}
            % end
    end.

%% 获取头像Id

get_face_id(?career_cike, 1) -> 2100;
get_face_id(?career_cike, 0) -> 2000;
get_face_id(?career_xianzhe, 1) -> 3100;
get_face_id(?career_xianzhe, 0) -> 3000;

get_face_id(?career_qishi, 1) -> 5100;
get_face_id(?career_qishi, 0) -> 5000;

get_face_id(_, _) -> 0.

%% 返回自己的一些信息
get_self_info(Role = #role{pid = Pid, sns = #sns{signature = Signature}, pos = #pos{map_base_id = MapBaseId}, attr = Attr}) ->
    NewSignature = case Signature =:= <<>> of
        true -> <<" ">>;
        false -> Signature
    end,
    Fight = case Attr of
        #attr{fight_capacity = F} -> F;
        _ -> 0
    end,
    {ok, #friend_online{
        pid = Pid                                                       %% 角色进程Id
        ,name = Role#role.name                                          %% 名称
        ,sex = Role#role.sex                                            %% 性别
        ,career = Role#role.career                                      %% 职业
        ,lev = Role#role.lev                                            %% 级别
        ,map_id = MapBaseId                                             %% 所在地图Id
        ,face_id = get_face_id(Role#role.career, Role#role.sex)         %% 头像Id
        ,vip_type = Role#role.vip#vip.type                              %% vip类型
        ,signature = NewSignature                                       %% 签名
        ,prestige = Role#role.assets#assets.prestige                    %% 人气值
        ,guild = Role#role.guild#role_guild.name                        %% 帮会名称
        ,online_late = util:unixtime()                                  %% 最近上线时间
        ,fight = Fight                                                  %% 战斗力
    }}.

%% 上线通知
login_notify(Role = #role{id = {RoleId, SrvId}, name = Name, sex = Sex}) ->
    MeFriendRec = #friend{role_id = RoleId, srv_id = SrvId, name = Name, sex = Sex, online = 1},
    {ok, FriendOnline} = get_self_info(Role),
    NewMeFriendRec = convert_to_friend(friend_online, MeFriendRec#friend{online = 1}, FriendOnline),
    Friends = get_dict(sns_role_friends),
    do_login_notify(Friends, NewMeFriendRec, Role),
    guild_login_notify(Role).

%% 上线通知
do_login_notify([#friend{online = 1, pid = FrPid, type = Type} | T], MeFriendRec, Role = #role{id = {RoleId, SrvId}}) when is_pid(FrPid) ->
    role:c_apply(async, FrPid, {friend, do_login_notify_async, [RoleId, SrvId, Type, MeFriendRec]}),
    do_login_notify(T, MeFriendRec, Role);
do_login_notify([_Fr | T], MeFriendRec, Role) ->
    do_login_notify(T, MeFriendRec, Role);
do_login_notify([], _Myself, _Role) ->
    ok.

%% 上线通知(回调函数)
do_login_notify_async(#role{id = _RoleId, link = #link{conn_pid = ConnPid}}, FrRoleId, FrSrvId, Type, #friend{pid = Pid, name = Name, sex = Sex, career = Career, lev = Lev, prestige = Prestige, map_id = MapId, fight = Fight, face_id = FaceId, vip_type = VipType}) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Fr} ->
            case Type of
                ?sns_friend_type_hy -> 
                    notice:inform(util:fbin(?L(<<"您的好友~s上线了">>), [Name]));
                % ?sns_friend_type_cr -> 
                %     notice:inform(util:fbin(?L(<<"您的仇人~s上线了">>), [Name]));
                ?sns_friend_type_kuafu ->
                    notice:inform(util:fbin(?L(<<"您的跨服好友~s上线了">>), [Name]));
                _ -> ignore
            end,
            NewFriend = Fr#friend{online = 1, pid = Pid, sex = Sex, career = Career, lev = Lev,
                prestige = Prestige, online_late = util:unixtime(), map_id = MapId, fight = Fight, face_id = FaceId, vip_type = VipType},
            update_friend(cache, NewFriend),
            sys_conn:pack_send(ConnPid, 12140, {FrRoleId, FrSrvId}),
            {ok};
        {false, _Reason} ->
            {ok}
    end.

%% 军团好友上线通知！！
guild_login_notify(Role = #role{id = {Rid, SrvId}, name = Name}) ->
    Online_Guild = guild_mem:online_pid(Role),
    case erlang:length(Online_Guild) of 
        0 -> ok;
        _ ->
            do_guild_login_notify({Rid, SrvId, Name}, Online_Guild)
    end.

do_guild_login_notify(_, []) -> ok;
do_guild_login_notify({Rid, SrvId, Name}, [Pid|Rest]) ->
    role:c_apply(async, Pid, {friend, do_guild_login_notify_async, [{Rid, SrvId, Name}]}),
    do_guild_login_notify({Rid, SrvId, Name}, Rest).

do_guild_login_notify_async(#role{link = #link{conn_pid = ConnPid}}, {FrRoleId, FrSrvId, FrName}) ->
    notice:inform(util:fbin(?L(<<"您的军团好友~s上线了">>), [FrName])),
    sys_conn:pack_send(ConnPid, 12140, {FrRoleId, FrSrvId}),
    {ok}.

% 下线通知
logout_notify(Role = #role{id = {RoleId, SrvId}, name = Name, sex = Sex}) ->
    Me = #friend{role_id = RoleId, srv_id = SrvId, name = Name, sex = Sex},
    case get_dict(sns_role_friends) of
        Friends when is_list(Friends) ->
            do_logout_notify(Friends, Me, Role);
        _ ->
            skip
    end,
    logout_notify_guild(Role).

% 下线通知
do_logout_notify([#friend{pid = FrPid, type = Type} | T], Me, Role = #role{id = {RoleId, SrvId}}) when is_pid(FrPid) ->
    role:c_apply(async, FrPid, {friend, do_logout_notify_async, [RoleId, SrvId, Type, Me]}),
    do_logout_notify(T, Me, Role);
do_logout_notify([_ | T], Me, Role) ->
    do_logout_notify(T, Me, Role);
do_logout_notify([], _Me, _Role) ->
    ok.

%% 下线通知(回调函数)
do_logout_notify_async(#role{id = _RoleId, link = #link{conn_pid = ConnPid}}, FrRoleId, FrSrvId, _Type, #friend{name = _Name, sex = _Sex}) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Fr} ->
            % case _Type of
            %     ?sns_friend_type_hy -> 
            %         notice:inform(util:fbin(?L(<<"您的好友~s下线了">>), [_Name]));
            %     ?sns_friend_type_cr -> 
            %         notice:inform(util:fbin(?L(<<"您的仇人~s下线了">>), [_Name]));
            %     ?sns_friend_type_kuafu ->
            %         notice:inform(util:fbin(?L(<<"您的跨服好友~s下线了">>), [_Name]));
            %     _ -> ignore
            % end,
            sys_conn:pack_send(ConnPid, 12145, {FrRoleId, FrSrvId}),
            NewFriend = Fr#friend{pid = undefined, online = 0},
            update_friend(cache, NewFriend),
            {ok};
        {false, _Reason} ->
            {ok}
    end.

%军团好友下线通知！！
logout_notify_guild(Role = #role{id = {Rid, SrvId}, name = Name}) ->
    Online_Guild = guild_mem:online_pid(Role),
    case erlang:length(Online_Guild) of 
        0 -> skip;
        _ ->
            do_logout_notify_guild({Rid, SrvId, Name}, Online_Guild)
    end.
do_logout_notify_guild(_, []) -> ok;
do_logout_notify_guild({Rid, SrvId, Name}, [Pid|Rest]) ->
    role:c_apply(async, Pid, {friend, do_logout_notify_guild_async, [{Rid, SrvId, Name}]}),
    do_logout_notify_guild({Rid, SrvId, Name}, Rest).
do_logout_notify_guild_async(#role{link = #link{conn_pid = ConnPid}}, {FrRoleId, FrSrvId, _FrName}) ->
    % notice:inform(util:fbin(?L(<<"您的军团好友~s下线了">>), [_FrName])),
    sys_conn:pack_send(ConnPid, 12145, {FrRoleId, FrSrvId}),
    {ok}.

%% 获取缓存中的好友记录
get_friend(cache, {FrRoleId, FrSrvId}) ->
    Friends = get_dict(sns_role_friends),
    get_friend(list, Friends, {FrRoleId, FrSrvId});
%% 获取其他的好友记录
get_friend(Pid, {FrRoleId, FrSrvId}) when is_pid(Pid) ->
    case role:get_dict(Pid, sns_role_friends) of
        {ok, Friends} ->
            get_friend(list, Friends, {FrRoleId, FrSrvId});
        _ ->
            {false, ?L(<<"好友信息不存在">>)}
    end.

get_friend(list, [Fr = #friend{role_id = RoleId, srv_id =SrvId} | T], {FrRoleId, FrSrvId}) ->
    case RoleId =:= FrRoleId andalso SrvId =:= FrSrvId of
        true ->
            {ok, Fr};
        false ->
            get_friend(list, T, {FrRoleId, FrSrvId})
    end;
get_friend(list, [], {_FrRoleId, _FrSrvId}) ->
    {false, ?L(<<"好友信息不存在">>)};
get_friend(list, undefined, {_FrRoleId, _FrSrvId}) ->
    {false, ?L(<<"好友信息不存在">>)}.



%% 插入好友信息
insert_friend(cache, Friend = #friend{role_id = RoleId, srv_id = SrvId}) ->
    case get_friend(cache, {RoleId, SrvId}) of
        {ok, _Friend} ->
            {false, ?L(<<"好友已经存在">>)};
        {false, _Reason} ->
            Friends = get_dict(sns_role_friends),
            {ok, _} = role:put_dict(sns_role_friends, [Friend | Friends])
    end.

%% 删除缓存中的好友信息
delete_friend(cache, {FrRoleId, FrSrvId}) ->
    case get_dict(sns_role_friends) of
        Friends when is_list(Friends) -> 
                NewFriends = delete_friend(Friends, {FrRoleId, FrSrvId}),
                {ok, _} = role:put_dict(sns_role_friends, NewFriends);
        _ -> ok
    end;
delete_friend([Friend = #friend{role_id = RoleId, srv_id = SrvId} | T], {FrRoleId, FrSrvId}) ->
    case RoleId =:= FrRoleId andalso SrvId =:= FrSrvId of
        true ->
            T;
        false ->
            [Friend | delete_friend(T, {FrRoleId, FrSrvId})]
    end;
delete_friend([], {_FrRoleId, _FrSrvId}) ->
    [].

insert_deleted_friend(Data = {FrRoleId, FrSrvId, _Time}) ->
    case get_dict(deleted_friend) of
        undefined -> role:put_dict(deleted_friend, [Data]);
        false -> skip;
        DelF ->
            case do_get_deleted_friend(DelF, FrRoleId, FrSrvId, []) of
                false ->
                    role:put_dict(deleted_friend, [Data | DelF]);
                {ok, _, Remain} ->
                    role:put_dict(deleted_friend, [Data | Remain])
            end
    end.

%%del_deleted_friend({FrRoleId, FrSrvId}) ->
%%    case get_dict(deleted_friend) of
%%        false -> false;
%%        DelF ->
%%            case do_get_deleted_friend(DelF, FrRoleId, FrSrvId, []) of
%%                false -> false;
%%                {ok, _, Remain} ->
%%                    role:put_dict(delete_friend, Remain)
%%            end
%%    end.

do_get_deleted_friend([], _FrRoleId, _FrSrvId, _Remain) -> false;
do_get_deleted_friend([D = {FrRoleId, FrSrvId, _} | T], FrRoleId, FrSrvId, Remain) -> {ok, D, T ++ Remain};
do_get_deleted_friend([D = {_FrRoleId, _FrSrvId, _} | T], FrRoleId1, FrSrvId1, Remain) ->
    do_get_deleted_friend(T, FrRoleId1, FrSrvId1, [D | Remain]).

get_deleted_friend({FrRoleId, FrSrvId}) ->
    case get_dict(deleted_friend) of
        false -> false;
        undefined -> false;
        DelF ->
            case do_get_deleted_friend(DelF, FrRoleId, FrSrvId, []) of
                false -> false;
                {ok, Ret, _Remain} ->
                    {ok, Ret}
            end
    end.

all_deleted_frd() ->
     case get_dict(deleted_friend) of
        false -> [];
        undefined -> [];
        DelF -> DelF
    end.   

%% 更新缓存好友信息
update_friend(cache, Friend) ->
    Friends = get_dict(sns_role_friends),
    NewFriends = update_friend(Friends, Friend),
    {ok, _} = role:put_dict(sns_role_friends, NewFriends);
update_friend([Fr = #friend{role_id = RoleId, srv_id = SrvId} | T], Friend = #friend{role_id = FrRoleId, srv_id = FrSrvId}) ->
    case RoleId =:= FrRoleId andalso SrvId =:= FrSrvId of
        true ->
            [Friend | T];
        false ->
            [Fr | update_friend(T, Friend)]
    end;
update_friend([], _Friend) ->
    [].

%% 获取字典项
get_dict(DictKey) ->
    case role:get_dict(DictKey) of
        {ok, Data} -> 
            Data;
        _ -> false
    end.

%% 检查
check_all([Cond | T], Role, {FrRoleId, FrSrvId, Type}) ->
    case check_condition(Cond, Role, {FrRoleId, FrSrvId, Type}) of
        {false, Reason} ->
            {false, Reason};
        {ok} ->
            check_all(T, Role, {FrRoleId, FrSrvId, Type})
    end;
check_all([], _Role, {_FrRoleId, _FrSrvId, _Type}) ->
    {ok}.

check_condition(exist, _Role, {FrRoleId, FrSrvId, _Type}) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, _F = #friend{}} ->
            {false, ?L(<<"该玩家已经在你的列表中">>)};
        {false, _Reason} ->
            {ok}
    end;

check_condition(not_exist, _Role, {FrRoleId, FrSrvId, _Type}) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, #friend{}} ->
            {ok};
        {false, _Reason} ->
            {false, ?L(<<"该玩家不存在">>)}
    end;

%% 检查自己好友人数上限
check_condition(max_self, _Role, {_FrRoleId, _FrSrvId, FrType}) ->
    Friends = get_dict(sns_role_friends),
    FriendList = [Fr || Fr = #friend{type = Type} <- Friends, Type =:= FrType],
    % case length(FriendList) >= get_max_fr_num(Role, FrType) of
    case length(FriendList) >= get_max_fr_num2(FrType) of
        true ->
            {false, ?L(<<"你的列表数已经达到上限">>)};
        false ->
            {ok}
    end;

%% 检查是否已经在自己的申请列表了
check_condition(apply_exist, Role, {FrRoleId, FrSrvId, _FrType}) ->
    case is_friend_or_applied(Role, {FrRoleId, FrSrvId}) of 
        true ->
            {false, ?L(<<"对方已经是好友或已向你发送了申请">>)};
        false ->
            {ok} 
    end;

%% 检查对方人数上限
% check_condition(max_friend, _Role, {FrRoleId, FrSrvId, Type = ?sns_friend_type_kuafu}) ->
%     case center:call(c_mirror_group, call, [node, FrSrvId, friend_dao, get_count, [FrRoleId, FrSrvId, Type]]) of
%         0 -> {ok};
%         Num when is_integer(Num) ->
%             case role_api:c_lookup(by_id, {FrRoleId, FrSrvId}, #role.pid) of
%                 {ok, _N, FrPid} when is_pid(FrPid) ->
%                     case role:c_apply(sync, FrPid, {fun sync_get_max_fr_num2/2, [Type]}) of
%                         Max when is_integer(Max) ->
%                             case Num >= Max of
%                                 true -> {false, ?L(<<"对方列表数已经达到上限了">>)};
%                                 false -> {ok}
%                             end;
%                         _ -> {false, ?L(<<"该玩家不在线">>)}
%                     end;
%                 _ -> {false, ?L(<<"该玩家不在线">>)}
%             end;
%         _ -> {false, ?L(<<"该玩家不在线">>)}
%     end;
check_condition(max_friend, _Role, {FrRoleId, FrSrvId, Type}) ->
    case friend_dao:get_count(FrRoleId, FrSrvId, Type) of
        0 -> {ok};
        Num ->
            Max = if
                Type =:= ?sns_friend_type_hy ->
                    case role_api:lookup(by_id, {FrRoleId, FrSrvId}, #role.pid) of
                        {ok, _N, FrPid} when FrPid =:= self() ->
                            get_max_fr_num2(Type);
                        {ok, _N, FrPid} when is_pid(FrPid) ->
                            role:apply(sync, FrPid, {fun sync_get_max_fr_num2/2, [Type]});
                        _ -> ?def_fr_max
                    end;
                true -> ?def_fr_max
            end,
            case Num >= Max of
                true -> {false, ?L(<<"对方列表数已经达到上限了">>)};
                false -> {ok}
            end
    end;

%% 检查自己是否可以添加跨服好友
check_condition(self_kuafu, #role{lev = Lev, attr = #attr{fight_capacity = Fight}}, _) ->
    case Lev >= 52 andalso Fight >= 6500 of
        true -> {ok};
        false ->
            {false, ?L(<<"添加失败，您或对方不满足成为跨服好友条件，添加跨服好友需要等级52战力达到6500">>)}
    end;

%% 检查对方是否在线
check_condition(online, _Role, {FrRoleId, FrSrvId, _Type}) ->
    case role_api:c_lookup(by_id, {FrRoleId, FrSrvId}, [#role.lev, #role.pid, #role.attr]) of
        {ok, Node, [_Lev, _Pid, _]} when Node =:= node() -> {ok};
        {ok, _Node, [Lev, _Pid, #attr{fight_capacity = Fight}]} when Lev >= 52 andalso Fight >= 6500 -> %% 跨服限制
            {ok};
        {ok, _Node, [_Lev, _Pid, _Attr]} ->
            {false, ?L(<<"添加失败，您或对方不满足成为跨服好友条件，添加跨服好友需要等级52战力达到6500">>)};
        _ ->
            {false, ?L(<<"该玩家不在线">>)}
    end;

check_condition(_, _, _) ->
    {ok}.

%% 检查是否所有好友都存在
check_friends_exist(Role, [[FrRoleId, FrSrvId] | T]) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, #friend{}} ->
            check_friends_exist(Role, T);
        {false, _Reason} ->
            {false, ?L(<<"该玩家不在线">>)}
    end;
check_friends_exist(_Role, []) ->
    {ok}.


get_max_fr_num2(?sns_friend_type_hy) ->
    ?def_fr_max;

get_max_fr_num2(?sns_friend_type_msr) ->
    ?def_msr_max;

get_max_fr_num2(_) ->
    0.

%% 获取可以添加的好友最大数量
% get_max_fr_num(Role, ?sns_friend_type_hy) ->
%     ?def_fr_max + vip:effect(max_friend, Role);
% get_max_fr_num(Role, ?sns_friend_type_kuafu) ->
%     ?def_fr_max + vip:effect(max_friend, Role);
% get_max_fr_num(_Role, _FrType) ->
%     ?def_fr_max.


%% 同步获取可以添加的好友最大数量
sync_get_max_fr_num2(_Role, FrType) ->
    {ok, get_max_fr_num2(FrType)}.


%% 同步获取可以添加的好友最大数量
% sync_get_max_fr_num(Role, FrType) ->
%     {ok, get_max_fr_num(Role, FrType)}.

%% 增加所有类型好友，不检查
do_add_friend(_Role = #role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}, name = RoleName, lev = RLev, sex = RSex, career = RCareer,vip = #vip{type = VipType}} 
    % link = #link{conn_pid = ConnPid}}
    ,{FrRoleId, FrSrvId, Type}) ->
   if 
        Type =:= ?sns_friend_type_hy orelse Type =:= ?sns_friend_type_kuafu ->
            ?DEBUG("申请添加好友：~w~w", [FrRoleId, FrSrvId]),
            case role_api:c_lookup(by_id, {FrRoleId, FrSrvId}, #role.pid) of %%检查是否在线,在线则发送消息通知
                {ok, _, Pid} when is_pid(Pid)  ->
                    role:apply(async, Pid, {friend, do_add_friend_dict, [{RoleId, VipType, SrvId, RoleName, RCareer, get_face_id(RCareer, RSex), RLev, RSex}]}),
                    % role:pack_send(Pid, 10932, {100, 1, <<>>}),
                    role:apply(async, Pid, {friend, send_client_notify, []}),
                    ok;
                _ ->
                    ok
            end,                                                                                      
            friend_dao:insert_friend_apply(FrRoleId, {RoleId, VipType, SrvId, RoleName, RCareer, get_face_id(RCareer, RSex), RLev, RSex}),%%将好友申请写入到数据库
            {ok, send};
        true -> %% 以下只处理拉黑名单,或者由陌生人变为黑名单
            GroupId = ?sns_fr_group_id_hmd , %%黑名单，分组id为2
            case sns_dao:get_role_by_id2(FrRoleId, FrSrvId) of  %% 查看好友信息是否存在
                {true, [_, _, FrName, Sex, Career, Lev]} ->
                    Friends = get_friend_list(),
                    List = [F || F = #friend{type = Type1} <- Friends, Type1 == ?sns_friend_type_msr],

                    Add = #friend{role_id = FrRoleId, srv_id = FrSrvId, name = FrName, type = ?sns_friend_type_hmd,
                            career = Career, sex = Sex, lev = Lev, face_id = get_face_id(Career, Sex), group_id = ?sns_fr_group_id_hmd, last_chat = util:unixtime()},
                    
                    case lists:keyfind(FrRoleId, #friend.role_id, List) of 
                        false ->
                            %%之前不是陌生人，则直接拉黑
                            friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, Type, 0, GroupId) ,
                            % insert_friend(cache, Add = #friend{role_id = FrRoleId, srv_id = FrSrvId, name=FrName, group_id = GroupId,
                            %     type = ?sns_friend_type_hmd, career = Career, lev = Lev,  face_id = get_face_id(Career, Sex), last_chat = util:unixtime()}),
                            insert_friend(cache, Add);
                        _ ->
                            delete_friend(cache, {FrRoleId, FrSrvId}),
                            friend_dao:delete_friend(RoleId, SrvId, FrRoleId, FrSrvId),
                            insert_friend(cache, Add),
                            friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, ?sns_friend_type_hmd, 0, 
                                type2groupid(?sns_friend_type_hmd))
                    end,
                    sys_conn:pack_send(ConnPid, 12146, {[Add]}),
                    {ok, add};
                {false, []} -> 
                    {false, <<"没有该玩家信息">>} 
            end
    end.

do_add_friend_dict(_Role = #role{id = {Rid, _}}, {FrRoleId, VipType, FrSrvId, RoleName, RCareer, FaceId, RLev, RSex}) ->
    Data = get_friend_apply(Rid),
    case lists:keyfind(FrRoleId, 1, Data) of 
        false ->
            put_friend_apply(Rid, {FrRoleId, VipType, FrSrvId, RoleName, RCareer, FaceId, RLev, RSex}),
            {ok};
        _ ->
            {ok}
    end.
    % Data2 = get_friend_apply(Rid),

send_client_notify(_Role = #role{id = {Rid, _}, link = #link{conn_pid = ConnPid}, sns = #sns{recv_cnt = Cnt}}) ->
    Data = get_friend_apply(Rid),
    Friends = get_dict(sns_role_friends),
    CanRecvNum =
    case Cnt =< 0 of
        true ->
            0;
        false ->
            length([F || F = #friend{role_id = FrRoleId, srv_id = FrSrvId, recv_flag = ?can_recv} <- Friends, case get_deleted_friend({FrRoleId, FrSrvId}) of {ok,_}-> false; false -> true end])
    end,
    ?DEBUG("   ************* 好友通知信息  ~w    ~w", [length(Data), CanRecvNum]),
    sys_conn:pack_send(ConnPid, 12186, {erlang:length(Data), CanRecvNum}),
    {ok}.

%% 增加好友(回调函数)
do_add_friend_sync(#role{id = {RoleId, SrvId}, link = #link{conn_pid = _ConnPid}}, Friend = #friend{role_id = FrRoleId, srv_id = FrSrvId, 
                    career = Career, sex = Sex, type = Type, name = Name}) ->
    GroupId = case Type of
        ?sns_friend_type_msr->
            ?sns_fr_group_id_msr;
        ?sns_friend_type_cr->
            ?sns_fr_group_id_cr;
        ?sns_friend_type_hmd ->
            ?sns_fr_group_id_hmd;
        _ ->
            ?sns_fr_group_id_hy
    end,
    insert_friend(cache, Friend#friend{face_id = get_face_id(Career, Sex)}),
    friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, Name, Type, 0, GroupId),
    % send_add_friend(ConnPid, {FrRoleId, FrSrvId, Type}),
    {ok}.

%% 发送请求
send_12135(_Role = #role{link = #link{conn_pid = ConnPid}}, RoleId, VipType, SrvId, RoleName, RLev, RSex) ->
    Friends = get_dict(sns_role_friends),
    FriendList = [Fr || Fr = #friend{type = ?sns_friend_type_hy} <- Friends],
    case length(FriendList) >= get_max_fr_num2(?sns_friend_type_hy) of
        true -> ignore;
        false -> sys_conn:pack_send(ConnPid, 12135, [{RoleId, VipType, SrvId, RoleName, RLev, RSex}])
    end,
    {ok}.
        
%% 更新好友类型
do_update_friend_type(#role{id = {RoleId, SrvId}, name = RoleName, lev = Lev, sex = Sex, vip = #vip{type = VipType}}, {FrRoleId, FrSrvId, Type}) ->
    GroupId = type2groupid(Type),
    case Type of
        ?sns_friend_type_hy ->
            role_group:pack_send({FrRoleId, FrSrvId}, 12135, [{RoleId, VipType, SrvId, RoleName, Lev, Sex}]), 
            {ok, ?sns_friend_type_hy};
        ?sns_friend_type_kuafu ->
            {false, ?L(<<"跨服好友不支持设置分组">>)};
        _Other ->
            case global:whereis_name({role, FrRoleId, FrSrvId}) of
                Pid when is_pid(Pid) ->
                    role:apply(async, Pid, {friend, do_update_friend_type_sync, [RoleId, SrvId, Type]});
                _ ->
                    friend_dao:update_friend_type(FrRoleId, FrSrvId, RoleId, SrvId, Type)
            end,
            {ok, Friend = #friend{career = C, sex = S}} = get_friend(cache, {FrRoleId, FrSrvId}),
            NewFriend = Friend#friend{type = Type, group_id = GroupId},
            delete_friend(cache, {FrRoleId, FrSrvId}),
            insert_friend(cache, NewFriend#friend{face_id = get_face_id(C, S)}),
            friend_dao:update_friend_type(RoleId, SrvId, FrRoleId, FrSrvId, Type),
            {ok, Type}
    end.

%% 更新好友类型(回调函e)
do_update_friend_type_sync(#role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}, FrRoleId, FrSrvId, Type) ->
    {ok, Friend = #friend{career = C, sex = S}} = get_friend(cache, {FrRoleId, FrSrvId}),
    GroupId = type2groupid(Type),
    NewFriend = Friend#friend{type = Type, group_id = GroupId},
    delete_friend(cache, {FrRoleId, FrSrvId}),
    insert_friend(cache, NewFriend#friend{face_id = get_face_id(C, S)}),
    friend_dao:update_friend_type(RoleId, SrvId, FrRoleId, FrSrvId, Type),
    send_upd_friend(ConnPid, {FrRoleId, FrSrvId, Type}),
    {ok}.

%% 同意加为好友
% do_agree_add_friend(Role = #role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}, FrRoleId, FrSrvId, Type)
% when Type =:= ?sns_friend_type_kuafu ->
%     %% 同意跨服好友
%     case role_api:c_lookup(by_id, {FrRoleId, FrSrvId}, #role.pid) of
%         {ok, Node, Pid} when (Node =/= node()) ->
%             {ok, MyFrOnline} = get_self_info(Role),
%             MySelfFriend = convert_to_friend(friend_online, #friend{type = Type, group_id = type2groupid(Type), role_id = RoleId, srv_id = SrvId, online = 1}, MyFrOnline),
%             case role:c_apply(sync, Pid, {friend, do_agree_add_friend_sync, [MySelfFriend]}) of
%                 {ok, MyFriend} -> %% 亲密度会从这里回传一次，防止好友变仇人之后，再添加为好友的问题
%                     delete_friend(cache, {FrRoleId, FrSrvId}),
%                     insert_friend(cache, MyFriend#friend{type = Type}),
%                     case friend_dao:get_friend_by_id(RoleId, SrvId, FrRoleId, FrSrvId) of
%                         {false, _} ->
%                             send_add_friend(ConnPid, {FrRoleId, FrSrvId, Type}),
%                             friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, MyFriend#friend.name, Type, 0, type2groupid(Type));
%                         {true, _} ->
%                             send_upd_friend(ConnPid, {FrRoleId, FrSrvId, Type}),
%                             friend_dao:update_friend_type(RoleId, SrvId, FrRoleId, FrSrvId, Type)
%                     end,
%                     {ok};
%                 _ -> {false, ?L(<<"该玩家不在线">>)}
%             end;
%         _ ->
%             {false, ?L(<<"该玩家不在线">>)}
%     end;

%% 同意加为好友    
do_agree_add_friend(Role = #role{id = {RoleId, SrvId}, link = #link{conn_pid = _ConnPid}, name = MyName}, FrRoleId, FrSrvId, Type) ->

    ?DEBUG("***-----role_id:~w~w~n",[FrRoleId, FrSrvId]),
    Result = 
        case role_api:lookup(by_id, {FrRoleId, FrSrvId}, to_role) of
            {ok, _, #role{pid = Pid, lev = Lev, name = Name, sex = Sex, career = Career}} ->
                
                {ok, MyFrOnline} = get_self_info(Role),
                MySelfFriend = convert_to_friend(friend_online, #friend{type = Type, group_id = type2groupid(Type), role_id = RoleId, srv_id = SrvId, online = 1}, MyFrOnline),
                role:apply(sync, Pid, {friend, do_agree_add_friend_sync, [MySelfFriend]}),
                role:apply(async, Pid, {medal, listener, [friend]}), %%等测试
                role:pack_send(Pid, 10932, {6, 0, util:fbin(?L(<<"~s已成功添加您为好友！">>), [MyName])}),
                delete_friend(cache, {FrRoleId, FrSrvId}),
                insert_friend(cache, _NewFriend = #friend{role_id = FrRoleId, name = Name, srv_id = FrSrvId, type = ?sns_friend_type_hy, career = Career, sex = Sex,
                    lev = Lev,  online = 1, face_id = get_face_id(Career, Sex), pid = Pid, group_id = ?sns_fr_group_id_hy}),

                %%增量推送新加的好友
                sys_conn:pack_send(_ConnPid, 12146, {[_NewFriend]}),
                {ok, NRole} = medal:listener(Role, friend), %%
                {ok, NRole, Name};

            _ -> %%不在线,操作数据
                case sns_dao:get_role_by_id2(FrRoleId, FrSrvId) of  %% 查看好友是否存在
                    {true, [_, _, Name, Sex, Career, Lev]} ->
                        delete_friend(cache, {FrRoleId, FrSrvId}),
                        insert_friend(cache, _NewFriend = #friend{role_id = FrRoleId, name = Name, srv_id = FrSrvId, type = ?sns_friend_type_hy, career = Career, sex = Sex,
                            lev = Lev, online = 0, face_id = get_face_id(Career, Sex), group_id = ?sns_fr_group_id_hy}),

                        sys_conn:pack_send(_ConnPid, 12146, {[_NewFriend]}),
                        {ok, NRole} = medal:listener(Role, friend), %%是不是应该移到result下面会比较保险
                        
                        case friend_dao:get_friend_by_id(FrRoleId, FrSrvId, RoleId, SrvId) of %%是否已在对方列表
                            {false, _} ->
                                case friend_dao:get_count(FrRoleId, FrSrvId, Type) of 
                                    Num when Num >= ?def_fr_max ->
                                        % {false, <<"对方好友人数已达到最大值">>};
                                        {ok, NRole, Name};
                                    _ -> 
                                        friend_dao:insert_friend(FrRoleId, FrSrvId, RoleId, SrvId, MyName, Type, 0, type2groupid(Type)),
                                        friend_dao:insert_friend_agree_message(FrRoleId, MyName),
                                        {ok, NRole, Name}
                                end;
                            {true, [FrRoleId, FrSrvId, RoleId, SrvId, _, _, _, _]} ->
                                friend_dao:update_friend_type(FrRoleId, FrSrvId, RoleId, SrvId, Type),
                                {ok, NRole, Name}
                        end;
                    {false, _} ->
                        {false, <<"好友信息不存在">>}
                end

        end,
    case Result of 
        {ok, NRole2, FrName} ->
            case friend_dao:get_friend_by_id(RoleId, SrvId, FrRoleId, FrSrvId) of
                        {false, _} ->
                            friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, Type, 0, type2groupid(Type));
                        {true, [RoleId, SrvId, FrRoleId, FrSrvId, _, _, _, _]} ->
                            friend_dao:update_friend_type(RoleId, SrvId, FrRoleId, FrSrvId, Type)
            end,
            friend_dao:delete_friend_apply(RoleId, FrRoleId),
            delete_friend_apply(RoleId, {FrRoleId, FrSrvId}),
            {ok, NRole2};
        _ ->
            Result
    end.

%% 同意加为好友
do_agree_add_friend_sync(Role = #role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}, Friend = #friend{type = Type, role_id = FrRoleId, srv_id = FrSrvId, name = FrName, sex = Sex, career = Career}) ->
    NewFriend = #friend{intimacy = Intimacy} = case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, CacheFriend} ->
            Friend#friend{intimacy = CacheFriend#friend.intimacy};
        {false, _Reason} ->
            Friend
    end,
    delete_friend(cache, {FrRoleId, FrSrvId}),
    insert_friend(cache, _NewAdd = NewFriend#friend{face_id = get_face_id(Career, Sex), type = ?sns_friend_type_hy, online = 1}),
    case friend_dao:get_friend_by_id(RoleId, SrvId, FrRoleId, FrSrvId) of
        {false, _} ->
            friend_dao:insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, Type, 0, type2groupid(Type));
        {true, _} ->
            friend_dao:update_friend_type(RoleId, SrvId, FrRoleId, FrSrvId, Type)
    end,
    sys_conn:pack_send(ConnPid, 12146, {[_NewAdd]}),
    % case (util:rand(1, 10) =< 3) andalso (Type =/= ?sns_friend_type_kuafu) of
    %     true -> erlang:send_after(120 * 1000, self(), {apply_async, {friend, rand_chat, [FrRoleId, FrSrvId, FrName, Sex]}});
    %     false -> ignore
    % end,
    {ok, MyFrOnline} = get_self_info(Role),
    MySelfFriend = 
        case Intimacy > 0 of
            true -> %% TODO: 暂时用于解决双方亲密不一致的bug(2012/10/15更新:仇人重新添加好友)
                F = #friend{intimacy = Intimacy, type = Type, group_id = type2groupid(Type), role_id = RoleId, srv_id = SrvId, online = 1},
                convert_to_friend(friend_online, F, MyFrOnline);
            false ->
                F = #friend{type = Type, group_id = type2groupid(Type), role_id = RoleId, srv_id = SrvId, online = 1},
                convert_to_friend(friend_online, F, MyFrOnline)
        end,
    case catch role_listener:make_friend(Role, #friend{type = ?sns_friend_type_hy}) of
        NewRole2 when is_record(NewRole2, role) ->
            {ok, {ok, MySelfFriend}, NewRole2};
        _ ->
            {ok, {ok, MySelfFriend}}
    end.

%% 好友随机信息
rand_chat(_Role = #role{link = #link{conn_pid = ConnPid}}, FrRoleId, FrSrvId, FrName, Sex) ->
    sys_conn:pack_send(ConnPid, 10920, {FrRoleId, FrSrvId, FrName, Sex, [], util:rand_list(?sns_chat_content)}),
    {ok}.

%% 获取好友分组中的好友列表
get_friend_by_group_id(FrGroupId) ->
    Friends = get_dict(sns_role_friends),
    [Friend || Friend = #friend{group_id = GroupId} <- Friends, GroupId =:= FrGroupId].

%% 更新好友分组信息
update_friend_group_type(Role = #role{id = {RoleId, SrvId}}, [Friend = #friend{role_id = FrRoleId, srv_id = FrSrvId} | T], NewGroupType) ->
    update_friend(cache, Friend#friend{group_id = NewGroupType}),
    friend_dao:update_friend_group(RoleId, SrvId, FrRoleId, FrSrvId, NewGroupType),
    update_friend_group_type(Role, T, NewGroupType);
update_friend_group_type(_Role, [], _NewGroupType) ->
    ok.

%% 变更好友类型
update_friend_group_type2(Role = #role{id = {RoleId, SrvId}}, NewGroupId, [[FrRoleId, FrSrvId] | T]) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, #friend{type = ?sns_friend_type_kuafu}} ->
            {false, ?L(<<"跨服好友不能设置好友分组">>)};
        {ok, Friend} ->
            update_friend(cache, Friend#friend{group_id = NewGroupId}),
            friend_dao:update_friend_group(RoleId, SrvId, FrRoleId, FrSrvId, NewGroupId),
            update_friend_group_type2(Role, NewGroupId, T);
        _ ->
            {false, ?L(<<"不能操作非好友玩家">>)}
    end;
update_friend_group_type2(_Role, _NewGroupId, []) ->
    {ok}.


%%
%%判断是否是朋友或者是否已发送添加好友申请
is_friend_or_applied(_Role = #role{id = {Rid, _}}, {FrRoleId, FrSrvId}) ->
    % case get_friend(cache, {FrRoleId, FrSrvId}) of
    case is_friend({FrRoleId, FrSrvId}) of
        {true, _} -> 
            true;
        _ -> 
            Data = get_friend_apply(Rid),
            case lists:keyfind(FrRoleId, 1, Data) of 
                false -> false;
                _ -> true
            end
    end.

put_friend_apply(Rid, {FrRoleId, VipType, FrSrvId, RoleName, RCareer, FaceId, RLev, RSex}) ->
    Data = get_friend_apply(Rid),
    case lists:keyfind(FrRoleId, 1, Data) of 
        false ->
            NData = [{FrRoleId, VipType, FrSrvId, RoleName, RCareer, FaceId, RLev, RSex}] ++ Data,
            ?DEBUG("---NData---~p~n", [NData]),
            role:put_dict(friend_apply, NData),
            ok;
        _ ->
            ok
    end.

get_friend_apply(RoleId) ->
    NData = 
        case role:get_dict(friend_apply) of
            {ok, Data} -> 
                case Data of 
                    undefined -> undefined;
                    _ -> Data
                end;
            _ -> 
                undefined
        end,
    case NData of 
        undefined -> 
            case friend_dao:get_friend_apply(RoleId) of 
                {true, D} ->
                    ?DEBUG("wwww获取好友申请数据:[Msg:~w]", [D]),
                    D1 = [list_to_tuple(E)||E<-D],
                    role:put_dict(friend_apply, D1),
                    D1;
                {false, _} ->
                    role:put_dict(friend_apply, []),
                    []
            end;
        _ ->
            NData
    end.

delete_friend_apply(Rid, {FrRoleId, _FrSrvId}) ->
    Data = get_friend_apply(Rid),
    NData = lists:keydelete(FrRoleId, 1, Data),
    role:put_dict(friend_apply, NData).


%% @spec is_friend(Friend) -> {true, Fr} | true | false
%% @doc 判断是不是好友
is_friend({FrRoleId, FrSrvId}) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Friend = #friend{type = Type}} when Type =:= ?sns_friend_type_hy orelse Type =:= ?sns_friend_type_kuafu -> {true, Friend};
        _ -> false
    end;
is_friend(#friend{type = Type}) ->
    case Type =:= ?sns_friend_type_hy orelse Type =:= ?sns_friend_type_kuafu of
        true -> true;
        false -> false
    end.

%% 判断是不是黑名单成员
is_blacklist({FrRoleId, FrSrvId}) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Friend = #friend{type = ?sns_friend_type_hmd}} -> {true, Friend};
        _ -> false
    end.

%% 判断是不是跨服好友
is_kuafu_friend({FrRoleId, FrSrvId}) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Friend = #friend{type = ?sns_friend_type_kuafu}} -> {true, Friend};
        _ -> false
    end.

%% 刷新客户端角色亲密度
pack_send_intimacy(Pid, {FrRoleId, FrSrvId}) when is_pid(Pid) ->
    role:apply(async, Pid, {friend, do_pack_send_intimacy, [{FrRoleId, FrSrvId}]});
pack_send_intimacy(Role = #role{}, {FrRoleId, FrSrvId}) ->
    role:apply(async, Role#role.pid, {friend, do_pack_send_intimacy, [{FrRoleId, FrSrvId}]}).
do_pack_send_intimacy(#role{link = #link{conn_pid = ConnPid}}, {FrRoleId, FrSrvId}) ->
    case is_friend({FrRoleId, FrSrvId}) of
        {true, #friend{intimacy = Intimacy}} ->
            sys_conn:pack_send(ConnPid, 12163, {FrRoleId, FrSrvId, Intimacy});
        false -> skip
    end,
    {ok}.

%% 刷新角色亲密度
pack_send_intimacy(remote, Pid, {FrRoleId, FrSrvId}) when is_pid(Pid) ->
    role:c_apply(async, Pid, {friend, do_pack_send_cross_intimacy, [{FrRoleId, FrSrvId}]});
pack_send_intimacy(local, Pid, {FrRoleId, FrSrvId}) when is_pid(Pid) ->
    role:apply(async, Pid, {friend, do_pack_send_cross_intimacy, [{FrRoleId, FrSrvId}]}).

do_pack_send_cross_intimacy(#role{link = #link{conn_pid = ConnPid}}, {FrRoleId, FrSrvId}) ->
    case is_kuafu_friend({FrRoleId, FrSrvId}) of
        {true, #friend{intimacy = Intimacy}} ->
            sys_conn:pack_send(ConnPid, 12163, {FrRoleId, FrSrvId, Intimacy});
        false -> skip
    end,
    {ok}.

%% 判断是否更新角色送花积分和魅力积分跨区间
%% 返回true表示重置送花时间
update_rank_time(LastTime, Now) ->
    Today = util:unixtime(today),
    Last = util:unixtime({today, LastTime}),
    TickTime = 71400 + Today,
    LastTick = 71400 + Last,
    case Today =:= Last of
        true -> LastTime < TickTime andalso Now >= TickTime;
        false ->
            case Last + 86400 =:= Today of
                true ->
                    case LastTime >= LastTick andalso Now < TickTime of
                        true -> false;
                        false -> true
                    end;
                false -> true
            end
    end.

%% 增加角色魅力值
incr_charm(Role, Val) ->
    {ok, NewRole}= role_gain:do([#gain{label = charm, val = Val}], Role),
    L = NewRole#role.rank,
    Now = util:unixtime(),
    Nr = case lists:keyfind(?rank_glamor_day, 1, L) of
        false ->
            NewRole#role{rank = [{?rank_glamor_day, Val, Now} | L]};
        {?rank_glamor_day, V, Time} ->
            case update_rank_time(Time, Now) of
                true -> %% 重置
                    NewL = clean_old_data(?rank_glamor_day, L),
                    NewRole#role{rank = [{?rank_glamor_day, Val, Now} | NewL]};
                false ->
                    NewL = clean_old_data(?rank_glamor_day, L),
                    NewRole#role{rank = [{?rank_glamor_day, V + Val, Now} | NewL]}
            end
    end,
    rank:listener(glamor, Nr),
    rank:listener(glamor_day, Nr),
    {ok, role_listener:special_event(Nr, {20018, Nr#role.assets#assets.charm})}.

%% 增加送花积分
incr_flower(Role, Val) ->
    {ok, NewRole} = role_gain:do([#gain{label = flower, val = Val}], Role),
    L = NewRole#role.rank,
    Now = util:unixtime(),
    Nr = case lists:keyfind(?rank_flower_day, 1, L) of
        false ->
            NewRole#role{rank = [{?rank_flower_day, Val, Now} | L]};
        {?rank_flower_day, V, Time} ->
            case update_rank_time(Time, Now) of
                true -> %% 重置
                    NewL = clean_old_data(?rank_flower_day, L),
                    NewRole#role{rank = [{?rank_flower_day, Val, Now} | NewL]};
                false ->
                    NewL = clean_old_data(?rank_flower_day, L),
                    NewRole#role{rank = [{?rank_flower_day, V + Val, Now} | NewL]}
            end
    end,
    rank:listener(flower, Nr),
    rank:listener(flower_day, Nr),
    {ok, role_listener:special_event(Nr, {20017, Nr#role.assets#assets.flower})}.

%% 清除旧的送花数据
clean_old_data(Type, L) -> 
    clean_old_data(Type, L, []).
clean_old_data(_, [], Data) ->
    lists:reverse(Data);
clean_old_data(Type, [{Type, _, _} | T], Data) ->
    clean_old_data(Type, T, Data);
clean_old_data(Type, [H | T], Data) ->
    clean_old_data(Type, T, [H | Data]).

%% 增加跨服好友亲密度
incr_cross_intimacy(Role = #role{pid = RolePid, id = {Rid, SrvId}, name = Name, team_pid = TeamPid}, {FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark) ->
    case is_kuafu_friend({FrRoleId, FrSrvId}) of
        {true, Friend = #friend{name = FrName, intimacy = Intimacy}} ->
            notice:inform(RolePid, util:fbin(?L(<<"获得 {str,亲密度,#f65e6a} ~w">>), [Val])),
            update_friend(cache, Friend#friend{intimacy = Intimacy + Val}),
            friend_dao:update_friend_intimacy(Rid, SrvId, FrRoleId, FrSrvId, Intimacy + Val),
            NewRole = role_listener:special_event(Role, {20009, update}), %%好友亲密度改变
            log:log(log_intimacy, {Rid, SrvId, Name, FrRoleId, FrSrvId, FrName, Intimacy, Intimacy+Val, ReMark}),
            case NeedUpdate of
                ?true ->
                    case is_pid(TeamPid) of
                        true ->
                            case team:get_team_info(TeamPid) of
                                {ok, #team{leader = Leader, member = MemberList}} ->
                                    MemList = [{MPid, MRid} || #team_member{id = MRid, pid = MPid, mode = 0} <- [Leader | MemberList]],
                                    case MemList of
                                        [] -> skip;
                                        _ -> 
                                            case lists:keyfind({FrRoleId, FrSrvId}, 2, MemList) of
                                                false -> skip;
                                                _ -> refresh_buff(MemList)
                                            end
                                    end;
                                _Any -> skip
                            end;
                        _ -> skip
                    end;
                _ -> skip
            end,
            {ok, NewRole};
        false -> {ok}
    end.

%% 增加角色亲密度
incr_intimacy(Role = #role{pid = RolePid, id = {Rid, SrvId}, name = Name, team_pid = TeamPid}, {FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark) ->
    case is_friend({FrRoleId, FrSrvId}) of
        {true, Friend = #friend{name = FrName, intimacy = Intimacy}} ->
            notice:inform(RolePid, util:fbin(?L(<<"获得 {str,亲密度,#f65e6a} ~w">>), [Val])),
            update_friend(cache, Friend#friend{intimacy = Intimacy + Val}),
            friend_dao:update_friend_intimacy(Rid, SrvId, FrRoleId, FrSrvId, Intimacy + Val),
            NewRole = role_listener:special_event(Role, {20009, update}), %%好友亲密度改变
            case NeedUpdate of
                ?true ->
                    log:log(log_intimacy, {Rid, SrvId, Name, FrRoleId, FrSrvId, FrName, Intimacy, Intimacy+Val, ReMark}),
                    case is_pid(TeamPid) of
                        true ->
                            case team:get_team_info(TeamPid) of
                                {ok, #team{leader = Leader, member = MemberList}} ->
                                    MemList = [{MPid, MRid} || #team_member{id = MRid, pid = MPid, mode = 0} <- [Leader | MemberList]],
                                    case MemList of
                                        [] -> skip;
                                        _ -> 
                                            case lists:keyfind({FrRoleId, FrSrvId}, 2, MemList) of
                                                false -> skip;
                                                _ -> refresh_buff(MemList)
                                            end
                                    end;
                                _Any -> skip
                            end;
                        _ -> skip
                    end;
                _ -> skip
            end,
            {ok, NewRole};
        false ->
            {ok}
    end.
    
%% 增加角色和一位好友的亲密度
add_intimacy(To, From, Val) ->
    add_intimacy(To, From, Val, <<>>).
add_intimacy(Role = #role{}, {FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark) ->
    role:apply(async, Role#role.pid, {friend, incr_intimacy, [{FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark]});
add_intimacy(Pid, {FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark) when is_pid(Pid) ->
    role:apply(async, Pid, {friend, incr_intimacy, [{FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark]}).

%% 增加跨服角色亲密度
add_cross_intimacy(Type, To, From, Val) ->
    add_cross_intimacy(Type, To, From, Val, <<>>).
add_cross_intimacy(local, Pid, {FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark) when is_pid(Pid) ->
    role:apply(async, Pid, {friend, incr_cross_intimacy, [{FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark]});
add_cross_intimacy(remote, Pid, {FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark) when is_pid(Pid) ->
    role:c_apply(async, Pid, {friend, incr_cross_intimacy, [{FrRoleId, FrSrvId, NeedUpdate}, Val, ReMark]}).

%% 鲜花特效广播
flower_cast(12, _, _) ->
    notice:effect(34, <<>>);
flower_cast(11, _, _) ->
    notice:effect(33, <<>>);
flower_cast(10, _, _RecvPid) ->
    notice:effect(32, <<>>);
flower_cast(9, _, _RecvPid) ->
    notice:effect(31, <<>>);
flower_cast(8, _, RecvPid) ->
    notice:effect({21, RecvPid}, <<>>);
flower_cast(7, _, _) ->
    notice:effect(18, <<>>);
flower_cast(6, _, _) ->
    notice:effect(12, <<>>);
flower_cast(5, _, _) ->
    notice:effect(2, <<>>);
flower_cast(4, _, _) ->
    notice:effect(1, <<>>);
flower_cast(_Type, Val, _) when Val >= 999 ->
    notice:effect(0, <<>>);
flower_cast(_Type, Val, RecvPid) when Val >= 99 ->
    notice:effect({0, RecvPid}, <<>>);
flower_cast(_, _, _) -> skip.

cross_flower_cast(12, _, _) ->
    notice:effect(34, <<>>);
cross_flower_cast(11, _, _) ->
    notice:effect(33, <<>>);
cross_flower_cast(7, _, _) ->
    notice:effect(18, <<>>);
cross_flower_cast(6, _, _) ->
    notice:effect(12, <<>>);
cross_flower_cast(5, _, _) ->
    notice:effect(2, <<>>);
cross_flower_cast(4, _, _) ->
    notice:effect(1, <<>>);
cross_flower_cast(_Type, Val, _) when Val >= 999 ->
    notice:effect(0, <<>>);
cross_flower_cast(_, _, _) -> skip.


%% 传闻广播
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 12, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"钻石永恒久，一颗永珍藏！~s向~s赠送一枚定情钻戒，真是羡煞旁人啊！">>) , [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 11, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"~s携手~s将999朵粉红满天星洒向天空，与全服仙友分享满天星的清纯，共享这一刻的喜悦！！">>) , [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 10, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"~s将99朵蝴蝶兰抛向空中，如梦如幻的紫色花瓣描绘出~s的动人容颜，漫天飘散着高洁美丽的蝴蝶兰！！">>) , [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 9, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"~s将99朵香百合抛向空中，向~s诉说着与你一起如同天堂的深情，漫天飘散着洁白的百合花瓣！！">>) , [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 8, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"~s童趣大发，拿起雪球调皮地向~s扔了过去，雪花四溅，欢乐无穷！{open, 54, 我要扔雪球, #00ff24}">>) , [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 7, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"看那天空中绽放出千万朵美丽的鲜花，是~s携~s为天下教师献上的祝福，教师节快乐！">>) , [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 6, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"看那天空中绽放出千万朵美丽的太阳花，是~s携~s为天下慈父献上的祝福，父亲节快乐！">>) , [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 5, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"看那天空中绽放出千万朵美丽的康乃馨，是~s携~s一齐向全天下的母亲送上的祝福，母亲节快乐！">>), [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, 4, _) ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>) 
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"~s将999朵蓝色妖姬抛向空中，凌空拼出~s的名字，漫天飘散着妖媚的蓝色花瓣！！">>), [SendRoleMsg, RecvRoleMsg]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, _, Val) when Val >= 999 ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>)
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"~s赠送了~s{str, ~w, #f65e6a}朵玫瑰，天空下起了浪漫的花瓣雨！！">>), [SendRoleMsg, RecvRoleMsg, Val]));
broad_cast_msg(NameCode, SendRid, SendSrvId, SendName, RecvRid, RecvSrvId, RecvName, _, Val) when Val >= 99 ->
    SendRoleMsg = case NameCode =:= 0 of
        true -> util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[SendRid, SendSrvId, SendName]);
        false -> ?L(<<"神秘人">>)
    end,
    RecvRoleMsg = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>,[RecvRid, RecvSrvId, RecvName]),
    notice:send(53, util:fbin(?L(<<"~s赠送了~s{str, ~w, #f65e6a}朵玫瑰，~s感动得落下眼泪！">>), [SendRoleMsg, RecvRoleMsg, Val, RecvRoleMsg]));
broad_cast_msg(_, _, _, _, _, _, _, _, _) -> skip.


%% BaseId换成值
baseid_to_val(33002) -> 1;
baseid_to_val(33003) -> 99;
baseid_to_val(33004) -> 999;
baseid_to_val(33045) -> 999;
baseid_to_val(33048) -> 99;
baseid_to_val(33079) -> 99;
baseid_to_val(33117) -> 99;
baseid_to_val(33176) -> 9;
baseid_to_val(33198) -> 99;
baseid_to_val(33200) -> 99;
baseid_to_val(33201) -> 999;
baseid_to_val(33203) -> 999;
baseid_to_val(_) -> 1.

%% 把好友信息分组
to_team_member([{_Pid, _Rid}]) ->
    [{_Pid, _Rid, []}];
to_team_member([{Pid1, Rid1}, {Pid2, Rid2}]) ->
    [{Pid1, Rid1, [Rid2]}, {Pid2, Rid2, [Rid1]}];
to_team_member([{Pid1, Rid1}, {Pid2, Rid2}, {Pid3, Rid3} | _]) ->
    [{Pid1, Rid1, [Rid2, Rid3]}, {Pid2, Rid2, [Rid1, Rid3]}, {Pid3, Rid3, [Rid1, Rid2]}].

%% 角色加buff
do_refresh_buff([{RolePid, _Rid, FrList} | T]) ->
    role:c_apply(async, RolePid, {fun do_refresh_buff/2, [FrList]}),
    do_refresh_buff(T);
do_refresh_buff([]) ->
    ok.

%% 角色进程
do_refresh_buff(Role = #role{name = _Name}, FrList) ->
    Intimacy = calc_max_intimacy(FrList),
    BuffLabel = if
        Intimacy < 600 -> null;
        Intimacy < 2000 -> sns_buff_lv1;
        Intimacy < 4000 -> sns_buff_lv2;
        Intimacy < 7000 -> sns_buff_lv3;
        Intimacy < 12000 -> sns_buff_lv4;
        true -> sns_buff_lv5
    end,
    Role0 = clear_all_sns_buff(Role, ?sns_buff_list),
    NewRole = case BuffLabel of
        null -> Role0;
        _ ->
            case buff:add(Role0, BuffLabel) of
                {ok, NR} -> NR;
                {false, _Reason} -> Role0
            end
    end,
    {ok, role_api:push_attr(NewRole)}.

%% 清除所有的亲密度buff
clear_all_sns_buff(Role, [Label | T]) ->
    case buff:del_buff_by_label_no_push(Role, Label) of
        {ok, NewRole} ->
            clear_all_sns_buff(NewRole, T);
        false ->
            clear_all_sns_buff(Role, T)
    end;
clear_all_sns_buff(Role, []) ->
    Role.

%% 算计最大亲密度
calc_max_intimacy([{FrRoleId, FrSrvId} | T]) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, #friend{type = Type, intimacy = Intimacy}} when Type=:=?sns_friend_type_hy orelse Type=:=?sns_friend_type_kuafu ->
            Tint = calc_max_intimacy(T),
            case Intimacy > Tint of
                true -> Intimacy;
                false -> Tint
            end;
        _ -> calc_max_intimacy(T)
    end;
calc_max_intimacy([]) ->
    0.

%% 删除亲密度buff
do_remove_buff(Role) ->
    NewRole = clear_all_sns_buff(Role, ?sns_buff_list),
    %% NewRole2 = role_api:push_attr(NewRole),
    {ok, NewRole}.

%% 刺杀，好友变仇人
do_combat_over(winner, [], _Loser) -> ok;
do_combat_over(winner, [Fighter = #fighter{pid = RolePid, type = ?fighter_type_role} | T], Loser) ->
    case is_pid(RolePid) andalso is_process_alive(RolePid) of
        true ->
            do_combat_over(loser, Fighter, Loser),
            do_combat_over(winner, T, Loser);
        false -> do_combat_over(winner, T, Loser)
    end;
do_combat_over(winner, [_Fighter | T], Loser) ->
    do_combat_over(winner, T, Loser);
do_combat_over(loser, _Fighter, []) -> ok;
do_combat_over(loser, Fighter = #fighter{pid = RolePid, rid = RoleId, srv_id = SrvId}, [#fighter{pid = LoserPid, rid = LoserRoleId, srv_id = LoserSrvId, type = ?fighter_type_role} | T]) ->
    case role:apply(sync, RolePid, {friend, apply_kill_update_type, [sync_db, LoserRoleId, LoserSrvId]}) of
        true -> role:apply(async, LoserPid, {friend, apply_kill_update_type, [not_sync_db, RoleId, SrvId]});
        false -> ignore
    end,
    do_combat_over(loser, Fighter, T);
do_combat_over(loser, Fighter, [_Loser | T]) ->
    do_combat_over(loser, Fighter, T);

%% 好友组友打副本，一怪增加一个亲密度
do_combat_over(intimacy, [], _Loser) -> ok;
do_combat_over(intimacy, [Fighter = #fighter{type = ?fighter_type_role, pid = Pid} | T], Loser) when is_pid(Pid) ->
    Add = length(Loser),
    case role_api:lookup(by_pid, Pid, #role.event) of
        {ok, _, ?event_dungeon} ->
            case group_team_member([Fighter | T]) of
                [] -> ok;
                GroupList -> intimacy_dungeon(GroupList, Add)
            end;
        _ -> ok
    end;
do_combat_over(intimacy, [_Fighter | T], Loser) ->
    do_combat_over(intimacy, T, Loser).

%% 同步:修改好友类型为仇人
apply_kill_update_type(Role = #role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}, sync_db, FrRoleId, FrSrvId) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Friend = #friend{type = ?sns_friend_type_hy}} -> 
            NewFriend = Friend#friend{type = ?sns_friend_type_cr, group_id = ?sns_fr_group_id_cr},
            delete_friend(cache, {FrRoleId, FrSrvId}),
            insert_friend(cache, NewFriend),
            friend_dao:update_friend_type(RoleId, SrvId, FrRoleId, FrSrvId, ?sns_friend_type_cr),
            friend_dao:update_friend_type(FrRoleId, FrSrvId, RoleId, SrvId, ?sns_friend_type_cr),
            send_upd_friend(ConnPid, {FrRoleId, FrSrvId, ?sns_friend_type_cr}),
            {ok, true};
        {false, _Reason} ->
            add_friend(Role, ?sns_friend_type_cr, FrRoleId, FrSrvId),
            {ok, false};
        _ -> {ok, false} 
    end;
%% 异步:修改好友类型为仇人
apply_kill_update_type(_Role = #role{link = #link{conn_pid = ConnPid}}, not_sync_db, FrRoleId, FrSrvId) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Friend = #friend{type = ?sns_friend_type_hy}} -> 
            NewFriend = Friend#friend{type = ?sns_friend_type_cr, group_id = ?sns_fr_group_id_cr},
            delete_friend(cache, {FrRoleId, FrSrvId}),
            insert_friend(cache, NewFriend),
            send_upd_friend(ConnPid, {FrRoleId, FrSrvId, ?sns_friend_type_cr}),
            {ok};
        _ ->
            {ok}
    end.

%% 发送好友祝福提示
notice_friend_wish(Role) ->
    Friends = get_dict(sns_role_friends),
    FriendsHy = [Friend || Friend = #friend{type = ?sns_friend_type_hy, online = 1} <- Friends],
    request_friend_wish(FriendsHy, Role).
request_friend_wish([], _Role) -> ok;
request_friend_wish([#friend{role_id = FrRoleId, srv_id = FrSrvId} | T], Role = #role{id = {RoleId, SrvId}, name = Name, lev = Lev}) ->
    case global:whereis_name({role, FrRoleId, FrSrvId}) of
        FrPid when is_pid(FrPid) ->
            role:apply(async, FrPid, {friend, apply_request_friend_wish, [RoleId, SrvId, Name, Lev]}),
            ok;
        _ -> ok 
    end,
    request_friend_wish(T, Role).

apply_request_friend_wish(#role{link = #link{conn_pid = ConnPid}, lev = RoleLev, sns = #sns{wish_times = {Date, Times}}}, FrRoleId, FrSrvId, FrName, FrLev) ->
    case today() =:= Date andalso Times >= 20 of
        true -> {ok};
        false ->
            case friend_data_wish:wish(RoleLev) of
                false -> {ok};
                Exp ->
                    sys_conn:pack_send(ConnPid, 12170, {FrRoleId, FrSrvId, FrName, FrLev, Exp, Times}),
                    {ok}
            end
    end.

%% 队员分组
group_team_member([]) -> [];
group_team_member([_Fighter]) -> [];
group_team_member([#fighter{pid = RolePid1}, #fighter{rid = RoleId2, srv_id = SrvId2}]) ->
    [{RolePid1, [{RoleId2, SrvId2}]}];
group_team_member([#fighter{pid = RolePid1}, #fighter{pid = RolePid2, rid = RoleId2, srv_id = SrvId2}, #fighter{rid = RoleId3, srv_id = SrvId3} | _]) ->
    [{RolePid1, [{RoleId2, SrvId2}, {RoleId3, SrvId3}]}, {RolePid2, [{RoleId3, SrvId3}]}];
group_team_member(_Other) -> [].

%% 打副本增加亲密度
intimacy_dungeon([], _Size) -> ok;
intimacy_dungeon([{RolePid, MemberList} | T], Size) ->
    role:apply(async, RolePid, {fun do_intimacy_dungeon/3, [MemberList, Size]}),
    intimacy_dungeon(T, Size).

do_intimacy_dungeon(Role, [], _Size) -> 
        {ok, Role};
do_intimacy_dungeon(Role = #role{pid = RolePid, id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}}, [{FrRoleId, FrSrvId} | T], Size) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Friend = #friend{type = ?sns_friend_type_hy, intimacy = Intimacy, online = 1, pid = FrPid}} when is_pid(FrPid) ->
            NewIntimacy = Intimacy + Size,
            case role:apply(sync, FrPid, {fun apply_intimacy_dungeon/5, [RoleId, SrvId, NewIntimacy, Size]}) of
                ok -> 
                    NewFriend = Friend#friend{intimacy = NewIntimacy, modified = ?true},
                    update_friend(cache, NewFriend),
                    notice:inform(RolePid, util:fbin(?L(<<"获得 {str,亲密度,#f65e6a} ~w">>), [Size])),
                    sys_conn:pack_send(ConnPid, 12163, {FrRoleId, FrSrvId, NewIntimacy}),
                    NewRole = role_listener:special_event(Role, {20009, update}), %%好友亲密度改变
                    do_intimacy_dungeon(NewRole, T, Size);
                {false, _Reason} ->
                    do_intimacy_dungeon(Role, T, Size);
                _ ->
                    do_intimacy_dungeon(Role, T, Size)
            end;
        _ -> 
            do_intimacy_dungeon(Role, T, Size)
    end.

apply_intimacy_dungeon(Role = #role{pid = RolePid, link = #link{conn_pid = ConnPid}}, FrRoleId, FrSrvId, NewIntimacy, Size) ->
    case get_friend(cache, {FrRoleId, FrSrvId}) of
        {ok, Friend = #friend{type = ?sns_friend_type_hy, online = 1}} ->
            NewFriend = Friend#friend{intimacy = NewIntimacy, modified = ?true},
            update_friend(cache, NewFriend),
            notice:inform(RolePid, util:fbin(?L(<<"获得 {str,亲密度,#f65e6a} ~w">>), [Size])),
            sys_conn:pack_send(ConnPid, 12163, {FrRoleId, FrSrvId, NewIntimacy}),
            NewRole = role_listener:special_event(Role, {20009, update}), %%好友亲密度改变
            {ok, ok, NewRole};
        _ -> 
            {ok, {false, ?L(<<"好友信息有误">>)}}
    end.

%% 退出时保存好友信息
save_friend(logout, _Role) ->
    % FriendList = get_dict(sns_role_friends),
    % do_save_friend(Role, FriendList).
    ok.

%% 保存好友信息,目前只有亲密度，以后有其它信息也在这里保存
% do_save_friend(_Role = #role{name = Name}, undefined) -> 
%     ?ERR("[~s]角色退出，保存好友信息时发现好友列表为undefined", [Name]),
%     ok;
% do_save_friend(_Role, []) -> ok;
% do_save_friend(Role = #role{id = {RoleId, SrvId}}, [#friend{modified = ?true, role_id = FrRoleId, srv_id = FrSrvId, intimacy =  Intimacy} | T]) ->
%     friend_dao:update_friend_intimacy(RoleId, SrvId, FrRoleId, FrSrvId, Intimacy),
%     do_save_friend(Role, T);
% do_save_friend(Role, [_Friend | T]) ->
%     do_save_friend(Role, T).

%% 记录转换
convert_to_friend(friend_online, Friend, FriendOnline) ->
    #friend_online{pid = Pid, name = Name, sex = Sex, career = Career, lev = Lev, map_id = MapId, face_id = FaceId, vip_type = VipType, signature = Signature, prestige = Prestige, guild = Guild, online_late = OnlineLate, fight = Fight} = FriendOnline,
    Friend#friend{pid = Pid, name = Name, sex = Sex, career = Career, lev = Lev, map_id = MapId, face_id = FaceId, vip_type = VipType, signature = Signature, prestige = Prestige, guild = Guild, online_late = OnlineLate, fight = Fight}.

pid_select_friends(List, Length) when Length =< 30 ->
    [OlPid || #role_online{pid = OlPid} <- List];
pid_select_friends(List, Length) ->
    Index = util:rand(1, Length),
    Sub1 = lists:sublist(List, Index, 30),
    Sub2 = case length(Sub1) >= 30 of
        true -> Sub1;
        false -> 
            Sub3 = lists:sublist(List, 1, (30 - length(Sub1))),
            Sub3 ++ Sub1
    end,
    [OlPid || #role_online{pid = OlPid} <- Sub2].

%% 好友任务
do_select_friends(Param = #friend_param_rlist{target_pids = []}) ->
    send_select_friend(Param);
do_select_friends(Param = #friend_param_rlist{sex = {M, W}}) when M >= 3 andalso W >= 3 ->
    send_select_friend(Param);
do_select_friends(Param = #friend_param_rlist{pid = Pid, target_pids = [Pid | T]}) -> %% 不要自己
    do_select_friends(Param#friend_param_rlist{target_pids = T});
do_select_friends(Param = #friend_param_rlist{target_pids = [Pid | T]}) ->
    case is_pid(Pid) andalso is_process_alive(Pid) of
        true -> role:apply(async, Pid, {friend, apply_select_friends, [Param#friend_param_rlist{target_pids = T}]});
        false -> do_select_friends(Param#friend_param_rlist{target_pids = T})
    end.
apply_select_friends(_Role = #role{lev = Lev}, Param) when Lev < 10 ->
    do_select_friends(Param),
    {ok};
apply_select_friends(_Role = #role{id = {RoleId, SrvId}, name = Name, career = Career, sex = Sex, lev = Lev}, Param = #friend_param_rlist{sex = {M, W}, match = Match, unmatch = Unmatch}) ->
    NewParam = case {Sex, M < 3, W < 3} of
        {0, _, true} ->
            Param#friend_param_rlist{match = [{RoleId, SrvId, Name, Career, Sex, Lev} | Match], sex = {M, W + 1}};
        {1, true, _} ->
            Param#friend_param_rlist{match = [{RoleId, SrvId, Name, Career, Sex, Lev} | Match], sex = {M + 1, W}};
        _ ->
            Param#friend_param_rlist{unmatch = [{RoleId, SrvId, Name, Career, Sex, Lev} | Unmatch]}
    end,
    do_select_friends(NewParam),
    {ok}.
send_select_friend(#friend_param_rlist{conn_pid = ConnPid, match = Match, unmatch = Unmatch}) ->
    Length = length(Match),
    case {Length < 6, length(Unmatch) > 1} of
        {true, true} ->
            Sub = lists:sublist(Unmatch, 1, (6 - Length)),
            sys_conn:pack_send(ConnPid, 12173, {(Match ++ Sub)});
        {false, _} ->
            sys_conn:pack_send(ConnPid, 12173, {Match});
        {true, _} ->
            sys_conn:pack_send(ConnPid, 12173, {Match})
    end.

%% 修改角色名
do_update_friend_name(undefined, _RoleId, _SrvId, _Name) -> ok;
do_update_friend_name([], _RoleId, _SrvId, _Name) -> ok;
do_update_friend_name([#friend{type = ?sns_friend_type_kuafu, pid = Pid} | T], RoleId, SrvId, Name) when is_pid(Pid) ->
    role:c_apply(async, Pid, {fun async_update_friend_name/4, [RoleId, SrvId, Name]}),
    do_update_friend_name(T, RoleId, SrvId, Name);
do_update_friend_name([#friend{pid = Pid} | T], RoleId, SrvId, Name) when is_pid(Pid) ->
    role:apply(async, Pid, {fun async_update_friend_name/4, [RoleId, SrvId, Name]}),
    do_update_friend_name(T, RoleId, SrvId, Name);
do_update_friend_name([_ | T], RoleId, SrvId, Name) ->
    do_update_friend_name(T, RoleId, SrvId, Name).
async_update_friend_name(_Role, FrRoleId, FrSrvId, FrName) ->
    {ok, Friend} = get_friend(cache, {FrRoleId, FrSrvId}),
    NewFriend = Friend#friend{name = FrName},
    delete_friend(cache, {FrRoleId, FrSrvId}),
    insert_friend(cache, NewFriend),
    {ok}.

%% 跨服修改好友名字
cross_update_friend_name([], _) -> ok;
cross_update_friend_name([FrSrvId | T], {RoleId, SrvId, Name}) ->
    center:cast(c_mirror_group, cast, [node, FrSrvId, friend_dao, update_friend_name, [RoleId, SrvId, Name]]),
    cross_update_friend_name(T, {RoleId, SrvId, Name}).


%% 给所有好友发送邮件
do_mail_friends([], _) -> ok;
do_mail_friends([#friend{type = ?sns_friend_type_kuafu, srv_id = SrvId, role_id = Rid, name = RoleName} | T], Mail) ->
    center:cast(c_mirror_group, cast, [node, SrvId, mail_mgr, deliver, [{Rid, SrvId, RoleName}, Mail]]),
    do_mail_friends(T, Mail);
do_mail_friends([#friend{srv_id = SrvId, role_id = Rid, name = RoleName} | T], Mail) ->
    mail_mgr:deliver({Rid, SrvId, RoleName}, Mail),
    do_mail_friends(T, Mail).

%% 修改角色性别
do_update_friend_sex(undefined, _RoleId, _SrvId, _Sex, _FaceId) -> ok;
do_update_friend_sex([], _RoleId, _SrvId, _Sex, _FaceId) -> ok;
do_update_friend_sex([#friend{type = ?sns_friend_type_kuafu, pid = Pid} | T], RoleId, SrvId, Sex, FaceId) when is_pid(Pid) ->
    role:c_apply(async, Pid, {fun async_update_friend_sex/5, [RoleId, SrvId, Sex, FaceId]}),
    do_update_friend_sex(T, RoleId, SrvId, Sex, FaceId);
do_update_friend_sex([#friend{pid = Pid} | T], RoleId, SrvId, Sex, FaceId) when is_pid(Pid) ->
    role:apply(async, Pid, {fun async_update_friend_sex/5, [RoleId, SrvId, Sex, FaceId]}),
    do_update_friend_sex(T, RoleId, SrvId, Sex, FaceId);
do_update_friend_sex([_ | T], RoleId, SrvId, Sex, FaceId) ->
    do_update_friend_sex(T, RoleId, SrvId, Sex, FaceId).
async_update_friend_sex(_Role, FrRoleId, FrSrvId, FrSex, FrFaceId) ->
    {ok, Friend} = get_friend(cache, {FrRoleId, FrSrvId}),
    NewFriend = Friend#friend{sex = FrSex, face_id = FrFaceId},
    delete_friend(cache, {FrRoleId, FrSrvId}),
    insert_friend(cache, NewFriend),
    {ok}.

%% 检测跨服好友一方是马来服的玩家
%% TODO; 11/24 马来服中央服
% check_is_koramgame_friend(SrvId, FrSrvId) ->
%     [S1 | _] = re:split(bitstring_to_list(SrvId), "_", [{return, list}]),
%     [S2 | _] = re:split(bitstring_to_list(FrSrvId), "_", [{return, list}]),
%     (S1 =:= "koramgame" andalso S2 =/= "koramgame") orelse (S1 =/= "koramgame" andalso S2 =:= "koramgame").

%% 记录删除好友的日志
% log_intimacy(RoleId, SrvId, Name, FrRoleId, FrSrvId) ->
%     case get_friend(cache, {FrRoleId, FrSrvId}) of
%         {ok, #friend{type = ?sns_friend_type_kuafu}} -> ignore;
%         {ok, #friend{intimacy = Intimacy, name = FrName}} ->
%             log:log(log_intimacy, {RoleId, SrvId, Name, FrRoleId, FrSrvId, FrName, Intimacy, 0, <<>>});
%         _ -> ignore
%     end.

%% 今天日期
%% 测试reset
today() ->
    {Y, M, D} = erlang:date(),
    (Y * 10000 + M * 100 + D).

%% 取出跨服好友所有服务器id
get_friend_srvs([], Srvs) -> Srvs;
get_friend_srvs([#friend{type = ?sns_friend_type_kuafu, srv_id = SrvId} | T], Srvs) ->
    case lists:member(SrvId, Srvs) of
        true -> get_friend_srvs(T, Srvs);
        _ -> get_friend_srvs(T, [SrvId | Srvs])
    end;
get_friend_srvs([_ | T], Srvs) ->
        get_friend_srvs(T, Srvs).
%%----------------------------------------------------
%% sender
%%----------------------------------------------------
%% 通知客户端添加好友
% send_add_friend(ConnPid, {FrRoleId, FrSrvId, Type}) ->
%     sys_conn:pack_send(ConnPid, 12146, {FrRoleId, FrSrvId, Type}).

%% 通知客户端删除好友信息
send_del_friend(ConnPid, {FrRoleId, FrSrvId}) ->
    sys_conn:pack_send(ConnPid, 12120, {1, <<"">>, FrRoleId, FrSrvId}).

%% 通知客户端更新好友类型
send_upd_friend(ConnPid, {FrRoleId, FrSrvId, NewType}) ->
    sys_conn:pack_send(ConnPid, 12125, {1, <<"">>, NewType, FrRoleId, FrSrvId}).

%% 通知客户端被拒绝加为好友
send_decline_friend({RevRoleid, RevSrvId}, {FrRoleId, FrSrvId, FrName, Type}) ->
    role_group:pack_send({RevRoleid, RevSrvId}, 12147, {FrRoleId, FrSrvId, Type, FrName}).

%% 变更好友分组
send_upd_friend_group(ConnPid, FrGroupList) ->
    sys_conn:pack_send(ConnPid, 12158, FrGroupList).



% 取数据
get_certain_page_data(PageIndex, Data) ->
    case erlang:length(Data) of 
        0 ->{0, []};
        _ -> 
            TotalPage = util:ceil(length(Data) / ?sns_row_count),
            case PageIndex > TotalPage of 
                false ->
                    OffsetStart = (PageIndex - 1) * ?sns_row_count + 1, %% 从1开始
                    OffsetEnd = OffsetStart + ?sns_row_count,
                    PageData = do_page(Data, OffsetStart, OffsetEnd, 1, []),
                    PageData1 = lists:reverse(PageData),
                    {TotalPage, PageData1};
                true ->
                    {TotalPage, []}
            end
    end.

%% 获取某一页数据
do_page([], _OffsetStart, _OffsetEnd, _Index,T) -> T;
do_page(_, _OffsetStart, OffsetEnd, OffsetEnd,T) -> T;
do_page([Data | T], OffsetStart, OffsetEnd, Index, Temp) ->
    case OffsetStart =< Index of
        true ->
            do_page(T, OffsetStart, OffsetEnd, (Index + 1),[Data|Temp]);    
        false ->
            do_page(T, OffsetStart, OffsetEnd, (Index + 1),Temp)
    end.

give_energy(FrdId = {FrRoleId, FrSrvId}, Role = #role{id = {RoleId, SrvId}}) ->
    case get_friend(cache, FrdId) of
        {ok, #friend{give_flag = ?has_give}} ->
            {false, ?MSGID(<<"已经赠送，不能再赠送！">>)};
        {ok, Frd = #friend{}} ->
            case get_deleted_friend({FrRoleId, FrSrvId}) of
                {ok, _ } ->
                    {false, ?MSGID(<<"今天不能赠送此好友">>)};
                false ->
                    GiveTime = util:unixtime(),
                    Frd1 = do_update_friend_energy_flag(give, Role, Frd, GiveTime, ?has_give),
                    pack_send_12183(Role, Frd1),
                    update_friend_flag(RoleId, SrvId, FrRoleId, FrSrvId, GiveTime, ?can_recv),
                    {ok, ?MSGID(<<"赠送成功">>)}
            end;
        {false, _R} ->
            {false, ?MSGID(<<"不存在此好友喔">>)}
    end.

batch_give_energy(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case get_dict(sns_role_friends) of
        [] -> {false, ?MSGID(<<"没有好友">>)};
        Friends ->
            Friends1 = [F || F = #friend{role_id = FrRoleId, srv_id = FrSrvId, type = ?sns_friend_type_hy} <- Friends, get_deleted_friend({FrRoleId, FrSrvId}) =:= false],
            Res = do_batch_give_energy(Role, Friends1, []),
            ?DEBUG("================  批量返回数据 : ~w", [Res]),
            sys_conn:pack_send(ConnPid, 12183, {Res}),
            {ok, ?MSGID(<<"赠送成功">>)}
    end.

update_friend_flag(RoleId, SrvId, FrRoleId, FrSrvId, Time, Flag) ->
    case global:whereis_name({role, FrRoleId, FrSrvId}) of
        Pid when is_pid(Pid) ->
            role:apply(async, Pid, {friend, async_update_friend_recv_flag, [RoleId, SrvId, Time, Flag]});
        _ ->
            friend_dao:update_friend_recv_flag(Time, Flag, FrRoleId, FrSrvId, RoleId, SrvId)
    end.

do_batch_give_energy(_Role, [], Res) -> Res;
do_batch_give_energy(Role = #role{id = {RoleId, SrvId}}, [Frd = #friend{role_id = FrRoleId, srv_id = FrSrvId, recv_flag = RecvFlag, give_flag = ?no_give} | T], Res) ->
    Now = util:unixtime(),
    do_update_friend_energy_flag(give, Role, Frd, Now, ?has_give),
    update_friend_flag(RoleId, SrvId, FrRoleId, FrSrvId, Now, ?can_recv),
    do_batch_give_energy(Role, T, [{FrRoleId, FrSrvId, ?has_give, RecvFlag} | Res]);
do_batch_give_energy(Role, [#friend{} | T], Res) ->
    do_batch_give_energy(Role, T, Res).

recv_energy(FrdId = {_FrRoleId, _FrSrvId}, Role = #role{link = #link{conn_pid = ConnPid}, sns = Sns = #sns{recv_cnt = Cnt}}) ->
    case get_friend(cache, FrdId) of
        {ok, #friend{recv_flag = ?invalid_flag}} ->
            {false, ?MSGID(<<"当前状态不能领取">>)};
        {ok, #friend{recv_flag = ?no_recv}} ->
            {false, ?MSGID(<<"TA还没有赠送体力给你哦">>)};
        {ok, #friend{recv_flag = ?has_recv}} ->
            {false, ?MSGID(<<"已经收取哦">>)};
        {ok, Frd = #friend{recv_time = RecvTime}} ->
            Frd1 = do_update_friend_energy_flag(recv, Role, Frd, RecvTime, ?has_recv),
            {ok, Role1} = role_gain:do([#gain{label = energy, val = ?energy_num}], Role), %%energy:add_energy_limit(?energy_num, Role),
            sys_conn:pack_send(ConnPid, 12182, {Cnt-1, 1, ?MSGID(<<"获得5点体力">>)}),
            pack_send_12183(Role1, Frd1),
            {ok, ?MSGID(<<"获得5点体力">>), Role1#role{sns = Sns#sns{recv_cnt = Cnt - 1}}};
        {false, _R} ->
            {false, ?MSGID(<<"不存在此好友喔">>)}
    end.

async_update_friend_recv_flag(Role, FrRoleId, FrSrvId, RecvTime, Flag) ->
    {ok, Frd} = get_friend(cache, {FrRoleId, FrSrvId}),
    Frd1 = do_update_friend_energy_flag(recv, Role, Frd, RecvTime, Flag),
    pack_send_12183(Role, Frd1),
    {ok}.

do_update_friend_energy_flag(give, #role{id = {RoleId, SrvId}}, Frd = #friend{role_id = FrRoleId, srv_id = FrSrvId}, GiveTime, Flag) ->
    Frd1 = Frd#friend{give_time = GiveTime, give_flag = Flag},
    delete_friend(cache, {FrRoleId, FrSrvId}),
    insert_friend(cache, Frd1),
    friend_dao:update_friend_give_flag(GiveTime, Flag, RoleId, SrvId, FrRoleId, FrSrvId),
    Frd1;
    
do_update_friend_energy_flag(recv, Role = #role{id = {RoleId, SrvId}}, Frd = #friend{role_id = FrRoleId, srv_id = FrSrvId}, RecvTime, Flag) ->
    Frd1 = Frd#friend{recv_time = RecvTime, recv_flag = Flag},
    delete_friend(cache, {FrRoleId, FrSrvId}),
    insert_friend(cache, Frd1),
    send_client_notify(Role),
    friend_dao:update_friend_recv_flag(RecvTime, Flag, RoleId, SrvId, FrRoleId, FrSrvId),
    Frd1.

pack_send_12183(#role{link = #link{conn_pid = ConnPid}}, #friend{role_id = FrRoleId, srv_id = FrSrvId, give_flag = GiveFlag, recv_flag = RecvFlag}) ->
    sys_conn:pack_send(ConnPid, 12183, {[{FrRoleId, FrSrvId, GiveFlag, RecvFlag}]}).

init_energy(Role = #role{sns = Sns = #sns{recv_time = Time}}) ->
    Now = util:unixtime(),
    Role2 =
    case util:is_today(Time) of
        true ->
            Role;
        false ->
            Role1 = Role#role{sns = Sns#sns{recv_time = Now, recv_cnt = ?max_recv_cnt, give_cnt = ?max_give_cnt}},
            case get_energy_frd() of
                [] ->
                    Role1;
                Friends ->
                    reset_energy_flag(Role1, Friends, []),
                    Role1
            end
    end,
    Tomorrow = util:unixtime(today) + 86405,
    role_timer:set_timer(friend_energy_timer, (Tomorrow - Now) * 1000, {?MODULE, day_check, []}, day_check, Role2).

day_check(Role = #role{id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid}, sns = Sns}) ->
    clear_deleted_friend(RoleId, SrvId),
    Role1 = Role#role{sns = Sns#sns{recv_time = util:unixtime(), recv_cnt = ?max_recv_cnt, give_cnt = ?max_give_cnt}},
    sys_conn:pack_send(ConnPid, 12184, {?max_recv_cnt}),
    case get_energy_frd() of
        [] -> {ok, Role1};
        Friends ->
            Res = reset_energy_flag(Role, Friends, []),
            send_client_notify(Role),
            sys_conn:pack_send(ConnPid, 12183, {Res}),
            {ok, Role1}
    end.

reset_energy_flag(_Role, [], Ret) -> Ret;
reset_energy_flag(Role = #role{id = {RoleId, SrvId}}, [Frd = #friend{role_id = FrRoleId, srv_id = FrSrvId, give_time = GiveTime, give_flag = GiveFlag, recv_time = RecvTime, recv_flag = RecvFlag} | T], Ret) ->
    {GiveTime1, GiveFlag1} = case util:is_today(GiveTime) of true -> {GiveTime, GiveFlag}; false -> {0, ?no_give} end,
    {RecvTime1, RecvFlag1} = case util:is_today(RecvTime) of true -> {RecvTime, RecvFlag}; false -> {0, ?no_recv} end,%% 登陆重置时，如果是当天收到的体力，要保留。
    Frd1 = Frd#friend{give_time = GiveTime1, give_flag = GiveFlag1, recv_time = RecvTime1, recv_flag = RecvFlag1},
    delete_friend(cache, {FrRoleId, FrSrvId}),
    insert_friend(cache, Frd1),
    friend_dao:update_friend_energy_flag(GiveTime1, GiveFlag1, RecvTime1, RecvFlag1, RoleId, SrvId, FrRoleId, FrSrvId),
    reset_energy_flag(Role, T, [{FrRoleId, FrSrvId, GiveFlag1, RecvFlag1}| Ret]).

get_energy_frd() ->
    case get_dict(sns_role_friends) of
        [] -> [];
        Friends ->
            [F || F = #friend{type = ?sns_friend_type_hy, give_flag = GiveFlag, recv_flag = RecvFlag} <- Friends, GiveFlag =:= ?has_give orelse RecvFlag =:= ?can_recv orelse RecvFlag =:= ?has_recv]
    end.

clear_deleted_friend(RoleId, SrvId) ->
    friend_dao:delete_del_friend(RoleId, SrvId),
    role:put_dict(deleted_friend, []).

count_can_give_num() ->
    case get_dict(sns_role_friends) of
        [] -> 0;
        Friends ->
            length([F || F = #friend{type = ?sns_friend_type_hy, give_flag = GiveFlag} <- Friends, GiveFlag =:= ?no_give])
    end.

check_friend_or_applied_to(_Role = #role{id = {FromRid, _}}, Target = {ToRid, _SrvId}) -> %%查询是否已经向Target发出申请或者已经是好友关系
    %% 先判断是否为好友
    case check_all([max_self], _Role, {ToRid, _SrvId, ?sns_friend_type_hy}) of  %%检查各个条件是否满足
        {false, _} ->
            true;
        {ok} ->
            case is_friend(Target) of
                {true, _} -> true;
                false -> %%不是好友则判断我是否已经向对方发出申请
                    Sql = "select from_rid from role_friend_apply where from_rid = ~s and to_rid = ~s",
                    case db:get_all(Sql, [FromRid, ToRid]) of
                        {ok, Data} ->
                            ?DEBUG("获取好友申请数据:[Msg:~w]", [Data]),
                            case erlang:length(Data) > 0 of 
                                true -> true;
                                false -> false 
                            end;
                        _ -> false
                    end
            end
    end.


