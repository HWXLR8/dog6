run:
	docker compose up --build

deploy:
	docker compose up --build -d

stop:
	docker compose down

.PHONY: run deploy stop
.DEFAULT_GOAL := run
