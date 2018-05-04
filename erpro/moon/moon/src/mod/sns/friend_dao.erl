%%----------------------------------------------------
%% @doc friend_dao
%%
%% <pre>
%% 好友关系表
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(friend_dao).

-export([
        get_friends/2
        ,get_friends2/3
        ,get_friend_by_id/4
        ,delete_friend/4
        ,delete_friend_type/3
        ,insert_friend/8
        ,update_friend_type/5
        ,update_friend_intimacy/5
        ,update_friend_onlinlate/2
        ,update_friend_group/5
        ,get_count/3
        ,update_friend_name/3
        ,insert_friend_apply/2
        ,get_friend_apply/1
        ,get_friend_apply2/1
        ,delete_friend_apply/2
        ,delete_friend_apply_all/1
        ,update_friend_mail_sign/5 %%添加好友来信标识
        ,update_friend_mail_sign2/3 %%删除好友来信标识
        ,update_friend_last_chat/5
        ,insert_friend_agree_message/2
        ,select_friend_agree_message/1
        ,delete_friend_agree_message_all/1
        ,update_friend_give_flag/6
        ,update_friend_recv_flag/6
        ,update_friend_energy_flag/8
        ,get_deleted_friends/2
        ,insert_del_friend/5
        ,delete_del_friend/2
        ,delete_del_friend/4
    ]
).

-include("common.hrl").
-include("sns.hrl").

%% @spec get_friends(RoleId, SrvId) -> {false, []} | {true, Data}
%% @doc
%% <pre>
%% RoleId= integer() 角色Id
%% SrvId = string() 服务器标识
%% Data = list() 查询结果
%% 根据角色Id及服务器标识获取好友的信息
%% </pre>
get_friends(RoleId, SrvId) ->
    Sql = "select owner_rid, owner_srv_id, fr_rid, fr_srv_id, fr_name, fr_type, intimacy, fr_group_id, online_late, give_time, give_flag, recv_time, recv_flag from role_friend_relation where owner_rid = ~s and owner_srv_id = ~s",
    case db:get_all(Sql, [RoleId, SrvId]) of
        {ok, []} ->
            {false, []};
        {ok, Data} ->
            {true, Data};
        {error, _Msg} ->
            ?DEBUG("获取好友信息为空:[Msg:~w]", [_Msg]),
            {false, []}
    end.

%%只获取好友类型，数据库表存储三种类型：好友，陌生人，黑名单，其中存储陌生人的作用主要用于离线向陌生人发邮件(留言)，更新最近联系陌生人
get_friends2(RoleId, SrvId,_FrType) ->
    Sql = "select owner_rid, owner_srv_id, fr_rid, fr_srv_id, fr_name, fr_type, intimacy, fr_group_id, online_late from role_friend_relation where owner_rid = ~s and owner_srv_id = ~s",
    case db:get_all(Sql, [RoleId, SrvId]) of
        {ok, []} ->
            {false, []};
        {ok, Data} ->
            {true, Data};
        {error, _Msg} ->
            ?DEBUG("获取好友信息为空:[Msg:~w]", [_Msg]),
            {false, []}
    end.


%% @spec get_friend_by_id(RoleId, SrvId, FrRoleId, FrSrvId) -> {false, []} | {true, Data}
%% @doc
%% <pre>
%% RoleId = integer() 角色Id
%% SrvId = string() 角色服务器标识
%% FrRoleId = integer() 好友Id
%% FrSrvId = string() 好友服务器标识
%% Data = list() 查询结果
%% 获取指定好友的信息
%% </pre>
get_friend_by_id(RoleId, SrvId, FrRoleId, FrSrvId) ->
    Sql = "select owner_rid, owner_srv_id, fr_rid, fr_srv_id, fr_name, fr_type, intimacy, fr_group_id from role_friend_relation where owner_rid = ~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    case db:get_row(Sql, [RoleId, SrvId, FrRoleId, FrSrvId]) of
        {ok, [RoleId, SrvId, FrRoleId, FrSrvId, FrName, FrType, Intimacy, FrGroupId]} ->
            {true, [RoleId, SrvId, FrRoleId, FrSrvId, FrName, FrType, Intimacy, FrGroupId]};
        {error, _Msg} ->
            %% ?DEBUG("没有找到好友信息[Msg:~w]", [_Msg]),
            {false, []}
    end.

%% 插入一条好友关系记录
insert_friend(RoleId, SrvId, FrRoleId, FrSrvId, FrName, FrType, Intimacy, FrGroupId) ->
    Sql = "insert into role_friend_relation (owner_rid, owner_srv_id, fr_rid, fr_srv_id, fr_name, fr_type, intimacy, fr_group_id, give_time, give_flag, recv_time, recv_flag) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    db:execute(Sql, [RoleId, SrvId, FrRoleId, FrSrvId, FrName, FrType, Intimacy, FrGroupId, 0, ?no_give, 0, ?no_recv]).

%% 更新好友体力赠送标志
update_friend_energy_flag(GiveTime, GiveFlag, RecvTime, RecvFlag, RoleId, SrvId, FrRoleId, FrSrvId) ->
    Sql = "update role_friend_relation set give_time = ~s, give_flag = ~s, recv_time = ~s, recv_flag = ~s where owner_rid =~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [GiveTime, GiveFlag, RecvTime, RecvFlag, RoleId, SrvId, FrRoleId, FrSrvId]).

%% 更新好友体力赠送标志
update_friend_give_flag(GiveTime, GiveFlag, RoleId, SrvId, FrRoleId, FrSrvId) ->
    Sql = "update role_friend_relation set give_time = ~s, give_flag = ~s where owner_rid =~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [GiveTime, GiveFlag, RoleId, SrvId, FrRoleId, FrSrvId]).
%% 更新好友体力赠送标志
update_friend_recv_flag(RecvTime, RecvFlag, RoleId, SrvId, FrRoleId, FrSrvId) ->
    Sql = "update role_friend_relation set recv_time = ~s, recv_flag = ~s where owner_rid =~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [RecvTime, RecvFlag, RoleId, SrvId, FrRoleId, FrSrvId]).


%% 更新好友来信标识
update_friend_mail_sign(Mail_Sign, RoleId, SrvId, FrRoleId, FrSrvId) ->
    Sql = "update role_friend_relation set mail_sign = ~s where owner_rid =~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [Mail_Sign, RoleId, SrvId, FrRoleId, FrSrvId]).

%% 删除好友来信标识
update_friend_mail_sign2(Mail_Sign, RoleId, SrvId) ->
    Sql = "update role_friend_relation set mail_sign = ~s where owner_rid =~s and owner_srv_id = ~s",
    db:execute(Sql, [Mail_Sign, RoleId, SrvId]).

%% 更新好友联系时间
update_friend_last_chat(Time, RoleId, SrvId, FrRoleId, FrSrvId) ->
    Sql = "update role_friend_relation set last_chat = ~s where owner_rid =~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [Time, RoleId, SrvId, FrRoleId, FrSrvId]).

get_deleted_friends(RoleId, SrvId) ->
    Sql = "select owner_rid, owner_srv_id, fr_rid, fr_srv_id, give_time from sys_del_friend where owner_rid = ~s and owner_srv_id = ~s",
    case db:get_all(Sql, [RoleId, SrvId]) of
        {ok, []} ->
            {false, []};
        {ok, Data} ->
            {true, Data};
        {error, _Msg} ->
            ?DEBUG("获取已经删除好友信息为空:[Msg:~w]", [_Msg]),
            {false, []}
    end.

%% 插入一条已删除好友纪录
insert_del_friend(RoleId, SrvId, FrRoleId, FrSrvId, Time) ->
    Sql = "insert into sys_del_friend (owner_rid, owner_srv_id, fr_rid, fr_srv_id, give_time) values (~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [RoleId, SrvId, FrRoleId, FrSrvId, Time]) of
        {ok, _Ok} ->
            ?DEBUG("********* 保存已经删除数据成功 : ~w", [_Ok]);
        _Err ->
            ?DEBUG("*********** 保存已经删除好友失败 原因 ~w", [_Err]),
            skip
    end.

%%删除过期的删除好友纪录
delete_del_friend(RoleId, SrvId, FrRoleId, FrSrvId) ->
    Sql = "delete from  sys_del_friend where owner_rid = ~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [RoleId, SrvId, FrRoleId, FrSrvId]).

delete_del_friend(RoleId, SrvId) ->
    Sql = "delete from sys_del_friend where owner_rid = ~s and owner_srv_id = ~s",
    db:execute(Sql, [RoleId, SrvId]).

%% 更新好友类型
update_friend_type(RoleId, SrvId, FrRoleId, FrSrvId, FrType) ->
    GroupId = 
    case FrType of
            ?sns_friend_type_hy ->
                ?sns_fr_group_id_hy;
            ?sns_friend_type_cr ->
                ?sns_fr_group_id_cr;
            ?sns_friend_type_hmd ->
                ?sns_fr_group_id_hmd;
            _ ->
                ?sns_fr_group_id_hy
    end,
    %% ?DEBUG("===================update_friend_type[RoleId:~w, GroupId:~w, FrType:~w]", [RoleId, GroupId, FrType]),
    Sql = "update role_friend_relation set fr_type = ~s, fr_group_id = ~s where owner_rid = ~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [FrType, GroupId, RoleId, SrvId, FrRoleId, FrSrvId]).

%% 更新好友亲密度
update_friend_intimacy(RoleId, SrvId, FrRoleId, FrSrvId, Intimacy) ->
    Sql = "update role_friend_relation set intimacy = ~s where owner_rid = ~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [Intimacy, RoleId, SrvId, FrRoleId, FrSrvId]).

%% 更新好友分组
update_friend_group(RoleId, SrvId, FrRoleId, FrSrvId, FrGroupId) ->
    Sql = <<"update role_friend_relation set fr_group_id = ~s where owner_rid = ~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s">>,
    db:execute(Sql, [FrGroupId, RoleId, SrvId, FrRoleId, FrSrvId]).

%% 更新好友分组
update_friend_name(FrRoleId, FrSrvId, FrName) ->
    Sql = <<"update role_friend_relation set fr_name = ~s where fr_rid = ~s and fr_srv_id = ~s">>,
    db:execute(Sql, [FrName, FrRoleId, FrSrvId]).

%% 更新好友分组
update_friend_onlinlate(RoleId, SrvId) ->
    Sql = <<"update role_friend_relation set online_late = ~s where fr_rid = ~s and fr_srv_id = ~s">>,
    db:execute(Sql, [util:unixtime(), RoleId, SrvId]).

%% @spec delete_friend(RoleId, SrvId, FrRoleId, FrSrvId) -> AffectedRow
%% @doc
%% <pre>
%% RoleId = integer() 角色Id
%% SrvId = string() 服务器标识
%% FrRoleId = integer() 好友Id
%% FrSrvId = string() 好友服务器标识
%% AffectedRow = integer() 影响的行数
%% 删除指定好友的关系
%% </pre>
delete_friend(RoleId, SrvId, FrRoleId, FrSrvId) ->
    Sql = "delete from role_friend_relation where owner_rid = ~s and owner_srv_id = ~s and fr_rid = ~s and fr_srv_id = ~s",
    db:execute(Sql, [RoleId, SrvId, FrRoleId, FrSrvId]).

%%删除指定类型的好友
delete_friend_type(RoleId, SrvId,Type) ->
    Sql = "delete from role_friend_relation where owner_rid = ~s and owner_srv_id = ~s and fr_type = ~s",
    db:execute(Sql, [RoleId, SrvId, Type]).

get_count(RoleId, SrvId, FrType) ->
    Sql = "select count(*) from role_friend_relation where owner_rid = ~s and owner_srv_id = ~s and fr_type = ~s",
    case db:get_one(Sql, [RoleId, SrvId, FrType]) of
        {error, _Msg} -> 0;
        {ok, Num} -> Num
    end.

%% 获取好友申请数据
get_friend_apply(ToRoleId) ->
    Sql = "select from_rid, vip_type, from_srv_id, from_name, career, face_id, from_lev,from_sex from role_friend_apply where to_rid = ~s",
        case db:get_all(Sql, [ToRoleId]) of
            {ok, []} ->
                {false, []};
            {ok, Data} ->
                ?DEBUG("获取好友申请数据:[Msg:~w]", [Data]),
                % {true, formate_data(Data,[])};
                {true, Data};
            {error, _Msg} ->
                ?DEBUG("获取好友申请信息为空:[Msg:~w]", [_Msg]),
                {false, []}
        end.

get_friend_apply2(ToRoleId) ->
    Sql = "select from_rid, from_srv_id from role_friend_apply where to_rid = ~s",
        case db:get_all(Sql, [ToRoleId]) of
            {ok, []} ->
                {false, []};
            {ok, Data} ->
                ?DEBUG("获取好友申请数据:[Msg:~w]", [Data]),
                ?DEBUG("获取好友申请数据:[Msg:~w]", [Data]),
                % {true, formate_data(Data,[])};
                {true, Data};
            {error, _Msg} ->
                ?DEBUG("获取好友申请信息为空:[Msg:~w]", [_Msg]),
                {false, []}
        end.

%% 当角色离线时，将好友申请存入数据库
insert_friend_apply(ToRoleId,{FromRoleId, VipType, SrvId, FromRoleName,Career,FaceId, RLev, RSex}) ->
    Sql = "insert into role_friend_apply (to_rid, from_rid, vip_type, from_srv_id, from_name, career, face_id, from_lev,from_sex) values (~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    db:execute(Sql, [ToRoleId, FromRoleId, VipType, SrvId, FromRoleName,Career,FaceId, RLev, RSex]).
%% 忽略，同意好友申请时都会触发删除
delete_friend_apply(ToRoleId,FromRoleId) ->
    Sql = "delete from role_friend_apply where to_rid = ~s and  from_rid = ~s",
    db:execute(Sql, [ToRoleId, FromRoleId]).
 
delete_friend_apply_all(ToRoleId) ->
    Sql = "delete from role_friend_apply where to_rid = ~s",
    db:execute(Sql, [ToRoleId]).



%% 当角色离线时，被同意添加为好友时会记录
insert_friend_agree_message(ToRoleId,Name) ->
    Sql = "insert into role_friend_agree_sys_message (by_name,to_rid) values (~s, ~s)",
    db:execute(Sql, [Name, ToRoleId]).
%% 查找某一个角色的系统消息

select_friend_agree_message(ToRoleId) ->
    Sql = "select by_name from role_friend_agree_sys_message where to_rid = ~s ",
    case db:get_all(Sql, [ToRoleId]) of
            {ok, []} ->
                {false, []};
            {ok, Data} ->
                ?DEBUG("获取同意申请的好友姓名:[Msg:~w]", [Data]),
                {true, Data};
            {error, _Msg} ->
                ?DEBUG("获取同意申请的好友姓名:[Msg:~w]", [_Msg]),
                {false, []}
        end.
 
delete_friend_agree_message_all(ToRoleId) ->
    Sql = "delete from role_friend_agree_sys_message where to_rid = ~s",
    db:execute(Sql, [ToRoleId]).
