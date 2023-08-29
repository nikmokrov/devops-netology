# Variables
variable "yandex_cloud_id" {
  default = "b1gcn03m319mu8kiic9q"
}

variable "yandex_folder_id" {
  default = "b1ga7t052sv70padtm26"
}

variable "zone" {
  default = "ru-central1-b"
}

variable "image_id" {
  type = string
  # default = "fd8jvcoeij6u9se84dt5" # centos-7-base
  # default = "fd89dg1rq7uqslc6eigm" # debian-11
  # default = "fd8ps4vdhf5hhuj8obp2" # ubuntu-2204-lts
  default = "fd8s1rt9rlesqptbevhg" # ubuntu-2004-lts
}

variable "ssh_user" {
  # default = "centos"
  # default = "debian"
  default = "ubuntu"
}

variable "k8s_version" {
  default = "1.25"
}