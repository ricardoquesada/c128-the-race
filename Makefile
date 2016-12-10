.SILENT:

.PHONY: all clean res run

D71_IMAGE = "bin/therace.d71"
D64_IMAGE = "bin/therace.d64"
C1541 = c1541
X128 = x128
X64 = x64

all: res bin64 bin128
bin128: therace128 d71 run128
bin64: therace64 d64 run64

SRC=src/main.s src/intro.s src/cracktro.s src/music.s src/game.s

res:
	echo "Compressing resources..."
	-cp res/therace-legend-map.bin src
	-cp res/therace-level1-charset.bin src
	-cp res/therace-level1-map.bin src
	-cp res/therace-game-central-map.bin src

#
# c128
#

therace128: ${SRC}
	echo "Compiling..."
	cl65 -d -g -Ln bin/$@.sym -o bin/$@.prg -u __EXEHDR__ -t c128 -C $@.cfg $^

d71:
	echo "Generating d71 file..."
	$(C1541) -format "the race,rq" d71 $(D71_IMAGE)
	$(C1541) $(D71_IMAGE) -write bin/therace128.prg therace
	$(C1541) $(D71_IMAGE) -list

run128:
	echo "Running game"
	$(X128) -verbose -moncommands bin/therace128.sym $(D71_IMAGE)

#
# c64
#

therace64: ${SRC}
	echo "Compiling..."
	cl65 -d -g -Ln bin/$@.sym -o bin/$@.prg -u __EXEHDR__ -t c64 -C $@.cfg $^

d64:
	echo "Generating d64 file..."
	$(C1541) -format "the race,rq" d64 $(D71_IMAGE)
	$(C1541) $(D71_IMAGE) -write bin/therace64.prg therace
	$(C1541) $(D71_IMAGE) -list

run64:
	echo "Running game"
	$(X64) -verbose -moncommands bin/therace64.sym $(D71_IMAGE)

clean:
	rm -f src/*.o bin/*.sym bin/*.prg $(D71_IMAGE) $(D64_IMAGE)

