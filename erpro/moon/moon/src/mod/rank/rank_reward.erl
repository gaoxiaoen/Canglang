%%----------------------------------------------------
%% 排行榜称号数据
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_reward).
-export([
        login/1
        ,first_power_honor/1
        ,update_honor/3
        ,update_honor/4
        ,reward/1
        ,get_reward_base/3
    ]
).

-include("common.hrl").
-include("rank.hrl").
-include("role.hrl").
-include("achievement.hrl").
-include("npc.hrl").

%% 排行榜首席弟子称号 L = [npc_special{}]
first_power_honor(L) ->
    HonorL = do_first_power_honor(L, []),
    honor_mgr:replace_honor_gainer(rank_first_power_honor, HonorL).
do_first_power_honor([], HonorL) -> HonorL;
do_first_power_honor([#npc_special{data = {Rid, _Name, _Sex, ?career_zhenwu, _Looks}} | T], HonorL) ->
    do_first_power_honor(T, [{Rid, 20153} | HonorL]);
do_first_power_honor([#npc_special{data = {Rid, _Name, _Sex, ?career_cike, _Looks}} | T], HonorL) ->
    do_first_power_honor(T, [{Rid, 20155} | HonorL]);
do_first_power_honor([#npc_special{data = {Rid, _Name, _Sex, ?career_xianzhe, _Looks}} | T], HonorL) ->
    do_first_power_honor(T, [{Rid, 20154} | HonorL]);
do_first_power_honor([#npc_special{data = {Rid, _Name, _Sex, ?career_feiyu, _Looks}} | T], HonorL) ->
    do_first_power_honor(T, [{Rid, 20156} | HonorL]);
do_first_power_honor([#npc_special{data = {Rid, _Name, _Sex, ?career_qishi, _Looks}} | T], HonorL) ->
    do_first_power_honor(T, [{Rid, 20157} | HonorL]);
do_first_power_honor([_ | T], HonorL) ->
    do_first_power_honor(T, HonorL).

%% 角色登录重置排行榜称号
login(Role = #role{id = Rid, achievement = Ach = #role_achievement{honor_all = All}}) ->
    All1 = role_honor(All, Rid, ?rank_role_lev),
    All2 = role_honor(All1, Rid, ?rank_role_power),
    All3 = role_honor(All2, Rid, ?rank_role_coin),
    All4 = role_honor(All3, Rid, ?rank_role_soul),
    All5 = role_honor(All4, Rid, ?rank_role_skill),
    All6 = role_honor(All5, Rid, ?rank_role_achieve),
    All7 = role_honor(All6, Rid, ?rank_role_pet_power),
    All8 = role_honor(All7, Rid, ?rank_wit_acc),
    All9 = role_honor(All8, Rid, ?rank_wit_last),
    All10 = role_honor(All9, Rid, ?rank_glamor_acc),
    All11 = role_honor(All10, Rid, ?rank_flower_day),
    All12 = role_honor(All11, Rid, ?rank_glamor_day),
    All13 = role_honor(All12, Rid, ?rank_darren_coin),
    All14 = role_honor(All13, Rid, ?rank_darren_casino),
    All15 = role_honor(All14, Rid, ?rank_darren_exp),
    All16 = role_honor(All15, Rid, ?rank_darren_attainment),
    NewAll = role_honor(All16, Rid, ?rank_celebrity),
    Role#role{achievement = Ach#role_achievement{honor_all = NewAll}}.

%% 更新榜称号
update_honor(Type, OldL, NewL) -> %% 不区分男/女
    OldHonorL = find_honor(Type, 1, OldL, []),
    NewHonorL = find_honor(Type, 1, NewL, []),
    DelL = OldHonorL -- NewHonorL,
    AddL = NewHonorL -- OldHonorL,
    [achievement:del_honor(Rid, Honor) || {Rid, Honor} <- DelL],
    [achievement:add_and_use_honor(Rid, Honor) || {Rid, Honor} <- AddL],
    NewHonorL.
update_honor(Type, OldL, Male, Female) -> %% 区分男/女
    OldHonorL = find_honor(Type, 1, OldL, []),
    MaleHonorL = find_honor(Type, 1, Male, []),
    NewHonorL = find_honor(Type, 1, Female, MaleHonorL),
    DelL = OldHonorL -- NewHonorL,
    AddL = NewHonorL -- OldHonorL,
    [achievement:del_honor(Rid, Honor) || {Rid, Honor} <- DelL],
    [achievement:add_and_use_honor(Rid, Honor) || {Rid, Honor} <- AddL],
    NewHonorL.

%% 奖励发放
% reward(?rank_reward_open_srv_3) ->
%     do_reward(open_srv, ?rank_vie_kill);
% reward(?rank_reward_open_srv_5) ->
%     do_reward(open_srv, ?rank_role_lev),
%     do_reward(open_srv, ?rank_role_pet_power),
%     do_reward(open_srv, ?rank_total_power),
%     do_reward(open_srv, ?rank_role_achieve),
%     do_reward(open_srv, ?rank_guild_lev);
% reward(?rank_reward_merge_srv) ->
%     do_reward(merge_srv, ?rank_arms),
%     do_reward(merge_srv, ?rank_armor);
% reward(cross_flower) -> %% 跨服鲜花榜
%     do_reward(normal, ?rank_cross_flower),
%     do_reward(normal, ?rank_cross_glamor);
% reward(camp_darren) -> %% 达人榜活动
%     Now = util:unixtime(),
%     StartT = util:datetime_to_seconds({{2013, 5, 18}, {0, 0, 0}}),
%     EndT = util:datetime_to_seconds({{2013, 5, 23}, {0, 10, 59}}),
%     case Now >= StartT andalso Now =< EndT of
%         false -> false;
%         true ->
%             %%do_reward(camp, ?rank_darren_coin),
%             do_reward(camp, ?rank_darren_casino)
%             %%do_reward(camp, ?rank_darren_exp)
%     end;
% reward(camp_flower) -> %% 送花榜活动
%     Now = util:unixtime(),
%     StartT = util:datetime_to_seconds({{2013, 2, 1}, {0, 0, 1}}),
%     EndT = util:datetime_to_seconds({{2013, 2, 4}, {0, 10, 59}}), %% 注意推迟过来一天的10分钟
%     case Now >= StartT andalso Now =< EndT of
%         false -> false;
%         true ->
%             do_reward(camp, ?rank_cross_flower),
%             do_reward(camp, ?rank_cross_glamor)
%     end;
reward(_Type) -> ok.

%%----------------------------------------------------------------------
%% 内部方法
%%----------------------------------------------------------------------

%% 发放奖励
% do_reward(Label, Type) ->
%     #rank{roles = L} = rank_mgr:lookup(Type),
%     do_reward(Label, Type, 1, L, []).
% do_reward(Label, Type, _Sort, [], L) -> 
%     do_reward_finish(Label, Type, L);
% do_reward(Label, Type, Sort, [I | T], L) -> 
%     NewL = case get_reward_base(Label, Type, Sort) of
%         {ok, #rank_reward_base{items = Items, assets = Assets, subject = Subject, content = Content}} ->
%             case get_role_info(I) of
%                 {{Rid, SrvId}, RName} ->
%                     mail_mgr:deliver({Rid, SrvId, RName}, {Subject, Content, Assets, Items}),
%                     [{Rid, SrvId, RName, Sort} | L];
%                 {Rid, SrvId} ->
%                     mail_mgr:deliver({Rid, SrvId}, {Subject, Content, Assets, Items}),
%                     [{Rid, SrvId, <<>>, Sort} | L];
%                 _ -> 
%                     L
%             end;
%         _ -> 
%             L
%     end,
%     notice_reward(Label, Type, Sort, I),
%     do_reward(Label, Type, Sort + 1, T, NewL).

% get_reward_base(camp, ?rank_darren_exp, Sort) when Sort =< 10 ->
%     Items = case Sort of
%         1 -> [{29268, 1, 8}];
%         2 -> [{29268, 1, 5}];
%         3 -> [{29268, 1, 3}];
%         _ -> [{29268, 1, 1}]
%     end,
%     {ok, #rank_reward_base{
%         subject = ?L(<<"飞仙达人，秀出个性">>)
%         ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您在练级狂人榜排名第~p，获得了下列超值大礼哦！">>), [Sort])
%         ,items = Items
%     }};
% get_reward_base(camp, ?rank_darren_coin, Sort) when Sort =< 10 ->
%     Items = case Sort of
%         1 -> [{29269, 1, 8}];
%         2 -> [{29269, 1, 5}];
%         3 -> [{29269, 1, 3}];
%         _ -> [{29269, 1, 1}]
%     end,
%     {ok, #rank_reward_base{
%         subject = ?L(<<"飞仙达人，秀出个性">>)
%         ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您在金币消费榜排名第~p，获得了下列超值大礼哦！">>), [Sort])
%         ,items = Items
%     }};
% get_reward_base(camp, ?rank_darren_casino, Sort) when Sort =< 3 ->
%     Items = case Sort of
%         1 -> [{29517, 1, 1}, {26035, 1, 2}];
%         2 -> [{29282, 1, 2}, {26015, 1, 2}];
%         3 -> [{29282, 1, 1}, {26015, 1, 1}];
%         _ -> []%%[{29270, 1, 1}]
%     end,
%     {ok, #rank_reward_base{
%         subject = ?L(<<"飞仙达人，秀出个性">>)
%         ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您在寻宝达人榜排名第~p，获得了下列超值大礼哦！">>), [Sort])
%         ,items = Items
%     }};
% get_reward_base(camp, ?rank_cross_flower, Sort) when Sort =< 10 ->
%     Items = case Sort of
%         1 -> [{29234, 1, 1}];
%         2 -> [{29233, 1, 1}];
%         3 -> [{29233, 1, 1}];
%         _ -> [{29233, 1, 1}]
%     end,
%     {ok, #rank_reward_base{
%         subject = ?L(<<"飞仙达人，秀出个性">>)
%         ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您在跨服送花鲜花榜排名第~p，获得了下列超值大礼哦！">>), [Sort])
%         ,items = Items
%     }};
% get_reward_base(camp, ?rank_cross_glamor, Sort) when Sort =< 10 ->
%     Items = case Sort of
%         1 -> [{29234, 1, 1}];
%         2 -> [{29233, 1, 1}];
%         3 -> [{29233, 1, 1}];
%         _ -> [{29233, 1, 1}]
%     end,
%     {ok, #rank_reward_base{
%         subject = ?L(<<"飞仙达人，秀出个性">>)
%         ,content = util:fbin(?L(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。活动期间，您在跨服收花鲜花榜排名第~p，获得了下列超值大礼哦！">>), [Sort])
%         ,items = Items
%     }};
get_reward_base(Label, Type, Sort) ->
    rank_data_reward:get(Label, Type, Sort).

%% 奖励发放世界公告
% notice_reward(normal, ?rank_cross_flower, 1, #rank_cross_flower{id = {Rid, SrvId}, name = Name}) ->
%     Msg = notice:item_to_msg({29234, 1, 1}),
%     RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
%     notice:send(54, util:fbin(?L(<<"~s洒脱无双，赠送鲜花无数，成为飞仙全时空的大众情圣，获得全世界独一无二的称号：飞仙情圣及~s">>), [RoleMsg, Msg]));
% notice_reward(normal, ?rank_cross_glamor, 1, #rank_cross_glamor{id = {Rid, SrvId}, name = Name}) ->
%     Msg = notice:item_to_msg({29234, 1, 1}),
%     RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
%     notice:send(54, util:fbin(?L(<<"~s魅力无限，获赠鲜花无数，成为飞仙全时空的人气宝贝，获得全世界独一无二的称号：鲜花宝贝及~s">>),[RoleMsg, Msg]));
% notice_reward(_Label, _Type, _Sort, _RankInfo) ->
%     ok.

%% 奖励发放完成后 对获奖角色(本服)统一处理
% do_reward_finish(normal, ?rank_cross_flower, RewardList) ->
%     Now = util:unixtime(),
%     H20191 = [{{Rid, SrvId}, 20191}  || {Rid, SrvId, _Name, Sort} <- RewardList, Sort =:= 1],
%     honor_mgr:replace_honor_gainer(cross_flower_award, H20191, Now + 86400); 
% do_reward_finish(normal, ?rank_cross_glamor, RewardList) ->
%     Now = util:unixtime(),
%     H20190 = [{{Rid, SrvId}, 20190}  || {Rid, SrvId, _Name, Sort} <- RewardList, Sort =:= 1],
%     honor_mgr:replace_honor_gainer(cross_glamor_award, H20190, Now + 86400);
% do_reward_finish(_Label, _Type, _RewardList) -> ok.

%% 获取相关榜角色标志{Rid, SrvId}
% get_role_info(#rank_role_lev{id = Id, name = Name}) -> {Id, Name};
% get_role_info(#rank_role_power{id = Id, name = Name}) -> {Id, Name};
% get_role_info(#rank_role_pet_power{id = Id, name = Name}) -> {Id, Name};
% get_role_info(#rank_role_achieve{id = Id, name = Name}) -> {Id, Name};
% get_role_info(#rank_vie_kill{id = Id, name = Name}) -> {Id, Name};
% get_role_info(#rank_guild_lev{chief_rid = Rid, chief_srv_id = SrvId}) -> {Rid, SrvId};
% get_role_info(#rank_equip_arms{id = Id, name = Name}) -> {Id, Name};
% get_role_info(#rank_total_power{id = Id, name = Name}) -> {Id, Name};
% get_role_info(#rank_equip_armor{rid = Rid, srv_id = SrvId, name = Name}) -> {{Rid, SrvId}, Name};
% get_role_info(#rank_darren_coin{rid = Rid, srv_id = SrvId, name = Name}) -> {{Rid, SrvId}, Name};
% get_role_info(#rank_darren_casino{rid = Rid, srv_id = SrvId, name = Name, val = Val}) when Val >= 150 -> {{Rid, SrvId}, Name};
% get_role_info(#rank_darren_exp{rid = Rid, srv_id = SrvId, name = Name}) -> {{Rid, SrvId}, Name};
% get_role_info(#rank_cross_flower{rid = Rid, srv_id = SrvId, name = Name}) -> 
%     case role_api:is_local_role(SrvId) of
%         true -> {{Rid, SrvId}, Name};
%         false -> false
%     end;
% get_role_info(#rank_cross_glamor{rid = Rid, srv_id = SrvId, name = Name}) -> 
%     case role_api:is_local_role(SrvId) of
%         true -> {{Rid, SrvId}, Name};
%         false -> false
%     end;
% get_role_info(_) -> false.

%% 获取角色某个榜类型的称号
role_honor(HList, Rid, Type = ?rank_celebrity) -> %% 名人榜特殊处理
    #rank{roles = L} = rank_mgr:lookup(Type),
    get_celebrity_honor(Rid, L, HList);
role_honor(HList, Rid, Type) ->
    #rank{honor_roles = HL} = rank_mgr:lookup(Type),
    HonorL = find_honor(Type, 1, HL, []),
    %% ?DEBUG("~w----------------[~w]", [Rid, HonorL]),
    case lists:keyfind(Rid, 1, HonorL) of
        {Rid, HonorId} -> [{HonorId, <<>>, 0} | HList];
        _ -> HList
    end.
get_celebrity_honor(_Rid, [], L) -> L;
get_celebrity_honor(Rid, [#rank_global_celebrity{id = HonorId, r_list = RList} | T], L) ->
    case lists:keyfind(Rid, #rank_celebrity_role.id, RList) of
        false -> get_celebrity_honor(Rid, T, L);
        _ -> get_celebrity_honor(Rid, T, [{HonorId, <<>>, 0} | L])
    end.

%% 查找出相关名称的称号[RId..] | [{Rid, Sex}...] -----------> [{Rid, Honor}...]
find_honor(_Type, _N, [], L) -> L;
find_honor(Type, N, [{Rid, Sex} | T], L) when Sex =:= 0 orelse Sex =:= 1 -> %% 对区别男/女称号的查找
    case get_honor(Sex, Type, N) of 
        false ->
            find_honor(Type, N + 1, T, L);
        Honor ->
            find_honor(Type, N + 1, T, [{Rid, Honor} | L])
    end;
find_honor(Type, N, [{Rid, Honor} | T], L) when is_tuple(Rid) andalso is_integer(Honor) -> %% 当前已是{角色,称号}数据
    find_honor(Type, N + 1, T, [{Rid, Honor} | L]);
find_honor(Type, N, [I | T], L) ->
    case get_honor(Type, N) of 
        false ->
            find_honor(Type, N + 1, T, L);
        Honor ->
            find_honor(Type, N + 1, T, [{I, Honor} | L])
    end.

%% 获取相关榜相关名次称号数据
get_honor(0, ?rank_glamor_acc, 1) -> 30189;
get_honor(0, ?rank_glamor_acc, 2) -> 30188;
get_honor(0, ?rank_glamor_acc, 3) -> 30187;
get_honor(0, ?rank_glamor_acc, _) -> 30186;
get_honor(1, ?rank_glamor_acc, 1) -> 30185;
get_honor(1, ?rank_glamor_acc, 2) -> 30184;
get_honor(1, ?rank_glamor_acc, 3) -> 30183;
get_honor(1, ?rank_glamor_acc, _) -> 30182;
get_honor(0, ?rank_flower_day, _) -> 20194;
get_honor(1, ?rank_flower_day, _) -> 20195;
get_honor(0, ?rank_glamor_day, _) -> 20192;
get_honor(1, ?rank_glamor_day, _) -> 20193;
get_honor(_Sex, _Type, _Sort) -> false.
get_honor(?rank_role_lev, 1) -> 30169;
get_honor(?rank_role_lev, 2) -> 30168;
get_honor(?rank_role_lev, 3) -> 30167;
get_honor(?rank_role_lev, _) -> 30166;
get_honor(?rank_role_power, 1) -> 30165;
get_honor(?rank_role_power, 2) -> 30164;
get_honor(?rank_role_power, 3) -> 30163;
get_honor(?rank_role_power, _) -> 30162;
get_honor(?rank_role_coin, 1) -> 30173;
get_honor(?rank_role_coin, 2) -> 30172;
get_honor(?rank_role_coin, 3) -> 30171;
get_honor(?rank_role_coin, _) -> 30170;
get_honor(?rank_role_soul, 1) -> 30177;
get_honor(?rank_role_soul, 2) -> 30176;
get_honor(?rank_role_soul, 3) -> 30175;
get_honor(?rank_role_soul, _) -> 30174;
get_honor(?rank_role_skill, 1) -> 30193;
get_honor(?rank_role_skill, 2) -> 30192;
get_honor(?rank_role_skill, 3) -> 30191;
get_honor(?rank_role_skill, _) -> 30190;
get_honor(?rank_role_achieve, 1) -> 30181;
get_honor(?rank_role_achieve, 2) -> 30180;
get_honor(?rank_role_achieve, 3) -> 30179;
get_honor(?rank_role_achieve, _) -> 30178;
get_honor(?rank_role_pet_power, 1) -> 30197;
get_honor(?rank_role_pet_power, 2) -> 30196;
get_honor(?rank_role_pet_power, 3) -> 30195;
get_honor(?rank_role_pet_power, _) -> 30194;
get_honor(?rank_wit_acc, 1) -> 30201;
get_honor(?rank_wit_acc, 2) -> 30200;
get_honor(?rank_wit_acc, 3) -> 30199;
get_honor(?rank_wit_acc, _) -> 30198;
get_honor(?rank_wit_last, 1) -> 20150;
get_honor(?rank_wit_last, 2) -> 20151;
get_honor(?rank_wit_last, 3) -> 20152;
get_honor(?rank_darren_coin, 1) -> 20200;
get_honor(?rank_darren_casino, 1) -> 20201;
get_honor(?rank_darren_exp, 1) -> 20202;
get_honor(?rank_darren_attainment, 1) -> 20203;
get_honor(_Type, _Sort) -> false.
