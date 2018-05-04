####################################################################
## @author Administrator
## @datetime 2010-12-03
## @description 公用makefile文件
##
####################################################################

SHELL := /bin/bash
.PHONY: all clean hrl

HERE := $(shell which "$0" 2>/dev/null || echo .)
BASE := $(shell dirname $(HERE))
SHELL_DIR := $(shell cd $(BASE) && pwd)
GAME_NAME := $(shell cd ../../../script/ && bash get_game_name.sh $(SHELL_DIR)/../../../setting/common.config)
AGENT_NAME := $(shell cd ../../../script/ && bash get_agent_name.sh $(SHELL_DIR)/../../../setting/common.config)
SERVER_NAME := $(shell cd ../../../script/ && bash get_server_name.sh $(SHELL_DIR)/../../../setting/common.config)

## ebin 根目录
APP_EBIN_ROOT := /data/games/${GAME_NAME}_$(AGENT_NAME)_$(SERVER_NAME)/server/ebin

ifeq ($(ERL_CMD),)
	ERL := $(shell cd ../../../script/ && bash get_erl_command.sh erl)
	ERLC := $(shell cd ../../../script/ && bash get_erl_command.sh erlc)
else
	ERL := $(ERL_CMD)
	ERLC := $(ERLC_CMD)
endif

EMULATOR := beam

INCLUDE_DIRS := include

EBIN_DIR := $(APP_EBIN_ROOT)/$(APP_NAME)
##指定编译时查找common.doc/trunk/hrl中的文件
ERLC_FLAGS := -Werror -I $(INCLUDE_DIRS) -I ../../../hrl -pa  $(APP_EBIN_ROOT)/common -pa $(EBIN_DIR)
##这里可以通过 make DEBUG=true来达到打开debug_info选项的目的
ifdef DEBUG
  ERLC_FLAGS += +debug_info
endif

ifdef TEST
  ERLC_FLAGS += -DTEST
endif


##所有的erl源码文件
ERL_SOURCES := $(wildcard $(SRC_DIRS))
ERL_SOURCES2 := $(addprefix $(EBIN_DIR)/,$(notdir $(ERL_SOURCES)))
##所有对应的erl beam文件
ERL_OBJECTS := $(ERL_SOURCES2:%.erl=%.$(EMULATOR))
##输出文件
EBIN_FILES = $(ERL_OBJECTS)

all: mk_dir $(EBIN_FILES)

clean:
	(rm -rf $(APP_EBIN_ROOT)/$(APP_NAME)/*)
	
common:
	@(cd ../common;$(MAKE))
	
mk_dir:
	@(mkdir -p $(APP_EBIN_ROOT)/$(APP_NAME)/)
	
debug: clean
	$(MAKE) DEBUG=true
