
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_secret" "cloudflare_api_key_cert-manager" {
  metadata {
    name      = "cloudflare-api-key"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }

  data = {
    apiKey = data.google_secret_manager_secret_version.cloudflare_api_key.secret_data
  }
}


resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  chart      = "cert-manager"
  values     = [
    file("${path.module}/values/cert-manager.values.yaml"),
  ]
}
