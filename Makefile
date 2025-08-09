IMAGE = arch-lighttpd

all: build run

build:
	docker build -t $(IMAGE) .

run:
	docker run -p 80:80 $(IMAGE)

clean:
	docker rm -f $$(docker ps -aq --filter ancestor=$(IMAGE)) || true
	docker rmi -f $(IMAGE) || true
	docker image prune -f
	docker rmi -f $$(docker images -f "dangling=true" -q) || true

.PHONY: all build run clean
.DEFAULT_GOAL := all
