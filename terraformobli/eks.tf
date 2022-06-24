resource "aws_eks_cluster" "obligatorio" {
  name     = "obligatorio"
  role_arn = "arn:aws:iam::170695521185:role/LabRole"

  vpc_config {
    subnet_ids = [aws_subnet.obligatorio-subnet-private1.id, aws_subnet.obligatorio-subnet-private2.id]
  }
  depends_on = [
  ]
}

output "endpoint" {
  value = aws_eks_cluster.obligatorio.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.obligatorio.certificate_authority[0].data
}
resource "aws_eks_node_group" "workersobli" {
  cluster_name    = aws_eks_cluster.obligatorio.name
  node_group_name = "workersoblig"
  node_role_arn   = "arn:aws:iam::170695521185:role/LabRole"
  subnet_ids = [aws_subnet.obligatorio-subnet-private1.id, aws_subnet.obligatorio-subnet-private2.id]


  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 2
  }
}
