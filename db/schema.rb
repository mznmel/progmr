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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130103133823) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "votes"
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["ancestry"], :name => "index_comments_on_ancestry"
  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"
  add_index "comments", ["votes"], :name => "index_comments_on_votes"

  create_table "post_votes", :force => true do |t|
    t.boolean  "vote"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "post_votes", ["user_id", "post_id"], :name => "index_post_votes_on_user_id_and_post_id", :unique => true

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "content"
    t.integer  "comments",     :default => 0
    t.integer  "user_id"
    t.integer  "major_tag_id"
    t.integer  "minor_tag_id"
    t.integer  "extra_tag_id"
    t.integer  "votes",        :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "posts", ["extra_tag_id"], :name => "index_posts_on_extra_tag_id"
  add_index "posts", ["major_tag_id"], :name => "index_posts_on_major_tag_id"
  add_index "posts", ["minor_tag_id"], :name => "index_posts_on_minor_tag_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"
  add_index "posts", ["votes"], :name => "index_posts_on_votes"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "posts_karma",     :default => 0
    t.integer  "comments_karma",  :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
