
-module(equip_wash_data).
-export([get/1, get_rate/1]).
-include("item.hrl").


get(101021)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(101031)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(101032)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(101041)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(101042)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(101043)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(101051)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(101052)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(101053)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(101054)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(101061)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(101062)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(101063)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(101064)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(101065)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(101071)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(101072)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(101073)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(101074)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(101075)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(101076)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(101121)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101131)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(101132)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(101141)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(101142)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(101143)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(101151)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(101152)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(101153)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(101154)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(101161)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(101162)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(101163)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(101164)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(101165)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(101171)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(101172)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(101173)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(101174)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(101175)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(101176)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(101221)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101231)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(101232)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(101241)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(101242)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(101243)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(101251)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(101252)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(101253)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(101254)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(101261)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(101262)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(101263)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(101264)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(101265)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(101271)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(101272)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(101273)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(101274)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(101275)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(101276)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(101321)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101331)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(101332)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(101341)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(101342)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(101343)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(101351)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(101352)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(101353)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(101354)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(101361)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(101362)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(101363)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(101364)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(101365)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(101371)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(101372)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(101373)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(101374)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(101375)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(101376)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(101421)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101431)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(101432)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(101441)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(101442)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(101443)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(101451)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(101452)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(101453)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(101454)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(101461)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(101462)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(101463)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(101464)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(101465)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(101471)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(101472)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(101473)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(101474)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(101475)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(101476)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(101521)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101531)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(101532)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(101541)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(101542)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(101543)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(101551)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(101552)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(101553)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(101554)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(101561)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(101562)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(101563)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(101564)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(101565)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(101571)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(101572)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(101573)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(101574)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(101575)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(101576)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(101621)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101631)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(101632)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(101641)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(101642)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(101643)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(101651)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(101652)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(101653)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(101654)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(101661)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(101662)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(101663)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(101664)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(101665)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(101671)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(101672)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(101673)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(101674)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(101675)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(101676)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(101721)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(101731)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(101732)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(101741)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(101742)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(101743)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(101751)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(101752)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(101753)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(101754)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(101761)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(101762)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(101763)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(101764)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(101765)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(101771)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(101772)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(101773)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(101774)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(101775)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(101776)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(101821)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(101831)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(101832)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(101841)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(101842)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(101843)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(101851)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(101852)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(101853)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(101854)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(101861)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(101862)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(101863)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(101864)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(101865)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(101871)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(101872)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(101873)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(101874)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(101875)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(101876)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(101921)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(101931)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(101932)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(101941)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(101942)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(101943)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(101951)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(101952)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(101953)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(101954)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(101961)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(101962)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(101963)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(101964)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(101965)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(101971)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(101972)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(101973)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(101974)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(101975)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(101976)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(102021)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(102031)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(102032)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(102041)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(102042)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(102043)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(102051)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(102052)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(102053)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(102054)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(102061)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(102062)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(102063)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(102064)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(102065)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(102071)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(102072)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(102073)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(102074)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(102075)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(102076)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(102121)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102131)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(102132)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(102141)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(102142)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(102143)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(102151)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(102152)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(102153)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(102154)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(102161)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(102162)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(102163)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(102164)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(102165)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(102171)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(102172)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(102173)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(102174)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(102175)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(102176)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(102221)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102231)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(102232)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(102241)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(102242)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(102243)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(102251)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(102252)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(102253)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(102254)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(102261)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(102262)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(102263)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(102264)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(102265)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(102271)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(102272)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(102273)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(102274)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(102275)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(102276)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(102321)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102331)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(102332)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(102341)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(102342)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(102343)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(102351)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(102352)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(102353)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(102354)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(102361)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(102362)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(102363)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(102364)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(102365)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(102371)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(102372)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(102373)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(102374)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(102375)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(102376)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(102421)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102431)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(102432)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(102441)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(102442)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(102443)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(102451)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(102452)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(102453)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(102454)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(102461)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(102462)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(102463)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(102464)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(102465)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(102471)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(102472)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(102473)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(102474)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(102475)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(102476)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(102521)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102531)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(102532)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(102541)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(102542)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(102543)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(102551)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(102552)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(102553)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(102554)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(102561)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(102562)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(102563)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(102564)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(102565)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(102571)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(102572)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(102573)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(102574)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(102575)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(102576)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(102621)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102631)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(102632)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(102641)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(102642)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(102643)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(102651)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(102652)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(102653)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(102654)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(102661)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(102662)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(102663)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(102664)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(102665)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(102671)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(102672)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(102673)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(102674)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(102675)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(102676)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(102721)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(102731)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(102732)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(102741)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(102742)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(102743)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(102751)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(102752)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(102753)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(102754)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(102761)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(102762)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(102763)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(102764)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(102765)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(102771)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(102772)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(102773)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(102774)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(102775)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(102776)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(102821)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(102831)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(102832)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(102841)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(102842)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(102843)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(102851)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(102852)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(102853)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(102854)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(102861)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(102862)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(102863)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(102864)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(102865)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(102871)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(102872)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(102873)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(102874)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(102875)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(102876)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(102921)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(102931)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(102932)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(102941)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(102942)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(102943)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(102951)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(102952)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(102953)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(102954)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(102961)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(102962)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(102963)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(102964)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(102965)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(102971)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(102972)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(102973)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(102974)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(102975)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(102976)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(103021)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(103031)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(103032)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(103041)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(103042)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(103043)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(103051)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(103052)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(103053)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(103054)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(103061)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(103062)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(103063)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(103064)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(103065)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(103071)  ->
	{ok, {{1,2}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(103072)  ->
	{ok, {{2,3}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(103073)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(103074)  ->
	{ok, {{3,4}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(103075)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(103076)  ->
	{ok, {{3,5}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(103121)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103131)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(103132)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(103141)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(103142)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(103143)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(103151)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(103152)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(103153)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(103154)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(103161)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(103162)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(103163)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(103164)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(103165)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(103171)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(103172)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(103173)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(103174)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(103175)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(103176)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(103221)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103231)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(103232)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(103241)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(103242)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(103243)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(103251)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(103252)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(103253)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(103254)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(103261)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(103262)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(103263)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(103264)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(103265)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(103271)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(103272)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(103273)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(103274)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(103275)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(103276)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(103321)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103331)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(103332)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(103341)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(103342)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(103343)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(103351)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(103352)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(103353)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(103354)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(103361)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(103362)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(103363)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(103364)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(103365)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(103371)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(103372)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(103373)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(103374)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(103375)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(103376)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(103421)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103431)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(103432)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(103441)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(103442)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(103443)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(103451)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(103452)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(103453)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(103454)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(103461)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(103462)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(103463)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(103464)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(103465)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(103471)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(103472)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(103473)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(103474)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(103475)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(103476)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(103521)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103531)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(103532)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(103541)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(103542)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(103543)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(103551)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(103552)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(103553)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(103554)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(103561)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(103562)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(103563)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(103564)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(103565)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(103571)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(103572)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(103573)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(103574)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(103575)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(103576)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(103621)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103631)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 1, 1200}};	
get(103632)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,15}, 3, 1500}};	
get(103641)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 1, 1200}};	
get(103642)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 3, 1500}};	
get(103643)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,30}, 5, 2000}};	
get(103651)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 1, 1200}};	
get(103652)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 3, 1500}};	
get(103653)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 5, 2000}};	
get(103654)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,45}, 8, 2500}};	
get(103661)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 1, 1200}};	
get(103662)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 3, 1500}};	
get(103663)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 5, 2000}};	
get(103664)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 8, 2500}};	
get(103665)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,60}, 10, 3000}};	
get(103671)  ->
	{ok, {{1,2}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 1, 1200}};	
get(103672)  ->
	{ok, {{2,3}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 3, 1500}};	
get(103673)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 5, 2000}};	
get(103674)  ->
	{ok, {{3,4}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 8, 2500}};	
get(103675)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 10, 3000}};	
get(103676)  ->
	{ok, {{3,5}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,70}, 12, 4500}};	
get(103721)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(103731)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(103732)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(103741)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(103742)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(103743)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(103751)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(103752)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(103753)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(103754)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(103761)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(103762)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(103763)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(103764)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(103765)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(103771)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(103772)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(103773)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(103774)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(103775)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(103776)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(103821)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(103831)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(103832)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(103841)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(103842)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(103843)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(103851)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(103852)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(103853)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(103854)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(103861)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(103862)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(103863)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(103864)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(103865)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(103871)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(103872)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(103873)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(103874)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(103875)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(103876)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(103921)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(103931)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 1, 1200}};	
get(103932)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,15}, 3, 1500}};	
get(103941)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 1, 1200}};	
get(103942)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 3, 1500}};	
get(103943)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,30}, 5, 2000}};	
get(103951)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 1, 1200}};	
get(103952)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 3, 1500}};	
get(103953)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 5, 2000}};	
get(103954)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,45}, 8, 2500}};	
get(103961)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 1, 1200}};	
get(103962)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 3, 1500}};	
get(103963)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 5, 2000}};	
get(103964)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 8, 2500}};	
get(103965)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,60}, 10, 3000}};	
get(103971)  ->
	{ok, {{1,2}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 1, 1200}};	
get(103972)  ->
	{ok, {{2,3}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 3, 1500}};	
get(103973)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 5, 2000}};	
get(103974)  ->
	{ok, {{3,4}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 8, 2500}};	
get(103975)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 10, 3000}};	
get(103976)  ->
	{ok, {{3,5}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,70}, 12, 4500}};	
get(101011)  ->
	{ok, {{1,1}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(101111)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101211)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101311)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101411)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101511)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101611)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(101711)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(101811)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(101911)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(102011)  ->
	{ok, {{1,1}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(102111)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102211)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102311)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102411)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102511)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102611)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(102711)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(102811)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(102911)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(103011)  ->
	{ok, {{1,1}, [{?attr_dmg,1,3},{?attr_hitrate,1,2},{?attr_critrate,1,2},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(103111)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103211)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103311)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103411)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103511)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103611)  ->
	{ok, {{1,1}, [{?attr_js,1,2},{?attr_defence,1,5},{?attr_rst_all,1,4},{?attr_hp_max,1,5},{?attr_evasion,1,3},{?attr_tenacity,1,3}], {1,5}, 1, 1200}};	
get(103711)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(103811)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(103911)  ->
	{ok, {{1,1}, [{?attr_dmg,1,2},{?attr_hitrate,1,3},{?attr_critrate,1,3},{?attr_dmg_magic,1,1}], {1,5}, 1, 1200}};	
get(_EqmId) -> {false}.

get_rate(1) -> 500000000;
get_rate(2) -> 323625030;
get_rate(3) -> 215943013;
get_rate(4) -> 148229763;
get_rate(5) -> 104464790;
get_rate(6) -> 75447011;
get_rate(7) -> 55745151;
get_rate(8) -> 42070008;
get_rate(9) -> 32381317;
get_rate(10) -> 25384809;
get_rate(11) -> 20242014;
get_rate(12) -> 16398947;
get_rate(13) -> 13482761;
get_rate(14) -> 11238137;
get_rate(15) -> 9487367;
get_rate(16) -> 8104860;
get_rate(17) -> 7000568;
get_rate(18) -> 6109054;
get_rate(19) -> 5382150;
get_rate(20) -> 4783975;
get_rate(21) -> 4287495;
get_rate(22) -> 3872125;
get_rate(23) -> 3522029;
get_rate(24) -> 3224909;
get_rate(25) -> 2971127;
get_rate(26) -> 2753066;
get_rate(27) -> 2564658;
get_rate(28) -> 2401029;
get_rate(29) -> 2258237;
get_rate(30) -> 2133073;
get_rate(31) -> 2022904;
get_rate(32) -> 1925560;
get_rate(33) -> 1839238;
get_rate(34) -> 1762436;
get_rate(35) -> 1693891;
get_rate(36) -> 1632538;
get_rate(37) -> 1577477;
get_rate(38) -> 1527937;
get_rate(39) -> 1483263;
get_rate(40) -> 1442889;
get_rate(41) -> 1406328;
get_rate(42) -> 1373158;
get_rate(43) -> 1343012;
get_rate(44) -> 1315571;
get_rate(45) -> 1290555;
get_rate(46) -> 1267716;
get_rate(47) -> 1246839;
get_rate(48) -> 1227732;
get_rate(49) -> 1210226;
get_rate(50) -> 1194169;
get_rate(51) -> 1179427;
get_rate(52) -> 1165881;
get_rate(53) -> 1153422;
get_rate(54) -> 1141955;
get_rate(55) -> 1131394;
get_rate(56) -> 1121659;
get_rate(57) -> 1112680;
get_rate(58) -> 1104395;
get_rate(59) -> 1096745;
get_rate(60) -> 1089678;
get_rate(61) -> 1083147;
get_rate(62) -> 1077108;
get_rate(63) -> 1071522;
get_rate(64) -> 1066353;
get_rate(65) -> 1061568;
get_rate(66) -> 1057138;
get_rate(67) -> 1053034;
get_rate(68) -> 1049232;
get_rate(69) -> 1045708;
get_rate(70) -> 1042441;
get_rate(71) -> 1039413;
get_rate(72) -> 1036604;
get_rate(73) -> 1033999;
get_rate(74) -> 1031581;
get_rate(75) -> 1029339;
get_rate(76) -> 1027257;
get_rate(77) -> 1025325;
get_rate(78) -> 1023532;
get_rate(79) -> 1021867;
get_rate(80) -> 1020320;
get_rate(81) -> 1018885;
get_rate(82) -> 1017551;
get_rate(83) -> 1016313;
get_rate(84) -> 1015162;
get_rate(85) -> 1014093;
get_rate(86) -> 1013100;
get_rate(87) -> 1012178;
get_rate(88) -> 1011320;
get_rate(89) -> 1010524;
get_rate(90) -> 1009783.


