%%----------------------------------------------------
%% 排行榜协议监听配置
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_cfg).
-export([check/2]).

check(0, _Data) ->
    case get(exchange_rank_flag) of
        true -> %% 玩家交易过滤
            put(exchange_rank_flag, false),
            false;
        _ -> 
            true
    end;

check(10115, _Data) -> false;  %% 角色移动

%% 市场相关事件过滤
check(11302, _Data) -> false;
check(11304, _Data) -> false;
check(11305, _Data) -> false;
check(11306, _Data) -> false;
check(11332, _Data) -> false;
check(11334, _Data) -> false;

%% 信件发放
check(11701, _Data) -> false;

%% 交易
check(11231, _Data) -> false;

%% 徒弟奖励
check(16410, _Data) -> false;

%% 通缉
check(15001, _Data) -> false;

check(_Cmd, _Data) -> true.
