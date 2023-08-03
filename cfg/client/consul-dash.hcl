data_dir = "/opt/consul"
log_level = "DEBUG"
node_name = "dashboard" 

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

retry_join = ["consul-server"]

connect {
  enabled = true
}

ports {
  grpc = 8502
}

acl {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  tokens {
    agent = "e5759802-2787-bf66-7a93-0f1e7900faad"
  }
}
