CC=gcc
CFLAGS=-Wall -O2

all: network-check

network-check: network-check.c
	$(CC) $(CFLAGS) -o network-check network-check.c

clean:
	rm -f network-check

install: all
	install -d $(DESTDIR)/usr/bin
	install -m 755 network-check $(DESTDIR)/usr/bin/

.PHONY: all clean install
