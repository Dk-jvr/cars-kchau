package DataBase

import (
	"database/sql"
	"fmt"
	"github.com/Dk-jvr/cars-kchau.git/Models"
	"github.com/google/uuid"
	_ "github.com/lib/pq"
	"sync"
)

var (
	db      *sql.DB
	dbMutex sync.Mutex
)

func InitDataBase() *sql.DB {
	var err error
	connectionString := "user=dbuser dbname=cars password=password host=localhost port=5434 sslmode=disable"
	db, err = sql.Open("postgres", connectionString)
	if err != nil {
		fmt.Printf("Connection to database error: %s", err.Error())
		return nil
	}
	err = CreateDataBase()
	if err != nil {
		fmt.Printf("Error due to %s", err.Error())
	}
	return db
}

func CreateDataBase() error {
	const createTables = `
			DROP TABLE IF EXISTS Users CASCADE ;
			DROP TABLE IF EXISTS UserData;
			DROP TABLE IF EXISTS UserCars;

			CREATE TABLE IF NOT EXISTS Users (
			    user_id UUID PRIMARY KEY,
			    username TEXT UNIQUE NOT NULL,
			    email TEXT UNIQUE NOT NULL,
			    password BYTEA NOT NULL
			);
			
			CREATE TABLE IF NOT EXISTS UserData (
			    user_id UUID PRIMARY KEY,
			    passport_series TEXT NOT NULL,
			    passport_number TEXT NOT NULL,
			    UNIQUE(passport_series, passport_number),
			    CONSTRAINT FK_user_id FOREIGN KEY(user_id)
			        REFERENCES Users(user_id) 
			);

			CREATE TABLE IF NOT EXISTS UserCars (
			  	user_id UUID,
			  	car_number TEXT,
			  	PRIMARY KEY(user_id, car_number),
			  	car_model TEXT NULL,
			  	car_series TEXT NOT NULL,
			  	CONSTRAINT FK_user_car FOREIGN KEY(user_id)
			        REFERENCES Users(user_id)
			);
		`
	_, err := db.Exec(createTables)
	return err
}

func CreateUser(user Models.User, errChan chan<- error) {
	const queryString = `INSERT INTO Users VALUES ($1, $2, $3, $4);`
	sha256Password := Models.HashPassword(user.Password)
	go func(user Models.User) {
		dbMutex.Lock()
		defer dbMutex.Unlock()
		_, err := db.Exec(queryString, uuid.New(), user.Username, user.Email, sha256Password)
		errChan <- err
	}(user)
}
