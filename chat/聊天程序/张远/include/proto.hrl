%%普通用户请求协议
-define(RE_REGISTER,						10000). %%用户注册
-define(RE_LOGIN,							11000).	%%用户登录
-define(RE_SELECT_ROOM,						12000).	%%选择聊天室
-define(RE_SENDMSG,						    13000).	%%发送消息
-define(RE_LEAVE_ROOM,						14000).	%%离开房间
-define(RE_LOGOUT,							15000).	%%用户退出聊天

%%管理员请求协议
-define(RE_ADD_ROOM,						16000). %%管理员增加聊天室
-define(RE_DELETE_ROOM,						17000).	%%管理员删除聊天室

%%客户端请求回复
-define(RE_REGISTER_REPLY,					50000). %%注册返回
-define(RE_LOGIN_REPLY,						51000).	%%登录返回
-define(RE_SELECT_ROOM_REPLY,				52000).	%%选择房间返回
-define(RE_BROADCAST_MSG,					53000).	%%广播消息
-define(RE_LEAVE_ROOM_REPLY,				54000).	%%离开房间返回
-define(RE_DISCONNECT,						55000).	%%断开连接
-define(RE_NEW_ADDED_ROOM_NAME,				56000).	%%新增房间返回
-define(RE_NEW_DELETED_ROOM_NAME,			57000).	%%删除房间返回
