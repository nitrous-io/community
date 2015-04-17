package main

import (
	"log"
	"net/http"
	"os"

	"github.com/jmoiron/sqlx"
	"github.com/julienschmidt/httprouter"
	_ "github.com/lib/pq"
	"github.com/nitrous-io/community/data"
	"github.com/nitrous-io/community/handlers"
)

var cwd, addr string

func init() {
	var err error
	cwd, err = os.Getwd()
	if err != nil {
		panic(err)
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	addr = "0.0.0.0:" + port
}

func main() {
	dbURL := os.Getenv("DB_URL")
	if dbURL == "" {
		panic("DB_URL not set")
	}
	db, err := sqlx.Open("postgres", dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	data.Db = db

	router := httprouter.New()

	//router.ServeFiles("/css/*filepath", http.Dir(cwd+"github.com/nitrous-io/community/public/css"))
	//router.ServeFiles("/js/*filepath", http.Dir(cwd+"github.com/nitrous-io/community/public/js"))

	router.GET("/community", handler.HomeIndexPage)

	router.GET("/community/login", handler.LoginPage)
	router.GET("/community/signup", handler.SignupPage)
	router.POST("/community/login", handler.Login)
	router.POST("/community/signup", handler.Signup)

	router.GET("/community/tutorials", handler.TutorialIndexPage)
	router.GET("/community/tutorial/:prettyurl", handler.TutorialShowPage)

	// Protected: Authed.
	router.GET("/community/logout", handler.Logout)

	// Protected: Admin Authed.
	router.GET("/community/tutorials/new", handler.TutorialNewPage)
	router.POST("/community/tutorials", handler.TutorialCreate)

	//router.GET("/community/tutorials/:name/edit", handler.TutorialEditPage)
	//router.PUT("/community/tutorials/:name", handler.TutorialUpdate)
	//router.DELETE("/community/tutorials/:name/delete", handler.TutorialDelete)

	log.Fatal(http.ListenAndServe(":8080", router))
}
