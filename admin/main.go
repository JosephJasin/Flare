package main

import (
	"./panel/Session"
	"./repo"
	"github.com/gorilla/mux"
	"log"
	"net/http"
)

func main() {
	s := repo.NewRepo()
	s.DelOldPosts()
	//start()
}

func start() {
	router := mux.NewRouter()

	//router.HandleFunc("/posts/del", repo.DelPost).Methods(http.MethodGet)
	//router.HandleFunc("/posts/add", repo.AddPost).Methods(http.MethodPost)
	router.HandleFunc("/admin/login", Session.AdminSignIn).Methods(http.MethodPost)
	router.HandleFunc("/admin/add", Session.AddAdmin)

	log.Fatal(
		http.ListenAndServe(":6969", router))
}
