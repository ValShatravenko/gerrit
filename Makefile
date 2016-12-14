NAME    = kaigara/gerrit
VERSION = 0.0.1

build:
	docker build -t $(NAME):$(VERSION) --rm .
	docker tag $(NAME):$(VERSION) $(NAME):latest

start: build
	docker run --rm -it -p 8080:8080 -p 29418:29418 \
		-v $(CURDIR)/config.yaml:/etc/kaigara/metadata/config.yaml $(NAME)

clean:
	-docker rmi -f $(NAME):$(VERSION)
