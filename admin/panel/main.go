package main

import (
	API "./api"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	api := API.NewApi()
	api.Start()
}
