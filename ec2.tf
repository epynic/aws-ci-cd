# EC2 instance & SSH keypairs 
resource "aws_instance" "prod_jump_box" {
  ami           = "ami-0b9694372522e2b59"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.jump_box_server_keypair.id

  subnet_id                   = aws_subnet.prod_public_subnet_1a.id
  vpc_security_group_ids      = [aws_security_group.prod_public_ssh_sg.id]
  associate_public_ip_address = true

  tags = {
    Env  = var.infra_env
    Name = "${var.infra_name}-jump-box"
  }
}

# ssh keypair - generate
resource "tls_private_key" "generated_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jump_box_server_keypair" {
  key_name   = "jump_box_server"
  public_key = tls_private_key.generated_keypair.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.generated_keypair.private_key_pem}' > ./jump_box.pem && chmod 400 ./jump_box.pem"
  }
}

# EIP
resource "aws_eip_association" "eip_jump_box_assoc" {
  instance_id   = aws_instance.prod_jump_box.id
  allocation_id = aws_eip.prod_public_eip.id
}