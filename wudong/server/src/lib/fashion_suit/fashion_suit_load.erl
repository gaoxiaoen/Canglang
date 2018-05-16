%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(fashion_suit_load).
-author("lzx").
-include("fashion_suit.hrl").
-include("server.hrl").

%% API
-export([
    load_fashion_suit/1,
    replace_fashion_suit/1
]).

%% 加载宝宝数据
load_fashion_suit(PKey) ->
    Sql = io_lib:format("select ac_suit_ids,fashion_act_suit_ids from fashion_suit where pkey=~p limit 1", [PKey]),
    db:get_row(Sql).


replace_fashion_suit(StFashionSuit) ->
    Sql = io_lib:format("replace into fashion_suit set pkey=~p,ac_suit_ids='~s',fashion_act_suit_ids='~s'",
        [
            StFashionSuit#st_fashion_suit.pkey,
            util:term_to_bitstring(StFashionSuit#st_fashion_suit.fashion_suit_ids),
            util:term_to_bitstring(StFashionSuit#st_fashion_suit.fashion_act_suit_ids)
        ]
    ),
    db:execute(Sql).


