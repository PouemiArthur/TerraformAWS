resource "aws_vpc" "rdsvpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "pjrsub" {
  vpc_id = aws_vpc.rdsvpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "pjrigw" {
  vpc_id = aws_vpc.rdsvpc.id
}

resource "aws_route_table" "pjrroutetable" {
  vpc_id = aws_vpc.rdsvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pjrigw.id
    }
}

resource "aws_route_table_association" "pjrrtassoc" {
  subnet_id = aws_subnet.pjrsub.id
  route_table_id = aws_route_table.pjrroutetable.id
  }

resource "aws_subnet" "pjrrdssubneta" {
  vpc_id = aws_vpc.rdsvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "pjrrdssubnetb" {
  vpc_id = aws_vpc.rdsvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
}

resource "aws_db_subnet_group" "pjrrdssubnet" {
  name = "pjrrdssubnetg"
  subnet_ids = [aws_subnet.pjrrdssubneta.id, aws_subnet.pjrrdssubnetb.id]
  }

resource "aws_security_group" "ec2sg" {
  name = "pjrsecgroup"
  vpc_id = aws_vpc.rdsvpc.id

  ingress {
    description = "http"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    }
  egress {
    description = "allow_all"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "rdssg" {
  name = "pjrrdssg"
  vpc_id = aws_vpc.rdsvpc.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "TCP"
    security_groups = [aws_security_group.ec2sg.id]
    }
}

resource "aws_key_pair" "pjrkey" {
  key_name = "mypckey"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "pjrec2" {
  ami = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name = aws_key_pair.pjrkey.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.pjrsub.id
  vpc_security_group_ids = [aws_security_group.ec2sg.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = 16
    delete_on_termination = true
    encrypted = true
    }
}

resource "aws_db_instance" "pjrrds" {
  allocated_storage = 20
  db_name = "pjrmydatabase"
  engine = "postgres"
  engine_version = "17.9"
  instance_class = "db.t3.micro"
  username = "pouemiarthur"
  password = "PJrRDS#7"
  db_subnet_group_name = aws_db_subnet_group.pjrrdssubnet.name
  vpc_security_group_ids = [aws_security_group.rdssg.id]
  skip_final_snapshot = true
  publicly_accessible = false
}
