resource "aws_security_group" "games" {
  count  = 0
  name   = "games-rdp"
  vpc_id = var.vpcid

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    # it really sucks that terraform doesn't seem to be able to do the "My IP" thing for the source addrss in a security group
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
