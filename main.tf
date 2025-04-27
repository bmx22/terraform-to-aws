#key pair
resource "aws_key_pair" "techno-kp" {
  key_name   = "dev-key"
  public_key = file("~/.ssh/techno-key.pub")
}

#instance
resource "aws_instance" "techno-node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.techno-server-ami.id
  key_name               = aws_key_pair.techno-kp.id
  vpc_security_group_ids = [aws_security_group.techno-sg.id]
  subnet_id              = aws_subnet.techno-public.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "~/.ssh/techno-key"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }

  tags = {
    Name = "dev-node"
  }
}