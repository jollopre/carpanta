.PHONY: up down build test shell console logs start stop

COMPOSE_FILES_TEST=-f docker-compose.base.yml -f docker-compose.test.yml
COMPOSE_FILES_DEVELOPMENT=-f docker-compose.base.yml -f docker-compose.devel.yml
COMPOSE_FILES_PRODUCTION=-f docker-compose.base.yml -f docker-compose.prod.yml
TAG=$(shell git log --pretty=format:%H -n 1)

up:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} up -d
down:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} down
build:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} build
test:
	@docker-compose ${COMPOSE_FILES_TEST} build
	@docker-compose ${COMPOSE_FILES_TEST} run --rm app bundle exec rake spec
clean:
	@docker-compose -f docker-compose.base.yml down --rmi local --volumes
shell:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bash
console:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bin/console
logs:
	@docker-compose -f docker-compose.base.yml logs -f
start:
	@docker-compose ${COMPOSE_FILES_PRODUCTION} build
	@docker-compose ${COMPOSE_FILES_PRODUCTION} up -d
stop:
	@docker-compose ${COMPOSE_FILES_PRODUCTION} down
