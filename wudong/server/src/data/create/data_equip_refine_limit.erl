%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_equip_refine_limit
	%%% @Created : 2017-07-10 11:07:54
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_equip_refine_limit).
-export([equip_refine_lim/1]).
-include("error_code.hrl").
-include("equip.hrl").
equip_refine_lim(1) -> 5;
equip_refine_lim(2) -> 10;
equip_refine_lim(3) -> 20;
equip_refine_lim(4) -> 40;
equip_refine_lim(5) -> 60;
equip_refine_lim(6) -> 90;
equip_refine_lim(7) -> 130;
equip_refine_lim(8) -> 180;
equip_refine_lim(9) -> 230;
equip_refine_lim(10) -> 290;
equip_refine_lim(11) -> 350;
equip_refine_lim(12) -> 420;
equip_refine_lim(13) -> 490;
equip_refine_lim(14) -> 570;
equip_refine_lim(15) -> 650;
equip_refine_lim(_) -> 0.
