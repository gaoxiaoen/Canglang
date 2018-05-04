%%-------------------------------------------------------------------
%% File              :mod_pet_data.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-10-20
%% @doc
%%     宠物数据模块
%% @end
%%-------------------------------------------------------------------


-module(mod_pet_data).


%%
%% Include files
%%
-include("mgeew.hrl").

%%
%% Exported Functions
%%
-export([init_role_pet/1,
         get_role_pet/1,
         t_set_role_pet/2,
         set_role_pet/2,
         
         init_pet_bag/1,
         get_pet_bag/1,
         t_set_pet_bag/2,
         set_pet_bag/2,
         dump_pet_bag/1,
         
         get_pet/1,
         t_set_pet/2,
         set_pet/2,
         erase_pet/1
        ]).

-export([get_role_bag_pets/1,
         create_pet/1,
         gen_p_pet/1
        ]).

%% 玩家宠物数据
init_role_pet(RoleId) ->
    case db_api:dirty_read(?DB_ROLE_PET,RoleId) of
        [RolePet] ->
            next;
        _ ->
            RolePet = #r_role_pet{role_id=RoleId}
    end,
    mod_role:init_dict({?DB_ROLE_PET, RoleId}, RolePet).
get_role_pet(RoleId) ->
    mod_role:get_dict({?DB_ROLE_PET, RoleId}).
t_set_role_pet(RoleId,RolePet) ->
    mod_role:t_set_dict({?DB_ROLE_PET, RoleId}, RolePet).
set_role_pet(RoleId,RolePet) ->
    mod_role:set_dict({?DB_ROLE_PET, RoleId}, RolePet).

%% 宠物背包
init_pet_bag(RoleId) ->
    BagIdList = [?PET_BAG_ID_MAIN,?PET_BAG_ID_DEPOT],
    init_pet_bag(BagIdList,RoleId).
init_pet_bag([],_RoleId) ->
    ok;
init_pet_bag([BagId | BagIdList],RoleId) ->
    case db_api:dirty_read(?DB_ROLE_PET,{RoleId,BagId}) of
        [PetBag] ->
            next;
        _ ->
            case BagId of
                ?PET_BAG_ID_MAIN ->
                    GridNumber = ?PET_BAG_MAIN_MAX_GRID_NUMBER;
                ?PET_BAG_ID_DEPOT ->
                    GridNumber = ?PET_BAG_DEPOT_MAX_GRID_NUMBER;
                _ ->
                    GridNumber = 0
            end,
            PetBag = #r_pet_bag{pet_bag_key={RoleId,BagId},grid_number=GridNumber,pets=[]},
            mod_role:set_dict({?DB_PET_BAG, {RoleId,BagId}}, PetBag)
    end,
    mod_role:set_dict({?DB_PET_BAG, {RoleId,BagId}}, PetBag),
    init_pet_bag(BagIdList,RoleId).

get_pet_bag({RoleId,BagId}) ->
    mod_role:get_dict({?DB_PET_BAG, {RoleId,BagId}}).
t_set_pet_bag({RoleId,BagId},PetBag) ->
    mod_role:t_set_dict({?DB_PET_BAG, {RoleId,BagId}}, PetBag).
set_pet_bag({RoleId,BagId},PetBag) ->
    mod_role:set_dict({?DB_PET_BAG, {RoleId,BagId}}, PetBag).
dump_pet_bag(RoleId) ->
    case get_role_pet(RoleId) of
        {ok,#r_role_pet{battle_id=BattlePetId}} ->
            next;
        _ ->
            BattlePetId = 0
    end,
    [case get_pet_bag({RoleId,BagId}) of
         {ok,#r_pet_bag{pets=PetIdList}=PetBag} ->
             lists:foreach(fun(PetId) -> dump_pet(PetId,BattlePetId) end, PetIdList),
             db_api:dirty_write(?DB_PET_BAG,PetBag),
             ok;
         _ ->
             ignore
     end || BagId <- [?PET_BAG_ID_MAIN,?PET_BAG_ID_DEPOT]].

%% 宠物数据
get_pet(PetId) ->
    case mod_role:get_dict({?DB_PET, PetId}) of
        {ok,Pet} ->
            {ok,Pet};
        _ ->
            case db_api:dirty_read(?DB_PET,PetId) of
                [Pet] ->
                    mod_role:init_dict({?DB_PET, PetId}, Pet),
                    {ok,Pet};
                _ ->
                    {error,not_found}
            end
    end.
t_set_pet(PetId,Pet) ->
    mod_role:t_set_dict({?DB_PET, PetId}, Pet).
set_pet(PetId,Pet) ->
    mod_role:set_dict({?DB_PET, PetId}, Pet).
erase_pet(PetId) ->
    mod_role:erase_dict({?DB_PET, PetId},?DB_PET).

dump_pet(PetId,BattlePetId) ->
    case get_pet(PetId) of
        {ok,Pet} ->
            case PetId == BattlePetId of
                true ->
                    BuffList = mod_buff:get_object_buff(PetId, ?ACTOR_TYPE_PET),
                    NewPet = Pet#r_pet{buffs=BuffList},
                    db_api:dirty_write(?DB_PET,NewPet);
                _ ->
                    db_api:dirty_write(?DB_PET,Pet)
            end,
            ok;
        _ ->
            ignore
    end.

%% 获取玩家携带宠物信息列表
%% return [] | [#p_pet_tiny{},...]
get_role_bag_pets(RoleId) ->
    case get_pet_bag({RoleId,?PET_BAG_ID_MAIN}) of
        {ok,#r_pet_bag{pets=PetIdList}} ->
            [begin
                 {ok,Pet} = get_pet(PetId),
                 #p_pet_tiny{pet_id=PetId,
                             pet_name=Pet#p_pet.pet_name,
                             type_id=Pet#p_pet.type_id,
                             bind=Pet#p_pet.bind}
             end || PetId <- PetIdList];
        _ ->
            []
    end.

%% 创建宠物
%% return {ok,#p_pet{}}
create_pet(PetTypeId) ->
    PetInfo = cfg_pet:find(PetTypeId),
    #r_pet_info{type_id=TypeId,
                name=Name,
                base_attr_dot=BaseAttrDot,
                life=Life,
                inborn=InbornList,
                hp_aptitude=HpAptitude,
                mp_aptitude=MpAptitude,
                phy_attack_aptitude=PhyAttackAptitude,
                magic_attack_aptitude=MagicAttackAptitude,
                phy_defence_aptitude=PhyDefenceAptitude,
                magic_defence_aptitude=MagicDefenceAptitude,
                miss_aptitude=MissAptitude,
                skills=Skills} = PetInfo,
    {Power,Magic,Body,Spirit,Agile} = gen_pet_base_attr(BaseAttrDot),
    #r_level_exp{exp=NextLevelExp} = cfg_pet_level_exp:find(1),
    InbornWeightList = [InbornWeight ||{_,InbornWeight} <- InbornList],
    {Inborn,_} = lists:nth(common_tool:get_random_index(InbornWeightList, 0, 0), InbornList),
    SkillList = lists:foldl(
                  fun({SkillId,SkillLevel,SkillWeight},AccSkillList) -> 
                          case common_tool:random(1, 10000) > SkillWeight of
                              true ->
                                  AccSkillList;
                              _ ->
                                  [#p_actor_skill{skill_id=SkillId,level=SkillLevel} | AccSkillList]
                          end
                  end, [], Skills),
    Pet = #r_pet{type_id=TypeId,
                 pet_name=Name,
                 status=0,
                 bind=0,
                 life=Life,
                 inborn=Inborn,
                 level=1,
                 exp=0,
                 next_level_exp=NextLevelExp,
                 hp_aptitude=gen_pet_aptitude(HpAptitude,0),
                 mp_aptitude=gen_pet_aptitude(MpAptitude,0),
                 phy_attack_aptitude=gen_pet_aptitude(PhyAttackAptitude,0),
                 magic_attack_aptitude=gen_pet_aptitude(MagicAttackAptitude,0),
                 phy_defence_aptitude=gen_pet_aptitude(PhyDefenceAptitude,0),
                 magic_defence_aptitude=gen_pet_aptitude(MagicDefenceAptitude,0),
                 miss_aptitude=gen_pet_aptitude(MissAptitude,0),
                 i_power=Power,
                 i_magic=Magic,
                 i_body=Body,
                 i_spirit=Spirit,
                 i_agile=Agile,
                 b_power=Power + 1,
                 b_magic=Magic + 1,
                 b_body=Body + 1,
                 b_spirit=Spirit + 1,
                 b_agile=Agile + 1,
                 add_attr_dot=5,
                 power=Power + 1,
                 magic=Magic + 1,
                 body=Body + 1,
                 spirit=Spirit + 1,
                 agile=Agile + 1,
                 attr=#p_fight_attr{},
                 skills=SkillList,
                 buffs=[]
                 },
    {ok,Pet}.

%% {power,magic,body,spirit,agile}
gen_pet_base_attr(TotalPoint) ->
    Count = 5,
    Min = 11,
    Max = 29,
    PointList = common_tool:gen_multi_random_number(Count, Min, Max, TotalPoint, []),
    StartIndex = common_tool:random(1, Count),
    gen_pet_base_attr2(Count,StartIndex,Count,PointList,[]).

gen_pet_base_attr2(0,_StartIndex,_Count,_PointList,AttrList) ->
    erlang:list_to_tuple(AttrList);
gen_pet_base_attr2(Index,StartIndex,Count,PointList,AttrList) ->
    case StartIndex > Count of
        true ->
            NewStartIndex = 1;
        false ->
            NewStartIndex = StartIndex
    end,
    gen_pet_base_attr2(Index - 1,StartIndex + 1,Count,PointList,[lists:nth(NewStartIndex, PointList) | AttrList]).

%% 根据最小值和最大值，随机计算各种意资质
gen_pet_aptitude([{Min,Max}],_DefaultValue) ->
    random:seed(erlang:now()),
    common_tool:random(Min, Max);
gen_pet_aptitude(_,DefaultValue) ->
    DefaultValue.

%% 生成p_pet，根据r_pet记录数据生成
%% Pet #r_pet{}
%% return #p_pet{}
gen_p_pet(Pet) ->
    #r_pet{pet_id=PetId,
           role_id=RoleId,
           pet_name= PetName, 
           type_id= TypeId, 
           status= Status, 
           bind= Bind, 
           life= Life, 
           inborn= Inborn, 
           exp= Exp, 
           next_level_exp= NextLevelExp, 
           level= Level, 
           hp_aptitude= HpAptitude, 
           mp_aptitude= MpAptitude, 
           phy_attack_aptitude= PhyAttackAptitude, 
           magic_attack_aptitude= MagicAttackAptitude, 
           phy_defence_aptitude= PhyDefenceAptitude, 
           magic_defence_aptitude= MagicDefenceAptitude, 
           miss_aptitude= MissAptitude, 
           i_power= IPower, i_magic= IMagic, i_body= IBody, i_spirit= ISpirit, i_agile= IAgile, 
           b_power= BPower, b_magic= BMagic, b_body= BBody, b_spirit= BSpirit, b_agile= BAgile, 
           add_attr_dot= AddAttrDot, 
           power= Power, magic= Magic, body= Body, spirit= Spirit, agile= Agile, 
           attr= Attr, skills=Skills} = Pet,
    #p_pet{  pet_id = PetId,
             role_id = RoleId,  
             type_id=TypeId,
             pet_name=PetName,
             status=Status,
             bind=Bind,
             life=Life,
             inborn=Inborn,
             level=Level,exp=Exp,next_level_exp=NextLevelExp,
             hp_aptitude=HpAptitude,
             mp_aptitude=MpAptitude,
             phy_attack_aptitude=PhyAttackAptitude,
             magic_attack_aptitude=MagicAttackAptitude,
             phy_defence_aptitude=PhyDefenceAptitude,
             magic_defence_aptitude=MagicDefenceAptitude,
             miss_aptitude=MissAptitude,
             i_power=IPower,i_magic=IMagic,i_body=IBody,i_spirit=ISpirit,i_agile=IAgile,
             b_power=BPower,b_magic=BMagic,b_body=BBody,b_spirit=BSpirit,b_agile=BAgile,
             add_attr_dot=AddAttrDot,
             power=Power,magic=Magic,body=Body,spirit=Spirit,agile=Agile,
             attr=Attr,skills = Skills
          }.
    
               