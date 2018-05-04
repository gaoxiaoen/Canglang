%%%-------------------------------------------------------------------
%%% File        :common_fcm.erl
%%%-------------------------------------------------------------------
-module(common_fcm).

%% API
-export([
         get_fcm_validation_tip/1,
         set_fcm_flag/1,
		 get_fcm_url/2
        ]).

-include("common.hrl").

set_fcm_flag(true) ->
    db_api:dirty_write(?DB_SYSTEM_CONFIG, #r_system_config{key=fcm, value="true"}),
	common_misc:gen_system_config_beam();
set_fcm_flag(_) ->
    db_api:dirty_write(?DB_SYSTEM_CONFIG, #r_system_config{key=fcm, value="false"}),
	common_misc:gen_system_config_beam().


get_fcm_validation_tip(1) ->
    true;
get_fcm_validation_tip(2) ->
    {false, ?_LANG_FCM_001};
get_fcm_validation_tip(-1) ->
    {false, ?_LANG_FCM_002};
get_fcm_validation_tip(-2) ->
    {false, ?_LANG_FCM_003};
get_fcm_validation_tip(-4) ->
    true;
get_fcm_validation_tip(-5) ->
    {false, ?_LANG_FCM_004};
get_fcm_validation_tip(-6) ->
    {false, ?_LANG_FCM_000};
get_fcm_validation_tip(-3) ->
    {false, ?_LANG_FCM_005};
get_fcm_validation_tip(_R) ->
    {false, ?_LANG_FCM_000}.


get_fcm_url(Realname,Card)->
	[FcmValidationKey] = common_config_dyn:find_common(fcm_validation_key),
	[FcmValidationUrl] = common_config_dyn:find_common(fcm_validation_url),
    case common_config:get_agent_name() of
        "4399" ->
            Url = lists:concat([FcmValidationUrl, "?account=",
                                mochiweb_util:quote_plus(erlang:get(account_name)), "&truename=", mochiweb_util:quote_plus(Realname), "&card=",
                                Card, "&sign=", common_tool:md5(lists:concat([Realname, 
                                                                              common_tool:to_list(erlang:get(account_name)), 
                                                                              FcmValidationKey,
                                                                              Card]))]),
            ok;
        "2918" ->
            %% 做了urlencode
            MD5 = common_tool:md5(lists:concat([mochiweb_util:quote_plus(Realname), mochiweb_util:quote_plus(erlang:get(account_name)),
                                                FcmValidationKey, Card])),
            Param = mochiweb_util:urlencode([{"account", erlang:get(account_name)}, {"truename", Realname}, {"card", Card}]),
            Url = lists:concat([FcmValidationUrl, "?", Param, "&sign=", MD5]);
        "96pk" ->
            %% 做了urlencode
            MD5 = common_tool:md5(lists:concat([mochiweb_util:quote_plus(Realname), 
                                                mochiweb_util:quote_plus(erlang:get(account_name)),
                                                FcmValidationKey, Card])),
            Param = mochiweb_util:urlencode([{"account", erlang:get(account_name)}, {"truename", Realname}, {"card", Card}]),
            Url = lists:concat([FcmValidationUrl, Param, "&sign=", MD5]);
        "pptv" ->
            MD5 = common_tool:md5(lists:concat([mochiweb_util:quote_plus(Realname), 
                                                mochiweb_util:quote_plus(erlang:get(account_name)),
                                                FcmValidationKey, Card])),
            [ServerID] = common_config_dyn:find(common,agent_id),
            Param = mochiweb_util:urlencode([{"gid", "mccq"}, {"account", erlang:get(account_name)}, {"truename", Realname}, {"card", Card},{"server_id",ServerID}]),
            Url = lists:concat([FcmValidationUrl, "?", Param, "&sign=", MD5]);
        _ ->
            MD5 = common_tool:md5(lists:concat([mochiweb_util:quote_plus(Realname), mochiweb_util:quote_plus(erlang:get(account_name)),
                                                FcmValidationKey, Card])),
            [ServerID] = common_config_dyn:find(common,agent_id),
            Param = mochiweb_util:urlencode([{"account", erlang:get(account_name)}, {"truename", Realname}, {"card", Card},{"server_id",ServerID}]),
            Url = lists:concat([FcmValidationUrl, "?", Param, "&sign=", MD5])
    end,
    {ok,Url}.