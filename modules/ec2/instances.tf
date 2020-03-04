# Key Pair for our instance
resource "aws_key_pair" "keypair" {
  key_name   = "mykey"
  public_key = file("/home/kevin/.ssh/terraform.pub")
}


# EC2 instance with NGINX bootstraping
resource "aws_instance" "test-instance" {
  count         = var.ec2_count
  key_name      = aws_key_pair.keypair.key_name
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [
      var.security_group_id,
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/kevin/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras enable nginx1.12",
      "sudo yum -y install nginx",
      "sudo systemctl start nginx"
    ]
  }

  tags = {
    Name = "nginx"
  }
}
