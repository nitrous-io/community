package handler

import (
	"fmt"
	"html/template"
	"net/http"
	"path/filepath"

	"github.com/julienschmidt/httprouter"
)

var (
	homeTmpl = template.Must(template.New("home").ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/home-index.html")))
)

type sessionVars struct {
	Username string
	Authed   bool
	Admin    bool
}

func HomeIndexPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var sv sessionVars
	if cookieValue, err := decodeCookie(r, "user-session"); err != nil {
		fmt.Println(err)
	} else {
		sv.Username = cookieValue["username"].(string)
		sv.Authed = true
		if cookieValue["usertype"] == "admin" {
			sv.Admin = true
		}
	}

	tmplErr := homeTmpl.ExecuteTemplate(w, "home-index.html", sv)
	if tmplErr != nil {
		http.Error(w, tmplErr.Error(), http.StatusInternalServerError)
	}
}
