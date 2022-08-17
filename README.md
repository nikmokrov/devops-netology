# devops-netology
Файл .gitignore в директории terraform:

**/.terraform/*
git будет игнорировать все файлы во всех скрытых поддиректориях .terraform во всех поддиректориях директории terraform

*.tfstate
*.tfstate.*
git будет игнорировать все файлы, заканчивающиеся на .tfstate или имеющие в своем названии .tfstate. во всех поддиректориях

crash.log
crash.*.log
git будет игнорировать все файлы crash.log и все файлы, имена которых начинаются на crash и заканчиваются на .log, например crash.1.log

*.tfvars
*.tfvars.json
git будет игнорировать все файлы, имена которых заканчиваются на .tfvars и .tfvars.json

override.tf
override.tf.json
*_override.tf
*_override.tf.json
здесь git проигнорирует все файлы override.tf и override.tf.json и все файлы, имена которых заканчиваются на _override.tf и _override.tf.json

.terraformrc
terraform.rc
игнорируются все файлы .terraformrc и terraform.rc во всех поддиректориях

Add new line for fix branch

Add another line with IDE PyCharm editor
