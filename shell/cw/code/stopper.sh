#!/bin/bash
kill -9 $(ps aux | grep 'sh radar.sh' | awk '{print $2}') >/dev/null 2>/dev/null
kill -9 $(ps aux | grep '/runner.sh' | awk '{print $2}') >/dev/null 2>/dev/null
