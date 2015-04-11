package handler

import (
	"fmt"
	"html/template"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/data"
)

var (
	homeTmpl *template.Template = template.Must(template.New("home").ParseFiles("github.com/nitrous-io/community/templates/home-index.html"))
)

type User struct {
	Username string
}

func HomeIndexPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	session, getStoreErr := Store.Get(r, "user-session")
	if getStoreErr != nil {
		fmt.Println("Unable to set or get user session from store: ", getStoreErr)
	}
	userToken := session.Values["token"].(string)
	userName := session.Values["username"].(string)

	fmt.Println(userToken)
	u := &User{
		Username: userName,
	}

	if LoggedIn(userToken) {
		//TODO: Handle logged in and not logged in users.
		fmt.Println("logged in")
	} else {
		fmt.Println("not logged in")
	}

	err := homeTmpl.ExecuteTemplate(w, "home-index.html", u)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func LoggedIn(token string) bool {
	t := &data.Token{
		Token: token,
	}
	if err := t.GetByToken(); err != nil {
		return false
	}
	return true
}
