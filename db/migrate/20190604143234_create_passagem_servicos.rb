class CreatePassagemServicos < ActiveRecord::Migration[5.2]
  def change
    create_table :passagem_servicos do |t|
    	t.string :status
    	t.integer :pessoa_entrou_id, null: false
    	t.integer :pessoa_saiu_id, null: false
    	t.string :observacoes

    	t.datetime :passada_em
    	t.datetime :desativada_em

      t.timestamps
    end
  end
end
