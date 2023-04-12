mock "tfplan/v2" {
  module {
    source = "mock-tfplan-v2.sentinel"
  }
}

policy "unit-tests" {
 source            = "./test.sentinel"
 enforcement_level = "hard-mandatory"
}