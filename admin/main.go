package main

import (
	"./panel/Session"
	"./repo"
	"net/http"
)

func main() {
	http.HandleFunc("/posts/del", repo.DelPost)
	http.HandleFunc("/posts/add", repo.AddPost)
	http.HandleFunc("/admin/login", Session.AdminSignIn)
	http.ListenAndServe(":6969", nil)
}
