#!/usr/bin/env python3

import os

bash_command = ["cd ~/DEVOPS-22/Homeworks/02-git-01/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
work_dir = os.popen(bash_command[0] + ' && pwd').read().strip()
is_change = False
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:   ', '')
        print(work_dir + '/' + prepare_result.strip())
