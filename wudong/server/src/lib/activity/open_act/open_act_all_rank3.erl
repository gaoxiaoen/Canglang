%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 全民冲榜
%%% @end
%%% Created : 25. 三月 2017 14:39
%%%-------------------------------------------------------------------
-module(open_act_all_rank3).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("mount.hrl").
-include("light_weapon.hrl").
-include("magic_weapon.hrl").
-include("wing.hrl").
-include("rank.hrl").
-include("arena.hrl").
-include("pet.hrl").
-include("footprint_new.hrl").
-include("cat.hrl").
-include("pet_weapon.hrl").
-include("golden_body.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    sys_midnight_cacl/0,
    get_act/0,

    get_state/1,
    get_act_info/1,
    recv/2,
    gm_reward/0,
    get_sub_act_type/0
]).

init(#player{key = Pkey} = Player) ->
    StOpenActAllRank =
        case player_util:is_new_role(Player) of
            true ->
                #st_open_act_all_rank3{pkey = Pkey};
            false ->
                activity_load:dbget_open_act_all_rank3(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_OPEN_ALL_RANK3, StOpenActAllRank),
    update_open_act_all_rank(),
    Player.

update_open_act_all_rank() ->
    StOpenActAllRank = lib_dict:get(?PROC_STATUS_OPEN_ALL_RANK3),
    #st_open_act_all_rank3{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StOpenActAllRank,
    case get_act() of
        [] ->
            NewStOpenActAllRank = #st_open_act_all_rank3{pkey = Pkey};
        #base_open_act_all_rank{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(Now, OpTime),
            if
                BaseActId =/= ActId ->
                    NewStOpenActAllRank = #st_open_act_all_rank3{pkey = Pkey, act_id = BaseActId, op_time = Now};
                Flag == false ->
                    NewStOpenActAllRank = #st_open_act_all_rank3{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStOpenActAllRank = StOpenActAllRank
            end
    end,
    lib_dict:put(?PROC_STATUS_OPEN_ALL_RANK3, NewStOpenActAllRank).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_open_act_all_rank().

gm_reward() ->
    sys_midnight_cacl2().

%% 凌晨邮件结算
sys_midnight_cacl() ->
    {{_Y, _Mon, _D},{H, M, _S}} = erlang:localtime(),
    if
        H == 23 andalso M == 58 -> sys_midnight_cacl2();
        true -> ok
    end.

sys_midnight_cacl2() ->
    case get_act() of
        [] ->
            ok;
        #base_open_act_all_rank{list = BaseList, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            IsCenter = config:is_center_node(),
            if
                LTime > 150 -> skip;
                IsCenter == true -> skip;
                true ->
                    F = fun({RandType, SendType, RankMin, RankMax, _BaseLv, GiftId}) ->
                        case SendType of
                            2 ->
                                ok;
                            1 ->
                                List = get_reward_pkey(RandType, RankMin, RankMax),
                                F2 = fun(#a_rank{rp = Rp, rank = Rank}) ->
                                    Pkey = Rp#rp.pkey,
                                    {Title0, Content0} = t_mail:mail_content(69),
                                    Title = io_lib:format(Title0, [get_str(RandType)]),
                                    Content = io_lib:format(Content0, [get_str(RandType), Rank]),
                                    mail:sys_send_mail([Pkey], Title, Content, [{GiftId, 1}])
                                end,
                                lists:map(F2, List)
                        end
                    end,
                    spawn(fun() -> timer:sleep(150000), lists:map(F, BaseList) end)
            end
    end.

get_str(N) ->
    open_act_all_rank:get_str(N).

get_reward_pkey(RandType, RankMin, RankMax) ->
    open_act_all_rank:get_reward_pkey(RandType, RankMin, RankMax).

get_state(Player) ->
    update_open_act_all_rank(),
    StOpenActAllRank = lib_dict:get(?PROC_STATUS_OPEN_ALL_RANK3),
    #st_open_act_all_rank3{recv_list = RecvList} = StOpenActAllRank,
    case get_act() of
        [] ->
            -1;
        #base_open_act_all_rank{list = BaseList} ->
            F = fun({RankType, SendType, _RankMin, _RankMax, BaseLv, _GiftId}) ->
                RecvStatus = lists:keyfind(BaseLv, 2, RecvList),
                if
                    SendType == ?OPEN_ALL_RANK_MAIL_SEND ->
                        [];
                    RecvStatus =/= false ->
                        [];
                    true ->
                        ?IF_ELSE(get_recv_status(Player, RankType, BaseLv) == true, [1], [])
                end
            end,
            List = lists:flatmap(F, BaseList),
            ?IF_ELSE(List == [], 0, 1)
    end.

get_act_info(Player) ->
    case get_act() of
        [] ->
            {0, 0, "", 0, 0, 0, 0, [], []};
        #base_open_act_all_rank{open_info = OpenInfo, list = BaseList} ->
            RankType = element(1, hd(BaseList)),
            LTime = activity:calc_act_leave_time(OpenInfo),
            {NickName, Creer, Sex, Avatar} = get_1_data(RankType),
            %% 邮件发送奖励
            F1 = fun({_RankType1, SendType1, MinRank1, MaxRank1, _BaseLv1, GiftId1}) ->
                ?IF_ELSE(SendType1 == 1, [[MinRank1, MaxRank1, GiftId1]], [])
            end,
            BaseList1 = lists:flatmap(F1, BaseList),
            %% 手动领取奖励
            F2 = fun({RankType2, SendType2, _MinRank2, _MaxRank2, BaseLv2, GiftId2}) ->
                ?IF_ELSE(SendType2 == 2, [[BaseLv2, GiftId2, get_recv(Player, RankType2, BaseLv2)]], [])
            end,
            BaseList2 = lists:flatmap(F2, BaseList),
            Stage = get_stage(Player, RankType),
            {LTime, RankType, NickName, Creer, Sex, Avatar, Stage, BaseList1, BaseList2}
    end.

get_recv(Player, RankType, BaseLv) ->
    StOpenActAllRank = lib_dict:get(?PROC_STATUS_OPEN_ALL_RANK3),
    #st_open_act_all_rank3{recv_list = RecvList} = StOpenActAllRank,
    RecvStatus = lists:keyfind(BaseLv, 2, RecvList),
    if
        RecvStatus =/= false ->
            2;
        true ->
            ?IF_ELSE(get_recv_status(Player, RankType, BaseLv) == true, 1, 0)
    end.

recv(Player, BaseLv) ->
    case get_act() of
        [] ->
            {Player, 0};
        #base_open_act_all_rank{list = BaseList, act_id = BaseActId} ->
            RankType = element(1, hd(BaseList)),
            StOpenActAllRank = lib_dict:get(?PROC_STATUS_OPEN_ALL_RANK3),
            #st_open_act_all_rank3{recv_list = RecvList} = StOpenActAllRank,
            RecvStatus = lists:keyfind(BaseLv, 2, RecvList),
            IsRecvStaus = get_recv_status(Player, RankType, BaseLv),
            if
                RecvStatus =/= false ->
                    {Player, 3}; %% 已经领取
                IsRecvStaus =/= true ->
                    {Player, 2}; %% 未达成
                true ->
                    F = fun({_RankType, SendType, _MinRank, _MaxRank, BaseLv0, _GiftId}) ->
                        BaseLv0 == BaseLv andalso SendType == 2
                    end,
                    [{_RankType, _SendType, _MinRank, _MaxRank, _BaseLv, GiftId}|_] = lists:filter(F, BaseList),
                    NewRecvList = [{RankType, BaseLv} | RecvList],
                    NewStOpenActAllRank = StOpenActAllRank#st_open_act_all_rank3{recv_list = NewRecvList, op_time = util:unixtime(), act_id = BaseActId},
                    lib_dict:put(?PROC_STATUS_OPEN_ALL_RANK3, NewStOpenActAllRank),
                    activity_load:dbup_open_act_all_rank3(NewStOpenActAllRank),
                    GiveGoodsList = goods:make_give_goods_list(670,[{GiftId,1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(Player, [33], true),
                    {NewPlayer, 1}
            end
    end.

get_1_data(RankType) ->
    open_act_all_rank:get_1_data(RankType).

get_stage(_Player, _type) ->
    open_act_all_rank:get_stage(_Player, _type).

get_recv_status(_Player, _type, _BaseLv) ->
    open_act_all_rank:get_recv_status(_Player, _type, _BaseLv).

get_act() ->
    case activity:get_work_list(data_open_all_rank3) of
        [] -> [];
        [Base | _] -> Base
    end.

get_sub_act_type() ->
    case get_act() of
        [] ->
            0;
        #base_open_act_all_rank{list = BaseList} ->
            {ActType, _, _, _, _, _} = hd(BaseList),
            ActType
    end.