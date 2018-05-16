%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 宠物战回合制关卡副本
%%% @end
%%% Created : 21. 十一月 2017 17:56
%%%-------------------------------------------------------------------
-module(pet_war_dun).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("pet_war.hrl").
-include("goods.hrl").
-include("pet.hrl").
-include("scene.hrl").
-include("battle.hrl").

%% API
-export([
    get_dun_info/0, %% 读取副本面板信息
    challenge/3, %% 发起挑战
    get_war_mon_list/1,
    recv_star/3, %% 领取星数奖励
    saodang/2, %% 扫荡
    get_dun_info/1,
    recv_dun_reward/2, %% 领取副本奖励
    get_star_info/1, %% 获取星数信息
    one_key_saodang/2, %% 一键扫荡
    gm/1
]).

%% 内部接口
-export([
    init/1,
    midnight_refresh/0,
    add_hp/2,
    logout/1
]).

gm(DunId) ->
    St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    NewSt = St#st_pet_war_dun{dun_id = DunId},
    lib_dict:put(?PROC_STATUS_PET_WAR_DUN, NewSt).

add_hp(_Player, _Hp) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    #st_pet{pet_list = PetList} = StPet,
    F = fun(Pet) ->
        Pet#pet{}
    end,
    lists:map(F, PetList),
    ok.

init(#player{key = Pkey} = Player) ->
    StPetWarDun =
        case player_util:is_new_role(Player) of
            true -> #st_pet_war_dun{pkey = Pkey};
            false -> pet_war_load:load_pet_dun(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_PET_WAR_DUN, StPetWarDun),
    update_pet_war_dun(),
    Player.

update_pet_war_dun() ->
    StPetWarDun = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    #st_pet_war_dun{op_time = OpTime} = StPetWarDun,
    Now = util:unixtime(),
    case util:is_same_date(OpTime, Now) of
        true ->
            NewStPetWarDun = StPetWarDun;
        false ->
            NewStPetWarDun = StPetWarDun#st_pet_war_dun{saodang_list = [], op_time = Now}
    end,
    lib_dict:put(?PROC_STATUS_PET_WAR_DUN, NewStPetWarDun).

midnight_refresh() ->
    update_pet_war_dun().

get_star_info(Chapter) ->
    St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    #st_pet_war_dun{
        recv_star_list = RecvStarList,
        dun_id = DunId
    } = St,
    #base_pet_war_dun{
        chapter = MyChapter
    } = data_pet_war_dun:get(max(1, DunId)),
    BaseStarRewardList = data_pet_war_star:get_by_chapter(Chapter),
    F = fun({Star, Reward}) ->
        case lists:member({Chapter, Star}, RecvStarList) of
            true -> [Star, 2, util:list_tuple_to_list(Reward)]; %%已领取
            false ->
                if
                    MyChapter > Chapter -> [Star, 1, util:list_tuple_to_list(Reward)]; %%可领取
                    true ->
                        Ids = data_pet_war_dun:get_ids_by_chapter(Chapter),
                        F0 = fun(Id) -> Id =< DunId end,
                        List = lists:filter(F0, Ids),
                        ?IF_ELSE(length(List) >= Star, [Star, 1, util:list_tuple_to_list(Reward)], [Star, 0, util:list_tuple_to_list(Reward)])
                end
        end
    end,
    lists:map(F, BaseStarRewardList).

%% 读取副本面板信息
get_dun_info() ->
    St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    #st_pet_war_dun{
        dun_id = DunId
    } = St,
    if
        DunId == 0 ->
            Ids = data_pet_war_dun:ids(),
            Id = hd(Ids),
            #base_pet_war_dun{
                chapter = Chapter
            } = data_pet_war_dun:get(Id),
            {Id, Chapter, 0};
        true ->
            case data_pet_war_dun:get(DunId + 1) of
                [] -> %% 极限点
                    #base_pet_war_dun{chapter = Chapter} = data_pet_war_dun:get(DunId),
                    {DunId, Chapter, 1};
                #base_pet_war_dun{chapter = Chapter} -> %% 读取下一可挑战副本ID
                    {DunId + 1, Chapter, 0}
            end
    end.

%% 发起挑战
challenge(Player, ChallengeDunId, ChallengeMapId) ->
    St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    #st_pet_war_dun{dun_id = DunId} = St,
    case check_challenge(Player, ChallengeDunId, ChallengeMapId, DunId) of
        {fail, Code} -> {Code, [], [], Player};
        {true, WarPetList} ->
            WarMonList = get_war_mon_list(ChallengeDunId),
            {Winner, BattleBin} = pet_battle:battle_mon(Player, WarPetList, WarMonList),
            server_send:send_to_sid(Player#player.sid, BattleBin),
            case Winner of
                ?TEAM1 ->
                    NewSt = St#st_pet_war_dun{dun_id = ChallengeDunId, op_time = util:unixtime()},
                    lib_dict:put(?PROC_STATUS_PET_WAR_DUN, NewSt),
                    pet_war_load:update_pet_dun(NewSt),
                    #base_pet_war_dun{
                        first_pass_reward = FirstPassReward,
                        chapter = Chapter
                    } = data_pet_war_dun:get(ChallengeDunId),
                    put(pet_war_dun, {ChallengeDunId, FirstPassReward}),
                    Sql = io_lib:format("insert into log_pet_round_dungeon set pkey=~p,dun_id=~p,ret=~p,chapter=~p,first_pass_reward='~s',daily_pass_reward='~s',time=~p",
                        [Player#player.key, ChallengeDunId, 1, Chapter, util:term_to_bitstring(FirstPassReward), util:term_to_bitstring([]), util:unixtime()]),
                    log_proc:log(Sql),
                    {1, util:list_tuple_to_list(FirstPassReward), util:list_tuple_to_list([]), Player};
                _ -> %% 挑战输
                    {0, [], [], Player}
            end
    end.

rand_ratio(RewardList) ->
    F = fun({Gid, GNum, Power}) ->
        {{Gid, GNum}, Power}
    end,
    List = lists:map(F, RewardList),
    util:list_rand_ratio(List).

check_challenge(Player, ChallengeDunId, ChallengeMapId, DunId) ->
    Base = data_pet_war_dun:get(ChallengeDunId),
    if
        ChallengeDunId =< DunId -> {fail, 4}; %% 已挑战完
        ChallengeDunId > DunId + 1 -> {fail, 5}; %% 前置关卡未挑战
        Player#player.lv < Base#base_pet_war_dun.lv -> {fail, 11}; %% 等级不足
        true ->
            StPetMap = lib_dict:get(?PROC_STATUS_PET_MAP),
            #st_pet_map{map_list = MapList} = StPetMap,
            StPet = lib_dict:get(?PROC_STATUS_PET),
            #st_pet{pet_list = PetList} = StPet,
            F = fun({{MapId, Pos}, PetKey}) ->
                if
                    MapId == ChallengeMapId ->
                        case lists:keyfind(PetKey, #pet.key, PetList) of
                            false -> [];
                            Pet ->
                                BasePet = data_pet:get(Pet#pet.type_id),
                                Pet00 = pet_attr:get_war_pet(StPet, Pet),
                                [Pet00#pet{war_pos = Pos, war_skill = BasePet#base_pet.war_skill_list}]
                        end;
                    true -> []
                end
            end,
            WarPetList = lists:flatmap(F, MapList),
            if
                WarPetList == [] -> {fail, 6}; %% 没有出战宠物
                true -> {true, WarPetList}
            end
    end.

get_war_mon_list(ChallengeDunId) ->
    #base_pet_war_dun{map_id = MapId, mon_list = MonIdList} = data_pet_war_dun:get(ChallengeDunId),
    #base_pet_map{map = MapIdList} = data_pet_war_map:get(MapId),
    F = fun(MonId, {AccMapIdList, AccMonList}) ->
        if
            AccMapIdList == [] -> {AccMapIdList, AccMonList};
            true ->
                [Pos | T] = AccMapIdList,
                Mon = data_pet_war_mon:get(MonId),
                {T, [Mon#base_round_mon{war_pos = Pos} | AccMonList]}
        end
    end,
    {_MonIdList, WarMonList} = lists:foldl(F, {MapIdList, []}, MonIdList),
    WarMonList.

%% 领取星数奖励
recv_star(Player, Chapter, Star) ->
    case check_recv_star(Chapter, Star) of
        {fail, Code} ->
            {Code, [], Player};
        {true, StarReward} ->
            St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
            #st_pet_war_dun{recv_star_list = RecvStarList} = St,
            NewRecvStarList = [{Chapter, Star} | RecvStarList],
            NewSt = St#st_pet_war_dun{recv_star_list = NewRecvStarList, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_PET_WAR_DUN, NewSt),
            pet_war_load:update_pet_dun(NewSt),
            GiveGoodsList = goods:make_give_goods_list(738, StarReward),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            Sql = io_lib:format("insert into log_pet_round_dun_star set pkey=~p,chapter=~p,recv_star=~p,reward='~s',time=~p",
                [Player#player.key, Chapter, Star, util:term_to_bitstring(StarReward), util:unixtime()]),
            log_proc:log(Sql),
            {1, util:list_tuple_to_list(StarReward), NewPlayer}
    end.

check_recv_star(Chapter, Star) ->
    St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    #st_pet_war_dun{recv_star_list = RecvStarList, dun_id = DunId} = St,
    case lists:member({Chapter, Star}, RecvStarList) of
        true -> {fail, 2}; %% 已领取
        false ->
            case data_pet_war_star:get_by_chapter_star(Chapter, Star) of
                [] -> {fail, 0}; %% 配置错误
                #base_pet_war_star{reward = StarReward} ->
                    #base_pet_war_dun{chapter = BaseChapter} = data_pet_war_dun:get(max(1, DunId)),
                    if
                        BaseChapter < Chapter -> {fail, 0}; %% 还未挑战到此章节
                        true ->
                            Ids = data_pet_war_dun:get_ids_by_chapter(Chapter),
                            F = fun(BaseDunId) -> BaseDunId =< DunId end,
                            PassList = lists:filter(F, Ids),
                            if
                                Star > length(PassList) -> {fail, 7}; %% 星数不足
                                true -> {true, StarReward}
                            end
                    end
            end
    end.

%% 关卡扫荡
saodang(Player, SaodangDunId) ->
    case check_saodang(SaodangDunId) of
        {fail, Code} -> {Code, [], Player};
        {true, BasePetWarDun, NewSaodangList, LogSaodangNum} ->
            St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
            NewSt = St#st_pet_war_dun{saodang_list = NewSaodangList, op_time = util:unixtime()},
            lib_dict:put(?PROC_STATUS_PET_WAR_DUN, NewSt),
            pet_war_load:update_pet_dun(NewSt),
            #base_pet_war_dun{daily_pass_reward = DailyPassReward, chapter = Chapter} = BasePetWarDun,
            DailyReward = rand_ratio(DailyPassReward),
            GiveGoodsList = goods:make_give_goods_list(739, [DailyReward]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            Sql = io_lib:format("insert into log_pet_round_dun_saodang set pkey=~p, chapter=~p, dun_id=~p,saodang=~p,reward='~s',`time`=~p",
                [Player#player.key, Chapter, SaodangDunId, LogSaodangNum, util:term_to_bitstring([DailyReward]), util:unixtime()]),
            log_proc:log(Sql),
            {1, util:list_tuple_to_list([DailyReward]), NewPlayer}
    end.

check_saodang(SaodangDunId) ->
    St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    #st_pet_war_dun{dun_id = DunId, saodang_list = SaodangList} = St,
    if
        SaodangDunId > DunId -> {fail, 8}; %% 该关卡还未通关
        true ->
            Base = data_pet_war_dun:get(SaodangDunId),
            case lists:keytake(SaodangDunId, 1, SaodangList) of
                false -> {true, Base, [{SaodangDunId, 1} | SaodangList], 1};
                {value, {_DunId, SaodangNum}, Rest} ->
                    if
                        SaodangNum >= Base#base_pet_war_dun.saodang_num -> {fail, 3}; %% 扫荡次数满了
                        true -> {true, Base, [{SaodangDunId, SaodangNum + 1} | Rest], SaodangNum + 1}
                    end
            end
    end.

one_key_saodang(Player, Chapter) ->
    AllDunIds = data_pet_war_dun:get_ids_by_chapter(Chapter),
    F = fun(DunId, {AccReward, AccDunIdList}) ->
        case check_saodang(DunId) of
            {fail, _} -> {AccReward, AccDunIdList};
            {true, BasePetWarDun, _NewSaodangList, _LogSaodangNum} ->
                #base_pet_war_dun{daily_pass_reward = DailyPassReward} = BasePetWarDun,
                DailyReward = rand_ratio(DailyPassReward),
                {[DailyReward|AccReward], [DunId|AccDunIdList]}
        end
    end,
    {SumReward, SaodangDunIdList} = lists:foldl(F, {[], []}, AllDunIds),
    St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    MaxDunId = lists:max(AllDunIds),
    if
        St#st_pet_war_dun.dun_id < MaxDunId -> {12, [], Player};
        SumReward == [] -> {13, [], Player};
        true ->
            St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
            NewSt = St#st_pet_war_dun{
                saodang_list = get_saodang(SaodangDunIdList, St#st_pet_war_dun.saodang_list),
                op_time = util:unixtime()
            },
            lib_dict:put(?PROC_STATUS_PET_WAR_DUN, NewSt),
            pet_war_load:update_pet_dun(NewSt),
            GiveGoodsList = goods:make_give_goods_list(739, SumReward),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {1, util:list_tuple_to_list(SumReward), NewPlayer}
    end.

get_saodang(DunList, SaodangList) ->
    F = fun(DunId, AccSaodangList) ->
        case lists:keytake(DunId, 1, AccSaodangList) of
            false ->
                [{DunId, 1}|AccSaodangList];
            {value, {DunId, Num}, Rest} ->
                [{DunId, Num+1}|Rest]
        end
    end,
    lists:foldl(F, SaodangList, DunList).

get_dun_info(DunId) ->
    St = lib_dict:get(?PROC_STATUS_PET_WAR_DUN),
    #st_pet_war_dun{saodang_list = SaodangList} = St,
    case lists:keyfind(DunId, 1, SaodangList) of
        false -> SaodangNum = 0;
        {_DunId, SaodangNum0} ->
            SaodangNum = SaodangNum0
    end,
    #base_pet_war_dun{
        first_pass_reward = FirstPassReward,
        daily_pass_reward = DailyPassReward
    } = data_pet_war_dun:get(DunId),
    NewDailyPassReward = lists:map(fun({Gid, GNum, _Power}) -> [Gid, GNum] end, DailyPassReward),
    {SaodangNum, util:list_tuple_to_list(FirstPassReward), NewDailyPassReward}.

%% 奖励领取
recv_dun_reward(Player, DunId) ->
    case get(pet_war_dun) of
        {DunId, GoodsList} ->
            GiveGoodsList = goods:make_give_goods_list(737, GoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            erase(pet_war_dun),
            {1, NewPlayer};
        _ ->
            {0, Player}
    end.

%% 异常退出时，邮件补发奖励
logout(Player) ->
    case get(pet_war_dun) of
        {_DunId, GoodsList} ->
            {Title, Content} = t_mail:mail_content(152),
            mail:sys_send_mail([Player#player.key], Title, Content, GoodsList),
            erase(pet_war_dun);
        _ ->
            skip
    end.