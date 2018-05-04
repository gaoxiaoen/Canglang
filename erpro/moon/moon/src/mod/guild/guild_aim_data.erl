%----------------------------------------------------
%%  帮会目标数据
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_aim_data).
-export([get/1]).

-include("guild.hrl").

get(0) ->
    #guild_aim_data{
        type = 0
        ,column = 1          
        ,name = language:get(<<"帮会提升到5级">>)
        ,fund = 500
        ,items = [{30011,1,1},{23000,1,3},{32530,1,3}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到5级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到5级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(1) ->
    #guild_aim_data{
        type = 1
        ,column = 1          
        ,name = language:get(<<"帮会提升到10级">>)
        ,fund = 1000
        ,items = [{30011,1,3},{23000,1,10},{23002,1,3},{32530,1,3}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到10级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到10级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };


get(2) ->
    #guild_aim_data{
        type = 2
        ,column = 1          
        ,name = language:get(<<"帮会提升到15级">>)
        ,fund = 2000
        ,items = [{30011,1,5},{23002,1,3},{32530,1,5}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到15级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到15级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };


get(3) ->
    #guild_aim_data{
        type = 3
        ,column = 1          
        ,name = language:get(<<"帮会提升到20级">>)
        ,fund = 4000
        ,items = [{30011,1,10},{23002,1,5},{32531,1,5}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到20级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到20级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };


get(4) ->
    #guild_aim_data{
        type = 4
        ,column = 1          
        ,name = language:get(<<"帮会提升到25级">>)
        ,fund = 8000
        ,items = [{30011,1,15},{23002,1,8},{27000,1,20}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到25级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到25级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(5) ->
    #guild_aim_data{
        type = 5
        ,column = 1          
        ,name = language:get(<<"帮会提升到30级">>)
        ,fund = 15000
        ,items = [{30011,1,20},{23003,1,1},{27001,1,10}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到30级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到30级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(6) ->
    #guild_aim_data{
        type = 6
        ,column = 1          
        ,name = language:get(<<"帮会提升到35级">>)
        ,fund = 30000
        ,items = [{30011,1,25},{23003,1,2},{27002,1,10}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到35级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到35级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };



get(7) ->
    #guild_aim_data{
        type = 7
        ,column = 1          
        ,name = language:get(<<"帮会提升到40级">>)
        ,fund = 50000
        ,items = [{30011,1,30},{23003,1,3},{27003,1,10}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到40级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到40级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };


get(8) ->
    #guild_aim_data{
        type = 8
        ,column = 1          
        ,name = language:get(<<"帮会提升到45级">>)
        ,fund = 100000
        ,items = [{30011,1,40},{23003,1,5},{27003,1,20}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到45级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到45级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };


get(9) ->
    #guild_aim_data{
        type = 9
        ,column = 1          
        ,name = language:get(<<"帮会提升到50级">>)
        ,fund = 200000
        ,items = [{30011,1,50},{23003,1,8},{27003,1,30}]
        ,subject = language:get(<<"完成帮会目标“帮会提升到50级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会提升到50级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(10) ->
    #guild_aim_data{
        type = 10
        ,column = 2          
        ,name = language:get(<<"学习第一个帮会技能">>)
        ,fund = 300
        ,items = [{30210,1,1},{27000,1,5}]
        ,subject = language:get(<<"完成帮会目标“学习第一个帮会技能”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“学习第一个帮会技能”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };
get(11) ->
    #guild_aim_data{
        type = 11
        ,column = 2          
        ,name = language:get(<<"学习5个帮会技能">>)
        ,fund = 800
        ,items = [{30210,1,1},{27000,1,10}]
        ,subject = language:get(<<"完成帮会目标“学习5个帮会技能”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“学习5个帮会技能”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(12) ->
    #guild_aim_data{
        type = 12
        ,column = 2          
        ,name = language:get(<<"学习全部帮会技能">>)
        ,fund = 2000
        ,items = [{30210,1,2},{27000,1,30}]
        ,subject = language:get(<<"完成帮会目标“学习全部帮会技能”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“学习全部帮会技能”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(20) ->
    #guild_aim_data{
        type = 20
        ,column = 2          
        ,name = language:get(<<"提升一个技能到7级">>) %% TODO
        ,fund = 3000
        ,items = [{30210,1,2},{27000,1,30}]
        ,subject = language:get(<<"完成帮会目标“提升一个技能到7级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“提升一个技能到7级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };


get(21) ->
    #guild_aim_data{
        type = 21
        ,column = 2          
        ,name = language:get(<<"提升一个技能到15级">>)
        ,fund = 10000
        ,items = [{30210,1,3},{27001,1,10}]
        ,subject = language:get(<<"完成帮会目标“提升一个技能到15级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“提升一个技能到15级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(22) ->
    #guild_aim_data{
        type = 22
        ,column = 2          
        ,name = language:get(<<"提升5个技能到15级">>)
        ,fund = 50000
        ,items = [{30210,1,5},{27002,1,10}]
        ,subject = language:get(<<"完成帮会目标“提升5个技能到15级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“提升5个技能到15级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(23) ->
    #guild_aim_data{
        type = 23
        ,column = 2          
        ,name = language:get(<<"提升全部技能到15级">>)
        ,fund = 100000
        ,items = [{30210,1,5},{27003,1,10}]
        ,subject = language:get(<<"完成帮会目标“提升全部技能到15级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“提升全部技能到15级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(30) ->
    #guild_aim_data{
        type = 30
        ,column = 3          
        ,name = language:get(<<"帮会福利提升到7级">>)
        ,fund = 200
        ,items = [{27000,1,5}]
        ,subject = language:get(<<"完成帮会目标“帮会福利提升到7级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会福利提升到7级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(31) ->
    #guild_aim_data{
        type = 31
        ,column = 3          
        ,name = language:get(<<"帮会福利提升到15级">>)
        ,fund = 500
        ,items = [{27000,1,10}]
        ,subject = language:get(<<"完成帮会目标“帮会福利提升到15级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会福利提升到15级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(40) ->
    #guild_aim_data{
        type = 40
        ,column = 3          
        ,name = language:get(<<"帮会神炉提升到7级">>)
        ,fund = 500
        ,items = [{21020,1,1}]
        ,subject = language:get(<<"完成帮会目标“帮会神炉提升到7级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会神炉提升到7级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(41) ->
    #guild_aim_data{
        type = 41
        ,column = 3          
        ,name = language:get(<<"帮会神炉提升到15级">>)
        ,fund = 2000
        ,items = [{21020,1,3}]
        ,subject = language:get(<<"完成帮会目标“帮会神炉提升到15级”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“帮会神炉提升到15级”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(50) ->
    #guild_aim_data{
        type = 50
        ,column = 3          
        ,name = language:get(<<"招募30个帮会成员">>)
        ,fund = 200
        ,items = [{30023,1,5}]
        ,subject = language:get(<<"完成帮会目标“招募30个帮会成员”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“招募30个帮会成员”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(51) ->
    #guild_aim_data{
        type = 51
        ,column = 3          
        ,name = language:get(<<"招募40个帮会成员">>)
        ,fund = 300
        ,items = [{30023,1,20}]
        ,subject = language:get(<<"完成帮会目标“招募40个帮会成员”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“招募40个帮会成员”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(52) ->
    #guild_aim_data{
        type = 52
        ,column = 3          
        ,name = language:get(<<"招募50个帮会成员">>)
        ,fund = 400
        ,items = [{30023,1,50}]
        ,subject = language:get(<<"完成帮会目标“招募50个帮会成员”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“招募50个帮会成员”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(53) ->
    #guild_aim_data{
        type = 53
        ,column = 3          
        ,name = language:get(<<"招募60个帮会成员">>)
        ,fund = 500
        ,items = [{30023,1,99}]
        ,subject = language:get(<<"完成帮会目标“招募60个帮会成员”奖励">>)
        ,text = language:get(<<"在帮会全体兄弟姐妹的努力下，帮会日益发展壮大，终于达成了“招募60个帮会成员”的目标！帮会全体成员共同获得了该目标的奖励，请再接再厉！">>)
    };

get(_) ->
    #guild_aim_data{
        type = 0
        ,column = 0          
        ,name = <<>>
        ,fund = 0
        ,items = []
        ,subject = <<>>
        ,text = <<>>
    }.
