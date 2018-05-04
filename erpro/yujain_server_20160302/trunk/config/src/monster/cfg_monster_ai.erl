%% Author: caochuncheng2002@gmail.com
%% Created: 2015-11-20
%% Description: 怪物AI配置，不可以修改，必须由怪物AI配置表生成

-module(cfg_monster_ai).

-include("common.hrl").

-export([
         find/1
        ]).


find(1001) ->
    #r_ai{ai_id=1001,ai_list=[#r_ai_trigger{priority=1,trigger_type=2,trigger_val_1=66,trigger_val_2=0,
                                            event_type=1,event_val_1=3100004,event_val_2=1},
                              #r_ai_trigger{priority=2,trigger_type=2,trigger_val_1=33,trigger_val_2=0,
                                            event_type=1,event_val_1=3100004,event_val_2=1},
                              #r_ai_trigger{priority=3,trigger_type=6,trigger_val_1=15000,trigger_val_2=0,
                                            event_type=1,event_val_1=3100001,event_val_2=1}]};
find(1002) ->
    #r_ai{ai_id=1002,ai_list=[#r_ai_trigger{priority=1,trigger_type=2,trigger_val_1=75,trigger_val_2=0,
                                            event_type=1,event_val_1=3100004,event_val_2=1},
                              #r_ai_trigger{priority=1,trigger_type=2,trigger_val_1=50,trigger_val_2=0,
                                            event_type=1,event_val_1=3100004,event_val_2=1},
                              #r_ai_trigger{priority=1,trigger_type=2,trigger_val_1=25,trigger_val_2=0,
                                            event_type=1,event_val_1=3100004,event_val_2=1}]};
find(_) -> 
    undefined.


