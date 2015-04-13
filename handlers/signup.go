package handler

import (
	"errors"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"

	"github.com/julienschmidt/httprouter"
)

var signupAPI string = os.Getenv("NITROUS_API") + "/users"

var (
	//signupTmpl *template.Template = template.Must(template.New("signup").ParseFiles("github.com/nitrous-io/community/templates/signup.html"))
	signupTmpl *template.Template = template.Must(template.New("signup").ParseFiles("../templates/signup.html"))
)

func SignupPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := signupTmpl.ExecuteTemplate(w, "signup.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func Signup(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var token string

	if err := authenticateSignup(r); err != nil {
		// TODO: Flash error messages.
		fmt.Println(err)
		http.Redirect(w, r, "/community/signup", 302)
	} else {
		// Successful signup. Auto-login user.
		if res, err := authenticateLogin(r); err != nil {
			// Unable to log in for some reason.
			fmt.Println(err)
			http.Redirect(w, r, "/community/login", 302)
		} else {
			// Successful login.
			token = getJSONToken(res)
		}
	}

	username := r.FormValue("username")
	setSession(username, token, w)

	http.Redirect(w, r, "/community", 302)
}

// Ping Nitrous signup URL.
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
