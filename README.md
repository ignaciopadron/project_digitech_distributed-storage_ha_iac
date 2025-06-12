# 🚀 Almacenamiento Distribuido con SeaweedFS y ownCloud Infinite Scale

## 📡 Infraestructura como Código con K3s, Alta Disponibilidad y Escalabilidad Horizontal Automatizada

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-1.0+-purple.svg)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-2.15+-red.svg)](https://www.ansible.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-K3s-blue.svg)](https://k3s.io/)
[![Tailscale](https://img.shields.io/badge/Network-Tailscale-purple.svg)](https://tailscale.com/)

---

## 💭 **Motivación Personal**

> *"Tuve algún problema con Google Drive en el explorador Gnome en Ubuntu (Linux), entonces pensé en levantar mi propia infraestructura para tener mis recursos sin problemas."*

> *"En un mundo donde los cambios son cada vez más rápidos, el coste de oportunidad se vuelve decisivo. Llegar tarde sería como no llegar. Por tanto, tener acceso a tus recursos sin interrupciones, es decir, con alta disponibilidad y tolerancia a fallos, ya es algo tan importante como el servicio que se ofrece."*

> *"La soberanía digital y tecnológica de los recursos que usas garantiza la autonomía y aborda las vulnerabilidades con respecto a infraestructuras críticas, reduciendo el riesgo y la dependencia a empresas extranjeras."*

---

## 🎯 **Resumen Ejecutivo**

**Solución completa de almacenamiento distribuido** desplegada con **Infrastructure as Code** en un cluster **Kubernetes K3s** con:
- ✅ **Alta disponibilidad** y tolerancia a fallos
- ✅ **Escalabilidad horizontal** automatizada (Cluster-Autoscaler + HPA + Cloud-init)
- ✅ **Stack de monitoreo** completo (Prometheus, Grafana, Loki)
- ✅ **Seguridad robusta** con Tailscale VPN
- ✅ **Despliegue automatizado** en Hetzner Cloud

## 📋 Descripción Técnica

### 🏗️ **Stack Tecnológico**

| Categoría | Tecnología | Propósito |
|-----------|------------|-----------|
| **🏗️ IaC** | Terraform | Provisioning de infraestructura en Hetzner Cloud |
| **🔧 Automatización** | Ansible | Configuración, despliegue y seguridad |
| **🚀 Orquestación** | Kubernetes (K3s) | Gestión de contenedores y servicios |
| **🔒 Networking** | Tailscale VPN | Red privada segura mesh network |
| **💾 Storage** | SeaweedFS | Almacenamiento distribuido compatible S3 |
| **☁️ Colaboración** | ownCloud Infinite Scale (OCIS) | Plataforma de colaboración empresarial |
| **📊 Monitoreo** | Prometheus + Grafana + Loki | Observabilidad completa |

### 🚀 **Características Principales**

- **📈 Autoescalado Inteligente**: Cluster Autoscaler + HPA (Horizontal Pod Autoscaler)
- **☁️ Inicialización Automática**: Cloud-init para nodos worker dinámicos  
- **🌐 Gestión de Certificados**: cert-manager con Let's Encrypt
- **🔐 Seguridad Robusta**: SSH hardening, UFW firewall, fail2ban
- **📊 Observabilidad**: Métricas, logs y alertas centralizadas

## 🎯 **Casos de Uso**

### 🏢 **Para Empresas**
- **Soberanía de datos** sin dependencia de proveedores externos
- **Colaboración segura** con ownCloud Infinite Scale
- **Escalabilidad automática** según demanda
- **Monitoreo proactivo** de la infraestructura

### 👨‍💻 **Para Desarrolladores**
- **Entorno de desarrollo** con almacenamiento S3 compatible
- **CI/CD pipelines** con storage distribuido
- **Laboratorio de Kubernetes** para aprendizaje
- **Backup automático** de proyectos y datos

### 🏠 **Para Uso Personal**
- **Alternativa a Google Drive/Dropbox** con control total
- **Media server** con almacenamiento distribuido
- **Backup familiar** con alta disponibilidad
- **Aprendizaje de tecnologías** cloud-native

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                 Hetzner Cloud Infrastructure                │
│                    (Terraform Managed)                     │
├─────────────────────────────────────────────────────────────┤
│                    Tailscale VPN Network                    │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Master    │  │   Worker    │  │   Auto-scaled       │  │
│  │   Node      │  │   Nodes     │  │   Workers           │  │
│  │             │  │             │  │   (Hetzner Cloud)   │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────────────────┐
                    │   Applications      │
                    ├─────────────────────┤
                    │ • SeaweedFS (S3)    │
                    │ • OCIS              │
                    │ • Prometheus        │
                    │ • Grafana           │
                    │ • Loki              │
                    │ • cert-manager      │
                    └─────────────────────┘
```

## 🔧 Tecnologías Clave

### 🏗️ Terraform
- **Provisioning** de infraestructura en Hetzner Cloud
- **Gestión de estado** centralizada y versionada
- **Creación automática** de servidores, redes y SSH keys
- **Outputs** para integración con Ansible

### 📈 Cluster Autoscaler
- **Escalado automático** de nodos worker
- **Integración nativa** con Hetzner Cloud API
- **Optimización de costos** eliminando nodos no utilizados
- **Configuración declarativa** via Kubernetes manifests

### 📊 HPA (Horizontal Pod Autoscaler)
- **Escalado de pods** basado en métricas
- **Soporte para CPU, memoria** y métricas personalizadas
- **Integración** con metrics-server y Prometheus
- **Configuración por aplicación** con targets específicos

### ☁️ Cloud-Init
- **Inicialización automática** de instancias en Hetzner Cloud
- **Scripts de configuración** ejecutados al boot
- **Instalación de Tailscale** y unión a la red VPN
- **Configuración de K3s agent** con parámetros específicos
- **Metadata de Hetzner** para provider-id y etiquetas

## 🚀 Inicio Rápido

### Prerrequisitos

- **Terraform** 1.0+
- **Ansible** 2.15+
- **Python** 3.8+
- **kubectl** (para gestión del cluster)
- **Cuentas activas** en:
  - [Hetzner Cloud](https://console.hetzner.cloud/)
  - [Tailscale](https://login.tailscale.com/)

### 1. Clonar el Repositorio

```bash
git clone https://github.com/ignaciopadron/project_digitech_distributed-storage_ha_iac.git
cd project_digitech_distributed-storage_ha_iac
```

### 2. Configurar Variables de Entorno

```bash
# Variables de Terraform
export HCLOUD_TOKEN="tu-hetzner-cloud-token"
export TF_VAR_hcloud_token="$HCLOUD_TOKEN"

# Variables de Ansible
cp ansible/group_vars/all/vault.yml.example ansible/group_vars/all/vault.yml
ansible-vault edit ansible/group_vars/all/vault.yml
```

### 3. Desplegar Infraestructura con Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 4. Configurar Cluster con Ansible

```bash
# Flujo recomendado usando Makefile
make config      # Configurar servidores y desplegar K3s
make secrets     # Crear secretos de Kubernetes
make deploy-apps # Desplegar aplicaciones
```

## 📁 Estructura del Proyecto

```
project_digitech_distributed-storage_ha_iac/
├── terraform/                  # 🏗️ Infraestructura como código
│   ├── main.tf                # Configuración principal de Hetzner Cloud
│   ├── variables.tf           # Variables de Terraform
│   ├── outputs.tf             # Outputs para Ansible
│   └── inventory.tpl          # Template de inventario
├── ansible/                    # 🔧 Automatización con Ansible
│   ├── roles/                  # Roles organizados por función
│   │   ├── 01-common/         # Configuración básica del sistema
│   │   ├── 02-security/       # SSH, firewall, fail2ban
│   │   ├── 03-docker/         # Instalación de Docker
│   │   ├── 04-network/        # Configuración de Tailscale
│   │   └── 05-k3s-cluster/    # Despliegue de K3s
│   ├── group_vars/            # Variables globales
│   ├── templates/             # Plantillas de configuración
│   ├── playbook.yml           # Playbook principal
│   └── k8s-secrets-setup.yml  # Gestión de secretos
├── k8s/                       # 📦 Manifiestos de Kubernetes
│   ├── scaling/               # Configuración de autoescalado
│   ├── seaweedfs/             # Almacenamiento distribuido
│   ├── stack-observabilidad/  # Monitoreo (Prometheus, Grafana, Loki)
│   └── service/               # Servicios e ingress
├── scripts/                   # 🛠️ Scripts de utilidad
└── Makefile                   # 🎯 Comandos de automatización
```

## 🔧 Configuración

### Variables de Terraform

Configura las variables en `terraform/terraform.tfvars`:

```hcl
# Hetzner Cloud
hcloud_token = "tu-hetzner-cloud-token"
server_type = "cx22"
location = "fsn1"
ssh_key_name = "tu-clave-ssh"

# Configuración del cluster
node_count = 3
```

### Variables de Ansible

Las variables sensibles se almacenan en `ansible/group_vars/all/vault.yml` (encriptado):

```yaml
# Tokens de API
hcloud_token: "tu-hetzner-cloud-token"
tailscale_auth_key: "tskey-auth-tu-clave"
k3s_token: "tu-k3s-token-secreto"

# Credenciales de aplicaciones
grafana_admin_password: "password-seguro"
ocis_admin_password: "password-seguro"
seaweedfs_s3_secret_key: "clave-s3-secreta"
```

### Configuración de Red

El proyecto utiliza **Tailscale** para crear una red privada segura entre todos los nodos:

- **Puerto SSH**: 2211 (personalizado)
- **API K8s**: 6443 (accesible externamente)
- **Monitoreo**: Grafana (3000), Prometheus (9090)

## 📊 Aplicaciones Incluidas

| Aplicación | Puerto | Descripción |
|------------|--------|-------------|
| **Grafana** | 3000 | Dashboard de monitoreo |
| **Prometheus** | 9090 | Métricas del sistema |
| **Loki** | 3100 | Agregación de logs |
| **OCIS** | 9200 | Colaboración (ownCloud) |
| **SeaweedFS** | 8888 | Almacenamiento S3 |

## 🔒 Seguridad

### Características de Seguridad

- **🏗️ Terraform State**: Gestión segura del estado de infraestructura
- **🔐 SSH Hardening**: Puerto personalizado, solo claves públicas
- **🛡️ Firewall UFW**: Configuración restrictiva
- **🚫 Fail2ban**: Protección contra ataques de fuerza bruta
- **🔒 Ansible Vault**: Encriptación de secretos
- **🌐 Tailscale VPN**: Red privada entre nodos
- **📜 cert-manager**: Certificados SSL automáticos

### Puertos Abiertos

```yaml
# Administración
- 2211 (SSH)
- 80/443 (HTTP/HTTPS)

# Kubernetes
- 6443 (API Server)
- 10250 (Kubelet)
- 2379/2380 (etcd - solo HA)

# Monitoreo
- 3000 (Grafana)
- 9090 (Prometheus)
- 3100 (Loki)

# Aplicaciones
- 9200 (OCIS)
- 8888 (SeaweedFS)
```

## 📈 Autoescalado

El cluster incluye un sistema completo de autoescalado en dos niveles:

### 🔄 Cluster Autoscaler (Escalado de Nodos)
- **Escalado automático** de nodos worker basado en demanda de recursos
- **Integración nativa** con Hetzner Cloud API
- **Creación/destrucción** dinámica de servidores según carga
- **Configuración via cloud-init** con Tailscale y K3s preconfigurado
- **Etiquetas automáticas** para identificación y balanceado

### 📊 HPA - Horizontal Pod Autoscaler (Escalado de Pods)
- **Escalado automático** de pods basado en métricas de CPU/memoria
- **Configuración personalizable** por aplicación
- **Integración** con Prometheus metrics
- **Respuesta rápida** a picos de carga

### ☁️ Cloud-Init para Nodos Worker
- **Inicialización automática** de nuevos nodos
- **Instalación y configuración** de Tailscale
- **Unión automática** al cluster K3s
- **Configuración de etiquetas** y roles específicos
- **Script optimizado** para Hetzner Cloud metadata

**Flujo de Autoescalado:**
```
Alta Demanda → HPA escala pods → Recursos insuficientes → 
Cluster Autoscaler crea nodo → Cloud-init configura nodo → 
Nodo se une al cluster → Pods se programan en nuevo nodo
```

## 🛠️ Comandos Útiles

```bash
# Infraestructura con Terraform
cd terraform
terraform plan                    # Planificar cambios
terraform apply                   # Aplicar infraestructura
terraform destroy                 # Destruir infraestructura

# Gestión del cluster con Ansible
make config          # Configurar y desplegar K3s
make secrets         # Crear secretos de K8s
make deploy-apps     # Desplegar aplicaciones
make validate        # Validar configuración

# Desarrollo y debug
make debug-config    # Ejecutar en modo verbose
make check-syntax    # Verificar sintaxis
make ping-hosts      # Verificar conectividad
make clean          # Limpiar archivos temporales

# Kubernetes
export KUBECONFIG=$PWD/kubeconfig
kubectl get nodes
kubectl get pods --all-namespaces
```

## 📚 Documentación Adicional

- [🔐 Arquitectura de Secretos](ansible/README-Secrets-Architecture.md)
- [🎭 Guía de Roles](ansible/README-Roles.md)
- [🔒 Configuración de Seguridad](ansible/roles/02-security/README.md)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 Autor

**Ignacio Padrón** - *System Administrator & DevOps Engineer*

- 🌐 Website: [ignaciopadron.es](https://www.ignaciopadron.es)
- 💼 LinkedIn: [ignaciopadron](https://linkedin.com/in/ignaciopadron)
- 📧 Email: ignaciopadrond@gmail.com
- 🐙 GitHub: [@ignaciopadron](https://github.com/ignaciopadron)

---

## 🌟 **¿Te ha sido útil este proyecto?**

Si este proyecto te ha ayudado o te parece interesante:

- ⭐ **Dale una estrella** en GitHub
- 🔄 **Compártelo** con otros desarrolladores
- 💬 **Déjanos feedback** en los issues
- 🤝 **Contribuye** con mejoras

**¡Tu apoyo motiva a seguir desarrollando soluciones open source!** 🚀