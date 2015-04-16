package handler_test

import (
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/handlers"
)

var devLogoutAPI = os.Getenv("NITROUS_DEV_API") + "/logout"

func setupServerLogout() (*httptest.Server, error) {
	router := httprouter.New()
	router.GET("/community/logout", handler.Logout)
	return httptest.NewServer(router), nil
}

func TestLogout(t *testing.T) {
	ts, err := setupServerSignup()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	result, err := http.NewRequest("DELETE", devLogoutAPI, nil)
	if err != nil {
		t.Fatal(err)
	}
	res, err := http.DefaultClient.Do(result)
	if err != nil {
		t.Fatal(err)
	}

	b, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		t.Fatal(err)
	}

	// TODO: Test Logout properly.
	if res.StatusCode != http.StatusBadRequest {
		t.Errorf("%s - Expected status code %v, Got %v", devLogoutAPI, http.StatusBadRequest, res.StatusCode)
	}
	expectedBody := `{"error":"invalid_request","error_description":"auth token is required"}`
	if string(b) != expectedBody {
		t.Errorf("%s - Expected body %s, Got %s", devLogoutAPI, expectedBody, string(b))
	}
}
