%%----------------------------------------------------
%% @doc 转换任务系统损益处理
%%
%% <pre>
%% 需要打印任务的损益处理， 
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(task_gain).

-export([
        convert/2
        ,rebuild_rewards/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("task.hrl").
-include("assets.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("attr.hrl").
-include("storage.hrl").

-define(EQM_ID, [101001,101101,101201,101301,101401,101501,101601,101701,101801,101901,102001,102101,102201,102301,102401,102501,102601,102701,102801,102901,103001,103101,103201,103301,103401,103501,103601,103701,103801,103901]).

%% @spec convert(GainLoseList::[#gain{} | #loss{}], Role::#role{}) -> [#gain{} | #loss{}]
%% @doc
%% 转换一船动态的损益处理为普通的损益处理,好像未使用
convert([], _Role) -> [];
convert([GL | T], Role) ->
    case convert(GL, Role) of
        {false, GL} ->
            ?ELOG("[任务系统]损益处理转换遇到非法标签GL:~w", [GL]),
            convert(T, Role);
        NewGL -> 
            [NewGL | convert(T, Role)]
    end;

%% 选择损益物品
convert(G = #gain{label = item_random, val = ItemList, msg = Msg}, _Role) ->
    L = length(ItemList),
    case L > 0 of
        true ->
            Item = lists:nth(random:uniform(L), ItemList),
            #gain{label = item, val = Item, msg = Msg};
        false -> {false, G}
    end;
convert(L = #loss{label = item_random, val = ItemList, msg = Msg}, _Role) ->
    L = length(ItemList),
    case L > 0 of
        true ->
            Item = lists:nth(random:uniform(L), ItemList),
            #loss{label = item, val = Item, msg = Msg};
        false -> {false, L}
    end;

%% 占位函数
convert(GL, _Role) ->
    GL.

%% 重构奖励内容
%% @spec rebuild_rewards(GLList, Task::#task{}) -> NewGLList
%% @doc 重构奖励内容 
rebuild_rewards([], _Task, _FinishImm) -> [];
rebuild_rewards([#gain{label = exp} | T], Task = #task{type = ?task_type_bh, accept_num = AcceptNum}, FinishImm) when AcceptNum =/= 1 ->
    rebuild_rewards(T, Task, FinishImm);
rebuild_rewards([#gain{label = exp} | T], Task = #task{type = ?task_type_sm, accept_num = AcceptNum}, FinishImm) when  AcceptNum =/= 1 ->
    rebuild_rewards(T, Task, FinishImm);
rebuild_rewards([GL = #gain{label = item, val = [BaseId, _, _]} | T], Task, FinishImm) ->
    case lists:member(BaseId, ?EQM_ID) of
        true ->
            rebuild_rewards(T, Task, FinishImm);
        false ->
            [GL | rebuild_rewards(T, Task, FinishImm)]
    end;
rebuild_rewards([#loss{label = _Label} | T], Task, ?true) ->
    rebuild_rewards(T, Task, ?true);
rebuild_rewards([GL | T], Task, FinishImm) ->
    [GL | rebuild_rewards(T, Task, FinishImm)].
