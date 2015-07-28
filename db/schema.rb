# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150722020431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id",     null: false
    t.integer  "parent_id",   null: false
    t.string   "parent_type", null: false
  end

  create_table "doc_categories", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "position",   default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "doc_categories", ["position"], name: "index_doc_categories_on_position", using: :btree

  create_table "docs", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.integer  "doc_category_id",              null: false
    t.string   "slug",                         null: false
    t.string   "title",                        null: false
    t.text     "content_markdown",             null: false
    t.text     "content_html",                 null: false
    t.text     "content_text"
    t.integer  "score",            default: 0
    t.integer  "state",            default: 0
    t.string   "cover_image_url"
    t.integer  "position",         default: 0, null: false
    t.datetime "published_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "docs", ["doc_category_id"], name: "index_docs_on_doc_category_id", using: :btree
  add_index "docs", ["slug"], name: "index_docs_on_slug", unique: true, using: :btree
  add_index "docs", ["state", "published_at"], name: "index_docs_on_state_and_published_at", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "parent_id",   null: false
    t.string   "parent_type", null: false
  end

  add_index "likes", ["user_id", "parent_id", "parent_type"], name: "index_likes_on_user_id_and_parent_id_and_parent_type", unique: true, using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "slug"
    t.string   "title"
    t.text     "content_markdown"
    t.text     "content_html"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "score",            default: 0
    t.integer  "state",            default: 0
    t.string   "cover_image_url"
    t.datetime "published_at"
    t.text     "content_text"
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  add_index "posts", ["state", "published_at"], name: "index_posts_on_state_and_published_at", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tutorials", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.string   "slug",                         null: false
    t.string   "title",                        null: false
    t.text     "content_markdown",             null: false
    t.text     "content_html",                 null: false
    t.integer  "score",            default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "state",            default: 0
    t.string   "cover_image_url"
    t.datetime "published_at"
    t.text     "content_text"
  end

  add_index "tutorials", ["slug"], name: "index_tutorials_on_slug", unique: true, using: :btree
  add_index "tutorials", ["state", "published_at"], name: "index_tutorials_on_state_and_published_at", using: :btree

  create_table "users", id: false, force: :cascade do |t|
    t.integer  "id",                                  null: false
    t.string   "name"
    t.citext   "username",                            null: false
    t.string   "email",                               null: false
    t.string   "email_md5",                           null: false
    t.string   "nitrous_oauth_token"
    t.boolean  "admin",               default: false, null: false
    t.datetime "last_fetched_at",                     null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["id"], name: "index_users_on_id", unique: true, using: :btree

end
