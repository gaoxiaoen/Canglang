%%----------------------------------------------------
%% 消息通知系统
%% 
%% @author yeahoo2000@gmail.com
%% @author liuweihua(yjbgwxf@gmail.com)
%% @end
%%----------------------------------------------------
-module(notice).
-behaviour(gen_server).
-export([
        send/2
        ,send/3
        ,send/9
        ,send_interface/5
        ,send_interface/6
        ,send_interface/7
        ,send_interface/8
        ,inform/1
        ,inform/2
        ,inform_gainloss/3
        ,alert/1
        ,alert/2
        ,confirm/2
        ,confirm/3
        ,prompt/2
        ,prompt/3
        ,effect/2
        ,role_to_msg/1
        ,item_to_msg/1
        ,items_to_name/1
        ,item2_to_inform/1
        ,item3_to_inform/1
        ,baseid_item3_to_inform/1
        ,gain_to_item3_inform/1
        ,async_notice_board_cast/2
        ,gold/1
        ,charge/2
        ,alert/3
        ,alert/4
        ,notice_said/0
        ,stop_sys_said/0
        ,start_sys_said/0

        ,rumor/1

        ,get_item_msg/1
        ,item_msg/1
        ,get_role_msg/1
        ,get_role_msg/2
        ,get_dungeon_msg/1
        ,get_npc_msg/1
    ]
).

-export([start_link/0 ,cast/1 ,call/1 ,info/1]).
-export([reload/0 ,get_notice_boards/1 ,reload_board/0, claim_notice_attach/2, get_claimable_notice/1, async_claim_notice_attach/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([timeout_notice/1, login/1]).

-include("common.hrl").
-include("role.hrl").
-include("item.hrl").
-include("chat_rpc.hrl").
-include("gain.hrl").
-include("notice.hrl").
-include("link.hrl").
-include("dungeon.hrl").
-include("npc.hrl").
%%
-include("attr.hrl").

%% -define(role_login_notice_send_gap, 60).
-define(said_freq, 300).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
stop_sys_said() ->
    sys_notice ! stop_sys_said.
   
start_sys_said() ->
    sys_notice ! start_sys_said.


%% @spec send(Channel, Style, Rid, SrvId, Name, Sex, Msg) -> ok
%% @type Msg = binary()
%% @type Style = integer()
%% @doc 发送玩家广播信息
%% 1:玩家广播,
%% 带玩家姓名的广播,但是Msg可进行解析,跟玩家直接说话有区别,由玩家点击触发某些系统,系统广播出来
%% 2:系统广播
%% 系统为说话主体,Msg可以附带物品信息组装
%% <div>pos具体位置见显示规范策划文档</div>
%% <pre>
%% 可点击字段可用格式: 
%% {role, Id, SrvId, Name, #3ad6f0}
%% {item, Id, BaseId, quantity}
%% {npc, NpcName, #f65e6a}
%% {str, name, #ffe100}
%% {map, MapId}
%% {open, Id, Name, Color} Id-> 1:锻造00ff24 2:炼炉 00ff24 3:VIP ffff00
%% ----------事件通知可用格式-----------
%% {item2, BaseId, Quantity} 事件物品显示, 不带tips 
%% {str, String, #3ad6f0} 普通带颜色的字段标识
%% {item3, BaseId, Quantity, Bind} 事件物品显示, 带tips
%% 示例1:
%% util:fbin(<<"天降鸿福, 恭喜~s人品大爆棚,铸造中的~s强化至+7">>, ["{role, 1, test_1, yeahoo, #3ad6f0}", "{item, 100, 100001}", 7]);
%% 示例2:
%% 1. <<"{#00ff00}{role, 1, test_1, yeahoo, #3ad6f0} 获得了极品装备 {item, 100, 100001}">>
%% 2. <<"{role, 1, test_1, yeahoo, #3ad6f0} 击败了 {role, 2, test_1, yeahoo1, #3ad6f0}">>
%% </pre>

notice_said() ->
    case db:get_one(?DB_SYS, "SELECT IFNULL(max(id), 1) FROM `sys_notice_said`") of
        {ok, NextId} ->
            Sql = <<"select id, freq, times, text from sys_notice_said where id = ~s">>,
            case db:get_row(Sql, [NextId]) of
                {ok, [_Id, _Freq, _Times, Text]} ->
                    ?DEBUG("---Text---~p~n", [Text]),
                    send_notice_said(Text);
                {error, _Msg} ->
                    ?DEBUG("-----~p~n", [_Msg]),
                    ?DEBUG("-----~w~n", [_Msg]),
                    {false, []}
            end
        end.

send_notice_said(Msg) ->
    role_group:pack_cast(world, 10932, {7, 0, Msg}),
    ok.

rumor(Msg) ->
    send_notice_said(Msg).

%% Special的取值参考role.hrl里面的定义
send(?chat_world, Style, Rid, SrvId, Name, Sex, Vip, Special, Msg) ->     
    case not(is_frequency(world)) of
        true -> role_group:pack_cast(world, 10930, {?chat_world, Style, Rid, SrvId, Name, Sex, Vip, Special, Msg});
        false -> ignore
    end;
send(_, _, _, _, _, _, _, _, _) -> ignore.

%% @spec send(Style, Msg) -> ok
%% @type Msg = binary()
%% @type Style = integer()
%% @doc  系统广播信息
send(Style, Msg) -> role_group:pack_cast(world, 10931, {Style, Msg, []}).
%% 带场景BASEID BaseIds为空,代表不限制场景
send(Style, Msg, BaseIds) when is_list(BaseIds) -> role_group:pack_cast(world, 10931, {Style, Msg, BaseIds}).

%% @spec inform(Pid, Msg) -> ok
%% Msg = bitstring()
%% @doc 特殊样式
%% {item2, BaseId, Quantity} {str, String, #3ad6f0} 
%% 人名: #3ad6f0
inform(Pid, Msg) when is_pid(Pid) ->
    role:pack_send(Pid, 10932, {?chat_sys, 0, Msg});
inform(_, _) -> ok.

%% 转换名称列表
items_to_name(ItemList) when is_list(ItemList) ->
    items_to_name(ItemList, []).
items_to_name([], NameList) -> NameList;
items_to_name([#item{base_id = BaseId} | T], NameList) ->
    case item_data:get(BaseId) of
        {ok, #item_base{name = Name}} ->
            items_to_name(T, [Name | NameList]);
        _ ->
            ?ERR("获取物品名称出错:~w",[BaseId]),
            items_to_name(T, NameList)
    end.

%% allow_intf()
allow_intf() ->
    Data = [],
    Platform =  util:platform(undefined),
    lists:member(Platform, Data).

to_inter_name(ItemName) ->
    to_inter_name(ItemName, <<"">>).
to_inter_name([], Name) -> Name;
to_inter_name([N | T], Name) ->
    NewName = case Name =:= <<"">> of
        true -> util:fbin(<<"~s">>, [N]);
        false -> util:fbin(<<"~s,~s">>,[Name, N])
    end,
    to_inter_name(T, NewName).

%% send_interface
%% 1:龙宫秘境，2:仙府秘境，3:神秘商店，4：boss战斗掉落，5:劫镖公告，6:角色升级，7:进入镇妖塔，8:创建角色，9：进入竞技场，10：结为夫妻， 11：加入帮派，12：上线，13：下线
%% md5(live_info+登录KEY+op+ts)
send_interface({role_id, Id}, OP, RoleName1, BossName, ItemName) ->
    case allow_intf() of
        true -> spawn(fun() -> do_send_interface({role_id, Id}, OP, RoleName1, <<"">>, BossName, ItemName) end);
        false -> skip
    end.
send_interface({role_id, Id}, OP, RoleName1, RoleName2, BossName, ItemName) ->
    case allow_intf() of
        true -> spawn(fun() -> do_send_interface({role_id, Id}, OP, RoleName1, RoleName2, BossName, ItemName) end);
        false -> skip
    end.
do_send_interface({role_id, {Rid, SrvId}}, OP, RoleName1, RoleName2, BossName, ItemName) ->
    case role_api:lookup(by_id, {Rid, SrvId}, [#role.account, #role.link]) of
        {ok, _Node, [Account, #link{conn_pid = ConnPid}]} ->
            Ts = util:unixtime(),
            ServerKey = util:server_key(SrvId),
            Tname = to_inter_name(ItemName),
            L = lists:concat([ServerKey, "bname=", bitstring_to_list(BossName), "op=", OP, "role=", bitstring_to_list(RoleName1), "role2=", bitstring_to_list(RoleName2), "ser=", bitstring_to_list(SrvId), "ts=", Ts, "tn=", bitstring_to_list(Tname), "uid=", bitstring_to_list(Account)]),
            Ticket = util:md5(L),
            sys_conn:pack_send(ConnPid, 10966, {OP, Account, SrvId, RoleName1, RoleName2, BossName, ItemName, Ts, Ticket});
        _ ->
            skip
    end.

send_interface({pid, Pid}, OP, Account, SrvId, RoleName1, BossName, ItemName) when is_pid(Pid) ->
    case allow_intf() of
        true ->
            Ts = util:unixtime(),
            ServerKey = util:server_key(SrvId),
            Tname = to_inter_name(ItemName),
            L = lists:concat([ServerKey, "bname=", bitstring_to_list(BossName), "op=", OP, "role=", bitstring_to_list(RoleName1), "role2=", bitstring_to_list(<<"">>), "ser=", bitstring_to_list(SrvId), "ts=", Ts, "tn=", bitstring_to_list(Tname), "uid=", bitstring_to_list(Account)]),
            Ticket = util:md5(L),
            role:pack_send(Pid, 10966, {OP, Account, SrvId, RoleName1, <<"">>, BossName, ItemName, Ts, Ticket});
        false -> skip
    end;
send_interface({connpid, ConnPid}, OP, Account, SrvId, RoleName1, BossName, ItemName) when is_pid(ConnPid) ->
    case allow_intf() of
        true ->
            Ts = util:unixtime(),
            ServerKey = util:server_key(SrvId),
            Tname = to_inter_name(ItemName),
            L = lists:concat([ServerKey, "bname=", bitstring_to_list(BossName), "op=", OP, "role=", bitstring_to_list(RoleName1), "role2=", bitstring_to_list(<<"">>), "ser=", bitstring_to_list(SrvId), "ts=", Ts, "tn=", bitstring_to_list(Tname), "uid=", bitstring_to_list(Account)]),
            Ticket = util:md5(L),
            Data = {OP, Account, SrvId, RoleName1, <<"">>, BossName, ItemName, Ts, Ticket},
            sys_conn:pack_send(ConnPid, 10966, Data);
        false -> skip
    end.

send_interface({pid, Pid}, OP, Account, SrvId, RoleName1, RoleName2, BossName, ItemName) when is_pid(Pid) ->
    case allow_intf() of
        true ->
            Ts = util:unixtime(),
            ServerKey = util:server_key(SrvId),
            Tname = to_inter_name(ItemName),
            L = lists:concat([ServerKey, "bname=", bitstring_to_list(BossName), "op=", OP, "role=", bitstring_to_list(RoleName1), "role2=", bitstring_to_list(RoleName2), "ser=", bitstring_to_list(SrvId), "ts=", Ts, "tn=", bitstring_to_list(Tname), "uid=", bitstring_to_list(Account)]),
            Ticket = util:md5(L),
            role:pack_send(Pid, 10966, {OP, Account, SrvId, RoleName1, RoleName2, BossName, ItemName, Ts, Ticket});
        false -> skip
    end;
send_interface({connpid, ConnPid}, OP, Account, SrvId, RoleName1, RoleName2, BossName, ItemName) when is_pid(ConnPid) ->
    case allow_intf() of
        true ->
            Ts = util:unixtime(),
            ServerKey = util:server_key(SrvId),
            Tname = to_inter_name(ItemName),
            L = lists:concat([ServerKey, "bname=", bitstring_to_list(BossName), "op=", OP, "role=", bitstring_to_list(RoleName1), "role2=", bitstring_to_list(RoleName2), "ser=", bitstring_to_list(SrvId), "ts=", Ts, "tn=", bitstring_to_list(Tname), "uid=", bitstring_to_list(Account)]),
            Ticket = util:md5(L),
            sys_conn:pack_send(ConnPid, 10966, {OP, Account, SrvId, RoleName1, RoleName2, BossName, ItemName, Ts, Ticket});
        false -> skip
    end.

%% @spec inform(Msg) -> ok
%% Msg = bitstring()
%% @doc 特殊样式
%% {item, BaseId, Quantity} {str, String, #3ad6f0} 
%% 人名: #3ad6f0
%% <div> 角色当前进程调用 </div>
inform(<<>>) -> ignore;
inform(Msg) ->
    case get(conn_pid) of
        undefined -> false;
        Pid ->
            sys_conn:pack_send(Pid, 10932, {?chat_sys, 0, Msg})
    end.

%% @spec inform_gainloss(Rpid, Type, GLlist) ->
%% Rpid = pid()
%% Type = integer()
%% GLlist = [#gain{} | #loss{} | ...]
%% 向客户端发送 损益数据的提示
inform_gainloss(Rpid, Type, GLlist) ->
    {G, L} = format_gl([], [], GLlist),
    role:pack_send(Rpid, 10950, {Type, G, L}).

%% @spec item2_to_inform(Item) -> BinStr 
%% @doc 将单个物品或者物品列表信息组装成事件格式
%% 该组装格式的物品不带tips 
item2_to_inform({ItemBaseId, Bind, Q}) when is_integer(ItemBaseId) ->
    case item:make(ItemBaseId, Bind, Q) of
        {ok, Items} ->
            item2_to_inform(Items);
        _ ->
            <<>>
    end;
item2_to_inform(Item = #item{quantity = Q, base_id = BaseId}) when is_record(Item, item) ->
    Bstr = util:fbin(<<"{item2, ~w, ~w}">>, [BaseId, Q]),
    Bstr;
item2_to_inform(ItemList) when is_list(ItemList)->
    item2_to_inform(ItemList, <<>>).
item2_to_inform([], Bin) -> Bin;
item2_to_inform([#item{quantity = Q, base_id = BaseId} | T], Bin) ->
    Bstr = case T =:= [] of
        true -> util:fbin(<<"~s{item2, ~w, ~w}">>, [Bin, BaseId, Q]);
        false -> util:fbin(<<"~s{item2, ~w, ~w}，">>, [Bin, BaseId, Q])
    end,
    item2_to_inform(T, Bstr).

%% @spec item3_to_inform(Item) -> BinStr 
%% @doc 将单个物品或者物品列表信息组装成事件格式
%% 注意: 带tips的物品只能是Item的基础数据,像交易类的物品改变过数据,无法满足tips
%% 该组装格式的物品带tips 
item3_to_inform(Item = #item{quantity = Q, bind = Bind, base_id = BaseId}) when is_record(Item, item) ->
    Bstr = util:fbin(<<"{item3, ~w, ~w, ~w}">>, [BaseId, Q, Bind]),
    Bstr;
item3_to_inform(ItemList) when is_list(ItemList)->
    item3_to_inform(ItemList, <<>>).
item3_to_inform([], Bin) -> Bin;
item3_to_inform([#item{quantity = Q, bind = Bind, base_id = BaseId} | T], Bin) ->
    Bstr = case T =:= [] of
        true -> util:fbin(<<"~s{item3, ~w, ~w, ~w}">>, [Bin, BaseId, Q, Bind]);
        false -> util:fbin(<<"~s{item3, ~w, ~w, ~w}，">>, [Bin, BaseId, Q, Bind])
    end,
    item3_to_inform(T, Bstr).

%% @spec gains_to_inform(Gain) -> BinStr 
%% @doc 将单个奖励物品或者物品列表信息组装成事件格式
%% 注意: 带tips的物品只能是Item的基础数据,像交易类的物品改变过数据,无法满足tips
%% 该组装格式的物品带tips 
gain_to_item3_inform(#gain{label = item, val = [BaseId, Bind, Q]}) ->
    Bstr = util:fbin(<<"{item3, ~w, ~w, ~w}">>, [BaseId, Q, Bind]),
    Bstr;
gain_to_item3_inform(GainList) when is_list(GainList)->
    gain_to_item3_inform(GainList, <<>>).
gain_to_item3_inform([], Bin) -> Bin;
gain_to_item3_inform([#gain{label = item, val = [BaseId, Bind, Q]} | T], Bin) ->
    Bstr = case T of
        [] -> util:fbin(<<"~s{item3, ~w, ~w, ~w}">>, [Bin, BaseId, Q, Bind]);
        [#gain{label = Label}] when Label =/= item -> util:fbin(<<"~s{item3, ~w, ~w, ~w}">>, [Bin, BaseId, Q, Bind]);
        _ -> util:fbin(<<"~s{item3, ~w, ~w, ~w}，">>, [Bin, BaseId, Q, Bind])
    end,
    gain_to_item3_inform(T, Bstr);
gain_to_item3_inform([_G | T], Bin) ->
    gain_to_item3_inform(T, Bin).

%% @spec baseid_item3_to_inform(ItemidList) -> bitstring();
%% @doc 将物品列表组装成事件格式，并发送，这里物品每一个列表格式如下 {基础ID，是否绑定, 物品数量} 
%% 注意: 带tips的物品只能是Item的基础数据,像交易类的物品改变过数据,无法满足tips
%% 该组装格式的物品带tips 
baseid_item3_to_inform([]) -> <<>>;
baseid_item3_to_inform(L = [{_, _, _} | _]) ->
    baseid_item3_to_inform(L, []).
baseid_item3_to_inform([], BackL) ->
    item3_to_inform(BackL);
baseid_item3_to_inform([{BaseId, Bind, Num} | T], BackL) ->
    case item:make(BaseId, Bind, Num) of
        false ->
            ?ERR("物品【~w, ~w, ~w】make 失败", [BaseId, Bind, Num]),
            baseid_item3_to_inform(T, BackL);
        {ok, ItemList} ->
            baseid_item3_to_inform(T, BackL ++ ItemList)
    end.

%% @spec alert(Type, Msg) -> true | false
%% Type = integer()
%% Msg = bitstring()
%% @doc 给玩家发送一个alert信息(只在角色进程内才能调用成功)
%% <div>Type为显示界面的类型，0:表示默认界面</div>
alert(Msg) -> alert(0, Msg).
alert(Type, Msg) ->
    case get(conn_pid) of
        undefined -> false;
        Pid ->
            sys_conn:pack_send(Pid, 10940, {Type, Msg})
    end.

%% @spec confirm(Type, Msg, Callback) -> true | false
%% Type = integer()
%% Msg = bitstring()
%% Callback = mfa()
%% @doc 询问玩家确认某个操作(只在角色进程内才能调用成功)
%% <div>Type为显示界面的类型，0:表示默认界面</div>
%% <div>回调Callback时会在原参数Args前面自动加上两个参数，变为: [角色数据#role{} | [玩家的选择结果 | Args]]</div>
%% <div>对Callback的返回值要求: {ok} | {ok, NewRole}</div>
confirm(Msg, {M, F, A}) -> confirm(0, Msg, {M, F, A}).
confirm(Type, Msg, {M, F, A}) ->
    case get(confirm_idx) of
        [H | T] ->
            put({confirm_info, H}, {M, F, A}),
            sys_conn:pack_send(get(conn_pid), 10941, {H, Type, Msg}),
            put(confirm_idx, T ++ [H]),
            true;
        _ ->
            false
    end.

%% @spec prompt(Type, Msg, Callback) -> bool()
%% @spec prompt(ConnPid, Type, Msg, Callback) -> bool()
%% Type = integer()
%% Msg = bitstring()
%% Callback = mfa()
%% @doc 给玩家发送一个prompt消息(只在角色进程内才能调用成功)
%% <div>Type为显示界面的类型，0:表示默认界面</div>
%% <div>回调Callback时会在原参数Args前面自动加上两个参数，变为: [角色数据#role{} | [玩家的输入结果 | Args]]</div>
%% <div>对Callback的返回值要求: {ok} | {ok, NewRole}</div>
prompt(Msg, {M, F, A}) -> prompt(0, Msg, {M, F, A}).
prompt(Type, Msg, {M, F, A}) ->
    case get(prompt_idx) of
        [H | T] ->
            put({prompt_info, H}, {M, F, A}),
            sys_conn:pack_send(get(conn_pid), 10942, {H, Type, Msg}),
            put(prompt_idx, T ++ [H]),
            true;
        _ ->
            false
    end.

%% @spec effect(Arg, Msg) -> any()
%% Arg = Type::integer() | {Type::integer(), RolePid::pid()} | {Type::integer(), MapId::integer(), X, Y}
%% Msg = bitstring()
%% @doc 特效广播接口, 全服或不全服由type控制
%% <div> Type：
%% 特效类型0-送花 1-蓝色妖姬 2-康乃馨 5-至尊铜币大奖 6-陨石 10-婚礼烟花 11-婚庆礼炮 12-黄月季 13-我喜欢你，14-求包养，15-七夕快乐，16-今夜私奔，17-永结同心 18-教师节送花 19-我要脱光 20-光棍万岁, 21-雪球, 22-元旦快乐, 23-蛇年吉祥, 24-情定2013, 25-求桃花运, 26-2012走你, 27-春节快乐 28-金蛇献瑞 29-恭贺新禧,  31-香水百合， 32-花蝶密语， 33-星语星愿, 34-定情钻戒
%% </div>
effect(Args, Msg) when is_integer(Args) ->
    role_group:pack_cast(world, 10999, {Args, Msg});
effect({Type, Pid}, Msg) when is_pid(Pid) ->
    role:pack_send(Pid, 10999, {Type, Msg});
effect({Type, MapId, X, Y}, Msg) ->
    map:pack_send_to_near(MapId, {X, Y}, 10999, {Type, Msg});
effect(_, _) -> ok.

%% @spec role_to_msg(RoleInfo) -> BinStr
%% RoleInfo = #role{} | {RoleId, SrvId, Name}
%% @doc 聊天广播将Role成链接
role_to_msg(Role = #role{id = {_Rid, _SrvId}, name = Name}) when is_record(Role, role)->
    Name;
role_to_msg({_RoleId, _SrvId, Name}) ->
    Name;

role_to_msg(Name) ->
    Name_Color = notice_color:get_color_name(), 
    Msg = util:fbin(<<"<u><font color='~s'>~s</font></u>">>, [Name_Color, Name]),
    Msg.

item_to_msg(T = {ItemName, Quality, Num}) when is_tuple(T)->
    Item_Color = notice_color:get_color_item(Quality),
    Msg = util:fbin(<<"<font color='~s'>【~s】x ~w</font>">>, [Item_Color, ItemName, Num]),
    Msg;
%% @spec item_to_msg(Item) -> BinStr
%% @doc 将单个物品或者物品列表信息发送到聊天框
item_to_msg(Item = #item{quantity = Q, base_id = BaseId}) when is_record(Item, item) ->
    Id = item_srv_cache:add(Item),
    Bstr = util:fbin(<<"{item, ~w, ~w, ~w}">>, [Id, BaseId, Q]),
    Bstr;
item_to_msg({ItemBaseId, Bind, Q}) when is_integer(ItemBaseId) ->
    case item:make(ItemBaseId, Bind, Q) of
        {ok, Items} ->
            item_to_msg(Items);
        _ ->
            <<>>
    end;
item_to_msg(ItemList) when is_list(ItemList)->
    item_to_msg(ItemList, <<>>);
item_to_msg(List = [{_, _, _} | _T]) ->
    item_to_msg(List, <<>>).

item_to_msg([], Bin) -> Bin;
item_to_msg([Item = #item{quantity = Q, base_id = BaseId} | T], Bin) ->
    Id = item_srv_cache:add(Item),
    Bstr = case Bin =:= <<>> of
            false->
                util:fbin(<<"{item, ~w, ~w, ~w}  ~s">>, [Id, BaseId, Q, Bin]);
            true->
                util:fbin(<<"{item, ~w, ~w, ~w}~s">>, [Id, BaseId, Q, Bin])
    end,
    item_to_msg(T, Bstr);
item_to_msg([{ItemBaseId, Bind, Q} | T], Bin) ->
    case item:make(ItemBaseId, Bind, Q) of
        {ok, Items} ->
            NewBin = item_to_msg(Items, Bin),
            item_to_msg(T, NewBin);
        _ ->
            item_to_msg(T, Bin)
    end.


%%<a href='11100&99999'><u><font color='FF6F1B1B'>忠诚之剑</font></u></a>
%%<a href='11100&99999'><font color='FF6F1B1B'>【忠诚之剑】x3</font></a>
%%<a href='11001&玩家名&玩家id&srv_id'><font color='FF6F1B1B'>玩家名</font></a>其他内容<a href='11100&99999'><font color='FF6F1B1B'>【忠诚之剑】x3</font></a>	

get_item_msg(Item = #item{base_id = ItemBaseId}) ->
    {ok, #item_base{name = Name, quality = Q}} = item_data:get(ItemBaseId),
    Id = item_srv_cache:add(Item),
    Item_Color = notice_color:get_color_item(Q),
    util:fbin(<<"<a href='11100&~w'><font color='~s'>【~s】x~w</font></a>" >>, [Id, Item_Color, Name, 1] );

%% Items -> [{ItemBaseId, Bind, Num}]
%% -> <<>>
get_item_msg(Items) ->
    do_item_msg(Items, <<>>).

do_item_msg([], Msg) -> Msg;
do_item_msg([I | T], Msg) ->
    ItemMsg = item_msg(I),
    M = util:fbin(<<"~s ~s">>, [Msg, ItemMsg]),
    do_item_msg(T, M).

item_msg([ItemBaseId, Bind, Num]) ->
    item_msg({ItemBaseId, Bind, Num});
item_msg({ItemBaseId, Bind, Num}) ->
    case item:make(ItemBaseId, Bind, Num) of
        {ok, [Item | _T]} ->
            {ok, #item_base{name = Name, quality = Q}} = item_data:get(ItemBaseId),
            Id = item_srv_cache:add(Item),
            Item_Color = notice_color:get_color_item(Q),
            util:fbin(<<"<a href='11100&~w'><font color='~s'>【~s】x~w</font></a>" >>, [Id, Item_Color, Name, Num] );
        _ ->
            <<>>
    end.

get_role_msg(#role{name = RoleName, id = Rid}) ->
    get_role_msg(RoleName, Rid).

get_role_msg(RoleName, {RoleId, SrvId}) ->
    Color  = notice_color:get_color_name(), 
    util:fbin(<<"<a href='11101&~s&~w&~s'><u><font color='~s'>~s</font></u></a>">>, [RoleName, RoleId, SrvId, Color, RoleName]).

get_dungeon_msg(DungeonId) ->
    Color  = notice_color:get_color_dungeon(),
    #dungeon_base{name = Name} = dungeon_data:get(DungeonId),
    util:fbin(<<"<font color='~s'>【~s】</font>">>, [Color, Name]).

get_npc_msg(NpcBaseId) ->
    Color  = notice_color:get_color_npc(),
    {ok, #npc_base{name = Name}} = npc_data:get(NpcBaseId),
    util:fbin(<<"<font color='~s'>【~s】</font>">>, [Color, Name]).

%% @spec get_notice_boards(Role) -> List
%% @doc 获取系统公告板内容
get_notice_boards(#role{pid = Pid}) ->
    info({notice_board, Pid}).

%% @spec get_claimable_notice(Role) - ok
%% @doc 获取可领取附件公告
get_claimable_notice(#role{id = {Rid, Srvid}, link = #link{conn_pid = ConnPid}}) ->
    info({claimable_notice_board, {Rid, Srvid}, ConnPid}).

%% @spec claim_notice_attach(ID, Role) -> ok
%% @doc 领取公告附件
claim_notice_attach(ID, #role{id = {Rid, Srvid}, name = Name, pid = Pid}) ->
    cast({claim_notice_attach, ID, Rid, Srvid, Name, Pid}).

%% @spec async_claim_notice_attach(Role, Notice) -> {ok} | {ok, NewRole}
%% @doc 异步调用领取附件
async_claim_notice_attach(#role{link = #link{conn_pid = ConnPid}}, 
    #notice_board{id = ID, coin = 0, gold = 0, bind_coin = 0, bind_gold = 0, items = Items}
) when length(Items) =:= 0 ->
    sys_conn:pack_send(ConnPid, 10963, {?true, <<>>, ID}),
    {ok};

async_claim_notice_attach(Role = #role{id = {Rid, Srvid}, name = Name, link = #link{conn_pid = ConnPid}}, 
    #notice_board{id = ID, coin = Coin, gold = Gold, bind_coin = BC, bind_gold = BG, items = Items}
) ->
    L = pack_gain_list(Gold, Coin, BG, BC, Items, []),
    case role_gain:do(L, Role) of
        {ok, NewRole} ->
            notice:inform(util:fbin(?L(<<"获得 ~s">>), [baseid_item3_to_inform(Items)])),
            sys_conn:pack_send(ConnPid, 10963, {?true, ?L(<<"领取公告附件成功">>), ID}),
            case Gold > 0 of
                true -> inform(util:fbin(?L(<<"\n获得 {str,晶钻,#FFD700} ~p">>), [Gold]));
                false -> ok
            end,
            case Coin > 0 of
                true -> inform(util:fbin(?L(<<"\n获得 {str,金币,#FFD700} ~p">>), [Coin]));
                false -> ok
            end,
            case BG > 0 of
                true -> inform(util:fbin(?L(<<"\n获得 {str,绑定晶钻,#FFD700} ~p">>), [BG]));
                false -> ok
            end,
            case BC > 0 of
                true -> inform(util:fbin(?L(<<"\n获得 {str,绑定金币,#FFD700} ~p">>), [BC]));
                false -> ok
            end,
            log:log(log_coin, {<<"公告附件">>, <<"">>, Role, NewRole}),
            log:log(log_gold, {<<"公告附件">>, <<"">>, Role, NewRole}),
            {ok, NewRole};
        _ ->
            sys_conn:pack_send(ConnPid, 10963, {?false, ?L(<<"领取失败，请检查您背包是否有足够空间来存放附件！">>), ID}),
            cast({claim_notice_attach_fail, ID, Rid, Srvid, Name}),
            {ok}
    end.
pack_gain_list(Gold, Coin, BindGold, BindCoin, [], L) ->
    [#gain{label = gold, val = Gold}, #gain{label = gold_bind, val = BindGold}, #gain{label = coin, val = Coin}, #gain{label = coin_bind, val = BindCoin} | L ];
pack_gain_list(Gold, Coin, BindGold, BindCoin, [{BaseId, Bind, Num} | Items], L) ->
    pack_gain_list(Gold, Coin, BindGold, BindCoin, Items, [#gain{label = item, val = [BaseId, Bind, Num]}| L]).

%% 广播全服公告
login(#role{id = RoleId, pid = Pid}) ->
    info({login, RoleId, Pid}),
    ok.

notice_board_cast(Notices) ->
    OnlinePids = role_adm:online_roles(pid),
    Fun = fun(Pid) -> catch role:apply(async, Pid, {?MODULE, async_notice_board_cast, [Notices]}) end,
    lists:foreach(Fun, OnlinePids).

async_notice_board_cast(Role = #role{link = #link{conn_pid = ConnPid}}, Notices) ->
    case sift_notice(Role, Notices) of
        [] -> {ok};
        MNotices ->
            sys_conn:pack_send(ConnPid, 10960, {MNotices}),
            {ok}
    end.

%% TODO
%% timeout_notice() ->
timeout_notice(ID) ->
    gen_server:cast({global, ?MODULE}, {timeout_notice, ID}).

%% 查询指定角色充值晶钻
gold(RoleId) ->
    case ets:lookup(charge_info_for_notice,  RoleId) of
        [{_, Gold}] -> Gold;
        _ -> 0
    end.

%% 有新充值的
charge(#role{id = RoleId}, Gold) ->
    info({charge, RoleId, Gold}).

%% @spec cast(Msg) -> ok
%% Msg = term()
%% @doc 向系统公告发送一个handle_cast消息
cast(Msg) ->
    gen_server:cast({global, ?MODULE}, Msg).

%% @spec call(Msg) -> Reply
%% Msg = term()
%% Reply = term()
%% @doc 向系统公告发送一个handle_call请求消息
call(Msg) ->
    gen_server:call({global, ?MODULE}, Msg).

%% @spec info(Msg) -> ok
%% Msg = term()
%% @doc 向公告系统发送一个handle_info消息
info(Msg) ->
    catch sys_notice ! Msg,
    ok.

%% @spec reload() -> ok
%% @doc 重载系统公告
reload() ->
    info(reload).

%% @spec reload_board() -> ok
%% @doc 重载公告板内容
reload_board() ->
    info(reload_board).

%% @doc 启动服务
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%%----------------------------------------------------
%% 内部实现
%%----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    self() ! reload,
    self() ! reload_board,
    self() ! broadcast,
    self() ! init_charge_info,
    MidNight = util:unixtime({today, util:unixtime()}) + 86400,
    erlang:send_after((MidNight - util:unixtime() + 120) * 1000, self(), midnight),     %% 每天凌晨定时读取一次数据库获取最新公告
    ets:new(charge_info_for_notice, [set, named_table, public, {keypos, 1}, {read_concurrency, true}]),
    erlang:register(sys_notice, self()),

    Said_Data = said_data:get_all(),
    put(said_data, {Said_Data, erlang:length(Said_Data), 1, util:unixtime()}),
    put(stop_sys_said, ?false),
    % erlang:send_after(5 * 1000, self(), said),     %% 开始系统自带的传闻

    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #notice_state{}}.

%%---------------------------------------------------------------------
%% handle_call
%%---------------------------------------------------------------------
handle_call(lookup, _From, State) ->
    {reply, {ok, State}, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%---------------------------------------------------------------------
%% handle_cast
%%---------------------------------------------------------------------
%% 领取附件
handle_cast({claim_notice_attach, ID, Rid, Srvid, Name, Pid}, State = #notice_state{boards = Boards}) ->
    case check_claim(Rid, Srvid, ID) of
        false ->
            role:pack_send(Pid, 10963, {?false, ?L(<<"您已经领取过该公告附件，请勿重复领取!">>), ID}),
            {noreply, State};
        NoticeClaim ->
            Now = util:unixtime(),
            case lists:keyfind(ID, #notice_board.id, Boards) of
                false ->
                    role:pack_send(Pid, 10963, {?false, ?L(<<"您来晚了，该公告已失效！">>), ID}),
                    {noreply, State};
                Notice = #notice_board{time = Time} when Time > Now ->
                    role:apply(async, Pid, {notice, async_claim_notice_attach, [Notice]}),
                    NewNoticeClaim = [{ID, Time, util:unixtime()} | NoticeClaim],
                    save_claim_notice_attach(Rid, Srvid, Name, NewNoticeClaim),
                    put({Rid, Srvid, notice_claim}, NewNoticeClaim),
                    {noreply, State};
                _ ->
                    role:pack_send(Pid, 10963, {?false, ?L(<<"您来晚了，该公告已失效！">>), ID}),
                    {noreply, State}
            end
    end;

%% 领取附件失败
handle_cast({claim_notice_attach_fail, ID, Rid, Srvid, Name}, State) ->
    case get({Rid, Srvid, notice_claim}) of
        undefined ->
            {noreply, State};
        NoticeClaim ->
            NewNoticeClaim = [{NID, Vtime, Ctime} || {NID, Vtime, Ctime} <- NoticeClaim, Vtime >= util:unixtime(), NID =/= ID],
            save_claim_notice_attach(Rid, Srvid, Name, NewNoticeClaim),
            put({Rid, Srvid, notice_claim}, NewNoticeClaim),
            {noreply, State}
    end;

%% 清掉过期的公告
handle_cast({timeout_notice, ID}, State) ->
    self() ! {out_date_notice, ID},
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%%---------------------------------------------------------------------------
%% handle_info
%%---------------------------------------------------------------------------
handle_info(stop_sys_said, State) ->
    put(stop_sys_said, ?true),
    {noreply, State};

handle_info(start_sys_said, State) ->
    put(stop_sys_said, ?false),
    erlang:send_after(1 * 1000, self(), said),
    {noreply, State};


handle_info(said, State) ->
    case get(stop_sys_said) of 
        ?false ->
            case get(said_data) of
                {Data, Length, Nth, LastTime} ->
                    Now = util:unixtime(),
                    Nth2 = 
                        case Nth > Length of 
                            false ->
                               Nth;
                            true ->
                                1
                        end,
                    Said = #notice_said{id = Id, times = Times, times_cur = Times_Cur, content = Content} = lists:nth(Nth2, Data),
                    ?DEBUG("---Content--~s~n", [Content]),
                    % send_notice_said(Content),
                    role_group:pack_cast(world, 10932, {6, 0, Content}),
                    case Times =/= 0 andalso Times_Cur + 1 > Times of 
                        true -> 
                            put(said_data, {lists:keydelete(Id, #notice_said.id, Data), Length - 1, Nth2, Now});
                        false ->
                            NData = lists:keyreplace(Id, #notice_said.id, Data, Said#notice_said{times_cur = Times_Cur + 1}),                             
                            put(said_data, {NData, Length, Nth2 + 1, Now})
                    end,

                    case util:is_same_day2(LastTime, Now) of 
                        true ->
                            ok;
                        _ ->
                            Said_Data = said_data:get_all(),
                            put(said_data, {Said_Data, erlang:length(Said_Data), 1, util:unixtime()})
                    end,
                    erlang:send_after(?said_freq * 1000, self(), said);
                _ -> ok
            end;
        _ -> ok
    end,
    {noreply, State};


handle_info(midnight, State) ->
    erlang:send_after(86400 * 1000, self(), midnight),
    self() ! reload,
    {noreply, State};

handle_info(broadcast, State) ->
    self() ! top,           %% 广播顶部公告
    self() ! left,          %% 广播左下公告
    {noreply, State};

%% 从数据库重载公告
handle_info(reload, _State = #notice_state{boards = NoticeBoards}) ->
    NewState = notice_db:load(),
    {noreply, NewState#notice_state{boards = NoticeBoards}};

%% 顶部定时公告
handle_info(top, State = #notice_state{top_gap = Gap, top = Notices}) ->
    %?DEBUG("send top notice ~p : ~p", [Gap, Notices]),
    erlang:send_after(Gap * 1000, self(), top),
    case broadcast(Notices) of
        false ->
            %?DEBUG("broadcast false!"),
            {noreply, State};
        {Msg, NewOrderNotices} ->
            %?DEBUG("broadcast ~p", [Msg]),
            send(15, Msg),
            {noreply, State#notice_state{top = NewOrderNotices}}
    end;

%% 左下角公告
handle_info(left, State = #notice_state{left_gap  = Gap, left = Notices}) ->
    %?DEBUG("send left notice ~p : ~p", [Gap, Notices]),
    erlang:send_after(Gap * 1000, self(), left),
    case broadcast(Notices) of
        false ->
            %?DEBUG("broadcast false!"),
            {noreply, State};
        {Msg, NewOrderNotices} ->
            %?DEBUG("broadcast ~p", [Msg]),
            send(56, Msg),
            {noreply, State#notice_state{left = NewOrderNotices}}
    end;

%%---------------------------------------------------------------------
%% 公告板内容
%%---------------------------------------------------------------------
%% 角色登陆
%% handle_info({login , RoleId, Pid}, State) ->
%%    erlang:send_after(?role_login_notice_send_gap * 1000, self(), {notice_board, Pid}),
%%    erlang:send_after(?role_login_notice_send_gap * 1000, self(), {claimable_notice_board, RoleId, Pid}),
%%    {noreply, State};

%% 公告板内容
handle_info({notice_board, Pid}, State = #notice_state{boards = Boards}) ->
    catch role:apply(async, Pid, {?MODULE, async_notice_board_cast, [ [Notice || Notice = #notice_board{time = Time} <- Boards, Time > util:unixtime()] ]}),
    {noreply, State};

%% 可领取附件公告版内容
handle_info({claimable_notice_board, {Rid, Srvid}, ConnPid}, State = #notice_state{boards = Boards}) ->
    case get({Rid, Srvid, notice_claim}) of
        undefined ->
            catch sys_conn:pack_send(ConnPid, 10965, {[{ID} || #notice_board{id = ID} <- Boards]}),
            {noreply, State};
        NoticeClaim ->
            ClaimID = [{CID} || {CID, _, _} <- NoticeClaim],
            AbleID = [{ID} || #notice_board{id = ID, time = Time} <- Boards, Time > util:unixtime()],
            catch sys_conn:pack_send(ConnPid, 10965, {AbleID -- ClaimID}),
            {noreply, State}
    end;

%% 从数据库重载通用公告板   注意这个在 系统公告后载入
handle_info(reload_board, State) ->
    Boards = notice_db:load_boards(),
    Now = util:unixtime(),
    {FutureBoards, NowBoards} = {[B || B = #notice_board{stime = St} <- Boards, St > Now], [B || B = #notice_board{stime = St} <- Boards, St =< Now]},
    OrderBoards = lists:reverse(lists:keysort(#notice_board.id, NowBoards)),
    Fun = fun(#notice_board{id = ID, time = Time}) -> erlang:send_after((Time - util:unixtime()) * 1000, self(), {out_date_notice, ID}) end,
    lists:foreach(Fun, NowBoards),
    notice_board_cast(OrderBoards),
    load_claim_attach_log(),
    FunFu = fun(#notice_board{id = ID, stime = Stime}) -> erlang:send_after((Stime - util:unixtime()) * 1000, self(), {new_notice_board, ID}) end,
    lists:foreach(FunFu, FutureBoards),
    {noreply, State#notice_state{boards = OrderBoards, future_boards = FutureBoards}};

%% 清除一条公告版内容
handle_info({out_date_notice, ID}, State = #notice_state{boards = Boards}) ->
    NewBoards = lists:keydelete(#notice_board.id, ID, Boards),
    role_group:pack_cast(world, 10962, {ID}),
    {noreply, State#notice_state{boards = NewBoards}};

%% 开始发公告
handle_info({new_notice_board, ID}, State = #notice_state{boards = Boards, future_boards = FB}) ->
    case lists:keyfind(ID, #notice_board.id, FB) of
        Notice = #notice_board{time = Time} ->
            Now = util:unixtime(),
            case Time < Now of
                true ->
                    {noreply, State};
                false ->
                    erlang:send_after((Time - Now) * 1000, self(), {out_date_notice, ID}),
                    NewBoards = lists:reverse(lists:keysort(#notice_board.id, [Notice | Boards])),
                    notice_board_cast(NewBoards),
                    {noreply, State#notice_state{boards = NewBoards, future_boards = lists:keydelete(ID, #notice_board.id, FB)}}
            end;
        false ->
            {noreply, State}
    end;

%% 初始化充值信息
handle_info(init_charge_info, State) ->
    RmbRoleInfo = notice_db:charge_info_for_notice(),
    ets:insert(charge_info_for_notice, RmbRoleInfo),
    {noreply, State};

%% 新充值玩家
handle_info({charge, RoleId, Gold}, State) ->
    OldGold =  gold(RoleId),
    ets:insert(charge_info_for_notice, {RoleId, OldGold + Gold}),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%%----------------------------------------------------------
%% terminate
%%----------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%-----------------------------------------------------------
%% code_change
%%-----------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%-----------------------------------------------------------
%% 私有函数
%%-----------------------------------------------------------

%% @doc     检查玩家广播是否频繁
%% @spec    is_frequency(atom()) -> true | false
is_frequency(world) -> %% 世界频道间隔:10秒
    is_frequency(chat_to_world, 10);

is_frequency(guild) ->
    is_frequency(chat_to_guild, 3);

is_frequency(team) ->
    is_frequency(chat_to_team, 3);

is_frequency(friend) ->
    is_frequency(chat_to_friend, 3);

is_frequency(_) -> %% 其它频道间隔:2秒
    is_frequency(chat_to_other, 2).

%% @doc     检查相应频道发言是否频繁
%% @spec    is_frequency(Type, N) -> true | false
%% @type    Type = atom()  
%% @type    N = integer()
is_frequency(Type, N) ->
    case get(Type) of
        T when is_integer(T) ->
            Now = util:unixtime(),
            case (Now - T) < N of
                true ->
                    true;
                false ->
                    put(Type, Now),
                    false
            end;
        _ ->
            put(Type, util:unixtime()),
            false
    end.

%% 格式化损益
format_gl(G, L, []) -> {G, L};
format_gl(G, L, [H|T]) ->
    case do_format_gl(H) of
        undefined -> format_gl(G, L, T);
        {gain, R} -> format_gl([R|G], L, T);
        {loss, R} -> format_gl(G, [R|L], T)
    end.

do_format_gl(Rec) when is_record(Rec, gain) ->
    #gain{label = Label, val = Val} = Rec,
    R = case Label of
        exp -> {0, 0, Val};
        exp_per -> {1, 1, Val};
        gold -> {2, 2, Val};
        gold_bind -> {2, 2, Val};
        coin -> {3, 3, Val};
        coin_bind -> {3, 3, Val};
        coin_all -> {3, 3, Val};
        psychic -> {4, 4, Val};
        psychic_per -> {5, 5, Val};
        honor -> {6, 6, Val};
        energy -> {7, 7, Val};
        attainment -> {8, 8, Val};
        guild_contrib -> {9, 9, Val};
        item -> 
            [BaseId, _, Quantity] = Val,
            {10, BaseId, Quantity};
        _ -> ?ERR("不支持的物品类型:~w", [Label]), undefined
    end,
    {gain, R};
do_format_gl(Rec) when is_record(Rec, loss) ->
    #loss{label = Label, val = Val} = Rec,
    R = case Label of
        exp -> {0, 0, Val};
        exp_per -> {1, 1, Val};
        gold -> {2, 2, Val};
        gold_bind -> {2, 2, Val};
        coin -> {3, 3, Val};
        coin_bind -> {3, 3, Val};
        coin_all -> {3, 3, Val};
        psychic -> {4, 4, Val};
        psychic_per -> {5, 5, Val};
        honor -> {6, 6, Val};
        energy -> {7, 7, Val};
        attainment -> {8, 8, Val};
        guild_contrib -> {9, 9, Val};
        item -> 
            [BaseId, _, Quantity] = Val,
            {10, BaseId, Quantity};
        _ -> ?ERR("不支持的物品类型:~w", [Label]), undefined
    end,
    {loss, R};
do_format_gl(Rec) ->
    ?ERR("格式化损益错误:~w", [Rec]),
    undefined.

%% 导入领取日志
load_claim_attach_log() ->
    lists:foreach(
        fun({Rid, Srvid, Notice}) -> 
                put({Rid, Srvid, notice_claim}, Notice) 
        end, 
        notice_db:load_claim_attach_log()).

%% 检测是否可以领取公告附件
check_claim(Rid, Srvid, ID) ->
    case get({Rid, Srvid, notice_claim}) of
        undefined ->
            [];
        Notice ->
            case lists:keyfind(ID, 1, Notice) of
                false ->
                    Notice;
                _ ->
                    false
            end
    end.

%% 广播公告
broadcast([]) -> false;         %% 没有公告
broadcast(Notices) ->           %% 有公告
    broadcast(Notices, []).
broadcast([], _Notices) ->      %% 不需要播放任何公告
    false;
broadcast([H = #notice{start = Beg, finish = End, msg = Msg} | T], Notices) -> 
    Now = util:unixtime(),
    case Now >= Beg of          %% 注：beg 为 0 时 Now 肯定大于 Beg，beg 为 0 表示不受开始时间限制
        false ->                %% 还没开始
            broadcast(T, Notices ++ [H]);
        true ->                 %% 过了开始时间
            case Now < End orelse End =:= 0 of  %% End 为 0 不受结束时间限制
                true ->         %% 播放到时
                    {Msg, T ++ Notices ++ [H]};
                false ->        %% 公告已经过时
                    broadcast(T, Notices)
            end
    end.

%% 保存领取记录到数据库
save_claim_notice_attach(Rid, Srvid, Name, NoticeClaim) ->
    spawn(notice_db, save_claim_notice_attach, [Rid, Srvid, Name, NoticeClaim]).

sift_notice(Role, Notices) ->
    sift_notice(Role, Notices, []).
sift_notice(_Role, [], Sifted) -> Sifted;
sift_notice(Role, [N = #notice_board{condition = Conditions} | Notices], Sifted) ->
    case satisfy_notice_condition(Role, Conditions) of
        true -> sift_notice(Role, Notices, [N | Sifted]);
        false -> sift_notice(Role, Notices, Sifted)
    end.

satisfy_notice_condition(_Role, []) ->
    true;
satisfy_notice_condition(Role = #role{lev = Lev}, [["lev", Min, Max] | Conditions]) ->
    case Lev >= Min andalso Lev =< Max of
        true -> satisfy_notice_condition(Role, Conditions);
        false -> false
    end;
satisfy_notice_condition(Role = #role{attr = #attr{fight_capacity = FC}}, [["fight", Min, Max] | Conditions]) ->
    case FC >= Min andalso FC =< Max of
        true -> satisfy_notice_condition(Role, Conditions);
        false -> false
    end;
satisfy_notice_condition(Role = #role{id = RoleId}, [["charge", Min, Max] | Conditions]) ->
    Gold = gold(RoleId), 
    case Gold >= Min andalso Gold =< Max of
        true -> satisfy_notice_condition(Role, Conditions);
        false -> false
    end;
satisfy_notice_condition(Role = #role{sex = Sex}, [["sex", CSex] | Conditions]) ->
    case Sex =:= CSex of
        true -> satisfy_notice_condition(Role, Conditions);
        false -> false
    end;
satisfy_notice_condition(Role = #role{career = Career}, [["career", Careers] | Conditions]) ->
    case lists:member(Career, Careers) of
        true -> satisfy_notice_condition(Role, Conditions);
        false -> false
    end;
satisfy_notice_condition(_Role, [Condition | _Conditions]) ->
    ?ERR("unknow notice condition is ~w", [Condition]),
    false.


%% ------------------------------------------------
%% 所有人发
alert(succ, world, MsgId) when is_integer(MsgId) ->
    role_group:pack_cast(world, 11101, {MsgId}),
    ok;
alert(error, world, MsgId) when is_integer(MsgId) ->
    role_group:pack_cast(world, 11102, {MsgId}), 
    ok;
alert(common, world, MsgId) when is_integer(MsgId) ->
    role_group:pack_cast(world, 11103, {MsgId}),
    ok;

alert(succ, world, Msg) ->
    role_group:pack_cast(world, 11111, {Msg}),
    ok;
alert(error, world, Msg) ->
    role_group:pack_cast(world, 11112, {Msg}), 
    ok;
alert(common, world, Msg) ->
    role_group:pack_cast(world, 11113, {Msg}),
    ok;

%% 发单个人 
%% -> ok
alert(Type, #role{link = #link{conn_pid = ConnPid}}, MsgId) ->
    alert(Type, ConnPid, MsgId);   

alert(succ, ConnPid, MsgId) when is_integer(MsgId) ->
    sys_conn:pack_send(ConnPid, 11101, {MsgId}),
    ok;
alert(error, ConnPid, MsgId) when is_integer(MsgId) ->
    sys_conn:pack_send(ConnPid, 11102, {MsgId}), 
    ok;
alert(common, ConnPid, MsgId) when is_integer(MsgId) ->
    sys_conn:pack_send(ConnPid, 11103, {MsgId}),
    ok;

alert(succ, ConnPid, Msg) ->
    sys_conn:pack_send(ConnPid, 11111, {Msg}),
    ok;
alert(error, ConnPid, Msg) ->
    sys_conn:pack_send(ConnPid, 11112, {Msg}), 
    ok;
alert(common, ConnPid, Msg) ->
    sys_conn:pack_send(ConnPid, 11113, {Msg}),
    ok.


%% 发所有人
alert(succ, world, MsgId, Args) when is_integer(MsgId) ->
    role_group:pack_cast(world, 11121, {MsgId, Args}),
    ok;
alert(error, world, MsgId, Args) when is_integer(MsgId) ->
    role_group:pack_cast(world, 11122, {MsgId, Args}), 
    ok;
alert(common, world, MsgId, Args) when is_integer(MsgId) ->
    role_group:pack_cast(world, 11123, {MsgId, Args}),
    ok;

%% 发单个人
alert(Type, #role{link = #link{conn_pid = ConnPid}}, MsgId, Args) ->
    alert(Type, ConnPid, MsgId, Args);

alert(succ, ConnPid, MsgId, Args) when is_integer(MsgId) ->
    sys_conn:pack_send(ConnPid, 11121, {MsgId, Args}),
    ok;
alert(error, ConnPid, MsgId, Args) when is_integer(MsgId) ->
    sys_conn:pack_send(ConnPid, 11122, {MsgId, Args}), 
    ok;
alert(common, ConnPid, MsgId, Args) when is_integer(MsgId) ->
    sys_conn:pack_send(ConnPid, 11123, {MsgId, Args}),
    ok.

