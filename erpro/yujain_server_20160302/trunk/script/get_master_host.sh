#!/bin/bash
## setting/common.config
grep "master_host" $1 | awk -F"," '{print $2}' | awk -F\" '{print $2}'