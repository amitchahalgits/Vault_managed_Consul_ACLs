service {
  name = "counting"
  port = 9003
  token = "851d1349-0f1d-eb7f-d030-421fc03ee9ac"
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

