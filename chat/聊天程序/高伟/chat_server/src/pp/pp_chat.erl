%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 10:55
%%%-------------------------------------------------------------------
-module(pp_chat).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").

%%世界
handle(11001, Status, [Data])
  when is_list(Data)->
  Data1 = [Status#player_status.accid, Status#player_status.accname, Data],
  {ok, BinData} = pt_11:write(11001, Data1),
  lib_send:send_to_all(BinData);

%%私聊
%%_Uid:用户ID
%%_Nick:用户名
%%Data:内容
%%_Uid 和 _Nick 任意一个即可
handle(11002, Status, [Color, _Uid, _Nick, Data])
  when is_list(Data)->
  Data1 = [Status#player_status.accid, Status#player_status.accname, Data, Color],
  {ok, BinData} = pt_11:write(11002, Data1),
  lib_send:send_to_uid(_Uid, BinData);

handle(_Cmd, _Status, _Data) ->
  ?DEBUG("pp_chat no match", []),
  {error, "pp_chat no match"}.
