FROM golang:1.18 AS builder
RUN mkdir -p /app
RUN GOCACHE=OFF
COPY . /app

RUN cd /app && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/bin/hello-server main.go

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root
COPY --from=builder /go/bin/hello-server .

ENTRYPOINT ["/root/hello-server"]
EXPOSE 8080