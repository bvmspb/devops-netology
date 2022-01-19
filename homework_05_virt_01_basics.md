# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 sysadmin 05.01 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения.»

# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

---

## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

```answer1
Полная (аппаратная) виртуализация - вариант с минимальными (возможными) 
накладными расходами на саму виртуализацию, то есть производительность 
будет максимально возможной - близкой к работе на физическом оборудовании 
хоста. При этом такой вариант позволяет полностью изолировать каждую 
из ВМ и сами ВМ могут работать с операционными системами на различных 
ядрах. 
Позволяет объединять несколько физических хостов в кластер для 
создания общего пула доступных ресурсов для работающих в данном кластере 
ВМ. Также это может быть полезно для "прозрачной" миграции ВМ с одного 
хоста на другой (при модернизации, например).
Можно делать "снимок" с ВМ - удобный способ быстрого создания резервной 
копии всей ВМ целиком перед какими-то действиями (установка обновления, 
нового ПО и.т.), либо на регулярной основе. 

Паравиртуализация позволяет получить возможность запуска одной или 
нескольких ВМ на "существующем сервере", то есть ВМ работают полностью 
независимо друг от друга - каждая ВМ работает отдельным процессом на 
хосте, но сам сервер, на котором запущен гипервизор ВМ, также может 
выполнять и другие функции (сетевое хранилище, контроллер домена, 
принтсервер и т.д., и т.п.). Так как гипервизор работает под "действующей" 
ОС - ресурсы, доступные для ВМ разделяются с другими процессами на данном 
хосте. Может возникнуть ситуация нехватки ресурсов, вплоть до завершения 
работы процессов ВМ. При высокой нагрузке скорость работы может быть 
заметно снижена. Сами ВМ могут быть абсолютно разные - также как и при 
полной (аппаратной) виртуализации.
Также поддерживает создание "снимков" ВМ - удобная резервная копия всего 
сервера, работающего в ВМ, например.

Виртуализация на основе ОС (контейнеры) - самый легковесный вариант, 
который позволяет использовать ядро хоста для запуска изолированных 
процессов с минимальными накладными расходами. Идеально подходит для 
запуска прикладного ПО, приложений, с изоляцие от уровня "железного 
сервера". Так как используются возможности ядра ОС хоста, то нет 
необходимости загрузки полной копии образа ОС, что позволяет запускать 
одновременно больше различных контейнеров на одном физическом хосте. 
Контейнеры, как правило, представляют из себя статичный образ 
подготовленного к работе приложения, а все данные поступают для него 
извне, также как и сохранение результатов его работы (если такое 
подразумевается), как правило, осуществляется вне контейнера. Такой 
способ позволяет иметь удобную возможность запуска определенной версии 
приложения без необходимости обеспечения всех зависимостей для таких 
(возможно старых) версий приложения на хосте.
Возможна ситуация нехватки ресурсов при одновременной работе 
нескольких контейнеров на одном хосте (и других процессов, которые 
также могут активно расходовать системные ресурсы) - в таких случаях 
может произойти вплоть до полной остановки выполнения процесса, 
обеспечивающего работу таких контейнеров (наряду с другими процессами 
на хосте).

```

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу.
- Различные web-приложения.
- Windows системы для использования бухгалтерским отделом.
- Системы, выполняющие высокопроизводительные расчеты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

```answer2
Ответ в таблице ниже:
```
| Условия использования | Вариант организации серверов |
| --- | --- |
| Высоконагруженная БД | физические сервера - Для сокращения любых "узкий мест" и дополнительных потребителей аппаратных ресурсов. Также может быть вариант с полной (аппаратной) виртуализацией - при условии достаточности ресурсов для корректной работы гипервизора и нагруженной БД. У нас на работе сервера БД работают в кластере, с репликацией между собой, но при этом сами запущены в различных ВМ на гипервизоре полной (аппаратной) виртуализации, который в свою очередь тоже работает с кластером из нескольких хостов, чьи ресурсы разделяются на работающие ВМ. Виртуализация позволяет легче управлять доступными ресурсами (добавить на время пикового сезона, например), а также облегчает резервное копирование |
| Различные web-приложения| В зависимости от "тяжести" web-приложения подойдет любая из виртуализаций. Удобнее всего и, как правило эффективнее всего - виртуализация уровня ОС (контейнеры). Как правило web-приложения спроектированы для работы в распределенном режиме (либо вовсе - микросервисная архитектура), что позволяет разворачивать дополнительные копии приложения (контейнера) при необходимости увеличить емкость для параллельной обработки входящих запросов.|
| Windows системы для использования бухгалтерским отделом| Паравиртуализация, либо полная (аппаратная) виртуализация - в зависимости от доступных ресурсов и лицензий. Тот же Hyper-V позволяет работать и в таком типе виртуализации и другом. Как правило достаточно даже работы в паравиртуальном окружении - получаешь все блага виртуализации (возможность нарастить ресурсы для ВМ, при необходимости; возможность легкого резервного копирования; клонирование ВМ для запуска новых экземпляров типового сервера и т.п.)|
| Системы, выполняющие высокопроизводительные расчеты на GPU. | Физические сервера с прямым доступом к железу, как наиболее производительное и простое решение, либо полная аппаратная виртуализация (для минимизации накладных расходов) с прямым пробрасыванием GPU в одну или несколько ВМ, но для этого нужны специализированные GPU, которые стоят сильно дороже "гражданских" (либо использовать хаки, которые позволяют подменить дешевую видеокарту ее "специализированным" дорогим аналогом). Видел ролики в сети, где даже из одной "бытовой" видеокарты умудрялись делать две "половинки", каждая из которых была доступна на хосте (паравиртуализация на базе KVM и еще на Hyper-V тоже видел) и в работающей параллельно ВМ - каждая из таких "видеокарт" нагружала свою "половину" от реальной аппаратной видеокарты и решение вполне масштабировалось - позволяло распределять нагрузку. |


## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

```answer3
Ответ в таблице ниже:
```
| Сценарий | Вариант организации виртуализации серверов |
| --- | --- |
| 1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий. | Если администраторы "больше по части Windows", то организовать виртуализацию на базе Hyper-V, как стандартный стек виртуализации, доступный непосредственно на серверах от MS. Можно даже гипервизор запустить на отдельном "чистом" сервере в режиме полной (аппаратной) виртуализации для повышения стабильности работы/доступных ресурсов для ВМ. Если же есть "достаточное количество знающих Linux-администраторов", то мжно попробовать создать "экономичное решение" на базе KVM (тот же proxmox для удобства администрирования - должно быть доступно для "любого администратора"). Но, возможно, самое правильное решение под такую задачу, если же у компании есть деньги, понимание перспектив воего роста в будущем и, тем более, работа с несколькими серверными/ЦОДами, то решение vSphere от VMWare может дать максимум с точки зрения виртуализации, на мой взгляд/опыт. Хотя решения на базе Xen называются как "самые стабильные" - трудно настроить, но настроив один раз потом больше не возвращаешься к этому снова и снова - так понимаю, что такой выбор должен быть осознанным решением администратора, который уже имеет опыт внедрения и использования таких серверов из прошлого, а не "совет со стороны". Про резервное копирование - слышал, что у нас в компании для этого используются решения от Veeam. |
| 2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин. | Виртуализация на базе KVM - достаточно низкий порог входа, помимо полной поддержки ядра Linux, есть неплохая совместимость и с Windows, а также этот продукт активно развивается и постоянно добавляет как новые возможности/"фишки", но и улучшает поддержку и работу со всеми современными технологиями. |
| 3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры. | Бесплатный вариант Hyper-V от MS - как самое простое решение (добавить роль серверу, управляение через стандартную оснастку и т.п. "понятные" технологии для администраторов Windows-серверов. Также должна быть максимально развитая поддержка именно Windows инфраструктуры. Альтернативой можно попробовать использование бесплатного варианта VMWare ESXi - если аппаратных ограничений бесплатной версии достаточно для нужд сети/компании. Этот вариант может быть "стабильнее", по крайней мере так исторически принято считать было всегда. |
| 4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux. | Решения от Oracle Virtual Box, например - очень частая/распространенная ситуация по разворачиваю нескольких ВМ (через тот же vagrant, например) именно для нужд тестирования в условиях работы с  различными дистрибутивами. |



## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проб

```answer4
Наличие нескольких систем управления виртуализацией одновременно 
подразумевает наличие параллельно работающих хостов (и даже 
нескольких), чьи ресурсы не могут быть объединены в единый кластер, 
доступный для _всех_ ВМ - каждая виртуальная среда работает "отдельно" 
от остальных и даже если простаивает, то не может эффективно 
перераспределить свои ресурсы для ВМ запущенных в другом гипервизоре.
Также есть проблем с управляющим персоналом - ведь у каждой системы 
управления виртуализацией есть свои особенности, возможности и нужен 
обученный/опытный персонал для каждой такой системы (далеко не все 
администраторы могут в равной степени эффективно управлять всеми 
доступными системами).
Резервное копирование также может потребоваться делать для каждой 
системы "по своему", что требует усилий не только на настройку и 
поддержку такой функции, но и может потребовать дополнительных расходов 
дискового пространства, например, для хранения независимых резервных 
копий каждой из систем.  
```