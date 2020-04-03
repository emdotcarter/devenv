ID ?= 0

PORT = 3000
PORT-js = 3001
PORT-ruby = 3002
PORT-python = 8000
PORT-java = 3004

.PHONY: build-base build-js build-ruby build-python build-java build-mongodb build-postgresql build-all stop clean

base:
	$(MAKE) build-base
	$(call runDevEnv,)

js ruby python java:
	$(MAKE) build-$@
	$(call runDevEnv,$@,-)

mongodb postgresql:
	$(MAKE) build-$@
	$(call runDb,$@,-)

build-base:
	$(call buildDockerfile)

build-js: build-base
	$(call buildDockerfile,js,-)

build-ruby: build-base
	$(call buildDockerfile,ruby,-)

build-python: build-base
	$(call buildDockerfile,python,-)

build-java: build-base
	$(call buildDockerfile,java,-)

build-mongodb: build-base
	$(call buildDockerfile,mongodb,-)

build-postgresql: build-base
	$(call buildDockerfile,postgresql,-)

build-all: build-js build-ruby build-python build-java build-mongodb build-postgresql

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
		-v="$$HOME/.ssh/id_rsa:/home/mcarter/.ssh/id_rsa" \
		-v="$$PWD:/home/mcarter/dev/devenv" \
		-p $(PORT$(2)$(1)):$(PORT$(2)$(1)) \
		-e DISPLAY=10.0.0.6:0 \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
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
		-v="$$HOME/.ssh/id_rsa:/home/mcarter/.ssh/id_rsa" \
		-v="$$PWD:/home/mcarter/dev/devenv" \
		mdotcarter/devenv:latest$(1) \
		|| docker start devenv$(2)$(1)-$(ID)
		docker ps
endef
