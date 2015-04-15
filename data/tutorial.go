package data

import (
	"database/sql"
	"fmt"
	"time"

	"github.com/lib/pq"
)

type Tutorial struct {
	ID        int64      `db:"id"`
	UserID    int64      `db:"user_id"`
	Author    string     `db:"author"`
	Title     string     `db:"title"`
	Post      string     `db:"post"`
	Approved  bool       `db:"approved"`
	CreatedAt *time.Time `db:"created_at"`
	UpdatedAt *time.Time `db:"updated_at"`
}

func (t *Tutorial) Insert() error {
	nstmt, err := Db.PrepareNamed(`INSERT INTO tutorials
		(user_id, author, title, post, approved, created_at, updated_at)
		VALUES (:user_id, :author, :title, :post, :approved, now(), now())
		RETURNING *;
		`)
	if err != nil {
		return err
	}
	defer nstmt.Close()

	err = nstmt.QueryRow(t).StructScan(t)
	if err, ok := err.(*pq.Error); ok {
		return fmt.Errorf("%s", err) // TODO: Check err.Code.Name() for unique_violation error, foreign_key_violation error.
	}

	return err
}
