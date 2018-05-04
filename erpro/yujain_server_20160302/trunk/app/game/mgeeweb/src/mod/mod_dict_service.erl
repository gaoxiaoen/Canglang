%% Author: caochuncheng2002@gmail.com
%% Created: 2013-6-20
%% Description: 管理平台字典接口
-module(mod_dict_service).

%%
%% Include files
%%
-include("mgeeweb.hrl").
%%
%% Exported Functions
%%
-export([
         do/1
         ]).

%%
%% API Functions
%%

do(Req) ->
    case catch do2(Req) of
        {error,OpCode,OpReason} ->
            Rtn = [{op_code,OpCode},{op_reason,OpReason}];
        {ok,goods,ItemDict,StoneDict,EquipDict} ->
            Rtn = [{op_code,0},{op_reason,""},
                   {item,ItemDict},{stone,StoneDict},{equip,EquipDict}];
        {ok,Data} ->
            Rtn = [{op_code,0},{op_reason,""},{data,Data}]
    end,
    mgeeweb_tool:return_json(Rtn, Req).

do2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    Action =  proplists:get_value("action",QueryString,""),
    do3(Action,QueryString).

do3("goods",_QueryString) ->
    {ok,goods,cfg_item:get_dict(),cfg_stone:get_dict(),cfg_equip:get_dict()};
do3("item",_QueryString) ->
    {ok,cfg_item:get_dict()};
do3("stone",_QueryString) ->
    {ok,cfg_stone:get_dict()};
do3("equip",_QueryString) ->
    {ok,cfg_equip:get_dict()};
do3("mission",_QueryString) ->
    {ok,cfg_mission_dict:get_mission_dict()};
do3("log",_QueryString) ->
    {ok,cfg_log_dict:get_log_dict()};
do3("map",_QueryString) ->
    {ok,cfg_map_dict:get_map_dict()};
do3(_Action,_QueryString) ->
    {error,?_RC_ADMIN_API_005,""}.

