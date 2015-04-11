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

	"github.com/gorilla/sessions"
	"github.com/julienschmidt/httprouter"
)

var (
	oAuthAPI     string = os.Getenv("NITROUS_OAUTH_URL")
	secretString string = os.Getenv("COOKIE_SECRET")
)

var (
	loginTmpl *template.Template = template.Must(template.New("login").ParseFiles("github.com/nitrous-io/community/templates/users/login.html"))
)

func LoginPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := loginTmpl.ExecuteTemplate(w, "login.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

var Store = sessions.NewCookieStore([]byte(secretString))

func Login(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var token string

	if res, err := authenticateUser(r); err != nil {
		fmt.Println(err)
		http.Redirect(w, r, "/community/login", 302)
	} else {
		token = getJSONToken(res)
	}

	session, err := Store.Get(r, "user-session")
	if err != nil {
		fmt.Println("Unable to set or get user session from store: ", err)
	}

	// TODO: Convert user email to username if logged in with email.
	session.Values["username"] = r.FormValue("username")
	session.Values["token"] = token

	// TODO: Set usertypes to differentiate admin users from normal users.
	//if r.FormValue("username") == "admin" {
	//	session.Values["usertype"] = "admin"
	//} else {
	//	session.Values["usertype"] = "user"
	//}

	if err := session.Save(r, w); err != nil {
		fmt.Println("Unable to save session in store: ", err)
	}

	http.Redirect(w, r, "/community", 302)
}

func authenticateUser(r *http.Request) (*http.Response, error) {
	loginURL := fmt.Sprintf("%s?grant_type=%s&username=%s&password=%s",
		oAuthAPI,
		r.FormValue("grant_type"),
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

	type LoginJSONResp struct {
		Token string `json:"access_token"`
	}

	var l LoginJSONResp
	readErr := json.Unmarshal(body, &l)
	if readErr != nil {
		log.Fatal(readErr)
	}

	token := l.Token
	return token
}
