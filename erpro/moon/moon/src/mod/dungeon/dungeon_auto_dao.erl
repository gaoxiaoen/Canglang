%%----------------------------------------------------
%% 副本扫荡信息存储
%% @author wangweibiao
%%----------------------------------------------------
-module(dungeon_auto_dao).
-export([
		load_info/0,
        insert_info/1,
        update_info/2,
		delete_info/1
        % ,

		% load_reward/0,
		% insert_reward/1,
		% delete_reward/1
		]).
-include("achievement.hrl").
-include("common.hrl").
-include("role.hrl").

load_info() ->
    % Sql = "select rid, srv_id, dungeon_id, count, cur_count, time, is_stop, rewards from sys_dungeon_auto_info",
    % case db:get_all(Sql, []) of
    %     {ok, Data} ->
    %         % ?DEBUG("----Dungeon--Clear---Data---:~w~n",[Data]),
    %         do_format(to_dungeon_clear, Data),            
    %         ok;
    %     {error, undefined} -> 
    %         false;
    %     _ ->
    %         false
    % end.
    ok.

insert_info({Rid, SrvId, DungeonId, Count, Cur_Count, Start_Time, Is_Stop, Rewards}) ->
	Sql = "insert into sys_dungeon_auto_info (rid, srv_id, dungeon_id, count, cur_count, time, is_stop, rewards) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
	db:execute(Sql, [Rid, SrvId, DungeonId, Count, Cur_Count, Start_Time, Is_Stop, util:term_to_string(Rewards)]).

update_info(rest_count, {Rid, Cur_Count}) ->
	Sql = "update sys_dungeon_auto_info set cur_count = ~s where rid = ~s",
    db:execute(Sql, [Cur_Count, Rid]);

update_info(stop_clear, {Rid, Is_Stop}) ->
    Sql = "update sys_dungeon_auto_info set is_stop = ~s where rid = ~s",
    db:execute(Sql, [Is_Stop, Rid]).


delete_info(Rid) ->
	Sql = "delete from sys_dungeon_auto_info where rid = ~s",
    db:execute(Sql, [Rid]).


% load_reward() ->
%     Sql = "select rid,value from sys_dungeon_auto_reward",
%     case db:get_all(Sql, []) of
%         {ok, Data} ->
%             % ?DEBUG("-----Dungeon--Rewards--Data---:~w~n",[Data]),
%             do_format(to_dungeon_auto_reward, Data),            
%             ok;
%         {error, undefined} -> 
%             false;
%         _ ->
%             false
%     end.

% insert_reward({Rid, Value}) ->
% 	Sql = "replace into sys_dungeon_auto_reward (rid, value) values(~s, ~s)",
%     db:execute(Sql, [Rid, util:term_to_string(Value)]).

% delete_reward(Rid) ->
% 	Sql = "delete from sys_dungeon_auto_reward where rid = ~s",
%     db:execute(Sql, [Rid]).




%%------------------------------------------------------------------
%% 内部方法
%%------------------------------------------------------------------

%% 执行数据转换
% do_format(to_dungeon_clear, []) -> ok;
% do_format(to_dungeon_clear, [[Rid, SrvId, DungeonId, Count, Cur_Count, Start_Time, Is_Stop, Rewards]| T]) ->

%     {ok, Val} = util:bitstring_to_term(Rewards),
%     % dungeon_auto_mgr:insert_reward({Rid, Val}),

%     dungeon_auto_mgr:insert_info({Rid, SrvId, DungeonId, Count, Cur_Count, Start_Time, Is_Stop}),
%     do_format(to_dungeon_clear, T).

% do_format(to_dungeon_auto_reward, []) -> ok;
% do_format(to_dungeon_auto_reward, [[Rid, Value] | T]) ->
% 	{ok, Val} = util:bitstring_to_term(Value),
%     dungeon_auto_mgr:insert_reward({Rid, Val}),
%     do_format(to_dungeon_auto_reward, T).
