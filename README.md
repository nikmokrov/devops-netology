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

Just another line for commit in main branch


# Ответы на задание к занятию «2.4. Инструменты Git»
1. Полный хеш и комментарий коммита, хеш которого начинается на aefea 
можно посмотреть командой <br/>
_git show aefea_ <br/>
полный хеш - aefead2207ef7e2aa5dc81a34aedf0cad4c32545 <br/>
комментарий - Update CHANGELOG.md
2. Коммит 85024d3 соответствует тегу "v0.12.23". Это также видно по команде <br/>
_git show 85024d3_ <br/>
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23) <br/>
Можно проверить командой <br/>
_git show v0.12.23_ <br/>
которая возвращает информацию по тому же коммиту 85024d3
3. Сколько родителей у коммита b8d720? Напишите их хеши.<br/>
_git show b8d720_ показывает, что это мердж-коммит и значит у него 2 родителя.<br/>
Строка Merge: 56cd7859e0 9ea88f22fc указывает хеши родителей.<br/>
Отдельно можем посмотреть этих родителей командами
_git show b8d720^_ для 1-го родителя (56cd7859e05c36c06b56d013b55a252d0bb7e158)<br/>
и _git show b8d720^2_ для 2-го родителя (9ea88f22fc6269854151c571162c5bcf958bee2b)
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24<br/>
Я сделал это командой _git log v0.12.23^..v0.12.24 --oneline_. В выводе команды видны хеши и комментарии:<br/>
33ff1c03bb (tag: v0.12.24) v0.12.24<br/>
b14b74c493 [Website] vmc provider links<br/>
3f235065b9 Update CHANGELOG.md<br/>
6ae64e247b registry: Fix panic when server is unreachable<br/>
5c619ca1ba website: Remove links to the getting started guide's old location<br/>
06275647e2 Update CHANGELOG.md<br/>
d5f9411f51 command: Fix bug when using terraform login on Windows<br/>
4b6d06cc5d Update CHANGELOG.md<br/>
dd01a35078 Update CHANGELOG.md<br/>
225466bc3e Cleanup after v0.12.23 release<br/>
85024d3100 (tag: v0.12.23) v0.12.23<br/>
5. Найдите коммит в котором была создана функция func providerSource.
Командой _git grep "func providerSource("_ находим, что функция определена в файле provider_source.go
Далее командой _git log -L :providerSource:provider_source.go_ находим 3 коммита: один явно не то, а вот 
в двух других видим добавление строчки "func providerSource(...)".
По коду видно, что в коммите 8c928e83589d90a031f811fae52a81be7153e82f функция была создана, а в 
коммите 5af1e6234ab6da412fb8637393c5a17a1b293663 изменена.
Эти же коммиты можно найти командой _git log --pretty=oneline -S "func providerSource"_, причем команда
_git log --pretty=oneline -S "func providerSource("_ выдает только искомый коммит - 8c928e83589d90a031f811fae52a81be7153e82f
6. Найдите все коммиты в которых была изменена функция globalPluginDirs.
Аналогично командой _git grep "globalPluginDirs("_ находим 2 файла: commands.go и plugins.go.
В файле commands.go эта функция только вызывается, а определена она в файле plugins.go.
Командой _git log -L :globalPluginDirs:plugins.go_ находим все коммиты, в которых функция изменялась:<br/>
8364383c35 (функция была определена)<br/>
66ebff90cd<br/>
41ab0aef7a<br/>
52dbf94834<br/>
78b1220558<br/>
7. Кто автор функции synchronizedWriters?
Командой _git log -S "synchronizedWriters("_ находим 3 коммита, в которых упомянута эта функция. 
В первом из них (самом раннем) она была определена. Автор этого коммита, а значит и функции - Martin Atkins <mart@degeneration.co.uk> 

