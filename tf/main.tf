terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.20"
    }
  }
}

variable "do_token" {
  sensitive = true
}
variable "private_key" {
  sensitive = true
  type = string
  default = "~/.ssh/id_rsa"
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "chervie" {
  name = "chervie"
}
