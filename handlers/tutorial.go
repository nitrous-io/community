package handler

import (
	"fmt"
	"html/template"
	"net/http"
	"path/filepath"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/data"
)

var (
	tutorialNewTmpl   = template.Must(template.New("tutorial").ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/tutorial-new.html")))
	tutorialIndexTmpl = template.Must(template.New("tutorial").ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/tutorial-index.html")))
)

func TutorialNewPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	if _, err := decodeCookie(r, "user-session"); err != nil {
		fmt.Println(err)
		http.Redirect(w, r, "/community", 302)
	}

	err := tutorialNewTmpl.ExecuteTemplate(w, "tutorial-new.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func TutorialCreate(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	var userid int64
	var username string
	if cookieValue, err := decodeCookie(r, "user-session"); err != nil {
		fmt.Println(err)
		http.Redirect(w, r, "/community", 302)
	} else {
		userid = cookieValue["userid"].(int64)
		username = cookieValue["username"].(string)
	}

	t := data.Tutorial{
		UserID: userid,
		Author: username,
		Title:  r.FormValue("title"),
		Post:   r.FormValue("post"),
	}
	// Insert into db.
	if err := t.Insert(); err != nil {
		fmt.Println("TutorialCreate: ", err)
		// TODO: Flash error messages.
		http.Redirect(w, r, "/community/tutorial/new", 302)
	}

	// Successful submission: Flash success message and inform user that submission will be reviewed.
	http.Redirect(w, r, "/community", 302)
}

func TutorialIndexPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	type ttrlVars struct {
		Tutorials []data.Tutorial
	}
	tv := ttrlVars{}
	if err := data.Db.Select(&tv.Tutorials, "SELECT * FROM tutorials;"); err != nil {
		fmt.Println(err)
	}

	err := tutorialIndexTmpl.ExecuteTemplate(w, "tutorial-index.html", tv)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
