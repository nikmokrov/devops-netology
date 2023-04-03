# Домашнее задание к занятию 16 «Платформа мониторинга Sentry»
## Задание 1
![Pic.1](10-monitoring/05-sentry/pics/projects.png "Pic. 1")

## Задание 2
![Pic.2](10-monitoring/05-sentry/pics/stack_trace.png "Pic. 2")
![Pic.3](10-monitoring/05-sentry/pics/resolved.png "Pic. 3")

## Задание 3
![Pic.4](10-monitoring/05-sentry/pics/mail_alert.png "Pic. 4")

## Задание повышенной сложности
![Pic.5](10-monitoring/05-sentry/pics/sdk_event.png "Pic. 5")
![Pic.6](10-monitoring/05-sentry/pics/sdk_filenotfound.png "Pic. 6")

[sentry_test.py](10-monitoring/05-sentry/sentry_test.py)</br>

```python
#!/usr/bin/python3

import sentry_sdk
sentry_sdk.init(
    dsn="https://8d72dad0518f42219038ed399eff3ea0@o4504948857110528.ingest.sentry.io/4504948859338752",

    traces_sample_rate=1.0,
    release="0.0.1",
    environment="dev",
    dist="python 3.9"
)

with open('test123.txt', 'r') as file:
    content = file.readlines()
    print(content)

```