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

ActiveRecord::Schema.define(:version => 20140211124058) do

  create_table "admins", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "role"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "labs", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "department_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "labstocks", :force => true do |t|
    t.integer  "office_id"
    t.integer  "quantity"
    t.integer  "quantity_used", :default => 0
    t.string   "status",        :default => "P"
    t.integer  "lab_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "lab_id"
    t.string   "message_type"
    t.string   "name"
    t.integer  "quantity"
    t.string   "sender"
    t.integer  "department_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "offices", :force => true do |t|
    t.date     "date"
    t.string   "voucher_no"
    t.string   "name"
    t.string   "description"
    t.float    "price_unit"
    t.integer  "quantity"
    t.float    "total_price"
    t.integer  "department_id"
    t.integer  "quantity_assigned", :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

end
