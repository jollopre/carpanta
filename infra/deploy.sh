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
  COMPOSE_FILES_DEPLOY="-f docker-compose.base.yml -f docker-compose.deploy.yml"
}

build_image() {
  IMAGE_NAME=${IMAGE_NAME} IMAGE_TAG=${IMAGE_TAG} docker-compose ${COMPOSE_FILES_DEPLOY} build
}

push_image() {
  docker push ${IMAGE_NAME}:${IMAGE_TAG}
}

provision() {
  IMAGE_NAME=${IMAGE_NAME} IMAGE_TAG=${IMAGE_TAG} docker-compose ${COMPOSE_FILES_DEPLOY} run --rm -v ${PWD}/.aws:/root/.aws app bundle exec rake -f infra/Rakefile deploy:up[infra/production.json]
}

call() {
  load_from_environment
  build_image
  #push_image
  #provision
}
call
