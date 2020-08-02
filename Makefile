.PHONY: up down build test clean shell shell_assets console logs start stop build_production release deploy

COMPOSE_FILES_ASSETS=-f docker-compose.assets.yml
COMPOSE_FILES_TEST=-f docker-compose.base.yml -f docker-compose.test.yml
COMPOSE_FILES_DEVELOPMENT=-f docker-compose.base.yml -f docker-compose.devel.yml
COMPOSE_FILES_PRODUCTION=-f docker-compose.base.yml -f docker-compose.prod.yml
IMAGE_NAME=jollopre/carpanta
IMAGE_TAG=$(shell git log --pretty=format:%H -n 1)

up:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} up -d
down:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} down
build:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} build
test:
	@docker-compose ${COMPOSE_FILES_TEST} build
	@docker-compose ${COMPOSE_FILES_ASSETS} run --rm assets npm test
	@docker-compose ${COMPOSE_FILES_TEST} run --rm app bundle exec rake spec
clean:
	@docker-compose ${COMPOSE_FILES_ASSETS} down --rmi local --volumes
	@docker-compose ${COMPOSE_FILES_TEST} down --rmi local --volumes
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} down --rmi local --volumes
shell:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bash
shell_assets:
	@docker-compose ${COMPOSE_FILES_ASSETS} run --rm assets sh
console:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bin/console
logs:
	@docker-compose -f docker-compose.base.yml logs -f
start:
	@docker-compose ${COMPOSE_FILES_PRODUCTION} build
	@docker-compose ${COMPOSE_FILES_PRODUCTION} up -d
stop:
	@docker-compose ${COMPOSE_FILES_PRODUCTION} down
build_production:
	IMAGE_NAME=${IMAGE_NAME} IMAGE_TAG=${IMAGE_TAG} docker-compose ${COMPOSE_FILES_PRODUCTION} build
release:
	@docker push ${IMAGE_NAME}:${IMAGE_TAG}
deploy: build_production release
	IMAGE_NAME=${IMAGE_NAME} IMAGE_TAG=${IMAGE_TAG} docker-compose ${COMPOSE_FILES_PRODUCTION} run --rm -v ${PWD}/.aws:/root/.aws app bundle exec rake deploy:up[infra/production.json]
