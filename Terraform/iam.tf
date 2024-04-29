resource "aws_iam_role" "my_eks_role" {
  name               = "my-eks-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "my_node_role" {
  name               = "my-node-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


#resource "aws_iam_role" "my_node_role" {
#  name               = "my-node-role"
#  assume_role_policy =  templatefile("oidc_assume_role_policy.json", { OIDC_ARN = aws_iam_openid_connect_provider.cluster.arn, OIDC_URL = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""), NAMESPACE = "kube-system", SA_NAME = "aws-node" })
#  tags = merge(
#    var.tags,
#    {
#      "ServiceAccountName"      = "aws-node"
#      "ServiceAccountNameSpace" = "kube-system"
#    }
#  )
#  depends_on = [aws_iam_openid_connect_provider.cluster]
#}




resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.my_eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.my_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.my_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.my_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.my_eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks-SecretsManagerReadWrite" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.my_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks-CloudWatchFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.my_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AWSOpsWorksCloudWatchLogs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
  role       = aws_iam_role.my_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks-CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.my_node_role.name
}

# RDS-Connect-Role için IAM rolü
resource "aws_iam_role" "rds_connect_role" {
  name               = "RDS-Connect-Role"
  assume_role_policy = jsonencode({
    "Version"   : "2012-10-17",
    "Statement" : [
      {
        "Effect"   : "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action"   : "sts:AssumeRole"
      }
    ]
  })
}

# IAM rolü için gerekli olan politika
resource "aws_iam_policy" "rds_connect_policy" {
  name   = "RDS-Connect-Policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "rds-db:connect"
        ],
        "Resource": [
          "arn:aws:rds:eu-central-1:533267417178:dbuser:db-X3RZY23OJOER7X6VQTLB4CVYSM/*"
        ]
      }
    ]
  })
}

# IAM politikasını IAM role ile ilişkilendirme
resource "aws_iam_role_policy_attachment" "rds_connect_role_policy_attachment" {
  role       = aws_iam_role.rds_connect_role.name
  policy_arn = aws_iam_policy.rds_connect_policy.arn
}

