resource "digitalocean_droplet" "cosmos" {
    image = "ubuntu-22-04-x64"
    name = "cosmos"
    region = "ams3"
    size = "s-1vcpu-1gb-intel"
    ssh_keys = [
      data.digitalocean_ssh_key.chervie.id
    ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.private_key)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update",
      "apt -qqy upgrade",
      "apt install -qqy python3-pip",
      "pip3 install ansible"
    ]
  }

}
