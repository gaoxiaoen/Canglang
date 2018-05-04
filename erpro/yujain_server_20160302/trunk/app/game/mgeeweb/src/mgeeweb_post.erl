%%%-------------------------------------------------------------------
%%%
%%%
%%% @doc
%%%
%%% @end
%%%
%%%-------------------------------------------------------------------
-module(mgeeweb_post).

-include("mgeeweb.hrl").

%% API
-export([handle/3]).

handle("crossdomain.xml", Req, _DocRoot) ->
    CrossdomainXML = "
<cross-domain-policy>
<allow-access-from domain=\"*\"/>
</cross-domain-policy>",
%%     CrossdomainXML = "
%% <cross-domain-policy>
%% <allow-http-request-headers-from domain=\"*\" headers=\"*\" secure=\"true\"/>
%% <allow-access-from domain=\"*\"/>
%% </cross-domain-policy>",
    mgeeweb_tool:return_xml({auto_head, CrossdomainXML}, Req);

handle(Path, Req, DocRoot) ->
	try 
		post(Path, Req, DocRoot)
	catch 
		ErrType:ErrReason -> 
			?ERROR_MSG("ErrType=~w,Reason=~w,Stacktrace=~w", [ErrType,ErrReason,erlang:get_stacktrace()]),
			Req:not_found()
	end.

post("goods" ++ RemainPath, Req, DocRoot) ->
    mod_goods_service:handle(RemainPath, Req, DocRoot);

post("role" ++ RemainPath, Req, DocRoot) ->
    mod_role_service:handle(RemainPath, Req, DocRoot);

post("family" ++ RemainPath, Req, DocRoot) ->
    mod_family_service:handle(RemainPath, Req, DocRoot);

post("pay" ++ RemainPath, Req, DocRoot) ->
    mod_pay_service:handle(RemainPath, Req, DocRoot);

post("admin" ++ RemainPath, Req, DocRoot) ->
    mod_admin_service:handle(RemainPath, Req, DocRoot);

post("broadcast" ++ RemainPath, Req, DocRoot) ->
    mod_broadcast_service:handle(RemainPath, Req, DocRoot);

post("ban" ++ RemainPath, Req, DocRoot) ->
    mod_ban_service:handle(RemainPath, Req, DocRoot);

post("limit/account" ++ RemainPath, Req, DocRoot) ->
    mod_limit_account_service:handle(RemainPath, Req, DocRoot);

post("limit/ip" ++ RemainPath, Req, DocRoot) ->
    mod_limit_ip_service:handle(RemainPath, Req, DocRoot);

post("limit/device_id" ++ RemainPath, Req, DocRoot) ->
    mod_limit_device_id_service:handle(RemainPath, Req, DocRoot);

post("customer" ++ RemainPath, Req, DocRoot) ->
    mod_customer_service:handle(RemainPath, Req, DocRoot);


post(Path, Req, DocRoot) ->
    ?ERROR_MSG("~ts,Path=~w, Req=~w,DocRoot=~w",["receive unknown message",Path, Req, DocRoot]),
    Req:not_found().