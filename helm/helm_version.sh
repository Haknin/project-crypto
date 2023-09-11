#!/bin/bash
# Navigate to the chart directory
cd crypto-site/helm/crypto_flask_haknin/

# Extract the current version from Chart.yaml
VERSION=$(grep "version:" Chart.yaml | cut -d ' ' -f 2)

# Split the version into major, minor, and patch numbers
MAJOR=$(echo $VERSION | cut -d '.' -f 1)
MINOR=$(echo $VERSION | cut -d '.' -f 2)
PATCH=$(echo $VERSION | cut -d '.' -f 3)

# Increment the patch number
PATCH=$((PATCH + 1))

# Construct the new version number
NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Update Chart.yaml with the new version
sed -i "s/version: $VERSION/version: $NEW_VERSION/g" Chart.yaml

# Package the helm chart
helm package . --destination /tmp --version $NEW_VERSION --app-version $NEW_VERSION

# Rename the package
mv /tmp/flaskapp-$NEW_VERSION.tgz /tmp/helm-project-$NEW_VERSION.tgz

# Push the package to the GCP bucket
gsutil cp /tmp/helm-project-$NEW_VERSION.tgz gs://bucket-haknin

# Cleanup
rm /tmp/helm-project-$NEW_VERSION.tgz
echo "Chart helm-project-$NEW_VERSION.tgz has been uploaded to the bucket-haknin bucket."

# List all versions, sorted
ALL_VERSIONS=$(gsutil ls gs://bucket-haknin | grep helm-project | sort)

# Count total versions
COUNT=$(echo "$ALL_VERSIONS" | wc -l)

# Calculate how many to delete
DELETE_COUNT=$((COUNT - 5))

# Loop and delete oldest versions if there are more than 5
if [ $DELETE_COUNT -gt 0 ]; then
    echo "$ALL_VERSIONS" | head -n $DELETE_COUNT | while read -r version; do
        gsutil rm "$version"
        echo "Deleted old version: $version"
    done
fi
