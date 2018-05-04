%%----------------------------------------------------
%% @doc anticrack 版本转换
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(anticrack_parse).
-export([
        do/1
    ]
).

-include("common.hrl").
-include("misc.hrl").

do({anticrack, 1, Escort, Dungeon}) ->
    do({anticrack, 2, Escort, Dungeon, 0});

do(Anticrack) ->
    Ver = element(2, Anticrack),
    case Ver =:= ?ANTICRACK_VER andalso is_record(Anticrack, anticrack) of
        true -> {ok, Anticrack};
        false -> {false, ?L(<<"角色anticrack扩展数据解析时发生异常">>)}
    end.

