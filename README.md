# Домашнее задание к занятию «Продвинутые методы работы с Terraform»

### Грибанов Антон. FOPS-31

### Цели задания

1. Научиться использовать модули.
2. Отработать операции state.
3. Закрепить пройденный материал.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**04/src**](https://github.com/netology-code/ter-homeworks/tree/main/04/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.8.4
Пишем красивый код, хардкод значения не допустимы!
------

### Задание 1

1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания с помощью двух вызовов remote-модуля -> двух ВМ, относящихся к разным проектам(marketing и analytics) используйте labels для обозначения принадлежности.  В файле cloud-init.yml необходимо использовать переменную для ssh-ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/). Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку.

#### Добавляем в main.if: 

```bash
  vars = {
    ssh-authorized-keys = file(var.ssh-authorized-keys[0])
}
```
#### Добавляем в variables.tf:

```bash
variable "ssh-authorized-keys" {
  type    = list(string)
  default = ["/home/qshar/.ssh/digma.pub"]
}
```


2. Добавьте в файл cloud-init.yml установку nginx.
3. Предоставьте скриншот подключения к консоли и вывод команды ```sudo nginx -t```, скриншот консоли ВМ yandex cloud с их метками. Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.marketing_vm

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_001.png)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_002.png)

------
В случае использования MacOS вы получите ошибку "Incompatible provider version" . В этом случае скачайте remote модуль локально и поправьте в нем версию template провайдера на более старую.
------

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля, например: ```ru-central1-a```.
2. Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.

```bash
variable "env_name" {
  type    = string
  description = "Имя облачной сети"
}

variable "zone" {
  type    = string
  description = "Зона, в которой создать подсеть"
}

variable "cidr" {
  type    = string
  description = "CIDR-блок для подсети"
```

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_003.png)
 
3. Модуль должен возвращать в root module с помощью output информацию о yandex_vpc_subnet. Пришлите скриншот информации из terraform console о своем модуле. Пример: > module.vpc_dev

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_004.png)
 
4. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_005.png)

5. Сгенерируйте документацию к модулю с помощью terraform-docs.
 
Пример вызова

```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```

#### Файл DOC.dm: [DOC.dm](https://github.com/Qshar1408/hw_04/blob/main/src/01-03/DOC.md)

### Задание 3
1. Выведите список ресурсов в стейте.

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_006.png)

2. Полностью удалите из стейта модуль vpc.

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_007.png)

3. Полностью удалите из стейта модуль vm.

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_008.png)

4. Импортируйте всё обратно. Проверьте terraform plan. Значимых(!!) изменений быть не должно.
Приложите список выполненных команд и скриншоты процессы.

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_009.png)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_010.png)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_011.png)

## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


### Задание 4*

1. Измените модуль vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.  
  
Пример вызова
```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}
```

Предоставьте код, план выполнения, результат из консоли YC.

#### Код_Задание_04: [Код_Задание_04](https://github.com/Qshar1408/hw_04/blob/main/src/04)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_012.png)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_013.png)





### Задание 7*

1. Разверните у себя локально vault, используя docker-compose.yml в проекте.

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_014.png)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_015.png)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_016.png)


2. Для входа в web-интерфейс и авторизации terraform в vault используйте токен "education".

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_017.png)

3. Создайте новый секрет по пути http://127.0.0.1:8200/ui/vault/secrets/secret/create
Path: example  
secret data key: test 
secret data value: congrats!

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_022.png)

5. Считайте этот секрет с помощью terraform и выведите его в output по примеру:
```
provider "vault" {
 address = "http://<IP_ADDRESS>:<PORT_NUMBER>"
 skip_tls_verify = true
 token = "education"
}
data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
} 

Можно обратиться не к словарю, а конкретному ключу:
terraform console: >nonsensitive(data.vault_generic_secret.vault_example.data.<имя ключа в секрете>)
```

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_018.png)

5. Попробуйте самостоятельно разобраться в документации и записать новый секрет в vault с помощью terraform.

#### Для написания нового секрета создаю новый ресурс:

```bash
resource "vault_generic_secret" "top_secret" {
  path = "secret/example"

  data_json = jsonencode({
    top_secret = var.my_secret
  })
}
```
#### Новое значение - DevOpsMonkey 

```bash
variable "my_secret" {
  type    = string
  default = "DevOpsMonkey"
}
```

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_019.png)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_020.png)

![hw_04](https://github.com/Qshar1408/hw_04/blob/main/img/hw_04_021.png)


#### Код_Задание_07: [Код_Задание_07](https://github.com/Qshar1408/hw_07/blob/main/src/07)


### Задание 8*
Попробуйте самостоятельно разобраться в документаци и с помощью terraform remote state разделить root модуль на два отдельных root-модуля: создание VPC , создание ВМ . 

### Правила приёма работы

В своём git-репозитории создайте новую ветку terraform-04, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-04.

В качестве результата прикрепите ссылку на ветку terraform-04 в вашем репозитории.

**Важно.** Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 

