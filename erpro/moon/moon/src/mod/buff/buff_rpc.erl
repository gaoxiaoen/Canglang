%%----------------------------------------------------
%% BUFF系统远程调用
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(buff_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("buff.hrl").
-include("gain.hrl").
-include("link.hrl").

%% 获取BUFF列表
handle(10400, {}, #role{buff = #rbuff{buff_list = BuffList}}) ->
    SendData = buff:bufflist_to_client(BuffList),
    {reply, {SendData}};

%% 删除BUFF
handle(10401,{Id}, Role) ->
    {ok, NewRole} = buff:del_by_id(Role, Id),
    {reply, {Id}, NewRole};

%% 获取快捷恢复
handle(10403, {}, #role{buff = #rbuff{shortcut_pool = ShortCutPool}}) ->
    SendData = buff:shortcut_to_client(ShortCutPool),
    {reply, {SendData}};

%% 修改快捷恢复
handle(10404, {1, Flag}, Role = #role{link = #link{conn_pid = ConnPid}, id = {Rid, SrvId}, buff = Rbuff = #rbuff{shortcut_pool = ShortCutPool}})
when Flag =:= 1 orelse Flag =:= 0 ->
    case lists:keyfind(hp, 1, ShortCutPool) of
        false ->
            ?ERR("角色[id:~w, SrvId:~s]数据错误,无法发现快捷回复属性", [Rid, SrvId]),
            {reply, {?false, <<"">>}};
        {hp, HpPool, _} ->
            {Atom, Msg} = case Flag of
                1 -> {open, ?L(<<"开启快捷回复气血成功">>)};
                0 -> {close, ?L(<<"关闭快捷回复气血成功">>)} 
            end,
            NewHpPool = {hp, HpPool, Atom},
            NewShortCutPool = lists:keyreplace(hp, 1, ShortCutPool, NewHpPool),
            Msg2 = buff:shortcut_to_client(NewShortCutPool),
            sys_conn:pack_send(ConnPid, 10403, {Msg2}),
            {reply, {?true, Msg}, role_api:push_attr(Role#role{buff = Rbuff#rbuff{shortcut_pool = NewShortCutPool}})}
    end;
handle(10404, {2, Flag}, Role = #role{link = #link{conn_pid = ConnPid}, id = {Rid, SrvId}, buff = Rbuff = #rbuff{shortcut_pool = ShortCutPool}})
when Flag =:= 1 orelse Flag =:= 0 ->
    case lists:keyfind(mp, 1, ShortCutPool) of
        false ->
            ?ERR("角色[id:~w, SrvId:~s]数据错误,无法发现快捷回复属性", [Rid, SrvId]),
            {reply, {?false, <<"">>}};
        {mp, MpPool, _} ->
            {Atom, Msg} = case Flag of
                1 -> {open, ?L(<<"开启快捷回复法力成功">>)};
                0 -> {close, ?L(<<"关闭快捷回复法力成功">>)} 
            end,
            NewMpPool = {mp, MpPool, Atom},
            NewShortCutPool = lists:keyreplace(mp, 1, ShortCutPool, NewMpPool),
            Msg2 = buff:shortcut_to_client(NewShortCutPool),
            sys_conn:pack_send(ConnPid, 10403, {Msg2}),
            {reply, {?true, Msg}, role_api:push_attr(Role#role{buff = Rbuff#rbuff{shortcut_pool = NewShortCutPool}})}
    end;

%% 购买快捷恢复
handle(10405, {_, Num}, #role{}) when Num =< 0 -> {ok};
handle(10405, {1, Num}, Role = #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}, buff = Rbuff = #rbuff{shortcut_pool = ShortCutPool}})
when Num > 0 ->
    case lists:keyfind(hp, 1, ShortCutPool) of
        false ->
            ?ERR("角色[id:~w, SrvId:~s]数据错误,无法发现快捷回复属性", [Rid, SrvId]),
            {reply, {?false, <<"">>}};
        {hp, HpPool, _} when HpPool > 100000000 -> {reply, {?false, ?L(<<"气血储存已经满满的啦，再补就要溢出了">>)}};
        {hp, HpPool, Flag} ->
            Coin = 7000 * Num,
            case role_gain:do([#loss{label = coin_all, val = Coin, msg = ?L(<<"金币不足, 无法购买">>)}], Role) of
                {false, L = #loss{label = coin_all}} -> {reply, {?coin_less, L#loss.msg}};
                {false, L} ->
                    {reply, {?false, L#loss.msg}};
                {ok, NewRole} ->
                    NewHpPool = {hp, HpPool + (Num * 50000), Flag},
                    NewShortCutPool = lists:keyreplace(hp, 1, ShortCutPool, NewHpPool),
                    Msg2 = buff:shortcut_to_client(NewShortCutPool),
                    sys_conn:pack_send(ConnPid, 10403, {Msg2}),
                    log:log(log_coin, {<<"购买自动恢复">>, <<"购买气血恢复">>, Role, NewRole}),
                    {reply, {?true, util:fbin(?L(<<"花费~w金币,增加气血存储量:~w">>), [Coin, Num * 50000])},
                        role_api:push_attr(NewRole#role{buff = Rbuff#rbuff{shortcut_pool = NewShortCutPool}})}
            end
    end;

%%  快捷回复法力
handle(10405, {_, Num}, #role{}) when Num =< 0 -> {ok};
handle(10405, {2, Num}, Role = #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}, buff = Rbuff = #rbuff{shortcut_pool = ShortCutPool}})
when Num > 0 ->
    case lists:keyfind(mp, 1, ShortCutPool) of
        false ->
            ?ERR("角色[id:~w, SrvId:~s]数据错误,无法发现快捷回复属性", [Rid, SrvId]),
            {reply, {?false, <<"">>}};
        {mp, MpPool, _} when MpPool > 100000000 -> {reply, {?false, ?L(<<"法力储存已经满满的啦，再补就要溢出了">>)}};
        {mp, MpPool, Flag} ->
            Coin = 55000 * Num,
            case role_gain:do([#loss{label = coin_all, val = Coin, msg = ?L(<<"金币不足, 无法购买">>)}], Role) of
                {false, L = #loss{label = coin_all}} ->
                    {reply, {?coin_less, L#loss.msg}};
                {false, L} ->
                    {reply, {?false, L#loss.msg}};
                {ok, NewRole} ->
                    NewMpPool = {mp, MpPool + (Num * 50000), Flag},
                    NewShortCutPool = lists:keyreplace(mp, 1, ShortCutPool, NewMpPool),
                    Msg2 = buff:shortcut_to_client(NewShortCutPool),
                    sys_conn:pack_send(ConnPid, 10403, {Msg2}),
                    log:log(log_coin, {<<"购买自动恢复">>, <<"购买法力恢复">>, Role, NewRole}),
                    {reply, {?true, util:fbin(?L(<<"花费~w金币,增加法力存储量:~w">>), [Coin, Num * 50000])},
                        role_api:push_attr(NewRole#role{buff = Rbuff#rbuff{shortcut_pool = NewShortCutPool}})}
            end
    end;

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
