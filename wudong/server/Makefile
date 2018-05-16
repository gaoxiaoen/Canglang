SHELL := /bin/bash
ERL := erl
PROCESS_NUM := 8

.PHONY: all hipe clean
_: all

all:
	@($(ERL) -pa ebin -noshell -eval "case make:files([\"src/tool/mmake.erl\"], [{outdir, \"ebin\"}]) of error -> halt(1); _ -> ok end" -eval "case mmake:all($(PROCESS_NUM),[$(MAKE_OPTS)]) of up_to_date -> halt(0); error -> halt(1) end.")

hipe:
	@($(ERL) -pa ebin -noshell -eval "case make:files([\"src/tool/game_hipe.erl\"], [{outdir, \"ebin\"}]) of error -> halt(1); _ -> ok end" -eval "case game_hipe:hipe() of ok -> halt(0); _ -> halt(1) end.")

clean:
	@(rm -f ebin/*.beam && svn up --force)


