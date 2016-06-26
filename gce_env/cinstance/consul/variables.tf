variable "account_file" {
    default = "/etc/BuddyonServer-account.json"
}

variable "image" {
	default = "buddyon-v20160626"
}

variable "project" {
    default = "buddyonserver"
}

variable "region" {
    default = "us-central1"
}

variable "zone" {
    default = "us-central1-a"
}

variable "cluster_name" {
    default = "buddyon"
}

variable "consul_datacenter" {
    default = "buddyon"
}

variable "server_count" {
	default = 3
}

variable "sshkey_metadata" {
	default = "core: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfuvpdY6YGFvxVrYg5bsSnwxdpvl3KOfYNkC72ilUcp4Ax+1pP75dalspRylB1D7rrL0xQR0hzKu+7nBcYmvw2EhJifH0ESm3ICKaw0yvy2At6X+UlzR3YhnmJ84+HfLNetdGpc+qRKRR6FZqiO5fUw8Lyp+SAsrWPFOOuHYObUmcLrkJl0Ii/3oEjyWgAXtTcIKn4Iu+utGzmipwmOam0LoWhIrhoF7CBmM1mccSblJ1pCKgGcSyHUb0WwL/Yi1Fh6Vm2VW2g71VydCvr5VEPylsNWd9zoNxEAzUpUM9E4JBfkfLl9bsPReKDvGc0pyLRL6g/23Px2M1C+YlQ40z5 ubuntu@ubuntu-xenial"
}
