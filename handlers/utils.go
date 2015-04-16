package handler

import (
	"net/http"
	"os"

	"github.com/gorilla/securecookie"
)

// Set pwd path as environment variable to form absolute path to templates so that test and source files can compile templates.
var pwd = os.Getenv("PWD_PATH")
var nitrousAPI = os.Getenv("NITROUS_API")

// http://www.gorillatoolkit.org/pkg/securecookie.

var cookieHandler = securecookie.New(
	securecookie.GenerateRandomKey(64),
	securecookie.GenerateRandomKey(32))

func setSession(userid int64, username, usertype string, w http.ResponseWriter) {
	value := map[string]interface{}{
		"userid":   userid,
		"username": username,
		"usertype": usertype, // usertype can be "admin" or ""
	}
	// Default MaxAge is 86400 * 30 (30 days).
	if encoded, err := cookieHandler.Encode("user-session", value); err == nil {
		cookie := &http.Cookie{
			Name:  "user-session",
			Value: encoded,
			Path:  "/community",
		}
		http.SetCookie(w, cookie)
	}
}

func clearSession(w http.ResponseWriter) {
	// Delete cookie.
	cookie := &http.Cookie{
		Name:   "user-session",
		Value:  "",
		Path:   "/community",
		MaxAge: -1,
	}
	http.SetCookie(w, cookie)
}

func decodeCookie(r *http.Request, cookieName string) (map[string]interface{}, error) {
	if cookie, err := r.Cookie(cookieName); err == nil {
		cookieValue := make(map[string]interface{})
		if err = cookieHandler.Decode(cookieName, cookie.Value, &cookieValue); err == nil {
			return cookieValue, nil
		} else {
			return nil, err
		}
	} else {
		// No user-session - not logged in.
		return nil, err
	}
}
