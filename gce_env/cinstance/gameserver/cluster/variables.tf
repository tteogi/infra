variable "account_file" {
    default = "/etc/BuddyonServer-account.json"
}

variable "discovery_url" {
    default = "none"
}

variable "flannel_backend" {
    default = "vxlan"
}

variable "flannel_network" {
    default = "10.10.0.0/16"
}

variable "image" {
	default = "buddyon-v20160626"
}

variable "project" {
    default = "buddyon"
}

variable "portal_net" {
    default = "10.200.0.0/16"
}

variable "region" {
    default = "asia-east1"
}

variable "sshkey_metadata" {
}

variable "token_auth_file" {
	default = "none"
}

variable "server_count" {
    default = 2
}

variable "zone" {
    default = "asia-east1-b"
}

variable "cluster_name" {
    default = "buddyon"
}

variable "consul_servers" {
    default = "\"10.140.0.3\",\"10.140.0.2\",\"10.140.0.4\""
}

variable "nomad_servers" {
    default = "\"10.140.0.3\",\"10.140.0.2\",\"10.140.0.4\""
}

variable "consul_datacetner" {
    default = "buddyon"
}
