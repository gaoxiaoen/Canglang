%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2017 15:40
%%%-------------------------------------------------------------------
-module(hotfix16).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").
-include("equip.hrl").


%% API
-compile(export_all).



-define(BUG_KEY_ID(Key), {bug_key_id, Key}).
%% 统计bug list


%%log
make_bug_info() ->
    case center:is_center_all() of
        true ->
            Nodes = center:get_all_nodes(),
            F = fun(#ets_kf_nodes{node = Node}, AccIn) ->
                try
                    case rpc:call(Node, ?MODULE, get_bug_list, []) of
                        BugList when is_list(BugList) ->
                            BugList ++ AccIn;
                        _R ->
                            AccIn
                    end
                catch
                    _:_ ->
                        ?WARNING("rpc get log  fail,node:~s", [Node]),
                        AccIn
                end
            end,
            L = lists:foldl(F, [], Nodes),
            write_to_text(L);
        _ ->
            skip
    end.


%% 统计bug list
get_bug_list() ->
    ServerNum = config:get_server_num(),
    Data1 = get_reg3(),
    [{ServerNum, Data1}].


%% 写入文本
write_to_text(List) ->
    FileName = io_lib:format("../use_gift_num.txt", []),
    {ok, S} = file:open(FileName, write),
    lists:foreach(fun({ServerId, List1}) ->

        io:format(S, "~w    ~w~n", [ServerId, List1])
    end, List),
    file:close(S).


get_reg1() ->
%%    305
    Sql = "select pkey,goods_id,create_num FROM log_goods_create WHERE `from` = 305 and goods_id = 8002404  and `time` > 1526054400",
%%     Sql = "select pkey,goods_id,create_num FROM log_goods_create WHERE `from` = 305 and goods_id = 8002404 and `time` < 1526093100 and `time` > 1526054400",
    case db:get_all(Sql) of
        [] -> [];
        Data ->
            F = fun([Pkey, GoodsId, GoodsNum]) ->
%%                Sql1 = io_lib:format("select num FROM goods WHERE pkey = ~p", [Pkey]),
%%                case db:get_row(Sql1) of
%%                    [] -> [];
%%                    [Num] ->
%%                        [{Pkey, Num, [{GoodsId, GoodsNum}]}]
%%                end,
                [{Pkey, [{GoodsId, GoodsNum}]}]
            end,
            List = lists:flatmap(F, Data),
            merge_kv(List)
    end.

get_reg2()->
    F = fun(Pkey)->
        Sql = io_lib:format("select sum(num) from goods where pkey = ~p and goods_id = 8002404", [Pkey]),
        case db:get_row(Sql) of
            [] ->
                [{Pkey,0}];
            [Num] ->
                if
                    Num == null -> [];
                    true ->
                        ban(Pkey),

                        SqlDe = io_lib:format("delete from goods where pkey = ~w and goods_id = 8002404", [Pkey]),
                        db:execute(SqlDe),

                        unban(Pkey),
                        [{Pkey,Num}]
                end
        end
    end,
    lists:flatmap(F,player_key_list()).

get_reg3()->
    F = fun(Pkey)->
        Sql = io_lib:format("select count(*) from log_open_gift where pkey = ~p and gift_id = 8002404", [Pkey]),
        case db:get_row(Sql) of
            [] ->
                [{Pkey,0}];
            [Num] ->
                if
                    Num == null -> [];
                    Num == 0 -> [];
                    true ->
                        [{Pkey,Num}]
                end
        end
    end,
    lists:flatmap(F,player_key_list()).



%%合并keyval
merge_kv(List) ->
    F = fun({Key, Val}, L) ->
        case lists:keytake(Key, 1, L) of
            false -> [{Key, Val} | L];
            {value, {_, Val1}, T} ->
                [{Key, Val ++ Val1} | T]
        end
    end,
    lists:foldl(F, [], List).

delete_goods(Player) ->

    ok.


text()->
    Sql = io_lib:format("select soul_info from equip_soul where pkey = ~p", [300010390]),
    case db:get_row(Sql) of
        [] ->
            skip;
        [Soul] ->
            ?DEBUG("Soul ~p~n",[Soul]),
            ok
    end.
%% 300010431
%% 回收玩家宝石
back_soul(GoodsNum, PlayerId) ->

    ban(PlayerId),

    Sql = io_lib:format("select soul_info from equip_soul where pkey = ~p", [PlayerId]),
    case db:get_row(Sql) of
        [] ->
            skip;
        [Soul] ->
            SoulList = equip_soul:pack_equip_soul(util:bitstring_to_term(Soul)),
            F = fun(St, {List11, Num}) ->
                F0 = fun({Location, State, GoodsId}, {List0, Num0}) ->
                    case data_equip_soul:get_gid(GoodsId) of
                        [] ->{[{Location, State, GoodsId} | List0], Num0};
                        Base ->
                            Sum = get_lv(Base#base_equip_soul.lv),
                            if
                                Sum < Num0 ->
                                    {[{Location, State, 0} | List0], Num0 - Sum};
                                true -> {[{Location, State, GoodsId} | List0], Num0}
                            end
                    end
                end,
                {Att_list, Num1} = lists:foldl(F0, {[], Num}, St#st_soul_info.info_list),
                Q = max(0, Num1),
                {[#st_soul_info{info_list = Att_list, subtype = St#st_soul_info.subtype} | List11], Q}
            %%                     Att_list = St#st_magic_info.att_list,
            end,
            {NewSoulList, Num11} = lists:foldl(F, {[], GoodsNum}, SoulList),
            Data = util:term_to_bitstring(equip_soul:format_equip_soul(NewSoulList)),
            Sql1 = io_lib:format("replace into equip_soul set pkey= ~p,soul_info='~s'", [PlayerId, Data]),
            db:execute(Sql1),
            GoodsList = load_player_goods(PlayerId, "goods"),
            PlayerGoodsList = goods_info_init(GoodsList),
            F0 = fun(Goods, {L1, L2}) ->
                if Goods#goods.location == ?GOODS_LOCATION_BAG ->
                    {L1, [Goods | L2]};
                    true ->
                        {[Goods | L1], L2}
                end
            end,
            {_PlayerGoodsList1, GoodsList1} = lists:foldl(F0, {[], []}, PlayerGoodsList),
            F1 = fun(Goods, Num111) ->
                Base = data_equip_soul:get_gid(Goods#goods.goods_id),
                if
                    Base == [] -> Num111;
                    Base#base_equip_soul.lv == 0 -> Num111;
                    true ->
                        Sum = get_lv(Base#base_equip_soul.lv),
                        if
                            Goods#goods.num * Sum =< Num111 ->
                                NewGoods = Goods#goods{num = 0},
                                goods_load:dbup_goods_num(NewGoods),
                                max(0, Num111 - Goods#goods.num * Sum);
                            true ->
                                Count = Num111 div Sum,
                                NewGoods = Goods#goods{num = Goods#goods.num - Count},
                                goods_load:dbup_goods_num(NewGoods),
                                0
                        end
                end
            end,
            lists:foldl(F1, Num11, GoodsList1)
    end,

    unban(PlayerId),
    ok.
%%加载玩家所有物品信息
load_player_goods(Pkey, Table) ->
    SQL = io_lib:format("select gkey ,pkey ,goods_id,location ,cell ,num ,bind ,expiretime ,goods_lv,star,stren ,color,  wash_luck_value,wash_attrs,gemstone_groove,total_attrs,combat_power, refine_attr, exp, god_forging,lock_s,fix_attrs,random_attrs,sex from ~s where pkey = ~p", [Table, Pkey]),
    db:get_all(SQL).

ban(Pkey)->
    SqlBan = io_lib:format("update player_login set status = 1 where pkey = ~w", [Pkey]), %% 封号
    db:execute(SqlBan),
    case misc:get_player_process(Pkey) of
        Pid when is_pid(Pid) ->
            player:stop(Pid);
        _ ->
            skip
    end.

unban(Pkey)->
    SqlUnBan = io_lib:format("update player_login set status = 0 where pkey = ~w", [Pkey]), %% 解封
    db:execute(SqlUnBan).


get_lv(1)->1;
get_lv(2)->2;
get_lv(3)->4;
get_lv(4)->8;
get_lv(5)->24;
get_lv(6)->72;
get_lv(7)->216;
get_lv(8)->864;
get_lv(9)->4320;
get_lv(10)->21600;
get_lv(11)->108000;
get_lv(12)->540000;
get_lv(13)->2700000;
get_lv(14)->13500000;
get_lv(15)->67500000;
get_lv(_)->0.



goods_info_init(GoodsList) ->
    goods_info_init(util:unixtime(), GoodsList, []).

goods_info_init(_Now, [], GoodsList) ->
    GoodsList;
%%    gkey ,pkey ,goods_id,location ,cell ,num ,bind ,expiretime ,goods_lv,star,stren ,color,  wash_luck_value,wash_attrs,gemstone_groove,total_attrs,combat_power, refine_attr, exp, god_forging,lock_s,fix_attrs,random_attrs,sex
goods_info_init(Now, [[Gkey, Pkey, GoodsId, Location, Cell, Num, Bind, Expiretime, GoodsLv, Star, Stren, Color, Wash_luck_value, WashAttrs,GemstoneGroove, TotalAttrs, CombatPower, RefineAttr, Exp, GodForging, Lock, FixAttrs, RandomAttrs, Sex] | Tail], GoodsList) ->
    case data_equip_soul:get_gid(GoodsId) of
        [] ->
            goods_info_init(Now, Tail, GoodsList);
        _ ->
            GemstoneGrooveList = util:bitstring_to_term(GemstoneGroove),
            WashAttrsList = util:bitstring_to_term(WashAttrs),
            TotalAttrsList = util:bitstring_to_term(TotalAttrs),
            RefineAttrList = util:bitstring_to_term(RefineAttr),
            FixAttrsList = util:bitstring_to_term(FixAttrs),
            RandomAttrsList = util:bitstring_to_term(RandomAttrs),
            Goods = #goods{key = Gkey, pkey = Pkey, goods_id = GoodsId, location = Location, cell = Cell, num = Num,
                bind = Bind, expire_time = Expiretime, goods_lv = GoodsLv, star = Star, stren = Stren, color = Color, wash_luck_value = Wash_luck_value, gemstone_groove = GemstoneGrooveList,
                total_attrs = TotalAttrsList, wash_attr = WashAttrsList, combat_power = CombatPower, refine_attr = RefineAttrList, exp = Exp, god_forging = GodForging, lock = Lock,
                fix_attrs = FixAttrsList, random_attrs = RandomAttrsList, sex = Sex
            },
            goods_info_init(Now, Tail, [Goods | GoodsList])
    end.





select_goods() ->
    ok.


delect_mail()->

    lists:foreach(fun(Pkey)->
        SqlBan = io_lib:format("update player_login set status = 1 where pkey = ~w", [Pkey]), %% 封号
        db:execute(SqlBan),
        case misc:get_player_process(Pkey) of
            Pid when is_pid(Pid) ->
                player:stop(Pid);
            _ ->
                skip
        end
    end,pkeys()),

    lists:foreach(fun(Gkey)->
        SqlUnBan = io_lib:format("delete from mail where mkey = ~p", [Gkey]), %%% 删除
        db:execute(SqlUnBan)
    end,mail_key_list()),


    lists:foreach(fun(Pkey)->
        SqlUnBan = io_lib:format("update player_login set status = 0 where pkey = ~w", [Pkey]), %% 解封
        db:execute(SqlUnBan)
    end,pkeys()),


    ok.


mail_key_list()->
    [
        300010000000056131,
        300010000000056129,
        11110000000151779,
        20010000002110311	,
        20010000002111772	,
        20010000002111791	,
        20010000002112293	,
        20010000002112326	,
        20010000002112349	,
        20010000002112351	,
        20010000002112369	,
        20010000002112403	,
        20010000002112405	,
        20010000002112413	,
        20010000002112428	,
        20010000002112465	,
        20010000002112471	,
        20010000002112473	,
        20010000002112500	,
        20010000002112551	,
        20010000002112568	,
        20010000002112602	,
        20010000002112612	,
        20010000002112616	,
        20010000002112636	,
        20010000002112722	,
        20010000002112749	,
        20010000002129998	,
        20010000002130058	,
        20010000002130114	,
        20180000000770042	,
        20180000000774247	,
        20370000000391387	,
        20370000000392809	,
        20370000000392852	,
        20370000000392861	,
        20370000000392865	,
        20370000000392927	,
        20370000000393567	,
        20370000000393662	,
        20370000000393673].




pkeys()->
    [
        300010390,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        200100212,
        201802075,
        201802075,
        203700195,
        203700195,
        203700195,
        203700195,
        203700195,
        203700195,
        203700195,
        203700195,
        203700195].

player_key_list()->
    [
        300010390,
        202301822,
        202301452,
        202502206,
        203700195,
        204001876,
        201500169,
        201801485,
        201802075,
        200102167,
        200100212,
        200100486,
        200100525,
        200101936,
        203900028,
        203900395,
        203901017,
        200500913,
        201600280,
        201701869,
        201701615,
        201701015,
        202001176,
        202100107].





%% 202301822	1
%% 202301452	1
%% 202502206	1
%% 203700195	22
%% 204001876	1
%% 201500169	3
%% 201801485	4
%% 201802075	4
%% 200102167	3
%% 200100212	28
%% 200100486	1
%% 200100525	2
%% 200101936	1
%% 203900028	7
%% 203900395	4
%% 203901017	1
%% 200500913	1
%% 201600280	3
%% 201701869	2
%% 201701615	2
%% 201701015	2
%% 202001176	1
%% 202100107	1


repair()->
    F = fun({Pkey,Val})->
        back_soul(Val*8,Pkey)
    end,
    lists:foreach(F,repair_list()),

    ok.



repair_list()->
    [

        {300010390,3},
        {202301822,30000},
        {202301452,30012},
        {202502206,30002},
        {203700195,510573},
        {204001876,30004},
        {201500169,90001},
        {201801485,120233},
        {201802075,120063},
        {200102167,152885},
        {200100212,120774},
        {200100486,30028},
        {200100525,122624},
        {200101936,7992},
        {203900028,240048},
        {203900395,150047},
        {203901017,30024},
        {200500913,30034},
        {201600280,90013},
        {201701869,90005},
        {201701615,60020},
        {201701015,60001},
        {202001176,30002},
        {202100107,30002}].

%% [{[{5,0,0},{4,0,0},{3,1,5101444},{2,1,5101405},{1,1,5101426}],4},{[{1,1,5101435},{2,1,5101426},{3,1,5101406},{4,0,0},{5,0,0}],5},{[{1,1,5101427},{2,1,5101435},{3,1,5101416},{4,0,0},{5,0,0}],3},{[{1,1,5101428},{2,1,5101407},{3,1,5101436},{4,0,0},{5,0,0}],1},{[{5,0,0},{4,0,0},{3,1,5101407},{2,1,5101428},{1,1,5101447}],130},{[{1,1,0},{2,1,5101448},{3,1,5101407},{4,0,0},{5,0,0}],6},{[{5,0,0},{4,0,0},{3,1,5101408},{2,1,5101418},{1,1,5101438}],2},{[{5,0,0},{4,0,0},{3,1,5101408},{2,1,5101418},{1,1,5101438}],7}]



send_key_mail()->
    Tatil = ?T("具体的回收方案在这里哦"),
    Center = ?T("玩家大大您好 以下为具体回收方案：    1.回收您邮件背包的4级宝石礼包    2.按总数量回收4级宝石   3.对已消耗的4级宝石，按总量减去已回数，将高级宝石拆分成低级宝石，回收其中等价宝石     4.我们还将返还您翻牌时所消耗元宝数\n感谢您对游戏的支持"
    ),

F = fun({Pkey,GoodsList})->
    Sql = io_lib:format("select pkey from player_state where pkey = ~p", [Pkey]),
    case db:get_row(Sql) of
        [] ->
            skip;
        [Pkey] ->
            mail:sys_send_mail([Pkey],Tatil,Center,GoodsList);
        O ->
         skip
    end

    end,
    lists:foreach(F,mail_list()),

ok.




mail_list()->
    [
        {202301822,[{10199,200}] },
        {300010390,[{10199,200}] },
        {202301452,[{10199,200}] },
        {202502206,[{10199,200}] },
        {203700195,[{10199,4400}]},
        {204001876,[{10199,200}] },
        {201500169,[{10199,600}] },
        {201801485,[{10199,800}] },
        {201802075,[{10199,800}] },
        {200102167,[{10199,600}] },
        {200100212,[{10199,5600}]},
        {200100486,[{10199,200}] },
        {200100525,[{10199,400}] },
        {200101936,[{10199,200}] },
        {203900028,[{10199,1400}]},
        {203900395,[{10199,800}] },
        {203901017,[{10199,200}] },
        {200500913,[{10199,200}] },
        {201600280,[{10199,600}] },
        {201701869,[{10199,400}] },
        {201701615,[{10199,400}] },
        {201701015,[{10199,400}] },
        {202001176,[{10199,200}] },
        {202100107,[{10199,200}] }].









