resource "aws_vpc" "vpcresource" {
  cidr_block = "192.30.40.0/24"
  tags = {
    Name = "vpc01"
  }
}
resource "aws_subnet" "publicsubnetresource" {
  vpc_id     = "${aws_vpc.vpcresource.id}"
  cidr_block = "192.30.40.0/27"

  tags = {
    Name = "public_subnet"
  }
}
resource "aws_subnet" "privatesubnetresource" {
  vpc_id     = "${aws_vpc.vpcresource.id}"
  cidr_block = "192.30.40.32/27"

  tags = {
    Name = "private_subnet"
  }
}
resource "aws_internet_gateway" "intgatewayresource" {
  vpc_id = "${aws_vpc.vpcresource.id}"

  tags = {
    Name = "internetgateway"
  }
}
resource "aws_nat_gateway" "natresource" {
  connectivity_type = "private"
  subnet_id         = "${aws_subnet.pubsubnetresource.id}"
}
resource "aws_route_table" "publicrouteresource" {
  vpc_id = "${aws_vpc.vpcresource.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.intgatewayresource.id}"
  }
  tags = {
    Name = "publicroute"
  }
}
resource "aws_route_table_association" "pubassociation" {
  subnet_id      = "${aws_subnet.pubsubnetresource.id}"
  route_table_id = "${aws_route_table.pubrouteresource.id}"
}
resource "aws_route_table" "privaterouteresource" {
  vpc_id = "${aws_vpc.vpcresource.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natresource.id}"
  }
  tags = {
    Name = "privateroute"
  }
}
resource "aws_route_table_association" "priassociation" {
  subnet_id      = "${aws_subnet.privatesubnetresource.id}"
  route_table_id = "${aws_route_table.privaterouteresource.id}"
}

