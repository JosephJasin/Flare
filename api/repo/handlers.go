package repo

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
)

var repo = NewRepo()

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
// {"course": "someCourse", "uid": "someUID"}
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
