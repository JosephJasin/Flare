package repo

import (
	"context"
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
	CreationDate int64  `json:"creation_date"`
	Facebook     string `json:"facebook"`
	ID           int    `json:"id"`
	Image        string `json:"image"`
	IsRequest    bool   `json:"is_request"`
	Name         string `json:"name"`
	UID          string `json:"uid"`
	Whatsapp     string `json:"whatsapp"`
}

func NewRepo() *Repo {
	return &Repo{
		option.WithCredentialsFile("./flare-7c623.json"),
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
	_, _, addErr := dbClient.Collection("posts").Add(this.cntxt, p)
	if addErr != nil {
		panic(addErr)
		return nil, addErr
	}

	p.CreationDate = time.Now().UnixNano()
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
