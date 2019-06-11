class CreatePerfis < ActiveRecord::Migration[5.2]
  def change
    create_table :perfis do |t|
    	t.string :nome, null: false
    	t.string :status
    	t.boolean :is_disabled, default: false

      t.timestamps
    end
  end
end
