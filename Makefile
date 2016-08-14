.PHONY: all convert watch
all: convert

convert:
	./convert.sh

watch:
	./convert.sh ; while true ; do inotifywait -e MODIFY assets/* *.pl; echo 'refreshing'; ./convert.sh; done
