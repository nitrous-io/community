package data

import (
	"database/sql"
	"fmt"
	"time"

	"github.com/jmoiron/sqlx"
	"github.com/lib/pq"
)

type Tutorial struct {
	ID        int64      `db:"id"`
	UserID    int64      `db:"user_id"`
	Author    string     `db:"author"`
	PrettyURL string     `db:"pretty_url"`
	Title     string     `db:"title"`
	Post      string     `db:"post"`
	Approved  bool       `db:"approved"`
	CreatedAt *time.Time `db:"created_at"`
	UpdatedAt *time.Time `db:"updated_at"`
}

func (t *Tutorial) Insert(db *sqlx.DB) error {
	nstmt, err := db.PrepareNamed(`INSERT INTO tutorials
	(user_id, author, pretty_url, title, post, approved, created_at, updated_at)
	VALUES (:user_id, :author, :pretty_url, :title, :post, :approved, now(), now())
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

func GetAllTutorials(t []*Tutorial, db *sqlx.DB) ([]*Tutorial, error) {
	if err := db.Select(&t, "SELECT * FROM tutorials;"); err != nil {
		return nil, err
	}
	return t, nil
}

func (t *Tutorial) GetByPrettyURL(prettyurl string) error {
	err := Db.Get(t, "SELECT * FROM tutorials WHERE pretty_url = $1 LIMIT 1;", prettyurl)
	switch err {
	case nil:
		return nil
	case sql.ErrNoRows:
		return err
	default:
		return err
	}
}
