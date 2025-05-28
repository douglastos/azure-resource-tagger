#!/usr/bin/env bash
set -uo pipefail

SUBSCRIPTION_ID=$AZ_SUB_ID
az account set --subscription "$SUBSCRIPTION_ID"

TAGS=(status=semuso env=prd produto=int cliente=sir iac=nao)

# Abrir o arquivo em um descritor separado para evitar problemas de leitura
exec 3< resources.txt

while IFS= read -r RID <&3; do
  CLEANED_RID=$(echo "$RID" | tr -d '\r' | xargs)
  [[ -z "$CLEANED_RID" ]] && continue
  echo "Tagging: $CLEANED_RID"
  az tag update --resource-id "$CLEANED_RID" --operation merge --tags "${TAGS[@]}" \
    || echo "❌ Falha ao taguear: $CLEANED_RID"
done

exec 3<&-
