.PHONY: up down build test clean shell shell_assets console lint logs seed start stop deploy

COMPOSE_FILES_ASSETS=-f docker-compose.assets.yml
COMPOSE_FILES_TEST=-f docker-compose.base.yml -f docker-compose.test.yml
COMPOSE_FILES_DEVELOPMENT=-f docker-compose.base.yml -f docker-compose.devel.yml
COMPOSE_FILES_PRODUCTION=-f docker-compose.base.yml -f docker-compose.prod.yml

up:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} up -d
down:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} down
build:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} build
test:
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
lint:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bundle exec standardrb
logs:
	@docker-compose -f docker-compose.base.yml logs -f
seed:
	@docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bundle exec rake db:seed
start:
	@docker-compose ${COMPOSE_FILES_PRODUCTION} build
	@docker-compose ${COMPOSE_FILES_PRODUCTION} up -d
stop:
	@docker-compose ${COMPOSE_FILES_PRODUCTION} down
deploy:
	sh infra/deploy.sh
