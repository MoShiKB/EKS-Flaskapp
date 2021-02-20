resource "aws_security_group" "worker-SG" {
  name        = "worker-SG"
  description = "Security Group for EKS nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}