package handler

import (
	"html/template"
	"net/http"
	"os"
	"path/filepath"

	"github.com/julienschmidt/httprouter"
)

var cwd string

func init() {
	var err error
	cwd, err = os.Getwd()
	if err != nil {
		panic(err)
	}
}

var (
	homeTmpl *template.Template = template.Must(template.New("home").ParseFiles(filepath.Join(cwd, "github.com/nitrous-io/community/templates/home-index.html")))
)

func HomeIndexPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := homeTmpl.ExecuteTemplate(w, "home-index.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
