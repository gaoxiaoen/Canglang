%% ********************************
%% 结拜系统rpc处理模块
%% @author lishen (105326073@qq.com)
%% ********************************
-module(sworn_rpc).
-export([handle/3]).

-include("role.hrl").
-include("gain.hrl").
%%
-include("sworn.hrl").
-include("common.hrl").


%% -------------------------------------
%% 对外接口
%% -------------------------------------
%% 请求结拜
handle(16301, {Type}, Role = #role{ride = Ride}) 
when Ride =:= ?ride_fly -> %% 取消飞行
    NewRole = Role#role{ride = ?ride_no},
    team:update_ride(NewRole),
    handle(16301, {Type}, NewRole);
handle(16301, {Type}, Role = #role{action = Action})
when Action >= ?action_sit andalso Action =< ?action_sit_lovers -> %% 取消打坐
    handle(16301, {Type}, sit:handle_sit(?action_no, Role));
handle(16301, {Type}, Role)
when Type =:= 1 orelse Type =:= 2 ->
    LossList = type2loss(Type),
    role:send_buff_begin(),
    case role_gain:do(LossList, Role) of
        {false, #loss{msg = Msg}} ->
            role:send_buff_clean(),
            {reply, {0, Type, Msg}};
        {ok, NewRole} ->
            case sworn:check_propose_sworn(NewRole) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, Type, Reason}};
                {ok, Role2} when Type =:= ?SWORN_LOD ->
                    case sworn:start_fight(Type, NewRole, Role2) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {0, Type, Reason}};
                        ok ->
                            role:send_buff_flush(),
                            {reply, {1, Type, <<>>}, NewRole}
                    end;
                {ok, Role2} ->
                    case sworn:start_sworn(Type, NewRole, Role2) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {0, Type, Reason}};
                        ok ->
                            role:send_buff_flush(),
                            log:log(log_coin, {<<"结拜">>, <<"普通结拜">>, Role, NewRole}),
                            {reply, {1, Type, <<>>}, NewRole}
                    end;
                {ok, Role2, Role3} when Type =:= ?SWORN_LOD ->
                    case sworn:start_fight(Type, NewRole, Role2, Role3) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {0, Type, Reason}};
                        ok ->
                            role:send_buff_flush(),
                            {reply, {1, Type, <<>>}, NewRole}
                    end;
                {ok, Role2, Role3} ->
                    case sworn:start_sworn(Type, NewRole, Role2, Role3) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {0, Type, Reason}};
                        ok ->
                            role:send_buff_flush(),
                            log:log(log_coin, {<<"结拜">>, <<"普通结拜">>, Role, NewRole}),
                            {reply, {1, Type, <<>>}, NewRole}
                    end
            end
    end;

%% 请求修改自定义称号
handle(16302, {}, Role = #role{id = Id}) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> {reply, {0, 0, ?L(<<"您确定您已经结拜过了吗？">>)}};
        [SwornInfo = #sworn_info{is_award = IsAward}] ->
            case sworn:check_propose_title(Role, SwornInfo) of
                {false, Reason} ->
                    {reply, {0, 0, Reason}};
                {ok, Num} ->
                    case IsAward =:= ?true of
                        true ->
                            {reply, {1, Num, <<>>}};
                        false ->
                            {reply, {2, Num, <<>>}}
                    end
            end
    end;
    
%% 设置自定义称号
handle(16303, {Head, Tail}, _Role) when byte_size(Head) =/= 6 orelse byte_size(Tail) =/= 3 ->
    {reply, {0, ?L(<<"称号长度不正确">>)}};
handle(16303, {Head, Tail}, Role = #role{id = Id}) ->
    case {util:text_banned(Head), util:text_banned(Tail)} of
        {false, false} ->
            role:send_buff_begin(),
            case ets:lookup(ets_role_sworn, Id) of
                [] -> {reply, {0, ?L(<<"您确定您已经结拜过了吗？">>)}};
                [SwornInfo = #sworn_info{is_award = ?false}] ->
                    case sworn:set_title(Head, Tail, Role, SwornInfo) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {0, Reason}};
                        {ok, NewRole} ->
                            role:send_buff_flush(),
                            {reply, {1, <<>>}, NewRole}
                    end;
                [SwornInfo = #sworn_info{is_award = ?true}] ->
                    case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, self_title, null), msg = ?L(<<"晶钻不足，无法修改称号">>)}], Role) of
                        {false, #loss{msg = Msg}} ->
                            role:send_buff_clean(),
                            {reply, {0, Msg}};
                        {ok, Role1} ->
                            case sworn:edit_title(Head, Tail, Role1, SwornInfo) of
                                {false, Reason} ->
                                    role:send_buff_clean(),
                                    {reply, {0, Reason}};
                                {ok, NewRole} ->
                                    role:send_buff_flush(),
                                    {reply, {1, <<>>}, NewRole}
                            end
                    end
            end;
        _ ->
            {reply, {0, ?L(<<"称号存在敏感词，和谐社会请尽量不要使用敏感词">>)}}
    end;

%% 请求加入新成员
handle(16304, {}, Role = #role{id = Id}) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> {reply, {0, <<>>, ?L(<<"您确定您已经结拜过了吗？">>)}};
        [SwornInfo] ->
            case sworn:check_propose_add(Role, SwornInfo) of
                {false, Reason} ->
                    {reply, {0, <<>>, Reason}};
                {ok, Name} ->
                    {reply, {1, Name, <<>>}}
            end
    end;

%% 确定新成员加入
handle(16305, {}, Role = #role{id = Id}) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> {reply, {0, ?L(<<"您确定您已经结拜过了吗？">>)}};
        [SwornInfo] ->
            role:send_buff_begin(),
            case sworn:add_member(Role, SwornInfo) of
                {false, Reason} ->
                    role:send_buff_clean(),
                    {reply, {0, Reason}};
                {ok, NewRole} ->
                    role:send_buff_flush(),
                    {reply, {1, <<>>}, NewRole}
            end
    end;

%% 请求割袍断义
handle(16306, {}, #role{id = Id}) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> {reply, {0, [], ?L(<<"您确定您已经结拜过了吗？">>)}};
        [SwornInfo] ->
            case sworn:check_propose_del(SwornInfo) of
                {false, Reason} ->
                    {reply, {0, [], Reason}};
                {ok, NameList} ->
                    {reply, {1, NameList, <<>>}}
            end
    end;

%% 割袍断义
handle(16307, {}, Role = #role{id = Id}) ->
    case ets:lookup(ets_role_sworn, Id) of
        [] -> {reply, {0, ?L(<<"您确定您已经结拜过了吗？">>)}};
        [SwornInfo] ->
            role:send_buff_begin(),
            case role_gain:do([#loss{label = gold, val = pay:price(?MODULE, break_less, null), msg = ?L(<<"解除结义关系是要付出一定代价的，请准备好晶钻再来">>)}], Role) of
                {false, #loss{msg = Msg}} ->
                    role:send_buff_clean(),
                    {reply, {0, Msg}};
                {ok, Role1} ->
                    case sworn:del_member(Role1, SwornInfo) of
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {0, Reason}};
                        {ok, NewRole} ->
                            role:send_buff_flush(),
                            {reply, {1, <<>>}, NewRole}
                    end
            end
    end;

%% 请求结拜所需金币和晶钻
handle(16309, {}, _) ->
    case check_camp_time() of
        true -> %% 5.20活动
            {reply, {?SWORN_COMMON_COIN, ?CAMP_SWORN_LOD_GOLD}};
        false ->
            {reply, {?SWORN_COMMON_COIN, ?SWORN_LOD_GOLD}}
    end;

%% 容错
handle(_Cmd, _Data, _Role) ->
    {error, unknown_command}.

%% -------------------------------------
%% 私有函数
%% -------------------------------------
type2loss(?SWORN_COMMON) ->
    [#loss{label = coin, val = ?SWORN_COMMON_COIN, msg = ?L(<<"虽说情谊值万金但是你连几个金币都没有，怎么结拜？">>)}];
type2loss(?SWORN_LOD) ->
    case check_camp_time() of
        true ->
            [#loss{label = gold, val = ?CAMP_SWORN_LOD_GOLD, msg = ?L(<<"晶钻不够啦！">>)}];
        false ->
            [#loss{label = gold, val = ?SWORN_LOD_GOLD, msg = ?L(<<"晶钻不够啦！">>)}]
    end.

%% 判断是否有优惠活动
check_camp_time() ->
    {Y, M, D} = date(),
    Flag1 = (Y =:= 2013 andalso M =:= 2 andalso (D >= 12 andalso D =< 16)), %% 活动2 2/12 - 2/16
    Flag2 = campaign_adm:is_camp_time(sworn),
    Flag1 orelse Flag2.
