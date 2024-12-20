resource "aws_security_group" "kube-default" {
  name = "${var.name}-default-security-group"
  description = "Default security group for ${var.name}"
  vpc_id = data.aws_vpc.lab-vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "k8s-default"
  }
}
