GODOCKER
========

Con l'immagine ufficiale di `GO` e' possibile lanciare alcuni comandi molto utili per lo sviluppo, ad esempio:

````bash
docker run golang go get -v github.com/flaviocopes/findlinks
````
In questo caso scarica il repository da github, e in automatico fa un parser, trovando che deve essere scaricata la dipendenza non standard `golang.org/x/net/html` (presente nell'import di `findlinks.go`).

Ora con `docker ps -l` vedo che e' presente un container in status `Exited`, che e' proprio quello che ha eseguito il comando precedente, e immagino che quanto scaricato risieda proprio in quel container.

Poiche' il container e' in status `Exited`, per ispezionarlo devo usare un trick trovato [qui](https://medium.com/@pimterry/5-ways-to-debug-an-exploding-docker-container-4f729e2c0aa8), ovvero salvarlo in un immagine, e poi eseguire quell'immagine! Es:

````bash
docker commit <container name_or_id> my-broken-container && docker run -ti my-broken-container /bin/bash
````

Dopo di quel comando mi ritrovo nel path `/go`, e con `ls` trovo che e' effettivamente il `GOPATH`, in quanto al suo interno sono presenti la `bin` e la `src`, in particolare la situazione che vedo e':

````
go\
   |- bin\
          | - findlinks
   |- src\
          | - github.com/ (con flaviocopes/findlinks/, ovvero il repository)
          | - golang.org/ (con x/net/html, ovvero quanto scaricato)

````
Dopo averlo ispezionato dunque vedo che in `/go` risiedono i sorgenti Go del progetto, inoltre con `echo $GOPATH` scopro che quella e' effettivamente la cartella impostata per essere il path di Go.

A questo punto se lo reputo utile, posso anche pensare di salvare l'immagine chiamandola `findlinks` per comodita':

````bash
docker commit "$(docker ps -lq)[o nome del container]" findlinks
````

e quindi la si puo' eseguire ad esempio con `docker run -p 8000:8000 findlinks findlinks`, dove il primo findlinks e' il nome dell'immagine, mentre il secondo e' il comando che gli voglio passare, in questo caso lo stesso `findlinks`.


PROBLEMA: IMMAGINE GIGANTE!
---------------------------

L'immagine pesa circa `800 MB`, cosa non buona, calcolando che sto usando un semplice eseguibile... per ovviare a questo si puo' usare il `docker multistage`.

Curiosita':

> Why is the image this big? Because what happens is that the Go app is compiled inside the container. So the image needs to have a Go compiler installed. And everything needed by the compiler of course, GCC, and a whole Linux distribution (Debian Jessie). It downloads Go and installs it, compiles the app and runs it.

Due utili riferimenti per snellire di molto le immagini:

- [https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/)

- [https://github.com/blueimp/mailhog](https://github.com/blueimp/mailhog), questo e' fatto benissimo a mio avviso

Esempio di multi-stage build:

````
FROM golang:1.8.3 as builder
WORKDIR /go/src/github.com/flaviocopes/findlinks
RUN go get -d -v golang.org/x/net/html
COPY findlinks.go  .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o findlinks .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/flaviocopes/findlinks/findlinks .
CMD ["./findlinks"]
````

