%%-------------------------------------------------------------------------
%% 邮件系统 后台管理 数据库操作
%% @author yjbgwxf@gmail.com
%%-------------------------------------------------------------------------
-module(mail_adm_db).
-export([insert_mail_log/11, get_roles/2, get_roles/3, insert_inner_mail_log/10, get_role_info/2]).

-include("common.hrl").

%% 保存后台发送邮件日志
insert_mail_log(Roles, Subject, Text, AdmName, Time, Coin, Gold, BindGold, Stone, Scale, Items) ->
    Sql = <<"insert into log_mail(roles, subject, text, real_name, sendtime, coin, gold, bind_gold, stone, scale, items) 
            values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)">>,

    case db:execute(Sql, [Roles, Subject, Text, AdmName, Time, Coin, Gold, BindGold, Stone, Scale, Items]) of
        {error, _Why} ->
            ?DEBUG("******** WHY: ~p", [_Why]),
            ?ELOG("[~w], 保存后台邮件日志到数据库发生错误，[Reason: ~w]", [?MODULE, _Why]),
            false;
        {ok, _Result} ->
            true
    end.

%% 保存后台发给内部人员（公司）的邮件日志
insert_inner_mail_log(Roles, Subject, Text, AdmName, Time, Coin, Gold, BindCoin, BindGold, Items) ->
    Sql = <<"insert into log_mail_inner(roles, subject, text, real_name, sendtime, coin, gold, bind_coin, bind_gold, items) 
            values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)">>,
    case db:execute(Sql, [Roles, Subject, Text, AdmName, Time, Coin, Gold, BindCoin, BindGold, Items]) of
        {error, _Why} ->
            ?ELOG("[~w], 保存后台邮件日志到数据库发生错误，[Reason: ~w]", [?MODULE, _Why]),
            false;
        {ok, _Result} ->
            true
    end.

get_roles(Min, Max) ->
    Sql = <<"select id, srv_id, name, lev from role">>,
    case db:get_all(Sql) of
        {ok, Roles} -> 
            catch [{Rid, Srvid, Name} || [Rid, Srvid, Name, Lev] <- Roles, Lev >= Min andalso Lev =< Max];
        {error, _Why2} ->
            ?ELOG("查询等级在 ~w 和 ~w 之间的玩家时，数据库查询失败, 【Reason: ~s】", [Min, Max, _Why2]),
            false
    end.

get_roles(Min, Max, PlatForm) -> 
    ?DEBUG("--mail_adm_db--:~p~n~n", [PlatForm]),
    Sql = <<"select id, srv_id, name, lev, platform from role">>, 
    case db:get_all(Sql) of
        {ok, Roles} -> 
            catch [{Rid, Srvid, Name} || [Rid, Srvid, Name, Lev, PlatForm1] <- Roles, Lev >= Min andalso Lev =< Max andalso PlatForm1 == PlatForm];
        {error, _Why2} ->
            ?ELOG("查询等级在 ~w 和 ~w 之间的玩家时，数据库查询失败, 【Reason: ~s】", [Min, Max, _Why2]),
            false
    end.

%% 查询角色数据
get_role_info(by_id, {Rid, Srvid}) ->
    Sql = <<"select name from role where id = ~s and srv_id = ~s">>,
    case db:get_one(Sql, [Rid, Srvid]) of
        {ok, Name} -> Name;
        {error, _Why} -> 
            ?ERR("查询角色 [~w,~s] 的名字时，数据库操作发生错误 [~s]", [Rid, Srvid, _Why]),
            <<>>
    end;
get_role_info(by_name, Name) ->
    Sql = <<"select id, srv_id from role where name = ~s">>,
    case db:get_row(Sql, [Name]) of
        {ok, [Rid, Srvid]} -> {Rid, Srvid};
        {error, _Why} -> 
            ?ERR("查询角色 [~s] 的 id 时，数据库操作发生错误 [~s]", [Name, _Why]),
            {0, <<>>}
    end.
