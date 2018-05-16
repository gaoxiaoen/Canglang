%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_field_boss_rank
	%%% @Created : 2018-03-15 18:08:43
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_field_boss_rank).
-export([get/2]).
-include("common.hrl").
-include("field_boss.hrl").
get(35001,Rank) when 1 =< Rank andalso 1 >= Rank -> [{8001057,8},{2003000,20}];
get(35001,Rank) when 2 =< Rank andalso 2 >= Rank -> [{8001057,7},{2003000,15}];
get(35001,Rank) when 3 =< Rank andalso 3 >= Rank -> [{8001057,6},{2003000,12}];
get(35001,Rank) when 4 =< Rank andalso 10 >= Rank -> [{8001057,5},{2003000,10}];
get(35001,Rank) when 11 =< Rank andalso 20 >= Rank -> [{8001057,4},{2003000,8}];
get(35001,Rank) when 21 =< Rank andalso 50 >= Rank -> [{8001057,3},{2003000,6}];
get(35001,Rank) when 51 =< Rank andalso 100 >= Rank -> [{8001057,2},{2003000,4}];
get(35001,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{8001057,1},{2003000,2}];
get(35002,Rank) when 1 =< Rank andalso 1 >= Rank -> [{8001057,8},{2003000,20}];
get(35002,Rank) when 2 =< Rank andalso 2 >= Rank -> [{8001057,7},{2003000,15}];
get(35002,Rank) when 3 =< Rank andalso 3 >= Rank -> [{8001057,6},{2003000,12}];
get(35002,Rank) when 4 =< Rank andalso 10 >= Rank -> [{8001057,5},{2003000,10}];
get(35002,Rank) when 11 =< Rank andalso 20 >= Rank -> [{8001057,4},{2003000,8}];
get(35002,Rank) when 21 =< Rank andalso 50 >= Rank -> [{8001057,3},{2003000,6}];
get(35002,Rank) when 51 =< Rank andalso 100 >= Rank -> [{8001057,2},{2003000,4}];
get(35002,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{8001057,1},{2003000,2}];
get(35003,Rank) when 1 =< Rank andalso 1 >= Rank -> [{8001057,8},{2003000,20}];
get(35003,Rank) when 2 =< Rank andalso 2 >= Rank -> [{8001057,7},{2003000,15}];
get(35003,Rank) when 3 =< Rank andalso 3 >= Rank -> [{8001057,6},{2003000,12}];
get(35003,Rank) when 4 =< Rank andalso 10 >= Rank -> [{8001057,5},{2003000,10}];
get(35003,Rank) when 11 =< Rank andalso 20 >= Rank -> [{8001057,4},{2003000,8}];
get(35003,Rank) when 21 =< Rank andalso 50 >= Rank -> [{8001057,3},{2003000,6}];
get(35003,Rank) when 51 =< Rank andalso 100 >= Rank -> [{8001057,2},{2003000,4}];
get(35003,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{8001057,1},{2003000,2}];
get(35004,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405002,10},{7405003,6},{8001057,10}];
get(35004,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405002,8},{7405003,4},{8001057,8}];
get(35004,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405002,6},{7405003,3},{8001057,6}];
get(35004,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405002,5},{7405003,2},{8001057,4}];
get(35004,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405002,4},{7405003,1},{2003000,10}];
get(35004,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405002,3},{7405003,1},{2003000,8}];
get(35004,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405002,2},{7405003,1},{2003000,6}];
get(35004,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405002,1},{7405003,1},{2003000,4}];
get(35005,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405002,10},{7405003,6},{8001057,10}];
get(35005,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405002,8},{7405003,4},{8001057,8}];
get(35005,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405002,6},{7405003,3},{8001057,6}];
get(35005,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405002,5},{7405003,2},{8001057,4}];
get(35005,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405002,4},{7405003,1},{2003000,10}];
get(35005,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405002,3},{7405003,1},{2003000,8}];
get(35005,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405002,2},{7405003,1},{2003000,6}];
get(35005,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405002,1},{7405003,1},{2003000,4}];
get(35006,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405003,10},{7405004,6},{8001057,20}];
get(35006,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405003,8},{7405004,4},{8001057,16}];
get(35006,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405003,6},{7405004,3},{8001057,12}];
get(35006,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405003,5},{7405004,2},{8001057,10}];
get(35006,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405003,4},{7405004,1},{2003000,20}];
get(35006,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405003,3},{7405004,1},{2003000,16}];
get(35006,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405003,2},{7405004,1},{2003000,12}];
get(35006,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405003,1},{7405004,1},{2003000,10}];
get(35008,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405004,10},{7405005,6},{1015001,10}];
get(35008,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405004,8},{7405005,4},{1015001,8}];
get(35008,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405004,6},{7405005,3},{1015001,6}];
get(35008,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405004,5},{7405005,2},{1015001,4}];
get(35008,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405004,4},{7405005,1},{2003000,20}];
get(35008,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405004,3},{7405005,1},{2003000,16}];
get(35008,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405004,2},{7405005,1},{2003000,12}];
get(35008,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405004,1},{7405005,1},{2003000,10}];
get(35009,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405005,10},{7405006,6},{1015001,20}];
get(35009,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405005,8},{7405006,4},{1015001,16}];
get(35009,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405005,6},{7405006,3},{1015001,12}];
get(35009,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405005,5},{7405006,2},{1015001,10}];
get(35009,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405005,4},{7405006,1},{2003000,20}];
get(35009,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405005,3},{7405006,1},{2003000,16}];
get(35009,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405005,2},{7405006,1},{2003000,12}];
get(35009,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405005,1},{7405006,1},{2003000,10}];
get(35010,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405003,10},{7405004,6},{8001057,20}];
get(35010,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405003,8},{7405004,4},{8001057,16}];
get(35010,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405003,6},{7405004,3},{8001057,12}];
get(35010,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405003,5},{7405004,2},{8001057,10}];
get(35010,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405003,4},{7405004,1},{2003000,20}];
get(35010,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405003,3},{7405004,1},{2003000,16}];
get(35010,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405003,2},{7405004,1},{2003000,12}];
get(35010,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405003,1},{7405004,1},{2003000,10}];
get(35011,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405004,10},{7405005,6},{1015001,10}];
get(35011,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405004,8},{7405005,4},{1015001,8}];
get(35011,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405004,6},{7405005,3},{1015001,6}];
get(35011,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405004,5},{7405005,2},{1015001,4}];
get(35011,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405004,4},{7405005,1},{2003000,20}];
get(35011,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405004,3},{7405005,1},{2003000,16}];
get(35011,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405004,2},{7405005,1},{2003000,12}];
get(35011,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405004,1},{7405005,1},{2003000,10}];
get(35012,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405005,10},{7405006,6},{1015001,20}];
get(35012,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405005,8},{7405006,4},{1015001,16}];
get(35012,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405005,6},{7405006,3},{1015001,12}];
get(35012,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405005,5},{7405006,2},{1015001,10}];
get(35012,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405005,4},{7405006,1},{2003000,20}];
get(35012,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405005,3},{7405006,1},{2003000,16}];
get(35012,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405005,2},{7405006,1},{2003000,12}];
get(35012,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405005,1},{7405006,1},{2003000,10}];
get(35013,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405003,10},{7405004,6},{8001057,20}];
get(35013,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405003,8},{7405004,4},{8001057,16}];
get(35013,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405003,6},{7405004,3},{8001057,12}];
get(35013,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405003,5},{7405004,2},{8001057,10}];
get(35013,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405003,4},{7405004,1},{2003000,20}];
get(35013,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405003,3},{7405004,1},{2003000,16}];
get(35013,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405003,2},{7405004,1},{2003000,12}];
get(35013,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405003,1},{7405004,1},{2003000,10}];
get(35014,Rank) when 1 =< Rank andalso 1 >= Rank -> [{7405004,10},{7405005,6},{1015001,10}];
get(35014,Rank) when 2 =< Rank andalso 2 >= Rank -> [{7405004,8},{7405005,4},{1015001,8}];
get(35014,Rank) when 3 =< Rank andalso 3 >= Rank -> [{7405004,6},{7405005,3},{1015001,6}];
get(35014,Rank) when 4 =< Rank andalso 10 >= Rank -> [{7405004,5},{7405005,2},{1015001,4}];
get(35014,Rank) when 11 =< Rank andalso 20 >= Rank -> [{7405004,4},{7405005,1},{2003000,20}];
get(35014,Rank) when 21 =< Rank andalso 50 >= Rank -> [{7405004,3},{7405005,1},{2003000,16}];
get(35014,Rank) when 51 =< Rank andalso 100 >= Rank -> [{7405004,2},{7405005,1},{2003000,12}];
get(35014,Rank) when 101 =< Rank andalso 10000 >= Rank -> [{7405004,1},{7405005,1},{2003000,10}];
get(_,_) -> [].
