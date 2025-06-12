# Inventario de Ansible generado por Terraform.
# Describe la infraestructura para que Ansible pueda configurarla.

# ==============================================================================
# Variables Globales de Conexión
# ==============================================================================
[all:vars]
# Ansible se conectará como 'root' inicialmente para realizar la configuración base,
# como crear el usuario 'ciberpadron' y configurar el acceso SSH.
ansible_user = root

# El puerto SSH definido en Terraform. Ansible lo usará para conectarse.
ansible_port = {{ ssh_port }}

# La clave privada para la conexión. Asume que estás usando tu clave local.
ansible_ssh_private_key_file = ~/.ssh/id_rsa

# Asegura que Ansible use Python 3.
ansible_python_interpreter = /usr/bin/python3

# Desactiva la comprobación de clave de host, útil para infraestructura efímera.
ansible_ssh_common_args = '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# ==============================================================================
# Definición de Grupos
# ==============================================================================

# --- Grupo principal que contiene todos los nodos del clúster ---
[k3s_cluster]
%{ for node in nodes ~}
${node.name} ansible_host=${node.ipv4_address}
%{ endfor ~}


# --- Grupos lógicos para la instalación de K3s ---

# Este grupo es CRUCIAL. Contiene solo el primer nodo.
# Se usa para ejecutar las tareas de inicialización del clúster.
[k3s_master_initial]
${nodes[0].name}


# Este grupo contiene los nodos restantes que se unirán a un clúster ya existente.
[k3s_masters_additional]
%{ for i, node in nodes ~}
%{ if i > 0 ~}
${node.name}
%{ endif ~}
%{ endfor ~}

# Este es un grupo 'contenedor' (o 'meta-grupo'). Es útil si en el futuro
# quieres añadir grupos de workers y tratarlos a todos como 'k3s_cluster'.
[k3s_all_nodes:children]
k3s_cluster