package main

import (
	"gitlab.com/jonny7/distrolog/internal/server"
	"log"
)

func main()  {
	srv := server.NewHTTPServer(":8080")
	log.Fatal(srv.ListenAndServe())
}
