output "gameserver" {
    value = "${join("\n", google_compute_instance.gameserver.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

resource "template_file" "gameserver" {
    template = "${file("./templates/gameserver.env")}"
    vars {
        servername = "ok"
    }
}

provider "google" {
    credentials = "${file("${var.account_file}")}"
    project = "${var.project}"
    region = "${var.region}"
}

resource "google_compute_instance" "gameserver" {
    count = "${var.server_count}"

    name = "${var.cluster_name}-gameserver${count.index}"
    machine_type = "custom-1-2048"
    can_ip_forward = true
    zone = "${var.zone}"
    tags = ["gameserver"]

    disk {
        image = "${var.image}"
        size = 200
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
            "cat <<'EOF' > /tmp/gameserver.env\n${template_file.gameserver.rendered}\nEOF",
            "echo 'ETCD_NAME=${self.name}' >> /tmp/gameserver.env",
            "echo 'ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379' >> /tmp/gameserver.env",
            "echo 'ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380' >> /tmp/gameserver.env",
            "echo 'ETCD_INITIAL_ADVERTISE_PEER_URLS=http://${self.network_interface.0.address}:2380' >> /tmp/gameserver.env",
            "echo 'ETCD_ADVERTISE_CLIENT_URLS=http://${self.network_interface.0.address}:2379' >> /tmp/gameserver.env",
            "sudo mv /tmp/gameserver.env /etc/gameserver.env",
        ]
        connection {
            user = "core"
            agent = true
        }
    }

    depends_on = [
        "template_file.gameserver",
    ]
}