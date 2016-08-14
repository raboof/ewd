.PHONY: all convert watch
all: convert

convert:
	./convert.sh

watch:
	./convert.sh ; while true ; do inotifywait assets/* *.pl; ./convert.sh; done
