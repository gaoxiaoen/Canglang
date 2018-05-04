%% Author: caochuncheng2002@gmail.com
%% Created: 2015-11-09
%% Description: 副本怪物配置，不可以修改，必须由副本怪物配置表生成

-module(cfg_fb_monster).

-include("common.hrl").

-export([
         find/1
        ]).


find(20001) ->
    #r_fb_monster{fb_id=20001,born_type=0,born_interval=0,wait_interval=0,monster_level=1,
     monsters=[#r_fb_monster_sub{order_id=0,monsters=[#r_fb_monster_item{type_code=20001,x=3233,y=2230,dir=0}]}]};
find(20002) ->
    #r_fb_monster{fb_id=20002,born_type=1,born_interval=0,wait_interval=0,monster_level=1,
     monsters=[#r_fb_monster_sub{order_id=1,monsters=[#r_fb_monster_item{type_code=10000,x=3728,y=2031,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3593,y=1945,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3581,y=2091,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3448,y=2004,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3440,y=2192,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3413,y=1835,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3300,y=1932,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3299,y=2076,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3666,y=2157,dir=0}]},
               #r_fb_monster_sub{order_id=2,monsters=[#r_fb_monster_item{type_code=10000,x=2707,y=2066,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2767,y=2211,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2607,y=2151,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2826,y=2036,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2697,y=1883,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2559,y=1892,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2561,y=2017,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2598,y=2276,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2440,y=2102,dir=0}]},
               #r_fb_monster_sub{order_id=3,monsters=[#r_fb_monster_item{type_code=10001,x=1861,y=1885,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1789,y=2046,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1572,y=2085,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1483,y=1677,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1641,y=1910,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1690,y=1795,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1444,y=1941,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1370,y=1792,dir=0}]},
               #r_fb_monster_sub{order_id=4,monsters=[#r_fb_monster_item{type_code=10002,x=1590,y=1879,dir=0}]}]};
find(30001) ->
    #r_fb_monster{fb_id=30001,born_type=0,born_interval=0,wait_interval=10,monster_level=1,
     monsters=[#r_fb_monster_sub{order_id=0,monsters=[#r_fb_monster_item{type_code=10002,x=3233,y=2230,dir=0}]}]};
find(30002) ->
    #r_fb_monster{fb_id=30002,born_type=1,born_interval=0,wait_interval=0,monster_level=1,
     monsters=[#r_fb_monster_sub{order_id=1,monsters=[#r_fb_monster_item{type_code=10000,x=3728,y=2031,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3593,y=1945,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3581,y=2091,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3448,y=2004,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3440,y=2192,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3413,y=1835,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3300,y=1932,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3299,y=2076,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=3666,y=2157,dir=0}]},
               #r_fb_monster_sub{order_id=2,monsters=[#r_fb_monster_item{type_code=10000,x=2707,y=2066,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2767,y=2211,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2607,y=2151,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2826,y=2036,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2697,y=1883,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2559,y=1892,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2561,y=2017,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2598,y=2276,dir=0},
                                                      #r_fb_monster_item{type_code=10000,x=2440,y=2102,dir=0}]},
               #r_fb_monster_sub{order_id=3,monsters=[#r_fb_monster_item{type_code=10001,x=1861,y=1885,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1789,y=2046,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1572,y=2085,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1483,y=1677,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1641,y=1910,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1690,y=1795,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1444,y=1941,dir=0},
                                                      #r_fb_monster_item{type_code=10001,x=1370,y=1792,dir=0}]},
               #r_fb_monster_sub{order_id=4,monsters=[#r_fb_monster_item{type_code=10002,x=1590,y=1879,dir=0}]}]};
find(30003) ->
    #r_fb_monster{fb_id=30003,born_type=1,born_interval=0,wait_interval=0,monster_level=1,
     monsters=[#r_fb_monster_sub{order_id=1,monsters=[#r_fb_monster_item{type_code=10010,x=3728,y=2031,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=3593,y=1945,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=3581,y=2091,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=3448,y=2004,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=3440,y=2192,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=3413,y=1835,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=3300,y=1932,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=3299,y=2076,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=3666,y=2157,dir=0}]},
               #r_fb_monster_sub{order_id=2,monsters=[#r_fb_monster_item{type_code=10010,x=2707,y=2066,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=2767,y=2211,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=2607,y=2151,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=2826,y=2036,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=2697,y=1883,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=2559,y=1892,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=2561,y=2017,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=2598,y=2276,dir=0},
                                                      #r_fb_monster_item{type_code=10010,x=2440,y=2102,dir=0}]},
               #r_fb_monster_sub{order_id=3,monsters=[#r_fb_monster_item{type_code=10011,x=1861,y=1885,dir=0},
                                                      #r_fb_monster_item{type_code=10011,x=1789,y=2046,dir=0},
                                                      #r_fb_monster_item{type_code=10011,x=1572,y=2085,dir=0},
                                                      #r_fb_monster_item{type_code=10011,x=1483,y=1677,dir=0},
                                                      #r_fb_monster_item{type_code=10011,x=1641,y=1910,dir=0},
                                                      #r_fb_monster_item{type_code=10011,x=1690,y=1795,dir=0},
                                                      #r_fb_monster_item{type_code=10011,x=1444,y=1941,dir=0},
                                                      #r_fb_monster_item{type_code=10011,x=1370,y=1792,dir=0}]},
               #r_fb_monster_sub{order_id=4,monsters=[#r_fb_monster_item{type_code=10012,x=1590,y=1879,dir=0}]}]};
find(_) -> 
    undefined.


