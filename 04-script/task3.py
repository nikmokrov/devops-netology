#!/usr/bin/env python3

import os 
import sys

git_dir = sys.argv[1].rstrip('/') if len(sys.argv) > 1 else '.'
bash_command = ["cd " + git_dir, "git status 2>&1"]
fd = os.popen(' && '.join(bash_command))
result_os = fd.read()
exit_code = fd.close()
if exit_code is not None:
    print ('There is no git repository')
    exit
work_dir = os.popen(bash_command[0] + ' && pwd').read().strip()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:   ', '')
        print(work_dir + '/' + prepare_result.strip())
