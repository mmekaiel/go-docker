#
# Copyright (c) 2019 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM golang:1.12-alpine AS builder

# add git for go modules
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

# add git for go modules
RUN apk update && apk add --no-cache make git gcc 

WORKDIR /temp
COPY go.mod .

RUN go mod download

# COPY Dockerfile .
COPY ./res ./res
COPY main.go .
COPY Makefile .

RUN make build

# Next image - Copy built Go binary into new workspace
FROM alpine

# Copy statically linked binary
COPY --from=builder /temp/res /res
COPY --from=builder /temp/go-docker /go-docker

# Notice "CMD", we don't use "Entrypoint" because there is no OS
CMD [ "/go-docker" ,"--registry","--confdir=/res"]