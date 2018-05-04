%%----------------------------------------------------
%% 平台接口
%% @author  qingxuan
%%----------------------------------------------------
-module(platform_api).
-include("common.hrl").
-include("role.hrl").
-include("vip.hrl").

%% 后台接口
-export([
    login/1
]).

login(Role) ->
    try do_login(Role)
    catch T:X ->
        ?ERR("~p", {T, X}),
        Role
    end.

do_login(Role = #role{account = Account, name = RoleName, id = {RoleId, _SrvId}, login_info = LoginInfo, lev = Lev, vip = Vip}) ->
    RegTime = case LoginInfo of
        #login_info{reg_time = RegTime_} -> RegTime_; 
        _ -> 0
    end,
    IsVip = case Vip of
        #vip{type = VipType} when VipType > 0 -> 1;
        _ -> 0
    end,
    SrvName = case sys_env:get(platform_srv_cn) of
        _SrvName when is_binary(_SrvName) orelse is_list(_SrvName) -> _SrvName;
        _ -> <<>>
    end,
    EncodedRoleName = util:urlencode(unicode:characters_to_list(RoleName)),
    EncodedAccount = util:urlencode(unicode:characters_to_list(Account)),
    Url = io_lib:format("http://games.yeahworld.com/auth/phone_usersingame.html?qid=~s&gid=~s&sid=~s&regtime=~p&level=~p&is_vip=~p&rolename=~s&role_id=~p", [EncodedAccount, <<"moon">>, SrvName, RegTime, Lev, IsVip, EncodedRoleName, RoleId]),
    ?DEBUG(Url),
    httpc:request(get, {Url, []}, [{timeout, 3000}], [{sync, false}]),
    Role.
