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

ActiveRecord::Schema.define(version: 2019_06_12_193552) do

  create_table "categorias", force: :cascade do |t|
    t.string "nome", null: false
    t.boolean "is_disabled", default: false
    t.datetime "desativada_em"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "objetos", force: :cascade do |t|
    t.integer "categoria_id", null: false
    t.integer "perfil_id"
    t.integer "passagem_servico_id"
    t.json "itens", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "passagem_servicos", force: :cascade do |t|
    t.string "status"
    t.integer "pessoa_entrou_id", null: false
    t.integer "pessoa_saiu_id", null: false
    t.string "observacoes"
    t.datetime "passada_em"
    t.datetime "desativada_em"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perfis", force: :cascade do |t|
    t.string "nome", null: false
    t.boolean "is_disabled", default: false
    t.datetime "desativado_em"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pessoas", force: :cascade do |t|
    t.string "nome", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
