package handler

import (
	"fmt"
	"net/http"

	"github.com/julienschmidt/httprouter"
	"github.com/nitrous-io/community/utils"
)

//
// Deletes token from Nitrous DB upon logout by calling Nitrous logout API.
// Session cookie on Nitrous community is also deleted.
//

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

	utils.ClearSession(w)

	http.Redirect(w, r, "/community", 302)
}
