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

ActiveRecord::Schema.define(version: 20160411052640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cameras", force: :cascade do |t|
    t.decimal  "range_m",              default: 10.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recording_session_id"
    t.boolean  "static",               default: true
    t.boolean  "one_time",             default: true
    t.string   "name"
    t.integer  "user_id"
  end

  add_index "cameras", ["recording_session_id"], name: "index_cameras_on_recording_session_id", using: :btree

  create_table "cuts", force: :cascade do |t|
    t.integer  "edit_id"
    t.integer  "video_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

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

  create_table "edits", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ride_id"
  end

  add_index "edits", ["ride_id"], name: "index_edits_on_ride_id", using: :btree

  create_table "final_cuts", force: :cascade do |t|
    t.integer  "edit_id"
    t.integer  "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "final_cuts", ["edit_id"], name: "index_final_cuts_on_edit_id", using: :btree
  add_index "final_cuts", ["video_id"], name: "index_final_cuts_on_video_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "status"
    t.integer  "progress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "timestamp"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.decimal  "latitude",       precision: 12, scale: 8, default: 49.2578263
    t.decimal  "longitude",      precision: 12, scale: 8, default: -123.1939534
  end

  create_table "photos", force: :cascade do |t|
    t.float    "exif_latitude"
    t.float    "exif_longitude"
    t.datetime "timestamp"
    t.string   "image"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "camera_id"
  end

  create_table "recording_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_at"
  end

  add_index "recording_sessions", ["user_id"], name: "index_recording_sessions_on_user_id", using: :btree

  create_table "rides", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "strava_activity_id"
    t.string   "strava_name"
    t.datetime "strava_start_at"
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

  create_table "time_series_data", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "timestamps",     default: [],              array: true
    t.decimal  "latitudes",      default: [],              array: true
    t.decimal  "longitudes",     default: [],              array: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

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
    t.integer  "camera_id"
    t.string   "source_url"
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
  end

  add_foreign_key "cameras", "recording_sessions"
  add_foreign_key "dropbox_events", "users"
  add_foreign_key "dropbox_photos", "dropbox_events"
  add_foreign_key "edits", "rides"
  add_foreign_key "final_cuts", "edits"
  add_foreign_key "final_cuts", "videos"
  add_foreign_key "recording_sessions", "users"
end
