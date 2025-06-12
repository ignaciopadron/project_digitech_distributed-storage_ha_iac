# Rol 02-security: Configuración de Seguridad

Este rol configura la seguridad básica del sistema incluyendo SSH hardening, fail2ban y firewall UFW.

## Configuración de Puertos

### Puertos TCP Permitidos

#### Administración y Acceso Básico
- **SSH (2211)**: Puerto SSH personalizado (definido en `group_vars/all/vars.yml`)
- **80**: HTTP para redirecciones y Let's Encrypt
- **443**: HTTPS para servicios web

#### Kubernetes Control Plane
- **6443**: Kubernetes API Server (acceso externo con kubectl)
- **2379**: etcd server client API (clusters HA)
- **2380**: etcd server peer API (clusters HA)
- **10250**: Kubelet API (comunicación server a agente)
- **10251**: kube-scheduler (solo localhost por defecto)
- **10252**: kube-controller-manager (solo localhost por defecto)

#### Monitoreo y Observabilidad
- **3000**: Grafana dashboard
- **9090**: Prometheus server
- **3100**: Loki log aggregation
- **9093**: Alertmanager
- **9100**: Node Exporter (métricas del sistema)
- **8080**: cAdvisor (métricas de contenedores)

#### Aplicaciones Específicas
- **9000**: SeaweedFS Master
- **8888**: SeaweedFS Filer
- **9333**: SeaweedFS Master (puerto adicional)

### Puertos UDP Permitidos

#### Networking de Kubernetes
- **8472**: Flannel VXLAN (CNI por defecto de K3s)

#### Tailscale
- **41641**: Tailscale (puerto por defecto, si se necesita acceso directo)

## Reglas de Interfaz

### Interfaces Confiables
- **tailscale0**: Permite todo el tráfico en la interfaz de Tailscale
- **docker0**: Permite todo el tráfico en la interfaz de Docker

## Configuración de Seguridad

### SSH Hardening
- Deshabilitado login root
- Deshabilitada autenticación por contraseña
- Solo autenticación por clave pública
- Puerto personalizado (2211)

### Fail2ban
- Tiempo de baneo: 1 hora
- Ventana de tiempo: 10 minutos
- Máximo reintentos: 5 (general), 3 (SSH)

### Límites del Sistema
- Archivos abiertos: 65536 (soft/hard)
- Procesos: 65536 (soft/hard)

## Variables Importantes

```yaml
# En group_vars/all/vars.yml
ssh_port: 2211

# En roles/02-security/defaults/main.yml
ufw_allowed_ports_tcp: [lista de puertos]
ufw_allowed_ports_udp: [lista de puertos]
ufw_interface_rules: [reglas por interfaz]
```

## Notas de Seguridad

1. **Tailscale**: Se confía completamente en la interfaz tailscale0
2. **Docker**: Se permite tráfico en docker0 para contenedores
3. **etcd**: Los puertos 2379/2380 solo son necesarios en clusters HA
4. **Monitoreo**: Los puertos de monitoreo están abiertos para acceso desde la red
5. **API K8s**: El puerto 6443 está abierto para acceso externo con kubectl 