package handler_test

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/data"
	"github.com/nitrous-io/community/handlers"
	"github.com/nitrous-io/community/utils"
)

func setupServerTutorialTags() (*httptest.Server, error) {
	router := httprouter.New()
	router.GET("/community/tutorials/tags/:tag", handler.TutorialTagIndexPage)
	return httptest.NewServer(router), nil
}

func TestTutorialTagIndexPage(t *testing.T) {
	ts, err := setupServerTutorialTags()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	db := utils.SetupDB(t)
	defer db.Close()

	data.Db = db

	tagArray := fmt.Sprintf("{%v}", "apple,orange")

	ttrl := data.Tutorial{
		UserID:       1,
		Author:       "bighero",
		PrettyURL:    "how-to-build-a-robot",
		Title:        "How to build a robot",
		PostMarkdown: "# baymax",
		PostHTML:     "<h1>baymax</h1>",
		Tags:         tagArray,
	}

	if dbErr := ttrl.Insert(db); dbErr != nil {
		t.Fatal(dbErr)
	}

	res, err := http.Get(ts.URL + "/community/tutorials/tags/apple")
	if err != nil {
		t.Fatal(err)
	}
	if res.StatusCode != http.StatusOK {
		t.Errorf("/community/tutorials/tags/apple - Expected status code %v, Got %v", http.StatusOK, res.StatusCode)
	}

	b, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Contains(b, []byte{'b', 'a', 'y', 'm', 'a', 'x'}) {
		t.Errorf("/community/tutorials - Expected response body to contain %s, Got %s", "baymax", b)
	}
}
