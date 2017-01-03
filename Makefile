NAME    = kaigara/gerrit
VERSION ?= $(shell git describe --tags --abbrev=0 | tr -d 'v' 2>/dev/null)

build:
	docker build -t $(NAME):$(VERSION) --rm .
	docker tag $(NAME):$(VERSION) $(NAME):latest

start: build
	docker run --rm -it -p 8080:8080 -p 29418:29418 \
		-v $(CURDIR)/defaults.yaml:/etc/kaigara/metadata/config.yaml $(NAME)

clean:
	-docker rmi -f $(NAME):$(VERSION)
