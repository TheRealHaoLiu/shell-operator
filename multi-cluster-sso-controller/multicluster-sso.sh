#!/usr/bin/env bash

if [[ $1 == "--config" ]] ; then
  cat <<EOF
configVersion: v1
kubernetes:
- apiVersion: hive.openshift.io/v1
  kind: ClusterClaim
  executeHookOnEvent: ["Added"]
EOF
else
  echo "BINDING_CONTEXT_PATH: $(cat $BINDING_CONTEXT_PATH | jq -c )"
  clusterClaimName=$(jq -r .[0].objects[0].object.metadata.name $BINDING_CONTEXT_PATH)
  clusterClaimNamespace=$(jq -r .[0].objects[0].object.metadata.namespace $BINDING_CONTEXT_PATH)

  #TODO: iterate through objects?
  echo "[Added] ClusterClaim '${clusterClaimName}' Namespace '${clusterClaimNamespace}'"
  echo "Creating Test ConfigMap"

  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${clusterClaimName}
  namespace: ${clusterClaimNamespace}
EOF

fi
