-module(guild_exp_data).
-export([get/1, get_bonus/1]).
get(1) ->0;
get(2) ->1200;
get(3) ->2400;
get(4) ->4400;
get(5) ->6000;
get(6) ->9200;
get(7) ->12400;
get(8) ->13800;
get(9) ->15200;
get(10) ->19300;
get(11) ->36400;
get(12) ->36400;
get(13) ->41600;
get(14) ->44800;
get(15) ->44800;
get(16) ->54000;
get(17) ->54000;
get(18) ->72000;
get(19) ->80000;
get(20) ->100000;
get(_)->100000.

get_bonus(1) ->20000;
get_bonus(2) ->21127;
get_bonus(3) ->23405;
get_bonus(4) ->27562;
get_bonus(5) ->32286;
get_bonus(6) ->37219;
get_bonus(7) ->43923;
get_bonus(8) ->50668;
get_bonus(9) ->58458;
get_bonus(10) ->65290;
get_bonus(11) ->75380;
get_bonus(12) ->86383;
get_bonus(13) ->99440;
get_bonus(14) ->113359;
get_bonus(15) ->128784;
get_bonus(16) ->147513;
get_bonus(17) ->167414;
get_bonus(18) ->192495;
get_bonus(19) ->221930;
get_bonus(20) ->256701;
get_bonus(_)-> 0.



