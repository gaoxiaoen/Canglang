%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午5:38
%%%-------------------------------------------------------------------
-module(goods_dict).
-author("fancy").
-include("common.hrl").
-include("goods.hrl").

%% API
-export([
    update_goods/2 ,
    del_dict_goods/2 ,
    get_list/2,
	dict_to_list/1
]).


%% if have when ,can be a condition use.
update_goods(GoodsList, GoodsSt) when is_record(GoodsSt, st_goods) andalso is_list(GoodsList) ->
	F = fun(GoodsInfo,AccGoodsSt) ->
            update_goods(GoodsInfo,AccGoodsSt)
        end,
    lists:foldl(F,GoodsSt,GoodsList);

update_goods(GoodsInfo, GoodsSt) when is_record(GoodsSt, st_goods)->
	Newdict = update_goods(GoodsInfo,GoodsSt#st_goods.dict),
	%?PRINT("update_goods ~p ~n ~p ~n ~p ~n",[goods_dict:dict_to_list(GoodsSt#st_goods.dict),GoodsInfo,[{Goods#goods.goods_id,Goods#goods.key}||Goods<-goods_dict:dict_to_list(Newdict)]]),
	GoodsSt#st_goods{dict = Newdict};

%%更新物品信息
update_goods([],GoodsDict)->
	GoodsDict;

%%更新物品信息
update_goods(GoodsInfoList,GoodsDict)  when is_list(GoodsInfoList)->
    F = fun(GoodsInfo,AccDict) ->
            update_goods(GoodsInfo,AccDict)
        end,
    lists:foldl(F,GoodsDict,GoodsInfoList);


%% 更新dict中的物品，无则添加，有则更新
update_goods(GoodsInfo, GoodsDict) when is_record(GoodsInfo,goods) ->
	Key = GoodsInfo#goods.key,
    case dict:is_key(Key, GoodsDict) of
		_ when GoodsInfo#goods.num =< 0->%%删除
			dict:erase(Key,GoodsDict);
        true -> %% 更新
            NewGoodsDict = dict:erase(Key, GoodsDict),
            dict:append(Key, GoodsInfo, NewGoodsDict);
        false ->
            dict:append(Key, GoodsInfo, GoodsDict)
    end;

update_goods(_GoodsInfo, GoodsDict) ->
   GoodsDict.

%%删除物品
del_dict_goods(#goods{key = Key} = _GoodsInfo ,GoodsDict) ->
    case dict:is_key(Key,GoodsDict) of
        true ->
            dict:erase(Key,GoodsDict);
        false ->
            GoodsDict
    end.

dict_to_list(Dict)->
	get_list(dict:to_list(Dict),[]).

%% @doc 取出列表,从dict取
get_list([], L) ->
    L;
get_list([{_Key, List} | T], L) ->
    get_list(T, List ++ L).