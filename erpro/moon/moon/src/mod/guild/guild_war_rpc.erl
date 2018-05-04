%% --------------------------------------------------------------------
%% 帮战rpc
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------
-module(guild_war_rpc).

-export([handle/3
    ,push/3]).

-include("common.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("guild_war.hrl").
%%
-include("assets.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% 帮战报名
handle(14601, {_Union}, Role = #role{guild = #role_guild{gid = GuildId, srv_id = SrvId}, assets = #assets{guild_war = _Gwar, guild_war_acc = _Gwaracc}}) ->
    OpenTime = sys_env:get(srv_open_time),
    case guild_war_util:day_diff(OpenTime, util:unixtime()) of
        Day when Day < 2 -> %% 开服前二天不开帮战
            {reply, {?false, ?L(<<"圣地之争报名还没有开始">>)}};
        _ ->
            ?debug_log([guild_war, {_Gwar, _Gwaracc}]),
            case guild_mgr:lookup(by_id, {GuildId, SrvId}) of
                #guild{lev = Lev} when Lev < ?guild_war_sign_guildlevellimit ->
                    {reply, {?false, ?L(<<"您的帮会级别低于5级，请提升帮会等级">>)}};
                false ->
                    {reply, {?false, ?L(<<"您还没有帮会">>)}};
                _ ->        
                    case guild_war_mgr:sign_up(Role, ?guild_war_union_attack) of
                        {ok} ->
                            ?debug_log([sign_up, success]),
                            {reply, {?true, <<"">>}};
                        {false, Reason} ->
                            ?debug_log([sign_up, Reason]),
                            {reply, {?false, Reason}}
                    end
            end
    end;

%% 进入准备区
handle(14602, {}, #role{team_pid = Pid}) when is_pid(Pid) ->
    {reply, {?false, ?L(<<"组队状态下不能进入圣地之争">>)}};
handle(14602, {}, #role{event = Event}) when Event =/= ?event_no andalso Event =/= ?event_guild ->
    {reply, {?false, ?L(<<"当前状态不能进入圣地之争">>)}};
handle(14602, {}, Role = #role{pid = Rpid}) ->
    do_handle(
        fun(WarPid) ->
                case guild_war:enter_prepare_map(WarPid, Role) of
                    {false, Reason} ->
                        guild_war_util:send_notice(Rpid, Reason, 2),
                        {reply, {?false, Reason}};
                    _ ->
                        campaign_task:listener(Role, guild_war, 1),
                        {reply, {?true, <<"">>}}
                end
        end,
        fun() ->
                ?debug_log([enter_prepare, not_start]),
                {reply, {?false, ?L(<<"圣地之争还没有开始">>)}}
        end
    );

%% 进入战区
handle(14603, {}, Role = #role{event = ?event_guild_war, event_pid = Epid}) ->
    guild_war:enter_war_map(Epid, Role),
    {ok};

%% 获取是否为第一次帮战
handle(14604, {}, _Role) ->
    Reply = guild_war_mgr:is_first_war(),
    {reply, {Reply}};

%% 帮战报名情况
handle(14605, {}, _Role) ->
    Reply = sign_up_info(guild_war_mgr:sign_up_info()),
    {reply, Reply};

%% 邀请帮会
handle(14606, {Gname}, _Role = #role{id = Rid, guild = RoleGuild}) ->
    case guild_mgr:lookup(by_name, Gname) of
        #guild{members = Members} ->
            case guild_war_util:get_guild_leader(Members) of
                false ->
                    {reply, {?false, ?L(<<"很遗憾，对方帮主不在线，邀请失败。">>)}};
                InRid ->
                    guild_war_mgr:invite(Rid, RoleGuild, InRid),
                    {ok}
            end;
        false ->
            {reply, {?false, ?L(<<"不存在此帮会，请重新输入">>)}}
    end;

%% 当前守护帮会
handle(14608, {}, _) ->
    Reply = case guild_war_mgr:owner_info() of
        undefined ->
            ?L(<<>>);
        Gid ->
            case guild_mgr:lookup(by_id, Gid) of
                false ->
                    ?L(<<>>);
                #guild{name = Name} ->
                    Name;
                _ ->
                    ?L(<<>>)
            end
    end,
    {reply, {Reply}};

%% 退出帮战
handle(14610, {}, Role = #role{event = ?event_guild_war, event_pid = Epid}) ->
    guild_war:leave_war(Epid, Role),
    {reply, {?true, <<"">>}};

%% 主将赛面板
handle(14611, {}, #role{event = ?event_guild_war, event_pid = Epid, id = Rid}) ->
    guild_war:push_compete(Epid, Rid),
    {ok};

%% 报名主将赛
handle(14612, {TeamNo}, Role = #role{pid = Rpid, event = ?event_guild_war, event_pid = Epid}) ->
    case guild_war:sign_compete(Epid, Role, TeamNo) of
        {false, Reason} ->
            guild_war_util:send_notice(Rpid, Reason, 2),
            {ok};
        {ok} ->
            {ok}
    end;

%% 取消报名主将赛
handle(14613, {}, Role = #role{pid = Rpid, event = ?event_guild_war, event_pid = Epid}) ->
    case guild_war:cancel_sign_compete(Epid, Role) of
        {false, Reason} ->
            guild_war_util:send_notice(Rpid, Reason, 2),
            {ok};
        {ok} ->
            {ok}
    end;

%% 帮战战况(个人)
handle(14621, {1, _Page}, #role{event = Event}) when Event =/= ?event_guild_war ->
    {reply, {?false, ?L(<<"您不在圣地之争中，不能查看当前圣地之争战况">>), 0, []}};
handle(14621, {1, Page}, #role{id = Rid, event = ?event_guild_war, event_pid = Epid}) ->
    case guild_war:war_info(Epid, role, Page, Rid) of
        {false, Reason} ->
            {reply, {?false, Reason, 0, []}};
        {Num, List} ->
            {reply, {?true, <<"">>, Num, List}}
    end;
handle(14621, {2, Page}, #role{id = Rid}) ->
    case guild_war_mgr:last_war_info(role, Page, Rid) of
        {false, Reason} ->
            {reply, {?false, Reason, 0, []}};
        {Num, List} ->
            {reply, {?true, <<"">>, Num, List}}
    end;

%% 帮战战况(帮会)
handle(14622, {1, _Page}, #role{event = Event}) when Event =/= ?event_guild_war ->
    {reply, {?false, ?L(<<"您不在圣地之争中，不能查看当前圣地之争战况">>), 0, []}};
handle(14622, {1, Page}, #role{id = Rid, event = ?event_guild_war, event_pid = Epid}) ->
    case guild_war:war_info(Epid, guild, Page, Rid) of
        {false, Reason} ->
            {reply, {?false, Reason, 0, []}};
        {Num, List} ->
            {reply, {?true, <<"">>, Num, List}}
    end;
handle(14622, {2, Page}, #role{id = Rid}) ->
    case guild_war_mgr:last_war_info(guild, Page, Rid) of
        {false, Reason} ->
            {reply, {?false, Reason, 0, []}};
        {Num, List} ->
            {reply, {?true, <<"">>, Num, List}}
    end;

%% 帮战战况(联盟)
handle(14623, {1}, #role{event = Event}) when Event =/= ?event_guild_war ->
    {reply, {?false, ?L(<<"您不在圣地之争中，不能查看当前圣地之争战况">>), []}};
handle(14623, {1}, #role{id = Rid, event = ?event_guild_war, event_pid = Epid}) ->
    case guild_war:war_info(Epid, union, 0, Rid) of
        {false, Reason} ->
            {reply, {?false, Reason, []}};
        {_Num, List} ->
            {reply, {?true, <<"">>, List}}
    end;
handle(14623, {2}, #role{id = Rid}) ->
    case guild_war_mgr:last_war_info(union, 0, Rid) of
        {false, Reason} ->
            {reply, {?false, Reason, []}};
        {_Num, List} ->
            {reply, {?true, <<"">>, List}}
    end;

%% 帮战小战况
handle(14624, {}, #role{event = ?event_guild_war, event_pid = Epid, id = Rid}) ->
    guild_war:push_small_war_info(Epid, Rid),
    {ok};

%% 帮战倒计时
handle(14631, {}, Role) ->
    guild_war_flow:get_flow_time(Role),
    {ok};

%% 获取玩家当前是进攻还是防守方
handle(14632, {}, Role = #role{event = ?event_guild_war}) ->
    guild_war:get_union(Role),
    {ok};

handle(_Cmd, _Request, _Role = #role{name = _Name}) ->
    ?DEBUG("无效请求 name = ~s, cmd = ~w, request = ~w", [_Name, _Cmd, _Request]),
    {ok}.

%% @spec push(Pids, Cmd, Data)
%% Pids = [pid(), ...] | pid()
%% Cmd = atom()
%% Data = term()
%% 推送消息到客户端
%% 推送倒计时
push(Pid, get_flow_time, {Type, Time}) when is_pid(Pid) ->
    role:pack_send(Pid, 14631, {Type, Time});
%% 推送联盟方
push(Pid, get_union, {Type}) when is_pid(Pid) ->
    role:pack_send(Pid, 14632, {Type});

push(_, _Cmd, _Para) ->
    ?DEBUG("无效请求 cmd = ~w, para = ~w", [_Cmd, _Para]),
    {ok}.

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------
do_handle(Act, Act2) ->
    WarPid = guild_war_mgr:get_war_pid(),
    case is_pid(WarPid) andalso is_process_alive(WarPid) of
        true ->
            Act(WarPid);
        false ->
            Act2()
    end.

%% 帮战报名信息
sign_up_info(Guilds) ->
    sign_up_info(Guilds, [], []).

sign_up_info([], AtkGuilds, DfdGuilds) ->
    {AtkGuilds, DfdGuilds};
sign_up_info([#guild_war_guild{id = Gid, union = Union, realm = Realm} | T], AtkGuilds, DfdGuilds) ->
    GuildInfo = case guild_mgr:lookup(by_id, Gid) of
        #guild{name = Name, lev = Lev, chief = Chief, num = Num} ->
            {Name, Lev, Chief, Num, Realm};
        _ ->
            {<<"">>, 0, <<"">>, 0, 0}
    end,
    case Union of
        ?guild_war_union_attack ->
            sign_up_info(T, [GuildInfo | AtkGuilds], DfdGuilds);
        ?guild_war_union_defend ->
            sign_up_info(T, AtkGuilds, [GuildInfo | DfdGuilds])
    end.


