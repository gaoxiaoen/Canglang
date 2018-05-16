%%%-------------------------------------------------------------------
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(fashion_suit_init).
-author("lzx").
-include("common.hrl").
-include("fashion_suit.hrl").
-include("server.hrl").
-include("skill.hrl").
-export([
    init/1,
    get_attribute/0,
    cal_fashion_suit_attrbute/1,
    timer_update/0,
    logout/0
]).


init(Player) ->
    StFashionSuit =
        case player_util:is_new_role(Player) of
            true ->
                #st_fashion_suit{pkey = Player#player.key};
            false ->
                init_fashion_suit(Player#player.key)
        end,
    cal_fashion_suit_attrbute(StFashionSuit),
    St1 = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    ActSuitIds = St1#st_fashion_suit.fashion_act_suit_ids,
    F0 = fun({SuitId, Lv}) ->
        case data_fashion_suit_star:get(SuitId, Lv) of
            [] -> [];
            #base_fashion_suit_star{skill = Skill} ->
                [{SuitId, Skill}]
        end
    end,
    SkillList0 = lists:flatmap(F0, ActSuitIds),
    lib_dict:put(?PROC_STATUS_PLAYER_FASHION_SUIT, St1#st_fashion_suit{skill_list = SkillList0}),
    SkillList = [Skill0 || {_, Skill0} <- SkillList0],
    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- Player#player.passive_skill, Type /= ?PASSIVE_SKILL_TYPE_FASHION_SUIT] ++ fashion_suit:filter_skill_for_battle(SkillList),
    Player#player{passive_skill = PassiveSkillList}.


%% 计算套装属性
cal_fashion_suit_attrbute(_StFashionSuit) ->
    ActIds = _StFashionSuit#st_fashion_suit.fashion_suit_ids,
    F = fun(SuitId) ->
        #base_fashion_suit{attrs = AttrS} = data_fashion_suit:get(SuitId),
        [attribute_util:make_attribute_by_key_val_list(AttrS)]
    end,
    AttrList = lists:flatmap(F, ActIds),

    ActSuitIds = _StFashionSuit#st_fashion_suit.fashion_act_suit_ids,
    F0 = fun({SuitId, Lv}) ->
        case data_fashion_suit_star:get(SuitId, Lv) of
            [] -> [];
            Base ->
                [attribute_util:make_attribute_by_key_val_list(Base#base_fashion_suit_star.attrs)]
        end
    end,
    AttrList2 = lists:flatmap(F0, ActSuitIds),

    Attribute = attribute_util:sum_attribute(AttrList ++ AttrList2),
    Cbp = attribute_util:calc_combat_power(Attribute),
    StFashionSuit1 = _StFashionSuit#st_fashion_suit{
        attribute = Attribute,
        cbp = Cbp
    },
    lib_dict:put(?PROC_STATUS_PLAYER_FASHION_SUIT, StFashionSuit1).




init_fashion_suit(PKey) ->
    case fashion_suit_load:load_fashion_suit(PKey) of
        [ActSuitIds, FashionActSuitIds] ->
            NewFashionActSuitIds = if
                                       FashionActSuitIds == null -> [];
                                       true -> util:bitstring_to_term(FashionActSuitIds)
                                   end,

            #st_fashion_suit{
                pkey = PKey,
                fashion_act_suit_ids = NewFashionActSuitIds,
                fashion_suit_ids = util:bitstring_to_term(ActSuitIds)
            };
        _R ->
            #st_fashion_suit{pkey = PKey}
    end.


%%
get_attribute() ->
    #st_fashion_suit{
        attribute = AttriBute
    } = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    AttriBute.



timer_update() ->
    FsSt = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    if FsSt#st_fashion_suit.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_PLAYER_FASHION_SUIT, FsSt#st_fashion_suit{is_change = 0}),
        fashion_suit_load:replace_fashion_suit(FsSt);
        true -> ok
    end.


logout() ->
    FsSt = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    if FsSt#st_fashion_suit.is_change == 1 ->
        fashion_suit_load:replace_fashion_suit(FsSt);
        true -> ok
    end.

















