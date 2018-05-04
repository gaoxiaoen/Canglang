-module(guild_jingpai).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").

-export(
    [
        add_item/2          %% 增加竞拍物品
        ,all_item/1          %% 查询所有竞拍物品
        ,jingpai/0          %% 出价竞拍
        ,giveup_item/0      %% 放弃竞拍

        %% 回调函数
        ,async_add_item/2
        ,sync_get_item/1
    ]
).



add_item(#role{guild = #role_guild{pid = GuildPid}}, ItemList) when is_pid(GuildPid), is_list(ItemList) ->
    guild:apply(async, GuildPid, {?MODULE, async_add_item, [ItemList]});
add_item(_R, _ItemList) ->
    false.

all_item(#role{guild = #role_guild{pid = GuildPid}}) when is_pid(GuildPid) ->
    case guild:apply(sync, GuildPid, {?MODULE, sync_get_item, []}) of
        Items when is_list(Items) ->
            Items;
        _ ->
            error
    end.

jingpai() ->
    ok.

giveup_item() ->
    ok.

async_add_item(Guild = #guild{jingpai = Jingpai = #jingpai{items = _Items}}, ItemList) ->
    Jingpai1 = do_add_item(ItemList, Jingpai),
    Guild1 = Guild#guild{jingpai = Jingpai1},
    {ok, Guild1}.

do_add_item([], Jingpai) -> Jingpai;
do_add_item([Item = {_BaseId, _Bind, _Num} | T], Jingpai = #jingpai{next_id = NextId, items = Items}) ->
    Items1 = [#jingpai_item{id = NextId, item = Item, birthday = util:unixtime(), status = ?JINGPAI_IDLE} | Items],
    do_add_item(T, Jingpai#jingpai{next_id = NextId + 1, items = Items1}).

sync_get_item(#guild{jingpai = #jingpai{items = Items}}) ->
    Items.

