%%%-------------------------------------------------------------------
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         宝宝
%%% @end
%%%-------------------------------------------------------------------
-module(baby_util).
-author("lzx").

-include("baby.hrl").
-include("server.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("scene.hrl").
-include("marry.hrl").

%% API
-export([
    gm_create/0,
    gm_create_baby/1,
    validate_name/2,
    get_born_time/1,
    kill_mon/2,
    player_marriage/2,
    is_has_baby/1,
    check_player_marray/2,
    get_couple_lv/1,
    gm_set_baby_lv/1
]).


%% @获取宝宝出生时间
get_born_time(#player{key = _PKey}) ->
    Baby = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case Baby#baby_st.type_id > 0 of
        true ->
            0;
        false ->
            NowTime = util:unixtime(),
            case Baby#baby_st.born_time > NowTime of
                true -> Baby#baby_st.born_time - NowTime;
                false ->
                    0
            end
    end.


%% 检查玩家的
check_player_marray(#player{marry = #marry{couple_key = OldCouple}} = Player, NewMarry) ->
    if OldCouple > 0 andalso NewMarry#marry.couple_key =< 0 -> %%离婚
        player_divore(Player);
        OldCouple =< 0 andalso NewMarry#marry.couple_key > 0 -> %%结婚
            player_marriage(Player, NewMarry#marry.couple_key);
        true -> ok
    end.


%% @doc 获取夫妻关爱等级
get_couple_lv(CoupleKey) ->
    case ?GLOBAL_DATA_RAM:get(?BABY_COUPLE_LOVE_LV(CoupleKey), false) of
        false ->
            Sql = io_lib:format("select lv from baby where pkey = ~w", [CoupleKey]),
            case db:get_row(Sql) of
                [CoupleLv] ->
                    ?GLOBAL_DATA_RAM:set(?BABY_COUPLE_LOVE_LV(CoupleKey), CoupleLv),
                    CoupleLv;
                _ ->
                    0
            end;
        CoupleLv ->
            CoupleLv
    end.


%% @doc 结婚获得宝宝
player_marriage(#player{lv = Lv, marry = #marry{mkey = Mkey}} = _Player, CoupleKey) ->
    case Lv >= ?BABY_OPEN_LV of
        true ->
            OpenTime = config:get_opening_time(),
            NowTime = util:unixtime(),
            MarryTime = case ets:lookup(?ETS_MARRY, Mkey) of
                            [#st_marry{time = MarryTime0}] -> MarryTime0;
                            _ ->
                                NowTime
                        end,
            X = max(MarryTime - util:unixdate(OpenTime), 0) div 3600,
            Y = config:get_open_days(),
            ?PRINT("X:~w ============== Y:~w ========= ", [X, Y]),
            #baby_st{type_id = TypeId, born_time = MyBornTime} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
            if TypeId > 0 -> skip;
                MyBornTime > 0 ->
                    case baby_load:load_born_time(CoupleKey) of
                        BornTime when BornTime > NowTime ->
                            if MyBornTime > BornTime ->
                                NewBabySt = BabySt#baby_st{born_time = NowTime, is_change = 1},
                                lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBabySt),
                                gen_server:cast(_Player#player.pid, couple_upgrade);
                                true -> skip
                            end;
                        _ -> skip
                    end;
                true ->
                    BornTime =
                        case baby_load:load_born_time(CoupleKey) of
                            0 ->
                                NowTime + round(max((72 - X), 0) * (1 - 0.1 * max((3 - Y), 0)) * ?ONE_HOUR_SECONDS);
                            Time ->
                                if Time > NowTime -> Time;
                                    true ->
                                        NowTime + round(max((72 - X), 0) * (1 - 0.1 * max((3 - Y), 0)) * ?ONE_HOUR_SECONDS)
                                end
                        end,
                    NewBabySt = BabySt#baby_st{born_time = BornTime, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBabySt),
                    gen_server:cast(_Player#player.pid, couple_upgrade)
            end;
        false ->
            ok
    end.


%% @doc 离婚
player_divore(Player) ->
    #baby_st{type_id = TypeId, born_time = BornTime} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    NowTime = util:unixtime(),
    if TypeId > 0 orelse BornTime =< NowTime -> ok;
        true ->
            NewBabySt = BabySt#baby_st{
                born_time = 0,
                is_change = 1
            },
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBabySt),
            gen_server:cast(Player#player.pid, couple_upgrade)
    end.


%% 创造一个宝宝
gm_create() ->
    #baby_st{type_id = TypeId} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case TypeId > 0 of
        true -> skip;
        false ->
            NowTime = util:unixtime(),
            NewBabySt = BabySt#baby_st{
                born_time = NowTime + 60,
                is_change = 1
            },
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBabySt)
    end,
    ok.

%% gm create_baby
gm_create_baby(Player) ->
    #baby_st{type_id = TypeId} = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case TypeId > 0 of
        true -> skip;
        false ->
            case catch baby:create_baby(Player, 1, ?T("哈哈你好")) of
                {ok, NewPlayer} -> NewPlayer;
                _R ->
                    ?PRINT("create err ~w", [_R]),
                    Player
            end
    end.

%%
gm_set_baby_lv(NewLv) ->
    #baby_st{type_id = TypeId, pkey = Pkey} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case TypeId > 0 of
        true ->
            NewBaby = BabySt#baby_st{lv = NewLv, is_change = 1},
            ?GLOBAL_DATA_RAM:set(?BABY_COUPLE_LOVE_LV(Pkey), NewLv),
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBaby);
        false ->
            ok
    end.


%% 名字合法性检测:长度
validate_name(len, Name) ->
    Len = util:char_len(xmerl_ucs:to_unicode(Name, 'utf-8')),
    case Len < 7 andalso Len > 0 of
        true ->
            validate_name(keyword, Name);
        false ->
            %%角色名称长度为2~6个汉字
            {fail,6}
    end;


%%判断是有敏感词
validate_name(keyword, Name) ->
    case util:check_keyword(Name) of
        true ->
            {fail,32};
        false ->
            true
    end.




kill_mon(Mon, #attacker{pid = Pid}) ->
    case scene:is_normal_scene(Mon#mon.scene) of
        false -> skip;
        true ->
            player:apply_state(async, Pid, {baby, kill_mon, 1})
    end.


%% 检查是否拥有宝宝了
is_has_baby(_Player) ->
    #baby_st{type_id = TypeId, born_time = BorTime} = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    TypeId > 0 orelse BorTime > 0.


