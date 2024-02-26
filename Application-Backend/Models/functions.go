package Models

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"github.com/golang-jwt/jwt/v5"
	"net/http"
	"time"
)

var (
	secretKey *ecdsa.PrivateKey
)

func init() {
	secretKey, _ = ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
}

func HashPassword(password string) string {
	hash := sha256.New()
	hash.Write([]byte(password))
	return hex.EncodeToString(hash.Sum(nil))
}

func CreateToken(username string) (string, error) {
	claims := jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(1 * time.Hour)),
		IssuedAt:  jwt.NewNumericDate(time.Now()),
		Subject:   username,
	}
	token := jwt.NewWithClaims(jwt.SigningMethodES256, claims)
	tokenStr, err := token.SignedString(secretKey)
	return tokenStr, err
}

func ErrAuthMaker(writer http.ResponseWriter, httpStatus int, err string, tokenStr string) {
	response := make(map[string]string)
	response["jwt"] = tokenStr
	response["Error"] = err
	jsonResponse, _ := json.Marshal(response)
	writer.WriteHeader(httpStatus)
	writer.Write(jsonResponse)
}

func ErrValidationMaker(writer http.ResponseWriter, httpStatus int, err string) {
	response := make(map[string]string)
	response["Error"] = err
	jsonResponse, _ := json.Marshal(response)
	writer.WriteHeader(httpStatus)
	writer.Write(jsonResponse)
}

func TokenValidation(tokenStr string) error {
	token, err := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
		return &secretKey.PublicKey, nil
	})
	if err != nil {
		return err
	}
	claims, ok := token.Claims.(jwt.MapClaims)
	if ok && token.Valid && time.Now().Unix() < int64(claims["exp"].(float64)) {
		return nil
	} else {
		return errors.New("Invalid Token Error")
	}
}
