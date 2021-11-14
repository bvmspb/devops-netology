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



Terraform
=========

- Website: https://www.terraform.io
- Forums: [HashiCorp Discuss](https://discuss.hashicorp.com/c/terraform-core)
- Documentation: [https://www.terraform.io/docs/](https://www.terraform.io/docs/)
- Tutorials: [HashiCorp's Learn Platform](https://learn.hashicorp.com/terraform)
- Certification Exam: [HashiCorp Certified: Terraform Associate](https://www.hashicorp.com/certification/#hashicorp-certified-terraform-associate)

<img alt="Terraform" src="https://www.datocms-assets.com/2885/1629941242-logo-terraform-main.svg" width="600px">

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

The key features of Terraform are:

- **Infrastructure as Code**: Infrastructure is described using a high-level configuration syntax. This allows a blueprint of your datacenter to be versioned and treated as you would any other code. Additionally, infrastructure can be shared and re-used.

- **Execution Plans**: Terraform has a "planning" step where it generates an *execution plan*. The execution plan shows what Terraform will do when you call apply. This lets you avoid any surprises when Terraform manipulates infrastructure.

- **Resource Graph**: Terraform builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, Terraform builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.

- **Change Automation**: Complex changesets can be applied to your infrastructure with minimal human interaction. With the previously mentioned execution plan and resource graph, you know exactly what Terraform will change and in what order, avoiding many possible human errors.

For more information, see the [introduction section](https://www.terraform.io/intro) of the Terraform website.

Getting Started & Documentation
-------------------------------
Documentation is available on the [Terraform website](https://www.terraform.io):
  - [Intro](https://www.terraform.io/intro/index.html)
  - [Docs](https://www.terraform.io/docs/index.html)

If you're new to Terraform and want to get started creating infrastructure, please check out our [Getting Started guides](https://learn.hashicorp.com/terraform#getting-started) on HashiCorp's learning platform. There are also [additional guides](https://learn.hashicorp.com/terraform#operations-and-development) to continue your learning.

Show off your Terraform knowledge by passing a certification exam. Visit the [certification page](https://www.hashicorp.com/certification/) for information about exams and find [study materials](https://learn.hashicorp.com/terraform/certification/terraform-associate) on HashiCorp's learning platform.

Developing Terraform
--------------------

This repository contains only Terraform core, which includes the command line interface and the main graph engine. Providers are implemented as plugins, and Terraform can automatically download providers that are published on [the Terraform Registry](https://registry.terraform.io). HashiCorp develops some providers, and others are developed by other organizations. For more information, see [Extending Terraform](https://www.terraform.io/docs/extend/index.html).

To learn more about compiling Terraform and contributing suggested changes, please refer to [the contributing guide](.github/CONTRIBUTING.md).

To learn more about how we handle bug reports, please read the [bug triage guide](./BUGPROCESS.md).

## License
[Mozilla Public License v2.0](https://github.com/hashicorp/terraform/blob/main/LICENSE)