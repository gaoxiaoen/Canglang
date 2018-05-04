%%----------------------------------------------------
%% 右下角信息转换函数
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(notice_inform).
-export([gain_loss/2]).

-include("common.hrl").
-include("gain.hrl").
%%

%% #gain{} #loss{} 数据转换
%% @spec gain_loss(GLs, Str) -> NewStr.
%% GLs = [#gain{}, #loss{}...]
%% Str = <<>> | <<"领取信件">> | <<"提交任务">>
%% NewStr = binary()
gain_loss([], Str) -> Str;
% gain_loss([#gain{label = coin, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n获得 {str,金币,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = coin, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,金币,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = coin_all, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,金币,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#gain{label = coin_bind, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n获得 {str,绑定金币,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = coin_bind, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,绑定金币,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#gain{label = gold, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n获得 {str,晶钻,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = gold, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,晶钻,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#gain{label = gold_bind, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n获得 {str,绑定晶钻,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = gold_bind, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,绑定晶钻,#FFD700} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#gain{label = arena, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n获得 {str,竞技场积分,#2fecdc} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = arena, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,竞技场积分,#2fecdc} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#gain{label = exp, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n获得 {str,经验,#00ff24} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = exp, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,经验,#00ff24} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#gain{label = charm, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n获得 {str,魅力,#00ff24} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#loss{label = charm, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n扣除 {str,魅力,#00ff24} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#gain{label = psychic, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n获得 {str,灵力,#3ad6f0} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#loss{label = psychic, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n扣除 {str,灵力,#3ad6f0} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#gain{label = attainment, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n获得 {str,阅历,#f65e6a} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = attainment, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,阅历,#f65e6a} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#gain{label = achievement, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n获得 {str,成就,#2fecdc} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#loss{label = achievement, val = Val} | T], Str) when Val > 0 ->
%     NStr = util:fbin(?L(<<"\n扣除 {str,成就,#2fecdc} ~p">>), [Val]),
%     gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#gain{label = guild_war, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n获得 {str,帮战积分,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#loss{label = guild_war, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n扣除 {str,帮战积分,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#gain{label = guild_devote, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n获得 {str,帮会贡献,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#loss{label = guild_devote, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n扣除 {str,帮会贡献,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#gain{label = career_devote, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n获得 {str,师门积分,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#loss{label = career_devote, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n扣除 {str,师门积分,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#gain{label = lilian, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n获得 {str,仙道历练,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#loss{label = lilian, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n扣除 {str,仙道历练,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#gain{label = practice, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n获得 {str,试练积分,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
gain_loss([#loss{label = practice, val = Val} | T], Str) when Val > 0 ->
    NStr = util:fbin(?L(<<"\n扣除 {str,试练积分,#2fecdc} ~p">>), [Val]),
    gain_loss(T, <<Str/binary, NStr/binary>>);
% gain_loss([#gain{label = item, val = [BaseId, Bind, Num]} | T], Str) ->
%     case item:make(BaseId, Bind, Num) of
%         {ok, Items} ->
%             NStr = util:fbin(?L(<<"\n获得 ~s">>), [notice:item3_to_inform(Items)]),
%             gain_loss(T, <<Str/binary, NStr/binary>>);
%         _ ->
%             gain_loss(T, Str)
%     end;
% gain_loss([#loss{label = item, val = [BaseId, Bind, Num]} | T], Str) ->
%     case item:make(BaseId, Bind, Num) of
%         {ok, Items} ->
%             NStr = util:fbin(?L(<<"\n扣除 ~s">>), [notice:item3_to_inform(Items)]),
%             gain_loss(T, <<Str/binary, NStr/binary>>);
%         _ ->
%             gain_loss(T, Str)
%     end;
gain_loss([_ | T], Str) ->
    gain_loss(T, Str).
