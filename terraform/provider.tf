provider "aws" {
        region = "us-west-2"
}

resource "aws_instance" "my-instance" {
  ami = "ami-0ecc74eca1d66d8a6"
  instance_type = "t2.micro"
  key_name = "hghg"
  vpc_security_group_ids = [aws_security_group.z1security.id]
  user_data = <<-EOF
  #! /bin/bash
  #!/bin/bash
  sudo apt update -y
  sudo apt install default-jre -y
  sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  sudo apt update
  sudo apt install jenkins -y
  sudo jenkins --version
  sudo systemctl start jenkins
  echo "get access to jenkins"
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  EOF
  tags = {
    Name = "jenkins"
  }
}
