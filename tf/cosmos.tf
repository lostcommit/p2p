resource "digitalocean_droplet" "cosmos" {
    count = 1
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
      "apt -qy update",
      "apt install -qy python3-minimal wget liblz4-tool aria2 jq chrony lynis",
    ]
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.private_key} ../ansible/testcase.yaml"
  }
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.cosmos:
    droplet.name => droplet.ipv4_address
  }
}
