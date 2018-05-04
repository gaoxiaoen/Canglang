%%----------------------------------------------------
%% 副本相关远程调用
%%
%% @author yeahoo2000@gmail.com
%% @author mobin
%% @end
%%----------------------------------------------------
-module(dungeon_rpc).
-export([handle/3,
        push/3
    ]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("assets.hrl").
-include("dungeon.hrl").
-include("tree.hrl").
-include("pos.hrl").
-include("condition.hrl").
-include("gain.hrl").
-include("attr.hrl").
-include("misc.hrl").
-include("timing.hrl").
-include("expedition.hrl").
-include("arena_career.hrl").

-define(debug_log(P), ?DEBUG("type=~w, value=~w~n", P)).

-define(blue_award_id, 104007).
-define(purple_award_id, 104008).
-define(dungeon_clear_max, 30).
%% 进入副本
handle(13500, {_}, Role = #role{event = Event}) when Event =/= ?event_no ->
    notice:alert(error, Role, ?MSGID(<<"你当前状态下不能进入副本">>)),
    {ok};

handle(13500, {DungeonId}, Role = #role{}) ->
    case dungeon_data:get(DungeonId) of
        {false, Reason} -> 
            notice:alert(error, Role, Reason),
            {reply, {0, []}};
        DungeonBase = #dungeon_base{cond_enter = CondEnter, type = Type} ->
            case dungeon_type:role_enter(Role, DungeonBase, 1) of
                {ok, Role2} ->
                    Conds = [Cond || Cond <- CondEnter, is_record(Cond, gain) orelse is_record(Cond, loss)],
                    Role3 = case role_gain:do(Conds, Role2) of
                        {ok, _Role2} ->
                            _Role2;
                        _ ->
                            Role2
                    end,
                    Params = case Type of
                        ?dungeon_type_time ->
                            [0];
                        _ ->
                            []
                    end,
                    {reply, {DungeonId, Params}, Role3};
                {false, Reason} ->
                    notice:alert(error, Role, Reason),
                    {reply, {0, []}};
                false ->
                    {reply, {0, []}}
            end
    end;

%% 请求副本选择地图和副本列表
handle(13501, {}, #role{dungeon = RoleDungeons, dungeon_map = DungeonMap}) ->
    Msg = dungeon_api:pack_proto_13501(DungeonMap, RoleDungeons),
    {reply, Msg};

%% 购买副本次数
handle(13503, {DungeonId}, Role = #role{dungeon = RoleDungeons}) ->
    case dungeon_type:get_paid_price(DungeonId, Role) of
        false ->
            notice:alert(error, Role, ?MSGID(<<"已达到当天重置上限">>)),
            {ok};
        Price ->
            RoleDungeon = lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons),
            buy_dungeon_count(Price, Role, RoleDungeon)
    end;

%%领取蓝礼包
handle(13507, {DungeonMapId}, Role = #role{id = Rid, dungeon_map = DungeonMap}) ->
    case lists:keyfind(DungeonMapId, 1, DungeonMap) of
        {DungeonMapId, Blue, Purple, ?false, PurpleIsTaken, IsOpened} ->
            case dungeon_data:map(DungeonMapId) of
                #dungeon_map_base{total_blue = Blue, blue_rewards = Rewards} ->
                    DungeonMap2 = lists:keyreplace(DungeonMapId, 1, DungeonMap, 
                        {DungeonMapId, Blue, Purple, ?true, PurpleIsTaken, IsOpened}),
                    Role2 = Role#role{dungeon_map = DungeonMap2},
                    case role_gain:do(Rewards, Role2) of
                        {ok, Role3} ->
                            {reply, {?true}, Role3};
                        _ ->
                            award:send(Rid, ?blue_award_id, Rewards),
                            {reply, {?false}, Role2}
                    end;
                _ ->
                    notice:alert(error, Role, ?MSGID(<<"不符合礼包的领取条件">>)),
                    {ok}
            end;
        _ ->
            notice:alert(error, Role, ?MSGID(<<"不符合礼包的领取条件">>)),
            {ok}
    end;

%%领取紫礼包
handle(13508, {DungeonMapId}, Role = #role{id = Rid, dungeon_map = DungeonMap}) ->
    case lists:keyfind(DungeonMapId, 1, DungeonMap) of
        {DungeonMapId, Blue, Purple, BlueIsTaken, ?false, IsOpened} ->
            case dungeon_data:map(DungeonMapId) of
                #dungeon_map_base{total_purple = Purple, purple_rewards = Rewards} ->
                    DungeonMap2 = lists:keyreplace(DungeonMapId, 1, DungeonMap, 
                        {DungeonMapId, Blue, Purple, BlueIsTaken, ?true, IsOpened}),
                    Role2 = Role#role{dungeon_map = DungeonMap2},
                    case role_gain:do(Rewards, Role2) of
                        {ok, Role3} ->
                            {reply, {?true}, Role3};
                        _ ->
                            award:send(Rid, ?purple_award_id, Rewards),
                            {reply, {?false}, Role2}
                    end;
                _ ->
                    notice:alert(error, Role, ?MSGID(<<"不符合礼包的领取条件">>)),
                    {ok}
            end;
        _ ->
            notice:alert(error, Role, ?MSGID(<<"不符合礼包的领取条件">>)),
            {ok}
    end;

%% 战斗中不能离开副本
handle(13510, {}, _Role = #role{event = ?event_dungeon, combat_pid = Cpid}) when is_pid(Cpid) ->
    {ok, _Role};

%% 离开副本
handle(13510, {}, Role = #role{event = ?event_dungeon, event_pid = DungeonPid}) ->
    case dungeon:get_info(DungeonPid) of
        {ok, Dungeon = #dungeon{}} ->
            leave_dungeon(Role, Dungeon);
        _ ->
            {ok}
    end;

handle(13510, {}, _Role) ->
    ?DEBUG("当不在副本中时收到离开副本指令: ~w~n", [_Role#role.event]),
    {ok};


%% 请求扫荡副本
% handle(13511, {DungeonId, Count}, Role = #role{}) ->
%     case dungeon_auto:auto(DungeonId, Count, Role) of
%         {false, ReasonId} ->
%             notice:alert(error, Role, ReasonId),
%             {ok};
%         {ok, Reply, Role2} ->
%             {reply, Reply, Role2}
%     end;


%% 请求翻牌，若没有则退出副本
handle(13515, {}, Role = #role{event = ?event_dungeon, event_pid = DungeonPid}) ->
    case dungeon:get_info(DungeonPid) of
        {ok, Dungeon = #dungeon{extra = Extra}} ->
            ?debug_log([extra, Extra]),
            case lists:keyfind(cards_id, 1, Extra) of
                {cards_id, CardsId} ->
                    dungeon:post_event(DungeonPid, {dungeon_cards, CardsId}),
                    {reply, {}};
                false ->
                    leave_dungeon(Role, Dungeon)
            end;
        _ ->
            {ok}
    end;

handle(13516, {Pos}, Role = #role{id = Rid, link = #link{conn_pid = ConnPid}, event = ?event_dungeon, event_pid = DungeonPid}) ->
    dungeon:post_event(DungeonPid, {choose_card, Rid, ConnPid, Pos}),
    {ok, Role};
handle(13516, {_Pos}, _Role) ->
    ?DEBUG("当不在副本中时收到选择卡牌的指令: ~w~n", [_Role#role.event]),
    {ok};

%% 新远征王军：剩余进入次数
handle(13571, {}, Role) ->
    expedition:push_info(Role),
    {ok};
    
%% 新远征王军：购买次数
handle(13572, {}, Role = #role{expedition = Exp}) ->
    BuyTimes = expedition:get_buy_times(Exp) + 1,
    case expedition:get_buy_limit(Role) of
        BuyLimit when BuyTimes > BuyLimit ->
            notice:alert(error, Role, ?MSGID(<<"购买次数超出当天限制">>)),
            {reply, {?false}};            
        _ ->
            case expedition:buy_price(BuyTimes) of
                undefined ->
                    notice:alert(error, Role, ?MSGID(<<"购买次数超出当天限制">>)),
                    {reply, {?false}};
                Gold -> 
                    Loss = [#loss{label = gold, val = Gold}],
                    case role_gain:do(Loss, Role) of
                        {ok, Role1} -> 
                            Now = util:unixtime(),
                            Role2 = Role1#role{expedition = Exp#expedition{buy_times = BuyTimes, last_buy_time = Now}},
                            expedition:push_info(Role2),
                            {reply, {?true}, Role2};
                        {false, #loss{err_code = ?gold_less}} -> 
                            notice:alert(error, Role, ?MSGID(<<"晶钻不足">>)),
                            {reply, {?false}};
                        {false, _Loss} ->
                            {reply, {?false}}
                    end
            end
    end;
 
%% 新远征王军：推送伙伴列表
handle(13573, {}, Role = #role{expedition = Exp}) ->
    case expedition:get_left_count(Role) of
        Count when Count =< 0 ->
            notice:alert(error, Role, ?MSGID(<<"已达到当天远征王军的进入上限">>)),
            {reply, {?false, []}};
        _Count ->
            Roles = arena_career:get_expedition_partners(Role),
            case Roles of
                [] ->
                    notice:alert(error, Role, ?MSGID(<<"匹配不到玩家">>)),
                    {reply, {?false, []}};
                _ -> 
                    NewRole = Role#role{expedition = Exp#expedition{
                            partners = Roles
                        }
                    },
                    {reply, {?true, Roles}, NewRole}
            end
    end;

%% 新远征王军：进入
handle(13574, {DungeonId}, Role = #role{expedition = _Exp = #expedition{partners = Roles}, pos = Pos}) ->
    case expedition:get_left_count(Role) of
        Count when Count =< 0 ->
            notice:alert(error, Role, ?MSGID(<<"已达到当天远征王军的进入上限">>)),
            {reply, {?false}};
        _Count ->
            case dungeon_data:get(DungeonId) of
                {false, Reason} -> 
                    notice:alert(error, Role, Reason),
                    {reply, {?false}};
                DungeonBase = #dungeon_base{cond_enter = CondEnter} ->
                    {Followers, _} = lists:foldr(fun(R, {L, I})->
                            FR = arena_career:to_fight_role(R, Pos),
                            Pos1 = case I of
                                1 -> 
                                    [X, Y] = ?expedition_follower_pos1,
                                    Pos#pos{x = X, y = Y, dest_x = X, dest_y = Y};
                                2 ->
                                    [X, Y] = ?expedition_follower_pos2,
                                    Pos#pos{x = X, y = Y, dest_x = X, dest_y = Y};
                                _ ->
                                    Pos
                            end,
                            {[ FR#role{pos = Pos1} | L ], I + 1}
                    end, {[], 1}, Roles),
                    case dungeon_type:role_enter(Role, DungeonBase, 1, [{followers, Followers}]) of
                        {ok, Role2} ->
                            Conds = [Cond || Cond <- CondEnter, is_record(Cond, gain) orelse is_record(Cond, loss)],
                            NewRole = case role_gain:do(Conds, Role2) of
                                {ok, _Role2} ->
                                    _Role2;
                                _ ->
                                    Role2
                            end,
                            log:log(log_activity_activeness, {<<"远征王军玩法">>, 2, NewRole}),
                            {reply, {?true}, NewRole};
                        {false, Reason} ->
                            notice:alert(error, Role, Reason),
                            {reply, {?false}};
                        false ->
                            notice:alert(error, Role, ?MSGID(<<"无法进入副本">>)),
                            {reply, {?false}}
                    end
            end
    end;

handle(13581, {}, _Role = #role{id = Rid}) ->
    Items = expedition_change:list(Rid),
    {reply, {Items}};

handle(13582, {Id, Num}, Role) when Num >= 1 ->
    case expedition_change:buy(Id, Num, Role) of
        {false, ReasonId} ->
            notice:alert(error, Role, ReasonId),
            {ok};
        {ok, NewAssets, NewBag} ->
            Role2 = Role#role{assets = NewAssets, bag = NewBag},
            notice:alert(succ, Role2, ?MSGID(<<"兑换成功，物品已经发送到你的背包">>)),
            expedition:push_status(Role2),
            {reply, {}, Role2}
    end;
   
%% 请求扫荡副本
%% Imm 是否立即完成 1：是， 0：否
handle(13585, {DungeonId, Count, Imm}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case Count > ?dungeon_clear_max of 
        false ->
            case dungeon_auto:auto(DungeonId, Count, Imm, Role) of
                {false, ReasonId} ->
                    notice:alert(error, Role, ReasonId),
                    {ok};
                {Reply, Role2} ->
                    ?DEBUG("---Reply---~p~n", [Reply]),
                    case Imm of 
                        1 ->
                            notice:alert(succ, ConnPid, ?MSGID(<<"已完成副本扫荡！">>));
                        _ -> skip
                    end,
                    {reply, Reply, Role2}
            end;
        true ->
            notice:alert(error, ConnPid, ?MSGID(<<"单次扫荡次数不能超过30次">>)),
            {ok}
    end;

%% 请求到本次扫荡开始到当前时间的扫荡掉落(请求之后开始自动推送)
% handle(13586, {}, Role) ->
%     {Reply, NewRole} = dungeon_auto:get_rewards(Role),
%     {reply, {Reply}, NewRole};

%% 获取扫荡掉落
% handle(13587, {}, _Role = #role{link = #link{conn_pid = ConnPid}, event = Event}) when Event =/= ?event_guaji->
%     notice:alert(error, ConnPid, ?L(<<"当前未进行扫荡！">>)),
%     {ok};
handle(13587, {}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case dungeon_auto:gain_rewards(Role) of
        {false, Reason, NRole, Reply} ->
            notice:alert(error, ConnPid, Reason),
            {reply, {Reply}, NRole};
        {false, Reason} ->
            notice:alert(error, ConnPid, Reason),
            % {ok};
            {reply, {[]}};
        {ok, NR, Reply} ->
            notice:alert(succ, ConnPid, ?MSGID(<<"获取掉落成功">>)),
            {reply, {Reply}, NR}
    end;

%% 停止扫荡
% handle(13588, {}, _Role = #role{link = #link{conn_pid = ConnPid}, event = Event}) when Event =/= ?event_guaji ->
%     notice:alert(error, ConnPid, ?L(<<"当前未进行扫荡！">>)),
%     {ok};
handle(13588, {}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case dungeon_auto:stop_clear(Role) of 
        {ok, NRole} ->
            {reply, {?true}, NRole};
        {false, Reason} -> 
            notice:alert(error, ConnPid, Reason),
            {ok}
    end;

%%立即完成扫荡
% handle(13589, {}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
%     case dungeon_auto:clear_now(Role) of
%         {false, Reason} ->
%             notice:alert(error, ConnPid, Reason),
%             {ok};
%         {ok, Reply, NR} ->
%             notice:alert(succ, ConnPid, ?L(<<"扫荡完成！">>)),
%             {reply, {0, 0, Reply}, NR}
%     end;

handle(_Cmd, _Data, _Role) ->
    ?DEBUG("接到错误指令: ~w, ~w, ~w, ~n", [_Cmd, _Data, _Role]),
    {error, unknow_command}.

%% 推送相关数据
push(levdun_auto, {?false, Msg}, #role{pid = Pid}) ->
    role:pack_send(Pid, 13543, {?false, Msg, 0, <<"">>, []});
push(levdun_auto, {?true, Msg, DunId, DunName, Rewards}, #role{pid = Pid}) ->
    ?DEBUG("~w", [{DunId, Rewards}]),
    role:pack_send(Pid, 13543, {?true, Msg, DunId, DunName, Rewards});

push(_, _, _) ->
    ok.

%% --------------------------------------------------------------------
%% 内部函数
%% --------------------------------------------------------------------
leave_dungeon(Role = #role{link = #link{conn_pid = ConnPid}}, Dungeon) ->
    case dungeon_type:role_leave(Role, Dungeon) of
        {false, Reason} ->
            notice:alert(error, Role, Reason),
            {ok};
        {ok, Role2} ->
            sys_conn:pack_send(ConnPid, 13510, {}),
            % adventure_listen(Role, Dungeon),
            {ok, Role2#role{status = ?status_normal, hp = Role2#role.hp_max}}
    end.

buy_dungeon_count(Price, Role = #role{dungeon = RoleDungeons}, RoleDungeon = #role_dungeon{id = DungeonId, paid_count = PaidCount, last = Last}) ->
    case role_gain:do([Price], Role) of
        {false, #loss{msg = Msg}} -> 
            notice:alert(error, Role, Msg),
            {ok};
        {ok, Role2} -> 
            log:log(log_coin, {<<"购买副本次数">>, <<"购买副本次数">>, Role, Role2}),
            RoleDungeons2 = case Last >= util:unixtime({today, util:unixtime()}) of
                true ->
                    lists:keyreplace(DungeonId, #role_dungeon.id, RoleDungeons,
                        RoleDungeon#role_dungeon{paid_count = PaidCount + 1, last = util:unixtime()});
                false ->
                    lists:keyreplace(DungeonId, #role_dungeon.id, RoleDungeons, 
                        RoleDungeon#role_dungeon{enter_count = 0, paid_count = 1, last = util:unixtime()})
            end,
            {reply, {}, Role2#role{dungeon = RoleDungeons2}} 
    end.


% adventure_listen(Role = #role{dungeon = RoleDungeons}, #dungeon{id = DungeonId, extra = Extra}) -> 
%     IfClear = 
%         case lists:keyfind(clear, 1, Extra) of
%             false -> false;
%             _ -> true 
%         end,
%     case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
%         #role_dungeon{clear_count = ClearCount} ->
%             case ClearCount =:= 1 andalso IfClear of 
%                 true ->
%                     adventure:trigger_adventure(Role, DungeonId, ?true, ?false);
%                 false ->
%                     case ClearCount > 1 andalso IfClear of
%                         true ->
%                             adventure:trigger_adventure(Role, DungeonId, ?false, ?false);
%                         false -> 
%                             ignore
%                     end
%             end;                
%         _ -> ignore
%     end.
