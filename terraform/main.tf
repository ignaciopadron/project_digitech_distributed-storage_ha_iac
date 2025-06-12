# main.tf - Configuración principal de Terraform

terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.40"
    }
  }
}

# Configuración del proveedor Hetzner Cloud
provider "hcloud" {
  token = var.hcloud_token
}

# Usar la clave SSH existente en Hetzner Cloud
data "hcloud_ssh_key" "existing" {
  name = "cluster-k3s-ssh"  # Nombre de la clave existente en Hetzner
}

# Crear los 3 nodos del clúster
resource "hcloud_server" "k3s_node" {
  count       = var.nodes_count
  name        = "${var.cluster_name}-node-${count.index + 1}"
  image       = var.image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [data.hcloud_ssh_key.existing.id]  # Usar la clave existente

  labels = {
    "cluster-name" = var.cluster_name
  }

# cloud-init mínimo para el bootstrap de Ansible.
# Ansible se conectará como 'root' para hacer el resto.
  user_data = <<-EOF
  #cloud-config
  package_update: true
  package_upgrade: true
  packages:
    - python3
  EOF
}