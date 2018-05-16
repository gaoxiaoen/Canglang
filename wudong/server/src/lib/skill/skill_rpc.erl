%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 一月 2015 上午11:10
%%%-------------------------------------------------------------------
-module(skill_rpc).
-author("fancy").
-include("common.hrl").
-include("server.hrl").

%% API
-export([handle/3]).

%%技能列表
handle(21001, Player, _) ->
    skill:get_skill_list(Player),
    ok;

%%主动技能学习
handle(21002, Player, {SkillId}) ->
    {Code, Player2} = skill:learn_skill(Player, SkillId),
    {ok, Bin} = pt_210:write(21002, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player2};

%%主动技能升级
handle(21003, Player, {SkillId}) ->
    {Code, Player2} = skill:upgrade_skill(Player, SkillId),
    {ok, Bin} = pt_210:write(21003, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player2};

%%被动技能学习
handle(21004, Player, {SkillId}) ->
    {Code, Player2} = skill:learn_skill_passive(Player, SkillId),
    {ok, Bin} = pt_210:write(21004, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player2};

%%被动技能升级
handle(21005, Player, {SkillId}) ->
    {Code, Player2} = skill:upgrade_skill_passive(Player, SkillId),
    {ok, Bin} = pt_210:write(21005, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attr, Player2};


%%职业技能熟练度升级
handle(21006, Player, {SkillId}) ->
    {Code, Player2} = skill:upgrade_career_skill(Player, SkillId),
    {ok, Bin} = pt_210:write(21006, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attr, Player2};

%%切换主技能效果
handle(21007, Player, {SkillEffect}) ->
    {Ret, NewPlayer} = skill:change_skill_effect(Player, SkillEffect),
    {ok, Bin} = pt_210:write(21007, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


handle(_cmd, _Player, _Data) ->
    ok.
