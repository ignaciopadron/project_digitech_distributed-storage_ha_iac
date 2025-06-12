# Documentación de Roles de Ansible

## Filosofía y Separación de Responsabilidades

Este proyecto sigue el **principio de responsabilidad única**:

### 🔧 **ANSIBLE** (Infraestructura)
- **Responsabilidad**: Configurar OS + instalar K3s cluster
- **Entregable**: Cluster K3s funcional + kubeconfig
- **Límite**: NO gestiona aplicaciones de Kubernetes

### ⚙️ **HELM/KUBECTL** (Aplicaciones)
- **Responsabilidad**: Gestionar aplicaciones y secretos de Kubernetes
- **Entregable**: Aplicaciones desplegadas y configuradas

## Estructura de Roles

```
roles/
├── packages/     # Instalación de paquetes del sistema
├── users/        # Gestión de usuarios del sistema
├── security/     # Configuración de seguridad (SSH, firewall, fail2ban)
├── system/       # Configuración del sistema (kernel, módulos)
└── network/      # Configuración de red (WireGuard)
```

## Descripción de Roles

### 📦 **packages**
**Responsabilidad**: Gestión de paquetes del sistema operativo

**Funciones**:
- Actualizar repositorios del sistema
- Instalar paquetes base necesarios
- Configurar repositorios adicionales si es necesario

**Variables principales**:
- `system_packages`: Lista de paquetes a instalar

**Archivos**:
- `defaults/main.yml`: Paquetes por defecto
- `tasks/main.yml`: Tareas de instalación

---

### 👥 **users**
**Responsabilidad**: Gestión de usuarios del sistema

**Funciones**:
- Crear usuario administrador
- Configurar claves SSH
- Establecer permisos sudo

**Variables principales**:
- `admin_user`: Nombre del usuario administrador
- `ssh_public_key`: Clave SSH pública

**Archivos**:
- `defaults/main.yml`: Configuración por defecto de usuarios
- `tasks/main.yml`: Tareas de creación y configuración

---

### 🔒 **security**
**Responsabilidad**: Configuración de seguridad del sistema

**Funciones**:
- Configurar SSH (puerto, autenticación, hardening)
- Configurar firewall UFW
- Instalar y configurar fail2ban
- Aplicar límites del sistema

**Variables principales**:
- `ssh_port`: Puerto SSH personalizado
- `ssh_*`: Configuraciones de SSH
- `fail2ban_*`: Configuraciones de fail2ban
- `ufw_*`: Reglas de firewall

**Templates**:
- `sshd_config.j2`: Configuración SSH hardened

**Archivos**:
- `defaults/main.yml`: Configuraciones de seguridad por defecto
- `tasks/main.yml`: Tareas de configuración de seguridad
- `templates/sshd_config.j2`: Template de configuración SSH

---

### ⚙️ **system**
**Responsabilidad**: Configuración del sistema operativo

**Funciones**:
- Configurar zona horaria
- Cargar módulos del kernel necesarios para K3s
- Configurar parámetros del kernel
- Preparar el sistema para Kubernetes

**Variables principales**:
- `timezone`: Zona horaria del sistema
- `kernel_modules`: Módulos del kernel a cargar
- `sysctl_params`: Parámetros del kernel

**Archivos**:
- `defaults/main.yml`: Configuraciones del sistema por defecto
- `tasks/main.yml`: Tareas de configuración del sistema

---

### 🌐 **network**
**Responsabilidad**: Configuración de red del sistema

**Funciones**:
- Configurar WireGuard VPN
- Establecer conectividad entre nodos
- Preparar la red para el cluster K3s

**Variables principales**:
- `wg_*`: Configuraciones de WireGuard
- `wg_config_path`: Ruta del archivo de configuración

**Templates**:
- `wg0.conf.j2`: Configuración de WireGuard

**Archivos**:
- `defaults/main.yml`: Configuraciones de red por defecto
- `tasks/main.yml`: Tareas de configuración de red
- `templates/wg0.conf.j2`: Template de configuración WireGuard

## Principios de Diseño

### ✅ **Buenas Prácticas Implementadas**

1. **Responsabilidad Única**: Cada rol tiene una función específica
2. **Separación de Concerns**: Variables en `defaults/`, lógica en `tasks/`
3. **Reutilización**: Roles independientes y modulares
4. **Configurabilidad**: Variables sobrescribibles en `group_vars/`
5. **Idempotencia**: Todas las tareas son idempotentes
6. **Límites Claros**: Ansible NO gestiona aplicaciones K8s

### 🚫 **Lo que NO hace Ansible**

- **NO** gestiona secretos de Kubernetes
- **NO** despliega aplicaciones en K8s
- **NO** configura Helm charts
- **NO** gestiona recursos de Kubernetes

## Uso de los Roles

### **Playbook Principal**
```yaml
- hosts: all
  become: yes
  roles:
    - packages
    - users  
    - security
    - system
    - network
```

### **Variables Globales**
```yaml
# group_vars/all/vars.yml
cluster_name: "k3s-digitech"
domain_name: "ciberpadron.space"
admin_user: "ciberpadron"
ssh_port: 2211
```

### **Secretos de Infraestructura**
```yaml
# group_vars/all/vault.yml (cifrado)
hcloud_token: "token_hetzner"
tailscale_auth_key: "tskey-auth-clave"
k3s_token: "token_k3s"
```

## Flujo de Ejecución

```
1. packages    → Instala paquetes base
2. users       → Crea usuario admin
3. security    → Configura SSH, firewall, fail2ban
4. system      → Configura kernel y sistema
5. network     → Configura WireGuard
6. [K3s]       → Instala cluster (en playbook principal)
```

## Mantenimiento

### **Añadir Nueva Funcionalidad**
1. Identificar si corresponde a Ansible (infraestructura/OS)
2. Si es aplicación K8s → usar Helm/kubectl
3. Si es infraestructura → añadir al rol apropiado

### **Modificar Configuraciones**
1. Variables comunes → `group_vars/all/vars.yml`
2. Secretos → `group_vars/all/vault.yml`
3. Defaults de rol → `roles/*/defaults/main.yml`

### **Testing**
```bash
# Verificar sintaxis
ansible-playbook --syntax-check playbook.yml

# Dry run
ansible-playbook --check playbook.yml

# Ejecutar
ansible-playbook playbook.yml --ask-vault-pass
```

## Conclusión

Los roles de Ansible están diseñados para:
- **Preparar** el sistema operativo
- **Instalar** K3s cluster
- **Entregar** un cluster funcional

Todo lo relacionado con aplicaciones se gestiona con herramientas nativas de Kubernetes, manteniendo una separación clara de responsabilidades. 