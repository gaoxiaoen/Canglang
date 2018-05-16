%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 三月 2016 18:33
%%%-------------------------------------------------------------------
-module(return).
-author("and_me").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
%% API
-export([goods_return/0]).

-compile(export_all).




goods_return()->
  db:execute("DELETE from cron_return"),
  db:execute("DELETE from mail"),
  db:execute("DELETE from market"),
  %%低等级段物品全删了
  LowLevelPkeyList = db:get_all("SELECT pkey,career FROM player_state where lv < 45"),
  Fun1 = fun([PkeyBin,_Career])->
			db:execute(io_lib:format("DELETE from goods WHERE pkey = ~p",[PkeyBin])),
            db:execute(io_lib:format("delete from player_skill where pkey = ~p",[PkeyBin]))
	end,
  lists:foreach(Fun1,LowLevelPkeyList),

  PkeyList = db:get_all("SELECT pkey,career,lv FROM player_state"),
  Fun = fun([PkeyBin,Career,Lv])->
			Pkey =  binary_to_list(PkeyBin),
			PlayerSQL= io_lib:format("select accname ,logout_time from player_login where pkey = ~p limit 1", [Pkey]),
			[_Accname,LogoutTime] = db:get_row(PlayerSQL), %%获得最后登陆时间
			IsProcess  = db:get_row(io_lib:format("SELECT * FROM cron_return where pkey =  ~p",[Pkey])),
	        %%没有被处理过
			case IsProcess == [] andalso (Lv >=45 orelse LogoutTime >= 1454860800)  of
			  true ->
				GoodsInfoList = lists:foldl(fun goods_info_init/2,[],goods_load:load_player_goods(Pkey)),
				{EquipLvG,GemG,WashG,StrenG}= goods_return(GoodsInfoList,{[],[],[],[]}),
				mail:sys_send_mail([Pkey], ?T("玩家等级补偿"), ?T("等级补偿"), [#give_goods{goods_id = 10106,num = get_add_money(Lv)},#give_goods{goods_id = 10109,num = get_add_coin(Lv)}]),
				mail:sys_send_mail([Pkey], ?T("强化补偿"), ?T("等级补偿"), merge_recently_goods(StrenG)),
				mail:sys_send_mail([Pkey], ?T("洗练补偿"), ?T("洗练补偿"), merge_recently_goods(WashG)),
				mail:sys_send_mail([Pkey], ?T("宝石补偿"), ?T("洗练补偿"), merge_recently_goods(GemG)),
				mail:sys_send_mail([Pkey], ?T("装备升级补偿"), ?T("装备升级补偿"), merge_recently_goods(EquipLvG)),
				mail:sys_send_mail([Pkey], ?T("新装备获得"), ?T("原装备取消，获得一套新的11级装备"), merge_recently_goods(get_equip_list(Career))),
				reset_skill(Pkey),
				?PRINT("Pkey ~p give goods ok ~n",[Pkey]),
				db:execute(io_lib:format("insert cron_return set pkey = ~p",[Pkey])),
				ok;
			  _->
				skip
			end
		end,
	lists:foreach(Fun,PkeyList),
%%  List11 = division(PkeyList,20),
%%  ?PRINT("all num ~p ~n",[length(PkeyList)]),
%%  ?PRINT("start  spawn ~p ~n",[length(List11)]),
%%  [spawn(fun()->
%%			erlang:put(debug_t1111,true),
%%			lists:foreach(Fun,L),
%%			erlang:erase(debug_t1111)
%%		 end)||L<-List11],

  ok.

division(List,Num)->
  Length  = length(List),
  Add = trunc(Length / Num),
  division1(List,1,Add,length(List),[]).

division1(List,Nth,Add,Length,Out)->
  if
	Nth + Add > Length->
	  [lists:sublist(List,Nth,Add)|Out];
	true->
	  division1(List,Nth + Add,Add,Length,[lists:sublist(List,Nth,Add)|Out])
end.

goods_return([],ReturnGoods)->
  ReturnGoods;
goods_return([Goods|Left],ReturnGoods)->
  case data_goods_old:get(Goods#goods.goods_id) of
	GoodsTypeInfo when Goods#goods.cell >0 andalso GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_EQUIP-> %%穿在身上的装备补偿
	  goods_load:dbdel_goods(Goods),
	  {LvG,GemG,WashG,StrenG} = ReturnGoods,
	  NewReturnGoods = {
		level_return(GoodsTypeInfo#goods_type.equip_lv) ++LvG,
		gem_return(Goods#goods.gemstone_groove) ++ GemG,
		wash_return(Goods#goods.wash_attr,GoodsTypeInfo) ++ WashG,
		[{10109,stren_return(Goods#goods.stren)}|StrenG]
	  },
	  goods_return(Left,NewReturnGoods);
	GoodsTypeInfo when GoodsTypeInfo#goods_type.type == ?GOODS_TYPE_EQUIP-> %%没穿在身上的装备直接删除
	  goods_load:dbdel_goods(Goods),
	  goods_return(Left,ReturnGoods);
	_->
	  goods_return(Left,ReturnGoods)
  end.


get_add_money(Lv) when Lv <45->
  2000;
get_add_money(Lv) when Lv >= 45 andalso Lv =< 52->
  5000;
get_add_money(Lv) when Lv >= 53 andalso Lv =< 60->
  10000;
get_add_money(Lv) when Lv >= 61 andalso Lv =< 68->
  15000;
get_add_money(Lv) when Lv >=69->
  20000.

get_equip_list(Career)->
  get_weapon(Career) ++ [{30092,1},{30102,1},{30112,1},{30122,1},{30132,1},{30142,1},{30152,1},{30162,1}].

get_weapon(1)->
  [{30012,1},{30022,1}];
get_weapon(2)->
  [{30032,1},{30042,1}];
get_weapon(3)->
  [{30052,1},{30062,1}];
get_weapon(4)->
  [{30072,1},{30082,1}].

level_return(Lv) when Lv < 45 ->
  [];
level_return(Lv) when Lv >= 45 andalso Lv =< 52 ->
  [{28102,13},{28122,13},{28150,26}];

level_return(Lv) when Lv >= 53 andalso Lv =< 60 ->
  [{28102,26},{28122,26},{28150,52}];
level_return(Lv) when Lv >= 61->
  [{28102,63},{28122,63},{28150,126}].

gem_return(GemList)->
  Fun = fun({_,GoodsId},Out)->
	case data_goods:get(GoodsId) of
	  GoodsType when is_record(GoodsType,goods_type)->
		[{ GoodsId,1}|Out];
	  _ when GoodsId == 0->
		Out;
	  _->
		?PRINT("gem_return error ~p ~n",[GoodsId])
	end
		end,
  lists:foldl(Fun,[],GemList).

stren_return(Stren)->
	if
	  Stren == 0->0;
	  Stren >= 1 andalso Stren =< 3-> 410000;
	  Stren >= 4 andalso Stren =< 6-> 830000;
	  Stren >= 7 andalso Stren =< 9-> 1660000;
	  Stren >= 10 andalso Stren =< 12-> 4000000;
	  true-> 10000000
	end.

get_add_coin(Stren)->
  if
	Stren < 45->500000;
	Stren >= 45 andalso Stren =< 52-> 2260000;
	Stren >= 53 andalso Stren =< 60-> 3500000;
	Stren >= 61 andalso Stren =< 68-> 6000000;
	true-> 10000000
  end.


wash_return(WashList,GoodsType)->
  Lv = GoodsType#goods_type.equip_lv,
  Fun = fun({Type,Value},Out)->
		  Color = data_wash_colour:get(Type,Lv,Value),
		  case {Lv,Color} of
			  _ when Lv < 45 andalso Color == 1->
				  [{28000,1}|Out];
			_ when Lv < 45 andalso Color == 2->
			  [{28000,2}|Out];
			_ when Lv < 45 andalso Color >= 3->
			  [{28000,5}|Out];
			_ when Lv >= 45 andalso Lv =< 52 andalso Color == 1->
			  [{28000,1}|Out];
			_ when Lv >= 45 andalso Lv =< 52 andalso Color == 2->
			  [{28000,2}|Out];
			_ when Lv >= 45 andalso Lv =< 52 andalso Color >= 3->
			  [{28000,5}|Out];
			_ when  Lv >= 53 andalso Lv =< 60 andalso Color == 1->
			  [{28000,1}|Out];
			_ when  Lv >= 53 andalso Lv =< 60 andalso Color == 2->
			  [{28000,4}|Out];
			_ when  Lv >= 53 andalso Lv =< 60 andalso Color >=3 ->
			  [{28000,10}|Out];
			_ when Lv >= 61 andalso Color == 1->
			  [{28000,1}|Out];
			_ when Lv >= 61 andalso Color == 2->
			  [{28000,7}|Out];
			_ when Lv >= 61 andalso Color >=3 ->
			  [{28000,17}|Out];
              Other->
				 io:format(" wash_return ~p ~n",[Other])
		  end
       end,
lists:foldl(Fun,[],WashList).



goods_info_init([Gkey ,Pkey ,GoodsId,Location ,Cell ,Num ,Bind  ,Expiretime ,GoodsLv ,Star,Stren ,Color,Wash_luck_value,WashAttrs,GemstoneGroove,TotalAttrs,CombatPower],PlayerGoods)->
  case catch data_goods_old:get(GoodsId) of
	GoodsTypeInfo when is_record(GoodsTypeInfo, goods_type) ->
	  GemstoneGrooveList = util:bitstring_to_term(GemstoneGroove),
	  WashAttrsList = util:bitstring_to_term(WashAttrs),
	  TotalAttrsList = util:bitstring_to_term(TotalAttrs),
	  GoodsInfo0 = #goods{key = binary_to_list(Gkey),pkey = binary_to_list(Pkey), goods_id = GoodsId,location = Location,cell = Cell,num = Num,
		bind = Bind,expire_time = Expiretime ,goods_lv = GoodsLv,star = Star, stren = Stren,color = Color,wash_luck_value = Wash_luck_value, gemstone_groove = GemstoneGrooveList,
		total_attrs = TotalAttrsList,wash_attr = WashAttrsList,combat_power = CombatPower
	  },
	  [GoodsInfo0|PlayerGoods];
	_->
	  ?PRINT("GoodsId ~p not exist ~n",[GoodsId]),
	  PlayerGoods
  end.

merge_recently_goods(GoodsList)->
  merge_recently_goods([],GoodsList).

merge_recently_goods(GoodsList,[])->
  [#give_goods{goods_id = GoodsId,num = Num }||{GoodsId,Num}<-GoodsList,Num >0];

merge_recently_goods(GoodsList,[{GoodsId,Num}|L])->
  case lists:keytake(GoodsId,1,GoodsList) of
	false->
	  merge_recently_goods([{GoodsId,Num}|GoodsList],L);
	{value,{GoodsId,OldNum},L1}->
	  merge_recently_goods([{GoodsId,Num + OldNum}|L1],L)
  end.



reset_skill(Pkey) ->
    SkillInfo = db:get_row(io_lib:format("select skills from player_skill where pkey = ~p",[Pkey])),
    case SkillInfo of
        [] -> skip;
        [Skills|_] ->
             SkillList = util:bitstring_to_term(Skills),
            SkillList2 = [{Sid,1,State}|| {Sid,_slv,State}<- SkillList],
            db:execute(io_lib:format("update player_skill set skills = '~s' where pkey = ~p",[util:term_to_bitstring(SkillList2),Pkey]))
    end.

