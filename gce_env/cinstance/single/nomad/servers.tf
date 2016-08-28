output "nomad_server" {
    value = "${join(", ", google_compute_instance.nomad_server.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

provider "google" {
    credentials = "${file("${var.account_file}")}"
    project = "${var.project}"
    region = "${var.region}"
}

data "template_file" "nomad_server" {
    template = "${file("./templates/nomad_server.hcl")}"
    vars {
        node_name = "nomad-server"
        datacenter = "${var.nomad_datacenter}"
        region = "${var.region}"
    }
}
data "template_file" "env" {
    template = "${file("./templates/server.env")}"
}

resource "google_compute_instance" "nomad_server" {
    count = "${var.server_count}"
    name = "nomad-server-${count.index}"
    machine_type = "${var.machine_type}"
    can_ip_forward = true
    zone = "${var.zone}"
    tags = ["nomad"]

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
            "cat <<'EOF' > /tmp/nomad.hcl\n${element(data.template_file.nomad_server.*.rendered, count.index)}\nEOF",
            "sed -i 's/&my_address&/'${self.network_interface.0.address}'/g' /tmp/nomad.hcl",
            "sudo mv /tmp/nomad.hcl /opt/etc/nomad.d/nomad.hcl",
            "cat <<'EOF' > /tmp/server.env\n${data.template_file.env.rendered}\nEOF",
            "sudo mv /tmp/server.env /opt/etc/server.env",
            "sudo systemctl enable nomad",
            "sudo systemctl start nomad",
        ]
        connection {
            user = "core"
            agent = true
        }
    }
    depends_on = [
    ]
}