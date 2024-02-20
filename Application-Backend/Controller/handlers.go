package Controller

import (
	"encoding/json"
	"github.com/Dk-jvr/cars-kchau.git/DataBase"
	"github.com/Dk-jvr/cars-kchau.git/Models"
	"net/http"
)

func Registration(writer http.ResponseWriter, request *http.Request) {
	var user Models.User
	var tokenStr string
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&user)

	writer.Header().Set("Content-Type", "application/json")
	if err != nil {
		Models.ErrMaker(writer, http.StatusBadRequest, err.Error(), "")
		return
	}
	err = DataBase.CreateUser(user)
	if err != nil {
		Models.ErrMaker(writer, http.StatusInternalServerError, err.Error(), "")
		return
	}
	tokenStr, err = Models.CreateToken(user.Username)
	if err != nil {
		Models.ErrMaker(writer, http.StatusInternalServerError, err.Error(), "")
		return
	}
	Models.ErrMaker(writer, http.StatusOK, "", tokenStr)
	return
}

func Authentication(writer http.ResponseWriter, request *http.Request) {
	var user Models.AuthUser
	var tokenStr string
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&user)
	if err != nil {
		Models.ErrMaker(writer, http.StatusBadRequest, err.Error(), "")
		return
	}
	isContain, username := DataBase.CheckUser(user)
	if isContain {
		tokenStr, err = Models.CreateToken(username)
		if err != nil {
			Models.ErrMaker(writer, http.StatusInternalServerError, err.Error(), "")
			return
		}
		Models.ErrMaker(writer, http.StatusOK, "", tokenStr)
		return

	} else {
		Models.ErrMaker(writer, http.StatusNotFound, "User Not Found...", "")
		return
	}
}
