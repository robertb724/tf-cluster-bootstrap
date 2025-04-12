provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "k3s-ansible"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3s-ansible"
}

provider "google" {
  project = "robertb724-personal"
}
