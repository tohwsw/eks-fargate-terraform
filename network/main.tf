#create VPC

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

#create public subnets

data "aws_availability_zones" "all" { }

resource "aws_subnet" "pub_subnet" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${(count.index + 1)}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

#create private subnet

resource "aws_subnet" "priv_subnet" {
  count = length(data.aws_availability_zones.all.names)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + length(data.aws_availability_zones.all.names))
  availability_zone = data.aws_availability_zones.all.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${(count.index + 1)}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

#Create internet gateway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "eks-igw"
  }
}
#Creating NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet[0].id
  tags = {
    Name = "eks-nat-gw"
  }
  depends_on = [ aws_internet_gateway.ig ]
}

#Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidr_block_igw
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "eks-public-rt"
  }
}
#Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidr_block_igw
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "eks-private-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(data.aws_availability_zones.all.names)
  subnet_id      = element(aws_subnet.pub_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(data.aws_availability_zones.all.names)
  subnet_id      = element(aws_subnet.priv_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
