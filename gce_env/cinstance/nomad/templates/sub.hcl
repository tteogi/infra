bind_addr = "10.21.0.10"

advertise {
  # We need to specify our host's IP because we can't
  # advertise 0.0.0.0 to other nodes in our cluster.
  rpc = "10.21.0.10:4647"
}

# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/opt/nomad/data"

# Enable the server
server {
    enabled = true
    start_join = [&join_servers&] 
    retry_join = [&join_servers&]
    retry_interval = "15s"
}
