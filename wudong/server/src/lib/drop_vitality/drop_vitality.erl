%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 掉落活跃度，用于决定掉落物品是否绑定
%%% @end
%%% Created : 01. 七月 2016 上午11:27
%%%-------------------------------------------------------------------
-module(drop_vitality).
-author("fengzhenlin").
-include("server.hrl").
-include("drop_vitality.hrl").
-include("common.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    logout/1,
    update/1,
    d_trigger/3
]).

%% 1 达到vip等级a级
%% 2 人物等级a级
%%------策划暂时不用 先别删 绝对坑-------
%% 3 a件装备达到b等级
%% 4 装备洗练a条以上b颜色属性
%% 5 活跃度达到a
%% 6 当天跨服boss有伤害
%% 7 许愿树给好友浇水a次
%% 8 星座升级a次
%% 9 原力培养a次
%% 10 仙盟奉献a次
%% 11 等级战力比小于a
%% 12 世界或仙盟聊天次数a次
%% 13 同IP下,累积注册账号大于a个
%%-----------------------------------
%% 14 当日剑池剑池经验到达a点

init(Player) ->
    StDropVitality = drop_vitality_load:dbget_drop_vitality(Player),
    put_dict(StDropVitality),
    NewPlayer = update(Player),
    NewPlayer.

logout(_Player) ->
    St = get_dict(),
    drop_vitality_load:dbup_drop_vitality(St),
    ok.

update(Player) ->
    StDropVitaltiy = get_dict(),
    #st_drop_vitality{
        task_list = TaskList,
        history_list = HistoryList,
        update_time = UpdateTime
    } = StDropVitaltiy,
    Now = util:unixtime(),
    NewTaskList = update_1(Player, Now, TaskList, []),
    NewStDropVitaltiy = StDropVitaltiy#st_drop_vitality{
        task_list = NewTaskList
    },
    NewStDropVitaltiy1 =
        case util:is_same_date(Now, UpdateTime) of
            true -> NewStDropVitaltiy;
            false ->
                Last3Day = util:unixdate() - 3*?ONE_DAY_SECONDS,
                LastDayPoint = calc_sum_point(TaskList, false),
                NewHistory = [{LastDayPoint, UpdateTime}|HistoryList],
                NewHistory1 = [{P,T} || {P,T}<-NewHistory, T >= Last3Day],
                NewHistory2 = lists:sublist(NewHistory1, 3),
                NewStDropVitaltiy#st_drop_vitality{history_list = NewHistory2,update_time = Now}
        end,
    put_dict(NewStDropVitaltiy1),
    NewPlayer = update_vitality_point(Player),
    NewPlayer.
update_1(_Player, _Now, [], NewTaskList) -> NewTaskList;
update_1(Player, Now, [DV|Tail], NewTaskList) ->
    #d_v{
        id = Id,
        update_time = UpdateTime
    } = DV,
    case data_drop_vitality:get(Id) of
        [] -> update_1(Player, Now, Tail, NewTaskList);
        Base ->
            #base_d_v{
                refresh_type = RefreshType
            } = Base,
            case RefreshType of
                1 -> update_1(Player, Now, Tail, [DV|NewTaskList]);
                _ ->
                    case util:is_same_date(Now, UpdateTime) of
                        true -> update_1(Player, Now, Tail, [DV|NewTaskList]);
                        false ->
                            NewDV = #d_v{
                                id = Id
                            },
                            update_1(Player, Now, Tail, [NewDV|NewTaskList])
                    end
            end
    end.

update_vitality_point(Player) ->
    StDropVitaltiy = get_dict(),
    #st_drop_vitality{
        task_list = TaskList,
        history_list = HistoryList
    } = StDropVitaltiy,
    NewPoint = calc_sum_point(TaskList, true),
    Now = util:unixtime(),
    RegDay = util:get_diff_days(Now, Player#player.reg_time),
    DivDays = max(1, min(RegDay, 3)),
    NewPoint1 = ?IF_ELSE(HistoryList == [], 0, round(lists:sum([P||{P,_T}<-HistoryList])/DivDays)),
    SumNewPoint = round(NewPoint + NewPoint1),
    NewSt = StDropVitaltiy#st_drop_vitality{sum_point = SumNewPoint},
    put_dict(NewSt),
    case SumNewPoint >= 100 of
        true -> Player#player{drop_bind = 0};
        false -> Player#player{drop_bind = 1}
    end.

calc_sum_point(TaskList, IsAll) ->
    F = fun(DV, SumPoint) ->
        #d_v{id = Id, state = State} = DV,
        case State == 1 of
            true ->
                case data_drop_vitality:get(Id) of
                    [] -> SumPoint;
                    Base ->
                        if
                            IsAll andalso Base#base_d_v.refresh_type == 1 -> Base#base_d_v.point + SumPoint; %%只要永久固定活跃度
                            (not IsAll) andalso Base#base_d_v.refresh_type == 2 -> Base#base_d_v.point + SumPoint; %%只要每天刷新活跃度
                            true -> SumPoint
                        end
                end;
            false ->
                SumPoint
        end
    end,
    lists:foldl(F, 0, TaskList).

d_trigger(Player, Type, Args) ->
    StDropVitaltiy = get_dict(),
    #st_drop_vitality{
        task_list = TaskList
    } = StDropVitaltiy,
    TaskIdList = data_drop_vitality:get_type(Type),
    F = fun(Id) ->
            case lists:keyfind(Id, #d_v.id, TaskList) of
                false -> [#d_v{id = Id}];
                DV -> ?IF_ELSE(DV#d_v.state == 1, [], [DV])
            end
        end,
    DVList = lists:flatmap(F, TaskIdList),
    Now = util:unixtime(),
    F1= fun(DV, AccTaskList) ->
            Base = data_drop_vitality:get(DV#d_v.id),
            NewDV = do_d_trigger(Type, Base, Player, DV, Args),
            NewDV1 = NewDV#d_v{update_time = Now},
            [NewDV1|lists:keydelete(DV#d_v.id, #d_v.id, AccTaskList)]
        end,
    NewTaskList = lists:foldl(F1, TaskList, DVList),
    NewSt = StDropVitaltiy#st_drop_vitality{
        task_list = NewTaskList
    },
    put_dict(NewSt),
    case TaskIdList =/= [] of
        true -> update_vitality_point(Player);
        false -> Player
    end.

do_d_trigger(1, Base, _Player, DV, _Args) ->
    #base_d_v{args = {Vip}} = Base,
    VipLv = vip:get_real_vip(),
    case VipLv >= Vip of
        true -> DV#d_v{arg1 = Vip,state = 1};
        false -> DV
    end;

do_d_trigger(2, Base, Player, DV, _Args) ->
    #base_d_v{args = {Lv}} = Base,
    case Player#player.lv >= Lv of
        true -> DV#d_v{arg1 = Lv,state = 1};
        false -> DV
    end;

%% do_d_trigger(3, Base, _Player, DV, _Args) ->
%%     #base_d_v{args = {Num, Lv}} = Base,
%%     GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
%%     F = fun(Goods) ->
%%         case Goods#goods.goods_lv >= Lv of
%%             true -> Goods;
%%             false -> []
%%         end
%%     end,
%%     GoodsList1 = lists:flatten(lists:map(F,GoodsList)),
%%     Len1 = length(GoodsList1),
%%     case Len1 >= Num of
%%         true -> DV#d_v{arg1 = Num,arg2 = Lv,state = 1};
%%         false -> DV
%%     end;
%%
%% do_d_trigger(4, Base, _Player, DV, _Args) ->
%%     #base_d_v{args = {Num, Color}} = Base,
%%     GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
%%     F1= fun(Goods,List) ->
%%         F = fun({Key,Val},AccList) ->
%%                 Cl = data_wash_colour:get(Key,Goods#goods.goods_lv,Val),
%%                 case Cl >= Color of
%%                     true -> [Cl|AccList];
%%                     false -> AccList
%%                 end
%%             end,
%%         lists:foldl(F,List,Goods#goods.wash_attr)
%%     end,
%%     ColorList = lists:foldl(F1,[],GoodsList),
%%     Len1 = length(ColorList),
%%     case Len1 >= Num of
%%         true -> DV#d_v{arg1 = Num,arg2 = Color,state = 1};
%%         false -> DV
%%     end;
%%
%% do_d_trigger(5, Base, _Player, DV, Val) ->
%%     #base_d_v{args = {Vitality}} = Base,
%%     case Val >= Vitality of
%%         true -> DV#d_v{arg1 = Vitality,state = 1};
%%         false -> DV
%%     end;
%%
%% do_d_trigger(6, _Base, _Player, DV, _Args) ->
%%     DV#d_v{arg1 = 1,state = 1};
%%
%% do_d_trigger(11, Base, Player, DV, _Args) ->
%%     #base_d_v{args = {Ratio}} = Base,
%%     #player{lv = Lv, cbp = Cbp} = Player,
%%     case round(Lv / Cbp * 100000) =< Ratio of
%%         true -> DV#d_v{arg1 = Lv, arg2 = Cbp,state = 1};
%%         false -> DV
%%     end;
%%
%% do_d_trigger(Type, Base, _Player, DV, Args)
%%     when Type == 7 orelse Type == 8 orelse Type == 9 orelse Type == 10 orelse Type == 12 ->
%%     #base_d_v{args = {Times}} = Base,
%%     #d_v{arg1 = OldTimes} = DV,
%%     NewTimes = OldTimes + Args,
%%     case NewTimes >= Times of
%%         true -> DV#d_v{arg1 = NewTimes,state = 1};
%%         false -> DV#d_v{arg1 = NewTimes,state = 0}
%%     end;
%%
%% do_d_trigger(13, Base, Player, DV, _Args) ->
%%     #base_d_v{args = {Times}} = Base,
%%     #player{reg_ip = RegIp} = Player,
%%     Sql = io_lib:format("select count(*) from player_login where reg_ip='~s'",[RegIp]),
%%     case db:get_row(Sql) of
%%         [] -> DV;
%%         [RegTimes] ->
%%             case RegTimes >= Times of
%%                 true -> DV#d_v{arg1 = RegTimes,state = 1};
%%                 false -> DV
%%             end
%%     end;
do_d_trigger(14, Base, _Player, DV, Val) ->
    #base_d_v{args = {Vitality}} = Base,
    case Val >= Vitality of
        true -> DV#d_v{arg1 = Vitality,state = 1};
        false -> DV
    end;

do_d_trigger(_Type, _Base, _Player, DV, _Args) ->
    DV.

get_dict() ->
    lib_dict:get(?PROC_STATUS_DROP_VITALITY).

put_dict(StDropVitality) ->
    lib_dict:put(?PROC_STATUS_DROP_VITALITY, StDropVitality).