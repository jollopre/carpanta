.PHONY: build test shell

build:
	@docker build --target base -t carpanta:provisioner .
test:
	@docker run --rm carpanta:provisioner bundle exec rake spec
shell:
	@docker run --rm -it -v ${PWD}:/usr/src carpanta:provisioner bash
