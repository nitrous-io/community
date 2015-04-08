package handler

import (
	"html/template"
	"net/http"
	"path/filepath"

	"github.com/julienschmidt/httprouter"
)

var (
	loginTmpl  *template.Template = template.Must(template.New("login").ParseFiles(filepath.Join(cwd, "github.com/nitrous-io/community/templates/users/login.html")))
	signupTmpl *template.Template = template.Must(template.New("signup").ParseFiles(filepath.Join(cwd, "github.com/nitrous-io/community/templates/users/signup.html")))
)

func LoginPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := loginTmpl.ExecuteTemplate(w, "login.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func Login(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	// TODO: Authenticate User.
	http.Redirect(w, r, "/community", 302)
}

func SignupPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := signupTmpl.ExecuteTemplate(w, "signup.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
