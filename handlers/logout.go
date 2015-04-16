package handler

import (
	"fmt"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

var logoutAPI = nitrousAPI + "/logout"

func Logout(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	result, err := http.NewRequest("DELETE", logoutAPI, nil)
	if err != nil {
		fmt.Println(err)
	}
	res, err := http.DefaultClient.Do(result)
	if err != nil {
		fmt.Println(err)
	}
	if res.StatusCode != http.StatusOK {
		// TODO: Flash error messages.
		fmt.Println("successfully logged out")
	} else {
		fmt.Println("did not log out")
	}

	clearSession(w)

	http.Redirect(w, r, "/community", 302)
}
