data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "test" {
  count                  = length(var.subnet_ids)
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.test.id]
  key_name               = var.key_pair_name
  subnet_id              = var.subnet_ids[count.index]
  tags = {
    Name    = "${var.main_project_tag}"
    Purpose = "Testing VPC"
  }
}

resource "aws_security_group" "test" {
  name        = var.main_project_tag
  description = "Security group for test instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.main_project_tag}"
    Purpose = "Testing VPC"
  }
}

resource "terraform_data" "test" {
  count            = length(aws_instance.test)
  triggers_replace = [aws_instance.test[count.index].id]

  connection {
    host        = aws_instance.test[count.index].public_ip
    user        = "ubuntu"
    private_key = file(var.key_pair_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "echo success"
    ]
  }
}