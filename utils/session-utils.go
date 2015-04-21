package utils

import (
	"net/http"

	"github.com/gorilla/securecookie"
)

//
// Implements a client side session storage with Gorilla securecookie package.
// http://www.gorillatoolkit.org/pkg/securecookie.
//

// Initialize secure cookie handler.
var CookieHandler = securecookie.New(
	securecookie.GenerateRandomKey(64),
	securecookie.GenerateRandomKey(32),
)

// Store session values in a map in a single cookie.
func SetSession(userid int64, username, usertype string, w http.ResponseWriter) {
	value := map[string]interface{}{
		"userid":   userid,
		"username": username,
		"usertype": usertype, // usertype can be "admin" or ""
	}
	// Cookie duration is set to the default MaxAge which is 86400 * 30 (30 days).
	if encoded, err := CookieHandler.Encode("user-session", value); err == nil {
		cookie := &http.Cookie{
			Name:  "user-session",
			Value: encoded,
			Path:  "/community",
		}
		http.SetCookie(w, cookie)
	}
}

// Delete cookie.
func ClearSession(w http.ResponseWriter) {
	cookie := &http.Cookie{
		Name:   "user-session",
		Value:  "",
		Path:   "/community",
		MaxAge: -1,
	}
	http.SetCookie(w, cookie)
}

// If a common pattern emerges add a helper to return a struct of UserID and Username from cookie.
func DecodeCookie(r *http.Request, cookieName string) (map[string]interface{}, error) {
	if cookie, err := r.Cookie(cookieName); err == nil {
		cookieValue := make(map[string]interface{})
		if err = CookieHandler.Decode(cookieName, cookie.Value, &cookieValue); err == nil {
			return cookieValue, nil
		} else {
			return nil, err
		}
	} else {
		// No user-session - not logged in.
		return nil, err
	}
}
