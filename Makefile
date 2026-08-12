.PHONY: all build clean install test

BINARY_NAME=vim9-lsp-setup
BIN_DIR=bin
CMD_DIR=cmd/vim9-lsp-setup

all: build

build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BIN_DIR)
	go build -o $(BIN_DIR)/$(BINARY_NAME) ./$(CMD_DIR)
	@echo "✓ Build complete: $(BIN_DIR)/$(BINARY_NAME)"

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(BIN_DIR)
	@echo "✓ Clean complete"

install: build
	@echo "Installing vim9-lsp-server..."
	@$(BIN_DIR)/$(BINARY_NAME) $(HOME)/.vim/pack/vpm/start
	@echo "✓ Installation complete"

test:
	@echo "Running tests..."
	go test -v ./...
	@echo "✓ Tests complete"

help:
	@echo "Vim9 LSP Client - Makefile targets:"
	@echo "  make build    - Build the setup tool"
	@echo "  make clean    - Remove build artifacts"
	@echo "  make install  - Build and install vim9-lsp-server"
	@echo "  make test     - Run tests"
	@echo "  make help     - Show this help message"
