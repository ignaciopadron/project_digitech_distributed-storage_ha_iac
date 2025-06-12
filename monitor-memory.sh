#!/bin/bash
echo "=== MONITOREO DE MEMORIA DEL CLUSTER ==="
echo "Fecha: $(date)"
echo ""
kubectl top nodes
echo ""
echo "=== TOP 10 PODS POR MEMORIA ==="
kubectl top pods -A --sort-by=memory | head -11
echo ""
echo "=== PODS CON PROBLEMAS ==="
kubectl get pods -A | grep -v Running | grep -v Completed || echo "✅ Todos los pods están Running" 