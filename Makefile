ID ?= 0

build:
	docker build . -f Dockerfile -t mdotcarter/devenv:latest
	docker build . -f Dockerfile-js -t mdotcarter/devenv:latestjs
	docker build . -f Dockerfile-mongodb -t mdotcarter/devenv:latestmongodb

run:
	$(call runDevEnv,)

js:
	$(call runDevEnv,$@,-)

mongodb:
	$(call runDb,$@,-)

stop:
	docker stop $$(docker ps -aq)

clean:
	docker rm $$(docker ps -aq)

define runDevEnv
	docker network create devenv || true
	docker run -d -i -t \
		--name="devenv$(2)$(1)-$(ID)" \
		--network="devenv" \
		-v="$$HOME/.ssh/id_rsa_ghbb:/root/.ssh/id_rsa_ghbb" \
		-v="$$PWD:/root/dev/devenv" \
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
		-v="$$HOME/.ssh/id_rsa_ghbb:/root/.ssh/id_rsa_ghbb" \
		-v="$$PWD:/root/dev/devenv" \
		mdotcarter/devenv:latest$(1) \
		|| docker start devenv$(2)$(1)-$(ID)
		docker ps
endef
