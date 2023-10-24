provider "aws" {
  region = "af-south-1" # Change to your desired region
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = file("${path.module}/your_public_key.pub")
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Change to your desired AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name
}

output "key_pair_name" {
  value = aws_key_pair.example.key_name
}

output "public_ip" {
  value = aws_instance.example.public_ip
}