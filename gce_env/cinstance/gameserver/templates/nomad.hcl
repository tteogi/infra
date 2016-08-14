# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/opt/datas/nomad"

enable_debug = true

bind_addr    = "0.0.0.0"

name = "${node_name}"

datacenter = "${datacenter}"

region = "${region}"

advertise {
  http = "&my_address&:4646"
  rpc  = "&my_address&:4647"
  serf = "&my_address&:4648"
}

consul {
  server_auto_join =  true
  client_auto_join =  true
}

# Enable the client
client {
    enabled = true
    # For demo assume we are talking to server1. For production,
    # this should be like "nomad.service.consul:4647" and a system
    # like Consul used for service discovery.
    servers = [${servers}]

    options {
      "docker.cleanup.image"   = "0"
      "driver.raw_exec.enable" = "1"
    }
    meta {
      region = "${region}"
    }
}