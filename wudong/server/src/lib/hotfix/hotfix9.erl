%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 九月 2017 21:50
%%%-------------------------------------------------------------------
-module(hotfix9).
-include("common.hrl").
-include("server.hrl").

%% API
-export([back_goods/0]).

%%  玩家ID
get_ids() ->
    [
        250600056,
        350800596,
        252600030,
        252500873,
        252601745,
        253301120,
        252600104,
        254200041,
        253000201,
        350800377,
        250601119,
        253002160,
        252500951,
        252500036,
        252900972,
        251700772,
        253300338,
        253300792,
        252901737,
        251202072,
        800300608,
        253000124,
        254101593,
        251803156,
        200100456,
        251900226,
        250601330,
        250102927,
        250101581,
        251202945,
        250301215,
        253301458,
        250103613,
        250103094,
        251700196,
        252501764,
        253302844,
        250500403,
        253302392,
        150300065,
        252600062,
        350100118,
        200101282,
        350100063,
        251701165,
        350101666,
        251400855,
        351001751,
        251601917,
        250103170
    ].



get_back_goods_id() -> [6602008,4103015,1015001,2014001,20340,8001054,2003000].

%%

mail_content() ->
    Title = ?T("数据回收道具补偿邮件2"),
    Content = ?T("亲爱的仙友，由于“活动中积分兑换”BUG导致玩家道具获取过多，现已进行数据回收，回收还在进行中。这是您回收时损失的道具，特此返还。祝您游戏愉快"),
    {Title,Content}.


back_mail_content() ->
    Title = ?T("邮件数据错误补偿"),
    Content = ?T("亲爱的仙友，由于15日晚上23点邮件数据错误导致道具获取过多，现已进行数据回收，对您造成不便敬请谅解，特此发放补偿福利。祝您游戏愉快。"),
    BackGoods = [{10106,1000},{10101,200000},{8001054,60}],
    {Title,Content,BackGoods}.




back_goods() ->
    IdPlayers = get_ids(),
    SaveIds =
        lists:foldl(fun(PlayerId,AccList2) ->
            BackGoodsId = get_back_goods_id(),
            NewAccList2 =
                lists:foldl(fun(BackId, AccList) ->
                    Sql = io_lib:format("SELECT goods_id,create_num FROM log_goods_use WHERE pkey = ~w AND goods_id = ~w AND `time` > 1505448000 AND `time` < 1505451600", [PlayerId, BackId]),
                    case db:get_all(Sql) of
                        List when is_list(List) ->
                            BackList2 = [{GoodsId, GoodsNum} || [GoodsId, GoodsNum] <- List],
                            BackList22 = goods:merge_goods(BackList2),
                            BackList22 ++ AccList;
                        _ ->
                            AccList
                    end
                            end, [], BackGoodsId),
            [{PlayerId, NewAccList2} | AccList2]
                    end, [], IdPlayers),

    lists:foreach(fun({PlayerId,BackGoodsList}) ->
        {Title2,Content2,BackGiftList} = back_mail_content(),
        mail:sys_send_mail([PlayerId], Title2, Content2, BackGiftList),
        [back_goods_to_player(PlayerId,GoodsId,GoodsNum) || {GoodsId,GoodsNum} <- BackGoodsList]
        end,SaveIds).



back_goods_to_player(PlayerId,GoodsId,MailNum) ->
    Sql = io_lib:format("SELECT goods_id,create_num FROM log_goods_create WHERE pkey = ~w AND goods_id = ~w AND `time` > 1505452200  AND `time` < 1505655300 ", [PlayerId, GoodsId]),
    case db:get_all(Sql) of
        List when is_list(List) ->
            BackList2 = [{GoodsId2,GoodsNum} ||[GoodsId2,GoodsNum] <- List],
            case goods:merge_goods(BackList2) of
                [{_,SumNum}|_] -> ok;
                _ -> SumNum = 0
            end;
        _ ->
            SumNum = 0
    end,
    BackNum = SumNum - MailNum,
    ?ERR("back to player num ~w ~w ~w",[PlayerId,GoodsId,BackNum]),
    case BackNum > 0 of
        true ->
            {Title,Content} = mail_content(),
            mail:sys_send_mail([PlayerId], Title, Content, [{GoodsId, BackNum}]);
        _ ->
            skip
    end.










