package main

import (
	"log"
	"net/http"
	"os"
	"path/filepath"

	"github.com/jmoiron/sqlx"
	"github.com/julienschmidt/httprouter"
	_ "github.com/lib/pq"
	"github.com/nitrous-io/community/handlers"
)

var cwd, dbURL, addr string

func init() {
	var err error
	cwd, err = os.Getwd()
	if err != nil {
		panic(err)
	}

	dbURL := os.Getenv("DB_URL")
	if dbURL == "" {
		panic("DB_URL not set")
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	addr = "0.0.0.0:" + port
}

func main() {
	db, err := sqlx.Open("postgres", dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	router := httprouter.New()

	router.GET("/community", handler.HomeIndexPage)

	router.GET("/community/login", handler.LoginPage)
	router.POST("/community/login", handler.Login)
	router.GET("/community/signup", handler.SignupPage)
	//router.POST("/community/signup", handler.Signup)
	//router.DELETE("/logout", handler.Logout)

	//router.GET("/community/tutorials", handler.TutorialIndexPage)
	//router.GET("/community/tutorials/:name", handler.TutorialShowPage)
	//router.GET("/community/tutorials/:name/edit", handler.TutorialEditPage)
	//router.PATCH("/community/tutorials/:name", handler.TutorialUpdate)
	//router.GET("/community/tutorials/new", handler.TutorialNewPage)
	//router.POST("/community/tutorials/create", handler.TutorialCreate)
	//router.DELETE("/community/tutorials/:name/delete", handler.TutorialDelete)

	http.Handle("/templates/", http.StripPrefix("/templates/", http.FileServer(http.Dir(filepath.Join(cwd, "/github.com/nitrous-io/community/templates")))))
	//http.Handle("/public/", http.StripPrefix("/public/", http.FileServer(http.Dir(filepath.Join(cwd, "/github.com/nitrous-io/community/public")))))

	log.Fatal(http.ListenAndServe(":8080", router))
}
