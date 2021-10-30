# devops-netology
##Netology, DevOps engineer training 2021-2022. Personal repository of student Baksheev Vladimir
One line modified-added

GIT01
Будут игнорироваться (git'ом):
* Все файлы из скрытой папки .terraform
* Все файлы tfstate Terraform (содержащие в своем имени .tfstate)
* crash.log файл
* Все файлы оканчивающиеся на .tfvars
* Файлы override.tf и override.tf.json, а также файлы, оканчивающиеся на _override.tf и на _override.tf.json
* Файлы .terraformrc и terraform.rc

При этом никакие файлы/дирректории в исключения для игнорирования не были добавлены - то есть все файлы, подпадающие под маски, перечисленные выше - будут проигнорированы git'ом.

GIT02
Я создал ветку fix и закомитил изменения в файле README.md в нее, затем я переключился обратно в ветку origin\main и сделал изменения в том же файле (который не содержит изменения, внесенные в ветке fix) - также закомитил и запушил в origin - из IDE Pycharm.

