package handler

import (
	"html/template"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

var (
	signupTmpl *template.Template = template.Must(template.New("signup").ParseFiles("github.com/nitrous-io/community/templates/users/signup.html"))
)

func SignupPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := signupTmpl.ExecuteTemplate(w, "signup.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
