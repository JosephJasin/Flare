package main

import (
	"./repo"
	"net/http"
)

func main() {
	http.HandleFunc("/del", repo.DelPost)
	http.HandleFunc("/add", repo.AddPost)
	http.ListenAndServe(":6969", nil)
}
