resource "aws_instance" "jenkins" {
  ami           = "ami-0edab8d70528476d3"
  instance_type = "t2.micro"
  key_name      = "<key name>"
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
}

resource "aws_security_group" "Jenkins_SG" {
  name_prefix = "Jenkins-SG"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "ec2_ip" {
  value = aws_instance.jenkins.public_ip
}