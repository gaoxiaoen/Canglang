#!/bin/bash
## setting/common.config
grep "server_name" $1 | awk -F"," '{print $2}' | awk -F\" '{print $2}'