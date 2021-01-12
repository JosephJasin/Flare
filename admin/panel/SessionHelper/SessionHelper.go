package SessionHelper

import (
	"golang.org/x/crypto/bcrypt"
	"math/rand"
	"time"
)

func GetRandomToken(tokenLength int) string {
	token := ""
	for i := 0; i < tokenLength; i++ {
		r := rand.New(rand.NewSource(time.Now().UnixNano()))
		token += string(rune(r.Intn(126-33) + 33)) // ascii range w/ no escape sequences
	}

	return token
}

func HashPassword(password string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.MinCost)
	if err != nil {
		panic(err)
		return "", err
	}

	return string(hash), nil
}

func CompareHashPassword(password, hash string) bool {
	return nil == bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
}
