#!/usr/bin/env python3
import docker
import os
from datetime import datetime

# Qarnot user info
remote_repository = 'containers.qarnot.com'
remote_user = 'samuelgaussf'
remote_username = 'samuel.lazerson@gauss-fusion.com'
remote_password = os.getenv('QARNOT_REGISTRY_KEY')

# Image info
dockerfile = 'Dockerfile'
image_name = 'roce_mpi_test'
platform   = 'linux/amd64'
build_args = ['platform',platform]

# Tag the image with a build date
image_tag = datetime.now().strftime("%m%d%y")

# Create the Client
client = docker.from_env()
# Build the image
(image,log)=client.images.build(path='./',tag=f"{image_name}:{image_tag}",platform=platform,dockerfile=dockerfile)
# Now tag the image with the remote name and 'latest'
remote_name = f'{remote_repository}/{remote_user}/{image_name}'
late_tag = 'latest'
image.tag(remote_name,image_tag)
image.tag(remote_name,late_tag)
# Login to the remote Server
client.login(username=remote_username,registry=remote_repository,password=remote_password)
# Push the image tags
for line in client.images.push(remote_name, tag=image_tag,stream=True,decode=True):
	print(line)
for line in client.images.push(remote_name, tag=late_tag,stream=True,decode=True):
	print(line)
