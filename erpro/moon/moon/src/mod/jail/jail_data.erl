%%----------------------------------------------------
%% 雪山地牢数据配置
%% @author mobin
%% @end
%%----------------------------------------------------
-module(jail_data).
-export([
        bosses/1
        ,floor_bosses/1
        ,floor_rewards/1
        ,race/1
    ]
).


bosses(1) ->
    [19001, 19006, 19011, 19016, 19021, 19026, 19031, 19036, 19041, 19046, 19051, 19056, 19061, 19066, 19071];
bosses(2) ->
    [19002, 19007, 19012, 19017, 19022, 19027, 19032, 19037, 19042, 19047, 19052, 19057, 19062, 19067, 19072];
bosses(3) ->
    [19003, 19008, 19013, 19018, 19023, 19028, 19033, 19038, 19043, 19048, 19053, 19058, 19063, 19068, 19073];
bosses(4) ->
    [19004, 19009, 19014, 19019, 19024, 19029, 19034, 19039, 19044, 19049, 19054, 19059, 19064, 19069, 19074];
bosses(5) ->
    [19005, 19010, 19015, 19020, 19025, 19030, 19035, 19040, 19045, 19050, 19055, 19060, 19065, 19070, 19075];
bosses(_) ->
    [].

floor_bosses(1) ->
    [
        {[{1, 1}], 100}
    ];
floor_bosses(2) ->
    [
        {[{1, 2}], 100}
    ];
floor_bosses(3) ->
    [
        {[{1, 1}, {2, 1}], 100},
        {[{1, 3}], 100}
    ];
floor_bosses(4) ->
    [
        {[{1, 1}, {3, 1}], 100},
        {[{2, 2}], 100}
    ];
floor_bosses(5) ->
    [
        {[{1, 1}, {2, 2}], 100},
        {[{1, 2}, {3, 1}], 100}
    ];
floor_bosses(6) ->
    [
        {[{2, 3}], 100},
        {[{1, 1}, {2, 1}, {3, 1}], 100},
        {[{1, 3}, {3, 1}], 100}
    ];
floor_bosses(7) ->
    [
        {[{1, 1}, {2, 3}], 100},
        {[{1, 1}, {3, 2}], 100},
        {[{1, 2}, {2, 1}, {3, 1}], 100}
    ];
floor_bosses(8) ->
    [
        {[{2, 4}], 100},
        {[{1, 2}, {3, 2}], 100},
        {[{2, 1}, {3, 2}], 100}
    ];
floor_bosses(9) ->
    [
        {[{3, 3}], 100},
        {[{1, 1}, {2, 1}, {3, 2}], 100},
        {[{1, 3}, {3, 2}], 100},
        {[{1, 2}, {2, 2}, {3, 1}], 100}
    ];
floor_bosses(10) ->
    [
        {[{1, 1}, {3, 3}], 100},
        {[{2, 2}, {3, 2}], 100},
        {[{2, 5}], 100},
        {[{1, 2}, {2, 1}, {3, 2}], 100}
    ];
floor_bosses(11) ->
    [
        {[{1, 2}, {3, 3}], 100},
        {[{2, 1}, {3, 3}], 100},
        {[{1, 2}, {2, 3}, {3, 1}], 100}
    ];
floor_bosses(12) ->
    [
        {[{1, 1}, {2, 1}, {3, 3}], 100},
        {[{1, 3}, {3, 3}], 100},
        {[{2, 3}, {3, 2}], 100},
        {[{1, 1}, {2, 4}, {3, 1}], 100}
    ];
floor_bosses(13) ->
    [
        {[{2, 5}, {3, 1}], 100},
        {[{1, 1}, {2, 3}, {3, 2}], 100},
        {[{2, 2}, {3, 3}], 100}
    ];
floor_bosses(14) ->
    [
        {[{1, 2}, {2, 3}, {3, 2}], 100},
        {[{1, 1}, {2, 2}, {3, 3}], 100}
    ];
floor_bosses(15) ->
    [
        {[{3, 5}], 100},
        {[{2, 3}, {3, 3}], 100},
        {[{1, 2}, {2, 2}, {3, 3}], 100}
    ];
floor_bosses(16) ->
    [
        {[{2, 3}, {3, 2}, {4, 1}], 100},
        {[{2, 1}, {3, 2}, {4, 2}], 100},
        {[{3, 4}, {4, 1}], 100}
    ];
floor_bosses(17) ->
    [
        {[{2, 4}, {3, 3}], 100},
        {[{2, 3}, {3, 1}, {4, 2}], 100},
        {[{2, 2}, {3, 3}, {4, 1}], 100}
    ];
floor_bosses(18) ->
    [
        {[{2, 2}, {3, 2}, {4, 2}], 100},
        {[{2, 1}, {3, 4}, {4, 1}], 100},
        {[{3, 2}, {4, 3}], 100}
    ];
floor_bosses(19) ->
    [
        {[{2, 1}, {3, 3}, {4, 2}], 100},
        {[{2, 3}, {3, 3}, {4, 1}], 100},
        {[{2, 2}, {3, 1}, {4, 3}], 100}
    ];
floor_bosses(20) ->
    [
        {[{2, 3}, {3, 2}, {4, 2}], 100},
        {[{2, 2}, {4, 4}], 100},
        {[{2, 1}, {3, 2}, {4, 3}], 100}
    ];
floor_bosses(21) ->
    [
        {[{2, 2}, {3, 3}, {4, 2}], 100},
        {[{2, 3}, {3, 1}, {4, 3}], 100},
        {[{2, 1}, {3, 5}, {4, 1}], 100}
    ];
floor_bosses(22) ->
    [
        {[{2, 1}, {3, 4}, {4, 2}], 100},
        {[{2, 2}, {3, 2}, {4, 3}], 100},
        {[{3, 6}, {4, 1}], 100}
    ];
floor_bosses(23) ->
    [
        {[{2, 1}, {3, 3}, {4, 3}], 100},
        {[{2, 2}, {3, 1}, {4, 4}], 100},
        {[{3, 5}, {4, 2}], 100}
    ];
floor_bosses(24) ->
    [
        {[{2, 1}, {3, 6}, {4, 1}], 100},
        {[{2, 1}, {3, 2}, {4, 4}], 100},
        {[{3, 4}, {4, 3}], 100}
    ];
floor_bosses(25) ->
    [
        {[{2, 2}, {3, 3}, {4, 3}], 100},
        {[{2, 1}, {3, 1}, {4, 5}], 100}
    ];
floor_bosses(26) ->
    [
        {[{3, 6}, {4, 2}], 100},
        {[{3, 2}, {4, 5}], 100},
        {[{2, 1}, {4, 6}], 100}
    ];
floor_bosses(27) ->
    [
        {[{2, 1}, {3, 3}, {4, 4}], 100},
        {[{3, 5}, {4, 3}], 100},
        {[{3, 1}, {4, 6}], 100}
    ];
floor_bosses(28) ->
    [
        {[{2, 2}, {3, 0}, {4, 6}], 100},
        {[{2, 1}, {3, 2}, {4, 5}], 100},
        {[{4, 7}], 100}
    ];
floor_bosses(29) ->
    [
        {[{3, 3}, {4, 5}], 100},
        {[{2, 1}, {3, 1}, {4, 6}], 100}
    ];
floor_bosses(30) ->
    [
        {[{2, 2}, {3, 2}, {4, 5}], 100},
        {[{3, 2}, {4, 6}], 100},
        {[{2, 1}, {4, 7}], 100}
    ];
floor_bosses(31) ->
    [
        {[{3, 3}, {4, 3}, {5, 2}], 100},
        {[{3, 2}, {4, 5}, {5, 1}], 100},
        {[{3, 1}, {4, 7}], 100}
    ];
floor_bosses(32) ->
    [
        {[{3, 2}, {4, 4}, {5, 2}], 100},
        {[{4, 8}], 100},
        {[{3, 2}, {4, 4}, {5, 2}], 100}
    ];
floor_bosses(33) ->
    [
        {[{3, 2}, {4, 3}, {5, 3}], 100},
        {[{3, 3}, {4, 1}, {5, 4}], 100},
        {[{4, 7}, {5, 1}], 100}
    ];
floor_bosses(34) ->
    [
        {[{4, 6}, {5, 2}], 100},
        {[{3, 1}, {4, 4}, {5, 3}], 100},
        {[{3, 4}, {4, 3}, {5, 2}], 100}
    ];
floor_bosses(35) ->
    [
        {[{4, 5}, {5, 3}], 100},
        {[{3, 1}, {4, 3}, {5, 4}], 100}
    ];
floor_bosses(36) ->
    [
        {[{4, 9}], 100},
        {[{3, 2}, {5, 6}], 100},
        {[{4, 4}, {5, 4}], 101},
        {[{3, 1}, {4, 2}, {5, 5}], 100}
    ];
floor_bosses(37) ->
    [
        {[{4, 3}, {5, 5}], 100},
        {[{3, 1}, {4, 1}, {5, 6}], 100},
        {[{3, 4}, {5, 5}], 100}
    ];
floor_bosses(38) ->
    [
        {[{4, 2}, {5, 6}], 100},
        {[{3, 3}, {4, 1}, {5, 5}], 100},
        {[{3, 1}, {5, 7}], 100}
    ];
floor_bosses(39) ->
    [
        {[{3, 3}, {5, 6}], 100},
        {[{4, 1}, {5, 7}], 100},
        {[{3, 2}, {4, 2}, {5, 5}], 100}
    ];
floor_bosses(40) ->
    [
        {[{3, 1}, {4, 3}, {5, 5}], 100},
        {[{5, 8}], 100},
        {[{3, 1}, {4, 3}, {5, 5}], 100}
    ];
floor_bosses(41) ->
    [
        {[{3, 1}, {4, 2}, {5, 6}], 100},
        {[{3, 2}, {5, 7}], 100},
        {[{4, 4}, {5, 5}], 100}
    ];
floor_bosses(42) ->
    [
        {[{4, 3}, {5, 6}], 100},
        {[{3, 1}, {4, 1}, {5, 7}], 100}
    ];
floor_bosses(43) ->
    [
        {[{3, 1}, {5, 8}], 100},
        {[{4, 2}, {5, 7}], 100}
    ];
floor_bosses(44) ->
    [
        {[{4, 1}, {5, 8}], 100}
    ];
floor_bosses(45) ->
    [
        {[{5, 9}], 100}
    ];
floor_bosses(_) ->
    [].

floor_rewards(1) ->
    {[{111101,1,400,800},{111011,1,400,800},{111001,2,100,1000}], 10000, 100, 0, 120};
floor_rewards(2) ->
    {[{111101,1,400,800},{111011,1,400,800},{111001,2,100,1000}], 10000, 100, 0, 120};
floor_rewards(3) ->
    {[{111101,1,400,800},{111011,1,400,800},{111001,2,100,1000}], 10000, 100, 0, 120};
floor_rewards(4) ->
    {[{111102,1,400,800},{111012,1,400,800},{111002,2,100,1000}], 10000, 100, 0, 120};
floor_rewards(5) ->
    {[{111102,1,400,800},{111012,1,400,800},{111002,2,100,1000}], 20000, 200, 0, 120};
floor_rewards(6) ->
    {[{111102,1,400,800},{111012,1,400,800},{111002,2,100,1000}], 20000, 200, 0, 120};
floor_rewards(7) ->
    {[{111102,1,400,800},{111012,1,400,800},{111002,2,100,1000}], 20000, 200, 0, 120};
floor_rewards(8) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 30000, 300, 0, 120};
floor_rewards(9) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 30000, 300, 0, 120};
floor_rewards(10) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 30000, 300, 1, 120};
floor_rewards(11) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 30000, 300, 0, 180};
floor_rewards(12) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 30000, 300, 0, 180};
floor_rewards(13) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 0, 180};
floor_rewards(14) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 0, 180};
floor_rewards(15) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 0, 180};
floor_rewards(16) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 0, 180};
floor_rewards(17) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 0, 180};
floor_rewards(18) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 0, 180};
floor_rewards(19) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 0, 180};
floor_rewards(20) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 1, 240};
floor_rewards(21) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 40000, 400, 0, 240};
floor_rewards(22) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 0, 240};
floor_rewards(23) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 0, 240};
floor_rewards(24) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 0, 240};
floor_rewards(25) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 0, 240};
floor_rewards(26) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 0, 240};
floor_rewards(27) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 0, 240};
floor_rewards(28) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 0, 240};
floor_rewards(29) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 0, 240};
floor_rewards(30) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 50000, 500, 1, 300};
floor_rewards(31) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(32) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(33) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(34) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(35) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(36) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(37) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(38) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(39) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 300};
floor_rewards(40) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 1, 360};
floor_rewards(41) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 60000, 600, 0, 360};
floor_rewards(42) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 70000, 700, 0, 360};
floor_rewards(43) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 70000, 700, 0, 360};
floor_rewards(44) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 70000, 700, 0, 360};
floor_rewards(45) ->
    {[{111103,1,400,800},{111013,1,400,800},{111003,2,100,1000}], 70000, 700, 0, 360};
floor_rewards(_) ->
    undefined.

race(19001) ->
    1;
race(19002) ->
    1;
race(19003) ->
    1;
race(19004) ->
    1;
race(19005) ->
    1;
race(19006) ->
    1;
race(19007) ->
    1;
race(19008) ->
    1;
race(19009) ->
    1;
race(19010) ->
    1;
race(19011) ->
    1;
race(19012) ->
    1;
race(19013) ->
    1;
race(19014) ->
    1;
race(19015) ->
    1;
race(19016) ->
    2;
race(19017) ->
    2;
race(19018) ->
    2;
race(19019) ->
    2;
race(19020) ->
    2;
race(19021) ->
    2;
race(19022) ->
    2;
race(19023) ->
    2;
race(19024) ->
    2;
race(19025) ->
    2;
race(19026) ->
    2;
race(19027) ->
    2;
race(19028) ->
    2;
race(19029) ->
    2;
race(19030) ->
    2;
race(19031) ->
    3;
race(19032) ->
    3;
race(19033) ->
    3;
race(19034) ->
    3;
race(19035) ->
    3;
race(19036) ->
    3;
race(19037) ->
    3;
race(19038) ->
    3;
race(19039) ->
    3;
race(19040) ->
    3;
race(19041) ->
    3;
race(19042) ->
    3;
race(19043) ->
    3;
race(19044) ->
    3;
race(19045) ->
    3;
race(19046) ->
    4;
race(19047) ->
    4;
race(19048) ->
    4;
race(19049) ->
    4;
race(19050) ->
    4;
race(19051) ->
    4;
race(19052) ->
    4;
race(19053) ->
    4;
race(19054) ->
    4;
race(19055) ->
    4;
race(19056) ->
    4;
race(19057) ->
    4;
race(19058) ->
    4;
race(19059) ->
    4;
race(19060) ->
    4;
race(19061) ->
    5;
race(19062) ->
    5;
race(19063) ->
    5;
race(19064) ->
    5;
race(19065) ->
    5;
race(19066) ->
    5;
race(19067) ->
    5;
race(19068) ->
    5;
race(19069) ->
    5;
race(19070) ->
    5;
race(19071) ->
    5;
race(19072) ->
    5;
race(19073) ->
    5;
race(19074) ->
    5;
race(19075) ->
    5;
race(_) ->
    1.

