bind_addr = "0.0.0.0"

# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/opt/datas/nomad"

name = "${node_name}"

datacenter = "${datacenter}"

advertise {
	http = "&my_address&:4646"
	rpc = "&my_address&:4647"
	serf = "&my_address&:4648"
}

addresses {
	rpc = "&my_address&"
	serf = "&my_address&"
}

# Enable the server
server {
    enabled = true

    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = ${server_count}
}

consul {
  server_auto_join =  true
  client_auto_join =  true
}