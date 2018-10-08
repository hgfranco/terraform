provider "aws" {
  profile    = "${var.profile}"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami = "ami-4826c22b"
  key_name = "${aws_key_pair.webserver.key_name}"   
  instance_type = "${var.key_name}"   
  tags {
    Name = "{var.tag_name}"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

