# 🔐 Gestión de Secretos - Separación de Responsabilidades

## 📋 Resumen

**Principio de Responsabilidad Única (SRP)**:

- **🔧 Ansible**: Crea `Secret` de Kubernetes desde `vault.yml`
- **⚙️ Helm**: Solo consume secretos mediante referencias
- **🎯 Resultado**: Código limpio, seguro y mantenible

## 🔄 Comandos Principales

```bash
# 1. Configurar secretos
cp ansible/group_vars/all/vault.yml.example ansible/group_vars/all/vault.yml
ansible-vault edit ansible/group_vars/all/vault.yml

# 2. Crear secretos en K8s
make k8s-secrets

# 3. Validar secretos
make validate-secrets

# 4. Desplegar aplicaciones
make apps
```

## 🔐 Variables Requeridas en vault.yml

```yaml
# SeaweedFS
seaweedfs_s3_access_key: "tu-access-key"
seaweedfs_s3_secret_key: "tu-secret-key"
seaweedfs_jwt_signing_key: "jwt-key-secreta"

# OCIS
ocis_admin_user: "admin"
ocis_admin_password: "password-segura"

# Grafana
grafana_admin_user: "admin"
grafana_admin_password: "password-segura"

# Escalabilidad (Hetzner Cloud)
hcloud_token: "tu-hetzner-token"
k3s_token: "tu-k3s-token"
tailscale_auth_key: "tskey-auth-tu-key"
```

## 🎯 Secretos Creados

| Namespace | Secret | Keys | Usado Por |
|-----------|--------|------|-----------|
| `ocis` | `ocis-s3-credentials` | `accessKey`, `secretKey` | OCIS → SeaweedFS |
| `ocis` | `ocis-admin-user-secret` | `user-id`, `password` | OCIS Admin |
| `monitoring` | `grafana-admin-secret` | `admin-user`, `admin-password` | Grafana |
| `seaweedfs` | `seaweedfs-s3-secret` | `admin-access-key`, `admin-secret-key` | SeaweedFS S3 |
| `seaweedfs` | `seaweedfs-signing-key` | `signingKey` | SeaweedFS JWT |
| `kube-system` | `hcloud-token` | `token` | Cluster Autoscaler |
| `kube-system` | `hcloud-cluster-config` | `config` | Autoscaler Config |
| `cert-manager` | `le-account-key` | (auto) | Let's Encrypt |

## 🔗 Consumo en Helm Charts

### OCIS
```yaml
secretRefs:
  s3CredentialsSecretRef: "ocis-s3-credentials"
  adminUserSecretRef: "ocis-admin-user-secret"
```

### Grafana
```yaml
admin:
  existingSecret: "grafana-admin-secret"
  userKey: "admin-user"
  passwordKey: "admin-password"
```

## 🔄 Rotación de Secretos

```bash
# 1. Editar secretos
ansible-vault edit ansible/group_vars/all/vault.yml

# 2. Actualizar K8s
make k8s-secrets

# 3. Reiniciar apps (opcional)
kubectl rollout restart deployment/ocis -n ocis
kubectl rollout restart deployment/grafana -n monitoring
```

## 🐛 Troubleshooting

### Error: KUBECONFIG no configurado
```bash
kubectl cluster-info
# Si falla: make node-setup
```

### Error: Secret no encontrado
```bash
kubectl get secrets --all-namespaces -l app.kubernetes.io/managed-by=ansible
make k8s-secrets
```

### Error: Variables no definidas
```bash
ansible-vault view ansible/group_vars/all/vault.yml
ansible-vault edit ansible/group_vars/all/vault.yml
```

## ✅ Ventajas

- **🧩 Modularidad**: Cada herramienta tiene su responsabilidad
- **🔒 Seguridad**: Secretos centralizados y encriptados
- **🛠️ Mantenibilidad**: Un solo lugar para gestionar secretos
- **🚀 Escalabilidad**: Credenciales seguras para autoscaling

¡Separación limpia entre Ansible y Helm! 🚀 