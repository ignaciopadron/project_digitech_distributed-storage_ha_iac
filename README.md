# 🚀 DigiTech SeaweedFS K3s Cluster

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ansible](https://img.shields.io/badge/Ansible-2.15+-red.svg)](https://www.ansible.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-K3s-blue.svg)](https://k3s.io/)
[![Tailscale](https://img.shields.io/badge/Network-Tailscale-purple.svg)](https://tailscale.com/)

> **Infraestructura como Código para un cluster K3s altamente disponible con SeaweedFS, monitoreo completo y autoescalado en Hetzner Cloud**

## 📋 Descripción

Este proyecto implementa una infraestructura completa de Kubernetes (K3s) con:

- **🔧 Automatización completa** con Ansible
- **📊 Stack de monitoreo** (Prometheus, Grafana, Loki)
- **💾 Almacenamiento distribuido** con SeaweedFS
- **🔒 Seguridad robusta** con Tailscale VPN
- **📈 Autoescalado** en Hetzner Cloud
- **🌐 Gestión de certificados** con cert-manager
- **☁️ Colaboración** con OCIS (ownCloud Infinite Scale)

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
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

## 🚀 Inicio Rápido

### Prerrequisitos

- **Ansible** 2.15+
- **Python** 3.8+
- **kubectl** (para gestión del cluster)
- **Cuentas activas** en:
  - [Hetzner Cloud](https://console.hetzner.cloud/)
  - [Tailscale](https://login.tailscale.com/)

### 1. Clonar el Repositorio

```bash
git clone https://github.com/ignaciopadron/digitech-seaweedfs-k3s.git
cd digitech-seaweedfs-k3s
```

### 2. Configurar Variables de Entorno

```bash
# Copiar archivo de ejemplo
cp ansible/group_vars/all/vault.yml.example ansible/group_vars/all/vault.yml

# Editar con tus credenciales
ansible-vault edit ansible/group_vars/all/vault.yml
```

### 3. Configurar Inventario

```bash
# Editar el inventario con tus servidores
vim ansible/inventory.yml
```

### 4. Desplegar el Cluster

```bash
# Flujo recomendado
make config      # Configurar servidores y desplegar K3s
make secrets     # Crear secretos de Kubernetes
make deploy-apps # Desplegar aplicaciones
```

## 📁 Estructura del Proyecto

```
digitech-seaweedfs-k3s/
├── ansible/                    # Automatización con Ansible
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
├── k8s/                       # Manifiestos de Kubernetes
│   ├── scaling/               # Configuración de autoescalado
│   └── apps/                  # Aplicaciones del cluster
├── terraform/                 # Infraestructura como código
├── scripts/                   # Scripts de utilidad
└── Makefile                   # Comandos de automatización
```

## 🔧 Configuración

### Variables Principales

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

El cluster incluye **cluster-autoscaler** para Hetzner Cloud:

- **Escalado automático** basado en demanda de recursos
- **Nodos worker** se crean/destruyen dinámicamente
- **Configuración via cloud-init** con Tailscale
- **Etiquetas automáticas** para identificación

## 🛠️ Comandos Útiles

```bash
# Gestión del cluster
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

⭐ **¡Dale una estrella si este proyecto te ha sido útil!** 