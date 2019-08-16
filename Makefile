ID ?= 0

PORT = 3000
PORT-js = 3001
PORT-ruby = 3002
PORT-go = 3003
PORT-python = 3004

build:
	docker build . -f Dockerfile -t mdotcarter/devenv:latest
	# docker build . -f Dockerfile-js -t mdotcarter/devenv:latestjs
	# docker build . -f Dockerfile-ruby -t mdotcarter/devenv:latestruby
	# docker build . -f Dockerfile-go -t mdotcarter/devenv:latestgo
	docker build . -f Dockerfile-python -t mdotcarter/devenv:latestpython
	# docker build . -f Dockerfile-mongodb -t mdotcarter/devenv:latestmongodb
	# docker build . -f Dockerfile-postgres -t mdotcarter/devenv:latestpostgres

run:
	$(call runDevEnv,)

js ruby go python:
	$(call runDevEnv,$@,-)

mongodb postgres:
	$(call runDb,$@,-)

stop:
	docker stop $$(docker ps -aq)

clean:
	docker rm $$(docker ps -aq)

nuclear:
	docker stop $$(docker ps -aq)
	docker rm $$(docker ps -aq)
	docker rmi -f $$(docker images -aq)


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
