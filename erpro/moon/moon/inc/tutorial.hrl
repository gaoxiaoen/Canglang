%----------------------------------------------------
%% 新手引导
%% @author qingxuan
%%----------------------------------------------------

-define(tutorial_map, 120).  %% 新手场景
-define(tutorial_npc1, 10298).  %% 第一个怪
-define(tutorial_npc1_pos_x, 1521).
-define(tutorial_npc1_pos_y, 500).
-define(tutorial_npc2, 10299).  %% 第二个怪
-define(tutorial_npc2_pos_x, 2168).
-define(tutorial_npc2_pos_y, 500).

%% 新手流程阶段(小于255表示还没结束新手剧情)
-define(tutorial_step_init, 0).
-define(tutorial_step_finish, 255).

-record(tutorial, {
    step = ?tutorial_step_init
    ,npc = [1]   %% 要打的两个怪物的npc id
}).


-define(tutorial_handle(Cmd, Data, Role), 
        handle(Cmd, Data, Role = #role{tutorial = #tutorial{}}) -> tutorial_rpc:handle(Cmd, Data, Role) ).

% -define(tutorial_handle(Cmd, Data, Role), 
%         handle(_Cmd, _Data, skip) -> {ok} ).
