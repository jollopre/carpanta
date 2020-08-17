#!/bin/bash
set -euo pipefail

copy_environment_example() {
  if [[ ! -e infra/deploy.env ]]; then
    cp infra/deploy.env.example infra/deploy.env
  fi
}

load_from_environment() {
  copy_environment_example
  export $(cat infra/deploy.env)
  IMAGE_TAG=$(git log --pretty=format:%H -n 1)
}

build_image() {
  docker build -t ${IMAGE_NAME}:${IMAGE_TAG} --target production .
}

push_image() {
  docker push ${IMAGE_NAME}:${IMAGE_TAG}
}

provision() {
  IMAGE_TAG=${IMAGE_TAG} docker-compose -f docker-compose.base.yml -f docker-compose.deploy.yml run app
}

call() {
  load_from_environment
  build_image
  push_image
  provision
}
call
