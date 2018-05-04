%%----------------------------------------------------
%% 缘分摇一摇
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(fate).
-export([
        reg_city/2
        ,logout/1
        ,get_panel_info/2
        ,update_info/8
        ,shake/1
        ,async_shake/2
        ,send_gift/3
        ,get_log_info/2
        ,update_log_info/3
        ,reward/3
    ]
).
-include("common.hrl").
-include("fate.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("link.hrl").
-include("assets.hrl").
-include("gain.hrl").
-include("sns.hrl").
-include("vip.hrl").

%% 获取摇一摇附加动态信息
get_other_info(#role{vip = #vip{type = VipType, portrait_id = Face}, career = Career, lev = Lev, looks = Looks, eqm = Eqm, assets = #assets{charm = Charm}}) ->
    {VipType, Face, Charm, Career, Lev, Looks, Eqm}.

%% 角色上线 注册角色信息
%% reg_city(Role = #role{id = RoleId, link = #link{ip = IP}, attr = #attr{fight_capacity = FC}}, _City) ->
%%    center:cast(c_fate_mgr, role_login, [RoleId, FC, IP, get_other_info(Role)]),
%%    ok.
reg_city(_role, _City) ->
    ok.

%% 角色下线
logout(#role{id = RoleId, lev = Lev}) when Lev >= ?FATE_MIN_LEV ->
    center:cast(c_fate_mgr, role_logout, [RoleId]);
logout(_Role) ->
    ok.

%% 获取面板信息
get_panel_info(Role = #role{assets = #assets{charm = Charm}}, _City) ->
    {ok, FateBaseInfo} = role_convert:do(to_fate_base, Role),
    case center:call(c_fate_mgr, get_panel_info, [FateBaseInfo#fate_role_base_info{other_info = get_other_info(Role)}]) of 
        {ok, Num, Province, City} -> {Province, City, Charm, Num};
        _ -> {<<>>, <<>>, Charm, 0}
    end.

%% 更新缘分签信息
update_info(_Role, <<>>, _Sex, _Age, _Star, _Msg, _Province, _City) ->
    {false, ?L(<<"名字不能为空">>)};
update_info(_Role, Name, _Sex, _Age, _Star, _Msg, _Province, _City) when byte_size(Name) > 21 ->
    {false, ?L(<<"名字太长">>)};
update_info(_Role, _Name, _Sex, _Age, _Star, Msg, _Province, _City) when byte_size(Msg) > 100 ->
    {false, ?L(<<"交友宣言内容太长">>)};
update_info(#role{id = RoleId, pid = Pid}, Name, Sex, Age, Star, Msg, Province, City) ->
    case util:check_name(Name) of
        {false, Reason} -> 
            {false, Reason};
        ok ->
            case util:text_banned(Msg) of
                true ->
                    {false, ?L(<<"交友宣言内容包括有非法关键词">>)};
                false ->
                    center:cast(c_fate_mgr, cast, [{update_info, RoleId, Pid, Name, Sex, Age, Star, Msg, Province, City}]),
                    ok
            end
    end.

%% 摇一摇
shake(Role = #role{id = RoleId, pid = Pid, attr = #attr{fight_capacity = FC}}) ->
    case center:is_connect() of
        false -> 
            {false, ?L(<<"你们与时空隧道失去联系">>)};
        _ ->
            Friends = friend:get_friend_list(),
            FriendIds = [{FrRid, FrSrvId} || #friend{role_id = FrRid, srv_id = FrSrvId, type = FrType} <- Friends, (FrType =:= ?sns_friend_type_kuafu orelse ?sns_friend_type_hy)],
            center:cast(c_fate_mgr, cast, [{shake, RoleId, Pid, FC, FriendIds, get_other_info(Role)}]),
            ok
    end.

%% 摇一摇结果推送客户端显示
async_shake(#role{pid = Pid}, CompressedData) ->
    case catch binary_to_term(CompressedData) of
        [ok, L] ->
            role:pack_send(Pid, 17706, {L});
        _ ->
            ok
    end,
    {ok}.

%% 给TA送礼
send_gift(Role, RecvRoleId, Type) -> %% 送爱心
    case check_send_gift(Role, RecvRoleId, Type) of
        {false, Reason} -> 
            {false, Reason};
        true ->
            case role_api:c_lookup(by_id, RecvRoleId) of
                {ok, Node, RecvRole} when Node =:= node() ->
                    do_send_gift(local, Role, RecvRole, Type);
                {ok, _Node, RecvRole} ->
                    do_send_gift(remote, Role, RecvRole, Type);
                _ ->
                    {false, ?L(<<"对方不在线">>)}
            end
    end.
do_send_gift(local, Role = #role{id = {Rid, SrvId}, pid = Pid}, RecvRole = #role{name = RecvName, id = {RecvRid, RecvSrvid}, pid = RecvPid}, 1) -> %% 送爱心
    Val = 9,
    role:apply(async, RecvPid, {friend, incr_charm, [Val]}), %%  收花的增加魅力值
    SendRoleMsg = notice:role_to_msg(Role),
    RecvRoleMsg = notice:role_to_msg(RecvRole),
    {ChatMsg1, ChatMsg2} = case friend:is_friend({RecvRid, RecvSrvid}) =/= false of
        true -> 
            friend:add_intimacy(RecvPid, {Rid, SrvId, 0}, Val, <<"送爱心">>),
            friend:add_intimacy(Pid, {RecvRid, RecvSrvid, 1}, Val, <<"送爱心">>),
            friend:pack_send_intimacy(RecvPid, {Rid, SrvId}),
            friend:pack_send_intimacy(Pid, {RecvRid, RecvSrvid}),
            {util:fbin(?L(<<"~s给你送上了 红心一枚 表达对你款款爱意，你因此获得魅力~p点。因为你们本来就是好友的亲密度也增加了~p点。">>), [SendRoleMsg, Val, Val]),
                util:fbin(?L(<<"你羞涩的给~s送上一个红心 表达爱意，令ta魅力值增加~p点越发魅力动人。因为你们本来就是好友的亲密度也增加了~p点。">>), [RecvRoleMsg, Val, Val])};
        false ->
            {util:fbin(?L(<<"~s给你送上了 红心一枚 表达对你款款爱意，你因此获得魅力~p点。可惜你们不是好友，要不亲密度也会增加的。">>), [SendRoleMsg, Val]),
                util:fbin(?L(<<"你羞涩的给~s送上一个红心 表达爱意，令ta魅力值增加~p点越发魅力动人。可惜你们不是好友，要不亲密度也会增加的。">>), [RecvRoleMsg, Val])}
    end,
    role:pack_send(Pid, 17712, {RecvRid, RecvSrvid, <<>>, 0, 0, 0, [], ChatMsg2}),
    role:pack_send(RecvPid, 17712, {Rid, SrvId, <<>>, 0, 0, 0, [], ChatMsg1}),
    NewRole = update_log_info(Role, praise, {RecvRid, RecvSrvid}),
    log:log(log_handle_all, {17713, <<"TA送爱心">>, util:fbin("本地[~p, ~s, ~s]", [RecvRid, RecvSrvid, RecvName]), Role}),
    {ok, NewRole};
do_send_gift(remote, Role = #role{id = {Rid, SrvId}, pid = Pid}, RecvRole = #role{name = RecvName, id = {RecvRid, RecvSrvid}, pid = RecvPid}, 1) -> %% 送爱心
    Val = 9,
    role:c_apply(async, RecvPid, {friend, incr_charm, [Val]}), %%  收花的增加魅力值
    SendRoleMsg = notice:role_to_msg(Role),
    RecvRoleMsg = notice:role_to_msg(RecvRole),
    {ChatMsg1, ChatMsg2} = case friend:is_kuafu_friend({RecvRid, RecvSrvid}) =/= false of
        true -> 
            friend:add_cross_intimacy(remote, RecvPid, {Rid, SrvId, 0}, Val, <<"送爱心">>),
            friend:add_cross_intimacy(local, Pid, {RecvRid, RecvSrvid, 1}, Val, <<"送爱心">>),
            friend:pack_send_intimacy(remote, RecvPid, {Rid, SrvId}),
            friend:pack_send_intimacy(local, Pid, {RecvRid, RecvSrvid}),
            {util:fbin(?L(<<"~s给你送上了 红心一枚 表达对你款款爱意，你因此获得魅力~p点。因为你们本来就是好友的亲密度也增加了~p点。">>), [SendRoleMsg, Val, Val]),
                util:fbin(?L(<<"你羞涩的给~s送上一个红心 表达爱意，令ta魅力值增加~p点越发魅力动人。因为你们本来就是好友的亲密度也增加了~p点。">>), [RecvRoleMsg, Val, Val])};
        false ->
            {util:fbin(?L(<<"~s给你送上了 红心一枚 表达对你款款爱意，你因此获得魅力~p点。可惜你们不是好友，要不亲密度也会增加的。">>), [SendRoleMsg, Val]),
                util:fbin(?L(<<"你羞涩的给~s送上一个红心 表达爱意，令ta魅力值增加~p点越发魅力动人。可惜你们不是好友，要不亲密度也会增加的。">>), [RecvRoleMsg, Val])}
    end,
    role:pack_send(Pid, 17712, {RecvRid, RecvSrvid, <<>>, 0, 0, 0, [], ChatMsg2}),
    role:c_pack_send(RecvPid, 17712, {Rid, SrvId, <<>>, 0, 0, 0, [], ChatMsg1}),
    NewRole = update_log_info(Role, praise, {RecvRid, RecvSrvid}),
    log:log(log_handle_all, {17713, <<"TA送爱心">>, util:fbin("跨服[~p, ~s, ~s]", [RecvRid, RecvSrvid, RecvName]), Role}),
    {ok, NewRole};
do_send_gift(local, Role = #role{id = {Rid, SrvId}, pid = Pid}, RecvRole = #role{name = RecvName, id = {RecvRid, RecvSrvid}, pid = RecvPid}, 2) -> %% 送99玫瑰
    case role_gain:do([#loss{label = item, val = [33003, 0, 1]}], Role) of
        {false, _} -> {false, ?L(<<"貌似你的背包里没有99朵鲜花哦">>)};
        {ok, NRole} ->
            Val = 198,
            role:apply(async, RecvPid, {friend, incr_charm, [Val]}), %%  收花的增加魅力值
            SendRoleMsg = notice:role_to_msg(Role),
            RecvRoleMsg = notice:role_to_msg(RecvRole),
            {ChatMsg1, ChatMsg2} = case friend:is_friend({RecvRid, RecvSrvid}) =/= false of
                true -> 
                    friend:add_intimacy(RecvPid, {Rid, SrvId, 0}, Val, item:name(33003)),
                    friend:add_intimacy(Pid, {RecvRid, RecvSrvid, 1}, Val, item:name(33003)),
                    friend:pack_send_intimacy(RecvPid, {Rid, SrvId}),
                    friend:pack_send_intimacy(Pid, {RecvRid, RecvSrvid}),
                    {util:fbin(?L(<<"~s从远方给你寄来 99朵玫瑰 ta的心意已表露无遗 ，你的魅力果然无法阻挡魅力值骤升~p点。因为你们本来就是好友的亲密度也增加了~p点。">>), [SendRoleMsg, Val, Val]),
                util:fbin(?L(<<"你终于鼓起勇气的给~s送上99朵玫瑰 ，ta的魅力随之飙升~p点，希望ta能明白你的心意。因为你们本来就是好友的亲密度也增加~p点。">>), [RecvRoleMsg, Val, Val])};
                false ->
                    {util:fbin(?L(<<"~s从远方给你寄来 99朵玫瑰 ta的心意已表露无遗 ，你的魅力果然无法阻挡魅力值骤升~p点。可惜你们不是好友，要不亲密度也会增加的。">>), [SendRoleMsg, Val]),
                util:fbin(?L(<<"你终于鼓起勇气的给~s送上99朵玫瑰 ，ta的魅力随之飙升~p点，希望ta能明白你的心意。可惜你们不是好友，要不亲密度也会增加的。">>), [RecvRoleMsg, Val])}
            end,
            Msg = util:fbin(?L(<<"~s与~s果然是缘分天定，通过缘分摇一摇相识、相知、相惜。~s赠送的99朵鲜花更是他们之间情谊的见证。{open,44,我要摇一摇,#00ff00}">>) , [SendRoleMsg, RecvRoleMsg, SendRoleMsg]),
            notice:send(53, Msg),
            {ok, NewRole0} = friend:incr_flower(NRole, Val), %% 增加送花人的送花积分
            NewRole = update_log_info(NewRole0, flower, {RecvRid, RecvSrvid}),
            role:pack_send(Pid, 17712, {RecvRid, RecvSrvid, <<>>, 0, 0, 0, [], ChatMsg2}),
            role:pack_send(RecvPid, 17712, {Rid, SrvId, <<>>, 0, 0, 0, [], ChatMsg1}),
            log:log(log_handle_all, {17713, <<"TA送玫瑰">>, util:fbin("本地[~p, ~s, ~s]", [RecvRid, RecvSrvid, RecvName]), Role}),
            NewRole1 = campaign_listener:handle(flower, NewRole, 99),
            {ok, NewRole1}
    end;
do_send_gift(remote, Role = #role{id = {Rid, SrvId}, pid = Pid}, RecvRole = #role{name = RecvName, id = {RecvRid, RecvSrvid}, pid = RecvPid}, 2) -> %% 送99玫瑰
    case role_gain:do([#loss{label = item, val = [33003, 0, 1]}], Role) of
        {false, _} -> {false, ?L(<<"貌似你的背包里没有99朵鲜花哦">>)};
        {ok, NRole} ->
            Val = 198,
            role:c_apply(async, RecvPid, {friend, incr_charm, [Val]}), %%  收花的增加魅力值
            SendRoleMsg = notice:role_to_msg(Role),
            RecvRoleMsg = notice:role_to_msg(RecvRole),
            {ChatMsg1, ChatMsg2} = case friend:is_kuafu_friend({RecvRid, RecvSrvid}) =/= false of
                true -> 
                    friend:add_cross_intimacy(remote, RecvPid, {Rid, SrvId, 0}, Val, item:name(33033)),
                    friend:add_cross_intimacy(local, Pid, {RecvRid, RecvSrvid, 1}, Val, item:name(33033)),
                    friend:pack_send_intimacy(remote, RecvPid, {Rid, SrvId}),
                    friend:pack_send_intimacy(local, Pid, {RecvRid, RecvSrvid}),
                    {util:fbin(?L(<<"~s从远方给你寄来 99朵玫瑰 ta的心意已表露无遗 ，你的魅力果然无法阻挡魅力值骤升~p点。因为你们本来就是好友的亲密度也增加了~p点。">>), [SendRoleMsg, Val, Val]),
                util:fbin(?L(<<"你终于鼓起勇气的给~s送上99朵玫瑰 ，ta的魅力随之飙升~p点，希望ta能明白你的心意。因为你们本来就是好友的亲密度也增加~p点。">>), [RecvRoleMsg, Val, Val])};
                false ->
                    {util:fbin(?L(<<"~s从远方给你寄来 99朵玫瑰 ta的心意已表露无遗 ，你的魅力果然无法阻挡魅力值骤升~p点。可惜你们不是好友，要不亲密度也会增加的。">>), [SendRoleMsg, Val]),
                util:fbin(?L(<<"你终于鼓起勇气的给~s送上99朵玫瑰 ，ta的魅力随之飙升~p点，希望ta能明白你的心意。可惜你们不是好友，要不亲密度也会增加的。">>), [RecvRoleMsg, Val])}
            end,
            SendRoleMsg = notice:role_to_msg(Role),
            RecvRoleMsg = notice:role_to_msg(RecvRole),
            Msg1 = util:fbin(?L(<<"~s通过缘分摇一摇与域外有缘人~s相识，建立了深厚的情谊，当即赠送鲜花99朵以表达对~s的爱慕。{open,44,我要摇一摇,#00ff00}">>) , [SendRoleMsg, RecvRoleMsg, RecvRoleMsg]),
            notice:send(53, Msg1),
            Msg2 = util:fbin(?L(<<"~s通过缘分摇一摇与域外有缘人~s相识，并得到~s的青睐，收到了对方赠送的99朵鲜花，此刻~s真是个幸福的人啊！{open,44,我要摇一摇,#00ff00}">>) , [RecvRoleMsg, SendRoleMsg, SendRoleMsg, RecvRoleMsg]),
            center:cast(RecvSrvid, notice, send, [53, Msg2]),
            {ok, Role0} = friend:incr_flower(NRole, Val), %% 增加送花人的送花积分
            NewRole = update_log_info(Role0, flower, {RecvRid, RecvSrvid}),
            role:pack_send(Pid, 17712, {RecvRid, RecvSrvid, <<>>, 0, 0, 0, [], ChatMsg2}),
            role:c_pack_send(RecvPid, 17712, {Rid, SrvId, <<>>, 0, 0, 0, [], ChatMsg1}),
            log:log(log_handle_all, {17713, <<"TA送玫瑰">>, util:fbin("跨服[~p, ~s, ~s]", [RecvRid, RecvSrvid, RecvName]), Role}),
            NewRole0 = campaign_listener:handle(flower, NewRole, Val),
            {ok, NewRole0}
    end.

%% 判断是否可以发礼物
check_send_gift(Role, RecvRoleId, 1) -> %% 爱心
    case center:call(c_fate_mgr, check_ta, [Role#role.id, RecvRoleId]) of
        true ->
            {Max, N, Roles} = get_log_info(Role, praise),
            case lists:member(RecvRoleId, Roles) of
                true -> 
                    {false, ?L(<<"今天已赞美过该TA了哦">>)};
                _ when N >= Max ->
                    {false, ?L(<<"今天赞美TA次数已使用完了哦">>)};
                _ ->
                    true
            end;
        _ ->
            {false, ?L(<<"您们不是TA关系，不能送爱心哦">>)}
    end;
check_send_gift(Role, RecvRoleId, 2) -> %% 爱心
    case center:call(c_fate_mgr, check_ta, [Role#role.id, RecvRoleId]) of
        true ->
            {Max, N, Roles} = get_log_info(Role, flower),
            case lists:member(RecvRoleId, Roles) of
                true -> 
                    {false, ?L(<<"今天已送过花给该TA了哦">>)};
                _ when N >= Max ->
                    {false, ?L(<<"今天送花给TA次数已使用完了哦">>)};
                _ ->
                    true
            end;
        _ ->
            {false, ?L(<<"您们不是TA关系，送花失败">>)}
    end;
check_send_gift(_Role, _RecvRole, _Type) ->
    {false, ?L(<<"类型不正确">>)}.

%% 奖励
reward(Role, OtherRoleId, Type = shake) -> %% 摇到奖励
    {Max, N, _Roles} = get_log_info(Role, Type),
    case N >= Max of
        true -> 
            {ok};
        false ->
            GL = [#gain{label = exp, val = 3000}],
            case role_gain:do(GL, Role) of
                {false, _} -> 
                    {ok};
                {ok, NRole} ->
                    Msg = notice_inform:gain_loss(GL, ?L(<<"缘分摇一摇">>)),
                    notice:inform(Role#role.pid, Msg),
                    NewRole = update_log_info(NRole, Type, OtherRoleId),
                    {ok, NewRole}
            end
    end;
reward(Role, OtherRoleId, Type = agree_chat) ->
    {Max, N, Roles} = get_log_info(Role, Type),
    case lists:member(OtherRoleId, Roles) orelse N >= Max of
        true -> 
            {ok};
        false ->
            GL = [
                #gain{label = exp, val = 9999}
                ,#gain{label = charm, val = 9}
            ],
            case role_gain:do(GL, Role) of
                {false, _} -> 
                    {ok};
                {ok, NRole} ->
                    Msg = notice_inform:gain_loss(GL, ?L(<<"同意TA聊天">>)),
                    notice:inform(Role#role.pid, Msg),
                    NewRole = update_log_info(NRole, Type, OtherRoleId),
                    {ok, NewRole}
            end
    end;
reward(Role, OtherRoleId, Type = chat) ->
    {Max, N, Roles} = get_log_info(Role, Type),
    case lists:member(OtherRoleId, Roles) orelse N >= Max of
        true -> 
            {ok};
        false ->
            GL = [
                #gain{label = exp, val = 9999}
                ,#gain{label = charm, val = 9}
            ],
            case role_gain:do(GL, Role) of
                {false, _} -> 
                    {ok};
                {ok, NRole} ->
                    Msg = notice_inform:gain_loss(GL, ?L(<<"成功与TA聊天">>)),
                    notice:inform(Role#role.pid, Msg),
                    NewRole = update_log_info(NRole, Type, OtherRoleId),
                    {ok, NewRole}
            end
    end;
reward(_Role, _OtherRoleId, _Type) ->
    {ok}.

%% 获取指定类型操作次数
get_log_info(#role{fate = #fate{logs = Logs}}, Type) ->
    {N, L} = case lists:keyfind(Type, 1, Logs) of
        {Type, N1, L1, Time} -> 
            case util:is_today(Time) of
                true -> {N1, L1};
                _ -> {0, []}
            end;
        _ ->
            {0, []}
    end,
    {log_limit_num(Type), N, L}.

%% 更新指定类型日志信息
update_log_info(Role = #role{fate = Fate = #fate{logs = Logs}}, Type, OtherRoleId) ->
    {_Max, N, Roles} = get_log_info(Role, Type),
    Log = {Type, N + 1, [OtherRoleId | Roles], util:unixtime()},
    NewLogs = lists:keydelete(Type, 1, Logs),
    Role#role{fate = Fate#fate{logs = [Log | NewLogs]}}.

%% 每种操作日志上限值
log_limit_num(shake) -> 3;         %% 摇一摇
log_limit_num(chat) -> 3;          %% 被接受聊天
log_limit_num(agree_chat) -> 3;    %% 接受聊天
log_limit_num(praise) -> 5;        %% 赞美
log_limit_num(flower) -> 5;        %% 送花
log_limit_num(fate_act) -> 5;      %% 摇骰子/猜拳
log_limit_num(_) -> 0.
