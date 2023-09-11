#!/bin/bash

command_output=$(helm status my-gcs-repo 2>&1)

expected_error="Error: release: not found"

if [ "$command_output" = "$expected_error" ]; then
    helm install my-gcs-repo project-crypto/helm/crypto_flask_haknin/
else
    helm upgrade --recreate-pods my-gcs-repo project-crypto/helm/crypto_flask_haknin/
fi
