# Makefile para orquestar el despliegue del cluster K3s
# Flujo recomendado: make config -> make secrets -> make deploy-apps

.PHONY: help config secrets deploy-apps validate clean

# Variables por defecto
INVENTORY ?= inventory.yml
ANSIBLE_DIR = ansible
KUBECONFIG_FILE = kubeconfig

help: ## Mostrar esta ayuda
	@echo "🚀 Comandos disponibles para el cluster K3s:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "📋 Flujo recomendado:"
	@echo "  1. make config      # Configurar servidores y desplegar K3s"
	@echo "  2. make secrets     # Crear secretos de Kubernetes"
	@echo "  3. make deploy-apps # Desplegar aplicaciones"

config: ## Configurar servidores y desplegar cluster K3s
	@echo "🔧 Configurando servidores y desplegando cluster K3s..."
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml -i $(INVENTORY)
	@echo "✅ Cluster K3s configurado exitosamente"
	@echo "📁 Kubeconfig guardado en: $(KUBECONFIG_FILE)"
	@echo ""
	@echo "🔧 Para usar kubectl:"
	@echo "export KUBECONFIG=$$PWD/$(KUBECONFIG_FILE)"
	@echo "kubectl get nodes"

secrets: ## Crear secretos de Kubernetes desde Ansible Vault
	@echo "🔐 Creando secretos de Kubernetes..."
	@if [ ! -f "$(KUBECONFIG_FILE)" ]; then \
		echo "❌ Error: $(KUBECONFIG_FILE) no encontrado. Ejecuta 'make config' primero."; \
		exit 1; \
	fi
	export KUBECONFIG=$$PWD/$(KUBECONFIG_FILE) && \
	cd $(ANSIBLE_DIR) && \
	ansible-playbook k8s-secrets-setup.yml -i localhost, --ask-vault-pass
	@echo "✅ Secretos de Kubernetes creados exitosamente"

deploy-apps: ## Desplegar aplicaciones con Helm
	@echo "🚀 Desplegando aplicaciones..."
	@if [ ! -f "$(KUBECONFIG_FILE)" ]; then \
		echo "❌ Error: $(KUBECONFIG_FILE) no encontrado. Ejecuta 'make config' primero."; \
		exit 1; \
	fi
	@if [ -f "scripts/deploy_apps.sh" ]; then \
		export KUBECONFIG=$$PWD/$(KUBECONFIG_FILE) && \
		bash scripts/deploy_apps.sh; \
	else \
		echo "⚠️  Script scripts/deploy_apps.sh no encontrado"; \
		echo "📝 Crear script de despliegue de aplicaciones"; \
	fi

validate: ## Validar configuración y secretos
	@echo "🔍 Validando configuración..."
	@if [ -f "$(ANSIBLE_DIR)/validate-secrets.sh" ]; then \
		export KUBECONFIG=$$PWD/$(KUBECONFIG_FILE) && \
		bash $(ANSIBLE_DIR)/validate-secrets.sh; \
	else \
		echo "⚠️  Script de validación no encontrado"; \
	fi

clean: ## Limpiar archivos temporales
	@echo "🧹 Limpiando archivos temporales..."
	@find . -name "*.retry" -delete
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Limpieza completada"

# Comandos de desarrollo y depuración
debug-config: ## Ejecutar configuración en modo debug
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml -i $(INVENTORY) -vvv

check-syntax: ## Verificar sintaxis de playbooks
	cd $(ANSIBLE_DIR) && ansible-playbook --syntax-check playbook.yml
	cd $(ANSIBLE_DIR) && ansible-playbook --syntax-check k8s-secrets-setup.yml

list-hosts: ## Listar hosts del inventario
	cd $(ANSIBLE_DIR) && ansible-inventory -i $(INVENTORY) --list

ping-hosts: ## Verificar conectividad con hosts
	cd $(ANSIBLE_DIR) && ansible all -i $(INVENTORY) -m ping 