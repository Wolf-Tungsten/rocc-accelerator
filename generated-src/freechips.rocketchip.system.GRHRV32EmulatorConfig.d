rvi-bmark-tests = \
	median.riscv \
	multiply.riscv \
	qsort.riscv \
	towers.riscv \
	vvadd.riscv \
	dhrystone.riscv \
	mt-matmul.riscv

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rvi-bmark-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/benchmarks/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rvi-bmark-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/benchmarks/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rvi-bmark-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rvi-bmark-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rvi-bmark-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-bmark-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-bmark-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-bmark-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-bmark-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(rvi-bmark-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32ua-p-asm-tests = \
	rv32ua-p-amoadd_w \
	rv32ua-p-amoand_w \
	rv32ua-p-amoor_w \
	rv32ua-p-amoxor_w \
	rv32ua-p-amoswap_w \
	rv32ua-p-amomax_w \
	rv32ua-p-amomaxu_w \
	rv32ua-p-amomin_w \
	rv32ua-p-amominu_w \
	rv32ua-p-lrsc

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32ua-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32ua-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32ua-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ua-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ua-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ua-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ua-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ua-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32uc-p-asm-tests = \
	rv32uc-p-rvc

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32uc-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32uc-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32uc-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32uc-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32uc-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32uc-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32uc-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32uc-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32ui-p-asm-tests = \
	rv32ui-p-simple \
	rv32ui-p-add \
	rv32ui-p-addi \
	rv32ui-p-and \
	rv32ui-p-andi \
	rv32ui-p-auipc \
	rv32ui-p-beq \
	rv32ui-p-bge \
	rv32ui-p-bgeu \
	rv32ui-p-blt \
	rv32ui-p-bltu \
	rv32ui-p-bne \
	rv32ui-p-fence_i \
	rv32ui-p-jal \
	rv32ui-p-jalr \
	rv32ui-p-lb \
	rv32ui-p-lbu \
	rv32ui-p-lh \
	rv32ui-p-lhu \
	rv32ui-p-lui \
	rv32ui-p-lw \
	rv32ui-p-or \
	rv32ui-p-ori \
	rv32ui-p-sb \
	rv32ui-p-sh \
	rv32ui-p-sw \
	rv32ui-p-sll \
	rv32ui-p-slli \
	rv32ui-p-slt \
	rv32ui-p-slti \
	rv32ui-p-sra \
	rv32ui-p-srai \
	rv32ui-p-srl \
	rv32ui-p-srli \
	rv32ui-p-sub \
	rv32ui-p-xor \
	rv32ui-p-xori

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32ui-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32ui-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32ui-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ui-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ui-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ui-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32ui-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ui-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

rv32mi-p-asm-tests = \
	rv32mi-p-csr \
	rv32mi-p-mcsr \
	rv32mi-p-illegal \
	rv32mi-p-ma_addr \
	rv32mi-p-ma_fetch \
	rv32mi-p-sbreak \
	rv32mi-p-scall

$(addprefix $(output_dir)/, $(addsuffix .hex, $(rv32mi-p-asm-tests))): $(output_dir)/%.hex: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%.hex
	mkdir -p $(output_dir)
	ln -fs $< $@

$(addprefix $(output_dir)/, $(rv32mi-p-asm-tests)): $(output_dir)/%: $(RISCV)/riscv64-unknown-elf/share/riscv-tests/isa/%
	mkdir -p $(output_dir)
	ln -fs $< $@

run-rv32mi-p-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32mi-p-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-rv32mi-p-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-asm-p-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ua-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ui-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-p-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ua-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ui-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-p-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ua-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ui-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-p-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(rv32ua-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ui-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

run-asm-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(rv32ua-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ui-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(rv32ua-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ui-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(rv32ua-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ui-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-asm-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(rv32ua-p-asm-tests) $(rv32uc-p-asm-tests) $(rv32ui-p-asm-tests) $(rv32mi-p-asm-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'

regression-tests = \
rv32mi-p-ma_addr \
rv32mi-p-csr \
rv32ui-p-sh \
rv32ui-p-lh \
rv32uc-p-rvc \
rv32mi-p-sbreak \
rv32ui-p-sll
run-regression-tests: $(addprefix $(output_dir)/, $(addsuffix .out, $(regression-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-regression-tests-debug: $(addprefix $(output_dir)/, $(addsuffix .vpd, $(regression-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.vpd,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-regression-tests-fst: $(addprefix $(output_dir)/, $(addsuffix .fst, $(regression-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $(patsubst %.fst,%.out,$^) /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
run-regression-tests-fast: $(addprefix $(output_dir)/, $(addsuffix .run, $(regression-tests)))
	@echo; perl -ne 'print "  [$$1] $$ARGV \t$$2\n" if( /\*{3}(.{8})\*{3}(.*)/ || /ASSERTION (FAILED):(.*)/i )' $^ /dev/null | perl -pe 'BEGIN { $$failed = 0 } $$failed = 1 if(/FAILED/i); END { exit($$failed) }'
