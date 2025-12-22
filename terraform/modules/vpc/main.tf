
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "poc-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

# resource "aws_subnet" "public" {
#   count                   = 2
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
#   availability_zone       = var.azs[count.index]
#   map_public_ip_on_launch = true
#   tags = { Name = "public-${count.index}" }
# }


resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${var.azs[count.index]}"
    Tier = "public"
  }
}

resource "aws_subnet" "private_platform" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 2)
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-platform-${var.azs[count.index]}"
    Tier = "private"
    Role = "platform"
  }
}

resource "aws_subnet" "private_workload" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 4)
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-workload-${var.azs[count.index]}"
    Tier = "private"
    Role = "workload"
  }
}

# resource "aws_subnet" "private" {
#   count             = 4
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + 2)
#   availability_zone = var.azs[count.index % 2]
#   tags = { Name = "private-${count.index}" }
# }

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "pub" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# resource "aws_route_table_association" "priv" {
#   count          = 4
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

resource "aws_route_table_association" "private_platform" {
  count          = length(aws_subnet.private_platform)
  subnet_id      = aws_subnet.private_platform[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_workload" {
  count          = length(aws_subnet.private_workload)
  subnet_id      = aws_subnet.private_workload[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_cloudwatch_log_group" "flowlogs" {
  name              = "/aws/vpc/flowlogs"
  retention_in_days = 14
}

resource "aws_iam_role" "flowlogs" {
  name = "vpc-flowlogs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "flowlogs" {
  role = aws_iam_role.flowlogs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "this" {
  vpc_id          = aws_vpc.this.id
  traffic_type    = "ALL"
  log_destination = aws_cloudwatch_log_group.flowlogs.arn
  iam_role_arn   = aws_iam_role.flowlogs.arn
}
