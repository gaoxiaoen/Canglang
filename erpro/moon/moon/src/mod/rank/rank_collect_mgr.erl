%%----------------------------------------------------
%% 排行榜角色数据收集全局管理 
%% @author jackguan@jieyou.cn
%%----------------------------------------------------
-module(rank_collect_mgr).
-behaviour(gen_fsm).
-export([
        start_link/0
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([
        idel/2
        ,save/2
        ,stop/0
        ,gm_save_data/0
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("rank.hrl").
-include("item.hrl").
-include("skill.hrl").
-include("soul_world.hrl").

-define(save_time, 10800). %% 3:00 开始保存数据
-define(gs, 1). %% 神佑
-define(wing_skill, 2). %% 翅膀
-define(demon, 3). %% 守护
-define(soul_world, 4). %% 神魔阵
%%-define(save_num, 50). %% 保存的数量

-record(state, {
        saved = 0           %% 0:未保存 1:已保存 
        ,ts = 0             %% 进入某状态时刻
        ,timeout_val = 0    %% 空闲时间(不是固定的)
    }).

%%------------------------------------
%% 对外接口
%%------------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec stop() -> ok | {error, Error}
%% @doc 关闭排行榜角色特殊属性进程
stop() ->
    gen_fsm:send_all_state_event(?MODULE, stop).

%%------------------------------------
%% 系统函数
%%------------------------------------
init([])->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    IdelTime = get_idel_time(),
    ?INFO("[~w] 启动完成:~p", [?MODULE, IdelTime]),
    {ok, idel, #state{saved = 0, ts = erlang:now(), timeout_val = IdelTime}, IdelTime}.

handle_event(stop, _StateName, StateData) ->
    {stop, normal, StateData};
handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(normal, _StateName, _State) ->
    ?INFO("排行榜角色特殊属性进程正常关闭"),
    ok;
terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%------------------------------------
%% 状态处理函数 
%%------------------------------------
%% 空闲状态结束
idel(timeout, StateData) ->
    ?INFO("准备收集排行榜角色特殊属性数据"),
    Saved = case check() of
        false -> 0;
        _ -> 1
    end,
    {next_state, save, StateData#state{saved = Saved, ts = erlang:now(), timeout_val = 5000}, 5000};
idel(_Event, StateData) ->
    continue(idel, StateData).

save(timeout, StateData = #state{saved = 0}) ->
    ?INFO("开始收集排行榜角色特殊属性数据"),
    save_data(), %%保存数据
    IdelTime = get_idel_time(),
    {next_state, idel, StateData#state{ts = erlang:now(), timeout_val = IdelTime}, IdelTime};
save(timeout, StateData = #state{saved = 1}) ->
    ?INFO("开始收集排行榜角色特殊属性数据"),
    %% 已保存数据,只更改状态
    IdelTime = get_idel_time(),
    {next_state, idel, StateData#state{ts = erlang:now(), timeout_val = IdelTime}, IdelTime};
save(_Event, StateData) ->
    continue(save, StateData).


%%------------------------------------
%% 内部处理函数 
%%------------------------------------
%% 获取空闲时间 - 状态机为毫秒
get_idel_time() ->
    Now = util:unixtime(),
    BeginTime = util:unixtime({today, Now}) + ?save_time,
    Rtn = case BeginTime > Now of
        true -> BeginTime - Now;
        false ->
            util:unixtime({tomorrow, Now}) - Now + ?save_time
    end,
    Rtn * 1000.

continue(StateName, StateData = #state{ts = Ts, timeout_val = TimeVal}) ->
    {next_state, StateName, StateData, util:time_left(TimeVal, Ts)}.

%% 保存搜集数据
save_data() ->
    L = [?soul_world, ?wing_skill, ?gs],
    [save(Type) || Type <- L].

save(Type) when is_integer(Type) ->
    case Type of
        ?soul_world -> %% 神魔阵
            do_save(Type, rank_mgr:lookup(?rank_soul_world));
        ?wing_skill -> %% 翅膀技能
            do_save(Type, rank_mgr:lookup(?rank_role_power));
        ?gs -> %% 神佑
            do_save(Type, rank_mgr:lookup(?rank_role_power));
        _ -> ok
    end;
save(_) -> ok.

do_save(Type, #rank{roles = [I | T]}) ->
    case Type of
        ?soul_world -> %% 神魔阵
            case to_sql(Type, 1, I) of
                ok -> ok;
                VS ->
                    OtherVS = to_sql(Type, 2, T, <<>>),
                    Sql = util:fbin("INSERT INTO log_rank_soul_world (`rank`,`ctime`,`rid`,`srv_id`,`name`,`lev`,`gong`,`xue`,`jing`,`fang`,`shang`,`gold`,`wood`,`water`,`fire`,`terra`) VALUES ~s ~s", [VS, OtherVS]),
                    db:execute(Sql)
            end;
        ?wing_skill -> %% 翅膀技能
            case to_sql(Type, 1, I) of
                ok -> ok;
                VS ->
                    OtherVS = to_sql(Type, 2, T, <<>>),
                    Sql = util:fbin("INSERT INTO log_rank_wing_skill (`rank`,`ctime`,`rid`,`srv_id`,`name`,`lev`,`name1`,`step1`,`name2`,`step2`,`name3`,`step3`,`name4`,`step4`,`name5`,`step5`) VALUES ~s ~s", [VS, OtherVS]),
                    db:execute(Sql)
            end;
        ?gs -> %% 神佑
            case to_sql(Type, 1, I) of
                ok -> ok;
                VS ->
                    OtherVS = to_sql(Type, 2, T, <<>>),
                    Sql = util:fbin("INSERT INTO log_rank_gs (`rank`,`ctime`,`rid`,`srv_id`,`name`,`lev`,`quayifu`,`levyifu`,`quayaodai`,`levyaodai`,`quahuwan`,`levhuwan`,`quahushou`,`levhushou`,`quakuzi`,`levkuzi`,`quaxiezi`,`levxiezi`,`quaweapon`,`levweapon`,`quahufu1`,`levhufu1`,`quahufu2`,`levhufu2`,`quajiezhi1`,`levjiezhi1`,`quajiezhi2`,`levjiezhi2`) VALUES ~s ~s", [VS, OtherVS]),
                    db:execute(Sql)
            end;
        _ -> ok
    end;
do_save(_Type, _Rank) ->
    ok.

%%------------------------------------------------
%% 数据SQL转换
%%------------------------------------------------
%% 转换成批量插入SQL语句
to_sql(_Type, _N, [], Str) -> Str;
to_sql(Type, N, [I | T], Str) ->
    NewStr = util:fbin(",~s", [to_sql(Type, N, I)]),
    to_sql(Type, N + 1, T, <<Str/binary, NewStr/binary>>).

%% 单条数据SQL语句转换
to_sql(Type, N, I) ->
    case Type of
        ?soul_world -> %% 神魔阵 从灵戒战力榜取数据
            case get_field_soul(I) of
                Fs when is_list(Fs) ->
                    Fields = [N, util:unixtime() | Fs],
                    db:format_sql("(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)", Fields);
                _ -> ok
            end;
        ?wing_skill -> %% 翅膀技能
            case get_field_wing(I) of
                Fs when is_list(Fs) ->
                    Fields = [N, util:unixtime() | Fs],
                    db:format_sql("(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)", Fields);
                _ -> ok
            end;
        ?gs -> %% 神佑 从战力排行取神佑数据
            case get_field(I) of
                Fs when is_list(Fs) ->
                    Fields = [N, util:unixtime() | Fs],
                    db:format_sql("(~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s,~s)", Fields);
                _ -> ok
            end;
        _ ->
            ok
    end.

%% 神佑
get_field(#rank_role_power{rid = Rid, srv_id = SrvId, name = Name, lev = Lev, eqm = Eqm}) -> %% 神佑
    {Gslweapon, Gsqweapon} = get_gs_val(1, Eqm), %% 武器
    {Gslyifu, Gsqyifu} = get_gs_val(2, Eqm), %% 衣服
    {Gslkuzi, Gsqkuzi} = get_gs_val(6, Eqm), %% 裤子
    {Gslhushou, Gsqhushou} = get_gs_val(5, Eqm), %% 护手
    {Gslhuwan, Gsqhuwan} = get_gs_val(4, Eqm), %% 护腕
    {Gslxiezi, Gsqxiezi} = get_gs_val(7, Eqm), %% 鞋子
    {Gslyaodai, Gsqyaodai} = get_gs_val(3, Eqm), %% 腰带
    {Gsljiezhi1, Gsqjiezhi1} = get_gs_val(11, Eqm), %% 戒指1
    {Gsljiezhi2, Gsqjiezhi2} = get_gs_val(12, Eqm), %% 戒指2
    {Gslhufu1, Gsqhufu1} = get_gs_val(8, Eqm), %% 护符1
    {Gslhufu2, Gsqhufu2} = get_gs_val(9, Eqm), %% 护符2
    [Rid, SrvId, Name, Lev, Gsqyifu, Gslyifu, Gsqyaodai, Gslyaodai, Gsqhuwan, Gslhuwan, Gsqhushou, Gslhushou, Gsqkuzi, Gslkuzi, Gsqxiezi, Gslxiezi, Gsqweapon, Gslweapon, Gsqhufu1, Gslhufu1, Gsqhufu2, Gslhufu2, Gsqjiezhi1, Gsljiezhi1, Gsqjiezhi2, Gsljiezhi2];
get_field(_) -> ok.

%% 翅膀技能
get_field_wing(#rank_role_power{rid = Rid, srv_id = SrvId, name = Name, lev = Lev, eqm = Eqm}) -> %% 翅膀技能
    WList = get_wing_skill_val(Eqm),
    Val = lists:flatten([tuple_to_list(A) || A <- WList]),
    S = case length(Val) of
        0 -> [0,0,0,0,0,0,0,0,0,0];
        2 -> [0,0,0,0,0,0,0,0];
        4 -> [0,0,0,0,0,0];
        6 -> [0,0,0,0];
        8 -> [0,0];
        10 -> [];
        _ -> []
    end,
    [Rid, SrvId, Name, Lev] ++ Val ++ S.

%% 神魔阵
get_field_soul(#rank_soul_world{rid = Rid, srv_id = SrvId, name = Name, role_lev = Lev, spirits = Spirits, arrays = Arrays}) ->
    case Arrays of
        [] -> ok;
        _ ->
            SoulList = [get_soul(Array, Spirits) || Array <- Arrays],
            NewSoulList = lists:flatten([tuple_to_list(Soul) || Soul <- SoulList]),
            [Rid, SrvId, Name, Lev] ++ NewSoulList
    end.
%% 获取神魔阵相关属性
get_soul(#soul_world_array{id = Id, lev = Lev, spirit_id = SpiritId}, Spirits) ->
    case lists:keyfind(SpiritId, #soul_world_spirit.id, Spirits) of
        #soul_world_spirit{name = Name, lev= SpiritLev, magics = [#soul_world_spirit_magic{type = 1, lev = LevLianDeng}, #soul_world_spirit_magic{type = 2, lev = LevHuLu}]} ->
            {util:fbin("{\"Arrayid\":~p, \"Arraylev\":~p, \"Spiritname\":\"~s\", \"Spiritlev\":~p, \"LevLianDeng\":~p, \"LevHuLu\":~p}", [Id, Lev, Name, SpiritLev, LevLianDeng, LevHuLu])};
        _ -> {util:fbin("{\"Arrayid\":~w, \"Arraylev\":~w, \"Spiritname\":\"~w\", \"Spiritlev\":~w, \"LevLianDeng\":~w, \"LevHuLu\":~w}", [0, 0, 0, 0, 0, 0])}
    end.

%% 获取神佑属性
get_gs_val(Type, Eqm) ->
    case lists:keyfind(Type, #item.id, Eqm) of
        false -> {0, 0};
        Item -> item:get_gs_pingfeng_args(Item)
    end.

%% 获取翅膀技能属性
get_wing_skill_val(Eqm) ->
    case lists:keyfind(15, #item.id, Eqm) of
        false -> [];
        Item -> get_wing_skill(Item)
    end.
get_wing_skill(#item{attr = Attr}) ->
    Fun = fun({CodeName, _Flag, SkillId}, L) when CodeName =:= ?attr_skill ->
            #skill{name = SkillName} = skill_data:get(SkillId),
            Step = SkillId rem 100,
            [{SkillName, Step} | L];
        (_, L) ->
            L
    end,
    lists:foldl(Fun, [], Attr);
get_wing_skill(_) -> 
    [].

check() ->
    Now = util:unixtime(),
    case db:get_one("SELECT COUNT(*) FROM log_rank_gs WHERE ctime = FROM_UNIXTIME(~s, '%Y-%m-%d')", [Now]) of
        {error, _Err} -> ?ERR("访问数据库时发生异常");
        {ok, Num} when Num >= 1 -> %% 数据已经存在
            true;
        {ok, _} -> false
    end.

%%------------------------------------
%% GM命令
%%------------------------------------
gm_save_data() ->
    save_data().
