%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 15:23
%%%-------------------------------------------------------------------
-module(taobao_init).
-author("and_me").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("taobao.hrl").

%% API
-export([init/1,times_reset/1]).


init(Player) ->
  GoodsDict = goods_dict_init(Player),
  GoodsStatus = #st_goods{
	key = Player#player.key,
	sid = Player#player.sid,
	max_cell = 60,
	leftover_cell_num = 60 - dict:size(GoodsDict),
	dict = GoodsDict},
  lib_dict:put(?PROC_STATUS_TAOBAO_BAG,GoodsStatus),
  TaoBaoInfo = taobao_info(Player),
  lib_dict:put(?PROC_STATUS_TAOBAO_INFO,TaoBaoInfo),
  Player.


goods_dict_init(Player)->
  GoodsDict = dict:new(),
  case player_util:is_new_role(Player) of
	  false->
		  case taobao_load:load_player_goods(Player#player.key) of
			[] ->
			  GoodsDict;
			GoodsList when is_list(GoodsList) ->
			  PlayerGoods =  lists:foldl(fun goods_info_init/2,[],GoodsList),
			  goods_dict:update_goods(PlayerGoods,GoodsDict)
		  end;
	  _->
		  GoodsDict
  end.



goods_info_init([Gkey ,Pkey ,GoodsId,Location ,Cell ,Num ,Bind  ,Expiretime ,GoodsLv ,Star,Stren ,Color,Wash_luck_value,WashAttrs,GemstoneGroove,TotalAttrs,CombatPower],PlayerGoods)->
  case data_goods:get(GoodsId) of
      [] ->
          PlayerGoods;
	_GoodsTypeInfo ->
	  GemstoneGrooveList = util:bitstring_to_term(GemstoneGroove),
	  WashAttrsList = util:bitstring_to_term(WashAttrs),
	  TotalAttrsList = util:bitstring_to_term(TotalAttrs),
	  GoodsInfo0 = #goods{key = Gkey,pkey = Pkey, goods_id = GoodsId,location = Location,cell = Cell,num = Num,
		bind = Bind,expire_time = Expiretime ,goods_lv = GoodsLv,star = Star, stren = Stren,color = Color,wash_luck_value = Wash_luck_value, gemstone_groove = GemstoneGrooveList,
		total_attrs = TotalAttrsList,wash_attr = WashAttrsList,combat_power = CombatPower
	  },
	  [GoodsInfo0|PlayerGoods]
  end.

taobao_info(Player)->
  case taobao_load:load_taobao_info(Player) of
	[] -> 	  %%新玩家
	  {TimesList,RefreshList} = taobao_refresh_times_init([],[],false),
	  NewRoleSql = io_lib:format("insert into taobao_info set pkey = ~p,luck_value=~p,times = '~s',refresh_times = '~s',recently_goods = '[]'", [Player#player.key,0,util:term_to_bitstring(TimesList),util:term_to_bitstring(RefreshList)]),
	  db:execute(NewRoleSql),
	  #taobao_info{pkey = Player#player.key,times = TimesList,refresh_times = RefreshList};
	[LuckValue,Times,RefreshTime,RecentlyGoods] ->
    Now = util:unixtime(),
    IsSameDay = util:is_same_date(Player#player.logout_time,Now),
    {NewTimesList,NewRefreshTimeList} = taobao_refresh_times_init(util:bitstring_to_term(Times),util:bitstring_to_term(RefreshTime),IsSameDay),
	  #taobao_info{pkey = Player#player.key,luck_value = LuckValue,times = NewTimesList,refresh_times = NewRefreshTimeList,recently_goods = util:bitstring_to_term(RecentlyGoods)}
  end.

times_reset(Player)->
  Binfo = lib_dict:get(?PROC_STATUS_TAOBAO_INFO),
  {NewTimesList,NewRefreshTimeList} = taobao_refresh_times_init(Binfo#taobao_info.times,Binfo#taobao_info.refresh_times,false),
  NewBinfo = Binfo#taobao_info{times = NewTimesList,refresh_times = NewRefreshTimeList},
  lib_dict:put(?PROC_STATUS_TAOBAO_INFO,NewBinfo),
  taobao_load:updata_taobao_info_times(NewBinfo,Player#player.key),
  ok.


taobao_refresh_times_init(TimesList,RefreshTimeList,IsSameDay)->
  Fun = fun(Type,{T,R})->
		  Config = data_taobao_config:get(Type),
		  case lists:keyfind(Type,1,TimesList)of
			false->
			  NewT = [{Type,Config#base_taobao_config.max_times}|T];
			_  when IsSameDay == false ->
			  NewT = [{Type,Config#base_taobao_config.max_times}|T];
			{Type,Times}->
			  NewT = [{Type,Times}|T]
		  end,
		  case lists:keyfind(Type,1,RefreshTimeList)of
			    false when Type == 2->
				  NewR = [{Type,util:unixtime() + 6*3600}|R];
				false when Type == 3->
					NewR = [{Type,util:unixtime() + 48*3600}|R];
			false->
			  NewR = [{Type,util:unixtime()}|R];
			{Type,RTimes} ->
			  NewR = [{Type,RTimes}|R]
		  end,
		  {NewT,NewR}
		end,
  lists:foldl(Fun,{[],[]},data_taobao_config:get_all_type()).





