provider "aws" {
  region = "eu-west-1" # Change to your desired region
}

# resource "tls_private_key" "key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# resource "aws_key_pair" "example" {
#   key_name   = "my-key-pair"
# #   public_key = file("${path.module}/your_public_key.pub")
#    public_key = tls_private_key.example.public_key_openssh
#    tags = {
#     Name = "Ansibletest"    
#   }
# }

# // Creates a secret manager secret for the public key
# resource "aws_secretsmanager_secret" "keys_sm_secret" {
#   count              = var.create_keypair_sm_entry ? 1 : 0
#   name   = "${var.aws_resource_identifier_supershort}-sm-${random_string.random.result}"
# }

resource "aws_instance" "example" {
  ami           = "ami-06ed60ed1369448bd" # Change to your desired AMI
  instance_type = "t3.micro"
  key_name      = "ansibletestmanual"//aws_key_pair.example.key_name
  subnet_id                   = "subnet-0eeed545965bcc422"
  security_groups = [aws_security_group.example.id]
  iam_instance_profile = "ansibletest"
  associate_public_ip_address =   "true"
  tags = {
    Name = "Ansibletest"    
  }
}


resource "aws_security_group" "example" {
  name        = "allow-ssh"
  description = "Allow SSH access"
  vpc_id      = "vpc-01f8cf2855398cc3c"  # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # You can restrict this to specific IP ranges
  }

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

// Terraform requires egress to be defined as it is disabled by default..
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ansibletest"   
    NaTestme = "Ansibletest"  
  }
}

# output "ec2_private_ip" {
#    value = aws_instance.example.private_ip
# }

# output "myprivate_key"{
#   value=  tls_private_key.example.public_key_openssh 
# }

# output "key_pair_name" {
#   value = aws_key_pair.example.key_name
# }

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}