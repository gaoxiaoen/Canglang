%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 二月 2015 下午4:54
%%%-------------------------------------------------------------------
-module(player_setting).
-author("fancy").
-include("common.hrl").
-include("server.hrl").

%% %% API
%% -export([init/1,get_setting/1 ,update_setting/2]).
%%
%%
%% get_setting(Player) ->
%%     SettingStatus = lib_dict:get(?PROC_STATUS_SETTING),
%%     #st_setting{
%%        sell_1 = S1,
%%        sell_2 = S2,
%%        sell_3 = S3,
%%        sell_4 = S4,
%%        sell_career = S5,
%%        close_chat = Clc
%%     } = SettingStatus,
%%     SettingString = io_lib:format("~p,~p,~p,~p,~p,~p",[S1,S2,S3,S4,S5,Clc]),
%%     {ok,Bin} = pt_130:write(13010,SettingString),
%%     server_send:send_to_sid(Player#player.sid,Bin),
%%     ok.
%%
%% update_setting(Player,SettingString) ->
%%     SettingList = util:explode(",",SettingString),
%%     S1 = util:to_integer(lists:nth(1,SettingList)),
%%     S2 = util:to_integer(lists:nth(2,SettingList)),
%%     S3 = util:to_integer(lists:nth(3,SettingList)),
%%     S4 = util:to_integer(lists:nth(4,SettingList)),
%%     S5 = util:to_integer(lists:nth(5,SettingList)),
%%     Clc = util:to_integer(lists:nth(6,SettingList)),
%%     SettingStatus = #st_setting{
%%         sell_1 = S1,
%%         sell_2 = S2,
%%         sell_3 = S3,
%%         sell_4 = S4,
%%         sell_career = S5,
%%         close_chat = Clc
%%     },
%%     lib_dict:put(?PROC_STATUS_SETTING,SettingStatus),
%%     String = setting_to_string(SettingStatus),
%%     SQL = io_lib:format("update player_login set setting = '~s' where id = ~p and sn = ~p and pf = ~p",[String,Player#player.id,Player#player.sn,Player#player.pf]),
%%     db:execute(SQL),
%%     {ok,Bin} = pt_130:write(13011,1),
%%     server_send:send_to_sid(Player#player.sid,Bin),
%%     ok.
%%
%% init(SettingList) ->
%%     Setting = config_stting(SettingList,#st_setting{}),
%%     lib_dict:put(?PROC_STATUS_SETTING,Setting),
%%     ok.
%%
%% config_stting(undefined,Setting) ->Setting;
%% config_stting([],Setting) -> Setting;
%% config_stting([{Key,V}|L],Setting) ->
%%     Setting2 =
%%         case Key of
%%             s1 -> Setting#st_setting{sell_1 = V};
%%             s2 -> Setting#st_setting{sell_2 = V};
%%             s3 -> Setting#st_setting{sell_3 = V};
%%             s4 -> Setting#st_setting{sell_4 = V};
%%             s5 -> Setting#st_setting{sell_career = V};
%%             clc -> Setting#st_setting{close_chat = V};
%%             _ -> Setting
%%         end,
%%     config_stting(L,Setting2).
%%
%% setting_to_string(Setting) ->
%%     #st_setting{
%%         sell_1 = S1,
%%         sell_2 = S2,
%%         sell_3 = S3,
%%         sell_4 = S4,
%%         sell_career = S5,
%%         close_chat = Clc
%%     } = Setting,
%%     SettingList = [{s1,S1},{s2,S2},{s3,S3},{s4,S4},{s5,S5},{clc,Clc}],
%%     util:term_to_string(SettingList).
