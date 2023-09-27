terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.83.0"
    }
  }
}

provider "google" {
  credentials = file("key.json")
  project     = "projetobase-399518"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_compute_instance" "puppetserver" {
  name         = "puppetserver"
  machine_type = "e2-micro"
  zone         = "us-central1-c"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_compute_instance" "puppetagent" {
  name         = "puppetagent"
  machine_type = "e2-micro"
  zone         = "us-central1-c"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-stable"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}