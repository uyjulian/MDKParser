
SOURCES += Main.cpp LexicalAnalyzer.cpp MDKMessages.cpp MDKParser.cpp Parser.cpp ReservedWord.cpp MDKParser.rc

PROJECT_BASENAME = MDKParser



include external/tp_stubz/Rules.lib.make

%.utf8.rc: %.rc
	@printf '\t%s %s\n' ICONV $<
	iconv -f UTF-16 -t UTF8 $< | sed 's/\.rc/.utf8.rc/g' > $@

%.o: %.utf8.rc
	@printf '\t%s %s\n' WINDRES $<
	$(WINDRES) $(WINDRESFLAGS) $< $@

MDKParser.rc: string_table_en.utf8.rc string_table_jp.utf8.rc

clean::
	rm -f string_table_en.utf8.rc string_table_jp.utf8.rc
