%% --------------------------------------
%% 充值自动发送邮件 数据库接口
%% @author lishen(105326073@qq.com)
%% --------------------------------------
-module(charge_mail_dao).
-export([insert/1, update/1, update/2, delete/1]).

-include("common.hrl").
-include("charge_mail.hrl").


%% 保存自动发送邮件
insert(#charge_mail{id = Id, total_gold = TotalGold, once_gold = OnceGold, title = Title, content = Content}) ->
    Sql = "insert into log_charge_mail(id, total_gold, once_gold, title, content, update_time)values(~s,~s,~s,~s,~s,~s);",
    case db:execute(Sql, [Id, TotalGold, OnceGold, Title, Content, util:unixtime()]) of
        {error, _Why} ->
            ?ERR("[~w], 保存自动发送邮件到数据库发生错误，[Reason: ~w]", [?MODULE, _Why]),
            {false, ?L(<<"添加邮件失败">>)};
        {ok, _Result} ->
            {ok, _Result}
    end.

%% 更新自动发送邮件
update(#charge_mail{id = Id, total_gold = TotalGold, once_gold = OnceGold, title = Title, content = Content}) ->
    Sql = "update log_charge_mail set total_gold=~s, once_gold=~s, title=~s, content=~s, update_time=~s where id=~s;",
    case db:execute(Sql, [TotalGold, OnceGold, Title, Content, util:unixtime(), Id]) of
        {error, _Why} ->
            ?ERR("[~w], 更新自动发送邮件失败, [Reason: ~w]", [?MODULE, _Why]),
            {false, ?L(<<"更新邮件失败">>)};
        {ok, _Result} ->
            {ok, _Result}
    end.

%% 更新邮件已接收玩家列表
update(Id, RecvRoles) ->
    Sql = "update log_charge_mail set recv_roles=~s where id=~s;",
    case db:execute(Sql, [util:term_to_string(RecvRoles), Id]) of
        {error, _Why} ->
            ?ERR("[~w], 更新自动发送邮件已接收玩家列表失败，[Reason: ~w]", [?MODULE, _Why]),
            {false, ?L(<<"更新已接收玩家列表失败">>)};
        {ok, _Result} ->
            {ok, _Result}
    end.

%% 删除自动发送邮件
delete(Id) ->
    Sql = "delete from log_charge_mail where id=~s;",
    case db:execute(Sql, [Id]) of
        {error, _Why} ->
            ?ERR("[~w], 删除自动发送邮件失败，[Reason: ~w]", [?MODULE, _Why]),
            {false, ?L(<<"删除邮件失败">>)};
        {ok, _Result} ->
            {ok, _Result}
    end.
