#!/usr/bin/python3

import sys

if len(sys.argv) <= 1:
    print('PR message needed')
else:
    pr_mess = sys.argv[1].strip('"')
    pr_mess = sys.argv[1].strip("'")
    print(pr_mess)

curl_str = 'curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer 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" https://api.github.com/repos/nikmokrov/devops-netology/pulls -d ' + "'" + f'{"title":"new123 feature","body":"{pr_mess}","head":"new123","base":"main"}' + "'"
print(curl_str)
