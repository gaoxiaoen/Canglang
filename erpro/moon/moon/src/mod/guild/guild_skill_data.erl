-module(guild_skill_data).
-export([get/2]).

-include("guild.hrl").

get(guild_skill, {1, 0}) ->
    {ok, #guild_skill{
            id = {1, 0}
            ,type = 1
            ,lev = 0
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 0
            ,fund = 0
            ,desc = <<"未激活">>
            ,buff = undefined
        }
    };
get(guild_skill, {1, 1}) ->
    {ok, #guild_skill{
            id = {1, 1}
            ,type = 1
            ,lev = 1
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 1
            ,fund = 350
            ,desc = <<"增加20点攻击">>
            ,buff = guild_dmg_1
        }
    };
get(guild_skill, {1, 2}) ->
    {ok, #guild_skill{
            id = {1, 2}
            ,type = 1
            ,lev = 2
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 2
            ,fund = 700
            ,desc = <<"增加40点攻击">>
            ,buff = guild_dmg_2
        }
    };
get(guild_skill, {1, 3}) ->
    {ok, #guild_skill{
            id = {1, 3}
            ,type = 1
            ,lev = 3
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 3
            ,fund = 1400
            ,desc = <<"增加60点攻击">>
            ,buff = guild_dmg_3
        }
    };
get(guild_skill, {1, 4}) ->
    {ok, #guild_skill{
            id = {1, 4}
            ,type = 1
            ,lev = 4
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 4
            ,fund = 2800
            ,desc = <<"增加80点攻击">>
            ,buff = guild_dmg_4
        }
    };
get(guild_skill, {1, 5}) ->
    {ok, #guild_skill{
            id = {1, 5}
            ,type = 1
            ,lev = 5
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 5
            ,fund = 5040
            ,desc = <<"增加100点攻击">>
            ,buff = guild_dmg_5
        }
    };
get(guild_skill, {1, 6}) ->
    {ok, #guild_skill{
            id = {1, 6}
            ,type = 1
            ,lev = 6
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 6
            ,fund = 9072
            ,desc = <<"增加120点攻击">>
            ,buff = guild_dmg_6
        }
    };
get(guild_skill, {1, 7}) ->
    {ok, #guild_skill{
            id = {1, 7}
            ,type = 1
            ,lev = 7
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 7
            ,fund = 16329
            ,desc = <<"增加140点攻击">>
            ,buff = guild_dmg_7
        }
    };
get(guild_skill, {1, 8}) ->
    {ok, #guild_skill{
            id = {1, 8}
            ,type = 1
            ,lev = 8
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 8
            ,fund = 26127
            ,desc = <<"增加160点攻击">>
            ,buff = guild_dmg_8
        }
    };
get(guild_skill, {1, 9}) ->
    {ok, #guild_skill{
            id = {1, 9}
            ,type = 1
            ,lev = 9
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 9
            ,fund = 41803
            ,desc = <<"增加180点攻击">>
            ,buff = guild_dmg_9
        }
    };
get(guild_skill, {1, 10}) ->
    {ok, #guild_skill{
            id = {1, 10}
            ,type = 1
            ,lev = 10
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 10
            ,fund = 66886
            ,desc = <<"增加200点攻击">>
            ,buff = guild_dmg_10
        }
    };
get(guild_skill, {1, 11}) ->
    {ok, #guild_skill{
            id = {1, 11}
            ,type = 1
            ,lev = 11
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 11
            ,fund = 100329
            ,desc = <<"增加220点攻击">>
            ,buff = guild_dmg_11
        }
    };
get(guild_skill, {1, 12}) ->
    {ok, #guild_skill{
            id = {1, 12}
            ,type = 1
            ,lev = 12
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 12
            ,fund = 150493
            ,desc = <<"增加240点攻击">>
            ,buff = guild_dmg_12
        }
    };
get(guild_skill, {1, 13}) ->
    {ok, #guild_skill{
            id = {1, 13}
            ,type = 1
            ,lev = 13
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 13
            ,fund = 225740
            ,desc = <<"增加260点攻击">>
            ,buff = guild_dmg_13
        }
    };
get(guild_skill, {1, 14}) ->
    {ok, #guild_skill{
            id = {1, 14}
            ,type = 1
            ,lev = 14
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 14
            ,fund = 304749
            ,desc = <<"增加280点攻击">>
            ,buff = guild_dmg_14
        }
    };
get(guild_skill, {1, 15}) ->
    {ok, #guild_skill{
            id = {1, 15}
            ,type = 1
            ,lev = 15
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 15
            ,fund = 411411
            ,desc = <<"增加300点攻击">>
            ,buff = guild_dmg_15
        }
    };
get(guild_skill, {1, 16}) ->
    {ok, #guild_skill{
            id = {1, 16}
            ,type = 1
            ,lev = 16
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 16
            ,fund = 555406
            ,desc = <<"增加320点攻击">>
            ,buff = guild_dmg_16
        }
    };
get(guild_skill, {1, 17}) ->
    {ok, #guild_skill{
            id = {1, 17}
            ,type = 1
            ,lev = 17
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 17
            ,fund = 722027
            ,desc = <<"增加340点攻击">>
            ,buff = guild_dmg_17
        }
    };
get(guild_skill, {1, 18}) ->
    {ok, #guild_skill{
            id = {1, 18}
            ,type = 1
            ,lev = 18
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 18
            ,fund = 938636
            ,desc = <<"增加360点攻击">>
            ,buff = guild_dmg_18
        }
    };
get(guild_skill, {1, 19}) ->
    {ok, #guild_skill{
            id = {1, 19}
            ,type = 1
            ,lev = 19
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 19
            ,fund = 1220227
            ,desc = <<"增加380点攻击">>
            ,buff = guild_dmg_19
        }
    };
get(guild_skill, {1, 20}) ->
    {ok, #guild_skill{
            id = {1, 20}
            ,type = 1
            ,lev = 20
            ,name = <<"攻击强化">>
            ,icon = 10001
            ,glev = 20
            ,fund = 1464272
            ,desc = <<"增加400点攻击">>
            ,buff = guild_dmg_20
        }
    };
get(guild_skill, {2, 0}) ->
    {ok, #guild_skill{
            id = {2, 0}
            ,type = 2
            ,lev = 0
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 0
            ,fund = 0
            ,desc = <<"未激活">>
            ,buff = undefined
        }
    };
get(guild_skill, {2, 1}) ->
    {ok, #guild_skill{
            id = {2, 1}
            ,type = 2
            ,lev = 1
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 1
            ,fund = 350
            ,desc = <<"增加200点生命">>
            ,buff = guild_hp_1
        }
    };
get(guild_skill, {2, 2}) ->
    {ok, #guild_skill{
            id = {2, 2}
            ,type = 2
            ,lev = 2
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 2
            ,fund = 700
            ,desc = <<"增加300点生命">>
            ,buff = guild_hp_2
        }
    };
get(guild_skill, {2, 3}) ->
    {ok, #guild_skill{
            id = {2, 3}
            ,type = 2
            ,lev = 3
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 3
            ,fund = 1400
            ,desc = <<"增加400点生命">>
            ,buff = guild_hp_3
        }
    };
get(guild_skill, {2, 4}) ->
    {ok, #guild_skill{
            id = {2, 4}
            ,type = 2
            ,lev = 4
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 4
            ,fund = 2800
            ,desc = <<"增加500点生命">>
            ,buff = guild_hp_4
        }
    };
get(guild_skill, {2, 5}) ->
    {ok, #guild_skill{
            id = {2, 5}
            ,type = 2
            ,lev = 5
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 5
            ,fund = 5040
            ,desc = <<"增加600点生命">>
            ,buff = guild_hp_5
        }
    };
get(guild_skill, {2, 6}) ->
    {ok, #guild_skill{
            id = {2, 6}
            ,type = 2
            ,lev = 6
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 6
            ,fund = 9072
            ,desc = <<"增加700点生命">>
            ,buff = guild_hp_6
        }
    };
get(guild_skill, {2, 7}) ->
    {ok, #guild_skill{
            id = {2, 7}
            ,type = 2
            ,lev = 7
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 7
            ,fund = 16329
            ,desc = <<"增加800点生命">>
            ,buff = guild_hp_7
        }
    };
get(guild_skill, {2, 8}) ->
    {ok, #guild_skill{
            id = {2, 8}
            ,type = 2
            ,lev = 8
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 8
            ,fund = 26127
            ,desc = <<"增加900点生命">>
            ,buff = guild_hp_8
        }
    };
get(guild_skill, {2, 9}) ->
    {ok, #guild_skill{
            id = {2, 9}
            ,type = 2
            ,lev = 9
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 9
            ,fund = 41803
            ,desc = <<"增加1000点生命">>
            ,buff = guild_hp_9
        }
    };
get(guild_skill, {2, 10}) ->
    {ok, #guild_skill{
            id = {2, 10}
            ,type = 2
            ,lev = 10
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 10
            ,fund = 66886
            ,desc = <<"增加1100点生命">>
            ,buff = guild_hp_10
        }
    };
get(guild_skill, {2, 11}) ->
    {ok, #guild_skill{
            id = {2, 11}
            ,type = 2
            ,lev = 11
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 11
            ,fund = 100329
            ,desc = <<"增加1200点生命">>
            ,buff = guild_hp_11
        }
    };
get(guild_skill, {2, 12}) ->
    {ok, #guild_skill{
            id = {2, 12}
            ,type = 2
            ,lev = 12
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 12
            ,fund = 150493
            ,desc = <<"增加1300点生命">>
            ,buff = guild_hp_12
        }
    };
get(guild_skill, {2, 13}) ->
    {ok, #guild_skill{
            id = {2, 13}
            ,type = 2
            ,lev = 13
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 13
            ,fund = 225740
            ,desc = <<"增加1400点生命">>
            ,buff = guild_hp_13
        }
    };
get(guild_skill, {2, 14}) ->
    {ok, #guild_skill{
            id = {2, 14}
            ,type = 2
            ,lev = 14
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 14
            ,fund = 304749
            ,desc = <<"增加1500点生命">>
            ,buff = guild_hp_14
        }
    };
get(guild_skill, {2, 15}) ->
    {ok, #guild_skill{
            id = {2, 15}
            ,type = 2
            ,lev = 15
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 15
            ,fund = 411411
            ,desc = <<"增加1600点生命">>
            ,buff = guild_hp_15
        }
    };
get(guild_skill, {2, 16}) ->
    {ok, #guild_skill{
            id = {2, 16}
            ,type = 2
            ,lev = 16
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 16
            ,fund = 555406
            ,desc = <<"增加1700点生命">>
            ,buff = guild_hp_16
        }
    };
get(guild_skill, {2, 17}) ->
    {ok, #guild_skill{
            id = {2, 17}
            ,type = 2
            ,lev = 17
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 17
            ,fund = 722027
            ,desc = <<"增加1800点生命">>
            ,buff = guild_hp_17
        }
    };
get(guild_skill, {2, 18}) ->
    {ok, #guild_skill{
            id = {2, 18}
            ,type = 2
            ,lev = 18
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 18
            ,fund = 938636
            ,desc = <<"增加1900点生命">>
            ,buff = guild_hp_18
        }
    };
get(guild_skill, {2, 19}) ->
    {ok, #guild_skill{
            id = {2, 19}
            ,type = 2
            ,lev = 19
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 19
            ,fund = 1220227
            ,desc = <<"增加2000点生命">>
            ,buff = guild_hp_19
        }
    };
get(guild_skill, {2, 20}) ->
    {ok, #guild_skill{
            id = {2, 20}
            ,type = 2
            ,lev = 20
            ,name = <<"生命强化">>
            ,icon = 10002
            ,glev = 20
            ,fund = 1464272
            ,desc = <<"增加2100点生命">>
            ,buff = guild_hp_20
        }
    };
get(guild_skill, {3, 0}) ->
    {ok, #guild_skill{
            id = {3, 0}
            ,type = 3
            ,lev = 0
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 0
            ,fund = 0
            ,desc = <<"未激活">>
            ,buff = undefined
        }
    };
get(guild_skill, {3, 1}) ->
    {ok, #guild_skill{
            id = {3, 1}
            ,type = 3
            ,lev = 1
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 1
            ,fund = 350
            ,desc = <<"增加40点防御">>
            ,buff = guild_df_1
        }
    };
get(guild_skill, {3, 2}) ->
    {ok, #guild_skill{
            id = {3, 2}
            ,type = 3
            ,lev = 2
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 2
            ,fund = 700
            ,desc = <<"增加60点防御">>
            ,buff = guild_df_2
        }
    };
get(guild_skill, {3, 3}) ->
    {ok, #guild_skill{
            id = {3, 3}
            ,type = 3
            ,lev = 3
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 3
            ,fund = 1400
            ,desc = <<"增加80点防御">>
            ,buff = guild_df_3
        }
    };
get(guild_skill, {3, 4}) ->
    {ok, #guild_skill{
            id = {3, 4}
            ,type = 3
            ,lev = 4
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 4
            ,fund = 2800
            ,desc = <<"增加100点防御">>
            ,buff = guild_df_4
        }
    };
get(guild_skill, {3, 5}) ->
    {ok, #guild_skill{
            id = {3, 5}
            ,type = 3
            ,lev = 5
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 5
            ,fund = 5040
            ,desc = <<"增加120点防御">>
            ,buff = guild_df_5
        }
    };
get(guild_skill, {3, 6}) ->
    {ok, #guild_skill{
            id = {3, 6}
            ,type = 3
            ,lev = 6
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 6
            ,fund = 9072
            ,desc = <<"增加140点防御">>
            ,buff = guild_df_6
        }
    };
get(guild_skill, {3, 7}) ->
    {ok, #guild_skill{
            id = {3, 7}
            ,type = 3
            ,lev = 7
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 7
            ,fund = 16329
            ,desc = <<"增加160点防御">>
            ,buff = guild_df_7
        }
    };
get(guild_skill, {3, 8}) ->
    {ok, #guild_skill{
            id = {3, 8}
            ,type = 3
            ,lev = 8
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 8
            ,fund = 26127
            ,desc = <<"增加180点防御">>
            ,buff = guild_df_8
        }
    };
get(guild_skill, {3, 9}) ->
    {ok, #guild_skill{
            id = {3, 9}
            ,type = 3
            ,lev = 9
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 9
            ,fund = 41803
            ,desc = <<"增加200点防御">>
            ,buff = guild_df_9
        }
    };
get(guild_skill, {3, 10}) ->
    {ok, #guild_skill{
            id = {3, 10}
            ,type = 3
            ,lev = 10
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 10
            ,fund = 66886
            ,desc = <<"增加220点防御">>
            ,buff = guild_df_10
        }
    };
get(guild_skill, {3, 11}) ->
    {ok, #guild_skill{
            id = {3, 11}
            ,type = 3
            ,lev = 11
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 11
            ,fund = 100329
            ,desc = <<"增加240点防御">>
            ,buff = guild_df_11
        }
    };
get(guild_skill, {3, 12}) ->
    {ok, #guild_skill{
            id = {3, 12}
            ,type = 3
            ,lev = 12
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 12
            ,fund = 150493
            ,desc = <<"增加260点防御">>
            ,buff = guild_df_12
        }
    };
get(guild_skill, {3, 13}) ->
    {ok, #guild_skill{
            id = {3, 13}
            ,type = 3
            ,lev = 13
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 13
            ,fund = 225740
            ,desc = <<"增加280点防御">>
            ,buff = guild_df_13
        }
    };
get(guild_skill, {3, 14}) ->
    {ok, #guild_skill{
            id = {3, 14}
            ,type = 3
            ,lev = 14
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 14
            ,fund = 304749
            ,desc = <<"增加300点防御">>
            ,buff = guild_df_14
        }
    };
get(guild_skill, {3, 15}) ->
    {ok, #guild_skill{
            id = {3, 15}
            ,type = 3
            ,lev = 15
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 15
            ,fund = 411411
            ,desc = <<"增加320点防御">>
            ,buff = guild_df_15
        }
    };
get(guild_skill, {3, 16}) ->
    {ok, #guild_skill{
            id = {3, 16}
            ,type = 3
            ,lev = 16
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 16
            ,fund = 555406
            ,desc = <<"增加340点防御">>
            ,buff = guild_df_16
        }
    };
get(guild_skill, {3, 17}) ->
    {ok, #guild_skill{
            id = {3, 17}
            ,type = 3
            ,lev = 17
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 17
            ,fund = 722027
            ,desc = <<"增加360点防御">>
            ,buff = guild_df_17
        }
    };
get(guild_skill, {3, 18}) ->
    {ok, #guild_skill{
            id = {3, 18}
            ,type = 3
            ,lev = 18
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 18
            ,fund = 938636
            ,desc = <<"增加380点防御">>
            ,buff = guild_df_18
        }
    };
get(guild_skill, {3, 19}) ->
    {ok, #guild_skill{
            id = {3, 19}
            ,type = 3
            ,lev = 19
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 19
            ,fund = 1220227
            ,desc = <<"增加400点防御">>
            ,buff = guild_df_19
        }
    };
get(guild_skill, {3, 20}) ->
    {ok, #guild_skill{
            id = {3, 20}
            ,type = 3
            ,lev = 20
            ,name = <<"防御强化">>
            ,icon = 10003
            ,glev = 20
            ,fund = 1464272
            ,desc = <<"增加420点防御">>
            ,buff = guild_df_20
        }
    };
get(guild_skill, {4, 0}) ->
    {ok, #guild_skill{
            id = {4, 0}
            ,type = 4
            ,lev = 0
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 0
            ,fund = 0
            ,desc = <<"未激活">>
            ,buff = undefined
        }
    };
get(guild_skill, {4, 1}) ->
    {ok, #guild_skill{
            id = {4, 1}
            ,type = 4
            ,lev = 1
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 1
            ,fund = 350
            ,desc = <<"增加5点精准">>
            ,buff = guild_hitrate_1
        }
    };
get(guild_skill, {4, 2}) ->
    {ok, #guild_skill{
            id = {4, 2}
            ,type = 4
            ,lev = 2
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 2
            ,fund = 700
            ,desc = <<"增加7点精准">>
            ,buff = guild_hitrate_2
        }
    };
get(guild_skill, {4, 3}) ->
    {ok, #guild_skill{
            id = {4, 3}
            ,type = 4
            ,lev = 3
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 3
            ,fund = 1400
            ,desc = <<"增加9点精准">>
            ,buff = guild_hitrate_3
        }
    };
get(guild_skill, {4, 4}) ->
    {ok, #guild_skill{
            id = {4, 4}
            ,type = 4
            ,lev = 4
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 4
            ,fund = 2800
            ,desc = <<"增加11点精准">>
            ,buff = guild_hitrate_4
        }
    };
get(guild_skill, {4, 5}) ->
    {ok, #guild_skill{
            id = {4, 5}
            ,type = 4
            ,lev = 5
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 5
            ,fund = 5040
            ,desc = <<"增加13点精准">>
            ,buff = guild_hitrate_5
        }
    };
get(guild_skill, {4, 6}) ->
    {ok, #guild_skill{
            id = {4, 6}
            ,type = 4
            ,lev = 6
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 6
            ,fund = 9072
            ,desc = <<"增加15点精准">>
            ,buff = guild_hitrate_6
        }
    };
get(guild_skill, {4, 7}) ->
    {ok, #guild_skill{
            id = {4, 7}
            ,type = 4
            ,lev = 7
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 7
            ,fund = 16329
            ,desc = <<"增加17点精准">>
            ,buff = guild_hitrate_7
        }
    };
get(guild_skill, {4, 8}) ->
    {ok, #guild_skill{
            id = {4, 8}
            ,type = 4
            ,lev = 8
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 8
            ,fund = 26127
            ,desc = <<"增加19点精准">>
            ,buff = guild_hitrate_8
        }
    };
get(guild_skill, {4, 9}) ->
    {ok, #guild_skill{
            id = {4, 9}
            ,type = 4
            ,lev = 9
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 9
            ,fund = 41803
            ,desc = <<"增加21点精准">>
            ,buff = guild_hitrate_9
        }
    };
get(guild_skill, {4, 10}) ->
    {ok, #guild_skill{
            id = {4, 10}
            ,type = 4
            ,lev = 10
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 10
            ,fund = 66886
            ,desc = <<"增加23点精准">>
            ,buff = guild_hitrate_10
        }
    };
get(guild_skill, {4, 11}) ->
    {ok, #guild_skill{
            id = {4, 11}
            ,type = 4
            ,lev = 11
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 11
            ,fund = 100329
            ,desc = <<"增加26点精准">>
            ,buff = guild_hitrate_11
        }
    };
get(guild_skill, {4, 12}) ->
    {ok, #guild_skill{
            id = {4, 12}
            ,type = 4
            ,lev = 12
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 12
            ,fund = 150493
            ,desc = <<"增加29点精准">>
            ,buff = guild_hitrate_12
        }
    };
get(guild_skill, {4, 13}) ->
    {ok, #guild_skill{
            id = {4, 13}
            ,type = 4
            ,lev = 13
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 13
            ,fund = 225740
            ,desc = <<"增加32点精准">>
            ,buff = guild_hitrate_13
        }
    };
get(guild_skill, {4, 14}) ->
    {ok, #guild_skill{
            id = {4, 14}
            ,type = 4
            ,lev = 14
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 14
            ,fund = 304749
            ,desc = <<"增加35点精准">>
            ,buff = guild_hitrate_14
        }
    };
get(guild_skill, {4, 15}) ->
    {ok, #guild_skill{
            id = {4, 15}
            ,type = 4
            ,lev = 15
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 15
            ,fund = 411411
            ,desc = <<"增加38点精准">>
            ,buff = guild_hitrate_15
        }
    };
get(guild_skill, {4, 16}) ->
    {ok, #guild_skill{
            id = {4, 16}
            ,type = 4
            ,lev = 16
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 16
            ,fund = 555406
            ,desc = <<"增加41点精准">>
            ,buff = guild_hitrate_16
        }
    };
get(guild_skill, {4, 17}) ->
    {ok, #guild_skill{
            id = {4, 17}
            ,type = 4
            ,lev = 17
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 17
            ,fund = 722027
            ,desc = <<"增加44点精准">>
            ,buff = guild_hitrate_17
        }
    };
get(guild_skill, {4, 18}) ->
    {ok, #guild_skill{
            id = {4, 18}
            ,type = 4
            ,lev = 18
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 18
            ,fund = 938636
            ,desc = <<"增加47点精准">>
            ,buff = guild_hitrate_18
        }
    };
get(guild_skill, {4, 19}) ->
    {ok, #guild_skill{
            id = {4, 19}
            ,type = 4
            ,lev = 19
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 19
            ,fund = 1220227
            ,desc = <<"增加50点精准">>
            ,buff = guild_hitrate_19
        }
    };
get(guild_skill, {4, 20}) ->
    {ok, #guild_skill{
            id = {4, 20}
            ,type = 4
            ,lev = 20
            ,name = <<"精准强化">>
            ,icon = 10004
            ,glev = 20
            ,fund = 1464272
            ,desc = <<"增加53点精准">>
            ,buff = guild_hitrate_20
        }
    };
get(guild_skill, {5, 0}) ->
    {ok, #guild_skill{
            id = {5, 0}
            ,type = 5
            ,lev = 0
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 0
            ,fund = 0
            ,desc = <<"未激活">>
            ,buff = undefined
        }
    };
get(guild_skill, {5, 1}) ->
    {ok, #guild_skill{
            id = {5, 1}
            ,type = 5
            ,lev = 1
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 1
            ,fund = 350
            ,desc = <<"增加5点格挡">>
            ,buff = guild_evasion_1
        }
    };
get(guild_skill, {5, 2}) ->
    {ok, #guild_skill{
            id = {5, 2}
            ,type = 5
            ,lev = 2
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 2
            ,fund = 700
            ,desc = <<"增加7点格挡">>
            ,buff = guild_evasion_2
        }
    };
get(guild_skill, {5, 3}) ->
    {ok, #guild_skill{
            id = {5, 3}
            ,type = 5
            ,lev = 3
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 3
            ,fund = 1400
            ,desc = <<"增加9点格挡">>
            ,buff = guild_evasion_3
        }
    };
get(guild_skill, {5, 4}) ->
    {ok, #guild_skill{
            id = {5, 4}
            ,type = 5
            ,lev = 4
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 4
            ,fund = 2800
            ,desc = <<"增加11点格挡">>
            ,buff = guild_evasion_4
        }
    };
get(guild_skill, {5, 5}) ->
    {ok, #guild_skill{
            id = {5, 5}
            ,type = 5
            ,lev = 5
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 5
            ,fund = 5040
            ,desc = <<"增加13点格挡">>
            ,buff = guild_evasion_5
        }
    };
get(guild_skill, {5, 6}) ->
    {ok, #guild_skill{
            id = {5, 6}
            ,type = 5
            ,lev = 6
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 6
            ,fund = 9072
            ,desc = <<"增加15点格挡">>
            ,buff = guild_evasion_6
        }
    };
get(guild_skill, {5, 7}) ->
    {ok, #guild_skill{
            id = {5, 7}
            ,type = 5
            ,lev = 7
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 7
            ,fund = 16329
            ,desc = <<"增加17点格挡">>
            ,buff = guild_evasion_7
        }
    };
get(guild_skill, {5, 8}) ->
    {ok, #guild_skill{
            id = {5, 8}
            ,type = 5
            ,lev = 8
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 8
            ,fund = 26127
            ,desc = <<"增加19点格挡">>
            ,buff = guild_evasion_8
        }
    };
get(guild_skill, {5, 9}) ->
    {ok, #guild_skill{
            id = {5, 9}
            ,type = 5
            ,lev = 9
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 9
            ,fund = 41803
            ,desc = <<"增加21点格挡">>
            ,buff = guild_evasion_9
        }
    };
get(guild_skill, {5, 10}) ->
    {ok, #guild_skill{
            id = {5, 10}
            ,type = 5
            ,lev = 10
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 10
            ,fund = 66886
            ,desc = <<"增加23点格挡">>
            ,buff = guild_evasion_10
        }
    };
get(guild_skill, {5, 11}) ->
    {ok, #guild_skill{
            id = {5, 11}
            ,type = 5
            ,lev = 11
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 11
            ,fund = 100329
            ,desc = <<"增加26点格挡">>
            ,buff = guild_evasion_11
        }
    };
get(guild_skill, {5, 12}) ->
    {ok, #guild_skill{
            id = {5, 12}
            ,type = 5
            ,lev = 12
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 12
            ,fund = 150493
            ,desc = <<"增加29点格挡">>
            ,buff = guild_evasion_12
        }
    };
get(guild_skill, {5, 13}) ->
    {ok, #guild_skill{
            id = {5, 13}
            ,type = 5
            ,lev = 13
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 13
            ,fund = 225740
            ,desc = <<"增加32点格挡">>
            ,buff = guild_evasion_13
        }
    };
get(guild_skill, {5, 14}) ->
    {ok, #guild_skill{
            id = {5, 14}
            ,type = 5
            ,lev = 14
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 14
            ,fund = 304749
            ,desc = <<"增加35点格挡">>
            ,buff = guild_evasion_14
        }
    };
get(guild_skill, {5, 15}) ->
    {ok, #guild_skill{
            id = {5, 15}
            ,type = 5
            ,lev = 15
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 15
            ,fund = 411411
            ,desc = <<"增加38点格挡">>
            ,buff = guild_evasion_15
        }
    };
get(guild_skill, {5, 16}) ->
    {ok, #guild_skill{
            id = {5, 16}
            ,type = 5
            ,lev = 16
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 16
            ,fund = 555406
            ,desc = <<"增加41点格挡">>
            ,buff = guild_evasion_16
        }
    };
get(guild_skill, {5, 17}) ->
    {ok, #guild_skill{
            id = {5, 17}
            ,type = 5
            ,lev = 17
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 17
            ,fund = 722027
            ,desc = <<"增加44点格挡">>
            ,buff = guild_evasion_17
        }
    };
get(guild_skill, {5, 18}) ->
    {ok, #guild_skill{
            id = {5, 18}
            ,type = 5
            ,lev = 18
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 18
            ,fund = 938636
            ,desc = <<"增加47点格挡">>
            ,buff = guild_evasion_18
        }
    };
get(guild_skill, {5, 19}) ->
    {ok, #guild_skill{
            id = {5, 19}
            ,type = 5
            ,lev = 19
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 19
            ,fund = 1220227
            ,desc = <<"增加50点格挡">>
            ,buff = guild_evasion_19
        }
    };
get(guild_skill, {5, 20}) ->
    {ok, #guild_skill{
            id = {5, 20}
            ,type = 5
            ,lev = 20
            ,name = <<"格挡强化">>
            ,icon = 10005
            ,glev = 20
            ,fund = 1464272
            ,desc = <<"增加53点格挡">>
            ,buff = guild_evasion_20
        }
    };
get(guild_skill, {6, 0}) ->
    {ok, #guild_skill{
            id = {6, 0}
            ,type = 6
            ,lev = 0
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 0
            ,fund = 0
            ,desc = <<"未激活">>
            ,buff = undefined
        }
    };
get(guild_skill, {6, 1}) ->
    {ok, #guild_skill{
            id = {6, 1}
            ,type = 6
            ,lev = 1
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 1
            ,fund = 350
            ,desc = <<"增加5点暴怒">>
            ,buff = guild_critrate_1
        }
    };
get(guild_skill, {6, 2}) ->
    {ok, #guild_skill{
            id = {6, 2}
            ,type = 6
            ,lev = 2
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 2
            ,fund = 700
            ,desc = <<"增加7点暴怒">>
            ,buff = guild_critrate_2
        }
    };
get(guild_skill, {6, 3}) ->
    {ok, #guild_skill{
            id = {6, 3}
            ,type = 6
            ,lev = 3
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 3
            ,fund = 1400
            ,desc = <<"增加9点暴怒">>
            ,buff = guild_critrate_3
        }
    };
get(guild_skill, {6, 4}) ->
    {ok, #guild_skill{
            id = {6, 4}
            ,type = 6
            ,lev = 4
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 4
            ,fund = 2800
            ,desc = <<"增加11点暴怒">>
            ,buff = guild_critrate_4
        }
    };
get(guild_skill, {6, 5}) ->
    {ok, #guild_skill{
            id = {6, 5}
            ,type = 6
            ,lev = 5
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 5
            ,fund = 5040
            ,desc = <<"增加13点暴怒">>
            ,buff = guild_critrate_5
        }
    };
get(guild_skill, {6, 6}) ->
    {ok, #guild_skill{
            id = {6, 6}
            ,type = 6
            ,lev = 6
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 6
            ,fund = 9072
            ,desc = <<"增加15点暴怒">>
            ,buff = guild_critrate_6
        }
    };
get(guild_skill, {6, 7}) ->
    {ok, #guild_skill{
            id = {6, 7}
            ,type = 6
            ,lev = 7
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 7
            ,fund = 16329
            ,desc = <<"增加17点暴怒">>
            ,buff = guild_critrate_7
        }
    };
get(guild_skill, {6, 8}) ->
    {ok, #guild_skill{
            id = {6, 8}
            ,type = 6
            ,lev = 8
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 8
            ,fund = 26127
            ,desc = <<"增加19点暴怒">>
            ,buff = guild_critrate_8
        }
    };
get(guild_skill, {6, 9}) ->
    {ok, #guild_skill{
            id = {6, 9}
            ,type = 6
            ,lev = 9
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 9
            ,fund = 41803
            ,desc = <<"增加21点暴怒">>
            ,buff = guild_critrate_9
        }
    };
get(guild_skill, {6, 10}) ->
    {ok, #guild_skill{
            id = {6, 10}
            ,type = 6
            ,lev = 10
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 10
            ,fund = 66886
            ,desc = <<"增加23点暴怒">>
            ,buff = guild_critrate_10
        }
    };
get(guild_skill, {6, 11}) ->
    {ok, #guild_skill{
            id = {6, 11}
            ,type = 6
            ,lev = 11
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 11
            ,fund = 100329
            ,desc = <<"增加26点暴怒">>
            ,buff = guild_critrate_11
        }
    };
get(guild_skill, {6, 12}) ->
    {ok, #guild_skill{
            id = {6, 12}
            ,type = 6
            ,lev = 12
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 12
            ,fund = 150493
            ,desc = <<"增加29点暴怒">>
            ,buff = guild_critrate_12
        }
    };
get(guild_skill, {6, 13}) ->
    {ok, #guild_skill{
            id = {6, 13}
            ,type = 6
            ,lev = 13
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 13
            ,fund = 225740
            ,desc = <<"增加32点暴怒">>
            ,buff = guild_critrate_13
        }
    };
get(guild_skill, {6, 14}) ->
    {ok, #guild_skill{
            id = {6, 14}
            ,type = 6
            ,lev = 14
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 14
            ,fund = 304749
            ,desc = <<"增加35点暴怒">>
            ,buff = guild_critrate_14
        }
    };
get(guild_skill, {6, 15}) ->
    {ok, #guild_skill{
            id = {6, 15}
            ,type = 6
            ,lev = 15
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 15
            ,fund = 411411
            ,desc = <<"增加38点暴怒">>
            ,buff = guild_critrate_15
        }
    };
get(guild_skill, {6, 16}) ->
    {ok, #guild_skill{
            id = {6, 16}
            ,type = 6
            ,lev = 16
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 16
            ,fund = 555406
            ,desc = <<"增加41点暴怒">>
            ,buff = guild_critrate_16
        }
    };
get(guild_skill, {6, 17}) ->
    {ok, #guild_skill{
            id = {6, 17}
            ,type = 6
            ,lev = 17
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 17
            ,fund = 722027
            ,desc = <<"增加44点暴怒">>
            ,buff = guild_critrate_17
        }
    };
get(guild_skill, {6, 18}) ->
    {ok, #guild_skill{
            id = {6, 18}
            ,type = 6
            ,lev = 18
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 18
            ,fund = 938636
            ,desc = <<"增加47点暴怒">>
            ,buff = guild_critrate_18
        }
    };
get(guild_skill, {6, 19}) ->
    {ok, #guild_skill{
            id = {6, 19}
            ,type = 6
            ,lev = 19
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 19
            ,fund = 1220227
            ,desc = <<"增加50点暴怒">>
            ,buff = guild_critrate_19
        }
    };
get(guild_skill, {6, 20}) ->
    {ok, #guild_skill{
            id = {6, 20}
            ,type = 6
            ,lev = 20
            ,name = <<"暴怒强化">>
            ,icon = 10006
            ,glev = 20
            ,fund = 1464272
            ,desc = <<"增加53点暴怒">>
            ,buff = guild_critrate_20
        }
    };
get(guild_skill, {7, 0}) ->
    {ok, #guild_skill{
            id = {7, 0}
            ,type = 7
            ,lev = 0
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 0
            ,fund = 0
            ,desc = <<"未激活">>
            ,buff = undefined
        }
    };
get(guild_skill, {7, 1}) ->
    {ok, #guild_skill{
            id = {7, 1}
            ,type = 7
            ,lev = 1
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 1
            ,fund = 350
            ,desc = <<"增加5点坚韧">>
            ,buff = guild_tenacity_1
        }
    };
get(guild_skill, {7, 2}) ->
    {ok, #guild_skill{
            id = {7, 2}
            ,type = 7
            ,lev = 2
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 2
            ,fund = 700
            ,desc = <<"增加7点坚韧">>
            ,buff = guild_tenacity_2
        }
    };
get(guild_skill, {7, 3}) ->
    {ok, #guild_skill{
            id = {7, 3}
            ,type = 7
            ,lev = 3
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 3
            ,fund = 1400
            ,desc = <<"增加9点坚韧">>
            ,buff = guild_tenacity_3
        }
    };
get(guild_skill, {7, 4}) ->
    {ok, #guild_skill{
            id = {7, 4}
            ,type = 7
            ,lev = 4
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 4
            ,fund = 2800
            ,desc = <<"增加11点坚韧">>
            ,buff = guild_tenacity_4
        }
    };
get(guild_skill, {7, 5}) ->
    {ok, #guild_skill{
            id = {7, 5}
            ,type = 7
            ,lev = 5
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 5
            ,fund = 5040
            ,desc = <<"增加13点坚韧">>
            ,buff = guild_tenacity_5
        }
    };
get(guild_skill, {7, 6}) ->
    {ok, #guild_skill{
            id = {7, 6}
            ,type = 7
            ,lev = 6
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 6
            ,fund = 9072
            ,desc = <<"增加15点坚韧">>
            ,buff = guild_tenacity_6
        }
    };
get(guild_skill, {7, 7}) ->
    {ok, #guild_skill{
            id = {7, 7}
            ,type = 7
            ,lev = 7
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 7
            ,fund = 16329
            ,desc = <<"增加17点坚韧">>
            ,buff = guild_tenacity_7
        }
    };
get(guild_skill, {7, 8}) ->
    {ok, #guild_skill{
            id = {7, 8}
            ,type = 7
            ,lev = 8
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 8
            ,fund = 26127
            ,desc = <<"增加19点坚韧">>
            ,buff = guild_tenacity_8
        }
    };
get(guild_skill, {7, 9}) ->
    {ok, #guild_skill{
            id = {7, 9}
            ,type = 7
            ,lev = 9
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 9
            ,fund = 41803
            ,desc = <<"增加21点坚韧">>
            ,buff = guild_tenacity_9
        }
    };
get(guild_skill, {7, 10}) ->
    {ok, #guild_skill{
            id = {7, 10}
            ,type = 7
            ,lev = 10
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 10
            ,fund = 66886
            ,desc = <<"增加23点坚韧">>
            ,buff = guild_tenacity_10
        }
    };
get(guild_skill, {7, 11}) ->
    {ok, #guild_skill{
            id = {7, 11}
            ,type = 7
            ,lev = 11
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 11
            ,fund = 100329
            ,desc = <<"增加26点坚韧">>
            ,buff = guild_tenacity_11
        }
    };
get(guild_skill, {7, 12}) ->
    {ok, #guild_skill{
            id = {7, 12}
            ,type = 7
            ,lev = 12
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 12
            ,fund = 150493
            ,desc = <<"增加29点坚韧">>
            ,buff = guild_tenacity_12
        }
    };
get(guild_skill, {7, 13}) ->
    {ok, #guild_skill{
            id = {7, 13}
            ,type = 7
            ,lev = 13
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 13
            ,fund = 225740
            ,desc = <<"增加32点坚韧">>
            ,buff = guild_tenacity_13
        }
    };
get(guild_skill, {7, 14}) ->
    {ok, #guild_skill{
            id = {7, 14}
            ,type = 7
            ,lev = 14
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 14
            ,fund = 304749
            ,desc = <<"增加35点坚韧">>
            ,buff = guild_tenacity_14
        }
    };
get(guild_skill, {7, 15}) ->
    {ok, #guild_skill{
            id = {7, 15}
            ,type = 7
            ,lev = 15
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 15
            ,fund = 411411
            ,desc = <<"增加38点坚韧">>
            ,buff = guild_tenacity_15
        }
    };
get(guild_skill, {7, 16}) ->
    {ok, #guild_skill{
            id = {7, 16}
            ,type = 7
            ,lev = 16
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 16
            ,fund = 555406
            ,desc = <<"增加41点坚韧">>
            ,buff = guild_tenacity_16
        }
    };
get(guild_skill, {7, 17}) ->
    {ok, #guild_skill{
            id = {7, 17}
            ,type = 7
            ,lev = 17
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 17
            ,fund = 722027
            ,desc = <<"增加44点坚韧">>
            ,buff = guild_tenacity_17
        }
    };
get(guild_skill, {7, 18}) ->
    {ok, #guild_skill{
            id = {7, 18}
            ,type = 7
            ,lev = 18
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 18
            ,fund = 938636
            ,desc = <<"增加47点坚韧">>
            ,buff = guild_tenacity_18
        }
    };
get(guild_skill, {7, 19}) ->
    {ok, #guild_skill{
            id = {7, 19}
            ,type = 7
            ,lev = 19
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 19
            ,fund = 1220227
            ,desc = <<"增加50点坚韧">>
            ,buff = guild_tenacity_19
        }
    };
get(guild_skill, {7, 20}) ->
    {ok, #guild_skill{
            id = {7, 20}
            ,type = 7
            ,lev = 20
            ,name = <<"坚韧强化">>
            ,icon = 10007
            ,glev = 20
            ,fund = 1464272
            ,desc = <<"增加53点坚韧">>
            ,buff = guild_tenacity_20
        }
    };
get(guild_skill, _) -> false.

