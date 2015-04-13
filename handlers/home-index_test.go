package handler_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/handlers"
)

func setupServerHomeIndex() (*httptest.Server, error) {
	router := httprouter.New()
	router.GET("/community", handler.HomeIndexPage)
	return httptest.NewServer(router), nil
}

func TestHomeIndexPage(t *testing.T) {
	ts, err := setupServerHomeIndex()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	res, err := http.Get(ts.URL + "/community")
	if err != nil {
		t.Fatal(err)
	}
	if res.StatusCode != http.StatusOK {
		t.Errorf("/community - Expected status code %v, Got %v", http.StatusOK, res.StatusCode)
	}
}
