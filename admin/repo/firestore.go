package repo

import (
	"context"
	"encoding/json"
	firebase "firebase.google.com/go"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"
	"time"
)

type Repo struct {
	serviceAccount option.ClientOption
	cntxt          context.Context
}

type Post struct {
	Course       string `json:"course"`
	CreationDate int64  `json:"timestamp"`
	Facebook     string `json:"facebook"`
	ID           int    `json:"id"`
	Image        string `json:"image"`
	IsRequest    bool   `json:"isRequest"`
	Name         string `json:"name"`
	UID          string `json:"uid"`
	Whatsapp     string `json:"whatsapp"`
}

func NewRepo() *Repo {
	return &Repo{
		option.WithCredentialsFile("./flare-service_account.json"),
		context.Background(),
	}
}

func (this *Repo) AddPost(p *Post) (*Post, error) {
	app, createErr := firebase.NewApp(this.cntxt, nil, this.serviceAccount)
	if createErr != nil {
		panic(createErr)
		return nil, createErr
	}

	dbClient, clientErr := app.Firestore(this.cntxt)
	if clientErr != nil {
		panic(clientErr)
		return nil, clientErr
	}

	defer dbClient.Close()

	p.CreationDate = time.Now().Unix()

	jPost, _ := json.Marshal(p)
	var mPost map[string]interface{}
	json.Unmarshal(jPost, &mPost)

	_, _, addErr := dbClient.Collection("posts").Add(this.cntxt, mPost)
	if addErr != nil {
		panic(addErr)
		return nil, addErr
	}

	// and happily ever after :)
	return p, nil
}

func (this *Repo) DelPost(uid, courseName string) (bool, error) {
	app, createErr := firebase.NewApp(this.cntxt, nil, this.serviceAccount)
	if createErr != nil {
		panic(createErr)
		return false, createErr
	}

	dbClient, clientErr := app.Firestore(this.cntxt)
	if clientErr != nil {
		panic(clientErr)
		return false, clientErr
	}
	defer dbClient.Close()

	it := dbClient.Collection("posts").Where("uid", "==", uid).Documents(this.cntxt)
	for {
		doc, itErr := it.Next()
		if itErr == iterator.Done {
			it.Stop() // memory leak issues
			break
		}
		if itErr != nil {
			panic(itErr.Error())
			return false, itErr
		}

		if doc.Data()["course"] == courseName {
			dbClient.Collection("posts").Doc(doc.Ref.ID).Delete(this.cntxt)
		}
	}

	return true, nil
}

func (this *Repo) DelOldPosts() error {
	app, createErr := firebase.NewApp(this.cntxt, nil, this.serviceAccount)
	if createErr != nil {
		panic(createErr)
		return createErr
	}

	dbClient, clientErr := app.Firestore(this.cntxt)
	if clientErr != nil {
		panic(clientErr)
		return clientErr
	}
	defer dbClient.Close()

	// posts that are a week old
	it := dbClient.Collection(
		"posts").Where("timestamp", "<=", time.Now().Unix()-604800).Documents(this.cntxt)
	for {
		doc, itErr := it.Next()
		if itErr == iterator.Done {
			it.Stop() // memory leak issues
			break
		}
		if itErr != nil {
			panic(itErr.Error())
			return itErr
		}

		dbClient.Collection("posts").Doc(doc.Ref.ID).Delete(this.cntxt)
	}

	return nil
}
