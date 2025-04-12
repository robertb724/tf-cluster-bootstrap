terraform {
  backend "gcs" {
    bucket  = "robertb724-tfstate"
    prefix  = "homelab/"
  }
}
