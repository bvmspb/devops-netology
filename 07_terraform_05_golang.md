# devops-netology DEVSYS-PDC-2

### DEVSYS-PDC-2 terraform 07.05 Vladimir Baksheev / Владимир Бакшеев Домашнее задание к занятию «7.5. Основы golang»

# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).

```bash
    root@bvm-HP-EliteBook-8470p:~# cd /home/bvm/
    root@bvm-HP-EliteBook-8470p:/home/bvm# rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
    root@bvm-HP-EliteBook-8470p:/home/bvm# exit
    выход
    bvm@bvm-HP-EliteBook-8470p:~$ go version
    go version go1.18.3 linux/amd64
```

2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

```answer2
Спасибо! Занятное интерактивное пособие - самое то для знакомства с языком 
и его конструкциями, подходами и т.п. Жаль только, что изучение языков 
программировани всегда требует времени - сначала для изучения синтаксиса 
и основных правил, а затем нужно время для практики. И, как и говорить на 
других языках - такой навык может быть подходящим для всех (не все рождены
чтобы стать разработчиками). Хорошо, что есть stackoverflow ))
```

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные 
у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:

```answer3.1
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number (amount of meters): ")
        var input float64
        fmt.Scanf("%f", &input)
    
        output := input * 0.3048
    
        fmt.Println("Amount in feet:",output)
    }
```

```bash
    bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/07_terraform_05_golang$ go run task3_1.go 
    Enter a number (amount of meters): 10
    Amount in feet: 3.048
```
[task3_1.go](./07_terraform_05_golang/task3_1.go)
 
2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
```
```go
    package main
    
    import (
        "fmt"
        "errors"
    )
    
    func Min(values []int) (min int, e error) {
        if len(values) == 0 {
            return 0, errors.New("Cannot detect a minimum value in an empty slice")
        }
    
        min = values[0]
        for _, v := range values {
                if (v < min) {
                    min = v
                }
        }
    
        return min, nil
    }
    
    func main() {
        values_list := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
        
        v, err := Min(values_list)
        
        if err != nil {
            fmt.Println(err, v)      // Zero cannot be used 0
        }
        
        fmt.Println("The list of values:", values_list)
        fmt.Println("Minimum value from the list is:", v)
    }
```
```bash
    bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/07_terraform_05_golang$ go run task3_2.go 
    The list of values: [48 96 86 68 57 82 63 70 37 34 83 27 19 97 9 17]
    Minimum value from the list is: 9
```
[task3_2.go](./07_terraform_05_golang/task3_2.go)

3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.

```go
    package main
    
    import "fmt"
    
    func main() {
        var values_list []int
    
        for i := 0; i < 100; i++ {
            if( i%3 == 0 ) {
                values_list = append(values_list,i)
    //             fmt.Print(i," ")
            }
        }
        fmt.Printf("values=%v\nlength=%d \n", values_list, len(values_list))
    }
```
```bash
    bvm@bvm-HP-EliteBook-8470p:~/netology/devops-netology/07_terraform_05_golang$ go run task3_3.go 
    values=[0 3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99]
    length=34 
```
В виде решения ссылку на код или сам код. 

[task3_1.go](./07_terraform_05_golang/task3_1.go)
[task3_2.go](./07_terraform_05_golang/task3_2.go)
[task3_3.go](./07_terraform_05_golang/task3_3.go)

---
