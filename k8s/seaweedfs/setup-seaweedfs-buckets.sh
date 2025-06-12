#!/bin/bash
set -e
# Endpoint de SeaweedFS S3
S3_ENDPOINT="http://seaweedfs-s3.seaweedfs.svc.cluster.local:8333"

# Buckets necesarios para oCIS
BUCKETS=("ocis-system-storage" "ocis-user-storage")


# Crear buckets usando el cliente AWS S3
for BUCKET in "${BUCKETS[@]}"; do

  echo "Verificando/Creando bucket $BUCKET..."
  
  # El comando 'aws s3api head-bucket' falla si el bucket no existe.
  # Lo usamos para verificar antes de intentar crear.
  if kubectl run s3-client-check --rm -i --restart=Never --image=amazon/aws-cli \
    --command -- aws --no-sign-request --endpoint-url $S3_ENDPOINT \
    s3api head-bucket --bucket "$BUCKET" >/dev/null 2>&1; then
    echo "Bucket $BUCKET ya existe."
  else
    echo "Bucket $BUCKET no encontrado. Creando..."
    kubectl run s3-client-create --rm -i --restart=Never --image=amazon/aws-cli \
      --command -- aws --no-sign-request --endpoint-url $S3_ENDPOINT \
      s3 mb "s3://$BUCKET"
    echo "Bucket $BUCKET creado."
  fi
done
echo "Proceso de buckets completado."