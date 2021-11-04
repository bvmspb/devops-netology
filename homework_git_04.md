# devops-netology DEVSYS-PDC-2
##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir
###DEVSYS-PDC-2 GIT 02.04 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «2.4. Инструменты Git»

# Домашнее задание к занятию «2.4. Инструменты Git»

Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом 
терраформа https://github.com/hashicorp/terraform 

* **git clone https://github.com/hashicorp/terraform.git terraform**

В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены. 

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.

[aefead2207ef7e2aa5dc81a34aedf0cad4c32545],
[Update CHANGELOG.md]

    git show aefea
    commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
    Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

2. Какому тегу соответствует коммит `85024d3`?

[v0.12.23]

    git show 85024d3
    commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

3. Сколько родителей у коммита `b8d720`? Напишите их хеши.

[2 родителя] - [56cd7859e] и [9ea88f22f]

    git show b8d720
    commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
    Merge: 56cd7859e 9ea88f22f

    git show b8d720^1 --oneline
    56cd7859e Merge pull request #23857 from hashicorp/cgriggs01-stable

    git show b8d720^2 --oneline
    9ea88f22f add/update community provider listings

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами  v0.12.23 и v0.12.24.


    git log --pretty=oneline  v0.12.23..v0.12.24
    33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24) v0.12.24
    b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
    3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
    6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
    5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
    06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
    d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
    4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
    dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
    225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release


5. Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит 
так `func providerSource(...)` (вместо троеточего перечислены аргументы).

[8c928e83589d90a031f811fae52a81be7153e82f]

    git log -S'func providerSource('
    commit 8c928e83589d90a031f811fae52a81be7153e82f
    Author: Martin Atkins <mart@degeneration.co.uk>
    Date:   Thu Apr 2 18:04:39 2020 -0700

    main: Consult local directories as potential mirrors of providers


6. Найдите все коммиты в которых была изменена функция `globalPluginDirs`.

Нашел файл (plugins.go), в котором искомая функция определена:

    git grep -pn --break --heading -e 'func globalPluginDirs('

Поиск всех изменений функции в конкретном файле:

    git log -L :'func globalPluginDirs':plugins.go --oneline
    78b122055 Remove config.go and update things using its aliases
    52dbf9483 keep .terraform.d/plugins for discovery
    41ab0aef7 Add missing OS_ARCH dir to global plugin paths
    66ebff90c move some more plugin search path logic to command
    8364383c3 Push plugin discovery down into command package


7. Кто автор функции `synchronizedWriters`? 

[Martin Atkins]

    git log -S 'synchronizedWriters'
commit bdfea50cc85161dea41be0fe3381fd98731ff786
Author: James Bardin <j.bardin@gmail.com>
Date:   Mon Nov 30 18:02:04 2020 -0500

    remove unused

commit fd4f7eb0b935e5a838810564fd549afe710ae19a
Author: James Bardin <j.bardin@gmail.com>
Date:   Wed Oct 21 13:06:23 2020 -0400

    remove prefixed io

commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700

    main: synchronize writes to VT100-faker on Windows


