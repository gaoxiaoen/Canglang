####################################################################
## @author Administrator
## @datetime 2013-11-25
## @description 编译更新脚本
##
####################################################################

SHELL := /bin/bash

.PHONY: all erlang_proto mm_map gen_dict

all:erlang_proto mm_map gen_dict

GAME_PROTO := $(wildcard ../proto/*.proto)

erlang_proto:$(GAME_PROTO)
	@(php build_proto_erlang.php)
  
mm_map:
	@(php build_mm_map.php server)
  
gen_dict:
	@(php build_dict.php)
	