package handler

import (
	"net/http"
	"os"

	"github.com/gorilla/securecookie"
)

var pwd string = os.Getenv("PWD_PATH")

// http://www.gorillatoolkit.org/pkg/securecookie.

var cookieHandler = securecookie.New(
	securecookie.GenerateRandomKey(64),
	securecookie.GenerateRandomKey(32))

func setSession(username, token string, w http.ResponseWriter) {
	value := map[string]string{
		"username": username,
		"token":    token,
		//"usertype": "admin",
	}
	// Default MaxAge is 86400 * 30 (30 days).
	if encoded, err := cookieHandler.Encode("user-session", value); err == nil {
		cookie := &http.Cookie{
			Name:  "user-session",
			Value: encoded,
			Path:  "/",
		}
		http.SetCookie(w, cookie)
	}
}

func clearSession(w http.ResponseWriter) {
	// Delete cookie.
	cookie := &http.Cookie{
		Name:   "user-session",
		Value:  "",
		Path:   "/",
		MaxAge: -1,
	}
	http.SetCookie(w, cookie)
}

func getUsername(r *http.Request) (string, error) {
	var username string
	if cookie, err := r.Cookie("user-session"); err != nil {
		// Not logged in.
		return "", err
	} else {
		// Logged in.
		cookieValue := make(map[string]string)
		if err = cookieHandler.Decode("user-session", cookie.Value, &cookieValue); err == nil {
			username = cookieValue["username"]
			return username, nil
		} else {
			return "", err
		}
	}
}
