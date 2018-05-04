%%----------------------------------------------------
%% @doc 社交模块
%%
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(sns_dao).

-include("common.hrl").

-export([
        %% get_sns/2
        %% ,insert_sns/6
        %% ,update_sns/6
        get_role_by_name/1
        ,get_role_by_name2/1
        ,get_role_by_id/2
        ,get_role_by_id2/2
    ]
).

%% get_sns(ParamRid, ParamSrvId) ->
%%     Sql = "select rid, srv_id, fr_max, online_late, fr_group, signature from role_sns where rid = ~s and srv_id = ~s",
%%     case db:get_row(Sql, [ParamRid, ParamSrvId]) of
%%         [] ->
%%             {false, []};
%%         [Rid, SrvId, FrMax, OnlineLate, FrGroup, Signature] ->
%%             {true, [Rid, SrvId, FrMax, OnlineLate, FrGroup, Signature]}
%%     end.
%% 
%% insert_sns(Rid, SrvId, FrMax, OnlineLate, FrGroup, Signature) ->
%%     NewFrGroup = util:term_to_bitstring(FrGroup),
%%     Sql = "insert into role_sns(rid, srv_id, fr_max, online_late, fr_group, signature) values (~s, ~s, ~s, ~s, ~s)",
%%     db:execute(Sql, [Rid, SrvId, FrMax, OnlineLate, NewFrGroup, Signature]).
%% 
%% update_sns(Rid, SrvId, FrMax, OnlineLate, FrGroup, Signature) ->
%%     NewFrGroup = util:term_to_bitstring(FrGroup),
%%     Sql = "update role_sns set fr_max = ~s, online_late = ~s, fr_group = ~s, signature = ~s where rid = ~s and srv_id = ~s",
%%     db:execute(Sql, [FrMax, OnlineLate, NewFrGroup, Signature, Rid, SrvId]).

get_role_by_name(Name) ->
    Sql = <<"select id, srv_id, name from role where name = ~s">>,
    case db:get_row(Sql, [Name]) of
        {ok, [Rid, SrvId, Name2]} ->
            {true, [Rid, SrvId, Name2]};
        {error, _Msg} ->
            ?DEBUG("执行数据库出错了[Msg:~w]", [_Msg]),
            {false, []}
    end.

get_role_by_name2(Name) ->
    Sql = <<"select srv_id,lev,career,sex,portrait_id from role where is_delete <> 1 and name = ~s">>,
    case db:get_row(Sql, [Name]) of
        {ok, [SrvId,Lev,Career,Sex,FaceId]} ->
            {true, [SrvId,Lev,Career,Sex,FaceId]};
        {error, _Msg} ->
            ?DEBUG("执行数据库出错了[Msg:~w]", [_Msg]),
            {false, []}
    end.


get_role_by_id(RoleId, SrvId) ->
    Sql = <<"select id, srv_id, name, sex, career,login_time from role where id = ~s and srv_id = ~s and is_delete <> 1">>,
    case db:get_row(Sql, [RoleId, SrvId]) of
        {ok, [Rid, SrvId, Name, Sex, Career, LoginTime]} ->
            {true, [Rid, SrvId, Name, Sex, Career, LoginTime]};
        {error, _Msg} ->
            {false, []}
    end.
                                            
get_role_by_id2(RoleId, SrvId) ->
    Sql = <<"select id, srv_id, name, sex, career,lev from role where id = ~s and srv_id = ~s and is_delete <> 1">>,
    case db:get_row(Sql, [RoleId, SrvId]) of
        {ok, [Rid, SrvId, Name, Sex, Career, Lev]} ->
            {true, [Rid, SrvId, Name, Sex, Career, Lev]};
        {error, _Msg} ->
            ?DEBUG("***get_role_by_id2**:~s~n",[_Msg]),
            % ?DUMP(_Msg),
            {false, []}
    end.
