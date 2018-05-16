%% 配置生成时间 2018-05-14 17:01:09
-module(data_act_equip_sell).
-export([get/1]).
-export([get_all/0]).
-include("activity.hrl").

get(1) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=1,end_day=3,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=1,
        list=[
            #base_act_equip_sell_sub{id=3 ,page= 1 ,dec = ?T(" 夏日炫装 "),goods_info=  [{6602018, 10}] ,sell_num= 2 ,price= 998,cbp= 20000 ,bind= 0},
            #base_act_equip_sell_sub{id=2 ,page= 1 ,dec = ?T(" 夏日炫装 "),goods_info=  [{4104028, 1}] ,sell_num= 1 ,price= 688,cbp= 13720 ,bind= 0},
            #base_act_equip_sell_sub{id=1 ,page= 1 ,dec = ?T(" 夏日炫装 "),goods_info=  [{6607007, 1}] ,sell_num= 1 ,price= 288,cbp= 6000,bind= 0}
        ],
        act_info=#act_info{}
    };

get(6) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=4,end_day=5,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=6,
        list=[
            #base_act_equip_sell_sub{id=1 ,page= 1 ,dec = ?T(" 隐龙迷踪 "),goods_info= [{6605007,1} ],sell_num= 1,price= 88 ,cbp= 2000,bind= 0},
            #base_act_equip_sell_sub{id=2 ,page= 1 ,dec = ?T(" 隐龙迷踪 "),goods_info= [{ 6607004,1}] ,sell_num= 1,price= 288 ,cbp= 6000 ,bind= 0},
            #base_act_equip_sell_sub{id=3 ,page= 1 ,dec = ?T(" 隐龙迷踪 "),goods_info= [{4104015,1}] ,sell_num= 1,price= 688 ,cbp= 13720,bind= 0}
        ],
        act_info=#act_info{}
    };

get(30) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=8,end_day=9,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=30,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("功夫熊猫"),goods_info= [{6601008,1}],sell_num=1,price=988,cbp=40000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("功夫熊猫"),goods_info= [{8001503,1}],sell_num=1,price=1688,cbp=40000,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("功夫熊猫"),goods_info=[{6607006,1}],sell_num=1,price=488,cbp=10000,bind=0}
        ],
        act_info=#act_info{}
    };

get(31) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [],gs_id=[30999,30098,30097,30031,30029,30028,30027,30024,30022,30020,30018,30017,30016,30015,30013,30012,30009,30007,30006,30005,30004,30003,30002,8003,8001,1001,1505,2002,2001,2650,2649,2648,2647,2646,2645,2644,2643,2642,2641,2640,2639,2638,2637,2636,2635,2634,2633,2631,2628,2626,2625,2619,2614,2613,2605,2603,2596,2593,2589,2585,2583,2578,2575,2570,2566,2544,2542,2540,2536,2533,2519,2501,3012,3011,3010,3009,3008,3007,3006,3551,3550,3549,3548,3547,3546,3545,3542,3539,3538,3534,3526,3521,3513,3501,5025,5023,5021,5019,6012,6010,6008,6006,4006,8542,8541,8540,8539,8538,8537,8536,8535,8534,8533,8531,8530,8529,8527,8523,8522,8521,8507,8505,8501,9004,9003,9002,9001,9505,9504,9503,9502,9501],open_day=12,end_day=13,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=31,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("翼飞冲天"),goods_info=[{8001601,1}],sell_num=1,price=888,cbp=20000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("翼飞冲天"),goods_info=[{3207002,10}],sell_num=1,price=1988,cbp=48800,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("翼飞冲天"),goods_info=[{6605003,1}],sell_num=1,price=288,cbp=6000,bind=0}
        ],
        act_info=#act_info{}
    };

get(36) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=36,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("紫气东来"),goods_info=[{6601006,1}],sell_num=1,price=1880,cbp=40000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("紫气东来"),goods_info=[{3307005,10}],sell_num=1,price=1680,cbp=40000,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("紫气东来"),goods_info=[{6603075,1}],sell_num=1,price=288,cbp=6000,bind=0}
        ],
        act_info=#act_info{}
    };

get(37) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000}],gs_id=[],open_day=1,end_day=3,start_time=0,end_time=0,limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=0},
        act_id=37,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("反季爆款"),goods_info=[{6604043,10}],sell_num=1,price=388,cbp=10000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("反季爆款"),goods_info=[{4104028,1}],sell_num=1,price=688,cbp=13720,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("反季爆款"),goods_info=[{6608007,10}],sell_num=1,price=288,cbp=6000,bind=0}
        ],
        act_info=#act_info{}
    };

get(33) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,16},{00,00,00}},end_time={{2017,10,17},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=15},
        act_id=33,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("星际幻想"),goods_info=[{4104014,1}],sell_num=1,price=888,cbp=13720,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("星际幻想"),goods_info=[{6601014,1}],sell_num=1,price=1688,cbp=38880,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("星际幻想"),goods_info=[{6605019,1}],sell_num=1,price=288,cbp=6000,bind=0}
        ],
        act_info=#act_info{}
    };

get(34) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,10,25},{00,00,00}},end_time={{2017,10,26},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=34,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("甜心女王"),goods_info=[{6601012,1}],sell_num=1,price=3880,cbp=80000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("甜心女王"),goods_info=[{6605011,1}],sell_num=1,price=188,cbp=4000,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("甜心女王"),goods_info=[{4103020,1}],sell_num=1,price=588,cbp=7840,bind=0}
        ],
        act_info=#act_info{}
    };

get(35) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000}],gs_id=[],open_day=0,end_day=0,start_time={{2017,11,01},{00,00,00}},end_time={{2017,11,02},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=16},
        act_id=35,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("狩猎行动"),goods_info=[{6601015,1}],sell_num=1,price=3880,cbp=60000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("狩猎行动"),goods_info=[{4103038,1}],sell_num=1,price=588,cbp=7840,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("狩猎行动"),goods_info=[{3307002,10}],sell_num=1,price=1888,cbp=40000,bind=0}
        ],
        act_info=#act_info{}
    };

get(38) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,11},{00,00,00}},end_time={{2018,05,11},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=30},
        act_id=38,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("超神之旅"),goods_info=[{6601008,1}],sell_num=3,price=4880,cbp=40000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("超神之旅"),goods_info=[{4103021,1}],sell_num=3,price=988,cbp=7840,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("超神之旅"),goods_info=[{6609003,1}],sell_num=3,price=188,cbp=2000,bind=0}
        ],
        act_info=#act_info{}
    };

get(41) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,06,01},{00,00,00}},end_time={{2018,06,01},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=30},
        act_id=41,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("人月团圆"),goods_info=[{6601005,1}],sell_num=3,price=7888,cbp=80000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("人月团圆"),goods_info=[{4103016,1}],sell_num=3,price=988,cbp=7840,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("人月团圆"),goods_info=[{6603069,1}],sell_num=3,price=288,cbp=2000,bind=0}
        ],
        act_info=#act_info{}
    };

get(40) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,25},{00,00,00}},end_time={{2018,05,25},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=30},
        act_id=40,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("福祉盈门"),goods_info=[{6601006,1}],sell_num=3,price=4888,cbp=40000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("福祉盈门"),goods_info=[{4103025,1}],sell_num=3,price=988,cbp=7840,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("福祉盈门"),goods_info=[{6609014,1}],sell_num=3,price=588,cbp=4000,bind=0}
        ],
        act_info=#act_info{}
    };

get(39) ->
    #base_act_equip_sell{
        open_info=#open_info{gp_id = [{0,60000},{30001,50000},{8001,8500},{1001,1500},{1501,2000},{2001,2500},{2501,3000},{50001,60000},{3001,3500},{3501,4000},{5001,5500},{6001,6500},{4001,4500},{8501,9000},{9001,9500},{9501,10000},{10001,10500}],gs_id=[],open_day=0,end_day=0,start_time={{2018,05,18},{00,00,00}},end_time={{2018,05,18},{23,59,59}},limit_open_day=0,limit_end_day=0,merge_st_day=0,merge_et_day=0,merge_times_list=[],ignore_gs=[],priority=0,after_open_day=30},
        act_id=39,
        list=[
            #base_act_equip_sell_sub{id=1,page=1,dec = ?T("夏日幻想"),goods_info=[{6601018,1}],sell_num=3,price=2888,cbp=20000,bind=0},
            #base_act_equip_sell_sub{id=2,page=1,dec = ?T("夏日幻想"),goods_info=[{4103020,1}],sell_num=3,price=988,cbp=7840,bind=0},
            #base_act_equip_sell_sub{id=3,page=1,dec = ?T("夏日幻想"),goods_info=[{6603043,1}],sell_num=3,price=1288,cbp=10000,bind=0}
        ],
        act_info=#act_info{}
    };
get(_) -> [].

get_all() -> [1,6,30,31,36,37,33,34,35,38,41,40,39].
