%% @author and_me
%% @doc @todo Add description to mount_load.


-module(pray_load).

-include("server.hrl").
-include("common.hrl").
-include("pray.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
-export([load_pray_bag/1,
		 load_pary_info/1,
		 add_pray_equip/1,
		 dbdel_pray_equip/1,
		 dbup_pray_fashid/1,
		 dbup_pray_equip_remain_time/1,
		 update_pray_goods_state/1,
		 dbup_pray_max_cell/1]).

load_pray_bag(Player)->
	Sql = io_lib:format("select `key`,pkey,goods_id,wash_attr,num,state, gemstone_groove from pray_bag where pkey = ~p",[Player#player.key]),
	 case db:get_all(Sql) of
		[]->
			[];
		List->
			List1 = [#pray_goods{
					pkey = Pkey,
					key = Key,
					goods_id = GoodsId,
					wash_attr = util:bitstring_to_term(WashAttr),
					num = Num,
					state = State,
					gemstone_groove = util:bitstring_to_term(GemstoneGroove)}
			||[Key,Pkey,GoodsId,WashAttr,Num,State,GemstoneGroove]<-List],
			lists:keysort(#pray_goods.state, List1)
	end.

load_pary_info(Pkey)->
	Sql = io_lib:format("select max_cell,equip_remain_time,quick_times,fashion_id,fashion_time from pray_info where pkey = ~p",[Pkey]),
    case db:get_row(Sql) of
        [] ->
            %%新玩家
            NewRoleSql = io_lib:format("insert into pray_info set pkey = ~p,max_cell=~p,equip_remain_time = ~p, quick_times = ~p ,fashion_id = 10001 ,fashion_time = ~p",
									   [Pkey,30,0,0,0]),
            db:execute(NewRoleSql),
            {30,0,0,10001,0};
        [Max_cell,Equip_remain_time,Quick_times,Fashion_id,Fashion_time] ->
            {Max_cell,Equip_remain_time,Quick_times,Fashion_id,Fashion_time}
    end.

add_pray_equip(PrayGoods)->
	#pray_goods{
		pkey = Pkey,		
		key = 	Key,
		goods_id = GoodsId ,
		wash_attr = WashAttr,
		num = Num,
		state = State,
		gemstone_groove = GemstoneGroove
       
    } = PrayGoods,
	
	WashSttrsString = util:term_to_bitstring(WashAttr),
	GemstoneGrooveBin = util:term_to_bitstring(GemstoneGroove),
	
    SQL = io_lib:format("insert into pray_bag (`key` ,pkey ,goods_id,num ,state,wash_attr, gemstone_groove) values
    (~p,~p,~p,~p,~p,'~s','~s')",
        [Key,Pkey,GoodsId,Num,State,WashSttrsString , GemstoneGrooveBin]),
    db:execute(SQL).

dbdel_pray_equip(GoodsInfo) ->
    SQL = io_lib:format("DELETE FROM pray_bag where `key` = ~p",[GoodsInfo#pray_goods.key]),
    db:execute(SQL).

dbup_pray_fashid(StPRAY) ->
	SQL = io_lib:format("update pray_info set fashion_id = ~p ,fashion_time = ~p where pkey = ~p",[StPRAY#st_pray.fashion_id,StPRAY#st_pray.fashion_time,StPRAY#st_pray.pkey]),
    db:execute(SQL).

dbup_pray_equip_remain_time(StPRAY) ->
	SQL = io_lib:format("update pray_info set quick_times = ~p,equip_remain_time = ~p where pkey = ~p",[StPRAY#st_pray.quick_times,StPRAY#st_pray.equip_remain_time,StPRAY#st_pray.pkey]),
    db:execute(SQL).

update_pray_goods_state(PrayGoods)->
	SQL = io_lib:format("update pray_bag set state = ~p where `key` = ~p",[PrayGoods#pray_goods.state,PrayGoods#pray_goods.key]),
    db:execute(SQL).

dbup_pray_max_cell(StPRAY) ->
	SQL = io_lib:format("update pray_info set max_cell = ~p where pkey = ~p",[StPRAY#st_pray.cell_num,StPRAY#st_pray.pkey]),
    db:execute(SQL).

