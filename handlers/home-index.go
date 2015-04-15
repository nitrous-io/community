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

	if cookie, err := r.Cookie("user-session"); err == nil {
		cookieValue := make(map[string]interface{})
		if err = cookieHandler.Decode("user-session", cookie.Value, &cookieValue); err == nil {
			sv.Username = cookieValue["username"].(string)
			sv.Authed = true
			if cookieValue["usertype"] == "admin" {
				sv.Admin = true
			}
		} else {
			fmt.Println(err)
		}
	} else {
		// sv.Authed defaults to false if no user-session.
		fmt.Println(err)
	}

	err := homeTmpl.ExecuteTemplate(w, "home-index.html", sv)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
