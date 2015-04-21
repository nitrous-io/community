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
	"path/filepath"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/utils"
)

//
// User fills in credentials on a form on Nitrous community.
// Logs user in by pinging login API on Nitrous Pro.
// Login API returns an access token in JSON format.
// Use token value to ping tokenAuth API on Nitrous Pro to get session values.
// Sets session values in encrypted cookie stored on client side.
//

var (
	pwd        = os.Getenv("PWD_PATH")
	nitrousAPI = os.Getenv("NITROUS_API")
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
	var p ProfileResp
	if res, err := authenticateByToken(token); err != nil {
		fmt.Println(err)
	} else {
		p = getUserProfile(res)
	}

	userid := p.User.ID
	username := p.User.Username
	usertype := ""
	if p.User.Admin {
		usertype = "admin"
	}

	utils.SetSession(userid, username, usertype, w)

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

// getToken derives Token value from the JSON response returned by the login API.
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

// Ping Nitrous tokenAuth API.
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

type ProfileResp struct {
	User struct {
		ID       int64  `json:"id"`
		Username string `json:"username"`
		Admin    bool   `json:"admin"`
	}
}

// getUserProfile derives ID, Username, and Admin values from the JSON response returned by the tokenAuth API.
func getUserProfile(res *http.Response) ProfileResp {
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal("getUserProfile ReadAll: ", err)
	}
	defer res.Body.Close()

	var p ProfileResp
	readErr := json.Unmarshal(body, &p)
	if readErr != nil {
		log.Fatal(readErr)
	}

	return p
}
