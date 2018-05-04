%%----------------------------------------------------
%% %% 防沉迷系统RPC 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(fcm_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("log_client.hrl").

%% 身份证认证
handle(13400, {Sfz, Name}, Role) ->
    case fcm:auth_sfz(Role, {Sfz, Name}) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} -> {reply, {1, <<"通过">>}, NRole}
    end;

%% 防沉迷认证
handle(13401, {}, Role) ->
    case fcm:auth(Role) of
        {Ver, AccTime, N, NRole} -> {reply, {Ver, AccTime, N, <<>>}, NRole};
        _ -> {ok}
    end;

%% 防沉迷（韩国）
handle(13410, {}, Role) ->
    fcm_kr:authenticate(Role);

%% 客户端日志信息借用该模块一协议号
handle(13430, {Md5, System, Browser, FpVersion, ClientVarsion, ErrorCode, Msg}, _Role = #role{id = {RoleId, SrvId}, account = Account, name = Name}) ->
    log_client:insert(#log_client_msg{role_id = RoleId, srv_id = SrvId, account = Account, name = Name, md5 = Md5, system = System, browser = Browser, fp_version = FpVersion, client_version = ClientVarsion, error_code = ErrorCode, msg = Msg, time = util:unixtime()}),
    {ok};

%% 请求新的验证码数据
handle(13495, {Cmd}, Role) ->
    T = case get(captcha_update) of
        T1 when is_integer(T1) -> T1;
        _ -> 0
    end,
    Now = util:unixtime(),
    case T + 1 > Now of
        true -> {ok};
        false ->
            case captcha:do(13495, {Cmd}, Role) of
                false -> {ok};
                {ok, ImgBin} -> 
                    put(captcha_update, Now),
                    {reply, {Cmd, ImgBin}}
            end
    end;

%% 进行验证码验证
handle(13496, {Cmd, Code}, Role) ->
    case captcha:do(13496, {Cmd, Code}, Role) of
        false -> 
            {reply, {2, <<>>, Cmd, <<>>}};
        {false, ImgBin} ->
            {reply, {0, <<>>, Cmd, ImgBin}};
        ok ->
            {reply, {1, <<>>, Cmd, <<>>}};
        {ok, NewRole} ->
            {reply, {1, <<>>, Cmd, <<>>}, NewRole}
    end;

handle(_Cmd, _Data, _Role) -> %% 容错处理
    {error, unknow_command}.
