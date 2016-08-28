output "consul_server" {
    value = "${join(", ", google_compute_instance.consul_server.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

provider "google" {
    credentials = "${file("${var.account_file}")}"
    project = "${var.project}"
    region = "${var.region}"
}

data "template_file" "consul_server" {
    template = "${file("./templates/consul_server.json")}"
    vars {
        node_name = "consul-server"
        datacenter = "${var.consul_datacenter}"
        region = "${var.region}"
    }
}

data "template_file" "env" {
    template = "${file("./templates/server.env")}"
}

resource "google_compute_instance" "consul_server" {
    count = "${var.server_count}"
    name = "consul-server-${count.index}"
    machine_type = "${var.machine_type}"
    can_ip_forward = true
    zone = "${var.zone}"
    tags = ["consul"]

    disk {
        image = "${var.image}"
        size = 10
    }
    network_interface {
        network = "default"
        access_config {
            // Ephemeral IP
        }
    }
    metadata {
        "sshKeys" = "${var.sshkey_metadata}"
    }
    provisioner "remote-exec" {
        inline = [
            "cat <<'EOF' > /tmp/consul.json\n${element(data.template_file.consul_server.*.rendered, count.index)}\nEOF",
            "sudo mv /tmp/consul.json /opt/etc/consul.d/consul.json",
            "cat <<'EOF' > /tmp/server.env\n${data.template_file.env.rendered}\nEOF",
            "sudo mv /tmp/server.env /opt/etc/server.env",
            "sudo systemctl enable consul",
            "sudo systemctl start consul",
        ]
        connection {
            user = "core"
            agent = true
        }
    }
    depends_on = [
    ]
}