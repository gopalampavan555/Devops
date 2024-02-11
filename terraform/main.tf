terraform {
  required_version = ">= 0.13"

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0ba98499caf94125a"
  instance_type = "t2.micro"
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
