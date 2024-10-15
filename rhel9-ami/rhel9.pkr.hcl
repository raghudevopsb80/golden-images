variable "ssh_password" {}

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "rhel9" {
  ami_name      = "rhel9-golden-image"
  instance_type = "t3.small"
  region        = "us-east-1"
  source_ami    = "ami-041e2ea9402c46c32"
  ssh_username  = "ec2-user"
  ssh_password  = var.ssh_password
}

build {
  name    = "rhel9-golden-image"
  sources = [
    "source.amazon-ebs.rhel9"
  ]

  provisioner "shell" {
    inline = ["uname"]
  }

  provisioner "shell-local" {
    inline = [
      "ansible-playbook -i ${build.Host}, -e ansible_user=ec2-user -e ${var.ssh_password} main.yml"
    ]

  }

}