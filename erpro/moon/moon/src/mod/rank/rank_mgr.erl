%%----------------------------------------------------
%% 排行榜
%% @author LiuWeihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(rank_mgr).
-behaviour(gen_server).

-export([
        rank_num/1
        ,async/1
        ,lookup/1
        ,update_ets/1
        ,start_link/0
        ,keys/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("rank.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("achievement.hrl").

-record(state, {
        loaded = 0
    }).

%% 查询ets表
%% lookup(Type) -> #rank{}
lookup(Type) ->
    case ets:lookup(sys_rank, Type) of
        [Rank = #rank{}] -> Rank;
        _ -> #rank{type = Type}
    end.

%% 更新ets表
%% update_ets(State) -> ok
update_ets(Rank) when is_record(Rank, rank) ->
    ets:insert(sys_rank, Rank);
update_ets(_Rank) -> ok.

%% 获取各排行榜容量总数
rank_num(_) -> ?in_rank_num.

%% 异步方式 请求
async(Args) ->
    gen_server:cast(?MODULE, Args).

%%----------------------------------------------------
%% 系统函数
%%----------------------------------------------------
%% 启动排行榜进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(sys_rank, [set, named_table, protected, {keypos, #rank.type}]),
    case rank_dao:load() of
        ok ->
            erlang:send_after(600000, self(), save),
            % erlang:send_after(util:unixtime({nexttime, 86399}) * 1000, self(), do_hour_24),
            erlang:send_after(util:unixtime({nexttime, 1800}) * 1000, self(), update),
            % erlang:send_after(util:unixtime({nexttime, 43200}) * 1000, self(), update_honor),
            % erlang:send_after(util:unixtime({nexttime, 71400}) * 1000, self(), clear_flower),
            % erlang:send_after(util:unixtime({nexttime, 82800}) * 1000, self(), dungeon_reward),
            %% erlang:register(?MODULE, self()), %% 注册一个名字，方便查看排行榜信息
            % rank_qixi:startup_qixi(),
            process_flag(trap_exit, true), 
            ?INFO("[~w] 启动完成", [?MODULE]),
            {ok, #state{}};
        _ ->
            ?ERR("排行榜启动失败"),
            {stop, load_failure}
    end.

%%----------------------------------------------------
%% handle_call
%%----------------------------------------------------
handle_call(_Request, _From, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% handle_cast
%%----------------------------------------------------

%% 更新登陆时间信息
handle_cast({login_update, RoleId}, State) ->
    Now = util:unixtime(),
    update_rank_info(RoleId, ?rank_role_lev, #rank_role_lev.date, Now),
    update_rank_info(RoleId, ?rank_role_coin, #rank_role_coin.date, Now),
    update_rank_info(RoleId, ?rank_role_pet, #rank_role_pet.date, Now),
    update_rank_info(RoleId, ?rank_role_achieve, #rank_role_achieve.date, Now),
    update_rank_info(RoleId, ?rank_role_power, #rank_role_power.date, Now),
    update_rank_info(RoleId, ?rank_role_soul, #rank_role_soul.date, Now),
    update_rank_info(RoleId, ?rank_role_skill, #rank_role_skill.date, Now),

    update_rank_info(RoleId, ?rank_arms, #rank_equip_arms.date, Now),
    update_rank_info(RoleId, ?rank_armor, #rank_equip_armor.date, Now),
    update_rank_info(RoleId, ?rank_guild_lev, #rank_guild_lev.date, Now),

    update_rank_info(RoleId, ?rank_vie_acc, #rank_vie_acc.date, Now),
    update_rank_info(RoleId, ?rank_wit_acc, #rank_wit_acc.date, Now),
    update_rank_info(RoleId, ?rank_flower_acc, #rank_flower_acc.date, Now),
    update_rank_info(RoleId, ?rank_glamor_acc, #rank_glamor_acc.date, Now),
    update_rank_info(RoleId, ?rank_vie_kill, #rank_glamor_acc.date, Now),
    update_rank_info(RoleId, ?rank_popu_acc, #rank_popu_acc.date, Now),
    update_rank_info(RoleId, ?rank_total_power, #rank_total_power.date, Now),
    update_rank_info(RoleId, ?rank_mount_power, #rank_mount_power.date, Now),
    update_rank_info(RoleId, ?rank_role_pet_power, #rank_role_pet_power.date, Now),
    {noreply, State}; 

%% 角色变性
handle_cast({update_sex, #role{id = RoleId, sex = Sex}}, State) ->
    update_rank_info(RoleId, ?rank_role_lev, #rank_role_lev.sex, Sex),
    update_rank_info(RoleId, ?rank_role_coin, #rank_role_coin.sex, Sex),
    update_rank_info(RoleId, ?rank_role_pet, #rank_role_pet.sex, Sex),
    update_rank_info(RoleId, ?rank_role_achieve, #rank_role_achieve.sex, Sex),
    update_rank_info(RoleId, ?rank_role_soul, #rank_role_soul.sex, Sex),
    update_rank_info(RoleId, ?rank_role_skill, #rank_role_skill.sex, Sex),

    update_rank_info(RoleId, ?rank_arms, #rank_equip_arms.sex, Sex),
    update_rank_info(RoleId, ?rank_armor, #rank_equip_armor.sex, Sex),

    update_rank_info(RoleId, ?rank_vie_acc, #rank_vie_acc.sex, Sex),
    update_rank_info(RoleId, ?rank_wit_acc, #rank_wit_acc.sex, Sex),
    update_rank_info(RoleId, ?rank_flower_acc, #rank_flower_acc.sex, Sex),
    update_rank_info(RoleId, ?rank_glamor_acc, #rank_glamor_acc.sex, Sex),
    update_rank_info(RoleId, ?rank_vie_kill, #rank_vie_kill.sex, Sex),
    update_rank_info(RoleId, ?rank_popu_acc, #rank_popu_acc.sex, Sex),
    {noreply, State};

%%-----------------------------------------------------------
%% 更新排行榜数据
%%-----------------------------------------------------------

%% 角色帮会更新处理 特殊处理同步玫瑰排行榜
handle_cast({in_guild, #role{id = RoleId, guild = #role_guild{name = GName}}}, State) ->
    update_rank_info(RoleId, ?rank_flower_acc, #rank_flower_acc.guild, GName),
    update_rank_info(RoleId, ?rank_glamor_acc, #rank_glamor_acc.guild, GName),
    {noreply, State};
handle_cast({out_guild, #role{id = RoleId}}, State) ->
    update_rank_info(RoleId, ?rank_flower_acc, #rank_flower_acc.guild, <<>>),
    update_rank_info(RoleId, ?rank_glamor_acc, #rank_glamor_acc.guild, <<>>),
    {noreply, State};

%% 各排行榜下榜入口
%% Type = integer()  下榜类型
%% ID = tuple()      下榜主键组合
handle_cast({exit_rank, Type, Id}, State) ->
    Rank = #rank{roles = RankList} = lookup(Type),
    {Key, _} = keys(Type),
    case lists:keyfind(Id, Key, RankList) of
        false -> %% 没有在榜上
            {noreply, State};
        _ -> %% 在榜上 进行下榜操作
            NewRankList = lists:keydelete(Id, Key, RankList),
            update_ets(Rank#rank{roles = NewRankList, last_val = 0}),
            {noreply, State}
    end;

%% 各排行榜新上榜入口
%% Type = integer() 上榜类型
%% Value = integer() 当前值
%% Data = tuple() 上榜记录
%% I = #rank_data_celebrity{} 名人榜的类型
handle_cast({gm, Type = ?rank_celebrity, I, RList}, State) -> %% 名人榜 特殊处理 记录第一个达到目标的名人
    ?DEBUG("--gm 名人榜- 上榜--"),
    Rank =  #rank{roles = RankList} = lookup(Type),
    Id = I#rank_data_celebrity.id,
    Honor = I#rank_data_celebrity.honor,
    case lists:keyfind(Id, #rank_global_celebrity.id, RankList) of
        false -> %% 之前无人达到条件 是第一个达到目标 可上榜
            ?DEBUG("----之前无人达到条件---gm 名人榜- 上榜--~w~n",[RankList]),
            R = #rank_global_celebrity{id = Id, date = util:unixtime(), r_list = RList},
            NewRankList = [R | RankList],
            rank_celebrity:rewards(I, RList), %% 奖励发放 通过信件方式
            NewRank = Rank#rank{roles = NewRankList},
            update_ets(NewRank),
            rank_log:save_celebrity(R),
            rank_dao:save(NewRank), %% 名人榜即时写数据库
            send_world_message(RList, Honor),
            {noreply, State};
        R = #rank_global_celebrity{r_list = OldRList} -> %% 已经有人在榜上 增加
            ?DEBUG("----已经有人在榜上---gm 名人榜- 上榜--~w~n",[OldRList]),
            NewR = R#rank_global_celebrity{r_list = RList ++ OldRList},
            NewRankList = lists:keyreplace(Id, #rank_global_celebrity.id, RankList, NewR),
            rank_celebrity:rewards(I, RList), %% 奖励发放 奖励大厅
            NewRank = Rank#rank{roles = NewRankList},
            update_ets(NewRank),
            send_world_message(RList, Honor),
            % rank_log:save_celebrity(NewR),
            rank_dao:save(NewRank), %% 名人榜即时写数据库
            {noreply, State}
    end;
handle_cast({in_rank, Type = ?rank_celebrity, I, RList}, State) -> %% 名人榜 特殊处理 记录第一个达到目标的名人
    % ?DEBUG("----------in_rank-----"),
    Rank = #rank{roles = RankList} = lookup(Type),
    % ?DEBUG("----------RankList----:~p~n", [RankList]),
    Id = I#rank_data_celebrity.id,
    ?DEBUG("----------in_rank-Id----:~p~n", [Id]),
    Honor = I#rank_data_celebrity.honor,
    % ?DEBUG("----------in_rank-----"),
    case lists:keyfind(Id, #rank_global_celebrity.id, RankList) of
        false -> %% 之前无人达到条件 是第一个达到目标 可上榜
            R = #rank_global_celebrity{id = Id, date = util:unixtime(), r_list = RList},
            NewRankList = [R | RankList],
            NewRank = Rank#rank{roles = NewRankList},
            rank_celebrity:rewards(I, RList), %% 奖励发放 奖励大厅
            update_ets(NewRank),
            rank_log:save_celebrity(R),
            rank_dao:save(NewRank), %% 名人榜即时写数据库
            ?DEBUG("----------之前无人达到条件-----"),
            send_world_message(RList, Honor),
            {noreply, State};
        _ -> %% 已经有人在榜上 不可上榜
            ?DEBUG("----------已经有人在榜上 不可上榜-----"),
            {noreply, State}
    end;
handle_cast({in_rank, Type, Value, NewData}, State) ->
    Rank = #rank{roles = RankList, last_val = LastValue} = lookup(Type),
    {IdKey, SortKeys} = keys(Type),
    Id = erlang:element(IdKey, NewData),
    Max = rank_num(Type),
    case lists:keyfind(Id, IdKey, RankList) of
        false -> %% 当前角色不在榜上 试上榜
            ?DEBUG("--当前角色不在榜上--\n"),
            ?DEBUG("--当前角色不在榜上-Last Value-:~w~n",[LastValue]),
            case Value >= LastValue orelse Max > length(RankList) of
                false -> %% 条件不满足 无法上榜 直接返回
                    {noreply, State};
                true ->
                    ToSortList = [NewData | lists:reverse(RankList)],
                    {NewRankList, NewLastValue} = update_rank(Max, SortKeys, ToSortList),
                    NewRank = Rank#rank{roles = NewRankList, last_val = NewLastValue},
                    update_ets(NewRank),
                    {noreply, State}
            end;
        _OldData -> %% 当前在榜上 数据有变化 更新榜上数据
            % ?DEBUG("--当前在榜上--\n"),
            NRandList = lists:keyreplace(Id, IdKey, RankList, NewData), %% 把榜上数据替换成最新数据
            ToSortList = lists:reverse(NRandList), %% 为确保数值一致情况下先上榜排行在前
            {NewRankList, NewLastValue} = update_rank(Max, SortKeys, ToSortList),
            NewRank = Rank#rank{roles = NewRankList, last_val = NewLastValue},
            update_ets(NewRank),
            {noreply, State}
    end;

%% 修正排行榜
handle_cast(revert, State) ->
    RankList = ets:tab2list(sys_rank),
    do_revert(RankList),
    {noreply, State};

%% 修改指定榜排序
handle_cast({reverse, Type}, State) ->
    Rank = #rank{roles = RankList} = lookup(Type),
    NewRankList = lists:reverse(RankList),
    update_ets(Rank#rank{roles = NewRankList}),
    {noreply, State};

%% 清空指定榜数据
handle_cast({clear, TypeList}, State) when is_list(TypeList) ->
    [update_ets(#rank{type = Type}) || Type <- TypeList],
    {noreply, State};
handle_cast({clear, Type}, State) ->
    update_ets(#rank{type = Type}),
    {noreply, State};

%% 清空所有排行榜
handle_cast(clear_all, State) ->
    L = ets:tab2list(sys_rank),
    [update_ets(#rank{type = Type}) || #rank{type = Type} <- L, Type =/= ?rank_celebrity],
    {noreply, State};

%% 移除名人榜指定类型的上榜数据
handle_cast({remove, Id}, State) ->
    Rank = #rank{roles = RankList} = lookup(?rank_celebrity),
    NewRankList = lists:keydelete(Id, #rank_global_celebrity.id, RankList),
    update_ets(Rank#rank{roles = NewRankList}),
    {noreply, State};

%% 移除名人榜上非本服角色数据
handle_cast({remove_not_local, Id}, State) ->
    ?INFO("开始删除名人榜数据[~p]", [Id]),
    Rank = #rank{roles = RankList} = lookup(?rank_celebrity),
    case lists:keyfind(Id, #rank_global_celebrity.id, RankList) of
        false ->
            ?DEBUG("此名人榜没人上榜[~p]", [Id]),
            ok;
        Cel = #rank_global_celebrity{r_list = Roles} ->
            ?DEBUG("名人榜[~p]角色数据量[~p]", [Id, length(Roles)]),
            case remove_not_local(Roles, Id, []) of
                [] -> %% 全部非本服
                    NewRankList = lists:keydelete(Id, #rank_global_celebrity.id, RankList),
                    update_ets(Rank#rank{roles = NewRankList});
                NewRoles ->
                    NewCel = Cel#rank_global_celebrity{r_list = NewRoles},
                    NewRankList = lists:keyreplace(Id, #rank_global_celebrity.id, RankList, NewCel),
                    update_ets(Rank#rank{roles = NewRankList})
            end
    end,
    ?INFO("删除名人榜数据完成"),
    {noreply, State};

%% 移除名人榜上指定时间段内指定类型上榜的数据
handle_cast({remove_time_types, Types, StartTime, EndTime}, State) ->
    ?INFO("开始删除名人榜数据[~w]", [Types]),
    Rank = #rank{roles = RankList} = lookup(?rank_celebrity),
    NewRankList = remove_time_types(RankList, [], Types, StartTime, EndTime),
    update_ets(Rank#rank{roles = NewRankList}),
    ?INFO("删除名人榜数据完成[~p -> ~p]", [length(RankList), length(NewRankList)]),
    {noreply, State};

%% 排行榜更新
handle_cast(update, State) ->
    do_update(),
    % update_honor(),
    % update_darren_honor(),
    {noreply, State};

handle_cast(set_time, State) ->
    erlang:send_after(util:unixtime({nexttime, 82800}) * 1000, self(), dungeon_reward),
    {noreply, State};

%% 称号更新
handle_cast({update_honor, Type}, State) ->
    do_update_honor(Type),
    {noreply, State};

handle_cast({reward, 0}, State) ->
    rank_reward:reward(camp_darren),
    rank_reward:reward(camp_flower),
    {noreply, State};
handle_cast({reward, 10000}, State) ->
    rank_reward:reward(cross_flower),
    {noreply, State};
handle_cast({reward, Type}, State) ->
    ?INFO("开始发放排行榜奖励"),
    rank_reward:reward(Type),
    ?INFO("发放排行榜奖励完成"),
    {noreply, State};

%% 中央服收集排行榜数据
handle_cast({collect_rank_data, Sn, CrossType, LocalType}, State) ->
    ?DEBUG("收到中央服收集排行榜数据的消息[~p, ~p]", [CrossType, LocalType]),
    Data = rank:list(LocalType),
    case rank_cross_cond:do(CrossType, Data, []) of
        [] -> ok;
        NewData ->
            CompressedData = term_to_binary([CrossType, LocalType, NewData], [compressed]),
            center:cast(c_rank_mgr, commit_rank_data, [Sn, CompressedData])
    end,
    {noreply, State};

handle_cast({update_cross_rank_data, CompressedData}, State) ->
    case catch binary_to_term(CompressedData) of
        [Type, Data] ->
            ?DEBUG("收到中央服整理好的排行榜[~p]数据:~p", [Type, length(Data)]),
            Rank = lookup(Type),
            NewRank = Rank#rank{roles = Data},
            update_ets(NewRank);
        _ ->
            ?ERR("收到中央服整理好的排行榜数据无法正常解压")
    end,
    {noreply, State};

%% 更新仙道会排行榜数据
handle_cast({update_world_compete_rank_data, Type, Data}, State) ->
    Rank = lookup(Type),
    NewRank = Rank#rank{roles = Data},
    update_ets(NewRank),
    {noreply, State};

%% 替换一个榜的数据
handle_cast({replace, Type, Data}, State) ->
    Rank = lookup(Type),
    NewRank = Rank#rank{roles = Data},
    update_ets(NewRank),
    {noreply, State};

handle_cast(open_srv, State) ->
    % check_reward(open_srv),
    {noreply, State};
handle_cast(merge_srv, State) ->
    % check_reward(merge_srv),
    {noreply, State};

%% 更新称号
handle_cast({cross_flower, Type, AwardFlowerData, AwardGlamorData}, State) -> 
    FirstFlower = [{Rid, SrvId, Name, Rank} || {Rid, SrvId, Name, Rank} <- AwardFlowerData, Rank =:= 1], 
    FirstGlamor = [{Rid, SrvId, Name, Rank} || {Rid, SrvId, Name, Rank} <- AwardGlamorData, Rank =:= 1], 
    cast_notice(Type, FirstFlower, FirstGlamor),
    FlowerRoleList = get_local_role(AwardFlowerData),
    GlamorRoleList = get_local_role(AwardGlamorData),
    case FlowerRoleList of
        [] -> skip;
        FlowerRoleList ->
            case center:call(c_rank_mgr, apply, [sync, {get_flower_award, FlowerRoleList}]) of
                ok ->
                    send_flower_mail(1, FlowerRoleList),
                    add_flower_honor(1, FlowerRoleList);
                _ ->
                    ?ERR("无法请求中央服发送跨服送花排行榜的回应")
            end
    end,
    case GlamorRoleList of
        [] -> skip;
        GlamorRoleList ->
            case center:call(c_rank_mgr, apply, [sync, {get_glamor_award, GlamorRoleList}]) of
                ok ->
                    send_flower_mail(2, GlamorRoleList),
                    add_flower_honor(2, GlamorRoleList);
                _ ->
                    ?ERR("无法请求中央服发送跨服送花排行榜的回应")
            end
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% handle_info
%%----------------------------------------------------

%% 定时保存数据
handle_info(save, State) ->
    erlang:send_after(300000, self(), save),
    spawn(
        fun() ->
                rank_dao:save()
        end
    ),
    {noreply, State};

%% 每天午夜12点，会收到rid_update消息，更新排行榜数据，去除7天没有登陆的玩家
handle_info(do_hour_24, State) ->
    % rank_log:save_darren(),
    % check_reward(open_srv),
    % update_darren_honor(),
    % erlang:send_after(util:unixtime({nexttime, 86399}) * 1000, self(), do_hour_24),
    {noreply, State};

%% 除了更新数据外，还需要更新最后的排名的值
handle_info(update, State) ->
    do_update(),
    erlang:send_after(util:unixtime({nexttime, 1800}) * 1000, self(), update),
    {noreply, State};

%% 每天中午12点更新相关榜称号
handle_info(update_honor, State) ->
    update_honor(),
    check_reward(merge_srv),
    erlang:send_after(util:unixtime({nexttime, 43200}) * 1000, self(), update_honor),
    {noreply, State};

%% 每天下午7点50更新本服送花榜
handle_info(clear_flower, State) ->
    rank_qixi:reward(),
    rank_reward:reward(cross_flower),
    rank_reward:reward(camp_flower),
    rank_log:save([?rank_cross_flower, ?rank_cross_glamor]),
    update_ets(#rank{type = ?rank_flower_day}),
    update_ets(#rank{type = ?rank_glamor_day}),
    update_ets(#rank{type = ?rank_cross_flower}),
    update_ets(#rank{type = ?rank_cross_glamor}),
    erlang:send_after(util:unixtime({nexttime, 71400}) * 1000, self(), clear_flower),
    {noreply, State};

%% 七夕送花活动
handle_info(qixi_flower, State) ->
    Rank1 = lookup(?rank_flower_day),
    Rank2 = lookup(?rank_glamor_day),
    rank_qixi:handle_qixi(Rank1, ?rank_flower_day),
    rank_qixi:handle_qixi(Rank2, ?rank_glamor_day),
    rank_qixi:startup_qixi(),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% 系统关闭
%%----------------------------------------------------
terminate(_Reason, _State) ->
    rank_dao:save(),
    ok.

%%----------------------------------------------------
%% 热代码切换
%%----------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 私有函数。
%%----------------------------------------------------

%% 移除在指定时间段内指定类型上榜
remove_time_types([], RankL, _Types, _StartTime, _EndTime) ->
    lists:reverse(RankL);
remove_time_types([Rank = #rank_global_celebrity{id = Id, date = Date} | T], RankL, Types, StartTime, EndTime) ->
    case lists:member(Id, Types) orelse Types =:= [all] of
        true when Date >= StartTime andalso Date < EndTime -> %% 需要处理
            ?INFO("踢除名人榜:~p ", [Id]),
            rank_dao:delete_celebrity(Id),
            remove_time_types(T, RankL, Types, StartTime, EndTime);
        _ ->
            remove_time_types(T, [Rank | RankL], Types, StartTime, EndTime)
    end.

%% 移除名人榜上非本服角色数据
remove_not_local([], _Id, Roles) -> lists:reverse(Roles);
remove_not_local([Role = #rank_celebrity_role{rid = Rid, srv_id = SrvId, name = Name} | T], Id, Roles) ->
    case role_api:is_local_role(SrvId) of
        true -> remove_not_local(T, Id, [Role | Roles]);
        false ->
            ?INFO("删除角色名人榜数据[~p, ~p, ~s, ~s]", [Id, Rid, SrvId, Name]),
            rank_dao:delete_celebrity(Rid, SrvId, Id),
            remove_not_local(T, Id, Roles)
    end.

add_flower_honor(1, FlowerRoleList) ->
    Now = util:unixtime(),
    H20191 = [{{Rid, SrvId}, 20191}  || {Rid, SrvId, _Name, Rank} <- FlowerRoleList, Rank =:= 1],
    honor_mgr:replace_honor_gainer(cross_flower_award, H20191, Now + 86400);
add_flower_honor(2, GlamorRoleList) ->
    Now = util:unixtime(),
    H20190 = [{{Rid, SrvId}, 20190}  || {Rid, SrvId, _Name, Rank} <- GlamorRoleList, Rank =:= 1],
    honor_mgr:replace_honor_gainer(cross_glamor_award, H20190, Now + 86400).

%% 发送奖励邮件
send_flower_mail(_, []) -> skip;
send_flower_mail(1, FlowerRoleList) ->
    do_send_flower_mail(1, FlowerRoleList);
send_flower_mail(2, GlamorRoleList) ->
    do_send_flower_mail(2, GlamorRoleList).

do_send_flower_mail(_, []) -> ok;
do_send_flower_mail(1, [{Rid, SrvId, Name, Rank} | T]) ->
    Subject = ?L(<<"飞仙情圣排名奖励">>),
    Content = util:fbin(?L(<<"恭喜您荣登跨服飞仙情圣榜第~w名，获得魅力礼包1个">>), [Rank]),
    Items = case Rank of
        1 -> [{29234, 1, 1}];
        _ -> [{29233, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items}),
    do_send_flower_mail(1, T);
do_send_flower_mail(2, [{Rid, SrvId, Name, Rank} | T]) ->
    Subject = ?L(<<"鲜花宝贝排名奖励">>),
    Content = util:fbin(?L(<<"恭喜您荣登跨服鲜花宝贝榜第~w名，获得魅力礼包1个">>), [Rank]),
    Items = case Rank of
        1 -> [{29234, 1, 1}];
        _ -> [{29233, 1, 1}]
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {Subject, Content, [], Items}),
    do_send_flower_mail(2, T).

%% 公告
cast_notice(_, [], []) -> skip;
cast_notice(0, _, _) -> skip;
cast_notice(1, FirstFlower, FirstGlamor) ->
    Msg1 = notice:item_to_msg({29234, 1, 1}),
    case FirstFlower of
        [{Rid1, SrvId1, Name1, 1}] ->
            RoleMsg1 = notice:role_to_msg({Rid1, SrvId1, Name1}),
            notice:send(54, util:fbin(?L(<<"~s洒脱无双，赠送鲜花无数，成为飞仙全时空的大众情圣，获得全世界独一无二的称号：飞仙情圣及~s">>), [RoleMsg1, Msg1]));
        _ -> skip
    end,
    case FirstGlamor of
        [{Rid2, SrvId2, Name2, 1}] ->
            RoleMsg2 = notice:role_to_msg({Rid2, SrvId2, Name2}),
            notice:send(54, util:fbin(?L(<<"~s魅力无限，获赠鲜花无数，成为飞仙全时空的人气宝贝，获得全世界独一无二的称号：鲜花宝贝及~s">>),[RoleMsg2, Msg1]));
        _ -> skip
    end.

%% 获取本服角色列表
get_local_role(RoleList) ->
    get_local_role(RoleList, []).
get_local_role([], RoleList) -> RoleList;
get_local_role([{Rid, SrvId, Name, Rank} | T], RoleList) ->
    case role_api:is_local_role(SrvId) of
        true -> get_local_role(T, [{Rid, SrvId, Name, Rank} | RoleList]);
        false -> get_local_role(T, RoleList)
    end.

%% 检验是否需发放相关奖励
check_reward(open_srv) ->
    case sys_env:get(srv_open_time) of
        OpenTime when is_integer(OpenTime) ->
            Now = util:unixtime(),
            Check_Time = Now - OpenTime,
            case sys_env:get(rank_reward_flag_3) of
                Flag3 when Flag3 =/= 1 andalso Check_Time > 2 * 86400 andalso Check_Time < 3 * 86400 -> %% 3天后0点发奖励
                    ?INFO("开始发放3天排行榜奖励"),
                    rank_reward:reward(?rank_reward_open_srv_3),
                    sys_env:save(rank_reward_flag_3, 1),
                    ?INFO("发放3天排行榜奖励完成");
                _ ->
                    ok
            end,
            case sys_env:get(rank_reward_flag_5) of
                Flag5 when Flag5 =/= 1 andalso Check_Time > 4 * 86400 andalso Check_Time < 5 * 86400 -> %% 5天后0点发奖励
                    ?INFO("开始发放5天排行榜奖励"),
                    rank_reward:reward(?rank_reward_open_srv_5),
                    sys_env:save(rank_reward_flag_5, 1),
                    ?INFO("发放5天排行榜奖励完成");
                _ ->
                    ok
            end;
        _M ->
            ?ERR("取开服时间失败:~w", [_M]),
            ok
    end;
check_reward(merge_srv) ->
    case sys_env:get(merge_time) of
        MergeTime when is_integer(MergeTime) ->
            Now = util:unixtime(), 
            Check_Time = Now - util:unixtime({today, MergeTime}),
            case sys_env:get(rank_reward_merge_srv) of
                Flag when Flag =/= 1 andalso Check_Time >= 7 * 86400 andalso Check_Time < 8 * 86400 -> %% 7天后12点发奖励
                     ?INFO("开始发放排行榜合服奖励"),
                     rank_reward:reward(?rank_reward_merge_srv),
                     sys_env:save(rank_reward_merge_srv, 1),
                     ?INFO("发放排行榜合服奖励完成");
                _ ->
                    ok
            end;
        _M ->
            ?ERR("取合服时间失败:~w", [_M]),
            ok
    end;
check_reward(_) -> ok.

%% 更新排行榜称号
update_honor() ->
    ?INFO("[~w] 开始更新排行榜称号获得者", [?MODULE]),
    do_update_honor(?rank_role_lev),
    do_update_honor(?rank_role_coin),
    do_update_honor(?rank_role_power),
    do_update_honor(?rank_role_soul),
    do_update_honor(?rank_role_skill),
    do_update_honor(?rank_role_achieve),
    do_update_honor(?rank_role_pet_power),
    do_update_honor(?rank_wit_acc),
    do_update_honor(?rank_glamor_acc),
    ?INFO("[~w] 完成更新排行榜称号获得者", [?MODULE]),
    ok.
do_update_honor(Type = ?rank_glamor_acc) -> %% 魅力排行榜 区分男女
    Rank = #rank{honor_roles = OldHonorL, roles = RankL} = lookup(Type),
    L10 = lists:sublist(RankL, 10),
    IdL10 = [{Rid, Sex} || #rank_glamor_acc{id = Rid, sex = Sex} <- L10],
    NewHonorL = rank_reward:update_honor(Type, OldHonorL, IdL10),
    update_ets(Rank#rank{honor_roles = NewHonorL});
do_update_honor(Type) ->
    Rank = #rank{honor_roles = OldHonorL, roles = RankL} = lookup(Type),
    {IdPos, _} = keys(Type),
    L10 = lists:sublist(RankL, 10),
    IdL10 = [element(IdPos, H) || H <- L10],
    NewHonorL = rank_reward:update_honor(Type, OldHonorL, IdL10),
    update_ets(Rank#rank{honor_roles = NewHonorL}).

%% 更新达人榜称号数据
% update_darren_honor() ->
%     ?INFO("开始更新达人榜称号数据..."),
%     rank_reward:reward(camp_darren),
%     {L1, _List1} = case rank:list(?rank_darren_coin) of
%         [#rank_darren_coin{id = Rid1} = I1 | _] -> {[{?rank_darren_coin, Rid1}], [I1]};
%         _ -> {[], []}
%     end,
%     {L2, _List2} = case rank:list(?rank_darren_exp) of
%         [#rank_darren_exp{id = Rid2} = I2 | _] -> {[{?rank_darren_exp, Rid2}], [I2]};
%         _ -> {[], []}
%     end,
%     {L3, _List3} = case rank:list(?rank_darren_casino) of
%         [#rank_darren_casino{id = Rid3} = I3 | _] -> {[{?rank_darren_casino, Rid3}], [I3]};
%         _ -> {[], []}
%     end,
%     {L4, _List4} = case rank:list(?rank_darren_attainment) of
%         [#rank_darren_attainment{id = Rid4} = I4 | _] -> {[{?rank_darren_attainment, Rid4}], [I4]};
%         _ -> {[], []}
%     end,
%     L = L1 ++ L2 ++ L3 ++ L4,
%     catch npc_mgr:update_rank_npc(L),
%     do_update_darren_honor(?rank_darren_coin),
%     do_update_darren_honor(?rank_darren_casino),
%     do_update_darren_honor(?rank_darren_exp),
%     do_update_darren_honor(?rank_darren_attainment),
%     ?INFO("更新达人榜称号数据结束..."),
%     ok.
% do_update_darren_honor(Type) ->
%     Rank = #rank{honor_roles = OldHonorL, roles = RankL} = lookup(Type),
%     {IdPos, _} = keys(Type),
%     L10 = lists:sublist(RankL, 1),
%     IdL10 = [element(IdPos, H) || H <- L10],
%     NewHonorL = rank_reward:update_honor(Type, OldHonorL, IdL10),
%     update_ets(Rank#rank{honor_roles = NewHonorL, roles = []}).

%% 更新排行榜
do_update() ->
    ?INFO("[~w] 开始更新排行榜数据", [?MODULE]),
    rank_log:save(), %% 排行榜快照 保存到数据库供后台查看使用
    rid_week_nologin(?rank_role_lev, #rank_role_lev.date),
    % rid_week_nologin(?rank_role_coin, #rank_role_coin.date),
    rid_week_nologin(?rank_role_pet, #rank_role_pet.date),
    % rid_week_nologin(?rank_role_achieve, #rank_role_achieve.date),
    % rid_week_nologin(?rank_role_soul, #rank_role_soul.date),
    rid_week_nologin(?rank_role_skill, #rank_role_skill.date),
    rid_week_nologin(?rank_role_power, #rank_role_power.date),
    rid_week_nologin(?rank_role_pet_power, #rank_role_pet_power.date),

    rid_week_nologin(?rank_arms, #rank_equip_arms.date),
    rid_week_nologin(?rank_armor, #rank_equip_armor.date),
    %% rid_week_nologin(?rank_guild_lev, #rank_guild_lev.date),
    %% rid_week_nologin(?rank_guild_combat, #rank_guild_combat.date),
    %% rid_week_nologin(?rank_guild_last, #rank_guild_last.date),
    %% rid_week_nologin(?rank_guild_exploits, #rank_guild_exploits.date),

    % rid_week_nologin(?rank_vie_acc, #rank_vie_acc.date),
    % rid_week_nologin(?rank_vie_kill, #rank_vie_last.date),
    %% rid_week_nologin(?rank_vie_cross, #rank_vie_cross.date),

    % rid_week_nologin(?rank_wit_acc, #rank_wit_acc.date),
    %% rid_week_nologin(?rank_wit_last, #rank_wit_last.date),

    % rid_week_nologin(?rank_flower_acc, #rank_flower_acc.date),
    % rid_week_nologin(?rank_glamor_acc, #rank_glamor_acc.date),
    %% rid_week_nologin(?rank_popu_acc, #rank_popu_acc.date),

    % rid_week_nologin(?rank_total_power, #rank_total_power.date),
    % rid_week_nologin(?rank_mount_power, #rank_mount_power.date),

    ?INFO("[~w] 更新排行榜数据完成", [?MODULE]),
    ok.

%%----------------------------------------------------
%% @spec update_date(RoleId, IdPos, DatePos, RankedData) -> {NewRankedData}
%% @type RoleId::integer() 玩家角色ID
%% @type IdPos::integer()  玩家角色ID在记录中位置
%% @type DatePos::integer() 记录中date字段的位置
%% @type RankedData = [Tuple] 某项排行榜数据
%%----------------------------------------------------
update_rank_info(RoleId, Type = ?rank_celebrity, DataPos, Data) -> %% 名人榜特殊数据结构 特殊处理
    Rank = #rank{roles = RankList} = lookup(Type),
    NewRankList = update_celebrity_rank_info(RoleId, RankList, DataPos, Data, []),
    update_ets(Rank#rank{roles = NewRankList});
update_rank_info(RoleId, Type, DataPos, Data) ->
    Rank = #rank{roles = RankList} = lookup(Type),
    {IdPos, _} = keys(Type),
    case lists:keyfind(RoleId, IdPos, RankList) of
        false ->
            false;
        RoleData ->
            NewRoleData = erlang:setelement(DataPos, RoleData, Data),
            NewRankList = lists:keyreplace(RoleId, IdPos, RankList, NewRoleData),
            update_ets(Rank#rank{roles = NewRankList})
    end.
update_celebrity_rank_info(_RoleId, [], _DataPos, _Data, RankList) -> RankList;
update_celebrity_rank_info(RoleId, [I = #rank_global_celebrity{r_list = RList} | T], DataPos, Data, RankList) ->
    case lists:keyfind(RoleId, #rank_celebrity_role.id, RList) of
        false -> %% 角色不存在
            update_celebrity_rank_info(RoleId, T, DataPos, Data, [I | RankList]);
        RoleData ->
            NewRoleData = erlang:setelement(DataPos, RoleData, Data),
            NewRList = lists:keyreplace(RoleId, #rank_celebrity_role.id, RList, NewRoleData),
            NewI = I#rank_global_celebrity{r_list = NewRList},
            update_celebrity_rank_info(RoleId, T, DataPos, Data, [NewI | RankList])
    end.

%%----------------------------------------------------
%% @spec update_rank(Type, SortKeys, ToSortList, Max) -> {NewRankedData, NewLastValue}
%% @dos 
%%      Max = integer()      排行榜最大排序数据量
%%      SortKeys = list()    排序键值
%%      ToSortList = list()  准备进行排序列表
%%      NewLastValue = integer()  最后一名键值
%% @desc 更新排行榜上数据
%%----------------------------------------------------
update_rank(Max, SortKeys, ToSortList) ->
    SortList = keys_sort(SortKeys, ToSortList), %% 倒序让条件相同情况下 先上榜在前
    if
        length(SortList) < Max -> %% 排行榜未满，直接上榜
            {lists:reverse(SortList), 0};
        length(SortList) =:= Max -> %% 排行榜刚刚满数
            [LastPlayer | _] = SortList,
            [FirstBasis | _] = lists:reverse(SortKeys),
            {lists:reverse(SortList), element(FirstBasis,LastPlayer)};
        true -> %% 排行榜超出指定长度，需去除最后一名
            [_N | AscendRankedData] = SortList,
            [LastPlayer | _] = AscendRankedData,
            [FirstBasis | _] = lists:reverse(SortKeys),
            {lists:reverse(AscendRankedData), element(FirstBasis,LastPlayer)}
    end.

%%-----------------------------------------
%% @spec keys_sort(BasisPos,TupleList) -> TupleList1
%% @type BasisPos :: [KeyPos]
%% @type KeyPos :: integer()
%% @type TupleList :: [Tuple]
%% @type Tuple :: tuple()
%% @desc 依据列表[keyPos]中依次对TupleList中相应位置的键值进行排序
%%-----------------------------------------
%% 备注 现排序采用循环排序键组合排序 如果有三个键就排序三次，N个键就会排序N次
%% 不知道效率如何 先观察 如果效率不行可换成一次快速排序方式
keys_sort([],TupleList) ->
    TupleList;

keys_sort([H|T], TupleList) ->
    NewTupleList = lists:keysort(H, TupleList),
    keys_sort(T,NewTupleList).

%% 修正排行榜排行
do_revert([]) -> ok;
do_revert([#rank{type = ?rank_celebrity} | T]) ->
    do_revert(T);
do_revert([Rank = #rank{type = Type, roles = RankList} | T]) ->
    case keys(Type) of
        {false, _} -> do_revert(T);
        {_Id, SortKeys} ->
            SortList = keys_sort(SortKeys, RankList),
            NewRankList = lists:reverse(SortList),
            update_ets(Rank#rank{roles = NewRankList}),
            do_revert(T);
        _ -> do_revert(T)
    end;
do_revert(_) -> ok.

%%-----------------------------------------
%% @spec rid_week_nologin(Type, State, DatePos) -> {NewRankedData,NewLastValue}
%% @type ...
%% @desc 去除排行榜中7天没有登陆的玩家
%%-----------------------------------------
rid_week_nologin(Type, DatePos) ->
    Rank = #rank{roles = RankList} = lookup(Type),
    case rid_7_nologin(RankList, [], DatePos, false) of
        {true, NewRankList} -> %% 有删除到数据 
            update_ets(Rank#rank{roles = lists:reverse(NewRankList)});
        {false, _List} -> %% 没有删除到数据
            ok
    end.

% 去除7天没登陆的玩家
rid_7_nologin([], NewList, _Type, Del) ->
    {Del, NewList};
rid_7_nologin([H | T], NewList, DatePos, Del) ->
    Interval = (util:unixtime() - element(DatePos, H)),
    case Interval < ?RANK_NOLOGIN_TIME of
        true -> % 没超过7天
            rid_7_nologin(T, [H | NewList], DatePos, Del);
        _ -> % 超过7天
            %% ?DEBUG("~w 超过7天没有登陆，已被删除",[H]),
            rid_7_nologin(T, NewList, DatePos, true)
    end.

%% 获取各类型排序的键值
%% @spec keys(Type) -> {Key, SortKeys}
%% Key = integer()    记录主键字段
%% SortKeys = list()  排序字段组合 后者优先原则
keys(?rank_role_lev) -> {#rank_role_lev.id, [#rank_role_lev.lev]};
keys(?rank_role_coin) -> {#rank_role_coin.id, [#rank_role_coin.vip, #rank_role_coin.gold, #rank_role_coin.coin]};
keys(?rank_role_pet) -> {#rank_role_pet.id, [#rank_role_pet.growrate, #rank_role_pet.aptitude, #rank_role_pet.petlev]};
keys(?rank_role_pet_power) -> {#rank_role_pet_power.id, [#rank_role_pet_power.power]};
keys(?rank_pet_grow) -> {#rank_pet_grow.id, [#rank_pet_grow.petlev, #rank_pet_grow.grow]};
keys(?rank_pet_potential) -> {#rank_pet_potential.id, [#rank_pet_potential.petlev, #rank_pet_potential.potential]};
keys(?rank_role_achieve) -> {#rank_role_achieve.id, [#rank_role_achieve.vip, #rank_role_achieve.lev, #rank_role_achieve.achieve]};
keys(?rank_role_power) -> {#rank_role_power.id, [#rank_role_power.power]};
keys(?rank_role_soul) -> {#rank_role_soul.id, [#rank_role_soul.vip, #rank_role_soul.lev, #rank_role_soul.soul]};
keys(?rank_role_skill) -> {#rank_role_skill.id, [#rank_role_skill.vip, #rank_role_skill.lev, #rank_role_skill.skill]};
keys(?rank_arms) -> {#rank_equip_arms.id, [#rank_equip_arms.score]};
keys(?rank_armor) -> {#rank_equip_armor.id, [#rank_equip_armor.score]};
keys(?rank_guild_lev) -> {#rank_guild_lev.id, [#rank_guild_lev.num, #rank_guild_lev.fund, #rank_guild_lev.lev]};
keys(?rank_guild_power) -> {#rank_guild_power.id, [#rank_guild_power.lev, #rank_guild_power.power]};

keys(?rank_guild_combat) -> {#rank_guild_combat.id, [#rank_guild_combat.lev, #rank_guild_combat.score, #rank_guild_combat.accScore]};
keys(?rank_guild_last) -> {#rank_guild_last.id, [#rank_guild_last.num, #rank_guild_last.lev, #rank_guild_last.score]};
keys(?rank_guild_exploits) -> {#rank_guild_exploits.id, [#rank_guild_exploits.vip, #rank_guild_exploits.lev, #rank_guild_exploits.score]};
keys(?rank_vie_acc) -> {#rank_vie_acc.id, [#rank_vie_acc.vip, #rank_vie_acc.lev, #rank_vie_acc.score]};
keys(?rank_vie_last) -> {#rank_vie_last.id, [#rank_vie_last.vip, #rank_vie_last.lev, #rank_vie_last.score]};
keys(?rank_vie_kill) -> {#rank_vie_kill.id, [#rank_vie_kill.vip, #rank_vie_kill.lev, #rank_vie_kill.kill]};
keys(?rank_vie_last_kill) -> {#rank_vie_last_kill.id, [#rank_vie_last_kill.vip, #rank_vie_last_kill.lev, #rank_vie_last_kill.kill]};
keys(?rank_vie_cross) -> {#rank_vie_cross.id, [#rank_vie_cross.vip, #rank_vie_cross.lev, #rank_vie_cross.win]};
keys(?rank_wit_acc) -> {#rank_wit_acc.id, [#rank_wit_acc.vip, #rank_wit_acc.lev, #rank_wit_acc.score]};
keys(?rank_wit_last) -> {#rank_wit_last.id, [#rank_wit_last.vip, #rank_wit_last.lev, #rank_wit_last.score]};
keys(?rank_flower_acc) -> {#rank_flower_acc.id, [#rank_flower_acc.vip, #rank_flower_acc.lev, #rank_flower_acc.flower]};
keys(?rank_glamor_acc) -> {#rank_glamor_acc.id, [#rank_glamor_acc.vip, #rank_glamor_acc.lev, #rank_glamor_acc.glamor]};
keys(?rank_flower_day) -> {#rank_flower_day.id, [#rank_flower_day.vip, #rank_flower_day.lev, #rank_flower_day.flower]};
keys(?rank_glamor_day) -> {#rank_glamor_day.id, [#rank_glamor_day.vip, #rank_glamor_day.lev, #rank_glamor_day.glamor]};
keys(?rank_popu_acc) -> {#rank_popu_acc.id, [#rank_popu_acc.vip, #rank_popu_acc.lev, #rank_popu_acc.popu]};
keys(?rank_darren_coin) -> {#rank_darren_coin.id, [#rank_darren_coin.val]};
keys(?rank_darren_casino) -> {#rank_darren_casino.id, [#rank_darren_casino.val]};
keys(?rank_darren_exp) -> {#rank_darren_exp.id, [#rank_darren_exp.val]};
keys(?rank_darren_attainment) -> {#rank_darren_attainment.id, [#rank_darren_attainment.val]};
keys(?rank_mount_power) -> {#rank_mount_power.id, [#rank_mount_power.power]};
keys(?rank_mount_lev) -> {#rank_mount_lev.id, [#rank_mount_lev.mount_lev]};
keys(?rank_total_power) -> {#rank_total_power.id, [#rank_total_power.total_power]};
keys(?rank_cross_world_compete_winrate) -> {#rank_world_compete.id, [#rank_world_compete.win_rate]};
keys(?rank_platform_world_compete_winrate) -> {#rank_world_compete.id, [#rank_world_compete.win_rate]};
keys(?rank_world_compete_winrate) -> {#rank_world_compete.id, [#rank_world_compete.win_rate]};
keys(?rank_cross_world_compete_lilian) -> {#rank_world_compete.id, [#rank_world_compete.lilian]};
keys(?rank_platform_world_compete_lilian) -> {#rank_world_compete.id, [#rank_world_compete.lilian]};
keys(?rank_world_compete_lilian) -> {#rank_world_compete.id, [#rank_world_compete.lilian]};
keys(?rank_world_compete_win) -> {#rank_world_compete_win.id, [#rank_world_compete_win.win_count]};
keys(?rank_world_compete_section) -> {#rank_world_compete.section_mark, [#rank_world_compete.section_mark]};
keys(?rank_platform_world_compete_section) -> {#rank_world_compete.section_mark, [#rank_world_compete.section_mark]};
keys(?rank_practice) -> {#rank_practice.id, [#rank_practice.score]};
keys(?rank_soul_world) -> {#rank_soul_world.id, [#rank_soul_world.power]};
keys(?rank_soul_world_array) -> {#rank_soul_world_array.id, [#rank_soul_world_array.lev]};
keys(?rank_soul_world_spirit) -> {#rank_soul_world_spirit.id, [#rank_soul_world_spirit.power]};
keys(_Type) ->
    {false, []}.

%%
send_world_message([], _Honor) -> ok;
send_world_message([#rank_celebrity_role{name = Name}|T], Honor) ->
    RoleMsg = notice:role_to_msg(Name),
    role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"恭喜~s获得~s称号！被永久载入编年史！">>), [RoleMsg, Honor])}),
    send_world_message(T, Honor).

