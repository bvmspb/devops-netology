# devops-netology DEVSYS-PDC-2

##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir

###DEVSYS-PDC-2 sysadmin 04.01 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «4.1. Командная оболочка Bash: Практические навыки»

# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

Сначала идет оригинальный текст заданий с моими ответами под ними - как 
я всегда делал на этом курсе.
Далее, в конце я добавил копию обновленного за сегодня задания, которое 
появилось пока я занимался выполнением изначальной версии задания - 
подставил свои ответы туда тоже. Все ответы одинаковые, отличие только 
в оформлении - в моем варианте есть комментарии и вывод 
команд/log-файлов, то есть он более подробный. Прошу выбрать тот, который 
для вас будет удобнее.

Также в обновленном задании есть неточности - заголовки "Обязательная задача" 
присутствуют только три раза, а не 4 (столько обязательных заданий). И в 
первом задании вопрос звучит про переменные c, d и e, а в таблице указаны a, 
b и с - я эти неточности исправил у себя во второй части/версии, но прошу 
исправить вопросник в репозитории, чтобы других участников курса не путать. 

## Обязательные задания. Оригинальная версия.

1. Есть скрипт:
```bash
    a=1
    b=2
    c=a+b
    d=$a+$b
    e=$(($a+$b))
```
    * Какие значения переменным c,d,e будут присвоены?
    * Почему?

```answer
        Прежде всего доработаю скрипт, чтобы вывести значения переменных в конце 
        его выполнения:
            bvm@RU1L0605:~$ cat ./script1.sh
            #!/usr/bin/env bash
            a=1
            b=2
            c=a+b
            d=$a+$b
            e=$(($a+$b))
            echo a=$a
            echo b=$b
            echo c=$c
            echo d=$d
            echo e=$e
            bvm@RU1L0605:~$ ./script1.sh
            a=1
            b=2
            c=a+b
            d=1+2
            e=3
        
        Ни одна из переменных c, d и e не былв декларирована, например, как 
        числовая, то есть они могут принимать как числовые, так и строковые 
        значения, без ограничений и попыток приведения к заданному типу со 
        стороны shell'а.
        
        Таким Образом:
        с = a+b - было присвоено строковое значение "a+b" как есть. Хотя у 
        нас и есть переменные со схожими именами (a и b), но отсылки к их 
        значениям не было сделано (через символ $ перед именем переменной).  
        
        d = 1+2 - снова видим, что переменной было присвоено строковое 
        значение склееное из значений двух других переменных и знака + между 
        ними. В этот раз уже обратились именно к значениями переменных a и b, 
        но то, что для человека выглядит как попытка вычислить арифметическое 
        выражение, на самом деле только записано в виде такой строки.
        
        e = 3 - наконец, было не только использовано обращение к значениям 
        двух переменных a и b, но и прямо указано на необходимость 
        осушествить вычисление (запись арифметической операции в скобках и
        дополнительные вторые скобки с $ перед ними, чтобы получить именно 
        значение осуществленной операции). 
```

2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:

```bash
    while ((1==1)
    do
    curl https://localhost:4757
    if (($? != 0))
    then
    date >> curl.log
    fi
    done
```
```answer
        Попытка запустить скрипт в заданном виде привела к ошибке:
            syntax error near unexpected token `done'
        
        Из этого следует, что раз "done" является неожиданным оператором, а он 
        является закрывающим для do, то ошибка должна быть где-то рядом с ним - 
        в самом начале скрипта. Видно, что количество скобок закрывающих не 
        совпадает с открывающими в описании условия цикла while - надо 
        исправить, после чего скрипт начинает свою работу.  
        Но так как запуск curl, проверка кода его завершения и возврат к началу 
        цикла осуществляются достаточно быстро - в случае недоступности сервиса 
        на указанном порту, curl.log будет забиваться информацией очень быстро. 
        Даже если у нас будет оповещение о недоступности сервиса, пока сервис 
        снова заработает - может пройти время и файл может очень быстро вырасти 
        в размере - добавим заждержку между каждым циклом проверки - sleep 10
        Также скроем код вывода потока stderr от curl, а в stdout добавим 
        вывод полученного кода завершения последней попытки выполнения curl. 
        Получается такой исправленный и дополненный вариант:
            #!/usr/bin/env bash
            exit_code=0
            while ((1==1))
            do
                    curl https://localhost:4757 2>null
                    exit_code=$?
                    if (( $exit_code != 0 ))
                            then
                                    echo "Service is not running. curl exit code: " $exit_code
                                    date >> curl.log
                    else
                            break
                    fi
                    sleep 10
            done
        
        Можно также сделать выход (exit) из скрипта полностью в случае успеха 
        и обрабатывать этот код завершения уже там, откуда скрипт проверки 
        доступности сервиса запускали, например. Также можно было бы добавить 
        удаление накопившегося старого curl.log при первоначальном запуске 
        скрипта, например.
```

3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.

```answer
        В результате у меня получился такой скрипт, в котором все ключевые 
        параметры заданы в переменными и можно не копаясь в дебрях скрипта 
        добавить, например, дополнительные хосты для отслеживания позднее, 
        при необходимости, а результат работы (коды возврата из curl) 
        сохраняются для каждого хоста в log-файле:
            bvm@RU1L0605:~$ cat script04_01_4.sh
            #!/usr/bin/env bash
            hosts=(192.168.0.1 173.194.222.113 87.250.250.242)
            port=80
            ctimeout=5
            counter=5
            i=0 #index to go through the array
            c=0 #counter for every array element
            while (( i < ${#hosts[@]} ))
            do
                    while (( c < $counter ))
                    do
                            curl --silent --head --fail --connect-timeout $ctimeout ${hosts[i]}:$port >/dev/null
                            echo "Host "${hosts[i]} "status code: "$? >>checkhosts.log
                            let "c += 1"
                    done
                    c=0 #reset counter to start again for each array record
                    let "i += 1" #go through every array record
            done
        
        Вот результаты прогона у меня в WSL:
            bvm@RU1L0605:~$ tail -f checkhosts.log
            Host 192.168.0.1 status code: 28
            Host 192.168.0.1 status code: 28
            Host 192.168.0.1 status code: 28
            Host 192.168.0.1 status code: 28
            Host 192.168.0.1 status code: 28
            Host 173.194.222.113 status code: 0
            Host 173.194.222.113 status code: 0
            Host 173.194.222.113 status code: 0
            Host 173.194.222.113 status code: 0
            Host 173.194.222.113 status code: 0
            Host 87.250.250.242 status code: 22
            Host 87.250.250.242 status code: 22
            Host 87.250.250.242 status code: 22
            Host 87.250.250.242 status code: 22
            Host 87.250.250.242 status code: 22
```

4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается

```answer
        Поменял в списке хостов местами первый и второй, чтобы ошибка не 
        возникала сразу и оба лога успели наполниться значимыми записями, 
        а не только одной ошибкой на первом же. Также добавил сохранение 
        кода выхода из curl в новую переменную и проверку ее значения для 
        записи проблемы в error.log и выхода:
            bvm@RU1L0605:~$ cat script04_01_4.sh
            #!/usr/bin/env bash
            hosts=(173.194.222.113 192.168.0.1 87.250.250.242)
            port=80
            ctimeout=5
            counter=5
            i=0 #index to go through the array
            c=0 #counter for every array element
            errcode=0
            while (( i < ${#hosts[@]} ))
            do
                    while (( c < $counter ))
                    do
                            curl --silent --head --fail --connect-timeout $ctimeout ${hosts[i]}:$port >/dev/null
                            errcode=$?
                            echo "Host "${hosts[i]} "status code: "$errcode >>checkhosts.log
                            let "c += 1"
                            if [ ! $errcode = 0 ]
                            then
                                    echo "Host "${hosts[i]} " is unavailable. Status code: "$errcode >>error.log
                                    exit
                            fi
                    done
                    c=0 #reset counter to start again for each array record
                    let "i += 1" #go through every array record
            done
        
        Результаты в обоих log-файлах:
            bvm@RU1L0605:~$ cat error.log
            Host 192.168.0.1  is unavailable. Status code: 28
            bvm@RU1L0605:~$ cat checkhosts.log
            Host 173.194.222.113 status code: 0
            Host 173.194.222.113 status code: 0
            Host 173.194.222.113 status code: 0
            Host 173.194.222.113 status code: 0
            Host 173.194.222.113 status code: 0
            Host 192.168.0.1 status code: 28
```

## Ответы по шаблону из обновленной версии задания

# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | было присвоено строковое значение "a+b" как есть. |
| `d`  | 1+2  | снова видим, что переменной было присвоено строковое значение склееное из значений двух других переменных и знака + между ними |
| `e`  | 3  | наконец, было не только использовано обращение к значениям двух переменных a и b, но и прямо указано на необходимость осушествить вычисление (запись арифметической операции в скобках и дополнительные вторые скобки с $ перед ними, чтобы получить именно значение осуществленной операции).  |

## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:

Исправленный скрипт:
```bash
#!/usr/bin/env bash
exit_code=0
while ((1==1))
do
        curl https://localhost:4757 2>null
        exit_code=$?
        if (( $exit_code != 0 ))
                then
                        echo "Service is not running. curl exit code: " $exit_code
                        date >> curl.log
        else
                break
        fi
        sleep 10
done
```

## Обязательная задача 3
Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
#!/usr/bin/env bash
hosts=(192.168.0.1 173.194.222.113 87.250.250.242)
port=80
ctimeout=5
counter=5
i=0 #index to go through the array
c=0 #counter for every array element
while (( i < ${#hosts[@]} ))
do
        while (( c < $counter ))
        do
                curl --silent --head --fail --connect-timeout $ctimeout ${hosts[i]}:$port >/dev/null
                echo "Host "${hosts[i]} "status code: "$? >>checkhosts.log
                let "c += 1"
        done
        c=0 #reset counter to start again for each array record
        let "i += 1" #go through every array record
done
```

## Обязательная задача 4
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/usr/bin/env bash
hosts=(173.194.222.113 192.168.0.1 87.250.250.242)
port=80
ctimeout=5
counter=5
i=0 #index to go through the array
c=0 #counter for every array element
errcode=0
while (( i < ${#hosts[@]} ))
do
        while (( c < $counter ))
        do
                curl --silent --head --fail --connect-timeout $ctimeout ${hosts[i]}:$port >/dev/null
                errcode=$?
                echo "Host "${hosts[i]} "status code: "$errcode >>checkhosts.log
                let "c += 1"
                if [ ! $errcode = 0 ]
                then
                        echo "Host "${hosts[i]} " is unavailable. Status code: "$errcode >>error.log
                        exit
                fi
        done
        c=0 #reset counter to start again for each array record
        let "i += 1" #go through every array record
done
```