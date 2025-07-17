SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

LOCALBIN := $(shell pwd)/bin
BUF := $(LOCALBIN)/buf

.PHONY: all
all: proto

# The help target prints out all targets with their descriptions.
# The target descriptions by '##'. The awk command is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help.
# More info on the usage of ANSI control characters for terminal formatting:
# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# More info on the awk command:
# http://linuxcommand.org/lc3_adv_awk.php
.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:*.*?##/ { printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Lint

.PHONY: fmt
fmt: buf.format go.fmt ## Format all protobuf and golang files.

.PHONY: lint
lint: lint.golang lint.buf ## Run all lint checks.

.PHONY: lint.golang
lint.golang: ## Run golang lint checks.
	@if [ ! -z $$(gofmt -l ./) ]; then  \
		echo "golang files not formatted. run make fmt to fix" ;\
		exit 1 ;\
	fi

.PHONY: lint.buf
lint.buf: $(BUF) ## Run buf lint checks.
	@trap "echo 'protobuf files not formatted. run make fmt'" ERR && \
		$(BUF) format --exit-code > /dev/null
	@$(BUF) lint

.PHONY: license-check
license-check: ## Check that source code files have the correct license header.
	@trap "echo 'Please run 'make gen-license-headers' and commit updates.'" ERR && \
		$(LICENSE_CHECK)

.PHONY: gen-license-headers
gen-license-headers: ## Generate license headers for source code files.
	@$(LICENSE_CHECK) --write

##@ Buf

.PHONY: buf.dep-update
buf.dep-update: $(BUF) ## Update buf.mod and buf.lock file.
	$(BUF) dep update

.PHONY: buf.format
buf.format: $(BUF) ## Format all protobuf files.
	$(BUF) format --write

##@ Golang

.PHONY: go.fmt
go.fmt: ## Format all golang files.
	gofmt -l -w ./

$(BUF): go.mod go.sum
	go build -o $(BUF) github.com/bufbuild/buf/cmd/buf

LICENSE_CHECK ?= tools/license_check/license_check.py
