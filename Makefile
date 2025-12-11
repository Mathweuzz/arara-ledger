# Makefile para AraraLedger - Passo 3
# Compila:
#   - src/util/hello-files.cob
#   - src/storage/files-init.cob
#   - src/storage/accounts-io.cob + src/tui/menu.cob (TUI)

COBC      = cobc
COBCFLAGS = -free -Wall -I copy

BIN_DIR   = bin
SRC_DIR   = src

.PHONY: all run-hello run-init run-menu clean

all: $(BIN_DIR)/hello-files $(BIN_DIR)/files-init $(BIN_DIR)/menu

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/hello-files: $(SRC_DIR)/util/hello-files.cob | $(BIN_DIR)
	$(COBC) $(COBCFLAGS) -x $< -o $@

$(BIN_DIR)/files-init: $(SRC_DIR)/storage/files-init.cob \
                       copy/accounts.cpy copy/journal.cpy copy/ledger.cpy copy/common.cpy \
                       | $(BIN_DIR)
	$(COBC) $(COBCFLAGS) -x $< -o $@

$(BIN_DIR)/menu: $(SRC_DIR)/tui/menu.cob $(SRC_DIR)/storage/accounts-io.cob \
                 copy/accounts.cpy copy/common.cpy \
                 | $(BIN_DIR)
	$(COBC) $(COBCFLAGS) -x $(SRC_DIR)/tui/menu.cob \
                             $(SRC_DIR)/storage/accounts-io.cob \
                             -o $@

run-hello: $(BIN_DIR)/hello-files
	./$(BIN_DIR)/hello-files

run-init: $(BIN_DIR)/files-init
	./$(BIN_DIR)/files-init

run-menu: $(BIN_DIR)/menu
	./$(BIN_DIR)/menu

clean:
	rm -f $(BIN_DIR)/*
