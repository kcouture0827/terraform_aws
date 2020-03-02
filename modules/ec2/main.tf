resource "aws_instance" "test-instance-1" {
  ami           = "ami-0a887e401f7654935"
  instance_type = "t2.micro"
}

resource "aws_instance" "test-instance-2" {
  ami           = "ami-0a887e401f7654935"
  instance_type = "t2.micro"
}