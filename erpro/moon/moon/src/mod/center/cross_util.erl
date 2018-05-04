%%----------------------------------------------------
%% 跨服工具模块
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(cross_util).
-export([
        is_local_srv/1
    ]
).

-include("common.hrl").
-include("center.hrl").

%% 是否本服 -> true | false
is_local_srv(SrvId) ->
    SrvId1 = util:to_list(SrvId),
    LocalSrvId = sys_env:get(srv_id),
    SrvIds = sys_env:get(srv_ids),
    case SrvId1 =:= LocalSrvId of
        true -> true;
        false ->
            case lists:member(SrvId1, SrvIds) of
                true -> true;
                false -> false
            end
    end.
