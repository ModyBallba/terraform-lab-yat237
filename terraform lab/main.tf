provider "aws" {
  region = var.aws_region
}

# 1. Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MyVPC"
  }
}

# 2. Create AWS Internet Gateway
resource "aws_internet_gateway" "My_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MyGateway"
  }
}

# 3. Create public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.My_gw.id
  }

  tags = {
    Name = "PublicRoute"
  }
}

# 4. Create private route table
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRoute"
  }
}

# 5. Create subnets
resource "aws_subnet" "Public_Subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block             = var.public_subnet_cidr
  availability_zone      = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "Private_Subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block             = var.private_subnet_cidr
  availability_zone      = var.availability_zone

  tags = {
    Name = "Private Subnet"
  }
}

# 6. Route Table Associations
resource "aws_route_table_association" "rt_associate_public" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_associate_private" {
  subnet_id      = aws_subnet.Private_Subnet.id
  route_table_id = aws_route_table.private_route.id
}

# 7. Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Security group for Bastion host"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "BastionSG"
  }
}

resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.bastion_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_egress" {
  type              = "egress"
  security_group_id = aws_security_group.bastion_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# 8. Security Group for Application Server
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for Application server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "AppSG"
  }
}

resource "aws_security_group_rule" "app_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.app_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
}

resource "aws_security_group_rule" "app_port_3000" {
  type              = "ingress"
  security_group_id = aws_security_group.app_sg.id
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
}

resource "aws_security_group_rule" "app_egress" {
  type              = "egress"
  security_group_id = aws_security_group.app_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# 9. Bastion Host Instance
resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Public_Subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "BastionHost"
  }
}

# 10. Application Server Instance
resource "aws_instance" "app" {
  ami                    = var.app_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.Private_Subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "AppServer"
  }
}
