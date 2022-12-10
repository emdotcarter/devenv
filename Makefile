.PHONY: build-base build-python build-postgres build-all stop clean

base:
	$(MAKE) build-base
	$(call runDevEnv,)

python:
	$(MAKE) build-$@
	$(call runDevEnv,$@,-)

postgres:
	$(MAKE) build-$@
	$(call runDb,$@,-)

build-base:
	$(call buildDockerfile)

build-python: build-base
	$(call buildDockerfile,python,-)

build-postgres: build-base
	$(call buildDockerfile,postgres,-)

build-all: build-python build-postgres

define buildDockerfile
	docker build . -f Dockerfile$(2)$(1) -t mdotcarter/devenv:latest$(1)
endef

define runDevEnv
	docker network create devenv-net || true
	docker run -d -i -t \
		--name="devenv$(2)$(1)" \
		--network="devenv" \
		-v="$$HOME/.ssh/id_rsa:/home/mcarter/.ssh/id_rsa" \
		-v="$$PWD:/home/mcarter/dev/devenv" \
		-e DISPLAY=10.0.0.6:0 \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		mdotcarter/devenv:latest$(1) \
		|| docker start devenv$(2)$(1)
		docker ps
		docker attach --detach-keys="ctrl-a,d" devenv$(2)$(1) || true
		docker ps
endef

define runDb
	docker network create devenv-net || true
	docker run -d -i -t \
		--name="devenv$(2)$(1)" \
		--network="devenv" \
		mdotcarter/devenv:latest$(1) \
		|| docker start devenv$(2)$(1)
	docker ps
endef
