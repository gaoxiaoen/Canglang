%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% roll 点
%%% @end
%%% Created : 14. 三月 2017 下午2:54
%%%-------------------------------------------------------------------
-module(field_boss_roll).
-author("fengzhenlin").
-include("field_boss.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("skill.hrl").

%% API
-compile([export_all]).

roll_handle(LimMana, OldMana, NewMana, Der) ->
    if
        LimMana > 0 andalso OldMana == LimMana ->
            field_boss_proc:rpc_add_roll(Der#bs.key, Der#bs.mid, Der#bs.scene, Der#bs.copy);
        OldMana > 0 andalso NewMana =< 0 ->
            field_boss_roll:start_roll(Der#bs.key);
        true ->
            skip
    end,
    ok.

%%创建roll点
create_roll(Mkey, Mid, SceneId, Copy) ->
    Now = util:unixtime(),
    case ets_get_roll(Mkey) of
        [] ->
            %%1小时超时
            Ref = erlang:send_after(3600 * 1000, self(), {roll_time_end, Mkey}),
            RollId = gen_roll_id(),
            FRoll = #f_roll{
                roll_id = RollId,
                mkey = Mkey,
                mid = Mid,
                scene_id = SceneId,
                copy = Copy,
                create_time = Now,
                end_time = Now + 3600,
                end_ref = Ref,
                state = 1
            },
            ets_update_roll(FRoll);
        _ ->
            skip
    end,
    ok.


%% 客户端需求分配一个roll_id
gen_roll_id() ->
    case get(f_roll_id) of
        undefined -> RollId = 0;
        RollId -> RollId
    end,
    NewRollId = RollId + 1,
    put(f_roll_id,NewRollId),
    NewRollId.




%%开始roll
start_roll(Mkey) ->
    case ets_get_roll(Mkey) of
        [] ->
            skip;
        Roll ->
            case Roll#f_roll.state == 1 of
                true -> field_boss_proc:rpc_start_roll(Roll#f_roll.mkey);
                false -> skip
            end,
            ok
    end.

refresh_roll(Mkey) ->
    case ets_get_roll(Mkey) of
        [] ->
            skip;
        Roll ->
            util:cancel_ref([Roll#f_roll.end_ref]),
            Now = util:unixtime(),
            Ref = erlang:send_after(?ROLL_TIME * 1000, self(), {roll_time_end, Mkey}),
            FRoll = Roll#f_roll{
                create_time = Now,
                end_time = Now + ?ROLL_TIME,
                end_ref = Ref,
                state = 2
            },
            ets_update_roll(FRoll),
            notice_all(FRoll),
            ok
    end.

notice_all(Roll) ->
    #f_roll{
        hurt_list = HurtList
    } = Roll,
    MyNode = node(),
    F = fun({Pkey, Node}) ->
        case Node == MyNode orelse Node == none of
            true ->
                send_roll_notice(Pkey, Roll);
            false ->
                center:apply(Node, field_boss_roll, send_roll_notice, [Pkey, Roll])
        end
        end,
    lists:foreach(F, HurtList).

send_roll_notice(Pkey, Roll) ->
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            Online#ets_online.pid ! {apply_state, {field_boss_roll, send_roll_notice_1, Roll}}
    end.

send_roll_notice_1(Roll, Player) ->
    #f_roll{
        roll_id = RollId,
        mkey = Mkey,
        scene_id = SceneId,
        end_time = EndTime,
        roll_list = RollList
    } = Roll,
    Boss = data_field_boss:get(SceneId),
    #field_boss{
        roll_gift = GiftId
    } = Boss,
    case RollList of
        [] -> MaxPoint = 0, Name = "", MyPoint = 0;
        _ ->
            {_Pkey, _Node, MaxPoint, _Time, Name} = hd(lists:reverse(lists:keysort(3, RollList))),
            case lists:keyfind(Player#player.key, 1, RollList) of
                false -> MyPoint = 0;
                {_, _, MyPoint, _, _} -> skip
            end
    end,
    Now = util:unixtime(),
    LeaveTime = max(0, EndTime - Now),
    Data = {RollId,Mkey, GiftId, LeaveTime, MaxPoint, Name, MyPoint},
    {ok, Bin} = pt_560:write(56006, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


%%roll伤害列表
hurt_roll(Mkey, Pkey, Node) ->
    case ets_get_roll(Mkey) of
        [] -> skip;
        Roll ->
            #f_roll{
                hurt_list = HurtList
            } = Roll,
            NewHurtList = [{Pkey, Node} | lists:delete({Pkey, Node}, HurtList)],
            NewRoll = Roll#f_roll{
                hurt_list = NewHurtList
            },
            ets_update_roll(NewRoll)
    end,
    ok.

%%roll 掷骰子
player_roll(Player, Mkey) ->
    case ets_get_roll(Mkey) of
        [] ->
            case config:is_center_node() of
                true -> skip;
                false ->
                    cross_area:apply(field_boss_roll, player_roll, [Mkey, Player#player.key, Player#player.sid, Player#player.node, Player#player.nickname])
            end;
        _Roll ->
            player_roll(Mkey, Player#player.key, Player#player.sid, Player#player.node, Player#player.nickname),
            ok
    end.
player_roll(Mkey, Pkey, Sid, Node, Pname) ->
    Data =
        case ets_get_roll(Mkey) of
            [] -> {0, 0};
            Roll ->
                #f_roll{
                    roll_list = RollList
                } = Roll,
                case lists:keyfind(Pkey, 1, RollList) of
                    false ->
                        Point = util:rand(1, 100),
                        Now = util:unixtime(),
                        NewRollList = [{Pkey, Node, Point, Now, Pname} | RollList],
                        NewRoll = Roll#f_roll{
                            roll_list = NewRollList
                        },
                        ets_update_roll(NewRoll),
                        notice_all(NewRoll),
                        {1, Point};
                    _ ->
                        {0, 0}
                end
        end,
    {ok, Bin} = pt_560:write(56007, Data),
    server_send:send_to_sid(Node, Sid, Bin).
%%    case node() == Node orelse Node == none of
%%        true ->
%%            server_send:send_to_sid(Sid, Bin),
%%            ok;
%%        false ->
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
%%            ok
%%    end.

%%时间到
open_roll(Mkey) ->
    case ets_get_roll(Mkey) of
        [] -> [];
        Roll ->
            #f_roll{
                roll_list = RollList
            } = Roll,
            case RollList of
                [] -> skip;
                _ ->
                    SortList = lists:reverse(lists:keysort(3, RollList)),
                    {_, _, Point, _, _} = hd(SortList),
                    L = [{P, N, Po, T, Pn} || {P, N, Po, T, Pn} <- SortList, Po == Point],
                    L1 = lists:keysort(4, L),
                    {Pkey, Node, _, _, _} = hd(L1),
                    CurNode = node(),
                    case Node == CurNode of
                        true ->
                            do_roll_reward(Pkey, Roll);
                        false ->
                            center:apply(Node, field_boss_roll, do_roll_reward, [Pkey, Roll])
                    end
            end
    end,
    ets:delete(?ETS_FIELD_BOSS_ROLL, Mkey),
    ok.

do_roll_reward(Pkey, Roll) ->
    #f_roll{
        mid = Mid,
        scene_id = SceneId
    } = Roll,
    Boss = data_field_boss:get(SceneId),
    #field_boss{
        roll_gift = RollGift
    } = Boss,
    Mon = data_mon:get(Mid),
    Title = ?T("世界首领护盾礼包"),
    Content = io_lib:format(?T("您参与攻击~p级世界首领~s，成功获得护盾礼包奖励，请查收奖励。"), [Mon#mon.lv, Mon#mon.name]),
    mail:sys_send_mail([Pkey], Title, Content, [{RollGift, 1}]),
    Pname = shadow_proc:get_name(Pkey),
    notice_sys:add_notice(field_boss_roll, [Pname]),
    ok.

%% do_roll_reward_1(RollGift, Player) ->
%%     GiveGoodsList = goods:make_give_goods_list(509,[{RollGift,1}]),
%%     {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
%%     {ok, NewPlayer}.

ets_get_roll(Mkey) ->
    case ets:lookup(?ETS_FIELD_BOSS_ROLL, Mkey) of
        [] -> [];
        [Roll | _] -> Roll
    end.

ets_update_roll(Roll) ->
    ets:insert(?ETS_FIELD_BOSS_ROLL, Roll).