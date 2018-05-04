%%----------------------------------------------------
%% 活跃度模块 
%% 
%% @author Shawn 
%%----------------------------------------------------
-module(activity_rpc).
-export([
        handle/3
    ]
).

-include("activity.hrl").
-include("role.hrl").
-include("common.hrl").
-include("gain.hrl").
-include("activity2.hrl").
-include("vip.hrl").
-include("link.hrl").

%% 刷新活跃度面板
%%handle(13800, {}, Role) ->
%%    {Table, Sum, SumLimit} = activity:get_activity_table(Role),
%%    {reply, {Table, Sum, SumLimit}}; 
%%
%%%% 请求剩余时间
%%%% {奖励类型, 剩余时间, ID, 数量} 
%%handle(13801, {}, Role = #role{activity = Activity = #activity{online_award = {Tag, OnlineTime}}}) when Tag>=1 andalso Tag =<12 ->
%%    {Tag, Label, Val, Time} = lists:keyfind(Tag, 1, ?ONLINE_AWARD),       
%%    {Type, [Base, _, Num]} = case Label =:= gold_bind of
%%        true -> {1, [Val, 0, 0]};
%%        false -> {2, Val}
%%    end,
%%    case OnlineTime >= Time of
%%        true -> {reply, {Type, 0, Base, Num}};
%%        false ->
%%            Now = util:unixtime(),
%%            LastCheckTime = activity:update_award_time(),
%%            NewTime = OnlineTime + (Now - LastCheckTime),
%%            BackTime = case NewTime >= Time of
%%                true -> 0; false -> Time - NewTime
%%            end,
%%            {reply, {Type, BackTime, Base, Num}, Role#role{activity = Activity#activity{online_award = {Tag, NewTime}}}}
%%    end;
%%
%%handle(13801, {}, #role{activity = #activity{}}) ->
%%    {reply, {0, 0, 0, 0}};
%%
%%handle(13803, {}, #role{activity = #activity{online_award = {Tag, _}}}) when Tag >=1 andalso Tag < 12 ->
%%    {_, Label, Val, Time} = lists:keyfind(Tag+1, 1, ?ONLINE_AWARD),       
%%    {Type, [Base, _, Num]} = case Label =:= gold_bind of
%%        true -> {1, [Val, 0, 0]};
%%        false -> {2, Val}
%%    end,
%%    {reply, {Type, Time, Base, Num}};
%%handle(13803, {}, #role{activity = #activity{}}) ->
%%    {reply, {0, 0, 0, 0}};
%%
%%%% 请求获得奖励
%%%% {是否成功, 奖励类型, ID, 数量, 下一级奖励类型, ID, 数量, 下一级时间}
%%handle(13802, {}, Role) ->
%%    case activity:get_online_award(Role) of
%%        {skip, Role} -> {reply, {2, 0, 0, 0, 0, 0, 0, 0}};
%%        {false, NewRole, BackTime} -> {reply, {0, 0, 0, 0, 0, 0, 0, BackTime}, NewRole};
%%        {true, NewRole, Label, Val, NextLabel, NextVal, BackTime} ->
%%            {Type, [Base, Bind, Num]} = case Label =:= gold_bind of
%%                true -> {1, [Val, 0, 0]};
%%                false -> {2, Val} 
%%            end,
%%            {NextType, [NextBase, _, NextNum]} = case NextLabel of
%%                0 -> {0, [0, 0, 0]};
%%                gold_bind -> {1, [NextVal, 0, 0]};
%%                item -> {2, NextVal} 
%%            end,
%%            case role_gain:do([#gain{label = Label, val = Val}], NewRole) of
%%                {ok, Nrole} ->
%%                    Msg = case Label =:= item of
%%                        true -> util:fbin(?L(<<"在线奖励获得\n{item3, ~w, ~w, ~w}">>), [Base, Num, 1]);
%%                        false -> util:fbin(?L(<<"在线奖励获得\n绑定晶钻:~w">>), [Val])
%%                    end,
%%                    notice:inform(Msg),
%%                    {reply, {1, Type, Base, Num, NextType, NextBase, NextNum, BackTime}, Nrole};
%%                {false, _G} when Label =:= item ->
%%                    [BaseId, Bind, Num] = Val,
%%                    case mail:send_system(NewRole, {?L(<<"在线奖励">>),
%%                                ?L(<<"由于你的背包已满,在线奖励的物品发送到您的邮件">>), [], {BaseId, Bind, Num}}) of
%%                        ok -> {reply, {1, Type, Base, Num, NextType, NextBase, NextNum, BackTime}, NewRole};
%%                        {false, _R} ->
%%                            ?ELOG("在线奖励失败,原因:~s",[_R]),
%%                            {reply, {1, Type, Base, Num, NextType, NextBase, NextNum, BackTime}, NewRole}
%%                    end
%%            end
%%    end;

%% 请求日常
handle(13804, {}, Role) ->
    Reply = activity2:get_info(Role),
    {reply, Reply};

%% 提交日常任务
handle(13805, {TaskId}, Role) ->
    case activity2:reward(Role, TaskId) of
        {ok, Role1} ->
            log:log(log_coin, {<<"提交日常">>, <<>>, Role, Role1}),
            %% {Role2, NewTaskId} = activity2:fire_tasks(Role1),   %% 触发一个日常任务
            {reply, {?true, ?L(<<"成功领取奖励">>), 0}, Role1};
        {fail, rewarded} ->
            {reply, {?false, ?L(<<"该奖励你今天已领取过">>), 0}};
        _R ->
            {reply, {?false, ?L(<<"领取奖励失败">>), 0}}
    end;

%% 领取远方来信奖励
handle(13808, {Id}, Role) ->
    case npc_mail:reward(Id, Role) of
        {fail, not_enough} ->
            {reply, {?false, ?MSGID(<<"条件不满足，不可领取奖励">>)}};
        {ok, Role1} ->
            {reply, {?true, ?MSGID(<<"领取成功">>)}, Role1};
        {fail, not_found} ->
            {reply, {?false, ?MSGID(<<"找不到远方来信">>)}}
    end;

%% 收取一个神秘来信
handle(13810, {MailId}, Role = #role{id = Rid, link = #link{conn_pid = ConnPid}, vip = Vip = #vip{mail_list = MailList}}) ->
    ?DEBUG(" --->>>> ~w, MailList: ~w", [MailId, MailList]),
    MailList1 = vip:check_npcmail_expire(MailList),
    Role1 = Role#role{vip = Vip#vip{mail_list = MailList1}},
    case lists:keyfind(MailId, 1, MailList) of
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"不存在此神秘来信">>)),
            sys_conn:pack_send(ConnPid, 13810, {0}),
            {ok, Role1};
        _ ->
            case charge_data:get_discount_info(MailId) of
                false ->
                    notice:alert(error, ConnPid, ?MSGID(<<"收取失败">>)),
                    sys_conn:pack_send(ConnPid, 13810, {0}),
                     {ok, Role1}; 
                {Gold, {ItemBaseId, Num}} ->
                    case role_gain:do([#loss{label = gold, val = Gold}], Role1) of
                        {ok, Role2} ->
                            sys_conn:pack_send(ConnPid, 13810, {1}),
                            Role3 = Role2#role{vip = Vip#vip{mail_list = lists:keydelete(MailId, 1, MailList1)}},
                            case role_gain:do([#gain{label = item, val = [ItemBaseId, 1, Num]}], Role3) of
                                {ok, Role4} ->
                                    notice:alert(succ, ConnPid, ?MSGID(<<"领取成功">>)),
                                    {ok, Role4};
                                _ ->
                                    award:send(Rid, 205000, [#gain{label = item, val = [ItemBaseId, 1, Num]}]),
                                    {ok, Role3}
                            end;
                        _ ->
                            notice:alert(error, ConnPid, ?MSGID(<<"晶钻不足">>)),
                            sys_conn:pack_send(ConnPid, 13810, {0}),
                            {ok, Role1}
                    end
            end
    end;


%% @doc 每日签到: 请求签到信息
handle(13820, {}, _Role = #role{id = Id}) ->
    {Info, LastTime} = signon:get_signon_info(Id),    
    {reply, {LastTime, lists:keysort(1, Info)}};


%% @spec Nth 表示每月的第几天
%% @doc 每日签到: 签到
handle(13821, {}, Role = #role{}) ->
    {Reply, NRole} = signon:signon(Role),
    {reply, Reply, NRole};



%% 容错匹配
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
