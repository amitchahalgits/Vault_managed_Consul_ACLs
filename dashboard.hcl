service {
  name = "dashboard"
  port = 9002
  token = "a9eefa52-b8f8-4741-5dc9-7340790ab613"
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

