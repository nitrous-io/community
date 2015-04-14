package data

import (
	"database/sql"
	"time"
)

// Token struct taken from https://github.com/nitrous-io/dedicated/nitrous/models/token/token.go.
type Token struct {
	ID         int64          `db:"id"`
	UserID     int64          `db:"user_id"`
	Token      string         `db:"token"`
	Type       string         `db:"type"`
	LastIP     sql.NullString `db:"last_ip"`
	CreatedAt  *time.Time     `db:"created_at"`
	LastSeenAt *time.Time     `db:"last_seen_at"`
}

func (t *Token) GetByToken() error {
	err := Db.Get(t, "SELECT * FROM tokens WHERE token = $1 LIMIT 1;", t.Token)
	if err == sql.ErrNoRows {
		return err
	}
	return err
}
