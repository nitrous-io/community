package handler

import (
	"encoding/json"
	"errors"
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"path/filepath"

	"github.com/julienschmidt/httprouter"
)

var loginAPI = nitrousAPI + "/oauth/token"
var tokenAuthAPI = nitrousAPI + "/user"

var (
	loginTmpl = template.Must(template.New("login").ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/login.html")))
)

func LoginPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := loginTmpl.ExecuteTemplate(w, "login.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func Login(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var token string
	// Ping Nitrous login API.
	if res, err := authenticateLogin(r); err != nil {
		fmt.Println(err)
		http.Redirect(w, r, "/community/login", 302)
	} else {
		token = getToken(res)
	}

	// Ping Nitrous token auth API with token to get username and usertype (admin or non-admin).
	var userid int64
	var usertype, username string
	if res, err := authenticateByToken(token); err != nil {
		fmt.Println(err)
	} else {
		userid, username, usertype = getUserProfile(res)
	}

	setSession(userid, username, usertype, w)

	http.Redirect(w, r, "/community", 302)
}

// Ping Nitrous login API.
// If successful, returns {"access_token":"","token_type":"Bearer"}.
func authenticateLogin(r *http.Request) (*http.Response, error) {
	loginURL := fmt.Sprintf("%s?grant_type=%s&username=%s&password=%s",
		loginAPI,
		"password",
		r.FormValue("username"),
		r.FormValue("password"))

	res, err := http.Post(loginURL, "", nil)
	if err != nil {
		log.Fatal("authenticateLogin HTTP POST Request: ", err)
	}
	if res.StatusCode != http.StatusOK {
		return nil, errors.New("Incorrect login credentials")
	}

	return res, nil
}

func getToken(res *http.Response) string {
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal("getToken ReadAll: ", err)
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

// Ping Nitrous token auth API.
// If successful, returns {"user":{"id": ,"name": ,"username":"","email": ,"admin":bool,(other container details)}}.
func authenticateByToken(token string) (*http.Response, error) {
	client := &http.Client{}
	req, err := http.NewRequest("GET", tokenAuthAPI, nil)
	if err != nil {
		log.Fatal("authenticateByToken HTTP NewRequest: ", err)
	}

	req.Header.Set("Authorization", "Bearer "+token)

	res, reqErr := client.Do(req)
	if err != nil {
		log.Fatal("authenticateByToken Do: ", reqErr)
	}

	if res.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("authenticateByToken: Expected %v, Got %v", http.StatusOK, res.StatusCode)
	}

	return res, nil
}

func getUserProfile(res *http.Response) (int64, string, string) {
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal("getUserProfile ReadAll: ", err)
	}
	defer res.Body.Close()

	type ProfileResp struct {
		User struct {
			ID       int64  `json:"id"`
			Username string `json:"username"`
			Admin    bool   `json:"admin"`
		}
	}
	var p ProfileResp
	readErr := json.Unmarshal(body, &p)
	if readErr != nil {
		log.Fatal(readErr)
	}

	usertype := ""
	if p.User.Admin {
		usertype = "admin"
	}

	return p.User.ID, p.User.Username, usertype
}
