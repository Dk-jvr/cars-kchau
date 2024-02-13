package DataBase

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
)

var (
	db *sql.DB
)

func InitDataBase() *sql.DB {
	var err error
	connectionString := "user=dbuser dbname=cars password=password host=localhost port=5433 sslmode=disable"
	db, err = sql.Open("postgres", connectionString)
	if err != nil {
		fmt.Printf("Connection to database error: %s", err.Error())
		return nil
	}
	return db
}
