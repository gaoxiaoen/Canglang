%%-------------------------------------------------------------------------
%% 邮件系统 管理接口
%% @author yjbgwxf@gmail.com
%%-------------------------------------------------------------------------
-module(mail_adm).
-export([send/4             %% 纯文本邮件接口(GM回复)，     不走 缓存服务器
        ,send/6             %% 公司内部邮件接口             不走 缓存服务器
        ,send/7             %% 在线给玩家发送邮件接口       不走 缓存服务器         一次发送有上限
        ,send/9             %% 全服性邮件                   走   缓存服务器
        ,send/10            %% 全服性邮件                   走   缓存服务器
    ]
).

-include("mail.hrl").
-include("item.hrl").
-include("common.hrl").
-include("role.hrl").

-define(max_send_roles, 100).       %% 一次发送允许上限人数
-define(mail_max_attachment_num, 50).   %% 一次限制发50个附件上限
-define(max_deadline, (util:unixtime() + (40 * 24 * 3600))).

%% 资产种类
-type assets_type()     ::  0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 12 | 13 | 14.
%%  2 ---> 金币        3 ---> 晶钻     4 ---> 绑定晶钻   5 ---> 龙鳞 6 --->符石  
%%1 ---> 绑定金币 4 ---> 竞技场积分   5 ---> 经验         6 ---> 灵力
%%  7 ---> 荣誉值   8 ---> 精力(活跃度)     9 ---> 阅历值   12 ---> 传音次数    13 ---> 魅力值      14 ---> 送花积分

%% 资产列表元素类型
-type assets()          ::  {assets_type(), integer()}.

%% 绑定类型
-type bind()            ::  0 | 1.  %% 0 ---> 非绑定    1 ---> 绑定 

%% 物品列表元素类型
-type itemid()          ::  {integer(), bind(), integer()}.

%% 全服邮件类型
-type mail_type()       ::  1 | 2 | 3.  %% 1 ---> 发在线    2 ---> 在线等级限制     3 ---> 全服等级限制

-spec send(integer(), binary(), binary(), binary()) -> [] | [binary()].
%% @spec send(ID, Srvid, Sub, Text) -> [Result]
%% ID = integer()
%% Srvid = Name = Sub = Text = binary()
%% @doc 后台发邮件给玩家，纯文本类，例如：给玩家反馈的回复  
%% <div>不经过邮件缓存器</div>
send(Rid, _Srvid, _Sub, _Text) when not(is_integer(Rid)) ->
    [util:fbin(<<"错误的角色ID ~w 数据类型">>, [Rid])];
send(_Rid, Srvid, _Sub, _Text) when not(is_binary(Srvid)) ->
    [util:fbin(<<"错误的服务器标志 ~w 数据类型">>, [Srvid])];
send(_Rid, Srvid, _Sub, _Text) when byte_size(Srvid) =:= 0  ->
    [<<"错误的服务器标志, 不可以为空">>];
send(_Rid, _Srvid, Sub, _Text) when not(is_binary(Sub)) ->
    [util:fbin(<<"错误的邮件主题 ~w 数据类型">>, [Sub])];
send(_Rid, _Srvid, Sub, _Text) when byte_size(Sub) =:= 0 ->
    [<<"请填写邮件主题">>];
send(_Rid, _Srvid, _Sub, Text) when not(is_binary(Text)) ->
    [util:fbin(<<"错误的邮件内容 ~w 数据类型">>, [Text])];
send(_Rid, _Srvid, _Sub, Text) when byte_size(Text) =:= 0 ->
    [<<"请填写邮件内容">>];
send(Rid, Srvid, Sub, Text) ->
    ?DEBUG("---竟然是这里接收了！！！---~n~n~n~n~n"),
    case mail:send_system({Rid, Srvid}, {Sub, Text}) of
        ok ->
            [];
        {false, Reason} ->
            [Reason]
    end.

send(AdmName, Sub, Text, Type, Time, Min, Max, Assets, ItemIds) ->
    send(AdmName, Sub, Text, Type, Time, Min, Max, Assets, ItemIds, <<>>).


-spec send(binary(), binary(), binary(), mail_type(), integer(), integer(), integer(), [assets()], [itemid()]) -> [binary()] | [].
%% @spec send(Adm, Sub, Text, MailType, Time, MinLev, MaxLev, Assets, ItemIds) -> ReasonList
%% @doc 后台管理调用邮件接口, 给当时在线的玩家发送
send(AdmName, _Sub, _Text, _Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) when not(is_binary(AdmName)) ->
    [util:fbin(<<"错误的管理员 ~w 数据类型">>, [AdmName])];
send(<<>>, _Sub, _Text, _Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) ->
    [<<"请填写管理员名字">>];
send(_AdmName, Sub, _Text, _Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) when not(is_binary(Sub)) ->
    [util:fbin(<<"错误的邮件主题 ~w 数据类型">>, [Sub])];
send(_AdmName, <<>>, _Text, _Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) ->
    [<<"请填写邮件主题">>];
send(_AdmName, _Sub, Text, _Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) when not(is_binary(Text)) ->
    [util:fbin(<<"错误的邮件内容 ~w 数据类型">>, [Text])];
send(_AdmName, _Sub, <<>>, _Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) ->
    [<<"请填写邮件内容">>];
send(_AdmName, _Sub, _Text, Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) when not(is_integer(Type)) ->
    [util:fbin(<<"错误的邮件类型 ~w 数据类型">>, [Type])];
send(_AdmName, _Sub, _Text, Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) when Type < 1 orelse Type > 3 ->
    [util:fbin(<<"错误的邮件类型 ~w 数据范围">>, [Type])];
send(_AdmName, _Sub, _Text, _Type, Time, _Min, _Max, _Assets, _ItemIds, _Platform) when not(is_integer(Time)) orelse Time < 0 ->
    [util:fbin(<<"错误的邮件定时 ~w 数据类型">>, [Time])];
send(_AdmName, _Sub, _Text, _Type, _Time, Min, _Max, _Assets, _ItemIds, _Platform) when not(is_integer(Min)) orelse Min < 0 ->
    [util:fbin(<<"错误的等级下限 ~w 数据类型">>, [Min])];
send(_AdmName, _Sub, _Text, _Type, _Time, _Min, Max, _Assets, _ItemIds, _Platform) when not(is_integer(Max)) orelse Max < 0 ->
    [util:fbin(<<"错误的等级上限 ~w 数据类型">>, [Max])];
send(_AdmName, _Sub, _Text, _Type, _Time, Min, Max, _Assets, _ItemIds, _Platform) when Min > Max ->
    [util:fbin(<<"错误的等级下限 ~w，上限 ~w 数据范围">>, [Min, Max])];
send(_AdmName, _Sub, _Text, _Type, _Time, _Min, _Max, Assets, _ItemIds, _Platform) when not(is_list(Assets)) ->
    [util:fbin(<<"错误的资产列表 ~w，数据类型">>, [Assets])];
send(_AdmName, _Sub, _Text, _Type, _Time, _Min, _Max, _Assets, ItemIds, _Platform) when not(is_list(ItemIds)) ->
    [util:fbin(<<"错误的物品列表 ~w，数据类型">>, [ItemIds])];

%% 发在线
send(AdmName, Sub, Text, 1, 0, _Min, _Max, Assets, ItemIds, Platform) ->
    ?DEBUG("----发在线----~n~n~n"),
    debug2(AdmName, Sub, Text, 1, 0, _Min, _Max, Assets, ItemIds, Platform),
    case check_valid_attach(ItemIds, Assets) of
        {false, Reason} ->
            [Reason];
        {Items, ClearAssets, ItemsInfo} ->
            IDs_Online = 
                case Platform of
                    <<>> -> 
                        [{{Rid, Srvid}, Name} || {Rid, Srvid, Name, _Lev, _Platform1} <- get_online_roles()];
                    _ -> 
                        [{{Rid, Srvid}, Name} || {Rid, Srvid, Name, _Lev, Platform1} <- get_online_roles(), Platform == Platform1]
                end,
            ?DEBUG("---IDs_Online---~p~n", [IDs_Online]),
            add_mail_buff(AdmName, IDs_Online, Sub, Text, ClearAssets, Items, ItemsInfo, util:unixtime()),
            []
    end;

%% 发在线, 等级限制
send(AdmName, Sub, Text, 2, 0, Min, Max, Assets, ItemIds, Platform) ->
    ?DEBUG("----发在线, 等级限制----~n"),
    debug2(AdmName, Sub, Text, 2, 0, Min, Max, Assets, ItemIds, Platform),
    case check_valid_attach(ItemIds, Assets) of
        {false, Reason} ->
            [Reason];
        {Items, ClearAssets, ItemsInfo} ->
            IDs_Online = 
                case Platform of
                    <<>> ->
                        [{{Rid, Srvid}, Name} || {Rid, Srvid, Name, Lev, _Platform1} <- get_online_roles(), (Lev >= Min) andalso (Lev =< Max)];
                    _ ->
                        [{{Rid, Srvid}, Name} || {Rid, Srvid, Name, Lev, Platform1} <- get_online_roles(), (Lev >= Min) andalso (Lev =< Max) andalso (Platform == Platform1)]
                end,
            ?DEBUG("---IDs_Online---~p~n", [IDs_Online]),
            add_mail_buff(AdmName, IDs_Online, Sub, Text, ClearAssets, Items, ItemsInfo, util:unixtime()),
            []
    end;

%% 发全服, 等级限制
send(AdmName, Sub, Text, 3, 0, Min, Max, Assets, ItemIds, Platform) ->
    ?DEBUG("---- 发全服, 等级限制----~n"),
    debug2(AdmName, Sub, Text, 3, 0, Min, Max, Assets, ItemIds, Platform),
    case check_valid_attach(ItemIds, Assets) of
        {false, Reason} ->
            [Reason];
        {Items, ClearAssets, ItemsInfo} ->
            {IDs_db, IDs_Online} = 
                case Platform of 
                    <<>> ->
                        {[{{Rid, Srvid}, Name} || {Rid, Srvid, Name} <- mail_adm_db:get_roles(Min, Max)],
                        [{{Rid, Srvid}, Name} || {Rid, Srvid, Name, Lev, _Platform1} <- get_online_roles(), (Lev >= Min) andalso (Lev =< Max)]};
                    _ ->
                        {[{{Rid, Srvid}, Name} || {Rid, Srvid, Name} <- mail_adm_db:get_roles(Min, Max, Platform)],
                        [{{Rid, Srvid}, Name} || {Rid, Srvid, Name, Lev, Platform1} <- get_online_roles(), (Lev >= Min) andalso (Lev =< Max) andalso (Platform1 == Platform)]}
                end,
            ?DEBUG("---IDs_db---~p~n", [IDs_db]),
            ?DEBUG("---IDs_Online---~p~n", [IDs_Online]),
            IDs = lists:ukeysort(1, IDs_Online ++ IDs_db),
            add_mail_buff(AdmName, IDs, Sub, Text, ClearAssets, Items, ItemsInfo, util:unixtime()),
            []
    end;

%% 定时邮件 定时在线
send(AdmName, Sub, Text, Type, Time, Min, Max, Assets, ItemIds, Platform) ->
    ?DEBUG("---定时邮件 定时在线-----~n"),
    debug2(AdmName, Sub, Text, 3, 0, Min, Max, Assets, ItemIds, Platform),
    case Time > util:unixtime() andalso Time < ?max_deadline of
        true ->
            case check_valid_attach(ItemIds, Assets) of
                {false, Reason} ->
                    [Reason];
                _ ->
                    mail_mgr:timing_online_mail(Time, ?MODULE, send, [AdmName, Sub, Text, Type, 0, Min, Max, Assets, ItemIds, Platform]),
                    [<<"成功添加定时邮件">>]
            end;
        false ->
            [<<"定时时间已过期, 或定时时间太遥远了">>]
    end.

%% 给玩家发送邮件
send(AdmName, _Sub, _Text, _Names, _IDs, _Assets, _Items) when not(is_binary(AdmName)) ->
    [util:fbin(<<"管理员 ~w 参数有误, it is not a binary">>, [AdmName])];
send(AdmName, _Sub, _Text, _Names, _IDs, _Assets, _Items) when byte_size(AdmName) =:= 0 ->
    [<<"请填写管理员名字">>];
send(_AdmName, Sub, _Text, _Names, _IDs, _Assets, _Items) when not(is_binary(Sub)) ->
    [util:fbin(<<"邮件主题 ~w 参数有误, it is not a bianry">>, [Sub])];
send(_AdmName, Sub, _Text, _Names, _IDs, _Assets, _Items) when byte_size(Sub) =:= 0 ->
    [<<"请填写邮件主题">>];
send(_AdmName, _Sub, Text, _Names, _IDs, _Assets, _Items) when not(is_binary(Text)) ->
    [util:fbin(<<"邮件内容 ~w 参数有误, it is not a bianry">>, [Text])];
send(_AdmName, _Sub, Text, _Names, _IDs, _Assets, _Items) when byte_size(Text) =:= 0 ->
    [<<"请填写邮件内容">>];
send(_AdmName, _Sub, _Text, [], [], _Assets, _Items) ->
    [<<"发送对象为空">>];
send(_AdmName, _Sub, _Text, [<<>>], [], _Assets, _Items) ->
    [<<"发送对象为空">>];
send(_AdmName, _Sub, _Text, [], [{0, <<>>}], _Assets, _Items) ->
    [<<"发送对象为空">>];
send(_AdmName, _Sub, _Text, [<<>>], [{0, <<>>}], _Assets, _Items) ->
    [<<"发送对象为空">>];
send(_AdmName, _Sub, _Text, Names, _IDs, _Assets, _Items) when not(is_list(Names)) ->
    [util:fbin(<<"发送对象角色名 ~w 参数有误, it is not a name list">>, [Names])];
send(_AdmName, _Sub, _Text, _Names, IDs, _Assets, _Items) when not(is_list(IDs)) ->
    [util:fbin(<<"发送对象ID ~w 参数有误, it is not a name list">>, [IDs])];
send(_AdmName, _Sub, _Text, _Names, _IDs, Assets, _Items) when not(is_list(Assets)) ->
    [util:fbin(<<"发送资产 ~w 参数有误, it is not a assets list">>, [Assets])];
send(_AdmName, _Sub, _Text, _Names, _IDs, _Assets, Items) when not(is_list(Items)) ->
    [util:fbin(<<"发送物品 ~w 参数有误, it is not a item list">>, [Items])];
send(_AdmName, _Sub, _Text, [<<>>], IDs, _Assets, _ItemIds) when length(IDs) > ?max_send_roles ->
    [util:fbin(<<"发送对象列表不可以超过 ~w 人, 当前有 ~w 人">>, [?max_send_roles, length(IDs)])];
send(_AdmName, _Sub, _Text, [], IDs, _Assets, _ItemIds) when length(IDs) > ?max_send_roles ->
    [util:fbin(<<"发送对象列表不可以超过 ~w 人, 当前有 ~w 人">>, [?max_send_roles, length(IDs)])];
send(_AdmName, _Sub, _Text, Names, _IDs, _Assets, _ItemIds) when length(Names) > ?max_send_roles ->
    [util:fbin(<<"发送对象列表不可以超过 ~w 人, 当前有 ~w 人">>, [?max_send_roles, length(Names)])];

%% 按ID列表发送
send(AdmName, Sub, Text, Names, IDs, Assets, ItemIds) when Names =:= [] orelse Names =:= [<<>>] ->
    ?DEBUG("--按ID列表发送---"),
    debug(AdmName, Sub, Text, Names, IDs, Assets, ItemIds),
    case catch lists:all(fun({Rid, Srvid}) -> is_integer(Rid) andalso is_binary(Srvid) andalso Rid > 0 andalso Srvid =/= <<>> end, IDs) of
        true ->
            case no_duplicate(IDs) of
                true ->
                    case check_valid_attach(ItemIds, Assets) of
                        {false, Reason} ->
                            [Reason];
                        {Items, ClearAssets, ItemsInfo} ->
                            send_assets_items(AdmName, IDs, Sub, Text, ClearAssets, Items, ItemsInfo)
                    end;
                false ->
                    [<<"发送角色列表中含有重复玩家">>]
            end;
        _ ->
            [<<"传入非法的发生对象ID列表">>]
    end;

%% 按角色名字列表发送
send(AdmName, Sub, Text, Names, IDs, Assets, ItemIds) when IDs =:= [] orelse IDs =:= [{0, <<>>}] ->
    ?DEBUG("-----"),
    debug(AdmName, Sub, Text, Names, IDs, Assets, ItemIds),
    case lists:all(fun(Name) -> is_binary(Name) andalso Name =/= <<>> end, Names) of
        true ->
            case no_duplicate(Names) of
                true ->
                    case check_valid_attach(ItemIds, Assets) of
                        {false, Reason} ->
                            [Reason];
                        {Items, ClearAssets, ItemsInfo} ->
                            %% send_assets_items2(AdmName, Names, Sub, Text, ClearAssets, Items, ItemsInfo, ItemIds, Assets)
                            send_assets_items(AdmName, Names, Sub, Text, ClearAssets, Items, ItemsInfo)
                    end;
                false ->
                    [<<"发送角色列表中含有重复玩家">>]
            end;
        false ->
            [<<"传入非法的发生对象名字列表">>]
    end;

send(_AdmName, _Sub, _Text, Names, IDs, _Assets, _Items) ->
    [util:fbin(<<"不能同时采用角色名称 ~w 和ID ~w 来发送">>, [Names, IDs])].

%% 发公司内部人员
send(AdmName, _Sub, _Text, _Names, _Assets, _Items) when not(is_binary(AdmName)) ->
    [util:fbin(<<"管理员 ~w 参数有误, it is not a binary">>, [AdmName])];
send(<<>>, _Sub, _Text, _Names, _Assets, _Items) ->
    [<<"请填写管理员名字">>];
send(_AdmName, Sub, _Text, _Names, _Assets, _Items) when not(is_binary(Sub)) ->
    [util:fbin(<<"邮件主题 ~w 参数有误, it is not a bianry">>, [Sub])];
send(_AdmName, <<>>, _Text, _Names, _Assets, _Items) ->
    [<<"请填写邮件主题">>];
send(_AdmName, _Sub, Text, _Names, _Assets, _Items) when not(is_binary(Text)) ->
    [util:fbin(<<"邮件内容 ~w 参数有误, it is not a bianry">>, [Text])];
send(_AdmName, _Sub, <<>>, _Names, _Assets, _Items) ->
    [<<"请填写邮件内容">>];
send(_AdmName, _Sub, _Text, [], _Assets, _Items) ->
    [<<"发送对象为空">>];
send(_AdmName, _Sub, _Text, Names, _Assets, _Items) when not(is_list(Names)) ->
    [util:fbin(<<"发送对象 ~w 参数有误, it is not a name list">>, [Names])];
send(_AdmName, _Sub, _Text, _Names, Assets, _Items) when not(is_list(Assets)) ->
    [util:fbin(<<"发送资产 ~w 参数有误, it is not a assets list">>, [Assets])];
send(_AdmName, _Sub, _Text, _Names, _Assets, Items) when not(is_list(Items)) ->
    [util:fbin(<<"发送物品 ~w 参数有误, it is not a item list">>, [Items])];
send(_AdmName, _Sub, _Text, Names, _Assets, _Items) when length(Names) > ?max_send_roles ->
    [util:fbin(<<"发送对象列表不可以超过 ~w 人">>, [?max_send_roles])];
send(AdmName, Sub, Text, Names, Assets, ItemIds) ->
    case lists:all(fun(Name) -> is_binary(Name) andalso Name =/= <<>> end, Names) of
        true ->
            case no_duplicate(Names) of
                true ->
                    case check_valid_attach(ItemIds, Assets) of
                        {false, Reason} ->
                            [Reason];
                        {Items, ClearAssets, ItemsInfo} ->
                            send_assets_items_inner(AdmName, Names, Sub, Text, ClearAssets, Items, ItemsInfo)
                    end;
                false ->
                    [<<"发送角色列表中含有重复玩家">>]
            end;
        false ->
            [<<"传入非法的发生对象名字列表">>]
    end.

%% 发送包括资产和物品
send_assets_items(AdmName, Roles, Sub, Text, Assets, Items, ItemsInfo) ->
    case do_send_assets_items(AdmName, Roles, Sub, Text, Assets, Items, [], []) of  %% 需要发送物品
        {[],[]} ->
            {Coin, Gold, BindGold, Stone, Scale} = check_send_assets(Assets),
            %?DEBUG("******* D: ~w", [D]),
            %?DEBUG("check_role ~w", [check_send_roles(Roles)]),
            %?DEBUG("**** Items ~w", [Items]),
            %?DEBUG("****** ItemsInfo ~w", [ItemsInfo]),
            %?DEBUG("~s, ~s, ~s, ~s, ~w, ~s, ~s, ~s, ~s, ~s, ~s",[check_send_roles(Roles), Sub, Text, AdmName, util:unixtime(),Coin, Gold, BindGold, Stone, Scale, ItemsInfo]),
            %% 在这里会报错，找不到原因，先屏蔽了。
            case mail_adm_db:insert_mail_log(check_send_roles(Roles), Sub, Text, AdmName, util:unixtime(),Coin, Gold, BindGold, Stone, Scale, ItemsInfo) of
                true ->
                    [];
                false ->
                    [<<"邮件发送日志写入数据库失败">>]
            end;
        {FailList, FailRoles} when length(FailRoles) =/= length(Roles) ->
            SucRoles = Roles -- FailRoles,
            {Coin, Gold, BindGold, Stone, Scale} = check_send_assets(Assets),
            case mail_adm_db:insert_mail_log(check_send_roles(SucRoles), Sub, Text, AdmName, util:unixtime(),Coin, Gold, BindGold, Stone, Scale, ItemsInfo) of
                true ->
                    make_reasons(FailList);
                false ->
                    [<<"邮件发送日志写入数据库失败">> | make_reasons(FailList)]
            end;
        {FailList, _} ->
            make_reasons(FailList);
        _ ->
            [<<"系统错误">>]
    end.

do_send_assets_items(_, [], _, _, _, _, FailList, FailIds) ->
    {FailList, FailIds};
do_send_assets_items(AdmName, [Role | T], Sub, Text, Assets, Items, FailList, FailIds) ->
    case mail:send_system(Role, {Sub, Text, Assets, Items}) of
        ok ->
            do_send_assets_items(AdmName, T, Sub, Text, Assets, Items, FailList, FailIds);
        {false, Reason} ->
            do_send_assets_items(AdmName, T, Sub, Text, Assets, Items, [{Role, Reason}|FailList], [Role|FailIds])
    end.


% send_assets_items2(AdmName, Names, Sub, Text, ClearAssets, Items, ItemsInfo, ItemIds, Assets)
%% 发送包括资产和物品
%send_assets_items2(AdmName, Roles, Sub, Text, Assets, _Items, ItemsInfo, RawItemIds, RawAssets) ->
%    case do_send_assets_items2(AdmName, Roles, Sub, [], [], RawItemIds, RawAssets) of  %% 需要发送物品
%        {[],[]} ->
%            {Coin, Gold, BindGold, Stone, Scale} = check_send_assets(Assets),
%            case mail_adm_db:insert_mail_log(check_send_roles(Roles), Sub, Text, AdmName, util:unixtime(),Coin, Gold, BindGold, Stone, Scale, ItemsInfo) of
%                true ->
%                    [];
%                false ->
%                    [<<"邮件发送日志写入数据库失败">>]
%            end;
%        {FailList, FailRoles} when length(FailRoles) =/= length(Roles) ->
%            SucRoles = Roles -- FailRoles,
%            {Coin, Gold, BindGold, Stone, Scale} = check_send_assets(Assets),
%            case mail_adm_db:insert_mail_log(check_send_roles(SucRoles), Sub, Text, AdmName, util:unixtime(),Coin, Gold, BindGold, Stone, Scale, ItemsInfo) of
%                true ->
%                    make_reasons(FailList);
%                false ->
%                    [<<"邮件发送日志写入数据库失败">> | make_reasons(FailList)]
%            end;
%        {FailList, _} ->
%            make_reasons(FailList);
%        _ ->
%            [<<"系统错误">>]
%    end.


%do_send_assets_items2(_, [], _, FailList, FailIds, _, _) ->
%    {FailList, FailIds};
%do_send_assets_items2(AdmName, [Role | T], Sub, FailList, FailIds, RawItemIds, RawAssets) ->
%    case mail:send_system2(Role, {Sub, RawAssets, RawItemIds}) of
%        ok ->
%            do_send_assets_items2(AdmName, T, Sub, FailList, FailIds, RawItemIds, RawAssets);
%        {false, Reason} ->
%            do_send_assets_items2(AdmName, T, Sub, [{Role, Reason}|FailList], [Role|FailIds], RawItemIds, RawAssets)
%    end.

%% 发送包括资产和物品给内部人员
send_assets_items_inner(AdmName, Roles, Sub, Text, Assets, Items, ItemsInfo) ->
    case do_send_assets_items_inner(AdmName, Roles, Sub, Text, Assets, Items, [], []) of  %% 需要发送物品
        {[],[]} ->
            {Coin, Gold, BindCoin, BindGold} = check_send_assets(Assets),
            case mail_adm_db:insert_inner_mail_log(check_send_roles(Roles), Sub, Text, AdmName, util:unixtime(),Coin, Gold, BindCoin, BindGold, ItemsInfo) of
                true ->
                    [];
                false ->
                    [<<"邮件发送日志写入数据库失败">>]
            end;
        {FailList, FailRoles} when length(FailRoles) =/= length(Roles) ->
            SucRoles = Roles -- FailRoles,
            {Coin, Gold, BindCoin, BindGold} = check_send_assets(Assets),
            case mail_adm_db:insert_inner_mail_log(check_send_roles(SucRoles), Sub, Text, AdmName, util:unixtime(),Coin, Gold, BindCoin, BindGold, ItemsInfo) of
                true ->
                    make_reasons(FailList);
                false ->
                    [<<"邮件发送日志写入数据库失败">> | make_reasons(FailList)]
            end;
        {FailList, _} ->
            make_reasons(FailList);
        _ ->
            [<<"系统错误">>]
    end.

%% 给内部人员发邮件不存数据库日志
do_send_assets_items_inner(_, [], _, _, _, _, FailList, FailIds) ->
    {FailList, FailIds};
do_send_assets_items_inner(AdmName, [Role | T], Sub, Text, Assets, Items, FailList, FailIds) ->
    case mail:send_system(0, Role, {Sub, Text, Assets, Items}) of
        ok ->
            do_send_assets_items_inner(AdmName, T, Sub, Text, Assets, Items, FailList, FailIds);
        {false, Reason} ->
            do_send_assets_items_inner(AdmName, T, Sub, Text, Assets, Items, [{Role, Reason}|FailList], [Role|FailIds])
    end.


%% 添加邮件到缓存器
add_mail_buff(_AdmName, [], _Sub, _Text, _Assets, _MakedItems, _ItemsInfo, _Time) -> 
    ok;
add_mail_buff(AdmName, [{{Rid, Srvid}, Name} | Roles], Sub, Text, Assets, Items, ItemsInfo, Time) ->
    mail_adm_mgr:add_buff(#mail_buff{adm = AdmName, dest = {Rid, Srvid}, name = Name, 
            submit_time = Time, subject = Sub, content = Text, assets = Assets, items = Items, items_info = ItemsInfo}),
    add_mail_buff(AdmName, Roles, Sub, Text, Assets, Items, ItemsInfo, Time).

%% 获取全服在线角色列表
get_online_roles() ->
    F = fun(H, T) -> lists:foldl(fun(X, L) -> [X | L] end, T, H) end,
    lists:foldl(fun(H, T) -> F(H,T) end, [], [Roles || {_, Roles} <- role_adm:roles_online_background_mail()]).

%% @spec check_valid_attach() -> {false, Reason} | {Items, Assets, ItemInfo}
%% @doc 检测邮件附件合法性
check_valid_attach(ItemIds, Assets) ->
    case check_make_item(ItemIds) of
        {false, Reason} -> 
            {false, Reason};
        MakedItems when length(MakedItems) =< ?mail_max_attachment_num ->
            case check_valid_assets(Assets) of
                {false, Reason} ->
                    {false, Reason};
                ClearAssets ->
                    {MakedItems, ClearAssets, make_item_info(ItemIds)}
            end;
        _MakedItems ->
            {false, util:fbin(<<"邮件附件数为 ~w，超过最大允许数量 ~w 件">>, [length(_MakedItems), ?mail_max_attachment_num])}
    end.

%% 组装邮件发送失败原因
make_reasons(FailList) ->
    make_reasons(FailList, []).
make_reasons([], Reasons) ->
    Reasons;
make_reasons([{{Rid, Srvid}, Reason} | T], Reasons) ->
    make_reasons(T, [util:fbin("给角色 [~w, ~s] ，发送邮件时发生错误，原因是：~s", [Rid, Srvid, Reason]) | Reasons]);
make_reasons([{Name, Reason} | T], Reasons) ->
    make_reasons(T, [util:fbin("给角色 [~s] ，发送邮件时发生错误，原因是：~s", [Name, Reason]) | Reasons]).

%% 找出发送的金币，晶钻数
check_send_assets(Assets) ->
    check_send_assets(Assets, {0, 0, 0, 0, 0}).
check_send_assets([], Re) ->
    Re;
check_send_assets([{?mail_coin, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin + Value, Gold, BindGold, Stone, Scale});
check_send_assets([{?mail_gold, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold + Value, BindGold, Stone, Scale});
%check_send_assets([{?mail_coin_bind, Value} | T], {Coin, Gold, BindCoin, BindGold}) ->
%     check_send_assets(T, {Coin, Gold, BindCoin + Value, BindGold});
check_send_assets([{?mail_gold_bind, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold, BindGold + Value, Stone, Scale});

check_send_assets([{?mail_stone, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold, BindGold, Stone + Value, Scale});
check_send_assets([{?mail_scale, Value} | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold, BindGold, Stone, Scale + Value});

check_send_assets([_ | T], {Coin, Gold, BindGold, Stone, Scale}) ->
    check_send_assets(T, {Coin, Gold, BindGold, Stone, Scale}).


%% 拼接发送物品信息保存到数据库
make_item_info(Items) ->
    make_item_info(Items, <<>>).
make_item_info([], ItemsName) ->
    ItemsName;
make_item_info([{0, _Bind, _Quantity} | T], ItemsName) ->
    make_item_info(T, ItemsName);
make_item_info([{Itemid, Bind, Quantity} | []], ItemsName) ->
    NewName = case item_data:get(Itemid) of
        {ok, #item_base{name = Name, quality = ?quality_white}} ->   %% 白
            util:fbin("【~s(白)，~s，~w件】", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name, quality = ?quality_green}} ->   %% 绿
            util:fbin("【~s(绿)，~s，~w件】", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name, quality = ?quality_blue}} ->   %% 蓝
            util:fbin("【~s(蓝)，~s，~w件】", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name, quality = ?quality_purple}} ->   %% 紫
            util:fbin("【~s(紫)，~s，~w件】", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name, quality = ?quality_orange}} ->   %% 橙
            util:fbin("【~s(橙)，~s，~w件】", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name}} ->   %% 
            util:fbin("【~s，~s，~w件】", [Name, bindtype(Bind), Quantity]);
        _ ->
            util:fbin(<<"【物品 ~w 找不到数据】">>, [Itemid])
    end,
    <<ItemsName/binary, NewName/binary>>;
make_item_info([{Itemid, Bind, Quantity} | T], ItemsName) ->
    NewName = case item_data:get(Itemid) of
        {ok, #item_base{name = Name, quality = ?quality_white}} ->   %% 白
            util:fbin("【~s(白)，~s，~w件】<Br>", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name, quality = ?quality_green}} ->   %% 绿
            util:fbin("【~s(绿)，~s，~w件】<Br>", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name, quality = ?quality_blue}} ->   %% 蓝
            util:fbin("【~s(蓝)，~s，~w件】<Br>", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name, quality = ?quality_purple}} ->   %% 紫
            util:fbin("【~s(紫)，~s，~w件】<Br>", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name, quality = ?quality_orange}} ->   %% 橙
            util:fbin("【~s(橙)，~s，~w件】<Br>", [Name, bindtype(Bind), Quantity]);
        {ok, #item_base{name = Name}} ->   %% 
            util:fbin("【~s，~s，~w件】<Br>", [Name, bindtype(Bind), Quantity]);
        _ ->
            util:fbin(<<"【物品 ~w 找不到数据】<Br>">>, [Itemid])
    end,
    make_item_info(T, <<ItemsName/binary, NewName/binary>>).

check_send_roles(Roles) ->
    check_send_roles(Roles, <<>>).
check_send_roles([], BinaryRoles) ->
    BinaryRoles;
check_send_roles([{ID, Srvid}|[]], BinaryRoles) ->
    case role_api:lookup(by_id, {ID, Srvid}, to_mail) of
        {ok, _, {_, _, Name}} ->
            BinID = util:fbin(<<"[~w,~s,~s]">>, [ID, Srvid, Name]),
            <<BinaryRoles/binary, BinID/binary>>;
        _ ->
            Name = mail_adm_db:get_role_info(by_id, {ID, Srvid}),
            BinID = util:fbin(<<"[~w,~s,~s]">>, [ID, Srvid, Name]),
            <<BinaryRoles/binary, BinID/binary>>
    end;
check_send_roles([{ID, Srvid}|T], BinaryRoles) ->
    case role_api:lookup(by_id, {ID, Srvid}, to_mail) of
        {ok, _, {_, _, Name}} ->
            Bin = util:fbin(<<"[~w,~s,~s]<Br>">>, [ID, Srvid, Name]),
            check_send_roles(T, <<BinaryRoles/binary, Bin/binary>>);
        _ ->
            Name = mail_adm_db:get_role_info(by_id, {ID, Srvid}),
            Bin = util:fbin(<<"[~w,~s,~s]<Br>">>, [ID, Srvid, Name]),
            check_send_roles(T, <<BinaryRoles/binary, Bin/binary>>)
    end;
check_send_roles([Name|[]], Names) ->
    case role_api:lookup(by_name, Name, to_mail) of
        {ok, _, {ID, Srvid, _}} ->
            Bin = util:fbin(<<"[~w,~s,~s]">>, [ID, Srvid, Name]),
            <<Names/binary, Bin/binary>>;
        _ ->
            {ID, Srvid} = mail_adm_db:get_role_info(by_name, Name),
            Bin = util:fbin(<<"[~w,~s,~s]">>, [ID, Srvid, Name]),
            <<Names/binary, Bin/binary>>
    end;
check_send_roles([Name|T], Names) ->
    case role_api:lookup(by_name, Name, to_mail) of
        {ok, _, {ID, Srvid, _}} ->
            Bin = util:fbin(<<"[~w,~s,~s]<Br>">>, [ID, Srvid, Name]),
            check_send_roles(T, <<Names/binary, Bin/binary>>);
        _ ->
            {ID, Srvid} = mail_adm_db:get_role_info(by_name, Name),
            Bin = util:fbin(<<"[~w,~s,~s]<Br>">>, [ID, Srvid, Name]),
            check_send_roles(T, <<Names/binary, Bin/binary>>)
    end.

%% 根据base_id产生物品，如果哟错误的BaseId会生成失败，返回错误信息
check_make_item(ItemIds) ->
    check_make_item(ItemIds, []).
check_make_item([], Items) ->
    Items;
check_make_item([{0, _Bind, _Quantity} | T], Items) ->
    check_make_item(T, Items);
check_make_item([{BaseId, _Bind, _Quantity} | _T], _Items) when not(is_integer(BaseId)) ->
    {false, util:fbin(<<"错误的物品元素 baseid 数据 ~w">>, [BaseId])};
check_make_item([{BaseId, Bind, _Quantity} | _T], _Items) when Bind =/= 0 andalso Bind =/= 1 ->
    {false, util:fbin(<<"错误的物品元素 baseid 数据 ~w 的绑定类型(0/1) ~w">>, [BaseId, Bind])};
check_make_item([{BaseId, _Bind, Quantity} | _T], _Items) when not(is_integer(Quantity)) ->
    {false, util:fbin(<<"错误的物品元素 baseid 数据 ~w 的数量类型 ~w">>, [BaseId, Quantity])};
check_make_item([{BaseId, _Bind, Quantity} | _T], _Items) when Quantity =< 0 ->
    {false, util:fbin(<<"baseid 为 ~w 的物品数量 ~w 必须大于 0">>, [BaseId, Quantity])};
check_make_item([{BaseId, Bind, Quantity} | T], Items) ->
    case item:make(BaseId, Bind, Quantity) of
        {ok, NewItems} ->
            check_make_item(T, NewItems ++ Items);
        false ->
            {false, util:fbin(<<"baseid 为 ~w 的物品元素数据有误">>, [BaseId])}
    end;
check_make_item([_ErrorID | _T], _Items) ->
    {false, util:fbin(<<"非法物品元素数据 ~w">>, [_ErrorID])}.

%% 检测资产的有效性
check_valid_assets(Assets) ->
    check_valid_assets(Assets, []).
check_valid_assets([], Assets) ->
    Assets;
check_valid_assets([{_, 0} | T], Assets) ->
    check_valid_assets(T, Assets);
check_valid_assets([{Type, _Value} | _T], _Assets) when not(is_integer(Type)) ->
    {false, util:fbin("错误的资产类型 ~w", [Type])};
check_valid_assets([{_Type, Value} | _T], _Assets) when not(is_integer(Value)) ->
    {false, util:fbin("错误的资产值 ~w", [{_Type, Value}])};
check_valid_assets([{Type, Value} | _T], _Assets) when Value =< 0 ->
    {false, util:fbin("错误的资产值 ~w，必须大于 0", [{Type, Value}])};
check_valid_assets([{Type, Value} | T], Assets) ->
    check_valid_assets(T, [{Type, Value} | Assets]);
check_valid_assets([_Error | _T], _Assets) ->
    {false, util:fbin("错误的资产元素 ~w", [_Error])}.

bindtype(0) -> <<"非绑定">>;
bindtype(_) -> <<"绑定">>.

%% 
no_duplicate(Roles) -> length(Roles) =:= length(lists:usort(Roles)).


debug(_AdmName, _Sub, _Text, _Names, _IDs, _Assets, _ItemIds) ->
    ?DEBUG("--AdmName---~p~n", [_AdmName]),
    ?DEBUG("--Sub---~p~n", [_Sub]),
    ?DEBUG("--Text---~p~n", [_Text]),
    ?DEBUG("--Names---~p~n", [_Names]),
    ?DEBUG("--IDs---~p~n", [_IDs]),
    ?DEBUG("--Assets---~p~n", [_Assets]),
    ?DEBUG("--ItemIds---~p~n", [_ItemIds]).

debug2(_AdmName, _Sub, _Text, _Type, _Time, _Min, _Max, _Assets, _ItemIds, _Platform) ->
    ?DEBUG("--AdmName---~p~n", [_AdmName]),
    ?DEBUG("--Sub---~p~n", [_Sub]),
    ?DEBUG("--Text---~p~n", [_Text]),
    ?DEBUG("--Type---~p~n", [_Type]),
    ?DEBUG("--Time---~p~n", [_Time]),
    ?DEBUG("--Min---~p~n", [_Min]),
    ?DEBUG("--Max---~p~n", [_Max]),
    ?DEBUG("--Assets---~p~n", [_Assets]),
    ?DEBUG("--ItemIds---~p~n", [_ItemIds]),
    ?DEBUG("--Platform---~p~n", [_Platform]).
