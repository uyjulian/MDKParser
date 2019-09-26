###############################################
##                                           ##
##     Copyright (C) 2019-2019 Julian Uy     ##
##   https://sites.google.com/site/awertyb   ##
##                                           ##
## See "LICENSE.md" for license information. ##
##                                           ##
###############################################

CC = i686-w64-mingw32-gcc
CXX = i686-w64-mingw32-g++
WINDRES := i686-w64-mingw32-windres
GIT_TAG := $(shell git describe --abbrev=0 --tags)
ALLSRCFLAGS += -DGIT_TAG=\"$(GIT_TAG)\" 
CFLAGS += -O2 -flto
CFLAGS += $(ALLSRCFLAGS) -Wall -Wno-unused-value -Wno-format -I. -I.. -I../ncbind -DNDEBUG -DWIN32 -D_WIN32 -D_WINDOWS 
CFLAGS += -D_USRDLL -DMINGW_HAS_SECURE_API -DUNICODE -D_UNICODE -DNO_STRICT -fpermissive
WINDRESFLAGS += $(ALLSRCFLAGS) --codepage=65001
LDFLAGS += -static -static-libstdc++ -static-libgcc -shared -Wl,--kill-at
LDLIBS +=

%.o: %.c
	@printf '\t%s %s\n' CC $<
	$(CC) -c $(CFLAGS) -o $@ $<

%.o: %.cpp
	@printf '\t%s %s\n' CXX $<
	$(CXX) -c $(CFLAGS) -o $@ $<

%.utf8.rc: %.rc
	@printf '\t%s %s\n' ICONV $<
	iconv -f UTF-16 -t UTF8 $< | sed 's/\.rc/.utf8.rc/g' > $@

%.o: %.utf8.rc
	@printf '\t%s %s\n' WINDRES $<
	$(WINDRES) $(WINDRESFLAGS) $< $@


SOURCES := ../tp_stub.cpp Main.cpp LexicalAnalyzer.cpp MDKMessages.cpp MDKParser.cpp Parser.cpp ReservedWord.cpp MDKParser.utf8.rc
OBJECTS := $(SOURCES:.c=.o)
OBJECTS := $(OBJECTS:.cpp=.o)
OBJECTS := $(OBJECTS:.utf8.rc=.o)

BINARY ?= MDKParser.dll
ARCHIVE ?= MDKParser.$(GIT_TAG).7z

all: $(BINARY)

archive: $(ARCHIVE)

clean:
	rm -f $(OBJECTS) $(BINARY) $(ARCHIVE)

MDKParser.utf8.rc: string_table_en.utf8.rc string_table_jp.utf8.rc

$(ARCHIVE): $(BINARY) 
	rm -f $(ARCHIVE)
	7z a $@ $^

$(BINARY): $(OBJECTS) 
	@printf '\t%s %s\n' LNK $@
	$(CXX) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
