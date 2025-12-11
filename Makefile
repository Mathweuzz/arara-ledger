# Makefile para AraraLedger - Passo 2
# Compila:
#   - src/util/hello-files.cob
#   - src/storage/files-init.cob

COBC      = cobc
COBCFLAGS = -free -Wall -I copy

BIN_DIR   = bin
SRC_DIR   = src

.PHONY: all run-hello run-init clean

all: $(BIN_DIR)/hello-files $(BIN_DIR)/files-init

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/hello-files: $(SRC_DIR)/util/hello-files.cob | $(BIN_DIR)
	$(COBC) $(COBCFLAGS) -x $< -o $@

$(BIN_DIR)/files-init: $(SRC_DIR)/storage/files-init.cob \
                       copy/accounts.cpy copy/journal.cpy copy/ledger.cpy copy/common.cpy \
                       | $(BIN_DIR)
	$(COBC) $(COBCFLAGS) -x $< -o $@

run-hello: $(BIN_DIR)/hello-files
	./$(BIN_DIR)/hello-files

run-init: $(BIN_DIR)/files-init
	./$(BIN_DIR)/files-init

clean:
	rm -f $(BIN_DIR)/*