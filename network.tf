
# gateway

resource "aws_internet_gateway" "iustin-igw"{
	vpc_id = "${aws_vpc.iustin-vpc.id}"
	tags = {
		Name = "iustin-igw"
	}
}

#route table

resource "aws_route_table" "iustin-public-rt"{
	vpc_id = "${aws_vpc.iustin-vpc.id}"
	route{
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.iustin-igw.id}"
	}
	tags = {
		Name = "iustin-public-rt"
	}
}

#route table association

resource "aws_route_table_association" "iustin-crta-public-subnet1"{
	subnet_id = "${aws_subnet.iustin-subnet-pu1}"
	route_table_id = "${aws_route_table.iustin-public-rt.id}"
}

#public ip

data "http" "myip"{
	url = "http://ipv4.icanhazip.com"
}

# security group public

resource "aws_security_group" "iustin-port-sec"{
	vpc_id = "${aws_vpc.iustin-vpc.id}"

	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
		#or cidr_blocks = ["94.177.40.42"] - result of interrogating the public ip from my laptop/above - public ip of the maschine doing the request
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "iustin-port-sec"
	}
} 

#security group private

resource "aws_security_group" "iustin-port-sec-private"{
	vpc_id = "${aws_vpc.iustin-vpc.id}"

	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = ["0.0.0.0/0"]
	}

	# tcp connection only from the first of the public instances

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["10.0.1.0/24"]
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "iustin-port-sec-private"
	}
} 