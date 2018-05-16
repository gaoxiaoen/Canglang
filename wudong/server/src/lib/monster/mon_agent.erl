%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 场景怪物数据接口   priv_** 场景进程下的内部函数 dict_** 九宫格怪物数据处理函数
%%% @end
%%% Created : 14. 七月 2015 下午4:08
%%%-------------------------------------------------------------------
-module(mon_agent).
-author("fancy").
-include("common.hrl").
-include("scene.hrl").

-behaviour(gen_server).

-compile(export_all).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-record(state, {create_num = 0}).

%%%===================================================================
%%% API
%%%===================================================================
%%  --------------- 获取怪物数据 --------------
%% 获取一个怪物数据
get_mon(SceneId, Copy, Id) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, dict_get_mon, [Id]).

%% 获取场景怪物数据
get_scene_mon(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon, [Copy]).

%% 获取场景怪物数量
get_scene_mon_num(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_num, [Copy]).


%% 获取场景怪物同类列表
get_scene_mon_by_kind(SceneId, Copy, Kind) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_by_kind, [Copy, Kind]).

%% 获取场景怪物类型数量
get_scene_mon_num_by_kind(SceneId, Copy, Kind) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_num_by_kind, [Copy, Kind]).

%% 获取场景相同mid怪物列表
get_scene_mon_by_mid(SceneId, Mid) ->
    F = fun(Copy) ->
        scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_by_mid, [Mid])
        end,
    lists:flatmap(F, scene_copy_proc:get_scene_copy_ids(SceneId)).
get_scene_mon_by_mid(SceneId, Copy, Mid) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_by_mid, [Copy, Mid]).

%% 获取场景所有怪物进程
get_scene_mon_pids(SceneId) ->
    F = fun(Copy) ->
        scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_pids, [])
        end,
    lists:flatmap(F, scene_copy_proc:get_scene_copy_ids(SceneId)).
get_scene_mon_pids(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_pids, [Copy]).
get_scene_mon_pids(SceneId, Copy, X, Y) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_pids, [Copy, X, Y]).
get_scene_mon_pids(SceneId, Copy, Mids) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_pids, [Copy, Mids]).

%% 获取场景内boss列表
get_scene_mon_boss(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_boss, [Copy]).

%% 获取场景分身列表
get_scene_shadow_pids(SceneId, Copy) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_shadow_pids, [Copy]).

%% 获取场景可攻击怪物列表
get_scene_mon_for_battle(SceneId, Copy, X, Y, Area, ExceptList, Group, AtterSign) ->
    scene_agent:apply_call(SceneId, Copy, mon_agent, priv_get_scene_mon_for_battle, [Copy, X, Y, Area, ExceptList, Group, AtterSign, 0]).

%%------------------更新怪物数据 ----------------------
%% 增加怪物
update(Mon) ->
    LongTime = util:longunixtime(),%%数据同步时间，防止覆盖
    scene_agent:apply_cast(Mon#mon.scene, Mon#mon.copy, mon_agent, dict_put_mon, [Mon#mon{sync_time = LongTime}]).

%% 删除怪物
del_mon(Mon) ->
    scene_agent:apply_cast(Mon#mon.scene, Mon#mon.copy, mon_agent, dict_del_mon, [Mon#mon.key]).

update_xy(Mon) ->
    scene_agent:apply_cast(Mon#mon.scene, Mon#mon.copy, mon_agent, dict_put_mon_xy, [Mon#mon.key, Mon#mon.x, Mon#mon.y]).

%%玩家移动激活怪物AI
move_active_mon_ai(Scene, Copy, X, Y, Pkey, Pid, Now, LastTime) ->
    case lists:member(Scene, data_cross_dark_scene_lv:ids()) of
        false -> LastTime;
        true ->
            case Now - LastTime >= 3 of
                false -> LastTime;
                true ->
                    MonList = priv_get_scene_area_mon(Copy, X, Y),
                    [Mon#mon.pid ! {attack, [Pkey, Pid, ?SIGN_PLAYER]} || Mon <- MonList],
                    Now
            end
    end.


%%@param MonId 怪物资源ID
%%@param Scene 场景ID
%%@param X 坐标
%%@param X 坐标
%%@param Copy 房间号ID 为0时，普通房间，非0值切换房间。值相同，在同一个房间。
%%@param BroadCast:生成的时候是否广播(0:不广播; 1:广播)
%%@param Args:可变参数列表[Tuple1, Tuple2...]
%%            Tuple1 = tuple(), {auto_lv, V} | {group, V} | {cruise_info, V} |
%%                              {owner_id, OwnerId} | {mon_name, MonName} |  {color, MonColor} | {return_pid,true} | {return_id_pid,true}
%%@return MonAutoId 怪物自增ID，每个怪物唯一 如果可以变参数列表有return_pid 则返回怪物进程pid ;return_id_pid 则返回 {id,Pid}
create_mon([MonId, Scene, X, Y, Copy, _BroadCast, Args]) ->
    gen_server:call(?MODULE, {create, [MonId, Scene, X, Y, Copy, 1, Args]}).

create_mon_cast([MonId, Scene, X, Y, Copy, _BroadCast, Args]) ->
    gen_server:cast(?MODULE, {create, [MonId, Scene, X, Y, Copy, 1, Args]}).


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_mon_agent_pid() ->
    misc:whereis_name(local, ?MODULE).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    {ok, #state{create_num = 0}}.

%% MonId:怪物id
%% Scene:场景唯一id
%% X:怪物x坐标
%% Y:怪物y坐标
%% Type:怪物战斗类型（0被动，1主动）
%% Copy:房间id
%% BroadCast:生成的时候是否广播(0:不广播; 1:广播)
%% Args[] 额外参数
handle_call({create, [MonId, Scene, X, Y, Copy, BroadCast, Args]}, _FROM, State) ->
    CreateNum = State#state.create_num,

    {AutoId, KeyList} = priv_key_list(Scene, CreateNum),
    Mkey = lists:last(KeyList),
    {ok, Pid} = monster:start([Mkey, KeyList, MonId, Scene, X, Y, Copy, BroadCast, Args]),
    Reply =
        case lists:keyfind(return_pid, 1, Args) of
            false ->
                Mkey;
            _ ->
                Pid
        end,
    Reply2 =
        case lists:keyfind(return_id_pid, 1, Args) of
            false ->
                Reply;
            _ ->
                {Mkey, Pid}
        end,
    {reply, Reply2, State#state{create_num = AutoId}};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% 异步创建怪物，参数同上
handle_cast({create, [MonId, Scene, X, Y, Sid, BroadCast, Args]}, State) ->
    CreateNum = State#state.create_num,
    {AutoId, KeyList} = priv_key_list(Scene, CreateNum),
    Mkey = lists:last(KeyList),
    spawn(fun() -> monster:start([Mkey, KeyList, MonId, Scene, X, Y, Sid, BroadCast, Args]) end),
    {noreply, State#state{create_num = AutoId}};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
priv_key_list(Scene, AutoId) ->
    case scene:is_normal_scene(Scene) orelse scene:is_cross_dark_blibe(Scene) of
        true ->
            KeyList = lists:map(fun(Id) -> AutoId + Id end, [1, 2, 3, 4]),
            {AutoId + 4, KeyList};
        false ->
            KeyList = lists:map(fun(Id) -> AutoId + Id end, [1]),
            {AutoId + 1, KeyList}
    end.

%% 获取场景的所有怪物
priv_get_scene_mon() ->
    AllData = get(),
    [Mon || {_Key, Mon} <- AllData, is_record(Mon, mon)].

%% 获取场景的所有怪物
priv_get_scene_mon(Copy) ->
    AllMon = dict_get_id(Copy),
    get_scene_mon_helper(AllMon, Copy, []).

%% 获取场景区域怪物
priv_get_scene_area_mon(Copy, X, Y) ->
    Area = scene_calc:get_the_area(X, Y),
    dict_get_all_area_mon(Area, Copy).

%% 获取场景的所有怪物数量
priv_get_scene_mon_num(Copy) ->
    length(dict_get_id(Copy)).

priv_get_scene_mon_num_by_kind(Copy, Kind) ->
    AllMon = priv_get_scene_mon(Copy),
    length([0 || Mon <- AllMon, Mon#mon.kind == Kind, Mon#mon.shadow_key == 0]).

%% 根据mid获取场景所有怪物信息
priv_get_scene_mon_by_mid(Mid) ->
    AllData = get(),
    [Mon || {_Key, Mon} <- AllData, is_record(Mon, mon), Mon#mon.mid =:= Mid].

priv_get_scene_mon_by_mid(Copy, Mid) ->
    AllMon = priv_get_scene_mon(Copy),
    [Mon || Mon <- AllMon, Mon#mon.mid =:= Mid].

priv_get_scene_mon_by_kind(Copy, Kind) ->
    AllMon = priv_get_scene_mon(Copy),
    [Mon || Mon <- AllMon, Mon#mon.kind =:= Kind].

%%
get_scene_mon_helper([], _, Data) ->
    Data;
get_scene_mon_helper([Id | T], Copy, Data) ->
    case get(?MON_KEY(Id)) of
        undefined ->
            dict_del_id(Copy, Id),
            get_scene_mon_helper(T, Copy, Data);
        Mon ->
            get_scene_mon_helper(T, Copy, [Mon | Data])
    end.

%% @获取场景所有怪物的进程id
priv_get_scene_mon_pids() ->
    AllMon = priv_get_scene_mon(),
    [Mon#mon.pid || Mon <- AllMon].
priv_get_scene_mon_pids(Copy) ->
    AllMon = priv_get_scene_mon(Copy),
    [Mon#mon.pid || Mon <- AllMon].
priv_get_scene_mon_pids(Copy, X, Y) ->
    AllMon = priv_get_scene_area_mon(Copy, X, Y),
    [Mon#mon.pid || Mon <- AllMon].

%% Mids = lists() = 怪物资源id列表
priv_get_scene_mon_pids(Copy, Mids) ->
    AllMon = priv_get_scene_mon(Copy),
    F = fun(M) ->
        case lists:member(M#mon.mid, Mids) of
            true ->
                [M#mon.pid];
            false ->
                []
        end
        end,
    lists:flatmap(F, AllMon).

%% @获取指定id的怪物进程
priv_get_scene_mon_pid_by_id(Id) ->
    case dict_get_mon(Id) of
        [] ->
            0;
        Mon ->
            Mon#mon.pid
    end.

%% @获取场景内boss怪物
priv_get_scene_mon_boss(Copy) ->
    AllMon = priv_get_scene_mon(Copy),
    [Mon || Mon <- AllMon, Mon#mon.boss > 0].

%%获取场景的分身
priv_get_scene_shadow_pids(Copy) ->
    AllMon = priv_get_scene_mon(Copy),
    [Mon#mon.pid || Mon <- AllMon, Mon#mon.shadow_key /= 0].

%% 获取战斗所需信息
priv_get_scene_mon_for_battle(Copy, X, Y, Area, ExceptList, Group, AtterSign, _ShadowKey) ->
    AllMon =
        if
            Area >= 1000 ->
                priv_get_scene_mon(Copy);
            _ShadowKey == 0 orelse Area < 1000 ->
                AllArea = scene_calc:get_the_area(X, Y),
                dict_get_all_area_mon(AllArea, Copy);
            true ->
                priv_get_scene_mon(Copy)
        end,
    X1 = X + Area,
    X2 = X - Area,
    Y1 = Y + Area,
    Y2 = Y - Area,
    MonList = [Mon || Mon <- AllMon, Mon#mon.x >= X2 andalso Mon#mon.x =< X1, Mon#mon.y >= Y2 andalso Mon#mon.y =< Y1, Mon#mon.hp > 0, (Mon#mon.group /= Group orelse Group == 0),
        ((AtterSign == ?SIGN_PLAYER andalso Mon#mon.is_att_by_player == 1) orelse (AtterSign == ?SIGN_MON andalso Mon#mon.is_att_by_mon == 1)),
        not lists:member(Mon#mon.key, ExceptList)],
    scene_agent:sort_range_obj(MonList, X, Y).


%% 改变怪物属性
%% Id: 怪物唯一id
%% AtrrList: 怪物属性 [Tuple ...]
%%           Tuple = {group, Value} | {hp, Value} | {hp_lim, V} | {def, V}
%%                   | {skill, SkillList}, SkillList = [{技能id, 概率}...]
%%                   | {att_area, V}
priv_change_mon_attr(Id, AtrrList) ->
    case dict_get_mon(Id) of
        [] -> skip;
        Mon -> Mon#mon.pid ! {change_attr, AtrrList}
    end.

%% 怪物追踪目标时获取目标信息
trace_target_info_by_id([MonAid, Key, _MonGroup]) ->
    AttInfo = case dict_get_mon(Key) of
                  Mon when is_record(Mon, mon), Mon#mon.hp > 0 ->
                      #mon{
                          x = X,
                          y = Y
                      } = Mon,
                      {true, Key, X, Y};
                  _ ->
                      false
              end,
    monster:trace_info_back(MonAid, ?SIGN_MON, AttInfo).


%% ------------- 九宫格数据存储内部函数 --------------%%

dict_save_id(Copy, Id) ->
    case get(?COPY_KEY_MON(Copy)) of
        undefined ->
            D1 = dict:new(),
            put(?COPY_KEY_MON(Copy), dict:store(Id, 0, D1));
        D2 ->
            put(?COPY_KEY_MON(Copy), dict:store(Id, 0, D2))
    end.

dict_get_id(Copy) ->
    case get(?COPY_KEY_MON(Copy)) of
        undefined ->
            [];
        D ->
            dict:fetch_keys(D)
    end.

dict_del_id(Copy, Id) ->
    case get(?COPY_KEY_MON(Copy)) of
        undefined ->
            skip;
        D ->
            put(?COPY_KEY_MON(Copy), dict:erase(Id, D))
    end.

dict_get_area(XY, Copy) ->
    case get(?TABLE_AREA_MON(XY, Copy)) of
        undefined ->
            [];
        D ->
            dict:fetch_keys(D)
    end.

dict_save_to_area(Copy, X, Y, Id) ->
    XY = scene_calc:get_xy(X, Y),
    dict_save_to_area(Copy, XY, Id).

dict_save_to_area(Copy, XY, Id) ->
    case get(?TABLE_AREA_MON(XY, Copy)) of
        undefined ->
            D1 = dict:new(),
            put(?TABLE_AREA_MON(XY, Copy), dict:store(Id, 0, D1));
        D2 ->
            put(?TABLE_AREA_MON(XY, Copy), dict:store(Id, 0, D2))
    end.

dict_del_to_area(Copy, X, Y, Id) ->
    XY = scene_calc:get_xy(X, Y),
    dict_del_to_area(Copy, XY, Id).

dict_del_to_area(Copy, XY, Id) ->
    case get(?TABLE_AREA_MON(XY, Copy)) of
        undefined ->
            skip;
        D ->
            put(?TABLE_AREA_MON(XY, Copy), dict:erase(Id, D))
    end.

%% 获取单个怪物
dict_get_mon(Id) ->
    case get(?MON_KEY(Id)) of
        undefined ->
            [];
        Mon ->
            Mon
    end.

dict_get_mon_for_battle(Id, AttKey, Now) ->
    case get(?MON_KEY(Id)) of
        undefined ->
            [];
        Mon ->
            {LockKey, LockTime} = Mon#mon.att_lock,
            if LockKey == 0 orelse Now - LockTime > 15 ->
                put(?MON_KEY(Mon#mon.key), Mon#mon{att_lock = {AttKey, Now}});
                Mon;
                true -> {lock, Mon}
            end
    end.

dict_put_mon(Mon) when is_record(Mon, mon) ->
    case get(?MON_KEY(Mon#mon.key)) of
        undefined ->
            AttLock = Mon#mon.att_lock,
            dict_save_id(Mon#mon.copy, Mon#mon.key),
            dict_save_to_area(Mon#mon.copy, Mon#mon.x, Mon#mon.y, Mon#mon.key);
        _Mon ->
            XY1 = scene_calc:get_xy(Mon#mon.x, Mon#mon.y),
            XY2 = scene_calc:get_xy(_Mon#mon.x, _Mon#mon.y),
            AttLock = _Mon#mon.att_lock,
            if
                XY1 =:= XY2 ->
                    skip;
                true ->
                    dict_del_to_area(_Mon#mon.copy, XY2, _Mon#mon.key),
                    dict_save_to_area(Mon#mon.copy, XY1, Mon#mon.key)
            end
    end,
    put(?MON_KEY(Mon#mon.key), Mon#mon{att_lock = AttLock});
dict_put_mon(_) -> ok.

dict_put_mon_xy(Key, X, Y) ->
    case get(?MON_KEY(Key)) of
        undefined ->
            skip;
        Mon ->
            dict_put_mon(Mon#mon{x = X, y = Y}),
            ok
    end.

dict_del_mon(Id) ->
    case get(?MON_KEY(Id)) of
        undefined ->
            [];
        Mon ->
            dict_del_id(Mon#mon.copy, Id),
            dict_del_to_area(Mon#mon.copy, Mon#mon.x, Mon#mon.y, Id),
            erase(?MON_KEY(Id))
    end.

dict_del_all_area(Copy) ->
    Data = get(),
    F = fun({Key, _}) ->
        case Key of
            {tam, _, Cid} when Cid =:= Copy ->
                erase(Key);
            {ckm, Cid} when Cid =:= Copy ->
                erase(Key);
            {mai, _, Cid} when Cid =:= Copy ->
                erase(Key);
            _ ->
                skip
        end
        end,
    lists:foreach(F, Data).

dict_get_all_area(Area, Copy) ->
    lists:foldl(
        fun(A, L) ->
            dict_get_area(A, Copy) ++ L
        end,
        [], Area).

dict_get_area_mon(XY, Copy) ->
    AllMon = dict_get_area(XY, Copy),
    get_scene_mon_helper(AllMon, Copy, []).

dict_get_all_area_mon(Area, Copy) ->
    List = lists:foldl(
        fun(A, L) ->
            dict_get_area(A, Copy) ++ L
        end,
        [], Area),
    get_scene_mon_helper(List, Copy, []).


%%%=======================tool========================================================================
%%获取指定场景的怪物pid
scene_mon_pid(SceneId) ->
    MatchName = unicode:characters_to_list(util:to_list(lists:concat([scene_agent_, SceneId]))),
    F = fun(Pid) ->
        case erlang:process_info(Pid, registered_name) of
            {registered_name, Name} ->
                Name1 = unicode:characters_to_list(util:to_list(Name)),
                case match_name(Name1, MatchName) of
                    false -> [];
                    true ->
                        List = element(2, lists:keyfind(dictionary, 1, erlang:process_info(Pid))),
                        F = fun({_, Val}, L) ->
                            case is_record(Val, mon) of
                                true ->
                                    [Val#mon.pid | L];
                                false ->
                                    L
                            end
                            end,
                        lists:foldl(F, [], List)
                end;
            _ -> []
        end
        end,
    lists:flatmap(F, erlang:processes()).

%%获取所有的怪物id
all_mon_pid() ->
    MatchName = unicode:characters_to_list(util:to_list(scene_agent_)),
    F = fun(Pid) ->
        case erlang:process_info(Pid, registered_name) of
            {registered_name, Name} ->
                Name1 = unicode:characters_to_list(util:to_list(Name)),
                case match_name(Name1, MatchName) of
                    false -> [];
                    true ->
                        List = element(2, lists:keyfind(dictionary, 1, erlang:process_info(Pid))),
                        F = fun({_, Val}, L) ->
                            case is_record(Val, mon) of
                                true ->
                                    [Val#mon.pid | L];
                                false ->
                                    L
                            end
                            end,
                        lists:foldl(F, [], List)
                end;
            _ -> []
        end
        end,
    lists:flatmap(F, erlang:processes()).


match_name([], _) -> true;
match_name(_, []) -> true;
match_name([Target | T], [Match | L]) ->
    if Target == Match ->
        match_name(T, L);
        true -> false
    end.

send_all_msg(Msg) ->
    [Pid ! Msg || Pid <- all_mon_pid()].
send_scene_msg(SceneId, Msg) ->
    [Pid ! Msg || Pid <- scene_mon_pid(SceneId)].