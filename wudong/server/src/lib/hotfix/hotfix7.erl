%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 九月 2017 18:21
%%%-------------------------------------------------------------------
-module(hotfix7).
-author("Administrator").
-include("common.hrl").

%% API
-export([fix_back_goods/0]).

%%  玩家ID
get_ids() ->
    [
    200101282,
    200100456,
    250103613,
    250101581,
    250301215,
    250601330,
    250601119,
    250600056,
    251202072,
    251601917,
    251900226,
    252501764,
    252500036,
    252500951,
    252500873,
    252600104,
    252600030,
    252900972,
    253000124,
    253002160,
    253302392,
    253302844,
    253301458,
    253300792,
    253300338,
    253301120,
    254101593,
    350100063,
    350800596
        ].



get_back_goods_id() -> [6602008,4103015,1015001,2014001,20340,8001054,2003000].


%%删物品
fix_back_goods() ->
    IdPlayers = get_ids(),
    %% 先封号
    lists:foreach(fun(Pkey) ->
        Sql = io_lib:format("update player_login set status = 1 where pkey = ~w",[Pkey]),
        db:execute(Sql),
        case misc:get_player_process(Pkey) of
            Pid when is_pid(Pid) ->
                player:stop(Pid);
            _ ->
                skip
        end
                  end,IdPlayers),

    util:sleep(2000),
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
    %% 删物品
    lists:foreach(fun({Pkey,DeleteGoodsList}) ->
        %%
        case del_mail_goods(Pkey) of
            true ->
                %%已经提取过 删物品
                ?ERR("hotfix7 delete ================= pkey:~w,goods:~w",[Pkey,DeleteGoodsList]),
                [del_goods_out_line(Pkey,GoodsId,GoodsNum) || {GoodsId,GoodsNum} <- DeleteGoodsList];
            _ ->
                []
        end
                  end,SaveIds).


%% 离线删玩家数据
del_goods_out_line(_, _, 0) ->ok;
del_goods_out_line(Pkey, GoodsId, DelGoodsNum) ->
    ?PRINT("GoodsId =========~w, GoodsNum ~w", [GoodsId, DelGoodsNum]),
    Sql = io_lib:format("select gkey,goods_id,num from goods where pkey = ~w  and goods_id = ~w", [Pkey, GoodsId]),
    Data = db:get_all(Sql),
    loop_del(DelGoodsNum, Data, Pkey).

loop_del(0, _, _) -> ok;
loop_del(_, [], _) -> ok;
loop_del(DelGoodsNum, [[Gkey, _GoodsId, GoodsNum2] | T], Pkey) ->
    case DelGoodsNum >= GoodsNum2 of
        true ->
            DeleteSql = io_lib:format("delete from goods where gkey = ~w limit 1", [Gkey]),
            db:execute(DeleteSql),
            loop_del(DelGoodsNum - GoodsNum2, T, Pkey);
        _ ->
            LeftGoods = GoodsNum2 - DelGoodsNum,
            Sql2 = io_lib:format("update goods set num = ~p where gkey = ~w", [LeftGoods, Gkey]),
            db:execute(Sql2)
    end.



%% 删除邮件
del_mail_goods(Pkey) ->
    Sql = io_lib:format("DELETE FROM mail WHERE pkey = ~w AND title = \"~s\"",[Pkey,?T("数据回收道具补偿邮件")]),
    db:execute(Sql),
    true.















