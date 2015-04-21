package handler_test

import (
	"bytes"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/data"
	"github.com/nitrous-io/community/handlers"
	"github.com/nitrous-io/community/utils"
	"github.com/russross/blackfriday"
)

//
// Tests the following:
// - GET TutorialNewPage: authenticated and unauthenticated access should return correct status code.
// - POST Tutorial: authenticated access should be able to create new tutorial.
// - GET TutorialIndexPage: should return correct status code and contain byte value of a submitted tutorial in response body.
// - GET TutorialShowPage: should return correct status code when called with prettyurl and contain byte value of a submitted tutorial in response body.
//

func setupServerTutorial() (*httptest.Server, error) {
	router := httprouter.New()
	router.GET("/community/tutorials/new", handler.TutorialNewPage) // Admin Authed.
	router.POST("/community/tutorials", handler.TutorialCreate)     // Admin Authed.
	router.GET("/community/tutorials", handler.TutorialIndexPage)
	router.GET("/community/tutorial/:prettyurl", handler.TutorialShowPage)
	return httptest.NewServer(router), nil
}

func TestTutorialNew(t *testing.T) {
	ts, err := setupServerTutorial()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	req, err := http.NewRequest("GET", ts.URL+"/community/tutorials/new", nil)
	if err != nil {
		t.Fatal(err)
	}

	// Test authenticated access.
	value := map[string]interface{}{
		"userid":   1,
		"username": "bighero",
		"usertype": "admin",
	}
	if encoded, eErr := utils.CookieHandler.Encode("user-session", value); eErr == nil {
		cookie := &http.Cookie{
			Name:  "user-session",
			Value: encoded,
			Path:  "/community",
		}
		req.AddCookie(cookie)
	}

	if _, dErr := utils.DecodeCookie(req, "user-session"); dErr != nil {
		t.Logf("dErr: %s", dErr)
	}

	client := &http.Client{}
	res, rErr := client.Do(req)
	if err != nil {
		t.Fatal(rErr)
	}

	if res.StatusCode != http.StatusOK {
		t.Errorf("/community/tutorials/new - Expected status code %v, Got %v", http.StatusOK, res.StatusCode)
	}

	// Test unauthenticated access.
	unauthRes, UErr := http.Get(ts.URL + "/community/tutorials/new")
	if UErr != nil {
		t.Fatal(UErr)
	}
	if unauthRes.StatusCode != http.StatusNotFound {
		t.Errorf("/community/tutorials/new - Expected status code %v, Got %v", http.StatusNotFound, unauthRes.StatusCode)
	}
}

func TestTutorialCreate(t *testing.T) {
	ts, err := setupServerTutorial()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	db := utils.SetupDB(t)
	defer db.Close()

	data.Db = db

	req, err := http.NewRequest("POST", ts.URL+"/community/tutorials", nil)
	if err != nil {
		t.Fatal(err)
	}

	// Test authenticated access.
	var n int64 = 1
	value := map[string]interface{}{
		"userid":   n,
		"username": "bighero",
		"usertype": "admin",
	}
	if encoded, eErr := utils.CookieHandler.Encode("user-session", value); eErr == nil {
		cookie := &http.Cookie{
			Name:  "user-session",
			Value: encoded,
			Path:  "/community",
		}
		req.AddCookie(cookie)
	}

	cookieValue, err := utils.DecodeCookie(req, "user-session")
	if err != nil {
		t.Fatalf("%s", err)
	}
	userid := cookieValue["userid"].(int64)
	username := cookieValue["username"].(string)

	prettyurl, cErr := handler.ConvertToPrettyURL("How to build a robot")
	if cErr != nil {
		t.Logf("%s", cErr)
	}

	posthtml := blackfriday.MarkdownBasic([]byte("# baymax"))

	ttrl := data.Tutorial{
		UserID:       userid,
		Author:       username,
		PrettyURL:    prettyurl,
		Title:        "How to build a robot",
		PostMarkdown: "# baymax",
		PostHTML:     string(posthtml),
		Tags:         `{"apple", "orange"}`,
	}
	if dbErr := ttrl.Insert(db); dbErr != nil {
		t.Fatalf("%s", dbErr)
	}

	client := &http.Client{}
	_, rErr := client.Do(req)
	if rErr != nil {
		t.Fatal(rErr)
	}
}

func TestTutorialShow(t *testing.T) {
	ts, err := setupServerTutorial()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	db := utils.SetupDB(t)
	defer db.Close()

	data.Db = db

	posthtml := blackfriday.MarkdownBasic([]byte("# baymax"))

	ttr := data.Tutorial{
		UserID:       1,
		Author:       "bighero",
		PrettyURL:    "how-to-build-a-robot",
		Title:        "How to build a robot",
		PostMarkdown: "# baymax",
		PostHTML:     string(posthtml),
		Tags:         `{"apple", "orange"}`,
	}
	if dbErr := ttr.Insert(db); dbErr != nil {
		t.Fatalf("%s", dbErr)
	}

	res, err := http.Get(ts.URL + "/community/tutorial/how-to-build-a-robot")
	if err != nil {
		t.Fatal(err)
	}
	if res.StatusCode != http.StatusOK {
		t.Errorf("/community/tutorial/how-to-build-a-robot - Expected status code %v, Got %v", http.StatusOK, res.StatusCode)
	}

	b, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Contains(b, []byte{'b', 'a', 'y', 'm', 'a', 'x'}) {
		t.Errorf("/community/tutorial/how-to-buid-a-robot - Expected response body to contain %s, Got %s", "baymax", b)
	}

	if res.StatusCode != http.StatusOK {
		t.Errorf("/community/tutorials - Expected status code %v, Got %v", http.StatusOK, res.StatusCode)
	}
}

func TestTutorialIndexPage(t *testing.T) {
	ts, err := setupServerTutorial()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	db := utils.SetupDB(t)
	defer db.Close()

	data.Db = db

	posthtml := blackfriday.MarkdownBasic([]byte("# baymax"))

	ttrl := data.Tutorial{
		UserID:       1,
		Author:       "bighero",
		PrettyURL:    "how-to-build-a-robot",
		Title:        "How to build a robot",
		PostMarkdown: "# baymax",
		PostHTML:     string(posthtml),
		Tags:         `{"apple", "orange"}`,
	}

	if dbErr := ttrl.Insert(db); dbErr != nil {
		t.Fatal(dbErr)
	}

	res, err := http.Get(ts.URL + "/community/tutorials")
	if err != nil {
		t.Fatal(err)
	}
	if res.StatusCode != http.StatusOK {
		t.Errorf("/community/tutorials - Expected status code %v, Got %v", http.StatusOK, res.StatusCode)
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
