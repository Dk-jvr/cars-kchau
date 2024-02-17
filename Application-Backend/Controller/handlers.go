package Controller

import (
	"encoding/json"
	"fmt"
	"github.com/Dk-jvr/cars-kchau.git/DataBase"
	"github.com/Dk-jvr/cars-kchau.git/Models"
	"net/http"
)

func Registration(writer http.ResponseWriter, request *http.Request) {
	var user Models.User
	response := make(map[string]string)
	errChan := make(chan error)
	tokenChan := make(chan string)
	fmt.Println(request.Body)
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&user)

	writer.Header().Set("Content-Type", "application/json")
	if err != nil {
		writer.WriteHeader(http.StatusBadRequest)
		jsonResponse := Models.RegistrationResponse(response, "Error while receiving data...", err.Error(), "")
		writer.Write(jsonResponse)
		return

	}
	go DataBase.CreateUser(user, errChan)
	if err = <-errChan; err != nil {
		writer.WriteHeader(http.StatusInternalServerError)
		jsonResponse := Models.RegistrationResponse(response, "Error while receiving data...", err.Error(), "null")
		writer.Write(jsonResponse)
		return
	}
	go Models.CreateToken(user, errChan, tokenChan)
	if err = <-errChan; err != nil {
		writer.WriteHeader(http.StatusInternalServerError)
		jsonResponse := Models.RegistrationResponse(response, "Error while creation token...", err.Error(), "null")
		writer.Write(jsonResponse)
		return
	}
	writer.WriteHeader(http.StatusOK)
	jsonResponse := Models.RegistrationResponse(response, "Successful", "null", <-tokenChan)
	writer.Write(jsonResponse)
	return
}
