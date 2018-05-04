%%%-------------------------------------------------------------------
%%% @author  <caochuncheng2002@gmail.com>
%%% @copyright (C) 2010, 
%%% @doc
%%% 物品公共模块API
%%% @end
%%%-------------------------------------------------------------------
-module(common_goods).

-export([
         create_goods/1,
         
         create_item/1,
         
         create_stone/1,
         
         create_equip/1
        ]).
%% API
-export([
         get_notify_goods_name/1,
         get_prop_lang/3
        ]).

-include("common.hrl").
-include("common_server.hrl").


%%%===================================================================
%%% API
%%%===================================================================
get_prop_lang(PropType,PropId,PropNum)->
    case PropType of
        ?TYPE_EQUIP->
            [#r_equip_info{name=Name}] = cfg_equip:find(PropId);
        ?TYPE_STONE->
            [#r_stone_info{name=Name}] = cfg_item:find(PropId);
        _ ->
            [#r_item_info{name=Name}] = cfg_item:find(PropId)
    end,
    if PropNum > 1 ->
           lists:concat(["【",common_tool:to_list(Name),"】×",erlang:integer_to_list(PropNum)]);
       true ->
           lists:concat(["【",common_tool:to_list(Name),"】"])
    end.
get_notify_goods_name(_Goods) ->
    "".


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 创建道具
%% @args [r_goods_create_info]
%% 返回 {ok,GoodsList} or {error,Reason}
create_goods(#r_goods_create_info{item_type=ItemType}=CreateInfo) ->
    case ItemType of
        ?TYPE_ITEM ->
            create_item(CreateInfo);
        ?TYPE_EQUIP ->
            create_equip(CreateInfo);
        ?TYPE_STONE ->
            create_stone(CreateInfo);
        _ ->
            {error, error_type}
    end;
%% @批量创建道具 此处不做合并
%%  {ok,GoodsList} or {error,Reason}
create_goods(CreateInfoList) when is_list(CreateInfoList)->
    create_goods2(CreateInfoList,[]).

create_goods2([CreateInfo|CreateInfoList],GoodsList)->
    case create_goods(CreateInfo) of
        {ok,TmpGoodsList}->
            create_goods2(CreateInfoList,TmpGoodsList ++ GoodsList);
        {error,Reason}->
            {error,Reason}
    end;
create_goods2([],GoodsList)->
    {ok,GoodsList}.

create_item(CreateInfo) when is_record(CreateInfo, r_goods_create_info) ->
    #r_goods_create_info{item_type = ItemType,
                         via = Via,
                         type_id = TypeId,
                         item_num = ItemNum,
                         start_time = PStartTime,
                         end_time = PEndTime,
                         days = PDays
                        } = CreateInfo,
    case cfg_item:find(TypeId) of
        [#r_item_info{
                      use_min_level=ItemLevel,
                      is_overlap=IsOverlap
                     }] ->
            {StartTime, EndTime} =calc_startend_time(PStartTime, PEndTime, PDays),
            NewGoods= #p_goods{type=ItemType, 
                               via = Via,
                               type_id = TypeId,
                               start_time=StartTime,
                               end_time = EndTime,
                               level=ItemLevel
                              },
            %% 是否可叠加
            case IsOverlap =:= ?CAN_OVERLAP of
                true ->
                    case ItemNum div ?MAX_ITEM_NUMBER of
                        0->
                            GoodsList = [NewGoods#p_goods{number=ItemNum}];
                        N->
                            case ItemNum rem ?MAX_ITEM_NUMBER of
                                0 -> 
                                    GoodsList = lists:duplicate(N,NewGoods#p_goods{number=?MAX_ITEM_NUMBER});
                                R -> 
                                    GoodsList = [NewGoods#p_goods{number=R}
                                                |lists:duplicate(N,NewGoods#p_goods{number=?MAX_ITEM_NUMBER})]
                            end
                    end;
                false ->
                    GoodsList = lists:duplicate(ItemNum,NewGoods#p_goods{number=1})
            end,
            {ok, GoodsList};
        _ ->
            {error, error_type_id}
    end;
create_item(_) ->
    {error, error_record}.

%% 创建宝石
%% 返回 {ok,GoodsList} or {error,Reason}
create_stone(CreateInfo) when is_record(CreateInfo, r_goods_create_info) ->
    #r_goods_create_info{item_type = ItemType,
                         via = Via,
                         type_id = TypeId,
                         item_num = ItemNum,
                         start_time = PStartTime,
                         end_time = PEndTime,
                         days = PDays
                        } = CreateInfo,
    
    case cfg_stone:find(TypeId) of
        [#r_stone_info{
                       level=StoneLevel,
                       is_overlap=IsOverlap
                      }] ->

            {StartTime, EndTime} =calc_startend_time(PStartTime, PEndTime, PDays),
            NewGoods= #p_goods{type=ItemType, 
                               via = Via,
                               type_id = TypeId,
                               start_time=StartTime,
                               end_time = EndTime,
                               level=StoneLevel
                              },
            %% 是否可叠加
            case IsOverlap =:= ?CAN_OVERLAP of
                true ->
                    case ItemNum div ?MAX_ITEM_NUMBER of
                        0->
                            GoodsList = [NewGoods#p_goods{number=ItemNum}];
                        N->
                            case ItemNum rem ?MAX_ITEM_NUMBER of
                                0 -> 
                                    GoodsList = lists:duplicate(N,NewGoods#p_goods{number=?MAX_ITEM_NUMBER});
                                M -> 
                                    GoodsList = [NewGoods#p_goods{number=M}
                                                |lists:duplicate(N,NewGoods#p_goods{number=?MAX_ITEM_NUMBER})]
                            end
                    end;
                false ->
                    GoodsList = lists:duplicate(ItemNum,NewGoods#p_goods{number=1})
            end,
            {ok, GoodsList};
        _ ->
            {error, error_type_id}
    end;
create_stone(_) ->
    {error, error_record}.

%% 创建装备
%% 返回 {ok,GoodsList} or {error,Reason}
create_equip(CreateInfo) when is_record(CreateInfo, r_goods_create_info) ->
    #r_goods_create_info{item_type = ItemType,
                         via = Via,
                         type_id = TypeId,
                         item_num = ItemNum,
                         start_time = PStartTime,
                         end_time = PEndTime,
                         days = PDays,
                         stones = StonesList,
                         punch_num=PPunchNum
                        } = CreateInfo,
    
    case cfg_equip:find(TypeId) of
        [#r_equip_info{
                       use_min_level = EquipLevel,
                       endurance = Endurance,       %% 最大耐久度
                       property = Prop
                      }] ->
            {StartTime, EndTime} = calc_startend_time(PStartTime, PEndTime, PDays),
            PunchNum = 
                case erlang:length(StonesList) > PPunchNum of
                    true ->
                        erlang:length(StonesList);
                    false ->
                        PPunchNum
                end,
            
            %%TODO 处理镶嵌石头
            EquipStoneList = [],
            EquipGoods= #p_goods{type=ItemType, 
                                 via = Via,
                                 type_id = TypeId,
                                 start_time=StartTime,
                                 end_time = EndTime,
                                 punch_num = PunchNum,
                                 cur_endurance = Endurance,
                                 sum_endurance = Endurance,
                                 equip_stone = EquipStoneList,
                                 level = EquipLevel,
                                 attributes = gen_equip_attributes(Prop)
                                },
			{ok, lists:duplicate(ItemNum,EquipGoods#p_goods{number=1})};
        _ ->
            {error, error_type_id}
    end;
create_equip(_) ->
    {error, error_record}.

%% 根据装备配置的属性范围生成相应的属性值
gen_equip_attributes(Property) ->
    [_H|Props] = erlang:tuple_to_list(Property),
    gen_equip_attributes2(Props,1,[]).

gen_equip_attributes2([],_Index,Attrs) ->
    Attrs;
gen_equip_attributes2([ [] | Props],Index,Attrs) ->
    gen_equip_attributes2(Props,Index + 1,Attrs);
gen_equip_attributes2([ [Min,Max] | Props],Index,Attrs) ->
    random:seed(erlang:now()),
    Val = common_tool:random(Min, Max),
    gen_equip_attributes2(Props,Index + 1,[#p_attribute{id=Index,val=Val} | Attrs]).

calc_startend_time(StartTime, EndTime, EffectDays) ->
    NowSeconds = common_tool:now(),
    if StartTime =:= 0 andalso EndTime =:= 0 andalso EffectDays =/= 0 ->
           {NowSeconds - 5, NowSeconds + 24*60*60 * EffectDays};
       StartTime =/= 0 andalso EndTime =/= 0 andalso EffectDays =:= 0 ->
           {StartTime,EndTime};
       StartTime =:= 0 andalso EndTime =/= 0 andalso EffectDays =:= 0 ->
           {NowSeconds,NowSeconds + EndTime};
       true ->
           {0,0}
    end.
