%% **********************
%% 挂机系统数据结构
%% @author  wpf (wprehard@qq.com)
%% **********************
-module(hook_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").

%% 购买挂机次数晶钻数
-define(GOLD_200, pay:price(?MODULE, hook_times, null)).
-define(BUY_CNT, 200).
%% 挂机状态
-define(HOOK_ING, 1).
-define(HOOK_NO, 0).

%% 同步挂机数据
handle(13200, {}, #role{auto = {IsHook, Cnt, BuyCnt, _}}) ->
    {reply, {IsHook, Cnt + BuyCnt}};

%% 购买挂机次数
handle(13201, {}, Role = #role{auto = {IsHook, Cnt, BuyCnt, Time}}) ->
    LossList = [#loss{label = gold, val = ?GOLD_200, msg = ?L(<<"晶钻不足">>)}],
    role:send_buff_begin(),
    case role_gain:do(LossList, Role) of
        {false, #loss{err_code = ErrCode, msg = Msg}} ->
            role:send_buff_clean(),
            {reply, {ErrCode, Cnt + BuyCnt, Msg}};
        {ok, NR} ->
            role:send_buff_flush(),
            NewRole = NR#role{auto = {IsHook, Cnt, BuyCnt + ?BUY_CNT, Time}},
            {reply, {?true, Cnt + BuyCnt + ?BUY_CNT, <<>>}, NewRole}
    end;

%% 开始挂机
handle(13205, {}, R = #role{event = ?event_no, auto = {_, Cnt, BuyCnt, _}}) when Cnt > 0 orelse BuyCnt > 0 ->
    {reply, {?true, <<>>}, R#role{auto = {?HOOK_ING, Cnt, BuyCnt, util:unixtime()}}};
handle(13205, {}, R = #role{event = ?event_dungeon, auto = {_, Cnt, BuyCnt, _}}) when Cnt > 0 orelse BuyCnt > 0 ->
    case hook:check_hook_map(R) of
        ok ->
            {reply, {?true, <<>>}, R#role{auto = {?HOOK_ING, Cnt, BuyCnt, util:unixtime()}}};
        {false, Msg} ->
            {reply, {?false, Msg}}
    end;
handle(13205, {}, R = #role{event = ?event_super_boss, auto = {_, Cnt, BuyCnt, _}}) when Cnt > 0 orelse BuyCnt > 0 ->
    case hook:check_hook_map(R) of
        ok ->
            {reply, {?true, <<>>}, R#role{auto = {?HOOK_ING, Cnt, BuyCnt, util:unixtime()}}};
        {false, Msg} ->
            {reply, {?false, Msg}}
    end;
handle(13205, {}, #role{auto = {_, 0, 0, _}}) ->
    {reply, {0, ?L(<<"挂机次数不足, 您可以花费30晶钻购买200次战斗次数">>)}};
handle(13205, {}, _) ->
    {reply, {0, ?L(<<"当前活动中不允许挂机">>)}};

%% 取消；注意：战斗中取消，会少扣一次，策划允许
handle(13206, {}, #role{auto = {?HOOK_NO, _, _, _}}) ->
    {reply, {?true, <<>>}};
handle(13206, {}, R = #role{auto = {_, Cnt, BuyCnt, Time}}) ->
    {reply, {?true, <<>>}, R#role{auto = {?HOOK_NO, Cnt, BuyCnt, Time}}};

%%战力天平
handle(13230, {}, Role) ->
    Reply = hook:calc_all_point(Role),
    {reply, {Reply}};

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
