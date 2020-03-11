COMPOSE_FILES_DEVELOPMENT=-f docker-compose.yml -f docker-compose.devel.yml
COMPOSE_FILES_TEST=-f docker-compose.yml -f docker-compose.test.yml

.PHONY: development_up development_down build_test test bash console
development_up:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} up -d
development_down:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} down
build_devel:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} build
build_test:
	docker-compose ${COMPOSE_FILES_TEST} build
test:	build_test
	docker-compose ${COMPOSE_FILES_TEST} run --rm app bundle exec rake test:all
bash:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bash
console:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bin/console
