%% Author: caochuncheng2002@gmail.com
%% Created: 2013-5-31
%% Description: 日志接口
-module(common_log).

-include("common.hrl").
-include("common_server.hrl").

-export([
         insert_log/2,
         
         log_goods/1,
         log_goods_list/1,
         
         log_gold/1,
         log_silver/1,
         log_coin/1,
         log_common/1,
         
         log_letter/1
         ]).
-export([
         get_log_role_snapshot/2         
        ]).


%%============================元宝日志==========================
log_gold({RoleBase,LogType,LogTime,Gold}) ->
    log_gold({RoleBase,LogType,LogTime,Gold,0,0,""});
log_gold({RoleBase,LogType,LogTime,Gold,LogDesc}) ->
    log_gold({RoleBase,LogType,LogTime,Gold,0,0,LogDesc});
log_gold({RoleBase,LogType,LogTime,Gold,ItemTypeId,ItemNum,LogDesc}) ->
    #p_role_base{role_id = RoleId,role_name = RoleName,
                 account_name = AccountName,account_type = AccountType,account_via = AccountVia,
                 level = RoleLevel,gold = RemainGold} = RoleBase,
    SubLogType = LogType div 10000 rem 10,
    LogInfo = #r_log_gold{role_id = RoleId,role_name = RoleName,level = RoleLevel,
                          account_name = AccountName,account_type = AccountType,account_via = AccountVia,
                          type = LogType,mtype = SubLogType,mtime = LogTime,
                          gold = Gold,
                          item_id = ItemTypeId,num = ItemNum,
                          remain_gold = RemainGold,
                          log_desc = LogDesc},
    insert_log(gold,LogInfo).
%%============================元宝日志==========================

%%============================银子日志==========================
log_silver({RoleBase,LogType,LogTime,Silver}) ->
    log_silver({RoleBase,LogType,LogTime,Silver,0,0,""});
log_silver({RoleBase,LogType,LogTime,Silver,LogDesc}) ->
    log_silver({RoleBase,LogType,LogTime,Silver,0,0,LogDesc});
log_silver({RoleBase,LogType,LogTime,Silver,ItemTypeId,ItemNum,LogDesc}) ->
    #p_role_base{role_id = RoleId,role_name = RoleName,
                 account_name = AccountName,account_type = AccountType,account_via = AccountVia,
                 level = RoleLevel,silver = RemainSilver} = RoleBase,
    SubLogType = LogType div 10000 rem 10,
    LogInfo = #r_log_silver{role_id = RoleId,role_name = RoleName,level = RoleLevel,
                            account_name = AccountName,account_type = AccountType,account_via = AccountVia,
                            type = LogType,mtype = SubLogType,mtime = LogTime,
                            money = Silver,
                            item_id = ItemTypeId,num = ItemNum,
                            remain_money = RemainSilver,
                            log_desc = LogDesc},
    insert_log(silver,LogInfo).
%%============================银子日志==========================

%%============================铜钱日志==========================
log_coin({RoleBase,LogType,LogTime,Coin}) ->
    log_coin({RoleBase,LogType,LogTime,Coin,0,0,""});
log_coin({RoleBase,LogType,LogTime,Coin,LogDesc}) ->
    log_coin({RoleBase,LogType,LogTime,Coin,0,0,LogDesc});
log_coin({RoleBase,LogType,LogTime,Coin,ItemTypeId,ItemNum,LogDesc}) ->
    #p_role_base{role_id = RoleId,role_name = RoleName,
                 account_name = AccountName,account_type = AccountType,account_via = AccountVia,
                 level = RoleLevel,coin = RemainCoin} = RoleBase,
    SubLogType = LogType div 10000 rem 10,
    LogInfo = #r_log_coin{role_id = RoleId,role_name = RoleName,level = RoleLevel,
                          account_name = AccountName,account_type = AccountType,account_via = AccountVia,
                          type = LogType,mtype = SubLogType,mtime = LogTime,
                          coin = Coin,
                          item_id = ItemTypeId,num = ItemNum,
                          remain_coin = RemainCoin,
                          log_desc = LogDesc},
    insert_log(coin,LogInfo).
%%============================铜钱日志==========================

%%============================通用日志==========================
log_common({RoleId,Code,LogTime,Val1}) ->
    LogInfo = #r_log_common{role_id=RoleId,code=Code,val_1=Val1,val_2=0,val_3=0,val_4=0,val_5=0,mtime=LogTime,desc=""},
    insert_log(common, LogInfo);
log_common({RoleId,Code,LogTime,Val1,LogDesc}) ->
    LogInfo = #r_log_common{role_id=RoleId,code=Code,val_1=Val1,val_2=0,val_3=0,val_4=0,val_5=0,mtime=LogTime,desc=LogDesc},
    insert_log(common, LogInfo);
log_common({RoleId,Code,LogTime,Val1,Val2,LogDesc}) ->
    LogInfo = #r_log_common{role_id=RoleId,code=Code,val_1=Val1,val_2=Val2,val_3=0,val_4=0,val_5=0,mtime=LogTime,desc=LogDesc},
    insert_log(common, LogInfo);
log_common({RoleId,Code,LogTime,Val1,Val2,Val3,Val4,Val5,LogDesc}) ->
    LogInfo = #r_log_common{role_id=RoleId,code=Code,val_1=Val1,val_2=Val2,val_3=Val3,val_4=Val4,val_5=Val5,mtime=LogTime,desc=LogDesc},
    insert_log(common, LogInfo).

%%============================通用日志==========================

%%============================道具日志==========================
log_goods_list({RoleBase,LogType,LogTime,GoodsList,LogDesc}) ->
    log_goods_list({RoleBase,LogType,LogTime,GoodsList,0,LogDesc});
log_goods_list({RoleBase,LogType,LogTime,GoodsList,MapId,LogDesc}) ->
    #p_role_base{role_id = RoleId,role_name = RoleName,level = RoleLevel,
                 account_name = AccountName,account_type = AccountType,account_via = AccountVia} = RoleBase,
    
    LogInfoList = [begin 
                       #p_goods{via=GoodsVia,type_id=TypeId,number=Number} = Goods,
                       #r_log_goods{role_id = RoleId,role_name = RoleName,level = RoleLevel,
                                    account_name = AccountName,account_type = AccountType,account_via = AccountVia,
                                    type = LogType,
                                    mtime = LogTime,
                                    item_via = GoodsVia,
                                    item_id = TypeId,
                                    num = Number,
                                    map_id = MapId,
                                    detail = get_default_goods_detail(Goods),
                                    log_desc = LogDesc
                                   }
                       end || Goods <- GoodsList],
    insert_log(goods,LogInfoList).
    
log_goods({RoleBase,LogType,LogTime,Goods,LogDesc}) ->
    GoodsDetail = get_default_goods_detail(Goods),
    log_goods({RoleBase,LogType,LogTime,Goods,0,GoodsDetail,LogDesc});
log_goods({RoleBase,LogType,LogTime,Goods,MapId,LogDesc}) ->
    GoodsDetail = get_default_goods_detail(Goods),
    log_goods({RoleBase,LogType,LogTime,Goods,MapId,GoodsDetail,LogDesc});
log_goods({RoleBase,LogType,LogTime,Goods,MapId,GoodsDetail,LogDesc})->
    #p_role_base{role_id = RoleId,role_name = RoleName,level = RoleLevel,
                 account_name = AccountName,account_type = AccountType,account_via = AccountVia} = RoleBase,
    #p_goods{via=GoodsVia,type_id=TypeId,number=Number} = Goods,
    LogInfo = #r_log_goods{role_id = RoleId,role_name = RoleName,level = RoleLevel,
                           account_name = AccountName,account_type = AccountType,account_via = AccountVia,
                           type = LogType,
                           mtime = LogTime,
                           item_via = GoodsVia,
                           item_id = TypeId,
                           num = Number,
                           map_id = MapId,
                           detail = GoodsDetail,
                           log_desc = LogDesc
                          },
    insert_log(goods,LogInfo).

get_default_goods_detail(#p_goods{type = ?TYPE_EQUIP} = Goods) ->
    #p_goods{id=GoodsId,
             level=GoodsLevel,
             start_time=StartTime,
             end_time=EndTime,
             status=Status,
             punch_num=PunchNum,
             power=Power,
             equip_stone=EquipStone} = Goods,
    common_lang:get_format_lang_resources("{\"id\":~s,\"level\":~s,\"start_time\":~s,\"end_time\":~s,\"status\":~s,\"punch_num\":~s,\"power\":~s,\"equip_stone\":\\\"~s\\\"}", 
                                          [GoodsId,GoodsLevel,StartTime,EndTime,Status,PunchNum,Power,get_string_by_list(EquipStone,"")]);
get_default_goods_detail(Goods) ->
    #p_goods{id=GoodsId,
             start_time=StartTime,
             end_time=EndTime,
             status=Status} = Goods,
    common_lang:get_format_lang_resources("{\"id\":~s,\"start_time\":~s,\"end_time\":~s,\"status\":~s}", 
                                          [GoodsId,StartTime,EndTime,Status]).
%%============================道具日志==========================

%%============================信件日志==========================
log_letter(LogLetterInfoList) when erlang:is_list(LogLetterInfoList) ->
    NewLogLetterInfoList = 
        [begin 
             GoodsStr = get_log_letter_godds_str(LogLetterInfo#r_log_letter.attachments,"["),
			 case LogLetterInfo#r_log_letter.content of
				 {Key,_} ->
					 NewContent = common_tool:to_list(Key);
				 NewContent ->
					 next
			 end,
             LogLetterInfo#r_log_letter{content = NewContent,attachments = GoodsStr}
         end || LogLetterInfo <- LogLetterInfoList],
    insert_log(letter, NewLogLetterInfoList);
log_letter(LogLetterInfo) ->
	case LogLetterInfo#r_log_letter.content of
		{Key,_} ->
			NewContent = common_tool:to_list(Key);
		NewContent ->
			next
	end,
    GoodsStr = get_log_letter_godds_str(LogLetterInfo#r_log_letter.attachments,"["),
    insert_log(letter, [LogLetterInfo#r_log_letter{content = NewContent,attachments = GoodsStr}]),
    ok.

get_log_letter_godds_str([],GoodsStr) ->
    lists:concat([GoodsStr,"]"]);
get_log_letter_godds_str([HGoods|GoodsList],GoodsStr) ->
    case erlang:is_record(HGoods, p_goods) of
        true ->
            case GoodsList of
                [] ->
                    NewGoodsStr = lists:concat([GoodsStr,common_misc:record_to_json(HGoods)]);
                _ ->
                    NewGoodsStr = lists:concat([GoodsStr,common_misc:record_to_json(HGoods),","])
            end,
            get_log_letter_godds_str(GoodsList,NewGoodsStr);
        _ ->
            [HGoods|GoodsList]
    end.

%%============================信件日志==========================

%% 写日志到远程日志节点
insert_log(_,LogInfo)->
    logger_sender:log(LogInfo).

%% 将列表转换成 String
get_string_by_list([],Str) ->
    Str;
get_string_by_list([Value|List],Str)->
    case Str of
        "" ->
            NewStr = lists:concat(common_tool:to_list(Value));
        _ ->
            NewStr = lists:concat([Str,","|common_tool:to_list(Value)])
    end,
    get_string_by_list(List,NewStr).


get_log_role_snapshot(RoleBase,RolePos) ->
    #p_role_base{role_id = RoleId,gongxun=GongXun} = RoleBase,
    #r_role_pos{map_id = MapId,pos = #p_pos{x = X,y = Y}} = RolePos,
    ParamList = ["\"role_id\":" ++ common_tool:to_list(RoleId),
                 "\"gongxun\":" ++ common_tool:to_list(GongXun)],
    ExtraInfo = "{" ++ string:join(ParamList, ",") ++ "}",
    #p_role_base{role_id=RoleId,
                 role_name=RoleName,
                 account_name=AccountName,
                 account_via=AccountVia,
                 account_type=AccountType,
                 account_status=AccountStatus,
                 create_time=CreateTime,
                 faction_id=FactionId,
                 category=Category,
                 sex=Sex,
                 level=RoleLevel,
                 exp=Exp,
                 next_level_exp=NextLevelExp,
                 family_id=FamilyId,
                 family_name=FamilyName,
                 is_pay=IsPay,
                 total_gold=TotalGold,
                 gold=Gold,
                 silver=Silver,
                 coin=Coin,
                 last_login_time=LastLoginTime,
                 last_offline_time=LastOffineTime,
                 total_online_time=TotalOnlineTime,
                 last_device_id=LastDeviceId} = RoleBase,
    #r_log_role_snapshot{role_id = RoleId,
                         role_name = RoleName,
                         account_name = AccountName,
                         account_via = AccountVia,
                         account_type = AccountType,
                         account_status = AccountStatus,
                         create_time = CreateTime,
                         faction_id = FactionId,
                         category = Category, 
                         gender = Sex,
                         level = RoleLevel,
                         exp = Exp,
                         next_level_exp = NextLevelExp,
                         family_id = FamilyId,
                         family_name = FamilyName, 
                         is_pay = IsPay,
                         total_gold= TotalGold,
                         gold = Gold,
                         silver = Silver,
                         coin =  Coin,
                         last_login_time = LastLoginTime,
                         last_logout_time = LastOffineTime,
                         total_online_time= TotalOnlineTime, 
                         mtime = common_tool:now(),
                         map_id = MapId,
                         tx = X,
                         ty = Y,
						 last_device_id=LastDeviceId,
                         extra_info = ExtraInfo}.

                                                            