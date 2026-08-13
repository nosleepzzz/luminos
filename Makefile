# LuminOS helper build entrypoint
CFLAGS ?= -O2 -Wall -Wextra
BIN_DIR := iso/airootfs/usr/bin
SRCS := src/lumin-fetch.c src/lumin-mgr.c src/lumin-powerd.c \
	src/lumin-security.c src/lumin-game.c src/lumin-install.c
BINS := $(BIN_DIR)/lumin-fetch $(BIN_DIR)/lumin-mgr $(BIN_DIR)/lumin-powerd \
	$(BIN_DIR)/lumin-security $(BIN_DIR)/lumin-game $(BIN_DIR)/lumin-install

.PHONY: all clean

all: $(BINS) $(BIN_DIR)/lumin

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/lumin-%: src/lumin-%.c | $(BIN_DIR)
	gcc $(CFLAGS) $< -o $@

$(BIN_DIR)/lumin: $(BIN_DIR)/lumin-mgr
	ln -sfn lumin-mgr $@

clean:
	rm -f $(BINS) $(BIN_DIR)/lumin
