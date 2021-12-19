# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 sysadmin 04.03 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «4.3. Языки разметки JSON и YAML»

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

```answer
Сразу бросается в глаза отсутствие закрывающей кавычки у ключа ip, а 
также строка с самим ip-адресом записана как число, а не строка - также 
нужно взять в кавычки:
```
```yaml
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```



## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import json
import yaml
import socket
import time

jsonFile = '04_03_02.json'
yamlFile = '04_03_02.yaml'
serverList = {"drive.google.com": '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
# with open(jsonFile, 'r') as jsonFD:
#     serverList = json.load(jsonFD)
wait = 2
counter = 0

while True:
    print('-=== Round #', counter, ' ===-')
    for ServerName, ServerOldIp in serverList.items():
        ServerNewIp = socket.gethostbyname(ServerName)
        if ServerNewIp != ServerOldIp:  # ip has changed
            print('[ERROR]', ServerName, 'IP mismatch:', ServerOldIp, ServerNewIp)
            serverList[ServerName] = ServerNewIp
            try:
                with open(jsonFile, 'w') as jsonFD, open(yamlFile, 'w') as yamlFD:
                    json.dump(serverList, jsonFD)
                    yaml.dump(serverList, yamlFD)
            except IOError:
                print("File not found or path is incorrect")
            finally:
                yamlFD.close()
                jsonFD.close()
                print('Updated server list with ip-addresses info is stored in', jsonFile, 'and in', yamlFile)

        else:  # ip address is the same as it was before
            print(ServerName, '-', ServerOldIp)
        time.sleep(wait)
    counter += 1
```

### Вывод скрипта при запуске при тестировании:
```bash
bvm@RU1L0605:~$ python3 /mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/04_script_03_yaml/04_03_02.py
-=== Round # 0  ===-
[ERROR] drive.google.com IP mismatch: 0.0.0.0 74.125.205.194
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
[ERROR] mail.google.com IP mismatch: 0.0.0.0 74.125.131.17
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
[ERROR] google.com IP mismatch: 0.0.0.0 173.194.222.100
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
-=== Round # 1  ===-
drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: 74.125.131.17 64.233.165.83
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
[ERROR] google.com IP mismatch: 173.194.222.100 173.194.222.113
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
-=== Round # 2  ===-
drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: 64.233.165.83 173.194.221.83
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
[ERROR] google.com IP mismatch: 173.194.222.113 142.251.1.101
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
-=== Round # 3  ===-
[ERROR] drive.google.com IP mismatch: 74.125.205.194 142.251.1.194
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
[ERROR] mail.google.com IP mismatch: 173.194.221.83 108.177.14.83
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
[ERROR] google.com IP mismatch: 142.251.1.101 64.233.165.139
Updated server list with ip-addresses info is stored in 04_03_02.json and in 04_03_02.yaml
^CTraceback (most recent call last):
  File "/mnt/c/Users/vbaksheev/PycharmProjects/netology.devops/devops-netology/04_script_03_yaml/04_03_02.py", line 35, in <module>
    time.sleep(wait)
KeyboardInterrupt
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "173.194.73.194", "mail.google.com": "64.233.164.83", "google.com": "74.125.205.102"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 173.194.73.194
google.com: 74.125.205.102
mail.google.com: 64.233.164.83
```

| Ответ ко второму заданию |
| --- |
| Исправил исходный скрипт согласно полученным рекомендациям после проверки прошлого ДЗ. |
| Добавил два модуля для yaml и json. |
| Добавил в цикле выгрузку dict переменной serverList в два файла: json и yaml. Это происходит только в момент, когда ip-адрес не совпадает с сохраненным значением. Файлы перезаписываются каждый раз - то есть структура готова для загрузки последних успешно работавших значений. Если нужно было бы сделать что-то вроде отслеживания истории изменений ip-адресов, то можно было бы открывать файл в режиме "добавления" данных (append). |
| Также для проверки добавил в начале скрипта возможность загрузить значения для переменной serverList сразу из созданного ранее файла - это работает, но закомментировал и вернул к работе с первоначальным списком серверов-сервисов и их нулевыми ip-адресами, т.к. это более надежно с точки зрения работоспособности самого скрипта (если файла не будет вовсе или его содержимое будет повреждено/не совпадать с нашими ожиданиями, то скрипт никак не сможет работать). |
| Запускал из под wsl, т.к. обратил внимание, что там адреса заметно чаще меняются у серверов - пример вывода получается короче и нагляднее. Вероятно, под Windows dns кэшируется сильнее и потому не так часто меняются адреса в выводе скрипта. |
| Имена файлов также сделал внутренними переменными в скрипте, чтобы не усложнять реализацию обработкой параметров командной строки, или например, реализовать считывание всех необходимых в работе параметров из какого-то файла с конфигурацией, например. Это было бы оверкилл. |

