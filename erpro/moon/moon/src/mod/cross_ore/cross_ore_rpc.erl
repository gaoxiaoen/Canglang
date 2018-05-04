%% --------------------------------------------------------------------
%% 跨服仙府抢矿
%% @author wpf (wprehard@qq.com)
%% @end
%% --------------------------------------------------------------------
-module(cross_ore_rpc).
-export([handle/3]).
-include("common.hrl").
-include("ore.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("pos.hrl").

%% 活动状态时间
handle(17800, _, _Role) ->
    {Status, Time} = cross_ore:get_status(),
    {reply, {Status, Time}};

%% 请求战区
handle(17801, _, _Role) ->
    L = cross_ore:get_areas(),
    {reply, {?ORE_AREA_ROLE_MAX, L}};

%% 我的仙府
handle(17802, _, #role{id = RoleId}) ->
    Data = cross_ore:get_my_room(RoleId),
    {reply, Data};

%% 仙府计事
handle(17803, _, #role{id = RoleId}) ->
    Data = cross_ore:get_log(RoleId),
    {reply, Data};

%% 进入战区
handle(17804, {AeraId}, Role) ->
    case role:check_cd(rpc_17804, 2) of
        false -> {ok};
        true ->
            case cross_ore:role_enter(Role, AeraId) of
                {false, Msg} ->
                    {reply, {?false, Msg}};
                ok -> {ok}
            end
    end;

%% 查看其他人仙府
handle(17805, {Id}, _Role) ->
    Data = cross_ore:get_room_info(Id),
    {reply, Data};

%% 退出仙府
handle(17806, {}, Role) ->
    case cross_ore:role_leave(Role) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        ok -> {ok}
    end;

%% 当前分区仙府列表
handle(17807, {}, #role{pos = #pos{map = Map}}) ->
    case center:call(cross_ore_mgr, get_room_list, [Map]) of
        L when is_list(L) ->
            {reply, {L}};
        _ -> {reply, {[]}}
    end;

%% 仙府打劫
handle(17810, {Id}, Role) ->
    case cross_ore:rob_ore(Role, Id) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        ok -> {ok}
    end;

%% 争夺仙府
handle(17811, {Id}, Role) ->
    case cross_ore:capture_ore(Role, Id) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        ok -> {ok}
    end;

%% 驯养神兽
handle(17815, {AnimalId}, Role = #role{id = RoleId, pid = RolePid}) ->
    LL = [#loss{label = coin_all, val = 100000, msg = ?L(<<"金币不足">>)}],
    role:send_buff_begin(),
    case role_gain:do(LL, Role) of
        {false, #loss{err_code = ErrCode, msg = Msg}} ->
            role:send_buff_flush(),
            {reply, {ErrCode, Msg}};
        {ok, NewRole} ->
            case center:call(cross_ore_mgr, call_animal, [RoleId, AnimalId]) of
                {false, Msg} ->
                    role:send_buff_clean(),
                    {reply, {?false, Msg}};
                ok ->
                    log:log(log_coin, {<<"仙府驯养神兽">>, <<>>, Role, NewRole}),
                    role:pack_send(RolePid, 17802, cross_ore:get_my_room(RoleId)),
                    role:send_buff_flush(),
                    {reply, {?true, ?L(<<"驯养成功">>)}, NewRole};
                _O ->
                    ?DEBUG("_O:~w", [_O]),
                    role:send_buff_clean(),
                    {reply, {?false, ?L(<<"仙府通道不稳定，请稍后再试">>)}}
            end
    end;

%% 升级神兽
handle(17816, {AnimalId}, Role = #role{id = RoleId, pid = RolePid}) when AnimalId =:= 1 orelse AnimalId =:= 2 ->
    case center:call(cross_ore_mgr, preview_upgrade_animal, [RoleId, AnimalId]) of
        {false, #loss{err_code = ErrCode, msg = Msg}} ->
            {reply, {ErrCode, Msg}};
        {ok, NewLev} when NewLev > 10 ->
            {reply, {?false, ?L(<<"您的仙府神兽已是最高级">>)}};
        {ok, NewLev} ->
            LL = [#loss{label = gold, val = lev_to_upgrad_gold(NewLev), msg = ?L(<<"晶钻不足">>)}],
            role:send_buff_begin(),
            case role_gain:do(LL, Role) of
                {false, #loss{err_code = ErrCode, msg = Msg}} ->
                    role:send_buff_flush(),
                    {reply, {ErrCode, Msg}};
                {ok, NewRole} ->
                    case center:call(cross_ore_mgr, upgrade_animal, [RoleId, AnimalId]) of
                        {false, Msg} ->
                            role:send_buff_clean(),
                            {reply, {?false, Msg}};
                        ok ->
                            role:pack_send(RolePid, 17802, cross_ore:get_my_room(RoleId)),
                            role:send_buff_flush(),
                            {reply, {?true, ?L(<<"升级成功">>)}, NewRole};
                        _O ->
                            role:send_buff_clean(),
                            {reply, {?false, ?L(<<"仙府通道不稳定，请稍后再试">>)}}
                    end
            end;
        _O ->
            {reply, {?false, ?L(<<"仙府通道不稳定，请稍后再试">>)}}
    end;

%% 收割资源
handle(17817, {}, #role{id = RoleId}) ->
    case center:call(cross_ore_mgr, reap, [RoleId]) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        ok ->
            {reply, {?true, ?L(<<"收获的资源即将通过邮件发送，请耐心等待接收">>)}};
        _ ->
            {reply, {?true, ?L(<<"仙府通道不稳定，请稍后操作">>)}}
    end;

%% 放弃仙府
handle(17818, {}, #role{id = RoleId, pid = Pid}) ->
    case center:call(cross_ore_mgr, abandon_room, [RoleId]) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        ok ->
            role:pack_send(Pid, 17802, {0, <<>>, 0, [], [], 0, []}),
            {reply, {?true, ?L(<<"您已放弃仙府，还未收获的资源即将通过邮件发送，请耐心等待接收">>)}}
    end;

%% 容错
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% --------------------------------------------
%% 内部函数
%% --------------------------------------------

%% 升级神兽的yb数
lev_to_upgrad_gold(2) -> pay:price(?MODULE, lev_to_upgrad_gold, 2);
lev_to_upgrad_gold(3) -> pay:price(?MODULE, lev_to_upgrad_gold, 3);
lev_to_upgrad_gold(4) -> pay:price(?MODULE, lev_to_upgrad_gold, 4);
lev_to_upgrad_gold(5) -> pay:price(?MODULE, lev_to_upgrad_gold, 5);
lev_to_upgrad_gold(6) -> pay:price(?MODULE, lev_to_upgrad_gold, 6);
lev_to_upgrad_gold(7) -> pay:price(?MODULE, lev_to_upgrad_gold, 7);
lev_to_upgrad_gold(8) -> pay:price(?MODULE, lev_to_upgrad_gold, 8);
lev_to_upgrad_gold(9) -> pay:price(?MODULE, lev_to_upgrad_gold, 9);
lev_to_upgrad_gold(10) -> pay:price(?MODULE, lev_to_upgrad_gold, 10);
lev_to_upgrad_gold(_) -> pay:price(?MODULE, lev_to_upgrad_gold, 10).
