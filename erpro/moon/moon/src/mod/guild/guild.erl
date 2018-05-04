%%----------------------------------------------------
%%  帮会系统
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild).
-behaviour(gen_server).
-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([alters/2           %% 帮会属性修改类操作
        ,gain/2             %% 帮会获得资金
        ,alter/3            %% 帮会数据修改
        ,apply/3            %% 帮会同步，异步调用函数
        ,pack_send/3        %% 向指定帮会，的所有帮会成员发送指定协议内容
        ,event_callback/3   %% 注册一个定时帮会事件回调
        ,event_callback/2   %% 注册一个定时帮会事件回调
        ,send_after/3       %% 注册一个定时帮会事件回调函数，返回定时器的引用
        ,send_after/2       %% 注册一个定时帮会事件回调函数，返回定时器的引用
        ,dismiss/3          %% 帮会解散
        ,union_dismiss/1    %% 帮会合并解散 guild_union调用
        ,dismiss_by_mgr/1   %% 帮会解散
        ,role_guild_name/1  %% 获取角色场景广播帮会信息
        ,position_name/1    %% 职称
        ,reg_maintain_callback/2
        ,sys_msg/3            %% 发送一个帮会系统消息
        ,restart/3
        ,maintain_callback/1
    ]
).
-export([guild_loss/2       %% 扣除帮会资金
        ,guild_gain/2       %% 增加帮会资金
        ,guild_mail/2       %% 发生帮会邮件
        ,guild_chat/2       %% 帮会聊天信息
        ,guild_cast/2       %% 发生一个handle_cast消息
        ,guild_info/2       %% 发生一个handle_info消息
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("vip.hrl").
-include("buff.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("chat_rpc.hrl").
-include("rank.hrl").
%%

-define(UNIXDAYTIME, 86400).            %% unixtime 一天86400秒
-define(midnight, {0,0,1}).            %% 帮会数据凌晨更新时间
%%-define(midnight, {12,27,0}).            %% 帮会数据凌晨更新时间
-define(guild_dismiss_fund_line, -1000).    %% 帮会销毁资金线
-define(guild_dismiss_warn_times, 3).       %% 帮会资金过低，警告次数
-define(guild_vip_map_entrance(Vip), 
    case Vip of
        ?guild_vip -> ?guild_vip_map;
        _ -> ?guild_novip_map
    end
).

%% @spec gain(Devote, Role) -> ok
%% Devote = integer()
%% Role = #role{}
%% @doc 帮会给帮会增加资金
gain(Devote, #role{id = {Rid, Rsrvid}, guild = #role_guild{pid = Pid}}) when is_pid(Pid) ->
    Pid ! {gain, Devote, Rid, Rsrvid};
gain(_Devote, _Role) ->
    ok.

%% @spec guild_gain(Guild, {Rid, Rsrvid, Val}) -> ok
%% Guild = pid() | gid()
%% Rid = integer()
%% Rsrvid = binary()
%% Val = integer()
%% @doc 给帮会增加帮会资金，Rid，Rsrvid 是贡献帮会自己的帮会成员ID和服务器标志
guild_gain(GuildPid, {Rid, Rsrvid, Val}) when is_integer(Val) ->
    guild_info(GuildPid, {gain, Val, Rid, Rsrvid});
guild_gain({Gid, Gsrvid}, {Rid, Rsrvid, Val}) when is_integer(Val) ->
    guild_info({Gid, Gsrvid}, {gain, Val, Rid, Rsrvid}).

%% @spec loss(GuildPid, Val) -> true | {false, Reason}
%% GuildPid = pid()
%% Val = integer()
%% @doc 扣除帮会资金
guild_loss(GuildPid, Val) when is_pid(GuildPid) andalso is_integer(Val) ->
    case guild_call(GuildPid, {loss, Val}) of
        true ->
            true;
        {false, Reason} ->
            {false, Reason};
        _ ->
            {false, <<>>}
    end;
guild_loss({Gid, Gsrvid}, Val) when is_integer(Val) ->
    case guild_call({Gid, Gsrvid}, {loss, Val}) of
        true ->
            true;
        {false, Reason} ->
            {false, Reason};
        _ ->
            {false, <<>>}
    end;
guild_loss(_GuildPid, _Val) ->
    ?ERR("请求扣除帮会资金失败【is_pid: ~w】【is_integer: 】", [is_pid(_GuildPid), is_integer(_Val)]),
    {false, <<>>}.

%% @spec guild_mail({Gid, Gsrvid}, {Subject, Text}) -> true | false
%% Gid = integer()
%% Gsrvid = Subject = Text = binary()
%% @doc 给帮会成员发送邮件， Gid为帮会ID，Gsrvid为帮会服务器标识，Subject为邮件主题，Text为邮件内容, 必须采用异步调用
guild_mail({Gid, Gsrvid}, {Subject, Text}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members} ->
            Roles = [{Rid, Rsrvid, Rname} || #guild_member{id = {Rid, Rsrvid}, name = Rname} <- Members],
            mail_mgr:deliver(Roles, {Subject, Text, [], []}),
            true;
        _ ->
            false
    end.

%% @spec guild_chat(GuildPid, Msg) -> ok
%% GuildPid = pid()
%% Msg = binary()
%% @doc 给所有帮会成员发送一个系统消息
guild_chat(GuildPid, Msg) when is_pid(GuildPid), is_binary(Msg) ->
    GuildPid ! {guild_msg, Msg},
    ok;
guild_chat({Gid, Gsrvid}, Msg) when is_binary(Msg) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false -> ok;
        #guild{members = Mems} ->
            Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:pack_send(Pid, 10932, {?chat_guild, 61, Msg});
                (_GuildMember) -> ok 
            end,
            lists:foreach(Fun, Mems), 
            ok
    end;
guild_chat(Mems, Msg) when is_binary(Msg), is_list(Mems) ->
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:pack_send(Pid, 10932, {?chat_guild, 61, Msg});
        (_GuildMember) -> ok 
    end,
    lists:foreach(Fun, Mems), 
    ok;
guild_chat(_Guild, _Msg) ->
    ?ERR("向帮会成员发送一个系统消息时，函数参数匹配失败"),
    ok.

%% @spec sys_msg(Type, Guild, Msg) -> ok
%% Type = right_able | right_unable
%% Guild = {integer, binary} | [#guild_member{} | ..]
%% Msg = binary()
%% @doc 向帮会成员发送系统消息，right_able 会显示在左下角，right_unable 不会显示在左下角
sys_msg(right_able, {Gid, Gsrvid}, Msg) when is_binary(Msg) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false -> ok;
        #guild{members = Mems} ->
            Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:pack_send(Pid, 10932, {?chat_guild, 61, Msg});
                (_GuildMember) -> ok 
            end,
            lists:foreach(Fun, Mems), 
            ok
    end;
sys_msg(right_able, Mems, Msg) when is_binary(Msg) andalso is_list(Mems) ->
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:pack_send(Pid, 10932, {?chat_guild, 61, Msg});
        (_GuildMember) -> ok 
    end,
    lists:foreach(Fun, Mems), 
    ok;
sys_msg(_Type, {Gid, Gsrvid}, Msg) when is_binary(Msg) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false -> ok;
        #guild{members = Mems} ->
            Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:pack_send(Pid, 10931, {59, Msg, []});
                (_GuildMember) -> ok 
            end,
            lists:foreach(Fun, Mems), 
            ok
    end;
sys_msg(_Type, Mems, Msg) when is_binary(Msg) andalso is_list(Mems) ->
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:pack_send(Pid, 10931, {59, Msg, []});
        (_GuildMember) -> ok 
    end,
    lists:foreach(Fun, Mems), 
    ok;

sys_msg(_Type, _Guild, _Msg) ->
    ?ERR("向帮会成员发送一个系统消息时，函数参数匹配失败"),
    ok.

%% @spec apply(async, {Gid, Gsrvid}, Mfa) -> ok
%% Gid = integer()
%% Gsrvid = binary()
%% Mfa = {F} | {F, A} | {M, F, A}
%% @doc 对指定帮会应用MFA(异步方式)
%% <div>注意:F的返回值格式要求: F([State | A]) -> {ok} | {ok, NewState}</div>
apply(async, {0, <<>>}, _MFA) ->
    ok;
apply(async, GuildPid, MFA) when is_pid(GuildPid) ->
    case is_valid_mfa(MFA) of
        true ->
            GuildPid ! {apply_async, MFA},
            ok;
        false -> 
            ?ERR("执行帮会 apply 异步请求 传入错误的 MFA 参数 [~w]", [MFA]),
            ok
    end;
apply(async, {Gid, Gsrvid}, MFA) ->
    case is_valid_mfa(MFA) of
        true ->
            guild_info({Gid, Gsrvid}, {apply_async, MFA}),
            ok;
        false -> 
            ?ERR("执行帮会 apply 异步请求 传入错误的 MFA 参数 [~w]", [MFA]),
            ok
    end;
apply(async, _GuildID, _MFA) ->
    ?ERR("执行帮会异步调用时传入错误的ID或PID，[~w][MFA:~w]" , [_GuildID, _MFA]),
    ok;

%% @spec apply(sync, {Gid, Gsrvid}, Mfa) -> Reply | error
%% Gid = integer()
%% Gsrvid = binary()
%% Mfa = {F} | {F, A} | {M, F, A}
%% Reply = term()
%% @doc 对指定帮会应用MFA(同步方式)
%% <div>注意:F的返回值格式要求: F([State | A]) -> {ok, Reply} | {ok, Reply, NewState}</div>
apply(sync, Pid, _MFA) when Pid =:= self() ->
    ?ERR("执行帮会apply同步请求 [~w] 发生 self_call", [_MFA]),
    error;
apply(sync, Pid, MFA) when is_pid(Pid) ->
    case is_valid_mfa(MFA) of
        true ->
            guild_call(Pid, {apply_sync, MFA});
        false ->
            ?ERR("执行帮会 apply 同步请求 传入错误的 MFA 参数 [~w]", [MFA]),
            error
    end;

apply(sync, {0, <<>>}, _MFA) ->
    error;
apply(sync, {Gid, Gsrvid}, MFA) ->
    case is_valid_mfa(MFA) of
        true ->
            case global:whereis_name({guild, Gid, Gsrvid}) of
                undefined ->
                    ?ERR("向不存在帮会 [~w,~s] 发出请求 [~w]", [Gid, Gsrvid, MFA]),
                    error;
                Pid when self() =:= Pid ->
                    ?ERR("向帮会 [~w,~s] 发出的请求 [~w] 发生 self_call", [Gid, Gsrvid, MFA]),
                    error;
                Pid ->
                    guild_call(Pid, {apply_sync, MFA})
            end;
        false ->
            ?ERR("执行帮会 [~w,~s] apply 同步请求 传入错误的 MFA 参数 [~w]", [Gid, Gsrvid, MFA]),
            error
    end;
apply(sync, _Guild, _MFA) ->
    ?ERR("执行帮会 apply 同步请求时 传入错误的参数 [~w, ~w]，发生 function clause", [_Guild, _MFA]),
    error.

%% 检测 MFA 的有效性
is_valid_mfa({F}) when is_function(F) -> true;
is_valid_mfa({F, A}) when is_function(F) andalso is_list(A) -> true;
is_valid_mfa({M, F, A}) when is_atom(M) andalso is_atom(F) andalso is_list(A) -> true;
is_valid_mfa(_Mfa) -> false.

%% @spec guild_call(GuildPid, Msg) -> error | term()
%% GuildPid = pid()
%% Msg = term()
%% @doc 根据帮会Pid向帮会进程发起一个同步请求
guild_call(Pid, Msg) when is_pid(Pid) ->
    try gen_server:call(Pid, Msg) of
        Reply -> Reply
    catch
        exit:{timeout, _} ->
            ?ERR("向帮会 [~w] 发起的请求 [~w] 发生timeout", [Pid, Msg]),
            error;
        exit:{noproc, _} ->
            ?ERR("向帮会 [~w] 发起的请求 [~w] 发生noproc", [Pid, Msg]),
            error;
        Error:Info ->
            ?ERR("向帮会 [~w] 发起的请求 [~w] 收到异常消息{~w, ~w}", [Pid, Msg, Error, Info]),
            error
    end;
guild_call({Gid, Gsrvid}, Msg) when is_integer(Gid) andalso is_binary(Gsrvid) ->
    try gen_server:call({global, {guild, Gid, Gsrvid}}, Msg) of
        Reply -> Reply
    catch
        exit:{timeout, _} ->
            ?ERR("向帮会 [~w, ~s] 发起的请求 [~w] 发生timeout", [Gid, Gsrvid, Msg]),
            error;
        exit:{noproc, _} ->
            ?ERR("向帮会 [~w, ~s] 发起的请求 [~w] 发生noproc", [Gid, Gsrvid, Msg]),
            error;
        Error:Info ->
            ?ERR("向帮会 [~w, ~s] 发起的请求 [~w] 收到异常消息{~w, ~w}", [Gid, Gsrvid, Msg, Error, Info]),
            error
    end;

guild_call(Guild, Msg) ->
    ?ERR("调用函数 guild_call 时传入错误的 参数 [~w, ~w]，发生 function clause", [Guild, Msg]),
    error.

%% @spec guild_cast(To, Msg) -> ok
%% To = #role{} | gid()
%% gid() = {integer(), binary()}
%% Msg = term()
%% @doc 向帮会进程发送一个 handle_cast消息
guild_cast(Pid, Msg) when is_pid(Pid) ->
    gen_server:cast(Pid, Msg);
guild_cast({Gid, Gsrvid}, Msg) when is_integer(Gid), is_binary(Gsrvid) ->
    gen_server:cast({global, {guild, Gid, Gsrvid}}, Msg);
guild_cast(Guild, Msg) ->
    ?ERR("调用函数 guild_cast 时传入错误的 参数 [~w, ~w]，发生 function clause", [Guild, Msg]),
    ok.

%% @spec guild_info(To, Msg) -> ok
%% To = #role{} | gid()
%% gid() = {integer(), binary()}
%% Msg = term()
%% @doc 向帮会进程发生一个 handle_info 消息
guild_info(Pid, Msg) when is_pid(Pid) ->
    Pid ! Msg,
    ok;
guild_info({Gid, Gsrvid}, Msg) when is_integer(Gid), is_binary(Gsrvid) ->
    case global:whereis_name({guild, Gid, Gsrvid}) of
        undefined ->
            ?ERR("向帮会进程发送消息{~w}失败，找不指定的到帮会{~w, ~s}进程", [Msg, Gid, Gsrvid]),
            ok;
        Pid ->
            Pid ! Msg,
            ok
    end;
guild_info(Guild, Msg) ->
    ?ERR("调用函数 guild_info 时传入错误的 参数 [~w, ~w]，发生 function clause", [Guild, Msg]),
    ok.

%% @spec pack_send(Gid, Cmd, Data) ->
%% @type Gid = gid()
%% @type Cmd = integer()
%% @type Data = term()
%% @doc 向指定帮会的成员发送指定协议内容
pack_send({Gid, Gsrvid}, Cmd, Data) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            ok;
        #guild{members = Mems} ->
            Fun = fun(#guild_member{pid = 0}) -> ok;
                (#guild_member{pid = RolePid}) -> role:pack_send(RolePid, Cmd, Data)
            end,
            lists:foreach(Fun, Mems)
    end;
pack_send(Mems, Cmd, Data) when is_list(Mems) ->
    Fun = fun(#guild_member{pid = 0}) -> ok;
        (#guild_member{pid = RolePid}) -> role:pack_send(RolePid, Cmd, Data)
    end,
    lists:foreach(Fun, Mems);
pack_send(_Target, _Cmd, _Data) ->
    ?ERR("向成员发送错误的制定协议内容"),
    ok.

%% @spec event_callback(GuildID, After, MFA) -> ok
%% Guild = gid() | pid()
%% Ater = integer()
%% MFA = {M, F, A} | {F, A} | {F}
%% M = F = atom()
%% F = ArgList
%% @doc 注册一个事件回调函数, After(秒)时间后，执行指定的MFA
event_callback(_GuildID, After, _MFA) when not(is_integer(After)) ->
    ?ERR("注册帮会事件定时回调函数 [~w] 时，传入错误的时间值 [~w]", [_MFA, After]);
event_callback(_GuildID, After, _MFA) when After < 0 ->
    ?ERR("注册帮会事件定时回调函数 [~w] 时，传入错误的时间值 [~w]", [_MFA, After]);
event_callback(Guild, After, MFA) ->
    case is_valid_mfa(MFA) of
        true ->
            guild_info(Guild, {event_callback, After, MFA});
        false ->
            ?ERR("注册帮会 [~w] 事件回调函数时，传入错误的 MFA 参数 [~w]", [Guild, MFA]),
            ok
    end.

%% @spec event_callback(After, MFA) -> ok
%% @doc 注册一个事件回调函数，After(秒)时间后，执行指定的MFA， 该函数只能在帮会进程内执行
event_callback(After, _MFA) when not(is_integer(After)) ->
    ?ERR("注册帮会事件定时回调函数 [~w] 时，传入错误的时间值 [~w]", [_MFA, After]);
event_callback(After, _MFA) when After < 0 ->
    ?ERR("注册帮会事件定时回调函数 [~w] 时，传入错误的时间值 [~w]", [_MFA, After]);
event_callback(After, MFA) ->
    case is_valid_mfa(MFA) of
        true ->
            guild_info(self(), {event_callback, After, MFA});
        false ->
            ?ERR("注册帮会 [~w] 事件回调函数时，传入错误的 MFA 参数 [~w]", [self(), MFA]),
            ok
    end.

%% @spec send_after(GuildID, After, MFA) -> reference() | error
%% Guild = gid() | pid()
%% Ater = integer()
%% MFA = {M, F, A} | {F, A} | {F}
%% M = F = atom()
%% F = ArgList
%% @doc 注册一个事件回调函数, After(秒)时间后，执行指定的MFA
send_after(_GuildID, After, _MFA) when not(is_integer(After)) ->
    ?ERR("注册帮会事件定时回调函数 [~w] 时，传入错误的时间值 [~w]", [_MFA, After]),
    error;
send_after(_GuildID, After, _MFA) when After < 0 ->
    ?ERR("注册帮会事件定时回调函数 [~w] 时，传入错误的时间值 [~w]", [_MFA, After]),
    error;
send_after(Guild, After, MFA) ->
    case is_valid_mfa(MFA) of
        true -> 
            guild_call(Guild, {send_after, After, MFA});
        false ->
            ?ERR("注册帮会 [~w] 事件回调函数时，传入错误的 MFA 参数 [~w]", [Guild, MFA]),
            error
    end.

%% @spec send_after(After, MFA) -> reference() | error
%% @doc 注册一个事件回调函数，After(秒)时间后，执行指定的MFA， 该函数只能在帮会进程内执行
send_after(After, _MFA) when not(is_integer(After)) ->
    ?ERR("注册帮会事件定时回调函数 [~w] 时，传入错误的时间值 [~w]", [_MFA, After]),
    error;
send_after(After, _MFA) when After < 0 ->
    ?ERR("注册帮会事件定时回调函数 [~w] 时，传入错误的时间值 [~w]", [_MFA, After]),
    error;
send_after(After, MFA) ->
    case is_valid_mfa(MFA) of
        true -> 
            erlang:send_after(After * 1000, self(), {apply_async, MFA});
        false ->
            ?ERR("注册帮会 [~w] 事件回调函数时，传入错误的 MFA 参数 [~w]", [self(), MFA]),
            error
    end.

%% @spec reg_maintain_callback(GuildID, After, MFA) -> ok
%% Guild = gid() | pid()
%% MFA = {M, F, A} | {F, A} | {F}
%% @doc 注册一个帮会午夜维护事件回调函数, 0:10 分 左右执行
reg_maintain_callback(Guild, MFA) ->
    case is_valid_mfa(MFA) of
        true ->
            guild_info(Guild, {reg_maintain_callback, MFA});
        false ->
            ?ERR("注册帮会 [~w] 午夜维护事件回调函数时，传入错误的 MFA 参数 [~w]", [Guild, MFA]),
            ok
    end.

%% @spec dismiss(Rname) -> ok
%% Rname = binary()
%% @doc 帮会销毁， 该函数必须在当前帮会进程中调用
dismiss(Rid, Rsrvid, Rname) ->
    self() ! {dismiss, Rid, Rsrvid, Rname}, 
    ok.

%% @spec dismiss_by_mgr(GuildPid) -> ok
%% GuildPid = pid()
%% @doc 帮会管理进程销毁帮会
dismiss_by_mgr(GuildPid) when is_pid(GuildPid) -> 
    GuildPid ! {dismiss, 0, <<>>, <<"guild_mgr">>};
dismiss_by_mgr(_) -> 
    ok.

%% 场景广播角色帮会的名字显示
role_guild_name(#role{guild = #role_guild{gid = 0, name = Gname}}) ->
    <<"00", Gname/binary>>;
role_guild_name(#role{guild = #role_guild{name = Gname, position = Job}}) ->
    Pname = position_name(Job),
    JobBin = list_to_binary(integer_to_list(Job)),
    <<JobBin/binary, Gname/binary, <<" · ">>/binary, Pname/binary>>.

%% 获取职位名字
position_name(Job) ->
    case Job of
        ?guild_chief -> ?L(<<"帮主">>);
        ?guild_elder -> ?L(<<"长老">>);
        ?guild_lord -> ?L(<<"堂主">>);
        ?guild_elite -> ?L(<<"精英弟子">>);
        _ -> ?L(<<"弟子">>)
    end.

%%-----------------------------------------------------------------------
%% guild 修改函数
%%-----------------------------------------------------------------------
%% 批量修改帮会数据
alters([], State) ->
    State;
alters([{Type, Value} | T], State) ->
    alters(T, alter(Type, Value, State)).

alter(lev, Lev, State = #guild{members = Mems}) ->
    guild_refresh:refresh(13721, [{1, Lev}], Mems),
    State#guild{lev = Lev};

alter(maxnum, MaxNum, State = #guild{members = Mems}) ->
    guild_refresh:refresh(13721, [{3, MaxNum}], Mems),
    State#guild{maxnum = MaxNum};

alter(members, NewMems, State) ->
    DonationRank = lists:reverse(lists:keysort(#guild_member.gold, lists:keysort(#guild_member.coin, NewMems))),
    guild_refresh:refresh(12735, DonationRank, NewMems), 
    State#guild{members = NewMems};

alter(bulletin, {Bulletin, QQ, YY}, State = #guild{members = Mems}) ->
    guild_refresh:refresh(13722, [{31, Bulletin}, {32, QQ}, {33, YY}], Mems),
    State#guild{bulletin = {Bulletin, QQ, YY}};

alter(weal, Weal, State = #guild{members = Mems}) ->
    guild_refresh:refresh(13721, [{7, Weal}], Mems),
    State#guild{weal = Weal};

alter(exp, Exp, State = #guild{members = Mems}) ->
    guild_refresh:refresh(13721, [{10, Exp}], Mems),
    State#guild{exp = Exp};

alter(stove, Stove, State = #guild{members = Mems}) ->
    guild_refresh:refresh(13721, [{5, Stove}], Mems),
    State#guild{stove = Stove};

alter(fund, Fund, State = #guild{members = Mems}) ->
    guild_refresh:refresh(13720, Fund, Mems),
    NewState = State#guild{fund = Fund},
    guild_mgr:listen(guild_rank, NewState),    %% 帮会管理进程 数据副本监听
    NewState;

alter(day_fund, DayFund, State = #guild{members = Mems}) ->
    guild_refresh:refresh(13721, [{4, DayFund}], Mems),
    State#guild{day_fund = DayFund};

alter(note_list, List, State) ->
    State#guild{note_list = List};

alter(store_log, Log, State) ->
    State#guild{store_log = Log};

alter(donation_log, Log, State) ->
    State#guild{donation_log = Log};

alter(skills, Skills, State) ->
    State#guild{skills = Skills};

alter(chairs, Chairs, State) ->
    State#guild{chairs = Chairs};

alter(permission, {Skill, Stove, Store}, State = #guild{members = Mems}) ->
    guild_refresh:refresh(12746, {Skill, Stove, Store}, Mems), 
    State#guild{permission = {Skill, Stove, Store}};

alter(map, MapPid, State) ->
    State#guild{map = MapPid};

alter(rtime, Rtime, State) ->
    State#guild{rtime = Rtime};

alter(treasure_log, Log, State) ->
    State#guild{treasure_log = Log};

alter(wish_item_log, Log, State) ->
    State#guild{wish_item_log = Log};

%%alter(guild_task, Task, State) ->
%%    #guild{target_lst = Target} = State,
%%    State#guild{target_lst = [Task|Target]};

%%alter(mem_task, MemTask, State) ->
%%    #guild{target_info = Target} = State,
%%    State#guild{target_info = Target#guild_target{mem_task = MemTask}};

alter(shop, NewShopLvl, State) ->
    State#guild{shop = NewShopLvl};

alter(wish, NewWishLvl, State) ->
    State#guild{wish_pool_lvl = NewWishLvl};

alter(_Cmd, _Data, _State) ->
    ?ERR("帮会数据错误的修改类型：~w",[_Cmd]),
    _State.

%% @spec restart(Pid, Type, Reason) -> ok
%% Pid = pid() | {integer(), binary()}
%% Reason = term()
%% @doc 重启帮会进程
restart(Pid, Type, Reason) ->
    guild_info(Pid, {restart, Type, Reason}).

%%-----------------------------------------------------------
%% 系统函数
%%-----------------------------------------------------------
start_link(create, State = #guild{id = {Gid, Gsrvid}}) ->
    gen_server:start_link({global, {guild, Gid, Gsrvid}}, ?MODULE, [create, State], []);

start_link({restart, Reason}, State = #guild{id = {Gid, Gsrvid}}) ->
    gen_server:start_link({global, {guild, Gid, Gsrvid}}, ?MODULE, [{restart, Reason}, State], []).

%% 创建帮会初始化
init([Type, State = #guild{id = {Gid, Gsrvid}, name = Gname, gvip = Gvip}]) ->
    ?INFO("帮会 [~s] 正在启动...", [Gname]),
    {MapBaseID, Ex, Ey} = ?guild_vip_map_entrance(Gvip),
    case map_mgr:create(MapBaseID) of
        {false, Reason} ->
            ?ERR("帮会领地地图创建失败: ~s", [Reason]),
            {stop, create_guild_map_failure};
        {ok, MapPid, MapId} ->
            NewState = State#guild{pid = self(), map = MapPid, entrance = {MapId, Ex, Ey}, chairs = []},
            self() ! start,
            erlang:register(list_to_atom(lists:concat(["guild_", Gid, "_", binary_to_list(Gsrvid)])), self()), 
            init_start(Type, NewState),
            ?INFO("帮会 [~s] 启动完成", [Gname]),
            {ok, NewState}
    end.

%%----------------------------------------------------------
%% handle_call
%%----------------------------------------------------------
handle_call({loss, Val}, _From, State = #guild{fund = Fund}) when Fund < Val ->
    {reply, {false, ?L(<<"帮会资金不足">>)}, State};
handle_call({loss, Val}, _From, State = #guild{fund = Fund}) ->
    NewState = alters([{fund, Fund - Val}], State),
    update_guild_list(NewState),
    {reply, true, NewState};

%% 帮会同步请求
handle_call({apply_sync, {F}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(F, [State]), {undefined, F, []}, State);

handle_call({apply_sync, {F, A}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(F, [State | A]), {undefined, F, A}, State);

handle_call({apply_sync, {M, F, A}}, _From, State) ->
    handle_apply_sync_return(catch erlang:apply(M, F, [State | A]), {M, F, A}, State);

%% 注册一个事件回调函数，改函数会在 After 秒之后执行
handle_call({send_after, After, MFA}, _From, State) ->
    Ref = erlang:send_after(After * 1000, self(), {apply_async, MFA}),
    {reply, {ref, Ref}, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%----------------------------------------------------------
%% handle_cast
%%----------------------------------------------------------
handle_cast(you_guy_need_to_shutdown, State = #guild{name = Name}) ->
    ?INFO("帮会 [~s] 收到管理进程压迫，被迫自杀", [Name]),
    update_guild_list(State),
    exit(normal),
    {noreply, State};

%% 正常结束进程 合帮推销帮会时使用 guild_union中使用
handle_cast(stop, State) ->
    ?INFO("帮会[~s]正常结束进程", [State#guild.name]),
    {stop, normal, State};

%% 容错
handle_cast(_Data, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% handle_info
%%-----------------------------------------------------------
handle_info(start, State = #guild{name = Name, gvip = Vip}) ->
    erlang:send_after(30000, self(), gc),   %% 启动定时gc
    self() ! midnight,                      %% 凌晨清理
    spawn(guild_rss, start, [State]),       %% 订阅监听
%%  self() ! impeach,
    case Vip of
        ?guild_vip -> self() ! {guild_msg, util:fbin(<<"欢迎来到 VIP 军团 ~s">>, [Name])};
        _ -> self() ! {guild_msg, util:fbin(<<"欢迎来到 军团 ~s">>, [Name])}
    end,
    erlang:send_after(util:rand(3600, 14400) * 1000, self(), save_db),
    {noreply, State};

handle_info(impeach, State = #guild{impeach = Impeach = #impeach{status = Status, time = Time, id = Rid, srv_id = Rsrvid}}) ->
    case Status of
        ?guild_impeach_role ->
            case 2*86400 + Time - util:unixtime() of
                Diff when Diff > 0 ->
                    Ref = erlang:send_after(Diff * 1000, self(), {apply_async, {?MODULE, async_impeach_success, [{Rid, Rsrvid}]}}),
                    {noreply, State#guild{impeach = Impeach#impeach{ref = Ref}}};
                _ ->
                    Ref = erlang:send_after(0, self(), {apply_async, {?MODULE, async_impeach_success, [{Rid, Rsrvid}]}}),
                    {noreply, State#guild{impeach = Impeach#impeach{ref = Ref}}}
            end;
        _ ->
            {noreply, State}
    end;

%% 解散帮会
handle_info({dismiss, Rid, Rsrvid, Rname}, State = #guild{id = {Gid, Gsrvid}, name = Gname}) ->
    ?INFO("角色 [~s] 解散了帮会 [~s]", [Rname, Gname]),
    dismiss_guild(State),         %% 销毁清理
    spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"帮会销毁">>, <<"主动销毁">>]),
    catch guild_boss:dismiss({Gid, Gsrvid}), 
    exit(normal),
    {noreply, State};

%% 执行一个MFA
handle_info({apply_async, {F}}, State) ->
    handle_apply_async_return(catch erlang:apply(F, [State]), {undefined, F, []}, State);

handle_info({apply_async, {F, A}}, State) ->
    handle_apply_async_return(catch erlang:apply(F, [State | A]), {undefined, F, A}, State);

handle_info({apply_async, {M, F, A}}, State) ->
    handle_apply_async_return(catch erlang:apply(M, F, [State | A]), {M, F, A}, State);

%% 注册一个事件回调函数，改函数会在 After 秒之后执行
handle_info({event_callback, After, MFA}, State) ->
    erlang:send_after(After * 1000, self(), {apply_async, MFA}),
    {noreply, State};

%% 注册一个帮会午夜维护事件回调函数, 0:10 分 左右执行
handle_info({reg_maintain_callback, MFA}, State) ->
    case get(maintain_callback) of
        undefined ->
            put(maintain_callback, [MFA]);
        MFAs when is_list(MFAs) ->
            put(maintain_callback, [MFA|MFAs]);
        _MFAs ->
            ?ERR("错误的帮会午夜定时维护回调函数 ~w ", [_MFAs]),
            put(maintain_callback, [MFA])
    end,
    {noreply, State};

%% 帮会系统消息
handle_info({guild_msg, Msg}, State = #guild{members = Mems}) ->
    Fun = fun(#guild_member{pid = Pid}) -> catch role:pack_send(Pid, 10932, {?chat_guild, 61, Msg}) end,
    lists:foreach(Fun, Mems),
    {noreply, State};

%% 帮会系统消息 右下角
handle_info({right_msg, Msg}, State = #guild{members = Mems}) ->
    Fun = fun(#guild_member{pid = Pid}) -> catch role:pack_send(Pid, 10932, {?chat_right, 0, Msg}) end,
    lists:foreach(Fun, Mems),
    {noreply, State};

handle_info({gain, Devote, Rid, Rsrvid}, State = #guild{fund = Fund, members = Mems}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Mems) of
        false -> 
            {noreply, State};
        M = #guild_member{donation = DO} ->
            NewFund = Fund + Devote * 10,
            M1 = M#guild_member{donation = DO + Devote},
            ?DEBUG("=================>>>> 更新玩家累计贡献为 ~p~n", [DO+Devote]),
            NewMems = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Mems, M1),
            NewState = alters([{fund, NewFund}, {members, NewMems}], State),
            guild_refresh:refresh(13729, M1, NewMems),
            update_guild_list(NewState),
            {noreply, NewState}
    end;

%% 定时gc
handle_info(gc, State) ->
    garbage_collect(),
    erlang:send_after(util:rand(60000, 120000), self(), gc),
    {noreply, State};

%% 校准时间到午夜12点清理操作
handle_info(midnight, State) ->
    Mid = calendar:time_to_seconds(?midnight),
    Now = calendar:time_to_seconds(time()),
    case Now =< Mid of
        true -> erlang:send_after((Mid - Now) * 1000, self(), midnight_op);
        false -> erlang:send_after((Mid + ?UNIXDAYTIME - Now) * 1000, self(), midnight_op)
    end,
    {noreply, State};

%% 午夜12点定时任务
handle_info(midnight_op, State) ->
    self() ! checkout_target,
    self() ! maintain,
    erlang:send_after(?UNIXDAYTIME * 1000, self(), midnight_op),
    {noreply, State};

%% 军团目标
handle_info(checkout_target, State = #guild{members = Mems, target_info = #target_info{is_finish = Fin}}) ->
    NewGuild = #guild{lev = Lev} =
    case Fin =:= 1 of
        true ->
            State;
        false ->
            Exp = guild_aim:get_target_award(State),
            {ok, State1} = guild_common:add_exp(Exp, State),
            State1
    end,
   
    NewTargetList = guild_aim:get_target(Lev),
    ?DEBUG("********* 新军团目标 : ~w", [NewTargetList]),
    TargetIds = [Id || #target{id=Id} <- NewTargetList],
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, reset_trigger, [TargetIds]}); (_GuildMember) -> ok end,
    spawn(lists, foreach, [Fun, Mems]),

    {noreply, NewGuild#guild{target_info = #target_info{is_finish = 0, target_lst = NewTargetList}}};

%% 帮会维护
handle_info(maintain, State = #guild{}) ->
    State1 = maintain_callback(State),
    update_guild_ets(State1),
    erlang:send_after(util:rand(1, 10) * 1000, self(), update_guild_dets),
    {noreply, State1};

%% 更新数据到DETS/ETS
handle_info(update_guild_list, State) ->
    update_guild_list(State),
    {noreply, State};

%% 更新数据到DETS
handle_info(update_guild_dets, State) ->
    update_guild_dets(State),
    {noreply, State};

%% 更新数据到数据库
handle_info(save_db, State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), save_db),
    save_db(State),
    {noreply, State};

handle_info({'EXIT', _Pid, _REASON}, State) ->
    exit(normal),
    {noreply, State};

%% 指定让帮会重启
handle_info({restart, Type, Reason}, State = #guild{name = Name, map = MapPid}) ->
    case is_binary(Reason) of
        true -> ?INFO("帮会 [~s] 收到重启请求 [~s]", [Name, Reason]);
        false -> ?INFO("帮会 [~s] 收到重启请求 [~w]", [Name, Reason])
    end,
    exit(MapPid, normal),
    exit({shutdown, Type}),
    {noreply, State};

%% 容错
handle_info(_Data , State) ->
    ?ERR("错误的handle_info消息格式，匹配失败：[Data:~w]", [_Data]),
    {noreply, State}.

%%-----------------------------------------------------------
%% 系统关闭
%%-----------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%-----------------------------------------------------------
%% 热代码切换
%%-----------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------------
%% 私有函数
%%----------------------------------------------------------
%% 保存数据到数据库
save_db(State = #guild{id = {Gid, Gsrvid}, name = Gname}) ->
    try guild_db:save(State)
    catch
        Error:Info -> ?ERR("保存帮会[~w,~s,~s]数据到数据库发生异常[~w,~w]", [Gid, Gsrvid, Gname, Error, Info])
    end.

%% 更新数据到ETS
update_guild_list(State) ->
    update_guild_ets(State),
    update_guild_dets(State).

update_guild_ets(State = #guild{}) ->
    ets:insert(guild_list, State);
update_guild_ets(_State) ->
    ?ERR("帮会数据无法保存到ets中，帮会数据不是一个 guild record"),
    ok.

update_guild_dets(State = #guild{members = Mems}) ->
    dets:insert(guild_list, State#guild{members = [M#guild_member{pid = 0} || M <- Mems]});
update_guild_dets(_State) ->
    ?ERR("帮会数据无法保存到dets中，帮会数据不是一个 guild record"),
    ok.

%% 处理异步apply的返回值
handle_apply_async_return({ok, NewState}, _Mfa, _State) when is_record(NewState, guild) -> 
    update_guild_list(NewState),
    {noreply, NewState};
handle_apply_async_return({ok}, _Mfa, State) -> 
    {noreply, State};
handle_apply_async_return(Else, {M, F, A}, State) ->
    ?ERR("帮会 [~s] 执行{~w, ~w, ~w}时得到错误的返回值格式:~w", [State#guild.name, M, F, A, Else]),
    {noreply, State}.

%% 处理同步apply的返回值
handle_apply_sync_return({ok, Reply, NewState}, _Mfa, _State) when is_record(NewState, guild) -> 
    update_guild_list(NewState),
    {reply, Reply, NewState};
handle_apply_sync_return({ok, Reply}, _Mfa, State) -> 
    {reply, Reply, State};
handle_apply_sync_return(Else, {M, F, A}, State) ->
    ?ERR("帮会 [~s] 同步执行{~w, ~w, ~w}时得到错误的返回值格式:~w", [State#guild.name, M, F, A, Else]),
    {reply, Else, State}.

%% dismiss_guild(State) - > ok
%% 帮会解散
dismiss_guild(State = #guild{id = {Gid, Gsrvid}}) -> 
    clear_apply(State),
    clear_member(State),                                %% 主动注销时，已无帮会成员
    NewState = State#guild{status = ?guild_dismiss},
    update_guild_dets(NewState),
    ets:delete(guild_list, {Gid, Gsrvid}),              %% 清理 ETS数据，DETS不清理
    guild_mgr:sync_to_db(NewState),                     %% 用lev=0 来标志帮会是销毁状态
    spawn(guild_rss, dismiss, [NewState]),
    ok.

%% 帮会合并后被合并帮会解散
union_dismiss(State = #guild{id = {Gid, Gsrvid}}) -> 
    clear_apply(State),
    NewState = State#guild{members = [], status = ?guild_dismiss},
    update_guild_dets(NewState),
    ets:delete(guild_list, {Gid, Gsrvid}),              %% 清理 ETS数据，DETS不清理
    guild_mgr:sync_to_db(NewState),                     %% 用lev=0 来标志帮会是销毁状态
    spawn(guild_rss, dismiss, [NewState]),
    ok.

%% 清除 申请列表
clear_apply(#guild{id = {Gid, Gsrvid}, name = Gname, apply_list = AL}) ->
    Fun = fun(#apply_list{id = {Rid, Rsrvid}}) -> guild_mgr:mgr_cast({apply_refused, Rid, Rsrvid, Gid, Gsrvid, Gname}) end,
    lists:foreach(Fun, AL).

%% 清除 帮会成员
clear_member(#guild{id = {Gid, Gsrvid}, name = Gname, members = Mems}) ->
    Fun = fun(#guild_member{id = {Rid, Rsrvid}, name = Rname, pid = Pid}) ->
            case is_pid(Pid) of
                true-> 
                    spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"帮会销毁">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                    role:apply(async, Pid, {guild_mem, async_be_fired, []}),
                    guild_mgr:special(online_fire, {Rid, Rsrvid}); 
                false -> 
                    spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"帮会销毁">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                    guild_mgr:special(offline_fire, {Rid, Rsrvid})
            end,
            spawn(mail, send_system, [{Rid, Rsrvid}, {?L(<<"帮会销毁">>), util:fbin(?L(<<"您所在帮会 [~s] 连续 3 次以上帮会资金低于(含) ~w，已自动解散\n(每天凌晨 0:10 左右检测)">>), [Gname, ?guild_dismiss_fund_line])}])
    end,
    guild:guild_chat(Mems, util:fbin(?L(<<"帮会 [~s] 连续 3 次以上帮会资金低于(含) ~w，已自动解散\n(每天凌晨 0:10 左右检测)">>), [Gname, ?guild_dismiss_fund_line])), 
    lists:foreach(Fun, Mems).

%% 午夜凌晨维护执行函数
maintain_callback(State) ->
    case get(maintain_callback) of
        undefined ->
            State;
        MFAs when is_list(MFAs) ->
            execute_maintain_mfa(MFAs, State);
        _MFAs ->
            ?ERR("错误的帮会午夜定时维护回调函数 ~w ", [_MFAs]),
            State
    end.

execute_maintain_mfa([], State) -> State;
execute_maintain_mfa([{F} | MFAs], State) -> 
    {_, NewState} = handle_apply_async_return(catch erlang:apply(F, [State]), {undefined, F, []}, State),
    execute_maintain_mfa(MFAs, NewState);
execute_maintain_mfa([{F, A} | MFAs], State) ->
    {_, NewState} = handle_apply_async_return(catch erlang:apply(F, [State | A]), {undefined, F, A}, State),
    execute_maintain_mfa(MFAs, NewState);
execute_maintain_mfa([{M, F, A} | MFAs], State) ->
    {_, NewState} = handle_apply_async_return(catch erlang:apply(M, F, [State | A]), {M, F, A}, State),
    execute_maintain_mfa(MFAs, NewState);
execute_maintain_mfa([_MFA | MFAs], State) -> 
    ?ERR("错误的帮会定时维护 MFA [~w] 回调函数", [_MFA]),
    execute_maintain_mfa(MFAs, State).

%% 针对不同重启类型初始化
init_start(create, State) ->
    update_guild_list(State);      %% 创建帮会 需要写 dets/ets
init_start({restart, upgrade}, State = #guild{id = _Gid}) ->
    %% catch guild_boss:vip_upgrade(Gid),
    catch upgrade_mail(State),
    update_guild_ets(State);      %% 重启帮会 只需要写 ets
init_start(_Type, State) ->
    update_guild_ets(State),      %% 重启帮会 只需要写 ets
    ok.

upgrade_mail(#guild{members = Mems, gvip = ?guild_vip, name = Name, chief = RoleName}) ->
    Subject = ?L(<<"殷实之帮,奢华体验">>),
    Text = util:fbin(?L(<<"亲爱的玩家，您所在军团 [~s] 已升级为VIP军团">>), [Name]),
    Roles = [{Rid, Rsrvid, Rname} || #guild_member{id = {Rid, Rsrvid}, name = Rname} <- Mems],
    mail_mgr:deliver(Roles, {Subject, Text, [], []}),
    guild:guild_chat(Mems, util:fbin(?L(<<"~s 已将军团升级至VIP军团">>), [RoleName])),
    ok;
upgrade_mail(_) -> ok.
