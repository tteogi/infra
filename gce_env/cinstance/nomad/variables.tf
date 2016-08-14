variable "account_file" {
    default = "/etc/BuddyonServer-account.json"
}

variable "image" {
	default = "buddyon-v20160626"
}

variable "project" {
}

variable "region" {
    default = "asia-east1"
}

variable "zone" {
    default = "asia-east1-b"
}

variable "cluster_name" {
    default = "buddyon"
}

variable "nomad_datacenter" {
    default = "buddyon"
}

variable "server_count" {
	default = 3
}

variable "sshkey_metadata" {
}
