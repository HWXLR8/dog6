run:
	docker compose up --build

deploy:
	docker compose up --build -d

stop:
	docker compose down

eradicate:
	docker system prune -a -f --volumes
	docker volume ls -q | xargs -r docker volume rm

.PHONY: run deploy stop eradicate
.DEFAULT_GOAL := run
