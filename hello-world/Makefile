CC=gcc
CFLAGS=-Wall -O2

all: hello-world

hello-world: hello-world.c
	$(CC) $(CFLAGS) -o hello-world hello-world.c

clean:
	rm -f hello-world

install: all
	install -d $(DESTDIR)/usr/bin
	install -m 755 hello-world $(DESTDIR)/usr/bin/

.PHONY: all clean install
