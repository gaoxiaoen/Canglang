%%----------------------------------------------------
%% 地图元素数据
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(map_data_elem).
-export([get/1]).
-include("common.hrl").
-include("map.hrl").
-include("gain.hrl").
-include("condition.hrl").
get(101) ->
	#map_elem{
		base_id = 101
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 101}]
	};
get(102) ->
	#map_elem{
		base_id = 102
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 102}]
	};
get(103) ->
	#map_elem{
		base_id = 103
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 103}]
	};
get(104) ->
	#map_elem{
		base_id = 104
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 104}]
	};
get(105) ->
	#map_elem{
		base_id = 105
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 105}]
	};
get(106) ->
	#map_elem{
		base_id = 106
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 106}]
	};
get(107) ->
	#map_elem{
		base_id = 107
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 107}]
	};
get(108) ->
	#map_elem{
		base_id = 108
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 108}]
	};
get(109) ->
	#map_elem{
		base_id = 109
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 109}]
	};
get(110) ->
	#map_elem{
		base_id = 110
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 110}]
	};
get(111) ->
	#map_elem{
		base_id = 111
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 111}]
	};
get(112) ->
	#map_elem{
		base_id = 112
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 112}]
	};
get(113) ->
	#map_elem{
		base_id = 113
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 113}]
	};
get(114) ->
	#map_elem{
		base_id = 114
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 114}]
	};
get(115) ->
	#map_elem{
		base_id = 115
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 115}]
	};
get(116) ->
	#map_elem{
		base_id = 116
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 116}]
	};
get(117) ->
	#map_elem{
		base_id = 117
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 117}]
	};
get(118) ->
	#map_elem{
		base_id = 118
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 118}]
	};
get(119) ->
	#map_elem{
		base_id = 119
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 119}]
	};
get(120) ->
	#map_elem{
		base_id = 120
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 120}]
	};
get(121) ->
	#map_elem{
		base_id = 121
		,type = 2
		,name = <<"神秘宝箱">>
		,trigger_status = 0
			,data = [#map_elem_event{label = hide_box, value = 121}]
	};
get(_) ->
    false.

