	resource "kubernetes_manifest" "backend-argocd-job" {
 

  manifest  = yamldecode(file("../ArgoCD/backendjob.yaml"))

}

#resource "kubernetes_manifest" "frontend-argocd-job" {
# 
#
#  manifest  = yamldecode(file("../ArgoCD/frontendjob.yaml"))
#}

resource "kubernetes_manifest" "repo-argocd-job" {
 

  manifest  = yamldecode(file("../ArgoCD/repo.yaml"))
}

resource "kubernetes_manifest" "serviceaccount-argocd-job" {
 

  manifest  = yamldecode(file("../ArgoCD/serviceaccount.yaml"))
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  namespace  = "kube-system"
}

