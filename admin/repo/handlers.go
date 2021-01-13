package repo

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
)

var repo = NewRepo()

/* AddPost adds a post with the given data
{
	"adminEmail": "",
	"adminPassword": "", // admin data so no one can fuck with the data except an admin
    "course": "some course",
    "facebook": "facebook.com/someone",
    "id": 16,
    "image": "https://camo.githubusercontent.com/98ed65187a84ecf897273d9fa18118ce45845057/68747470733a2f2f7261772e6769746875622e636f6d2f676f6c616e672d73616d706c65732f676f706865722d766563746f722f6d61737465722f676f706865722e706e67",
    "isRequest": false,
    "name": "Baraa",
    "uid": "cvhjwekuw",
    "whatsapp": "079999999"
}
*/
func AddPost(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var post Post

	err := json.NewDecoder(r.Body).Decode(&post)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"error": "Error getting data from DB"}`))
	}

	repo.AddPost(&post)
	w.WriteHeader(http.StatusOK)
	// for testing
	json.NewEncoder(w).Encode(post)
}

// DelPost deletes a post with the given post uid and course name
/*
{
	"adminEmail": "",
	"adminPassword": "", // admin data so no one can fuck with the data except an admin
	"course": "someCourse",
	"uid": "someUID"
}
*/
func DelPost(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var post Post

	rawBody, parseErr0 := ioutil.ReadAll(r.Body)
	if parseErr0 != nil {
		http.Error(w, parseErr0.Error(), http.StatusBadRequest)
	}

	body := make(map[string]string)
	if parseErr1 := json.Unmarshal(rawBody, &body); parseErr1 != nil {
		http.Error(w, parseErr1.Error(), http.StatusInternalServerError)
	}

	repo.DelPost(body["uid"], body["course"])
	w.WriteHeader(http.StatusOK)
	// for testing
	json.NewEncoder(w).Encode(post)
}

func (this *Post) DeleteOldPosts() {

}
