FROM golang
ENV PORT 8081
EXPOSE 8081

WORKDIR /go/src/app
COPY . .

RUN go mod vendor
RUN go build -v -o app
RUN mv ./app /go/bin/

CMD ["app"]