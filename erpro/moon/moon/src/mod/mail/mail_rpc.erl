%%---------------------------------------------------------
%% 邮件系统 协议处理
%% @author 252563398@qq.com
%%---------------------------------------------------------

-module(mail_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("mail.hrl").
%%
-define(limitlength, 240).      %% 最长80个汉字
%% 获取邮件列表
handle(11700, {MailType}, _Role = #role{id = {Rid, SrvId}}) ->
    case mail_dao:select_by_type(Rid, SrvId, MailType) of %%查询数据库
        {ok, Mails} ->
            ?DEBUG("**********初始化邮件列表 MailType: ~w, C： ~w", [MailType, Mails]),
            {reply, {Mails}};
        {false, _Reason} -> {reply, {[]}}
    end;

%% 普通邮件发送
handle(11701, {_ToName, _Coin, _Id, <<>>, _Content}, _Role) ->
    {reply, {0, ?MSGID(<<"信件标题不能为空">>)}};
handle(11701, {_ToName, _Coin, _Id, _Subject, <<>>}, _Role) ->
    {reply, {0, ?MSGID(<<"信件内容不能为空">>)}};
handle(11701, {ToName, _Coin, _Id, _Subject, _Content}, _Role = #role{name = ToName}) ->
    {reply, {0, ?MSGID(<<"不能发送信件给自己">>)}};
handle(11701, {_ToName, _Coin, _Id, Subject, _Content}, _Role) when byte_size(Subject) > ?mail_max_subject_byte ->
    {reply, {0, ?MSGID(<<"标题不能超过10个汉字">>)}};
handle(11701, {_ToName, _Coin, _Id, _Subject, Content}, _Role) when byte_size(Content) > ?mail_max_content_byte ->
    {reply, {0, ?MSGID(<<"内容不能超过360个汉字">>)}};
handle(11701, {_ToName, Coin, _Id, _Subject, _Content}, _Role) when Coin > 0 ->
    {reply, {0, ?L(<<"不可以发金币">>)}};
handle(11701, {ToName, _Coin, _Id, _Subject, Content}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case check_time() of  
        false ->
            % {reply, {0, ?MSGID(<<"发送信件过频繁">>)}};
            notice:alert(error,ConnPid,<<"发送信件过频繁">>),
            {ok};
        true ->
            case mail:send2(Role, ToName, Content) of
                {ok, NR} ->
                    role:put_dict(last_mail_time, util:unixtime()),
                    {reply, {1, ?MSGID(<<"发信成功">>)}, NR};
                {_, Reason} -> 
                    notice:alert(error,ConnPid,Reason),
                    {ok}
            end
    end;

%% 删除邮件
handle(11703, {L}, _Role = #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}}) ->
    case mail_dao:del(Rid, SrvId, L) of
        [] -> {reply, {0, ?MSGID(<<"删除信件失败">>)}};
        Ids -> 
            ?DEBUG("*********  删除邮件成功  ************ "),
            sys_conn:pack_send(ConnPid, 11705, {Ids}),
            {reply, {1, ?MSGID(<<"删除信件成功">>)}}
    end;

%% 设置某邮件为已读取状态
handle(11704, {Ids}, _Role = #role{id = {Rid, SrvId}}) ->
    case mail_dao:set_status(Rid, SrvId, Ids) of
        [] -> {reply, {0, ?MSGID(<<"更新信件失败">>)}};
        _ -> {reply, {1, ?MSGID(<<"更新信件成功">>)}}
    end;

%% 吸附指定邮件中的附件
handle(11706, {Id}, Role) ->
    role:send_buff_begin(),
    case mail:attach_to_bag(Role, Id) of
        {ok, NRole} ->
            role:send_buff_flush(),
            log:log(log_coin, {<<"邮件领取">>, <<>>, Role, NRole}),
            log:log(log_attainment, {<<"邮件领取">>, <<>>, Role, NRole}),
            log:log(log_integral, {arena_score, <<"邮件">>, [], Role, NRole}),
            log:log(log_integral, {12, <<"邮件">>, [], Role, NRole}),
            log:log(log_integral, {guild_war, <<"邮件">>, [], Role, NRole}),
            log:log(log_xd_lilian, {<<"邮件领取">>, <<>>, Role, NRole}),
            log:log(log_soul, {<<"邮件领取">>, <<>>, Role, NRole}),
            ?DEBUG(" *********** 吸取邮件成功  ************** "),
            {reply, {1, ?MSGID(<<"收取附件成功">>)}, NRole};
        {false, _Reason} -> %%util:cn(Reason),
            role:send_buff_clean(),
            {reply, {0, ?MSGID(<<"收取失败">>)}}
    end;


%%发送邮件：类似于留言
handle(11710, {ToName, _Content,_}, _Role = #role{name = ToName,link = #link{conn_pid = ConnPid}}) ->
    notice:alert(error, ConnPid, ?L(<<"不能发送信件给自己">>)),
    {ok};
handle(11710, {_ToName, Content,_}, _Role = #role{link = #link{conn_pid = ConnPid}}) when byte_size(Content) > ?limitlength ->
    notice:alert(error, ConnPid, ?L(<<"内容不能超过80个汉字">>)),
    {ok};
handle(11710, {ToName, Content,Sign}, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    case check_time() of  
        false ->
            notice:alert(error, ConnPid, ?L(<<"发送信件过频繁">>)),
            {ok};
        true ->
            ?DEBUG("****玩家名字[FrSrvId:~w]", [ToName]),
            Content1 = forbid_word_filter:filter(Content),
            case mail:send2(Role, ToName, Content1, Sign) of
                {ok, NR} ->
                    role:put_dict(last_mail_time, util:unixtime()),
                    {reply, {1, <<"">>}, NR};
                {_, Reason} -> 
                    {reply, {0, Reason}}
            end
    end;

%%阅读邮件
handle(11711, {}, _Role = #role{id={RoleId, SrvId}}) ->
    case mail_dao:select_by_type2(RoleId, SrvId) of 
        {ok, Data} ->
            mail_dao:del_by_role(RoleId, SrvId), %%删除已存的邮件
            friend_dao:update_friend_mail_sign2(0, RoleId, SrvId), %%更新好友来信标识 ，0：表示没有来信
            {reply, {Data}};
        {false,_} ->
            {reply, {[]}}
    end;

%% 请求未读邮件数量
handle(11712, {}, _Role = #role{id = {Rid, SrvId}}) ->
    case mail_dao:get_unread_count(Rid, SrvId, 1) of %%查询数据库
        Count when is_integer(Count) ->
            {reply, {Count}};
        _ -> 
            {ok}
    end;


handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.

%% 发送邮件时间校验
%% 发送邮件时间间隔最小为: 30秒
check_time() -> 
    LastTime = case role:get_dict(last_mail_time) of
        {ok, undefined} -> 0;
        {ok, T} -> T
    end,
    (LastTime + 10) < util:unixtime().
