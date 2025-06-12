# terraform/variables.tf - Variables esenciales y desacopladas para la infraestructura.

# -------------------------------------
# --- Variables del Proveedor (Requeridas) ---
# -------------------------------------

variable "hcloud_token" {
  description = "Token de la API de Hetzner Cloud.."
  type        = string
  sensitive   = true
}

# -------------------------------------
# --- Variables de Infraestructura (Personalizables) ---
# -------------------------------------

variable "cluster_name" {
  description = "Nombre base para los recursos del clúster (servidores, etc.)."
  type        = string
  default     = "k3s-digitech"
}

variable "nodes_count" {
  description = "Número de nodos a crear en el clúster."
  type        = number
  default     = 3
}

variable "server_type" {
  description = "Tipo/tamaño de los servidores a crear en Hetzner."
  type        = string
  default     = "cx22" # 2 vCPU, 4 GB RAM, 80 GB Disco
}

variable "location" {
  description = "Ubicación del datacenter de Hetzner."
  type        = string
  default     = "nbg1" # Nuremberg
}

variable "image" {
  description = "Imagen del sistema operativo para los nodos."
  type        = string
  default     = "ubuntu-24.04"
}

# -------------------------------------
# --- Variables de Acceso y Red ---
# -------------------------------------

variable "ssh_port" {
  description = "Puerto personalizado para las conexiones SSH."
  type        = number
  default     = 2211
}