%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 邮件
%%% @end
%%% Created : 21. 一月 2015 下午12:00
%%%-------------------------------------------------------------------
-module(mail).
-author("fancy").

-include("mail.hrl").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").

%% API
-export([
    check_mail_state/0,
    get_mail_list/1,
    get_mail_content/2,
    delete_mail/2,
    delete_mail_all/1,
    sys_send_mail/3,
    sys_send_mail/4,
    sys_send_type_mail/5,
    get_mail_goods/2,
    get_mail_goods_all/1,
    add_dict_mail/1
]).

-export([
    gm_all/1,
    mail_all/3
]).

%%查询是否有未读邮件
check_mail_state() ->
    F = fun(Mail) ->
        Mail#mail.state == 0
        end,
    case lists:any(F, priv_get_mail_list()) of
        true -> 1;
        false -> 0
    end.
%%获取邮件列表
get_mail_list(Player) ->
    MailList = priv_get_mail_list(),
    F = fun(Mail) ->
        Attachement = ?IF_ELSE(Mail#mail.goodslist /= [], 1, 0),
        [
            Mail#mail.mkey, Mail#mail.type, Mail#mail.title, Mail#mail.time, Mail#mail.state, Attachement
        ]
        end,
    MailSubInfo = lists:map(F, MailList),
    {ok, Bin} = pt_190:write(19001, {MailSubInfo}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%获取邮件内容
get_mail_content(Player, Mkey) ->
    MailList = priv_get_mail_list(),
    case lists:keytake(Mkey, #mail.mkey, MailList) of
        false ->
            ?PRINT("MKEY NOT EXISTS !~p~n", [Mkey]),
            skip;
        {value, Mail, T} ->
            GoodsList = parse_goods_list(Mail#mail.goodslist),
            OverTime = max(0, Mail#mail.overtime - util:unixtime()),
            {ok, Bin} = pt_190:write(19002, {Mail#mail.mkey, Mail#mail.type, Mail#mail.title, Mail#mail.content, Mail#mail.time, OverTime, GoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            if Mail#mail.state == ?MAIL_STATE_UNREAD ->
                NewMail = Mail#mail{state = ?MAIL_STATE_READ},
                mail_load:dbup_mail_state(Mkey, ?MAIL_STATE_READ),
                priv_update_mail_list([NewMail | T]),
                activity:get_notice(Player, [73], true),
                ok;
                true ->
                    ok
            end
    end.

parse_goods_list(GoodsList) ->
    F = fun(Item) ->
        case Item of
            GiveGoods when is_record(GiveGoods, give_goods) ->
                {NewColor, Sex, Combat_power, FixAttrList, RandAttrList} = equip_random:parse_sell_args(GiveGoods#give_goods.args),
                FixAttrListPack = [[attribute_util:attr_tans_client(AttType), Value] || {AttType, Value} <- FixAttrList],
                RandAttrListPack = [[attribute_util:attr_tans_client(AttType), Value] || {AttType, Value} <- RandAttrList],
                [[0, GiveGoods#give_goods.goods_id, GiveGoods#give_goods.num, GiveGoods#give_goods.bind, NewColor, Sex, Combat_power, FixAttrListPack, RandAttrListPack]];
            _ -> []
        end
        end,
    lists:flatmap(F, GoodsList).

%%删除邮件
delete_mail(Player, Mkey) ->
    MailList = priv_get_mail_list(),
    case lists:keytake(Mkey, #mail.mkey, MailList) of
        false ->
            {ok, Bin} = pt_190:write(19003, {0, Mkey}),
            server_send:send_to_sid(Player#player.sid, Bin);
        {value, Mail, MailList2} ->
            if Mail#mail.type == ?MAIL_TYPE_CHARGE ->
                {ok, Bin} = pt_190:write(19003, {3, Mkey}),
                server_send:send_to_sid(Player#player.sid, Bin);
                Mail#mail.state /= ?MAIL_STATE_FETCH andalso Mail#mail.goodslist /= [] ->
                    {ok, Bin} = pt_190:write(19003, {4, Mkey}),
                    server_send:send_to_sid(Player#player.sid, Bin);
                true ->
                    mail_load:dbdelete_mail(Mkey),
                    priv_update_mail_list(MailList2),
                    {ok, Bin} = pt_190:write(19003, {1, Mkey}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    activity:get_notice(Player, [73], true)
            end
    end.

delete_mail_all(Player) ->
    F = fun(Mail, {L, KL}) ->
        if Mail#mail.type == ?MAIL_TYPE_CHARGE -> {[Mail | L], KL};
            Mail#mail.state /= ?MAIL_STATE_FETCH andalso Mail#mail.goodslist /= [] -> {[Mail | L], KL};
            true ->
                mail_load:dbdelete_mail(Mail#mail.mkey),
                {L, [Mail#mail.mkey | KL]}
        end
        end,
    {MailList, KeyList} =
        lists:foldl(F, {[], []}, priv_get_mail_list()),
    case KeyList of
        [] -> {6, KeyList};
        _ ->
            priv_update_mail_list(MailList),
            activity:get_notice(Player, [73], true),
            {1, KeyList}
    end.

%%收取邮件附件
get_mail_goods(Player, Mkey) ->
    MailList = priv_get_mail_list(),
    case lists:keytake(Mkey, #mail.mkey, MailList) of
        false ->
            throw({false, 0});
        {value, #mail{type = _MailType, goodslist = GoodsList, state = MailState, title = Title, content = Content} = Mail, T} ->
            if MailState == ?MAIL_STATE_FETCH orelse GoodsList == [] ->
                throw({false, 0});
                true ->
                    MailList2 = [Mail#mail{state = ?MAIL_STATE_FETCH} | T],
                    {ok, Player1} = goods:give_goods_throw(Player, GoodsList),
                    mail_load:dbup_mail_state(Mkey, ?MAIL_STATE_FETCH),
                    priv_update_mail_list(MailList2),
                    log_mail(Player#player.key, Player#player.nickname, 2, Mail#mail.goodslist, Title, Content),
                    {ok, Player1}
            end
    end.

%%提取全部邮件附件
get_mail_goods_all(Player) ->
    MailList = priv_get_mail_list(),
    case do_get_mail_goods_all(MailList, Player, [], []) of
        {false, Err} ->
            {Err, [], Player};
        {ok, NewPlayer, KeyList, NewMailList} ->
            priv_update_mail_list(NewMailList),
            {1, KeyList, NewPlayer}
    end.

do_get_mail_goods_all([], Player, KeyList, MailList) ->
    case KeyList /= [] of
        false ->
            {false, 5};
        true ->
            {ok, Player, KeyList, MailList}
    end;
do_get_mail_goods_all([Mail | T], Player, KeyList, MailList) ->
    if Mail#mail.state =/= ?MAIL_STATE_FETCH andalso Mail#mail.goodslist /= [] ->
        case catch goods:give_goods_throw(Player, Mail#mail.goodslist) of
            {ok, NewPlayer} ->
                NewMail = Mail#mail{state = ?MAIL_STATE_FETCH},
                mail_load:dbup_mail_state(Mail#mail.mkey, ?MAIL_STATE_FETCH),
                log_mail(Player#player.key, Player#player.nickname, 2, Mail#mail.goodslist, Mail#mail.title, Mail#mail.content),
                do_get_mail_goods_all(T, NewPlayer, [Mail#mail.mkey | KeyList], [NewMail | MailList]);
            _ ->
                case KeyList /= [] of
                    false ->
                        {false, 2};
                    true ->
                        {ok, Player, KeyList, MailList}
                end
        end;
        true ->
            do_get_mail_goods_all(T, Player, KeyList, [Mail | MailList])
    end.


%%系统发送邮件
%% keylist = [pkey]

sys_send_mail(Klist, Title, Content) ->
    sys_send_mail(Klist, Title, Content, [], 0).

sys_send_mail(Klist, Title, Content, GoodsList) ->
    sys_send_mail(Klist, Title, Content, GoodsList, 0).

sys_send_type_mail(Klist, Title, Content, GoodsList, MailType) ->
    sys_send_mail(Klist, Title, Content, GoodsList, MailType).

sys_send_mail(Klist, Title, Content, GoodsList, MailType) ->
    F = fun(Key, [MailSqlList, MailList]) ->
        {MailSql, Mail} = batch_insert_mail(MailType, Key, Title, Content, GoodsList),
        [[MailSql | MailSqlList], [Mail | MailList]]
        end,
    [SqlList, Mails] = lists:foldl(F, [[], []], Klist),
    F2 = fun(M) ->
        case player_util:get_player_online(M#mail.pkey) of
            [] -> skip;
            PlayerOnline ->
                PlayerOnline#ets_online.pid ! {insert_mail, M}
        end
         end,
    spawn(fun() ->
        lists:foreach(F2, Mails),
        batch_insert_db(SqlList)
          end),
    ok.


%%更新邮件
add_dict_mail(Mail) ->
    MailList = priv_get_mail_list(),
    priv_update_mail_list([Mail | MailList]).

%% -------private funcionts  -----------
priv_get_mail_list() ->
    lib_dict:get(?PROC_STATUS_MAIL).

priv_update_mail_list(MailList) ->
    lib_dict:put(?PROC_STATUS_MAIL, MailList).

batch_insert_mail(MailType, Key, Title, Content, GoodsList) ->
    Mkey = misc:unique_key(),
    Now = util:unixtime(),
    OverTime = ?IF_ELSE(MailType == ?MAIL_TYPE_CHARGE, Now + ?ONE_DAY_SECONDS * 15, Now + ?ONE_DAY_SECONDS * 7),
    State = 0,
    NewGoodsList = goods:make_give_goods_list(53, GoodsList),
    GoodsListBin = mail_init:give_goods_to_list(NewGoodsList),
    MailSql = mail_load:dbinsert_mail_sql(Mkey, Key, MailType, GoodsListBin, Title, Content, Now, State, OverTime),
    Mail = #mail{
        type = MailType,
        mkey = Mkey,
        pkey = Key,
        title = Title,
        content = Content,
        time = Now,
        overtime = OverTime,
        goodslist = NewGoodsList
    },
    log_mail_add(Key, NewGoodsList, Title, Content),
    {MailSql, Mail}.

batch_insert_db([]) -> ok;
batch_insert_db(SqlList) ->
    R = util:rand(1, 5),
    timer:sleep(1000 * R),
    case length(SqlList) > 100 of
        true ->
            {SqlList1, SqlList2} = lists:split(100, SqlList),
            Sqls = string:join(SqlList1, ";"),
            ?DO_IF(Sqls /= [], db:execute(Sqls)),
            batch_insert_db(SqlList2);
        false ->
            Sqls = string:join(SqlList, ";"),
            ?DO_IF(Sqls /= [], db:execute(Sqls))
    end.


%%全服邮件
gm_all(Id) ->
    Sql = io_lib:format("select id ,type,title,content,goodslist,lv_s,lv_e,reg_time_s,reg_time_e,login_time_s,login_time_e,game_channel_id from mail_adm where id = ~p and state = 1 ", [Id]),
    case db:get_row(Sql) of
        [] ->
            skip;
        Row ->
            [Id, Type, _Title, _Content, _GoodsList, Lv_s, Lv_e, Reg_time_s, Reg_time_e, Login_time_s, Login_time_e, Game_channel_id] = Row,
            Now = util:unixtime(),
            MaxTime = Now - 86400 * 30,
            Where = io_lib:format(" where pl.last_login_time > ~p ", [MaxTime]),
            if
                Type == 2 ->
                    Where2 = ?IF_ELSE(Lv_s > 0, io_lib:format("~s and ps.lv >= ~p", [Where, Lv_s]), Where),
                    Where3 = ?IF_ELSE(Lv_e > 0, io_lib:format("~s and ps.lv <= ~p", [Where2, Lv_e]), Where2),
                    Where4 = ?IF_ELSE(Reg_time_s > 0, io_lib:format("~s and pl.reg_time > ~p", [Where3, Reg_time_s]), Where3),
                    Where5 = ?IF_ELSE(Reg_time_e > 0, io_lib:format("~s and pl.reg_time < ~p", [Where4, Reg_time_e]), Where4),
                    Where6 = ?IF_ELSE(Login_time_s > 0, io_lib:format("~s and pl.last_login_time > ~p", [Where5, Login_time_s]), Where5),
                    Where7 = ?IF_ELSE(Login_time_e > 0, io_lib:format("~s and pl.last_login_time < ~p", [Where6, Login_time_e]), Where6),
                    Where8 = ?IF_ELSE(Game_channel_id > 0, io_lib:format("~s and pl.game_channel_id = ~p", [Where7, Game_channel_id]), Where7),
                    gm_all(0, Row, Where8);
                Type == 1 ->
                    gm_all(0, Row, Where)
            end

    end.
gm_all(Start, Row, Where) ->
    Num = 100,
    [Id, _Type, Title, Content, GoodsList | _] = Row,
    Sql = io_lib:format("select pl.pkey from player_login pl left join player_state ps on pl.pkey = ps.pkey  ~s order by pl.pkey asc limit ~p ,~p ", [Where, Start, Num]),
    L = db:get_all(Sql),
    Keys = lists:flatten(L),
    sys_send_mail(Keys, Title, Content, util:bitstring_to_term(GoodsList), _Type),
    End = Start + Num,
    timer:sleep(2000),
    case L of
        [] ->
            db:execute(io_lib:format("update mail_adm set state = 2 where id = ~p", [Id])),
            ok;
        _ -> gm_all(End, Row, Where)
    end.


log_mail_add(_Pkey, [], _, _) ->
    ok;
log_mail_add(Pkey, GoodsList, Title, Content) ->
    Name = shadow_proc:get_name(Pkey),
    log_mail(Pkey, Name, 1, GoodsList, Title, Content).


log_mail(Pkey, NickName, Type, GoodsList, Title, Content) ->
    Sql = io_lib:format("insert into log_mail set pkey=~p,nickname = '~s' ,type =~p,goods = '~s',time=~p,title = '~s',content = '~s'",
        [Pkey, NickName, Type, util:term_to_bitstring(pack_goods_list(GoodsList)), util:unixtime(), Title, Content]),
    log_proc:log(Sql).

pack_goods_list(GoodsList) ->
    F = fun(GiveGoods) ->
        {GiveGoods#give_goods.goods_id, GiveGoods#give_goods.num}
        end,
    lists:map(F, GoodsList).

mail_all(Title, Content, GoodsList) ->
    Sql = io_lib:format("select pkey from player_login where last_login_time > ~p", [util:unixtime() - ?ONE_DAY_SECONDS * 10]),
    L = db:get_all(Sql),
    Keys = lists:flatten(L),
    spawn(fun() -> mail_all_loop(Keys, Title, Content, GoodsList) end),
    ok.


mail_all_loop([], _Title, _Content, _GoodsList) ->
    ok;
mail_all_loop(KeyList, Title, Content, GoodsList) ->
    Num = 100,
    case lists:sublist(KeyList, Num) of
        [] -> ok;
        FetchList ->
            sys_send_mail(FetchList, Title, Content, GoodsList),
            timer:sleep(2000),
            mail_all_loop(KeyList--FetchList, Title, Content, GoodsList)
    end.
