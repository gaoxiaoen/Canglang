%% --------------------------------------
%% 充值自动发送邮件
%% @author lishen(105326073@qq.com)
%% --------------------------------------

-module(charge_mail).
-export([add_mail/4,
         edit_mail/5,
         del_mail/1,
         send_mail/1]).

-record(charge_mail_state, {
        mails = []      % 邮件列表
    }).

-include("common.hrl").
-include("charge_mail.hrl").
    
%%-------------------------------------------------------
%% 后台调用接口
%%-------------------------------------------------------
%% @spec add_mail(TotalGold, OnceGold, Title, Content) -> ok | [Error] .
%% TotalGold = OnceGold = integer()
%% Title = Content = binary()
%% @doc 添加邮件
add_mail(TotalGold, _OnceGold, _Title, _Content) when not(is_integer(TotalGold)) ->
    ?DEBUG("错误的累计充值 ~w 数据类型", [TotalGold]),
    [util:fbin(?L(<<"错误的累计充值 ~w 数据类型">>), [TotalGold])];
add_mail(TotalGold, _OnceGold, _Title, _Content) when TotalGold < 0 orelse TotalGold > 1000000 ->
    ?DEBUG("错误的累计充值 ~w 超出数值范围", [TotalGold]),
    [util:fbin(?L(<<"错误的累计充值 ~w 超出数值范围">>), [TotalGold])];
add_mail(_TotalGold, OnceGold, _Title, _Content) when not(is_integer(OnceGold)) ->
    ?DEBUG("错误的单次充值 ~w 数据类型", [OnceGold]),
    [util:fbin(?L(<<"错误的单次充值 ~w 数据类型">>), [OnceGold])];
add_mail(_TotalGold, OnceGold, _Title, _Content) when OnceGold < 0 orelse OnceGold > 1000000 ->
    ?DEBUG("错误的单次充值 ~w 超出数值范围", [OnceGold]),
    [util:fbin(?L(<<"错误的单次充值 ~w 超出数值范围">>), [OnceGold])];
add_mail(_TotalGold, _OnceGold, Title, _Content) when not(is_binary(Title)) ->
    ?DEBUG("错误的邮件标题 ~w 数据类型", [Title]),
    [util:fbin(?L(<<"错误的邮件标题 ~w 数据类型">>), [Title])];
add_mail(_TotalGold, _OnceGold, <<>>, _Content) ->
    ?DEBUG("请输入邮件标题", []),
    [?L(<<"请输入邮件标题">>)];
add_mail(_TotalGold, _OnceGold, _Title, Content) when not(is_binary(Content)) ->
    ?DEBUG("错误的邮件内容 ~w 数据类型", [Content]),
    [util:fbin(?L(<<"错误的邮件内容 ~w 数据类型">>), [Content])];
add_mail(_TotalGold, _OnceGold, _Title, <<>>) ->
    ?DEBUG("请输入邮件内容", []),
    [?L(<<"请输入邮件内容">>)];
add_mail(0, 0, _Title, _Content) ->
    ?DEBUG("判断条件不能都为0", []),
    [?L(<<"判断条件不能都为0">>)];
add_mail(TotalGold, OnceGold, _Title, _Content) when TotalGold > 0 andalso OnceGold > 0 ->
    ?DEBUG("判断条件不能都大于0", []),
    [?L(<<"判断条件不能都大于0">>)];

add_mail(TotalGold, OnceGold, Title, Content) ->
    #charge_mail_state{mails = Mails} = get_state(),
    Mail = #charge_mail{id = mail_mgr:get_id(), total_gold = TotalGold, once_gold = OnceGold, title = Title, content = Content},
    case charge_mail_dao:insert(Mail) of
        {ok, _Result} ->
            sys_env:save(charge_mail_state, #charge_mail_state{mails = [Mail | Mails]}),
            ok;
        {false, Reason} ->
            Reason
    end.
         
%% @spec set_mail(Id, TotalGold, OnceGold, Title, Content) -> ok | [Error].
%% Id = TotalGold = OnceGold = integer()
%% Title = Content = binary()
%% @doc 编辑邮件
edit_mail(Id, _TotalGold, _OnceGold, _Title, _Content) when not(is_integer(Id)) orelse Id < 0 ->
    ?DEBUG("错误的邮件ID ~w 数据类型", [Id]),
    [util:fbin(?L(<<"错误的邮件ID ~w 数据类型">>), [Id])];
edit_mail(_Id, TotalGold, _OnceGold, _Title, _Content) when not(is_integer(TotalGold)) ->
    ?DEBUG("错误的累计充值 ~w 数据类型", [TotalGold]),
    [util:fbin(?L(<<"错误的累计充值 ~w 数据类型">>), [TotalGold])];
edit_mail(_Id, TotalGold, _OnceGold, _Title, _Content) when TotalGold < 0 orelse TotalGold > 1000000 ->
    ?DEBUG("错误的累计充值 ~w 超出数值范围", [TotalGold]),
    [util:fbin(?L(<<"错误的累计充值 ~w 超出数值范围">>), [TotalGold])];
edit_mail(_Id, _TotalGold, OnceGold, _Title, _Content) when not(is_integer(OnceGold)) ->
    ?DEBUG("错误的单次充值 ~w 数据类型", [OnceGold]),
    [util:fbin(?L(<<"错误的单次充值 ~w 数据类型">>), [OnceGold])];
edit_mail(_Id, _TotalGold, OnceGold, _Title, _Content) when OnceGold < 0 orelse OnceGold > 1000000 ->
    ?DEBUG("错误的单次充值 ~w 超出数值范围", [OnceGold]),
    [util:fbin(?L(<<"错误的单次充值 ~w 超出数值范围">>), [OnceGold])];
edit_mail(_Id, _TotalGold, _OnceGold, Title, _Content) when not(is_binary(Title)) ->
    ?DEBUG("错误的邮件标题 ~w 数据类型", [Title]),
    [util:fbin(?L(<<"错误的邮件标题 ~w 数据类型">>), [Title])];
edit_mail(_Id, _TotalGold, _OnceGold, <<>>, _Content) ->
    ?DEBUG("请输入邮件标题", []),
    [?L(<<"请输入邮件标题">>)];
edit_mail(_Id, _TotalGold, _OnceGold, _Title, Content) when not(is_binary(Content)) ->
    ?DEBUG("错误的邮件内容 ~w 数据类型", [Content]),
    [util:fbin(?L(<<"错误的邮件内容 ~w 数据类型">>), [Content])];
edit_mail(_Id, _TotalGold, _OnceGold, _Title, <<>>) ->
    ?DEBUG("请输入邮件内容", []),
    [?L(<<"请输入邮件内容">>)];
edit_mail(_Id, 0, 0, _Title, _Content) ->
    ?DEBUG("判断条件不能都为0", []),
    [?L(<<"判断条件不能都为0">>)];
edit_mail(_Id, TotalGold, OnceGold, _Title, _Content) when TotalGold > 0 andalso OnceGold > 0 ->
    ?DEBUG("判断条件不能都大于0", []),
    [?L(<<"判断条件不能都大于0">>)];

edit_mail(Id, TotalGold, OnceGold, Title, Content) ->
    case sys_env:get(charge_mail_state) of
        State = #charge_mail_state{mails = Mails} ->
            Mail = #charge_mail{id = Id, total_gold = TotalGold, once_gold = OnceGold, title = Title, content = Content},
            case charge_mail_dao:update(Mail) of
                {ok, _Result} ->
                    sys_env:save(charge_mail_state, State#charge_mail_state{mails = handle_edit_mail(Mail, Mails)}),
                    ok;
                {false, Reason} ->
                    Reason
            end;
        _Else ->
            [?L(<<"服务端数据错误">>)]
    end.
    
%% @spec del_mail(Id) -> ok | [Error].
%% Id = integer()
%% @doc 删除邮件
del_mail(Id) when not(is_integer(Id)) orelse Id < 0 ->
    [util:fbin(?L(<<"错误的邮件ID ~w 数据类型">>), [Id])];

del_mail(Id) ->
    case sys_env:get(charge_mail_state) of
        State = #charge_mail_state{mails = Mails} ->
            case charge_mail_dao:delete(Id) of
                {ok, _Result} ->
                    sys_env:save(charge_mail_state, State#charge_mail_state{mails = handle_del_mail(Id, Mails)}),
                    ok;
                {false, Reason} ->
                    Reason
            end;
        _Else ->
            [?L(<<"服务端数据错误">>)]
    end.

%% @spec send_mail(Args, State) -> ok | [Error]
%% Args = {{Rid, SrvId, Name}, TotalGold, OnceGold}
%% TotalGold = OnceGold = integer()
%% @doc 发送邮件
send_mail(Args) ->
    case sys_env:get(charge_mail_state) of
        State = #charge_mail_state{mails = Mails} ->
            sys_env:save(charge_mail_state, State#charge_mail_state{mails = handle_send_mail(Args, Mails)}),
            ok;
        _Else ->
            ?DEBUG("服务端不存在邮件")
    end.


%%---------------------------------------------------------
%% 私有函数
%%---------------------------------------------------------
%% 处理邮件设置
handle_edit_mail(Mail, MailList) ->
    handle_edit_mail(Mail, MailList, []).
handle_edit_mail(Mail = #charge_mail{id = Id1, total_gold = TotalGold1, once_gold = OnceGold1}, [#charge_mail{id = Id2, total_gold = TotalGold2, once_gold = OnceGold2} | T], OldH)
when Id1 =:= Id2 andalso (TotalGold1 =/= TotalGold2 orelse OnceGold1 =/= OnceGold2) ->
    charge_mail_dao:update(Id1, []),
    OldH ++ [Mail | T];
handle_edit_mail(#charge_mail{id = Id1, title = Title, content = Content}, [OldMail = #charge_mail{id = Id2} | T], OldH) when Id1 =:= Id2 ->
    OldH ++ [OldMail#charge_mail{title = Title, content = Content} | T];
handle_edit_mail(Mail, [H | T], OldH) ->
    handle_edit_mail(Mail, T, [H | OldH]);
handle_edit_mail(_Mail, [], OldH) ->
    OldH.

%% 处理邮件发送
handle_send_mail(Args, MailList) ->
    handle_send_mail(Args, MailList, []).
handle_send_mail(Args = {To, TotalGold1, OnceGold1}, [H = #charge_mail{total_gold = TotalGold2, once_gold = OnceGold2, title = Title, content = Content, recv_roles = RoleList} | T], OldH)
when ((TotalGold2 > 0 andalso TotalGold1 >= TotalGold2) orelse (OnceGold2 > 0 andalso OnceGold1 >= OnceGold2)) ->
    case lists:member(To, RoleList) of
        true ->
            handle_send_mail(Args, T, [H | OldH]);
        false ->
            NewMail = H#charge_mail{recv_roles = [To | RoleList]},
            #charge_mail{id = Id, recv_roles = RecvRoles} = NewMail,
            case charge_mail_dao:update(Id, RecvRoles) of
                {ok, _Result} ->
                    spawn(mail_mgr, deliver, [To, {Title, Content, [], []}]),
                    handle_send_mail(Args, T, [NewMail | OldH]);
                {false, _Reason} ->
                    handle_send_mail(Args, T, [H | OldH])
            end
    end;
handle_send_mail(Args, [H | T], OldH) ->
    handle_send_mail(Args, T, [H | OldH]);
handle_send_mail(_Args, [], OldH) ->
    OldH.

%% 处理邮件删除
handle_del_mail(Id, MailList) ->
    handle_del_mail(Id, MailList, []).
handle_del_mail(Id, [#charge_mail{id = MailId} | T], OldH) when Id =:= MailId ->
    OldH ++ T;
handle_del_mail(Id, [H | T], OldH) ->
    handle_del_mail(Id, T, [H | OldH]);
handle_del_mail(_Id, [], OldH) ->
    OldH.

%% 获取sys_env里的State
get_state() ->
    case sys_env:get(charge_mail_state) of
        State when is_record(State, charge_mail_state) -> State;
        _Else -> #charge_mail_state{}
    end.
