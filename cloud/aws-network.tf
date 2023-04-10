data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "group-name"
    values = [var.region]
  }
}

# Main VPC resource
resource "aws_vpc" "nfd" {
  cidr_block                       = var.network_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = merge(
    { "Name" = "${var.main_project_tag}-vpc" },
    { "Project" = var.main_project_tag },
  )
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nfd.id

  tags = merge(
    { "Name" = "${var.main_project_tag}-igw" },
    { "Project" = var.main_project_tag },
  )
}

## Egress Only Gateway (IPv6)
resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.nfd.id
}


## The NAT Elastic IP
resource "aws_eip" "nat" {
  vpc = true

  tags = merge(
    { "Name" = "${var.main_project_tag}-nat-eip" },
    { "Project" = var.main_project_tag },
  )

  depends_on = [aws_internet_gateway.igw]
}

## The NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.0.id

  tags = merge(
    { "Name" = "${var.main_project_tag}-nat" },
    { "Project" = var.main_project_tag },
  )

  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.nat
  ]
}

## Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.nfd.id
  tags = merge(
    { "Name" = "${var.main_project_tag}-public-rtb" },
    { "Project" = var.main_project_tag },
  )
}

## Public routes
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

## Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.nfd.id
  tags = merge(
    { "Name" = "${var.main_project_tag}-private-rtb" },
    { "Project" = var.main_project_tag },
  )
}

## Private Routes
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "private_internet_access_ipv6" {
  route_table_id              = aws_route_table.private.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.eigw.id
}

## Public Subnets
resource "aws_subnet" "public" {
  count = var.public_subnet_count

  vpc_id                  = aws_vpc.nfd.id
  cidr_block              = local.public_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  ipv6_cidr_block                 = cidrsubnet(aws_vpc.nfd.ipv6_cidr_block, 8, count.index)
  assign_ipv6_address_on_creation = true

  tags = merge(
    { "Name" = "${var.main_project_tag}-public-${data.aws_availability_zones.available.names[count.index]}" },
    { "Project" = var.main_project_tag },
  )
}

## Private Subnets
resource "aws_subnet" "private" {
  count = var.private_subnet_count

  vpc_id = aws_vpc.nfd.id

  // Increment the netnum by the number of public subnets to avoid overlap
  cidr_block        = local.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    { "Name" = "${var.main_project_tag}-private-${data.aws_availability_zones.available.names[count.index]}" },
    { "Project" = var.main_project_tag },
  )
}

## Public Subnet Route Associations
resource "aws_route_table_association" "public" {
  count = var.public_subnet_count

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

## Private Subnet Route Associations
resource "aws_route_table_association" "private" {
  count = var.private_subnet_count

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}