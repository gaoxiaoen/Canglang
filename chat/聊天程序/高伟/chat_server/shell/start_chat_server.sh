#!/bin/bash
cd ../ebin
erl -name chat_server@127.0.0.1 -setcookie 123456  -boot start_sasl  -s server chat_server_start -extra 127.0.0.1 6666 1