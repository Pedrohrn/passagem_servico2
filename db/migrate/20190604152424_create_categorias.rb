class CreateCategorias < ActiveRecord::Migration[5.2]
  def change
    create_table :categorias do |t|
    	t.string :nome, null: false
    	t.boolean :is_disabled, default: false

    	t.datetime :desativado_em

      t.timestamps
    end
  end
end
