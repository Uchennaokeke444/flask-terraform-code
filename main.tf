provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "flask_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt install docker.io -y
sudo apt install python3-pip -y
sudo pip3 install flask
sudo apt install git
mkdir /home/ubuntu/app
cd /home/ubuntu/app
git clone https://github.com/Uchennaokeke444/flask-docker-hello-world.git
cd flask-docker-hello-world
docker build -t simple-flask-app:latest .
docker run -d -p 5000:5000 simple-flask-app

EOF

  tags = {
    Name = "flask-hello-world"
  }
}

resource "aws_security_group" "allow_connect" {
  name        = "allow_http"
  description = "Allow inbound HTTP traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "server_public_ip" {
  value = aws_instance.flask_server.public_ip
}