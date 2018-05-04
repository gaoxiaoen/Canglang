%% **********************
%% 许愿池rpc处理
%% @author wpf (wprehard@qq.com)
%% **********************

-module(wish_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("beer.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("rank.hrl").
-include("unlock_lev.hrl").
%%
%%
% -define(MIN_LEV, 20).

%% 获取当前铜币数
%% 没有屏蔽非法访问
handle(14400, {}, _Role) ->
    {Index, Count} = wish:get_count(),
    %% ?DEBUG("上线获取币数：~w", [{Index, Count}]),
    {reply, {Index, Count}};

%% 获取当前许愿池活动状态
handle(14401, {}, _Role) ->
    {Ver, Now, Next, End} = wish:get_state(),
    %% ?DEBUG("上线获取状态：~w", [{Now, Next, End}]),
    {reply, {Ver, Now, Next, End}};

%% 请求个人投币数
handle(14402, {}, #role{id = Rid}) ->
    Num = wish:get_role_num(Rid),
    {reply, {Num}};

%% 投币
handle(14405, {0}, _Role) ->
    {ok};
handle(14405, {Num}, Role) when Num > 0 ->
    V = 2000 * Num,
    G = [#gain{label = exp, val = V}],
    L = [#loss{label = item, val = [33028, 0, Num], msg = ?L(<<"许愿币不够">>)}],
    role:send_buff_begin(),
    case role_gain:do(L, Role) of
        {false, #loss{msg = Msg}} ->
            role:send_buff_clean(),
            {reply, {?false, Msg}};
        {ok, NewRole1} ->
            case wish:add_coin(Num, NewRole1) of
                {false, Msg} ->
                    role:send_buff_clean(),
                    {reply, {?false, Msg}};
                {ok} ->
                    case role_gain:do(G, NewRole1) of
                        {ok, NewRole2} ->
                            role:send_buff_flush(),
                            notice:inform(util:fbin(?L(<<"许愿投币 获得\n{str,经验,#00FF00} ~w">>), [V])),
                            NewRole = role_listener:special_event(NewRole2, {30010, 1}),
                            {reply, {?true, util:fbin(?L(<<"成功将~w个许愿币抛入池中">>), [Num])}, NewRole};
                        _ ->
                            role:send_buff_clean(),
                            {ok}
                    end
            end
    end;

%% 使用幸运仙泉
handle(14406, {}, Role) ->
    L = [#loss{label = item, val = [33029, 0, 1], msg = ?L(<<"背包没有幸运泉水">>)}],
    role:send_buff_begin(),
    case role_gain:do(L, Role) of
        {false, #loss{msg = Msg}} ->
            role:send_buff_clean(),
            {reply, {?false, Msg}};
        {ok, NewRole1} ->
            case wish:lucky(NewRole1) of
                {false, Msg} ->
                    role:send_buff_clean(),
                    {reply, {?false, Msg}};
                {ok, BuffBase} ->
                    case buff:add(NewRole1, BuffBase) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {?false, Reason}};
                        {ok, NewRole} ->
                            role:send_buff_flush(),
                            {reply, {?true, ?L(<<"成功使用幸运仙泉，享受幸运泉水带来的奖励吧">>)}, NewRole}
                    end
            end
    end;

handle(14407, {_}, #role{event = Event}) when Event =/= ?event_no ->
    {reply, {?false, ?L(<<"活动中，无法参加许愿活动">>)}};
handle(14407, {Type}, Role) when Type =:= 1 orelse Type =:= 2 ->
    case wish:trans(Type, Role) of
        {ok, NewRole} -> {ok, NewRole};
        {false, M} -> {reply, {?false, M}};
        _E ->
            ?ERR("许愿传送出错:~w", [_E]),
            {ok}
    end;

%% 燃放七夕烟花
%% 13=我喜欢你，14=求包养，15=七夕快乐，16=今夜私奔，17=永结同心
%% 19-我要脱光 20-光棍万岁
handle(14408, {Type}, Role)
when Type =:= 19 orelse Type =:= 20 orelse Type =:= 13 orelse Type =:= 14 orelse Type =:= 16 orelse (Type >= 22 andalso Type =< 30) ->
    V = 10000,
    G = [#gain{label = exp, val = V}],
    L = [#loss{label = item, val = [33197, 0, 1], msg = ?L(<<"您没有烟花">>)}],
    role:send_buff_begin(),
    case role_gain:do(L, Role) of
        {false, #loss{msg = Msg}} ->
            role:send_buff_clean(),
            {reply, {?false, Msg}};
        {ok, NewRole1} ->
            case fireworks:light_fire(Type, NewRole1) of
                {false, Msg} ->
                    role:send_buff_clean(),
                    {reply, {?false, Msg}};
                ok ->
                    log:log(log_item_del_loss, {<<"燃放烟花">>, NewRole1}),
                    case role_gain:do(G, NewRole1) of
                        {ok, NewRole2} ->
                            role:send_buff_flush(),
                            notice:inform(util:fbin(?L(<<"燃放烟花 获得\n{str,经验,#00FF00} ~w">>), [V])),
                            {reply, {?true, <<>>}, NewRole2};
                        _ ->
                            role:send_buff_clean(),
                            {ok}
                    end
            end
    end;

%% 通知烟花活动状态; 上线需要主动请求
handle(14409, {}, _Role) ->
    {_Ver, State, Next, Time} = fireworks:get_state(),
    {reply, {State, Next, Time}};

%% 烟花活动传送
handle(14410, {_}, #role{event = Event}) when Event =/= ?event_no ->
    {reply, {?false, ?L(<<"活动中，无法参加烟花晚会活动">>)}};
handle(14410, {Type}, Role) when Type =:= 1 orelse Type =:= 2 ->
    case fireworks:trans(Type, Role) of
        {ok, NewRole} -> {ok, NewRole};
        {false, Reason} -> {reply, {?false, Reason}};
        _E ->
            ?ERR("烟花活动传送出错:~w", [_E]),
            {ok}
    end;

%% 获取燃放烟花总数
handle(14411, {}, _Role) ->
    {Count} = fireworks:get_count(),
    {reply, {Count}};

%% -----------------------------------------------------------
%% 请求许愿墙
handle(14420, {}, Role) ->
    case role:check_cd(wish_rpc_14420, 5) of
        true ->
            Data = wish_wall:get_wall(Role),
            {reply, Data};
        false -> {ok}
    end;

%% 刷新许愿墙
handle(14421, {}, _Role) ->
    case role:check_cd(wish_rpc_14421, 5) of
        true ->
            Data = wish_wall:get_wall_rand(),
            {reply, Data};
        false -> {ok}
    end;

%% 许愿、表白
handle(14422, {_, _, ToSrvId, ToName, _, _Cont}, _Role)
when byte_size(ToSrvId) > 60 orelse byte_size(ToName) > 60 ->
    %% 过滤非法的角色ID
    {ok};
handle(14422, {Type, ToRid, ToSrvId, ToName, NickName, Cont}, Role = #role{id = RoleId, name = Name}) ->
    %% friend:get_friend(cache, {ToRid, ToSrvId})
    GL = [
        #loss{label = item, val = [33155, 1, 1], msg = ?L(<<"您需要一个许愿瓶才能许愿">>)}
        ,#gain{label = coin_bind, val = 20000}
        ,#gain{label = exp, val = 20000}
    ],
    role:send_buff_begin(),
    case role_gain:do(GL, Role) of
        {false, #loss{msg = Msg}} ->
            role:send_buff_clean(),
            {reply, {?false, Type, Msg}};
        {ok, NewRole} ->
            case wish_wall:add_wish(Type, RoleId, Name, {ToRid, ToSrvId}, ToName, NickName, Cont) of
                ok ->
                    role:send_buff_flush(),
                    notice:inform(?L(<<"许愿成功\n获得 20000绑定金币 20000经验">>)),
                    pack_send(Type, RoleId, Name, {ToRid, ToSrvId}, ToName, NickName, Cont),
                    {reply, {?true, Type, ?L(<<"许愿成功">>)}, NewRole};
                {false, Msg} ->
                    role:send_buff_clean(),
                    {reply, {?false, Type, Msg}};
                _ ->
                    role:send_buff_clean(),
                    {reply, {?false, Type, ?L(<<"网络不稳定，请稍后再试">>)}}
            end
    end;

% 参加活动，选择场景，随机阵营，后台管理进程->统计场景与阵营
% Reply = {等待时间，第几题}

handle(14430, {}, Role = #role{lev = Lev}) when Lev < ?beer_unlock_lev ->
    notice:alert(error, Role, ?MSGID(<<"等级不足,不能参加活动">>)),
    {ok};

handle(14430, {}, Role = #role{event = Event}) when Event =/= ?event_no ->
    notice:alert(error, Role, ?MSGID(<<"当前状态不能参加活动！">>)),
    {ok};

handle(14430, {}, Role = #role{id = Id = {_Rid, _}, link = #link{conn_pid = ConnPid}, beer_guide = BeerGuide}) ->
    ?DEBUG("申请参加活动者id:~p~n", [_Rid]),
    #beer_role_info{beer_times = Times} = beer_mgr:get_beer_info(Id),
    ?DEBUG("申请参加活动者次数:~p~n~n", [Times]),
    case Times > 0 of 
        true ->
            {Status, _, _, _, _, _, _} = beer:get_beer_info(),
            case Status of 
                finish ->
                    notice:alert(error, ConnPid, ?MSGID(<<"活动已结束!">>)),
                    {ok};
                _ ->
                    %% 新手引导送10晶钻
                    NR = 
                        case BeerGuide of
                            S when S == [] orelse S == [0] ->
                                {ok, NRole} = role_gain:do([#gain{label = gold, val = 10}], Role),
                                NRole#role{beer_guide = [1]};
                            _ -> Role
                        end, 
                    beer:enter_beer(NR),
                    {ok, NR}
            end;
        false -> 
            notice:alert(error, ConnPid, ?MSGID(<<"今日可参加次数已用完!">>)),
            {ok}
    end;

% 每答一题，客户端发送题目id答题结果，服务端判断是答题时间，统计答题的结果计算奖励，客户端自己飘奖励的结果
% Reply = {是否答题结束}
handle(14433, {_Nth, Result}, Role = #role{id = Id, link = #link{conn_pid = ConnPid}}) ->
    ?DEBUG("当前第~p道题~n", [_Nth]),
    {Status, _, AllTitle, NextTitle, _, _, _} = beer:get_beer_info(),
    case Status of 
        running ->
            {NRole, Coin, Exp} = deal_result_award(Result, Role),
            IfFinish = 
                case  NextTitle >= AllTitle of 
                    true -> 1;
                    _ -> 0
                end,
            beer_mgr:update_role_reward(Id, {Result, Coin, Exp}),
            {reply, {IfFinish}, NRole};
        _ -> 
            ?DEBUG("当前活动的状态为:~p~n", [Status]),
            notice:alert(error, ConnPid, ?MSGID(<<"活动已结束!">>)),
            {ok}
    end;

%% 退出场景
handle(14434, {}, Role = #role{event = Event}) when Event =/= ?event_beer ->
    notice:alert(error, Role, ?MSGID(<<"当前未参加酒桶节活动！">>)),
    {ok};
handle(14434, {}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 14434, {}),
    NRole = leave(Role),
    beer:leave(Role),
    {ok, NRole};

%%查询编年史题目的答案
handle(14435, {CeleId}, _Role) ->
    NowList = rank:list(?rank_celebrity),
    case lists:keyfind(CeleId, #rank_global_celebrity.id, NowList) of
        false -> 
            {reply, {<<"">>}};
        #rank_global_celebrity{r_list = Rlist} -> 
            case erlang:length(Rlist) > 0 of 
                true -> 
                    [#rank_celebrity_role{name = Name}|_] = Rlist,
                    {reply, {Name}};
                false -> 
                    {reply, {<<"">>}}
            end
    end;

% 丢鲜花1，丢鸡蛋2，丢烟花3
handle(14437, {Kind, _X1, _Y1, _X2}, Role = #role{id = Id = {Rid, _}}) when Kind =:= 1 orelse Kind =:= 2 orelse Kind =:= 3 ->
    case is_frequency(Kind) of
        false ->
            BeerRole = #beer_role_info{firework_times = Firework_Times} = get_role_beer_info(Id),
            case Kind =:= 3 andalso Firework_Times =< 0 of 
                true -> 
                    notice:alert(error, Role, ?MSGID(<<"今日丢烟花次数已用完啦">>)),
                    {reply, {Kind, ?false}};
                false ->
                    CheckGold = 
                        case Kind =:= 3 of
                            false -> {ok, Role};
                            true -> 
                                case role_gain:do([#loss{label = gold, val = 10, msg = ?MSGID(<<"晶钻不足！">>)}], Role) of 
                                    {false, #loss{msg = Msg}} -> 
                                        notice:alert(error, Role, Msg),
                                        error;
                                    {false, Rea} ->
                                        notice:alert(error, Role, Rea),
                                        error;
                                    {ok, NR} -> {ok, NR}
                                end
                        end,
                    case CheckGold of 
                        {ok, NR1} ->
                            IfAward = check_if_award(Kind, BeerRole),        
                            case beer:throw(Kind, IfAward, NR1, {Rid, Kind, _X1, _Y1, _X2}) of
                                NRole = #role{} -> 
                                    put({last_throw, Kind}, util:unixtime()),
                                    update_beer_role_info(sub, Kind, BeerRole),

                                    {reply, {Kind, ?true}, NRole};
                                _ -> 
                                   {reply, {Kind, ?false}}
                            end;
                        _ ->  {reply, {Kind, ?false}}
                    end
            end;
        Time -> 
            case Kind of 
                1 -> 
                    notice:alert(error, Role, util:fbin(?L(<<"需要等待~p秒之后才可以抛鲜花">>), [Time]));
                2 -> 
                    notice:alert(error, Role, util:fbin(?L(<<"需要等待~p秒之后才可以丢鸡蛋">>), [Time]));
                3 ->
                    notice:alert(error, Role, util:fbin(?L(<<"需要等待~p秒之后才可以丢烟花">>), [Time]));
                _ -> ok
            end,
            {reply, {Kind, ?false}}
    end;

handle(14439, {}, Role) ->
    Reply = get_beer_time_info(Role),
    {reply, {Reply}};

handle(14440, {}, Role) ->
    {ok, Role#role{beer_guide = [2]}};

handle(_Cmd, _, _) ->
    {error, unknow_command}.

%% ---------------------------------------------------------
%% private function
%% ---------------------------------------------------------
get_beer_time_info(_Role = #role{id = _Id}) -> 
    % #beer_role_info{beer_times = BeerTimes} = beer_mgr:get_beer_info(Id),
    % Avail = 
    %     case BeerTimes > 0 of 
    %         true -> 1;
    %         _ -> 0
    %     end,
    % {RAvail, Sec} = 
    % case Avail of 
    %     1 -> 
            {_, NextTime, _, _, _, _, _} = beer:get_beer_info(),
            Now = util:unixtime(),
            Duration = NextTime - Now,
            {RAvail, Sec} = 
                case  Duration > 0 of
                    true -> 
                        {1, Duration};
                    _ -> 
                        {1, 0}
                end,
    %     0 -> {0, 0} %% 0表示进入次数为0 
    % end,
    [{RAvail, 1, Sec}].



update_beer_role_info(sub, Kind, BeerRole = #beer_role_info{egg_times = Egg_Times, flower_times = Flower_Times, firework_times = Firework_Times}) ->
    NBeerRole = 
    case Kind of 
        1 -> if Flower_Times >= 1 -> BeerRole#beer_role_info{flower_times = Flower_Times - 1}; true ->BeerRole end;
        2 -> if Egg_Times >= 1 -> BeerRole#beer_role_info{egg_times = Egg_Times - 1}; true -> BeerRole end;
        3 -> if Firework_Times >= 1 -> BeerRole#beer_role_info{firework_times = Firework_Times - 1}; true -> BeerRole end;
        _ -> BeerRole
    end,
    beer_mgr:update_beer_info(NBeerRole),
    put(beer_role_info, NBeerRole),
    ok;

update_beer_role_info(add, Kind, BeerRole = #beer_role_info{egg_times = Egg_Times, flower_times = Flower_Times}) ->
    NBeerRole = 
    case Kind of 
        1 ->BeerRole#beer_role_info{flower_times = Flower_Times + 1};
        2 ->BeerRole#beer_role_info{egg_times = Egg_Times + 1};
        % _ ->BeerRole#beer_role_info{firework_times = Firework_Times + 1};
        _ -> BeerRole
    end,
    beer_mgr:update_beer_info(NBeerRole),
    put(beer_role_info, NBeerRole),
    ok.

    

check_if_award(Kind, #beer_role_info{egg_times = Egg_Times, flower_times = Flower_Times}) ->
    case Kind of 
        1-> if Flower_Times > 0 -> 1; true -> 0 end;
        2-> if Egg_Times > 0 -> 1; true -> 0 end;
        _ -> 0
    end.


is_frequency(Kind) -> 
    Now = util:unixtime(),
    case get({last_throw, Kind}) of
        undefined -> 
            false;
        Last ->  
            case Now - Last >= 5 of 
                true -> 
                    false;
                false -> 5 - (Now - Last) 
            end
    end.

deal_result_award(Result, Role = #role{id = Id, lev = Lev}) ->
    case beer_data:get_award(Lev) of
        #beer_award{award1 = Award1, award2 = Award2} ->
            BeerRole = get_role_beer_info(Id),
            Award = 
                case Result of 
                    1 ->
                        update_beer_role_info(add, 1, BeerRole), 
                        Award1;
                    0 -> 
                        update_beer_role_info(add, 2, BeerRole),
                        Award2
                end,
            {ok, NRole} = role_gain:do(Award, Role),
            {Coin, Exp} = get_coin_exp(Award),
            {NRole, Coin, Exp};
        _ ->
            {Role, 0, 0}
    end.

get_coin_exp([]) -> {0, 0};
get_coin_exp(Award) when is_list(Award) andalso erlang:length(Award) > 0 -> 
    Coin = 
        case lists:keyfind(coin, #gain.label, Award) of 
            #gain{val = Val1} -> Val1;
            _ -> 0
        end,
    Exp = 
        case lists:keyfind(exp, #gain.label, Award) of 
            #gain{val = Val2} -> Val2;
            _ -> 0
        end,
    {Coin, Exp};
get_coin_exp(_) -> {0, 0}.

get_role_beer_info(Id = {Rid, _}) ->
    case get(beer_role_info) of 
        Something = #beer_role_info{} -> Something;
        _ -> 
            BeerInfo = beer_mgr:get_beer_info(Id), % #beer_role_info{]}
            BeerInfo#beer_role_info{rid = Rid}
    end.

pack_send(1, _, _Name, _, _ToName, _NickName, _Cont) -> ok;
pack_send(Type, {Rid, SrvId}, Name, {ToRid, ToSrvId}, _ToName, NickName, Cont) ->
    case role_api:c_lookup(by_id, {ToRid, ToSrvId}, #role.pid) of
        {ok, _, Pid} ->
            center:cast(role, pack_send, [Pid, 14423, {Type, Rid, SrvId, Name, NickName, Cont}]);
        _ -> ignore
    end.

%% -> #role{}
leave_map(Role = #role{pos = #pos{last = {LastMapId, LastX, LastY}}}) ->
    case map:role_enter(LastMapId, LastX, LastY, Role) of
        {ok, NewR = #role{}} ->
            NewR#role{event = ?event_no};
        {false, 'bad_pos'} -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败:无效的坐标">>)),
            Role;
        {false, 'bad_map' } -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败:不存在的地图">>)),
            Role;
        {false, _Reason } -> 
            notice:alert(error, Role, ?MSGID(<<"进入地图失败">>)),
            Role
    end.

%% -> #role{}
leave(Role) ->
    leave_map(Role).
