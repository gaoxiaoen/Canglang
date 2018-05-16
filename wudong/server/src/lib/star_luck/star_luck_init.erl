%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 下午4:42
%%%-------------------------------------------------------------------
-module(star_luck_init).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("star_luck.hrl").

%% API
-export([
    init/1,
    update/1
]).

init(Player) ->
    StStarLuck = star_luck_load:dbget_star_luck_info(Player),
    star_luck:put_dict(StStarLuck),
    update(Player),
    Player.

update(Player) ->
    StStarLuck = star_luck:get_dict(),
    #st_star_luck{
        update_time = UpdateTime
    } = StStarLuck,
    Now = util:unixtime(),
    NewStStarLuck =
        case util:is_same_date(Now, UpdateTime) of
            true -> StStarLuck;
            false ->
                StStarLuck#st_star_luck{
                    update_time = Now,
                    free_times = 0,
                    zx_double_times = 0
                }
        end,
    star_luck:put_dict(NewStStarLuck),
    Player.