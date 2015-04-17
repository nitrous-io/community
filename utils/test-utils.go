package utils

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/jmoiron/sqlx"
	"github.com/mattes/migrate/migrate"
)

//
// Sets up mock DB for testing purposes only.
//

func SetupDB(t *testing.T) *sqlx.DB {
	dbURL := os.Getenv("TEST_DB_URL")
	if dbURL == "" {
		panic("TEST_DB_URL not set")
	}
	db, err := sqlx.Open("postgres", dbURL)
	if err != nil {
		t.Fatal(err)
	}

	// Run pending migrations.
	t.Log("Starting database migrations...")
	pwd, _ := os.Getwd()
	errs, ok := migrate.UpSync(dbURL, filepath.Join(pwd, "/../data/migrations"))
	if !ok {
		for _, err := range errs {
			t.Error(err)
			t.Fatal("SetupDB: migrations failed")
		}
	}
	t.Log("Completed database migrations")

	// Truncate tables.
	t.Log("Truncating tables...")
	tables := []string{}
	q := "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name <> 'schema_migrations';"
	if err := db.Select(&tables, q); err != nil {
		t.Fatal(err)
	}
	if _, err := db.Exec(fmt.Sprintf("TRUNCATE %s RESTART IDENTITY;", strings.Join(tables, ", "))); err != nil {
		t.Fatal(err)
	}
	t.Log("Completed truncating tables")

	return db
}
