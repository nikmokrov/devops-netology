#!/usr/bin/env python3

import os 
import sys

if len(sys.argv) <= 1:
    print('PR message needed')
    sys.exit()
pr_mess = sys.argv[1].strip('"')
pr_mess = sys.argv[1].strip("'")
git_dir = "~/DEVOPS-22/Homeworks/02-git-01/devops-netology"
bash_command = ["cd " + git_dir, "git checkout -b new123", "git add *", "git commit -m 'new 123'"]
fd = os.popen(' && '.join(bash_command))
fd.close()
#exit_code = fd.close()
#if exit_code is not None:
#    print ('Something wrong with git')
#    sys.exit()
bash_command = ["cd " + git_dir, "git checkout main"]
fd = os.popen(' && '.join(bash_command))
fd.close()
#exit_code = fd.close()
#if exit_code is not None:
#    print ('No checkout')
#    sys.exit()
bash_command = ["cd " + git_dir, "git push --all"]
fd = os.popen(' && '.join(bash_command))
fd.close()
#exit_code = fd.close()
#if exit_code is not None:
#    print ('No push')
#    sys.exit()
curl_str = 'curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer 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" https://api.github.com/repos/nikmokrov/devops-netology/pulls -d ' + "'" + '{"title":"new123 feature","body":"' + pr_mess + '","head":"new123","base":"main"}' + "'"
fd = os.popen(curl_str)
print(fd.read())
fd.close()
