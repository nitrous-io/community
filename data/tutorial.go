package data

import (
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
		return err
	}

	return err
}

func GetAllTutorials(db *sqlx.DB) ([]*Tutorial, error) {
	var ts []*Tutorial
	if err := db.Select(&ts, "SELECT * FROM tutorials;"); err != nil {
		return nil, err
	}
	return ts, nil
}

func GetByPrettyURL(db *sqlx.DB, prettyurl string) (*Tutorial, error) {
	t := &Tutorial{}
	err := db.Get(t, "SELECT * FROM tutorials WHERE pretty_url = $1 LIMIT 1;", prettyurl)
	if err != nil {
		return t, err
	}

	return t, nil
}
