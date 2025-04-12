resource "helm_release" "kube-prometheus-stack" {
  name             = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "monitoring"
  chart            = "kube-prometheus-stack"
  create_namespace = true
  version          = "56.8.0"
  values = [
    file("${path.module}/values/grafana.values.yaml"),
    file("${path.module}/values/prometheus.values.yaml")
  ]

  depends_on = [
    helm_release.longhorn
  ]

}

data "google_secret_manager_secret_version" "discrord_webhook_url" {
  secret  = "discord-webhook-url"
  version = "latest"
}

resource "kubernetes_secret" "discord_webhook" {
  metadata {
    name      = "discord-webhook-url"
    namespace = "monitoring"
  }

  data = {
    url = data.google_secret_manager_secret_version.discrord_webhook_url.secret_data
  }
}
