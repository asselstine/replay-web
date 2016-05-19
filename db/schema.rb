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

ActiveRecord::Schema.define(version: 20160519180157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "strava_activity_id"
    t.string   "strava_name"
    t.datetime "strava_start_at"
    t.datetime "timestamps",         default: [],              array: true
    t.decimal  "latitudes",          default: [],              array: true
    t.decimal  "longitudes",         default: [],              array: true
    t.datetime "start_at"
    t.datetime "end_at"
  end

  create_table "draft_photos", force: :cascade do |t|
    t.integer "photo_id"
    t.integer "activity_id"
  end

  create_table "drafts", force: :cascade do |t|
    t.integer  "setup_id"
    t.integer  "activity_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "video_id"
    t.string   "type"
    t.integer  "photo_id"
    t.integer  "source_video_id"
  end

  create_table "dropbox_events", force: :cascade do |t|
    t.string   "cursor"
    t.string   "path"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "dropbox_events", ["user_id"], name: "index_dropbox_events_on_user_id", using: :btree

  create_table "dropbox_photos", force: :cascade do |t|
    t.string   "photo"
    t.string   "path"
    t.string   "rev"
    t.integer  "dropbox_event_id"
    t.datetime "timestamp"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "dropbox_photos", ["dropbox_event_id"], name: "index_dropbox_photos_on_dropbox_event_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.float    "exif_latitude"
    t.float    "exif_longitude"
    t.datetime "timestamp"
    t.string   "image"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "filename"
  end

  create_table "setup_photos", force: :cascade do |t|
    t.integer "setup_id"
    t.integer "photo_id"
  end

  create_table "setup_uploads", force: :cascade do |t|
    t.integer "setup_id"
    t.integer "upload_id"
  end

  create_table "setups", force: :cascade do |t|
    t.decimal  "range_m",    precision: 6,  scale: 2, default: 16.0
    t.decimal  "latitude",   precision: 12, scale: 8, default: 49.256711
    t.decimal  "longitude",  precision: 12, scale: 8, default: -123.114225
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.text     "name"
    t.integer  "user_id"
  end

  create_table "strava_accounts", force: :cascade do |t|
    t.string   "uid"
    t.string   "token"
    t.string   "username"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "sync_job_status", default: 4
  end

  create_table "uploads", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.string   "type",        default: "Upload"
    t.string   "url"
    t.string   "filename"
    t.string   "unique_id"
    t.integer  "file_size"
    t.string   "file_type"
    t.string   "process_msg"
    t.integer  "photo_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "uploads", ["photo_id"], name: "index_uploads_on_photo_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.string   "refresh_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filename"
    t.string   "webm_url"
    t.string   "mp4_url"
    t.string   "status"
    t.string   "message"
    t.string   "job_id"
    t.integer  "duration_ms"
    t.string   "file"
    t.string   "duration",          default: "0"
    t.string   "bitrate"
    t.string   "size",              default: "0"
    t.string   "video_stream"
    t.string   "video_codec"
    t.string   "colorspace"
    t.string   "resolution"
    t.string   "width"
    t.string   "height"
    t.string   "frame_rate"
    t.string   "audio_stream"
    t.string   "audio_codec"
    t.string   "audio_sample_rate"
    t.string   "audio_channels"
    t.integer  "thumbnail_id"
    t.integer  "user_id"
  end

  add_index "videos", ["user_id"], name: "index_videos_on_user_id", using: :btree

  add_foreign_key "dropbox_events", "users"
  add_foreign_key "dropbox_photos", "dropbox_events"
  add_foreign_key "uploads", "photos"
  add_foreign_key "videos", "users"
end
