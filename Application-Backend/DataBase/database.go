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
			DROP TABLE IF EXISTS UserPhoto;

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

			CREATE TABLE IF NOT EXISTS UserPhoto (
				user_id UUID PRIMARY KEY,
				image_name TEXT NOT NULL DEFAULT 'QuOuK_wC9c8.jpg',
				CONSTRAINT FK_user_photo FOREIGN KEY(user_id)
			        REFERENCES Users(user_id)
			);
		`
	_, err := db.Exec(createTables)
	return err
}

func CreateUser(user Models.User) error {
	var err error
	const queryInsertNewUser = `INSERT INTO Users VALUES ($1, $2, $3, $4);`
	const queryInsertUserPhoto = `INSERT INTO UserPhoto VALUES($1);`

	sha256Password := Models.HashPassword(user.Password)
	user_id := uuid.New()
	dbMutex.Lock()
	defer dbMutex.Unlock()
	_, err = db.Exec(queryInsertNewUser, user_id, user.Username, user.Email, sha256Password)
	if err != nil {
		return err
	}
	_, err = db.Exec(queryInsertUserPhoto, user_id)
	return err
}

func CheckUser(user Models.AuthUser) (bool, string) {
	var username string
	sha256Password := Models.HashPassword(user.Password)
	result, _ := db.Exec(`SELECT username FROM Users
									WHERE email = $1 AND password = $2`, user.Email, sha256Password)
	db.QueryRow(`SELECT username FROM Users
									WHERE email = $1 AND password = $2`, user.Email, sha256Password).Scan(&username)

	if rows, _ := result.RowsAffected(); rows == 1 {
		return true, username
	} else {
		return false, ""
	}
}

func UpdateImage(username, imageName string) (string, error) {
	var oldImageName string
	const queryUpdateUserPhoto = `WITH selectImage AS (
		SELECT image_name FROM UserPhoto
		WHERE user_id = (SELECT user_id FROM Users 
		                        WHERE username = $1)
	),
	updateImage AS (
		UPDATE UserPhoto
		SET image_name = $2
		WHERE user_id = (SELECT user_id FROM Users 
		                        WHERE username = $1)
	)
	SELECT (SELECT image_name FROM selectImage);`
	err := db.QueryRow(queryUpdateUserPhoto, username, imageName).Scan(&oldImageName)
	return oldImageName, err
}

func GetImage(username string) (string, error) {
	var image string
	const querySelectImage = `SELECT image_name FROM UserPhoto
		WHERE user_id = (SELECT user_id FROM Users WHERE username = $1)`
	err := db.QueryRow(querySelectImage, username).Scan(&image)
	return image, err
}
