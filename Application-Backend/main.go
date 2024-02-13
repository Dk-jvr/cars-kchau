package main

import (
	"github.com/Dk-jvr/cars-kchau.git/DataBase"
	_ "github.com/lib/pq"
	"log"
	"net/http"
)

func main() {

	database := DataBase.InitDataBase()
	defer database.Close()

	log.Fatal(http.ListenAndServe(":8080", nil))
}
