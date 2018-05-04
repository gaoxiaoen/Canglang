%%----------------------------------------------------
%% @doc 社交模块
%%
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(sns).

-export([
        login/1
        ,logout/1
        ,init/2
        ,clean_gift/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("role_online.hrl").
-include("sns.hrl").
-include("vip.hrl").
-include("link.hrl").

login(Role) ->
    NRole = friend:login(Role),
    NRole.
 
logout(Role) ->
    friend:logout(Role).


%% 创建原始sns记录
init(RoleId, SrvId) ->
    #sns{role_id = RoleId, srv_id = SrvId, fr_max = ?def_fr_max, online_late = util:unixtime(), fr_group = [], signature = ?L(<<"Oh yeah 新月世界 ！">>)}.

%% 接收祝福回赠数清零
% clean_receive_gift(Role = #role{login_info = #login_info{last_logout = LastLogout}}) ->
%     Now = util:unixtime(),
%     Today = util:unixtime({today, Now}),
%     Tomorrow = Today + 86400,
%     case LastLogout < Today of
%         true ->
%             role_timer:set_timer(clean_sns_gift, (Tomorrow - Now) * 1000, {sns, clean_gift, []}, 1, clean_gift_role(Role));
%         false ->
%             role_timer:set_timer(clean_sns_gift, (Tomorrow - Now) * 1000, {sns, clean_gift, []}, 1, Role)
%     end.

clean_gift(Role) ->
    Now = util:unixtime(),
    Tomorrow = util:unixtime({today, Now}) + 86400,
    {ok, role_timer:set_timer(clean_sns_gift, (Tomorrow - Now) * 1000, {sns, clean_gift, []}, 1, clean_gift_role(Role))}.

clean_gift_role(Role = #role{sns = Sns}) ->
    Role#role{sns = Sns#sns{receive_gift = 0}}.
