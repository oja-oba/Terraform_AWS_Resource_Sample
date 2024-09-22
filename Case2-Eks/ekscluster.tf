#Eks cluster resource
resource "aws_eks_cluster" "aws_eks" {
    name = "eks_cluster_ore"
    role_arn = aws_iam_role.eks_cluster.arn

    vpc_config {
      subnet_ids = module.vpc.public_subnets
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    
     ]
  
    tags = {
      Name = "EKS_cluster_ore"     }

}

#worker node resource
resource "aws_eks_node_group" "node" {
    cluster_name = aws_eks_cluster.aws_eks.name
    node_group_name = "node_ore"
    node_role_arn = aws_iam_role.eks_nodes.arn
    subnet_ids = module.vpc.public_subnets
    instance_types = ["t3.micro"]
  
scaling_config {
  desired_size = 1
  max_size = 1
  min_size = 1
}

}


output "node-group" {
  value = aws_eks_node_group.node.arn
}

output "eks-name" {

  value = aws_eks_cluster.aws_eks.name
}