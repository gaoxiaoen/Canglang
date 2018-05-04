%%----------------------------------------------------
%% 仙境寻宝--开宝箱RPC
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(casino_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("casino.hrl").
-include("gain.hrl").
%%
-include("boss.hrl").
-include("link.hrl").
-include("vip.hrl").
-include("npc_store.hrl").
-include("assets.hrl").
-include("unlock_lev.hrl").

%% 获取仙境寻宝--界面数据
handle(14200, {}, #role{casino = #casino{volume = Vol, items = Items}}) ->
    {reply, {Vol, Items}};

%% 整理背包
handle(14201, {}, Role = #role{link = #link{conn_pid = ConnPid}, casino = Casino = #casino{items = Items}}) ->
    case check_time(last_casino_refresh, 4) of
        false -> 
            {ok};
        true ->
            role:put_dict(last_casino_refresh, util:unixtime()),
            DelInfo = [{?storage_casino, Item} || Item <- Items],
            storage_api:del_item_info(ConnPid, DelInfo),
            {ok, NewCasino} = storage:sort(Casino, Role),
            {reply, {1, <<>>}, Role#role{casino = NewCasino}}
    end;

%% 移动封印背包指定ID物品到背包
handle(14202, {Id, ?storage_bag, Tpos}, Role) when Tpos >= 0 ->
    role:send_buff_begin(),
    case storage:swap_by_pos(casino, Id, Tpos, Role) of
        {false, Reason} -> 
            role:send_buff_clean(),
            {reply, {Id, 0, Reason}};
        {ok, NewRole, Item} ->
            NewRole2 = role_listener:get_item(NewRole, Item),
            role:send_buff_flush(),
            {reply, {Id, 1, <<>>}, NewRole2}
    end;
%% 封印仓库移动到封印仓库
handle(14202, {Id, ?storage_casino, TPos}, Role) when TPos >= 0 ->
    role:send_buff_begin(),
    case storage:swap_by_pos_same(casino, Role, Id, TPos) of
        {false, Reason} ->
            role:send_buff_clean(),
            {reply, {Id, 0, Reason}};
        {ok, NewRole} ->
            role:send_buff_flush(),
            {reply, {Id, 1, <<>>}, NewRole}
    end;
handle(14202, _, _Role) ->
    {ok};

%% 移动封印背包所有物品到背包
handle(14203, {}, Role = #role{link = #link{conn_pid = ConnPid}, casino = Casino = #casino{volume = Volume, items = Items}}) ->
    case storage:add(bag, Role, Items) of
        {ok, NewBag} ->
            DelItemList = [{?storage_casino, Item} || Item <- Items],
            storage_api:del_item_info(ConnPid, DelItemList),
            PosList = lists:seq(1, Volume), 
            log:log(log_storage_handle, {<<"<-寻宝仓库(全部)">>, Items, Role}),
            NewRole = Role#role{bag = NewBag, casino = Casino#casino{items = [], free_pos = PosList}},
            NewRole2 = role_listener:get_item(NewRole, Items),
            {reply, {1, <<>>}, NewRole2};
        _ -> {reply, {0, ?L(<<"领取奖励失败，请检查背包是否已满">>)}}
    end;

%% 开封印
%% handle(14205, _, #role{vip = #vip{type = ?vip_no}}) ->
%%    {reply, {0, ?L(<<"非VIP用户不能使用仙境探险功能">>), []}};
%% handle(14205, _, #role{vip = #vip{type = ?vip_try}}) ->
%%    {reply, {0, ?L(<<"VIP体验用户不能使用仙境探险功能">>), []}};
handle(14205, {Type, N}, Role = #role{link = #link{conn_pid = ConnPid}, casino = #casino{items = Items}}) ->
    case check_time(last_casino_open, 1) of
        false_ -> 
            {ok};
        _ ->
            role:put_dict(last_casino_open, util:unixtime()),
            case platform_cfg:get_cfg(casino_open) of
                0 -> {reply, {0, ?L(<<"功能未开放">>), Type, []}};
                _ ->
                    role:send_buff_begin(),
                    case casino:apply(sync, {open, Type, N, Role}) of
                        {ok, NRole = #role{casino = Casino}, TotalItems} ->
                            DelInfo = [{?storage_casino, Item} || Item <- Items],
                            storage_api:del_item_info(ConnPid, DelInfo),
                            {ok, NewCasino} = storage:sort(Casino, NRole),
                            NewRole = NRole#role{casino = NewCasino},
                            NewRole2 = rank:listener(casino, NewRole, N),
                            campaign_task:listener(NewRole2, casino_count, {Type, N}),
                            NewRole3 = campaign_listener:handle({casino, Type}, NewRole2, N), %% 后台寻宝活动
                            NewRole4 = campaign_accumulative:listener(NewRole3, casino_count, {Type, N}), %% 累积类活动
                            log:log(log_item_del_loss, {<<"仙境寻宝">>, Role}),
                            role:send_buff_flush(),
                            {reply, {1, <<>>, Type, TotalItems}, NewRole4};
                        {gold, Reason} ->
                            role:send_buff_clean(),
                            {reply, {?gold_less, Reason, Type, []}};
                        {_, Reason} ->
                            role:send_buff_clean(),
                            {reply, {0, Reason, Type, []}}
                    end
            end
    end;

%% 获取仙境寻宝--界面数据
handle(14206, {0 = Type}, _Role) -> %% 返回非3类型日志
    AllLogs = casino:apply(sync, logs),
    Logs = get_type_logs(AllLogs, []),
    {reply, {Type, Logs}};
handle(14206, {Type}, _Role) ->
    AllLogs = casino:apply(sync, logs),
    case lists:keyfind(Type, 1, AllLogs) of
        {_, Logs} -> {reply, {Type, Logs}};
        _ -> {reply, {Type, []}}
    end;

%%进入淘宝界面
handle(14228, {}, #role{bag = #bag{items = Items}}) ->
    Bombs = 
        case storage:find(Items, #item.base_id, 611101) of 
            {false, _Msg} -> 0;
            {ok, Num, _, _, _} -> Num
        end,
    ?DEBUG("--进入淘宝界面 14228-有N个炸弹-：~w~n",[Bombs]),
    {reply, {Bombs}};
    

%% 一键开矿
% @N为交易的类型，N表示返回的 物品的个数
% @Auto 是否自动购买
% @Type 不同的矿洞类型 1: 赤焰矿洞 2：星河矿洞
handle(14229, {Type, N, Bomb, Auto}, Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{items = Items},
    super_boss_store = #super_boss_store{free_pos = Free_Pos}, vip = #vip{type = Lev}}) when Type =:= 1 orelse Type =:= 2 ->
    case check_vip_lev(Type, Lev) of 
        true ->
            {BombId, Price, Bombs} = get_bombs_info(Items, Type),
            case N == 0 of
                false -> 
                    Cost = 
                        case {Bombs >= Bomb, Auto == 1} of 
                            {true, _} ->
                                [
                                    #loss{label = item, val = [BombId, 0, Bomb], msg = ?MSGID(<<"亲，炸弹不足啊！">>)}
                                ];
                            {false, false} ->
                                notice:alert(error, ConnPid, ?MSGID(<<"亲，炸弹不足啊！">>)),
                                error;
                            {false, true} ->
                                [
                                    #loss{label = item, val = [BombId, 0, Bombs], msg = ?MSGID(<<"亲，炸弹不足啊！">>)},
                                    #loss{label = gold, val = Price * (Bomb - Bombs), msg = ?MSGID(<<"晶钻不足">>)}
                                ]
                        end,
                    case Cost of 
                        error -> {ok};
                        L when is_list(L) ->
                            role:send_buff_begin(),
                            case role_gain:do(L, Role) of
                               {false, #loss{msg = Msg}} ->
                                    role:send_buff_clean(), 
                                    notice:alert(error, ConnPid, Msg),
                                    {ok};
                               {ok, NRole} ->
                                    case erlang:length(Free_Pos) >= N of 
                                        true ->
                                            {ItemIds, NR} = casino_refresh_items:get_items(Type, N, NRole),
                                            % log:log(log_gold, {<<"淘宝一键开矿">>, util:fbin("淘宝成功", []), Role, NR}),
                                            log:log(log_taobao, {<<"淘宝一键开矿">>, util:fbin("~w", [ItemIds]), 1, N, Bomb, NR}),
                                            role:send_buff_flush(),
                                            {reply, {Type, ItemIds}, NR};
                                        false ->
                                            role:send_buff_clean(),
                                            notice:alert(error, ConnPid, ?MSGID(<<"仓库容量不足！">>)),
                                            {ok}
                                    end
                            end;
                        _ ->
                            {ok}   
                    end;
                true ->
                    {reply, {[]}, Role}
            end;
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"等级不足！">>)),
            {ok}
    end;


%% 开始交易
% @N为交易的类型，N表示返回的 物品的个数
% @Auto 是否自动购买
% @Type 不同的矿洞类型 1: 赤焰矿洞 2：星河矿洞
handle(14230, {Type, N, Auto}, Role = #role{link = #link{conn_pid = ConnPid}, bag = #bag{items = Items},
    super_boss_store = #super_boss_store{free_pos = Free_Pos}, vip = #vip{type = Lev}}) when Type =:= 1 orelse Type =:= 2 ->
    case check_vip_lev(Type, Lev) of 
        true ->
            {BombId, Price, Bombs} = get_bombs_info(Items, Type),
            case N == 0 of
                false -> 
                    Cost = 
                        case {Bombs > 0, Auto == 1} of 
                            {true, _} ->
                                [
                                    #loss{label = item, val = [BombId, 0, 1], msg = ?MSGID(<<"亲，没炸弹了！">>)}
                                ];
                            {false, false} ->
                                notice:alert(error, ConnPid, ?MSGID(<<"亲，没炸弹了！">>)),
                                error;
                            {false, true} ->
                                [
                                    #loss{label = gold, val = Price, msg = ?MSGID(<<"晶钻不足">>)}
                                ]
                        end,
                    case Cost of 
                        error -> {ok};
                        L when is_list(L) ->
                            role:send_buff_begin(),
                            case role_gain:do(L, Role) of
                               {false, #loss{msg = Msg}} ->
                                    role:send_buff_clean(), 
                                    notice:alert(error, ConnPid, Msg),
                                    {ok};
                               {ok, NRole} ->
                                    case erlang:length(Free_Pos) >= N of 
                                        true ->
                                            {ItemIds, NR} = casino_refresh_items:get_items(Type, N, NRole),
                                            % log:log(log_gold, {<<"淘宝开矿">>, util:fbin("淘宝成功", []), Role, NR}),
                                            log:log(log_taobao, {<<"淘宝开矿">>, util:fbin("~w", [ItemIds]), 2, N, 1, NR}),

                                            role:send_buff_flush(), 
                                            {reply, {Type, ItemIds}, NR};
                                        false ->
                                            role:send_buff_clean(),
                                            notice:alert(error, ConnPid, ?MSGID(<<"仓库容量不足！">>)),
                                            {ok}
                                    end
                            end;
                        _ ->
                            {ok}   
                    end;
                true ->
                    {reply, {[]}, Role}
            end;
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"等级不足！">>)),
            {ok}
    end;


%% 打开仓库
handle(14231, {}, _Role = #role{id={_Rid, _}, super_boss_store = #super_boss_store{items = Items}}) ->
    {reply, {Items}};

%% 全部拾取，由宝物袋进入背包，背包不足时将剩下的物品返回
handle(14233, {}, Role = #role{link = #link{conn_pid = ConnPid}, super_boss_store = Store = #super_boss_store{items = Items, free_pos = Free_Pos}}) ->
    case erlang:length(Items) > 0 of 
        true ->
            {NRole, Succ, Fail, _Reason} = add_to_bag(Items, Role),
            ?DEBUG("----Items----~p~n",[Items]),
            ?DEBUG("----Succ----~p~n",[Succ]),
            ?DEBUG("----Fail----~p~n",[Fail]),
            NItems = update_items(Items, Succ),
            NFreePos = lists:sort(Succ ++ Free_Pos),
            case erlang:length(Fail) of 
                0 ->
                    notice:alert(succ, ConnPid, ?MSGID(<<"拾取成功！">>)),
                    {reply, {[]}, NRole#role{super_boss_store =Store#super_boss_store{items = NItems,free_pos = NFreePos}}};
                _ ->
                    notice:alert(error, ConnPid, ?MSGID(<<"拾取好多物品-_-,背包容量貌似不足！！">>)),
                    {reply, {Fail}, NRole#role{super_boss_store =Store#super_boss_store{items = NItems, free_pos = NFreePos}}}
            end;
        false -> 
            notice:alert(error, ConnPid, ?MSGID(<<"没有可以拾取的物品">>)),
            {ok}
    end;

%% 拾取一个物品，由宝物袋进入背包，背包不足时将剩下的物品返回
handle(14234, {Pos}, Role = #role{link = #link{conn_pid = ConnPid}, super_boss_store = Store = #super_boss_store{items = Items, free_pos = Free_Pos}}) ->
    ?DEBUG("--拾取一个物品--:~w~n", [Pos]),
    case lists:keyfind(Pos, 1, Items) of 
        {Pos, BaseId, Num, S} ->
            {NRole, Succ, Fail, Reason} = add_to_bag([{Pos, BaseId, Num, S}], Role),
            case erlang:length(Fail) of 
                0 ->
                    NItems = lists:keydelete(Pos, 1, Items),
                    NFreePos = Succ ++ Free_Pos,
                         
                    ?DEBUG("--剩下的物品--:~w~n",[NItems]),
                    ?DEBUG("--剩下的空位--:~w~n",[NFreePos]),
                    notice:alert(succ, ConnPid, ?MSGID(<<"拾取成功！">>)),
                    {reply, {Pos}, NRole#role{super_boss_store = Store#super_boss_store{items = NItems, next_id = Pos, free_pos = lists:sort(NFreePos)}}};
                _ ->
                    ?DEBUG("--拾取失败--\n"),
                    notice:alert(error, ConnPid, Reason),
                    % {reply, {}, NRole}
                    {ok, NRole}
            end;
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"找不到该物品！">>)),
            {ok}
    end;

 %% 整理宝物袋
handle(14236, {Type}, Role = #role{super_boss_store = Store =#super_boss_store{items = Items}}) ->    
    {NFreePos2, Next_Id, NItems} = realloc_pos(Items),
    % ?DEBUG("--整理宝物袋成功，下一个可用id--:~w~n",[Next_Id]),
    % ?DEBUG("--整理宝物袋成功，所有可用id--:~w~n",[NFreePos2]),
    % ?DEBUG("--整理宝物袋成功，所有物品--:~w~n",[NItems]),
    NRole = Role#role{super_boss_store = Store#super_boss_store{items = lists:keysort(1, NItems), next_id = Next_Id, free_pos = NFreePos2}},
    case Type of 
        2 ->
            {reply, {lists:reverse(NItems)}, NRole};
        1->
            {ok, NRole}
    end;    

handle(14237, {}, _Role) ->
    Data = super_boss_casino:get_all_lucky_world(),
    ?DEBUG("-----~w~n",[Data]),
    {reply, {Data}};

handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.

check_vip_lev(Type, Lev) ->
    case Type =:= 2 of 
        true ->  
            case Lev >= 6 of 
                true -> true;
                false -> false
            end;
        false -> 
            true
    end. 

%%更新物品
update_items(Items, []) ->Items;
update_items(Items, [H|T]) ->
    Tuple = lists:keyfind(H, 1, Items),
    Temp = Items -- [Tuple],
    update_items(Temp, T).

%%重新分配物品的位置
realloc_pos(Items) ->
    do_realloc_pos(Items, ?free_pos, []).

do_realloc_pos([], Free_Pos, Items) -> {Free_Pos, lists:nth(1, Free_Pos), Items};

do_realloc_pos([{_, BaseId, Num, _}|T], Free_Pos, Items) ->
    case check_alloc(BaseId, Items, Num) of 
        0 ->
            Pos = lists:nth(1, Free_Pos),
            % ?DEBUG("---重新分配weizhi--:~w~n",[Pos]),
            NFreePos = Free_Pos -- [Pos],
            do_realloc_pos(T, NFreePos, [{Pos, BaseId, Num, ?old_item}|Items]);
        {Pos, _, Num2} ->
            case Num + Num2 > 99 of 
                true ->
                    NItems = lists:keyreplace(Pos, 1, Items, {Pos, BaseId, 99, ?old_item}),
                    Pos2 = lists:nth(1, Free_Pos),
                    % ?DEBUG("---重新分配weizhi--:~w~n",[Pos2]),
                    NFreePos = Free_Pos -- [Pos2],
                    do_realloc_pos(T, NFreePos, [{Pos2, BaseId, Num + Num2 - 99, ?old_item}|NItems]);
                false ->
                    NItems = lists:keyreplace(Pos, 1, Items, {Pos, BaseId, Num + Num2, ?old_item}),
                     do_realloc_pos(T, Free_Pos, NItems)
            end
    end.

check_alloc(BaseId, Items, Num)->
   do_check({BaseId, Num}, Items).

do_check({_BaseId, _Num}, []) -> 0;
do_check({BaseId, Num}, [{Pos, BaseId, Num2, _}|T]) ->
    case Num2 >= 99 of 
        true ->
            do_check({BaseId, Num}, [T]);
        false ->
            {Pos, BaseId, Num2}
    end;
do_check({BaseId, Num}, [{_, _B, _, _}|T]) ->
    do_check({BaseId, Num}, T).

% %% 盘龙仓库数据结构
% -record(super_boss_store, {
%         next_id = 1             %% 下个可用ID
%         ,volume = 200            %% 背包容量
%         ,free_pos = ?FREEPOS(1, 200)   %% 可用位置，默认是undefined
%         ,items = []             %% 物品数据
%     }
% ).



add_to_bag(Items, Role)->
    do_add_to_bag(Items, Role, [], [], <<"">>).

do_add_to_bag([], Role, Succ, Fail, Reason) ->  {Role, Succ, Fail, Reason};
do_add_to_bag([{Pos, BaseId, Num, Is_New}|T], Role, Succ, Fail, Reason) ->
    case storage:make_and_add_fresh(BaseId, 0, Num, Role) of
        {ok, NewRole, _} -> 
            NewRole2 = role_listener:get_item(NewRole, #item{base_id = BaseId, quantity = Num}),
            random_award:item(NewRole2, BaseId, Num),
            do_add_to_bag(T, NewRole2, [Pos|Succ], Fail, Reason);
        {_, Reason1} -> 
            do_add_to_bag(T, Role, Succ, [{Pos, BaseId, Num, Is_New}|Fail], Reason1)
    end.

%%----------------------------------------
%% 内部方法
%%----------------------------------------

%% 获取炸弹信息
get_bombs_info(Items, Type) ->
    BombId = 
        case Type of 
            1 -> 611101;
            2 -> 611102
        end,
    Price = 
        case shop:item_price(BombId) of
            false -> 30;
            P -> 
                P
        end,
    Bombs = 
        case storage:find(Items, #item.base_id, BombId) of 
            {false, _Msg} -> 0;
            {ok, Num, _, _, _} -> Num
        end,
    {BombId, Price, Bombs}.

%% 时间间隔最小为: 秒
check_time(Type, N) -> 
    LastTime = case role:get_dict(Type) of
        {ok, undefined} -> 0;
        {ok, T} -> T
    end,
    (LastTime + N) < util:unixtime().

%% 获取总日志
get_type_logs([], Logs) ->
    NewLogs0 = lists:keysort(#casino_log.get_time, Logs),
    NewLogs = lists:reverse(NewLogs0),
    lists:sublist(NewLogs, ?casino_max_log_num);
get_type_logs([{Type, Logs} | T], AllLogs) when Type =:= ?casino_type_one orelse Type =:= ?casino_type_two ->
    get_type_logs(T, Logs ++ AllLogs);
get_type_logs([_ | T], AllLogs) ->
    get_type_logs(T, AllLogs).

