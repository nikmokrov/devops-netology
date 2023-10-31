#!/usr/bin/env python3

import sys
import json
import yaml

if len(sys.argv) < 2:
    sys.exit()

filename = sys.argv[1]
is_json = True
is_yaml = True

with open(filename, 'r') as fp:
    try:
        json_content = json.load(fp)
    except json.JSONDecodeError as exc:
        is_json = False
        json_exc = exc

with open(filename, 'r') as fp:
    try:
        yaml_content = yaml.load(fp, Loader=yaml.SafeLoader)
    except yaml.YAMLError as exc:
        is_yaml = False
        yaml_exc = exc

if not is_json and not is_yaml:
    print(f'File {filename} is not json nor yaml file')
    print(f'json exception: {json_exc.pos} - {json_exc.msg}')
    print(f'yaml exception: {yaml_exc}')
    sys.exit()
elif is_json:
    if filename.split('.')[0] + '.yaml' == filename:
        filename = filename.split('.')[0] + '_new.yaml'
    else:
        filename = filename.split('.')[0] + '.yaml'
    with open(filename, 'w') as fp:
        yaml.dump(json_content, fp)

elif is_yaml:
    if filename.split('.')[0] + '.json' == filename:
        filename = filename.split('.')[0] + '_new.json'
    else:
        filename = filename.split('.')[0] + '.json'
    with open(filename, 'w') as fp:
        json.dump(yaml_content, fp)
