%%----------------------------------------------------
%%  buff
%%
%% @author shawnoyc@163.com
%%----------------------------------------------------
-module(buff_adm).
-export([
        del_buff/3
    ]
).

-include("buff.hrl").
-include("common.hrl").
-include("role.hrl").


del_buff({id, Id, SrvId}, label, Label) ->
    case role_api:lookup(by_id, {Id, SrvId}, #role.pid) of
        {ok, _N, Pid} -> 
            role:apply(async, Pid, {fun do_del_buff/3, [label, Label]}),
            ok;
        _ -> 
            ?INFO("角色不在线"),
            ok
    end.

do_del_buff(Role = #role{name = Name, buff = #rbuff{buff_list = BuffList}}, label, Label) ->
    {ok, NewRole} = case lists:keyfind(Label, #buff.label, BuffList) of
        false ->
            ?INFO("未发现[~s]身上有Label为:~w的BUFF效果",[Name, Label]),
            {ok, Role};
        #buff{id = BuffId} ->
            ?INFO("已清除[~s]身上Label为:~w的BUFF效果",[Name, Label]),
            buff:del_by_id(Role, BuffId)
    end,
    {ok, NewRole}.
