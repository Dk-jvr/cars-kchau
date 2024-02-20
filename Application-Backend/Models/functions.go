package Models

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
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

func ErrMaker(writer http.ResponseWriter, httpStatus int, err string, tokenStr string) {
	response := make(map[string]string)
	response["jwt"] = tokenStr
	response["Error"] = err
	jsonResponse, _ := json.Marshal(response)
	writer.WriteHeader(httpStatus)
	writer.Write(jsonResponse)
}

func CheckUser(user AuthUser, errChan <-chan error, tokenChan <-chan string) {

}
