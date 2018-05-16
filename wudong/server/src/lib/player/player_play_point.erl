%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%     %%玩家AI镜像处理
%%% @end
%%% Created : 13. 十一月 2015 14:38
%%%-------------------------------------------------------------------
-module(player_play_point).
-author("hxming").
-include("server.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    init/1,
	pack_play_point_list/2,
	play_point_times/2
]).

init(_Player)->
	Template = data_play_point:get_all(),
	lib_dict:put(?PROC_STATUS_PLAY_POINT,Template),
	ok.

pack_play_point_list(List,Sid)->
	NewList = [[PlayPoint#play_point.type,PlayPoint#play_point.sub_id,PlayPoint#play_point.current_times,PlayPoint#play_point.max_times]
			  ||PlayPoint<-List],
	{ok,Bin} = pt_130:write(13005,{NewList}),	
	server_send:send_to_sid(Sid,Bin).




play_point_times(Type,Times)->
	case lists:keytake(Type, #play_point.type, lib_dict:get(?PROC_STATUS_PLAY_POINT)) of
		{value,PlayPoint,List1}->
			NewList = [PlayPoint#play_point{current_times = Times}|List1],
			lib_dict:put(?PROC_STATUS_PLAY_POINT,NewList);
		_->
			?ERR("play_point_times Type ~p  ~n",[Type])
	end.
			