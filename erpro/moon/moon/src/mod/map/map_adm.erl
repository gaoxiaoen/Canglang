%%----------------------------------------------------
%% 地图管理接口
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(map_adm).
-export([
        list/0
    ]
).

%% @spec list() -> list()
%% @doc 列出所有已经启动的地图
list() ->
    ets:tab2list(map_info).
