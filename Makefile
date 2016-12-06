.SILENT:

.PHONY: all clean res run

D71_IMAGE = "bin/therace.d71"
C1541 = c1541
X128 = x128

all: res bin
bin: therace d71 run

SRC=src/intro.s src/cracktro.s src/music.s

res:
	echo "Compressing resources..."

therace: ${SRC}
	echo "Compiling..."
	cl65 -d -g -Ln bin/$@.sym -o bin/$@.prg -u __EXEHDR__ -t c128 -C $@.cfg $^

d71:
	echo "Generating d71 file..."
	$(C1541) -format "the race,rq" d71 $(D71_IMAGE)
	$(C1541) $(D71_IMAGE) -write bin/therace.prg therace
	$(C1541) $(D71_IMAGE) -list

run:
	echo "Running game"
	$(X128) -verbose -moncommands bin/therace.sym $(D71_IMAGE)

clean:
	rm -f src/*.o bin/*.sym bin/*.prg $(D71_IMAGE)

