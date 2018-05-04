%%----------------------------------------------------
%% 排行榜奖励数据
%% @author whjing2012@game.com
%%----------------------------------------------------
-module(rank_data_reward).
-export([get/3]).
-include("rank.hrl").

%% 排行榜奖励数据
% get(open_srv, 0, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 1
%             ,items = [{26060,1,1},{25021,1,1},{22202,1,4}]
%             ,assets = [{3,888}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第1名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 2
%             ,items = [{26040,1,1},{25021,1,1}]
%             ,assets = [{3,500}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第2名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 3
%             ,items = [{26020,1,1},{25021,1,1}]
%             ,assets = [{3,500}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第3名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 4) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 4
%             ,items = [{25021,1,1}]
%             ,assets = [{3,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第4名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 5) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 5
%             ,items = [{25021,1,1}]
%             ,assets = [{3,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第5名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 6) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 6
%             ,items = []
%             ,assets = [{3,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第6名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 7) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 7
%             ,items = []
%             ,assets = [{3,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第7名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 8) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 8
%             ,items = []
%             ,assets = [{3,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第8名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 9) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 9
%             ,items = []
%             ,assets = [{3,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第9名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 0, 10) ->
%     {ok, #rank_reward_base{
%             rtype = 0
%             ,sort = 10
%             ,items = []
%             ,assets = [{3,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中获得全服等级排行第10名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 9, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 9
%             ,sort = 1
%             ,items = [{23003,1,5},{23012,1,5},{23006,1,5}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中仙宠战斗力排行第1名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 9, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 9
%             ,sort = 2
%             ,items = [{23003,1,3},{23012,1,3},{23006,1,3}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中仙宠战斗力排行第2名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 9, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 9
%             ,sort = 3
%             ,items = [{23003,1,2},{23012,1,2},{23006,1,2}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中仙宠战斗力排行第3名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 1
%             ,items = [{26062,1,1},{30210,1,10}]
%             ,assets = [{2,1000}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第1名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 2
%             ,items = [{26042,1,1},{30210,1,5}]
%             ,assets = [{2,800}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第2名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 3
%             ,items = [{26022,1,1},{30210,1,3}]
%             ,assets = [{2,500}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第3名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 4) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 4
%             ,items = []
%             ,assets = [{2,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第4名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 5) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 5
%             ,items = []
%             ,assets = [{2,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第5名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 6) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 6
%             ,items = []
%             ,assets = [{2,200}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第6名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 7) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 7
%             ,items = []
%             ,assets = [{2,200}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第7名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 8) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 8
%             ,items = []
%             ,assets = [{2,200}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第8名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 9) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 9
%             ,items = []
%             ,assets = [{2,200}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第9名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 98, 10) ->
%     {ok, #rank_reward_base{
%             rtype = 98
%             ,sort = 10
%             ,items = []
%             ,assets = [{2,200}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人综合战斗力排行第10名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 5, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 5
%             ,sort = 1
%             ,items = [{25021,1,1}]
%             ,assets = [{3,888}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人成就排行第1名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 5, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 5
%             ,sort = 2
%             ,items = []
%             ,assets = [{3,500}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人成就排行第2名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 5, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 5
%             ,sort = 3
%             ,items = []
%             ,assets = [{3,300}]
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中个人成就排行第3名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 33, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 33
%             ,sort = 1
%             ,items = [{26064,1,1},{21012,1,3},{24111,1,1},{24102,1,1},{24108,1,1},{24124,1,1}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中仙法竞技击败数排行排行第1名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 33, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 33
%             ,sort = 2
%             ,items = [{26044,1,1},{21012,1,3},{24110,1,1},{24101,1,1},{24107,1,1}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中仙法竞技击败数排行排行第2名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 33, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 33
%             ,sort = 3
%             ,items = [{26044,1,1},{21012,1,1}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中仙法竞技击败数排行排行第3名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 20, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 20
%             ,sort = 1
%             ,items = [{30020,1,99}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中帮会等级排行第1名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 20, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 20
%             ,sort = 2
%             ,items = [{30020,1,66}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中帮会等级排行第2名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(open_srv, 20, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 20
%             ,sort = 3
%             ,items = [{30020,1,33}]
%             ,assets = []
%             ,subject = language:get(<<"开服活动奖励">>)
%             ,content = language:get(<<"恭喜您在新服冲级活动中帮会等级排行第3名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };



% get(merge_srv, 11, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 11
%             ,sort = 1
%             ,items = [{22203,1,3},{27003,1,8}]
%             ,assets = []
%             ,subject = language:get(<<"合服活动奖励">>)
%             ,content = language:get(<<"恭喜您在合服活动中获得全服武器排行第1名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };
% get(merge_srv, 11, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 11
%             ,sort = 2
%             ,items = [{22203,1,2},{27003,1,4}]
%             ,assets = []
%             ,subject = language:get(<<"合服活动奖励">>)
%             ,content = language:get(<<"恭喜您在合服活动中获得全服武器排行第2名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };
% get(merge_srv, 11, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 11
%             ,sort = 3
%             ,items = [{22203,1,1},{27003,1,2}]
%             ,assets = []
%             ,subject = language:get(<<"合服活动奖励">>)
%             ,content = language:get(<<"恭喜您在合服活动中获得全服武器排行第3名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };
% get(merge_srv, 12, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 12
%             ,sort = 1
%             ,items = [{27003,1,10}]
%             ,assets = []
%             ,subject = language:get(<<"合服活动奖励">>)
%             ,content = language:get(<<"恭喜您在合服活动中获得全服防具排行第1名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };
% get(merge_srv, 12, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 12
%             ,sort = 2
%             ,items = [{27003,1,8}]
%             ,assets = []
%             ,subject = language:get(<<"合服活动奖励">>)
%             ,content = language:get(<<"恭喜您在合服活动中获得全服防具排行第2名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };
% get(merge_srv, 12, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 12
%             ,sort = 3
%             ,items = [{27003,1,6}]
%             ,assets = []
%             ,subject = language:get(<<"合服活动奖励">>)
%             ,content = language:get(<<"恭喜您在合服活动中获得全服防具排行第3名，特此发放您的奖励，请注意查收，祝您在飞仙的旅途上开心顺利！">>)
%         }
%     };

% get(normal, 52, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 1
%             ,items = [{29234, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第1名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 2
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第2名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 3
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第3名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 4) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 4
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第4名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 5) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 5
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第5名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 6) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 6
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第6名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 7) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 7
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第7名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 8) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 8
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第8名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 9) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 9
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第9名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 52, 10) ->
%     {ok, #rank_reward_base{
%             rtype = 52
%             ,sort = 10
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"飞仙情圣排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服飞仙情圣榜第10名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 1) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 1
%             ,items = [{29234, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第1名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 2) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 2
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第2名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 3) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 3
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第3名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 4) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 4
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第4名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 5) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 5
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第5名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 6) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 6
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第6名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 7) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 7
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第7名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 8) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 8
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第8名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 9) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 9
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第9名，获得魅力礼包1个">>)
%         }
%     };

% get(normal, 62, 10) ->
%     {ok, #rank_reward_base{
%             rtype = 62
%             ,sort = 10
%             ,items = [{29233, 1, 1}]
%             ,assets = []
%             ,subject = language:get(<<"鲜花宝贝排名奖励">>)
%             ,content = language:get(<<"恭喜您荣登跨服鲜花宝贝榜第10名，获得魅力礼包1个">>)
%         }
%     };

get(_, _, _) -> false.
