.PHONY: build clean

# Application paths
	BUILDPATH=$(CURDIR)
	APP_SERVICES=.

# Go parameters
	GO=CGO_ENABLED=1 GO111MODULE=on go
	GIT_SHA=$(shell git rev-parse HEAD)

	GOBUILD=$(GO) build
	GOINSTALL=$(GO) install
	GOCLEAN=$(GO) clean
	GOENV=go env

	MAIN=main.go
	EXENAME=go-docker
	##@if [ ! -d $(BUILDPATH)/pkg ] ; then mkdir -p $(BUILDPATH)/pkg ; fi

.PHONY: build $(APP_SERVICES)

build: $(APP_SERVICES)

$(APP_SERVICES):
	$(GOBUILD)

hello:
	@echo "Hello, I am a makefile in the $(BUILDPATH) directory" 

goenv:
	@echo "GoLang environment variables:"
	$(GOENV)
	@echo "go flags:"
	$(GOFLAGS)

clean:
	@echo "cleaning"
	@rm -f $(BUILDPATH)/main

run: 
	$(GO) run $(MAIN) 
docker:
	docker build \
	    --build-arg http_proxy \
	    --build-arg https_proxy \
			-f ./Dockerfile \
			--label "git_sha=$(GIT_SHA)" \
			-t mmekaiel/go-docker:1.0.1 \
			.

all: hello build