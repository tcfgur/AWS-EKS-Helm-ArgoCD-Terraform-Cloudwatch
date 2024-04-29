resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.46.0"
  create_namespace = true
  values     = [templatefile("install.yaml", {})]
  wait       = false 
  depends_on = [aws_eks_cluster.my_cluster]
}

