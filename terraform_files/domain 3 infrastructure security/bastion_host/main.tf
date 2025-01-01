resource "aws_security_group" "private_subnet_sg" {
  name        = "private-subnet-sg"
  description = "Security group for private subnet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_instance.bastion.public_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-subnet-sg"
  }
}

resource "aws_security_group" "public_subnet_sg" {
  name        = "public-subnet-sg"
  description = "Security group for public subnet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-subnet-sg"
  }
}


resource "aws_instance" "bastion" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
}


resource "aws_subnet" "public_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.1.0/24" # Adjust the CIDR block as needed
  availability_zone = "us-west-2a"  # Adjust the availability zone as needed

  tags = {
    Name = "public-subnet"
  }
}
