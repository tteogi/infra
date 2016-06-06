variable "account_file" {
    default = "/etc/BuddyonServer-account.json"
}

variable "discovery_url" {}

variable "flannel_backend" {
    default = "vxlan"
}

variable "flannel_network" {
    default = "10.10.0.0/16"
}

variable "image" {}

variable "project" {}

variable "portal_net" {
    default = "10.200.0.0/16"
}

variable "region" {
    default = "us-central1"
}

variable "sshkey_metadata" {}

variable "token_auth_file" {}

variable "worker_count" {
    default = 3
}

variable "zone" {
    default = "us-central1-a"
}

variable "cluster_name" {
    default = "testing"
}
