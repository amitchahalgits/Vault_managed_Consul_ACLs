service {
  name = "dashboard"
  port = 9002
  token = "c42c4dd5-8c6c-2b70-d75a-772f8a2d3982"
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

