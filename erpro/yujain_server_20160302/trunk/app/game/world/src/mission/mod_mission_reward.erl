%% Author: caochuncheng2002@gmail.com
%% Created: 2013-06-27
%% Description:发放奖励
-module(mod_mission_reward).

%%
%% Include files
%%
-include("mgeew.hrl").  
%%
%% Exported Functions
%%
-export([
         reward/7,
         reward_calc/6,
         do_mission_reward/5
        ]).

%%
%% API Functions
%%

%% 任务奖励
%% 返回{ok,NewRoleBase,PMissionInfo}
reward(RoleId,PId,DataRecord,RoleBase,MissionColor,NewCommitTimes,MissionBaseInfo) ->
    case MissionBaseInfo#r_mission_base_info.type of
        ?MISSION_TYPE_LOOP ->
            do_reward_loop(RoleId,PId,DataRecord,RoleBase,MissionColor,NewCommitTimes,MissionBaseInfo);
        _ ->
            do_reward_normal(RoleId,PId,DataRecord,RoleBase,MissionColor,NewCommitTimes,MissionBaseInfo)
    end.

%% 循环任务奖励
do_reward_loop(RoleId,PId,DataRecord,RoleBase,MissionColor,NewCommitTimes,MissionBaseInfo) ->
    #r_mission_base_info{big_group = BigGroup,
                         reward_info = RewardInfo} = MissionBaseInfo,
    #p_role_base{level = RoleLevel} = RoleBase,
        case cfg_mission:find_mission_loop_reward({BigGroup,RoleLevel}) of
            [{LoopRewardInfo,LoopRewardItemList}] ->
                next;
            _ ->
                LoopRewardInfo = undefined,LoopRewardItemList = [],
                erlang:throw({error,?_RC_MISSION_DO_010,""})
        end,
    NewRewardInfo = 
        RewardInfo#r_mission_reward{exp=LoopRewardInfo#r_mission_reward.exp,
                                    silver=LoopRewardInfo#r_mission_reward.silver,
                                    coin=LoopRewardInfo#r_mission_reward.coin
                                   },
    case lists:keyfind(NewCommitTimes, 1, LoopRewardItemList) of
        false ->
            RewardItemList = [];
        {_,RewardItemList} ->
            next
    end,
    %% 基本属性奖励
    PMissionReward = get_reward_base(MissionColor,NewCommitTimes,NewRewardInfo,#p_mission_reward{}),
    %% 任务道具奖励
    #p_role_base{category = RoleCategory} = RoleBase,
    GoodsList = get_reward_item(DataRecord,NewRewardInfo,RoleCategory,RewardItemList),
    NewPMissionReward = PMissionReward#p_mission_reward{goods_list = GoodsList},
    {ok,NewRoleBase} = do_mission_reward(RoleId,PId,RoleBase,NewPMissionReward,1),
    {ok,NewRoleBase,NewPMissionReward}.

%% 一般任务奖励
do_reward_normal(RoleId,PId,DataRecord,RoleBase,MissionColor,NewCommitTimes,MissionBaseInfo) ->
    #p_role_base{category = RoleCategory} = RoleBase,
    #r_mission_base_info{reward_info = RewardInfo,reward_item_list = RewardItemList} = MissionBaseInfo,
    %% 基本属性奖励
    PMissionReward = get_reward_base(MissionColor,NewCommitTimes,RewardInfo,#p_mission_reward{}),
    %% 任务道具奖励
    GoodsList = get_reward_item(DataRecord,RewardInfo,RoleCategory,RewardItemList),
    NewPMissionReward = PMissionReward#p_mission_reward{goods_list = GoodsList},
    {ok,NewRoleBase} = do_mission_reward(RoleId,PId,RoleBase,NewPMissionReward,1),
    {ok,NewRoleBase,NewPMissionReward}.

%% 任务奖励操作
%% {ok,NewRoleBase}
do_mission_reward(RoleId,PId,RoleBase,PMissionReward,DoTimes) ->
    #p_role_base{coin = Coin,silver=Silver} = RoleBase,
    #p_mission_reward{exp=AddExp,
                      silver =AddSilver,
                      coin = AddCoin,
                      goods_list = GoodsList} = PMissionReward,
    %% 加钱
    NewRoleBase = RoleBase#p_role_base{coin = Coin + AddCoin,
                                       silver = Silver + AddSilver},
    %% 道具奖励
	case GoodsList of
		[] -> %% 没有道具奖励
			IsLetter = false,
			NewGoodsList = [],
			LogGoodsList = [];
		_ ->
			case catch mod_bag:t_create_goods_by_p_goods(RoleId, GoodsList) of
				{ok,NewGoodsList,LogGoodsList} ->
					IsLetter = false,
					next;
				{bag_error,not_enough_pos} -> %% 发送信件
					IsLetter = true,
					NewGoodsList = [],
					LogGoodsList = GoodsList;
				BagError ->
					IsLetter = false,
					NewGoodsList = [],
					LogGoodsList = [],
					erlang:throw(BagError)
			end
	end,
    %% 加角色经经验，加其它经验，调用统一接口
    Func = 
        fun() ->
                LogTime = common_tool:now(),
                mod_role_bi:do_add_exp(RoleId,?ADD_EXP_TYPE_MISSION,AddExp),
                %% 道具日志
                case IsLetter of
                    true ->
                        next;
                    _ ->
						case NewGoodsList =/= [] of
							true ->
								common_log:log_goods_list({NewRoleBase,?LOG_GAIN_GOODS_DO_MISSION,LogTime,LogGoodsList,""}),
								common_misc:send_role_goods_change(PId, NewGoodsList, []);
							_ ->
								next
						end
                end,
                %% 铜钱日志
                case AddCoin > 0 of
                    true ->
                        common_log:log_coin({NewRoleBase,?LOG_GAIN_COIN_MISSION,LogTime,AddCoin});
                    _ ->
                        next
                end,
                %% 银币日志
                case AddSilver > 0 of
                    true ->
                        common_log:log_gold({NewRoleBase,?LOG_GAIN_SILVER_MISSION,LogTime,AddSilver});
                    _ ->
                        next
                end,
                %% 通知前端变化
                AttrList = [#p_attr{attr_code = ?ROLE_BASE_SILVER,int_value = NewRoleBase#p_role_base.silver},
                            #p_attr{attr_code = ?ROLE_BASE_COIN,int_value = NewRoleBase#p_role_base.coin}],
                common_misc:send_role_attr_change(PId, RoleId, AttrList),
                %% 需要发送详细的奖励说明信件给玩家
                RoleName = RoleBase#p_role_base.role_name,
                GameName = common_misc:game_name(),
                case IsLetter of
                    true ->
                        ItemLetterTitle = common_lang:get_lang(100601),
                        LetterGoodsMsg = 
                            lists:foldl(
                              fun(LetterGoods,AccLetterGoodsMsg) -> 
                                      lists:concat([AccLetterGoodsMsg,common_goods:get_notify_goods_name(LetterGoods),"\n    "]) 
                              end, "", LogGoodsList),
                        ItemContent = common_letter:create_temp(1900002, [RoleName,DoTimes,LetterGoodsMsg,GameName]),
                        common_letter:sys2p(RoleId,ItemContent,ItemLetterTitle,LogGoodsList,14);
                    _ ->
                        case DoTimes > 1 andalso LogGoodsList =/= [] of
                            true ->
                                ItemLetterTitle = common_lang:get_lang(100601),
                                LetterGoodsMsg = 
                                    lists:foldl(
                                      fun(LetterGoods,AccLetterGoodsMsg) -> 
                                              lists:concat([AccLetterGoodsMsg,common_goods:get_notify_goods_name(LetterGoods),"\n    "]) 
                                      end, "", LogGoodsList),
                                ItemContent = common_letter:create_temp(1900002, [RoleName,DoTimes,LetterGoodsMsg,GameName]),
                                common_letter:sys2p(RoleId,ItemContent,ItemLetterTitle,14);
                            _ ->
                                next
                        end
                end,
                case DoTimes > 1 of
                    true ->
                        LetterBaseMsg = 
                            lists:foldl(
                              fun({Value,Desc},AccLetterBaseMsg) -> 
                                      case Value > 0 of
                                          true ->
                                              lists:concat([AccLetterBaseMsg,Value,Desc,","]);
                                          _ ->
                                              AccLetterBaseMsg
                                      end
                              end, "", [{AddExp,?_LANG_EXP},
                                        {AddCoin,?_LANG_COIN}
                                       ]),
                        BaseLetterTitle = common_lang:get_lang(100600),
                        BaseContent = common_letter:create_temp(1900001, [RoleName,DoTimes,LetterBaseMsg,GameName]),
                        common_letter:sys2p(RoleId,BaseContent,BaseLetterTitle,14);
                    _ ->
                        next
                end
        end,
    mod_mission:add_mission_func(RoleId, Func),
    {ok,NewRoleBase}.

%% 基本属性奖励
%% 返回  #p_mission_reward{}
get_reward_base(MissionColor,NewCommitTimes,RewardInfo,PMissionReward) ->
    #r_mission_reward{rollback_times=RollBackTimes,
                      formula_base=FormulaBase,
                      exp=AddExp,
                      silver=AddSilver,
                      coin=AddCoin
                      } = RewardInfo,
    case NewCommitTimes > RollBackTimes of
        true ->
            MultTimes = 1;
        _ ->
            MultTimes = NewCommitTimes
    end,
    case FormulaBase of
        ?MISSION_REWARD_FORMULA_BASE_NORMAL ->
            TotalExp = AddExp,
            TotalSilver = AddSilver, 
            TotalCoin = AddCoin,
            next;
        ?MISSION_REWARD_FORMULA_BASE_CALC_ALL_TIMES ->
            TotalExp = AddExp * MultTimes,
            TotalSilver = AddSilver * MultTimes, 
            TotalCoin = AddCoin * MultTimes,
            next;
        ?MISSION_REWARD_FORMULA_BASE_CALC_EXP_TIMES ->
            TotalExp = AddExp * MultTimes,
            TotalSilver = AddSilver, 
            TotalCoin = AddCoin,
            next;
        ?MISSION_REWARD_FORMULA_BASE_CALC_PRESTIGE_TIMES ->
            TotalExp = AddExp,
            TotalSilver = AddSilver, 
            TotalCoin = AddCoin,
            next;
        _ ->
            TotalExp = 0,
            TotalSilver = 0, 
            TotalCoin = 0,
            next
    end,
    [MultColor] = common_config_dyn:find(mission_etc, {mission_color,MissionColor}),
    PMissionReward#p_mission_reward{exp=common_tool:ceil(TotalExp * MultColor),
                                    silver=TotalSilver,
                                    coin=TotalCoin,
                                    goods_list=[]}.
%% 道具奖励
%% 返回 [#p_goods{}...] | []
get_reward_item(_DataRecord,_RewardInfo,_RoleCategory,[]) ->
    [];
get_reward_item(DataRecord,RewardInfo,RoleCategory,RewardItemList) ->
    #r_mission_reward{formula_item = FormulaItem,is_category = IsCategory} = RewardInfo,
    Len = erlang:length(RewardItemList),
    case FormulaItem of
        ?MISSION_REWARD_FORMULA_ITEM_CHOOSE_ONE ->
            case IsCategory of
                1 ->
                    case Len >= RoleCategory of
                        true ->
                            ItemList = [lists:nth(RoleCategory, RewardItemList)];
                        _ ->
                            [H|_T] = RewardItemList,
                            ItemList = [H]
                    end;
                _ ->
                    [ChooseId|_] = DataRecord#m_mission_do_tos.prop_choose,
                    case lists:keyfind(ChooseId, #r_mission_reward_item.item_type_id, RewardItemList) of
                        false ->
                            ItemList = [];
                        RewardItem ->
                            ItemList = [RewardItem]
                    end
            end,
            next;
        ?MISSION_REWARD_FORMULA_ITEM_RANDOM_ONE ->
            random:seed(erlang:now()),
            ItemList = [lists:nth(common_tool:random(1, Len), RewardItemList)],
            next;
        ?MISSION_REWARD_FORMULA_ITEM_ALL ->
            ItemList = RewardItemList,
            next;
        _ ->
            ItemList = [],
            next
    end,
    lists:foldl(
      fun(#r_mission_reward_item{item_type_id=ItemTypeId,
                                 item_type=ItemType,
                                 item_num=ItemNum},AccGoodsList) -> 
              CreateInfo = #r_goods_create_info{via = ?GOODS_VIA_MISSION, 
                                                item_type = ItemType, 
                                                type_id = ItemTypeId, 
                                                item_num = ItemNum},
              case common_goods:create_goods(CreateInfo) of
                  {ok,PGoodsList} ->
                      PGoodsList ++ AccGoodsList;
                  _ ->
                      erlang:throw({error,?_RC_MISSION_DO_009,""})
              end
      end, [], ItemList).

%% 计算任务奖励
%% 返回 #p_mission_reward{} | {error,OpCode,OpReason}
reward_calc(RoleLevel,RoleCategory,MissionBaseInfo,MissionColor,CurTimes,DoTimes) ->
    case MissionBaseInfo#r_mission_base_info.type of
        ?MISSION_TYPE_LOOP ->
            do_reward_calc_loop(RoleLevel,RoleCategory,MissionBaseInfo,MissionColor,CurTimes,DoTimes);
        _ ->
            do_reward_calc_normal(RoleLevel,RoleCategory,MissionBaseInfo,MissionColor,CurTimes,DoTimes)
    end.
do_reward_calc_loop(RoleLevel,RoleCategory,MissionBaseInfo,MissionColor,CurTimes,DoTimes) ->
    #r_mission_base_info{big_group = BigGroup,
                         reward_info = RewardInfo} = MissionBaseInfo,
    case cfg_mission:find_mission_loop_reward({BigGroup,RoleLevel}) of
        [{LoopRewardInfo,LoopRewardItemList}] ->
            next;
        _ ->
            LoopRewardInfo = undefined,LoopRewardItemList = [],
            erlang:throw({error,?_RC_MISSION_DO_010,""})
    end,
    NewRewardInfo = 
        RewardInfo#r_mission_reward{
                                    exp=LoopRewardInfo#r_mission_reward.exp,
                                    silver=LoopRewardInfo#r_mission_reward.silver,
                                    coin=LoopRewardInfo#r_mission_reward.coin
                                   },
    do_reward_calc_loop2(DoTimes,CurTimes,RoleCategory,MissionColor,NewRewardInfo,LoopRewardItemList,#p_mission_reward{}).

do_reward_calc_loop2(0,_CurTimes,_RoleCategory,_MissionColor,_RewardInfo,_LoopRewardItemList,PMissionReward) ->
    PMissionReward;
do_reward_calc_loop2(DoTimes,CurTimes,RoleCategory,MissionColor,RewardInfo,LoopRewardItemList,PMissionReward) ->
    case lists:keyfind(CurTimes, 1, LoopRewardItemList) of
        false ->
            RewardItemList = [];
        {_,RewardItemList} ->
            next
    end,
    %% 基本属性奖励
    PMissionRewardBase = get_reward_base(MissionColor,CurTimes,RewardInfo,PMissionReward),
    %% 任务道具奖励
    GoodsList = get_reward_item(#m_mission_do_tos{},RewardInfo,RoleCategory,RewardItemList),
    NewPMissionReward = PMissionRewardBase#p_mission_reward{goods_list = GoodsList ++ PMissionRewardBase#p_mission_reward.goods_list},
    do_reward_calc_loop2(DoTimes - 1,CurTimes + 1,RoleCategory,MissionColor,RewardInfo,LoopRewardItemList,NewPMissionReward).

do_reward_calc_normal(_RoleLevel,RoleCategory,MissionBaseInfo,MissionColor,CurTimes,DoTimes) ->
    #r_mission_base_info{reward_info = RewardInfo,reward_item_list = RewardItemList} = MissionBaseInfo,
    do_reward_calc_normal2(DoTimes,CurTimes,RoleCategory,MissionColor,RewardInfo,RewardItemList,#p_mission_reward{}).

do_reward_calc_normal2(0,_CurTimes,_RoleCategory,_MissionColor,_RewardInfo,_RewardItemList,PMissionReward) ->
    PMissionReward;
do_reward_calc_normal2(DoTimes,CurTimes,RoleCategory,MissionColor,RewardInfo,RewardItemList,PMissionReward) ->
    %% 基本属性奖励
    PMissionRewardBase = get_reward_base(MissionColor,CurTimes,RewardInfo,PMissionReward),
    %% 任务道具奖励
    GoodsList = get_reward_item(#m_mission_do_tos{},RewardInfo,RoleCategory,RewardItemList),
    NewPMissionReward = PMissionRewardBase#p_mission_reward{goods_list = GoodsList ++ PMissionRewardBase#p_mission_reward.goods_list},
    do_reward_calc_normal2(DoTimes - 1,CurTimes + 1,RoleCategory,MissionColor,RewardInfo,RewardItemList,NewPMissionReward).

