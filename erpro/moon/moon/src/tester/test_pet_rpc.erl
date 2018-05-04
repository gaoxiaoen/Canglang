%%----------------------------------------------------
%% 仙宠系统测试 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(test_pet_rpc).
-export([handle/3]).

-include("common.hrl").
-include("tester.hrl").

%% 返回宠物列表
handle(list, {}, _Tester) ->
    tester:pack_send(12600, {}),
    {ok};
handle(12600, {_RenameNum, _Pets}, _TesterState) ->
    ?DEBUG("收到宠物列表RenameNum:~w Pets:~w",[_RenameNum, _Pets]),
    {ok};

%% 放生一个宠物
handle(del, {Id}, _Tester) ->
    tester:pack_send(12601, {Id}),
    {ok};
handle(12601, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 出战一个宠物
handle(war, {Id}, _Tester) ->
    tester:pack_send(12602, {Id}),
    {ok};
handle(12602, {_Id, _Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w]", [_Id, _Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物休息
handle(rest, {Id}, _Tester) ->
    tester:pack_send(12603, {Id}),
    {ok};
handle(12603, {_Id, _Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w]", [_Id, _Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物升级
handle(upgrade, {Id}, _Tester) ->
    tester:pack_send(12604, {Id}),
    {ok};
handle(12604, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物属性分配
handle(attr, {Id, Xl, Tz, Js, Lq}, _Tester) ->
    tester:pack_send(12605, {Id, Xl, Tz, Js, Lq}),
    {ok};
handle(12605, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物更名
handle(rename, {Id, Name}, _Tester) ->
    tester:pack_send(12606, {Id, Name}),
    {ok};
handle(12606, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 破蛋而出
handle(topet, {ItemId, Id}, _Tester) ->
    tester:pack_send(12607, {ItemId, Id}),
    {ok};
handle(12607, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 购买更名次数
handle(buy_rename, {}, _Tester) ->
    tester:pack_send(12608, {}),
    {ok};
handle(12608, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物继承合并
handle(join, {MainId, SecondId}, _Tester) ->
    tester:pack_send(12609, {MainId, SecondId}),
    {ok};
handle(12609, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物喂养
handle(feed, {Id}, _Tester) ->
    tester:pack_send(12610, {Id}),
    {ok};
handle(12610, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物技能遗忘
handle(feed, {Id, SkillId}, _Tester) ->
    tester:pack_send(12611, {Id, SkillId}),
    {ok};
handle(12611, {_Id, _SkillId, _Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w:~w]", [_Id, _SkillId, _Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物技能合并
handle(skill_join, {MainId, SecondId}, _Tester) ->
    tester:pack_send(12613, {MainId, SecondId}),
    {ok};
handle(12613, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物蛋刷新
handle(refresh, {ItemId, Refresh, IsBatch}, _Tester) ->
    tester:pack_send(12614, {ItemId, Refresh, IsBatch}),
    {ok};
handle(12614, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物潜力提升
handle(potential, {Id, Type, IsProtect}, _Tester) ->
    tester:pack_send(12615, {Id, Type, IsProtect}),
    {ok};
handle(12615, {_Id, _Type, _Asc, _Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w:~w:~w]", [_Id, _Type, _Asc, _Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物洗随
handle(potential, {Id}, _Tester) ->
    tester:pack_send(12616, {Id}),
    {ok};
handle(12616, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w:~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物炼魂
handle(pet_to_item, {Id}, _Tester) ->
    tester:pack_send(12617, {Id}),
    {ok};
handle(12617, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 宠物合并预览
handle(preview, {MainId, SecondId}, _Tester) ->
    tester:pack_send(12619, {MainId, SecondId}),
    {ok};
handle(12619, {_MainId, _SecondId, _Code, _Msg, _PetList}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w:~w:~w]", [_MainId, _SecondId, _Code, _Msg, _PetList]),
    util:cn(_Msg),
    {ok};

%% 服务器推送更新宠物列表
handle(12630, {_Pets}, _TesterState) ->
    ?DEBUG("收到更新宠物列表Pets:~w",[_Pets]),
    {ok};

%% 服务器推送新增宠物列表
handle(12631, {_Pets}, _TesterState) ->
    ?DEBUG("收到新增宠物列表Pets:~w",[_Pets]),
    {ok};

%% 服务器推送删除宠物列表
handle(12632, {_Pets}, _TesterState) ->
    ?DEBUG("收到删除宠物列表Pets:~w",[_Pets]),
    {ok};

%% 服务器推送部分属性更新
handle(12633, {_Id, _GrowVal, _SkillNum}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w]", [_Id, _GrowVal, _SkillNum]),
    {ok};

%% 服务器推送刷新宠物列表
handle(12634, {_Pets}, _TesterState) ->
    ?DEBUG("收到刷新宠物列表Pets:~w",[_Pets]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
