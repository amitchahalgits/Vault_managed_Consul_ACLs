service {
  name = "counting"
  port = 9003
  token = "c42c4dd5-8c6c-2b70-d75a-772f8a2d3982"
  connect {
    sidecar_service {}
  }

  check {
    id       = "counting-check"
    http     = "http://localhost:9003/health"
    method   = "GET"
    interval = "10s"
    timeout  = "1s"
  }
}

