package handler

import (
	"encoding/json"
	"errors"
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/julienschmidt/httprouter"
)

var loginAPI string = os.Getenv("NITROUS_API") + "/oauth/token"

var (
	//loginTmpl *template.Template = template.Must(template.New("login").ParseFiles("github.com/nitrous-io/community/templates/login.html"))
	loginTmpl *template.Template = template.Must(template.New("login").ParseFiles("../templates/login.html"))
)

func LoginPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := loginTmpl.ExecuteTemplate(w, "login.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func Login(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var token string

	if res, err := authenticateLogin(r); err != nil {
		fmt.Println(err)
		http.Redirect(w, r, "/community/login", 302)
	} else {
		token = getJSONToken(res)
	}

	// TODO: Convert email to username if logged in with email.
	username := r.FormValue("username")
	setSession(username, token, w)

	http.Redirect(w, r, "/community", 302)
}

// Ping Nitrous login URL.
func authenticateLogin(r *http.Request) (*http.Response, error) {
	loginURL := fmt.Sprintf("%s?grant_type=%s&username=%s&password=%s",
		loginAPI,
		"password",
		r.FormValue("username"),
		r.FormValue("password"))

	res, err := http.Post(loginURL, "", nil)
	if err != nil {
		log.Fatal("HTTP POST Request: ", err)
	}
	if res.StatusCode != http.StatusOK {
		return nil, errors.New("Incorrect login credentials")
	}

	return res, nil
}

func getJSONToken(res *http.Response) string {
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal("ReadAll: ", err)
	}
	defer res.Body.Close()

	type LoginResp struct {
		Token string `json:"access_token"`
	}

	var l LoginResp
	readErr := json.Unmarshal(body, &l)
	if readErr != nil {
		log.Fatal(readErr)
	}

	return l.Token
}
