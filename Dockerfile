# sudo docker build -t go-docker:1.0 .
    # sudo docker images
# Run docker image in interactive mode - will die when ctrl+c
    # sudo docker run --name go-docker -it -p 8080:8081 go-docker h
# Run docker image in detached mode - will constantly run
    # sudo docker run --name go-docker -d -p 8080:8081 go-docker
# Push a new tag to docker repository
    # sudo docker push mmekaiel/go-docker:1.0.1



# FROM golang:1.12.0-alpine3.9

# # Make an app directory
# RUN mkdir /app

# # Add all our project conents to the created app directory
# ADD . /app

# # Set the created app directory as our working directory
# WORKDIR /app

# RUN make build

# CMD [ "/app/go-docker" ,"--registry","--confdir=/res"]





# FROM golang:1.12.0-alpine3.9

# # set the working directory
# WORKDIR $GOPATH/src/github.com/hello

# COPY . .

# RUN make build

# FROM scratch

# ENV APP_PORT=49990
# EXPOSE $APP_PORT

# COPY --from=builder /github.com/hello/res /res
# COPY --from=builder /github.com/hello /.

# ENTRYPOINT ["/main","--registry","--confdir=/res"]






#FROM golang:1.12.0-alpine3.9 AS builder
FROM golang:1.12-alpine AS builder

# add git for go modules
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

# add git for go modules
RUN apk update && apk add --no-cache make git gcc 

WORKDIR /temp
COPY go.mod .

RUN go mod download

COPY . .

RUN make build

# Next image - Copy built Go binary into new workspace
FROM alpine

#RUN apk --no-cache 

COPY --from=builder /temp/res /res
COPY --from=builder /temp/go-docker /go-docker

CMD [ "/go-docker" ,"--registry","--confdir=/res"]
