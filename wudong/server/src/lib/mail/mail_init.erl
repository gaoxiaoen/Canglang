%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 一月 2015 下午1:52
%%%-------------------------------------------------------------------
-module(mail_init).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("mail.hrl").
-include("goods.hrl").
%% API
-export([init/1, give_goods_to_list/1]).

init(Player) ->
    Now = util:unixtime(),
    MailList =
        case player_util:is_new_role(Player) of
            true ->
                [];
            false ->
                case mail_load:dbget_mail(Player#player.key) of
                    [] ->
                        [];
                    MailInofList ->
                        F = fun([Mkey, PKey, Type, GoodsList, Title, Content, Time, State, OverTime]) ->
                            if OverTime < Now ->
                                mail_load:dbdelete_mail(Mkey),
                                [];
                                true ->
                                    [
                                        #mail{
                                            mkey = Mkey,
                                            pkey = PKey,
                                            type = Type,
                                            goodslist = list_to_give_goods(GoodsList),
                                            title = Title,
                                            content = Content,
                                            time = Time,
                                            state = State,
                                            overtime = OverTime
                                        }]
                            end
                            end,
                        lists:flatmap(F, MailInofList)
                end
        end,
    lib_dict:put(?PROC_STATUS_MAIL, MailList),
    Player.


give_goods_to_list(GiveGoodsList) ->
%%    FieldList = record_info(fields, give_goods),
    F = fun(GiveGoods) ->
        {GiveGoods#give_goods.goods_id,
            GiveGoods#give_goods.num,
            GiveGoods#give_goods.bind,
            GiveGoods#give_goods.from,
            GiveGoods#give_goods.expire_time,
            GiveGoods#give_goods.args}
%%        ValueList = lists:nthtail(1, tuple_to_list(GiveGoods)),
%%        lists:zipwith(fun(Key, Val) -> {Key, Val} end, FieldList, ValueList)
        end,
    util:term_to_bitstring(lists:map(F, GiveGoodsList)).

%%stringTO列表
list_to_give_goods(GoodsList) ->
%%    KVList =
%%        lists:zipwith(fun(Key, Val) ->
%%            {Key, Val} end, record_info(fields, give_goods),
%%            lists:nthtail(1, tuple_to_list(#give_goods{}))),
    F = fun(Item) ->
        case Item of
            {GoodsId, Num} ->
                %%后台邮件
                [#give_goods{goods_id = GoodsId, num = Num, from = 239}];
            {GoodsId, Num, Bind, From, ExpireTime, Args} ->
                [#give_goods{goods_id = GoodsId, num = Num, bind = Bind, from = From, expire_time = ExpireTime, args = Args}];
            _ -> []
%%                F1 = fun({Key, Val}, List) ->
%%                    case lists:keyfind(Key, 1, L) of
%%                        false ->
%%                            List ++ [Val];
%%                        {_, NewVal} ->
%%                            List ++ [NewVal]
%%                    end
%%                     end,
%%                list_to_tuple([give_goods | lists:foldl(F1, [], KVList)])
        end
        end,
    lists:flatmap(F, util:bitstring_to_term(GoodsList)).
