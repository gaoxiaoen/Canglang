%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 三月 2016 下午2:52
%%%-------------------------------------------------------------------
-module(lv_vip).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    lv_up/1
]).

lv_up(Player) ->
    case get_content(Player#player.lv) of
        [] -> skip;
        GoodsId ->
            Title = ?T("冲级送VIP"),
            Content = io_lib:format(?T("恭喜你升级到了~p级，感谢你对我们游戏的支持和热爱，奉上小礼物，请笑纳！"),[Player#player.lv]),
            mail:sys_send_mail([Player#player.key],Title,Content,[{GoodsId,1}])
    end.

get_content(PlayerLv) ->
    case PlayerLv of
%%         40 -> 20903;
%%         51 -> 20904;
%%         55 -> 20905;
%%         61 -> 20906;
%%         64 -> 20907;
%%         70 -> 20908;
        _ -> []
    end.
