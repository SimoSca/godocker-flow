FROM golang

COPY ./go/src/github.com/SimoSca/godocker-flow /go/src/github.com/SimoSca/godocker-flow
WORKDIR /go/src/github.com/SimoSca/godocker-flow

RUN go get && go install







# FROM golang:alpine as build
# WORKDIR /go/src/github.com/mailhog/MailHog
# COPY . .
# # Install MailHog as statically compiled binary:
# # ldflags explanation (see `go tool link`):
# #   -s  disable symbol table
# #   -w  disable DWARF generation
# RUN CGO_ENABLED=0 go install -ldflags='-s -w'

# FROM scratch
# # ca-certificates are required for the "release message" feature:
# COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# COPY --from=build /go/bin/MailHog /bin/
# # User ID 1000 is a workaround for boot2docker issue #581, see
# # https://github.com/boot2docker/boot2docker/issues/581
# USER 1000
# # ENTRYPOINT ["MailHog"]
# # Expose the SMTP and HTTP ports used by default by MailHog:
# # EXPOSE 1025 8025


# # FROM golang:alpine as builder
# # RUN mkdir /build 
# # ADD . /build/
# # WORKDIR /build
# # use some compile-time parameters in the build stage to instruct the go compiler to statically link the runtime libraries into the binary itself:
# # RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .
# # FROM scratch
# # COPY --from=builder /build/main /app/
# # WORKDIR /app
# # CMD ["./main"]