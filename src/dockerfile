FROM golang:1.10 AS builder

WORKDIR $GOPATH/src/whatos 
COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /main .

FROM scratch
COPY --from=builder /main ./
EXPOSE 8081
ENTRYPOINT ["./main" ]
