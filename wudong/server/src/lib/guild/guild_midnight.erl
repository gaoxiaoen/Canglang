%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 帮派晚上12点处理
%%% @end
%%% Created : 20. 一月 2017 下午2:23
%%%-------------------------------------------------------------------
-module(guild_midnight).
-author("fengzhenlin").
-include("guild.hrl").
-include("common.hrl").

%% API
-compile(export_all).

%%晚上零点帮派处理
guild_midnight_handle() ->
    Now = util:unixtime(),
    %%更新帮派信息
    FirstG = ets:first(?ETS_GUILD),
    do_one_guild(FirstG, Now),
    %%更新成员信息
    First = ets:first(?ETS_GUILD_MEMBER),
    do_one_member(First, Now),
    %%称号
    spawn(fun() -> timer:sleep(10000), guild_rank_des() end),
    ok.

%%帮派更新
do_one_guild('$end_of_table', _Now) -> ok;
do_one_guild(Key, Now) ->
    Guild = guild_ets:get_guild(Key),
    %%更新活跃之星
    {LastHyKey, HyVal} = guild_hy:get_first_hy(Key),
    NewGuild = Guild#guild{
        last_hy_key = LastHyKey,
        last_hy_val = HyVal,
        like_times = 0,
        hy_gift_time = 0,

        max_pass_floor = 0
        , pass_pkey = 0
        , pass_floor_list = []
        , pass_update_time = Now
    },
    guild_ets:set_guild(NewGuild),
    NextKey = ets:next(?ETS_GUILD, Key),
    do_one_guild(NextKey, Now).

%%帮派成员更新
do_one_member('$end_of_table', _Now) -> ok;
do_one_member(Key, Now) ->
    Member = guild_ets:get_guild_member(Key),
    #g_member{
        daily_dedicate = DailyDed,
        jc_hy_val = JcHyVal
    } = Member,
    %%更新每日活跃度、每日奉献值
    Member1 =
        case DailyDed > 0 orelse JcHyVal > 0 of
            true -> guild_hy:update_calc_member_hy(Member);
            false -> Member
        end,

    %%重置妖魔入侵
    Member2 = guild_demon:update_guild_demon(Member1),

    guild_ets:set_guild_member(Member2),

    NextKey = ets:next(?ETS_GUILD_MEMBER, Key),
    do_one_member(NextKey, Now).

%%帮派排行称号
guild_rank_des() ->
    case guild_util:get_guild_top_n_list(1) of
        [] -> skip;
        [G|_] ->
            #guild{
                pkey = Pkey
            } = G,
            designation_proc:add_des(10010, [Pkey]),
            Title = ?T("系统邮件"),
            Content = ?T("贡献您所在仙盟获得排名第一，掌门的称号奖励已发放，请在称号界面查看"),
            mail:sys_send_mail([Pkey], Title, Content),
            ok
    end.