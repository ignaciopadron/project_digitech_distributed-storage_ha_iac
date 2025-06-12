#!/bin/bash

# validate-secrets.sh
# Script para validar que todos los secretos de Kubernetes estén correctamente creados
# Ejecutar después de 'make k8s-secrets'

set -e

echo "🔍 Validando secretos de Kubernetes creados por Ansible..."
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para verificar si un secret existe y tiene las claves esperadas
validate_secret() {
    local namespace=$1
    local secret_name=$2
    local expected_keys=$3
    
    echo -e "\n${BLUE}📦 Validando secret: ${namespace}/${secret_name}${NC}"
    
    # Verificar si el secret existe
    if ! kubectl get secret "$secret_name" -n "$namespace" >/dev/null 2>&1; then
        echo -e "${RED}❌ Secret ${namespace}/${secret_name} no existe${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Secret existe${NC}"
    
    # Verificar las claves esperadas
    local missing_keys=()
    for key in $expected_keys; do
        if ! kubectl get secret "$secret_name" -n "$namespace" -o jsonpath="{.data.$key}" >/dev/null 2>&1; then
            missing_keys+=("$key")
        fi
    done
    
    if [ ${#missing_keys[@]} -eq 0 ]; then
        echo -e "${GREEN}✅ Todas las claves presentes: $expected_keys${NC}"
    else
        echo -e "${RED}❌ Claves faltantes: ${missing_keys[*]}${NC}"
        return 1
    fi
    
    # Mostrar información del secret
    echo -e "${YELLOW}📋 Información del secret:${NC}"
    kubectl get secret "$secret_name" -n "$namespace" -o custom-columns="NAME:.metadata.name,TYPE:.type,DATA:.data" --no-headers
    
    return 0
}

# Función para verificar namespace
validate_namespace() {
    local namespace=$1
    
    if ! kubectl get namespace "$namespace" >/dev/null 2>&1; then
        echo -e "${RED}❌ Namespace $namespace no existe${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Namespace $namespace existe${NC}"
    return 0
}

# Contador de errores
errors=0

echo -e "\n${BLUE}🏗️  Verificando namespaces...${NC}"
echo "================================"

namespaces=("ocis" "monitoring" "seaweedfs" "kube-system" "cert-manager")
for ns in "${namespaces[@]}"; do
    if ! validate_namespace "$ns"; then
        ((errors++))
    fi
done

echo -e "\n${BLUE}🔐 Verificando secretos...${NC}"
echo "=========================="

# Validar secretos de OCIS
if ! validate_secret "ocis" "ocis-s3-credentials" "accessKey secretKey"; then
    ((errors++))
fi

if ! validate_secret "ocis" "ocis-admin-user-secret" "user-id password"; then
    ((errors++))
fi

# Validar secretos de Monitoring
if ! validate_secret "monitoring" "grafana-admin-secret" "admin-user admin-password"; then
    ((errors++))
fi

# Validar secretos de SeaweedFS
if ! validate_secret "seaweedfs" "seaweedfs-s3-secret" "admin-access-key admin-secret-key"; then
    ((errors++))
fi

if ! validate_secret "seaweedfs" "seaweedfs-signing-key" "signingKey"; then
    ((errors++))
fi

# Validar secretos de escalabilidad (kube-system)
if ! validate_secret "kube-system" "hcloud-token" "token"; then
    ((errors++))
fi

if ! validate_secret "kube-system" "hcloud-cluster-config" "config"; then
    ((errors++))
fi

# Validar secretos de cert-manager
echo -e "\n${BLUE}📦 Validando secret: cert-manager/le-account-key${NC}"
if kubectl get secret "le-account-key" -n "cert-manager" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Secret le-account-key existe${NC}"
    echo -e "${YELLOW}📋 Información del secret:${NC}"
    kubectl get secret "le-account-key" -n "cert-manager" -o custom-columns="NAME:.metadata.name,TYPE:.type,DATA:.data" --no-headers
else
    echo -e "${RED}❌ Secret cert-manager/le-account-key no existe${NC}"
    ((errors++))
fi

# Resumen final
echo -e "\n${BLUE}📊 Resumen de validación${NC}"
echo "======================="

if [ $errors -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡Todos los secretos están correctamente configurados!${NC}"
    echo -e "${GREEN}✅ Total de secretos validados: 8${NC}"
    echo ""
    echo -e "${BLUE}🔄 Próximos pasos:${NC}"
    echo "1. Ejecutar: make apps"
    echo "2. Verificar que las aplicaciones usen los secretos correctamente"
    echo "3. Probar la funcionalidad de escalabilidad automática"
else
    echo -e "${RED}❌ Se encontraron $errors errores en la validación${NC}"
    echo ""
    echo -e "${YELLOW}🔧 Para solucionar:${NC}"
    echo "1. Verificar que vault.yml tenga todas las variables requeridas"
    echo "2. Ejecutar: make k8s-secrets"
    echo "3. Volver a ejecutar este script"
    exit 1
fi

echo -e "\n${BLUE}📋 Comandos útiles:${NC}"
echo "=================="
echo "# Ver todos los secretos gestionados por Ansible:"
echo "kubectl get secrets --all-namespaces -l app.kubernetes.io/managed-by=ansible"
echo ""
echo "# Ver detalles de un secret específico:"
echo "kubectl describe secret <secret-name> -n <namespace>"
echo ""
echo "# Rotar secretos:"
echo "ansible-vault edit group_vars/all/vault.yml"
echo "make k8s-secrets" 