%% ************************
%% 技能rpc测试模块
%% wprehard@qq.com
%% ************************

-module(test_skill_rpc).
-export([handle/3]).
-include("common.hrl").
-include("skill.hrl").

handle(get_skills, {}, _Tester) ->
    tester:pack_send(11500, {}),
    {ok};
handle(11500, {_List}, _Tester) ->
    ?DEBUG("角色技能列表：~w", [_List]),
    {ok};

handle(upgrade_skill, {SkillId}, _Tester) ->
    ?DEBUG("请求学习技能[ID:~w]", [SkillId]),
    tester:pack_send(11501, {SkillId}),
    {ok};
handle(11501, {_Msg, _SkillId, _NewSkill}, _Tester) ->
    ?DEBUG("升级技能返回[Msg:~w, SkillId:~w, NewSkill：~w]", [_Msg, _SkillId, _NewSkill]),
    {ok};

handle(11503, {}, _Tester) ->
    ?DEBUG("技能可升级通知"),
    {ok};

handle(get_append_skill, {}, _Tester) ->
    ?DEBUG("请求已加等级技能列表"),
    tester:pack_send(11504, {}),
    {ok};
handle(11504, {_Data}, _Tester) ->
    ?DEBUG("已加等级的技能列表返回[List:~w]", [_Data]),
    {ok};

handle(get_shortcuts, {}, _Tester) ->
    tester:pack_send(11540, {}),
    {ok};
handle(11540, {_List}, _Tester) ->
    ?DEBUG("技能快捷栏列表：~w", [_List]),
    {ok};

handle(fill_shortcuts, {Index, SkillId}, _Tester) ->
    tester:pack_send(11541, {Index, SkillId}),
    {ok};
handle(11541, {_Ret}, _Tester) ->
    ?DEBUG("技能拖放快捷栏失败: ~w", [_Ret]),
    {ok};

handle(change_shortcuts, {Index1, Index2}, _Tester) ->
    tester:pack_send(11542, {Index1, Index2}),
    {ok};
handle(11542, {_Ret}, _Tester) ->
    ?DEBUG("技能替换快捷栏失败: ~w", [_Ret]),
    {ok};

handle(_Cmd, _Msg, _Tester) ->
    {error, unknown_command}.
