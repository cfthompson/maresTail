terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "gamesInstance" {
  ami           = var.ami
  instance_type = var.instance_type
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }
  vpc_security_group_ids = [var.secgroup]
  user_data = file("userdata.ps1")
  key_name               = var.key

  tags = {
    Name = "GamesExp"
  }
}
