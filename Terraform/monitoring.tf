module "container-insights" {
  source  = "Gooygeek/container-insights/helm"
  version = "1.0.0"
  eks_cluster_name = aws_eks_cluster.my_cluster.name
  eks_oidc_provider_arn =  aws_iam_openid_connect_provider.cluster.arn
  eks_oidc_provider_url =  aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer
  iam_role_name = "eks-container-insights-role-cwagent"
  aws_region = var.aws_region
}#

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.my_cluster.identity.0.oidc.0.issuer
}
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.cluster.certificates.0.sha1_fingerprint], var.oidc_thumbprint_list)
  url = aws_eks_cluster.my_cluster.identity.0.oidc.0.issuer
}



#module "eks-cloudwatch-logs" {
#  source  = "DNXLabs/eks-cloudwatch-logs/aws"
#  version = "0.1.5"
#  cluster_identity_oidc_issuer = aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer
#  cluster_identity_oidc_issuer_arn = aws_iam_openid_connect_provider.cluster.arn
#  cluster_name = aws_eks_cluster.my_cluster.name
#  region = var.aws_region
#  worker_iam_role_name = aws_iam_role.my_node_role.name
#}
#
#module "eks-cloudwatch-metrics" {
#  source  = "DNXLabs/eks-cloudwatch-metrics/aws"
#  version = "1.0.0"
#  cluster_identity_oidc_issuer = aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer
#  cluster_identity_oidc_issuer_arn = aws_iam_openid_connect_provider.cluster.arn
#  cluster_name = aws_eks_cluster.my_cluster.name
#  worker_iam_role_name = aws_iam_role.my_node_role.name
#}
#