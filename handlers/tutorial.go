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
	tutorialNewTmpl = template.Must(template.New("signup").ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/tutorial-new.html")))
)

func TutorialNewPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	err := tutorialNewTmpl.ExecuteTemplate(w, "tutorial-new.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func TutorialCreate(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	title := r.FormValue("title")
	post := r.FormValue("post")
	var userid int64
	var username string

	if cookie, err := r.Cookie("user-session"); err == nil {
		cookieValue := make(map[string]interface{})
		if err = cookieHandler.Decode("user-session", cookie.Value, &cookieValue); err == nil {
			userid = cookieValue["userid"].(int64)
			username = cookieValue["username"].(string)
		} else {
			fmt.Println(err)
		}
	} else {
		fmt.Println(err)
	}

	t := data.Tutorial{
		UserID:   userid,
		Author:   username,
		Title:    title,
		Post:     post,
		Approved: false,
	}

	// Insert into db.
	if err := t.Insert(); err != nil {
		fmt.Println("TutorialCreate - t.Insert():", err)
		// TODO: Flash error messages.
		http.Redirect(w, r, "/community/tutorial/new", 302)
	}

	// Successful submission: Flash success message and inform user that submission will be reviewed.
	http.Redirect(w, r, "/community", 302)
}
