%%----------------------------------------------------
%%  奖励
%% @author  qingxuan
%%----------------------------------------------------

-record(award, {
    id
    ,base_id        %% 基础id
    ,hidden = 0  %% 是否显示在奖励大厅, ?true , ?false
    ,title          %% 标题
    ,content        %% 信件内容
    ,gains          %% 奖励内容
}).

-record(base_award, {
    id
    ,hidden = 0  %% 是否显示在奖励大厅, ?true , ?false
    ,title
    ,gains = []
    ,limit = 99
}).


-record(adventure_dungeon, {
    dungeon_id          = 0,        %% 副本id
    max                 = 0,        %% 每日
    must                = 0,        %% 首通是否必须
    hole_weight         = 0,        %% 洞穴概率
    clear_weight        = 0,        %% 扫荡概率
    hole_id             = 0         %% 洞穴id
    }).

-record(adventure_hole, {
        hole_id         = 0,        %%　洞穴id
        account_num     = {0, 0},    %% 遭遇次数区间
        barrier_wei     = 0,
        barrier_awd     = [],
        npc_wei         = 0,
        npc_awd         = [],
        item_wei        = 0,
        item_awd        = [],
        box_wei         = 0,
        box_awd         = [],
        box_max         = 0
    }).

%%角色奇遇事件
-record(adventure_event, {
        id              = 0,        %% 时间id
        hole_id         = 0,        %% 洞穴id
        expire          = 0         %% 有效截止时间
    }).
