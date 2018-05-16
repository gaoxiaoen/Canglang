%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 一月 2015 17:59
%%%-------------------------------------------------------------------
-module(money).
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    add_coin/5,
    add_gold/5,
    add_bind_gold/5,
    only_add_bind_gold/5,
    add_no_bind_gold/5,
    add_repute/2,
    add_exploit_pri/2,
    add_honor/2,
    add_sd_pt/2,
    add_arena_pt/2,
    add_xingyun_pt/2,
    add_xinghun/2,
    add_reiki/2,
    update_gold_client/2,
    get_gold/1,
    add_act_gold/2,
    add_manor_pt/5,
    add_equip_part/2,
    fairy_crystal/2,
    add_sweet/2
]).

-export([
    cost_money/6
]).
%%货币判断接口
-export([
    is_enough/3,
    is_enough_list/2
]).

%%日记相关接口
-export([
%%    log_coin/7,
%%    log_gold/7
]).


%%消费类型说明
%%在goods_from.erl中定义

cost_money(Player, Type, Cost, Reason, GoodsId, GoodsNum) ->
    NewCosty = ?IF_ELSE(Cost > 0, -Cost, Cost),
    case Type of
        coin ->
            add_coin(Player, NewCosty, Reason, GoodsId, GoodsNum);
        gold ->
            add_no_bind_gold(Player, NewCosty, Reason, GoodsId, GoodsNum);
        bgold ->
            add_gold(Player, NewCosty, Reason, GoodsId, GoodsNum);
        _ ->
            throw({"money", Type, NewCosty, Reason})
    end.

%%
%%%%增加铜币
%%%%可调用进程：任意进程
%%%%%%AddCoin: 扣除时为负数
%%%%AddReason：修改银币原因 intger 统一在goods_from模块定义
%%%%返回值：#player{}
add_coin(Player, AddCoin, AddReason, GoodsId, GoodsNum) when AddCoin >= 0 ->
    NewPlayer = Player#player{coin = Player#player.coin + AddCoin},
    gold_count:add_coin(AddCoin),
    global_money_create:add_money(AddCoin, AddReason, 3),
    if
        AddCoin >= 10000 ->
            player_load:dbup_player_coin(NewPlayer),
            log_coin(Player, Player#player.coin, NewPlayer#player.coin, AddCoin, AddReason, GoodsId, GoodsNum);
        true ->
            skip
    end,
    update_coin_client(NewPlayer),
    NewPlayer;

add_coin(Player, AddCoin, AddReason, GoodsId, GoodsNum) when Player#player.coin >= -AddCoin ->
    NewPlayer = Player#player{coin = Player#player.coin + AddCoin},
    if
        -AddCoin >= 10000 ->
            player_load:dbup_player_coin(NewPlayer),
            log_coin(Player, Player#player.coin, NewPlayer#player.coin, AddCoin, AddReason, GoodsId, GoodsNum);
        true ->
            skip
    end,
    update_coin_client(NewPlayer),
    cost_coin(Player, -AddCoin, AddReason),
    NewPlayer;

add_coin(_Player, AddCoin, AddReason, _GoodsId, _GoodsNum) ->
    throw({"add_coin", {AddCoin, _Player#player.bcoin, _Player#player.coin}, AddReason}).


%%增加元宝,优先操作绑定元宝，绑定元宝不够，扣除非绑的
%%可调用进程：任意进程
%%AddGold: 扣除时为负数
%%AddReason：修改银币原因 intger 统一在goods_from模块定义
%% goodsId 购买传入物品id,数量,否传0
%% GoodsNum 购买的物品数量
%%返回值：#player{}
add_gold(Player, 0, _AddReason, _GoodsId, _Num) -> Player;
add_gold(Player, AddGold, AddReason, GoodsId, GoodsNum) ->
    [Gold, BGold] = get_gold(Player#player.key),
    add_gold(Player#player{gold = Gold, bgold = BGold}, AddGold, AddReason, Gold, BGold, GoodsId, GoodsNum).

add_gold(Player, AddGold, AddReason, Gold, BGold, _GoodsId, _GoodsNum) when AddGold >= 0 ->
    NewGold = Gold + AddGold,
    NewPlayer = Player#player{gold = NewGold},
    player_load:dbup_player_gold(NewPlayer),
    log_gold(Player, Gold, BGold, NewPlayer#player.gold, NewPlayer#player.bgold, AddGold, AddReason, _GoodsId, _GoodsNum, Player#player.sn_cur, Player#player.accname),
    update_gold_client(NewPlayer, AddReason),
    gold_count:add_gold(AddGold),
    global_money_create:add_money(AddGold, AddReason, 1),
    activity:get_notice(Player, [5], true),
    NewPlayer;

add_gold(Player, AddGold, AddReason, Gold, BGold, GoodsId, GoodsNum) when BGold >= -AddGold ->
    NewBGold = BGold + AddGold,
    NewPlayer = Player#player{bgold = NewBGold},
    player_load:dbup_player_gold(NewPlayer),
    log_gold(Player, Gold, BGold, NewPlayer#player.gold, NewPlayer#player.bgold, AddGold, AddReason, GoodsId, GoodsNum, Player#player.sn_cur, Player#player.accname),
    update_gold_client(NewPlayer, AddReason),
    cost_bind_gold(NewPlayer, AddGold, AddReason),
    consume_to_client(NewPlayer, 0, -AddGold, GoodsId, GoodsNum),
    activity:get_notice(Player, [5], true),
    NewPlayer;

add_gold(Player, AddGold, AddReason, Gold, BGold, GoodsId, GoodsNum) when Gold + BGold >= -AddGold ->
    NewGold = Gold + BGold + AddGold,
    ?DEBUG("#########NewGold:~p~n", [NewGold]),
    NewPlayer = Player#player{gold = NewGold, bgold = 0},
    player_load:dbup_player_gold(NewPlayer),
    log_gold(Player, Gold, BGold, NewPlayer#player.gold, NewPlayer#player.bgold, AddGold, AddReason, GoodsId, GoodsNum, Player#player.sn_cur, Player#player.accname),
    update_gold_client(NewPlayer, AddReason),
    cost_bind_gold(NewPlayer, BGold, AddReason),
    cost_no_bind_gold(NewPlayer, min(0, NewPlayer#player.gold - Player#player.gold), AddReason),
    consume_to_client(NewPlayer, AddGold + BGold, BGold, GoodsId, GoodsNum),
    activity:get_notice(Player, [5], true),
    NewPlayer;

add_gold(_Player, AddGold, AddReason, Gold, BGold, _GoodsId, _GoodsNum) ->
    throw({"add_gold", {AddGold, Gold, BGold}, AddReason}).


%%绑定元宝操作
add_bind_gold(Player, 0, _addReason, _GoodsId, _GoodsNum) -> Player;
add_bind_gold(Player, AddBGold, AddReason, _GoodsId, _GoodsNum) when AddBGold > 0 ->
    [Gold, BGold] = get_gold(Player#player.key),
    NewBGold = BGold + AddBGold,
    NewPlayer = Player#player{bgold = NewBGold, gold = Gold},
    player_load:dbup_player_gold(NewPlayer),
    log_gold(Player, Gold, BGold, NewPlayer#player.gold, NewPlayer#player.bgold, AddBGold, AddReason, _GoodsId, _GoodsNum, Player#player.sn_cur, Player#player.accname),
    update_gold_client(NewPlayer, AddReason),
    gold_count:add_gold(AddBGold),
    global_money_create:add_money(AddBGold, AddReason, 2),
    NewPlayer;
add_bind_gold(Player, AddBGold, AddReason, GoodsId, GoodsNum) ->
    add_gold(Player, AddBGold, AddReason, GoodsId, GoodsNum).


%%非绑定元宝操作
add_no_bind_gold(Player, 0, _addReason, _GoodsId, _GoodsNum) -> Player;
add_no_bind_gold(Player, AddGold, AddReason, GoodsId, GoodsNum) when AddGold > 0 ->
    add_gold(Player, AddGold, AddReason, GoodsId, GoodsNum);

add_no_bind_gold(Player, AddGold, AddReason, GoodsId, GoodsNum) when AddGold < 0 ->
    [Gold, BGold] = get_gold(Player#player.key),
    NewGold = max(0, Gold + AddGold),
    NewPlayer = Player#player{gold = NewGold, bgold = BGold},
    player_load:dbup_player_gold(NewPlayer),
    log_gold(Player, Gold, BGold, NewPlayer#player.gold, NewPlayer#player.bgold, AddGold, AddReason, GoodsId, GoodsNum, Player#player.sn_cur, Player#player.accname),
    update_gold_client(NewPlayer, AddReason),
    cost_no_bind_gold(NewPlayer, AddGold, AddReason),
    consume_to_client(NewPlayer, AddGold, 0, GoodsId, GoodsNum),
    consume_back_charge:add_consume(-AddGold, Player),
    activity:get_notice(Player, [5], true),
    NewPlayer.


%% 只操作绑定元宝
only_add_bind_gold(Player, 0, _addReason, _GoodsId, _GoodsNum) -> Player;
only_add_bind_gold(Player, AddBGold, AddReason, GoodsId, GoodsNum) ->
    [Gold, BGold] = get_gold(Player#player.key),
    only_add_bind_gold(Player#player{gold = Gold, bgold = BGold}, AddBGold, AddReason, Gold, BGold, GoodsId, GoodsNum).
only_add_bind_gold(Player, AddGold, AddReason, Gold, BGold, _GoodsId, _GoodsNum) when AddGold >= 0 ->
    [Gold, BGold] = get_gold(Player#player.key),
    NewBGold = BGold + AddGold,
    NewPlayer = Player#player{bgold = NewBGold, gold = Gold},
    player_load:dbup_player_gold(NewPlayer),
    log_gold(Player, Gold, BGold, NewPlayer#player.gold, NewPlayer#player.bgold, AddGold, AddReason, _GoodsId, _GoodsNum, Player#player.sn_cur, Player#player.accname),
    update_gold_client(NewPlayer, AddReason),
    gold_count:add_gold(AddGold),
    global_money_create:add_money(AddGold, AddReason, 2),
    NewPlayer;
only_add_bind_gold(Player, AddGold, AddReason, Gold, BGold, GoodsId, GoodsNum) when BGold >= -AddGold ->
    NewBGold = BGold + AddGold,
    NewPlayer = Player#player{bgold = NewBGold},
    player_load:dbup_player_gold(NewPlayer),
    log_gold(Player, Gold, BGold, NewPlayer#player.gold, NewPlayer#player.bgold, AddGold, AddReason, GoodsId, GoodsNum, Player#player.sn_cur, Player#player.accname),
    update_gold_client(NewPlayer, AddReason),
    cost_bind_gold(NewPlayer, AddGold, AddReason),
    consume_to_client(NewPlayer, 0, -AddGold, GoodsId, GoodsNum),
    NewPlayer;

only_add_bind_gold(_Player, AddGold, AddReason, Gold, BGold, _GoodsId, _GoodsNum) ->
    throw({"only_add_no_bind_gold", {AddGold, Gold, BGold}, AddReason}).

%%增加声望
%%可调用进程：任意进程
%%AddRepute：扣除时为负数
%%返回值：#player{}
add_repute(Player, 0) -> Player;
add_repute(Player, AddRepute) ->
    NewRepute = max(0, Player#player.repute + AddRepute),
    NewPlayer = Player#player{repute = NewRepute},
    {ok, BinGold} = pt_130:write(13004, {[[14, NewPlayer#player.repute]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    player_load:dbup_player_repute(NewPlayer),
    NewPlayer.

%%增加六龙历练
%%可调用进程：任意进程
%%AddRepute：扣除时为负数
%%返回值：#player{}
add_sd_pt(Player, 0) -> Player;
add_sd_pt(Player, AddRepute) ->
    NewRepute = max(0, Player#player.sd_pt + AddRepute),
    NewPlayer = Player#player{sd_pt = NewRepute},
    {ok, BinGold} = pt_130:write(13004, {[[13, NewPlayer#player.sd_pt]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    player_load:dbup_player_sd_pt(NewPlayer),
    NewPlayer.

%%增加荣誉
add_honor(Player, 0) -> Player;
add_honor(Player, AddHonor) ->
    NewHonor = max(0, Player#player.honor + AddHonor),
    NewPlayer = Player#player{honor = NewHonor},
    player_load:dbup_player_honor(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[7, NewPlayer#player.honor]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    NewPlayer.

%%增加玩家功勋值
add_exploit_pri(Player, 0) -> Player;
add_exploit_pri(Player, Add) ->
    NewExploit = max(0, Player#player.exploit_pri + Add),
    NewPlayer = Player#player{exploit_pri = NewExploit},
    player_load:dbup_player_exploit_pri(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[12, NewPlayer#player.exploit_pri]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    NewPlayer.

%%增加竞技积分
add_arena_pt(Player, 0) -> Player;
add_arena_pt(Player, Add) ->
    NewArenaPt = max(0, Player#player.arena_pt + Add),
    NewPlayer = Player#player{arena_pt = NewArenaPt},
    player_load:dbup_player_arena_pt(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[5, NewPlayer#player.arena_pt]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    NewPlayer.

%%增加星运积分
add_xingyun_pt(Player, 0) -> Player;
add_xingyun_pt(Player, Add) ->
    NewArenaPt = max(0, Player#player.xingyun_pt + Add),
    NewPlayer = Player#player{xingyun_pt = NewArenaPt},
    player_load:dbup_player_xingyun_pt(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[10, NewPlayer#player.xingyun_pt]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    NewPlayer.

%%增加星魂
add_xinghun(Player, 0) -> Player;
add_xinghun(Player, Add) ->
    NewXinghun = max(0, Player#player.xinghun + Add),
    NewPlayer = Player#player{xinghun = NewXinghun},
    player_load:dbup_player_xinghun(NewPlayer),
    {ok, Bin} = pt_130:write(13004, {[[9, NewPlayer#player.xinghun]]}),
    server_send:send_to_sid(Player#player.sid, Bin),
    NewPlayer.

%%增加家园积分
add_manor_pt(Player, 0, _FromWhere, _, _) -> Player;
add_manor_pt(Player, Add, _FromWhere, GoodsId, Num) ->
    NewVal = max(0, Player#player.manor_pt + Add),
    NewPlayer = Player#player{manor_pt = NewVal},
    player_load:dbup_player_manor_pt(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[15, NewPlayer#player.manor_pt]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    log_manor_pt(Player#player.key, Player#player.nickname, Player#player.manor_pt, NewVal, abs(Add), _FromWhere, GoodsId, Num),
    NewPlayer.

%%增加装备碎片
add_equip_part(Player, 0) -> Player;
add_equip_part(Player, Add) ->
    NewVal = max(0, Player#player.equip_part + Add),
    NewPlayer = Player#player{equip_part = NewVal},
    player_load:dbup_player_equip_part(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[17, NewPlayer#player.equip_part]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    log_equip_part(Player#player.key, Player#player.nickname, Player#player.equip_part, NewVal, abs(Add)),
    NewPlayer.


%%增加十荒神器器灵
add_reiki(Player, 0) -> Player;
add_reiki(Player, Add) ->
    NewReiki = max(0, Player#player.reiki + Add),
    NewPlayer = Player#player{reiki = NewReiki},
    player_load:dbup_player_reiki(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[11, NewPlayer#player.reiki]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    NewPlayer.

%%增加甜蜜度
add_sweet(Player, 0) -> Player;
add_sweet(Player, Add) ->
    NewReiki = max(0, Player#player.sweet + Add),
    NewPlayer = Player#player{sweet = NewReiki},
    player_load:dbup_player_sweet(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[16, NewPlayer#player.sweet]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    NewPlayer.

%%增加活动金币
add_act_gold(Player, 0) -> Player;
add_act_gold(Player, Add) ->
    NewActGold = max(0, Player#player.act_gold + Add),
    NewPlayer = Player#player{act_gold = NewActGold},
    player_load:dbup_player_act_gold(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[18, NewPlayer#player.act_gold]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    NewPlayer.

%%增加仙晶
fairy_crystal(Player, 0) -> Player;
fairy_crystal(Player, Add) ->
    NewActGold = max(0, Player#player.fairy_crystal + Add),
    NewPlayer = Player#player{fairy_crystal = NewActGold},
    player_load:dbup_player_fairy_crystal(NewPlayer),
    {ok, BinGold} = pt_130:write(13004, {[[19, NewPlayer#player.fairy_crystal]]}),
    server_send:send_to_sid(Player#player.sid, BinGold),
    NewPlayer.

%%判断货币是否足够
%%可调用进程：任意进程
%%参数：CostType:coin铜币 gold元宝
%%返回值：true/false
is_enough(_, Cost, _) when Cost == 0 -> true;
is_enough(Player, Cost, CostType) when Cost > 0 ->
    case CostType of
        coin -> Player#player.coin >= Cost;
        bgold ->
            [Gold, BGold] = get_gold(Player#player.key),
            Gold + BGold >= Cost;
        gold ->
            [Gold, _BGold] = get_gold(Player#player.key),
            Gold >= Cost;
        _ -> false
    end;
is_enough(_, _, _) -> false.

%%判断货币列表是否足够
is_enough_list(Player, MoneyList) ->
    F = fun({Type, Cost}, L) ->
        case lists:keytake(Type, 1, L) of
            false -> [{Type, Cost} | L];
            {value, {_, Val}, T} ->
                [{Type, Cost + Val} | T]
        end
        end,
    NewMoneyList = lists:foldl(F, [], MoneyList),
    F1 = fun({Type1, Cost1}) ->
        if Type1 == bgold ->
            Gold = lists:sum([Cost2 || {Type2, Cost2} <- NewMoneyList, Type2 == gold]),
            is_enough(Player, Cost1 + Gold, Type1);
            true ->
                is_enough(Player, Cost1, Type1)
        end
         end,
    lists:all(F1, NewMoneyList).

%%铜币日志
log_coin(Player, OldCoin, NewCoin, AddCoin, AddReason, GoodsId, GoodsNum) ->
    Desc = case lists:keyfind(AddReason, 1, goods_from:from_types()) of
               false -> "";
               {_, Desc1} -> Desc1
           end,
    Sql = io_lib:format(<<"insert into log_coin set pkey = ~p,oldcoin =~p,newcoin=~p,addcoin=~p,addreason=~p,time=~p,game_id=~p,channel_id=~p,game_channel_id=~p,nickname='~s',goods_id=~p,goods_num=~p,`desc`='~s',sn=~p,acc_name='~s'">>,
        [Player#player.key, OldCoin, NewCoin, AddCoin, AddReason, util:unixtime(), Player#player.game_id, Player#player.pf, Player#player.game_channel_id, Player#player.nickname, GoodsId, GoodsNum, Desc, Player#player.sn_cur, Player#player.accname]),
    log_proc:log(Sql),
    ok.

%%元宝日志
log_gold(Player, OldGold, OldBGold, NewGold, NewBGold, AddGold, AddReason, GoodsId, GoodsNum, Sn, AccName) ->
    Desc = case lists:keyfind(AddReason, 1, goods_from:from_types()) of
               false -> "";
               {_, Desc1} -> Desc1
           end,
    Sql = io_lib:format(<<"insert into log_gold set pkey = ~p,oldgold=~p,oldbgold=~p,newgold=~p,newbgold=~p,addgold=~p,addreason=~p,time=~p,game_id=~p,channel_id=~p,game_channel_id=~p,nickname='~s',goods_id=~p,goods_num=~p,`desc`='~s',sn=~p,acc_name='~s'">>,
        [Player#player.key, OldGold, OldBGold, NewGold, NewBGold, AddGold, AddReason, util:unixtime(),
            Player#player.game_id, Player#player.pf, Player#player.game_channel_id, Player#player.nickname, GoodsId, GoodsNum, Desc, Sn, AccName]),
    log_proc:log(Sql),
    ok.

get_gold(Key) ->
    case db:get_row(io_lib:format("select gold,bgold from player_state where pkey = ~p", [Key])) of
        [] -> [0, 0];
        Data -> Data
    end.


%%更新元宝
update_gold_client(Player, _AddReason) ->
    {ok, Bin} = pt_130:write(13004, {[[1, Player#player.gold], [2, Player#player.bgold]]}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%更新银币
update_coin_client(Player) ->
    {ok, Bin} = pt_130:write(13004, {[[3, Player#player.coin]]}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.
%%元宝消耗活动接口
%%消耗非绑元宝
cost_no_bind_gold(Player, Cost, Reason) ->
    case lists:member(Reason, [32, 695]) of
        true -> skip;
        false ->
            consume_rank:add_consume_val(Reason, Player, -Cost),
            act_consume_score:add_consume_val(Reason, Player, -Cost),
            cross_consume_rank:add_consume_val(Reason, Player, -Cost),
            area_consume_rank:add_consume_val(Reason, Player, -Cost),
            acc_consume:add_consume_val(-Cost), %%累计消费
            act_consume_rebate:add_consume(Player, -Cost),
            merge_act_acc_consume:add_consume(Player,-Cost)
    end,
    self() ! {m_task_trigger, 14, -Cost},
    ok.
%%消耗绑定元宝
cost_bind_gold(_Player, Cost, _Reason) ->
    self() ! {m_task_trigger, 14, -Cost},
    ok.

%%银币消耗活动接口
cost_coin(Player, Cost, _Reason) ->
    target_act:trigger_tar_act(Player, 9, Cost),
    self() ! {m_task_trigger, 13, Cost},
    ok.

%%消耗到客户端
consume_to_client(Player, Gold, BGold, GoodsId, Num) ->
    {ok, Bin} = pt_130:write(13026, {GoodsId, Num, abs(Gold), abs(BGold), Player#player.gold, Player#player.bgold}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.
%%consume_to_client(_Player, _Gold, _BGold, _GoodsId, _Num) ->
%%    ok.

log_manor_pt(Pkey, Nickname, Old, New, Change, From, GoodsId, Num) ->
    Sql = io_lib:format("insert into log_manor_pt set pkey=~p,nickname='~s',old_pt=~p,new_pt=~p,change_pt=~p,`from`=~p,goods_id=~p,num=~p,time=~p",
        [Pkey, Nickname, Old, New, Change, From, GoodsId, Num, util:unixtime()]),
    log_proc:log(Sql).

%% 装备碎片日志
log_equip_part(Pkey, Nickname, Old, New, Change) ->
    Sql = io_lib:format("insert into log_equip_part set pkey=~p,nickname='~s',old_pt=~p,new_pt=~p,change_pt=~p,time=~p",
        [Pkey, Nickname, Old, New, Change, util:unixtime()]),
    log_proc:log(Sql).