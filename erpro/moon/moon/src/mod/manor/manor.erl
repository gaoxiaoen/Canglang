%% 庄园功能
-module(manor).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("manor.hrl").
-include("channel.hrl").

-export(
    [
        login/1
        ,have_free_hole/1
        ,get_baoshi/1
        ,set_baoshi_cd_timer/1
        ,baoshi_cd_timeout/2
        ,make_baoshi/2
        ,is_my_npc/2
        ,set_npc_old/2
        ,set_moyao_cd_timer/1
        ,moyao_cd_timeout/2
        ,get_material/2
        ,cost_material/2
        ,gen_moyao/1
        ,add_moyao_num/3
        ,set_trade_timer/2
        ,stop_trade_timer/1
        ,trade_timeout/1
        ,set_train_pet_timer/2
        ,train_pet_timeout/2
        ,del_train_pet_timer/1
        ,sec2yb/1
        ,calc/1
        ,fire/2
        ,get_enchant_rate/2
        ,status/1
        ,all_attr/2
    ]
).

login(Role = #role{}) ->
    Fun = fun(Label, Role1) -> login(Label, Role1) end,
    lists:foldl(Fun, Role, [baoshi, moyao, trade, train]).
 
login(baoshi, Role = #role{manor_baoshi = Baoshi = #manor_baoshi{hole_col = HoleCol = #hole_col{cd_time = Cd, last_time = LastTime,  holes = Holes}}}) ->
    Now = util:unixtime(),
    case Now - LastTime >= Cd of
        true ->
            Holes1 = lists:keymap(fun(_X)-> ?false end, #hole.have_cd, Holes),
            Role#role{manor_baoshi = Baoshi#manor_baoshi{hole_col = HoleCol#hole_col{ cd_time=0, holes = Holes1}}};
        false ->
            Cd1 = (Cd - (Now - LastTime)) * 1000,
            role_timer:set_timer(manor_baosi_timer, Cd1, {?MODULE, baoshi_cd_timeout, [0]}, 1, Role)
    end;

login(moyao, Role = #role{manor_moyao = Moyao = #manor_moyao{ hole_col = HoleCol = #hole_col{cd_time = Cd, last_time = LastTime, holes = Holes}}})->
   Now = util:unixtime(),
   case Now - LastTime >= Cd of
       true ->
           Holes1 = lists:keymap(fun(_X)-> ?false end, #hole.have_cd, Holes),
           Role#role{manor_moyao = Moyao#manor_moyao{ hole_col = HoleCol#hole_col{cd_time = 0,holes = Holes1}}};
       false ->
           CdTime = (Cd - (Now - LastTime)) * 1000,
           role_timer:set_timer(manor_moyao_timer, CdTime, {?MODULE, moyao_cd_timeout, [0]}, 1, Role)
   end;
    
login(trade, Role = #role{manor_trade = Trade = #manor_trade{trade_time = TradeTime, trade_npc = TradeNpc}})->
    case TradeNpc =/= 0 of
        true ->
            Now = util:unixtime(),
            {_Cost, TotalTime, _PerProfit} = manor_trade_data:get_npc_conf(TradeNpc),
            case Now - TradeTime >= TotalTime of
                true ->
                    Role#role{manor_trade = Trade#manor_trade{has_cd = 0}};
                false ->
                    RemainSec = TotalTime - (Now - TradeTime),
                    Role1 = set_trade_timer(RemainSec, Role),
                    Role1
            end;
        false ->
            Role
    end;

login(train, Role = #role{ manor_train = Train = #manor_train{train_time = TrainTime, train_npc = Npc, has_gain = Gain}}) ->
    Now = util:unixtime(),
    case Npc =/= 0 of
        true -> 
            {_Cost, Time, Exp} = manor_train_data:get_npc_conf(Npc),
            Elapse = Now - TrainTime,
            case Elapse >= Time*60 of
                true ->
                    AddExp = (Time - Gain) * Exp,
                    Role1 = pet_api:asc_pet_exp(Role, AddExp),
                    Role1#role{manor_train = Train#manor_train{train_time = 0,train_npc = 0}};
                false ->
                    TotalGain = Elapse div 60,
                    RealGain = TotalGain - Gain,
                    AddExp = RealGain * Exp,
                    Role1 = pet_api:asc_pet_exp(Role, AddExp),
                    Remain = Time * 60 - Elapse,
                    Role2 = set_train_pet_timer( Remain rem 60, Role1),
                    Role2#role{manor_train = Train#manor_train{has_gain=TotalGain}}
            end;
        false -> Role
    end.


%% 检查是否有空闲的孔
%% have_free_hole = #hole | false
have_free_hole(Holes) ->
    FreeHole = [Hole || Hole = #hole{item_id = ItemId, have_cd = HaveCd} <- Holes, ItemId =:= 0, HaveCd =:= ?false],
    case length(FreeHole) > 0 of
        false -> false;
        true ->
            [Hole1|_T] = FreeHole,
            Hole1
    end.

%% 随机抽取宝石
get_baoshi(BaoshiType) ->
    case manor_baoshi_data:type2baoshi(BaoshiType) of
        [] -> false;
        BaoshiList -> rand_baoshi(BaoshiList, util:rand(1,10000), 0)
    end.

%%do_get_baoshi(_BaoshiList, 0, Res) -> Res;
%%do_get_baoshi(BaoshiList, Num, Res) ->
%%    Ret = rand_baoshi(BaoshiList, util:rand(1,10000), 0),
%%    case Ret of
%%        false -> false;
%%        BaoshiId -> do_get_baoshi(BaoshiList, Num-1, [BaoshiId|Res])
%%    end.

rand_baoshi([], _Rand, _Range) -> ?DEBUG("---->>>> big bug... 取不到宝石!!!!!"), false;
rand_baoshi([{Id, Rate} | T], Rand, Range) ->
    case Rand =< Range+Rate of
        true -> Id;
        false ->
            rand_baoshi(T, Rand, Range+Rate)
    end.

%% @spec set_baoshi_cd_timer(Role) -> NewRole
%% 
%% @doc
set_baoshi_cd_timer(Role = #role{manor_baoshi = ManorBaoshi = #manor_baoshi{hole_col=HoleCol}}) ->
    %% 先去掉之前设置的定时器
    Now = util:unixtime(),
    case role_timer:del_timer(manor_baosi_timer, Role) of
        false -> %% 没有定时器
            NewRole1 = role_timer:set_timer(manor_baosi_timer, 10*60*1000, {?MODULE, baoshi_cd_timeout, [Now]}, 1, Role),
            NewRole1#role{manor_baoshi=ManorBaoshi#manor_baoshi{hole_col=HoleCol#hole_col{last_time=Now, cd_time=10*60}}};
        {ok, {_Timeout, Remain}, NewRole} ->
            NewCdTime = 10*60*1000+Remain,
            NewRole1 = role_timer:set_timer(manor_baosi_timer, NewCdTime, {?MODULE, baoshi_cd_timeout, [Now]}, 1, NewRole),
            NewRole1#role{manor_baoshi=ManorBaoshi#manor_baoshi{hole_col=HoleCol#hole_col{last_time=Now, cd_time=NewCdTime div 1000}}}
    end. 

%% 宝石CD定时器响应回调函数
baoshi_cd_timeout(Role = #role{link=#link{conn_pid=ConnPid}, manor_baoshi = ManorBaoshi = #manor_baoshi{hole_col=HoleCol=#hole_col{holes=Holes}}}, _LastTime) ->
    Fun = fun(_X) -> ?false end,
    NewHoles = lists:keymap(Fun, #hole.have_cd, Holes),
    sys_conn:pack_send(ConnPid, 19503, {?true, ?MSGID(<<"消除CD成功">>)}),
    Role1 = Role#role{manor_baoshi = ManorBaoshi#manor_baoshi{hole_col = HoleCol#hole_col{holes = NewHoles, cd_time=0}}},
    manor_rpc:pack_send_19521(Role1),
    {ok, Role1}.

%% 根据宝石ID生成宝石
make_baoshi([], Res) -> Res;
make_baoshi([Id|T], Res) ->
    case item:make(Id, 1, 1) of
        false -> 
            {false, <<"生成宝石失败">>};
        {ok,[Item]} ->
            make_baoshi(T, [Item|Res])
    end.

is_my_npc(NpcId, Npc) ->
    case lists:keyfind(NpcId, #manor_npc.id, Npc) of
        false ->
            false;
        _ ->
            true
    end.

set_npc_old(NpcId, Role = #role{manor_enchant = ManorEnchant = #manor_enchant{has_npc = HasNpc}}) ->
    case NpcId =/= 0 of
        true ->
            case lists:keyfind(NpcId, #manor_npc.id, HasNpc) of
                false ->
                    Role;
                #manor_npc{is_new = 0} ->
                    Role;
                A = #manor_npc{} ->
                    HasNpc1 = lists:keyreplace(NpcId, #manor_npc.id, HasNpc, A#manor_npc{is_new = 0}),
                    Role1 = Role#role{manor_enchant = ManorEnchant#manor_enchant{has_npc = HasNpc1}},
                    manor_rpc:pack_send_19521(Role1),
                    Role1
            end;
        false ->
            Role
    end.

%% @spec set_moyao_cd_timer(Role) -> NewRole
set_moyao_cd_timer(Role = #role{manor_moyao = ManorMoyao = #manor_moyao{hole_col=HoleCol}}) ->
    %% 先去掉之前设置的定时器
    Now = util:unixtime(),
    case role_timer:del_timer(manor_moyao_timer, Role) of
        false -> %% 没有定时器
            NewRole1 = role_timer:set_timer(manor_moyao_timer, 20*60*1000, {?MODULE, moyao_cd_timeout, [Now]}, 1, Role),
            NewRole1#role{manor_moyao=ManorMoyao#manor_moyao{hole_col=HoleCol#hole_col{last_time=Now, cd_time=20*60}}};
        {ok, {_Timeout, Remain}, NewRole} ->
            NewCdTime = 20*60*1000+Remain,
            NewRole1 = role_timer:set_timer(manor_moyao_timer, NewCdTime, {?MODULE, moyao_cd_timeout, [Now]}, 1, NewRole),
            NewRole1#role{manor_moyao=ManorMoyao#manor_moyao{hole_col=HoleCol#hole_col{last_time=Now, cd_time=NewCdTime div 1000}}}
    end. 

%% 魔药CD定时器响应回调函数
moyao_cd_timeout(Role = #role{link=#link{conn_pid=ConnPid}, manor_moyao = ManorMoyao = #manor_moyao{hole_col=HoleCol=#hole_col{holes=Holes}}}, _LastTime) ->
    Fun = fun(_X) -> ?false end,
    NewHoles = lists:keymap(Fun, #hole.have_cd, Holes),
    sys_conn:pack_send(ConnPid, 19507, {?true, ?MSGID(<<"消除CD成功">>)}),
    Role1 = Role#role{manor_moyao = ManorMoyao#manor_moyao{hole_col = HoleCol#hole_col{holes = NewHoles, cd_time=0}}},
    manor_rpc:pack_send_19521(Role1),
    {ok, Role1}.

%% 设定训练小伙伴定时器
set_train_pet_timer(Secs, Role = #role{manor_train = ManorTrain = #manor_train{}}) ->
    Now = util:unixtime(),
    NewRole1 = role_timer:set_timer(train_pet_timer, Secs*1000, {?MODULE, train_pet_timeout, [Now]}, 1, Role),
    NewRole1#role{manor_train=ManorTrain#manor_train{}}.

%% 去掉小伙伴定时器
del_train_pet_timer(Role) ->
    case role_timer:del_timer(train_pet_timer, Role) of
        false -> Role;
        {ok, {_Timeout, _Remain}, NewRole} -> NewRole
    end.

%% 小伙伴定时器回调
train_pet_timeout(Role = #role{ manor_train = ManorTrain = #manor_train{train_npc=TrainNpc,has_gain=HasGain}}, _LastTime) ->
    {_Cost, Time, _Exp} = manor_train_data:get_npc_conf(TrainNpc),
    {ok, Role3} =
    case HasGain < Time of
        true ->
            Role1 = del_train_pet_timer(Role),
            Role2 = set_train_pet_timer(60, Role1),
            {ok,Role2#role{manor_train = ManorTrain#manor_train{has_gain = HasGain + 1}}};
        false -> %% 最后一次,清掉玩家训练标志
            Role1 = Role#role{manor_train = ManorTrain#manor_train{train_npc = 0,has_gain = 0}},
            {ok, Role1}
    end,
    {_, _, P} = manor_train_data:get_npc_conf(TrainNpc),
    Role4 = pet_api:asc_pet_exp(Role3, P),
    manor_rpc:pack_send_19521(Role4),
    {ok, Role4}.

%% 设定跑商定时器
set_trade_timer(Secs, Role = #role{manor_train = ManorTrain = #manor_train{}}) ->
    NewRole1 = role_timer:set_timer(trade_timer, Secs*1000, {?MODULE, trade_timeout, []}, 1, Role),
    NewRole1#role{manor_train=ManorTrain#manor_train{}}.

stop_trade_timer(Role) ->
    case role_timer:del_timer(trade_timer, Role) of
        false -> Role;
        {ok, {_Timeout, _Remain}, NewRole} -> NewRole
    end.

trade_timeout(Role = #role{manor_trade = ManorTrade = #manor_trade{}}) ->
    Role1 = Role#role{manor_trade = ManorTrade#manor_trade{has_cd = 0}},
    manor_rpc:pack_send_19521(Role1),
    {ok, Role1}.

%% 领取原材料
%% get_material() -> NewRole
get_material([], Role) -> Role;
get_material([ItemId | T], Role) ->
    Role1 = do_add_material(ItemId, 1, Role),
    get_material(T, Role1).

%% items -> [{id,num}]
%% cost_material() -> {ok,NewRole} | {false, Reason}
cost_material(Items, Role) ->
    case check_material(Items, Role) of
        false ->
            {false, <<"材料不够">>};
        ok -> del_material(Items, Role)
    end.

%% 生成魔药
gen_moyao(Recipe) ->
    case manor_moyao_data:get_rate(Recipe) of
        false -> ?DEBUG("-----> 找不到配方 ~p~n", [Recipe]);
        {RateItems, SumRate} ->
            Rand = util:rand(1, SumRate),
            do_gen_moyao(RateItems, Rand, 0)
    end.

%% 增加玩家喝魔药数量
%% add_moyao_num -> NewRole
add_moyao_num(Role=#role{manor_moyao=ManorMoyao=#manor_moyao{has_eat_yao=HasEat}}, MoyaoId, Num) ->
    case lists:keyfind(MoyaoId, #has_eat_yao.id, HasEat) of
        false ->
            Role#role{manor_moyao=ManorMoyao#manor_moyao{has_eat_yao=[#has_eat_yao{id=MoyaoId,num=Num} | HasEat]}};
        #has_eat_yao{num=HasEatNum} ->
            NewList= lists:keyreplace(MoyaoId, #has_eat_yao.id, HasEat, #has_eat_yao{id=MoyaoId, num=HasEatNum+Num}),
            Role#role{manor_moyao=ManorMoyao#manor_moyao{has_eat_yao=NewList}}
    end.

%% 秒数 -> 晶钻
sec2yb(Sec) ->
    Yb = (Sec div 60) * 0.5,
    Yb1 = case Sec rem 60 of 0->Yb; _-> Yb+0.5 end,
    round(Yb1).

%% 算喝魔药带给角色的基础属性
calc(Role=#role{manor_moyao=#manor_moyao{has_eat_yao=HasEat}}) ->
    YaoId = [{Id,Num}||#has_eat_yao{id = Id, num = Num} <- HasEat],
    Attr = all_attr(YaoId, []),
    {ok, NewRole} = eqm_effect:do_attr(Attr, Role),
    NewRole.

all_attr([], Attr) -> Attr;
all_attr([{Id,Num}|T], Attr) ->
    Attr1 = Attr ++ get_effect(Id, Num),
    all_attr(T, Attr1).

get_effect(YaoId, Cnt) ->
    case manor_moyao_data:moyao_conf(YaoId) of
        false -> [];
		{AttrType, MaxTimes, Vals, MaxAttr} ->
				case Cnt > MaxTimes of
					true -> [{AttrType, 100, MaxAttr}];
					false ->
						V = count(Cnt, Vals,0),
						[{AttrType, 100, V}]
				end
	end.
	
count(_Cnt, [], V) -> V;
count(Cnt, [{{L,R}, Val} | T], V) ->
	case Cnt >= L andalso Cnt =< R of
		true -> V+(Cnt-L+1)*Val;
		false -> count(Cnt, T, V+(R-L+1)*Val)
	end.

%% 勋章触发
fire(MedalId, Role) ->
    NpcConf = manor_open_data:get(MedalId),
    add_npc(NpcConf, Role).


%% -------------------------------------  私有函数  --------------------------------------------

%% 随机魔药
%% RateItems=[{ItemId,Num} | ]
%% Rand 随机数
%% Range 范围
%% do_gen_moyao() -> item_id
do_gen_moyao([], _Rand, _Range) -> false;
do_gen_moyao([{ItemId, ItemRate} | T], Rand, Range) ->
    case Rand =< ItemRate+Range of
        true -> ItemId;
        false -> do_gen_moyao(T, Rand, Range+ItemRate)
    end.

%% 删除玩家材料
del_material([], Role) -> {ok, Role};
del_material([{ItemId, Num} | T], Role) ->
    case do_del_material(ItemId, Num, Role) of
        Ret={false, _Reason} -> Ret; %% 不应该在此
        {ok, NewRole} -> del_material(T, NewRole)
    end.

%% 添加材料
%% -> NewRole
do_add_material(ItemId, Num, Role=#role{manor_moyao=ManorBaoshi=#manor_moyao{material=Material}}) ->
    case lists:keyfind(ItemId, #material.id, Material) of
        false ->
            Role#role{manor_moyao=ManorBaoshi#manor_moyao{material=[#material{id=ItemId, num=Num}|Material]}};
        M=#material{num=OldNum}->
            NewMaterialList = lists:keyreplace(ItemId, #material.id, Material, M#material{num=OldNum+Num}),
            Role#role{manor_moyao=ManorBaoshi#manor_moyao{material = NewMaterialList}}
    end.

%% 删除材料
do_del_material(ItemId, Num, Role=#role{manor_moyao=ManorBaoshi=#manor_moyao{material=Material}}) ->
    case Num =:= 0 of
        true ->
            {ok, Role};
        false ->    
            case lists:keyfind(ItemId, #material.id, Material) of
                false ->
                    {false, <<"没有此材料">>};
                M=#material{num=HasNum}->
                    case HasNum >= Num of
                        false ->
                            {false, <<"材料不足">>};
                        true ->
                            NewMaterialList = lists:keyreplace(ItemId, #material.id, Material, M#material{num=HasNum-Num}),
                            NewRole = Role#role{manor_moyao=ManorBaoshi#manor_moyao{material = NewMaterialList}},
                            {ok, NewRole}
                    end
            end
    end.

%% check_material() -> ok | false
check_material([], _Role) -> ok;
check_material([{_ItemId, 0} | T], Role = #role{}) -> check_material(T, Role);
check_material([{ItemId, Num} | T], Role = #role{manor_moyao=#manor_moyao{material=Material}}) ->
    case lists:keyfind(ItemId, #material.id, Material) of
        false ->
            false;
        #material{num=HasNum} ->
            case HasNum >= Num of
                true -> check_material(T, Role);
                false -> false
            end
    end.

add_npc([], Role) -> Role;
add_npc([{Label, NpcId} | T], Role) ->
    Role2 =
    case add_npc(Label, NpcId, Role) of
        {ok, Role1 = #role{link = #link{conn_pid = ConnPid}}} ->
            sys_conn:pack_send(ConnPid, 19522, {NpcId}),
            Role1;
        {false, Role1} -> Role1
    end,
    add_npc(T, Role2).

add_npc(baoshi, NpcId, Role = #role{manor_baoshi = ManorBaoshi = #manor_baoshi{baoshi_npc = Npc}}) ->
    case lists:keyfind(NpcId, #manor_npc.id, Npc) of
        false ->
            {ok, Role#role{manor_baoshi = ManorBaoshi#manor_baoshi{baoshi_npc = [#manor_npc{id = NpcId} | Npc]}}};
        _ ->
            {false, Role}
    end;

add_npc(moyao, NpcId, Role = #role{manor_moyao= ManorMoyao = #manor_moyao{ material_npc = Npc}}) ->
    case lists:keyfind(NpcId, #manor_npc.id, Npc) of
        false ->
            {ok, Role#role{manor_moyao = ManorMoyao#manor_moyao{material_npc = [#manor_npc{id = NpcId} | Npc]}}};
        _ ->
            {false,Role}
    end;

add_npc(trade, NpcId, Role = #role{manor_trade = ManorTrade = #manor_trade {has_npc = Npc}}) ->
    case lists:keyfind(NpcId, #manor_npc.id, Npc) of
        false ->
            {ok, Role#role{manor_trade = ManorTrade#manor_trade{has_npc = [#manor_npc{id = NpcId} | Npc]}}};
        _ ->
            {false, Role}
    end;
add_npc(train, NpcId, Role = #role{manor_train = ManorTrain = #manor_train{has_npc = Npc}}) ->
    case lists:keyfind(NpcId, #manor_npc.id, Npc) of
        false ->
            {ok, Role#role{manor_train = ManorTrain#manor_train{has_npc = [#manor_npc{id = NpcId} | Npc]}}};
        _ ->
            {false, Role}
    end;

add_npc(make, NpcId, Role = #role{manor_enchant = ManorEnchant = #manor_enchant{has_npc = Npc}}) ->
    case lists:keyfind(NpcId, #manor_npc.id, Npc) of
        false ->
            {ok, Role#role{manor_enchant = ManorEnchant#manor_enchant{has_npc = [#manor_npc{id = NpcId} | Npc]}}};
        _ ->
            {false, Role}
    end.


status(Role = #role{
        manor_baoshi = #manor_baoshi{baoshi_npc = BaoshiNpc, hole_col = #hole_col{last_time = BaoshiLastTime, holes = BaoshiHoles, cd_time= BaoshiCd}},
        manor_moyao = #manor_moyao{material_npc = MaterialNpc, hole_col = #hole_col{last_time = YaoLastTime, holes = MoyaoHoles, cd_time= MoyaoCd}},
        manor_trade = #manor_trade{has_npc = AllTradeNpc, trade_time=TradeTime, has_cd=HasCd, trade_npc=TradeNpc},
        manor_train = #manor_train{has_npc = AllTrainNpc, train_time = TrainTime, train_npc = TrainNpc},
        manor_enchant = #manor_enchant{has_npc = MakeNpc},
        channels = #channels{flag = Flag, time = ChannelTimes, cd_time = ChannelCd}
    })->
        All = BaoshiNpc ++ MaterialNpc ++ AllTradeNpc ++ AllTrainNpc ++ MakeNpc,
        NewNpc = [Id || #manor_npc{id = Id, is_new = 1} <- All],
        Now = util:unixtime(),
        FreeHole = length([N || #hole{have_cd = N} <- BaoshiHoles, N =:= 0]),
        Info1 =
        case FreeHole =:= 0 of
            true -> 
                NewCdTime = (BaoshiCd - (Now - BaoshiLastTime)),
                ?DEBUG("*******************  CD TIME : ~w", [NewCdTime]),
                [{NewCdTime, FreeHole}];
            false ->
                case BaoshiCd > 0 of
                    true -> [{BaoshiCd - (Now - BaoshiLastTime), FreeHole}];
                    false -> [{0, FreeHole}]
                end
        end,

        FreeHole1 = length([N1 || #hole{have_cd = N1} <- MoyaoHoles, N1 =:= 0]),
        Info2 =
        case FreeHole1 =:= 0 of
            true -> 
                MCd = (MoyaoCd - (Now - YaoLastTime)),
                [{MCd, FreeHole1}];
            false ->
                case MoyaoCd > 0 of
                    true ->
                        [{MoyaoCd - (Now - YaoLastTime), FreeHole1}];
                    false ->
                        [{0, FreeHole1}]
                end
        end,

        Info3 = 
        case TradeNpc =:= 0 of %% 当前是否有另一场跑商
            false ->
                {_, TotalTime, _PerProfit} = manor_trade_data:get_npc_conf(TradeNpc),
                case (Now-TradeTime >= TotalTime) orelse (HasCd =:= 0) of 
                    false -> %% 正在跑商
                        [{TotalTime-(Now-TradeTime), 0}];
                    true -> %% 空闲
                        [{0, 1}]
                end;
            true ->
                [{0,1}]
        end,

        %% 训龙信息
        Info4 =
        case TrainNpc =:= 0 of
            false -> 
                {_, Time, _Exp} = manor_train_data:get_npc_conf(TrainNpc),
                [{Time*60 - (util:unixtime()-TrainTime), 0}];
            true ->
                [{0, 1}]
        end,

        Rem = Flag rem 5,
        Info5 =
        case (Rem =:= 0) andalso ChannelTimes =/= 0 of
            true ->
                ChannelEplase = Now - ChannelTimes,
                ChannelCd1 = ChannelCd - ChannelEplase,
                [{ChannelCd1, 0}];
            false ->
                Cnt = 5 - Rem,
                LevNum = channel:calc_lev_channel(Role),
                Num = case LevNum > 0 of true -> Cnt; false -> 0 end,
                [{0, Num}]
        end,
        A = Info1++Info2++Info3++Info4++Info5,
        {NewNpc, A}.

%% 获取庄园强化成功率加成
get_enchant_rate(#role{lev = RoleLev, manor_enchant = #manor_enchant{has_npc = HasNpc}}, Enchant) ->
    {Lev, TaskId} = manor_open_data:get_enchant_open(),
    case task:is_zhux_finish(TaskId) andalso RoleLev >= Lev of
        true ->
            case manor_enchant_data:get(Enchant) of
                false ->
                    {0,0,0};
                {Npc, Rate, F} ->
                    L = [NpcId || #manor_npc{id = NpcId} <- HasNpc],
                    case lists:member(Npc, L) of
                        true -> {Npc, Rate, F};
                        false -> {0,0,0}
                    end
            end;
        false ->
            {0,0,0}
    end.

