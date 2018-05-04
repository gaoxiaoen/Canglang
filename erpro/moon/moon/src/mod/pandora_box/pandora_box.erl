%% ------------------------------------
%% 梦幻宝盒系统
%% @author wpf(wprehard@qq.com)
%% @end
%% ------------------------------------
-module(pandora_box).
-behavior(gen_server).
-export([
        open/2
        ,polish/3
        ,get_item/3
        ,srv_merge/2
        ,start_link/0
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% 这2个条件你标注下在里面哈，后面有添加之类的按这个规则填
%% 1、列表不能包含 只有特殊职业才能购买 的物品
%% 2、同一个物品对于不同的职业和性别 的限制信息要一样

-record(state, {
        limits = []  %% 全服限制信息保存[#limit_state{}]
        ,roles = []  %% 角色信息列表保存[#role_pandora_box{}]
    }).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("pandora_box.hrl").
-include("gain.hrl").
-include("item.hrl").

-define(GOLD_SINGLE, 20).
-define(GOLD_BATCH, 120).

%% @doc 打开界面
open(_, #role{lev = Lev}) when Lev =< 30 ->
    {false, <<"您的等级未达30级，还不能打开梦幻宝盒">>};
open(#item{id = ItemId, special = Special}, #role{id = RoleId, name = Name, career = Career, sex = Sex, link = #link{conn_pid = ConnPid}}) ->
    case lists:keyfind(pandora_box, 1, Special) of
        {_, LuckyL} when is_list(LuckyL) ->
            L = [{BaseId, Num, Price} || #rand_base{base_id = BaseId, num = Num, price = Price} <- LuckyL],
            sys_conn:pack_send(ConnPid, 11940, {ItemId, 0, ?GOLD_SINGLE, ?GOLD_BATCH, L}),
            {ok};
        _L ->
            case ?CALL(?MODULE, {open, RoleId, Name, Career, Sex}) of
                {ok, LuckyL} ->
                    L = [{BaseId, Num, Price} || #rand_base{base_id = BaseId, num = Num, price = Price} <- LuckyL],
                    sys_conn:pack_send(ConnPid, 11940, {ItemId, 0, ?GOLD_SINGLE, ?GOLD_BATCH, L}),
                    {ok, LuckyL};
                Err ->
                    ?DEBUG("_ERR:~w", [Err]),
                    Err
            end
    end.

%% @doc 领取
get_item(Item = #item{id = ItemId, special = Special}, BaseId, Role = #role{id = RoleId, name = Name, link = #link{conn_pid = ConnPid}}) ->
    case lists:keyfind(pandora_box, 1, Special) of
        {_, LuckyL} when is_list(LuckyL) ->
            case lists:keyfind(BaseId, #rand_base.base_id, LuckyL) of
                false -> {false, ?L(<<"列表中没有此物品">>)};
                RB = #rand_base{base_id = BaseId, num = Num, price = Price, is_notice = IsNotice} ->
                    LL = [#loss{label = gold, val = Num * Price, msg = <<>>}
                        ,#loss{label = item_id, val = [{ItemId, 1}]}
                    ],
                    role:send_buff_begin(),
                    case role_gain:do(LL, Role) of
                        {false, #loss{err_code = ErrCode}} ->
                            role:send_buff_clean(),
                            {ErrCode, <<>>};
                        {ok, Role1} ->
                            GL = [#gain{label = item, val = [BaseId, 1, Num]}],
                            case role_gain:do(GL, Role1) of
                                {false, _} ->
                                    role:send_buff_clean(),
                                    {false, <<>>};
                                {ok, NewRole = #role{bag = Bag}} ->
                                    role:send_buff_flush(),
                                    case IsNotice of
                                        ?true -> broad_cast(RoleId, Name, [RB]);
                                        _ -> ignore
                                    end,
                                    NewSpecial = [{K, V} || {K, V} <- Special, K =/= pandora_box],
                                    {ok, NewBag, _} = storage_api:fresh_item(Item, Item#item{special = NewSpecial}, Bag, ConnPid),
                                    sys_conn:pack_send(ConnPid, 11940, {ItemId, 0, ?GOLD_SINGLE, ?GOLD_BATCH, []}),
                                    {ok, NewRole#role{bag = NewBag}}
                            end
                    end
            end;
        _ -> {false, ?L(<<"领取出错">>)}
    end.

%% @doc 刷新
polish(1, Item = #item{id = ItemId, special = Special}, Role = #role{id = RoleId, name = Name, career = Career, sex = Sex, link = #link{conn_pid = ConnPid}}) ->
    role:send_buff_begin(),
    LL = [#loss{label = gold, val = ?GOLD_SINGLE}],
    case role_gain:do(LL, Role) of
        {false, #loss{err_code = ErrCode}} ->
            role:send_buff_clean(),
            {ErrCode, ?L(<<"晶钻不足">>)};
        {ok, NewRole = #role{bag = Bag}} ->
            case ?CALL(?MODULE, {polish, 1, RoleId, Name, Career, Sex}) of
                {ok, LuckyL} ->
                    role:send_buff_flush(),
                    NewSpecial = [{K, V} || {K, V} <- Special, K =/= pandora_box],
                    {ok, NewBag, _} = storage_api:fresh_item(Item, Item#item{special = [{pandora_box, LuckyL} | NewSpecial]}, Bag, ConnPid),
                    L = [{BaseId, Num, Price} || #rand_base{base_id = BaseId, num = Num, price = Price} <- LuckyL],
                    sys_conn:pack_send(ConnPid, 11940, {ItemId, 0, ?GOLD_SINGLE, ?GOLD_BATCH, L}),
                    {ok, NewRole#role{bag = NewBag}};
                {false, _} ->
                    role:send_buff_clean(),
                    {false, ?L(<<"刷新梦幻宝盒出错">>)}
            end
    end;
polish(2, Item = #item{id = ItemId, special = Special}, Role = #role{id = RoleId, name = Name, career = Career, sex = Sex, link = #link{conn_pid = ConnPid}}) ->
    role:send_buff_begin(),
    LL = [#loss{label = gold, val = ?GOLD_BATCH}],
    case role_gain:do(LL, Role) of
        {false, #loss{err_code = ErrCode}} ->
            role:send_buff_clean(),
            {ErrCode, ?L(<<"晶钻不足">>)};
        {ok, NewRole = #role{bag = Bag}} ->
            case ?CALL(?MODULE, {polish, 6, RoleId, Name, Career, Sex}) of
                {ok, LuckyL} ->
                    role:send_buff_flush(),
                    NewSpecial = [{K, V} || {K, V} <- Special, K =/= pandora_box],
                    {ok, NewBag, _} = storage_api:fresh_item(Item, Item#item{special = [{pandora_box, LuckyL} | NewSpecial]}, Bag, ConnPid),
                    L = [{BaseId, Num, Price} || #rand_base{base_id = BaseId, num = Num, price = Price} <- LuckyL],
                    sys_conn:pack_send(ConnPid, 11940, {ItemId, 0, ?GOLD_SINGLE, ?GOLD_BATCH, L}),
                    {ok, NewRole#role{bag = NewBag}};
                {false, _} ->
                    role:send_buff_clean(),
                    {false, ?L(<<"刷新梦幻宝盒出错">>)}
            end
    end.

%% @doc 合服处理
srv_merge(undefined, undefined) ->
    #state{limits = [], roles = []};
srv_merge(State = #state{}, undefined) ->
    State;
srv_merge(undefined, State = #state{}) ->
    State;
srv_merge(#state{limits = L1, roles = Roles1}, #state{roles = Roles2}) ->
    %% 合服忽略全局限制的合并
    #state{limits = L1, roles = Roles1 ++ Roles2}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ---------------------------------------------------------------
%% 内部回调
%% ---------------------------------------------------------------

init([]) ->
    ?INFO("正在启动..."),
    erlang:send_after(600*1000, self(), save),
    case sys_env:get(pandora_box_state) of
        Data = #state{} ->
            ?INFO("启动完成..."),
            {ok, Data};
        _E ->
            ?INFO("梦幻宝盒进程首次启动完成:~w", [_E]),
            {ok, #state{}}
    end.

handle_call({open, RoleId, Name, Career, Sex}, _From, State = #state{limits = LL, roles = RoleList}) ->
    case lists:keyfind(RoleId, #role_pandora_box.rid, RoleList) of
        false ->
            RoleBox = #role_pandora_box{rid = RoleId, name = Name, limit = []}, %% 默认标示分组ID从1开始
            %% 获取对应Flag的全服限制
            {LimitState = #limit_state{limit = LimitG}, TmpLL} = case lists:keyfind({Career, Sex}, #limit_state.flag, LL) of
                false -> {#limit_state{flag = {Career, Sex}}, [#limit_state{flag = {Career, Sex}} | LL]};
                Lg -> {Lg, LL}
            end,
            %% 随机时装或饰品
            {LuckyL, _NoticeL, NewLimitG, NewLimitR} = rand({Career, Sex}, 1, LimitG, []),
            NewRoleList = [RoleBox#role_pandora_box{limit = NewLimitR} | RoleList],
            NewLL = lists:keyreplace({Career, Sex}, #limit_state.flag, TmpLL, LimitState#limit_state{limit = NewLimitG}),
            %% broad_cast(RoleId, Name, NoticeL),%% 公告
            {reply, {ok, LuckyL}, State#state{limits = NewLL, roles = NewRoleList}};
        RoleBox = #role_pandora_box{} ->
            %% 获取对应Flag的全服限制
            {LimitState = #limit_state{limit = LimitG}, TmpLL} = case lists:keyfind({Career, Sex}, #limit_state.flag, LL) of
                false -> {#limit_state{flag = {Career, Sex}}, [#limit_state{flag = {Career, Sex}} | LL]};
                Lg -> {Lg, LL}
            end,
            %% 随机时装或饰品
            {LuckyL, _NoticeL, NewLimitG, NewLimitR} = rand({Career, Sex}, 1, LimitG, []),
            NewRoleList = lists:keyreplace(RoleId, #role_pandora_box.rid, RoleList, RoleBox#role_pandora_box{limit = NewLimitR}),
            NewLL = lists:keyreplace({Career, Sex}, #limit_state.flag, TmpLL, LimitState#limit_state{limit = NewLimitG}),
            %% broad_cast(RoleId, Name, NoticeL),%% 公告
            {reply, {ok, LuckyL}, State#state{limits = NewLL, roles = NewRoleList}}
    end;

%% 刷新
handle_call({polish, Num, RoleId, _Name, Career, Sex}, _From, State = #state{limits = LL, roles = RoleList}) ->
    case lists:keyfind(RoleId, #role_pandora_box.rid, RoleList) of
        false ->
            ?ERR("角色[~w]刷新宝盒错误", [RoleId]),
            {reply, {false, <<>>}, State};
        RoleBox = #role_pandora_box{limit = LimitR} ->
            %% 获取对应Flag的全服限制
            {LimitState = #limit_state{limit = LimitG}, TmpLL} = case lists:keyfind({Career, Sex}, #limit_state.flag, LL) of
                false -> {#limit_state{flag = {Career, Sex}}, [#limit_state{flag = {Career, Sex}} | LL]};
                Lg -> {Lg, LL}
            end,
            %% 随机时装或饰品
            {LuckyL, _NoticeL, NewLimitG, NewLimitR} = rand({Career, Sex}, Num, LimitG, LimitR),
            NewRoleList = lists:keyreplace(RoleId, #role_pandora_box.rid, RoleList, RoleBox#role_pandora_box{limit = NewLimitR}),
            NewLL = lists:keyreplace({Career, Sex}, #limit_state.flag, TmpLL, LimitState#limit_state{limit = NewLimitG}),
            %% broad_cast(RoleId, Name, NoticeL),%% 公告
            {reply, {ok, LuckyL}, State#state{limits = NewLL, roles = NewRoleList}}
    end;
handle_call(_Request, _From, State) ->
    {noreply, State}.
            

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(save, State = #state{}) ->
    sys_env:save(pandora_box_state, State),
    erlang:send_after(600*1000, self(), save),
    ?INFO("梦幻宝盒数据保存成功"),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(load_failed, _State = #state{}) ->
    ?INFO("梦幻宝盒系统进程load出错关闭"),
    ok;
terminate(_Reason, State = #state{}) ->
    sys_env:save(pandora_box_state, State),
    ?INFO("梦幻宝盒系统进程关闭，数据已保存"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------
%% 内部函数
%%---------------------------------------------------------
rand(Flag, Num, LimitG, LimitR) ->
    Now = util:unixtime(),
    RandList = pandora_box_data:get(Flag),
    do_rand(Num, Now, Flag, RandList, LimitG, LimitR, [], []).

do_rand(0, _Now, _Flag, _RandList, LimitG, LimitR, LuckyL, NoticeL) ->
    {LuckyL, NoticeL, LimitG, LimitR};
do_rand(_Num, _Now, _Flag, [], LimitG, LimitR, LuckyL, NoticeL) ->
    {LuckyL, NoticeL, LimitG, LimitR};
do_rand(Num, Now, Flag, RandList, LimitG, LimitR, LuckyL, NoticeL) ->
    Ret = case check_must(Flag, LimitG) of
        false ->
            case check_must(Flag, LimitR) of
                false -> false;
                D1 -> D1
            end;
        D2 -> D2
    end,
    case Ret of
        RB = #rand_base{base_id = BaseId, is_notice = ?true} ->
            NewLimitG = update(global, Flag, Now, RB, LimitG, []),
            NewLimitR = update(role, Flag, Now, RB, LimitR, []),
            NewRandList = lists:keydelete(BaseId, #rand_base.base_id, RandList),
            do_rand(Num - 1, Now, Flag, NewRandList, NewLimitG, NewLimitR, [RB | LuckyL], [RB | NoticeL]);
        RB = #rand_base{base_id = BaseId} ->
            NewLimitG = update(global, Flag, Now, RB, LimitG, []),
            NewLimitR = update(role, Flag, Now, RB, LimitR, []),
            NewRandList = lists:keydelete(BaseId, #rand_base.base_id, RandList),
            do_rand(Num - 1, Now, Flag, NewRandList, NewLimitG, NewLimitR, [RB | LuckyL], NoticeL);
        false ->
            Total = lists:sum([X || #rand_base{rand = X} <- RandList]), %% 计算随机因子
            {Luck = #rand_base{is_notice = IsNotice}, NewRandList} = do_rand(RandList, util:rand(1, Total), []),
            NewLimitG = update(global, Flag, Now, Luck, LimitG, []),
            NewLimitR = update(role, Flag, Now, Luck, LimitR, []),
            Result = case check(global, Now, Luck, LimitG) of
                false -> false;
                true ->
                    case check(role, Now, Luck, LimitR) of
                        false -> false;
                        true -> true
                    end
            end,
            case Result of
                false ->
                    do_rand(Num, Now, Flag, RandList, NewLimitG, NewLimitR, LuckyL, NoticeL);
                true when IsNotice =:= ?true ->
                    do_rand(Num - 1, Now, Flag, NewRandList, NewLimitG, NewLimitR, [Luck | LuckyL], [Luck | NoticeL]);
                true ->
                    do_rand(Num - 1, Now, Flag, NewRandList, NewLimitG, NewLimitR, [Luck | LuckyL], NoticeL)
            end
    end.

%% 检测必出
check_must(_Flag, []) -> false;
check_must(Flag, [_RI = #rand_info{id = Id, lucky_num = N} | T]) ->
    case pandora_box_data:get_base(Flag, Id) of
        #rand_base{must_num = 0} ->
            check_must(Flag, T);
        RB = #rand_base{must_num = M} when N > M -> RB;
        _ -> check_must(Flag, T)
    end.

%% 检测限制信息
check(global, _Now, #rand_base{limit = 2}, _) ->
    true;
check(role, _Now, #rand_base{limit = 1}, _) ->
    true;
check(_, Now, #rand_base{base_id = BaseId, limit_time = {_, Xt}, limit_num = {Ln, Xn}, must_num = Xm}, L) ->
    case lists:keyfind(BaseId, #rand_info.id, L) of
        false ->
            ?DEBUG("L: ~w", [L]),
            true; %% 没有限制
        #rand_info{lucky_num = Lnum} when Xm =/= 0 andalso Lnum >= Xm ->
            true; %% 必出
        #rand_info{time_info = {ToTime, Xtn}} when Now =< ToTime andalso Xt =/= 0 andalso Xtn > Xt ->
            ?DEBUG("ToTime: ~w, Xtn:~w", [ToTime, Xtn]),
            false;
        #rand_info{num_info = {Nn, Xnn}} when Xn =/= 0 andalso Nn >= Ln andalso Xnn =< Xn ->
            ?DEBUG("Nn: ~w, Xnn:~w", [Nn, Xnn]),
            false;
        _ ->
            ?DEBUG("L: ~w", [L]),
            true
    end.

%% 更新限制信息
update(global, _, _, #rand_base{limit = 2}, L, _NewList) ->
    L;
update(role, _, _, #rand_base{limit = 1}, L, _NewList) ->
    L;
update(_Type, _Flag, Now, #rand_base{base_id = BaseId, limit_time = {Lt, Xt}, limit_num = {_Ln, Xn}}, [], NewList) ->
    ?DEBUG("*******************"),
    case lists:keyfind(BaseId, #rand_info.id, NewList) of
        false ->
            %% 首次记录限制信息
            Info = case Xt =/= 0 of
                true when Xn =/= 0 ->
                    #rand_info{id = BaseId, last_time = Now, lucky_num = 1, time_info = {Now + Lt, 0}, num_info = {1, 0}};
                true ->
                    #rand_info{id = BaseId, last_time = Now, lucky_num = 1, time_info = {Now + Lt, 0}};
                false when Xn =/= 0 ->
                    #rand_info{id = BaseId, last_time = Now, lucky_num = 1, num_info = {1, 0}};
                false ->
                    #rand_info{id = BaseId, last_time = Now, lucky_num = 1}
            end,
            [Info | NewList];
        _ -> NewList
    end;
update(Type, Flag, Now, RB = #rand_base{base_id = BaseId, limit_time = {Lt, Xt}}, [RI = #rand_info{id = BaseId, time_info = {ToTime, ToXt}, num_info = {Nn, _Xno}} | T], NewList) ->
    %% 随机选中的当前限制项
    Info = RI#rand_info{last_time = Now, lucky_num = 0, num_info = {Nn + 1, 0}},
    NewInfo = case Xt =/= 0 of
        false -> Info;
        true when Now >= ToTime ->
            %% 时间因子限制已过期:时间累加，次数重置
            Info#rand_info{time_info = {Now + Lt, 0}};
        true ->
            Info#rand_info{time_info = {ToTime, ToXt + 1}}
    end,
    update(Type, Flag, Now, RB, T, [NewInfo | NewList]);
update(Type, Flag, Now, RB, [RI = #rand_info{id = BaseId, time_info = {ToTime, _ToXt}, num_info = {Nn, Xno}, lucky_num = Lnum} | T], NewList) ->
    case pandora_box_data:get_base(Flag, BaseId) of
        %% TODO:这里默认了所有职业/性别之间的相同ID的物品的限制信息一样，如果表数据有出入，这里可能会有问题
        #rand_base{base_id = BaseId, limit_time = {Lt, Xt}, limit_num = {Ln, Xn}} ->
            Info = RI#rand_info{lucky_num = Lnum + 1},
            Info1 = case Xt =/= 0 of
                false -> Info;
                true when Now >= ToTime ->
                    Info#rand_info{time_info = {Now + Lt, 0}};
                true -> Info
            end,
            Info2 = case Xn =/= 0 of
                false -> Info1;
                true when Nn < Ln -> Info1; %% 抽中次数小于限制数
                true ->
                    case Xno >= Xn of
                        true -> %% 限制已失效
                            Info1#rand_info{num_info = {0, 0}};
                        false ->
                            Info1#rand_info{num_info = {Nn, Xno + 1}}
                    end
            end,
            ?DEBUG("*******************"),
            update(Type, Flag, Now, RB, T, [Info2 | NewList]);
        _ ->
            update(Type, Flag, Now, RB, T, NewList)
    end.

%% 随机奖励，返回选中项和剩余列表（强匹配确保有错报错）
do_rand([RB = #rand_base{rand = Rand} | T], RandVal, BackL) ->
    case RandVal =< Rand of
        true -> {RB, BackL ++ T};
        false ->
            do_rand(T, RandVal - Rand, [RB | BackL])
    end.

%% 公告
broad_cast({Rid, SrvId}, Name, NoticeL) ->
    Items = [{BaseId, 1, Num} || #rand_base{base_id = BaseId, num = Num} <- NoticeL],
    RoleMsg = notice:role_to_msg({Rid, SrvId, Name}),
    ItemMsg = notice:item_to_msg(Items),
    Msg = util:fbin(?L(<<"玩转梦幻，好运当头，~s打开<font color='#ff9600'>梦幻宝盒</font>幸运地获得~s">>), [RoleMsg, ItemMsg]),
    notice:send(54, Msg).
