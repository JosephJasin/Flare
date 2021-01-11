package main

import (
	"./repo"
	"net/http"
)

func main() {
	http.HandleFunc("/add", repo.AddPost)
	http.ListenAndServe(":6969", nil)
}
