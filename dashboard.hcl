service {
  name = "dashboard"
  port = 9002
  token = "13c90f32-5862-f2fc-9556-6614aa5333f9"
  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "counting"
            local_bind_port  = 5000
          }
        ]
      }
    }
  }

  check {
    id       = "dashboard-check"
    http     = "http://localhost:9002/health"
    method   = "GET"
    interval = "10s"
    timeout  = "1s"
  }
}

