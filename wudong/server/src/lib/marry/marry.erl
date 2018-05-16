%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 七月 2016 上午11:46
%%%-------------------------------------------------------------------
-module(marry).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("marry.hrl").
-include("team.hrl").
-include("scene.hrl").
-include("g_daily.hrl").

-export([
    init/1
    , marry_info/1
    , marry_data/0
    , marry_request/3
    , marry_answer/4
    , divorce/1

    , gm_marry_answer/3
    , gm_divorce/1
    , marry_fireworks/1
    , get_attr/1
]).

%%初始化玩家婚姻信息
init(Player) ->
    if Player#player.marry#marry.mkey == 0 -> Player;
        true ->
            case ets:lookup(?ETS_MARRY, Player#player.marry#marry.mkey) of
                [] ->
                    marry_load:update_marry_key(Player#player.key, 0),
                    Player#player{marry = #marry{}};
                [StMarry] ->
                    Marry = Player#player.marry,
                    Key = ?IF_ELSE(Player#player.key == StMarry#st_marry.key_boy, StMarry#st_marry.key_girl, StMarry#st_marry.key_boy),
                    Sex = ?IF_ELSE(Player#player.key == StMarry#st_marry.key_boy, 2, 1),
                    Shadow = shadow_proc:get_shadow(Key),
                    NewMarry = Marry#marry{marry_type = StMarry#st_marry.type, couple_key = Key, couple_name = Shadow#player.nickname, couple_sex = Sex},
                    Player#player{marry = NewMarry}
            end
    end.

%%婚姻信息
marry_info(Player) ->
    if Player#player.marry#marry.mkey == 0 ->

        {DesId, Des_Percent} = marry_designation:get_marry_designation(),
        LoveStage = marry_heart:get_my_heart_lv(),
        RingLv = marry_ring:get_my_ring_lv(),
        BabyBornTime = baby_util:get_born_time(Player),
        {0, Player#player.marry#marry.mkey, 0, <<>>, 0, 0, 0, 0, 0, 0, 0, DesId, Des_Percent, 0, LoveStage, 0, RingLv, 0, BabyBornTime};
        true ->
            MyBox = marry_gift:get_state(),
            CoupleBox = marry_gift:get_ta_state(Player#player.marry#marry.couple_key),
            {DesId, Des_Percent} = marry_designation:get_marry_designation(),
            Close = relation:get_friend_qmd(Player#player.marry#marry.couple_key),
            LoveStage = marry_heart:get_my_heart_lv(),
            LoveLv = 0,
            RingLv = marry_ring:get_my_ring_lv(),
            TreeLv = marry_tree:get_marry_tree_lv(),
            Shadow = shadow_proc:get_shadow(Player#player.marry#marry.couple_key),
            BabyBornTime = baby_util:get_born_time(Player),
            {1,
                Player#player.marry#marry.mkey,
                Player#player.marry#marry.couple_key,
                Shadow#player.nickname,
                Shadow#player.career,
                Shadow#player.sex,
                Shadow#player.avatar,
                Shadow#player.fashion#fashion_figure.fashion_cloth_id,
                Shadow#player.fashion#fashion_figure.fashion_head_id,
                MyBox, CoupleBox, DesId, Des_Percent, Close, LoveStage, LoveLv, RingLv, TreeLv, BabyBornTime
            }
    end.

%%结婚配置
marry_data() ->
    F = fun(Type) ->
        Base = data_marry:get(Type),
        {PriceType, Price} =
            case Base#base_marry.price of
                {bgold, Gold} -> {1, Gold};
                {_, Gold} -> {2, Gold}
            end,
        [Base#base_marry.type, PriceType, Price, Base#base_marry.close, Base#base_marry.cruise, goods:pack_goods(Base#base_marry.goods_list)]
        end,
    lists:map(F, data_marry:get_all()).

%%结婚请求
marry_request(Player, Type, Pkey) ->
    if Player#player.marry#marry.mkey /= 0 ->
        request_married(Player, Type, Pkey);
        true ->
            request_single(Player, Type, Pkey)
    end.


request_single(Player, Type, Pkey) ->
    MarryLv = ?MARRY_LV,
    if
        Player#player.team_key == 0 -> 3;
        Player#player.lv < MarryLv -> 40;
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> 42;
                true ->
                    case check_team(Player, Pkey) of
                        {false, Err} -> Err;
                        true ->
                            case player_util:get_player(Pkey) of
                                [] -> 5;
                                Role ->
                                    case scene:is_normal_scene(Role#player.scene) of
                                        false -> 43;
                                        true ->
                                            if Role#player.sex == Player#player.sex -> 6;
                                                Role#player.marry#marry.mkey /= 0 -> 11;
                                                Role#player.lv < MarryLv -> 41;
                                                true ->
                                                    case data_marry:get(Type) of
                                                        [] -> 7;
                                                        Base ->
                                                            case check_qmd(Pkey, Base#base_marry.close) of
                                                                {false, Err} -> Err;
                                                                true ->
                                                                    case check_price(Player, Base#base_marry.price) of
                                                                        false -> 9;
                                                                        true ->
                                                                            {ok, Bin} = pt_288:write(28804, {Type, Player#player.key, Player#player.nickname}),
                                                                            server_send:send_to_sid(Role#player.sid, Bin),
                                                                            1
                                                                    end
                                                            end
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.

request_married(Player, Type, Pkey) ->
    MarryLv = ?MARRY_LV,
    if
        Player#player.team_key == 0 -> 3;
        Player#player.lv < MarryLv -> 40;
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> 42;
                true ->
                    case check_team(Player, Pkey) of
                        {false, Err} -> Err;
                        true ->
                            case player_util:get_player(Pkey) of
                                [] -> 5;
                                Role ->
                                    case scene:is_normal_scene(Role#player.scene) of
                                        false -> 43;
                                        true ->
                                            if Role#player.sex == Player#player.sex -> 6;
                                                Role#player.marry#marry.mkey /= Player#player.marry#marry.mkey -> 46;
                                                Role#player.lv < MarryLv -> 41;
                                                true ->
                                                    case data_marry:get(Type) of
                                                        [] -> 7;
                                                        Base ->
                                                            case check_qmd(Pkey, Base#base_marry.close) of
                                                                {false, Err} -> Err;
                                                                true ->
                                                                    case check_price(Player, Base#base_marry.price) of
                                                                        false -> 9;
                                                                        true ->
                                                                            {ok, Bin} = pt_288:write(28804, {Type, Player#player.key, Player#player.nickname}),
                                                                            server_send:send_to_sid(Role#player.sid, Bin),
                                                                            1
                                                                    end
                                                            end
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.
%%检查组队
check_team(Player, Pkey) ->
    TeamMbs = team_util:get_team_mbs(Player#player.team_key),
    case length(TeamMbs) == 2 of
        false -> {false, 4};
        true ->
            case lists:keymember(Pkey, #t_mb.pkey, TeamMbs) of
                false -> {false, 3};
                true ->
                    true
            end
    end.

%%检查亲密度
check_qmd(Pkey, QmdNeed) ->
    Close = relation:get_friend_qmd(Pkey),
    if QmdNeed > Close -> {false, 8};
        true ->
            true
    end.

%%检查价格
check_price(Player, {PriceType, Price}) ->
    money:is_enough(Player, Price, PriceType).

gm_marry_answer(Player, Type, Pkey) ->
    Base = data_marry:get(Type),
    Role = player_util:get_player(Pkey),
    do_marry(Player, Role, Base, Type),
    ok.

%%结婚请求应答
marry_answer(1, Player, Type, Pkey) ->
    if Player#player.marry#marry.mkey /= 0 ->
        marry_answer_married(Player, Type, Pkey);
        true ->
            marry_answer_single(Player, Type, Pkey)
    end;
marry_answer(_2, _Player, _Type, Pkey) ->
    {ok, Bin} = pt_288:write(28805, {10}),
    server_send:send_to_key(Pkey, Bin),
    1.


marry_answer_single(Player, Type, Pkey) ->
    MarryLv = ?MARRY_LV,
    if Player#player.marry#marry.mkey /= 0 -> 2;
        Player#player.team_key == 0 -> 3;
        Player#player.lv < MarryLv -> 40;
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> 42;
                true ->
                    case check_team(Player, Pkey) of
                        {false, Err} -> Err;
                        true ->
                            case player_util:get_player(Pkey) of
                                [] -> 5;
                                Role ->
                                    case scene:is_normal_scene(Role#player.scene) of
                                        false -> 43;
                                        true ->
                                            if Role#player.sex == Player#player.sex -> 6;
                                                Role#player.marry#marry.mkey /= 0 -> 11;
                                                Role#player.lv < MarryLv -> 41;
                                                true ->
                                                    case data_marry:get(Type) of
                                                        [] -> 7;
                                                        Base ->
                                                            case check_qmd(Pkey, Base#base_marry.close) of
                                                                {false, Err} -> Err;
                                                                true ->
                                                                    case cost_gold(Role, Base#base_marry.price) of
                                                                        false -> 12;
                                                                        true ->
                                                                            do_marry(Player, Role, Base, Type),
                                                                            1
                                                                    end
                                                            end
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.

marry_answer_married(Player, Type, Pkey) ->
    MarryLv = ?MARRY_LV,
    if
        Player#player.team_key == 0 -> 3;
        Player#player.lv < MarryLv -> 40;
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> 42;
                true ->
                    case check_team(Player, Pkey) of
                        {false, Err} -> Err;
                        true ->
                            case player_util:get_player(Pkey) of
                                [] -> 5;
                                Role ->
                                    case scene:is_normal_scene(Role#player.scene) of
                                        false -> 43;
                                        true ->
                                            if Role#player.sex == Player#player.sex -> 6;
                                                Role#player.marry#marry.mkey /= Player#player.marry#marry.mkey -> 46;
                                                Role#player.lv < MarryLv -> 41;
                                                true ->
                                                    case data_marry:get(Type) of
                                                        [] -> 7;
                                                        Base ->
                                                            case check_qmd(Pkey, Base#base_marry.close) of
                                                                {false, Err} -> Err;
                                                                true ->
                                                                    case cost_gold(Role, Base#base_marry.price) of
                                                                        false -> 12;
                                                                        true ->
                                                                            do_marry_repeat(Player, Role, Base, Type)
                                                                    end
                                                            end
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.

do_marry(Player, Role, Base, Type) ->
    Mkey = misc:unique_key(),
    KeyBoy = ?IF_ELSE(Player#player.sex == 1, Player#player.key, Role#player.key),
    KeyGirl = ?IF_ELSE(Player#player.sex == 2, Player#player.key, Role#player.key),
    HeartLv = marry_heart:db_get_heart_lv(Player#player.key, Role#player.key),
    RingLv = marry_ring:db_get_ring_lv(Player#player.key, Role#player.key),
    StMarry =
        #st_marry{
            mkey = Mkey,
            type = Base#base_marry.type,
            key_boy = KeyBoy,
            key_girl = KeyGirl,
            time = util:unixtime(),
            heart_lv = HeartLv,
            ring_lv = RingLv,
            cruise_num = ?IF_ELSE(Base#base_marry.type == 3, 1, 0)
        },
    ets:insert(?ETS_MARRY, StMarry),
    marry_load:replace_marry(StMarry),
    ?DO_IF(Type == 2 orelse Type == 3, marry_rank:marry_trigger(Player, Role)),
    update_marry(Player#player.pid, Role, Base#base_marry.type, Mkey),
    update_marry(Role#player.pid, Player, Base#base_marry.type, Mkey),
    give_goods([Player, Role], Base#base_marry.goods_list),
    marry_room:marry_update(Player, Role#player.key),
    DailyAcc = g_daily:increment(?G_DAILY_MARRY),
    notice_sys:add_notice(marry, [Role, Player, DailyAcc + 1]),
    marry_load:log_marry(1, Player#player.key, Player#player.nickname, Role#player.key, Role#player.nickname, Type),
    1.

do_marry_repeat(Player, Role, Base, Type) ->
    case ets:lookup(?ETS_MARRY, Player#player.marry#marry.mkey) of
        [] -> 0;
        [StMarry] ->
            Times = ?IF_ELSE(Base#base_marry.type == 3, 1, 0),
            NewStMarry =
                StMarry#st_marry{
                    type = Base#base_marry.type,
                    time = util:unixtime(),
                    cruise_num = StMarry#st_marry.cruise_num + Times
                },
            ets:insert(?ETS_MARRY, NewStMarry),
            marry_load:replace_marry(NewStMarry),
            ?DO_IF(Type == 2 orelse Type == 3, marry_rank:marry_trigger(Player, Role)),
            update_marry(Player#player.pid, Role, Base#base_marry.type, StMarry#st_marry.mkey),
            update_marry(Role#player.pid, Player, Base#base_marry.type, StMarry#st_marry.mkey),
            give_goods([Player, Role], Base#base_marry.goods_list),
            DailyAcc = g_daily:increment(?G_DAILY_MARRY),
            notice_sys:add_notice(marry, [Role, Player, DailyAcc + 1]),
            marry_load:log_marry(1, Player#player.key, Player#player.nickname, Role#player.key, Role#player.nickname, Type),
            1
    end.

%%更新婚姻状态
update_marry(Pid, Couple, Type, Mkey) ->
    Marry = #marry{marry_type = Type, mkey = Mkey, couple_key = Couple#player.key, couple_name = Couple#player.nickname, couple_sex = Couple#player.sex},
    Pid ! {update_marry, Marry},
    ok.

give_goods(PlayerList, GoodsList) ->
    F = fun(P) -> P#player.pid ! {give_goods, GoodsList, 285} end,
    lists:foreach(F, PlayerList),
    ok.

%%结婚消费
cost_gold(Player, {PriceType, Price}) ->
    case ?CALL(Player#player.pid, {marry_cost_gold, PriceType, Price}) of
        [] -> false;
        Ret -> Ret
    end.

gm_divorce(Player) ->
    marry_room:divorce(Player),
    marry_gift:divorce(Player),
    dungeon_marry:divorce(Player),
    ets:delete(?ETS_MARRY, Player#player.marry#marry.mkey),
    Player#player.pid ! {update_marry, #marry{}},
    marry_load:del_marry(Player#player.marry#marry.mkey),
    case player_util:get_player_pid(Player#player.marry#marry.couple_key) of
        false ->
            ok;
        Pid ->
            Pid ! {update_marry, #marry{}}
    end.

%%离婚
divorce(Player) ->
    if Player#player.marry#marry.mkey == 0 -> 13;
        Player#player.marry#marry.cruise_state /= 0 -> 35;
        true ->
            case ?CALL(marry_proc:get_server_pid(), {check_cruise_state_mkey, Player#player.marry#marry.mkey}) of
                true -> 35;
                false ->
                    ets:delete(?ETS_MARRY, Player#player.marry#marry.mkey),
                    Player#player.pid ! {update_marry, #marry{}},
                    marry_load:del_marry(Player#player.marry#marry.mkey),
                    case player_util:get_player_pid(Player#player.marry#marry.couple_key) of
                        false ->
                            marry_room:divorce(Player#player.marry#marry.couple_key),
                            ok;
                        Pid ->
                            Pid ! {update_marry, #marry{}},
                            player:apply_state(async, Pid, {marry_room, divorce, []})
                    end,
                    marry_room:divorce(Player),
                    marry_gift:divorce(Player),
                    dungeon_marry:divorce(Player),
                    marry_proc:get_server_pid() ! {divorce, Player#player.marry#marry.mkey},
                    notice_sys:add_notice(divorce, [Player, #player{key = Player#player.marry#marry.mkey, nickname = Player#player.marry#marry.couple_name}]),
                    {Title, Content} = t_mail:mail_content(108),
                    mail:sys_send_mail([Player#player.marry#marry.couple_key], Title, io_lib:format(Content, [Player#player.nickname, Player#player.nickname])),
                    {Title1, Content1} = t_mail:mail_content(109),
                    mail:sys_send_mail([Player#player.key], Title1, io_lib:format(Content1, [Player#player.marry#marry.couple_name])),
                    marry_load:log_marry(2, Player#player.key, Player#player.nickname, Player#player.marry#marry.couple_key, Player#player.marry#marry.couple_name, Player#player.marry#marry.marry_type),
                    1
            end
    end.


marry_fireworks(Player) ->
    GoodsId = 7205002,
    Count = goods_util:get_goods_count(GoodsId),
    if
%%         Player#player.marry#marry.cruise_state =/= 0 -> {false, 25};
        true ->
            Base = data_cruise_act:get(8),
            PriceType = ?IF_ELSE(Base#base_cruise.price_type == 1, gold, bgold),
            if
                Count > 0 ->
                    goods:subtract_good(Player, [{GoodsId, 1}], 0),
                    {ok, Player};
                true ->
                    case money:is_enough(Player, Base#base_cruise.price, PriceType) of
                        false ->
                            {false, 9};
                        true ->
                            NewPlayer =
                                if PriceType == bgold ->
                                    money:add_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num);
                                    true ->
                                        money:add_no_bind_gold(Player, -Base#base_cruise.price, 286, Base#base_cruise.goods_id, Base#base_cruise.num)
                                end,
                            {ok, NewPlayer}
                    end
            end
    end.

get_attr(Player) ->
    AttributeMarryTree = marry_tree:get_marry_tree_attri(),
    AttributeMarryRing = marry_ring:get_attribute(),
    AttriMarryHeart = marry_heart:get_attribute(Player),
    attribute_util:sum_attribute([AttributeMarryTree, AttributeMarryRing, AttriMarryHeart]).