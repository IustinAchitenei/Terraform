# t3.public.1 (must research list, both or even all 3 instances should be done in one go)

resource "aws_instance" "iustin-ec2-pu1"{
	ami = "${lookup(var.AMI, var.AWS_REGION)}"
	instance_type = "t3.micro"

	subnet_id = "${aws_subnet.iustin-subnet-pu1.id}"
	
	vpc_security_group_ids = ["${aws_security_group.iustin-port-sec}"]

	key_name = "${aws_key_pair.iustin-paris-key-pair.id}"

	provisioner "file" {
		source = "nginx.sh"
		destination = "/tmp/nginx.sh"
	}

	provisioner "remote-exec" {
		in-line = [
			"chmod+x /tmp/nginx.sh",
			"sudo/tml/nginx.sh"
		]
	}

	connection {
		user = "${var.EC2_USER}"
		private_key = "${file("${var.iustin-paris-key-pair.pub}")}"
	}
}

# t3.public.2

resource "aws_instance" "iustin-ec2-pu2"{
	ami = "${lookup(var.AMI, var.AWS_REGION)}"
	instance_type = "t3.micro"

	subnet_id = "${aws_subnet.iustin-subnet-pu2.id}"
	
	vpc_security_group_ids = ["${aws_security_group.iustin-port-sec}"]

	key_name = "${aws_key_pair.iustin-paris-key-pair.id}"

	provisioner "file" {
		source = "nginx.sh"
		destination = "/tmp/nginx.sh"
	}

	provisioner "remote-exec" {
		in-line = [
			"chmod+x /tmp/nginx.sh",
			"sudo/tml/nginx.sh"
		]
	}

	connection {
		user = "${var.EC2_USER}"
		private_key = "${file("${var.iustin-paris-key-pair.pub}")}"
	}
}

# t3.private.only

resource "aws_instance" "iustin-ec2-pr1"{
	ami = "${lookup(var.AMI, var.AWS_REGION)}"
	instance_type = "t3.micro"

	subnet_id = "${aws_subnet.iustin-subnet-pr1.id}"
	
	vpc_security_group_ids = ["${aws_security_group.iustin-port-sec-private}"]

	key_name = "${aws_key_pair.iustin-paris-key-pair.id}"

	provisioner "file" {
		source = "nginx.sh"
		destination = "/tmp/nginx.sh"
	}

	provisioner "remote-exec" {
		in-line = [
			"chmod+x /tmp/nginx.sh",
			"sudo/tml/nginx.sh"
		]
	}

	connection {
		user = "${var.EC2_USER}"
		private_key = "${file("${var.iustin-paris-key-pair.pub}")}"
	}
}

#key pair with the ssh-keygen -f iustin-paris-region-key-pair

resource "aws_key_pair" "iustin-paris-key-pair"{
	key_name = "iustin-paris-key-pair"
	public_key = "${file(iustin-paris-key-pair.pub)}"
}
	
