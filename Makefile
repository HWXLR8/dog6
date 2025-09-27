run:
	docker compose up --build

deploy:
	docker compose up --build -d

stop:
	docker compose down

eradicate:
	docker system prune -a -f --volumes
	docker volume ls -q | xargs -r docker volume rm

purge:
	- docker rm -f $$(docker ps -aq)
	- docker rmi -f $$(docker images -q)
	- docker network prune -f

.PHONY: run deploy stop eradicate purge
.DEFAULT_GOAL := run
