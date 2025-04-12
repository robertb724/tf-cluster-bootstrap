resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

data "google_secret_manager_secret_version" "cloudflare_api_key" {
  secret  = "cloudflare-api-key"
  version = "latest"
}

resource "kubernetes_secret" "cloudflare_api_key" {
  metadata {
    name      = "cloudflare-api-key"
    namespace = kubernetes_namespace.external_dns.metadata[0].name
  }

  data = {
    apiKey = data.google_secret_manager_secret_version.cloudflare_api_key.secret_data
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  chart      = "external-dns"
  values = [
    file("${path.module}/values/external-dns.values.yaml"),
  ]
  version = "1.14.3"
}
