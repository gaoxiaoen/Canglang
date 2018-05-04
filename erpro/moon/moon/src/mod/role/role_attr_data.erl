%% -----------------------
%% 角色基本属性
%% @autor wpf
%%------------------------

-module(role_attr_data).
-export([
        get_attr_base/1
        ,get_attr_grow/1
        ,get_attr_cvt/1
    ]).

-include("attr.hrl").
%% 真武
get_attr_base(1) ->
    #attr_base{        
        js = 20
        ,hp_max = 75
        ,mp_max = 58
        ,dmg_max = 30
        ,dmg_min = 30
        ,aspd = 30
        ,defence = 60
        ,critrate = 10
        ,evasion = 0
        ,hitrate = 10
        ,resist_metal = 0
        ,resist_wood = 0
        ,resist_water = 0
        ,resist_fire = 0
        ,resist_earth = 0
        ,anti_stun = 0
        ,anti_poison = 0
        ,anti_sleep = 0
        ,anti_stone = 0
        ,anti_taunt = 0
    };
    
%% 魅影
get_attr_base(2) ->
    #attr_base{        
        js = 20
        ,hp_max = 75
        ,mp_max = 58
        ,dmg_max = 30
        ,dmg_min = 30
        ,aspd = 30
        ,defence = 60
        ,critrate = 10
        ,evasion = 0
        ,hitrate = 10
        ,resist_metal = 0
        ,resist_wood = 0
        ,resist_water = 0
        ,resist_fire = 0
        ,resist_earth = 0
        ,anti_stun = 0
        ,anti_poison = 0
        ,anti_sleep = 0
        ,anti_stone = 0
        ,anti_taunt = 0
    };
    
%% 天师
get_attr_base(3) ->
    #attr_base{        
        js = 20
        ,hp_max = 75
        ,mp_max = 58
        ,dmg_max = 30
        ,dmg_min = 30
        ,aspd = 30
        ,defence = 60
        ,critrate = 10
        ,evasion = 0
        ,hitrate = 10
        ,resist_metal = 0
        ,resist_wood = 0
        ,resist_water = 0
        ,resist_fire = 0
        ,resist_earth = 0
        ,anti_stun = 0
        ,anti_poison = 0
        ,anti_sleep = 0
        ,anti_stone = 0
        ,anti_taunt = 0
    };
    
%% 飞羽
get_attr_base(4) ->
    #attr_base{        
        js = 20
        ,hp_max = 75
        ,mp_max = 58
        ,dmg_max = 30
        ,dmg_min = 30
        ,aspd = 30
        ,defence = 60
        ,critrate = 10
        ,evasion = 0
        ,hitrate = 10
        ,resist_metal = 0
        ,resist_wood = 0
        ,resist_water = 0
        ,resist_fire = 0
        ,resist_earth = 0
        ,anti_stun = 0
        ,anti_poison = 0
        ,anti_sleep = 0
        ,anti_stone = 0
        ,anti_taunt = 0
    };
    
%% 天尊
get_attr_base(5) ->
    #attr_base{        
        js = 20
        ,hp_max = 75
        ,mp_max = 58
        ,dmg_max = 30
        ,dmg_min = 30
        ,aspd = 30
        ,defence = 60
        ,critrate = 10
        ,evasion = 0
        ,hitrate = 10
        ,resist_metal = 0
        ,resist_wood = 0
        ,resist_water = 0
        ,resist_fire = 0
        ,resist_earth = 0
        ,anti_stun = 0
        ,anti_poison = 0
        ,anti_sleep = 0
        ,anti_stone = 0
        ,anti_taunt = 0
    };
    
%% 新手
get_attr_base(6) ->
    #attr_base{        
        js = 20
        ,hp_max = 75
        ,mp_max = 58
        ,dmg_max = 30
        ,dmg_min = 30
        ,aspd = 30
        ,defence = 60
        ,critrate = 10
        ,evasion = 0
        ,hitrate = 10
        ,resist_metal = 0
        ,resist_wood = 0
        ,resist_water = 0
        ,resist_fire = 0
        ,resist_earth = 0
        ,anti_stun = 0
        ,anti_poison = 0
        ,anti_sleep = 0
        ,anti_stone = 0
        ,anti_taunt = 0
    };
    
get_attr_base(_R) ->
    #attr_base{}.

%% 真武
get_attr_grow(1) ->
    #attr_grow{        
        js = 1.5
        ,hp_max = 30
        ,mp_max = 8
        ,dmg = 6
        ,defence = 9
        ,critrate = 1
        ,evasion = 0
        ,hitrate = 1
		,resist_all = 3
    };
%% 魅影
get_attr_grow(2) ->
    #attr_grow{        
        js = 1.5
        ,hp_max = 30
        ,mp_max = 8
        ,dmg = 6
        ,defence = 9
        ,critrate = 1
        ,evasion = 0
        ,hitrate = 1
		,resist_all = 3
    };
%% 天师
get_attr_grow(3) ->
    #attr_grow{        
        js = 1.5
        ,hp_max = 30
        ,mp_max = 8
        ,dmg = 6
        ,defence = 9
        ,critrate = 1
        ,evasion = 0
        ,hitrate = 1
		,resist_all = 3
    };
%% 飞羽
get_attr_grow(4) ->
    #attr_grow{        
        js = 1.5
        ,hp_max = 30
        ,mp_max = 8
        ,dmg = 6
        ,defence = 9
        ,critrate = 1
        ,evasion = 0
        ,hitrate = 1
		,resist_all = 3
    };
%% 天尊
get_attr_grow(5) ->
    #attr_grow{        
        js = 1.5
        ,hp_max = 30
        ,mp_max = 8
        ,dmg = 6
        ,defence = 9
        ,critrate = 1
        ,evasion = 0
        ,hitrate = 1
		,resist_all = 3
    };
%% 新手
get_attr_grow(6) ->
    #attr_grow{        
        js = 1.5
        ,hp_max = 30
        ,mp_max = 8
        ,dmg = 6
        ,defence = 9
        ,critrate = 1
        ,evasion = 0
        ,hitrate = 1
		,resist_all = 3
    };
get_attr_grow(_) ->
    undefined.

%% 精神转法力系数
get_attr_cvt(1) ->
    #attr_convert{        
        js_mp = 2
    };
get_attr_cvt(2) ->
    #attr_convert{        
        js_mp = 2
    };
get_attr_cvt(3) ->
    #attr_convert{        
        js_mp = 2
    };
get_attr_cvt(4) ->
    #attr_convert{        
        js_mp = 2
    };
get_attr_cvt(5) ->
    #attr_convert{        
        js_mp = 2
    };
get_attr_cvt(_) ->
    undefined.
