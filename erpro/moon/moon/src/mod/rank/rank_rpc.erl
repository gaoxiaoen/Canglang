%%----------------------------------------------------
%% 排行榜相关远程调用
%% @author liuweihua(yjbgwxf@gmail.com)
%%
%%----------------------------------------------------
-module(rank_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("rank.hrl").
-include("pet.hrl").
-include("item.hrl").
-include("link.hrl").
-include("assets.hrl").

-define(rank_celebrity_row_count, 4).

%% 获取等级排行榜
handle(11000, {PageIndex}, _Role) ->
    Data = rank:list(?rank_role_lev),
    ?DEBUG("----获取等级排行榜---"),
    % ?DEBUG("----获取等级排行榜---:~w~n",[Data]),
    % ?DEBUG("----获取等级排行榜 PageIndex---:~w~n",[get_certain_page_data(PageIndex,Data)]),
    {reply, get_certain_page_data(PageIndex, Data)};

%% 获取财富排行榜
handle(11001, {}, _Role) ->
    {reply, {rank:list(?rank_role_coin)}};

%% 获取仙宠排行榜
handle(11004, {}, _Role) ->
    {reply, {rank:list(?rank_role_pet)}};
 
%% 获取成就排行榜
handle(11005, {}, _Role) ->
    {reply, {rank:list(?rank_role_achieve)}};

%% 获取战斗力排行榜
handle(11006, {PageIndex}, _Role) ->
    Data = rank:list(?rank_role_power),
    ?DEBUG("--获取战斗力排行榜---"),
    % ?DEBUG("--获取战斗力排行榜---:~w~n",[Data]),
    {reply, get_certain_page_data(PageIndex, Data)};

%% 获取元神排行榜
handle(11007, {}, _Role) ->
    {reply, {rank:list(?rank_role_soul)}};
 
%% 获取技能排行榜
handle(11008, {}, _Role) ->
    {reply, {rank:list(?rank_role_skill)}};

%% 获取宠物战斗力排行榜
handle(11009, {PageIndex}, _Role) ->
    Data = rank:list(?rank_role_pet_power),
    ?DEBUG("--获取宠物战斗力排行榜--"),
    % ?DEBUG("--获取宠物战斗力排行榜--:~w~n",[Data]),
    {reply, get_certain_page_data(PageIndex, Data)};

% %% 获取装备总评分排行榜
% handle(11010, {}, _Role) ->
%     {reply, {rank:e_all_list()}};

%% 获取武器排行榜
handle(11011, {PageIndex}, _Role) ->
    Data = rank:list(?rank_arms),
    ?DEBUG("--获取武器排行榜---:~w~n", [Data]),
    {reply, get_certain_page_data(PageIndex, Data)};

%% 获取防具排行榜
% @Type 类型即位置(1:装备 2:法袍 3:腰带 4:法腕 5:护手 6:法裤 7:法靴)
% handle(11012, {PageIndex,Type}, _Role) ->
%     ?DEBUG("---获取防具排行榜-类型--:~w~n",[Type]),
%     Data = filter_by_type(Type,rank:list(?rank_armor)),
%     ?DEBUG("---获取防具排行榜--:~w~n",[Data]),
%     {reply, get_certain_page_data(PageIndex,Data)};
%% 获取装备排行榜
handle(11012, {PageIndex}, _Role) -> 
    ?DEBUG("---获取装备排行榜-类型 PageIndex--~p~n~n~n", [PageIndex]),
    R1 = rank:list(?rank_armor),
    R2 = rank:list(?rank_arms),
    Data = lists:keysort(11, R2 ++ R1), %%目测防具数据较多
    {Total, ND} = get_certain_page_data(PageIndex, lists:reverse(Data)),
    NData = format_data(ND),
    {reply, {Total, lists:reverse(NData)}};


%% 获取坐骑战斗力排行榜
handle(11013, {}, _Role) ->
    {reply, {rank:list(?rank_mount_power)}};

%% 获取跨服坐骑战斗力排行榜
handle(11014, {}, _Role) ->
    {reply, {rank:list(?rank_cross_mount_power)}};

%% 获取试练积分排行榜
handle(11015, {}, _Role = #role{assets = #assets{practice_acc = AccScore}}) ->
    {reply, {AccScore, rank:list(?rank_practice)}};

%% 获取我的排行
handle(11018, {Type}, Role = #role{id= _Id}) ->
    ?DEBUG("---获取我的排行--：~w~n",[_Id]),
    ?DEBUG("---获取我的排行 Leixing--：~w~n",[Type]),
    case rank:sort_num(Type, Role)of 
        0 -> 
            {reply, {Type, 0}};
        N -> 
            ?DEBUG("---获取我的排行--：~w~n",[N]),
            PageIndex = util:ceil(N / ?rank_row_count),
            ?DEBUG("---获取我的排行 页数--：~w~n",[PageIndex]),
            {reply, {Type, PageIndex}}
    end;

%% 获取我的排行(防具类)
% handle(11019, {Type}, Role) ->
%     case rank:armor_rank_by_type(Type,Role) of 
%         0 -> 
%             {reply,{Type, 0}};
%         N -> 
%             PageIndex = erlang:round(N / ?rank_row_count),
%             ?DEBUG("---获取我的排行 页数--：~w~n",[PageIndex]),
%             {reply, {Type, PageIndex}}
%     end;
handle(11019, {}, Role) ->
    case rank:eqm_rank2(Role) of 
        0 -> 
            {reply,{0}};
        N -> 
            PageIndex = util:ceil(N / ?rank_row_count),
            ?DEBUG("---获取我的排行 页数--：~w~n",[PageIndex]),
            {reply, {PageIndex}}
    end;

%% 获取帮会等级排行榜
handle(11020, {PageIndex}, _Role) ->
    {reply, get_certain_page_data(PageIndex, rank:list(?rank_guild_lev))};

%% 获取仙岛斗法排行榜
handle(11021, {}, _Role) ->
    {reply, {rank:list(?rank_guild_combat)}};

%% 获取上场仙岛排行榜
handle(11022, {}, _Role) ->
    {reply, {rank:list(?rank_guild_last)}};

%% 获取个人战功排行榜
handle(11023, {}, _Role) ->
    {reply, {rank:list(?rank_guild_exploits)}};

%% 获取灵戒战力排行榜
handle(11024,  {}, _Role) ->
    {reply, {rank:list(?rank_soul_world)}};

%% 获取魔阵等级排行榜
handle(11025,  {}, _Role) ->
    {reply, {rank:list(?rank_soul_world_array)}};

%% 获取妖灵战力排行榜
handle(11026,  {}, _Role) ->
    {reply, {rank:list(?rank_soul_world_spirit)}};

%% 获取帮会战斗力排行榜
handle(11027, {PageIndex}, _Role) ->

    {reply, get_certain_page_data(PageIndex, rank:list(?rank_guild_power))};

%% 获取竞技累积排行榜
handle(11030, {}, _Role) ->
    {reply, {rank:list(?rank_vie_acc)}};

%% 获取上周竞技排行榜
handle(11031, {}, _Role) ->
    {reply, {rank:list(?rank_vie_last)}};

%% 获取跨服竞技排行榜
handle(11032, {}, _Role) ->
    {reply, {rank:list(?rank_vie_cross)}};

%% 获取竞技总斩杀排行榜
handle(11033, {}, _Role) ->
    {reply, {rank:list(?rank_vie_kill)}};

%% 获取竞技上场斩杀排行榜
handle(11034, {}, _Role) ->
    {reply, {rank:list(?rank_vie_last_kill)}};

%% 获取答题总积分排行榜
handle(11040, {}, _Role) ->
    {reply, {rank:list(?rank_wit_acc)}};

%% 获取上场答题积分排行榜
handle(11041, {}, _Role) ->
    {reply, {rank:list(?rank_wit_last)}};

%% 获取累积鲜花排行榜
handle(11050, {}, _Role) ->
    {reply, {rank:list(?rank_flower_acc)}};

%% 获取今日鲜花排行榜
handle(11051, {}, _Role) ->
    {reply, {rank:list(?rank_flower_day)}};

%% 获取跨服鲜花排行榜
handle(11052, {}, _Role) ->
    {reply, {rank:list(?rank_cross_flower)}};

%% 获取累积魅力排行榜
handle(11060, {}, _Role) ->
    {reply, {rank:list(?rank_glamor_acc)}};

%% 获取今日魅力排行榜
handle(11061, {}, _Role) ->
    {reply, {rank:list(?rank_glamor_day)}};

%% 获取跨服魅力排行榜
handle(11062, {}, _Role) ->
    {reply, {rank:list(?rank_cross_glamor)}};

%% 获取累积人气排行榜
handle(11070, {}, _Role) ->
    {reply, {rank:list(?rank_popu_acc)}};

%% 获取金币达人排行榜
handle(11072, {}, _Role) ->
    {reply, {rank:list(?rank_darren_coin)}};

%% 获取寻宝达人排行榜
handle(11073, {}, _Role) ->
    {reply, {rank:list(?rank_darren_casino)}};

%% 获取升级达人排行榜
handle(11074, {}, _Role) ->
    {reply, {rank:list(?rank_darren_exp)}};

%% 获取阅历达人排行榜
handle(11075, {}, _Role) ->
    {reply, {rank:list(?rank_darren_attainment)}};

%% 获取个人所有排行榜
handle(11081, {}, Role) ->
    {reply, {rank:role_ranks(Role)}};

%% 获取综合战力本服排行榜 仙道会使用
handle(11082, {Type = 98}, _Role) ->
    L = rank:list(Type),
    Data = [{Srvid, Rid, Name, Career, Sex, Lev, Guild, RolePower, PetPower, TotalPower, Realm, WcLev, Vip} || #rank_total_power{srv_id = Srvid, rid = Rid, name = Name, career = Career, sex = Sex, lev = Lev, guild = Guild, role_power = RolePower, pet_power = PetPower, total_power = TotalPower, realm = Realm, wc_lev = WcLev, vip = Vip} <- L],
    {reply, {Type, Data}};
%% 获取综合战力跨服排行榜 仙道会使用
handle(11082, {Type = 99}, _Role) ->
    L = rank:list(Type),
    Data = [{Srvid, Rid, Name, Career, Sex, Lev, Guild, RolePower, PetPower, TotalPower, Realm, WcLev, Vip} || #rank_cross_total_power{srv_id = Srvid, rid = Rid, name = Name, career = Career, sex = Sex, lev = Lev, guild = Guild, role_power = RolePower, pet_power = PetPower, total_power = TotalPower, realm = Realm, wc_lev = WcLev, vip = Vip} <- L],
    {reply, {Type, Data}};

%% 获取宠物战力排行榜 仙道会使用
handle(11083, {Type = ?rank_role_pet_power, PageIndex}, _Role) ->
    L = rank:list(Type),
    Data = [{Srvid, Rid, Name, Career, Sex, Color, PetName, PetLev, PetPower, Vip, Realm, PetRb} || #rank_role_pet_power{srv_id = Srvid, rid = Rid, name = Name, career = Career, sex = Sex, color = Color, petname = PetName, petlev = PetLev, power = PetPower, vip = Vip, realm = Realm, petrb = PetRb} <- L],
    {TotalPage,NData} = get_certain_page_data(PageIndex, Data),
    {reply, {Type, TotalPage, NData}};
handle(11083, {Type = 10}, _Role) ->
    L = rank:list(Type),
    Data = [{Srvid, Rid, Name, Career, Sex, Color, PetName, PetLev, PetPower, Vip, Realm, PetRb} || #rank_cross_role_pet_power{srv_id = Srvid, rid = Rid, name = Name, career = Career, sex = Sex, color = Color, petname = PetName, petlev = PetLev, power = PetPower, vip = Vip, realm = Realm, petrb = PetRb} <- L],
    {reply, {Type, Data}};

%% 获取角色属性TIP信息 仙道会使用
handle(11084, {Rid, Srvid, Type}, _Role) ->
    case rank:get_rank_role_attr(Rid, Srvid, Type) of
        {Career, Sex, Lev, Eqm, Looks} -> 
            NewEqm = [Item || Item <- Eqm, is_record(Item, item)],
            {reply, {Type, Career, Sex, Lev, NewEqm, Looks}};
        false -> {ok}
    end;

%% 获取角色宠物属性TIP信息 仙道会使用
handle(11085, {Rid, Srvid}, _Role) ->
    case rank:get_rank_pet(Rid, Srvid, ?rank_role_pet_power) of 
        #pet{name = Name, base_id = BaseId, lev = Lev, exp = Exp, fight_capacity = Power, eqm_num = Eqm_num, eqm = Eqm,
         attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq, xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal, step = Step,
         dmg = Dmg, critrate = Cri, hp_max = HpMax, mp_max = MpMax, defence = Def,tenacity = Ten, hitrate = Hit, evasion = Eva}, 
          attr_sys = #pet_attr_sys{
         xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}, skill = Skill, skill_num = SkillNum} -> 
            PetData = {Name, BaseId, Lev, Exp, pet_data_exp:get(Lev), Step, Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, 
            XlPer, TzPer, JsPer, LqPer, SkillNum, Skill, Dmg, Cri, HpMax, MpMax, Def, Ten, Hit, Eva, Power, Eqm_num, Eqm},
            
            {reply, PetData};
        _ -> 
            {ok}
    end;

%% 获取坐骑战力排行榜 仙道会使用
handle(11086, {Type = 13}, _Role) ->
    L = rank:list(Type),
    Data = [{Srvid, Rid, Name, Career, Sex, Guild, Mount, Step, MountLev, Quality, Power, Vip, Realm} || #rank_mount_power{srv_id = Srvid, rid = Rid, name = Name, career = Career, sex = Sex, power = Power, vip = Vip, realm = Realm, guild = Guild, mount = Mount, step = Step, mount_lev = MountLev, quality = Quality} <- L],
    {reply, {Type, Data}};
handle(11086, {Type = 14}, _Role) ->
    L = rank:list(Type),
    Data = [{Srvid, Rid, Name, Career, Sex, Guild, Mount, Step, MountLev, Quality, Power, Vip, Realm} || #rank_cross_mount_power{srv_id = Srvid, rid = Rid, name = Name, career = Career, sex = Sex, power = Power, vip = Vip, realm = Realm, guild = Guild, mount = Mount, step = Step, mount_lev = MountLev, quality = Quality} <- L],
    {reply, {Type, Data}};

%% 获取仙道会胜率排行榜
handle(11087, {Type = 100}, _Role) ->
    L = rank:list(Type), %% 全平台跨服
    {reply, {Type, L}};
handle(11087, {Type = 101}, _Role) ->
    L = rank:list(Type), %% 本服
    {reply, {Type, L}};
handle(11087, {Type = 104}, _Role) ->
    L = rank:list(Type), %% 同平台
    {reply, {Type, L}};

%% 获取仙道会历练排行榜
handle(11088, {Type = 102}, _Role) ->
    L = rank:list(Type),
    {reply, {Type, L}};
handle(11088, {Type = 103}, _Role) ->
    L = rank:list(Type),
    {reply, {Type, L}};
handle(11088, {Type = 105}, _Role) ->
    L = rank:list(Type),
    {reply, {Type, L}};

%% 获取仙道会段位排行榜
handle(11089, {Type = 109}, _Role) ->
    L = rank:list(Type),
    {reply, {Type, L}};
handle(11089, {Type = 110}, _Role) ->
    L = rank:list(Type),
    {reply, {Type, L}};

%% 获取全服名人排行榜
% Id 表示大类
handle(11090, {Id, PageIndex}, _Role) ->
    ?DEBUG("--Data--Type-~p~n~n~n", [Id]),
    ?DEBUG("--Data--PageIndex-~p~n~n~n", [PageIndex]),
    Data = rank:list(?rank_celebrity),
    ?DEBUG("--Data---~p~n~n~n", [Data]),
    % NData = get_celebrity_by_type(Data, Id),
    NData = get_celebrity_by_type(Data, Id),
    NData1 = lists:keysort(#rank_global_celebrity.date, NData),
    NData2 = lists:reverse(NData1),
    % NData1 = get_index_page_data(NData, PageIndex),
    ?DEBUG("--NData---~p~n~n~n", [NData2]),
    % {reply, {1, NData1}};
    {reply, get_certain_page_data2(PageIndex, NData2)};

%% 获取武器、防具物品数据
handle(11091, {Rid, Srvid, Type}, _Role) ->
    case rank:get_rank_item(Rid, Srvid, Type) of
        Item when is_record(Item, item) -> item:item_to_view(Item);
        _ -> {ok}
    end;

%% 获取角色属性TIP信息
handle(11092, {Rid, Srvid, Type}, _Role) ->
    case rank:get_rank_role_attr(Rid, Srvid, Type) of
        false -> {ok};
        Info -> {reply, Info}
    end;

%% 获取角色宠物属性TIP信息
handle(11093, {Rid, Srvid, Type}, _Role) ->
    case rank:get_rank_pet(Rid, Srvid, Type) of 
        #pet{id = Id, name = Name, type = PetType, base_id = BaseId, lev = Lev, mod = Mod, grow_val = GrowVal, happy_val = HappyVal, exp = Exp, attr = #pet_attr{xl = Xl, tz = Tz, js = Js, lq = Lq, xl_val = XlVal, tz_val = TzVal, js_val = JsVal, lq_val = LqVal}, attr_sys = #pet_attr_sys{xl_per = XlPer, tz_per = TzPer, js_per = JsPer, lq_per = LqPer}, skill = Skill, skill_num = SkillNum} -> 
            PetData = {Id, Name, PetType, BaseId, Lev, Mod, GrowVal, HappyVal, Exp, pet_data_exp:get(Lev), Xl, Tz, Js, Lq, XlVal, TzVal, JsVal, LqVal, XlPer, TzPer, JsPer, LqPer, SkillNum, Skill},
            {reply, PetData};
        _ -> 
            {ok}
    end;

%% 获取所在排行榜名次
handle(11094, {Type}, Role) ->
    {reply, {Type, rank:sort_num(Type, Role)}};

handle(11096, {}, Role) ->
    {reply, {rank:get_self_dungeon(Role)}};

%% 获取本服综合战力排行榜
handle(11098, {}, _Role) ->
    {reply, {rank:list(?rank_total_power)}};

%% 获取跨服综合战力排行榜
handle(11099, {}, _Role) ->
    {reply, {rank:list(?rank_cross_total_power)}};

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.


%%
% get_index_page_data(Data, Index) ->
%     Min = (Index - 1) * ?rank_celebrity_row_count,
%     Max = Index * ?rank_celebrity_row_count,
%     Fun = fun(E = #rank_global_celebrity{id = Id})->
%             I = Id rem 100,
%             case (I > Min) and (I =< Max) of 
%                 true ->
%                     E;
%                 _ ->
%                     []
%             end end,
%     lists:flatten(lists:map(Fun, Data)).

%% 取数据
get_certain_page_data(PageIndex, Data) ->
    case erlang:length(Data) of 
        0 ->{0, []};
        _ -> 
            TotalPage = util:ceil(length(Data) / ?rank_row_count),
            OffsetStart = (PageIndex - 1) * ?rank_row_count + 1, %% 从1开始
            OffsetEnd = OffsetStart + ?rank_row_count,
            PageData = do_page(Data, OffsetStart, OffsetEnd, 1, []),
            PageData1 = lists:reverse(PageData),
            {TotalPage, PageData1}
    end.

get_certain_page_data2(PageIndex, Data) ->
    case erlang:length(Data) of 
        0 ->{0, []};
        _ -> 
            TotalPage = util:ceil(length(Data) / ?rank_celebrity_row_count),
            OffsetStart = (PageIndex - 1) * ?rank_celebrity_row_count + 1, %% 从1开始
            OffsetEnd = OffsetStart + ?rank_celebrity_row_count,
            PageData = do_page(Data, OffsetStart, OffsetEnd, 1, []),
            PageData1 = lists:reverse(PageData),
            {TotalPage, PageData1}
    end.



%% 获取某一页数据
do_page([], _OffsetStart, _OffsetEnd, _Index,T) -> T;
do_page(_, _OffsetStart, OffsetEnd, OffsetEnd,T) -> T;
do_page([Data | T], OffsetStart, OffsetEnd, Index, Temp) ->
    case OffsetStart =< Index of
        true ->
            do_page(T, OffsetStart, OffsetEnd, (Index + 1),[Data|Temp]);    
        false ->
            do_page(T, OffsetStart, OffsetEnd, (Index + 1),Temp)
    end.


% %%查找角色排名所在的页的数据
% find_data(Type,Role) ->
%     Loc = rank:sort_num(Type,Role),
%     case Loc of 
%         0 -> 0;
%         _ ->    
%             ?DEBUG("--Loc--:~w~n",[Loc]),
%             PageIndex = erlang:round(Loc / ?rank_row_count),
%             ?DEBUG("-417---:~w~n",[PageIndex]),
%             {PageIndex}
%     end.


%% 通过类型过滤,主要用于装备防具的分类    
% filter_by_type(Type,Data) ->
%     do_filter(Type,Data,[]).

% do_filter(_,[],L) -> L;
% do_filter(Type,[H = #rank_equip_armor{type = Type}|T],L) ->
%     do_filter(Type,T,[H|L]);
% do_filter(Type,[#rank_equip_armor{type = _Other}|T],L) ->
%     do_filter(Type,T,L).

%% 根据类型获取名人榜数据
get_celebrity_by_type(Data, Type) ->
    Fun = fun(E = #rank_global_celebrity{id = Id})->
            case (Id div 100 rem 100) == Type of 
                true ->
                    E;
                _ ->
                    []
            end end,
    lists:flatten(lists:map(Fun, Data)).


format_data(Data) ->
    do_format(Data, []).
do_format([], L) -> L;
do_format([H|T],L)->
    case is_record(H, rank_equip_arms) of 
        true ->
            ?DEBUG("--rank_equip_arms---~p~n~n", [H#rank_equip_arms.score]),
            Data = {H#rank_equip_arms.srv_id,H#rank_equip_arms.rid,H#rank_equip_arms.name,H#rank_equip_arms.career,H#rank_equip_arms.sex,
            H#rank_equip_arms.guild,H#rank_equip_arms.arms,H#rank_equip_arms.score,H#rank_equip_arms.vip,H#rank_equip_arms.quality,H#rank_equip_arms.realm},
            do_format(T,[Data|L]);
        false ->
            case is_record(H, rank_equip_armor) of 
                true ->
                    ?DEBUG("--rank_equip_armor---~p~n~n", [H#rank_equip_armor.score]),
                    Data = {H#rank_equip_armor.srv_id,H#rank_equip_armor.rid,H#rank_equip_armor.name,H#rank_equip_armor.career,H#rank_equip_armor.sex,
                    H#rank_equip_armor.guild,H#rank_equip_armor.armor,H#rank_equip_armor.score,H#rank_equip_armor.vip,H#rank_equip_armor.quality,H#rank_equip_armor.realm},
                    do_format(T,[Data|L]);
                false ->
                    do_format(T, L)
            end
    end.
