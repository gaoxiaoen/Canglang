%% @filename mod_map_team.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-02-15 
%% @doc 
%% 地图队伍处理，即组队，队伍管理.

-module(mod_map_team).

-include("mgeem.hrl").

-export([
         handle/1
        ]).


handle({Module,?TEAM_CREATE,DataRecord,RoleId,PId,_Line}) ->
    do_team_create(Module,?TEAM_CREATE,DataRecord,RoleId,PId);

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).


%% 创建队伍
do_team_create(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_team_create2(RoleId) of
        {ok} ->
            do_team_create3(Module,Method,DataRecord,RoleId,PId);
        {error,OpCode} ->
            do_team_create_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_team_create2(RoleId) ->
    case mod_role:get_role_base(RoleId) of
        {ok,RoleBase} ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,?_RC_TEAM_CREATE_000})
    end,
    case RoleBase#p_role_base.team_id > 0 of
        true ->
            erlang:throw({error,?_RC_TEAM_CREATE_001});
        _ ->
            next
    end,
    {ok}.
do_team_create3(_Module,_Method,_DataRecord,_RoleId,_PId) ->
    
    ok.
do_team_create_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_team_create_toc{op_code=OpCode},
    ?DEBUG("do team create info fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).