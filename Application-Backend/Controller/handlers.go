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
	fmt.Println(request.Body)
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&user)

	writer.Header().Set("Content-Type", "application/json")
	if err != nil {
		writer.WriteHeader(http.StatusBadRequest)
		response["Message"] = "Error while receiving data..."
		response["Error"] = err.Error()
		jsonResponse, _ := json.Marshal(response)
		writer.Write(jsonResponse)
		return

	}
	go DataBase.CreateUser(user, errChan)
	if err = <-errChan; err != nil {
		writer.WriteHeader(http.StatusBadRequest)
		response["Message"] = "Error while receiving data..."
		response["Error"] = err.Error()
		jsonResponse, _ := json.Marshal(response)
		writer.Write(jsonResponse)
		return
	}
	writer.WriteHeader(http.StatusOK)
	response["Message"] = "Successful"
	response["Error"] = ""
	jsonResponse, _ := json.Marshal(response)
	writer.Write(jsonResponse)
	return
}
