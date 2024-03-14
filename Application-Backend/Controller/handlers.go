package Controller

import (
	"encoding/json"
	"errors"
	"github.com/Dk-jvr/cars-kchau.git/DataBase"
	"github.com/Dk-jvr/cars-kchau.git/Models"
	"github.com/go-playground/validator"
	"github.com/gorilla/mux"
	"io"
	"net/http"
)

func Registration(writer http.ResponseWriter, request *http.Request) {
	var user Models.User
	var tokenStr string
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&user)
	validate := validator.New()
	defer func() {
		Models.ErrAuthMaker(writer, err)
	}()

	writer.Header().Set("Content-Type", "application/json")

	if err != nil {
		writer.WriteHeader(http.StatusBadRequest)
		return
	}
	err = validate.Struct(user)
	if err != nil {
		writer.WriteHeader(http.StatusBadRequest)
		return
	}

	err = DataBase.CreateUser(user)
	if err != nil {
		writer.WriteHeader(http.StatusConflict)
		return
	}
	tokenStr, err = Models.CreateToken(user.Username)
	if err != nil {
		writer.WriteHeader(http.StatusInternalServerError)
		return
	}
	Models.SetCookie(writer, tokenStr)
	return
}

func Authentication(writer http.ResponseWriter, request *http.Request) {
	var user Models.AuthUser
	var tokenStr string
	decoder := json.NewDecoder(request.Body)
	err := decoder.Decode(&user)

	defer func() {
		Models.ErrAuthMaker(writer, err)
	}()

	if err != nil {
		writer.WriteHeader(http.StatusBadRequest)
		return
	}

	isContain, username := DataBase.CheckUser(user)
	if isContain {
		tokenStr, err = Models.CreateToken(username)
		if err != nil {
			writer.WriteHeader(http.StatusInternalServerError)
			return
		}
		Models.SetCookie(writer, tokenStr)
		return

	} else {
		err = errors.New("user Not Found")
		writer.WriteHeader(http.StatusNotFound)
		return
	}
}

func Validation(writer http.ResponseWriter, request *http.Request) {
	body := make(map[string]string)

	//TODO:подумать про получение токена, будем ли отдельно дергать ручку или же отправлять все сразу, лишаясь
	//	моментальной валидации и перехода на страницу пользователя  (!!!)

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
	vars := mux.Vars(request)
	username := vars["username"]
	switch request.Method {

	case http.MethodPost:
		var oldImage string
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
		image, err := DataBase.GetImage(username)
		if err != nil {
			http.Error(writer, err.Error(), http.StatusInternalServerError)
			return
		}
		imageFile, err := Models.GetImage(image)
		io.Copy(writer, imageFile)
		return

	case http.MethodDelete:

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

/*func UserInfo(writer http.ResponseWriter, request *http.Request) {
	vars := mux.Vars(request)
	username := vars["username"]

	switch request.Method {
	case http.MethodPost:

	case http.MethodGet:

	default:
		http.Error(writer, "Method Not Allowed", http.StatusMethodNotAllowed)
	}

}*/
