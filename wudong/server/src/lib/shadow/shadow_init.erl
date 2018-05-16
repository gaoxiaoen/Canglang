%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 八月 2016 11:40
%%%-------------------------------------------------------------------
-module(shadow_init).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("equip.hrl").

%% API
-compile(export_all).

load_shadow(IndexDict) ->
    Sql = "select pkey,lv,career,combat_power from player_state",
    Data = db:get_all(Sql),
    F = fun([Pkey, Lv, _Career, Cbp], Dict) ->
%%        if Cbp > 0 andalso Career /= 3 ->
        if Cbp > 0 ->
            Index = cbp_index(Cbp),
            case dict:is_key(Index, Dict) of
                false ->
                    dict:store(Index, [{Pkey, Lv}], Dict);
                true ->
                    List = dict:fetch(Index, Dict),
                    dict:store(Index, [{Pkey, Lv} | List], Dict)
            end;
            true ->
                Dict
        end
    end,
    lists:foldl(F, IndexDict, Data).

%%加载战力
load_cross_shadow(IndexDict) ->
    Sql = "select pkey,lv,cbp from shadow",
    Data = db:get_all(Sql),
    F = fun([Pkey, Lv, Cbp], Dict) ->
        if Cbp > 0 ->
            Index = cbp_index(Cbp),
            case dict:is_key(Index, Dict) of
                false ->
                    dict:store(Index, [{Pkey, Lv}], Dict);
                true ->
                    List = dict:fetch(Index, Dict),
                    dict:store(Index, [{Pkey, Lv} | List], Dict)
            end;
            true ->
                Dict
        end
    end,
    lists:foldl(F, IndexDict, Data).

get_shadow(Pkey, Node) ->
    case cache:get({shadow, Pkey}) of
        [] ->
            case config:is_center_node() of
                false ->
                    Shadow = backup_to_player(Pkey),
                    cache:set({shadow, Pkey}, Shadow, ?FIFTEEN_MIN_SECONDS),
                    Shadow;
                true ->
                    MyNode = node(),
                    if
                        MyNode == Node ->
                            case center:is_center_all() of
                                true ->
                                    Shadow = shadow_backup_to_player(Pkey),
                                    cache:set({shadow, Pkey}, Shadow, ?FIFTEEN_MIN_SECONDS),
                                    Shadow;
                                false ->
                                    #player{key = Pkey}
                            end;
                        true ->
                            case center:apply_call(Node, shadow_proc, get_shadow, [Pkey]) of
                                [] ->
                                    case center:is_center_all() of
                                        true ->
                                            Shadow = shadow_backup_to_player(Pkey),
                                            cache:set({shadow, Pkey}, Shadow, ?FIFTEEN_MIN_SECONDS),
                                            Shadow;
                                        false ->
                                            #player{key = Pkey}
                                    end;
                                Shadow ->
                                    cache:set({shadow, Pkey}, Shadow, ?FIFTEEN_MIN_SECONDS),
                                    Shadow
                            end
                    end
            end;
        Shadow ->
            Shadow
    end.

init_shadow(Player) ->
    #player{
        key = Player#player.key,
        nickname = Player#player.nickname,
        pf = Player#player.pf,
        sn = Player#player.sn,
        realm = Player#player.realm,
        career = Player#player.career,
        sex = Player#player.sex,
        lv = Player#player.lv,
        vip_lv = Player#player.vip_lv,
        cbp = Player#player.cbp,
        highest_cbp = Player#player.highest_cbp,
        skill = filter_skill(Player#player.skill),
        design = Player#player.design,
        guild = Player#player.guild,
        shadow = Player#player.shadow,
        pet = Player#player.pet,
        attribute = Player#player.attribute,
        fashion = Player#player.fashion,
        light_weaponid = Player#player.light_weaponid,
        wing_id = Player#player.wing_id,
        equip_figure = Player#player.equip_figure,
        suit_pet_star = Player#player.suit_pet_star,
        max_stone_lv = Player#player.max_stone_lv,
        max_stren_lv = Player#player.max_stren_lv,
        weared_equip = Player#player.weared_equip,
        mount_id = Player#player.mount_id,
        attr_dan = Player#player.attr_dan,
        avatar = Player#player.avatar,
        passive_skill = Player#player.passive_skill,
        magic_weapon_id = Player#player.magic_weapon_id,
        magic_weapon_skill = Player#player.magic_weapon_skill,
        god_weapon_id = Player#player.god_weapon_id,
        god_weapon_skill = Player#player.god_weapon_skill,
        pet_weaponid = Player#player.pet_weaponid,
        footprint_id = Player#player.footprint_id,
        pk = Player#player.pk,
        charm = Player#player.charm,
        achieve_view = Player#player.achieve_view,
        exp = Player#player.exp,
        last_login_time = Player#player.last_login_time,
        cat_id = Player#player.cat_id,
        golden_body_id = Player#player.golden_body_id,
        god_treasure_id = Player#player.god_treasure_id,
        jade_id = Player#player.jade_id,
        marry_ring_lv = Player#player.marry_ring_lv,
        marry_ring_type = Player#player.marry_ring_type,
        marry = Player#player.marry,
        baby = Player#player.baby,
        xian_stage = Player#player.xian_stage,
        war_team = Player#player.war_team,
        cross_scuffle_elite = Player#player.cross_scuffle_elite,
        baby_equip = Player#player.baby_equip
    }.

%%技能过滤
filter_skill(SkillList) ->
    F = fun(SkillData) ->
        case SkillData of
            {Sid, Lv, State} ->
                case data_skill:get(Sid) of
                    [] -> [];
                    Skill ->
                        if State == 0 orelse Skill#skill.type == 2 -> [{Sid, Lv}];
                            true -> []
                        end
                end;
            {Sid, Lv} -> [{Sid, Lv}];
            _ -> []
        end
    end,
    lists:flatmap(F, SkillList).


%%备份数据
player_to_backup(Player) ->
    FieldList = record_info(fields, attribute),
    ValueList = lists:nthtail(1, tuple_to_list(Player#player.attribute)),
    AttributeList = lists:zipwith(fun(Key, Val) -> {Key, Val} end, FieldList, ValueList),
    [
        {pf, Player#player.pf},
        {sn, Player#player.sn},
        {vip_lv, Player#player.vip_lv},
        {skill, Player#player.skill},
        {design, Player#player.design},
        {guild_key, Player#player.guild#st_guild.guild_key},
        {guild_name, Player#player.guild#st_guild.guild_name},
        {pet_id, Player#player.pet#fpet.type_id},
        {pet_name, Player#player.pet#fpet.name},
        {pet_skill, Player#player.pet#fpet.skill},
        {pet_figure, Player#player.pet#fpet.figure},
        {pet_att, Player#player.pet#fpet.att_param},
        {fashion, Player#player.fashion},
        {light_weaponid, Player#player.light_weaponid},
        {wind_id, Player#player.wing_id},
        {equip_figure, Player#player.equip_figure},
        {suit_pet_star, Player#player.suit_pet_star},
        {max_stone_lv, Player#player.max_stone_lv},
        {max_stren_lv, Player#player.max_stren_lv},
        {weared_equip, Player#player.weared_equip},
        {attribute, AttributeList},
        {mount_id, Player#player.mount_id},
        {attr_dan, Player#player.attr_dan},
        {avatar, Player#player.avatar},
        {passive_skill, Player#player.passive_skill},
        {sex, Player#player.sex},
        {magic_weapon_id, Player#player.magic_weapon_id},
        {magic_weapon_skill, Player#player.magic_weapon_skill},
        {god_weapon_id, Player#player.god_weapon_id},
        {god_weapon_skill, Player#player.god_weapon_skill},
        {pet_weapon_id, Player#player.pet_weaponid},
        {footprint_id, Player#player.footprint_id},
        {achieve, Player#player.achieve_view},
        {charm, Player#player.charm},
        {evil, Player#player.pk#pk.value},
        {exp, Player#player.exp},
        {cat_id, Player#player.cat_id},
        {golden_body_id, Player#player.golden_body_id},
        {god_treasure_id, Player#player.god_treasure_id},
        {jade_id, Player#player.jade_id},
        {marry_ring_lv, Player#player.marry_ring_lv},
        {marry_ring_type, Player#player.marry_ring_type},
        {couple_name, Player#player.marry#marry.couple_name},
        {couple_sex, Player#player.marry#marry.couple_sex},
        {couple_key, Player#player.marry#marry.couple_key},
        {baby_type, Player#player.baby#fbaby.type_id},
        {baby_figure, Player#player.baby#fbaby.figure},
        {baby_name, Player#player.baby#fbaby.name},
        {baby_skill, Player#player.baby#fbaby.skill},
        {xian_stage, Player#player.xian_stage}
    ].


backup_to_player(Pkey) ->
    Sql = io_lib:format(<<"select nickname,realm,career,sex,lv,combat_power, highest_combat_power,attrs from player_state where pkey = ~p ">>, [Pkey]),
    case db:get_row(Sql) of
        [] ->
            #player{
                key = Pkey,
                nickname = ?T("shadow")
            };
        [Nickname, Realm, Career, Sex, Lv, Cbp, Hcbp, Attrs] ->
            to_player(Pkey, Nickname, Realm, Career, Sex, Lv, Cbp, Hcbp, Attrs)
    end.

shadow_backup_to_player(Pkey) ->
    Sql = io_lib:format(<<"select nickname,career,sex,lv,cbp,attrs from shadow where pkey = ~p ">>, [Pkey]),
    case db:get_row(Sql) of
        [] ->
            #player{
                key = Pkey,
                nickname = ?T("shadow")
            };
        [Nickname, Career, Sex, Lv, Cbp, Attrs] ->
            to_player(Pkey, Nickname, 0, Career, Sex, Lv, Cbp, Cbp, Attrs)
    end.

player_to_shadow_backup(Player) ->
    Attrs = shadow_init:player_to_backup(Player),
    Sql = io_lib:format(<<"replace into shadow set pkey=~p, nickname = '~s',career = ~p,sex=~p,lv=~p,cbp=~p,attrs = '~s'">>,
        [
            Player#player.key, Player#player.nickname, Player#player.career, Player#player.sex, Player#player.lv, Player#player.cbp, util:term_to_bitstring(Attrs)
        ]),
    db:execute(Sql).

to_player(Pkey, Nickname, Realm, Career, Sex, Lv, Cbp, Hcbp, Attrs) ->
    F = fun({Key, Val}, P) ->
        case Key of
            pf -> P#player{pf = Val};
            sn -> P#player{sn = Val};
            vip_lv -> P#player{vip_lv = Val};
            skill -> P#player{skill = Val};
            passive_skill -> P#player{passive_skill = Val};
            design -> P#player{design = Val};
            sex -> P#player{sex = Val};
            guild_key -> P#player{guild = P#player.guild#st_guild{guild_key = Val}};
            guild_name -> P#player{guild = P#player.guild#st_guild{guild_name = Val}};
            pet_id -> P#player{pet = P#player.pet#fpet{type_id = Val}};
            pet_name -> P#player{pet = P#player.pet#fpet{name = Val}};
            pet_figure -> P#player{pet = P#player.pet#fpet{figure = Val}};
            pet_skill -> P#player{pet = P#player.pet#fpet{skill = Val}};
            pet_att -> P#player{pet = P#player.pet#fpet{att_param = Val}};
            fashion -> P#player{fashion = init_fashion(Val)};
            light_weaponid -> P#player{light_weaponid = Val};
            magic_weapon_id -> P#player{magic_weapon_id = Val};
            magic_weapon_skill -> P#player{magic_weapon_skill = Val};
            god_weapon_id -> P#player{god_weapon_id = Val};
            god_weapon_skill -> P#player{god_weapon_skill = Val};
            wind_id -> P#player{wing_id = Val};
            equip_figure -> P#player{equip_figure = Val};
            suit_pet_star -> P#player{suit_pet_star = Val};
            max_stone_lv -> P#player{max_stone_lv = Val};
            max_stren_lv -> P#player{max_stren_lv = Val};
            weared_equip -> P#player{weared_equip = init_weared_equip(Val)};
            attribute ->
                Attribute = init_attribute(Val),
                P#player{attribute = Attribute};
            mount_id -> P#player{mount_id = Val};
            attr_dan -> P#player{attr_dan = Val};
            avatar -> P#player{avatar = Val};
            pet_weapon_id -> P#player{pet_weaponid = Val};
            footprint_id -> P#player{footprint_id = Val};
            achieve -> P#player{achieve_view = Val};
            charm -> P#player{charm = Val};
            evil ->
                Pk = #pk{value = Val},
                P#player{pk = Pk};
            exp -> P#player{exp = Val};
            cat_id -> P#player{cat_id = Val};
            golden_body_id -> P#player{god_weapon_id = Val};
            god_treasure_id -> P#player{god_treasure_id = Val};
            jade_id -> P#player{jade_id = Val};
            marry_ring_lv -> P#player{marry_ring_lv = Val};
            marry_ring_type -> P#player{marry_ring_type = Val};
            couple_name ->
                Marry = P#player.marry,
                P#player{marry = Marry#marry{couple_name = Val}};
            couple_sex ->
                Marry = P#player.marry,
                P#player{marry = Marry#marry{couple_sex = Val}};
            couple_key ->
                Marry = P#player.marry,
                P#player{marry = Marry#marry{couple_key = Val}};
            baby_type ->
                Baby = P#player.baby,
                P#player{baby = Baby#fbaby{type_id = Val}};
            baby_figure ->
                Baby = P#player.baby,
                P#player{baby = Baby#fbaby{figure = Val}};
            baby_name ->
                Baby = P#player.baby,
                P#player{baby = Baby#fbaby{name = Val}};
            baby_skill ->
                Baby = P#player.baby,
                P#player{baby = Baby#fbaby{skill = Val}};
            xian_stage ->
                P#player{xian_stage = Val};
            _ -> P
        end
    end,
    Player = lists:foldl(F, #player{}, util:bitstring_to_term(Attrs)),
    NewSex = ?IF_ELSE(Player#player.sex > 0, Player#player.sex, Sex),
    Player#player{key = Pkey, nickname = Nickname, realm = Realm, career = Career, sex = NewSex, lv = Lv, cbp = Cbp, highest_cbp = Hcbp}.

%%属性转换
init_attribute(AttributeList) ->
    FieldList = record_info(fields, attribute),
    ValueList = lists:nthtail(1, tuple_to_list(#attribute{})),
    KVList = lists:zipwith(fun(Key, Val) -> {Key, Val} end, FieldList, ValueList),

    F = fun({Key, Val}, List) ->
        case lists:keyfind(Key, 1, AttributeList) of
            false ->
                [Val | List];
            {_, NewVal} ->
                [NewVal | List]
        end
    end,
    NewValueList = lists:reverse(lists:foldl(F, [], KVList)),
    list_to_tuple([attribute | NewValueList]).

%做一下老数据兼容
init_fashion(Fashion) ->
    case Fashion of
        {fashion_figure, ClothId, HeadId} ->
            #fashion_figure{fashion_cloth_id = ClothId, fashion_head_id = HeadId};
        {fashion_figure, ClothId, BubbleId, HeadId} ->
            #fashion_figure{fashion_cloth_id = ClothId, fashion_bubble_id = BubbleId, fashion_head_id = HeadId};
        Fashion when is_record(Fashion, fashion_figure) ->
            Fashion;
        _ ->
            #fashion_figure{}
    end.

%又做一下老数据兼容
init_weared_equip(WearedEquipList) ->
    F = fun(WearedEquip) ->
        case WearedEquip of
            {equip_attr_view, GoodsId, Stren, Star, Gem, Wash, RefineAttr} -> %% 兼容 1
                #equip_attr_view{goods_id = GoodsId, stren = Stren, star = Star, gem = Gem, wash = Wash, refine_attr = RefineAttr};
            {equip_attr_view, GoodsId, Stren, Star, Gem, Wash, RefineAttr,MagicInfo, GodForging} -> %% 兼容 2
                #equip_attr_view{goods_id = GoodsId, stren = Stren, star = Star, gem = Gem, wash = Wash, refine_attr = RefineAttr,magic_info = MagicInfo, god_forging = GodForging};
            WearedEquip when is_record(WearedEquip, equip_attr_view) ->
                WearedEquip;
            Other ->

                    ?ERR("init_weared_equip err :  ~p~n", [Other]),
                #equip_attr_view{}
        end
    end,
    lists:map(F, WearedEquipList).

cbp_index(Power) -> round(Power) div 20000.

update_cbp_index(IndexDict, Pkey, Power, Lv) when Power > 0 ->
    PowerIndex = cbp_index(Power),
    F = fun({Index, List}, {Dict, Up}) ->
        if PowerIndex == Index ->
            {dict:store(Index, [{Pkey, Lv} | lists:keydelete(Pkey, 1, List)], Dict), true};
            true ->
                {dict:store(Index, lists:keydelete(Pkey, 1, List), Dict), Up}
        end
    end,
    {IndexDict1, IsUp} = lists:foldl(F, {dict:new(), false}, dict:to_list(IndexDict)),
    if IsUp ->
        IndexDict1;
        true ->
            dict:store(PowerIndex, [{Pkey, Lv}], IndexDict1)
    end;
update_cbp_index(IndexDict, _, _, _) -> IndexDict.


%%根据战力匹配玩家
%%规则
priv_match_shadow_by_cbp(Dict, Power, Amount, FilterList, Lv) ->
    Index = cbp_index(Power),
    priv_match_loop(Amount, Dict, Index, 0, FilterList, [], Lv).

priv_match_loop(Amount, Dict, Index, Loop, KeyList, MatchList, Lv) ->
    if
        Amount =< 0 orelse Index - Loop < 0 -> MatchList;
        true ->
            IndexList = if Loop == 0 -> [Index]; true -> [Index + Loop, Index - Loop] end,
            F = fun(NewIndex) ->
                case dict:is_key(NewIndex, Dict) of
                    false -> [];
                    true ->
                        dict:fetch(NewIndex, Dict)
                end
            end,
            List = lists:flatmap(F, IndexList),
            %%过滤目标
            FilterList = lists:filter(fun({TarKey, TarLv}) ->
                lists:member(TarKey, KeyList) == false andalso TarLv >= Lv end, List),
            Len = length(FilterList),
            Node = node(),
            if Len >= Amount ->
                [get_shadow(Pkey, Node) || {Pkey, _} <- util:get_random_list(FilterList, Amount)] ++ MatchList;
                true ->
                    NewMatchList = [get_shadow(Pkey, Node) || {Pkey, _} <- FilterList] ++ MatchList,
                    priv_match_loop(Amount - Len, Dict, Index, Loop + 1, KeyList, NewMatchList, Lv)
            end
    end.