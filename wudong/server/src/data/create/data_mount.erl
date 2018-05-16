%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_mount
	%%% @Created : 2018-04-28 12:18:25
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_mount).
-export([get/1]).
-export([get_speed/1]).
-include("error_code.hrl").
-include("mount.hrl").
-include("common.hrl").
get(100001) -> #base_mount{mount_id = 100001 ,icon_id = 11001 ,name = ?T("踏风驹") ,is_special = 0 ,image_id = 10001 ,sword_image = 1 ,speed = 40 ,unlock_condition = 1 ,is_double = 0 ,is_showpic = 0};
get(100002) -> #base_mount{mount_id = 100002 ,icon_id = 11001 ,name = ?T("幽冥狼") ,is_special = 0 ,image_id = 10002 ,sword_image = 2 ,speed = 45 ,unlock_condition = 2 ,is_double = 0 ,is_showpic = 0};
get(100003) -> #base_mount{mount_id = 100003 ,icon_id = 11001 ,name = ?T("蚩灵鹿") ,is_special = 0 ,image_id = 10003 ,sword_image = 3 ,speed = 50 ,unlock_condition = 3 ,is_double = 0 ,is_showpic = 0};
get(100004) -> #base_mount{mount_id = 100004 ,icon_id = 11001 ,name = ?T("陷地夔") ,is_special = 0 ,image_id = 10004 ,sword_image = 4 ,speed = 55 ,unlock_condition = 4 ,is_double = 0 ,is_showpic = 0};
get(100005) -> #base_mount{mount_id = 100005 ,icon_id = 11001 ,name = ?T("赤铜狰") ,is_special = 0 ,image_id = 10005 ,sword_image = 5 ,speed = 60 ,unlock_condition = 5 ,is_double = 0 ,is_showpic = 0};
get(100006) -> #base_mount{mount_id = 100006 ,icon_id = 11001 ,name = ?T("蹈海玄武") ,is_special = 0 ,image_id = 10006 ,sword_image = 6 ,speed = 65 ,unlock_condition = 6 ,is_double = 0 ,is_showpic = 0};
get(100007) -> #base_mount{mount_id = 100007 ,icon_id = 11001 ,name = ?T("幻天丹狐") ,is_special = 0 ,image_id = 10007 ,sword_image = 7 ,speed = 70 ,unlock_condition = 7 ,is_double = 0 ,is_showpic = 0};
get(100008) -> #base_mount{mount_id = 100008 ,icon_id = 11001 ,name = ?T("赤焰獬豸") ,is_special = 0 ,image_id = 10008 ,sword_image = 8 ,speed = 75 ,unlock_condition = 8 ,is_double = 0 ,is_showpic = 0};
get(100009) -> #base_mount{mount_id = 100009 ,icon_id = 11001 ,name = ?T("霜狱狻猊") ,is_special = 0 ,image_id = 10009 ,sword_image = 9 ,speed = 75 ,unlock_condition = 9 ,is_double = 0 ,is_showpic = 0};
get(100010) -> #base_mount{mount_id = 100010 ,icon_id = 11001 ,name = ?T("九玄寒凤") ,is_special = 0 ,image_id = 10010 ,sword_image = 10 ,speed = 80 ,unlock_condition = 10 ,is_double = 0 ,is_showpic = 0};
get(100011) -> #base_mount{mount_id = 100011 ,icon_id = 11001 ,name = ?T("九玄寒凤") ,is_special = 0 ,image_id = 10011 ,sword_image = 11 ,speed = 80 ,unlock_condition = 11 ,is_double = 0 ,is_showpic = 0};
get(100012) -> #base_mount{mount_id = 100012 ,icon_id = 11001 ,name = ?T("天泽幻雪狐") ,is_special = 0 ,image_id = 10012 ,sword_image = 12 ,speed = 80 ,unlock_condition = 12 ,is_double = 0 ,is_showpic = 0};
get(100021) -> #base_mount{mount_id = 100021 ,icon_id = 10001 ,name = ?T("神兽拓拓") ,is_special = 1 ,image_id = 10021 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100022) -> #base_mount{mount_id = 100022 ,icon_id = 10002 ,name = ?T("渔人企鹅") ,is_special = 1 ,image_id = 10022 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100023) -> #base_mount{mount_id = 100023 ,icon_id = 10003 ,name = ?T("功夫胖达") ,is_special = 1 ,image_id = 10023 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100024) -> #base_mount{mount_id = 100024 ,icon_id = 10004 ,name = ?T("仙境花鸾（双人）") ,is_special = 1 ,image_id = 10024 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 1 ,is_showpic = 1};
get(100025) -> #base_mount{mount_id = 100025 ,icon_id = 10005 ,name = ?T("荒神海龙") ,is_special = 1 ,image_id = 10025 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100026) -> #base_mount{mount_id = 100026 ,icon_id = 10006 ,name = ?T("长生彩葫") ,is_special = 1 ,image_id = 10026 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100027) -> #base_mount{mount_id = 100027 ,icon_id = 10007 ,name = ?T("广寒玉兔") ,is_special = 1 ,image_id = 10027 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100028) -> #base_mount{mount_id = 100028 ,icon_id = 10008 ,name = ?T("圣夜行舟") ,is_special = 1 ,image_id = 10028 ,sword_image = 2 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100029) -> #base_mount{mount_id = 100029 ,icon_id = 10009 ,name = ?T("司晨星君") ,is_special = 1 ,image_id = 10029 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100030) -> #base_mount{mount_id = 100030 ,icon_id = 10010 ,name = ?T("圣诞麋鹿") ,is_special = 1 ,image_id = 10030 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100031) -> #base_mount{mount_id = 100031 ,icon_id = 10011 ,name = ?T("锦鲤金鳞") ,is_special = 1 ,image_id = 10031 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100032) -> #base_mount{mount_id = 100032 ,icon_id = 10012 ,name = ?T("狮王争霸") ,is_special = 1 ,image_id = 10032 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100033) -> #base_mount{mount_id = 100033 ,icon_id = 10013 ,name = ?T("独角金仙") ,is_special = 1 ,image_id = 10033 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100034) -> #base_mount{mount_id = 100034 ,icon_id = 10014 ,name = ?T("风驰电掣") ,is_special = 1 ,image_id = 10034 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(100035) -> #base_mount{mount_id = 100035 ,icon_id = 10015 ,name = ?T("血红梦魇") ,is_special = 1 ,image_id = 10035 ,sword_image = 4 ,speed = 75 ,unlock_condition = 20161 ,is_double = 0 ,is_showpic = 1};
get(_Data) -> [].
get_speed(100001) -> 40;
get_speed(1) -> 40;
get_speed(100002) -> 45;
get_speed(2) -> 75;
get_speed(100003) -> 50;
get_speed(3) -> 50;
get_speed(100004) -> 55;
get_speed(4) -> 75;
get_speed(100005) -> 60;
get_speed(5) -> 60;
get_speed(100006) -> 65;
get_speed(6) -> 65;
get_speed(100007) -> 70;
get_speed(7) -> 70;
get_speed(100008) -> 75;
get_speed(8) -> 75;
get_speed(100009) -> 75;
get_speed(9) -> 75;
get_speed(100010) -> 80;
get_speed(10) -> 80;
get_speed(100011) -> 80;
get_speed(11) -> 80;
get_speed(100012) -> 80;
get_speed(12) -> 80;
get_speed(100021) -> 75;
get_speed(100022) -> 75;
get_speed(100023) -> 75;
get_speed(100024) -> 75;
get_speed(100025) -> 75;
get_speed(100026) -> 75;
get_speed(100027) -> 75;
get_speed(100028) -> 75;
get_speed(100029) -> 75;
get_speed(100030) -> 75;
get_speed(100031) -> 75;
get_speed(100032) -> 75;
get_speed(100033) -> 75;
get_speed(100034) -> 75;
get_speed(100035) -> 75;
get_speed(_) -> 0.
