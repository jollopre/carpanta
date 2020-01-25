COMPOSE_FILES_DEVELOPMENT=-f docker-compose.yml -f docker-compose.devel.yml
development_up:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} up -d
development_down:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} down
bash:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bash
console:
	docker-compose ${COMPOSE_FILES_DEVELOPMENT} run --rm app bin/console
