package handler

import (
	"errors"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"path/filepath"

	"github.com/julienschmidt/httprouter"
)

//
// User signs up on a form on Nitrous community.
// Signs up user by pinging signup API on Nitrous Pro.
// If successful, log in user automatically by calling Login function, which will set session values.
// Else if unsuccessful, redirect to signup page.
//

var signupAPI = nitrousAPI + "/users"

var (
	signupTmpl = template.Must(template.New("signup").ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/signup.html")))
)

func SignupPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := signupTmpl.ExecuteTemplate(w, "signup.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func Signup(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	if err := authenticateSignup(r); err != nil {
		// TODO: Flash error messages.
		fmt.Println(err)
		http.Redirect(w, r, "/community/signup", 302)
	} else {
		Login(w, r, nil)
	}
}

// Ping Nitrous signup API.
// If successful, returns http.StatusCreated.
func authenticateSignup(r *http.Request) error {
	signupURL := fmt.Sprintf("%s?email=%s&username=%s&password=%s",
		signupAPI,
		r.FormValue("email"),
		r.FormValue("username"),
		r.FormValue("password"))

	res, err := http.Post(signupURL, "", nil)
	if err != nil {
		log.Fatal("HTTP POST Request: ", err)
	}
	if res.StatusCode != http.StatusCreated {
		return errors.New("User not created: got error " + string(res.StatusCode))
		// TODO: Flash error messages.
	}

	return nil
}
