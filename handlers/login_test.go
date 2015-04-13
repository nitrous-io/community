package handler_test

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/handlers"
)

var devLoginAPI string = os.Getenv("NITROUS_DEV_API") + "/oauth/token"

func setupServerLogin() (*httptest.Server, error) {
	router := httprouter.New()
	router.GET("/community/login", handler.LoginPage)
	router.POST("/community/login", handler.Login)
	return httptest.NewServer(router), nil
}

func TestLoginPage(t *testing.T) {
	ts, err := setupServerLogin()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	res, err := http.Get(ts.URL + "/community/login")
	if err != nil {
		t.Fatal(err)
	}
	if res.StatusCode != http.StatusOK {
		t.Errorf("%s/community/login - Expected status code %v, Got %v", ts.URL, http.StatusOK, res.StatusCode)
	}
}

func TestLogin(t *testing.T) {
	ts, err := setupServerLogin()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	type ExpectedStatus struct {
		Path       string
		StatusCode int
	}

	testCases := []ExpectedStatus{
		// Success case.
		{"?grant_type=password&username=bighero&password=baymaxxy", http.StatusOK},
		// Fail cases.
		{"?grant_type=password&username=fakebighero&password=baymaxxy", http.StatusBadRequest},
		{"?grant_type=password&username=bighero&password=fakebaymaxxy", http.StatusBadRequest},
		{"?username=bighero&password=baymaxxy", http.StatusBadRequest},
	}

	for _, tc := range testCases {
		res, err := http.Post(devLoginAPI+tc.Path, "", nil)
		if err != nil {
			t.Fatal(err)
		}
		if res.StatusCode != tc.StatusCode {
			t.Errorf("%s - Expected status code %v, Got %v", devLoginAPI+tc.Path, tc.StatusCode, res.StatusCode)
		}
	}
}
