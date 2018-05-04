%%----------------------------------------------------
%% 外观效果相关远程调用
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(looks_rpc).
-export([handle/3]).

-include("common.hrl").
-include("link.hrl").
-include("role.hrl").
-include("looks.hrl").
-include("item.hrl").

%% 获取皮肤外观列表
handle(19400, {}, Role) ->
    Reply = looks:first_career_looks(Role),
    NewReply = [{Lable, Mode, Value} || {Lable, Mode, Value} <- Reply],
    {reply, {NewReply}};

%% 设置外观
handle(19401, {Configs}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    NewRole = looks:configure(Configs, Role),
    Reply = looks:first_career_looks(NewRole),
    NewReply = [{Lable, Mode, Value} || {Lable, Mode, Value} <- Reply, lists:member(Lable, ?WARDROBE_DRESS_LOOKS)],
    sys_conn:pack_send(ConnPid, 19400, {NewReply}),
    {reply, {?true, ?L(<<"外观保存成功">>)}, NewRole};

%% 套装
handle(19450, Data, Role) ->
    suit_collect_rpc:handle(19450, Data, Role);

%% 套装 加成
handle(19451, Data, Role) ->
    suit_collect_rpc:handle(19451, Data, Role);

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
