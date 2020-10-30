terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "gamesInstance" {
  ami           = var.ami
  instance_type = var.instance_type
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }
  vpc_security_group_ids = [var.secgroup]
  user_data              = file("userdata.ps1")
  key_name               = var.key
  # get_password_data = true

  tags = {
    Name = "GamesExp"
  }
}

#resource "local_file" "rdp-script" {
#	filename = "rdp-instance.sh"
#	file_permission = "0750"
#	content = <<EOF
#  xfreerdp /u:administrator /v:${aws_instance.gamesInstance.public_ip} /p:base64decode(aws_instance.gamesInstance.password_data)
#	EOF
#}