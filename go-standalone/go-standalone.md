GO
==

Prima di eseguire `go` tramite il container, preferisco svolgere alcune prove.

Ad esempio per eseguire lo script `findlinks.go` devo dare il comando

````bash
go run findlinks.go
````

ma durante l'esecuzione ho trovato l'errore

````
findlinks.go:8:2: cannot find package "golang.org/x/net/html" in any of:
        /usr/local/go/src/golang.org/x/net/html (from $GOROOT)
        /Users/simonescardoni/go/src/golang.org/x/net/html (from $GOPATH)
````

che e' un errore di dipendenze. A questo punto ho provato con 

````bash
# da dove ho findlinks.go
go get .
````

ma stavolta trovo un errore perche' `go` mi da dei problemi con `GOPATH`. Googlerando trovato questo:

> The error message is telling you that it cannot do that, because the current directory isn't part of your $GOPATH

quindi per questo progetto provo 

````bash
export GOPATH=$(pwd)
````

e rilanciando `go get .` vedo che qui dentro (`./`) ha creato la directory `src`, con installate le dipendenze mancanti (`golang/x/net`). 
Nonostante mi abbia dato nuovamente errore, se eseguo `go run findlinks.go`, stavolta funzia!


La cosa importante da imparare ora come ora e' che se rimuovo la `src` appena creata, magicamente go continua a funzionare... 
questo perche' in ogni caso le stesse dipendenze le trovo in `~/go/src`, 
che eventualmente risulta essere il path di default in cui `Go` va a cercare.


REFS
====

- [https://flaviocopes.com/golang-docker/](https://flaviocopes.com/golang-docker/), da dove ho trovato `findlinks.go`