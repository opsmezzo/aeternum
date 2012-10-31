CFLAGS+=-g -Wall -Ideps/libuv/include

uname_S=$(shell uname -s)

ifeq (Darwin, $(uname_S))
CFLAGS+=-framework CoreServices
endif

ifeq (Linux, $(uname_S))
LDFLAGS+=-lc -lrt -ldl -lm -pthread
endif

ifeq (SunOS, $(uname_S))
CFLAGS+=-lsendfile -lsocket -lkstat -lnsl -lm
endif

all: libuv aeternum

debug: libuv aeternum_g

aeternum_g:
	gcc -ggdb $(CFLAGS) -o aeternum_g aeternum.c options.c deps/libuv/libuv.a $(LDFLAGS)

aeternum: 
	gcc $(CFLAGS) -o aeternum aeternum.c options.c deps/libuv/libuv.a $(LDFLAGS)

libuv: 
	cd deps/libuv/; ./gyp_uv -f make
	make -C deps/libuv/

clean: 
	rm -f aeternum
	rm -f aeternum_g

cleanall: 
	rm -f aeternum
	rm -f aeternum_g
	make clean -C deps/libuv/

.PHONY: clean cleanall
