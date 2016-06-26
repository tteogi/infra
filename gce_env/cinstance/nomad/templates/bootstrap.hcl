# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/opt/datas/nomad"

name = "${node_name}"

datacenter = "${datacenter}"

# Enable the server
server {
    enabled = true

    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = ${server_count}
}