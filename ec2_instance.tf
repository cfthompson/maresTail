terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "gamesInstance" {
  count         = var.awsProvider ? 1 : 0
  ami           = var.ami
  instance_type = var.instance_type
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }
  vpc_security_group_ids = [var.secgroup]
  user_data              = file("userdata.ps1")
  key_name               = var.key
  get_password_data      = true

  tags = {
    Name = "GamesExp"
  }
}

resource "local_file" "rdp-script" {
  count           = var.awsProvider ? 1 : 0
  depends_on      = [aws_instance.gamesInstance[0]]
  filename        = "rdp-instance.sh"
  file_permission = "0750"
  content         = <<EOF
 xfreerdp /u:administrator /v:${aws_instance.gamesInstance[0].public_ip} /p:"${rsadecrypt(aws_instance.gamesInstance[0].password_data, file(local.keypath))}"
	EOF
}

locals {
  keypath = join("", ["~/.ssh/", var.key, ".pem"])
}
