#!/bin/bash
bsc -sim -g mkTest_Stage_1 -u Stage_1_tb.bsv&&bsc -sim -e mkTest_Stage_1&&./a.out