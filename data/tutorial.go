package data

import (
	"database/sql"
	"time"

	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

type Tutorial struct {
	ID        int64      `db: "id"`
	UserID    int64      `db: "user_id"`
	Title     string     `db: "title"`
	Post      string     `db: "post"`
	CreatedAt *time.Time `db: "created_at"`
	UpdatedAt *time.Time `db: "updated_at"`
}

func (t *Tutorial) Insert(db *sqlx.DB) error {
	nstmt, err := db.PrepareNamed(`INSERT INTO tutorials
		(user_id, title, post, created_at, updated_at)
		VALUES (:user_id, :title, :post, now(), now())
		RETURNING *;
		`)
	if err != nil {
		return err
	}
	defer nstmt.Close()

	err = nstmt.QueryRow(t).StructScan(t)
	if err, ok := err.(*pq.Error); ok {
		return err.Code.Name() // TODO: Check unique_violation error.
	}
	return err
}
