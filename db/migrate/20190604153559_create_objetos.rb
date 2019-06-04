class CreateObjetos < ActiveRecord::Migration[5.2]
  def change
    create_table :objetos do |t|
    	t.integer :categoria_id, null: false
    	t.integer :perfil_id
    	t.integer :passagem_servico_id

    	t.json :itens, null: false

      t.timestamps
    end
  end
end
