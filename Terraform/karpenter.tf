data "aws_eks_cluster" "eks_k8s" {
  name = aws_eks_cluster.my_cluster.name
}

module "eks-cluster-autoscaler" {
  source  = "mrnim94/eks-cluster-autoscaler/aws"
  version = "1.0.2"

  aws_region = var.aws_region
  environment = "default"
  business_divsion = "nimtechnology"

  eks_cluster_certificate_authority_data = data.aws_eks_cluster.eks_k8s.certificate_authority[0].data
  eks_cluster_endpoint = data.aws_eks_cluster.eks_k8s.endpoint
  eks_cluster_id = aws_eks_cluster.my_cluster.name
  aws_iam_openid_connect_provider_arn = aws_iam_openid_connect_provider.cluster.arn
}