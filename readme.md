GODOCKER-FLOW
=============

Repository contenente la descrizione/esempio del workflow necessario per realizzare un ambiente `Go` che possa appoggiarsi a container `docker`, per in futuro avere a disposizione script riutilizzabili e gia' immersi in immagini.

#### Cosa troviamo?

Anzitutto essendo a zero su `Go` ho per prima cosa fatto una prova, con descrizione in 

- [go-standalone](./note/go-standalone/go-standalone.md)

- [go-docker](./note/go-docker/readme.md)



REFS
====

- [https://flaviocopes.com/golang-docker/](https://flaviocopes.com/golang-docker/)


Esplicazione su come buildare un immagine molto leggera:

- [https://www.cloudreach.com/blog/containerize-this-golang-dockerfiles/](https://www.cloudreach.com/blog/containerize-this-golang-dockerfiles/), questo spiega molto bene tutto

- [https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/), per ottenere immagini small


GO Conventions (very important when go from scratch):

- [https://golang.org/doc/articles/go_command.html](https://golang.org/doc/articles/go_command.html), spiega bene come iniziare, ed e' molto corto


Examples:

- [https://github.com/golang/example](https://github.com/golang/example), go ufficiale, molto utile


- [https://github.com/blueimp/mailhog](https://github.com/blueimp/mailhog), esempio di flow completo (molto ben fatto)



# Per puro GO

- [https://gist.github.com/posener/73ffd326d88483df6b1cb66e8ed1e0bd](https://gist.github.com/posener/73ffd326d88483df6b1cb66e8ed1e0bd)


FLOW
====

Ho trovato vari esempi che illustrano come usare un package `Golang` e come creare immagini `Docker` che lo utilizzino, fino addirittura ottenere un immagine di dimensioni ridottissime, ma... per me che provo per la prima volta, non risultava chiara la modalita' di **SVILUPPO** di questa architettura, ovvero:

_se sto creando un package e lo sto sviluppando, dove vanno i miei files sorgenti? dove devo svolgere la build? quali path utilizzo?_

Altra cosa: 

non voglio utilizzare il path di default in `~/go/`, perche' in fase di sviluppo preferisco avere tutto decentralizzato,
cosi' da poter eventualmente piallare tutte le subdipendenze e riprovare da una versione cleaned.

Dopo alcune letture ho trovato il flow a me piu' congeniale:

1 - se exporto il `GOPATH` nella shell esplicitando una directory, allora posso tuilizzare quella directory `MyDir`come base, e go sapra' appunto che quella directory e' di riferimento per i comandi lanciati da quella shell.

2 - a questo punto in `MyDir` Go si aspetta di trovare la directory `src`, e la dentro mettero' tutti i miei `packages`, ciascuno suddiviso per directory.

3 - per scaricare le dipendenze dei pacchetti, mi basta entrare a questo punto nel folder di quel pacchetto (sara' da qualche parte dentro a `MyDir/src/...`) e da li lanciare `go get`, oppure uso `go get MyDir/src/...`, dove se non specifio `/` o `./`, allora prova a scricarli da internet. Con `go get ...`, GO si aspetta di trovare almeno un file `.go` in quel path.


Quindi la cosa forte di `GO` e' che posso usare sia path assoluti che relativi, ed e' proprio questo il trick che usero':

- se il package e' su github, il path di download da web e' `github.com/SimoSca/godocker-flow`

- con la sovrascrttura in locale del `GOPATH`, dando come base `./go`, allora sviluppo il tutto dentro al path `./go/src/github.com/SimoSca/godocker-flow`

In questo modo in locale avro' la versione su cui sto lavorando, tutto nella directory di questo repo. 


**NOTA**

- per risolvere e scaricare dipendenze, sempre utilizzare `go get ...`

- per buildare semplicemente `go build ...` , ma gli devo specificare dove deve mettere il file compilato, ovvero l'output (di default nella `pwd`)

- per avere invece il binario a disposizione uso `go install`, che tra le altre provvede anche a generarlo nella `$GOPATH/bin`, e come nome usa il nome del folder in cui vive.


#### Altri dettagli

- in ogni directory deve esserci al + un package, quindi non si possono avere piu file `go` con la dicitura `package`;

- il package `main` viene compilato e messo nella `$GOPATH/bin`, invece gli altri packages vengono inseriti come dipendenze non eseguibili, in `$GOPATH/pkg/<architettura>/github.com/SimoSca/godocker-flow.a`
