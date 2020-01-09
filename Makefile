# Application paths
	BUILDPATH=$(CURDIR)

# Go parameters
	GO=CGO_ENABLED=1 GO111MODULE=on go
	GIT_SHA=$(shell git rev-parse HEAD)

	GOBUILD=$(GO) build
	GOINSTALL=$(GO) install
	GOCLEAN=$(GO) clean
	GOENV=go env

	MAIN=main.go
	EXENAME=go-docker

build: 
	@echo "building"
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
	@echo "running"
	$(GO) run $(MAIN) 
	
docker:
	docker build --network=host \
		-f ./Dockerfile \
		-t mmekaiel/go-docker:1.0.1 \
		.

all: hello build