###cloud vars

variable "env_name" {
  type    = string
  description = "Имя облачной сети"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона, в которой создать подсеть"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "CIDR-блок для подсети"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "ssh-authorized-keys" {
  type    = list(string)
  default = ["/home/qshar/.ssh/digma.pub"]
}

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}