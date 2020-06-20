.PHONY: build test shell

build:
	@docker build --target base -t carpanta:infra .
test:
	@docker run --rm carpanta:infra bundle exec rake spec
shell:
	@docker run --rm -it -v ${PWD}:/usr/src -v ${PWD}/.aws:/root/.aws carpanta:infra bash
