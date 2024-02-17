package Models

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"github.com/golang-jwt/jwt/v5"
	"time"
)

var (
	secretKey *ecdsa.PrivateKey
)

func init() {
	secretKey, _ = ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
}

func RegistrationResponse(data map[string]string, message string, err string, tokenStr string) []byte {
	data["Message"] = message
	data["jwt"] = tokenStr
	data["Error"] = err
	jsonResponse, _ := json.Marshal(data)
	return jsonResponse
}

func HashPassword(password string) string {
	hash := sha256.New()
	hash.Write([]byte(password))
	return hex.EncodeToString(hash.Sum(nil))
}

func CreateToken(user User, errChan chan<- error, tokenChan chan<- string) {
	claims := jwt.RegisteredClaims{
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(1 * time.Hour)),
		IssuedAt:  jwt.NewNumericDate(time.Now()),
		Subject:   user.Username,
	}
	token := jwt.NewWithClaims(jwt.SigningMethodES256, claims)
	tokenStr, err := token.SignedString(secretKey)
	errChan <- err
	tokenChan <- tokenStr
	close(errChan)
	close(tokenChan)
}
