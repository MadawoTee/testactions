provider "aws" {
  region = "af-south-1" # Change to your desired region
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
#   public_key = file("${path.module}/your_public_key.pub")
   public_key = tls_private_key.key.public_key_openssh
}

# // Creates a secret manager secret for the public key
# resource "aws_secretsmanager_secret" "keys_sm_secret" {
#   count              = var.create_keypair_sm_entry ? 1 : 0
#   name   = "${var.aws_resource_identifier_supershort}-sm-${random_string.random.result}"
# }

resource "aws_instance" "example" {
  ami           = "ami-05759acc7d8973892" # Change to your desired AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.example.key_name
  subnet_id                   = "subnet-0ad95192385c5946c"
}

output "key_pair_name" {
  value = aws_key_pair.example.key_name
}

output "public_ip" {
  value = aws_instance.example.public_ip
}