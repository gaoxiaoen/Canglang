####################################################################
## @author Administrator
## @datetime 2010-05-30
## @description beam文件被放在ebin下或者ebin子目录下，所以启动时要
##				注意-pa参数是否设置正确
##
####################################################################


##指定当前项目在svn仓库中的名字
APP_NAME := common
SRC_DIRS := src/gen_server2.erl src/*.erl src/mod/*.erl src/core/*.erl src/library/json/*.erl src/library/*.erl src/library/mysql/*.erl
include ../../../hrl/include.mk


##使用通配符方式指定每个文件的编译规则
$(EBIN_DIR)/gen_server2.$(EMULATOR): $(hrl) src/gen_server2.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/%.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/mod/%.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/core/%.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/library/%.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/library/json/%.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

$(EBIN_DIR)/%.$(EMULATOR): $(hrl) src/library/mysql/%.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN_DIR) $<

