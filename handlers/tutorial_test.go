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
	"github.com/nitrous-io/community/testhelpers"
)

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

	// Authenticated Access.
	value := map[string]interface{}{
		"userid":   1,
		"username": "bighero",
		"usertype": "admin",
	}
	if encoded, eErr := handler.CookieHandler.Encode("user-session", value); eErr == nil {
		cookie := &http.Cookie{
			Name:  "user-session",
			Value: encoded,
			Path:  "/community",
		}
		req.AddCookie(cookie)
	}

	if _, dErr := handler.DecodeCookie(req, "user-session"); dErr != nil {
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

	// Unauthenticated access.
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

	db := testhelpers.SetupDB(t)
	defer db.Close()

	data.Db = db

	req, err := http.NewRequest("POST", ts.URL+"/community/tutorials", nil)
	if err != nil {
		t.Fatal(err)
	}

	// Authenticated Access.
	var n int64
	n = 1
	value := map[string]interface{}{
		"userid":   n,
		"username": "bighero",
		"usertype": "admin",
	}
	if encoded, eErr := handler.CookieHandler.Encode("user-session", value); eErr == nil {
		cookie := &http.Cookie{
			Name:  "user-session",
			Value: encoded,
			Path:  "/community",
		}
		req.AddCookie(cookie)
	}

	var userid int64
	var username string
	if cookieValue, err := handler.DecodeCookie(req, "user-session"); err != nil {
		t.Fatalf("%s", err)
	} else {
		userid = cookieValue["userid"].(int64)
		username = cookieValue["username"].(string)
	}

	prettyurl, perr := handler.BeautifyURL("How to build a robot")
	if perr != nil {
		t.Logf("%s", perr)
	}

	ttr := data.Tutorial{
		UserID:    userid,
		Author:    username,
		PrettyURL: prettyurl,
		Title:     "How to build a robot",
		Post:      "baymax",
	}
	// Insert into db.
	if dbErr := ttr.Insert(db); dbErr != nil {
		t.Fatalf("%s", dbErr)
	}

	client := &http.Client{}
	res, rErr := client.Do(req)
	if rErr != nil {
		t.Fatal(rErr)
	}

	if res.StatusCode != http.StatusCreated {
		t.Errorf("/community/tutorials - Expected status code %v, Got %v", http.StatusOK, res.StatusCode)
	}

}

func TestTutorialShow(t *testing.T) {
	ts, err := setupServerTutorial()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	db := testhelpers.SetupDB(t)
	defer db.Close()

	data.Db = db

	ttr := data.Tutorial{
		UserID:    1,
		Author:    "bighero",
		PrettyURL: "how-to-build-a-robot",
		Title:     "How to build a robot",
		Post:      "baymax",
	}
	// Insert into db.
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

func TestTutorialndexPage(t *testing.T) {
	ts, err := setupServerTutorial()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	db := testhelpers.SetupDB(t)
	defer db.Close()

	data.Db = db

	ttrl := data.Tutorial{
		UserID:    1,
		Author:    "bighero",
		PrettyURL: "how-to-build-a-robot",
		Title:     "How to build a robot",
		Post:      "baymax",
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
