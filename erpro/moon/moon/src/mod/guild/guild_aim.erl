%----------------------------------------------------
%%  帮会目标
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_aim).
-export([
        update_task/2
        ,get_target/1
        ,unaccomplish_target/1
        ,async_update_target/2
        ,clear_trigger/1    %% 清除军团触发器
%%军团触发器
        ,guild_wish/4
        ,guild_buy/4
        ,guild_chleg/4
        ,guild_gc/4
        ,guild_dungeon/4
        ,guild_kill_pirate/4
        ,guild_tree/4
        ,guild_activity/4
        ,guild_skill/4
        ,guild_multi_dun/4
        ,get_target_award/1
    ]
).

-export([aims_status/1, aims_data/0]).

-include("common.hrl").%%
-include("guild.hrl").
-include("role.hrl").
%%
-include("chat_rpc.hrl").


%% 更新军团目标进度
update_task(_Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}, TargetId) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update_target, [TargetId]}).

async_update_target(Guild = #guild{target_info = Info = #target_info{is_finish = Fin, target_lst = List}}, TargetId) ->
    case Fin =:= 1 of
        true -> ok;     %% 所有已经完成，忽略
        false ->
            case lists:keyfind(TargetId, #target.id, List) of
                false -> ?INFO("帮会没有此目标..."), {ok};
                Target = #target{id = Id, cur_val = Val} ->
                    case Val >= guild_target_data:finish_val(Id) of
                        true ->
                            {ok};
                        false ->
                            Target1 = Target#target{cur_val = CurVal = Val + 1},
                            List1 = lists:keyreplace(TargetId, #target.id, List, Target1),
                            ?DEBUG("成功更新军团目标..... ~p~n", [List1]),
                            case CurVal >= guild_target_data:finish_val(Id) of
                                true ->
                                    Guild1 =
                                    case is_finish(List1)  of
                                        true ->
                                            ?DEBUG(">>>>>>>>>>>>>> 所有军团目标已经完成..."),
                                            Guild#guild{target_info = Info#target_info{is_finish = 1, target_lst = List1}};
                                        false -> 
                                            Guild#guild{target_info = Info#target_info{target_lst = List1}}
                                    end,
                                    {_, _, {exp, Exp}, _} = guild_target_data:get(TargetId),
                                    guild_common:add_exp(Exp, Guild1);  %% TODO:清除军团触发器..
                                false ->
                                    {ok, Guild#guild{target_info = Info#target_info{target_lst = List1}}}
                            end
                    end
            end
    end.

is_finish(TargetList) ->
    Flags = [Id || #target{cur_val=Cur,id = Id} <- TargetList, Cur < guild_target_data:finish_val(Id)],
    case length(Flags) =:= 0 of
        true -> true;
        false -> false
    end.


%% 暂时只处理经验值
get_target_award(#guild{target_info = #target_info{target_lst = TargetLst}}) ->
    F = fun(#target{id = Id, cur_val = CurVal}, Sum) ->
            {_,_, {_Label, Exp}, FinVal} = guild_target_data:get(Id),
            V = case CurVal >= FinVal of true -> FinVal; false -> CurVal end,
            CanAddExp = util:floor((V/FinVal) * Exp),
            Sum + CanAddExp
        end,
    SumExp = lists:foldl(F, 0, TargetLst),
    ?DEBUG(">>>> 可以获取的总军团经验为  ~p", [SumExp]),
    SumExp.

%% @spec aims_status(Role) -> {UnAccomplishList, UnClaimList}
%% Role = #role{}
%% UnAccomplishList = UnClaimList = [integer() | ...]
%% @doc 获取帮会目标完成情况
aims_status(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false -> 
            {[]};
        #guild{target_info = #target_info{target_lst = Lst}} ->
            {[{Id, guild_target_data:finish_val(Id), Val, case Val >= guild_target_data:finish_val(Id) of true ->1; false-> 0 end} || #target{id = Id, cur_val = Val} <- Lst]}
    end.

%% @spec aims_data() -> term()
%% @doc  获取帮会目标数据
aims_data() ->
    ok.

%% [#target{} | ]
unaccomplish_target(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false -> 
            [];
        #guild{target_info = #target_info{target_lst = Lst}} ->
            [Id || #target{id = Id, cur_val = Val} <- Lst, Val < guild_target_data:finish_val(Id)]
    end.

clear_trigger(Role = #role{trigger = Trg}) ->
    Trg1 = role_trigger:clear_guild_trg(Trg),
    Role#role{trigger = Trg1}.


%% 军团许愿事件 Args = []
guild_wish(Role, _TriggerId, _Args, TargetId) ->
    ?DEBUG("-------->>> 军团许愿触发器响应 ~p~n", [TargetId]),
    update_task(Role, TargetId).

%% 军团商城购买事件 Args = []
guild_buy(Role, _TriggerId, _Args, TargetId) ->
    ?DEBUG("-------->>> 军团商城购买触发器响应 ~p~n", [TargetId]),
    update_task(Role, TargetId).

%% 军团猎杀海盗事件 Args = []
guild_kill_pirate(Role, _TriggerId, _Args, TargetId) ->
    ?DEBUG("---------  猎杀海盗事件触发器响应 ~p~n", [TargetId]),
    update_task(Role, TargetId).

%% 军团中庭战神挑战事件 Args = []
guild_chleg(Role, _TriggerId, _Args, TargetId) ->
    ?DEBUG("---------  中庭战神挑战事件触发器响应 ~p~n", [TargetId]),
    update_task(Role, TargetId).

%% 军团攻城伐龙事件 Args = []
guild_gc(Role, _TriggerId, _Args, TargetId) ->
    ?DEBUG("---------  攻城伐龙事件触发器响应 ~p~n", [TargetId]),
    update_task(Role, TargetId).

%% 军团通关普通副本事件 Args = []
guild_dungeon(Role, _TriggerId, _Args, TargetId) ->
    ?DEBUG("---------  普通副本事件触发器响应 ~p~n", [TargetId]),
    update_task(Role, TargetId).

%% 军团参加世界树事件 Args = []
guild_tree(Role, _TriggerId, _Args, TargetId) ->
    ?DEBUG("---------  世界树事件触发器响应 ~p~n", [TargetId]),
    update_task(Role, TargetId).

%% 军团 活跃度事件 Args = []
guild_activity(Role, _TriggerId, _Args, TargetId) ->
    update_task(Role, TargetId).

%% 军团 领用技能事件 Args = []
guild_skill(Role, _TriggerId, _Args, TargetId) ->
    update_task(Role, TargetId).

%% 军团 领用技能事件 Args = []
guild_multi_dun(Role, _TriggerId, _Args, TargetId) ->
    update_task(Role, TargetId).

%%---------------------------------------------------------------------------
%% 私有函数
%%--------------------------------------------------------------------------

%% 根据军团等级获取目标种类数
get_type_num(Lev) -> guild_target_data:get_target_num(Lev).

%% 获取军团目标种类ID
get_type_id(Num) ->
    All = guild_target_data:all_type(),
    Len = length(All),
    case Num >= Len of
        true ->
            ?DEBUG("种类数不足！！！配置有误..."),
            All;
        false ->
            do_get_type_id(All, Num, [])
    end.

%% All = [int,int]
%% do_get_type_id -> [int,int]
do_get_type_id(_All, 0, Res) -> Res;
do_get_type_id(All, Num, Res) ->
    Rand = util:rand(1, length(All)),
    GetedId = lists:nth(Rand, All),
    Res1 = [GetedId | Res],
    All1 = All -- [GetedId],
    do_get_type_id(All1, Num-1, Res1).


%% 获取可接的军团目标
%% Lev -> 军团等级
get_target_id(Lev) ->
    Num = get_type_num(Lev),
    TypeId = get_type_id(Num), %% 符合要求所有目标类型
    %%?DEBUG("所有目标类型 ~p~n", [TypeId]),
    do_get_target(Lev, TypeId, []).


%% 获取可接的军团目标
%% Lev -> 军团等级
get_target(Lev) ->
    case get_target_id(Lev) of
        false ->
            ?ERR("初始化军团目标数据出错, 军团等级为~p",[Lev]), [];
        Ret -> [#target{id = Id, cur_val = 0} || Id <- Ret]
    end.


%% TypeId = [int,int]
%% Target = [int,int]
do_get_target(_Lev, [], Target) -> Target;
do_get_target(Lev, [TypeId | T], Target) ->
    Targets = guild_target_data:type2id(TypeId), %% 此类型所有目标数据 [{target_id,q}]
    LevQ = guild_target_data:get_target_q(Lev), %% 此军团等级对应的品质 [q,q,q,q]
    %%?DEBUG("-->> ~p:~p ", [Targets, LevQ]),
    %% 过滤掉不符合条件的
    CanGet = [{TargetId, guild_target_data:q2rate(TQ)} || {TargetId, TQ} <- Targets, lists:member(TQ, LevQ)],
    %%?DEBUG("..... can get: ~p~n", [CanGet]),
    RandTarget = get_rand_target(CanGet),
    do_get_target(Lev, T, [RandTarget|Target]).

%% Targets = [TargetId, Rate | T]
get_rand_target(Targets) ->
    SumRate = lists:foldl(fun({_, Rate}, Sum)-> Sum+Rate end, 0, Targets),
    Rand = util:rand(1, SumRate),
    get_rand(Rand, Targets).

get_rand(_Rand, []) -> false;
get_rand(Rand, Targets) ->
    do_get_rand(Rand, 0, Targets).

do_get_rand(_Rand, _Range, []) -> false;
do_get_rand(Rand, Range, [{TargetId,Rate}|T]) ->
    case Rand =< Range + Rate of
        true -> TargetId;
        false -> do_get_rand(Rand, Range+Rate, T)
    end.

