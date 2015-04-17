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
	tutorialShowTmpl  = template.Must(template.New("tutorial").ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/tutorial-show.html")))
)

func TutorialNewPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	if _, err := DecodeCookie(r, "user-session"); err != nil {
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
	if cookieValue, err := DecodeCookie(r, "user-session"); err != nil {
		fmt.Println(err)
		http.Redirect(w, r, "/community", 302)
	} else {
		userid = cookieValue["userid"].(int64)
		username = cookieValue["username"].(string)
	}

	prettyurl, err := BeautifyURL(r.FormValue("title"))
	if err != nil {
		fmt.Println(err)
	}

	t := data.Tutorial{
		UserID:    userid,
		Author:    username,
		PrettyURL: prettyurl,
		Title:     r.FormValue("title"),
		Post:      r.FormValue("post"),
	}
	// Insert into db.
	if err := t.Insert(data.Db); err != nil {
		fmt.Println("TutorialCreate: ", err)
		// TODO: Flash error messages.
		http.Redirect(w, r, "/community/tutorial/new", 302)
	}

	w.WriteHeader(http.StatusCreated)
	// Successful submission: Flash success message and inform user that submission will be reviewed.
	http.Redirect(w, r, "/community", 302)
}

func TutorialIndexPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	type ttrlVars struct {
		Tutorials []*data.Tutorial
	}
	var tv ttrlVars

	var ts []*data.Tutorial
	tx, dbErr := data.GetAllTutorials(ts, data.Db)
	if dbErr != nil {
		fmt.Println(dbErr)
	}
	tv.Tutorials = tx

	err := tutorialIndexTmpl.ExecuteTemplate(w, "tutorial-index.html", tv)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func TutorialShowPage(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	prettyurl := ps.ByName("prettyurl")

	t := data.Tutorial{}
	t.GetByPrettyURL(prettyurl)

	err := tutorialShowTmpl.ExecuteTemplate(w, "tutorial-show.html", t)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
