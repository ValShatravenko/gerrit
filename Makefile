NAME    = kaigara/gerrit
VERSION = 0.0.1

build:
	      docker build -t $(NAME):$(VERSION) --rm .
				docker tag $(NAME):$(VERSION) $(NAME):latest
start:
	      docker run -p 8080:8080 -d $(NAME) /usr/local/bin/gerrit-start.sh
clean:
				docker rmi -f $(NAME):$(VERSION)
