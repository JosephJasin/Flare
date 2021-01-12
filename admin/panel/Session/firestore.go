package Session

import (
	"context"
	firebase "firebase.google.com/go"
	"google.golang.org/api/option"
)

type Session struct {
	serviceAccount option.ClientOption
	cntxt          context.Context
}

type Admin struct {
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

func NewRepo() *Session {
	return &Session{
		option.WithCredentialsFile("./flare-service_account.json"),
		context.Background(),
	}
}

func (this *Session) AddAdmin(admin *Admin) (*Admin, error) {
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

	_, _, addErr := dbClient.Collection("admins").Add(this.cntxt, admin)
	if addErr != nil {
		panic(addErr)
		return nil, addErr
	}

	// and happily ever after :)
	return admin, nil
}

func (this *Session) DeleteAdmin(admin *Admin) (bool, error) {
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

	it := dbClient.Collection("admins").Where("Email", "==", admin.Email).Documents(this.cntxt)
	doc, _ := it.Next()
	dbClient.Collection("admins").Doc(doc.Ref.ID).Delete(this.cntxt)

	return true, nil
}

func (this *Session) CheckAdmin(admin *Admin) (bool, *Admin, error) {
	app, createErr := firebase.NewApp(this.cntxt, nil, this.serviceAccount)
	if createErr != nil {
		panic(createErr)
		return false, nil, createErr
	}

	dbClient, clientErr := app.Firestore(this.cntxt)
	if clientErr != nil {
		panic(clientErr)
		return false, nil, clientErr
	}
	defer dbClient.Close()

	query := dbClient.Collection("admins").Where("Email", "==", admin.Email).Documents(this.cntxt)
	doc, _ := query.Next()

	// update admin data from DB
	admin.Name = doc.Data()["Name"].(string)
	admin.Password = doc.Data()["Password"].(string)

	return doc != nil, admin, nil
}
