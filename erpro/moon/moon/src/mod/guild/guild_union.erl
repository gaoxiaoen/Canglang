%%----------------------------------------------------
%% 帮会合并 两个帮会合为一个帮会
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(guild_union).
-export([
        get_union_info/1
        ,send_union_apply/2
        ,disagree_union/1
        ,agree_union/2
        ,union/3
        ,union/4
    ]
).

-include("common.hrl").
-include("team.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("link.hrl").
%%

%% 获取联合帮会信息
get_union_info(Role = #role{id = Rid}) ->
    case team_api:get_team_info(Role) of
        {ok, #team{leader = #team_member{id = LeaderId}}} when Rid =/= LeaderId ->
            {false, ?L(<<"需要由队长发起合并操作">>)};
        {ok, #team{member = Members}} when length(Members) > 1 ->
            {false, ?L(<<"只需两个帮主一起进行帮会合并。合并时，队伍里不能超过2个人。">>)};
        {ok, #team{member = [Member]}} ->
            get_union_info(Role, Member);
        _ ->
            {false, ?L(<<"需要两个帮主一起组队，才能够完成顺利进行帮会合并！">>)}
    end.
get_union_info(#role{guild = #role_guild{gid = Gid1, srv_id = Gsrvid1}, name = Rname1}, #team_member{pid = MemPid, name = Rname2}) ->
    case role_api:lookup(by_pid, MemPid, #role.guild) of
        {ok, _, #role_guild{gid = Gid1, srv_id = Gsrvid1}} ->
            {false, ?L(<<"已是相同帮会，无需合并">>)};
        {ok, _, #role_guild{gid = Gid2, srv_id = Gsrvid2}} ->
            case {guild_mgr:lookup(by_id, {Gid1, Gsrvid1}), guild_mgr:lookup(by_id, {Gid2, Gsrvid2})} of
                {#guild{chief = Chief}, _} when Rname1 =/= Chief ->
                    {false, ?L(<<"您并不是帮主，不能完成该次合并！">>)};
                {_, #guild{chief = Chief}} when Rname2 =/= Chief ->
                    {false, ?L(<<"对方并不是帮主，不能完成该次合并！">>)};
                {#guild{realm = Realm1}, #guild{realm = Realm2}} when Realm1 =/= Realm2 ->
                    {false, ?L(<<"不同阵营帮会不能合帮">>)};
                {#guild{name = GName1}, #guild{name = GName2}} ->
                    {ok, [{Gid2, Gsrvid2, GName2}, {Gid1, Gsrvid1, GName1}]};
                _ ->
                    {false, ?L(<<"对方当前没有加入任何帮会">>)}
            end;
        _ ->
            {false, ?L(<<"对方不在线">>)}
    end.

%% 发送合帮申请
send_union_apply(_Role, {Gid, Gsrvid, _Gname1, Gid, Gsrvid, _Gname2}) ->
    {false, ?L(<<"已是相同帮会，无需合并">>)};
send_union_apply(Role = #role{id = {Rid, Srvid}, name = Name}, {Gid1, Gsrvid1, Gname1, Gid2, Gsrvid2, Gname2}) ->
    case team_api:get_team_info(Role) of
        {ok, #team{leader = #team_member{id = LeaderId}}} when LeaderId =/= {Rid, Srvid} ->
            {false, ?L(<<"需要由队长发起合并操作">>)};
        {ok, #team{member = Members}} when length(Members) > 1 ->
            {false, ?L(<<"只需两个帮主一起进行帮会合并。合并时，队伍里不能超过2个人。">>)};
        {ok, #team{member = Members}} when length(Members) =:= 1 ->
            [#team_member{pid = Pid} | _] = [Member || Member <- Members, Member#team_member.id =/= {Rid, Srvid}],
            case role_api:lookup(by_pid, Pid, #role.link) of
                {ok, _, #link{conn_pid = ConnPid}} -> 
                    sys_conn:pack_send(ConnPid, 12787, {Rid, Srvid, Name, Gid1, Gsrvid1, Gname1, Gid2, Gsrvid2, Gname2}),
                    put(guild_union_flag, {util:unixtime(), Gid1, Gsrvid1, Gid2, Gsrvid2}),
                    {ok};
                _ ->
                    {false, ?L(<<"对方不在线">>)}
            end;
        _ ->
            {false, ?L(<<"需要两个帮主一起组队，才能够完成顺利进行帮会合并！">>)}
    end.

%% 对方不同意合帮
disagree_union(Role) ->
    case team_api:get_team_info(Role) of
        {ok, #team{leader = #team_member{id = LeaderId, pid = MemPid}}} when LeaderId =/= Role#role.id ->
            case role_api:lookup(by_pid, MemPid, #role.link) of
                {ok, _, #link{conn_pid = ConnPid}} -> 
                    sys_conn:pack_send(ConnPid, 12788, {0, ?L(<<"对方不同意合帮">>)});
                _ -> ok
            end;
        _ -> ok
    end.

%% 双方同意合并
agree_union(_Role, {Gid, Gsrvid, Gid, Gsrvid}) ->
    {false, ?L(<<"已是相同帮会，无需合并">>)};
agree_union(Role = #role{id = RoleId, name = Name, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}, {Gid1, Gsrvid1, Gid2, Gsrvid2}) ->
    case team_api:get_team_info(Role) of
        {ok, #team{leader = #team_member{id = RoleId}}} ->
            {false, ?L(<<"需要由队长发起合并操作">>)};
        {ok, #team{member = Members}} when length(Members) > 1 ->
            {false, ?L(<<"只需两个帮主一起进行帮会合并。合并时，队伍里不能超过2个人。">>)};
        {ok, #team{leader = #team_member{pid = OtherPid}, member = Members}} when length(Members) =:= 1 ->
            case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
                Guild = #guild{chief = Name} when {Gid, Gsrvid} =:= {Gid1, Gsrvid1} orelse {Gid, Gsrvid} =:= {Gid2, Gsrvid2} ->
                    case catch role:apply(sync, OtherPid, {fun sync_agree_union/4, [Guild, {Gid1, Gsrvid1, Gid2, Gsrvid2}, {RoleId, Name}]}) of
                        {false, Reason} -> {false, Reason};
                        ok -> {ok};
                        _ -> {false, ?L(<<"对方不在线">>)}
                    end;
                _ ->
                    {false, ?L(<<"您并不是帮主，不能完成该次合并！">>)}
            end;  
        _ ->
            {false, ?L(<<"需要两个帮主一起组队，才能够完成顺利进行帮会合并！">>)}
    end.

%% 同步确认同意合并操作
sync_agree_union(Role = #role{link = #link{conn_pid = ConnPid}}, Guild1, UnionInfo, RoleInfo1) ->
    Reply = do_sync_agree_union(Role, Guild1, UnionInfo, RoleInfo1),
    case Reply of
        ok -> sys_conn:pack_send(ConnPid, 12788, {1, ?L(<<"合帮成功">>)});
        {false, Reason} -> sys_conn:pack_send(ConnPid, 12788, {0, Reason})
    end,
    {ok, Reply}.
do_sync_agree_union(#role{id = RoleId, name = Name, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}, Guild1, {Gid1, Gsrvid1, Gid2, Gsrvid2}, RoleInfo1) ->
    Now = util:unixtime(),
    case get(guild_union_flag) of
        {Time, Gid1, Gsrvid1, Gid2, Gsrvid2} when Now - Time < 300 -> %% 交互时间5分钟
             case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
                 #guild{realm = Realm} when Realm =/= Guild1#guild.realm ->
                     {false, ?L(<<"不同阵营帮会不能合帮">>)};
                 Guild2 = #guild{chief = Name} when {Gid, Gsrvid} =:= {Gid1, Gsrvid1} orelse {Gid, Gsrvid} =:= {Gid2, Gsrvid2} ->
                     case check_guild_num({Gid1, Gsrvid1}, Guild1, Guild2) of
                         false -> {false, ?L(<<"两个帮会的帮会人数相加起来大于并入帮会的人数上限。不能进行合并">>)};
                         true ->
                             case guild:apply(sync, {Gid2, Gsrvid2}, {guild_union, union, [Gid1, Gsrvid1, {{RoleId, Name}, RoleInfo1}]}) of
                                 {false, Reason} -> {false, Reason};
                                 ok -> ok;
                                 error ->
                                     ?ERR("帮会[~s, ~s]进行合并时出错1", [Guild1#guild.name, Guild2#guild.name]),
                                     {false, ?L(<<"帮会合并处理失败">>)}
                             end
                     end;
                 _ ->
                     {false, ?L(<<"您并不是帮主，不能完成该次合并！">>)}
             end;  
        {_Time, Gid1, Gsrvid1, Gid2, Gsrvid2} -> %% 交互时间超时
            {false, ?L(<<"双方交互时间超时，请重新进行合帮申请">>)};
        {_Time, Gid2, Gsrvid2, Gid1, Gsrvid1} -> %% 中途变化合帮方式
            {false, ?L(<<"中途变化合帮方式，请重新进行合帮申请">>)};
        _Info ->
            ?ERR("取申请数据异常，无法正常合帮[~w] [~w]", [{Gid1, Gsrvid1, Gid2, Gsrvid2}, _Info]),
            {false, ?L(<<"取申请数据异常，无法正常合帮">>)}
    end.

%% 判断合帮后成员数量是否超出上限
check_guild_num({Gid, Gsrvid}, Guild1 = #guild{id = {Gid, Gsrvid}}, Guild2) ->
    check_guild_num(Guild1, Guild2);
check_guild_num(_, Guild1, Guild2) ->
    check_guild_num(Guild2, Guild1).
check_guild_num(#guild{maxnum = MaxNum, members = Members1}, #guild{members = Members2}) -> 
    length(Members1) + length(Members2) =< MaxNum.

%% 合并帮会 两帮会合成一个帮会  被合并帮会进程执行
union(State = #guild{id = {Gid, Gsrvid}, name = Gname, chief = Chief}, OtherGid, OtherSrvid, RoleInfo1) ->
    case get(member_manage) of
        undefined ->
            case guild:apply(sync, {OtherGid, OtherSrvid}, {guild_union, union, [State, RoleInfo1]}) of
                {false, Reason} -> {ok, {false, Reason}};
                ok -> 
                    NewState = State#guild{members = [], status = ?guild_dismiss},
                    rank:guild_update(dismiss_guild, NewState),
                    spawn(guild_log, log, [Gid, Gsrvid, Gname, 0, Gsrvid, Chief, <<"帮会销毁">>, util:fbin(<<"帮会合帮(gid:~p Gsrvid:~s)">>, [OtherGid, OtherSrvid])]),
                    guild:union_dismiss(NewState),         %% 销毁清理
                    guild:guild_cast({Gid, Gsrvid}, stop),
                    {ok, ok, NewState};
                error -> 
                    ?ERR("帮会[~s]进行合并时出错2", [State#guild.name]),
                    {ok, {false, ?L(<<"帮会合并处理失败">>)}}
            end;
        _ ->
            {ok, {false, ?L(<<"帮会集体性活动中，禁止帮会合并">>)}}
    end.

%% 帮会合并处理
%% 合并帮会 两帮会合成一个帮会 目标帮会进程执行处理
union(Guild1 = #guild{id = {Gid1, Gsrvid1}, name = GName1, contact_image = ConImages1, members = Members1}, Guild2 = #guild{name = GName2, contact_image = ConImages2, members = Members2}, {{{Rid1, Rsrvid1}, Rname1}, {_RoleId2, Rname2}}) ->
    case get(member_manage) of
        undefined ->
            case check_guild_num(Guild1, Guild2) of
                false -> {ok, {false, ?L(<<"两个帮会的帮会人数相加起来大于并入帮会的人数上限。不能进行合并">>)}};
                true ->
                    NewGuild0 = Guild1#guild{contact_image = ConImages1 ++ ConImages2},
                    [guild_refresh:refresh(13729, Member, Members2) || Member <- Members1],
                    NewGuild = move_member(NewGuild0, Guild2, Members2),
                    guild_practise_mgr:apply(async, {union_guild, Guild1, Guild2}),
                    notice:send(62, util:fbin(?L(<<"无兄弟不帮会。恭喜帮会{str,~s,#7CFC00}与帮会{str,~s,#7CFC00}合并成功，一起携手，打造更强更团结的帮会！">>), [GName1, GName2])),
                    spawn(guild_log, log, [Gid1, Gsrvid1, GName1, Rid1, Rsrvid1, Rname1, <<"帮会合并">>, util:fbin(<<"帮会合帮(~s->~s)操作人[~s、~s]">>, [GName2, GName1, Rname1, Rname2])]),
                    {ok, ok, NewGuild}
            end;
        _ ->
            {ok, {false, ?L(<<"帮会集体性活动中，禁止帮会合并">>)}}
    end.

%% 旧帮会成员转移到新帮会
move_member(Guild, _OldGuild, []) -> Guild;
move_member(Guild = #guild{id = {Gid, Gsrvid}}, OldGuild, [Member = #guild_member{pid = Pid, rid = Rid, srv_id = Rsrvid, name = RName} | T]) ->
    NewMember = Member#guild_member{position = ?guild_disciple, authority = ?disciple_op},
    guild_refresh:refresh(13729, NewMember, OldGuild#guild.members),
    NewGuild = guild_mem:add_member(NewMember, Guild),
    case guild_mgr:lookup_spec(Rid, Rsrvid) of
        false -> 
            ?ERR("合帮时查找不到角色[~p,~s,~s]帮会特殊属性数据", [Rid, Rsrvid, RName]),
            Spec = #special_role_guild{id = {Rid, Rsrvid}, guild = {Gid, Gsrvid, -1}, status = 1},
            guild_mgr:special(update, Spec);
        Spec -> 
            NewSpec = Spec#special_role_guild{guild = {Gid, Gsrvid, -1}}, %% 角色上线时同步
            guild_mgr:special(update, NewSpec)
    end,
    case is_pid(Pid) of
        false -> ok;
        true ->
            catch role:apply(async, Pid, {fun replace_guild/3, [OldGuild, NewGuild]})
    end,
    move_member(NewGuild, OldGuild, T).
   
%% 在线角色帮会变更处理
replace_guild(Role = #role{guild = Guild, link = #link{conn_pid = ConnPid}}, _OldGuild, _NewGuild = #guild{weal = Weal, id = {Gid, Gsrvid}, name = GName}) ->
    Role0 = Role#role{guild = Guild#role_guild{gid = Gid, srv_id = Gsrvid, name = GName}},
    {ok, NRole} = guild_api:set(Role0, {change_position, ?guild_disciple, Weal}),
    sys_conn:pack_send(ConnPid, 12760, {GName}),
    sys_conn:pack_send(ConnPid, 12725, {}),
    %% map:role_update(NewRole),
    case NRole#role.event =:= ?event_guild of
        true -> {ok, guild_area:leave_direct(NRole)};
        _ -> {ok, NRole}
    end.
