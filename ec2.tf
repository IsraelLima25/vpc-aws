resource "aws_instance" "ec2-fiap-test-public" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2Instance
  key_name               = data.aws_key_pair.lab-fiap-pair.key_name
  subnet_id              = aws_subnet.public-a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id]

  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "ec2-dev-test-public"
  }

}