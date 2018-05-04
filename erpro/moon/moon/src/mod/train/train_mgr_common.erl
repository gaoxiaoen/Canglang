%% --------------------------------------------------------------------
%% @doc 飞仙历练管理进程 公共模块
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(train_mgr_common).
-export([
        assign/2
        ,assign/3
        ,assign/4
        ,update/3
        ,leave/3
        ,assign_lid/1
        ,check_area_load/2
        ,start_specify/2
        ,update_area_num/4
        ,lookup/3
    ]
).

-export([init/1
        ,update_role/3
        ,delete_role/3
        ,visitor/2
        ,check_area_load/3
        ,change_grade/4
        ,restart/4
        ,start_specify_train/3
        ,save/1
        ,update_area_num/5
    ]
).

-include("common.hrl").
-include("train.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("link.hrl").

-define(mgr_mod_mapping_train_mod(Mod), case Mod of train_mgr_center -> train_center; train_mgr -> train end).

%% ---------------------------------------------------------------
%% API
%% ---------------------------------------------------------------
%% @spec assign(Role) -> ok
%% @doc 查找分配历练区域
assign(local, #role{pid = Pid, attr = #attr{fight_capacity = FC}}) ->
    train_mgr:cast({assign, Pid, FC});
assign(center, #role{pid = Pid, attr = #attr{fight_capacity = FC}}) ->
    train_mgr_center:cast({assign, Pid, FC}).

%% @spec assign(Role, change_grade) -> ok
%% @doc 重新分配历练区域
assign(local, #role{pid = Pid, attr = #attr{fight_capacity = FC}}, change_grade) ->
    train_mgr:cast({change_grade, Pid, FC});
assign(center, #role{pid = Pid, attr = #attr{fight_capacity = FC}}, change_grade) ->
    train_mgr_center:cast({change_grade, Pid, FC}).

%% @spec check_area_load(Type, Lid) -> ok
%% @doc 检测场区负荷
check_area_load(train_center, Lid) ->
    train_mgr_center:cast({check_area_load, Lid});
check_area_load(train, Lid) ->
    train_mgr:cast({check_area_load, Lid}).

%% @spec update(_Cmd, TrainRole) -> ok
%% @doc 进入各种历练场后
update(train, train_role, TrainRole) -> train_mgr:cast({update_role, TrainRole});
update(train_center, train_role, TrainRole) -> train_mgr_center:cast({update_role, TrainRole});
%% update(train, train_rob, TrainRob) -> train_mgr:cast({update_rob, TrainRob});
%% update(train_center, train_rob, TrainRob) -> train_mgr_center:cast({update_rob, TrainRob});
update(train, train_visitor, TrainVisitor) -> train_mgr:cast({visitor, TrainVisitor});
update(train_center, train_visitor, TrainVisitor) -> train_mgr_center:cast({visitor, TrainVisitor});
update(_, _, _) -> ok.

%% @spec update(_Cmd, TrainRole) -> ok
%% @doc 离开各种历练场后
leave(train, train_role, {Fid, RoleId}) -> train_mgr:cast({delete_role, {Fid, RoleId}});
leave(train_center, train_role, {Fid, RoleId}) -> train_mgr_center:cast({delete_role, {Fid, RoleId}});
%% leave(train, train_rob, {Fid, RoleId}) -> train_mgr:cast({delete_rob, {Fid, RoleId}});
%% leave(train_center, train_rob, {Fid, RoleId}) -> train_mgr_center:cast({delete_rob, {Fid, RoleId}});
%% leave(train, train_visitor, {Fid, RoleId}) -> train_mgr:cast({delete_visitor, {Fid, RoleId}});
%% leave(train_center, train_visitor, {Fid, RoleId}) -> train_mgr_center:cast({delete_visitor, {Fid, RoleId}});
leave(_, _, _) -> ok.

%% @spec start_specify(List) -> ok
%% @doc 
start_specify(local, List) -> train_mgr:cast({start_specify, List});
start_specify(center, List) -> train_mgr_center:cast({start_specify, List}).

%% @spec assign_lid(Fc) -> integer()
%% @doc 获取战力段
assign_lid(FC) ->
    Field = fx_train_data:field(),
    assign_lid(FC, Field).
assign_lid(_FC, []) ->
    lists:max([Lev || {_, _, Lev, _} <- fx_train_data:field()]);
assign_lid(FC, [{Min, Max, Lev, _} | _Fields]) when FC >= Min andalso FC =< Max ->
    Lev;
assign_lid(FC, [_ | Fields]) ->
    assign_lid(FC, Fields).

%% @spec cast_area_load(Mod, Msg) -> ok
%% Mod = train | train_center
%% @doc 向管理进程发送一条信息
update_area_num(train, Lid, Aid, Num) -> train_mgr:cast({update_area_num, Lid, Aid, Num});
update_area_num(train_center, Lid, Aid, Num) -> train_mgr_center:cast({update_area_num, Lid, Aid, Num}).

%% @spec lookup(Type, Fun, Args) ->
%% Type = local || center
%% Fid = Aid = integer()
%% Fun = fun()
%% Args = list()
%% @doc 查找数据
lookup(local, Fun, Args) ->
    train_mgr:call({lookup, Fun, Args});
lookup(center, Fun , Args) ->
    train_mgr_center:call({lookup, Fun, Args}).

%% ----------------------------------------------------------------------------------------
%% 系统函数
%% ----------------------------------------------------------------------------------------
%% @doc 飞仙历练管理进程初始化 载入数据，启动子进程
init(MgrMod) ->
    ets:new(train_pid_id_mapping, [set, named_table, public, {read_concurrency, true}]),
    dets:open_file(train, [{file, "../var/train.dets"}, {keypos, #train_field.id}, {type, set}]),
    Fields = dets:foldl(fun(Elem, Acc) -> [Elem | Acc] end, [], train),
    ParsedFields = train_parse(Fields),
    NewFields = load_train_field(MgrMod, ParsedFields),
    save(NewFields),
    NewFields.

%% 更新玩家历练场数据
update_role(_MgrMod, TrainRole = #train_role{id = RoleId, grade = Lid, area = Aid}, Fields) ->
    Fid = {Lid, Aid},
%%    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    case lists:keyfind(Fid, #train_field.id, Fields) of
        false -> {ok};
        Field = #train_field{roles = Roles} ->
            NewRoles = case lists:keyfind(RoleId, #train_role.id, Roles) of
                false -> [TrainRole | Roles];
                _ -> lists:keyreplace(RoleId, #train_role.id, Roles, TrainRole)
            end,
            NewField = Field#train_field{roles = NewRoles},
            NewFields = lists:keyreplace(Fid, #train_field.id, Fields, NewField),
%%            cast_area_load(TrainMod, NewFields, {Lid, Aid, NewNum}),
            save([NewField]),
            {ok, NewFields}
    end.

%% %% 更新劫匪数据
%% update_rob(TrainRob = #train_rob{id = RobId, grade = Lid, area = Aid}, Fields) ->
%%     Fid = {Lid, Aid},
%%     case lists:keyfind(Fid, #train_field.id, Fields) of
%%         false ->
%%             {ok};
%%         Field = #train_field{robs = Robs} ->
%%             NewRobs = case lists:keyfind(RobId, #train_rob.id, Robs) of
%%                 false -> [TrainRob | Robs];
%%                 _ -> lists:keyreplace(RobId, #train_rob.id, Robs, TrainRob)
%%             end,
%%             NewField = Field#train_field{robs = NewRobs},
%%             NewFields = lists:keyreplace(Fid, #train_field.id, Fields, NewField),
%%             {ok, NewFields}
%%     end.
%% 
%% 游客进入
visitor(Visitor, Fields) ->
    catch refresh_field_info(Visitor, Fields),
    {ok}.
%%     case lists:keyfind(Fid, #train_field.id, Fields) of
%%         false ->
%%             {ok};
%%         Field = #train_field{visitors = Visitors} ->
%%             catch refresh_field_info(Visitor, Fields),
%%             NewVisitors = case lists:keyfind(Vid, #train_visitor.id, Visitors) of
%%                 false -> [Visitor | Visitors];
%%                 _ -> lists:keyreplace(Vid, #train_visitor.id, Visitors, Visitor)
%%             end,
%%             NewField = Field#train_field{visitors = NewVisitors},
%%             NewFields = lists:keyreplace(Fid, #train_field.id, Fields, NewField),
%%             {ok, NewFields}
%%     end.

%% 更新玩家历练场数据
delete_role(MgrMod, {Fid, RoleId}, Fields) ->
    {Lid, Aid} = Fid,
    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    case lists:keyfind(Fid, #train_field.id, Fields) of
        false ->
            {ok};
        Field = #train_field{roles = Roles} ->
            NewRoles = lists:keydelete(RoleId, #train_role.id, Roles),
            Num = length([Role || Role = #train_role{train_time = Tt} <- NewRoles, Tt > 0]),
            NewField = Field#train_field{roles = NewRoles, num = Num},
            NewFields = lists:keyreplace(Fid, #train_field.id, Fields, NewField),
            cast_area_load(TrainMod, NewFields, {Lid, Aid, Num}),
            save([NewField]),
            {ok, NewFields}
    end.

%% %% 更新玩家历练场数据
%% delete_rob({Fid, RoleId}, Fields) ->
%%     case lists:keyfind(Fid, #train_field.id, Fields) of
%%         false ->
%%             {ok};
%%         Field = #train_field{robs = Robs} ->
%%             NewRobs = lists:keydelete(RoleId, #train_rob.id, Robs),
%%             NewField = Field#train_field{robs = NewRobs},
%%             NewFields = lists:keyreplace(Fid, #train_field.id, Fields, NewField),
%%             {ok, NewFields}
%%     end.
%% 
%% %% 更新玩家历练场数据
%% delete_visitor({Fid, RoleId}, Fields) ->
%%     case lists:keyfind(Fid, #train_field.id, Fields) of
%%         false ->
%%             {ok};
%%         Field = #train_field{visitors = Visitors} ->
%%             NewVisitors = lists:keydelete(RoleId, #train_visitor.id, Visitors),
%%             NewField = Field#train_field{visitors = NewVisitors},
%%             NewFields = lists:keyreplace(Fid, #train_field.id, Fields, NewField),
%%             {ok, NewFields}
%%     end.

%% 检测是否场区需要新增
check_area_load(MgrMod, Lid, Fields) ->
    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    case assign_aid(TrainMod, Lid, Fields) of
        {false, _Reason} ->
            {ok};
        {ok, Aid} when is_integer(Aid) ->
            {ok};
        {ok, Field = #train_field{id = {_, Aid}}} ->
            NewFields = [Field | Fields],
            cast_area_load(TrainMod, NewFields, {Lid, Aid, 0}), %% 广播新场区
            {ok, NewFields}
    end.

%% 给玩家分配场区
assign(MgrMod, Pid, FC, Fields) ->
    Lid = assign_lid(FC),
    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    case assign_aid(TrainMod, Lid, Fields) of
        {false, Reason} ->
            ?ERR("战力 ~w 分配飞仙历练场区失败 ~s", [Reason]),
            {ok};
        {ok, Aid} when is_integer(Aid) ->
            catch role:apply(async, Pid, {train_common, assign_enter, [{Lid, Aid}, MgrMod]}),
            {ok};
        {ok, Field = #train_field{id = {_, Aid}}} ->
            catch role:apply(async, Pid, {train_common, assign_enter, [{Lid, Aid}, MgrMod]}),
            NewFields = [Field | Fields],
            cast_area_load(TrainMod, NewFields, {Lid, Aid, 0}), %% 广播新场区
            {ok, NewFields}
    end.

%% 给玩家重新分配场区
change_grade(MgrMod, Pid, FC, Fields) ->
    Lid = assign_lid(FC),
    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    case assign_aid(TrainMod, Lid, Fields) of
        {false, Reason} ->
            ?ERR("战力 ~w 分配飞仙历练场区失败 ~s", [Reason]),
            {ok};
        {ok, Aid} when is_integer(Aid) ->
            catch role:apply(async, Pid, {train_common, assign_enter, [{change_grade, {Lid, Aid}}, MgrMod]}),
            {ok};
        {ok, Field = #train_field{id = {_, Aid}}} ->
            catch role:apply(async, Pid, {train_common, assign_enter, [{change_grade, {Lid, Aid}}, MgrMod]}),
            NewFields = [Field | Fields],
            cast_area_load(TrainMod, NewFields, {Lid, Aid, 0}), %% 广播新场区
            {ok, NewFields}
    end.

%% 启动指定场区
start_specify_train(MgrMod, List, Fields) ->
    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    NewFields = do_start_specify_train(TrainMod, List, Fields),
    save(NewFields),
    {ok, NewFields}.

%% 数据保存到DETS中， 不保存劫匪数据，游客数据
save([Field = #train_field{roles = Roles} | Fields]) ->
    NewRoles = [Role || Role = #train_role{train_time = Tt} <- Roles, Tt > 0], %% 只保留在历练中的数据
    NewField = Field#train_field{roles = NewRoles, pid = 0, visitors = [], robs = [], xys = []},
    dets:insert(train, NewField),
    save(Fields),
    {ok};
save([]) -> {ok};
save(_) -> {ok}.

%% 重启退出的飞仙历练场区进程
restart(MgrMod, Pid, Reason, Fields) ->
    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    case lists:keyfind(Pid, #train_field.pid, Fields) of
        F = #train_field{id = Fid = {Lid, Aid}, roles = Roles} -> 
            ?ERR("收到飞仙历练第 ~w 段 ~w 区 EXIT 消息，【Reason：~w】", [Lid, Aid, Reason]),
            NewF = F#train_field{robs = [], roles = [Role#train_role{rob_time = 0} || Role <- Roles]},
            case TrainMod:start_link(NewF) of
                {ok, NewPid} ->
                    NewFields = lists:keyreplace(Fid, #train_field.id, Fields, F#train_field{pid = NewPid}),
                    {ok, NewFields};
                _ ->
                    ?ERR("飞仙历练第 ~w 段 ~w 区重启失败", [Lid, Aid]),
                    {ok}
            end;
        false -> 
            ?ERR("重启飞仙历练场区进程时找不到数据"),
            {ok}
    end.

%% 更新场区人数
update_area_num(MgrMod, Lid, Aid, Num, Fields) ->
    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    case lists:keyfind({Lid, Aid}, #train_field.id, Fields) of
        false ->
            {ok};
        Field ->
            NewFields = lists:keyreplace({Lid, Aid}, #train_field.id, Fields, Field#train_field{num = Num}),
            cast_area_load(TrainMod, Fields, {Lid, Aid, Num}),
            {ok, NewFields}
    end.

%% ---------------------------------------------------------------------------------------------
%% 私有
%% ---------------------------------------------------------------------------------------------

%% 数据转换
train_parse(Fields) ->
    train_parse(Fields, []).
train_parse([], NewFilds) ->
    NewFilds;
train_parse([Field | Fields], NewFilds) ->
    NewField = train_parse:ver(Field),
    train_parse(Fields, [NewField | NewFilds]).

%% 启动各个历练段
load_train_field(MgrMod, Fields) ->
    TrainMod = ?mgr_mod_mapping_train_mod(MgrMod),
    load_train_field(TrainMod, Fields, []).
load_train_field(_TrainMod, [], NewFields) ->
    NewFields;
load_train_field(TrainMod, [Field = #train_field{id = {Lid, Aid}, roles = Roles} | Fields], NewFields) ->
    NewRoles = [Role#train_role{pid = 0, rob_time = 0} || Role = #train_role{train_time = Tt} <- Roles, Tt > 0],   %% 启动保留历练者数据，并清掉劫匪，游客数据
    NewField = Field#train_field{roles = NewRoles, robs = [], visitors = [], num = length(NewRoles)},
    case TrainMod:start_link(NewField) of
        {ok, Pid} ->
            load_train_field(TrainMod, Fields, [NewField#train_field{pid = Pid} | NewFields]);
        _ ->
            ?ERR("飞仙历练场第 ~w 场 ~w 区启动失败", [Lid, Aid]),
            load_train_field(TrainMod, Fields, [NewField#train_field{pid = 0} | NewFields])
    end.

%% 获取一个分区场, 没有就启动一个新场区
assign_aid(TrainMod, Lid, Fields) ->
    Fun = fun(#train_field{pid = Pid, id = {LID, Aid}, num = Num}, Acc) ->
            case is_pid(Pid) andalso Lid =:= LID of
                true -> [{Aid, Num} | Acc];
                _ ->
                    Acc
            end
    end,
    FidLen = lists:foldl(Fun, [], Fields),
    assign_aid(TrainMod, FidLen, ?train_field_max_num, Lid, 0).

assign_aid(TrainMod, [], _Max, Lid, Index) ->
    Aid = Index + 1,
    Field = #train_field{id = {Lid, Aid}, lid = Lid, ver = ?train_ver},
    case TrainMod:start_link(Field) of
        {ok, Pid} ->
            {ok, Field#train_field{pid = Pid}};
        _ ->
            {false, util:fbin(?L(<<"启动新增历练 ~w 场 ~w 区失败">>), [Lid, Aid])}
    end;
assign_aid(_TrainMod, [{Aid, Len} | _FidLen], Max, _Lid, _Index) when Len < Max ->
    {ok, Aid};
assign_aid(TrainMod, [{Aid, _Len} | FidLen], Max, Lid, Index) ->
    assign_aid(TrainMod, FidLen, Max, Lid, max(Index, Aid)).

%% 全场区广播 指定所有场区是否满员消息
%% 指定场区进程来广播 TODO 
cast_area_load(_Mod, [], _Data) ->
    ok;
cast_area_load(Mod, [#train_field{pid = Pid, lid = Lid} | Fields], {Lid, Aid, Num}) ->
    train_common:info(Mod, Pid, {uplas, {Lid, Aid, Num}}),
    cast_area_load(Mod, Fields, {Lid, Aid, Num});
cast_area_load(Mod, [_ | Fields], Data) ->
    cast_area_load(Mod, Fields, Data).

%% 获取所有场区信息  进入玩家获取所有历练场信息
refresh_field_info(#train_visitor{pid = RolePid, fid = {Lid, Aid}}, Fields) ->
    Fun = fun(#train_field{id = {L, A}, num = Num}, Acc) ->
            case L =:= Lid of
                true ->
                    case Num >= ?train_field_max_num of
                        true -> [{L, A, 1} | Acc];
                        false -> [{L, A, 0} | Acc]
                    end;
                false ->
                    Acc
            end
    end,
    Infos = lists:keysort(2, lists:foldl(Fun, [], Fields)),
    role:pack_send(RolePid, 18901, {Lid, Aid, <<>>, Infos}).

%% 启动指定分区
do_start_specify_train(_TrainMod, [], Fields) ->
    Fields;
do_start_specify_train(TrainMod, [{Lid, Aid} | List], Fields) when is_integer(Lid) andalso is_integer(Aid) ->
    case lists:keyfind({Lid, Aid}, #train_field.id, Fields) of
        false ->
            Field = #train_field{id = {Lid, Aid}, lid = Lid},
            case TrainMod:start_link(Field) of
                {ok, Pid} ->
                    do_start_specify_train(TrainMod, List, [Field#train_field{pid = Pid} | Fields]);
                _ ->
                    ?ERR("指定的飞仙历练场第 ~w 场 ~w 区启动失败", [Lid, Aid]),
                    do_start_specify_train(TrainMod, List, Fields)
            end;
        _ ->
            do_start_specify_train(TrainMod, List, Fields)
    end;
do_start_specify_train(TrainMod, [_ | List], Fields) ->
    do_start_specify_train(TrainMod, List, Fields).
