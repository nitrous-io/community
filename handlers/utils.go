package handler

import (
	"net/http"
	"os"

	"github.com/gorilla/securecookie"
)

// Set pwd path as environment variable to form absolute path to templates so that test files and source files can compile templates.
var pwd = os.Getenv("PWD_PATH")
var nitrousAPI = os.Getenv("NITROUS_API")

// http://www.gorillatoolkit.org/pkg/securecookie.

var cookieHandler = securecookie.New(
	securecookie.GenerateRandomKey(64),
	securecookie.GenerateRandomKey(32))

func setSession(username, token, usertype string, w http.ResponseWriter) {
	value := map[string]string{
		"username": username,
		"token":    token,
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
