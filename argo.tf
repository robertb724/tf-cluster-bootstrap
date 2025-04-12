resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = kubernetes_namespace.argo.metadata[0].name
  chart      = "argo-cd"
  values     = [file("${path.module}/values/argo.values.yaml")]
  # version          = "1.7.2"
}

resource "kubernetes_secret" "argocd_git_repo" {
  metadata {
    name      = "homelab-argocd-git-repo"
    namespace = kubernetes_namespace.argo.metadata[0].name
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    url      = "https://github.com/robertb724/homelab-argo"
  }
  type = "Opaque"
}
