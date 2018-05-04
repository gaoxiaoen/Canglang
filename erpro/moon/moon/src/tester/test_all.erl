%%----------------------------------------------------
%% 测试集合
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_all).
-export([
        run/1
        ,handle/3
    ]
).
-include("common.hrl").
-include("tester.hrl").

run(_Tester) ->
    %% ---------------------------------------------------
    %% GM命令测试
    %%----------------------------------------------------
    tester:cmd(test_role_adm_rpc, test_all, {}),

    %%----------------------------------------------------
    %% 物品测试
    %%----------------------------------------------------
    tester:cmd(test_item_rpc, bag_item, {}),
    tester:cmd(test_item_rpc, store_item, {}),
    %% tester:cmd(test_item_rpc, move_bag_item, {1, 1, 3}),
    %% tester:cmd(test_item_rpc, move_store_item, {1, 1, 3}),
    %% tester:cmd(test_item_rpc, del_item, {2, 1}),
    tester:cmd(test_item_rpc, use_item, {0, 1}),
    tester:cmd(test_item_rpc, eqm_item, {}),
    tester:cmd(test_item_rpc, bag_item, {}),
    tester:cmd(test_item_rpc, use_item, {3, 1}),
    tester:cmd(test_item_rpc, eqm_item, {}),
    tester:cmd(test_item_rpc, bag_item, {}),
    tester:cmd(test_blacksmith_rpc, get_info, {1, 1}), 
    tester:cmd(test_blacksmith_rpc, train_eqm, {1, 1, 1}),
    %%----------------------------------------------------
    %% 角色测试
    %%----------------------------------------------------
    tester:cmd(test_role_rpc, get_attr, {}),
    %% tester:cmd(test_role_rpc, get_other_attr, {2, <<116,101,115,116,95,49>>}),
    tester:cmd(test_role_rpc, sit, {}),
    tester:cmd(test_role_rpc, cancel_sit, {}),
    tester:cmd(test_role_rpc, get_assets, {}),

    %% -----------------------------------------
    %% 组队测试
    %% -----------------------------------------
    tester:cmd(test_team_rpc, create_team, {}),

    %% -----------------------------------------
    %% 技能UI测试
    %% -----------------------------------------
    tester:cmd(test_skill_rpc, get_skills, {}),

    %% ---------------------------------------------------
    %% 任务测试
    %%----------------------------------------------------
    tester:cmd(test_task_rpc, test_all, {}), %% 获取已接任务列表

    %%----------------------------------------------------
    %% 排行榜测试
    %%----------------------------------------------------
    tester:cmd(test_rank_rpc, coin_list, {}),
    tester:pack_send(10100, {}),

    %% ---------------------------------------------------
    %% 商城测试
    %%----------------------------------------------------
    tester:cmd(test_shop_rpc, test_all, {}),

    %% ---------------------------------------------------
    %% 好友测试
    %% ---------------------------------------------------
    tester:cmd(test_friend_rpc, test_all, {}),
    ok.

%% 请求发送Buff列表
handle(run, {}, Tester) ->
    run(Tester),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
