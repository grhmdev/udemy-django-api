DOCKER_RUN = docker-compose run --rm app sh -c 

.PHONY: serve
serve:
	docker-compose up

# Targets below are used by GitHub actions!

.PHONY: lint
lint:
	${DOCKER_RUN} "flake8"

.PHONY: test
test:
	${DOCKER_RUN} "python manage.py test"
