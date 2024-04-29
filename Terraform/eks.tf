resource "aws_eks_cluster" "my_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.my_eks_role.arn
  enabled_cluster_log_types = ["audit", "api", "authenticator","scheduler"]

  vpc_config {
    subnet_ids            = values(aws_subnet.private_subnets)[*].id
    security_group_ids    = [aws_security_group.my_sg.id]
    endpoint_public_access    = true
    endpoint_private_access   = true
    public_access_cidrs    = ["0.0.0.0/0"]
  }

  depends_on = [aws_subnet.private_subnets, aws_security_group.my_sg]
}


resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.my_node_role.arn
  subnet_ids      = [aws_subnet.private_subnets["private_subnet_1"].id]
  instance_types  = ["t3.medium"]
  ami_type        = "AL2_x86_64"
 scaling_config {
   desired_size = 2
   min_size     = 1
   max_size     = 3
 }
 
}


