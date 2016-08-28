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

variable "nomad_datacenter" {
    default = "buddyon"
}

variable "consul_datacenter" {
    default = "buddyon"
}

variable "server_count" {
	default = 1
}

variable "sshkey_metadata" {
}

variable "machine_type" {
	default = "n1-standard-1"
}