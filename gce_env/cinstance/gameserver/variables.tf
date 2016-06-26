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
	default = "buddyon-v20160611-2"
}

variable "project" {
    default = "buddyonserver"
}

variable "portal_net" {
    default = "10.200.0.0/16"
}

variable "region" {
    default = "us-central1"
}

variable "sshkey_metadata" {
	default = "core: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfuvpdY6YGFvxVrYg5bsSnwxdpvl3KOfYNkC72ilUcp4Ax+1pP75dalspRylB1D7rrL0xQR0hzKu+7nBcYmvw2EhJifH0ESm3ICKaw0yvy2At6X+UlzR3YhnmJ84+HfLNetdGpc+qRKRR6FZqiO5fUw8Lyp+SAsrWPFOOuHYObUmcLrkJl0Ii/3oEjyWgAXtTcIKn4Iu+utGzmipwmOam0LoWhIrhoF7CBmM1mccSblJ1pCKgGcSyHUb0WwL/Yi1Fh6Vm2VW2g71VydCvr5VEPylsNWd9zoNxEAzUpUM9E4JBfkfLl9bsPReKDvGc0pyLRL6g/23Px2M1C+YlQ40z5 ubuntu@ubuntu-xenial"
}

variable "token_auth_file" {
	default = "none"
}

variable "server_count" {
    default = 1
}

variable "zone" {
    default = "us-central1-a"
}

variable "cluster_name" {
    default = "buddyon"
}

variable "consul_address" {
    default = "130.211.201.245"
}

variable "nomad_address" {
    default = "130.211.201.245"
}

variable "consul_datacetner" {
    default = "buddyon"
}
