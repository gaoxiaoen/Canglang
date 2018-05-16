%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2015 上午11:09
%%%-------------------------------------------------------------------
-author("fengzhenlin").

-record(notice,{
    id = 0,
    type = 0,  %%公告类型 1运营公告2系统公告
    content = "",
    showposlist = [],
    send_to_scene = [],  %%发送到指定场景时使用
    scene_copy = 0,      %%发送到指定场景分线时使用
    guild_key = 0,  %%发送到仙盟的仙盟key
    one_time = 0,  %%间隔时间
    next_time = 0  %%下次播放时间戳
}).

-record(base_notice,{
    id = 0,
    show_pos = [],
    send_type = 0,
    content = ""
}).