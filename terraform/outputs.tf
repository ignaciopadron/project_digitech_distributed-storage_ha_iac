# outputs.tf - Salidas optimizadas para automatización y conveniencia humana

# 1. El output para la automatización con Ansible.
# Su única responsabilidad es generar el inventario.
output "ansible_inventory" {
  description = "Contenido para el inventario de Ansible. Usar: terraform output -raw ansible_inventory > ../ansible/inventory.ini"
  value = templatefile("${path.module}/inventory.tpl", {
    nodes     = hcloud_server.k3s_node
    ssh_port  = var.ssh_port
  })
  sensitive = true # Buena práctica para no mostrar IPs y otra info en los logs.
}


# 2. Outputs de conveniencia para el operador humano.
# Son informativos y no crean acoplamiento.

output "k3s_nodes_public_ips" {
  description = "Lista de las IPs públicas de los nodos del clúster."
  value       = hcloud_server.k3s_node[*].ipv4_address
}

output "kubernetes_api_url" {
  description = "URL para acceder al API Server de Kubernetes (en el primer nodo)."
  value       = "https://${hcloud_server.k3s_node[0].ipv4_address}:6443"
}

output "ssh_command_example" {
  description = "Comando de ejemplo para conectar al primer nodo (después de que Ansible cree el usuario 'ciberpadron')."
  value       = "ssh ciberpadron@${hcloud_server.k3s_node[0].ipv4_address} -p ${var.ssh_port}"
}