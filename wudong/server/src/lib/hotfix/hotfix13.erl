%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         补发钻石啊啊
%%% @end
%%% Created : 27. 十月 2017 11:05
%%%-------------------------------------------------------------------
-module(hotfix13).
-author("lzx").
-include("common.hrl").
-include("player_mask.hrl").
-include("daily.hrl").
-include("dvip.hrl").


%% API
-compile(export_all).



single_add(Pkey) ->
    Sql = io_lib:format("SELECT  app_role_id,SUM(base_gold) FROM recharge WHERE `time` >=  1509012000 AND `time` < 1509100936 AND app_role_id = ~p", [Pkey]),
    case db:get_row(Sql) of
        [Pkey, SumGold] ->
            case misc:get_player_process(Pkey) of
                Pid when is_pid(Pid) ->
                    player:apply_state(async, Pid, {?MODULE, add_diamond, SumGold});
                _ ->
                    add_diamond_out_line(Pkey, SumGold)
            end;
        _ ->
            ok
    end.



fix_charge_diamond() ->
    case ?GLOBAL_DATA_RAM:get(fix_charge_diamond222,false) of
        false ->
            ?GLOBAL_DATA_RAM:get(fix_charge_diamond222,1),
            case db:get_all("SELECT  app_role_id,SUM(base_gold) FROM recharge WHERE `time` >=  1509012000 AND `time` < 1509030000 GROUP BY app_role_id") of
                List when is_list(List) ->
                    lists:foreach(fun([Pkey,SumGold]) ->
                        case misc:get_player_process(Pkey) of
                            Pid when is_pid(Pid) ->
                                player:apply_state(async,Pid,{?MODULE,add_diamond,SumGold});
                            _ ->
                                add_diamond_out_line(Pkey,SumGold),
                                util:sleep(1000)
                        end
                            end,List);
                _ ->
                    ok
            end;
        _ ->
            ok
    end.

%% 在线的
add_diamond(SumGold,Player) ->
    Player1 = dvip:charge(Player, SumGold),
    {ok,Player1}.




%% 不在线的
add_diamond_out_line(Pkey, AddCharge) ->
    {VipType,_} = player_mask:get_by_player_id(Pkey,?PLAYER_DVIP_STATE,{0,0}),
    LeftGold = player_mask:get_by_player_id(Pkey,?PLAYER_DVIP_CHARGE_GOLD, 0),
    AddDiamond = (AddCharge + LeftGold) div 10,
    case VipType > 0 of
        true ->
            DiaMondNum = daily:get_count_outline(Pkey,?DAILY_DVIP_DIAMOND, 0),
            daily:set_count_outline(Pkey,?DAILY_DVIP_DIAMOND, DiaMondNum + AddDiamond),
            LfGold2 = LeftGold + AddCharge - AddDiamond * 10,
            player_mask:set_by_player_id(Pkey,?PLAYER_DVIP_CHARGE_GOLD, LfGold2);
        _ -> ok
    end,
    case VipType == 1 of
        true ->
            {LastTime, ContineTime} = player_mask:get_by_player_id(Pkey,?PLAYER_DIVIP_SIGN_UP_MASK, {0, 0}),
            NowTime = util:unixtime(),
            case util:is_same_date(LastTime, NowTime) of
                true ->
                    NewC = ContineTime;
                false ->
                    case util:is_same_date(LastTime + ?ONE_DAY_SECONDS, NowTime) of
                        true ->
                            NewC = ContineTime + 1,
                            player_mask:set_by_player_id(Pkey,?PLAYER_DIVIP_SIGN_UP_MASK, {NowTime, NewC});
                        _ ->
                            NewC = 1,
                            player_mask:set_by_player_id(Pkey,?PLAYER_DIVIP_SIGN_UP_MASK, {NowTime, 1})
                    end
            end,
            ChargeVal = player_mask:get_by_player_id(Pkey,?PLAYER_DVIP_CHARGE, 0),
            NewCharge = ChargeVal + AddCharge,
            player_mask:set_by_player_id(Pkey,?PLAYER_DVIP_CHARGE, NewCharge),
            case NewCharge >= ?DVIP_CHARGE_TOTAL orelse NewC >= ?DVIP_CHARGE_DAY of
                true ->
                    player_mask:set_by_player_id(Pkey,?PLAYER_DVIP_STATE, {2, 0}),
                    dvip_log:log_dvip(Pkey, 2),
                    ok;
                _ ->
                    ok
            end;
        _ ->
            ok
    end.


%% 获取修复信息的玩家
get_fix_player_info() ->
    case db:get_all("SELECT  app_role_id,nickname,SUM(base_gold) FROM recharge WHERE `time` >=  1509012000 AND `time` < 1509030000 GROUP BY app_role_id") of
        List when is_list(List) ->
            FileName = io_lib:format("../diamond_~w.txt", [config:get_server_num()]),
            {ok, S} = file:open(FileName, write),
            lists:foreach(fun([Pkey, NickName, ChargeTotal]) ->
                {VipType, _} = player_mask:get_by_player_id(Pkey, ?PLAYER_DVIP_STATE, {0, 0}),
                case VipType > 0 of
                    true ->
                        io:format(S, "~w      ~s     ~w    ~n", [Pkey, bitstring_to_list(NickName), ChargeTotal]);
                    _ ->
                        ok
                end
                          end, List),
            file:close(S);
        _ ->
            ok
    end.






















