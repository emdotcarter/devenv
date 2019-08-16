ID ?= 0

PORT = 3000
PORT-js = 3001
PORT-ruby = 3002
PORT-python = 3003

.PHONY: build-base build-js build-ruby build-python build-mongodb build-postgres build-all stop clean

build-base:
	$(call buildDockerfile)

build-js:
	$(call buildDockerfile,js,-)

build-ruby:
	$(call buildDockerfile,ruby,-)

build-python:
	$(call buildDockerfile,python,-)

build-mongodb:
	$(call buildDockerfile,mongodb,-)

build-postgres:
	$(call buildDockerfile,postgres,-)

build-all: build-js build-ruby build-python build-mongodb build-postgres

base:
	$(MAKE) build-base
	$(call runDevEnv,)

js ruby python:
	$(MAKE) build-$@
	$(call runDevEnv,$@,-)

mongodb postgres:
	$(MAKE) build-$@
	$(call runDb,$@,-)

stop:
	docker stop $$(docker ps -aq)

clean:
	$(MAKE) stop && docker rm -f $$(docker ps -aq)

nuclear:
	-docker rm -f $$(docker ps -aq)
	-docker rmi -f $$(docker images -aq)

define buildDockerfile
	docker build . -f Dockerfile$(2)$(1) -t mdotcarter/devenv:latest$(1)
endef

define runDevEnv
	docker network create devenv || true
	docker run -d -i -t \
		--name="devenv$(2)$(1)-$(ID)" \
		--network="devenv" \
		-v="$$HOME/.ssh/id_rsa_ghbb:/home/mcarter/.ssh/id_rsa_ghbb" \
		-v="$$PWD:/home/mcarter/dev/devenv" \
		-p $(PORT$(2)$(1)):$(PORT$(2)$(1)) \
		mdotcarter/devenv:latest$(1) \
		|| docker start devenv$(2)$(1)-$(ID)
		docker ps
		docker attach --detach-keys="ctrl-a,d" devenv$(2)$(1)-$(ID) || true
		docker ps
endef

define runDb
	docker network create devenv || true
	docker run -d -i -t \
		--name="devenv$(2)$(1)-$(ID)" \
		--network="devenv" \
		-v="$$HOME/.ssh/id_rsa_ghbb:/home/mcarter/.ssh/id_rsa_ghbb" \
		-v="$$PWD:/home/mcarter/dev/devenv" \
		mdotcarter/devenv:latest$(1) \
		|| docker start devenv$(2)$(1)-$(ID)
		docker ps
endef
