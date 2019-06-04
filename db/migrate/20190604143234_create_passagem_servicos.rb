class CreatePassagemServicos < ActiveRecord::Migration[5.2]
  def change
    create_table :passagem_servicos do |t|
    	t.string :status, null: false
    	t.integer :pessoa_entrou_id, null: false
    	t.integer :pessoa_saiu_id, null: false
    	t.string :observacoes

      t.timestamps
    end
  end
end
