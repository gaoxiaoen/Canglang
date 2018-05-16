%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 仙术觉醒
%%% @end
%%% Created : 19. 十月 2017 16:52
%%%-------------------------------------------------------------------
-module(xian_skill).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("xian.hrl").
-include("skill.hrl").

%% API
-export([
    init/1,
    act_skill/2,
    get_cbp/0,
    get_attr/0,
    get_info/1,
    upgrade/2,
    get_skill_list/0
]).

init(#player{key = Pkey} = Player) ->
    StXianSkill =
        case player_util:is_new_role(Player) of
            true -> #st_xian_skill{pkey = Pkey};
            false -> xian_load:dbget_xian_skill(Pkey)
        end,
    NStXianSkill = update_skill_attr_cbp(StXianSkill),
    lib_dict:put(?PROC_STATUS_XIAN_SKILL, NStXianSkill),
    NewStXianSkill = repair(NStXianSkill),
    Player#player{
        xian_skill = NewStXianSkill#st_xian_skill.skill_list,
        passive_skill = NewStXianSkill#st_xian_skill.passive_skill_list ++ Player#player.passive_skill
    }.

repair(StXianSkill) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    WearedXianList = GoodsSt#st_goods.weared_xian,
    if
        length(WearedXianList) == length(StXianSkill#st_xian_skill.skill_lv_list) ->
            StXianSkill;
        true ->
            F = fun(#weared_xian{goods_id = GoodsId}) ->
                act_skill(#player{}, GoodsId)
            end,
            lists:map(F, WearedXianList),
            lib_dict:get(?PROC_STATUS_XIAN_SKILL)
    end.

update_skill_attr_cbp(StXianSkill) ->
    #st_xian_skill{skill_lv_list = SkillLvList} = StXianSkill,
    F = fun({SubType, Lv}) ->
        SkillId = data_feixian_skill:get_skillId_by_subtype_lv(SubType, Lv),
        #skill{type = Type} = data_skill:get(SkillId),
        if
            Type == ?SKILL_TYPE_PASSIVE -> [];
            true -> [SkillId]
        end
    end,
    SkillIdList = lists:flatmap(F, SkillLvList),
    F1 = fun({SubType, Lv}) ->
        SkillId = data_feixian_skill:get_skillId_by_subtype_lv(SubType, Lv),
        #skill{type = Type} = data_skill:get(SkillId),
        if
            Type == ?SKILL_TYPE_PASSIVE -> [{SkillId, ?PASSIVE_SKILL_TYPE_FEIXIAN}];
            true -> []
        end
    end,
    PassiveSkillInfoList = lists:flatmap(F1, SkillLvList),
    F2 = fun({SubType, Lv}) ->
        Attr = data_feixian_skill:get_attr_by_subtype_lv(SubType, Lv),
        attribute_util:make_attribute_by_key_val_list(Attr)
    end,
    AttrList = lists:map(F2, SkillLvList),

    F3 = fun({SubType, Lv}) ->
        SkillId = data_feixian_skill:get_skillId_by_subtype_lv(SubType, Lv),
        case data_skill:get(SkillId) of
            #skill{skill_cbp = Cbp} -> Cbp;
            _ -> 0
        end
    end,
    CbpList = lists:map(F3, SkillLvList),
    StXianSkill#st_xian_skill{
        skill_list = SkillIdList,
        passive_skill_list = PassiveSkillInfoList,
        attr = attribute_util:sum_attribute(AttrList),
        cbp = ?IF_ELSE(CbpList == [], 0, lists:sum(CbpList))
    }.

act_skill(_Player, GoodsId) ->
    case data_goods:get(GoodsId) of
        #goods_type{color = Color, subtype = SubType} when Color >= 4 ->
            St = lib_dict:get(?PROC_STATUS_XIAN_SKILL),
            #st_xian_skill{skill_lv_list = SkillLvList} = St,
            NewSkillLvList =
                case lists:keyfind(SubType, 1, SkillLvList) of
                    false ->
                        [{SubType, 1} | SkillLvList];
                    _ ->
                        SkillLvList
                end,
            NewStXianSkill = update_skill_attr_cbp(St#st_xian_skill{skill_lv_list = NewSkillLvList}),
            lib_dict:put(?PROC_STATUS_XIAN_SKILL, NewStXianSkill),
            if
                NewStXianSkill /= St ->
                    xian_load:dbup_xian_skill(NewStXianSkill);
                true -> ok
            end;
        _Other ->
            ok
    end.

get_cbp() ->
    St = lib_dict:get(?PROC_STATUS_XIAN_SKILL),
    Cbp = St#st_xian_skill.cbp,
    Cbp.

get_attr() ->
    St = lib_dict:get(?PROC_STATUS_XIAN_SKILL),
    St#st_xian_skill.attr.

get_info(_Player) ->
    St = lib_dict:get(?PROC_STATUS_XIAN_SKILL),
    #st_xian_skill{skill_lv_list = SkillLvList} = St,
    util:list_tuple_to_list(SkillLvList).

upgrade(SubType, Player) ->
    St = lib_dict:get(?PROC_STATUS_XIAN_SKILL),
    #st_xian_skill{skill_lv_list = SkillLvList} = St,
    case lists:keytake(SubType, 1, SkillLvList) of
        false -> {11, Player}; %% 未激活
        {value, {SubType, Lv}, Rest} ->
            case data_feixian_skill:get_cost_by_subtype_lv(SubType, Lv) of
                [] ->
                    {12, Player}; %% 已经最高阶级
                Consume ->
                    F = fun({GoodsId, GoodsNum}) ->
                        case GoodsId of
                            10101 ->
                                Player#player.coin < GoodsNum;
                            10106 ->
                                money:is_enough(Player, GoodsNum, bgold) == false;
                            10199 ->
                                money:is_enough(Player, GoodsNum, gold) == false;
                            _ ->
                                goods_util:get_goods_count(GoodsId) < GoodsNum
                        end
                    end,
                    case lists:any(F, Consume) of
                        true -> {5, Player}; %% 材料不足
                        false ->
                            {NewPlayer, NewConsume} = consume(Player, Consume),
                            goods:subtract_good(NewPlayer, NewConsume, 724),
                            NewSkillLvList = [{SubType, Lv+1} | Rest],
                            Sql = io_lib:format("insert into log_xian_skill_upgrade set pkey=~p, subtype=~p, befor_lv=~p, after_lv=~p, consume='~s',time=~p",
                                [Player#player.key, SubType, Lv, Lv+1, util:term_to_bitstring(Consume), util:unixtime()]),
                            log_proc:log(Sql),
                            NSt = St#st_xian_skill{skill_lv_list = NewSkillLvList},
                            NewSt = update_skill_attr_cbp(NSt),
                            lib_dict:put(?PROC_STATUS_XIAN_SKILL, NewSt),
                            NewPlayer00 = player_util:count_player_attribute(NewPlayer, true),
                            NewPlayer99 = NewPlayer00#player{xian_skill = NewSt#st_xian_skill.skill_list},
                            player_handle:sync_data(xian_skill, NewPlayer99),
                            xian_load:dbup_xian_skill(NewSt),
                            {1, NewPlayer99}
                    end
            end
    end.

consume(Player, ExchangeCostList) ->
    consume(Player, ExchangeCostList, []).

consume(Player, [], AccList) ->
    {Player, AccList};

consume(Player, [H|T], AccList) ->
    case H of
        {10101, Num} ->
            NewPlayer = money:add_coin(Player, -Num, 726, 0, 0),
            consume(NewPlayer, T, AccList);
        {10106, Num} ->
            NewPlayer = money:add_gold(Player, -Num, 727, 0, 0),
            consume(NewPlayer, T, AccList);
        {10199, Num} ->
            NewPlayer = money:add_no_bind_gold(Player, -Num, 725, 0, 0),
            consume(NewPlayer, T, AccList);
        _ ->
            consume(Player, T, [H | AccList])
    end.

get_skill_list() ->
    St = lib_dict:get(?PROC_STATUS_XIAN_SKILL),
    #st_xian_skill{
        skill_list = SkillList
    } = St,
    SkillList.