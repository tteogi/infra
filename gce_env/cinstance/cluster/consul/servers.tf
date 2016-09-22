output "bootstrap" {
    value = "${google_compute_instance.bootstrap.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "sub" {
    value = "${join(",", google_compute_instance.sub.*.network_interface.0.access_config.0.assigned_nat_ip)}"
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
    template = "${file("./templates/bootstrap.json")}"
    vars {
        node_name = "consul-server-bootstrap"
        datacenter = "${var.consul_datacenter}"
        server_count = "${var.server_count}"
    }
}

resource "template_file" "sub" {
    count = "${var.server_count - 1}"
    template = "${file("./templates/sub.json")}"
    vars {
        node_name = "consul-server-sub${count.index}"
        datacenter = "${var.consul_datacenter}"
        server_count = "${var.server_count}"
    }
}

resource "template_file" "server_address" {
    template = "${file("../../server_address.sh")}"
    vars {
    }
}

resource "google_compute_instance" "bootstrap" {
    count = 1

    name = "consul-server-bootstrap"
    machine_type = "custom-1-2048"
    can_ip_forward = true
    zone = "${var.zone}"
    tags = ["consul"]

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
            "cat <<'EOF' > /tmp/consul.json\n${template_file.bootstrap.rendered}\nEOF",
            "sudo mv /tmp/consul.json /opt/etc/consul.d/consul.json",
            "cat <<'EOF' > /tmp/server.env\n${template_file.env.rendered}\nEOF",
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
        "template_file.bootstrap",
        "template_file.env",
    ]
}

resource "google_compute_instance" "sub" {
    count = "${var.server_count - 1}"
    name = "consul-sub${count.index}-server"
    machine_type = "custom-1-2048"
    can_ip_forward = true
    zone = "${var.zone}"
    tags = ["consul"]

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
            "cat <<'EOF' > /tmp/consul.json\n${element(template_file.sub.*.rendered, count.index)}\nEOF",
            "sudo mv /tmp/consul.json /opt/etc/consul.d/consul.json",
            "cat <<'EOF' > /tmp/server.env\n${template_file.env.rendered}\nEOF",
            "sudo mv /tmp/server.env /opt/etc/server.env",
            "sudo systemctl enable consul",
            "sudo systemctl start consul",
        ]
        connection {
            user = "core"
            agent = true
        }
    }

    provisioner "local-exec" {
        command = "echo dsds"
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
            "sudo /opt/bin/server_address.sh /opt/etc/consul.d/consul.json ${element(google_compute_instance.sub.*.network_interface.0.access_config.0.assigned_nat_ip, count.index)} ${google_compute_instance.bootstrap.network_interface.0.access_config.0.assigned_nat_ip} ${join(" ", google_compute_instance.sub.*.network_interface.0.access_config.0.assigned_nat_ip)}"
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