.PHONEY: env env-notebook docker-build docker-push docker-run

SHELL:=bash

## Configs
GCP_PROJECT=wide-hexagon-397214
GCP_REGION=asia-south1
GCP_ARTIFACT_REPO=youtube-data-repo
IMAGE_NAME=youtube-data-project
IMAGE_VERSION=latest

IMAGE_GCP_NAME=${GCP_REGION}-docker.pkg.dev/${GCP_PROJECT}/${GCP_ARTIFACT_REPO}/${IMAGE_NAME}:${IMAGE_VERSION}

## Environment
env:
	@if [ -d "yt-env" ]; then \
		echo "yt-env directory already exists"; \
	else \
		echo "yt-env is being created"; \
		python -m venv yt-env; \
	fi
	source yt-env/bin/activate
	pip install -r requirements.txt
	pip install torch --index-url https://download.pytorch.org/whl/cpu

env-notebook: env
	python -m ipykernel install --user --name=yt-venv-jupyter


## Docker
docker-build:
	docker build . \
	-t ${IMAGE_NAME}:${IMAGE_VERSION} \
	-t ${IMAGE_GCP_NAME} \
	--build-arg YOUTUBE_API_KEY \
	--build-arg SERVICE_ACCOUNT_SECRET_KEY

docker-push:
	docker push ${IMAGE_GCP_NAME}

docker-run:
	docker run ${IMAGE_NAME}:${IMAGE_VERSION}

