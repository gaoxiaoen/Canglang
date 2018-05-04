
-module(stone_data).
-export([
        lev/1
        ,type/1
        ,item_type_to_inlay_stone_type/2
    ]
).


type(111201) -> 1		;
type(111202) -> 1		;
type(111203 ) -> 1		;
type(111204) -> 1		;
type(111205) -> 1		;
type(111206) -> 1		;
type(111207) -> 1		;
type(111208) -> 1		;
type(111209) -> 1		;
type(111211) -> 2		;
type(111212) -> 2		;
type(111213 ) -> 2		;
type(111214) -> 2		;
type(111215) -> 2		;
type(111216) -> 2		;
type(111217) -> 2		;
type(111218) -> 2		;
type(111219) -> 2		;
type(111221) -> 3		;
type(111222) -> 3		;
type(111223 ) -> 3		;
type(111224) -> 3		;
type(111225) -> 3		;
type(111226) -> 3		;
type(111227) -> 3		;
type(111228) -> 3		;
type(111229) -> 3		;
type(111231) -> 4		;
type(111232) -> 4		;
type(111233 ) -> 4		;
type(111234) -> 4		;
type(111235) -> 4		;
type(111236) -> 4		;
type(111237) -> 4		;
type(111238) -> 4		;
type(111239) -> 4		;
type(111241) -> 5		;
type(111242) -> 5		;
type(111243 ) -> 5		;
type(111244) -> 5		;
type(111245) -> 5		;
type(111246) -> 5		;
type(111247) -> 5		;
type(111248) -> 5		;
type(111249) -> 5		;
type(111251) -> 6		;
type(111252) -> 6		;
type(111253 ) -> 6		;
type(111254) -> 6		;
type(111255) -> 6		;
type(111256) -> 6		;
type(111257) -> 6		;
type(111258) -> 6		;
type(111259) -> 6		;
type(111261) -> 7		;
type(111262) -> 7		;
type(111263 ) -> 7		;
type(111264) -> 7		;
type(111265) -> 7		;
type(111266) -> 7		;
type(111267) -> 7		;
type(111268) -> 7		;
type(111269) -> 7		;
type(111271) -> 8		;
type(111272) -> 8		;
type(111273 ) -> 8		;
type(111274) -> 8		;
type(111275) -> 8		;
type(111276) -> 8		;
type(111277) -> 8		;
type(111278) -> 8		;
type(111279) -> 8		;
type(_BaseId) -> false.

%% 宝石等级
%% 已经没用了，兼容在这
lev(_BaseId) -> 0.

%% 宝石镶嵌数据
item_type_to_inlay_stone_type(Type, StoneType) ->
    {A, B, C} = item_type_to_inlay_stone_type(StoneType),
    case Type of
        default -> A;
        eight -> B;
        ten -> C;
        _ -> []
    end.
item_type_to_inlay_stone_type(10) -> {[2,4,5], [2,4,5], [2,4,5]};
item_type_to_inlay_stone_type(11) -> {[1,3,6,7], [1,3,7], [1,3,7]};
item_type_to_inlay_stone_type(12) -> {[1,3,6,7], [1,3,7], [1,3,7]};
item_type_to_inlay_stone_type(13) -> {[1,3,6,7], [1,3,7], [1,3,7]};
item_type_to_inlay_stone_type(14) -> {[1,3,6,7], [1,3,7], [1,3,7]};
item_type_to_inlay_stone_type(15) -> {[1,3,6,7], [1,3,7], [1,3,7]};
item_type_to_inlay_stone_type(16) -> {[1,3,6,7], [1,3,7], [1,3,7]};
item_type_to_inlay_stone_type(17) -> {[2,4,5,8], [2,4,8], [2,4,8]};
item_type_to_inlay_stone_type(18) -> {[2,4,5,8], [2,4,8], [2,4,8]};
item_type_to_inlay_stone_type(19) -> {[2,4,5,8], [2,4,8], [2,4,8]};
item_type_to_inlay_stone_type(_) -> {[], [], []}.


