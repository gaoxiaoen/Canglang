%%%-------------------------------------------------------------------
%%%
%%%
%%% @doc
%%%
%%% @end
%%%
%%%-------------------------------------------------------------------
-module(mgeeweb_get).

-include("mgeeweb.hrl").

%% API
-export([
         handle/3
        ]).

%%处理
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
		get(Path, Req, DocRoot)
	catch 
		ErrType:ErrReason -> 
			?ERROR_MSG("ErrType=~w,Reason=~w,Stacktrace=~w", [ErrType,ErrReason,erlang:get_stacktrace()]),
			Req:not_found()
	end.



%%实际的get处理
get("account" ++ RemainPath, Req, DocRoot) ->
    mod_account_service:get(RemainPath, Req, DocRoot);

get(Path, Req, DocRoot) ->
    ?ERROR_MSG("~ts,Path=~w, Req=~w,DocRoot=~w",["receive unknown message",Path, Req, DocRoot]),
    Req:not_found().

