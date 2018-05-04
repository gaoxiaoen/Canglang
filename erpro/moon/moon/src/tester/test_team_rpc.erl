%% ************************
%% 测试组队功能模块
%% wpf wprehard@qq.com wpf0208@jieyou.com
%% ************************
-module(test_team_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 创建队伍
handle(create_team, {}, _Tester) ->
    tester:pack_send(10842, {}),
    {ok};
handle(10842, {_Result, _Msg}, _Tester) ->
    ?DEBUG("创建队伍返回[Result:~w, Msg:~s]", [_Result, _Msg]),
    {ok};

%% 队伍列表广播信息接收
handle(10800, _TeamList, _Tester) ->
    ?DEBUG("收到队伍列表消息[TeamList:~w]", [_TeamList]),
    {ok};

%% 邀请组队
handle(invite, {Id, SrvId}, _Tester) ->
    tester:pack_send(10805, {Id, SrvId}),
    {ok};
handle(10805, {_Result, _Msg}, _Tester) ->
    ?DEBUG("邀请组队返回[Result:~w, Msg:~w]", [_Result, _Msg]),
    {ok};

%% 收到邀请组队请求
handle(10806, {_Id, _SrvId, _Name}, _Tester) ->
    ?DEBUG("收到组队邀请[ID:~w, Name:~s]", [{_Id, _SrvId}, _Name]),
    %% 回复0同意1拒绝
    tester:pack_send(10807, {0, _Id, _SrvId}),
    %% tester:pack_send(10807, {1, _Id, _SrvId}),
    {ok};

%% 申请组队
handle(apply, {Id, SrvId}, _Tester) ->
    tester:pack_send(10809, {Id, SrvId}),
    {ok};
handle(10809, {_Result, _Msg}, _Tester) ->
    ?DEBUG("申请组队返回[Result:~w, Msg:~w]", [_Result, _Msg]),
    {ok};

%% 收到申请组队请求
handle(10810, {_Id, _SrvId, _Name}, _Tester) ->
    ?DEBUG("收到组队邀请[ID:~w, Name:~s]", [{_Id, _SrvId}, _Name]),
    %% 回复0同意1拒绝
    tester:pack_send(10811, {0, _Id, _SrvId}),
    %% tester:pack_send(10811, {0, _Id, _SrvId}),
    {ok};

%% 委任队长
handle(appoint, {MId, MSrvId}, _Tester) ->
    tester:pack_send(10815, {MId,MSrvId}),
    {ok};
handle(10815, {_Result, _Msg}, _Tester) ->
    ?DEBUG("委任队长返回[Result:~w, Msg:~w]", [_Result, _Msg]),
    {ok};

%% 召回队员
handle(call, {1, MId, MSrvId}, _Tester) ->
    tester:pack_send(10817, {1, MId, MSrvId}),
    {ok};
handle(10817, {_Result, _Msg}, _Tester) ->
    ?DEBUG("召回队员返回[Result:~w, Msg:~w]", [_Result, _Msg]),
    {ok};

%% 召集通知
handle(10818, {_TeamId, _Msg}, _Tester) ->
    ?DEBUG("召集通知返回[TeamId:~w, Msg:~w]", [_TeamId, _Msg]),
    {ok};

%% 移除队员
handle(del, {1, MId, MSrvId}, _Tester) ->
    tester:pack_send(10819, {1, MId, MSrvId}),
    {ok};
handle(10819, {_Result, _Msg}, _Tester) ->
    ?DEBUG("移除队员返回[Result:~w, Msg:~w]", [_Result, _Msg]),
    {ok};

%% 出队通知
handle(10820, {_TeamId, _Msg}, _Tester) ->
    ?DEBUG("出队通知返回[TeamId:~w, Msg:~w]", [_TeamId, _Msg]),
    {ok};

%% 暂离
handle(tempout, {1}, _Tester) ->
    tester:pack_send(10831, {1}),
    {ok};
handle(10831, {_Result, _Msg}, _Tester) ->
    ?DEBUG("暂离返回[Result:~w, Msg:~w]", [_Result, _Msg]),
    {ok};

%% 归队
handle(back_team, {1}, _Tester) ->
    tester:pack_send(10832, {1}),
    {ok};
handle(10832, {_Result, _Msg}, _Tester) ->
    ?DEBUG("归队返回[Result:~w, Msg:~w]", [_Result, _Msg]),
    {ok};

%% 归队通知-广播给所有其他队员
handle(10833, {_TeamId, _MId, _MSrvId, _Msg}, _Tester) ->
    ?DEBUG("归队通知返回[TeamId:~w, Member:~w, Msg:~w]", [_TeamId, {_MId, _MSrvId}, _Msg]),
    {ok};

%% 退出队伍
handle(quit, {1}, _Tester) ->
    tester:pack_send(10841, {1}),
    {ok};
handle(10841, {_Result, _Msg}, _Tester) ->
    ?DEBUG("退出队伍返回[Result:~w, Msg:~w]", [_Result, _Msg]),
    {ok};

%% 请求邀请列表
handle(invite_list, {}, _Tester) ->
    tester:pack_send(10851, {}),
    {ok};
handle(10851, {_Data}, _Tester) ->
    ?DEBUG("邀请列表返回[invite_list:~w]", [_Data]),
    {ok};

%% 请求申请列表
handle(apply_list, {}, _Tester) ->
    tester:pack_send(10852, {}),
    {ok};
handle(10852, {_Data}, _Tester) ->
    ?DEBUG("申请列表返回[apply_list:~w]", [_Data]),
    {ok};

handle(_cmd, _Data, _TesterState) ->
    {error, unknown_command}.
