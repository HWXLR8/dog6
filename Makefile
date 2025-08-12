all: run

run:
	docker compose up --build

stop:
	docker compode down

.PHONY: all run stop
.DEFAULT_GOAL := all
