#!/bin/bash
## setting/common.config
grep "game_name" $1 | awk -F"," '{print $2}' | awk -F\" '{print $2}'