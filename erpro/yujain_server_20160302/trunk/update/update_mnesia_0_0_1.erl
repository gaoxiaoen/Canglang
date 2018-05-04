%%%-------------------------------------------------------------------
%%% File        :update_mnesia_0_0_1.erl
%%%-------------------------------------------------------------------
-module(update_mnesia_0_0_1).

-compile(export_all).

%% ==========================更新脚本保留函数 开始===============================

update() ->
	update_table_structure(),
    update_table_data(),
    ok.

%% 更新数据库结构
transform_table(TableName,TransFun,NewFieldList) ->
    case db_api:transform_table(TableName, ignore, NewFieldList) of
        {atomic, ok} ->
            io:format("transform table [~w]=~w succ.", [TableName,NewFieldList]),
            db_misc:do_each_dirty_read(TableName,TransFun,false),
            ok;
        {aborted,Reason} ->
            io:format("transform table [~w]=~w fail.error=~w", [TableName,NewFieldList,Reason]),
            erlang:throw({error,{transform_table,TableName}})
    end,
    ok.

%% ==========================更新脚本保留函数  结束===============================
%% 更新结构模板
update_table_structure() ->
    HelloTransFun =
        fun(R)->
                case R of
                    {r_hello,UID,NAME,SEX,AGE,TALL,EXT}->
                        NewR = {r_hello,UID,NAME,SEX,AGE,TALL,EXT,"2016-01-01"},
                        db_api:dirty_write(db_hello,NewR),
                        ok;
                    _->
                        ok
                end
        end,
    HelloFields = [uid,name,sex,age,tall,ext,born],
    transform_table(db_hello,HelloTransFun,HelloFields),
    ok.

%% 引入需要操作的记录结构，方便程序操作
-record(p_role_base, {role_id=0,server_id=0,role_name="",account_via="",account_name="",account_type=0,account_status=0,create_time=0,sex=2,skin=undefined,faction_id=0,category=0,exp=0,next_level_exp=0,level=0,family_id=0,family_name="",couple_id=0,couple_name="",team_id=0,is_pay=0,total_gold=0,gold=0,silver=0,coin=0,activity=0,gongxun=0,device_id="",last_device_id="",last_login_ip="",last_login_time=0,last_offline_time=0,total_online_time=0,energy=0}).
%% 更新数据模板
update_table_data() ->
    Add = 100,
    RoleBaseFunc = 
        fun(#p_role_base{total_gold=OldTatalGold,gold=OldGold}=RoleBase) ->
                db_api:dirty_write(db_role_base,RoleBase#p_role_base{is_pay=1,total_gold=OldTatalGold + Add,gold=OldGold + Add}),
                ok
        end,
    db_misc:do_each_dirty_read(db_role_base,RoleBaseFunc,false),
    ok.

