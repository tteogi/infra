provider "google" {
    credentials = "${file("${var.account_file}")}"
    project = "${var.project}"
    region = "${var.region}"
}

resource "google_compute_firewall" "consul" {
    description = "consul"
    name = "consul"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["8300", "8301", "8302", "8400", "8500", "8600"]
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "nomad" {
    description = "nomad"
    name = "nomad"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["4647", "4646", "4648"]
    }
    source_ranges = ["0.0.0.0/0"]
}

