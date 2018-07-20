ID ?= 0

run:
	docker run -itd \
		--name=devenv-$(ID) \
		-v=$$PWD:/root/dev/devenv \
		emdotcarter/devenv \
		|| docker start devenv-$(ID)
	docker attach --detach-keys=ctrl-a,d devenv-$(ID) || true
	docker ps

stop:
	docker stop $$(docker ps --aq)

clean:
	docker rm $$(docker ps -aq)

build:
	docker build . -f Dockerfile -t emdotcarter/devenv
