output "bootstrap" {
    value = "${google_compute_instance.bootstrap.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "sub" {
    value = "${join(", ", google_compute_instance.sub.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

provider "google" {
    credentials = "${file("${var.account_file}")}"
    project = "${var.project}"
    region = "${var.region}"
}

resource "template_file" "env" {
    template = "${file("./templates/server.env")}"
}

resource "template_file" "bootstrap" {
    template = "${file("./templates/bootstrap.hcl")}"
    vars {
        node_name = "nomad-bootstrap-server"
        datacenter = "${var.nomad_datacenter}"
        server_count = "${var.server_count}"
    }
}

resource "template_file" "sub" {
    count = "${var.server_count - 1}"
    template = "${file("./templates/sub.hcl")}"
    vars {
        node_name = "nomad-sub${count.index}-server"
        datacenter = "${var.nomad_datacenter}"
    }
}

resource "template_file" "server_address" {
    template = "${file("../server_address.sh")}"
    vars {
    }
}

resource "google_compute_instance" "bootstrap" {
    count = 1

    name = "nomad-server-bootstrap"
    machine_type = "custom-1-2048"
    can_ip_forward = true
    zone = "${var.zone}"
    tags = ["nomad"]

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
            "cat <<'EOF' > /tmp/nomad.hcl\n${template_file.bootstrap.rendered}\nEOF",
            "sudo mv /tmp/nomad.hcl /opt/etc/nomad.d/nomad.hcl"
        ]
        connection {
            user = "core"
            agent = true
        }
    }

    depends_on = [
        "template_file.bootstrap",
        "template_file.env",
    ]
}

resource "google_compute_instance" "sub" {
    count = "${var.server_count - 1}"
    name = "nomad-server-sub${count.index}"
    machine_type = "custom-1-2048"
    can_ip_forward = true
    zone = "${var.zone}"
    tags = ["nomad"]

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
            "cat <<'EOF' > /tmp/nomad.hcl\n${element(template_file.sub.*.rendered, count.index)}\nEOF",
            "sudo mv /tmp/nomad.hcl /opt/etc/nomad.d/nomad.hcl",
        ]
        connection {
            user = "core"
            agent = true
        }
    }

    depends_on = [
        "google_compute_instance.bootstrap",
        "template_file.sub",
        "template_file.env"
    ]
}

resource "null_resource" "cluster" {
    count = "${var.server_count - 1}"

    triggers {
        cluster_instance_ids = "${join(",", google_compute_instance.sub.*.id)}"
    }

    connection {
        host = "${element(google_compute_instance.sub.*.network_interface.0.access_config.0.assigned_nat_ip, count.index)}"
    }
    
    provisioner "remote-exec" {
        inline = [
            "cat <<'EOF' > /tmp/server_address.sh\n${template_file.server_address.rendered}\nEOF",
            "sudo chmod +x /tmp/server_address.sh",
            "sudo mv /tmp/server_address.sh /opt/bin/server_address.sh",
            "sudo /opt/bin/server_address.sh /opt/etc/nomad.d/nomad.hcl ${element(google_compute_instance.sub.*.network_interface.0.access_config.0.assigned_nat_ip, count.index)} ${google_compute_instance.bootstrap.network_interface.0.access_config.0.assigned_nat_ip} ${join(" ", google_compute_instance.sub.*.network_interface.0.access_config.0.assigned_nat_ip)}"
        ]
        connection {
            user = "core"
            agent = true
        }
    }

    depends_on = [
        "google_compute_instance.sub",
        "template_file.server_address",
        "template_file.env"
    ]
}