provider "aws" {
  region = "us-west-2"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = "${aws_instance.docker-standalone.id}"
  allocation_id = "${aws_eip.docker-standalone-ip.id}"

  connection {
    host = "${aws_eip.docker-standalone-ip.public_ip}"
    user = "ubuntu"
  }

  provisioner "file" {
    destination = "~/.ssh/config"
    content = <<EOF
Host github.com
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
EOF
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install git",
      "curl -L get.docker.io | sudo sh",
      "sudo usermod -aG docker ubuntu",
      "sudo /bin/sh -c 'curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose'"
    ]

  }

}

resource "aws_instance" "docker-standalone" {
  count = 1
  key_name = "${var.aws_keypair}"
  tags {
    Name = "Farallones-Docker-Orchestration"
    Type = "terraform-test"
    finance = "NSN_RnD"
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
