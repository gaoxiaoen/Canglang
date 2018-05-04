%%--------------------------------------------------------
%% 邮件系统数据处理22
%% @author 252563398@qq.com
%%----------------------------------------------------------

-module(mail_dao).
-export([
        insert/2  %%插入一封邮件
        ,insert2/3  %%插入一封邮件
        ,select_all/2  %%读取所有邮件列表
        ,select_by_type/3  %%读取指定类型邮件列表
        ,select_by_type2/2  %%读取指定类型邮件列表
        ,get_unread_count/3
        ,del_by_role/2  %%删除指定角色邮件列表
        ,select/3   %%读取指定邮件
        ,del/3   %%删除指定邮件列表
        ,set_status/3  %%邮件读取状态更改
        ,update_attach/3  %%邮件附件吸取
        ,get_maxid/0     %%获取邮件最大ID
        ,del_timeout/0   %%超时邮件删除
    ]
).

-include("common.hrl").
-include("link.hrl").
-include("role.hrl").
-include("mail.hrl").
%%
-include("item.hrl").

%% 向数据库信箱插入新邮件
insert(IsLog, Mail = #mail{id = Id, send_time = CT, from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName, to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName, subject = Subject, content = Content, mailtype = Mailtype, isatt = Isatt, assets = Assets, attachment = Items}) when is_list(Assets) andalso is_list(Items) ->
    case chect_num(ToRid, ToSrvId, Mailtype, get_max(Mailtype)) of
        false -> {false, ?L(<<"收信人信件已满">>)};
        true ->
            case role_api:is_local_role(ToSrvId) of
                false -> 
                    ?ERR("非本服信件[from_name:~s][to_name:~s][标题:~s]", [FromName, ToName, Subject]),
                    {false, ?L(<<"数据库操作失败，无法发送信件">>)};
                true ->
                    case {check_attach(assets, Assets), check_attach(item, Items)} of
                        {false, _} -> 
                            ?ERR("信件资产参数不正确[from_name:~s][to_name:~s][标题:~s][assets:~w]", [FromName, ToName, Subject, Assets]),
                            {false, ?L(<<"信件资产参数不正确">>)};
                        {true, false} ->
                            ?ERR("信件资产参数不正确[from_name:~s][to_name:~s][标题:~s][assets:~w]", [FromName, ToName, Subject, Items]),
                            {false, ?L(<<"物品附件参数不正确">>)};
                        _ ->
                            Sql = "insert into role_mail (id,from_rid,from_srv_id,from_name,to_rid,to_srv_id,to_name,mailtype,subject,content,assets,items,isatt,status,ct) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,0,~s)",
                            case db:execute(Sql, [Id, FromRid, FromSrvId, FromName, ToRid, ToSrvId, ToName, Mailtype, Subject, Content, util:term_to_bitstring(Assets), util:term_to_bitstring(Items), Isatt, CT]) of
                                {ok, Rows} when is_integer(Rows) andalso Rows > 0 -> 
                                    add_log(IsLog, Mail),
                                    {ok, Rows};
                                _Err -> 
                                    ?ERR("信件增加到数据库失败[from_name:~s][to_name:~s][标题:~s][error:~w]", [FromName, ToName, Subject, _Err]),
                                    {false, ?L(<<"数据库操作失败，无法发送信件">>)}
                            end
                    end
            end
    end;
insert(_IsLog, _) -> 
    ?DEBUG("信件参数不正确"),
    {false, ?L(<<"信件参数非法">>)}.

insert2(IsLog, Mail = #mail{send_time = CT, from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName, to_rid = ToRid, to_srv_id = ToSrvId, content = Content}, Sign) ->
    Sql = "insert into role_mail_message (from_rid, from_srv, to_rid, to_srv, from_name, content, ct, sign) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [FromRid, FromSrvId, ToRid, ToSrvId, FromName, Content, CT,Sign]) of
        {ok, Rows} when is_integer(Rows) andalso Rows > 0 -> 
            add_log(IsLog, Mail),
            {ok, Rows};
        _Err -> 
            ?ERR("信件增加到数据库失败[from_name:~s][error:~w]", [FromName, _Err]),
            {false, ?L(<<"数据库操作失败，无法发送信件">>)}
    end.




%% 校验附件是否正确
check_attach(_Label, []) -> true;
check_attach(assets, [{Type, N} | T]) when is_integer(Type) andalso is_integer(N) -> 
    check_attach(assets, T);
check_attach(item, [Item | T]) when is_record(Item, item) ->
    check_attach(item, T);
check_attach(_Label, _) -> false.

%% 查找指定角色所有邮件
select_all(Rid, SrvId) ->
    Sql = "select id,from_rid,from_srv_id,from_name,to_rid,to_srv_id,to_name,mailtype,subject,content,assets,items,isatt,status,ct from role_mail where to_rid=~s and to_srv_id=~s",
    case db:get_all(Sql, [Rid, SrvId]) of
        {ok, Data} when is_list(Data) -> {ok, format_mail(Data, [])};
        {error, undefined} -> {ok, []};
        _Else -> {false, ?L(<<"读取邮件出错">>)}
    end.

%% 查找指定角色指定邮件
select_by_type(Rid, SrvId, MailType) ->
    Sql = "select id,from_rid,from_srv_id,from_name,to_rid,to_srv_id,to_name,mailtype,subject,content,assets,items,isatt,status,ct from role_mail where to_rid=~s and to_srv_id=~s and mailtype=~s",
    case db:get_all(Sql, [Rid, SrvId, MailType]) of
        {ok, Data} when is_list(Data) -> {ok, format_mail(Data, [])};
        {error, undefined} -> {ok, []};
        _Else -> {false, ?L(<<"读取邮件出错">>)}
    end.

select_by_type2(Rid, SrvId) ->
    Sql = "select from_name,content,ct,sign from role_mail_message where to_rid=~s and to_srv=~s",
    case db:get_all(Sql, [Rid, SrvId]) of
        {ok, Data} when is_list(Data) -> {ok, Data};
        {error, undefined} -> {ok, []};
        _Else -> {false, <<"读取邮件出错">>}
    end.

get_unread_count(RoleId, SrvId, MailType) ->
    Sql = "select count(*) from role_mail where status = 0 and to_rid=~s and to_srv_id=~s and mailtype=~s",
    case db:get_row(Sql, [RoleId, SrvId, MailType]) of
        {ok, [Count]} -> 
            Count;
        _ ->
            0
    end.

%%删除指定角色的邮件列表
del_by_role(Rid,SrvId) ->
    Sql = "delete from role_mail_message where to_rid =~s and to_srv =~s",
    db:execute(Sql,[Rid,SrvId]).
    

%% 取出指定邮件
select(Rid, SrvId, Id) ->
    Sql = "select id,from_rid,from_srv_id,from_name,to_rid,to_srv_id,to_name,mailtype,subject,content,assets,items,isatt,status,ct from role_mail where id=~s and to_rid=~s and to_srv_id=~s",
    case db:get_row(Sql, [Id, Rid, SrvId]) of
        {ok, Data} -> format_mail(Data);
        _Else -> {false, ?L(<<"读取邮件失败">>)}
    end.

%% 删除指定ID列表邮件 收件信箱
del(Rid, SrvId, Ids) -> del(Rid, SrvId, Ids, []).
del(_Rid, _SrvId, [], DelIds) -> DelIds;
del(Rid, SrvId, [Id | T], DelIds) ->
    case do_del(Rid, SrvId, Id) of
        {ok, _Row} -> del(Rid, SrvId, T, [Id | DelIds]);
        {false, _Reason} -> del(Rid, SrvId, T, DelIds)
    end.
do_del(Rid, SrvId, Id) ->
    Sql = "delete from role_mail where to_rid=~s and to_srv_id=~s and id=~s",
    case db:execute(Sql, [Rid, SrvId, Id]) of
        {ok, Rows} when is_integer(Rows) andalso Rows > 0 -> {ok, Rows};
        _ -> {false, ?L(<<"删除邮件失败">>)}
    end.

%% 设置邮件为已读状态
set_status(Rid, SrvId, Ids) -> set_status(Rid, SrvId, Ids, []).
set_status(_Rid, _SrvId, [], L) -> L;
set_status(Rid, SrvId, [Id | T], L) ->
    case do_set_status(Rid, SrvId, Id) of
        {ok, _Row} -> set_status(Rid, SrvId, T, [Id | L]);
        {false, _Reason} -> set_status(Rid, SrvId, T, L)
    end.
do_set_status(Rid, SrvId, Id) ->
    Sql = "update role_mail set status = 1 where to_rid=~s and to_srv_id=~s and id=~s",
    case db:execute(Sql, [Rid, SrvId, Id]) of
        {ok, Rows} when is_integer(Rows) andalso Rows > 0 -> {ok, Rows};
        _ -> {false, ?L(<<"更新邮件状态失败">>)}
    end.

%% 更新邮件的附件为空
update_attach(Rid, SrvId, Id) ->
    Now = util:unixtime(),
    Sql = "update role_mail set status = 1, isatt=0, assets='[]', items='[]', read_time=~s where to_rid=~s and to_srv_id=~s and id=~s",
    case db:execute(Sql, [Now, Rid, SrvId, Id]) of
        {ok, Rows} when is_integer(Rows) andalso Rows > 0 -> 
            spawn( 
                fun() -> 
                        Sql1 = "update log_mail_all set read_time=~s where to_rid=~s and to_srv_id=~s and id=~s",
                        db:execute(Sql1, [Now, Rid, SrvId, Id])
                end
            ),
            {ok, Rows};
        _Reason ->
            ?ERR("[~p, ~s, ~p]收取信件更新数据库失败:[~w]", [Rid, SrvId, Id, _Reason]),
            {false, ?L(<<"数据库操作失败, 吸取附件失败">>)}
    end.

%% 获取当前最大ID值
get_maxid() ->
    Sql = "select max(id) from role_mail",
    case db:get_one(Sql, []) of
        {ok, MaxId} when is_integer(MaxId) -> {ok, MaxId};
        {ok, _} -> {ok, 0};
        _Else -> {false, ?L(<<"读取邮件数量出错">>)}
    end.

%% 删除过时邮件
del_timeout() ->
    spawn(
        fun() ->
                Sql = "delete from role_mail where isatt=0 and ct < ~s",
                OutTime = util:unixtime() - ?MAIL_SAVE_MAX_DAY,
                db:execute(Sql, [OutTime])
        end
    ).

%%---------------------------------------------------------------
%%  内部函数
%%---------------------------------------------------------------

%% 格式化从数据库取出的邮件
format_mail([], NewList) -> NewList;
format_mail([I | T], NewList) -> 
    case format_mail(I) of
        {false, _} -> format_mail(T, NewList);
        {ok, Mails} -> format_mail(T, [Mails | NewList])
    end.
format_mail([Id, FromRid, FromSrvId, FromName, ToRid, ToSrvId, ToName, Mailtype, Subject, Content, Ass, Items, Isatt, Status, CT]) ->
    case util:bitstring_to_term(Ass) of
        {error, Why} ->
            ?ERR("[~w:~s]邮件[~p]资产附件数据无法正确转换成term(): ~p", [ToRid, ToSrvId, Id, Why]),
            {false, ?L(<<"邮件资产附件已损坏">>)};
        {ok, Assets} ->
            case util:bitstring_to_term(Items) of
                {error, Why}  ->
                    ?ERR("[~w:~s]邮件[~p]物品附件数据无法正确转换成term(): ~p", [ToRid, ToSrvId, Id, Why]),
                    {false, ?L(<<"邮件物品附件已损坏">>)};
                {ok, Attach} ->
                    case item_parse:do(Attach) of
                        {false, Reason} ->
                            ?ERR("[~w:~s]邮件[~p]物品附件数据版本号转换失败term(): ~p", [ToRid, ToSrvId, Id, Reason]),
                            {false, Reason};
                        {ok, ItemsList} ->
                            case item_parse:do(ItemsList) of
                                {ok, NewItemsList} ->
                                    {ok, #mail{
                                            id = Id, send_time = CT
                                            ,from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName
                                            ,to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName
                                            ,status = Status, subject = Subject, content = Content, mailtype = Mailtype
                                            ,isatt = Isatt, assets = revert_assets(Assets, []), attachment = NewItemsList}
                                    };
                                _ ->
                                    ?ERR("信件物品版本转换失败"),
                                    {false, ?L(<<"物品版本转换失败">>)}
                            end
                    end
            end
    end.

%% 信件资产处理
revert_assets([], L) -> L;
revert_assets([{Type, Val} | T], L) when is_integer(Type) andalso is_integer(Val) ->
    revert_assets(T, [{Type, Val} | L]);
revert_assets([_ | T], L) ->
    revert_assets(T, L);
revert_assets(_, L) -> L.

%% 判断邮件数量
chect_num(_, _, _, 0) -> true;
chect_num(ToRid, ToSrvId, Mailtype, Max) ->
    case select_count(ToRid, ToSrvId, Mailtype) of
        {ok, Count} when Count < Max -> true;
        _ -> false
    end.
% chect_num2(ToRid, ToSrvId, Mailtype, Max) ->
%     case select_count(ToRid, ToSrvId, Mailtype) of
%         {ok, Count} when Count < Max -> true;
%         _ -> 
%             case delete_oldest(ToRid, ToSrvId, Mailtype) of 
%                 ok -> true;
%                 {false,Reason} -> {false,Reason}
%             end
%     end.

%% 查找指定角色邮件的数量
select_count(Rid, SrvId, Mailtype) ->
    Sql = "select count(*) from role_mail where to_rid=~s and to_srv_id=~s and mailtype=~s",
    case db:get_one(Sql, [Rid, SrvId, Mailtype]) of
        {ok, Count} -> {ok, Count};
        _Else -> {false, ?L(<<"读取邮件数量出错">>)}
    end.

%% 删除指定角色的一封邮件
% delete_oldest(Rid, SrvId, Mailtype) ->
%     Sql = "select min(ct) from role_mail where to_rid=~s and to_srv_id=~s and mailtype=~s",
%     Sql2 = "delete from role_mail where to_rid=~s and to_srv_id=~s and mailtype=~s and ct=~s", 
%     case db:get_one(Sql, [Rid, SrvId, Mailtype]) of
%         {ok, CT} ->
%             db:execute(Sql2, [Rid, SrvId, Mailtype,CT]),
%             ok;              
%         _Else -> 
%             {false, ?L(<<"读取邮件数量出错">>)}
%     end.


%% 邮件数据量最大值  0:表示无限制
get_max(?MAIL_TYPE_NOR) -> 20;
get_max(?MAIL_TYPE_SYS) -> 0;
get_max(_) -> 20.

%%------------------------------------------------------
%% 增加后台管理维护日志
%%------------------------------------------------------

%% 增加信件日志
%% 后台管理维护使用
add_log(1, _Mail = #mail{id = Id, send_time = CT, from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName, to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName, subject = Subject, content = Content, mailtype = Mailtype, assets = Assets, attachment = Items}) when is_list(Assets) andalso is_list(Items) ->
    ?DEBUG("---Mail--~p~n", [_Mail]),
    spawn( 
        fun() ->
                Sql = "insert into log_mail_all (id,from_rid,from_srv_id,from_name,to_rid,to_srv_id,to_name,mailtype,subject,content,assets,items,coin,gold,bind_gold,stone,scale,ct) values(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)",
                Coin = find_assets(?mail_coin, Assets),
                % BindCoin = find_assets(?mail_coin_bind, Assets),
                Gold = find_assets(?mail_gold, Assets),
                BindGold = find_assets(?mail_gold_bind, Assets),
                Stone = find_assets(?mail_stone, Assets),
                Scale = find_assets(?mail_scale, Assets),
                db:execute(Sql, [Id, FromRid, FromSrvId, FromName, ToRid, ToSrvId, ToName, Mailtype, Subject, Content, type_to_desc(Assets, <<>>), item_to_desc(Items, <<>>), Coin, Gold, BindGold, Stone, Scale, CT])
        end
    );
add_log(_, _) -> ok.

%% 取指定资产类型
find_assets(_Type, []) -> 0;
find_assets(Type, [{Type, Val} | _]) -> Val;
find_assets(Type, [_ | T]) ->
    find_assets(Type, T).

%% 资产类型转换成文字说明
type_to_desc([], Str) -> Str;
type_to_desc([{Type, Val} | T], Str) ->
    Desc = type_to_desc(Type),
    NewS = util:fbin("[~s:~p]", [Desc, Val]),
    type_to_desc(T, <<Str/binary, NewS/binary>>).

type_to_desc(?mail_coin) -> "金币";
type_to_desc(?mail_gold) -> "晶钻";
type_to_desc(?mail_gold_bind) -> "绑定晶钻";
type_to_desc(?mail_stone) -> "符石";
type_to_desc(?mail_scale) -> "龙鳞";

type_to_desc(?mail_coin_bind) -> "绑定金币";
type_to_desc(?mail_arena) -> "竞技场积分";
type_to_desc(?mail_exp) -> "经验";
type_to_desc(?mail_psychic) -> "灵力";
%% type_to_desc(?mail_honor) -> "荣誉值";
type_to_desc(?mail_activity) -> "精力";
type_to_desc(?mail_attainment) -> "阅力";
%% type_to_desc(?mail_hearsay) -> "传音";
type_to_desc(?mail_charm) -> "魅力";
type_to_desc(?mail_flower) -> "送花积分";
type_to_desc(?mail_guild_war) -> "帮战积分";
type_to_desc(?mail_guild_devote) -> "帮会贡献";
type_to_desc(?mail_career_devote) -> "师门积分";
type_to_desc(?mail_lilian) -> "仙道历练";
type_to_desc(?mail_practice) -> "试纸积分";
type_to_desc(?mail_soul) -> "魂气值";
type_to_desc(Type) ->
    util:fbin("未知类型[~p]", [Type]).

%% 物品数据转换成描述
item_to_desc([], Str) -> Str;
item_to_desc([#item{base_id = BaseId, quantity = Num} | T], Str) ->
    {ok, #item_base{name = Name}} = item_data:get(BaseId),
    NewS = util:fbin("[~s(~p) 数量:~p]", [Name, BaseId, Num]),
    item_to_desc(T, <<Str/binary, NewS/binary>>).
