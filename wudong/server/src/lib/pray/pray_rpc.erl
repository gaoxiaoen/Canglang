%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 一月 2015 14:04
%%%-------------------------------------------------------------------
-module(pray_rpc).
-include("common.hrl").
-include("server.hrl").
-include("pray.hrl").

%% API
-export([
    handle/3
]).

%%%%获取倒计时
%%handle(14000,Player,_) ->
%%    %Time = pray_init:loop(Player),
%%	%?PRINT("14000  ~n",[]),
%%	StPray = lib_dict:get(?PROC_STATUS_PRAY),
%%	Now = util:unixtime(),
%%	EquipRemainRime = ?IF_ELSE(StPray#st_pray.equip_remain_time - Now >0,StPray#st_pray.equip_remain_time - Now,0),
%%	{ok,Bin} = pt_140:write(14000,{EquipRemainRime}),
%%    server_send:send_to_sid(Player#player.sid,Bin),
%%	ok;
%%
%%%%获取祈祷信息
%%handle(14001,Player,_) ->
%%    StPray = lib_dict:get(?PROC_STATUS_PRAY),
%%	if
%%		StPray#st_pray.equip_remain_time =:= 0 andalso StPray#st_pray.bag_list =:= []->
%%			case pray_init:init_pray_bag(Player,0,StPray#st_pray.fashion_id,StPray#st_pray.fashion_time, StPray#st_pray.left_cell_num) of
%%					{[],0,undefined}->
%%						NewStPRAY = StPray;
%%					{GoodsList,EquipRemainTime,TimerRef}->
%%						NewStPRAY = StPray#st_pray{
%%									   timerRef = TimerRef,
%%									   left_cell_num = StPray#st_pray.cell_num - length(GoodsList),
%%									   bag_list = GoodsList,
%%									   equip_remain_time = EquipRemainTime},
%%						put(?PROC_STATUS_PRAY,NewStPRAY)
%%			end;
%%		true->
%%			NewStPRAY = StPray
%%	end,
%%    pray_pack:send_pray_info(NewStPRAY,Player),
%%	ok;
%%
%%%%提取祈祷装备
%%handle(14002,Player,_) ->
%%    case catch pray:extract(Player) of
%%		ok->
%%			{ok,Bin} = pt_140:write(14002,{1}),
%%    		server_send:send_to_sid(Player#player.sid,Bin),
%%			handle(14000,Player,0);
%%		{_,ErrorCode}->
%%			{ok,Bin} = pt_140:write(14002,{ErrorCode}),
%%    		server_send:send_to_sid(Player#player.sid,Bin);
%%		Other->
%%			?PRINT("Other ~p ~n",[Other]),
%%			{ok,Bin} = pt_140:write(14002,{0}),
%%    		server_send:send_to_sid(Player#player.sid,Bin)
%%	end,
%%	ok;
%%
%%%%快速祈祷
%%handle(14003 ,Player,_) ->
%%	case catch pray:quick_pray(Player) of
%%		{ok,NewPlayer}->
%%			{ok,Bin} = pt_140:write(14003,{1}),
%%    		server_send:send_to_sid(Player#player.sid,Bin),
%%			{ok,NewPlayer};
%%		{false,Code}->
%%			{ok,Bin} = pt_140:write(14003,{Code}),
%%    		server_send:send_to_sid(Player#player.sid,Bin),
%%			ok
%%	end;
%%
%%%%购买时装
%%handle(14004 ,Player,_) ->
%%	case catch pray:buy_fashion(Player) of
%%		{ok,NewPlayer}->
%%			{ok,Bin} = pt_140:write(14004,{1}),
%%    		server_send:send_to_sid(Player#player.sid,Bin),
%%			{ok,NewPlayer};
%%		{false,Code}->
%%			?PRINT(" 14004 ~p~n",[Code]),
%%			{ok,Bin} = pt_140:write(14004,{Code}),
%%    		server_send:send_to_sid(Player#player.sid,Bin),
%%			ok
%%	end;
%%
%%%%开格子
%%handle(14005 ,Player,{Cell}) ->
%%	case catch pray:open_cell(Player,Cell) of
%%		{ok,NewPlayer}->
%%			{ok,Bin} = pt_140:write(14005,{1}),
%%    		server_send:send_to_sid(Player#player.sid,Bin),
%%			{ok,NewPlayer};
%%		{false,Code}->
%%			?PRINT(" 14005 ~p~n",[Code]),
%%			{ok,Bin} = pt_140:write(14005,{Code}),
%%    		server_send:send_to_sid(Player#player.sid,Bin),
%%			ok
%%	end;

%
handle(_Cmd,_Player,_Data)->
	ok.
