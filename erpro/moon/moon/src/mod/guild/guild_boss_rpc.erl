%%----------------------------------------------------
%% @doc 帮会boss协议处理
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_boss_rpc).
-export([handle/3
    ,push/3]).

-include("common.hrl").
-include("role.hrl").
-include("guild_boss.hrl").
%%

%% 获取boss列表
handle(17500, {}, Role) ->
    Reply = guild_boss:get_boss_list(Role),
    {reply, Reply};

%% 喂养指定boss
handle(17501, {Type}, Role) ->
    case guild_boss:feed(Role, Type) of
        {ok, NewRole, Addition} -> 
            {reply, {?true, util:fbin(?L(<<"供养神兽成功,神兽增加~w点成长">>), [Addition])}, NewRole};
        max_lev ->
            {reply, {?false, ?L(<<"该神兽已经是最高级别了，赶快击杀它来获取奖励吧">>)}};
        feed_today ->
            {reply, {?false, ?L(<<"你今天已经供养过该神兽了，请明天再供它">>)}};
        max_feed ->
            {reply, {?false, ?L(<<"该神兽今天已经供养超过100次了，明天再供它吧">>)}};
        called ->
            {reply, {?false, ?L(<<"神兽已经召唤出来，不能再供养，请快去击杀吧">>)}};
        no_devote ->
            {reply, {?false, ?L(<<"需要帮贡达到500以上的帮会精英才能供养帮会神兽">>)}};
        no_boss ->
            {reply, {?false, ?L(<<"没有指定类型的神兽">>)}};
        no_adopted ->
            {reply, {?false, ?L(<<"没有领养过神兽">>)}};
        _Else ->
            {reply, {?false, ?L(<<"供养神兽失败">>)}}
    end;

%% 击杀指定boss
handle(17502, {Type}, Role) ->
    Reply = case guild_boss:call_out(Role, Type) of
        ok -> {?true, ?L(<<"帮会神兽已经成功召唤出来，赶快去帮会领地击杀吧">>)};
        no_permission -> {?false, ?L(<<"只有帮主或长老才可以选择挑战神兽的时机">>)};
        lev_lower -> {?false, ?L(<<"当前神兽未成长到少年期，尚未长大哦。你忍心欺负它么？">>)};
        called -> {?false, ?L(<<"帮会神兽已经在帮会领地了，赶快去击杀吧">>)};
        no_boss -> {?false, ?L(<<"没有指定类型的神兽">>)};
        no_guild -> {?false, ?L(<<"你还加入任何帮派，赶快加入一个吧">>)};
        no_adopted -> {?false, ?L(<<"没有领养过神兽">>)};
        _ -> {?false, ?L(<<"帮会神兽已召唤失败">>)}
    end,
    {reply, Reply};

%% 领养指定boss
handle(17503, {Type}, Role = #role{pid = Pid}) ->
    Reply = case guild_boss:adopt(Role, Type) of
        ok -> 
            PushData = guild_boss:get_boss_list(Role),
            role:pack_send(Pid, 17500, PushData),
            {?true, ?L(<<"领养神兽成功">>)};
        lev_lower -> {?false, ?L(<<"您的帮会等级不够，不能领养该神兽">>)};
        no_permission -> {?false, ?L(<<"只有帮主或长老才能领养神兽">>)};
        no_fund -> {?false, ?L(<<"帮会资金不足，不能领养">>)};
        type_exist -> {?false, ?L(<<"你们帮会已经有一只同类的神兽了">>)};
        _R -> {?false, ?L(<<"领养神兽失败">>)}
    end,
    {reply, Reply};

%% 传到boss身边
handle(17506, {}, Role) ->
    Reply = case guild_boss:to_boss_side(Role) of
        ok -> {?true, <<>>};
        no_called -> {?false, ?L(<<"没有已召唤出来的神兽">>)};
        no_adopted -> {?false, ?L(<<"没有领养过神兽">>)};
        wrong_event -> {?false, ?L(<<"当前状态不能传送">>)};
        in_team -> {?false, ?L(<<"在队伍中不能传送到帮会领地">>)};
        no_guild -> {?false, ?L(<<"你还加入任何帮派，赶快加入一个吧">>)};
        _ -> {?false, ?L(<<"传送失败">>)}
    end,
    {reply, Reply};

handle(_Cmd, _Request, _Role = #role{name = _Name}) ->
    ?DEBUG("无效请求 name = ~s, cmd = ~w, request = ~w", [_Name, _Cmd, _Request]),
    {ok}.

%% 推送用接口
push(Pid, 17504, Data) ->
    role:pack_send(Pid, 17504, Data);
push(_, _Cmd, _Para) ->
    ?DEBUG("无效请求 cmd = ~w, para = ~w", [_Cmd, _Para]),
    {ok}.
