%%---------------------------------------------------- 
%% 帮会系统管理器
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_merge).
-export([merge/0
        ,merge/1
        ,alter_name/2
        ,async_alter_name/2
        ,update_guild_name/2
        ,alter_srvid/2
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("link.hrl").

%% @spec merge() -> <<"success">>
%% @spec 合并两个服的帮会DETS文件，1服的文件对应放置在 ../var/server_1/目录下, 2服的文件对应放置在 ../var/server_2/目录下, 合成后的保存在 ../var/目录下
merge() ->
    dets:open_file(guild_list, [{file, "../var/guild.dets"}, {keypos, #guild.id}, {type, set}]),
    dets:open_file(special_role_guild, [{file, "../var/special_role_guild.dets"}, {keypos, #special_role_guild.id}, {type, set}]),
    dets:open_file(guild_server_1, [{file, "../var/server_1/guild.dets"}, {keypos, #guild.id}, {type, set}]),
    dets:open_file(special_role_guild_server_1, [{file, "../var/server_1/special_role_guild.dets"}, {keypos, #special_role_guild.id}, {type, set}]),
    dets:open_file(guild_server_2, [{file, "../var/server_2/guild.dets"}, {keypos, #guild.id}, {type, set}]),
    dets:open_file(special_role_guild_server_2, [{file, "../var/server_2/special_role_guild.dets"}, {keypos, #special_role_guild.id}, {type, set}]),
    case dets:first(guild_server_1) of
        '$end_of_table' -> ?INFO("server_1 目录下没有帮会需要合并的帮会");
        _ ->
            dets:traverse(guild_server_1,
                fun(Guild) ->
                        NewGuild = #guild{members = Mems} = guild_ver:convert(Guild),
                        dets:insert(guild_list, NewGuild#guild{members = [M#guild_member{pid = 0} || M <- Mems]}),
                        continue
                end
            )
    end,
    case dets:first(special_role_guild_server_1) of
        '$end_of_table' -> ok;
        _ ->
            dets:traverse(special_role_guild_server_1,
                fun(Special) ->
                        dets:insert(special_role_guild, Special),
                        continue
                end
            ),
            ok
    end,
    case dets:first(guild_server_2) of
        '$end_of_table' -> ?INFO("server_2 目录下没有帮会需要合并的帮会");
        _ ->
            dets:traverse(guild_server_2,
                fun(Guild) ->
                        handle_same_name(guild_ver:convert(Guild)),
                        continue
                end
            )
    end,
    case dets:first(special_role_guild_server_2) of
        '$end_of_table' -> ok;
        _ ->
            dets:traverse(special_role_guild_server_2,
                fun(Special) ->
                        dets:insert(special_role_guild, Special),
                        continue
                end
            ),
            ok
    end,
    dets:close(guild_list),
    dets:close(special_role_guild),
    dets:close(guild_server_1),
    dets:close(special_role_guild_server_1),
    dets:close(guild_server_2),
    dets:close(special_role_guild_server_2),
    <<"success">>.

merge([First | T]) ->
    dets:open_file(guild_list, [{file, "../var/guild.dets"}, {keypos, #guild.id}, {type, set}]),
    dets:open_file(special_role_guild, [{file, "../var/special_role_guild.dets"}, {keypos, #special_role_guild.id}, {type, set}]),
    dets:open_file(guild_first, [{file, "../var/" ++ First ++ "/guild.dets"}, {keypos, #guild.id}, {type, set}]),
    dets:open_file(special_role_guild_first, [{file, "../var/" ++ First ++ "/special_role_guild.dets"}, {keypos, #special_role_guild.id}, {type, set}]),
    case dets:first(guild_first) of
        '$end_of_table' -> ?INFO("server_1 目录下没有帮会需要合并的帮会");
        _ ->
            dets:traverse(guild_first,
                fun(Guild) ->
                        NewGuild = #guild{members = Mems} = guild_ver:convert(Guild),
                        dets:insert(guild_list, NewGuild#guild{members = [M#guild_member{pid = 0} || M <- Mems]}),
                        continue
                end
            )
    end,
    case dets:first(special_role_guild_first) of
        '$end_of_table' -> ok;
        _ ->
            dets:traverse(special_role_guild_first,
                fun(Special) ->
                        dets:insert(special_role_guild, Special),
                        continue
                end
            ),
            ok
    end,
    merge_other_guild(T),
    dets:close(guild_list),
    dets:close(special_role_guild),
    dets:close(guild_first),
    dets:close(special_role_guild_first),
    <<"success">>.

merge_other_guild([]) -> ok;
merge_other_guild([SrvId | T]) ->
    GuildDetsFlag = util:string_to_term("guild_dets_" ++ SrvId),
    SpecialRoleDetsFlag = util:string_to_term("special_role_guild_" ++ SrvId),
    dets:open_file(GuildDetsFlag, [{file, "../var/" ++ SrvId ++ "/guild.dets"}, {keypos, #guild.id}, {type, set}]),
    dets:open_file(SpecialRoleDetsFlag, [{file, "../var/" ++ SrvId ++ "/special_role_guild.dets"}, {keypos, #special_role_guild.id}, {type, set}]),
    case dets:first(GuildDetsFlag) of
        '$end_of_table' -> ?INFO("server_2 目录下没有帮会需要合并的帮会");
        _ ->
            dets:traverse(GuildDetsFlag,
                fun(Guild) ->
                        handle_same_name(guild_ver:convert(Guild)),
                        continue
                end
            )
    end,
    case dets:first(SpecialRoleDetsFlag) of
        '$end_of_table' -> ok;
        _ ->
            dets:traverse(SpecialRoleDetsFlag,
                fun(Special) ->
                        dets:insert(special_role_guild, Special),
                        continue
                end
            ),
            ok
    end,
    dets:close(GuildDetsFlag),
    dets:close(SpecialRoleDetsFlag),
    merge_other_guild(T).

%% @spec alter_name(Name, Role) -> {false, Reason} | ok
%% Name = Reason = binary()
%% Role = #role{}
%% @doc 修改帮会名字
alter_name(_Name, #role{guild = #role_guild{gid = 0}}) ->
    {false, ?L(<<"您没有帮会">>)};
alter_name(_Name, #role{guild = #role_guild{position = Job}}) when Job =/= ?guild_chief ->
    {false, ?L(<<"权限不足">>)};
alter_name(Name, #role{guild = #role_guild{pid = Pid}, link = #link{conn_pid  = ConnPid}}) ->
    guild:apply(async, Pid, {?MODULE, async_alter_name, [{Name, ConnPid}]}).

%% @spec async_alter_name(Guild, {NewName, ConnPid}) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% NewName = bianry()
%% ConnPid = pid()
%% @doc 修改帮会名字
async_alter_name(Guild = #guild{name = Name, members = Mems}, {NewName, ConnPid}) ->
    Len = byte_size(<<"【">>),
    <<A:Len/binary, _B/binary>> = Name,
    case A =:= <<"【">> of
        true ->
            update_members_guild_name(Mems, NewName),
            sys_conn:pack_send(ConnPid, 12782, {?true, <<>>}),
            {ok, Guild#guild{name = NewName}};
        false ->
            catch sys_conn:pack_send(ConnPid, 12782, {?false, ?L(<<"帮会名字无法再修改">>)}),
            {ok}
    end.

%% @spec alter_srvid(OldSrvid, NewSrvid) -> 
%% @doc 
alter_srvid(OldSrvid, NewSrvid) when is_binary(OldSrvid) andalso is_binary(NewSrvid) ->
    dets:open_file(guild_list, [{file, "../var/guild.dets"}, {keypos, #guild.id}, {type, set}]),
    dets:open_file(special_role_guild, [{file, "../var/special_role_guild.dets"}, {keypos, #special_role_guild.id}, {type, set}]),
    case dets:first(guild_list) of
        '$end_of_table' -> ?INFO("没有帮会");
        _ ->
            dets:traverse(guild_list,
                fun(Guild = #guild{id = {Gid, Gsrvid}, members = Mems}) ->
                        case Gsrvid =:= OldSrvid of
                            true -> 
                                {_Status, NewMems} = handle_guild_member_srvid(Mems, OldSrvid, NewSrvid),
                                dets:delete(guild_list, {Gid, Gsrvid}),
                                dets:insert(guild_list, Guild#guild{id = {Gid, NewSrvid}, srv_id = NewSrvid, members = NewMems});
                            false -> 
                                {Status, NewMems} = handle_guild_member_srvid(Mems, OldSrvid, NewSrvid),
                                case Status of
                                    true ->
                                        dets:delete(guild_list, {Gid, Gsrvid}),
                                        dets:insert(guild_list, Guild#guild{members = NewMems});
                                    false ->
                                        ok
                                end
                        end,
                        continue
                end
            )
    end,
    case dets:first(special_role_guild) of
        '$end_of_table' -> ok;
        _ ->
            dets:traverse(special_role_guild,
                fun(Special = #special_role_guild{id = Sid, guild = {Gid, Gsrvid, Date}}) ->
                        case Gsrvid =:= OldSrvid of
                            true -> 
                                dets:delete(guild_list, Sid),
                                dets:insert(special_role_guild, Special#special_role_guild{guild = {Gid, NewSrvid, Date}});
                            false -> ok
                        end,
                        continue
                end
            ),
            ok
    end,
    dets:close(guild_list),
    dets:close(special_role_guild),
    <<"success">>.

handle_guild_member_srvid(Mems, OldSrvid, NewSrvid) ->
    handle_guild_member_srvid(Mems, OldSrvid, NewSrvid, [], false).
handle_guild_member_srvid([], _OldSrvid, _NewSrvid, NewMems, Status) ->
    {Status, NewMems};
handle_guild_member_srvid([M = #guild_member{id = {Gid, Srvid}} | Mems], Srvid, NewSrvid, NewMems, _Status) ->
    handle_guild_member_srvid(Mems, Srvid, NewSrvid, [M#guild_member{id = {Gid, NewSrvid}, srv_id = NewSrvid} | NewMems], true);
handle_guild_member_srvid([M | Mems], Srvid, NewSrvid, NewMems, Status) ->
    handle_guild_member_srvid(Mems, Srvid, NewSrvid, [M | NewMems], Status).

handle_same_name(Guild = #guild{id = {Gid, Gsrvid}, name = Gname, members = Mems1}) ->
    case dets:match_object(guild_list, #guild{name = Gname, _ ='_'}) of
        [] ->
            dets:insert(guild_list, Guild#guild{members = [M#guild_member{pid = 0} || M <- Mems1]}),
            ok;
        [#guild{id = {Gid, Gsrvid}}] ->
            ok;
        [H = #guild{}] ->
            case compare_guild(H, Guild) of
                true ->
                    NewName = get_new_guild_name(Guild),
                    dets:insert(guild_list, Guild#guild{members = [M#guild_member{pid = 0} || M <- Mems1], name = NewName}),
                    ok;
                false ->
                    NewName = get_new_guild_name(H),
                    dets:insert(guild_list, H#guild{name = NewName}),
                    dets:insert(guild_list, Guild#guild{members = [M#guild_member{pid = 0} || M <- Mems1]}),
                    ok
            end;
        _Err ->
            dets:insert(guild_list, Guild#guild{members = [M#guild_member{pid = 0} || M <- Mems1]}),
            ok
    end.

compare_guild(#guild{lev = Lev1, fund = Fund1, members = Mems1}, #guild{lev = Lev2, fund = Fund2, members = Mems2}) ->
    if
        Lev1 > Lev2 -> true;
        Lev1 < Lev2 -> false;
        true ->
            Len1 = length(Mems1),
            Len2 = length(Mems2),
            if
                Len1 > Len2 -> true;
                Len1 < Len2 -> false;
                true ->
                    if 
                        Fund1 >= Fund2 -> true;
                        true -> false
                    end
            end
    end.

get_new_guild_name(#guild{name = Name, srv_id = <<>>}) ->
    Name;
get_new_guild_name(#guild{name = Name, srv_id = Srvid}) ->
    ForLen = byte_size(Srvid) - 1,
    <<_:ForLen/binary, Pre/binary>> = Srvid,
    util:fbin(<<"【~s】~s">>, [Pre, Name]).

update_members_guild_name([], _NewName) -> ok;
update_members_guild_name([#guild_member{pid = Pid} | Mems], NewName) when is_pid(Pid) ->
    role:apply(async, Pid, {?MODULE, update_guild_name, [NewName]}),
    update_members_guild_name(Mems, NewName);
update_members_guild_name([_ | Mems], NewName) ->
    update_members_guild_name(Mems, NewName).

update_guild_name(Role = #role{guild  = Guild, link = #link{conn_pid = ConnPid}}, NewGuildName) ->
    sys_conn:pack_send(ConnPid, 13722, {[{34, NewGuildName}]}),
    NewRole = Role#role{guild = Guild#role_guild{name = NewGuildName}},
    map:role_update(NewRole),
    {ok, NewRole}.
