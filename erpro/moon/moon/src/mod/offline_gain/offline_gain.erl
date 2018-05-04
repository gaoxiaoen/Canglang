%%----------------------------------------------------
%% 离线收益
%%
%% @doc 可发送离线收益系统 
%%
%% @author qingxuan
%%----------------------------------------------------
-module(offline_gain).
-export([
    send/2
    ,send/3
    ,login/1
]).

-include("common.hrl").
-include("gain.hrl").
-include("role.hrl").

send({RoleId, SrvId}, Gains, Notification) ->
    notification:send(offline, {RoleId, SrvId}, Notification),
    send({RoleId, SrvId}, Gains).

send({RoleId, SrvId}, Gains) ->
    db:execute(?DB_SYS, "INSERT INTO `offline_gain` (`role_id`, `srv_id`, `gains`, `fetched`, `ctime`) VALUES (~s, ~s, ~s, 0, ~s)", [RoleId, SrvId, util:term_to_bitstring(Gains), util:unixtime()]).

login(Role = #role{id = {RoleId, SrvId}}) ->
    case db:get_all("SELECT `gains` FROM `offline_gain` WHERE `role_id`=~s AND `srv_id`=~s AND `fetched`=0", [RoleId, SrvId]) of
        {ok, Data = [_|_]} ->
            Gains = lists:foldl(fun([StrGains], Acc) -> 
                    case util:bitstring_to_term(StrGains) of
                        {ok, G = [#gain{}|_]} -> 
                            Acc ++ G;
                        _ParseGainsErr -> 
                            ?ERR("~p", [_ParseGainsErr]),
                            Acc
                    end
                end, [], Data),
            Now = util:unixtime(),
            case db:execute("UPDATE `offline_gain` SET `fetched`=1, `fetch_time`=~s WHERE `role_id`=~s AND `srv_id`=~s AND `fetched`=0", [Now, RoleId, SrvId]) of
                {ok, _Affected} ->
                    lists:foldl(fun(Gain, TmpRole) ->
                        case role_gain:do(Gain, TmpRole) of
                            {ok, NewRole} -> NewRole;
                            {false, _G} -> TmpRole  %% 不能领的东西直接扔掉
                        end
                    end, Role, Gains);
                Other ->
                    ?ERR("~p", [Other]),
                    Role
            end;
        {ok, _Other} ->
            Role;
        {error, _Reason} ->
            ?ERR("~p", [_Reason]),
            Role
    end.

