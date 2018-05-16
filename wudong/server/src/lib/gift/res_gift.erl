%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc 资源礼包
%%%
%%% @end
%%% Created : 17. 二月 2016 13:55
%%%-------------------------------------------------------------------
-module(res_gift).
-author("hxming").

-include("lv_gift.hrl").
-include("common.hrl").
-include("server.hrl").
%% API
-export([init/1, logout/0, check_gift_state/2, get_gift/2, praise_gift/1, get_notice_state/1, set_is_get/1, get_state/1]).

-define(RES_GIFT_ID, 26101).
-define(OPEN_LV_45, 40).
-define(OPEN_LV_50, 50).
-define(OPEN_LV_60, 60).

-define(DOWN_GIFT_OPEN, 40). %%  下载资源礼包开放等级
-define(DOWN_GIFT, 1). %%  下载资源礼包
-define(DOWN_GIFT_ID, 26101). %%  下载资源礼包Id

init(Player) ->
    case player_util:is_new_role(Player) of
        true ->
            Gift = #st_res_gift{pkey = Player#player.key, is_change = 1},
            lib_dict:put(?PROC_STATUS_PLAYER_GIFT, Gift);
        false ->
            Sql = io_lib:format(<<"select gift_state,praise_gift,is_get from player_res_gift where pkey = ~p">>, [Player#player.key]),
            case db:get_row(Sql) of
                [] ->
                    Gift = #st_res_gift{pkey = Player#player.key, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PLAYER_GIFT, Gift);
                [GiftState, PraiseGift, IsGet] ->
                    Gift = #st_res_gift{
                        pkey = Player#player.key,
                        gift_state = util:bitstring_to_term(GiftState),
                        praise_gift = PraiseGift,
                        is_get = IsGet
                    },
                    lib_dict:put(?PROC_STATUS_PLAYER_GIFT, Gift)
            end
    end,
    Player.

logout() ->
    Gift = lib_dict:get(?PROC_STATUS_PLAYER_GIFT),
    if Gift#st_res_gift.is_change == 1 ->
        replace_db(Gift);
        true -> skip
    end,
    ok.

replace_db(Gift) ->
    Sql = io_lib:format("replace into player_res_gift set pkey = ~p,gift_state='~s',praise_gift =~p,is_get = ~p",
        [Gift#st_res_gift.pkey,
            util:term_to_bitstring(Gift#st_res_gift.gift_state),
            Gift#st_res_gift.praise_gift, Gift#st_res_gift.is_get]),
    db:execute(Sql).


%%检查礼包状态
check_gift_state(?DOWN_GIFT, _Player) ->
    Gift = lib_dict:get(?PROC_STATUS_PLAYER_GIFT),
    Reward0 = data_gift:get(?DOWN_GIFT),
    Reward = [tuple_to_list(X) || X <- Reward0],
    case lists:keyfind(?DOWN_GIFT, 1, Gift#st_res_gift.gift_state) of
        false -> {1, Reward};
        {?DOWN_GIFT, State} ->
            if
                State == 0 -> {1, Reward};
                true -> {2, Reward}
            end
    end;
check_gift_state(_, _) -> {0, 0}.

%%检查礼包状态
get_notice_state(Player) ->
    if Player#player.lv < ?DOWN_GIFT_OPEN -> 0;
        true ->
            Gift = lib_dict:get(?PROC_STATUS_PLAYER_GIFT),
            case lists:keyfind(?DOWN_GIFT, 1, Gift#st_res_gift.gift_state) of
                false -> 1;
                {_, 0} -> 1;
                {_, 1} -> -1
            end
    end.

%%领取礼包
get_gift(?DOWN_GIFT, Player) ->
    Gift = lib_dict:get(?PROC_STATUS_PLAYER_GIFT),
    case lists:keytake(?DOWN_GIFT, 1, Gift#st_res_gift.gift_state) of
        {value, {?DOWN_GIFT, 1}, _List0} ->
            {11, Player};
        false ->
            NewGift = Gift#st_res_gift{gift_state = [{?DOWN_GIFT, 1} | Gift#st_res_gift.gift_state],is_get = 0},
            lib_dict:put(?PROC_STATUS_PLAYER_GIFT, NewGift),
            replace_db(NewGift),
            Reward = data_gift:get(?DOWN_GIFT),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(525, Reward)),
            activity:get_notice(NewPlayer, [146], true),
            {1, NewPlayer};
        {value, {?DOWN_GIFT, 0}, List} ->
            NewGift = Gift#st_res_gift{gift_state = [{?DOWN_GIFT, 1} | List],is_get = 0},
            lib_dict:put(?PROC_STATUS_PLAYER_GIFT, NewGift),
            replace_db(NewGift),
            Reward = data_gift:get(?DOWN_GIFT),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(525, Reward)),
            activity:get_notice(NewPlayer, [146], true),
            {1, NewPlayer}
    end;
get_gift(_, Player) -> {12, Player}.


%%点赞礼包
praise_gift(Player) ->
    Gift = lib_dict:get(?PROC_STATUS_PLAYER_GIFT),
    if
        Gift#st_res_gift.praise_gift /= 0 -> ok;
        true ->
            NewGift = Gift#st_res_gift{praise_gift = 1},
            lib_dict:put(?PROC_STATUS_PLAYER_GIFT, NewGift),
            replace_db(NewGift),
            {Title, Content} = t_mail:mail_content(115),
            %%10106*100，10101*50000，3101000*5
            GoodsList = [{10106, 100}, {10101, 50000}, {3101000, 5}],
            mail:sys_send_mail([Player#player.key], Title, Content, GoodsList),
            ok
    end.

set_is_get(Player) ->
    Gift = lib_dict:get(?PROC_STATUS_PLAYER_GIFT),
    case lists:keytake(?DOWN_GIFT, 1, Gift#st_res_gift.gift_state) of
        {value, {?DOWN_GIFT, 1}, _List0} ->
            skip;
        false ->
            lib_dict:put(?PROC_STATUS_PLAYER_GIFT, Gift#st_res_gift{is_get = 1}),
            replace_db(Gift#st_res_gift{is_get = 1}),
            activity:get_notice(Player, [146], true)
    end,
    ok.

get_state(_Player) ->
    Gift = lib_dict:get(?PROC_STATUS_PLAYER_GIFT),
    Gift#st_res_gift.is_get.