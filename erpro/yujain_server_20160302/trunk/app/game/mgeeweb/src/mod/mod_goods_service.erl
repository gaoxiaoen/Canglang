%%%-------------------------------------------------------------------
%%% @author liuwei <>
%%% @copyright (C) 2010, liuwei
%%% @doc
%%%
%%% @end
%%% Created :11 Nov 2010 by liuwei <>
%%%-------------------------------------------------------------------
-module(mod_goods_service).

-include("mgeeweb.hrl").
-define(ETS_FILTER_LIST,ets_filter_list).
-define(ADMIN_ROLE_SEND_MONEY,admin_role_send_money).

%% API
-export([
         handle/3
        ]).


handle("/send_goods" ++ _, Req, _) ->
    do_send_goods(Req);


handle(Path, Req, _) ->
    ?ERROR_MSG("~ts,Path=~w,Req=~w",["receive unknown message",Path,Req]),
    mgeeweb_tool:return_json_error(Req).

-define(send_goods_op_type_by_role,1). %% 指定人发送物品
-define(send_goods_op_type_by_all,2). %% 全服发送物品
-define(send_goods_op_type_by_condition,3). %% 根据条件发送物品
do_send_goods(Req) ->
    case catch do_send_goods2(Req) of
        {ok,RoleIdList,Title,Text,Gold,Silver,Coin,GoodsList} ->
            do_send_goods3(Req,RoleIdList,Title,Text,Gold,Silver,Coin,GoodsList);
        {error,OpCode,OpReason} ->
            do_send_goods_error(Req,OpCode,OpReason)
    end.

%% 请求参数说明
%% op_type 操作类型,1指定人发送物品,2全服发送物品,3根据条件发送物品
%% role_id_list 玩家id列表,逗号分隔,当操作类型为1时，需要传此参数
%% e_title 邮件标题
%% e_content 邮件内容
%% gold 金币
%% silver 未使用
%% args 道具参数
%% 发送条件参数
%% sex 玩家性别
%% faction_id 国家id
%% start_level 开始等级
%% end_level 结束等级
%% selected_compare 等级条件
%% family_name 帮派名称
%% last_stamp 距离上次登录时间
%% is_online 是否在线
do_send_goods2(Req) ->
    ok = mgeeweb_tool:check_admin_api_request(Req),
    QueryString = Req:parse_post(),
    OpType = common_tool:to_integer(proplists:get_value("op_type",QueryString,"0")),
    case OpType of
        ?send_goods_op_type_by_role ->
            PRoleIdListStr = proplists:get_value("role_id_list",QueryString,""),
            PRoleIdList = string:tokens(PRoleIdListStr,","),
            RoleIdList = [common_tool:to_integer(PRoleId) || PRoleId <- PRoleIdList],
            case RoleIdList of
                [] ->
                    erlang:throw({error,?_RC_GOODS_SEND_GOODS_001,""});
                _ ->
                    next
            end,
            next;
        ?send_goods_op_type_by_all ->
            RoleIdList = db_api:dirty_all_keys(?DB_ROLE_BASE),
            next;
        ?send_goods_op_type_by_condition ->
            Sex = common_tool:to_integer(proplists:get_value("sex",QueryString,"0")),
            FactionId = common_tool:to_integer(proplists:get_value("faction_id",QueryString,"0")),
            StartLevel =  common_tool:to_integer(proplists:get_value("start_level",QueryString,"0")),
            EndLevel =  common_tool:to_integer(proplists:get_value("end_level",QueryString,"0")),
            SelCmpParam = proplists:get_value("selected_compare",QueryString,""),
            FamilyName = proplists:get_value("family_name",QueryString,""),
            LastStamp = common_tool:to_integer(proplists:get_value("last_stamp",QueryString,"0")),
            IsOnline = common_tool:to_integer(proplists:get_value("is_online",QueryString,"0")),
            ConditionParam = {Sex,FactionId,StartLevel,EndLevel,SelCmpParam,FamilyName,LastStamp,IsOnline},
            RoleIdList = get_role_id_list_by_send_condition(ConditionParam),
            next;
        _ ->
            RoleIdList = [],
            erlang:throw({error,?_RC_GOODS_SEND_GOODS_000,""})
    end,
    %% 信件内容
    Title =  base64:decode_to_string(base64:decode_to_string(proplists:get_value("e_title", QueryString,""))),
    case Title of
        "" ->
            erlang:throw({error,?_RC_GOODS_SEND_GOODS_002,""});
        _ ->
            next
    end,
    Text = base64:decode_to_string(base64:decode_to_string(proplists:get_value("e_content", QueryString,""))),
    case Text of
        "" ->
            erlang:throw({error,?_RC_GOODS_SEND_GOODS_003,""});
        _ ->
            next
    end,
    %% 
    Gold = common_tool:to_integer(proplists:get_value("gold", QueryString,"0")),
    Silver = common_tool:to_integer(proplists:get_value("silver", QueryString,"0")),
    
    Coin = common_tool:to_integer(proplists:get_value("coin", QueryString,"0")),
    
    %% 道具参数
    GoodsArgs = proplists:get_value("args", QueryString,""),
    GoodsList = get_goods_list_by_param(GoodsArgs),
    {ok,RoleIdList,Title,Text,Gold,Silver,Coin,GoodsList}.

%% 道具参数格式
%% item_type 道具类型,1道具,2宝石,3装备
%% type_id 道具类型id
%% item_num 道具数量
%% start_time,end_time 开始时间,结束时间 ,时间戳
%% days 有效天数
%% color 道具颜色1-6
%% quality 装备品质  1-5
%% reinforce 强化等级 1-36
%% punch_num 开孔数
%% item_type,type_id,item_num,bind_type,start_time,end_time,days,color,quality,reinforce,punch_num|....
get_goods_list_by_param("") ->
    [];
get_goods_list_by_param(Args) ->
    StrArgsList = string:tokens(Args,"|"),
    get_goods_list_by_param2(StrArgsList,[]).
get_goods_list_by_param2([],GoodsList) ->
    GoodsList;
get_goods_list_by_param2([StrArgs|StrArgsList],GoodsList) ->
    StrParamList =string:tokens(StrArgs, ","),
    {CreateInfo,_Index}=
        lists:foldl(
          fun(StrParam,{AccCreateInfo,AccIndex})->
                  NewAccIndex = AccIndex + 1,
                  case AccIndex of
                      1-> {AccCreateInfo#r_goods_create_info{item_type = common_tool:to_integer(StrParam)},NewAccIndex};
                      2-> {AccCreateInfo#r_goods_create_info{type_id = common_tool:to_integer(StrParam)},NewAccIndex};
                      3-> {AccCreateInfo#r_goods_create_info{item_num = common_tool:to_integer(StrParam)},NewAccIndex};
%%                       4-> {AccCreateInfo#r_goods_create_info{bind_type = common_tool:to_integer(StrParam)},NewAccIndex};
                      5-> {AccCreateInfo#r_goods_create_info{start_time = common_tool:to_integer(StrParam)},NewAccIndex};
                      6-> {AccCreateInfo#r_goods_create_info{end_time = common_tool:to_integer(StrParam)},NewAccIndex};
                      7-> {AccCreateInfo#r_goods_create_info{days = common_tool:to_integer(StrParam)},NewAccIndex};
%%                       8-> {AccCreateInfo#r_goods_create_info{color = common_tool:to_integer(StrParam)},NewAccIndex};
%%                       9-> {AccCreateInfo#r_goods_create_info{quality = common_tool:to_integer(StrParam)},NewAccIndex};
%%                       10-> {AccCreateInfo#r_goods_create_info{reinforce = common_tool:to_integer(StrParam)},NewAccIndex};
                      11-> {AccCreateInfo#r_goods_create_info{punch_num = common_tool:to_integer(StrParam)},NewAccIndex};
                      _ ->
                          {AccCreateInfo,NewAccIndex}
                  end      
          end, {#r_goods_create_info{via = ?GOODS_VIA_ADMIN_SENND_GOODS},1}, StrParamList),
    case common_goods:create_goods(CreateInfo) of
        {ok,PGoodsList} ->
            next;
        _ ->
            PGoodsList = [],
            erlang:throw({error,?_RC_GOODS_SEND_GOODS_004,""})
    end,
    get_goods_list_by_param2(StrArgsList,PGoodsList ++ GoodsList).

%% 根据条件查询符合的玩家id
get_role_id_list_by_send_condition({Sex,FactionId,StartLevel,EndLevel,SelCmpParam,FamilyName,LastStamp,IsOnline}) ->
    MatchHead = #p_role_base{role_id='$1',_='_',level='$2',sex='$3',faction_id='$4',family_name='$5',last_login_time='$6'},
    case SelCmpParam of
        ">"-> Guard = [{'>','$2',EndLevel}];
        "="-> Guard = [{'=:=','$2',EndLevel}];
        "<"-> Guard = [{'<','$2',EndLevel}];
        ">="-> Guard = [{'>=','$2',EndLevel}];
        "<="-> Guard = [{'=<','$2',EndLevel}];
        "between"-> Guard = [{'>=','$2',StartLevel},{'=<','$2',EndLevel}];
        _-> Guard = []
    end,
    case Sex of
        0 -> Guard2 = Guard;
        _ -> Guard2 = [{'=:=','$3',Sex}|Guard]
    end,
    case FactionId of
        0 -> Guard3 = Guard2;
        _ -> Guard3 = [{'=:=','$4',FactionId}|Guard2]
    end,
    case FamilyName of
        [] -> Guard4 = Guard3;
        _ -> Guard4 = [{'=:=','$5',FamilyName} | Guard3]
    end,
    case LastStamp of
        0 -> Guard5 = Guard4;
        _ -> Guard5 = [{'>','$6',LastStamp}|Guard4]
    end,
    PRoleIdList = db_api:dirty_select(?DB_ROLE_BASE, [{MatchHead, Guard5, ['$1']}]),
    case IsOnline of
        1 ->
            OnLineRoleIdList = db_api:dirty_all_keys(?DB_ROLE_ONLINE),
            RoleIdList = 
                lists:foldl(
                  fun(PRoleId,AccRoleIdList) -> 
                          case lists:member(PRoleId,OnLineRoleIdList) of
                              true ->
                                  [PRoleId|AccRoleIdList];
                              _ ->
                                  AccRoleIdList
                          end
                  end,[],PRoleIdList),
            next;
        _ ->
            RoleIdList = PRoleIdList
    end,
    RoleIdList.

do_send_goods3(Req,RoleIdList,Title,Text,Gold,Silver,Coin,GoodsList) ->
    %% 处理发送信件
    ?TRY_CATCH(erlang:send(mgeew_letter_server,{admin_send_goods,{RoleIdList,Title,Text,Gold,Silver,Coin,GoodsList}}),Err),
    Rtn = [{op_code,0},{op_reason,""}],
    mgeeweb_tool:return_json(Rtn, Req).

do_send_goods_error(Req,OpCode,OpReason) ->
    ?ERROR_MSG("~ts,Req=~w,OpCode=~w,OpReason=~w",["admin send googds error",Req,OpCode,OpReason]),
    Rtn = [{op_code,OpCode},{op_reason,OpReason}],
    mgeeweb_tool:return_json(Rtn, Req).