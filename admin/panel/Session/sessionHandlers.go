package Session

import (
	"../SessionHelper"
	"encoding/json"
	"io/ioutil"
	"net/http"
)

var repo = NewRepo()

// AdminSignIn bla bla bla
// {"Email": "example@domain.com", "Password": "raw stinky password"}
func AdminSignIn(w http.ResponseWriter, r *http.Request) {
	// request body init
	rawBody, err := ioutil.ReadAll(r.Body)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}
	var body map[string]string
	if parseErr := json.Unmarshal(rawBody, &body); parseErr != nil {
		panic(parseErr)
		return
	}

	admin := &Admin{
		Name:     "",
		Email:    body["email"],
		Password: body["password"],
	}

	adminExists, adminData, adminErr := repo.CheckAdmin(admin)
	if adminErr != nil || !adminExists {
		panic("something went wrong")
	}
	// compare password hashes
	var passwordMatch = SessionHelper.CompareHashPassword(body["password"], adminData.Password)

	// prepare response data
	respond := make(map[string]interface{}, 3)

	// if the password was not matched then nothing else did, and vice-versa
	if !passwordMatch {
		respond["success"] = 0
	} else {
		respond["success"] = 1
		respond["name"] = adminData.Name
	}

	// send the final response
	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(respond)
}

// add admin body has an additional two parameters ie email and password
// in order to sign in as an admin to add an admin
/*
{
	"email": "",
	"password": "",
	"newAdminName": "",
	"newAdminPassword": "",
	"newAdminEmail": ""
}
*/
func AddAdmin(w http.ResponseWriter, r *http.Request) {
	// request body init
	rawBody, err := ioutil.ReadAll(r.Body)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}
	var body map[string]string
	if parseErr := json.Unmarshal(rawBody, &body); parseErr != nil {
		panic(parseErr)
		return
	}

	admin := &Admin{
		Name:     body["newAdminName"],
		Email:    body["newAdminEmail"],
		Password: body["newAdminPassword"],
	}

	repo.AddAdmin(admin)

	w.Header().Set("Content-Type", "application/json")
}
