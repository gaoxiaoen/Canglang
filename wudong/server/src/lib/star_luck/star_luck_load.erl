%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 下午3:39
%%%-------------------------------------------------------------------
-module(star_luck_load).
-author("fengzhenlin").
-include("server.hrl").
-include("star_luck.hrl").

%% API
-export([
    dbget_star_luck_info/1,
    dbup_star_luck_info/1,
    dbup_star_luck_goods/2,
    dbdel_star_luck_goods/2
]).

dbget_star_luck_info(Player) ->
    #player{key = Pkey} = Player,
    NewSt = #st_star_luck{
        pkey = Pkey,
        dict = dict:new()
    },
    case player_util:is_new_role(Player) of
        true -> NewSt;
        false ->
            Sql = io_lib:format("select free_times, update_time, star_pos, open_bag_num,double_times from player_star_luck where pkey = ~p",
                [Pkey]),
            case db:get_row(Sql) of
                [] -> NewSt;
                [FreeTimes, UpdateTime, StarPosBin, OpenBagNum, DoubleTimes] ->
                    StStarLuck = #st_star_luck{
                        pkey = Pkey,
                        free_times = FreeTimes,
                        update_time = UpdateTime,
                        star_pos = util:bitstring_to_term(StarPosBin),
                        open_bag_num = OpenBagNum,
                        zx_double_times = DoubleTimes
                    },
                    Sql1 = io_lib:format("select gkey,pkey,goods_id,lv,exp,location,pos,`lock`,create_time from player_star_luck_goods where pkey = ~p",[Pkey]),
                    NewDict =
                        case db:get_all(Sql1) of
                            [] -> dict:new();
                            L ->
                                F = fun([GKey,_PKey,GoodsId,Lv,Exp,Location,Pos,Lock,CreateTime],AccDict) ->
                                        Star = #star{
                                            key = GKey,
                                            goods_id = GoodsId,
                                            lv = Lv,
                                            exp = Exp,
                                            location = Location,
                                            pos = Pos,
                                            lock = Lock,
                                            create_time = CreateTime
                                        },
                                        dict:store(GKey, Star, AccDict)
                                    end,
                                lists:foldl(F, dict:new(), L)
                        end,
                    StStarLuck#st_star_luck{
                        dict = NewDict
                    }
            end
    end.

dbup_star_luck_info(StStarLuck) ->
    #st_star_luck{
        pkey = Pkey,
        free_times = FreeTimes,
        update_time = UpdateTime,
        star_pos = StarPos,
        open_bag_num = OpenBagNum,
        zx_double_times = DoubleTimes
    } = StStarLuck,
    Sql = io_lib:format("replace into player_star_luck set pkey=~p,free_times=~p,update_time=~p,star_pos='~s',open_bag_num=~p,double_times=~p",
        [Pkey,FreeTimes,UpdateTime,util:term_to_bitstring(StarPos),OpenBagNum,DoubleTimes]),
    db:execute(Sql),
    ok.

dbup_star_luck_goods(Player,Star) ->
    #player{key = Pkey} = Player,
    #star{
        key = GKey,
        goods_id = GoodsId,
        lv = Lv,
        exp = Exp,
        location = Location,
        pos = Pos,
        lock = Lock,
        create_time = CreateTime
    } = Star,
    Sql = io_lib:format("replace into player_star_luck_goods set pkey=~p,goods_id=~p,lv=~p,exp=~p,location=~p,pos=~p,`lock`=~p,create_time=~p,gkey=~p",
        [Pkey, GoodsId, Lv, Exp, Location, Pos, Lock, CreateTime, GKey]),
    db:execute(Sql),
    ok.

dbdel_star_luck_goods(_Player, Star) ->
    Sql = io_lib:format("delete from player_star_luck_goods where gkey = ~p",[Star#star.key]),
    db:execute(Sql),
    ok.
