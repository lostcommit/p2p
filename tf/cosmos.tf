resource "digitalocean_droplet" "cosmos" {
    image = "ubuntu-22-04-x64"
    name = "cosmos"
    region = "ams3"
    size = "s-2vcpu-2gb-amd"
    tags = [
      "blockchain",
      "test",
      "cosmos"
    ]
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
      "export export DEBIAN_PRIORITY=critical",
      "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 013baa07180c50a7101097ef9de922f1c2fde6c4",
      "echo 'deb https://packages.cisofy.com/community/lynis/deb/ stable main' > /etc/apt/sources.list.d/cisofy-lynis.list",
      "apt -qy update",
      "apt -qy -o 'Dpkg::Options::=--force-confdef' -o 'Dpkg::Options::=--force-confold' upgrade",
      "apt install -qy python3-pip wget liblz4-tool aria2 jq chrony lynis",
      "pip3 install -q ansible"
    ]
  }

}
