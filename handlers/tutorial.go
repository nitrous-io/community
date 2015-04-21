package handler

import (
	"fmt"
	"html/template"
	"net/http"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/data"
	"github.com/nitrous-io/community/utils"
	"github.com/russross/blackfriday"
)

//
// Implements the following actions:
// - New(protected)
// - Create(protected)
// - Index
// - Show
//

var (
	tutorialNewTmpl   = template.Must(template.New("tutorial").ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/tutorial-new.html")))
	tutorialIndexTmpl = template.Must(template.New("tutorial").Funcs(map[string]interface{}{"ToHtml": ToHtml}).ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/tutorial-index.html")))
	tutorialShowTmpl  = template.Must(template.New("tutorial").Funcs(map[string]interface{}{"ToHtml": ToHtml}).ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/tutorial-show.html")))
)

// Escape HTML.
func ToHtml(s string) template.HTML {
	return template.HTML(s)
}

// Protected page: Admin access only.
func TutorialNewPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	// Lock page against unauthorized (non-admin) access.
	if _, err := utils.DecodeCookie(r, "user-session"); err != nil {
		fmt.Println(err)
		http.Redirect(w, r, "/community", 302)
	}

	err := tutorialNewTmpl.ExecuteTemplate(w, "tutorial-new.html", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

// Protected action: Admin access only.
func TutorialCreate(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	// Lock page against unauthorized (non-admin) access.
	cookieValue, err := utils.DecodeCookie(r, "user-session")
	if err != nil {
		fmt.Println(err)
		http.Redirect(w, r, "/community", 302)
	}

	prettyurl, err := ConvertToPrettyURL(r.FormValue("title"))
	if err != nil {
		fmt.Println(err)
	}

	posthtml := blackfriday.MarkdownBasic([]byte(r.FormValue("post")))

	// This is a stand-in solution to the current lack of support for postgres arrays: https://github.com/jmoiron/sqlx/issues/106.
	tagArray := fmt.Sprintf("{%v}", r.FormValue("tags"))

	t := data.Tutorial{
		UserID:       cookieValue["userid"].(int64),
		Author:       cookieValue["username"].(string),
		PrettyURL:    prettyurl,
		Title:        r.FormValue("title"),
		PostMarkdown: r.FormValue("post"),
		PostHTML:     string(posthtml),
		Tags:         tagArray,
		// TODO: Implement approved status.
	}
	if err := t.Insert(data.Db); err != nil {
		fmt.Println("TutorialCreate: ", err)
		// TODO: Flash error messages.
		http.Redirect(w, r, "/community/tutorial/new", 302)
	}

	// Successful submission: Flash success message and inform user that submission will be reviewed.
	http.Redirect(w, r, "/community", 302)
}

// Converts 'Title To URL' to 'title-to-url' format.
func ConvertToPrettyURL(title string) (string, error) {
	reg, err := regexp.Compile("[^a-zA-Z0-9]+")
	if err != nil {
		return "", err
	}
	prettyurl := reg.ReplaceAllString(title, "-")
	prettyurl = strings.ToLower(strings.Trim(prettyurl, "-"))

	return prettyurl, nil
}

func TutorialIndexPage(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	type ttrlVars struct {
		Tutorials []*data.Tutorial
		Tags      [][]string
	}
	var tv ttrlVars

	ttrls, dbErr := data.GetAllTutorials(data.Db)
	if dbErr != nil {
		fmt.Println(dbErr)
	}
	tv.Tutorials = ttrls

	for _, ttrl := range ttrls {
		tags := convertTagsToSlice(ttrl)
		tv.Tags = append(tv.Tags, tags)
	}

	err := tutorialIndexTmpl.ExecuteTemplate(w, "tutorial-index.html", tv)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

// TODO: Find a cleaner solution to driver's lack of support for postgres arrays.
func convertTagsToSlice(ttrl *data.Tutorial) []string {
	a := ([]byte(ttrl.Tags))
	b := (string(a[1 : len(a)-1]))
	tags := strings.Split(b, ",")
	return tags
}

func TutorialShowPage(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	prettyurl := ps.ByName("prettyurl")
	t, err := data.GetByPrettyURL(data.Db, prettyurl)
	if err != nil {
		fmt.Println(err)
	}

	type ttrlVars struct {
		Tutorial *data.Tutorial
		Tags     []string
	}
	var tv ttrlVars
	tv.Tutorial = t

	tags := convertTagsToSlice(t)
	tv.Tags = tags

	tErr := tutorialShowTmpl.ExecuteTemplate(w, "tutorial-show.html", tv)
	if tErr != nil {
		http.Error(w, tErr.Error(), http.StatusInternalServerError)
	}
}
