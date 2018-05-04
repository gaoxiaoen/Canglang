%% -*- coding: latin-1 -*-
%% GM模块，只在测试模式下使用，
%% 注：
%%   此文件使用 latin-1 编码，直接支持使用中文描述

-module(mod_gm).

-include("mgeew.hrl").

%% API
-export([
         handle/1,
         do_cmd/2
        ]).

%% @hidden
handle({?SYSTEM, ?SYSTEM_GM, DataRecord, RoleId, _PId, _Line}) ->
    do_gm(RoleId,DataRecord);

handle(Info) ->
    ?ERROR_MSG("receive unknown message,info=~w", [Info]).

do_gm(RoleId,DataRecord) ->
    #m_system_gm_tos{code=Command} = DataRecord,
    Result = do_cmd(RoleId,Command),
    ?ERROR_MSG("do gm command result:~w",[Result]),
    ok.

-define(GM_LANG_SUCC,"命令执行成功").
-define(GM_LANG_FAIL,"命令执行失败").
%% GM命令，执行处理
%% Commond 字符串，命令有“ ”空格分隔，如：
%% "help" 显示帮助信息
%% "add_gold 100" 增加元宝 100
%% "add_silver 100" 增加金币 100
%% "add_coin 100" 增加银币 100
%% "lv 10" 提升等级到10级
%% "add_exp 1000" 增加1000点经验 
%% "energy 100" 设置活力值
%% Result 命令执行操作结果返回
-spec
do_cmd(RoleId,Command) -> Result when
    RoleId :: integer(),
    Command :: string(),
    Result :: string().
do_cmd(RoleId,Command) ->
    case common_config:is_debug() of
        true ->
            ParamList = string:tokens(Command, " "),
            do_command(ParamList,RoleId);
        _ ->
            "无法处理此操作"
    end.
do_command(["help"],_RoleId) ->
    "所有GM命令使用说明：\n" ++ 
        "    \"help\":帮助信息\n" ++
        "    \"lv 10\":设置等级\n" ++
        "    \"add_exp 1000\":增加1000点经验\n" ++
        "    \"gold 100\":设置元宝\n" ++
        "    \"silver 100\":设置金币\n" ++
        "    \"coin 100\":设置银币\n" ++
        "    \"energy 100\":设置活力值\n" ++
        "    \"add_hp 100\":设置血量值\n" ++
        "    \"add_mp 100\":设置魔法值\n" ++
        "    \"add_anger 100\":设置怒气值\n" ++
        "\n";
%% @doc 设置等级
do_command(["lv", Val], RoleId) ->
    RoleLevel = list_to_integer(Val),
    [MaxLevel] = common_config_dyn:find(etc, max_role_level),
    case RoleLevel > MaxLevel of
        true ->
            "等只开放到" ++ erlang:integer_to_list(MaxLevel) ++ "级，设置失败";
        _ ->
            common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_level,{RoleId,RoleLevel}}}),
            ?GM_LANG_SUCC
    end;
%% @doc 增加经验
do_command(["add_exp", Val], RoleId) ->
    AddExp = list_to_integer(Val),
    common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_base_attr,{RoleId,AddExp}}}),
    ?GM_LANG_SUCC;
%% @doc 设置元宝
do_command(["gold", Val], RoleId) ->
    Glod = list_to_integer(Val),
    common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_base_attr,{RoleId,#p_role_base.gold,Glod}}}),
    ?GM_LANG_SUCC;
%% @doc 设置银币
do_command(["silver", Val], RoleId) ->
    Silver = list_to_integer(Val),
    common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_base_attr,{RoleId,#p_role_base.silver,Silver}}}),
    ?GM_LANG_SUCC;
%% @doc 设置铜钱
do_command(["coin", Val], RoleId) ->
    Coin = list_to_integer(Val),
    common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_base_attr,{RoleId,#p_role_base.coin,Coin}}}),
    ?GM_LANG_SUCC;
%% @doc 设置活力值
do_command(["energy", Val], RoleId) ->
    Energy = list_to_integer(Val),
    common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_base_attr,{RoleId,#p_role_base.energy,Energy}}}),
    ?GM_LANG_SUCC;

%% @doc 设置血量值
do_command(["add_hp",Val],RoleId) ->
    AddHp = list_to_integer(Val),
    common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_fight_attr,{RoleId,#p_fight_attr.hp,AddHp}}}),
    ?GM_LANG_SUCC;
%% @doc 设置魔值
do_command(["add_mp",Val],RoleId) ->
    AddMp = list_to_integer(Val),
    common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_fight_attr,{RoleId,#p_fight_attr.mp,AddMp}}}),
    ?GM_LANG_SUCC;
%% @doc 设置怒气值
do_command(["add_anger",Val],RoleId) ->
    AddAnger = list_to_integer(Val),
    common_misc:send_to_role(RoleId, {mod,mod_role_gm,{admin_set_role_fight_attr,{RoleId,#p_fight_attr.anger,AddAnger}}}),
    ?GM_LANG_SUCC;

%% @doc 添加BUFF
do_command(["add_buff", Val], RoleId) ->
    BuffId = list_to_integer(Val),
    mod_buff:add_object_buff(RoleId, ?ACTOR_TYPE_ROLE, BuffId, 0, 1),
    ?GM_LANG_SUCC;

%% @doc 删除BUFF
do_command(["del_buff", Val], RoleId) ->
    BuffId = list_to_integer(Val),
    mod_buff:delete_object_buff(RoleId, ?ACTOR_TYPE_ROLE, BuffId),
    ?GM_LANG_SUCC;

%% @hidden
do_command(ParamList, RoleId) ->
    ?ERROR_MSG("Role:~w unknown gm command, info:~w",[RoleId, ParamList]),
    "命令无法解释执行，请重新输入".



