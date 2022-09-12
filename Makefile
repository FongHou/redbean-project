PROJECT = redbean.com

SOURCES = $(shell ls src/*.fnl | sed 's/.fnl$$/.lua/' | sed 's/^src/.lua/')

.lua/%.lua: src/%.fnl
	./fennel --no-compiler-sandbox --compile $< >$@

clean:
	rm -f ${SOURCES}
	zip -qd ${PROJECT} ${SOURCES} || true

debug: clean
	DEBUG=1 ./${PROJECT} -u -D .

repl: clean
	./${PROJECT} -D .

reload: clean
	ls ${PROJECT} src/*.fnl | entr -r ./${PROJECT} -u -D .

release: ${SOURCES}
	zip ./${PROJECT} .init.lua
	zip -r ${PROJECT} .lua

deps:
	curl https://redbean.dev/redbean-latest.com >${PROJECT} && chmod +x ${PROJECT}
	curl https://fennel-lang.org/downloads/fennel-1.2.0 >fennel && chmod +x fennel
	curl https://raw.githubusercontent.com/pkulchenko/fullmoon/master/fullmoon.lua >.lua/fullmoon.lua
	curl https://raw.githubusercontent.com/slembcke/debugger.lua/master/debugger.lua >.lua/debugger.lua
	sudo sh -c "echo ':APE:M::MZqFpD::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
