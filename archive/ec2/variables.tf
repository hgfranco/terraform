variable "region" {
        default = "us-west-1"
}

variable "profile" {
    description = "AWS credentials profile you want to use"
}

variable "instance_type" {
        default = "m4.large"
}

variable "ami" {
        default = "ami-4826c22b"
}
