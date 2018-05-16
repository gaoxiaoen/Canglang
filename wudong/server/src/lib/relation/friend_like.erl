%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 三月 2016 15:16
%%%-------------------------------------------------------------------
-module(friend_like).
-author("and_me").

-include("common.hrl").
-include("server.hrl").
-include("relation.hrl").

%% API
-export([send_upgrade_info/1,
		 friend_upgrade/2,
	     like_add_award/2,
	     like/2,
	     times_reset/1]).

send_upgrade_info(Player)->
	case data_friend_like:get(Player#player.lv) of
		[] when Player#player.lv == 26->
			NewList = [#friend_like{pkey = 1,nickname = ?T("系统管理员"),career = 1,type = 2 ,data = 27}],
			lib_dict:put(?PROC_STATUS_FRIEND_LIKE,NewList),
			pack_friend_like_list(NewList,Player#player.sid),
			ok;
		[]->
			 ok;
		_->
			RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
			RelationsSt#st_relation.friends,
			[case misc:get_player_process(Relations#relation.pkey) of
				 undefined -> skip;
				 Pid -> erlang:send(Pid,{apply_state,{?MODULE,friend_upgrade,{Player#player.key,Player#player.nickname,Player#player.lv,Player#player.career}}})
			 end||Relations<-RelationsSt#st_relation.friends],
			ok
	end.


friend_upgrade(_,Player) when Player#player.lv > 45->
	ok;
friend_upgrade({FriendPkey,NickName,FriendLv,Career},Player)->
	List = lib_dict:get(?PROC_STATUS_FRIEND_LIKE),
	FriendLike =  #friend_like{pkey = FriendPkey,type = 1,career = Career,nickname = NickName,data = FriendLv},
	NewList = [FriendLike|List],
	lib_dict:put(?PROC_STATUS_FRIEND_LIKE,NewList),
	pack_friend_like_list(NewList,Player#player.sid),
	ok.

pack_friend_like_list(List0,Sid)->
	List = lists:sublist(List0,5),
	FriendList = [[FriendLike#friend_like.pkey,
		           FriendLike#friend_like.nickname,
		           FriendLike#friend_like.career,
				   FriendLike#friend_like.type,
				   FriendLike#friend_like.data]
			||FriendLike<-List],
	RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
	{ok,Bin} = pt_240:write(24010,{30 - RelationsSt#st_relation.like_times, 30,FriendList}),
    server_send:send_to_sid(Sid,Bin),
	ok.


like(0,Player)->
	Fun = fun(FriendLike,PlayerOut)->
			case data_friend_like:get(FriendLike#friend_like.data) of
				   [] ->
					   PlayerOut;
					BaseFriendLike->
						case misc:get_player_process(FriendLike#friend_like.pkey) of
							undefined -> skip;
							Pid -> erlang:send(Pid,{apply_state,{?MODULE,like_add_award,{Player#player.nickname,FriendLike#friend_like.data}}})
						end,
						RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
						if
							RelationsSt#st_relation.like_times < 30->
								lib_dict:put(?PROC_STATUS_RELATION,RelationsSt#st_relation{like_times = RelationsSt#st_relation.like_times + 1}),
								{ok,Player1} = goods:give_goods(PlayerOut,goods:make_give_goods_list(75,BaseFriendLike#base_friend_like.self_award)),
								[{_,Num}] = BaseFriendLike#base_friend_like.self_award,
								{ok,SelfBin} = pt_240:write(24013 ,{FriendLike#friend_like.nickname, 1, Num}),
								server_send:send_to_sid(Player#player.sid,SelfBin),
								Player1;
							true->
								{ok,SelfBin} = pt_240:write(24013 ,{FriendLike#friend_like.nickname, 1, 0}),
								server_send:send_to_sid(Player#player.sid,SelfBin),
								PlayerOut
						end
				end
		  end,
	NewPlayer = lists:foldl(Fun,Player,lib_dict:get(?PROC_STATUS_FRIEND_LIKE)),
	erlang:erase(?PROC_STATUS_FRIEND_LIKE),
	RelationsSt1 = lib_dict:get(?PROC_STATUS_RELATION),
	relation_load:update_friend_like(Player#player.key,RelationsSt1#st_relation.like_times,RelationsSt1#st_relation.self_like_times),
	pack_friend_like_list([],Player#player.sid),
	{ok,Bin} = pt_240:write(24011 ,{1}),
	server_send:send_to_sid(Player#player.sid,Bin),
	{ok,NewPlayer};

like(FriendPkey,Player)->
	List = lib_dict:get(?PROC_STATUS_FRIEND_LIKE),
	case lists:keytake(FriendPkey,#friend_like.pkey, List) of
		false->
			pack_friend_like_list(List,Player#player.sid),
			NewPlayer = Player,
			ErrorCode = 1,
			skip;
		{value,FriendLike,List11}->
			ErrorCode = 1,
			 case data_friend_like:get(FriendLike#friend_like.data) of
				 []->
					 NewPlayer = Player;
				 BaseFriendLike->
						case misc:get_player_process(FriendLike#friend_like.pkey) of
							undefined -> skip;
							Pid -> erlang:send(Pid,{apply_state,{?MODULE,like_add_award,{Player#player.nickname,FriendLike#friend_like.data}}})
						end,
						RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
						if
							RelationsSt#st_relation.like_times < 30->
								lib_dict:put(?PROC_STATUS_RELATION,RelationsSt#st_relation{like_times = RelationsSt#st_relation.like_times + 1}),
								relation_load:update_friend_like(Player#player.key,RelationsSt#st_relation.like_times + 1,RelationsSt#st_relation.self_like_times),
								{ok,NewPlayer} = goods:give_goods(Player,goods:make_give_goods_list(75,BaseFriendLike#base_friend_like.self_award)),
								[{_,Num}] = BaseFriendLike#base_friend_like.self_award,
								{ok,SelfBin} = pt_240:write(24013 ,{FriendLike#friend_like.nickname, 1, Num}),
								server_send:send_to_sid(Player#player.sid,SelfBin);
							true->
								{ok,SelfBin} = pt_240:write(24013 ,{FriendLike#friend_like.nickname, 1, 0}),
								server_send:send_to_sid(Player#player.sid,SelfBin),
								NewPlayer = Player
						end
			end,
			lib_dict:put(?PROC_STATUS_FRIEND_LIKE,List11),
			pack_friend_like_list(List11,Player#player.sid)
	end,
	{ok,Bin} = pt_240:write(24011 ,{ErrorCode}),
	server_send:send_to_sid(Player#player.sid,Bin),
	{ok,NewPlayer}.


like_add_award({NickName,Lv},Player)->
	RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
	if
		RelationsSt#st_relation.self_like_times < 50->
			lib_dict:put(?PROC_STATUS_RELATION,RelationsSt#st_relation{self_like_times = RelationsSt#st_relation.self_like_times + 1}),
			relation_load:update_friend_like(Player#player.key,RelationsSt#st_relation.like_times,RelationsSt#st_relation.self_like_times + 1),
			BaseFriendLike = data_friend_like:get(Lv),
			{ok,NewPlayer} = goods:give_goods(Player,goods:make_give_goods_list(76,BaseFriendLike#base_friend_like.other_award)),
			[{_,Num}] = BaseFriendLike#base_friend_like.other_award,
			{ok,Bin} = pt_240:write(24012 ,{NickName, 1, Num}),
			server_send:send_to_sid(Player#player.sid,Bin),
			{ok,NewPlayer};
		true->
			ok
	end.

times_reset(Player)->
	RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
	if
		RelationsSt#st_relation.like_times =/=0 orelse RelationsSt#st_relation.self_like_times =/=0->
			lib_dict:put(?PROC_STATUS_RELATION,RelationsSt#st_relation{like_times = 0,self_like_times = 0}),
			relation_load:update_friend_like(Player#player.key,0,0);
		true->
			skip
	end.




