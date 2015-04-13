package handler

import (
	"fmt"
	"html/template"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

var (
	// FIXME: Set test environment so that test files compile with the right path to templates.
	//homeTmpl *template.Template = template.Must(template.New("home").ParseFiles("github.com/nitrous-io/community/templates/home-index.html"))
	homeTmpl *template.Template = template.Must(template.New("home").ParseFiles("../templates/home-index.html"))
)

type User struct {
	Username string
}

func HomeIndexPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var u User

	if currentuser, err := getUsername(r); err != nil {
		u.Username = currentuser
	} else {
		fmt.Println(err)
		// There is no cookie; user is unauthenticated.
		// TODO: Serve different pages based on whether user in logged in or not.
	}

	err := homeTmpl.ExecuteTemplate(w, "home-index.html", u)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
