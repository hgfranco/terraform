provider "aws" {
  profile    = "${var.profile}"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "ami-22d68434"
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

