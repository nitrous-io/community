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
	tutorialTagIndexTmpl = template.Must(template.New("tutorial").Funcs(map[string]interface{}{"ToHtml": ToHtml}).ParseFiles(filepath.Join(pwd, "/github.com/nitrous-io/community/templates/tutorialtag-index.html")))
)

func TutorialTagIndexPage(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	type ttrlVars struct {
		Tutorials []*data.Tutorial
		Tags      [][]string
	}
	var tv ttrlVars

	tag := ps.ByName("tag")
	ttrls, err := data.GetByTag(data.Db, tag)
	if err != nil {
		fmt.Println(err)
	}
	tv.Tutorials = ttrls

	for _, ttrl := range ttrls {
		tags := convertTagsToSlice(ttrl)
		tv.Tags = append(tv.Tags, tags)
	}

	tErr := tutorialTagIndexTmpl.ExecuteTemplate(w, "tutorialtag-index.html", tv)
	if tErr != nil {
		http.Error(w, tErr.Error(), http.StatusInternalServerError)
	}
}
