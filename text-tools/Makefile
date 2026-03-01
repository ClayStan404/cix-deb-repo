CC=gcc
CFLAGS=-Wall -O2

all: word-count line-count

word-count: word-count.c
	$(CC) $(CFLAGS) -o word-count word-count.c

line-count: line-count.c
	$(CC) $(CFLAGS) -o line-count line-count.c

clean:
	rm -f word-count line-count

install: all
	install -d $(DESTDIR)/usr/bin
	install -m 755 word-count $(DESTDIR)/usr/bin/
	install -m 755 line-count $(DESTDIR)/usr/bin/

.PHONY: all clean install
