VERSION=1.0.0

# Mi serve per fare in modo che GO usi la directory ./go/ come directory di riferimento
export GOPATH=$(shell pwd)/go

# all: fmt combined

# se voglio costruire un singolo pacchetto

# example os single
single:
	# ottengo le dipendenze di quel pacchetto, o se fosse da internet lo downloaderei
	go get ./go/src/enomis1
	# genero il binary, che finira' in ./go/bin/ e non nel folder stesso del package
	go build ./go/src/enomis1 

build:
	@go install ./go/src/github.com/SimoSca/godocker-flow/
	@./go/bin/godocker-flow


# build_all:
# 	go get -d ./go/src
# go build 

# combined:
# @echo $(GOPATH)
# @ go get && go build
# @cd go/src/enomis1 && go get && go build
# @cd go/build/enomis2 && go get && go build

# release: tag release-deps 
# 	gox -ldflags "-X main.version=${VERSION}" -output="build/{{.Dir}}_{{.OS}}_{{.Arch}}" .

# fmt:
# 	go fmt ./...

# release-deps:
# 	go get github.com/mitchellh/gox

# pull:
# 	git pull
# 	cd ../data; git pull
# 	cd ../http; git pull
# 	cd ../MailHog-Server; git pull
# 	cd ../MailHog-UI; git pull
# 	cd ../smtp; git pull
# 	cd ../storage; git pull

# tag:
# 	git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
# 	cd ../data; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
# 	cd ../http; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
# 	cd ../MailHog-Server; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
# 	cd ../MailHog-UI; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
# 	cd ../smtp; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
# 	cd ../storage; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}


# .PNONY: all combined release fmt release-deps pull tag
.PHONY: build