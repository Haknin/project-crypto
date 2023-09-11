import docker
import re

client = docker.from_env()
images = client.images.list()

# Regular expression pattern to match version numbers in the tag
version_pattern = r"^haknin/crypto_docker:(\d+\.\d+)$"

existing_versions = [
    float(re.match(version_pattern, image.tags[0]).group(1))
    for image in images
    if image.tags and re.match(version_pattern, image.tags[0])
]

if existing_versions:
    latest_version = max(existing_versions)
    next_version = latest_version + 0.1
else:
    next_version = 1.0

# Format the version number to one decimal place
next_version = round(next_version, 1)
image_name = f"haknin/crypto_docker:{next_version}"

# Build the Docker image with the specified tag
client.images.build(path=".", tag=image_name, rm=True, pull=True)
print(f"Successfully built image: {image_name}")

# Push the image with the specified tag to Docker Hub
client.images.push(repository="haknin/crypto_docker", tag=next_version)
print(f"Successfully pushed image: {image_name}")

# Clean up older versions of the image
for image in images:
    if image.tags and re.match(version_pattern, image.tags[0]):
        version = float(re.match(version_pattern, image.tags[0]).group(1))
        if version != float(latest_version) and version != float(next_version):
            client.images.remove(image.id, force=True)
            print(f"Successfully removed image: {image.tags[0]}")
