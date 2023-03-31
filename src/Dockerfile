FROM golang:1.19.7-bullseye AS builder
WORKDIR /go/src/app
COPY . .

RUN go mod vendor
RUN CGO_ENABLED=0 GOOS=linux go build -v -o main

FROM scratch
ENV PORT 8081
EXPOSE 8081

WORKDIR /app
COPY --from=busybox:1.36.0 /bin/busybox /bin/busybox
COPY --from=builder /go/src/app/main /main
ENTRYPOINT ["/main" ]