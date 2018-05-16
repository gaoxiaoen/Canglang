%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield
	%%% @Created : 2016-06-23 21:45:46
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield).
-export([scene_lim/0]).
-export([kill_score/0]).
-export([assists_score/0]).
-export([collect_score/0]).
-export([buff_id/0]).
-export([skill_id/0]).
-export([skill_cd/0]).
-export([lim_energy/0]).
-export([energy_add/0]).
-export([energy_extra/0]).
-export([title_score/0]).
-export([title_kill/0]).
-export([logout_cd/0]).
-export([quit_cd/0]).
-include("common.hrl").
-include("battlefield.hrl").
scene_lim() ->30.
kill_score() ->10.
assists_score() ->1.
buff_id() ->40001.
skill_id() ->560000.
lim_energy() ->100.
energy_add() ->10.
energy_extra() ->[{1,10},{2,15},{3,20},{4,25},{5,30}].
collect_score() ->100.
title_score() ->4015.
title_kill() ->4016.
logout_cd() ->60.
quit_cd() ->180.
skill_cd() ->60.
