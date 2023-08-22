server = true
bootstrap = true
log_level = "DEBUG"
node_name = "server"

data_dir = "/opt/consul"

client_addr = "0.0.0.0"
bind_addr = "0.0.0.0"

ui_config {
  enabled=true
}

connect {
  enabled = true
}

acl {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  tokens {
    initial_management = "root"
    agent = "0c390aeb-976f-f034-6168-657602a9d2b1"
  }
}
