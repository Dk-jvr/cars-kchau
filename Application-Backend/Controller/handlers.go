package Controller

import (
	"encoding/json"
	"github.com/Dk-jvr/cars-kchau.git/DataBase"
	"github.com/Dk-jvr/cars-kchau.git/Models"
	"github.com/gorilla/mux"
	"io"
	"net/http"
)

func Registration(writer http.ResponseWriter, request *http.Request) {
	var user Models.User
	var tokenStr string
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&user)

	writer.Header().Set("Content-Type", "application/json")
	if err != nil {
		Models.ErrAuthMaker(writer, http.StatusBadRequest, err.Error(), "")
		return
	}
	err = DataBase.CreateUser(user)
	if err != nil {
		Models.ErrAuthMaker(writer, http.StatusInternalServerError, err.Error(), "")
		return
	}
	tokenStr, err = Models.CreateToken(user.Username)
	if err != nil {
		Models.ErrAuthMaker(writer, http.StatusInternalServerError, err.Error(), "")
		return
	}
	Models.ErrAuthMaker(writer, http.StatusOK, "", tokenStr)
	return
}

func Authentication(writer http.ResponseWriter, request *http.Request) {
	var user Models.AuthUser
	var tokenStr string
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&user)
	if err != nil {
		Models.ErrAuthMaker(writer, http.StatusBadRequest, err.Error(), "")
		return
	}
	isContain, username := DataBase.CheckUser(user)
	if isContain {
		tokenStr, err = Models.CreateToken(username)
		if err != nil {
			Models.ErrAuthMaker(writer, http.StatusInternalServerError, err.Error(), "")
			return
		}
		Models.ErrAuthMaker(writer, http.StatusOK, "", tokenStr)
		return

	} else {
		Models.ErrAuthMaker(writer, http.StatusNotFound, "User Not Found...", "")
		return
	}
}

func Validation(writer http.ResponseWriter, request *http.Request) {
	body := make(map[string]string)
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&body)
	if err != nil {
		Models.ErrValidationMaker(writer, http.StatusInternalServerError, err.Error())
		return
	}
	err = Models.TokenValidation(body["jwt"])
	if err != nil {
		Models.ErrValidationMaker(writer, http.StatusBadRequest, err.Error())
		return
	}
	Models.ErrValidationMaker(writer, http.StatusOK, "")
	return
}

func UpdateImage(writer http.ResponseWriter, request *http.Request) {
	switch request.Method {

	case http.MethodPost:
		var oldImage string
		vars := mux.Vars(request)
		username := vars["username"]
		image, header, err := request.FormFile("image")
		if err != nil {
			http.Error(writer, err.Error(), http.StatusBadRequest)
			return
		}
		defer image.Close()

		err = Models.AddImage(image, header, writer)
		if err != nil {
			http.Error(writer, err.Error(), http.StatusInternalServerError)
			return
		}
		oldImage, err = DataBase.UpdateImage(username, header.Filename)
		if err != nil {
			http.Error(writer, err.Error(), http.StatusInternalServerError)
			return
		}

		if !Models.IsDefaultImage(oldImage) && oldImage != header.Filename {
			err = Models.DeleteImage(oldImage)
			if err != nil {
				http.Error(writer, err.Error(), http.StatusInternalServerError)
				return
			}
		}
		return

	case http.MethodGet:
		vars := mux.Vars(request)
		username := vars["username"]
		image, err := DataBase.GetImage(username)
		if err != nil {
			http.Error(writer, err.Error(), http.StatusInternalServerError)
			return
		}
		imageFile, err := Models.GetImage(image)
		io.Copy(writer, imageFile)
		return

	case http.MethodDelete:
		vars := mux.Vars(request)
		username := vars["username"]
		oldImage, err := DataBase.UpdateImage(username, Models.GetGefaultImage())
		if err != nil {
			http.Error(writer, err.Error(), http.StatusInternalServerError)
			return
		}
		if !Models.IsDefaultImage(oldImage) {
			err = Models.DeleteImage(oldImage)
			if err != nil {
				http.Error(writer, err.Error(), http.StatusInternalServerError)
				return
			}
		}
		return

	default:
		http.Error(writer, "Method Not Allowed", http.StatusMethodNotAllowed)
	}

}
