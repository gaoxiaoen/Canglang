%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 三月 2016 上午11:25
%%%-------------------------------------------------------------------
-author("fengzhenlin").
-include("common.hrl").

-define(WORSHIP_SCENE, 10003).
%%城主信息
-record(worship,{
    worship_list = []  %%雕像列表 [#worhsip_player{}]
}).

-record(worship_player, {
    type = 0   %%雕像类型 1掌门 2战力 3等级
    , pkey = 0
    , update_time = 0 %%换人时间
}).