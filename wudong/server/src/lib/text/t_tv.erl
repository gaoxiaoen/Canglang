%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 12. 三月 2015 14:38
%%%-------------------------------------------------------------------
-module(t_tv).
-author("fzl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("pet.hrl").
-include("mount.hrl").
-include("fashion.hrl").
-include("wing.hrl").
-include("notice.hrl").

%%---颜色
%%---0白 1绿 2蓝 3紫 4橙 5红 6黑 7灰 8粉 9屎黄 10背景 11黄色

%%--超链接类型 注意要和 base_notice_sys 配置表上的类型同步
%%--1变色 2物品 3装备 4坐标 7任务 8人物 11羽翼 22首充返还 34王城守卫 35帮派红包 36护送 37六龙争霸 38答题
%% 40五倍经验挂机点 41vip 42充值 43仙盟 44 跨服1v1
%% API
-compile(export_all).

%%格式化颜色
cl(Content, Color) ->
    io_lib:format("[#$a type=1 color=~p]~s[#$/a]", [Color, util:to_list(Content)]).

%%格式化装备名字
eq(Goods) ->
    #goods{
        key = Key,
        goods_id = GoodsId
    } = Goods,
    BaseGoods = data_goods:get(GoodsId),
    #goods_type{
        goods_name = Name,
        color = Color
    } = BaseGoods,
    io_lib:format("[#$a type=3 color=~p id=~p]~s[#$/a]", [Color, Key, util:to_list(Name)]).

%%格式化坐标
xy(SceneId, X, Y, Content) ->
    io_lib:format("[#$a type=4 color=4 sid=~p posX=~p posY=~p]~s[#$/a]", [SceneId, X, Y, Content]).

%%格式化玩家名字
pn(Player) ->
    #player{
        key = Pkey,
        vip_lv = Vip,
        nickname = Name
    } = Player,
    io_lib:format("[#$a type=8 color=1 id=~p vip=~p]~s[#$/a]", [Pkey, Vip, util:to_list(Name)]).

%% 送花
sh(Player, String) ->
    #player{
        key = Pkey,
        vip_lv = Vip,
        nickname = Name
    } = Player,
    io_lib:format("[#$a type=57 color=1 id=~p vip=~p nickname=~s]~s[#$/a]", [Pkey, Vip, util:to_list(Name), util:to_list(String)]).

%% 关注
gz(Player, String) ->
    #player{
        key = Pkey,
        vip_lv = Vip,
        nickname = Name
    } = Player,
    io_lib:format("[#$a type=58 color=1 id=~p vip=~p nickname=~s]~s[#$/a]", [Pkey, Vip, util:to_list(Name), util:to_list(String)]).

%%格式化翅膀名字
wg(FashionId) ->
    BaseFashion = data_wing:get(FashionId),
    #base_wing{
        name = Name
    } = BaseFashion,
    io_lib:format("[#$a type=11 color=~p id=~p]~s[#$/a]", [4, FashionId, util:to_list(Name)]).

%%跨服副本
dun_cross(Content, DunId, Key, Password, Type) ->
    io_lib:format("[#$a type=16 color=4 argc=~p#~p#~s#~p]~s[#$/a]", [Key, DunId, Password, Type, util:to_list(Content)]).

guild(Gkey, Gname) ->
    io_lib:format("[#$a type=43 color=1 id=~p]~s[#$/a]", [Gkey, Gname]).

gn(GoodsId) ->
    BaseGoods = data_goods:get(GoodsId),
    #goods_type{
        goods_name = Name,
        color = Color
    } = BaseGoods,
    Flag = lists:member(GoodsId, [7401019, 7401020, 7401021, 7401022, 7401023, 7401024, 7402019, 7402020, 7402021, 7402022, 7402023, 7402024, 7403019, 7403020, 7403021, 7403022, 7403023, 7403024, 7404019, 7404020, 7404021, 7404022, 7404023, 7404024, 7415006, 7415007, 7415008, 7415009, 7405006, 7405007]),
    if
        Flag == true -> %% 飞仙相关道具特殊处理
            io_lib:format("[#$a type=78 color=~p ]~s[#$/a]", [Color, util:to_list(Name)]);
        true ->
            io_lib:format("[#$a type=2 color=~p id=~p]~s[#$/a]", [Color, GoodsId, util:to_list(Name)])
    end.

%%获取广播文本
get(Type) ->
    case data_notice_sys:get(Type) of
        [] -> "";
        BaseNotice -> BaseNotice#base_notice.content
    end.
