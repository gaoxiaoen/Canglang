%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_battlefield
	%%% @Created : 2017-11-15 14:28:34
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_battlefield).
-include("common.hrl").
-compile(export_all).
    ids() ->
    [1,2,3,4,5,6,7,8,9].
up_layer_kill(1)->3;
up_layer_kill(2)->3;
up_layer_kill(3)->3;
up_layer_kill(4)->5;
up_layer_kill(5)->5;
up_layer_kill(6)->5;
up_layer_kill(7)->5;
up_layer_kill(8)->5;
up_layer_kill(9)->0;
up_layer_kill(_) -> 0.
drop_layer_ratio(1)->0;
drop_layer_ratio(2)->3;
drop_layer_ratio(3)->3;
drop_layer_ratio(4)->0;
drop_layer_ratio(5)->3;
drop_layer_ratio(6)->3;
drop_layer_ratio(7)->0;
drop_layer_ratio(8)->3;
drop_layer_ratio(9)->3;
drop_layer_ratio(_) -> 0.
kill_score(1)->10;
kill_score(2)->10;
kill_score(3)->10;
kill_score(4)->10;
kill_score(5)->10;
kill_score(6)->10;
kill_score(7)->10;
kill_score(8)->10;
kill_score(9)->10;
kill_score(_) -> 0.
timer_score(1)->10;
timer_score(2)->20;
timer_score(3)->30;
timer_score(4)->40;
timer_score(5)->50;
timer_score(6)->60;
timer_score(7)->70;
timer_score(8)->80;
timer_score(9)->90;
timer_score(_) -> 0.
quit_score(1)->10;
quit_score(2)->20;
quit_score(3)->30;
quit_score(4)->40;
quit_score(5)->50;
quit_score(6)->60;
quit_score(7)->70;
quit_score(8)->80;
quit_score(9)->90;
quit_score(_) -> 0.
mon_score(1)->0;
mon_score(2)->0;
mon_score(3)->0;
mon_score(4)->0;
mon_score(5)->0;
mon_score(6)->0;
mon_score(7)->0;
mon_score(8)->0;
mon_score(9)->0;
mon_score(_) -> 0.
revive(1)->[{12,33},{20,30},{28,33},{32,41},{28,49},{20,53},{12,49},{9,41}];
revive(2)->[{12,33},{20,30},{28,33},{32,41},{28,49},{20,53},{12,49},{9,41}];
revive(3)->[{12,33},{20,30},{28,33},{32,41},{28,49},{20,53},{12,49},{9,41}];
revive(4)->[{12,33},{20,30},{28,33},{32,41},{28,49},{20,53},{12,49},{9,41}];
revive(5)->[{12,33},{20,30},{28,33},{32,41},{28,49},{20,53},{12,49},{9,41}];
revive(6)->[{12,33},{20,30},{28,33},{32,41},{28,49},{20,53},{12,49},{9,41}];
revive(7)->[{12,33},{20,30},{28,33},{32,41},{28,49},{20,53},{12,49},{9,41}];
revive(8)->[{12,33},{20,30},{28,33},{32,41},{28,49},{20,53},{12,49},{9,41}];
revive(9)->[{6,31},{21,46},{37,29},{22,13}];
revive(_) -> [].
mon_list(1)->[{64537,14,28},{64537,32,35},{64537,25,53},{64537,10,47}];
mon_list(2)->[{64539,20,26},{64539,20,57},{64539,7,41},{64539,33,41}];
mon_list(3)->[{64537,14,28},{64537,32,35},{64537,25,53},{64537,10,47}];
mon_list(4)->[{64539,20,26},{64539,20,57},{64539,7,41},{64539,33,41}];
mon_list(5)->[];
mon_list(6)->[];
mon_list(7)->[];
mon_list(8)->[];
mon_list(9)->[];
mon_list(_) -> [].
buff_list(60101)->[];
buff_list(60102)->[];
buff_list(60103)->[];
buff_list(60104)->[];
buff_list(60105)->[37601,37602,37603];
buff_list(60106)->[];
buff_list(60107)->[37601,37602,37603];
buff_list(60108)->[];
buff_list(60109)->[];
buff_list(_) -> [].
buff_time(60101)->15;
buff_time(60102)->15;
buff_time(60103)->15;
buff_time(60104)->15;
buff_time(60105)->15;
buff_time(60106)->15;
buff_time(60107)->15;
buff_time(60108)->15;
buff_time(60109)->15;
buff_time(_) -> 3000.
buff_pos_list(1)->[];
buff_pos_list(2)->[];
buff_pos_list(3)->[];
buff_pos_list(4)->[];
buff_pos_list(5)->[{13,41},{26,41},{20,33},{20,48},{20,41}];
buff_pos_list(6)->[{13,41},{26,41},{20,33},{20,48},{20,41}];
buff_pos_list(7)->[{13,41},{26,41},{20,33},{20,48},{20,41}];
buff_pos_list(8)->[];
buff_pos_list(9)->[];
buff_pos_list(_) -> [].
enter_goods_list(1)->{};
enter_goods_list(2)->{{8001085,1},{8001056,1},{8002401,1}};
enter_goods_list(3)->{{8001085,1},{8001056,1},{8002401,1}};
enter_goods_list(4)->{{8001085,2},{8001056,1},{8002401,2}};
enter_goods_list(5)->{{8001085,2},{8001056,2},{8002401,2}};
enter_goods_list(6)->{{8001085,2},{8001056,2},{8002401,2}};
enter_goods_list(7)->{{8001085,3},{8001056,3},{8002401,3}};
enter_goods_list(8)->{{8001085,3},{8001056,3},{8002401,3}};
enter_goods_list(9)->{{8001085,3},{8001056,3},{8002401,3}};
enter_goods_list(_) -> [].

    scene_ids() ->
    [60101,60102,60103,60104,60105,60106,60107,60108,60109].
scene(1)->60101;
scene(2)->60102;
scene(3)->60103;
scene(4)->60104;
scene(5)->60105;
scene(6)->60106;
scene(7)->60107;
scene(8)->60108;
scene(9)->60109;
scene(_) -> [].
