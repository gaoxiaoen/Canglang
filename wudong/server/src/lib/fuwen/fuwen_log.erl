%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 处理符文升级相关日志
%%% @end
%%% Created : 18. 八月 2017 18:13
%%%-------------------------------------------------------------------
-module(fuwen_log).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("fuwen.hrl").

%% API
-export([upgrade/2, resolved/4, put_on/3]).

get_color(1) -> "白色";
get_color(2) -> "蓝色";
get_color(3) -> "紫色";
get_color(4) -> "橙色";
get_color(5) -> "红色";
get_color(_) -> "白色".

upgrade(Fuwen, Player) ->
    #goods{
        pkey = Pkey,
        key = Key,
        goods_id = GoodsId,
        color = Color,
        goods_lv = GoodsLv
    } = Fuwen,
    ColorDesc = get_color(Color),
    LvDesc = io_lib:format("~p级", [GoodsLv]),
    FuwenDesc =  ?T(ColorDesc ++ LvDesc),
    NickName = Player#player.nickname,
    Sql = io_lib:format("replace into log_fuwen_upgrade set pkey=~p, nickname='~s', fuwen_desc='~s', fuwen_key=~p,goods_id=~p,color=~p,lv=~p,time=~p",
        [Pkey, NickName, FuwenDesc, Key, GoodsId, Color, GoodsLv, util:unixtime()]),
%%     db:execute(Sql).
    log_proc:log(Sql).

resolved(Fuwen, AddExp, AddBestExp, Player) ->
    #goods{
        pkey = Pkey,
        key = Key,
        goods_id = GoodsId,
        color = Color,
        goods_lv = GoodsLv
    } = Fuwen,
    ColorDesc = get_color(Color),
    LvDesc = io_lib:format("~p级", [GoodsLv]),
    FuwenDesc =  ?T(ColorDesc ++ LvDesc),
    NickName = Player#player.nickname,
    Sql = io_lib:format("replace into log_fuwen_resolved set pkey=~p, nickname='~s', fuwen_desc='~s', fuwen_key=~p,goods_id=~p,color=~p,goods_lv=~p,exp=~p,best_exp=~p, time=~p",
        [Pkey, NickName, FuwenDesc, Key, GoodsId, Color, GoodsLv, AddExp, AddBestExp, util:unixtime()]),
%%     db:execute(Sql).
    log_proc:log(Sql).

put_on(OldFuwen, NewFuwen, Player) ->
    #goods{
        pkey = Pkey,
        cell = OldCell,
        key = FuwenKey,
        goods_id = GoodsId,
        color = Color,
        goods_lv = OldGoodsLv
    } = OldFuwen,
    #goods{
        pkey = Pkey,
        cell = NewCell,
        goods_lv = NewGoodsLv
    } = NewFuwen,
    ColorDesc = get_color(Color),
    OldLvDesc = io_lib:format("~p级", [OldGoodsLv]),
    OldFuwenDesc =  ?T(ColorDesc ++ OldLvDesc),

    NewLvDesc = io_lib:format("~p级", [NewGoodsLv]),
    NewFuwenDesc =  ?T(ColorDesc ++ NewLvDesc),
    NickName = Player#player.nickname,
    Sql = io_lib:format("replace into log_fuwen_put_on set pkey=~p, nickname='~s', old_fuwen_desc='~s', new_fuwen_desc='~s', fuwen_key=~p,goods_id=~p,color=~p,old_lv=~p,new_lv=~p,time=~p,old_pos=~p,new_pos=~p",
        [Pkey, NickName, OldFuwenDesc, NewFuwenDesc, FuwenKey, GoodsId, Color, OldGoodsLv, NewGoodsLv, util:unixtime(), OldCell, NewCell]),
    log_proc:log(Sql).