# Provider configuration
provider "aws" {
  region = var.region
}

# Data sources
data "aws_availability_zones" "available" {}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "prod/network/terraform.tfstate"
    region = var.region
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Key pair
resource "aws_key_pair" "deployer" {
  key_name   = "access_key"
   public_key = file("${path.module}/access_key.pub")
}

# Webservers
resource "aws_instance" "webservers" {
  count         = 4
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids      = [aws_security_group.webserver.id]
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[count.index]
  associate_public_ip_address = true


  user_data = base64encode(templatefile("${path.module}/install_httpd.sh", {
    env = var.env
  }))

  tags = merge(
    {
      Name = "Webserver${count.index + 1}"
    },
    count.index > 1 ? { Owner = "acs730" } : {}
  )
}

# DB Server 5 (Private)
resource "aws_instance" "db_server5" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id              = data.terraform_remote_state.network.outputs.private_subnet_ids[0]

  user_data = base64encode(templatefile("${path.module}/install_db.sh", {
    env = var.env
  }))

  tags = {
    Name = "DB Server 5"
  }
}


# VM6 (Private)
resource "aws_instance" "VM6" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id              = data.terraform_remote_state.network.outputs.private_subnet_ids[1]


  tags = {
    Name = "VM6 (Private)"
  }
}