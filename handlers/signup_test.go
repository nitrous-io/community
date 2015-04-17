package handler_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/handlers"
)

//
// Tests the following:
// - GET SignupPage: simple get request should return correct status code.
// - POST Signup: unsuccessful test cases should return correct status code.
//

var devSignupAPI = nitrousDevAPI + "/users"

func setupServerSignup() (*httptest.Server, error) {
	router := httprouter.New()
	router.GET("/community/signup", handler.SignupPage)
	router.POST("/community/signup", handler.Signup)
	return httptest.NewServer(router), nil
}

func TestSignupPage(t *testing.T) {
	ts, err := setupServerSignup()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	res, err := http.Get(ts.URL + "/community/signup")
	if err != nil {
		t.Fatal(err)
	}
	if res.StatusCode != http.StatusOK {
		t.Errorf("%s/community/signup - Expected status code %v, Got %v", ts.URL, http.StatusOK, res.StatusCode)
	}
}

func TestSignup(t *testing.T) {
	ts, err := setupServerSignup()
	if err != nil {
		t.Fatal(err)
	}
	defer ts.Close()

	type ExpectedStatus struct {
		Path       string
		StatusCode int
	}

	testCases := []ExpectedStatus{
		// TODO: Implement success case.

		// Fail cases.
		// Existing user signup.
		{"?username=bighero&email=nitrousbighero@gmail.com&password=baymaxxy", http.StatusBadRequest},
		// Password too short.
		{"?username=newhero&email=nitrousnewhero@gmail.com&password=bay", http.StatusBadRequest},
	}

	for _, tc := range testCases {
		res, err := http.Post(devSignupAPI+tc.Path, "", nil)
		if err != nil {
			t.Fatal(err)
		}
		if res.StatusCode != tc.StatusCode {
			t.Errorf("%s - Expected status code %v, Got %v", devSignupAPI+tc.Path, tc.StatusCode, res.StatusCode)
		}
	}
}
