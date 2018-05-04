%%-------------------------------------------------------------------------
%% 邮件系统
%% @author 252563398@qq.com
%%-------------------------------------------------------------------------
-module(mail).
-export([
        send_system/2
        ,send_system/3

        ,send_system2/3
        ,send_system2/2
        
        ,send/3
        ,send2/4
        ,attach_to_bag/2
        ,get_role/1
        ,login/1
    ]
).
-include("common.hrl").
-include("role.hrl").
-include("item.hrl").
-include("storage.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("mail.hrl").
%%
-include("assets.hrl").

%%login(Role) -> ok.
login(_Role = #role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}}) ->
    case mail_dao:select_by_type2(Rid, SrvId) of 
        {ok, Data} ->
            Sign2 = [1||[_, _, _, Sign]<-Data, Sign =:= 2], %% 2为好友
            Sign3 = [1||[_, _, _, Sign]<-Data, Sign =:= 3], %% 3为军团
            Q2 = erlang:length(Sign2),
            Q3 = erlang:length(Sign3),
            case Q2 > 0 orelse Q3 > 0 of 
                true ->
                    sys_conn:pack_send(ConnPid, 11170, {[{2, Q2}, {3, Q3}]}),
                    ok;
                _ -> ok
            end;
        {false, _Reason} ->
            ?DEBUG("--mail login---~p~n", [_Reason]),
            ok
    end. 


%% 发送系统邮件
%% @spec send_system(To, MailInfo) -> ok | {false, Reason} 
%% To = [{Rid, SrvId}] | [Name] | [#role{}] | {Rid, SrvId} | Name | #role{}
%% MailInfo =  {Subject, Content, Assets, Items} | {Subject, Content}
%%   Subject = binary()
%%   Content = binary() 
%%   Assets = [tuple()]   [{资产类型, 值}]
%%   Items = [#item{}] 或 [{BaseId, Bind, Num}] 或 {BaseId, Bind, Num}
%% @doc 发送系统邮件接口
%% 由于无回滚机制，多封信件有可能出现一部分成功了，别一部分失败
send_system(To, MailInfo) ->
    % ?DEBUG("---To--~p~n~n", [To]),
    ?DEBUG("---MailInfo--~p~n~n", [MailInfo]),
    send_system(1, To, MailInfo).

send_system(_IsLog, [], _MailInfo) -> ok;
send_system(IsLog, [To | L], MailInfo) ->
    case do_send_system(IsLog, To, MailInfo) of
        ok -> send_system(IsLog, L, MailInfo);
        {false, Reason} -> {false, Reason}
    end;
send_system(IsLog, To, MailInfo) -> 
    do_send_system(IsLog, To, MailInfo).


send_system2(To, MailInfo) ->
    send_system2(1, To, MailInfo).

send_system2(_IsLog, [], _MailInfo) -> ok;
send_system2(IsLog, [To | L], MailInfo) ->
    case do_send_system2(IsLog, To, MailInfo) of
        ok -> send_system2(IsLog, L, MailInfo);
        {false, Reason} -> {false, Reason}
    end;
send_system2(IsLog, To, MailInfo) -> 
    do_send_system2(IsLog, To, MailInfo).

%% 普通邮件发送
%% @spec send(FromRole, To, MailInfo) -> {ok, NFromRole} | {false, Reason}
%% FromRole = #role{}
%% To = {Rid, SrvId}
%% MailInfo = {Subject, Content, Coin, Id}
%% Subject = binary()
%% Content = binary()
%% Coin = integer()
%% Id = integer()
%% @doc Id为-1时表示没有附件物品
send(FromRole = #role{id = {FromRid, FromSrvId}, name = FromName}, To, {Subject, Content, Coin, Id}) ->
    case get_role(To) of
        {false, Reason} -> {false, Reason};
        {ok, ToRole = #role{id = {ToRid, ToSrvId},  name = ToName}} ->
            role:send_buff_begin(),
            case do_loss(FromRole, Coin, Id) of %% 发送金币或物品 如果后面发送邮件失败则此步将不作处理
                {Label, Reason} -> 
                    role:send_buff_clean(),
                    {Label, Reason};
                {ok, NFromRole, {Assets, Items}} ->
                    case check_attach(Assets, Items) of
                        {false, Reason} -> 
                            role:send_buff_clean(),
                            {false, Reason};
                        {ok, Isatt} ->
                            Mail = #mail{
                                id = mail_mgr:get_id(), send_time = util:unixtime() %%获取唯一id以及当前时间
                                ,from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName
                                ,to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName
                                ,subject = Subject, content = Content
                                ,assets = Assets, attachment = Items, isatt = Isatt
                            },
                            case mail_dao:insert(1, Mail) of
                                {false, Reason} -> 
                                    role:send_buff_clean(),
                                    {false, Reason};
                                {ok, _} ->
                                    role:send_buff_flush(),
                                    push_info(add, ToRole, [Mail]),   %%在线则进行推送
                                    log:log(log_item_del, {Items, <<"邮件">>, <<"背包">>, FromRole}),
                                    log:log(log_coin, {<<"邮件">>, <<"">>, FromRole, NFromRole}),
                                    {ok, NFromRole}
                            end
                    end
            end
    end.

send2(FromRole=#role{id = {FromRid, FromSrvId}, name = FromName}, ToName, Content, Sign) ->
    ?DEBUG("****玩家信息[FrSrvId:~w]", ["HHHH"]),
    case get_role2(ToName) of
        {false, Reason} -> {false, Reason};
        {ok, R = #role{id = {ToRid, ToSrvId}}} ->
            Mail = #mail{
                id = mail_mgr:get_id(), send_time = util:unixtime() %%获取唯一id以及当前时间
                ,from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName
                ,to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName
                ,content = Content
            },
            ?DEBUG("****玩家信息[FrSrvId:~w]", ["HHHH"]),
            push_info2(add, R#role{name = ToName}, Mail, FromRole, Sign),   %%在线则进行推送
            {ok, FromRole}
    end.


%% 收取邮件附件到背包
%% 更新数据库成功后才算收取附件成功
attach_to_bag(Role = #role{id = {Rid, SrvId}}, Id) ->
    case mail_dao:select(Rid, SrvId, Id) of
        {false, Reason} -> {false, Reason};
        {ok, Mail = #mail{isatt = Isatt, assets = Assets, attachment = Items}} -> 
            case Isatt of
                0 -> {false, ?MSGID(<<"信件不带附件">>)};
                _ -> 
                    case do_attach_item_to_bag(Items, Role) of
                        {false, Reason} -> {false, Reason};
                        {ok, Role1} ->
                            Gs = [#gain{label = assets_type(Type), val = Val} || {Type, Val} <- Assets],
                            case role_gain:do(Gs, Role1) of
                                {false, _} -> 
                                    {false, ?MSGID(<<"收取资产数据失败">>)};
                                {ok, NRole} -> 
                                    case mail_dao:update_attach(Rid, SrvId, Id) of
                                        {false, Reason} -> 
                                            {false, Reason};
                                        {ok, _} ->
                                            %% send_inform(NRole, Assets, Items),
                                            NewMail = Mail#mail{status = 1, assets = [], attachment = []},
                                            push_info(refresh, NRole, [NewMail]), 
                                            NewRole = role_listener:get_item(NRole, Items),
                                            {ok, NewRole}
                                    end
                            end
                    end
            end
    end.

do_attach_item_to_bag([], Role) -> {ok, Role};
do_attach_item_to_bag(Items, Role) ->
    {Dress, CommonItems} = classfy(Items, [], []),
    ?DEBUG("*******  DRESS ~w", [Dress]),
    case storage:add(bag, Role, CommonItems) of  %% 这里要先处理背包
        false -> 
            {false, ?MSGID(<<"背包空间不足">>)};
        {ok, Bag1} ->
            dress:add_dress(Dress, Role#role{bag = Bag1})
    end.

classfy([], Dress, CommonItems) -> {Dress, CommonItems};
classfy([Item | T ], Dress, CommonItems) when Item#item.base_id div 1000 =:= 106 -> %% 暴露了时装
    classfy(T, Dress++[Item], CommonItems);
classfy([Item | T], Dress, CommonItems) ->
    classfy(T, Dress, CommonItems ++ [Item]).

%% 推送右下角提示信息
send_inform(#role{pid = Pid, assets = #assets{coin = OldCoin, coin_bind = OldCoinBind}}, #role{assets = #assets{coin = NewCoin, coin_bind = NewCoinBind}}, Items) ->
    CoinMsg = case OldCoin =:= NewCoin of
        true -> <<>>;
        false -> util:fbin(?L(<<"\n扣除 {str,金币,#FFD700} ~p">>), [OldCoin - NewCoin])
    end,
    BCoinMsg = case OldCoinBind =:= NewCoinBind of
        true -> <<>>;
        false -> util:fbin(?L(<<"\n扣除 {str,绑定金币,#FFD700} ~p">>), [OldCoinBind - NewCoinBind])
    end,
    ItemInfo = case Items of
        [] -> <<>>;
        _ -> util:fbin(?L(<<"\n扣除 ~s">>), [notice:item2_to_inform(Items)])
    end,
    Msg = util:fbin(?L(<<"邮件发送~s~s~s">>), [CoinMsg, BCoinMsg, ItemInfo]),
    notice:inform(Pid, Msg);
send_inform(Role = #role{pid = Pid}, Assets, []) ->
    notice:inform(Pid, ?L(<<"成功收取附件">>)),
    send_inform(Role, Assets);
send_inform(Role = #role{pid = Pid}, Assets, Items) ->
    ItemInfo = notice:item2_to_inform(Items),
    Msg = util:fbin(?L(<<"成功收取附件\n获得 ~s">>), [ItemInfo]),
    notice:inform(Pid, Msg),
    send_inform(Role, Assets).
send_inform(_Role, []) -> ok;
send_inform(Role = #role{pid = Pid}, [{Type, Val} | T]) ->
    Msg = util:fbin(?L(<<"获得 ~s ~p">>), [inform_msg(Type), Val]),
    notice:inform(Pid, Msg),
    send_inform(Role, T).

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------

%% 资产种类
% -type assets_type()     ::  0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 12 | 13 | 14.
% %%  0 ---> 金币     1 ---> 绑定金币         2 ---> 晶钻     3 ---> 绑定晶钻     4 ---> 竞技场积分   5 ---> 经验         6 ---> 灵力
% %%  7 ---> 荣誉值   8 ---> 精力(活跃度)     9 ---> 阅历值   12 ---> 传音次数    13 ---> 魅力值      14 ---> 送花积分

% %% 资产列表元素类型
% -type assets()          ::  {assets_type(), integer()}.

% %% 绑定类型
% -type bind()            ::  0 | 1.  %% 0 ---> 非绑定    1 ---> 绑定 

% %% 物品列表元素类型 base_id, bind, num
% -type itemid()          ::  {integer(), bind(), integer()}.



%% 发送系统邮件
%% 发送系统邮件成功后，如果收信人在线则推送信件给用户
%% To :: string() 玩家名字
do_send_system2(_IsLog, To, {Subject, Assets, Items}) ->
    case get_role2(To) of
        {false, Reason} -> {false, Reason};
        {ok, _R = #role{id = {ToRid, ToSrvId}}} ->
            AssetsGain = make_assets(Assets, []), 
            ItemsGain = make_items(Items, []),
            Gains = AssetsGain ++ ItemsGain,
            ?DEBUG("---mail--subject---~s~n", [Subject]),
            award:send({ToRid, ToSrvId}, 301000, Subject, Gains)
    end;

do_send_system2(_, _, _) ->
    ?ERR("信件参数不正确"),
    {false, ?L(<<"信件参数非法">>)}.


%%  2 ---> 金币        3 ---> 晶钻     4 ---> 绑定晶钻   5 ---> 龙鳞 6 --->符石
get_atom(2) -> coin;
% get_atom(1) -> coin_bind;
get_atom(3) -> gold;
get_atom(4) -> gold_bind;
get_atom(5) -> scale;
get_atom(6) -> stone;
get_atom(_) -> skip.


make_assets([], L) -> L;
make_assets([{Type, Value}|T], L) ->
    case get_atom(Type) of 
        skip ->
            make_assets(T, L);
        Label ->
            Gain = #gain{label = Label, val = Value},
            make_assets(T, [Gain] ++ L)
    end.
    
make_items([], L) -> L;
make_items([{BaseId, Bind, Quality}|T], L) ->
    Gain = #gain{label = item, val = [BaseId, Bind, Quality]},
    make_assets(T, [Gain] ++ L).
    

do_send_system(IsLog, To, {Subject, Content, Assets, Items}) when is_list(Assets) andalso is_list(Items) ->
    case get_role(To) of
        {false, Reason} -> {false, Reason};
        {ok, ToRole = #role{id = {ToRid, ToSrvId},  name = ToName}} ->
            case make_all_items(Items) of
                {false, Reason} -> {false, Reason};
                NewItems ->
                    case check_attach(Assets, NewItems) of
                        {false, Reason} -> {false, Reason};
                        {ok, Isatt} ->
                            {FromRid, FromSrvId} = ?MAIL_SYSTEM_USER(),
                            Mail = #mail{
                                id = mail_mgr:get_id(), send_time = util:unixtime()
                                ,from_rid = FromRid, from_srv_id = FromSrvId, from_name = ?L(<<"新月世界">>)
                                ,to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName
                                ,mailtype = ?MAIL_TYPE_SYS, subject = util:to_binary(Subject), content = util:to_binary(Content)
                                ,assets = Assets, attachment = NewItems, isatt = Isatt
                            },
                            case mail_dao:insert(IsLog, Mail) of
                                {false, Reason} -> {false, Reason};
                                {ok, _} ->
                                    push_info(add, ToRole, [Mail]),
                                    ok
                            end  
                    end
            end
    end;
do_send_system(IsLog, To, {Subject, Content, Assets, {BaseId, Bind, Quantity}}) ->
    case item:make(BaseId, Bind, Quantity) of 
        {ok, Items} -> do_send_system(IsLog, To, {Subject, Content, Assets, Items});
        false -> {false, ?L(<<"未知物品不能产生">>)}
    end;
do_send_system(IsLog, To, {Subject, Content, Assets, BaseId}) ->
    do_send_system(IsLog, To, {Subject, Content, Assets, {BaseId, 0, 1}});
do_send_system(IsLog, To, {Subject, Content}) ->
    do_send_system(IsLog, To, {Subject, Content, [], []});
do_send_system(_, _, _) ->
    ?ERR("信件参数不正确"),
    {false, ?L(<<"信件参数非法">>)}.

%% 生成多组物品
make_all_items(Items) ->
    make_all_items(Items, []).
make_all_items([], List) -> List;
make_all_items([{BaseId, Bind, Quantity} | T], List) ->
    case item:make(BaseId, Bind, Quantity) of 
        {ok, Items} ->
            make_all_items(T, Items ++ List);
        false ->
            {false, ?L(<<"未知物品不能产生">>)}
    end;
make_all_items([I = #item{} | T], List) ->
    make_all_items(T, [I | List]).

%% 收信人查找
%% 如果是同一角色调用则需使用参数角色记录
get_role(Role) when is_record(Role, role) -> {ok, Role};
get_role({Rid, SrvId}) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _N, R} ->
            {ok, R};
        _ -> %% 查找数据库
            case role_data:fetch_base(by_id, {Rid, SrvId}) of
                {ok, R} -> {ok, R};
                {false, _Err} -> {false, ?L(<<"收信人不存在">>)}
            end
    end;
get_role(Pid) when is_pid(Pid) ->
    case role_api:lookup(by_pid, Pid) of
        {ok, _N, R} ->
            {ok, R};
        _ ->
            {false, ?L(<<"收信人不存在">>)}
    end;
get_role(Name) ->
    case role_api:lookup(by_name, Name) of
        {ok, _N, R} ->
            {ok, R};
        _ -> %% 查找数据库
            case role_data:fetch_base(by_name, Name) of
                {ok, R} -> {ok, R};
                {false, _Err} -> {false, ?L(<<"收信人不存在">>)}
            end
    end.

get_role2(Name) ->
    case role_api:lookup(by_name, Name) of
        {ok, _N, R} ->
            {ok, R};
        _ -> %% 查找数据库
            % ?DEBUG("**get_role2查找数据库~w",["data"]),
            case sns_dao:get_role_by_name(Name) of 
                {true, [Rid, SrvId, _]} ->
                    {ok, #role{id={Rid, SrvId}}};
                {false, _} ->
                    {false, <<"玩家不存在！">>}
            end
    end.


%% 扣除发信人相关附件财产和物品
%% 先扣除但不推送结果，待发信成功后才进行推送
do_loss(Role, Coin, Id) ->
    case {loss_coin(Coin), loss_item(Role, Id)} of
        {{false, Reason}, _} -> {false, Reason};
        {_, {false, Reason}} -> {false, Reason};
        {{ok, Assets, L1}, {ok, Items, L2}} -> 
            case role_gain:do(L1 ++ L2, Role) of
                {ok, NewRole} -> 
                    send_inform(Role, NewRole, Items),%% 推送右下角消息
                    {ok, NewRole, {Assets, Items}};
                {false, #loss{label = coin, msg = Reason}} ->
                    {coin, Reason};
                {false, #loss{label = coin_all, msg = Reason}} ->
                    {coin, Reason};
                {false, #loss{msg = Reason}} -> 
                    {false, Reason}
            end
    end.

%% 扣除金币
loss_coin(Coin) when Coin < 0 ->
    {false, ?L(<<"金币输入非法">>)};
loss_coin(0) -> 
    {ok, [], [#loss{label = coin, val = 2000, msg = ?L(<<"金币不足">>)}]};
loss_coin(Coin) ->
    {ok, [{?mail_coin, Coin}], [
            #loss{label = coin, val = 2000, msg = ?L(<<"金币不足">>)}
            ,#loss{label = coin, val = Coin, msg = ?L(<<"金币不足">>)}
        ]}.

%% 查找附件物品
%% 查找到则从背包删除并返回新背包和物品 否则返回失败
loss_item(#role{bag = #bag{items = Items}}, Id) when is_integer(Id) andalso Id >= 0 ->
    case storage:find(Items, #item.id, Id) of
        {ok, #item{bind = 1}} -> {false, ?L(<<"绑定物品不能发送">>)};
        {ok, Item = #item{quantity = Q}} ->
            {ok, [Item], [#loss{label = item_id, val = [{Id, Q}]}]};
        {false, Reason} -> {false, Reason}
    end;
loss_item(_Role, _Id) -> {ok, [], []}.


%% 判断是否带附件
%% 金币和晶钻也算是附件的一种
%% 金币和晶钻不能同时发送
check_attach([], []) -> {ok, 0};
%% check_attach(_Assets, Items) when length(Items) > ?mail_max_attachment -> 
%%    {false, util:fbin(?L(<<"单次信件最多包括~p个附件">>), [?mail_max_attachment])};
check_attach(_, _) -> {ok, 1}.

%% 推送新增邮件给收信在线用户
%% 如果用户不在线则不进行推送

push_info(add, _Role = #role{link = #link{conn_pid = ConnPid}}, Mails) when is_pid(ConnPid) ->
    ?DEBUG("add[~w]", [Mails]),
    sys_conn:pack_send(ConnPid, 11702, {Mails});
push_info(refresh, _Role = #role{link = #link{conn_pid = ConnPid}}, Mails) when is_pid(ConnPid) ->
    sys_conn:pack_send(ConnPid, 11707, {Mails});
push_info(_, #role{name = _Name}, _) ->
    ?DEBUG("[~s]不在线", [_Name]),
    ok.

push_info2(add, _Role = #role{link = #link{conn_pid = ConnPid}}, Mail, _FromRole, Sign) when is_pid(ConnPid) ->
    %% ?DEBUG("add[~w]", [Mails]),
    sys_conn:pack_send(ConnPid, 11711, {[[Mail#mail.from_name, Mail#mail.content, util:unixtime(), Sign]]});

push_info2(add, #role{name = Name}, Mail,FromRole = #role{id = {FromRid, FromSrvId}}, Sign) ->
    mail_dao:insert2(1, Mail, Sign),
    ?DEBUG("[~s]不在线2", [Name]),
    case sns_dao:get_role_by_name(Name) of   %%角色不在线则修改角色中的好友列表，标识当前玩家有邮件发出给该角色
           {true, [FrRoleId, FrSrvId, _Name]} ->
                friend_dao:update_friend_mail_sign(1, FrRoleId, FrSrvId, FromRid, FromSrvId), %% 1表示有发信件
                friend:update_friend_list(msr, {FrRoleId, FrSrvId}, FromRole); %%更新陌生人列表(如果不是陌生人则不会更新)
           {false, _Reason} ->
                ?DEBUG("修改接收人好友信件标识[~s]", [_Reason])
    end.




%% 获取资产类型
assets_type(?mail_coin) -> coin;
assets_type(?mail_stone) -> stone;
assets_type(?mail_scale) -> scale;
assets_type(?mail_coin_bind) -> coin_bind;
assets_type(?mail_gold) -> gold;
assets_type(?mail_gold_bind) -> gold_bind;
assets_type(?mail_arena) -> arena;
assets_type(?mail_exp) -> exp;
assets_type(?mail_psychic) -> psychic;
%% assets_type(?mail_honor) -> honor;
assets_type(?mail_activity) -> activity;
assets_type(?mail_attainment) -> attainment;
%% assets_type(?mail_hearsay) -> hearsay;
assets_type(?mail_charm) -> charm;
assets_type(?mail_flower) -> flower;
assets_type(?mail_guild_war) -> guild_war;
assets_type(?mail_guild_devote) -> guild_devote;
assets_type(?mail_career_devote) -> career_devote;
assets_type(?mail_lilian) -> lilian;
assets_type(?mail_practice) -> practice;
assets_type(?mail_soul) -> soul;
assets_type(_Type) ->
    ?DEBUG("不支持的信件资产附件类型:~p", [_Type]),
    false.

inform_msg(?mail_coin) -> ?L(<<"{str,金币,#FFD700}">>);
inform_msg(?mail_coin_bind) -> ?L(<<"{str,绑定金币,#FFD700}">>);
inform_msg(?mail_gold) -> ?L(<<"{str,晶钻,#FFD700}">>);
inform_msg(?mail_gold_bind) -> ?L(<<"{str,绑定晶钻,#FFD700}">>);
inform_msg(?mail_arena) -> ?L(<<"{str,竞技场积分,#2fecdc}">>);
inform_msg(?mail_exp) -> ?L(<<"{str,经验,#00ff24}">>);
inform_msg(?mail_psychic) -> ?L(<<"{str,灵力,#3ad6f0}">>);
%% inform_msg(?mail_honor) -> ?L(<<"{str,荣誉,#ffe500}">>);
inform_msg(?mail_activity) -> ?L(<<"{str,精力,#b4f000}">>);
inform_msg(?mail_attainment) -> ?L(<<"{str,阅历,#f65e6a}">>);
%% inform_msg(?mail_hearsay) -> ?L(<<"{str,传音,#ffffff">>);
inform_msg(?mail_charm) -> ?L(<<"{str,魅力,#ff33cc}">>);
inform_msg(?mail_flower) -> ?L(<<"{str,送花积分,#2fecdc}">>);
inform_msg(?mail_guild_war) -> ?L(<<"{str,帮战积分,#2fecdc}">>);
inform_msg(?mail_guild_devote) -> ?L(<<"{str,帮会贡献,#2fecdc}">>);
inform_msg(?mail_career_devote) -> ?L(<<"{str,师门积分,#2fecdc}">>);
inform_msg(?mail_lilian) -> ?L(<<"{str,仙道历练,#2fecdc}">>);
inform_msg(?mail_practice) -> ?L(<<"{str,试练积分,#2fecdc}">>);
inform_msg(?mail_soul) -> ?L(<<"{str,魂气值,#2fecdc}">>);
inform_msg(?mail_hscore) -> ?L(<<"{str,捕宠达人积分,#2fecdc}">>);
inform_msg(_) -> <<>>.

