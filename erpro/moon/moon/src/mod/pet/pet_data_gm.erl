%%----------------------------------------------------
%% 宠物GM数据
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(pet_data_gm).
-export([
        get/2
    ]
).

-include("pet.hrl").

%% 宠物GM列表

get(Pet = #pet{attr = Attr}, 1) ->
    Pet#pet{
        lev = 9
        ,grow_val = 20
        ,attr = Attr#pet_attr{
            xl_val = 25
            ,tz_val = 25
            ,js_val = 25
            ,lq_val = 25
        }
        ,attr_sys = {pet_attr_sys,25,25,25,25}
        ,skill = [{110101, 0}, {180101, 0}]
        ,eqm = []
    };


get(Pet = #pet{attr = Attr}, 2) ->
    Pet#pet{
        lev = 11
        ,grow_val = 20
        ,attr = Attr#pet_attr{
            xl_val = 40
            ,tz_val = 40
            ,js_val = 40
            ,lq_val = 40
        }
        ,attr_sys = {pet_attr_sys,30,30,20,20}
        ,skill = [{110201, 0}, {180102, 0}]
        ,eqm = []
    };


get(Pet = #pet{attr = Attr}, 3) ->
    Pet#pet{
        lev = 13
        ,grow_val = 20
        ,attr = Attr#pet_attr{
            xl_val = 100
            ,tz_val = 100
            ,js_val = 100
            ,lq_val = 100
        }
        ,attr_sys = {pet_attr_sys,35,35,15,15}
        ,skill = [{110301, 0}, {180301, 0}, {150301, 0}, {117301, 0}]
        ,eqm = []
    };


get(Pet = #pet{attr = Attr}, 4) ->
    Pet#pet{
        lev = 49
        ,grow_val = 200
        ,attr = Attr#pet_attr{
            xl_val = 200
            ,tz_val = 200
            ,js_val = 200
            ,lq_val = 200
        }
        ,attr_sys = {pet_attr_sys,40,40,0,20}
        ,skill = [{110305,0},{117306,0},{130305,0},{121305,0},{150306,0},{112305,0}]
        ,eqm = [{50055,10,[{attr_pet_hp,10,6680},{attr_pet_hp,10,6680},{attr_pet_dmg_magic,10,286},{attr_pet_resist_metal,10,1527},{attr_pet_skill_id,10,117000}]},{50055,10,[{attr_pet_hp,10,6680},{attr_pet_hp,10,6680},{attr_pet_dmg_magic,10,286},{attr_pet_resist_wood,10,1527},{attr_pet_skill_id,10,117000}]},{50057,10,[{attr_pet_hp,10,6680},{attr_pet_hp,10,6680},{attr_pet_dmg_magic,10,286},{attr_pet_resist_fire,10,1527},{attr_pet_skill_id,10,110000}]},{50057,10,[{attr_pet_hp,10,6680},{attr_pet_hp,10,6680},{attr_pet_dmg_magic,10,286},{attr_pet_resist_water,10,1527},{attr_pet_skill_id,10,110000}]},{50058,10,[{attr_pet_hp,10,6680},{attr_pet_hp,10,6680},{attr_pet_dmg_magic,10,286},{attr_pet_resist_earth,10,1527},{attr_pet_skill_id,10,130000}]},{50058,10,[{attr_pet_hp,10,6680},{attr_pet_hp,10,6680},{attr_pet_dmg_magic,10,286},{attr_pet_resist_metal,10,1527},{attr_pet_skill_id,10,130000}]}]
    };


get(Pet = #pet{attr = Attr}, 5) ->
    Pet#pet{
        lev = 59
        ,grow_val = 300
        ,attr = Attr#pet_attr{
            xl_val = 250
            ,tz_val = 250
            ,js_val = 250
            ,lq_val = 250
        }
        ,attr_sys = {pet_attr_sys,40,40,0,20}
        ,skill = [{110306,0},{117308,0},{130306,0},{121306,0},{150308,0},{112306,0},{113306,0}]
        ,eqm = [{50055,11,[{attr_pet_hp,10,7856},{attr_pet_hp,10,7856},{attr_pet_dmg_magic,10,337},{attr_pet_resist_metal,10,1796},{attr_pet_skill_id,10,117000}]},{50055,11,[{attr_pet_hp,10,7856},{attr_pet_hp,10,7856},{attr_pet_dmg_magic,10,337},{attr_pet_resist_wood,10,1796},{attr_pet_skill_id,10,117000}]},{50057,11,[{attr_pet_hp,10,7856},{attr_pet_hp,10,7856},{attr_pet_dmg_magic,10,337},{attr_pet_resist_fire,10,1796},{attr_pet_skill_id,10,110000}]},{50057,11,[{attr_pet_hp,10,7856},{attr_pet_hp,10,7856},{attr_pet_dmg_magic,10,337},{attr_pet_resist_water,10,1796},{attr_pet_skill_id,10,110000}]},{50058,11,[{attr_pet_hp,10,7856},{attr_pet_hp,10,7856},{attr_pet_dmg_magic,10,337},{attr_pet_resist_earth,10,1796},{attr_pet_skill_id,10,130000}]},{50058,11,[{attr_pet_hp,10,7856},{attr_pet_hp,10,7856},{attr_pet_dmg_magic,10,337},{attr_pet_resist_metal,10,1796},{attr_pet_skill_id,10,130000}]}]
    };


get(Pet = #pet{attr = Attr}, 6) ->
    Pet#pet{
        lev = 69
        ,grow_val = 400
        ,attr = Attr#pet_attr{
            xl_val = 300
            ,tz_val = 300
            ,js_val = 300
            ,lq_val = 300
        }
        ,attr_sys = {pet_attr_sys,40,40,0,20}
        ,skill = [{110307,0},{117309,0},{130307,0},{121307,0},{150309,0},{112307,0},{113307,0},{111307,0}]
        ,eqm = [{50055,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_metal,10,2087},{attr_pet_skill_id,10,117000}]},{50055,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_wood,10,2087},{attr_pet_skill_id,10,117000}]},{50057,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_fire,10,2087},{attr_pet_skill_id,10,110000}]},{50057,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_water,10,2087},{attr_pet_skill_id,10,110000}]},{50058,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_earth,10,2087},{attr_pet_skill_id,10,130000}]},{50058,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_metal,10,2087},{attr_pet_skill_id,10,130000}]}]
    };


get(Pet = #pet{attr = Attr}, 7) ->
    Pet#pet{
        lev = 79
        ,grow_val = 553
        ,attr = Attr#pet_attr{
            xl_val = 310
            ,tz_val = 310
            ,js_val = 310
            ,lq_val = 310
        }
        ,attr_sys = {pet_attr_sys,40,40,0,20}
        ,skill = [{110308,0},{117310,0},{130308,0},{121308,0},{150310,0},{112308,0},{113308,0},{111308,0}]
        ,eqm = [{50055,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_metal,10,2087},{attr_pet_skill_id,10,117000}]},{50055,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_wood,10,2087},{attr_pet_skill_id,10,117000}]},{50057,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_fire,10,2087},{attr_pet_skill_id,10,110000}]},{50057,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_water,10,2087},{attr_pet_skill_id,10,110000}]},{50058,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_earth,10,2087},{attr_pet_skill_id,10,130000}]},{50058,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_metal,10,2087},{attr_pet_skill_id,10,130000}]}]
    };


get(Pet = #pet{attr = Attr}, 8) ->
    Pet#pet{
        lev = 89
        ,grow_val = 623
        ,attr = Attr#pet_attr{
            xl_val = 320
            ,tz_val = 320
            ,js_val = 320
            ,lq_val = 320
        }
        ,attr_sys = {pet_attr_sys,40,40,0,20}
        ,skill = [{110309,0},{117310,0},{130309,0},{121309,0},{150310,0},{112309,0},{113309,0},{111309,0}]
        ,eqm = [{50055,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_metal,10,2087},{attr_pet_skill_id,10,117000}]},{50055,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_wood,10,2087},{attr_pet_skill_id,10,117000}]},{50057,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_fire,10,2087},{attr_pet_skill_id,10,110000}]},{50057,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_water,10,2087},{attr_pet_skill_id,10,110000}]},{50058,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_earth,10,2087},{attr_pet_skill_id,10,130000}]},{50058,12,[{attr_pet_hp,10,9130},{attr_pet_hp,10,9130},{attr_pet_dmg_magic,10,391},{attr_pet_resist_metal,10,2087},{attr_pet_skill_id,10,130000}]}]
    };

get(_Pet, _Type) -> %% 容错处理
    {false, <<"没有此处理类型">>}.
