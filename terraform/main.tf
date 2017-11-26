provider "aws" {
  region = "us-west-2"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = "${aws_instance.docker-standalone.id}"
  allocation_id = "${aws_eip.docker-standalone-ip.id}"
}

resource "aws_instance" "docker-standalone" {
  count = 1
  key_name = "${var.aws_keypair}"
  tags {
    Name = "myintuit-app"
    Type = "intuit-tomcat"
    finance = "self"
    Owner = "${var.aws_keypair}"
  }
  instance_type = "t2.micro"
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
  availability_zone = "us-west-2a"
  ami = "ami-0a00ce72"
}

resource "aws_eip" "docker-standalone-ip" {
  vpc = true
}

resource "aws_route53_record" "docker-standalone-dns" {
   zone_id = "Z32B924BRSZ2H1"
   name = "${var.my_dns}.prvndhir.com"
   type = "A"
   ttl = "300"
   records = ["${aws_eip.docker-standalone-ip.public_ip}"]
}

output minion-external {
  value = "${aws_eip.docker-standalone-ip.public_ip}"
}
