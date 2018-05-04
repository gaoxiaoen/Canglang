####################################################################
## @author Administrator
## @datetime 2010-05-30
## @description beam文件被放在ebin下或者ebin子目录下，所以启动时要
##				注意-pa参数是否设置正确
##
####################################################################

##指定当前项目在svn仓库中的名字
APP_NAME := world
SRC_DIRS := src/mission/b_mission_model.erl src/*.erl src/hook/*.erl src/mod/*.erl src/ranking/*.erl src/server/*.erl src/mission/*.erl src/family/*.erl src/team/*.erl
include ../../../hrl/include.mk


##使用通配符方式指定每个文件的编译规则
$(EBIN_DIR)/b_mission_model.$(EMULATOR): $(hrl) src/mission/b_mission_model.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<
	
$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/%.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<
	
$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/mod/%.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<
	
$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/hook/%.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<
	
$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/ranking/%.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<
	
$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/server/%.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<
	
$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/mission/%.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<
	
$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/family/%.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/team/%.erl 
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<