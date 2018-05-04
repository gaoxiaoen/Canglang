%%----------------------------------------
%% 防沉迷系统
%%----------------------------------------
-module(fcm_kr).
-export([authenticate/1]).

-include("role.hrl").
-include("fcm.hrl").
-include("link.hrl").
-include("common.hrl").

-define(try_time, (3 * 86400)).
-define(fcm_kr_forbid_age, 18).

%% @spec authenticate(Role) -> {ok} | {ok, NewRole} 
%% @doc 认证玩家是否通过认证
authenticate(Role = #role{pid = Pid, login_info = #login_info{reg_time = RegTime}}) ->
    case sys_env:get(fcm_version) of
        ?fcm_version_close -> %% 关闭版本
            {ok};
        _ ->
            case fcm_dao:get_auth_info(Role) of
                {ok, Age, _Auth} when Age < ?fcm_kr_forbid_age ->
                    role:stop(async, Pid, <<>>),
                    {ok};
                {ok, _Age, 1} ->
                    {ok};
                _ ->    %% 未认证
                    case (util:unixtime() - RegTime) > ?try_time of
                        true ->
                            role:stop(async, Pid, get_auth_msg()),
                            {ok};     %% 过了三天试玩期
                        false ->
                            {ok}              %% 试玩三天
                    end
            end
    end.

%% 获取认证提示信息
get_auth_msg() -> <<"인증이 안된 아이디는 게임을 할 수 없습니다. <u><a href='http://sky.koramgame.co.kr/2012/0819/article_59.html'>인증하기</a></u>">>.
