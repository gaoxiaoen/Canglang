%% ****************************
%% 悬赏Boss系统
%% @author mobin
%% ****************************

-define(arrest, 0).
-define(steal, 1).
-define(done, 2).

-record(wanted_npc, {
        id = 0
        ,base_id = 0             %% NPC base_id
        ,coin = 0          
        ,stone = 0          
        ,origin_coin = 0
        ,origin_stone = 0
        ,kill_count = 0         
        ,killed_count = 0          
        ,status = ?arrest
        ,benefit_name = <<>>
        ,next_name = <<>>
        ,kill_count_index = 1
        ,kill_count_factor = 1
    }).

-record(wanted_role, {
        id = 0
        ,rid = {0, 0}
        ,name = <<>>
        ,lev = 0
        ,career = 0
        ,sex = 0
        ,looks = []
        ,coin = 0          
        ,stone = 0          
        ,origin_coin = 0
        ,origin_stone = 0
        ,kill_count = 0         
        ,killed_count = 0          
        ,status = ?arrest
        ,benefit_name = <<>>
        ,kill_count_index = 1
        ,kill_count_factor = 1
    }).

-record(wanted_assets, {
        coin = 0
        ,stone = 0
        ,odds = 0
        ,coin_index = 0
        ,coin_factor = 0          
        ,stone_index = 0         
        ,stone_factor = 0          
    }).

