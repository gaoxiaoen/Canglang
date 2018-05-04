%%----------------------------------------------------
%% 跨服代理接口
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(c_proxy).
-export([
        role_lookup/3
        ,pack_send/3
        ,chat_kuafu/2
    ]
).
-include("common.hrl").
-include("center.hrl").

%% 从所有服中查找某个角色的信息
%% 参数和返回值跟role_api:lookup/3相同
role_lookup(Type, {Id, SrvId}, ReturnType) ->
    case c_mirror_group:call(node, SrvId, role_api, lookup, [Type, {Id, SrvId}, ReturnType]) of
        {ok, N, R} -> {ok, N, R};
        {error, Reason} -> {error, Reason};
        Err ->
            ?ERR("执行c_proxy:role_lookup/3时发生异常: Type=~w, Id=~w, SrvId=~s, Err=~w", [Type, Id, SrvId, Err]), 
            {error, not_found}
    end.

%% 把要发送的消息传给指定的节点发送出去
pack_send({Id, SrvId}, Cmd, Data) ->
    c_mirror_group:cast(node, SrvId, role_group, pack_send, [{Id, SrvId}, Cmd, Data]).

%% @spec chat_kuafu(Platform, Msg) -> ok
%% @doc 向所有节点广播跨服群组聊天消息
chat_kuafu(Platform, DataMsg) when is_list(Platform) ->
    c_mirror_group:cast(platform, [list_to_bitstring(Platform)], chat, chat_kuafu, [DataMsg]);
chat_kuafu(Platform, DataMsg) when is_bitstring(Platform) ->
    c_mirror_group:cast(platform, [Platform], chat, chat_kuafu, [DataMsg]);
chat_kuafu(_, _DataMsg) -> ignore.
