%%---------------------------------------------
%% 测试邮件相关RPC调用
%% @author 252563398@qq.com
%%---------------------------------------------
-module(test_mail_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 邮件列表
handle(list, {MailType}, _Tester) ->
    tester:pack_send(11700, {MailType}),
    {ok};
handle(11700, {_MailList}, _TesterState) ->
    ?DEBUG("收到邮件列表:~w",[_MailList]),
    {ok};

%% 发送邮件
handle(send, {ToName, Coin, Id, Subject, Content}, _Tester) ->
    tester:pack_send(11701, {ToName, Coin, Id, Subject, Content}),
    {ok};
handle(11701, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 邮件增加返回
handle(11702, {_MailList}, _TesterState) ->
    ?DEBUG("收到新增加邮件列表:~w",[_MailList]),
    {ok};

%% 删除邮件
handle(del, {L}, _Tester) ->
    tester:pack_send(11703, {L}),
    {ok};
handle(11703, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 设置邮件状态为已读
handle(status, {IdsL}, _Tester) ->
    tester:pack_send(11704, {IdsL}),
    {ok};
handle(11704, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 邮件删除返回
handle(11705, {_DList}, _TesterState) ->
    ?DEBUG("收到删除邮件列表:~w",[_DList]),
    {ok};

%% 吸附指定邮件中的附件
handle(attach, {Id}, _Tester) ->
    tester:pack_send(11706, {Id}),
    {ok};
handle(11706, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 邮件更新返回
handle(11707, {_MailList}, _TesterState) ->
    ?DEBUG("收到更新邮件列表:~w",[_MailList]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
