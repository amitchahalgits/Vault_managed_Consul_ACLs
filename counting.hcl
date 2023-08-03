service {
  name = "counting"
  port = 9003
  token = "a9eefa52-b8f8-4741-5dc9-7340790ab613"
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

