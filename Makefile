.PHONY : release install clean uninstall

PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

OUT = bufferdelay
OBJ = main.o dtbuf.o time_ms.o
CFLAGS += -Wall -g -O3

release: bufferdelay

bufferdelay: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(OUT) $(OBJ)

$(OBJ): dtbuf.h time_ms.h

fmt:
	indent --linux-style \
		--indent-level4 \
		--no-tabs \
		--format-all-comments \
		--braces-on-if-line \
		--space-after-cast \
		*.c *.h
	# fix indent breaking pointer alignment on some function signatures
	find -name '*.[ch]' -exec sed -i '/^[a-z].*(.*)$$/s/ \* / */' {} ';'

clean:
	rm -f $(OBJ) $(OUT)

install: release
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	install $(OUT) $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	cp bufferdelay.1 $(DESTDIR)$(MANPREFIX)/man1/bufferdelay.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(OUT)
	rm -f $(DESTDIR)$(MANPREFIX)/man1/bufferdelay.1
