package main

import (
	"fmt"
	"github.com/Dk-jvr/cars-kchau.git/Controller"
	"github.com/Dk-jvr/cars-kchau.git/DataBase"
	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
	"log"
	"net/http"
)

func main() {
	router := mux.NewRouter()
	database := DataBase.InitDataBase()
	defer database.Close()

	router.HandleFunc("/cars/registration", Controller.Registration)
	router.HandleFunc("/cars/authentication", Controller.Authentication)
	router.HandleFunc("/cars/validation", Controller.Validation)
	router.HandleFunc("/cars/image/{username}", Controller.UpdateImage)
	fmt.Println("Listening server in 8080 port...")
	log.Fatal(http.ListenAndServe(":8080", router))
}
