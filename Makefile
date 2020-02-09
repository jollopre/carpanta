COMPOSE_FILES_DEVELOPMENT=-f docker-compose.yml -f docker-compose.devel.yml
COMPOSE_FILES_TEST=-f docker-compose.yml -f docker-compose.test.yml
development_up:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} up -d
development_down:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} down
build_test:
	docker-compose ${COMPOSE_FILES_TEST} build
test:	build_test
	docker-compose ${COMPOSE_FILES_TEST} run --rm app
bash:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bash
console:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bin/console
