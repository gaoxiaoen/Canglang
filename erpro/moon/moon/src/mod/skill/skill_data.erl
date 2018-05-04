%% *********************
%% 技能数据
%% *********************
-module(skill_data).
-export([
        get/1
    ]).

-include("skill.hrl").
get(720001) ->
    #skill{
            id         = 720001
			,name      = language:get(<<"保护/防御">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(720201) ->
    #skill{
            id         = 720201
			,name      = language:get(<<"逃跑">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(720301) ->
    #skill{
            id         = 720301
			,name      = language:get(<<"神恩">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 3                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(310001) ->
    #skill{
            id         = 310001
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310002             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(310002) ->
    #skill{
            id         = 310002
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310003             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 2
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310003) ->
    #skill{
            id         = 310003
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310004             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 4
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310004) ->
    #skill{
            id         = 310004
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310005             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 6
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310005) ->
    #skill{
            id         = 310005
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310006             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 8
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310006) ->
    #skill{
            id         = 310006
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310007             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 10
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310007) ->
    #skill{
            id         = 310007
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310008             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 12
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310008) ->
    #skill{
            id         = 310008
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310009             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 14
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310009) ->
    #skill{
            id         = 310009
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 310010             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310010) ->
    #skill{
            id         = 310010
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310011) ->
    #skill{
            id         = 310011
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310012) ->
    #skill{
            id         = 310012
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310013) ->
    #skill{
            id         = 310013
			,name      = language:get(<<"混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 24
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310100) ->
    #skill{
            id         = 310100
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310101             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(310101) ->
    #skill{
            id         = 310101
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310102             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 8
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131015 
            ,attr = []                                                       
        };
get(310102) ->
    #skill{
            id         = 310102
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310103             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 10
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310103) ->
    #skill{
            id         = 310103
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310104             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 12
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310104) ->
    #skill{
            id         = 310104
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310105             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 14
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310105) ->
    #skill{
            id         = 310105
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310106             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310106) ->
    #skill{
            id         = 310106
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310107             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310107) ->
    #skill{
            id         = 310107
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310108             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310108) ->
    #skill{
            id         = 310108
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310109             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310109) ->
    #skill{
            id         = 310109
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 310110             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 24
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310110) ->
    #skill{
            id         = 310110
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310111) ->
    #skill{
            id         = 310111
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310112) ->
    #skill{
            id         = 310112
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310113) ->
    #skill{
            id         = 310113
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310200) ->
    #skill{
            id         = 310200
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310201             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(310201) ->
    #skill{
            id         = 310201
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310202             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131016 
            ,attr = []                                                       
        };
get(310202) ->
    #skill{
            id         = 310202
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310203             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 3
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310203) ->
    #skill{
            id         = 310203
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310204             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 5
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310204) ->
    #skill{
            id         = 310204
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310205             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 7
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310205) ->
    #skill{
            id         = 310205
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310206             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 9
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310206) ->
    #skill{
            id         = 310206
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310207             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310207) ->
    #skill{
            id         = 310207
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310208             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310208) ->
    #skill{
            id         = 310208
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310209             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310209) ->
    #skill{
            id         = 310209
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 310210             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310210) ->
    #skill{
            id         = 310210
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310211) ->
    #skill{
            id         = 310211
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310212) ->
    #skill{
            id         = 310212
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310213) ->
    #skill{
            id         = 310213
			,name      = language:get(<<"荆棘缠绕">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310300) ->
    #skill{
            id         = 310300
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310301             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(310301) ->
    #skill{
            id         = 310301
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310302             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131017 
            ,attr = []                                                       
        };
get(310302) ->
    #skill{
            id         = 310302
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310303             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310303) ->
    #skill{
            id         = 310303
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310304             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310304) ->
    #skill{
            id         = 310304
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310305             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310305) ->
    #skill{
            id         = 310305
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310306             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310306) ->
    #skill{
            id         = 310306
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310307             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310307) ->
    #skill{
            id         = 310307
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310308             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310308) ->
    #skill{
            id         = 310308
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310309             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310309) ->
    #skill{
            id         = 310309
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 310310             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310310) ->
    #skill{
            id         = 310310
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 29
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310311) ->
    #skill{
            id         = 310311
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 31
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310312) ->
    #skill{
            id         = 310312
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 33
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310313) ->
    #skill{
            id         = 310313
			,name      = language:get(<<"安魂吟唱">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 35
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310400) ->
    #skill{
            id         = 310400
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310401             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(310401) ->
    #skill{
            id         = 310401
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310402             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 3
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131018 
            ,attr = []                                                       
        };
get(310402) ->
    #skill{
            id         = 310402
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310403             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 5
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310403) ->
    #skill{
            id         = 310403
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310404             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 7
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310404) ->
    #skill{
            id         = 310404
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310405             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 9
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310405) ->
    #skill{
            id         = 310405
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310406             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310406) ->
    #skill{
            id         = 310406
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310407             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310407) ->
    #skill{
            id         = 310407
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310408             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310408) ->
    #skill{
            id         = 310408
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310409             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310409) ->
    #skill{
            id         = 310409
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 310410             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310410) ->
    #skill{
            id         = 310410
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310411) ->
    #skill{
            id         = 310411
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310412) ->
    #skill{
            id         = 310412
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(310413) ->
    #skill{
            id         = 310413
			,name      = language:get(<<"虚弱诅咒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320500) ->
    #skill{
            id         = 320500
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320501             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(320501) ->
    #skill{
            id         = 320501
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320502             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131019 
            ,attr = []                                                       
        };
get(320502) ->
    #skill{
            id         = 320502
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320503             
            ,type      = 2                                    
            ,lev       = 2             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320503) ->
    #skill{
            id         = 320503
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320504             
            ,type      = 2                                    
            ,lev       = 3             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320504) ->
    #skill{
            id         = 320504
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320505             
            ,type      = 2                                    
            ,lev       = 4             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320505) ->
    #skill{
            id         = 320505
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320506             
            ,type      = 2                                    
            ,lev       = 5             
            ,cond_lev  = 24
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320506) ->
    #skill{
            id         = 320506
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320507             
            ,type      = 2                                    
            ,lev       = 6             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320507) ->
    #skill{
            id         = 320507
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320508             
            ,type      = 2                                    
            ,lev       = 7             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320508) ->
    #skill{
            id         = 320508
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320509             
            ,type      = 2                                    
            ,lev       = 8             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320509) ->
    #skill{
            id         = 320509
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 320510             
            ,type      = 2                                    
            ,lev       = 9             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320510) ->
    #skill{
            id         = 320510
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 10             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320511) ->
    #skill{
            id         = 320511
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 11             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320512) ->
    #skill{
            id         = 320512
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 12             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(320513) ->
    #skill{
            id         = 320513
			,name      = language:get(<<"女神之光">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 13             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300600) ->
    #skill{
            id         = 300600
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300601             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(300601) ->
    #skill{
            id         = 300601
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300602             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131020 
            ,attr = [{js ,50}]                                                       
        };
get(300602) ->
    #skill{
            id         = 300602
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300603             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = [{js ,75}]                                                       
        };
get(300603) ->
    #skill{
            id         = 300603
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300604             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = [{js ,100}]                                                       
        };
get(300604) ->
    #skill{
            id         = 300604
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300605             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 29
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = [{js ,125}]                                                       
        };
get(300605) ->
    #skill{
            id         = 300605
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300606             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 31
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = [{js ,150}]                                                       
        };
get(300606) ->
    #skill{
            id         = 300606
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300607             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 33
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = [{js ,200}]                                                       
        };
get(300607) ->
    #skill{
            id         = 300607
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300608             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 35
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = [{js ,275}]                                                       
        };
get(300608) ->
    #skill{
            id         = 300608
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300609             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 37
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = [{js ,350}]                                                       
        };
get(300609) ->
    #skill{
            id         = 300609
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 300610             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 39
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = [{js ,425}]                                                       
        };
get(300610) ->
    #skill{
            id         = 300610
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 41
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = [{js ,500}]                                                       
        };
get(300611) ->
    #skill{
            id         = 300611
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 43
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = [{js ,11}]                                                       
        };
get(300612) ->
    #skill{
            id         = 300612
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 45
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = [{js ,12}]                                                       
        };
get(300613) ->
    #skill{
            id         = 300613
			,name      = language:get(<<"智力强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 47
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = [{js ,13}]                                                       
        };
get(300700) ->
    #skill{
            id         = 300700
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300701             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(300701) ->
    #skill{
            id         = 300701
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300702             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131021 
            ,attr = [{hp_max,150}]                                                       
        };
get(300702) ->
    #skill{
            id         = 300702
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300703             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = [{hp_max,225}]                                                       
        };
get(300703) ->
    #skill{
            id         = 300703
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300704             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = [{hp_max,300}]                                                       
        };
get(300704) ->
    #skill{
            id         = 300704
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300705             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = [{hp_max,375}]                                                       
        };
get(300705) ->
    #skill{
            id         = 300705
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300706             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = [{hp_max,450}]                                                       
        };
get(300706) ->
    #skill{
            id         = 300706
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300707             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = [{hp_max,600}]                                                       
        };
get(300707) ->
    #skill{
            id         = 300707
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300708             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = [{hp_max,825}]                                                       
        };
get(300708) ->
    #skill{
            id         = 300708
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300709             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = [{hp_max,1050}]                                                       
        };
get(300709) ->
    #skill{
            id         = 300709
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 300710             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = [{hp_max,1275}]                                                       
        };
get(300710) ->
    #skill{
            id         = 300710
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = [{hp_max,1500}]                                                       
        };
get(300711) ->
    #skill{
            id         = 300711
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = [{hp_max,11}]                                                       
        };
get(300712) ->
    #skill{
            id         = 300712
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = [{hp_max,12}]                                                       
        };
get(300713) ->
    #skill{
            id         = 300713
			,name      = language:get(<<"生命强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = [{hp_max,13}]                                                       
        };
get(300800) ->
    #skill{
            id         = 300800
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300801             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(300801) ->
    #skill{
            id         = 300801
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300802             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131022 
            ,attr = []                                                       
        };
get(300802) ->
    #skill{
            id         = 300802
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300803             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300803) ->
    #skill{
            id         = 300803
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300804             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300804) ->
    #skill{
            id         = 300804
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300805             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300805) ->
    #skill{
            id         = 300805
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300806             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300806) ->
    #skill{
            id         = 300806
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300807             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300807) ->
    #skill{
            id         = 300807
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300808             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300808) ->
    #skill{
            id         = 300808
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300809             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300809) ->
    #skill{
            id         = 300809
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 300810             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300810) ->
    #skill{
            id         = 300810
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300811) ->
    #skill{
            id         = 300811
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300812) ->
    #skill{
            id         = 300812
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300813) ->
    #skill{
            id         = 300813
			,name      = language:get(<<"神圣恩赐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300900) ->
    #skill{
            id         = 300900
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300901             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(300901) ->
    #skill{
            id         = 300901
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300902             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131023 
            ,attr = []                                                       
        };
get(300902) ->
    #skill{
            id         = 300902
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300903             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300903) ->
    #skill{
            id         = 300903
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300904             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300904) ->
    #skill{
            id         = 300904
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300905             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300905) ->
    #skill{
            id         = 300905
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300906             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300906) ->
    #skill{
            id         = 300906
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300907             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300907) ->
    #skill{
            id         = 300907
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300908             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300908) ->
    #skill{
            id         = 300908
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300909             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300909) ->
    #skill{
            id         = 300909
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 300910             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300910) ->
    #skill{
            id         = 300910
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300911) ->
    #skill{
            id         = 300911
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300912) ->
    #skill{
            id         = 300912
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(300913) ->
    #skill{
            id         = 300913
			,name      = language:get(<<"奥术溅射">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 54
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301000) ->
    #skill{
            id         = 301000
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301001             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(301001) ->
    #skill{
            id         = 301001
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301002             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131024 
            ,attr = []                                                       
        };
get(301002) ->
    #skill{
            id         = 301002
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301003             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301003) ->
    #skill{
            id         = 301003
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301004             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301004) ->
    #skill{
            id         = 301004
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301005             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301005) ->
    #skill{
            id         = 301005
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301006             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301006) ->
    #skill{
            id         = 301006
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301007             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301007) ->
    #skill{
            id         = 301007
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301008             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301008) ->
    #skill{
            id         = 301008
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301009             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301009) ->
    #skill{
            id         = 301009
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 301010             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301010) ->
    #skill{
            id         = 301010
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301011) ->
    #skill{
            id         = 301011
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301012) ->
    #skill{
            id         = 301012
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 54
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(301013) ->
    #skill{
            id         = 301013
			,name      = language:get(<<"圣光守护">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 56
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210001) ->
    #skill{
            id         = 210001
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210002             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(210002) ->
    #skill{
            id         = 210002
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210003             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210003) ->
    #skill{
            id         = 210003
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210004             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 2
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210004) ->
    #skill{
            id         = 210004
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210005             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 4
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210005) ->
    #skill{
            id         = 210005
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210006             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 6
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210006) ->
    #skill{
            id         = 210006
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210007             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 8
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210007) ->
    #skill{
            id         = 210007
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210008             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 10
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210008) ->
    #skill{
            id         = 210008
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210009             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 12
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210009) ->
    #skill{
            id         = 210009
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 210010             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 14
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210010) ->
    #skill{
            id         = 210010
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210011) ->
    #skill{
            id         = 210011
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210012) ->
    #skill{
            id         = 210012
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210013) ->
    #skill{
            id         = 210013
			,name      = language:get(<<"灵风一闪">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210100) ->
    #skill{
            id         = 210100
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210101             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(210101) ->
    #skill{
            id         = 210101
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210102             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 3
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131004 
            ,attr = []                                                       
        };
get(210102) ->
    #skill{
            id         = 210102
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210103             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 5
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210103) ->
    #skill{
            id         = 210103
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210104             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 7
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210104) ->
    #skill{
            id         = 210104
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210105             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 9
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210105) ->
    #skill{
            id         = 210105
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210106             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210106) ->
    #skill{
            id         = 210106
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210107             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210107) ->
    #skill{
            id         = 210107
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210108             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210108) ->
    #skill{
            id         = 210108
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210109             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210109) ->
    #skill{
            id         = 210109
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 210110             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210110) ->
    #skill{
            id         = 210110
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210111) ->
    #skill{
            id         = 210111
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210112) ->
    #skill{
            id         = 210112
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210113) ->
    #skill{
            id         = 210113
			,name      = language:get(<<"极限冲杀">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210200) ->
    #skill{
            id         = 210200
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210201             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(210201) ->
    #skill{
            id         = 210201
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210202             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 8
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131005 
            ,attr = []                                                       
        };
get(210202) ->
    #skill{
            id         = 210202
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210203             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 10
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210203) ->
    #skill{
            id         = 210203
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210204             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 12
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210204) ->
    #skill{
            id         = 210204
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210205             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 14
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210205) ->
    #skill{
            id         = 210205
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210206             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210206) ->
    #skill{
            id         = 210206
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210207             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210207) ->
    #skill{
            id         = 210207
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210208             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210208) ->
    #skill{
            id         = 210208
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210209             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210209) ->
    #skill{
            id         = 210209
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 210210             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 24
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210210) ->
    #skill{
            id         = 210210
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210211) ->
    #skill{
            id         = 210211
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210212) ->
    #skill{
            id         = 210212
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210213) ->
    #skill{
            id         = 210213
			,name      = language:get(<<"终结收割">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210300) ->
    #skill{
            id         = 210300
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210301             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(210301) ->
    #skill{
            id         = 210301
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210302             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131006 
            ,attr = []                                                       
        };
get(210302) ->
    #skill{
            id         = 210302
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210303             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210303) ->
    #skill{
            id         = 210303
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210304             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210304) ->
    #skill{
            id         = 210304
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210305             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210305) ->
    #skill{
            id         = 210305
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210306             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210306) ->
    #skill{
            id         = 210306
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210307             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210307) ->
    #skill{
            id         = 210307
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210308             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210308) ->
    #skill{
            id         = 210308
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210309             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210309) ->
    #skill{
            id         = 210309
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 210310             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210310) ->
    #skill{
            id         = 210310
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 29
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210311) ->
    #skill{
            id         = 210311
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 31
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210312) ->
    #skill{
            id         = 210312
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 33
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210313) ->
    #skill{
            id         = 210313
			,name      = language:get(<<"死亡之缚">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 35
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210400) ->
    #skill{
            id         = 210400
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210401             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(210401) ->
    #skill{
            id         = 210401
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210402             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131007 
            ,attr = []                                                       
        };
get(210402) ->
    #skill{
            id         = 210402
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210403             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 3
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210403) ->
    #skill{
            id         = 210403
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210404             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 5
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210404) ->
    #skill{
            id         = 210404
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210405             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 7
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210405) ->
    #skill{
            id         = 210405
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210406             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 9
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210406) ->
    #skill{
            id         = 210406
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210407             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210407) ->
    #skill{
            id         = 210407
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210408             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210408) ->
    #skill{
            id         = 210408
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210409             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210409) ->
    #skill{
            id         = 210409
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 210410             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210410) ->
    #skill{
            id         = 210410
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210411) ->
    #skill{
            id         = 210411
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210412) ->
    #skill{
            id         = 210412
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(210413) ->
    #skill{
            id         = 210413
			,name      = language:get(<<"致盲穿刺">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220500) ->
    #skill{
            id         = 220500
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220501             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(220501) ->
    #skill{
            id         = 220501
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220502             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131008 
            ,attr = []                                                       
        };
get(220502) ->
    #skill{
            id         = 220502
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220503             
            ,type      = 2                                    
            ,lev       = 2             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220503) ->
    #skill{
            id         = 220503
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220504             
            ,type      = 2                                    
            ,lev       = 3             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220504) ->
    #skill{
            id         = 220504
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220505             
            ,type      = 2                                    
            ,lev       = 4             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220505) ->
    #skill{
            id         = 220505
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220506             
            ,type      = 2                                    
            ,lev       = 5             
            ,cond_lev  = 24
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220506) ->
    #skill{
            id         = 220506
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220507             
            ,type      = 2                                    
            ,lev       = 6             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220507) ->
    #skill{
            id         = 220507
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220508             
            ,type      = 2                                    
            ,lev       = 7             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220508) ->
    #skill{
            id         = 220508
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220509             
            ,type      = 2                                    
            ,lev       = 8             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220509) ->
    #skill{
            id         = 220509
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 220510             
            ,type      = 2                                    
            ,lev       = 9             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220510) ->
    #skill{
            id         = 220510
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 10             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220511) ->
    #skill{
            id         = 220511
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 11             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220512) ->
    #skill{
            id         = 220512
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 12             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(220513) ->
    #skill{
            id         = 220513
			,name      = language:get(<<"嗜血之刃">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 13             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200600) ->
    #skill{
            id         = 200600
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200601             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(200601) ->
    #skill{
            id         = 200601
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200602             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131009 
            ,attr = [{critrate,15}]                                                       
        };
get(200602) ->
    #skill{
            id         = 200602
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200603             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = [{critrate,22}]                                                       
        };
get(200603) ->
    #skill{
            id         = 200603
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200604             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = [{critrate,30}]                                                       
        };
get(200604) ->
    #skill{
            id         = 200604
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200605             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 29
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = [{critrate,37}]                                                       
        };
get(200605) ->
    #skill{
            id         = 200605
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200606             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 31
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = [{critrate,45}]                                                       
        };
get(200606) ->
    #skill{
            id         = 200606
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200607             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 33
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = [{critrate,60}]                                                       
        };
get(200607) ->
    #skill{
            id         = 200607
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200608             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 35
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = [{critrate,82}]                                                       
        };
get(200608) ->
    #skill{
            id         = 200608
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200609             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 37
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = [{critrate,105}]                                                       
        };
get(200609) ->
    #skill{
            id         = 200609
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 200610             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 39
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = [{critrate,127}]                                                       
        };
get(200610) ->
    #skill{
            id         = 200610
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 41
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = [{critrate,150}]                                                       
        };
get(200611) ->
    #skill{
            id         = 200611
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 43
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = [{critrate,172}]                                                       
        };
get(200612) ->
    #skill{
            id         = 200612
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 45
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = [{critrate,195}]                                                       
        };
get(200613) ->
    #skill{
            id         = 200613
			,name      = language:get(<<"暴怒强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 47
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = [{critrate,217}]                                                       
        };
get(200700) ->
    #skill{
            id         = 200700
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200701             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(200701) ->
    #skill{
            id         = 200701
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200702             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131010 
            ,attr = [{hitrate,6}]                                                       
        };
get(200702) ->
    #skill{
            id         = 200702
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200703             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = [{hitrate,9}]                                                       
        };
get(200703) ->
    #skill{
            id         = 200703
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200704             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = [{hitrate,12}]                                                       
        };
get(200704) ->
    #skill{
            id         = 200704
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200705             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = [{hitrate,15}]                                                       
        };
get(200705) ->
    #skill{
            id         = 200705
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200706             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = [{hitrate,18}]                                                       
        };
get(200706) ->
    #skill{
            id         = 200706
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200707             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = [{hitrate,24}]                                                       
        };
get(200707) ->
    #skill{
            id         = 200707
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200708             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = [{hitrate,33}]                                                       
        };
get(200708) ->
    #skill{
            id         = 200708
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200709             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = [{hitrate,42}]                                                       
        };
get(200709) ->
    #skill{
            id         = 200709
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 200710             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = [{hitrate,51}]                                                       
        };
get(200710) ->
    #skill{
            id         = 200710
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = [{hitrate,60}]                                                       
        };
get(200711) ->
    #skill{
            id         = 200711
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = [{hitrate,69}]                                                       
        };
get(200712) ->
    #skill{
            id         = 200712
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = [{hitrate,78}]                                                       
        };
get(200713) ->
    #skill{
            id         = 200713
			,name      = language:get(<<"精准强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = [{hitrate,87}]                                                       
        };
get(200800) ->
    #skill{
            id         = 200800
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200801             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(200801) ->
    #skill{
            id         = 200801
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200802             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131011 
            ,attr = []                                                       
        };
get(200802) ->
    #skill{
            id         = 200802
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200803             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200803) ->
    #skill{
            id         = 200803
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200804             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200804) ->
    #skill{
            id         = 200804
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200805             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200805) ->
    #skill{
            id         = 200805
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200806             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200806) ->
    #skill{
            id         = 200806
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200807             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200807) ->
    #skill{
            id         = 200807
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200808             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200808) ->
    #skill{
            id         = 200808
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200809             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200809) ->
    #skill{
            id         = 200809
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 200810             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200810) ->
    #skill{
            id         = 200810
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200811) ->
    #skill{
            id         = 200811
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200812) ->
    #skill{
            id         = 200812
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 54
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200813) ->
    #skill{
            id         = 200813
			,name      = language:get(<<"暗影毒雾">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 56
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200900) ->
    #skill{
            id         = 200900
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200901             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(200901) ->
    #skill{
            id         = 200901
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200902             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131012 
            ,attr = []                                                       
        };
get(200902) ->
    #skill{
            id         = 200902
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200903             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200903) ->
    #skill{
            id         = 200903
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200904             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200904) ->
    #skill{
            id         = 200904
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200905             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200905) ->
    #skill{
            id         = 200905
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200906             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200906) ->
    #skill{
            id         = 200906
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200907             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200907) ->
    #skill{
            id         = 200907
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200908             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200908) ->
    #skill{
            id         = 200908
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200909             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200909) ->
    #skill{
            id         = 200909
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 200910             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200910) ->
    #skill{
            id         = 200910
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200911) ->
    #skill{
            id         = 200911
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200912) ->
    #skill{
            id         = 200912
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(200913) ->
    #skill{
            id         = 200913
			,name      = language:get(<<"绝地反击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201000) ->
    #skill{
            id         = 201000
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201001             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(201001) ->
    #skill{
            id         = 201001
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201002             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131013 
            ,attr = []                                                       
        };
get(201002) ->
    #skill{
            id         = 201002
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201003             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201003) ->
    #skill{
            id         = 201003
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201004             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201004) ->
    #skill{
            id         = 201004
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201005             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201005) ->
    #skill{
            id         = 201005
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201006             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201006) ->
    #skill{
            id         = 201006
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201007             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201007) ->
    #skill{
            id         = 201007
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201008             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201008) ->
    #skill{
            id         = 201008
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201009             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201009) ->
    #skill{
            id         = 201009
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 201010             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201010) ->
    #skill{
            id         = 201010
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201011) ->
    #skill{
            id         = 201011
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201012) ->
    #skill{
            id         = 201012
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(201013) ->
    #skill{
            id         = 201013
			,name      = language:get(<<"末日浩劫">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 54
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510001) ->
    #skill{
            id         = 510001
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510002             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(510002) ->
    #skill{
            id         = 510002
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510003             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 2
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510003) ->
    #skill{
            id         = 510003
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510004             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 4
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510004) ->
    #skill{
            id         = 510004
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510005             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 6
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510005) ->
    #skill{
            id         = 510005
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510006             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 8
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510006) ->
    #skill{
            id         = 510006
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510007             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 10
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510007) ->
    #skill{
            id         = 510007
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510008             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 12
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510008) ->
    #skill{
            id         = 510008
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510009             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 14
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510009) ->
    #skill{
            id         = 510009
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 510010             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510010) ->
    #skill{
            id         = 510010
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510011) ->
    #skill{
            id         = 510011
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510012) ->
    #skill{
            id         = 510012
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510013) ->
    #skill{
            id         = 510013
			,name      = language:get(<<"凌空下劈">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 24
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510100) ->
    #skill{
            id         = 510100
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510101             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(510101) ->
    #skill{
            id         = 510101
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510102             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 3
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131026 
            ,attr = []                                                       
        };
get(510102) ->
    #skill{
            id         = 510102
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510103             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 5
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510103) ->
    #skill{
            id         = 510103
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510104             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 7
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510104) ->
    #skill{
            id         = 510104
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510105             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 9
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510105) ->
    #skill{
            id         = 510105
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510106             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510106) ->
    #skill{
            id         = 510106
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510107             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510107) ->
    #skill{
            id         = 510107
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510108             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510108) ->
    #skill{
            id         = 510108
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510109             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510109) ->
    #skill{
            id         = 510109
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 510110             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510110) ->
    #skill{
            id         = 510110
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510111) ->
    #skill{
            id         = 510111
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510112) ->
    #skill{
            id         = 510112
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510113) ->
    #skill{
            id         = 510113
			,name      = language:get(<<"巨刃击溃">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510200) ->
    #skill{
            id         = 510200
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510201             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(510201) ->
    #skill{
            id         = 510201
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510202             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131027 
            ,attr = []                                                       
        };
get(510202) ->
    #skill{
            id         = 510202
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510203             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510203) ->
    #skill{
            id         = 510203
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510204             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510204) ->
    #skill{
            id         = 510204
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510205             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510205) ->
    #skill{
            id         = 510205
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510206             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510206) ->
    #skill{
            id         = 510206
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510207             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510207) ->
    #skill{
            id         = 510207
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510208             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510208) ->
    #skill{
            id         = 510208
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510209             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510209) ->
    #skill{
            id         = 510209
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 510210             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510210) ->
    #skill{
            id         = 510210
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 29
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510211) ->
    #skill{
            id         = 510211
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 31
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510212) ->
    #skill{
            id         = 510212
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 33
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510213) ->
    #skill{
            id         = 510213
			,name      = language:get(<<"愤怒咆哮">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 35
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510300) ->
    #skill{
            id         = 510300
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510301             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(510301) ->
    #skill{
            id         = 510301
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510302             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 8
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131028 
            ,attr = []                                                       
        };
get(510302) ->
    #skill{
            id         = 510302
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510303             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 10
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510303) ->
    #skill{
            id         = 510303
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510304             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 12
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510304) ->
    #skill{
            id         = 510304
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510305             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 14
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510305) ->
    #skill{
            id         = 510305
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510306             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510306) ->
    #skill{
            id         = 510306
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510307             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510307) ->
    #skill{
            id         = 510307
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510308             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510308) ->
    #skill{
            id         = 510308
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510309             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510309) ->
    #skill{
            id         = 510309
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 510310             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 24
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510310) ->
    #skill{
            id         = 510310
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510311) ->
    #skill{
            id         = 510311
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510312) ->
    #skill{
            id         = 510312
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510313) ->
    #skill{
            id         = 510313
			,name      = language:get(<<"正义审判">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510400) ->
    #skill{
            id         = 510400
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510401             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(510401) ->
    #skill{
            id         = 510401
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510402             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131029 
            ,attr = []                                                       
        };
get(510402) ->
    #skill{
            id         = 510402
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510403             
            ,type      = 1                                    
            ,lev       = 2             
            ,cond_lev  = 3
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510403) ->
    #skill{
            id         = 510403
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510404             
            ,type      = 1                                    
            ,lev       = 3             
            ,cond_lev  = 5
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510404) ->
    #skill{
            id         = 510404
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510405             
            ,type      = 1                                    
            ,lev       = 4             
            ,cond_lev  = 7
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510405) ->
    #skill{
            id         = 510405
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510406             
            ,type      = 1                                    
            ,lev       = 5             
            ,cond_lev  = 9
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510406) ->
    #skill{
            id         = 510406
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510407             
            ,type      = 1                                    
            ,lev       = 6             
            ,cond_lev  = 11
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510407) ->
    #skill{
            id         = 510407
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510408             
            ,type      = 1                                    
            ,lev       = 7             
            ,cond_lev  = 13
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510408) ->
    #skill{
            id         = 510408
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510409             
            ,type      = 1                                    
            ,lev       = 8             
            ,cond_lev  = 15
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510409) ->
    #skill{
            id         = 510409
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 510410             
            ,type      = 1                                    
            ,lev       = 9             
            ,cond_lev  = 17
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510410) ->
    #skill{
            id         = 510410
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 10             
            ,cond_lev  = 19
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510411) ->
    #skill{
            id         = 510411
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 11             
            ,cond_lev  = 21
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510412) ->
    #skill{
            id         = 510412
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 12             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(510413) ->
    #skill{
            id         = 510413
			,name      = language:get(<<"大地震裂">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 13             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520500) ->
    #skill{
            id         = 520500
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520501             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(520501) ->
    #skill{
            id         = 520501
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520502             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 16
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131030 
            ,attr = []                                                       
        };
get(520502) ->
    #skill{
            id         = 520502
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520503             
            ,type      = 2                                    
            ,lev       = 2             
            ,cond_lev  = 18
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520503) ->
    #skill{
            id         = 520503
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520504             
            ,type      = 2                                    
            ,lev       = 3             
            ,cond_lev  = 20
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520504) ->
    #skill{
            id         = 520504
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520505             
            ,type      = 2                                    
            ,lev       = 4             
            ,cond_lev  = 22
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520505) ->
    #skill{
            id         = 520505
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520506             
            ,type      = 2                                    
            ,lev       = 5             
            ,cond_lev  = 24
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520506) ->
    #skill{
            id         = 520506
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520507             
            ,type      = 2                                    
            ,lev       = 6             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520507) ->
    #skill{
            id         = 520507
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520508             
            ,type      = 2                                    
            ,lev       = 7             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520508) ->
    #skill{
            id         = 520508
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520509             
            ,type      = 2                                    
            ,lev       = 8             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520509) ->
    #skill{
            id         = 520509
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 520510             
            ,type      = 2                                    
            ,lev       = 9             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520510) ->
    #skill{
            id         = 520510
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 10             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520511) ->
    #skill{
            id         = 520511
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 11             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520512) ->
    #skill{
            id         = 520512
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 12             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(520513) ->
    #skill{
            id         = 520513
			,name      = language:get(<<"光之屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 13             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500600) ->
    #skill{
            id         = 500600
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500601             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(500601) ->
    #skill{
            id         = 500601
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500602             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 23
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131031 
            ,attr = [{defence,75}]                                                       
        };
get(500602) ->
    #skill{
            id         = 500602
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500603             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 25
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = [{defence,112}]                                                       
        };
get(500603) ->
    #skill{
            id         = 500603
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500604             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 27
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = [{defence,150}]                                                       
        };
get(500604) ->
    #skill{
            id         = 500604
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500605             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 29
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = [{defence,187}]                                                       
        };
get(500605) ->
    #skill{
            id         = 500605
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500606             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 31
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = [{defence,225}]                                                       
        };
get(500606) ->
    #skill{
            id         = 500606
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500607             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 33
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = [{defence,300}]                                                       
        };
get(500607) ->
    #skill{
            id         = 500607
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500608             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 35
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = [{defence,412}]                                                       
        };
get(500608) ->
    #skill{
            id         = 500608
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500609             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 37
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = [{defence,525}]                                                       
        };
get(500609) ->
    #skill{
            id         = 500609
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 500610             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 39
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = [{defence,637}]                                                       
        };
get(500610) ->
    #skill{
            id         = 500610
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 41
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = [{defence,750}]                                                       
        };
get(500611) ->
    #skill{
            id         = 500611
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 43
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = [{defence,525}]                                                       
        };
get(500612) ->
    #skill{
            id         = 500612
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 45
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = [{defence,637}]                                                       
        };
get(500613) ->
    #skill{
            id         = 500613
			,name      = language:get(<<"防御强化">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 47
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = [{defence,750}]                                                       
        };
get(500700) ->
    #skill{
            id         = 500700
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500701             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(500701) ->
    #skill{
            id         = 500701
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500702             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 26
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131032 
            ,attr = [{evasion,6}]                                                       
        };
get(500702) ->
    #skill{
            id         = 500702
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500703             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = [{evasion,9}]                                                       
        };
get(500703) ->
    #skill{
            id         = 500703
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500704             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = [{evasion,12}]                                                       
        };
get(500704) ->
    #skill{
            id         = 500704
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500705             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = [{evasion,15}]                                                       
        };
get(500705) ->
    #skill{
            id         = 500705
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500706             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = [{evasion,18}]                                                       
        };
get(500706) ->
    #skill{
            id         = 500706
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500707             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = [{evasion,24}]                                                       
        };
get(500707) ->
    #skill{
            id         = 500707
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500708             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = [{evasion,33}]                                                       
        };
get(500708) ->
    #skill{
            id         = 500708
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500709             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = [{evasion,42}]                                                       
        };
get(500709) ->
    #skill{
            id         = 500709
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 500710             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = [{evasion,51}]                                                       
        };
get(500710) ->
    #skill{
            id         = 500710
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = [{evasion,60}]                                                       
        };
get(500711) ->
    #skill{
            id         = 500711
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = [{evasion,525}]                                                       
        };
get(500712) ->
    #skill{
            id         = 500712
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = [{evasion,637}]                                                       
        };
get(500713) ->
    #skill{
            id         = 500713
			,name      = language:get(<<"格挡强化">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = [{evasion,750}]                                                       
        };
get(500800) ->
    #skill{
            id         = 500800
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500801             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(500801) ->
    #skill{
            id         = 500801
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500802             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 28
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131033 
            ,attr = []                                                       
        };
get(500802) ->
    #skill{
            id         = 500802
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500803             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500803) ->
    #skill{
            id         = 500803
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500804             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500804) ->
    #skill{
            id         = 500804
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500805             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500805) ->
    #skill{
            id         = 500805
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500806             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500806) ->
    #skill{
            id         = 500806
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500807             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500807) ->
    #skill{
            id         = 500807
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500808             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500808) ->
    #skill{
            id         = 500808
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500809             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500809) ->
    #skill{
            id         = 500809
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 500810             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500810) ->
    #skill{
            id         = 500810
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500811) ->
    #skill{
            id         = 500811
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500812) ->
    #skill{
            id         = 500812
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500813) ->
    #skill{
            id         = 500813
			,name      = language:get(<<"圣盾闪现">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500900) ->
    #skill{
            id         = 500900
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500901             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(500901) ->
    #skill{
            id         = 500901
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500902             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 30
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131034 
            ,attr = []                                                       
        };
get(500902) ->
    #skill{
            id         = 500902
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500903             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500903) ->
    #skill{
            id         = 500903
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500904             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500904) ->
    #skill{
            id         = 500904
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500905             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500905) ->
    #skill{
            id         = 500905
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500906             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500906) ->
    #skill{
            id         = 500906
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500907             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500907) ->
    #skill{
            id         = 500907
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500908             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500908) ->
    #skill{
            id         = 500908
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500909             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500909) ->
    #skill{
            id         = 500909
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 500910             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500910) ->
    #skill{
            id         = 500910
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500911) ->
    #skill{
            id         = 500911
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500912) ->
    #skill{
            id         = 500912
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(500913) ->
    #skill{
            id         = 500913
			,name      = language:get(<<"执念回击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 54
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501000) ->
    #skill{
            id         = 501000
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501001             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(501001) ->
    #skill{
            id         = 501001
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501002             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 32
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 131035 
            ,attr = []                                                       
        };
get(501002) ->
    #skill{
            id         = 501002
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501003             
            ,type      = 0                                    
            ,lev       = 2             
            ,cond_lev  = 34
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 1200             
            ,cost_att  = 135                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501003) ->
    #skill{
            id         = 501003
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501004             
            ,type      = 0                                    
            ,lev       = 3             
            ,cond_lev  = 36
			,cond_skilled = 0
            ,cost_item = 1             
            ,cost_coin = 2800             
            ,cost_att  = 270                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501004) ->
    #skill{
            id         = 501004
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501005             
            ,type      = 0                                    
            ,lev       = 4             
            ,cond_lev  = 38
			,cond_skilled = 0
            ,cost_item = 3             
            ,cost_coin = 12500             
            ,cost_att  = 950                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501005) ->
    #skill{
            id         = 501005
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501006             
            ,type      = 0                                    
            ,lev       = 5             
            ,cond_lev  = 40
			,cond_skilled = 0
            ,cost_item = 5             
            ,cost_coin = 60000             
            ,cost_att  = 3680                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501006) ->
    #skill{
            id         = 501006
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501007             
            ,type      = 0                                    
            ,lev       = 6             
            ,cond_lev  = 42
			,cond_skilled = 0
            ,cost_item = 9             
            ,cost_coin = 140000             
            ,cost_att  = 19500                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501007) ->
    #skill{
            id         = 501007
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501008             
            ,type      = 0                                    
            ,lev       = 7             
            ,cond_lev  = 44
			,cond_skilled = 0
            ,cost_item = 15             
            ,cost_coin = 220000             
            ,cost_att  = 48000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501008) ->
    #skill{
            id         = 501008
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501009             
            ,type      = 0                                    
            ,lev       = 8             
            ,cond_lev  = 46
			,cond_skilled = 0
            ,cost_item = 35             
            ,cost_coin = 380000             
            ,cost_att  = 135000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501009) ->
    #skill{
            id         = 501009
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 501010             
            ,type      = 0                                    
            ,lev       = 9             
            ,cond_lev  = 48
			,cond_skilled = 0
            ,cost_item = 60             
            ,cost_coin = 740000             
            ,cost_att  = 300000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501010) ->
    #skill{
            id         = 501010
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 10             
            ,cond_lev  = 50
			,cond_skilled = 0
            ,cost_item = 90             
            ,cost_coin = 1000000             
            ,cost_att  = 475000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501011) ->
    #skill{
            id         = 501011
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 11             
            ,cond_lev  = 52
			,cond_skilled = 0
            ,cost_item = 180             
            ,cost_coin = 1000100             
            ,cost_att  = 675000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501012) ->
    #skill{
            id         = 501012
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 12             
            ,cond_lev  = 54
			,cond_skilled = 0
            ,cost_item = 360             
            ,cost_coin = 1000200             
            ,cost_att  = 950000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(501013) ->
    #skill{
            id         = 501013
			,name      = language:get(<<"不灭意志">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 13             
            ,cond_lev  = 56
			,cond_skilled = 0
            ,cost_item = 720             
            ,cost_coin = 1000300             
            ,cost_att  = 1250000                         
            ,item_id = 131001 
            ,attr = []                                                       
        };
get(600001) ->
    #skill{
            id         = 600001
			,name      = language:get(<<"猪南瓜普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600002) ->
    #skill{
            id         = 600002
			,name      = language:get(<<"闲逛的野猪怪加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600003) ->
    #skill{
            id         = 600003
			,name      = language:get(<<"通用怪AI1普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600004) ->
    #skill{
            id         = 600004
			,name      = language:get(<<"午睡灰熊普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600005) ->
    #skill{
            id         = 600005
			,name      = language:get(<<"午睡灰熊群睡">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600006) ->
    #skill{
            id         = 600006
			,name      = language:get(<<"午睡灰熊暴怒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600007) ->
    #skill{
            id         = 600007
			,name      = language:get(<<"午睡灰熊AOE">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600008) ->
    #skill{
            id         = 600008
			,name      = language:get(<<"森林女巫普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600009) ->
    #skill{
            id         = 600009
			,name      = language:get(<<"森林女巫沉默">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600010) ->
    #skill{
            id         = 600010
			,name      = language:get(<<"森林女巫召唤">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600011) ->
    #skill{
            id         = 600011
			,name      = language:get(<<"森林女巫AOE">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600012) ->
    #skill{
            id         = 600012
			,name      = language:get(<<"神鸦光屏障">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600013) ->
    #skill{
            id         = 600013
			,name      = language:get(<<"神鸦加格挡">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600014) ->
    #skill{
            id         = 600014
			,name      = language:get(<<"神鸦加血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600015) ->
    #skill{
            id         = 600015
			,name      = language:get(<<"神鸦普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600016) ->
    #skill{
            id         = 600016
			,name      = language:get(<<"神鸦群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600017) ->
    #skill{
            id         = 600017
			,name      = language:get(<<"种子草AOE">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600018) ->
    #skill{
            id         = 600018
			,name      = language:get(<<"种子草嘲讽">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600019) ->
    #skill{
            id         = 600019
			,name      = language:get(<<"种子草AOE2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600020) ->
    #skill{
            id         = 600020
			,name      = language:get(<<"种子草1.2普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600021) ->
    #skill{
            id         = 600021
			,name      = language:get(<<"种子草加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600022) ->
    #skill{
            id         = 600022
			,name      = language:get(<<"通用ai6群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600023) ->
    #skill{
            id         = 600023
			,name      = language:get(<<"通用ai6沉默">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600024) ->
    #skill{
            id         = 600024
			,name      = language:get(<<"通用ai6AOE">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600025) ->
    #skill{
            id         = 600025
			,name      = language:get(<<"通用ai6普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600026) ->
    #skill{
            id         = 600026
			,name      = language:get(<<"通用ai6普攻1.2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600027) ->
    #skill{
            id         = 600027
			,name      = language:get(<<"通用ai7坚韧">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600028) ->
    #skill{
            id         = 600028
			,name      = language:get(<<"通用ai7震裂">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600029) ->
    #skill{
            id         = 600029
			,name      = language:get(<<"通用ai7群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600030) ->
    #skill{
            id         = 600030
			,name      = language:get(<<"通用ai7普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600031) ->
    #skill{
            id         = 600031
			,name      = language:get(<<"通用ai7普攻1.2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600032) ->
    #skill{
            id         = 600032
			,name      = language:get(<<"石灵兵普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600033) ->
    #skill{
            id         = 600033
			,name      = language:get(<<"石灵兵加免伤">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600034) ->
    #skill{
            id         = 600034
			,name      = language:get(<<"石灵兵沉默">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600035) ->
    #skill{
            id         = 600035
			,name      = language:get(<<"石灵兵群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600036) ->
    #skill{
            id         = 600036
			,name      = language:get(<<"石灵兵加坚韧">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600037) ->
    #skill{
            id         = 600037
			,name      = language:get(<<"石灵兵随从普攻1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600038) ->
    #skill{
            id         = 600038
			,name      = language:get(<<"石灵兵随从加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600039) ->
    #skill{
            id         = 600039
			,name      = language:get(<<"石灵兵加血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600040) ->
    #skill{
            id         = 600040
			,name      = language:get(<<"石灵兵随从群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600041) ->
    #skill{
            id         = 600041
			,name      = language:get(<<"蜥蜴群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600042) ->
    #skill{
            id         = 600042
			,name      = language:get(<<"蜥蜴加命中">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600043) ->
    #skill{
            id         = 600043
			,name      = language:get(<<"蜥蜴加暴怒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600044) ->
    #skill{
            id         = 600044
			,name      = language:get(<<"蜥蜴随从普攻1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600045) ->
    #skill{
            id         = 600045
			,name      = language:get(<<"蜥蜴随从普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600046) ->
    #skill{
            id         = 600046
			,name      = language:get(<<"蜥蜴随从嘲讽">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600047) ->
    #skill{
            id         = 600047
			,name      = language:get(<<"蜥蜴随从群睡">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600048) ->
    #skill{
            id         = 600048
			,name      = language:get(<<"蜥蜴随从加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600049) ->
    #skill{
            id         = 600049
			,name      = language:get(<<"蜥蜴加血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600050) ->
    #skill{
            id         = 600050
			,name      = language:get(<<"沙虫群攻1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600051) ->
    #skill{
            id         = 600051
			,name      = language:get(<<"沙虫加格挡">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600052) ->
    #skill{
            id         = 600052
			,name      = language:get(<<"沙虫加坚韧">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600053) ->
    #skill{
            id         = 600053
			,name      = language:get(<<"沙虫普攻1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600054) ->
    #skill{
            id         = 600054
			,name      = language:get(<<"沙虫普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600055) ->
    #skill{
            id         = 600055
			,name      = language:get(<<"通用ai10群攻1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600056) ->
    #skill{
            id         = 600056
			,name      = language:get(<<"通用ai10普攻1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600057) ->
    #skill{
            id         = 600057
			,name      = language:get(<<"通用ai10普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600058) ->
    #skill{
            id         = 600058
			,name      = language:get(<<"通用ai10群沉默">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600059) ->
    #skill{
            id         = 600059
			,name      = language:get(<<"毒蝎群毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600060) ->
    #skill{
            id         = 600060
			,name      = language:get(<<"毒蝎单毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600061) ->
    #skill{
            id         = 600061
			,name      = language:get(<<"毒蝎普攻1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600062) ->
    #skill{
            id         = 600062
			,name      = language:get(<<"毒蝎普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600063) ->
    #skill{
            id         = 600063
			,name      = language:get(<<"毒蝎降防">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600064) ->
    #skill{
            id         = 600064
			,name      = language:get(<<"热毒蝎屏障">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600065) ->
    #skill{
            id         = 600065
			,name      = language:get(<<"热毒蝎普攻1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600066) ->
    #skill{
            id         = 600066
			,name      = language:get(<<"热毒蝎普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600067) ->
    #skill{
            id         = 600067
			,name      = language:get(<<"热蜥蜴加血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600068) ->
    #skill{
            id         = 600068
			,name      = language:get(<<"毒蝎首领中毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600069) ->
    #skill{
            id         = 600069
			,name      = language:get(<<"毒蝎首领格挡">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600070) ->
    #skill{
            id         = 600070
			,name      = language:get(<<"毒蝎首领群嘲">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600071) ->
    #skill{
            id         = 600071
			,name      = language:get(<<"毒蝎首领减攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600072) ->
    #skill{
            id         = 600072
			,name      = language:get(<<"毒蝎首领中毒2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600073) ->
    #skill{
            id         = 600073
			,name      = language:get(<<"毒蝎首领加格挡">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600074) ->
    #skill{
            id         = 600074
			,name      = language:get(<<"毒蝎首领中毒3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600075) ->
    #skill{
            id         = 600075
			,name      = language:get(<<"毒蝎首领加血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600076) ->
    #skill{
            id         = 600076
			,name      = language:get(<<"毒蝎首领加血2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600077) ->
    #skill{
            id         = 600077
			,name      = language:get(<<"毒蝎首领普攻2连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600078) ->
    #skill{
            id         = 600078
			,name      = language:get(<<"毒蝎首领普攻3连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600079) ->
    #skill{
            id         = 600079
			,name      = language:get(<<"毒蝎首领中毒4">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600080) ->
    #skill{
            id         = 600080
			,name      = language:get(<<"毒蝎首领减攻2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600081) ->
    #skill{
            id         = 600081
			,name      = language:get(<<"毒蝎首领普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600082) ->
    #skill{
            id         = 600082
			,name      = language:get(<<"通用ai12群1.2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600083) ->
    #skill{
            id         = 600083
			,name      = language:get(<<"通用ai12单2连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600084) ->
    #skill{
            id         = 600084
			,name      = language:get(<<"通用ai12单3连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600085) ->
    #skill{
            id         = 600085
			,name      = language:get(<<"通用ai12降防">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600086) ->
    #skill{
            id         = 600086
			,name      = language:get(<<"通用ai12加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600087) ->
    #skill{
            id         = 600087
			,name      = language:get(<<"通用ai12加格挡">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600088) ->
    #skill{
            id         = 600088
			,name      = language:get(<<"通用ai12降命中">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600089) ->
    #skill{
            id         = 600089
			,name      = language:get(<<"通用ai12普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600090) ->
    #skill{
            id         = 600090
			,name      = language:get(<<"通用ai12坚韧">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600091) ->
    #skill{
            id         = 600091
			,name      = language:get(<<"通用ai12群沉默">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600092) ->
    #skill{
            id         = 600092
			,name      = language:get(<<"通用ai13群1.2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600093) ->
    #skill{
            id         = 600093
			,name      = language:get(<<"通用ai13单2连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600094) ->
    #skill{
            id         = 600094
			,name      = language:get(<<"通用ai13单3连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600095) ->
    #skill{
            id         = 600095
			,name      = language:get(<<"通用ai13降防">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600096) ->
    #skill{
            id         = 600096
			,name      = language:get(<<"通用ai13加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600097) ->
    #skill{
            id         = 600097
			,name      = language:get(<<"通用ai12加血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600098) ->
    #skill{
            id         = 600098
			,name      = language:get(<<"通用ai13加血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600099) ->
    #skill{
            id         = 600099
			,name      = language:get(<<"通用ai13加格挡">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600100) ->
    #skill{
            id         = 600100
			,name      = language:get(<<"通用ai13降命中">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600101) ->
    #skill{
            id         = 600101
			,name      = language:get(<<"通用ai13普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600102) ->
    #skill{
            id         = 600102
			,name      = language:get(<<"通用ai13坚韧">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600103) ->
    #skill{
            id         = 600103
			,name      = language:get(<<"通用ai13群沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600104) ->
    #skill{
            id         = 600104
			,name      = language:get(<<"叶子群1.5">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600105) ->
    #skill{
            id         = 600105
			,name      = language:get(<<"叶子群1">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600106) ->
    #skill{
            id         = 600106
			,name      = language:get(<<"叶子群毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600107) ->
    #skill{
            id         = 600107
			,name      = language:get(<<"叶子群降攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600108) ->
    #skill{
            id         = 600108
			,name      = language:get(<<"叶子群加攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600109) ->
    #skill{
            id         = 600109
			,name      = language:get(<<"叶子加血">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600110) ->
    #skill{
            id         = 600110
			,name      = language:get(<<"龙1、3回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600111) ->
    #skill{
            id         = 600111
			,name      = language:get(<<"龙2回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600112) ->
    #skill{
            id         = 600112
			,name      = language:get(<<"龙4回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600113) ->
    #skill{
            id         = 600113
			,name      = language:get(<<"龙5、6回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600114) ->
    #skill{
            id         = 600114
			,name      = language:get(<<"龙7回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600115) ->
    #skill{
            id         = 600115
			,name      = language:get(<<"龙8回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600116) ->
    #skill{
            id         = 600116
			,name      = language:get(<<"龙9回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600117) ->
    #skill{
            id         = 600117
			,name      = language:get(<<"龙10回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600118) ->
    #skill{
            id         = 600118
			,name      = language:get(<<"龙11回合（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600119) ->
    #skill{
            id         = 600119
			,name      = language:get(<<"龙12回合以上（弃用）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600120) ->
    #skill{
            id         = 600120
			,name      = language:get(<<"宠物1普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600121) ->
    #skill{
            id         = 600121
			,name      = language:get(<<"宠物2普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600122) ->
    #skill{
            id         = 600122
			,name      = language:get(<<"宠物3普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600123) ->
    #skill{
            id         = 600123
			,name      = language:get(<<"叶子加格挡">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600124) ->
    #skill{
            id         = 600124
			,name      = language:get(<<"叶子降命中">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600125) ->
    #skill{
            id         = 600125
			,name      = language:get(<<"叶子群毒2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600126) ->
    #skill{
            id         = 600126
			,name      = language:get(<<"叶子群沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600127) ->
    #skill{
            id         = 600127
			,name      = language:get(<<"叶子群毒3">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600128) ->
    #skill{
            id         = 600128
			,name      = language:get(<<"叶子普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600129) ->
    #skill{
            id         = 600129
			,name      = language:get(<<"树根首领群1.5">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600130) ->
    #skill{
            id         = 600130
			,name      = language:get(<<"树根首领群1.2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600131) ->
    #skill{
            id         = 600131
			,name      = language:get(<<"树根首领群降防">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600132) ->
    #skill{
            id         = 600132
			,name      = language:get(<<"树根首领普攻1.8">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600133) ->
    #skill{
            id         = 600133
			,name      = language:get(<<"树根首领群暴击">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600134) ->
    #skill{
            id         = 600134
			,name      = language:get(<<"树根首领加血">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600135) ->
    #skill{
            id         = 600135
			,name      = language:get(<<"树根首领加暴击">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600136) ->
    #skill{
            id         = 600136
			,name      = language:get(<<"树根首领降坚韧">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600137) ->
    #skill{
            id         = 600137
			,name      = language:get(<<"树根首领群加攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600138) ->
    #skill{
            id         = 600138
			,name      = language:get(<<"树根首领群毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600139) ->
    #skill{
            id         = 600139
			,name      = language:get(<<"树根首领群沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600140) ->
    #skill{
            id         = 600140
			,name      = language:get(<<"树根首领群毒2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600141) ->
    #skill{
            id         = 600141
			,name      = language:get(<<"树根首领普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600142) ->
    #skill{
            id         = 600142
			,name      = language:get(<<"魔化蜥蜴群攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600143) ->
    #skill{
            id         = 600143
			,name      = language:get(<<"魔化蜥蜴普攻2连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600144) ->
    #skill{
            id         = 600144
			,name      = language:get(<<"魔化蜥蜴普攻3连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600145) ->
    #skill{
            id         = 600145
			,name      = language:get(<<"魔化蜥蜴群降攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600146) ->
    #skill{
            id         = 600146
			,name      = language:get(<<"魔化蜥蜴群加攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600147) ->
    #skill{
            id         = 600147
			,name      = language:get(<<"魔化蜥蜴加血">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600148) ->
    #skill{
            id         = 600148
			,name      = language:get(<<"魔化蜥蜴加格挡">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600149) ->
    #skill{
            id         = 600149
			,name      = language:get(<<"魔化蜥蜴降命中">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600150) ->
    #skill{
            id         = 600150
			,name      = language:get(<<"魔化蜥蜴普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600151) ->
    #skill{
            id         = 600151
			,name      = language:get(<<"魔化蜥蜴加坚韧">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600152) ->
    #skill{
            id         = 600152
			,name      = language:get(<<"魔化蜥蜴群沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600153) ->
    #skill{
            id         = 600153
			,name      = language:get(<<"树根首领群沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600154) ->
    #skill{
            id         = 600154
			,name      = language:get(<<"树根首领群毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600155) ->
    #skill{
            id         = 600155
			,name      = language:get(<<"树根首领群降攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600156) ->
    #skill{
            id         = 600156
			,name      = language:get(<<"树根首领召唤">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600157) ->
    #skill{
            id         = 600157
			,name      = language:get(<<"树根首领降格挡">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600158) ->
    #skill{
            id         = 600158
			,name      = language:get(<<"树根首领群攻1.2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600159) ->
    #skill{
            id         = 600159
			,name      = language:get(<<"树根首领沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600160) ->
    #skill{
            id         = 600160
			,name      = language:get(<<"树根首领加血">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600161) ->
    #skill{
            id         = 600161
			,name      = language:get(<<"树根首领普攻2连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600162) ->
    #skill{
            id         = 600162
			,name      = language:get(<<"树根首领普攻3连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600163) ->
    #skill{
            id         = 600163
			,name      = language:get(<<"树根首领群沉默1.2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600164) ->
    #skill{
            id         = 600164
			,name      = language:get(<<"树根首领普攻4连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600165) ->
    #skill{
            id         = 600165
			,name      = language:get(<<"树根首领沉默2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600166) ->
    #skill{
            id         = 600166
			,name      = language:get(<<"树根首领加格挡">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600167) ->
    #skill{
            id         = 600167
			,name      = language:get(<<"树根首领普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600168) ->
    #skill{
            id         = 600168
			,name      = language:get(<<"叶子精加血">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600169) ->
    #skill{
            id         = 600169
			,name      = language:get(<<"叶子精清buff">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600170) ->
    #skill{
            id         = 600170
			,name      = language:get(<<"叶子精群加攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600171) ->
    #skill{
            id         = 600171
			,name      = language:get(<<"叶子精群加坚韧">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600172) ->
    #skill{
            id         = 600172
			,name      = language:get(<<"蜥蜴头领群沉默毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600173) ->
    #skill{
            id         = 600173
			,name      = language:get(<<"蜥蜴头领群毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600174) ->
    #skill{
            id         = 600174
			,name      = language:get(<<"蜥蜴头领加格挡">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600175) ->
    #skill{
            id         = 600175
			,name      = language:get(<<"蜥蜴头领群攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600176) ->
    #skill{
            id         = 600176
			,name      = language:get(<<"蜥蜴头领嘲讽">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600177) ->
    #skill{
            id         = 600177
			,name      = language:get(<<"蜥蜴头领加攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600178) ->
    #skill{
            id         = 600178
			,name      = language:get(<<"蜥蜴头领普攻2连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600179) ->
    #skill{
            id         = 600179
			,name      = language:get(<<"蜥蜴头领群攻1.2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600180) ->
    #skill{
            id         = 600180
			,name      = language:get(<<"蜥蜴头领普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600181) ->
    #skill{
            id         = 600181
			,name      = language:get(<<"蜥蜴头领群沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600182) ->
    #skill{
            id         = 600182
			,name      = language:get(<<"蜥蜴头领加攻2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600183) ->
    #skill{
            id         = 600183
			,name      = language:get(<<"蜥蜴头领群毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600184) ->
    #skill{
            id         = 600184
			,name      = language:get(<<"蜥蜴头领沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600185) ->
    #skill{
            id         = 600185
			,name      = language:get(<<"霍德尔群沉默毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600186) ->
    #skill{
            id         = 600186
			,name      = language:get(<<"霍德尔群毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600187) ->
    #skill{
            id         = 600187
			,name      = language:get(<<"霍德尔加暴击">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600188) ->
    #skill{
            id         = 600188
			,name      = language:get(<<"霍德尔群攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600189) ->
    #skill{
            id         = 600189
			,name      = language:get(<<"霍德尔嘲讽">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600190) ->
    #skill{
            id         = 600190
			,name      = language:get(<<"霍德尔加攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600191) ->
    #skill{
            id         = 600191
			,name      = language:get(<<"霍德尔普攻3连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600192) ->
    #skill{
            id         = 600192
			,name      = language:get(<<"霍德尔群攻1.2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600193) ->
    #skill{
            id         = 600193
			,name      = language:get(<<"霍德尔普攻4连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600194) ->
    #skill{
            id         = 600194
			,name      = language:get(<<"霍德尔群沉默">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600195) ->
    #skill{
            id         = 600195
			,name      = language:get(<<"霍德尔加攻2">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600196) ->
    #skill{
            id         = 600196
			,name      = language:get(<<"霍德尔群毒">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600197) ->
    #skill{
            id         = 600197
			,name      = language:get(<<"霍德尔普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600198) ->
    #skill{
            id         = 600198
			,name      = language:get(<<"霍德尔沉默1.8">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600199) ->
    #skill{
            id         = 600199
			,name      = language:get(<<"南瓜怪3倍攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600200) ->
    #skill{
            id         = 600200
			,name      = language:get(<<"南瓜群攻加沉默">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600201) ->
    #skill{
            id         = 600201
			,name      = language:get(<<"南瓜群攻5">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600202) ->
    #skill{
            id         = 600202
			,name      = language:get(<<"南瓜单加攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600203) ->
    #skill{
            id         = 600203
			,name      = language:get(<<"南瓜加坚韧">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600204) ->
    #skill{
            id         = 600204
			,name      = language:get(<<"群攻加沉默">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600205) ->
    #skill{
            id         = 600205
			,name      = language:get(<<"南瓜加血">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600206) ->
    #skill{
            id         = 600206
			,name      = language:get(<<"群攻1.5">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600207) ->
    #skill{
            id         = 600207
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600208) ->
    #skill{
            id         = 600208
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600209) ->
    #skill{
            id         = 600209
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600210) ->
    #skill{
            id         = 600210
			,name      = language:get(<<"群攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600211) ->
    #skill{
            id         = 600211
			,name      = language:get(<<"降格挡">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600212) ->
    #skill{
            id         = 600212
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600213) ->
    #skill{
            id         = 600213
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600214) ->
    #skill{
            id         = 600214
			,name      = language:get(<<"沉默">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600215) ->
    #skill{
            id         = 600215
			,name      = language:get(<<"加坚韧">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600216) ->
    #skill{
            id         = 600216
			,name      = language:get(<<"群攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600217) ->
    #skill{
            id         = 600217
			,name      = language:get(<<"降攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600218) ->
    #skill{
            id         = 600218
			,name      = language:get(<<"远普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600219) ->
    #skill{
            id         = 600219
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600220) ->
    #skill{
            id         = 600220
			,name      = language:get(<<"加坚韧">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600221) ->
    #skill{
            id         = 600221
			,name      = language:get(<<"树精守卫群攻加沉默">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600222) ->
    #skill{
            id         = 600222
			,name      = language:get(<<"单4降攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600223) ->
    #skill{
            id         = 600223
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600224) ->
    #skill{
            id         = 600224
			,name      = language:get(<<"加血">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600225) ->
    #skill{
            id         = 600225
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600226) ->
    #skill{
            id         = 600226
			,name      = language:get(<<"加坚韧">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600227) ->
    #skill{
            id         = 600227
			,name      = language:get(<<"普攻1.5">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600228) ->
    #skill{
            id         = 600228
			,name      = language:get(<<"普攻1.5">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600229) ->
    #skill{
            id         = 600229
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600230) ->
    #skill{
            id         = 600230
			,name      = language:get(<<"远普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600231) ->
    #skill{
            id         = 600231
			,name      = language:get(<<"加血">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600232) ->
    #skill{
            id         = 600232
			,name      = language:get(<<"单毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600233) ->
    #skill{
            id         = 600233
			,name      = language:get(<<"西树枝群攻加中毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600234) ->
    #skill{
            id         = 600234
			,name      = language:get(<<"单攻加中毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600235) ->
    #skill{
            id         = 600235
			,name      = language:get(<<"单攻加沉默">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600236) ->
    #skill{
            id         = 600236
			,name      = language:get(<<"加格挡">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600237) ->
    #skill{
            id         = 600237
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600238) ->
    #skill{
            id         = 600238
			,name      = language:get(<<"单攻加嘲讽">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600239) ->
    #skill{
            id         = 600239
			,name      = language:get(<<"沉默">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600240) ->
    #skill{
            id         = 600240
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600241) ->
    #skill{
            id         = 600241
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600242) ->
    #skill{
            id         = 600242
			,name      = language:get(<<"东树枝单攻加中毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600243) ->
    #skill{
            id         = 600243
			,name      = language:get(<<"群毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600244) ->
    #skill{
            id         = 600244
			,name      = language:get(<<"群攻5">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600245) ->
    #skill{
            id         = 600245
			,name      = language:get(<<"加暴击">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600246) ->
    #skill{
            id         = 600246
			,name      = language:get(<<"普攻2">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600247) ->
    #skill{
            id         = 600247
			,name      = language:get(<<"加格挡">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600248) ->
    #skill{
            id         = 600248
			,name      = language:get(<<"加血">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600249) ->
    #skill{
            id         = 600249
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600250) ->
    #skill{
            id         = 600250
			,name      = language:get(<<"沉默">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600251) ->
    #skill{
            id         = 600251
			,name      = language:get(<<"加暴击">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600252) ->
    #skill{
            id         = 600252
			,name      = language:get(<<"降坚韧">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600253) ->
    #skill{
            id         = 600253
			,name      = language:get(<<"普攻2">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600254) ->
    #skill{
            id         = 600254
			,name      = language:get(<<"加格挡">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600255) ->
    #skill{
            id         = 600255
			,name      = language:get(<<"降防御">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600256) ->
    #skill{
            id         = 600256
			,name      = language:get(<<"加坚韧">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600257) ->
    #skill{
            id         = 600257
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600258) ->
    #skill{
            id         = 600258
			,name      = language:get(<<"降攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600259) ->
    #skill{
            id         = 600259
			,name      = language:get(<<"加坚韧">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600260) ->
    #skill{
            id         = 600260
			,name      = language:get(<<"树叶守卫普攻6">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600261) ->
    #skill{
            id         = 600261
			,name      = language:get(<<"群毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600262) ->
    #skill{
            id         = 600262
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600263) ->
    #skill{
            id         = 600263
			,name      = language:get(<<"加格挡">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600264) ->
    #skill{
            id         = 600264
			,name      = language:get(<<"加暴击">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600265) ->
    #skill{
            id         = 600265
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600266) ->
    #skill{
            id         = 600266
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600267) ->
    #skill{
            id         = 600267
			,name      = language:get(<<"加血">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600268) ->
    #skill{
            id         = 600268
			,name      = language:get(<<"加格挡">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600269) ->
    #skill{
            id         = 600269
			,name      = language:get(<<"群睡">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600270) ->
    #skill{
            id         = 600270
			,name      = language:get(<<"兽皮守卫远普攻4">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600271) ->
    #skill{
            id         = 600271
			,name      = language:get(<<"群攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600272) ->
    #skill{
            id         = 600272
			,name      = language:get(<<"加血">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600273) ->
    #skill{
            id         = 600273
			,name      = language:get(<<"加血">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600274) ->
    #skill{
            id         = 600274
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600275) ->
    #skill{
            id         = 600275
			,name      = language:get(<<"光屏障">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600276) ->
    #skill{
            id         = 600276
			,name      = language:get(<<"单攻加嘲讽">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600277) ->
    #skill{
            id         = 600277
			,name      = language:get(<<"普攻3连">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600278) ->
    #skill{
            id         = 600278
			,name      = language:get(<<"沉默">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600279) ->
    #skill{
            id         = 600279
			,name      = language:get(<<"群睡">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600280) ->
    #skill{
            id         = 600280
			,name      = language:get(<<"普攻3连">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600281) ->
    #skill{
            id         = 600281
			,name      = language:get(<<"光屏障">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600282) ->
    #skill{
            id         = 600282
			,name      = language:get(<<"单攻加嘲讽">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600283) ->
    #skill{
            id         = 600283
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600284) ->
    #skill{
            id         = 600284
			,name      = language:get(<<"单攻加嘲讽">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600285) ->
    #skill{
            id         = 600285
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600286) ->
    #skill{
            id         = 600286
			,name      = language:get(<<"光屏障">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600287) ->
    #skill{
            id         = 600287
			,name      = language:get(<<"单攻加嘲讽">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600288) ->
    #skill{
            id         = 600288
			,name      = language:get(<<"普攻3连">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600289) ->
    #skill{
            id         = 600289
			,name      = language:get(<<"黄铜甲守卫普攻4连">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600290) ->
    #skill{
            id         = 600290
			,name      = language:get(<<"普攻2连">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600291) ->
    #skill{
            id         = 600291
			,name      = language:get(<<"群攻5">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600292) ->
    #skill{
            id         = 600292
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600293) ->
    #skill{
            id         = 600293
			,name      = language:get(<<"单攻加中毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600295) ->
    #skill{
            id         = 600295
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600296) ->
    #skill{
            id         = 600296
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600297) ->
    #skill{
            id         = 600297
			,name      = language:get(<<"单攻加中毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600299) ->
    #skill{
            id         = 600299
			,name      = language:get(<<"绿革守卫单攻加中毒">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600300) ->
    #skill{
            id         = 600300
			,name      = language:get(<<"群攻加沉默">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600301) ->
    #skill{
            id         = 600301
			,name      = language:get(<<"普攻3连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600302) ->
    #skill{
            id         = 600302
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600303) ->
    #skill{
            id         = 600303
			,name      = language:get(<<"群攻加嘲讽">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600304) ->
    #skill{
            id         = 600304
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600305) ->
    #skill{
            id         = 600305
			,name      = language:get(<<"群睡">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600306) ->
    #skill{
            id         = 600306
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600307) ->
    #skill{
            id         = 600307
			,name      = language:get(<<"召唤">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600308) ->
    #skill{
            id         = 600308
			,name      = language:get(<<"召唤">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600309) ->
    #skill{
            id         = 600309
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600310) ->
    #skill{
            id         = 600310
			,name      = language:get(<<"银价守卫群攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600311) ->
    #skill{
            id         = 600311
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600312) ->
    #skill{
            id         = 600312
			,name      = language:get(<<"普攻2连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600313) ->
    #skill{
            id         = 600313
			,name      = language:get(<<"光屏障">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600314) ->
    #skill{
            id         = 600314
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600315) ->
    #skill{
            id         = 600315
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600316) ->
    #skill{
            id         = 600316
			,name      = language:get(<<"光屏障">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600317) ->
    #skill{
            id         = 600317
			,name      = language:get(<<"嘲讽">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600318) ->
    #skill{
            id         = 600318
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600319) ->
    #skill{
            id         = 600319
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600320) ->
    #skill{
            id         = 600320
			,name      = language:get(<<"光屏障">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600321) ->
    #skill{
            id         = 600321
			,name      = language:get(<<"嘲讽">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600322) ->
    #skill{
            id         = 600322
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600323) ->
    #skill{
            id         = 600323
			,name      = language:get(<<"单加攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600324) ->
    #skill{
            id         = 600324
			,name      = language:get(<<"剑士兔普攻3连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600325) ->
    #skill{
            id         = 600325
			,name      = language:get(<<"单攻加沉默">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600326) ->
    #skill{
            id         = 600326
			,name      = language:get(<<"普攻2连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600327) ->
    #skill{
            id         = 600327
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600328) ->
    #skill{
            id         = 600328
			,name      = language:get(<<"加格挡">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600329) ->
    #skill{
            id         = 600329
			,name      = language:get(<<"普攻2连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600330) ->
    #skill{
            id         = 600330
			,name      = language:get(<<"降命中">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600331) ->
    #skill{
            id         = 600331
			,name      = language:get(<<"普攻3连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600332) ->
    #skill{
            id         = 600332
			,name      = language:get(<<"普攻2连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600333) ->
    #skill{
            id         = 600333
			,name      = language:get(<<"降命中">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600334) ->
    #skill{
            id         = 600334
			,name      = language:get(<<"普攻3连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600335) ->
    #skill{
            id         = 600335
			,name      = language:get(<<"降防御">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600336) ->
    #skill{
            id         = 600336
			,name      = language:get(<<"普攻5连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600337) ->
    #skill{
            id         = 600337
			,name      = language:get(<<"骑士马光屏障">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600338) ->
    #skill{
            id         = 600338
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600339) ->
    #skill{
            id         = 600339
			,name      = language:get(<<"降格挡">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600340) ->
    #skill{
            id         = 600340
			,name      = language:get(<<"前期防玩家死降格挡">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600341) ->
    #skill{
            id         = 600341
			,name      = language:get(<<"沙虫给沙寇加血">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600342) ->
    #skill{
            id         = 600342
			,name      = language:get(<<"召唤小沙虫a">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600343) ->
    #skill{
            id         = 600343
			,name      = language:get(<<"召唤小沙虫2只">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600344) ->
    #skill{
            id         = 600344
			,name      = language:get(<<"安娜致盲穿刺">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600345) ->
    #skill{
            id         = 600345
			,name      = language:get(<<"安娜荆棘缠绕">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600346) ->
    #skill{
            id         = 600346
			,name      = language:get(<<"安娜大地震裂">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600347) ->
    #skill{
            id         = 600347
			,name      = language:get(<<"召唤小沙虫b">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600348) ->
    #skill{
            id         = 600348
			,name      = language:get(<<"降命中防死">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600349) ->
    #skill{
            id         = 600349
			,name      = language:get(<<"降坚韧防死">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600350) ->
    #skill{
            id         = 600350
			,name      = language:get(<<"加暴击防死">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600351) ->
    #skill{
            id         = 600351
			,name      = language:get(<<"世界树加暴击">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600352) ->
    #skill{
            id         = 600352
			,name      = language:get(<<"世界树加血">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600353) ->
    #skill{
            id         = 600353
			,name      = language:get(<<"世界树沉默">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600354) ->
    #skill{
            id         = 600354
			,name      = language:get(<<"世界树普攻2连">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600355) ->
    #skill{
            id         = 600355
			,name      = language:get(<<"世界树光屏障">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600356) ->
    #skill{
            id         = 600356
			,name      = language:get(<<"世界树嘲讽">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600357) ->
    #skill{
            id         = 600357
			,name      = language:get(<<"世界树睡眠">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600358) ->
    #skill{
            id         = 600358
			,name      = language:get(<<"世界树降格挡">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600359) ->
    #skill{
            id         = 600359
			,name      = language:get(<<"世界树降攻击">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600360) ->
    #skill{
            id         = 600360
			,name      = language:get(<<"世界树群毒">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600361) ->
    #skill{
            id         = 600361
			,name      = language:get(<<"世界树加攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600362) ->
    #skill{
            id         = 600362
			,name      = language:get(<<"世界树群攻加中毒">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600363) ->
    #skill{
            id         = 600363
			,name      = language:get(<<"世界树群攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600364) ->
    #skill{
            id         = 600364
			,name      = language:get(<<"龙1回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600365) ->
    #skill{
            id         = 600365
			,name      = language:get(<<"龙2回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600366) ->
    #skill{
            id         = 600366
			,name      = language:get(<<"龙3回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600367) ->
    #skill{
            id         = 600367
			,name      = language:get(<<"龙4回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600368) ->
    #skill{
            id         = 600368
			,name      = language:get(<<"龙5回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600369) ->
    #skill{
            id         = 600369
			,name      = language:get(<<"龙6回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600370) ->
    #skill{
            id         = 600370
			,name      = language:get(<<"龙7回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600371) ->
    #skill{
            id         = 600371
			,name      = language:get(<<"龙8回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600372) ->
    #skill{
            id         = 600372
			,name      = language:get(<<"龙9回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600373) ->
    #skill{
            id         = 600373
			,name      = language:get(<<"龙10回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600374) ->
    #skill{
            id         = 600374
			,name      = language:get(<<"龙11回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600375) ->
    #skill{
            id         = 600375
			,name      = language:get(<<"龙12回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600376) ->
    #skill{
            id         = 600376
			,name      = language:get(<<"龙13回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600377) ->
    #skill{
            id         = 600377
			,name      = language:get(<<"龙14回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600378) ->
    #skill{
            id         = 600378
			,name      = language:get(<<"龙15回合">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600379) ->
    #skill{
            id         = 600379
			,name      = language:get(<<"龙16回合以上">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600400) ->
    #skill{
            id         = 600400
			,name      = language:get(<<"20多人加暴击">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600401) ->
    #skill{
            id         = 600401
			,name      = language:get(<<"20多人睡眠">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600402) ->
    #skill{
            id         = 600402
			,name      = language:get(<<"20多人降攻击">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600403) ->
    #skill{
            id         = 600403
			,name      = language:get(<<"25多人沉默">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600404) ->
    #skill{
            id         = 600404
			,name      = language:get(<<"25多人加攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600405) ->
    #skill{
            id         = 600405
			,name      = language:get(<<"25多人嘲讽">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600406) ->
    #skill{
            id         = 600406
			,name      = language:get(<<"多人光屏障">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600407) ->
    #skill{
            id         = 600407
			,name      = language:get(<<"多人普攻2连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600408) ->
    #skill{
            id         = 600408
			,name      = language:get(<<"多人降格挡">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600409) ->
    #skill{
            id         = 600409
			,name      = language:get(<<"20多人睡眠">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600410) ->
    #skill{
            id         = 600410
			,name      = language:get(<<"25多人群体嘲讽">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600411) ->
    #skill{
            id         = 600411
			,name      = language:get(<<"20多人加暴击">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600412) ->
    #skill{
            id         = 600412
			,name      = language:get(<<"25多人群加攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600413) ->
    #skill{
            id         = 600413
			,name      = language:get(<<"多人普攻3连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600414) ->
    #skill{
            id         = 600414
			,name      = language:get(<<"25多人群沉默">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600415) ->
    #skill{
            id         = 600415
			,name      = language:get(<<"多人加格挡">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600416) ->
    #skill{
            id         = 600416
			,name      = language:get(<<"多人毒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600417) ->
    #skill{
            id         = 600417
			,name      = language:get(<<"多人群毒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600418) ->
    #skill{
            id         = 600418
			,name      = language:get(<<"25多人群嘲讽">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600419) ->
    #skill{
            id         = 600419
			,name      = language:get(<<"20多人群降攻击">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600420) ->
    #skill{
            id         = 600420
			,name      = language:get(<<"女巫法琳娜">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600421) ->
    #skill{
            id         = 600421
			,name      = language:get(<<"女巫法琳娜">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600422) ->
    #skill{
            id         = 600422
			,name      = language:get(<<"炎角恶魔攻降防御">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600423) ->
    #skill{
            id         = 600423
			,name      = language:get(<<"普攻2连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600424) ->
    #skill{
            id         = 600424
			,name      = language:get(<<"普攻3连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600425) ->
    #skill{
            id         = 600425
			,name      = language:get(<<"加血">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600426) ->
    #skill{
            id         = 600426
			,name      = language:get(<<"守护石领兵加坚韧">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600427) ->
    #skill{
            id         = 600427
			,name      = language:get(<<"普攻5连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600428) ->
    #skill{
            id         = 600428
			,name      = language:get(<<"群眩晕">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600429) ->
    #skill{
            id         = 600429
			,name      = language:get(<<"普攻2连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600430) ->
    #skill{
            id         = 600430
			,name      = language:get(<<"连锁爆炸">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600431) ->
    #skill{
            id         = 600431
			,name      = language:get(<<"普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600432) ->
    #skill{
            id         = 600432
			,name      = language:get(<<"毒蝎首领召唤">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600433) ->
    #skill{
            id         = 600433
			,name      = language:get(<<"加血">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600434) ->
    #skill{
            id         = 600434
			,name      = language:get(<<"群攻加眩晕">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600435) ->
    #skill{
            id         = 600435
			,name      = language:get(<<"群毒">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600436) ->
    #skill{
            id         = 600436
			,name      = language:get(<<"加格挡">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600437) ->
    #skill{
            id         = 600437
			,name      = language:get(<<"普攻2连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600438) ->
    #skill{
            id         = 600438
			,name      = language:get(<<"普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600439) ->
    #skill{
            id         = 600439
			,name      = language:get(<<"小蝎子普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600440) ->
    #skill{
            id         = 600440
			,name      = language:get(<<"树根首领加攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600441) ->
    #skill{
            id         = 600441
			,name      = language:get(<<"睡眠">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600442) ->
    #skill{
            id         = 600442
			,name      = language:get(<<"单攻2连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600443) ->
    #skill{
            id         = 600443
			,name      = language:get(<<"群攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600444) ->
    #skill{
            id         = 600444
			,name      = language:get(<<"单攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600445) ->
    #skill{
            id         = 600445
			,name      = language:get(<<"霍德尔魔影召唤16167">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600446) ->
    #skill{
            id         = 600446
			,name      = language:get(<<"群攻加沉默">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600447) ->
    #skill{
            id         = 600447
			,name      = language:get(<<"群加攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600448) ->
    #skill{
            id         = 600448
			,name      = language:get(<<"普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600449) ->
    #skill{
            id         = 600449
			,name      = language:get(<<"另一个魔影召唤16126">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600450) ->
    #skill{
            id         = 600450
			,name      = language:get(<<"冰雪双头狼冰冻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600451) ->
    #skill{
            id         = 600451
			,name      = language:get(<<"火普攻2连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600452) ->
    #skill{
            id         = 600452
			,name      = language:get(<<"群冰冻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600453) ->
    #skill{
            id         = 600453
			,name      = language:get(<<"群火攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600454) ->
    #skill{
            id         = 600454
			,name      = language:get(<<"普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600455) ->
    #skill{
            id         = 600455
			,name      = language:get(<<"王者巨人加血">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600456) ->
    #skill{
            id         = 600456
			,name      = language:get(<<"普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600457) ->
    #skill{
            id         = 600457
			,name      = language:get(<<"加坚韧">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600458) ->
    #skill{
            id         = 600458
			,name      = language:get(<<"群眩晕">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600459) ->
    #skill{
            id         = 600459
			,name      = language:get(<<"单眩晕">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600460) ->
    #skill{
            id         = 600460
			,name      = language:get(<<"加攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600461) ->
    #skill{
            id         = 600461
			,name      = language:get(<<"普攻3连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600462) ->
    #skill{
            id         = 600462
			,name      = language:get(<<"地牢守卫犬群眩晕">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600463) ->
    #skill{
            id         = 600463
			,name      = language:get(<<"攻击吸血大">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600464) ->
    #skill{
            id         = 600464
			,name      = language:get(<<"加攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600465) ->
    #skill{
            id         = 600465
			,name      = language:get(<<"吸血2连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(600466) ->
    #skill{
            id         = 600466
			,name      = language:get(<<"攻击吸血">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000001) ->
    #skill{
            id         = 1000001
			,name      = language:get(<<"加血样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000002) ->
    #skill{
            id         = 1000002
			,name      = language:get(<<"群加暴击样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000003) ->
    #skill{
            id         = 1000003
			,name      = language:get(<<"加暴击样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000004) ->
    #skill{
            id         = 1000004
			,name      = language:get(<<"降坚韧样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000005) ->
    #skill{
            id         = 1000005
			,name      = language:get(<<"群加攻样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000006) ->
    #skill{
            id         = 1000006
			,name      = language:get(<<"群毒样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000007) ->
    #skill{
            id         = 1000007
			,name      = language:get(<<"沉默样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000008) ->
    #skill{
            id         = 1000008
			,name      = language:get(<<"群攻样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000009) ->
    #skill{
            id         = 1000009
			,name      = language:get(<<"普攻2连样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000010) ->
    #skill{
            id         = 1000010
			,name      = language:get(<<"普攻3连样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000011) ->
    #skill{
            id         = 1000011
			,name      = language:get(<<"降攻样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000012) ->
    #skill{
            id         = 1000012
			,name      = language:get(<<"加格挡样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000013) ->
    #skill{
            id         = 1000013
			,name      = language:get(<<"降命中样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000014) ->
    #skill{
            id         = 1000014
			,name      = language:get(<<"普攻样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000015) ->
    #skill{
            id         = 1000015
			,name      = language:get(<<"加坚韧样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000016) ->
    #skill{
            id         = 1000016
			,name      = language:get(<<"群沉默样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000017) ->
    #skill{
            id         = 1000017
			,name      = language:get(<<"降格挡样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000018) ->
    #skill{
            id         = 1000018
			,name      = language:get(<<"群攻加沉默样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000019) ->
    #skill{
            id         = 1000019
			,name      = language:get(<<"群攻1.2样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000020) ->
    #skill{
            id         = 1000020
			,name      = language:get(<<"单加攻样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000021) ->
    #skill{
            id         = 1000021
			,name      = language:get(<<"单攻加嘲讽样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000022) ->
    #skill{
            id         = 1000022
			,name      = language:get(<<"群攻加中毒样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000023) ->
    #skill{
            id         = 1000023
			,name      = language:get(<<"单攻加中毒样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000024) ->
    #skill{
            id         = 1000024
			,name      = language:get(<<"群毒样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000025) ->
    #skill{
            id         = 1000025
			,name      = language:get(<<"光屏障样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000026) ->
    #skill{
            id         = 1000026
			,name      = language:get(<<"群睡样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000027) ->
    #skill{
            id         = 1000027
			,name      = language:get(<<"召唤样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000028) ->
    #skill{
            id         = 1000028
			,name      = language:get(<<"群攻加减攻样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000029) ->
    #skill{
            id         = 1000029
			,name      = language:get(<<"群攻加睡眠样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000030) ->
    #skill{
            id         = 1000030
			,name      = language:get(<<"嘲讽样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000031) ->
    #skill{
            id         = 1000031
			,name      = language:get(<<"吸血样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000032) ->
    #skill{
            id         = 1000032
			,name      = language:get(<<"单毒样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000033) ->
    #skill{
            id         = 1000033
			,name      = language:get(<<"加免伤样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000034) ->
    #skill{
            id         = 1000034
			,name      = language:get(<<"群攻加嘲讽样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000035) ->
    #skill{
            id         = 1000035
			,name      = language:get(<<"嘲讽样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(1000036) ->
    #skill{
            id         = 1000036
			,name      = language:get(<<"降防御样本">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601000) ->
    #skill{
            id         = 601000
			,name      = language:get(<<"安娜普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601001) ->
    #skill{
            id         = 601001
			,name      = language:get(<<"艾薇拉普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601002) ->
    #skill{
            id         = 601002
			,name      = language:get(<<"精灵雷尔夫普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601003) ->
    #skill{
            id         = 601003
			,name      = language:get(<<"龙骑士普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601004) ->
    #skill{
            id         = 601004
			,name      = language:get(<<"草系近程普攻1">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601005) ->
    #skill{
            id         = 601005
			,name      = language:get(<<"草系近程普攻2">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601006) ->
    #skill{
            id         = 601006
			,name      = language:get(<<"草系近程普攻大">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601007) ->
    #skill{
            id         = 601007
			,name      = language:get(<<"草系远程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601008) ->
    #skill{
            id         = 601008
			,name      = language:get(<<"熊爪近程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601009) ->
    #skill{
            id         = 601009
			,name      = language:get(<<"紫色近程普攻1">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601010) ->
    #skill{
            id         = 601010
			,name      = language:get(<<"紫色近程普攻2">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601011) ->
    #skill{
            id         = 601011
			,name      = language:get(<<"紫色近程普攻3">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601012) ->
    #skill{
            id         = 601012
			,name      = language:get(<<"紫色近程普攻4">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601013) ->
    #skill{
            id         = 601013
			,name      = language:get(<<"紫色远程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601014) ->
    #skill{
            id         = 601014
			,name      = language:get(<<"金色近程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601015) ->
    #skill{
            id         = 601015
			,name      = language:get(<<"金色近程普攻2">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601016) ->
    #skill{
            id         = 601016
			,name      = language:get(<<"金色远程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601017) ->
    #skill{
            id         = 601017
			,name      = language:get(<<"金色近程普攻3">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601018) ->
    #skill{
            id         = 601018
			,name      = language:get(<<"金色刀光近程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601019) ->
    #skill{
            id         = 601019
			,name      = language:get(<<"金色地裂普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601020) ->
    #skill{
            id         = 601020
			,name      = language:get(<<"蓝色远程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601021) ->
    #skill{
            id         = 601021
			,name      = language:get(<<"紫色闪电球普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601022) ->
    #skill{
            id         = 601022
			,name      = language:get(<<"蓝色近程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601023) ->
    #skill{
            id         = 601023
			,name      = language:get(<<"红色近程普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601024) ->
    #skill{
            id         = 601024
			,name      = language:get(<<"红色近程普攻2">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601025) ->
    #skill{
            id         = 601025
			,name      = language:get(<<"蓝色近程普攻2">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601026) ->
    #skill{
            id         = 601026
			,name      = language:get(<<"蓝色近程普攻3">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601027) ->
    #skill{
            id         = 601027
			,name      = language:get(<<"召唤黄金草刺球">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601028) ->
    #skill{
            id         = 601028
			,name      = language:get(<<"召唤黄金南瓜怪">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601029) ->
    #skill{
            id         = 601029
			,name      = language:get(<<"新手牛普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601030) ->
    #skill{
            id         = 601030
			,name      = language:get(<<"绿革士兵普攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601031) ->
    #skill{
            id         = 601031
			,name      = language:get(<<"女巫群攻">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601032) ->
    #skill{
            id         = 601032
			,name      = language:get(<<"女巫普攻2连">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(601033) ->
    #skill{
            id         = 601033
			,name      = language:get(<<"女巫群睡">>)
            ,id_type   = 10
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706160) ->
    #skill{
            id         = 706160
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 61
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706170) ->
    #skill{
            id         = 706170
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 61
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706180) ->
    #skill{
            id         = 706180
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 61
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706190) ->
    #skill{
            id         = 706190
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 61
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706200) ->
    #skill{
            id         = 706200
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706210) ->
    #skill{
            id         = 706210
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706220) ->
    #skill{
            id         = 706220
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706230) ->
    #skill{
            id         = 706230
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706240) ->
    #skill{
            id         = 706240
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706250) ->
    #skill{
            id         = 706250
			,name      = language:get(<<"蟹海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706260) ->
    #skill{
            id         = 706260
			,name      = language:get(<<"维京海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706270) ->
    #skill{
            id         = 706270
			,name      = language:get(<<"维京海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706280) ->
    #skill{
            id         = 706280
			,name      = language:get(<<"维京海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706290) ->
    #skill{
            id         = 706290
			,name      = language:get(<<"维京海盗">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706300) ->
    #skill{
            id         = 706300
			,name      = language:get(<<"维京海盗">>)
            ,id_type   = 63
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706310) ->
    #skill{
            id         = 706310
			,name      = language:get(<<"维京海盗">>)
            ,id_type   = 63
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706320) ->
    #skill{
            id         = 706320
			,name      = language:get(<<"维京海盗">>)
            ,id_type   = 63
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706330) ->
    #skill{
            id         = 706330
			,name      = language:get(<<"维京海盗">>)
            ,id_type   = 63
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707050) ->
    #skill{
            id         = 707050
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 70
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707060) ->
    #skill{
            id         = 707060
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 70
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707070) ->
    #skill{
            id         = 707070
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 70
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707080) ->
    #skill{
            id         = 707080
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 70
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707090) ->
    #skill{
            id         = 707090
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 70
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707100) ->
    #skill{
            id         = 707100
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 71
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707110) ->
    #skill{
            id         = 707110
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 71
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707120) ->
    #skill{
            id         = 707120
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 71
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707130) ->
    #skill{
            id         = 707130
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 71
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707140) ->
    #skill{
            id         = 707140
			,name      = language:get(<<"女海盗">>)
            ,id_type   = 71
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706420) ->
    #skill{
            id         = 706420
			,name      = language:get(<<"鼠海盗">>)
            ,id_type   = 64
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706430) ->
    #skill{
            id         = 706430
			,name      = language:get(<<"鼠海盗">>)
            ,id_type   = 64
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706440) ->
    #skill{
            id         = 706440
			,name      = language:get(<<"鼠海盗">>)
            ,id_type   = 64
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706450) ->
    #skill{
            id         = 706450
			,name      = language:get(<<"鼠海盗">>)
            ,id_type   = 64
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706460) ->
    #skill{
            id         = 706460
			,name      = language:get(<<"鼠海盗">>)
            ,id_type   = 64
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706470) ->
    #skill{
            id         = 706470
			,name      = language:get(<<"鼠海盗">>)
            ,id_type   = 64
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706480) ->
    #skill{
            id         = 706480
			,name      = language:get(<<"鼠海盗">>)
            ,id_type   = 64
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706490) ->
    #skill{
            id         = 706490
			,name      = language:get(<<"鼠海盗">>)
            ,id_type   = 64
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706580) ->
    #skill{
            id         = 706580
			,name      = language:get(<<"章鱼海盗">>)
            ,id_type   = 65
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706590) ->
    #skill{
            id         = 706590
			,name      = language:get(<<"章鱼海盗">>)
            ,id_type   = 65
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706600) ->
    #skill{
            id         = 706600
			,name      = language:get(<<"章鱼海盗">>)
            ,id_type   = 66
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706610) ->
    #skill{
            id         = 706610
			,name      = language:get(<<"章鱼海盗">>)
            ,id_type   = 66
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706620) ->
    #skill{
            id         = 706620
			,name      = language:get(<<"章鱼海盗">>)
            ,id_type   = 66
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706630) ->
    #skill{
            id         = 706630
			,name      = language:get(<<"章鱼海盗">>)
            ,id_type   = 66
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706640) ->
    #skill{
            id         = 706640
			,name      = language:get(<<"章鱼海盗">>)
            ,id_type   = 66
            ,book_id   = 10             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(706650) ->
    #skill{
            id         = 706650
			,name      = language:get(<<"玩家海盗加免疫">>)
            ,id_type   = 66
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707610) ->
    #skill{
            id         = 707610
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707620) ->
    #skill{
            id         = 707620
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707630) ->
    #skill{
            id         = 707630
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707640) ->
    #skill{
            id         = 707640
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707650) ->
    #skill{
            id         = 707650
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707660) ->
    #skill{
            id         = 707660
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707670) ->
    #skill{
            id         = 707670
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707680) ->
    #skill{
            id         = 707680
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707690) ->
    #skill{
            id         = 707690
			,name      = language:get(<<"石之守护之神">>)
            ,id_type   = 76
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707820) ->
    #skill{
            id         = 707820
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 78
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707830) ->
    #skill{
            id         = 707830
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 78
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707840) ->
    #skill{
            id         = 707840
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 78
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707850) ->
    #skill{
            id         = 707850
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 78
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707860) ->
    #skill{
            id         = 707860
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 78
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707870) ->
    #skill{
            id         = 707870
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 78
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707880) ->
    #skill{
            id         = 707880
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 78
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707890) ->
    #skill{
            id         = 707890
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 78
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707900) ->
    #skill{
            id         = 707900
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707910) ->
    #skill{
            id         = 707910
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707920) ->
    #skill{
            id         = 707920
			,name      = language:get(<<"破晓守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707930) ->
    #skill{
            id         = 707930
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707940) ->
    #skill{
            id         = 707940
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707950) ->
    #skill{
            id         = 707950
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707960) ->
    #skill{
            id         = 707960
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707970) ->
    #skill{
            id         = 707970
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707980) ->
    #skill{
            id         = 707980
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(707990) ->
    #skill{
            id         = 707990
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 79
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708000) ->
    #skill{
            id         = 708000
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708010) ->
    #skill{
            id         = 708010
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708020) ->
    #skill{
            id         = 708020
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708030) ->
    #skill{
            id         = 708030
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708040) ->
    #skill{
            id         = 708040
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708050) ->
    #skill{
            id         = 708050
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708060) ->
    #skill{
            id         = 708060
			,name      = language:get(<<"光守护之神">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708070) ->
    #skill{
            id         = 708070
			,name      = language:get(<<"光守护之神随从">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708080) ->
    #skill{
            id         = 708080
			,name      = language:get(<<"光守护之神随从">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708090) ->
    #skill{
            id         = 708090
			,name      = language:get(<<"光守护之神随从">>)
            ,id_type   = 80
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708100) ->
    #skill{
            id         = 708100
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708110) ->
    #skill{
            id         = 708110
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708120) ->
    #skill{
            id         = 708120
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708130) ->
    #skill{
            id         = 708130
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708140) ->
    #skill{
            id         = 708140
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708150) ->
    #skill{
            id         = 708150
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708160) ->
    #skill{
            id         = 708160
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708170) ->
    #skill{
            id         = 708170
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708180) ->
    #skill{
            id         = 708180
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708190) ->
    #skill{
            id         = 708190
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(708200) ->
    #skill{
            id         = 708200
			,name      = language:get(<<"殿守护之神">>)
            ,id_type   = 82
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800000) ->
    #skill{
            id         = 800000
			,name      = <<>>
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800001) ->
    #skill{
            id         = 800001
			,name      = language:get(<<"湮灭">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800002) ->
    #skill{
            id         = 800002
			,name      = language:get(<<"野蛮冲撞">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800003) ->
    #skill{
            id         = 800003
			,name      = language:get(<<"诅咒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800004) ->
    #skill{
            id         = 800004
			,name      = language:get(<<"挫志怒吼">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800005) ->
    #skill{
            id         = 800005
			,name      = language:get(<<"暴怒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800006) ->
    #skill{
            id         = 800006
			,name      = language:get(<<"鬼祭">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800007) ->
    #skill{
            id         = 800007
			,name      = language:get(<<"碾压">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800008) ->
    #skill{
            id         = 800008
			,name      = language:get(<<"突袭">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800009) ->
    #skill{
            id         = 800009
			,name      = language:get(<<"缠绕">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800010) ->
    #skill{
            id         = 800010
			,name      = language:get(<<"嘶吼">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800011) ->
    #skill{
            id         = 800011
			,name      = language:get(<<"暗言术">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800012) ->
    #skill{
            id         = 800012
			,name      = language:get(<<"黑色捶打">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800013) ->
    #skill{
            id         = 800013
			,name      = language:get(<<"心灵尖啸">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800014) ->
    #skill{
            id         = 800014
			,name      = language:get(<<"钻心">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800015) ->
    #skill{
            id         = 800015
			,name      = language:get(<<"狂暴">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800016) ->
    #skill{
            id         = 800016
			,name      = language:get(<<"落叶斩">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800017) ->
    #skill{
            id         = 800017
			,name      = language:get(<<"精确打击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800018) ->
    #skill{
            id         = 800018
			,name      = language:get(<<"斩杀">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800019) ->
    #skill{
            id         = 800019
			,name      = language:get(<<"疯狂涌入">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800020) ->
    #skill{
            id         = 800020
			,name      = language:get(<<"遗言">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800021) ->
    #skill{
            id         = 800021
			,name      = language:get(<<"迅捷一击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800022) ->
    #skill{
            id         = 800022
			,name      = language:get(<<"蛮力一击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800023) ->
    #skill{
            id         = 800023
			,name      = language:get(<<"闪烁突袭">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800024) ->
    #skill{
            id         = 800024
			,name      = language:get(<<"踩踏">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800025) ->
    #skill{
            id         = 800025
			,name      = language:get(<<"上勾拳">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800026) ->
    #skill{
            id         = 800026
			,name      = language:get(<<"暗杀">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800027) ->
    #skill{
            id         = 800027
			,name      = language:get(<<"圣击术">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800028) ->
    #skill{
            id         = 800028
			,name      = language:get(<<"审判">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800029) ->
    #skill{
            id         = 800029
			,name      = language:get(<<"自然之助">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800030) ->
    #skill{
            id         = 800030
			,name      = language:get(<<"火球术">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800031) ->
    #skill{
            id         = 800031
			,name      = language:get(<<"顶撞">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800032) ->
    #skill{
            id         = 800032
			,name      = language:get(<<"怒火攻心">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800033) ->
    #skill{
            id         = 800033
			,name      = language:get(<<"重击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800034) ->
    #skill{
            id         = 800034
			,name      = language:get(<<"怒吼">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800035) ->
    #skill{
            id         = 800035
			,name      = language:get(<<"猛击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800036) ->
    #skill{
            id         = 800036
			,name      = language:get(<<"寂静">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800037) ->
    #skill{
            id         = 800037
			,name      = language:get(<<"皓月精华">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800038) ->
    #skill{
            id         = 800038
			,name      = language:get(<<"黎明之息">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800039) ->
    #skill{
            id         = 800039
			,name      = language:get(<<"献祭">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800040) ->
    #skill{
            id         = 800040
			,name      = language:get(<<"梦境">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800041) ->
    #skill{
            id         = 800041
			,name      = language:get(<<"复仇">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800042) ->
    #skill{
            id         = 800042
			,name      = language:get(<<"波浪形态">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800043) ->
    #skill{
            id         = 800043
			,name      = language:get(<<"火炎击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800044) ->
    #skill{
            id         = 800044
			,name      = language:get(<<"沉默">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800045) ->
    #skill{
            id         = 800045
			,name      = language:get(<<"灵动一击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800046) ->
    #skill{
            id         = 800046
			,name      = language:get(<<"魅惑">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800047) ->
    #skill{
            id         = 800047
			,name      = language:get(<<"所有近程妖精的普通攻击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800048) ->
    #skill{
            id         = 800048
			,name      = language:get(<<"所有远程妖精的普通攻击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800049) ->
    #skill{
            id         = 800049
			,name      = language:get(<<"雷神普通攻击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800050) ->
    #skill{
            id         = 800050
			,name      = language:get(<<"精灵王普通攻击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800051) ->
    #skill{
            id         = 800051
			,name      = language:get(<<"美人鱼普通攻击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(800052) ->
    #skill{
            id         = 800052
			,name      = language:get(<<"小红帽普通攻击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(801101) ->
    #skill{
            id         = 801101
			,name      = language:get(<<"低级湮灭">>)
            ,id_type   = 11
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(801201) ->
    #skill{
            id         = 801201
			,name      = language:get(<<"中级湮灭">>)
            ,id_type   = 12
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(801301) ->
    #skill{
            id         = 801301
			,name      = language:get(<<"高级湮灭">>)
            ,id_type   = 13
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(802101) ->
    #skill{
            id         = 802101
			,name      = language:get(<<"低级冲撞">>)
            ,id_type   = 21
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(802201) ->
    #skill{
            id         = 802201
			,name      = language:get(<<"中级冲撞">>)
            ,id_type   = 22
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(802301) ->
    #skill{
            id         = 802301
			,name      = language:get(<<"高级冲撞">>)
            ,id_type   = 23
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(803101) ->
    #skill{
            id         = 803101
			,name      = language:get(<<"低级诅咒">>)
            ,id_type   = 31
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(803201) ->
    #skill{
            id         = 803201
			,name      = language:get(<<"中级诅咒">>)
            ,id_type   = 32
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(803301) ->
    #skill{
            id         = 803301
			,name      = language:get(<<"高级诅咒">>)
            ,id_type   = 33
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(804101) ->
    #skill{
            id         = 804101
			,name      = language:get(<<"低级怒吼">>)
            ,id_type   = 41
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(804201) ->
    #skill{
            id         = 804201
			,name      = language:get(<<"中级怒吼">>)
            ,id_type   = 42
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(804301) ->
    #skill{
            id         = 804301
			,name      = language:get(<<"高级怒吼">>)
            ,id_type   = 43
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(805101) ->
    #skill{
            id         = 805101
			,name      = language:get(<<"低级鬼祭">>)
            ,id_type   = 51
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(805201) ->
    #skill{
            id         = 805201
			,name      = language:get(<<"中级鬼祭">>)
            ,id_type   = 52
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(805301) ->
    #skill{
            id         = 805301
			,name      = language:get(<<"高级鬼祭">>)
            ,id_type   = 53
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(806101) ->
    #skill{
            id         = 806101
			,name      = language:get(<<"低级碾压">>)
            ,id_type   = 61
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(806201) ->
    #skill{
            id         = 806201
			,name      = language:get(<<"中级碾压">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(806301) ->
    #skill{
            id         = 806301
			,name      = language:get(<<"高级碾压">>)
            ,id_type   = 63
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(807101) ->
    #skill{
            id         = 807101
			,name      = language:get(<<"低级突袭">>)
            ,id_type   = 71
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(807201) ->
    #skill{
            id         = 807201
			,name      = language:get(<<"中级突袭">>)
            ,id_type   = 72
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(807301) ->
    #skill{
            id         = 807301
			,name      = language:get(<<"高级突袭">>)
            ,id_type   = 73
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(808101) ->
    #skill{
            id         = 808101
			,name      = language:get(<<"低级缠绕">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(808201) ->
    #skill{
            id         = 808201
			,name      = language:get(<<"中级缠绕">>)
            ,id_type   = 82
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(808301) ->
    #skill{
            id         = 808301
			,name      = language:get(<<"高级缠绕">>)
            ,id_type   = 83
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(809101) ->
    #skill{
            id         = 809101
			,name      = language:get(<<"低级嘶吼">>)
            ,id_type   = 91
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(809201) ->
    #skill{
            id         = 809201
			,name      = language:get(<<"中级嘶吼">>)
            ,id_type   = 92
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(809301) ->
    #skill{
            id         = 809301
			,name      = language:get(<<"高级嘶吼">>)
            ,id_type   = 93
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(810101) ->
    #skill{
            id         = 810101
			,name      = language:get(<<"低级暗言术">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(810201) ->
    #skill{
            id         = 810201
			,name      = language:get(<<"中级暗言术">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(810301) ->
    #skill{
            id         = 810301
			,name      = language:get(<<"高级暗言术">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(811101) ->
    #skill{
            id         = 811101
			,name      = language:get(<<"低级捶打">>)
            ,id_type   = 11
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(811201) ->
    #skill{
            id         = 811201
			,name      = language:get(<<"中级捶打">>)
            ,id_type   = 12
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(811301) ->
    #skill{
            id         = 811301
			,name      = language:get(<<"高级捶打">>)
            ,id_type   = 13
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(812101) ->
    #skill{
            id         = 812101
			,name      = language:get(<<"低级尖啸">>)
            ,id_type   = 21
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(812201) ->
    #skill{
            id         = 812201
			,name      = language:get(<<"中级尖啸">>)
            ,id_type   = 22
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(812301) ->
    #skill{
            id         = 812301
			,name      = language:get(<<"高级尖啸">>)
            ,id_type   = 23
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(813101) ->
    #skill{
            id         = 813101
			,name      = language:get(<<"低级审判">>)
            ,id_type   = 31
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(813201) ->
    #skill{
            id         = 813201
			,name      = language:get(<<"中级审判">>)
            ,id_type   = 32
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(813301) ->
    #skill{
            id         = 813301
			,name      = language:get(<<"高级审判">>)
            ,id_type   = 33
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(814101) ->
    #skill{
            id         = 814101
			,name      = language:get(<<"低级怒火">>)
            ,id_type   = 41
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(814201) ->
    #skill{
            id         = 814201
			,name      = language:get(<<"中级怒火">>)
            ,id_type   = 42
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(814301) ->
    #skill{
            id         = 814301
			,name      = language:get(<<"高级怒火">>)
            ,id_type   = 43
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(815101) ->
    #skill{
            id         = 815101
			,name      = language:get(<<"低级净化">>)
            ,id_type   = 51
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(815201) ->
    #skill{
            id         = 815201
			,name      = language:get(<<"中级净化">>)
            ,id_type   = 52
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(815301) ->
    #skill{
            id         = 815301
			,name      = language:get(<<"高级净化">>)
            ,id_type   = 53
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(816101) ->
    #skill{
            id         = 816101
			,name      = language:get(<<"低级黎明之息">>)
            ,id_type   = 61
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(816201) ->
    #skill{
            id         = 816201
			,name      = language:get(<<"中级黎明之息">>)
            ,id_type   = 62
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(816301) ->
    #skill{
            id         = 816301
			,name      = language:get(<<"高级黎明之息">>)
            ,id_type   = 63
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(817101) ->
    #skill{
            id         = 817101
			,name      = language:get(<<"低级波浪形态">>)
            ,id_type   = 71
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(817201) ->
    #skill{
            id         = 817201
			,name      = language:get(<<"中级波浪形态">>)
            ,id_type   = 72
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(817301) ->
    #skill{
            id         = 817301
			,name      = language:get(<<"高级波浪形态">>)
            ,id_type   = 73
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(818101) ->
    #skill{
            id         = 818101
			,name      = language:get(<<"低级钻心">>)
            ,id_type   = 81
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(818201) ->
    #skill{
            id         = 818201
			,name      = language:get(<<"中级钻心">>)
            ,id_type   = 82
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(818301) ->
    #skill{
            id         = 818301
			,name      = language:get(<<"高级钻心">>)
            ,id_type   = 83
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(819101) ->
    #skill{
            id         = 819101
			,name      = language:get(<<"低级狂暴">>)
            ,id_type   = 91
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(819201) ->
    #skill{
            id         = 819201
			,name      = language:get(<<"中级狂暴">>)
            ,id_type   = 92
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(819301) ->
    #skill{
            id         = 819301
			,name      = language:get(<<"高级狂暴">>)
            ,id_type   = 93
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(820101) ->
    #skill{
            id         = 820101
			,name      = language:get(<<"低级准星">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(820201) ->
    #skill{
            id         = 820201
			,name      = language:get(<<"中级准星">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(820301) ->
    #skill{
            id         = 820301
			,name      = language:get(<<"高级准星">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(821101) ->
    #skill{
            id         = 821101
			,name      = language:get(<<"低级闪烁">>)
            ,id_type   = 11
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(821201) ->
    #skill{
            id         = 821201
			,name      = language:get(<<"中级闪烁">>)
            ,id_type   = 12
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(821301) ->
    #skill{
            id         = 821301
			,name      = language:get(<<"高级闪烁">>)
            ,id_type   = 13
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 0             
            ,cond_lev  = 0
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(822101) ->
    #skill{
            id         = 822101
			,name      = language:get(<<"低级追击">>)
            ,id_type   = 21
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(822201) ->
    #skill{
            id         = 822201
			,name      = language:get(<<"中级追击">>)
            ,id_type   = 22
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(822301) ->
    #skill{
            id         = 822301
			,name      = language:get(<<"高级追击">>)
            ,id_type   = 23
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(823101) ->
    #skill{
            id         = 823101
			,name      = language:get(<<"低级祈福">>)
            ,id_type   = 31
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(823201) ->
    #skill{
            id         = 823201
			,name      = language:get(<<"中级祈福">>)
            ,id_type   = 32
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(823301) ->
    #skill{
            id         = 823301
			,name      = language:get(<<"高级祈福">>)
            ,id_type   = 33
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(824101) ->
    #skill{
            id         = 824101
			,name      = language:get(<<"低级祷告">>)
            ,id_type   = 41
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(824201) ->
    #skill{
            id         = 824201
			,name      = language:get(<<"中级祷告">>)
            ,id_type   = 42
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(824301) ->
    #skill{
            id         = 824301
			,name      = language:get(<<"高级祷告">>)
            ,id_type   = 43
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(825101) ->
    #skill{
            id         = 825101
			,name      = language:get(<<"低级天使附身">>)
            ,id_type   = 51
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(825201) ->
    #skill{
            id         = 825201
			,name      = language:get(<<"中级天使附身">>)
            ,id_type   = 52
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(825301) ->
    #skill{
            id         = 825301
			,name      = language:get(<<"高级天使附身">>)
            ,id_type   = 53
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835005) ->
    #skill{
            id         = 835005
			,name      = language:get(<<"32级召唤随从1">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835006) ->
    #skill{
            id         = 835006
			,name      = language:get(<<"召唤随从2">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835007) ->
    #skill{
            id         = 835007
			,name      = language:get(<<"召唤随从3">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835018) ->
    #skill{
            id         = 835018
			,name      = language:get(<<"随从补血">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835019) ->
    #skill{
            id         = 835019
			,name      = language:get(<<"33级攻击带吸蓝$1.5">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835020) ->
    #skill{
            id         = 835020
			,name      = language:get(<<"树根首领群吸$3">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835021) ->
    #skill{
            id         = 835021
			,name      = language:get(<<"树根首领吸蓝2连$3">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835022) ->
    #skill{
            id         = 835022
			,name      = language:get(<<"树根首领套盾$3">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835023) ->
    #skill{
            id         = 835023
			,name      = language:get(<<"随从群沉默$2">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835024) ->
    #skill{
            id         = 835024
			,name      = language:get(<<"普攻">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835025) ->
    #skill{
            id         = 835025
			,name      = language:get(<<"随从2连$2">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835043) ->
    #skill{
            id         = 835043
			,name      = language:get(<<"37级毒素爆发">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835046) ->
    #skill{
            id         = 835046
			,name      = language:get(<<"38级屏障">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835047) ->
    #skill{
            id         = 835047
			,name      = language:get(<<"嘲讽">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835048) ->
    #skill{
            id         = 835048
			,name      = language:get(<<"普攻">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835026) ->
    #skill{
            id         = 835026
			,name      = language:get(<<"34级没血自奶">>)
            ,id_type   = 50
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835250) ->
    #skill{
            id         = 835250
			,name      = language:get(<<"43级复活A">>)
            ,id_type   = 52
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835251) ->
    #skill{
            id         = 835251
			,name      = language:get(<<"复活a">>)
            ,id_type   = 52
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835257) ->
    #skill{
            id         = 835257
			,name      = language:get(<<"自损">>)
            ,id_type   = 52
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835258) ->
    #skill{
            id         = 835258
			,name      = language:get(<<"治疗">>)
            ,id_type   = 52
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835550) ->
    #skill{
            id         = 835550
			,name      = language:get(<<"44级虚弱">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835551) ->
    #skill{
            id         = 835551
			,name      = language:get(<<"中毒">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835552) ->
    #skill{
            id         = 835552
			,name      = language:get(<<"沉默">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835553) ->
    #skill{
            id         = 835553
			,name      = language:get(<<"治疗">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835554) ->
    #skill{
            id         = 835554
			,name      = language:get(<<"低血加攻">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835555) ->
    #skill{
            id         = 835555
			,name      = language:get(<<"反伤">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835556) ->
    #skill{
            id         = 835556
			,name      = language:get(<<"普攻">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835557) ->
    #skill{
            id         = 835557
			,name      = language:get(<<"主动加攻">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835500) ->
    #skill{
            id         = 835500
			,name      = language:get(<<"48级召唤冰原狼1">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835501) ->
    #skill{
            id         = 835501
			,name      = language:get(<<"召唤冰原狼2">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835502) ->
    #skill{
            id         = 835502
			,name      = language:get(<<"加攻">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835503) ->
    #skill{
            id         = 835503
			,name      = language:get(<<"加超暴击">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835504) ->
    #skill{
            id         = 835504
			,name      = language:get(<<"加嗜血">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835505) ->
    #skill{
            id         = 835505
			,name      = language:get(<<"召唤铁甲巨兔1">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835506) ->
    #skill{
            id         = 835506
			,name      = language:get(<<"召唤铁甲巨兔2">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835507) ->
    #skill{
            id         = 835507
			,name      = language:get(<<"反伤">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835508) ->
    #skill{
            id         = 835508
			,name      = language:get(<<"治疗">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835509) ->
    #skill{
            id         = 835509
			,name      = language:get(<<"屏障">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835510) ->
    #skill{
            id         = 835510
			,name      = language:get(<<"暴怒一击">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835511) ->
    #skill{
            id         = 835511
			,name      = language:get(<<"2连">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835512) ->
    #skill{
            id         = 835512
			,name      = language:get(<<"3连击">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835513) ->
    #skill{
            id         = 835513
			,name      = language:get(<<"普攻">>)
            ,id_type   = 55
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835600) ->
    #skill{
            id         = 835600
			,name      = language:get(<<"49级普攻">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835601) ->
    #skill{
            id         = 835601
			,name      = language:get(<<"连击">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835602) ->
    #skill{
            id         = 835602
			,name      = language:get(<<"概率反伤">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835603) ->
    #skill{
            id         = 835603
			,name      = language:get(<<"概率嗜血">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835604) ->
    #skill{
            id         = 835604
			,name      = language:get(<<"概率躲闪">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835605) ->
    #skill{
            id         = 835605
			,name      = language:get(<<"生命燃烧">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835606) ->
    #skill{
            id         = 835606
			,name      = language:get(<<"3连击">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835650) ->
    #skill{
            id         = 835650
			,name      = language:get(<<"51级普攻">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835651) ->
    #skill{
            id         = 835651
			,name      = language:get(<<"骨牢">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835652) ->
    #skill{
            id         = 835652
			,name      = language:get(<<"骨刺">>)
            ,id_type   = 56
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835700) ->
    #skill{
            id         = 835700
			,name      = language:get(<<"52级普攻">>)
            ,id_type   = 57
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835701) ->
    #skill{
            id         = 835701
			,name      = language:get(<<"践踏">>)
            ,id_type   = 57
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835702) ->
    #skill{
            id         = 835702
			,name      = language:get(<<"冲锋">>)
            ,id_type   = 57
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835750) ->
    #skill{
            id         = 835750
			,name      = language:get(<<"53级普攻">>)
            ,id_type   = 57
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835751) ->
    #skill{
            id         = 835751
			,name      = language:get(<<"反击风暴">>)
            ,id_type   = 57
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835752) ->
    #skill{
            id         = 835752
			,name      = language:get(<<"鲁莽">>)
            ,id_type   = 57
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835800) ->
    #skill{
            id         = 835800
			,name      = language:get(<<"54级普攻">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835801) ->
    #skill{
            id         = 835801
			,name      = language:get(<<"远程普攻">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835802) ->
    #skill{
            id         = 835802
			,name      = language:get(<<"标记">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835803) ->
    #skill{
            id         = 835803
			,name      = language:get(<<"爆头">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835804) ->
    #skill{
            id         = 835804
			,name      = language:get(<<"万箭齐发">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835805) ->
    #skill{
            id         = 835805
			,name      = language:get(<<"秒杀">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835850) ->
    #skill{
            id         = 835850
			,name      = language:get(<<"55级普攻">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835851) ->
    #skill{
            id         = 835851
			,name      = language:get(<<"摇摇乐">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835852) ->
    #skill{
            id         = 835852
			,name      = language:get(<<"正常·不稳定魔导弹">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835853) ->
    #skill{
            id         = 835853
			,name      = language:get(<<"自爆·不稳定魔导弹">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835854) ->
    #skill{
            id         = 835854
			,name      = language:get(<<"封印">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835855) ->
    #skill{
            id         = 835855
			,name      = language:get(<<"生命虹吸">>)
            ,id_type   = 58
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835900) ->
    #skill{
            id         = 835900
			,name      = language:get(<<"56级普攻">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835901) ->
    #skill{
            id         = 835901
			,name      = language:get(<<"束音成箭">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835902) ->
    #skill{
            id         = 835902
			,name      = language:get(<<"致盲·束音成箭">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835903) ->
    #skill{
            id         = 835903
			,name      = language:get(<<"音波攻击">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835904) ->
    #skill{
            id         = 835904
			,name      = language:get(<<"致盲·音波攻击">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835905) ->
    #skill{
            id         = 835905
			,name      = language:get(<<"致盲">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835906) ->
    #skill{
            id         = 835906
			,name      = language:get(<<"鼓舞">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835950) ->
    #skill{
            id         = 835950
			,name      = language:get(<<"57级普攻">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835951) ->
    #skill{
            id         = 835951
			,name      = language:get(<<"召唤1">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(835952) ->
    #skill{
            id         = 835952
			,name      = language:get(<<"召唤2">>)
            ,id_type   = 59
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830001) ->
    #skill{
            id         = 830001
			,name      = language:get(<<"普通单体攻击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830002) ->
    #skill{
            id         = 830002
			,name      = language:get(<<"2连击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830003) ->
    #skill{
            id         = 830003
			,name      = language:get(<<"3连击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830004) ->
    #skill{
            id         = 830004
			,name      = language:get(<<"治疗">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830005) ->
    #skill{
            id         = 830005
			,name      = language:get(<<"32级召唤随从1">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830006) ->
    #skill{
            id         = 830006
			,name      = language:get(<<"召唤随从2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830007) ->
    #skill{
            id         = 830007
			,name      = language:get(<<"召唤随从3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830014) ->
    #skill{
            id         = 830014
			,name      = language:get(<<"主怪aoe">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830015) ->
    #skill{
            id         = 830015
			,name      = language:get(<<"主怪减命中">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830016) ->
    #skill{
            id         = 830016
			,name      = language:get(<<"随从普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830017) ->
    #skill{
            id         = 830017
			,name      = language:get(<<"随从群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830018) ->
    #skill{
            id         = 830018
			,name      = language:get(<<"随从补血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830019) ->
    #skill{
            id         = 830019
			,name      = language:get(<<"33级攻击带吸蓝$1.5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830020) ->
    #skill{
            id         = 830020
			,name      = language:get(<<"树根首领群吸$3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830021) ->
    #skill{
            id         = 830021
			,name      = language:get(<<"树根首领吸蓝2连$3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830022) ->
    #skill{
            id         = 830022
			,name      = language:get(<<"树根首领套盾$3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830023) ->
    #skill{
            id         = 830023
			,name      = language:get(<<"随从群沉默$2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830024) ->
    #skill{
            id         = 830024
			,name      = language:get(<<"普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830025) ->
    #skill{
            id         = 830025
			,name      = language:get(<<"随从2连$2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830026) ->
    #skill{
            id         = 830026
			,name      = language:get(<<"34级没血自奶">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830027) ->
    #skill{
            id         = 830027
			,name      = language:get(<<"单体攻击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830028) ->
    #skill{
            id         = 830028
			,name      = language:get(<<"35级加免伤">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830049) ->
    #skill{
            id         = 830049
			,name      = language:get(<<"加免伤">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830050) ->
    #skill{
            id         = 830050
			,name      = language:get(<<"加免伤">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830051) ->
    #skill{
            id         = 830051
			,name      = language:get(<<"加免伤">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830029) ->
    #skill{
            id         = 830029
			,name      = language:get(<<"35级boss普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830030) ->
    #skill{
            id         = 830030
			,name      = language:get(<<"35级boss连击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830031) ->
    #skill{
            id         = 830031
			,name      = language:get(<<"35级boss群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830032) ->
    #skill{
            id         = 830032
			,name      = language:get(<<"36级求饶加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830033) ->
    #skill{
            id         = 830033
			,name      = language:get(<<"求饶怪普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830034) ->
    #skill{
            id         = 830034
			,name      = language:get(<<"求饶怪逃跑">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830035) ->
    #skill{
            id         = 830035
			,name      = language:get(<<"随从怪普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830036) ->
    #skill{
            id         = 830036
			,name      = language:get(<<"随从怪4连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830037) ->
    #skill{
            id         = 830037
			,name      = language:get(<<"随从怪群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830038) ->
    #skill{
            id         = 830038
			,name      = language:get(<<"求饶嗜血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830039) ->
    #skill{
            id         = 830039
			,name      = language:get(<<"求饶超暴击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830040) ->
    #skill{
            id         = 830040
			,name      = language:get(<<"求饶圣光守护">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830041) ->
    #skill{
            id         = 830041
			,name      = language:get(<<"37级主怪群毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830042) ->
    #skill{
            id         = 830042
			,name      = language:get(<<"毒液加深">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830043) ->
    #skill{
            id         = 830043
			,name      = language:get(<<"毒素爆发">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830044) ->
    #skill{
            id         = 830044
			,name      = language:get(<<"攻击带吸血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830045) ->
    #skill{
            id         = 830045
			,name      = language:get(<<"普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830046) ->
    #skill{
            id         = 830046
			,name      = language:get(<<"38级屏障">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830047) ->
    #skill{
            id         = 830047
			,name      = language:get(<<"嘲讽">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830048) ->
    #skill{
            id         = 830048
			,name      = language:get(<<"普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830100) ->
    #skill{
            id         = 830100
			,name      = language:get(<<"39级暗影之源">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830101) ->
    #skill{
            id         = 830101
			,name      = language:get(<<"暗灭连斩">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830102) ->
    #skill{
            id         = 830102
			,name      = language:get(<<"梦魇挣扎">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830103) ->
    #skill{
            id         = 830103
			,name      = language:get(<<"灵魂汲取">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830104) ->
    #skill{
            id         = 830104
			,name      = language:get(<<"普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830150) ->
    #skill{
            id         = 830150
			,name      = language:get(<<"41级随从减格挡">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830151) ->
    #skill{
            id         = 830151
			,name      = language:get(<<"普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830152) ->
    #skill{
            id         = 830152
			,name      = language:get(<<"连击">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830153) ->
    #skill{
            id         = 830153
			,name      = language:get(<<"随从加攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830154) ->
    #skill{
            id         = 830154
			,name      = language:get(<<"aoe">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830200) ->
    #skill{
            id         = 830200
			,name      = language:get(<<"42级防御下降">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830201) ->
    #skill{
            id         = 830201
			,name      = language:get(<<"伤害加深">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830202) ->
    #skill{
            id         = 830202
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830203) ->
    #skill{
            id         = 830203
			,name      = language:get(<<"连击">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830204) ->
    #skill{
            id         = 830204
			,name      = language:get(<<"aoe">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830250) ->
    #skill{
            id         = 830250
			,name      = language:get(<<"43级复活A">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830251) ->
    #skill{
            id         = 830251
			,name      = language:get(<<"复活a">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830252) ->
    #skill{
            id         = 830252
			,name      = language:get(<<"复活B">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830253) ->
    #skill{
            id         = 830253
			,name      = language:get(<<"复活b">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830254) ->
    #skill{
            id         = 830254
			,name      = language:get(<<"复活C">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830255) ->
    #skill{
            id         = 830255
			,name      = language:get(<<"复活c">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830256) ->
    #skill{
            id         = 830256
			,name      = language:get(<<"睡眠">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830257) ->
    #skill{
            id         = 830257
			,name      = language:get(<<"自损">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830258) ->
    #skill{
            id         = 830258
			,name      = language:get(<<"治疗">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830259) ->
    #skill{
            id         = 830259
			,name      = language:get(<<"aoe">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830260) ->
    #skill{
            id         = 830260
			,name      = language:get(<<"连锁闪电">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830261) ->
    #skill{
            id         = 830261
			,name      = language:get(<<"连击">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830262) ->
    #skill{
            id         = 830262
			,name      = language:get(<<"普攻">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830263) ->
    #skill{
            id         = 830263
			,name      = language:get(<<"群加暴击">>)
            ,id_type   = 2
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830350) ->
    #skill{
            id         = 830350
			,name      = language:get(<<"45级洞悉先机$1.5">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830351) ->
    #skill{
            id         = 830351
			,name      = language:get(<<"静默之爪$4">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830352) ->
    #skill{
            id         = 830352
			,name      = language:get(<<"连锁闪电$4">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830353) ->
    #skill{
            id         = 830353
			,name      = language:get(<<"普攻">>)
            ,id_type   = 3
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830400) ->
    #skill{
            id         = 830400
			,name      = language:get(<<"46级aoe">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830401) ->
    #skill{
            id         = 830401
			,name      = language:get(<<"4连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830402) ->
    #skill{
            id         = 830402
			,name      = language:get(<<"连锁闪电$4">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830403) ->
    #skill{
            id         = 830403
			,name      = language:get(<<"普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830450) ->
    #skill{
            id         = 830450
			,name      = language:get(<<"47级求饶加攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830451) ->
    #skill{
            id         = 830451
			,name      = language:get(<<"求饶怪普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830452) ->
    #skill{
            id         = 830452
			,name      = language:get(<<"求饶怪逃跑">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830453) ->
    #skill{
            id         = 830453
			,name      = language:get(<<"随从怪普攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830454) ->
    #skill{
            id         = 830454
			,name      = language:get(<<"随从怪4连">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830455) ->
    #skill{
            id         = 830455
			,name      = language:get(<<"随从怪群攻">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830456) ->
    #skill{
            id         = 830456
			,name      = language:get(<<"求饶嗜血">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830457) ->
    #skill{
            id         = 830457
			,name      = language:get(<<"求饶超暴击">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830458) ->
    #skill{
            id         = 830458
			,name      = language:get(<<"求饶圣光守护">>)
            ,id_type   = 4
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830500) ->
    #skill{
            id         = 830500
			,name      = language:get(<<"48级召唤冰原狼1">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830501) ->
    #skill{
            id         = 830501
			,name      = language:get(<<"召唤冰原狼2">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830502) ->
    #skill{
            id         = 830502
			,name      = language:get(<<"加攻">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830503) ->
    #skill{
            id         = 830503
			,name      = language:get(<<"加超暴击">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830504) ->
    #skill{
            id         = 830504
			,name      = language:get(<<"加嗜血">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830505) ->
    #skill{
            id         = 830505
			,name      = language:get(<<"召唤铁甲巨兔1">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830506) ->
    #skill{
            id         = 830506
			,name      = language:get(<<"召唤铁甲巨兔2">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830507) ->
    #skill{
            id         = 830507
			,name      = language:get(<<"反伤">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830508) ->
    #skill{
            id         = 830508
			,name      = language:get(<<"治疗">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830509) ->
    #skill{
            id         = 830509
			,name      = language:get(<<"屏障">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830510) ->
    #skill{
            id         = 830510
			,name      = language:get(<<"暴怒一击">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830511) ->
    #skill{
            id         = 830511
			,name      = language:get(<<"2连">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830512) ->
    #skill{
            id         = 830512
			,name      = language:get(<<"3连击">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830513) ->
    #skill{
            id         = 830513
			,name      = language:get(<<"普攻">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830550) ->
    #skill{
            id         = 830550
			,name      = language:get(<<"44级虚弱">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830551) ->
    #skill{
            id         = 830551
			,name      = language:get(<<"中毒">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830552) ->
    #skill{
            id         = 830552
			,name      = language:get(<<"沉默">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830553) ->
    #skill{
            id         = 830553
			,name      = language:get(<<"治疗">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830554) ->
    #skill{
            id         = 830554
			,name      = language:get(<<"低血加攻">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830555) ->
    #skill{
            id         = 830555
			,name      = language:get(<<"反伤">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830556) ->
    #skill{
            id         = 830556
			,name      = language:get(<<"普攻">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830557) ->
    #skill{
            id         = 830557
			,name      = language:get(<<"主动加攻">>)
            ,id_type   = 5
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830600) ->
    #skill{
            id         = 830600
			,name      = language:get(<<"49级普攻">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830601) ->
    #skill{
            id         = 830601
			,name      = language:get(<<"连击">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830602) ->
    #skill{
            id         = 830602
			,name      = language:get(<<"概率反伤">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830603) ->
    #skill{
            id         = 830603
			,name      = language:get(<<"概率嗜血">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830604) ->
    #skill{
            id         = 830604
			,name      = language:get(<<"概率躲闪">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830605) ->
    #skill{
            id         = 830605
			,name      = language:get(<<"生命燃烧">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830606) ->
    #skill{
            id         = 830606
			,name      = language:get(<<"3连击">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830650) ->
    #skill{
            id         = 830650
			,name      = language:get(<<"51级普攻">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830651) ->
    #skill{
            id         = 830651
			,name      = language:get(<<"骨牢">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830652) ->
    #skill{
            id         = 830652
			,name      = language:get(<<"骨刺">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830653) ->
    #skill{
            id         = 830653
			,name      = language:get(<<"毒刺">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830654) ->
    #skill{
            id         = 830654
			,name      = language:get(<<"混合毒液">>)
            ,id_type   = 6
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830700) ->
    #skill{
            id         = 830700
			,name      = language:get(<<"52级普攻">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830701) ->
    #skill{
            id         = 830701
			,name      = language:get(<<"践踏">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830702) ->
    #skill{
            id         = 830702
			,name      = language:get(<<"冲锋">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830703) ->
    #skill{
            id         = 830703
			,name      = language:get(<<"睡眠">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830750) ->
    #skill{
            id         = 830750
			,name      = language:get(<<"53级普攻">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830751) ->
    #skill{
            id         = 830751
			,name      = language:get(<<"反击风暴">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830752) ->
    #skill{
            id         = 830752
			,name      = language:get(<<"鲁莽">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830753) ->
    #skill{
            id         = 830753
			,name      = language:get(<<"治疗">>)
            ,id_type   = 7
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830800) ->
    #skill{
            id         = 830800
			,name      = language:get(<<"54级普攻">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830801) ->
    #skill{
            id         = 830801
			,name      = language:get(<<"远程普攻">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830802) ->
    #skill{
            id         = 830802
			,name      = language:get(<<"标记">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830803) ->
    #skill{
            id         = 830803
			,name      = language:get(<<"爆头">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830804) ->
    #skill{
            id         = 830804
			,name      = language:get(<<"万箭齐发">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830805) ->
    #skill{
            id         = 830805
			,name      = language:get(<<"秒杀">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830806) ->
    #skill{
            id         = 830806
			,name      = language:get(<<"加深伤害">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830850) ->
    #skill{
            id         = 830850
			,name      = language:get(<<"55级普攻">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830851) ->
    #skill{
            id         = 830851
			,name      = language:get(<<"摇摇乐">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830852) ->
    #skill{
            id         = 830852
			,name      = language:get(<<"正常·不稳定魔导弹">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830853) ->
    #skill{
            id         = 830853
			,name      = language:get(<<"自爆·不稳定魔导弹">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830854) ->
    #skill{
            id         = 830854
			,name      = language:get(<<"封印">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830855) ->
    #skill{
            id         = 830855
			,name      = language:get(<<"生命虹吸">>)
            ,id_type   = 8
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830900) ->
    #skill{
            id         = 830900
			,name      = language:get(<<"56级普攻">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830901) ->
    #skill{
            id         = 830901
			,name      = language:get(<<"束音成箭">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830902) ->
    #skill{
            id         = 830902
			,name      = language:get(<<"致盲·束音成箭">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830903) ->
    #skill{
            id         = 830903
			,name      = language:get(<<"音波攻击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830904) ->
    #skill{
            id         = 830904
			,name      = language:get(<<"致盲·音波攻击">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830905) ->
    #skill{
            id         = 830905
			,name      = language:get(<<"致盲">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830906) ->
    #skill{
            id         = 830906
			,name      = language:get(<<"鼓舞">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830950) ->
    #skill{
            id         = 830950
			,name      = language:get(<<"57级普攻">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830951) ->
    #skill{
            id         = 830951
			,name      = language:get(<<"召唤1">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(830952) ->
    #skill{
            id         = 830952
			,name      = language:get(<<"召唤2">>)
            ,id_type   = 9
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840001) ->
    #skill{
            id         = 840001
			,name      = language:get(<<"亡灵骑士反击姿态">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840002) ->
    #skill{
            id         = 840002
			,name      = language:get(<<"亡灵骑士单体嘲讽">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840003) ->
    #skill{
            id         = 840003
			,name      = language:get(<<"亡灵骑士大地震裂">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840004) ->
    #skill{
            id         = 840004
			,name      = language:get(<<"亡灵骑士巨刃击溃">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840005) ->
    #skill{
            id         = 840005
			,name      = language:get(<<"亡灵系不灭意志">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840006) ->
    #skill{
            id         = 840006
			,name      = language:get(<<"亡灵骑士普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840011) ->
    #skill{
            id         = 840011
			,name      = language:get(<<"亡灵法师混沌火球">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840012) ->
    #skill{
            id         = 840012
			,name      = language:get(<<"亡灵法师群体睡眠">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840013) ->
    #skill{
            id         = 840013
			,name      = language:get(<<"亡灵法师荆棘缠绕">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840014) ->
    #skill{
            id         = 840014
			,name      = language:get(<<"亡灵法师普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840021) ->
    #skill{
            id         = 840021
			,name      = language:get(<<"亡灵弓箭手连射">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840022) ->
    #skill{
            id         = 840022
			,name      = language:get(<<"亡灵弓箭手攻其不备">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840023) ->
    #skill{
            id         = 840023
			,name      = language:get(<<"亡灵弓箭手攻其不备（对方睡眠）">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840024) ->
    #skill{
            id         = 840024
			,name      = language:get(<<"亡灵弓箭手毒箭">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840025) ->
    #skill{
            id         = 840025
			,name      = language:get(<<"亡灵弓箭手普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840031) ->
    #skill{
            id         = 840031
			,name      = language:get(<<"双锤汉克吸血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840032) ->
    #skill{
            id         = 840032
			,name      = language:get(<<"双锤汉克晕眩">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840033) ->
    #skill{
            id         = 840033
			,name      = language:get(<<"狂暴系越战越勇1">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840034) ->
    #skill{
            id         = 840034
			,name      = language:get(<<"狂暴系越战越勇2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840035) ->
    #skill{
            id         = 840035
			,name      = language:get(<<"狂暴系越战越勇3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840036) ->
    #skill{
            id         = 840036
			,name      = language:get(<<"狂暴系越战越勇4">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840037) ->
    #skill{
            id         = 840037
			,name      = language:get(<<"狂暴系越战越勇5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840038) ->
    #skill{
            id         = 840038
			,name      = language:get(<<"狂暴系普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840041) ->
    #skill{
            id         = 840041
			,name      = language:get(<<"巨斧穆恩活血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840042) ->
    #skill{
            id         = 840042
			,name      = language:get(<<"狂暴系趁虚而入">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840043) ->
    #skill{
            id         = 840043
			,name      = language:get(<<"狂暴系趁虚而入（对方晕眩）">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840044) ->
    #skill{
            id         = 840044
			,name      = language:get(<<"狂暴系斩杀（<30%血量）">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840045) ->
    #skill{
            id         = 840045
			,name      = language:get(<<"狂暴系斩杀（<20%血量）">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840046) ->
    #skill{
            id         = 840046
			,name      = language:get(<<"狂暴系斩杀（<10%血量）">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840051) ->
    #skill{
            id         = 840051
			,name      = language:get(<<"利斧凯奇斧头格挡1">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840052) ->
    #skill{
            id         = 840052
			,name      = language:get(<<"利斧凯奇斧头格挡2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840053) ->
    #skill{
            id         = 840053
			,name      = language:get(<<"利斧凯奇斧头格挡3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840054) ->
    #skill{
            id         = 840054
			,name      = language:get(<<"利斧凯奇斧头格挡4">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840055) ->
    #skill{
            id         = 840055
			,name      = language:get(<<"利斧凯奇斧头格挡5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840061) ->
    #skill{
            id         = 840061
			,name      = language:get(<<"冰铠巨猿冰之铠甲">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840062) ->
    #skill{
            id         = 840062
			,name      = language:get(<<"冰铠巨猿冰铠硬化">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840063) ->
    #skill{
            id         = 840063
			,name      = language:get(<<"冰铠巨猿群体加防">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840064) ->
    #skill{
            id         = 840064
			,name      = language:get(<<"冰铠巨猿刺骨寒风1">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840067) ->
    #skill{
            id         = 840067
			,name      = language:get(<<"冰铠巨猿刺骨寒风2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840068) ->
    #skill{
            id         = 840068
			,name      = language:get(<<"冰铠巨猿刺骨寒风3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840069) ->
    #skill{
            id         = 840069
			,name      = language:get(<<"冰铠巨猿刺骨寒风4">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840070) ->
    #skill{
            id         = 840070
			,name      = language:get(<<"冰铠巨猿刺骨寒风5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840065) ->
    #skill{
            id         = 840065
			,name      = language:get(<<"冰铠巨猿群体嘲讽">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840066) ->
    #skill{
            id         = 840066
			,name      = language:get(<<"冰系近战普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840071) ->
    #skill{
            id         = 840071
			,name      = language:get(<<"冰锋狮子疯狂">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840072) ->
    #skill{
            id         = 840072
			,name      = language:get(<<"冰锋狮子零度爪击1">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840077) ->
    #skill{
            id         = 840077
			,name      = language:get(<<"冰锋狮子零度爪击2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840078) ->
    #skill{
            id         = 840078
			,name      = language:get(<<"冰锋狮子零度爪击3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840079) ->
    #skill{
            id         = 840079
			,name      = language:get(<<"冰锋狮子零度爪击4">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840080) ->
    #skill{
            id         = 840080
			,name      = language:get(<<"冰锋狮子零度爪击5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840073) ->
    #skill{
            id         = 840073
			,name      = language:get(<<"冰锋狮子狂暴">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 0                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840074) ->
    #skill{
            id         = 840074
			,name      = language:get(<<"冰锋狮子破冰">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840075) ->
    #skill{
            id         = 840075
			,name      = language:get(<<"冰锋狮子破冰（对方冻伤）">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840076) ->
    #skill{
            id         = 840076
			,name      = language:get(<<"冰系识别buff">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840081) ->
    #skill{
            id         = 840081
			,name      = language:get(<<"冰雪女王凜风1">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840086) ->
    #skill{
            id         = 840086
			,name      = language:get(<<"冰雪女王凜风2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840087) ->
    #skill{
            id         = 840087
			,name      = language:get(<<"冰雪女王凜风3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840088) ->
    #skill{
            id         = 840088
			,name      = language:get(<<"冰雪女王凜风4">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840089) ->
    #skill{
            id         = 840089
			,name      = language:get(<<"冰雪女王凜风5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840047) ->
    #skill{
            id         = 840047
			,name      = language:get(<<"冰雪女王冰封（敌）1">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840048) ->
    #skill{
            id         = 840048
			,name      = language:get(<<"冰雪女王冰封（敌）2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840049) ->
    #skill{
            id         = 840049
			,name      = language:get(<<"冰雪女王冰封（敌）3">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840050) ->
    #skill{
            id         = 840050
			,name      = language:get(<<"冰雪女王冰封（敌）4">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840082) ->
    #skill{
            id         = 840082
			,name      = language:get(<<"冰雪女王冰封（敌）5">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840083) ->
    #skill{
            id         = 840083
			,name      = language:get(<<"冰雪女王冰封（友）">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840084) ->
    #skill{
            id         = 840084
			,name      = language:get(<<"冰雪女王群体驱散">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840085) ->
    #skill{
            id         = 840085
			,name      = language:get(<<"冰系远程普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840091) ->
    #skill{
            id         = 840091
			,name      = language:get(<<"赤尾剧毒尾钉">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840092) ->
    #skill{
            id         = 840092
			,name      = language:get(<<"赤尾毒血沸腾">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840093) ->
    #skill{
            id         = 840093
			,name      = language:get(<<"赤尾麻痹毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840094) ->
    #skill{
            id         = 840094
			,name      = language:get(<<"赤尾毒性引爆">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840095) ->
    #skill{
            id         = 840095
			,name      = language:get(<<"赤尾毒性引爆（对方中毒）">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840096) ->
    #skill{
            id         = 840096
			,name      = language:get(<<"毒系近战普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840097) ->
    #skill{
            id         = 840097
			,name      = language:get(<<"毒系毒免疫">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840101) ->
    #skill{
            id         = 840101
			,name      = language:get(<<"腐化树根再生">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840102) ->
    #skill{
            id         = 840102
			,name      = language:get(<<"腐化树根毒雾">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840103) ->
    #skill{
            id         = 840103
			,name      = language:get(<<"腐化树根生命之力">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840104) ->
    #skill{
            id         = 840104
			,name      = language:get(<<"腐化树根群体净化">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840105) ->
    #skill{
            id         = 840105
			,name      = language:get(<<"腐化树根群体驱散">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840106) ->
    #skill{
            id         = 840106
			,name      = language:get(<<"毒系远程普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840111) ->
    #skill{
            id         = 840111
			,name      = language:get(<<"缝合怪毒败躯体">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840112) ->
    #skill{
            id         = 840112
			,name      = language:get(<<"缝合怪感染">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840113) ->
    #skill{
            id         = 840113
			,name      = language:get(<<"缝合怪疯狂">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840114) ->
    #skill{
            id         = 840114
			,name      = language:get(<<"缝合怪自爆">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840121) ->
    #skill{
            id         = 840121
			,name      = language:get(<<"欺诈者横扫">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840122) ->
    #skill{
            id         = 840122
			,name      = language:get(<<"欺诈者生命流失">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840123) ->
    #skill{
            id         = 840123
			,name      = language:get(<<"恶魔系落井下石">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840124) ->
    #skill{
            id         = 840124
			,name      = language:get(<<"恶魔系落井下石（对方被嘲讽）">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840131) ->
    #skill{
            id         = 840131
			,name      = language:get(<<"粉碎者裂颅一击">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840132) ->
    #skill{
            id         = 840132
			,name      = language:get(<<"粉碎者屏障粉碎">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840141) ->
    #skill{
            id         = 840141
			,name      = language:get(<<"吞噬者群体嘲讽">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840142) ->
    #skill{
            id         = 840142
			,name      = language:get(<<"吞噬者群体晕眩">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840143) ->
    #skill{
            id         = 840143
			,name      = language:get(<<"吞噬者加暴击">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840144) ->
    #skill{
            id         = 840144
			,name      = language:get(<<"吞噬者吞噬">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840145) ->
    #skill{
            id         = 840145
			,name      = language:get(<<"吞噬者二连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840146) ->
    #skill{
            id         = 840146
			,name      = language:get(<<"吞噬者三连">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(840147) ->
    #skill{
            id         = 840147
			,name      = language:get(<<"恶魔系普攻">>)
            ,id_type   = 1
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930001) ->
    #skill{
            id         = 930001
			,name      = language:get(<<"蓝焰恶魔沉默">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930002) ->
    #skill{
            id         = 930002
			,name      = language:get(<<"蓝焰恶魔降防">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930003) ->
    #skill{
            id         = 930003
			,name      = language:get(<<"群加暴击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930004) ->
    #skill{
            id         = 930004
			,name      = language:get(<<"群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930005) ->
    #skill{
            id         = 930005
			,name      = language:get(<<"群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930006) ->
    #skill{
            id         = 930006
			,name      = language:get(<<"群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930007) ->
    #skill{
            id         = 930007
			,name      = language:get(<<"群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930008) ->
    #skill{
            id         = 930008
			,name      = language:get(<<"群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930009) ->
    #skill{
            id         = 930009
			,name      = language:get(<<"群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930010) ->
    #skill{
            id         = 930010
			,name      = language:get(<<"群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930011) ->
    #skill{
            id         = 930011
			,name      = language:get(<<"光屏障">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930012) ->
    #skill{
            id         = 930012
			,name      = language:get(<<"攻击带吸蓝">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930013) ->
    #skill{
            id         = 930013
			,name      = language:get(<<"降坚韧">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930014) ->
    #skill{
            id         = 930014
			,name      = language:get(<<"加血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930015) ->
    #skill{
            id         = 930015
			,name      = language:get(<<"召唤">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930016) ->
    #skill{
            id         = 930016
			,name      = language:get(<<"加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930021) ->
    #skill{
            id         = 930021
			,name      = language:get(<<"主怪群毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930022) ->
    #skill{
            id         = 930022
			,name      = language:get(<<"毒液加深">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930023) ->
    #skill{
            id         = 930023
			,name      = language:get(<<"凝聚毒素">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930024) ->
    #skill{
            id         = 930024
			,name      = language:get(<<"吸取毒血">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930025) ->
    #skill{
            id         = 930025
			,name      = language:get(<<"普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930031) ->
    #skill{
            id         = 930031
			,name      = language:get(<<"霍德尔群沉默毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930032) ->
    #skill{
            id         = 930032
			,name      = language:get(<<"霍德尔群毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930033) ->
    #skill{
            id         = 930033
			,name      = language:get(<<"霍德尔加暴击">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930034) ->
    #skill{
            id         = 930034
			,name      = language:get(<<"霍德尔群攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930035) ->
    #skill{
            id         = 930035
			,name      = language:get(<<"霍德尔嘲讽">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930036) ->
    #skill{
            id         = 930036
			,name      = language:get(<<"霍德尔加攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930037) ->
    #skill{
            id         = 930037
			,name      = language:get(<<"霍德尔普攻3连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930038) ->
    #skill{
            id         = 930038
			,name      = language:get(<<"霍德尔群攻1.2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930039) ->
    #skill{
            id         = 930039
			,name      = language:get(<<"霍德尔普攻4连">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930040) ->
    #skill{
            id         = 930040
			,name      = language:get(<<"霍德尔群沉默">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930041) ->
    #skill{
            id         = 930041
			,name      = language:get(<<"霍德尔加攻2">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 2                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930042) ->
    #skill{
            id         = 930042
			,name      = language:get(<<"霍德尔群毒">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930043) ->
    #skill{
            id         = 930043
			,name      = language:get(<<"霍德尔普攻">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(930044) ->
    #skill{
            id         = 930044
			,name      = language:get(<<"霍德尔沉默1.8">>)
            ,id_type   = 0
            ,book_id   = 0             
            ,next_id   = 0             
            ,type      = 1                                    
            ,lev       = 1             
            ,cond_lev  = 1
			,cond_skilled = 0
            ,cost_item = 0             
            ,cost_coin = 0             
            ,cost_att  = 0                         
            ,item_id = 0 
            ,attr = []                                                       
        };
get(_) ->
    {error, false_skill}.
