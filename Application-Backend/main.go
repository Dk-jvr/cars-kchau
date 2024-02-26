package main

import (
	"github.com/Dk-jvr/cars-kchau.git/Controller"
	"github.com/Dk-jvr/cars-kchau.git/DataBase"
	_ "github.com/lib/pq"
	"log"
	"net/http"
)

func main() {

	database := DataBase.InitDataBase()
	defer database.Close()

	http.HandleFunc("/cars/registration", Controller.Registration)
	http.HandleFunc("/cars/authentication", Controller.Authentication)
	http.HandleFunc("/cars/validation", Controller.Validation)
	http.HandleFunc("/cars/image", Controller.ImageController)

	log.Fatal(http.ListenAndServe(":8080", nil))
}
